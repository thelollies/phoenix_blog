FROM trenpixster/elixir
MAINTAINER Rory Stephenson "rorystephenson@gmail.com"

ENV REFRESHED_AT 2015-09-17-08-57

RUN apt-get update
RUN apt-get -y install postgresql-client
RUN mkdir -p /opt/app/blog/prod
ADD . /opt/app/blog/prod
WORKDIR /opt/app/blog/prod

ENV MIX_ENV prod
RUN mix deps.get --only prod
RUN mix compile

ENV PORT 4000

EXPOSE 4000
CMD [ "/opt/app/blog/prod/bin/docker_run" ]
