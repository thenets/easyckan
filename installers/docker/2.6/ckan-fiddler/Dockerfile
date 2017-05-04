FROM debian:wheezy

# Thanks to https://github.com/jwieringa

RUN apt-get update \
  && apt-get install -y curl unzip \
  && rm -rf /var/lib/apt/lists/*

RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF

RUN echo "deb http://download.mono-project.com/repo/debian wheezy/snapshots/3.12.0 main" > /etc/apt/sources.list.d/mono-xamarin.list \
  && apt-get update \
  && apt-get install -y mono-devel ca-certificates-mono fsharp mono-vbnc nuget \
  && rm -rf /var/lib/apt/lists/*

RUN cd /tmp && curl -O http://ericlawrence.com/dl/MonoFiddler-v4484.zip

RUN unzip /tmp/MonoFiddler-v4484.zip

ENTRYPOINT ["mono", "/app/Fiddler.exe"]