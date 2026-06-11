# UART Architecture

## Specifications

- Clock Frequency: 50 MHz
- Baud Rate: 115200
- Data Bits: 8
- Stop Bits: 1
- Parity: None

## Modules

1. Baud Generator
2. UART Transmitter
3. UART Receiver
4. UART Top

## Frame Format

| Start | D0 | D1 | D2 | D3 | D4 | D5 | D6 | D7 | Stop |
|--------|----|----|----|----|----|----|----|----|------|
|   0    |    Data Bits     |      1      |