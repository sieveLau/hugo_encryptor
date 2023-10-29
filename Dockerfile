# FROM python:3.7 as build
FROM alpine
WORKDIR /
COPY requirements.txt /
RUN apk add python3 py3-pip
RUN pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
COPY hugo-encryptor.py /
CMD ["python", "hugo-encryptor.py"]
