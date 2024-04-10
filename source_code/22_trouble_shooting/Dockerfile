FROM python:3.12

WORKDIR /opt/app

COPY ./app.py ./

RUN python3 -m pip install flask

EXPOSE 8080

CMD ["python3", "./app.py"]