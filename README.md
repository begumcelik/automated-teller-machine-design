# ATM Design Implementation

Automated Teller Machine (ATM) designed using Verilog and implemented on the BASYS FPGA board. In this design, there is a login operation where the user first should insert their debit card and then enter his/her password. After having entered the password correctly, the user may do: 1) deposit/withdraw money to/from his/her account, 2) change the password of the account, or 3) log out from the ATM.

This project has been implemented for an undergraduate course CS303 - Logic & Digital System Design at Sabanci University.

## Contributors

- Alp Cihan
- Begüm Çelik

## Modules

- The clock divider module (clk_divider.v) generates a clock signal with a period of 50 ms, from a 25 MHz input clock (Please note that the BASYS boards can provide 3 different clock frequency: 25 MHz, 50 MHz, 100 MHz. These are set using the jumpers on the BASYS boards. We set the clock of all BASYS boards to 25 MHz.).
- The debouncer (debouncer.v) circuit gets the input from a push button and generates a one clock pulse output.
- The seven segment driver (ssd.v) module, drives the segments.
- The Top module (top_module.v) binds the clock divider, the debouncer and the seven segment driver modules.
