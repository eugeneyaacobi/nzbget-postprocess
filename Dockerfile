FROM linuxserver/nzbget
MAINTAINER eyaacobi

VOLUME /scripts

# Install Git
RUN apk add --no-cache git

# Install MP4 Automator
RUN apk add --no-cache \
  py-setuptools \
  py-pip \
  python3-dev \
 libffi-dev \
  gcc \
  musl-dev \
  openssl-dev \
  ffmpeg
RUN pip install --upgrade PIP
RUN pip install requests
RUN pip install requests[security]
RUN pip install requests-cache
RUN pip install babelfish
RUN pip install "guessit<2"
RUN pip install "subliminal<2"
RUN pip install qtfaststart

# Install nzbToMedia
RUN apk add --no-cache git
RUN git clone https://github.com/clinton-hall/nzbToMedia.git /scripts/nzbToMedia


RUN echo 'nzbToGamez.py:auto_update=1' >> /config/nzbget.conf
RUN echo 'nzbToHeadPhones.py:auto_update=1' >> /config/nzbget.conf
RUN echo 'nzbToMedia.py:auto_update=1' >> /config/nzbget.conf
RUN echo 'nzbToMylar.py:auto_update=1' >> /config/nzbget.conf
RUN echo 'nzbToNzbDrone.py:auto_update=1' >> /config/nzbget.conf
RUN echo 'nzbToSickBeard.py:auto_update=1' >> /config/nzbget.conf

#Set script file permissions
RUN chmod 775 -R /scripts

#Set script directory setting in NZBGet
#RUN /app/nzbget -o ScriptDir=/app/scripts,${MP4Automator_dir},/scripts/nzbToMedia
ONBUILD RUN sed -i 's/^ScriptDir=.*/ScriptDir=\/app\/scripts;\/scripts\/MP4_Automator;\/scripts\/nzbToMedia/' /config/nzbget.conf

#Adding Custom files
ADD init/ /etc/my_init.d/
RUN chmod -v +x /etc/my_init.d/*.sh