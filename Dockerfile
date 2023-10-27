FROM python:3.7
WORKDIR /
COPY requirements.txt /
RUN pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
COPY hugo-encryptor.py /
CMD ["python", "hugo-encryptor.py"]
