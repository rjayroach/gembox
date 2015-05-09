FROM ruby:2.2
RUN mkdir /app
RUN mkdir /data
WORKDIR /app
ADD Gemfile* /app/
ADD gembox.gemspec /app/gembox.gemspec
ADD lib/gembox/version.rb /app/lib/gembox/version.rb
RUN bundle install --without development:test --deployment
ADD . /app
EXPOSE 9000
CMD ["bundle", "exec", "rackup", "-p", "9000", "public.ru", "-o", "0.0.0.0"]

