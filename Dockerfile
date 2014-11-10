FROM shippableimages/ubuntu1404_python
MAINTAINER John Krauss <irving.krauss@gmail.com>

RUN apt-get update && apt-get -y install libxml2-dev libxslt-dev python-dev
RUN pip install git+https://github.com/govlab/nikola.git@d20b42aafa845ae4e1393f475e5bb86870c332b0#egg=common webassets markdown jinja2
