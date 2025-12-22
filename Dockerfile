# Need to specify platform otherwise building the container on apple silicon would not install the latest version of libpq
FROM python:3.14-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED 1

WORKDIR /code

RUN apt-get update &&  \
    apt-get install -y --no-install-recommends g++ libpq-dev git openssh-client

# Copy the requirements file and install
COPY Pipfile Pipfile.lock ./

RUN mkdir -p -m 0600 /root/.ssh && ssh-keyscan github.com >> /root/.ssh/known_hosts
RUN pip install pipenv keyrings.google-artifactregistry-auth
RUn ls -la
RUN pipenv sync --dev
RUN --mount=type=ssh pipenv install --dev --system --deploy && \
    rm -rf /var/lib/apt/lists/*

RUN rm -rf /root/.ssh/

