# base docker image
FROM python:3.11-slim

# Set environment variables
ENV POETRY_VERSION=2.1.0 \
    PYTHONUNBUFFERED=1 \
    POETRY_NO_INTERACTION=1

    # add these packages for pdf exporting jupyter notebooks
    # texlive-xetex \
    # pandoc
# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    gcc \
    libffi-dev \
    libpq-dev \
    python3-dev \
 && curl -sSL https://install.python-poetry.org | python3 - \
 && ln -s /root/.local/bin/poetry /usr/local/bin/poetry \
 && apt-get clean && rm -rf /var/lib/apt/lists/*


# working directory

WORKDIR /app
COPY pyproject.toml poetry.lock /app/


# Install dependencies (no venv, system-wide)
RUN poetry config virtualenvs.create false
RUN poetry install --no-root --only main


CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]