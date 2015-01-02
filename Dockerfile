FROM ruby:2.2
RUN mkdir /srv/app
RUN mkdir /data
WORKDIR /srv/app
ADD . /srv/app
RUN bundle install
EXPOSE 9000
CMD ["bundle", "exec", "rackup", "-p", "9000", "-D", "public.ru"]

