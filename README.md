# Vigenère Cipher on MIPS64

## Project Overview
This project implements a Vigenère cipher encryption algorithm using MIPS64 assembly language. The implementation includes additional features like alternating shift direction with each character in the key.

## Architecture
The program is designed to run on the MIPS64 architecture using the EduMIPS64 simulator. It implements an encryption algorithm that transforms plaintext using a key-based shifting approach.

### Core Components
- **Input Text**: The plaintext to be encrypted (the author's name)
- **Cipher Key**: The key used for encryption ("sev")
- **Output Buffer**: Storage for the encrypted result

## Algorithm Implementation

### Key Features
- **Alternating Direction**: Unlike traditional Vigenère cipher, this implementation alternates between forward and backward shifts for each character in the key
- **Alphabet Wrapping**: Handles cases where character shifts exceed 'a' or 'z' bounds
- **Register Optimization**: Efficiently uses MIPS64 registers for computation

### Encryption Process
1. Iterate through each character of the input message
2. For each character, apply a shift based on the corresponding character in the key
3. Toggle the shift direction with each new key character
4. Handle alphabet bounds by wrapping around as needed
5. Store the encrypted character in the output buffer

## Performance
- **Execution Cycles**: 469
- **Instruction Count**: 270
- **CPI (Cycles Per Instruction)**: 1.737

## Running the Program
To execute this program:

1. Load the EduMIPS64 simulator (`edumips64-1.3.0.jar`)
2. Open the xsevcim00.s assembly file
3. Run the simulation to see the encryption process
4. The encrypted output "fvnanrlzrjno" will be displayed in the simulator's output

## Register Usage
- **r4-r7**: Pointers to memory locations
- **r8-r13**: Constants for alphabet bounds and operations
- **r15**: Direction flag (1 or -1)
- **r16-r20**: Temporary values for encryption operations

## Author
- xsevcim00 (Martin Ševčík)
- Faculty of Information Technology, Brno University of Technology

## Note
This project was completed as an assignment for the INP (Design of Computer Systems) course at FIT BUT.