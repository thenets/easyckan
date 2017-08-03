FROM ubuntu:16.04

ENV DATAPUSHER_HOME /usr/lib/ckan/datapusher

#Install the required packages
RUN apt-get -qq update
RUN apt-get -qq -y install \
        python-dev \
        python-virtualenv \
        build-essential \
        libxslt1-dev \
        libxml2-dev \
        zlib1g-dev \
        git

#Create a source directory
RUN mkdir -p $DATAPUSHER_HOME/src

#Switch to source directory
WORKDIR $DATAPUSHER_HOME/src

#Clone the source
RUN git clone -b '0.0.10' https://github.com/ckan/datapusher.git

#Install pip
RUN apt-get install -y python-pip && \
        apt-get autoremove -y && \
        pip install -U pip
        
#Install the dependencies
WORKDIR datapusher
RUN pip install -r requirements.txt && \
        pip install -e .
EXPOSE 8800

#Run the DataPusher
CMD [ "python", "datapusher/main.py", "deployment/datapusher_settings.py"]