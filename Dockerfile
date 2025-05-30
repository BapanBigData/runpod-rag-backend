# Use official NVIDIA CUDA image with Ubuntu (for GPU support)
FROM nvidia/cuda:12.2.0-runtime-ubuntu22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV OLLAMA_BASE_URL=http://localhost:11434

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    python3 \
    python3-pip \
    python3-venv \
    && apt-get clean

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | bash

# Add Ollama to PATH
ENV PATH="/root/.ollama/bin:$PATH"

# Pull required models
RUN ollama pull llama3:8b && ollama pull mxbai-embed-large

# Set working directory
WORKDIR /app

# Copy all project files into container
COPY . .

# Install Python dependencies
RUN pip install --upgrade pip && pip install -r requirements.txt

# Start Ollama, build vector store, then launch FastAPI
CMD ollama serve & \
    sleep 10 && \
    python3 app/load_documents.py && \
    uvicorn app.main:app --host 0.0.0.0 --port 8000