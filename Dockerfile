FROM nvidia/cuda:12.2.0-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV OLLAMA_BASE_URL=http://localhost:11434

RUN sed -i 's|http://archive.ubuntu.com/ubuntu|http://mirror.math.princeton.edu/pub/ubuntu|g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --fix-missing \
    curl \
    git \
    unzip \
    python3 \
    python3-pip \
    python3-venv \
    libcuda1-525 && \
    apt-get clean

RUN curl -LO https://ollama.com/download/Ollama-linux.deb && \
    apt-get install -y ./Ollama-linux.deb && \
    rm Ollama-linux.deb

RUN /usr/bin/ollama pull llama3:8b && /usr/bin/ollama pull mxbai-embed-large

WORKDIR /app
COPY . .

RUN pip install --upgrade pip && pip install -r requirements.txt

# ✅ Use absolute path to avoid "ollama: not found"
CMD ["bash", "-c", "/usr/bin/ollama serve & sleep 10 && python3 app/load_documents.py && uvicorn app.main:app --host 0.0.0.0 --port 8000"]
