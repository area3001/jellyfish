## Jellyfish

Jellyfish is an implementation of our [LPD6803 driver](https://github.com/area3001/esp8266-arduino-lpd6803) for the ESP8266 combined with an MQTT client.

![Example Schematic](https://raw.githubusercontent.com/area3001/jellyfish/master/img/LIGHTS.JPG)

### Hardware

At the heart of Jellyfish there's an ESP12E module combined with a [TXB0106](http://www.ti.com/product/txb0106) and many options for sensors. The board we're using is the [ESP12_DEV](https://github.com/Brubacker/ESP12_DEV) board.
![DEV Board](https://raw.githubusercontent.com/area3001/jellyfish/master/img/ESP12_DEV00_0.jpg)

The pixels used in Jellyfish feature a LPD6803 IC paired with 4 RGB LEDs each to improve the pixel brightness. The pixels are arranged in a 8x8 configuration to create a large (approx. 1m by 1m) LED panel. the panel itself is fabricated using a thick 18mm piece of MDF wood for the back side, and 4mm thick MDF for the cross sections. The side panels and top panel will be made from opaque acryl.

![Pixel](https://raw.githubusercontent.com/area3001/jellyfish/master/img/LPD6803_PIXEL.jpg)
![Panel closeup](https://raw.githubusercontent.com/area3001/jellyfish/master/img/PANEL_CLOSEUP.jpg)

### Software

#### Client

Thanks to the folks from the [ESP8266 Community Forum](https://github.com/esp8266) we've been able to program the ESP12E using the Arduino IDE resulting in an easy to understand and easy to modify program.

#### Server

