# Local LLM Service

This service provides a local large language model (LLM) powered by `llama.cpp`.

## Prerequisites

1.  **`llama.cpp`**: This project uses `llama.cpp` to run the local LLM. You will need to clone and build it.

    ```bash
    git clone https://github.com/ggerganov/llama.cpp.git
    cd llama.cpp
    make
    ```

2.  **Model**: This service is configured to use the **Phi-3 Mini 4k Instruct GGUF** model. You will need to download it. A common place to find GGUF models is on Hugging Face. Make sure to download a quantized version (e.g., `Q4_K_M`) for efficient performance.

    - **Model to use**: `Phi-3-mini-4k-instruct.gguf`

    Place the downloaded model in a `models/` directory at the root of the repository (you will need to create this directory).

## Running the service

The `llama.cpp` server can be run using the following command, which is also available as a VSCode task (`local-llm:serve`):

```bash
./llama.cpp/main -m models/Phi-3-mini-4k-instruct.gguf -c 4096 -ngl 999 --server --port 8080
```

This will start a server compatible with the OpenAI API on port 8080.
