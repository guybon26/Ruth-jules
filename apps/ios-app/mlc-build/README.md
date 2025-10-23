# Compiling the Phi-3 Mini Model with MLC

This guide outlines the steps to compile the `Phi-3-mini-4k-instruct.gguf` model into a format compatible with the MLC (Machine Learning Compilation) framework for use in the Ruth iOS app.

## Prerequisites

1.  **Python Environment**: Ensure you have a Python 3.9+ environment.
2.  **MLC-LLM**: Install the MLC-LLM build tools.

    ```bash
    pip install --pre -U -f https://mlc.ai/wheels mlc-llm-nightly mlc-chat-nightly
    ```

## Compilation Steps

1.  **Convert Model Weights**: The first step is to convert the GGUF model weights into the MLC format.

    ```bash
    # Create a directory for the conversion process
    mkdir -p ./dist/models
    cd ./dist/models

    # Run the conversion script
    python -m mlc_llm.testing.convert_weights \
        --model-name Phi-3-mini-4k-instruct --model-format gguf \
        --model /path/to/your/Phi-3-mini-4k-instruct.Q4_K_M.gguf \
        --quantization q4f16_1 \
        --output .
    ```

2.  **Generate Model Library**: Once the weights are converted, you need to compile the model into a library that can be loaded by the iOS app.

    ```bash
    # From the `dist` directory
    cd ..

    # Compile the model
    mlc_llm compile ./models/Phi-3-mini-4k-instruct \
        --device iphone \
        --target "apple/iphone-14-pro-max" \
        --output ./lib/Phi-3-mini-4k-instruct-q4f16_1-iphone.tar
    ```
    *Note: Replace `iphone-14-pro-max` with a target compatible with the iPhone 13 mini if needed, though this is a generally safe target.*

3.  **Place Artifacts in Xcode Project**:
    -   Unzip the generated `.tar` file.
    -   Drag the resulting directory (containing the model library and weights) into the Xcode project (`apps/ios-app/Ruth/`).
    -   Ensure it's added to the "Copy Bundle Resources" build phase.

After completing these steps, the model will be available to be loaded by the MLC runtime within the iOS application.
