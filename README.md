# Brainrot Video Generator 

A web application that automatically generates "brainrot" videos from PDF content with AI-generated subtitles and audio.

##  Description

This application allows users to:
- Upload a PDF file
- Convert content into the "brainrot" style using Groq LLM
- Automatically download random videos from a YouTube playlist
- Generate audio from text using Google Text-to-Speech
- Automatically create subtitles with Whisper AI
- Combine everything into a complete video

## Installation and Usage

### Requirements
- Docker Desktop
- Groq API key (included in the code or provided manually)
- Internet connection

### Installation Steps

1. Clone repository:
```bash
git clone <repository-url>
cd brainrot
```

2. Build Docker image:
```bash
docker build -t brainrot-app .
```

3. Run the container:
```bash
docker run -p 8000:8000 -p 8501:8501 brainrot-app
```

##  Tool Utilized

### Backend
- FastAPI: REST API framework
- Whisper AI: Speech-to-text conversion
- Groq LLM: Text processing and transformation
- FFmpeg: Video processing
- MoviePy: Video editing
- gTTS (Google Text-to-Speech): Text-to-speech conversion

### Frontend
- Streamlit: Web user interface

### Other Tools and Libraries
- yt-dlp: Downloading videos from YouTube
- PyPDF: PDF file reading
- ImageMagick: Image processing
- pydub: Audio processing

##  Project Structure
```
brainrot/
├── app.py # Streamlit (Frontend)
├── api.py # FastAPI endpoints (Backend)
├── Dockerfile # Docker config
├── requirements.txt # Python dependencies
└── packages.txt # System dependencies
