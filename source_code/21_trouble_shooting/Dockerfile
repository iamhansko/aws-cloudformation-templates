FROM python:3.7-alpine
WORKDIR /app
COPY ./app.py ./
RUN python3 -m pip install flask
CMD ["python3", "./app.py"]