#include <ArduinoBLE.h>
#include "FastLED.h"

#define NUM_LEDS 50
CRGB leds[NUM_LEDS];

BLEService bleService("180A");
BLEByteCharacteristic* characteristics[1];

int receivedValues[5];
int currentValueIndex = 0;
int dataWasSentFlag = 0;
int currentLEDIndex = 0;

unsigned long flashInterval = 250;
unsigned long runInterval = 250;
unsigned long previousMillis = 0;

static uint8_t hue = 0;
bool fadingIn = true;

CRGB currentColor = CRGB::Black;

enum State {
  WAIT_FOR_START_BIT,
  RECEIVE_DATA,
  PROCESS_DATA
};

State currentState = WAIT_FOR_START_BIT;

void setup() {
  Serial.begin(9600);
  while (!Serial);

  FastLED.addLeds<NEOPIXEL, 6>(leds, NUM_LEDS);

  BLE.begin();
  BLE.setLocalName("Arduino Uno R4 Wifi");
  BLE.setAdvertisedService(bleService);

  String uuid = "00000000-0000-1000-8000-00805F9B34FB";
  characteristics[0] = new BLEByteCharacteristic(uuid.c_str(), BLERead | BLEWrite);
  bleService.addCharacteristic(*characteristics[0]);

  BLE.addService(bleService);
  BLE.advertise();

  Serial.println("Bluetooth® device active, waiting for connections...");
}

void loop() {
  BLEDevice controller = BLE.central();

  switch (currentState) {
    case WAIT_FOR_START_BIT:
      if (controller.connected()) {
        if (characteristics[0]->written()) {
          size_t length = characteristics[0]->valueLength();
          uint8_t receivedBytes[length];
          characteristics[0]->readValue(receivedBytes, length);

          int receivedValue = 0;
          for (int j = 0; j < length; j++) {
            receivedValue = (receivedValue << 8) | receivedBytes[j];
          }

          if (receivedValue == 0) {
            currentState = RECEIVE_DATA;
          }
        }
      }
      if(dataWasSentFlag) {
        effectSelector();
      }
      break;

    case RECEIVE_DATA:
      if (characteristics[0]->written()) {
        size_t length = characteristics[0]->valueLength();
        uint8_t receivedBytes[length];
        characteristics[0]->readValue(receivedBytes, length);

        int receivedValue = 0;
        for (int j = 0; j < length; j++) {
          receivedValue = (receivedValue << 8) | receivedBytes[j];
        }

        receivedValues[currentValueIndex] = receivedValue;
        currentValueIndex++;

        if (currentValueIndex == 5) {
          currentValueIndex = 0;
          processReceivedValues();
          dataWasSentFlag = 1;
          currentState = WAIT_FOR_START_BIT;
        }
      }
      break;
  }
}

void processReceivedValues() {
  for (int i = 0; i < 5; i++) {
    Serial.print("Received Value ");
    Serial.print(i);
    Serial.print(": ");
    Serial.println(receivedValues[i]);
  }
}

void effectSelector() {

  switch (receivedValues[0]) {
    case 0:
      fill_solid(leds, NUM_LEDS, CRGB(receivedValues[2], receivedValues[3], receivedValues[4]));
      FastLED.show();
      break;

    case 1:
      fadeEffect();  
      break;

    case 2:
      flashEffect();
      break;

    case 3:
      runningLightEffect();
      break;

    case 4:
      rainbowFadeEffect();
      break;

    default:
      switchError();
      break;
  }
}

void switchError() {
  unsigned long currentMillis = millis();

  if (currentMillis - previousMillis >= 500) {
    if (leds[0] == CRGB::Black) {
      fill_solid(leds, NUM_LEDS, CRGB(255, 0, 0));
    } else {
      fill_solid(leds, NUM_LEDS, CRGB::Black);
    }

    FastLED.show();
    previousMillis = currentMillis;
  }
}

void flashEffect() {
  unsigned long currentMillis = millis();

  if (currentMillis - previousMillis >= (flashInterval / (receivedValues[1] / 10))) {
    Serial.println((flashInterval * (receivedValues[1] / 10)));
    if (leds[0] == CRGB::Black) {
      fill_solid(leds, NUM_LEDS, CRGB(receivedValues[2], receivedValues[3], receivedValues[4]));
    } else {
      fill_solid(leds, NUM_LEDS, CRGB::Black);
    }

    FastLED.show();
    previousMillis = currentMillis;
  }
}

void runningLightEffect() {
  static unsigned long lastMillis = 0;
  unsigned long currentMillis = millis();

  if (currentMillis - lastMillis >= (runInterval * (20 - receivedValues[1] / 10))) {
    Serial.println((runInterval * (receivedValues[1] / 10)));
    fill_solid(leds, NUM_LEDS, CRGB::Black);
    leds[currentLEDIndex] = CRGB(receivedValues[2], receivedValues[3], receivedValues[4]);
    FastLED.show();

    currentLEDIndex++;

    if (currentLEDIndex == NUM_LEDS) {
      currentLEDIndex = 0;
      currentState = WAIT_FOR_START_BIT;
    }

    lastMillis = currentMillis;
  }
}

void rainbowFadeEffect() {
  static unsigned long lastMillis = 0;
  unsigned long currentMillis = millis();

  if (currentMillis - lastMillis >= 50) {  // Adjust the delay as needed
    CRGB color = CHSV(hue, 255, 255);

    fill_solid(leds, NUM_LEDS, color);
    FastLED.show();

    EVERY_N_MILLISECONDS(10) {
      hue++;
    }

    lastMillis = currentMillis;
  }
}

void fadeEffect() {
  uint16_t speed = 100; // Adjust the speed as needed

  EVERY_N_MILLISECONDS(speed) {
    if (fadingIn) {
      nblend(currentColor, CRGB(receivedValues[2], receivedValues[3], receivedValues[4]), 5); // Adjust the blending factor as needed
      if (currentColor.r + currentColor.g + currentColor.b >= 765) {  // Check if the brightness is close to 255*3 (white)
        fadingIn = false;
      }
    } else {
      nblend(currentColor, CRGB::Black, 5); // Adjust the blending factor as needed
      if (currentColor.r + currentColor.g + currentColor.b <= 0) {  // Check if the brightness is close to zero
        fadingIn = true;
      }
    }

    fill_solid(leds, NUM_LEDS, currentColor);
    FastLED.show();
  }
}
