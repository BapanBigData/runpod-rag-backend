
import os
from langchain_community.document_loaders import Docx2txtLoader
from langchain_community.embeddings import OllamaEmbeddings
from langchain_community.vectorstores import Chroma

# ✅ Make sure LangChain hits the correct Ollama endpoint
os.environ["OLLAMA_BASE_URL"] = "http://localhost:11434"

def build_vector_store():
    loader1 = Docx2txtLoader("documents/PMT_FAQ.docx")
    loader2 = Docx2txtLoader("documents/Status_15MAY.docx")
    docs = loader1.load() + loader2.load()

    embeddings = OllamaEmbeddings(model="mxbai-embed-large:latest")

    vectordb = Chroma.from_documents(
        documents=docs,
        embedding=embeddings,
        persist_directory="vector_store"
    )

    print(f"✅ Loaded {len(docs)} documents into vector store.")

if __name__ == "__main__":
    build_vector_store()
    print("✅ Vector DB built and saved.")


