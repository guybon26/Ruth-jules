# Testing the Ruth iOS App on Your iPhone

This guide provides step-by-step instructions to build and run the Ruth application on your physical iPhone.

## Prerequisites

1.  **A Mac with Xcode**: You need a Mac with the latest version of Xcode installed. You can download it from the Mac App Store.
2.  **An iPhone**: This guide is tailored for an iPhone 13 mini, but it will work on other modern iPhones as well.
3.  **Apple Developer Account**: You will need to sign into Xcode with your Apple ID to sign the app and run it on your device. A free account is sufficient.
4.  **The `Phi-3-mini-4k-instruct` GGUF model file** on your Mac.

## Step 1: Compile the SLM Model

Before you can run the app, you need to compile the SLM into the format used by the MLC framework.

1.  Open a terminal on your Mac.
2.  Follow the instructions in `apps/ios-app/mlc-build/README.md` to compile the `Phi-3-mini-4k-instruct.gguf` model.
3.  After running the `mlc_llm compile` command, you will have a `.tar` file. Unzip it. This will create a directory named `Phi-3-mini-4k-instruct-q4f16_1`. This directory contains the model library and weights. Keep this directory handy.

## Step 2: Open and Configure the Xcode Project

1.  **Open the Project**:
    *   Navigate to the `apps/ios-app` directory in your terminal.
    *   Run the following command to open the project in Xcode:
        ```bash
        xed .
        ```
    *   Alternatively, you can drag the `Package.swift` file from `apps/ios-app` onto the Xcode icon in your dock.

2.  **Add the Compiled Model to the Project**:
    *   In Xcode, you will see the project navigator on the left.
    *   Drag the compiled model directory (`Phi-3-mini-4k-instruct-q4f16_1`) from Finder directly into the **`Sources/Ruth`** folder in the Xcode project navigator.
    *   A dialog box will appear. Make sure **"Copy items if needed"** is checked and that the target **"Ruth"** is selected. Click "Finish".

3.  **Set Up Code Signing**:
    *   In the project navigator, click on the top-level item ("Ruth") to open the project settings.
    *   Select the "Ruth" target from the list on the left.
    *   Go to the **"Signing & Capabilities"** tab.
    *   Select your Apple ID from the "Team" dropdown menu. Xcode may prompt you to register your device.

## Step 3: Build and Run the App

1.  **Connect Your iPhone**:
    *   Connect your iPhone 13 mini to your Mac with a USB cable.
    *   Unlock your iPhone. You may need to tap "Trust" on your iPhone to allow your Mac to access it.

2.  **Select the Target Device**:
    *   At the top of the Xcode window, next to the "Run" (▶) and "Stop" (■) buttons, you'll see the current target (it might say "Any iOS Device").
    *   Click on it and select your iPhone from the list of devices.

3.  **Run the App**:
    *   Click the "Run" button (▶) or press **Cmd+R**.
    *   Xcode will build the app, install it on your iPhone, and launch it.

The first time the app launches, it will begin loading the model. You will see a "Loading Model..." indicator. Once it's done, you can start chatting with Ruth!
