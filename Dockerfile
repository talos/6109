FROM shippableimages/ubuntu1404_python
MAINTAINER John Krauss <irving.krauss@gmail.com>

RUN apt-get update && apt-get -y install libxml2-dev libxslt-dev python-dev
RUN pip install nikola webassets markdown
