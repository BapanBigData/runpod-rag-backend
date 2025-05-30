# ✅ Use CUDA-enabled Ubuntu base for GPU
FROM nvidia/cuda:12.2.0-runtime-ubuntu22.04

# ✅ Environment setup
ENV DEBIAN_FRONTEND=noninteractive
ENV OLLAMA_BASE_URL=http://localhost:11434

# ✅ Use reliable mirror and install system packages
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

# ✅ Install Ollama manually from .deb
RUN curl -LO https://ollama.com/download/Ollama-linux.deb && \
    apt-get install -y ./Ollama-linux.deb && \
    rm Ollama-linux.deb

# ✅ Pull Ollama models (LLM + embeddings)
RUN ollama pull llama3:8b && ollama pull mxbai-embed-large

# ✅ Set work directory
WORKDIR /app

# ✅ Copy project files
COPY . .

# ✅ Install Python dependencies
RUN pip install --upgrade pip && pip install -r requirements.txt

# ✅ Run Ollama, build vector store, and launch FastAPI
CMD ["bash", "-c", "ollama serve & sleep 10 && python3 app/load_documents.py && uvicorn app.main:app --host 0.0.0.0 --port 8000"]
