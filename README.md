# Project Name: Image Processing using UART and FPGA
## EC311 Final Project, Group 7

### Team Members
- Varsha Athreya
- Melissa Regalado
- Punnisa Amornsirikul
- Conor Holland Ruane

### Link to Video
[Watch the Video](https://www.youtube.com/watch?v=eB2KplseXf0)

### Overview of Project
A signal processing machine with UART and FPGA is used to darken, brighten, and invert images. MATLAB interfaces with the system, enabling efficient real-time manipulation of images through hardware-based processing.

### How to Run Our Project
1. Download all the Verilog modules, the constraints file (.xdc), the MATLAB script, and the correct JPG image (dog.jpg).
2. In the MATLAB script, change the “port” variable on line 2 to the correct port if necessary. To find the appropriate port, search “Device Manager” in Windows search, click “Ports,” and choose the port named “USB Serial Port.”
3. Change the image used if necessary, but we’ve included the dog.jpg image in the images folder in this repository.
4. Create a new project in Verilog and add all the relevant Verilog files along with the constraints file.
5. Generate a bitstream for the `top_top` module.
6. Run the MATLAB code with the appropriate switches on.
   - The rightmost switch (J15) must always be on for transmission.
   - The next four switches (L16, M13, R15, R17) correspond to four transformations: no transformation, lighten, darken, and inversion, respectively. Only one of the transformation switches should be on at a time because the transformations are encoded.
   - If darkening or lightening, use the leftmost switch (V10) to indicate how dark/light you want the processed image to be. If the switch is off, it will darken/lighten less. If the switch is on, it will darken/lighten more.

### Code Structure
#### top_top.v
The top hierarchical module is labeled `top_top.v`. We encode the transformation types, which include darkening, brightening, and inverting images. Then both a transmitter and a receiver module are instantiated to serve as the system’s transmission between the FPGA board and MATLAB script. We perform all our transformation logic in this module.

#### top.v
The transmitter is called `top` and is instantiating a transmitter debouncer and transmitter module. Originally, the transmitter was implemented with a button press, which is why the `top` module includes a debouncer. However, now that we are using a switch to always transmit, the debouncer is technically no longer necessary. We still kept the debouncer instantiated though in case we wanted to switch this functionality for debugging purposes.

#### receiver.v
This file is used to receive data serially into the UART. This data is sent from MATLAB and is connected via the serial port. The receiver then outputs the received data into 8 bits parallelly.   

#### transmitter.v
The transmitter receives the data from the transmitter parallelly (8 bits) and converts it into serial data, which is then transmitted back to the MATLAB script.

#### rgb_processor.m
In our MATLAB file, we initially read in an image and resize the image to our desired resolution. The data that is read in is converted into unsigned integer 8 bits, which is in a 3D matrix due to the RGB values. Afterward, the data that is going to be sent back is initialized as the same 3D matrix with zeros. To send the serial data through the UART, we are using nested for loops to send one byte at a time. These for loops access each pixel of the image, and each pixel has three bytes for the corresponding RGB values that get written into the UART and read back after the transmission. After every byte is processed, the processed image is displayed next to the original image.

**Both the transmitter and receiver modules make use of FSMs** within their architecture made up of an idle state and a transmitting/receiving state to determine when data is transmitted.

#### Receiver FSM:
- **State 0**: Waits for receiving signal (idle state)
- **State 1**: Receives the data bits one-by-one. The data is passed into the `rxshiftreg` and increments the counter. Once all bits have been received, it returns to the idle state.

#### Transmitter FSM:
- **State 0**: Waits for transmit signal (idle state)
- **State 1**: Transmits bits one-by-one by shifting data and updating `TxD`. Once all bits are sent, it returns to the idle state.

### Challenges
A major setback to expanding the functionality of our project was our inability to change the transmitter and receiver modules to categorize our data to be able to differentiate RGB pixels that would allow for more color filtering and a variety of other transformations. We also had trouble storing all the data in a buffer/FIFO and transmitting it back. We think the cause of this issue is that the transmitter is constantly transmitting data back, so if we are storing multiple bytes of data, we would need to wait until the storage is full before transmitting. However, at the same time, MATLAB is always reading what is being transmitted. So, when we’d implement any sort of storage in Verilog, we would receive back a completely black image. This would be something we hope to solve in the future.

### Resources Used
- [UART Communication on Basys 3 FPGA Dev Board - Instructables](https://www.instructables.com/UART-Communication-on-Basys-3-FPGA-Dev-Board-Power-1/)
- [FPGADude Digital Design FPGA Projects on GitHub](https://github.com/FPGADude/Digital-Design/tree/main/FPGA%20Projects/UART)
