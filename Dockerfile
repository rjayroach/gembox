FROM ruby:2.2
RUN mkdir /srv/app
RUN mkdir /data
WORKDIR /srv/app
ADD Gemfile /srv/app/Gemfile
ADD Gemfile.lock /srv/app/Gemfile.lock
ADD gembox.gemspec /srv/app/gembox.gemspec
ADD lib/gembox/version.rb /srv/app/lib/gembox/version.rb
RUN bundle install
ADD . /srv/app
EXPOSE 9000
CMD ["bundle", "exec", "rackup", "-p", "9000", "public.ru", "-o", "0.0.0.0"]

