import tkinter as tk
from tkinter import filedialog, messagebox, scrolledtext
import re

# Mapeo para instrucciones de tipo R: determina el field 'function'
r_function_map = {
    "ADD": "100000",
    "SUB": "100010",
    "SLT": "101010",
    "OR" : "100101",
    "AND": "100100",
    "NOP": "000000"  # NOP retorna 32 bits en 0
}

# Mapeo para instrucciones de tipo I: determina el opcode
i_opcode_map = {
    "SW":    "101011",
    "LW":    "100011",
    "ADDI":  "001000",
    "SUBI":  "001000",  # mismo opcode que ADDI
    "SLTI":  "001010",
    "ANDI":  "001100",
    "ORI":   "001101",
    "BEQ":   "000100",
    "BNE":   "000101",
    "BGTZ":  "000111"
}

# Para instrucciones de tipo J el opcode es fijo
j_opcode = "000010"

# Alias de registros
reg_alias = {
    "ZERO": 0, "AT":1, "V0":2, "V1":3,
    "A0":4, "A1":5, "A2":6, "A3":7,
    "T0":8, "T1":9, "T2":10, "T3":11, "T4":12, "T5":13, "T6":14, "T7":15,
    "S0":16, "S1":17, "S2":18, "S3":19, "S4":20, "S5":21, "S6":22, "S7":23,
    "T8":24, "T9":25, "K0":26, "K1":27, "GP":28, "SP":29, "FP":30, "RA":31
}

def reg_to_bin(reg):
    """
    Convierte un registro ('$4' o '$ZERO') a 5 bits.
    """
    r = reg.replace("$","").upper()
    if r in reg_alias:
        num = reg_alias[r]
    else:
        try:
            num = int(r)
        except ValueError:
            return None
    return format(num, '05b')

def imm_to_bin(imm, bits):
    """
    Convierte un inmediato (ej. "#101", "12" o "-5") a 'bits' bits.
    Usa complemento a dos para negativos.
    """
    try:
        if imm.startswith("#"):
            imm = imm[1:]
        num = int(imm, 0)  # 0 para detectar hex si "0x"
        if num < 0:
            num = (1 << bits) + num
        return format(num, f'0{bits}b')
    except:
        return None

def parse_offset_base(token):
    """
    Dado un string tipo '16($29)', retorna (offset, base_reg) o (None,None).
    """
    m = re.match(r'(-?\d+)\s*\(\s*(\$\w+)\s*\)', token)
    if not m:
        return None, None
    return m.group(1), m.group(2)

def convert_line(line):
    tokens = line.strip().replace(",", " ").split()
    if not tokens:
        return ""
    mnemonic = tokens[0].upper()

    # --- Tipo R ---
    if mnemonic in r_function_map:
        if mnemonic == "NOP":
            return "0" * 32
        if len(tokens) != 4:
            return f"Error: Número de operandos incorrecto en '{line.strip()}'"
        rd = reg_to_bin(tokens[1])
        rs = reg_to_bin(tokens[2])
        rt = reg_to_bin(tokens[3])
        if None in (rd, rs, rt):
            return f"Error: Registro inválido en '{line.strip()}'"
        return "000000" + rs + rt + rd + "00000" + r_function_map[mnemonic]

    # --- Tipo I ---
    if mnemonic in i_opcode_map:
        opcode = i_opcode_map[mnemonic]

        # 1) Formato offset(base) para LW/SW
        if mnemonic in {"LW","SW"}:
            # puede ser "LW $2, 16($29)" => tokens[1]='$2', tokens[2]='16($29)'
            if len(tokens) == 3:
                rt = reg_to_bin(tokens[1])
                offset, base = parse_offset_base(tokens[2])
                rs = reg_to_bin(base)
                imm = imm_to_bin(offset, 16)
            # o el formato general: rt rs imm
            elif len(tokens) == 4:
                rt = reg_to_bin(tokens[1])
                rs = reg_to_bin(tokens[2])
                imm = imm_to_bin(tokens[3], 16)
            else:
                return f"Error: Operandos inválidos en '{line.strip()}'"

            if None in (rs, rt, imm):
                return f"Error: Formato inválido en '{line.strip()}'"
            return opcode + rs + rt + imm

        # 2) Ramas BEQ, BNE
        if mnemonic in {"BEQ","BNE"}:
            if len(tokens) != 4:
                return f"Error: Operandos inválidos en '{line.strip()}'"
            rs = reg_to_bin(tokens[1])
            rt = reg_to_bin(tokens[2])
            imm = imm_to_bin(tokens[3], 16)
            if None in (rs, rt, imm):
                return f"Error: Formato inválido en '{line.strip()}'"
            return opcode + rs + rt + imm

        # 3) BGTZ
        if mnemonic == "BGTZ":
            if len(tokens) != 3:
                return f"Error: Operandos inválidos en '{line.strip()}'"
            rs = reg_to_bin(tokens[1])
            rt = "00000"
            imm = imm_to_bin(tokens[2], 16)
            if None in (rs, imm):
                return f"Error: Formato inválido en '{line.strip()}'"
            return opcode + rs + rt + imm

        # 4) Aritméticas/lógicas inmediatas ADDI, SUBI, SLTI, ANDI, ORI
        if mnemonic in {"ADDI","SUBI","SLTI","ANDI","ORI"}:
            if len(tokens) != 4:
                return f"Error: Operandos inválidos en '{line.strip()}'"
            rt = reg_to_bin(tokens[1])
            rs = reg_to_bin(tokens[2])
            raw_imm = tokens[3]
            # SUBI invierte signo
            if mnemonic == "SUBI":
                if raw_imm.startswith("#"):
                    raw_imm = "-" + raw_imm[1:]
                else:
                    raw_imm = "-" + raw_imm
            imm = imm_to_bin(raw_imm, 16)
            if None in (rs, rt, imm):
                return f"Error: Formato inválido en '{line.strip()}'"
            return opcode + rs + rt + imm

    # --- Tipo J ---
    if mnemonic == "J":
        if len(tokens) != 2:
            return f"Error: Operandos inválidos en '{line.strip()}'"
        target = imm_to_bin(tokens[1], 26)
        if target is None:
            return f"Error: Formato inválido en '{line.strip()}'"
        return j_opcode + target

    return f"Error: Instrucción desconocida '{mnemonic}'"

