ADDI  $8,  $0, 2
ADDI  $9,  $0, 100
ADDI  $10, $0, 0
ADDI  $4,  $0, 0
ADDI  $5,  $0, 1
SUB   $13, $9, $8
SLT   $14, $0, $13
BEQ   $14, $0, 21
ADDI  $11, $0, 2
ADDI  $12, $0, 1
SUB   $13, $8, $11
SLT   $14, $0, $13
BEQ   $14, $0, 9
ADD   $15, $0, $8
SUB   $15, $15, $11
SLT   $14, $0, $15
BEQ   $14, $0, 1
J     14
BEQ   $15, $0, 2
ADDI  $11, $11, 1
J     10
ADDI  $12, $0, 0
BEQ   $12, $0, 4
ADD   $13, $4, $5
SW    $8, 0($13)
ADDI  $5, $5, 1
ADDI  $10, $10, 1
ADDI  $8, $8, 1
J     5
SW    $10, 0($4)
NOP