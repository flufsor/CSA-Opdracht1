FROM python:alpine

ENV BEPASTY_CONFIG=/bepasty/bepasty.conf

RUN \
python -m venv bepasty && \
source /bepasty/bin/activate && \
pip install bepasty gunicorn gevent && \
mkdir /storage
 
COPY example-config.conf /bepasty/bepasty.conf
 
EXPOSE 4000
 
CMD ["/bepasty/bin/gunicorn", "bepasty.wsgi", "-k", "gevent", "--log-level=info", "--name", "bepasty", "--bind=0.0.0.0:4000", "--workers=4"]