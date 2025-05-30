# Use official NVIDIA CUDA image with Ubuntu (for GPU support)
FROM nvidia/cuda:12.2.0-runtime-ubuntu22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV OLLAMA_BASE_URL=http://localhost:11434

# Switch to a more reliable mirror & install system dependencies
RUN sed -i 's|http://archive.ubuntu.com/ubuntu|http://mirror.math.princeton.edu/pub/ubuntu|g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --fix-missing \
    curl \
    git \
    unzip \
    python3 \
    python3-pip \
    python3-venv && \
    apt-get clean

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | bash

# Add Ollama to PATH
ENV PATH="/root/.ollama/bin:$PATH"

# Pull required models
RUN ollama pull llama3:8b && ollama pull mxbai-embed-large

# Set working directory
WORKDIR /app

# Copy all project files into the container
COPY . .

# Install Python dependencies
RUN pip install --upgrade pip && pip install -r requirements.txt

# Start Ollama server, build the vector store, and launch FastAPI
CMD ["bash", "-c", "ollama serve & sleep 10 && python3 app/load_documents.py && uvicorn app.main:app --host 0.0.0.0 --port 8000"]
