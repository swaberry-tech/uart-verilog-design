# =====================================================
# UART Verilog Project Makefile
# =====================================================

IVERILOG = iverilog
VVP      = vvp
GTKWAVE  = gtkwave

RTL   = rtl
TB    = tb
SIM   = sim
WAVES = waves

# =====================================================
# Help
# =====================================================

help:
	@echo Available targets:
	@echo make baud       - Run baud generator testbench
	@echo make tx         - Run UART transmitter testbench
	@echo make rx         - Run UART receiver testbench
	@echo make top        - Run top-level UART testbench
	@echo make wave_baud  - Open baud waveform
	@echo make wave_tx    - Open TX waveform
	@echo make wave_rx    - Open RX waveform
	@echo make wave_top   - Open top-level waveform
	@echo make all        - Run all testbenches
	@echo make clean      - Remove generated files

# =====================================================
# Baud Generator
# =====================================================

baud:
	$(IVERILOG) -o $(SIM)/baud.out \
	$(RTL)/baud_gen.v \
	$(TB)/tb_baud_gen.v
	$(VVP) $(SIM)/baud.out

# =====================================================
# UART TX
# =====================================================

tx:
	$(IVERILOG) -o $(SIM)/tx.out \
	$(RTL)/baud_gen.v \
	$(RTL)/uart_tx.v \
	$(TB)/tb_uart_tx.v
	$(VVP) $(SIM)/tx.out

# =====================================================
# UART RX
# =====================================================

rx:
	$(IVERILOG) -o $(SIM)/rx.out \
	$(RTL)/baud_gen.v \
	$(RTL)/uart_rx.v \
	$(TB)/tb_uart_rx.v
	$(VVP) $(SIM)/rx.out

# =====================================================
# UART TOP
# =====================================================

top:
	$(IVERILOG) -o $(SIM)/top.out \
	$(RTL)/baud_gen.v \
	$(RTL)/uart_tx.v \
	$(RTL)/uart_rx.v \
	$(RTL)/uart_top.v \
	$(TB)/tb_uart_top.v
	$(VVP) $(SIM)/top.out

# =====================================================
# Run Everything
# =====================================================

all: baud tx rx top

# =====================================================
# Waveforms
# =====================================================

wave_baud:
	$(GTKWAVE) $(WAVES)/baud.vcd

wave_tx:
	$(GTKWAVE) $(WAVES)/tx.vcd

wave_rx:
	$(GTKWAVE) $(WAVES)/rx.vcd

wave_top:
	$(GTKWAVE) $(WAVES)/top.vcd

# =====================================================
# Cleanup
# =====================================================

clean:
	del /Q sim\*.out 2>nul
	del /Q waves\*.vcd 2>nul