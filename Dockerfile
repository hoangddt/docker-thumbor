FROM python:2

MAINTAINER Edu Herraiz <ghark@gmail.com>
MAINTAINER Quoc Hoang <hi@hoangddt.net>

VOLUME /data

# Things required for a python/pip environment
COPY system-requirements.txt /usr/src/app/system-requirements.txt
RUN  \
    awk '$1 ~ "^deb" { $3 = $3 "-backports"; print; exit }' /etc/apt/sources.list > /etc/apt/sources.list.d/backports.list && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y autoremove && \
    xargs apt-get -y -q install < /usr/src/app/system-requirements.txt && \
    apt-get clean

ENV HOME /usr/src/app
ENV SHELL bash
ENV WORKON_HOME /usr/src/app
WORKDIR /usr/src/app

COPY thumbor.conf /usr/src/app/thumbor.conf
COPY requirements.txt /usr/src/app/requirements.txt
RUN pip install -r /usr/src/app/requirements.txt

COPY conf/thumbor.conf.tpl /usr/src/app/thumbor.conf.tpl

RUN \ 
    ln /usr/lib/python2.7/dist-packages/cv2.x86_64-linux-gnu.so /usr/local/lib/python2.7/cv2.so && \
    ln /usr/lib/python2.7/dist-packages/cv.py /usr/local/lib/python2.7/cv.py

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["thumbor"]

EXPOSE 8000
