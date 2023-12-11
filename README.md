
# Prism Control

A simple app that allows you to select the color and effect for a WS2812B LED strip, controlled by an Arduino UNO R4 WiFi. The app establishes a connection via Bluetooth Low Energy (BLE) between your smartphone and the Arduino controller, sending the selected data upon command.



## Features

- Select Color
- Select Effect
- Select Speed
- Live previews

## Installation

Currently, installing iOS apps that aren't on the App Store can be challenging. Below are two methods for installing the app on your chosen device.

### With a Mac/MacBook

1. **Download and Install Xcode:** If you don't have Xcode installed on your computer, download and install it from the [official Apple website](https://developer.apple.com/xcode/).

2. **Connect your iOS Device:** Use a USB cable to connect your iPhone to your computer.

3. **Clone Repository:** Download or clone the repository."

4. **Enable Developer Mode:** [Enable Developer Mode](https://developer.apple.com/documentation/xcode/enabling-developer-mode-on-a-device) on your iOS device.

5. **Open Project:** Launch Xcode on your computer. Ensure you are using the latest version of Xcode.

6. **Select Deployment Target:** Select your connected device as a deployment target.

7. **Install Application:** Click the "Play" button to build and install the app on your chosen deployment target.

8. **Trust Developer:** Before launching the application, you need to trust the developer. [Here is an article](https://support.apple.com/de-at/HT204460#:~:text=Tippe%20auf%20%22Einstellungen%22%20%3E%20%22,f%C3%BCr%20diesen%20Entwickler%20zu%20etablieren.) on trusting the developer.

**Note:** Ensure that the repository file is obtained from a trusted source, and you have the necessary permissions to install third-party apps on your iOS device.

### Without a Mac/MacBook

1. **Download and Install iTunes:** If you don't have iTunes installed on your computer, download and install it from the [official Apple website](https://www.apple.com/itunes/).

2. **Connect your iOS Device:** Use a USB cable to connect your iPhone to your computer.

3. **Open iTunes:** Launch iTunes on your computer. Ensure you are using the latest version of iTunes.

4. **Authorize your Computer:** If prompted, authorize your computer to access your iOS device.

5. **Navigate to the "Apps" Section:** In iTunes, click on your device icon in the upper-left corner. In the left sidebar, click on "Apps."

6. **Add the App to iTunes:** Locate the IPA file of the app you want to install. You can obtain this file from the app developer or other legitimate sources.

7. **Install the App:** Drag and drop the IPA file into the "Apps" section in iTunes. Alternatively, use the "Add File to Library" option in the "File" menu.

8. **Sync your Device:** Click the "Sync" button in the bottom-right corner of iTunes to sync your device and install the app.

9. **Eject your Device:** Once the sync is complete, safely eject your iOS device from your computer.

10. **Check your Device:** The app should now be installed on your iOS device. You can find it on your home screen.

**Note:** Ensure that the app's IPA file is obtained from a trusted source, and you have the necessary permissions to install third-party apps on your iOS device.

## Prerequisites

- [Arduino IDE](https://www.arduino.cc/en/Main/Software)
- [Arduino UNO R4 WiFi](https://store.arduino.cc/products/uno-r4-wifi)
- [XCode](https://developer.apple.com/xcode/) or [iTunes](https://www.apple.com/at/itunes/)
- WS2812B LED strip
- iPhone
Optional
- Jumper cable
- Developer Board
- 1 x 330 Ω Resistor

**NOTE:** Here is a [link](https://howtomechatronics.com/tutorials/arduino/how-to-control-ws2812b-individually-addressable-leds-using-arduino/) where you can find a detailed explanation of how to connect a WS2812B strip and how it works in general.

## To-Do List

### User Interface (UI) Enhancement
- Implement improvements for a more user-friendly and aesthetically pleasing interface.
- Enhance the visual design and user experience.

### Code Documentation
- Thoroughly document the codebase to improve clarity and understanding.
- Include comments, explanations, and documentation for functions, methods, and important code segments.

## Feedback

If you have any feedback, please reach out to me at liquiddron3.github@gmail.com. 

