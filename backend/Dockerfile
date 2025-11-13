# Dockerfile at: backend/Dockerfile

FROM python:3.11-slim

# Working directory inside the container
WORKDIR /app

# Copy requirements from the app folder
COPY app/requirements.txt ./requirements.txt

# Install Python deps
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire backend project into the container
COPY . .

# Expose FastAPI port
EXPOSE 8000

# Run the FastAPI app
# main.py is in app/main.py, so module path is app.main:app
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
