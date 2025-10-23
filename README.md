# Ruth.

**"Loyal to the Truth."**

Ruth is a privacy-first, hybrid edge-first personal assistant. It is designed to execute most user requests on-device via a Small Language Model (SLM) and selectively offloads complex work to a cloud LLM.

## Project Structure

This repository is a monorepo containing the following components:

-   `apps/desktop-ui`: The Electron (React) shell for the desktop application.
-   `services/`: A collection of backend services that power Ruth.
    -   `router/`: The orchestrator that decides whether a request should be handled locally or by the cloud.
    -   `redactor/`: A service for PII/PHI detection and masking.
    -   `local-llm/`: A `llama.cpp` server for running the local SLM.
    -   `cloud-proxy/`: A vendor-agnostic gateway to cloud LLM(s).
-   `packages/shared/`: Shared code, types, prompts, and JSON schemas.
-   `infra/`: Infrastructure-related configurations.
    -   `docker/`: Dockerfiles and Docker Compose for orchestration.
    -   `ci/`: Continuous integration configurations.
-   `.vscode/`: VSCode tasks and launch configurations for development.

## Getting Started

1.  **Set up the Local LLM**: Follow the instructions in `services/local-llm/README.md` to download and build `llama.cpp` and the required GGUF model.
2.  **Install Dependencies**: Each service has its own dependencies. For the Python services, you can install them using `pip install -r requirements.txt`. For the UI, use `pnpm install`.
3.  **Run the Services**: You can run the services individually using the VSCode tasks defined in `.vscode/tasks.json` or all at once using Docker Compose:

    ```bash
    docker-compose -f infra/docker/docker-compose.yml up --build
    ```

Refer to the PRD for a more detailed breakdown of the project's architecture and goals.
