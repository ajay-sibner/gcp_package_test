# Need to specify platform otherwise building the container on apple silicon would not install the latest version of libpq
FROM python:3.14-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED 1

WORKDIR /code

RUN apt-get update &&  \
    apt-get install -y --no-install-recommends g++ libpq-dev

# Copy the requirements file and install
COPY Pipfile Pipfile.lock ./

ARG AR_AUTH_TOKEN
RUN echo "machine europe-west1-python.pkg.dev login oauth2accesstoken password $AR_AUTH_TOKEN" > ~/.netrc

RUN pip install pipenv
RUN pipenv sync --dev --system && rm ~/.netrc