# Resto del GUI sin cambios...
def load_asm():
    filepath = filedialog.askopenfilename(
        title="Selecciona el archivo ASM",
        filetypes=[("ASM Files", "*.ASM"), ("All Files", "*.*")]
    )
    if filepath:
        try:
            with open(filepath, "r") as f:
                content = f.read()
            asm_text.delete(1.0, tk.END)
            asm_text.insert(tk.END, content)
        except Exception as e:
            messagebox.showerror("Error", f"No se pudo cargar el archivo: {e}")

def convert_asm_to_bin():
    asm_content = asm_text.get(1.0, tk.END)
    lines = asm_content.strip().splitlines()
    bin_lines, errors = [], []

    for line in lines:
        if not line.strip() or line.strip().startswith(("//", ";")):
            continue
        out = convert_line(line)
        if out.startswith("Error:"):
            errors.append(out)
        else:
            bin_lines.append(out)

    if errors:
        messagebox.showerror("Errores en la conversión", "\n".join(errors))
        return

    bits = "".join(bin_lines)
    if len(bits) % 8 != 0:
        bits = bits.ljust(((len(bits)//8)+1)*8, '0')
    rows = [bits[i:i+8] for i in range(0, len(bits), 8)]
    if len(rows) < 1000:
        rows += ["00000000"]*(1000-len(rows))
    else:
        rows = rows[:1000]

    bin_text.delete(1.0, tk.END)
    bin_text.insert(tk.END, "\n".join(rows))
    messagebox.showinfo("Conversión", "Conversión a binario completada.")

def save_bin():
    content = bin_text.get(1.0, tk.END).strip()
    if not content:
        messagebox.showwarning("Aviso", "No hay contenido binario para guardar.")
        return
    filepath = filedialog.asksaveasfilename(
        title="Guardar archivo binario", defaultextension=".txt",
        filetypes=[("Text Files", "*.txt")]
    )
    if filepath:
        try:
            with open(filepath, "w") as f:
                f.write(content)
            messagebox.showinfo("Guardado", "Archivo guardado exitosamente.")
        except Exception as e:
            messagebox.showerror("Error", f"No se pudo guardar el archivo: {e}")

# GUI setup
root = tk.Tk()
root.title("Conversor ASM a Binario")
frame = tk.Frame(root); frame.pack(pady=5)
tk.Button(frame, text="Cargar ASM",    command=load_asm).grid(row=0,column=0,padx=5)
tk.Button(frame, text="Convertir a Binario", command=convert_asm_to_bin).grid(row=0,column=1,padx=5)
tk.Button(frame, text="Guardar Binario",    command=save_bin).grid(row=0,column=2,padx=5)

tk.Label(root, text="Contenido ASM:").pack()
asm_text = scrolledtext.ScrolledText(root, width=70, height=10); asm_text.pack(padx=10,pady=5)
tk.Label(root, text="Contenido Binario (8×1000):").pack()
bin_text = scrolledtext.ScrolledText(root, width=70, height=20); bin_text.pack(padx=10,pady=5)

root.mainloop()
