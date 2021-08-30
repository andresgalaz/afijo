# syntax=docker/dockerfile:1
FROM python:3
ENV PYTHONUNBUFFERED=1
WORKDIR /code
COPY requirements.txt /code/
RUN apt-get update && apt-get install -y \
	libgirepository1.0-doc \
	libgirepository1.0-dev \
	vim
# RUN pip install -r requirements.txt
COPY . /code/
