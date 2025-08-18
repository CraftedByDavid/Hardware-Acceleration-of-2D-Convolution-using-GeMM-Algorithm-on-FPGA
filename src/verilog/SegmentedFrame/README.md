

This folder contains the RTL modules for **segmented-frame image processing**.

### Module Overview

- **top_module.v**: Top-level module for segmented-frame processing
- **Ip_im2colconv_unit*.v**: Individual convolution processing units
- **uart_bram_reader.v**: UART to BRAM reader module
- **uart_transmission.v**: UART transmission module

### Segmented Processing Details

- The input image used is **224x224 pixels**.
- To speed up processing on the FPGA, the image is **segmented along the vertical axis into 8 horizontal segments**.
- **BRAM access on FPGA allows only one pixel at a time**, so processing the full frame sequentially takes longer.
- By segmenting the image:
  - Each segment can be processed **in parallel**, significantly reducing total convolution time.
  - **Overlapping rows** are included for proper convolution:
    - For a 3x3 kernel, 7 out of the 8 segments will include **2 extra overlapping rows**.
    - The number of overlapping rows will vary depending on the kernel size.
- After segment instantiation, the **8 segments run concurrently**, completing the convolution of the entire image faster than full-frame sequential processing.
- Compared to full-frame processing, the segmented **224x224 image convolution completes in approximately 2 ms on a 100 MHz clock**.
- Supports **stride=1** and **zero padding=0**.
- Signed kernels are supported.
- Verified on **Bolean FPGA** at **9600 baud rate**.
- Clock used: **100 MHz**.
- UART transmission happens **after each segment is processed**, which adds additional delay when viewing the image on a local system.
- Higher baud rates may cause errors during transmission.

### Notes

- Constrained by **Boolean FPGA pins file** (included in this folder).

