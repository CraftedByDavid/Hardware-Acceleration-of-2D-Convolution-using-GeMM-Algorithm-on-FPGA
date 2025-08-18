This folder contains the RTL (Register Transfer Level) modules for the 2D convolution accelerator project on FPGA.

### Module Overview

- **top.v**: Top-level module integrating all submodules
- **test1_sinc.v**: 2D convolution computation module
- **uart_bram_reader.v**: Module to read from Block RAM and transmit via UART
- **uart_transmission.v**: UART transmission module

### Instructions and Notes

- **Block Memory (BRAM) Initialization**: You need to initialize the BRAM IP in Vivado and instantiate it in `test1_sinc.v`.
- **Image and Kernel Sizes**: Both are variable. However, the current RTL equations do **not provide parameters to control zero-padding or stride**:
  - **Padding** is fixed to 0
  - **Stride** is fixed to 1
- **Kernel Values**: Signed kernels are supported.
- **FPGA Platform**: Verified on a **Boolean FPGA development board**.
- **UART Transmission**:
  - Verified at **9600 baud rate**. Higher baud rates may cause errors.
  - Convolution computation completes in approximately **19 ms**. However, displaying the image on the host PC may take a few seconds due to the UART speed.
  - UART transmission occurs **only after the convolution operation is complete**.
- **System Context**: This module is part of a **full-frame image processing pipeline**.
- **Clock Frequency**: 100 MHz
- For detailed theoretical background and design notes, please refer to the **`docs/` folder**.

