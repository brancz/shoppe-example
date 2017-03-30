FROM rails:4

RUN apt-get update -qq
RUN apt-get install -y build-essential libpq-dev

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install

COPY . /usr/src/app
EXPOSE 3000
CMD bundle exec rackup -p 3000 --host 0.0.0.0
