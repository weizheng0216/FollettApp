# Follett Capstone
This repository is owned by Follett and stores the Arduino source code that will run on the ESP32 microcontroller. This microcontroller will communicate with their ice machines to interpret errors and display information about its runtime. 


# Setup
**Required Materials**
- [Huzzah32 MCU][1]
- Serial to USB cable
- Serial to Serial cable

**Required Software** 
- Arduino IDE
- ESP32 Board Manager ([tutorial][2])

**Steps**

1) If you had purchased [this][1] Huzzah32 MCU from Adafruit, then the first step will be to solder serial pins to the board. These pins are located on the end closest to the Reset and GPIO0 buttons. 

2) Once soldered, connect the board with the Serial to USB to your PC.

3) Download the code provided in /main/BLE_Server/BLE_Server.ino and upload that to the board using the Arduino IDE. Ensure you select the correct board "ESP32" under the board manager. 

4) To upload, put the ESP into bootloader mode by holding down the GPIO0 button and pressing the Reset button, then letting go of the GPIO0 button when the terminal says "Connecting" 

5) There should be the following message in the Arduino Terminal upon a successful upload:

        Leaving...
        Hard resetting via RTS pin...
    Otherwise, double check your soldered connection, Serial to USB cable, or try putting the board into bootloader mode sooner.

6) After uploading your code to the board, disconnect the Serial to USB cable and connect the Serial to Serial cable. 

7) Attach the other end of the Serial to Serial cable to the Serial port on your Follett Ice Machine.

8) Finally, open the \_AppName\_ app and establish a connection with the board.

9) Once the Bluetooth connection is established, you should be able to view the live readings from the ice machine. 

[1]: https://www.adafruit.com/product/4172 
[2]: https://randomnerdtutorials.com/installing-the-esp32-board-in-arduino-ide-windows-instructions/ 
