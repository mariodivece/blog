# Working with the fantastic Trinket M0

<img src="https://raw.githubusercontent.com/mariodivece/blog/master/images/trinket-m0.jpeg"></img>

I fixed the default code for ```main.py``` to make it more readable
```python
"""
Trinket IO demos
Welcome to CircuitPython 2.0.0 :)

Editor: Visual Studio Code

Naming Conventions:
module_name, package_name, ClassName, method_name, ExceptionName, function_name,
GLOBAL_CONSTANT_NAME, global_var_name, instance_var_name, function_parameter_name, local_var_name
"""

# region Module Imports
import time
import adafruit_dotstar as dotstar
import board
import neopixel
import touchio
from adafruit_hid.keyboard import Keyboard
from adafruit_hid.keycode import Keycode
from analogio import AnalogIn, AnalogOut
from digitalio import DigitalInOut, Direction, Pull
#endregion

#region Setup

# One pixel connected internally!
BUILTIN_DOTSTAR_LED = dotstar.DotStar(board.APA102_SCK, board.APA102_MOSI, 1, brightness=0.2)

# Built in red LED
BUILTIN_LED = DigitalInOut(board.D13)
BUILTIN_LED.direction = Direction.OUTPUT

# Analog input on D0
PORT_ANALOG_INPUT_D0 = AnalogIn(board.D0)

# Analog output on D1
PORT_ANALOG_OUTPUT_D1 = AnalogOut(board.D1)

# Digital input with pullup on D2
PORT_DIGITAL_INPUT_D2 = DigitalInOut(board.D2)
PORT_DIGITAL_INPUT_D2.direction = Direction.INPUT
PORT_DIGITAL_INPUT_D2.pull = Pull.UP

# Capacitive touch on D3
PORT_CAPACITIVE_INPUT_D3 = touchio.TouchIn(board.D3)

# NeoPixel strip (of 16 LEDs) connected on D4
NEOPIXELS_COUNT = 16
NEOPIXELS = neopixel.NeoPixel(
    board.D4, NEOPIXELS_COUNT, brightness=0.2, auto_write=False)

# Used if we do HID output, see below
KBD = Keyboard()

#endregion

#region Helper Methods

def get_voltage(pin):
    """Helper to convert analog input to voltage"""
    return (pin.value * 3.3) / 65536

def wheel(pos):
    """# Helper to give us a nice color swirl.
    Input a value 0 to 255 to get a color value.
    The colours are a transition r - g - b - back to r.
    """
    if pos < 0:
        return [0, 0, 0]
    if pos > 255:
        return [0, 0, 0]
    
    if pos < 85:
        return [int(pos * 3), int(255 - (pos * 3)), 0]
    elif pos < 170:
        pos -= 85
        return [int(255 - pos * 3), 0, int(pos * 3)]
    else:
        pos -= 170
        return [0, int(pos * 3), int(255 - pos * 3)]

#endregion

#region Main Loop
i = 0
while True:
    # spin internal LED around! autoshow is on
    BUILTIN_DOTSTAR_LED[0] = wheel(i & 255)

    # also make the neopixels swirl around
    for p in range(NEOPIXELS_COUNT):
        idx = int((p * 256 / NEOPIXELS_COUNT) + i)
        NEOPIXELS[p] = wheel(idx & 255)
    NEOPIXELS.show()

    # set analog output to 0-3.3V (0-65535 in increments)
    PORT_ANALOG_OUTPUT_D1.value = i * 256

    # Read analog voltage on D0
    print("D0: %0.2f" % get_voltage(PORT_ANALOG_INPUT_D0))

    # use D3 as capacitive touch to turn on internal LED
    if PORT_CAPACITIVE_INPUT_D3.value:
        print("D3 touched!")
    BUILTIN_LED.value = PORT_CAPACITIVE_INPUT_D3.value

    if not PORT_DIGITAL_INPUT_D2.value:
        print("PORT_DIGITAL_INPUT_D2 on D2 pressed!")
        # optional! uncomment below & save to have it sent a keypress
        #KBD.press(Keycode.A)
        #KBD.release_all()

    i = (i + 1) % 256  # run from 0 to 255
    time.sleep(0.1) # make bigger to slow down
#endregion

```
