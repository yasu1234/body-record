FROM ruby:3.2.3

ENV WORKDIR /body-record

RUN apt-get update -qq && apt-get install -y postgresql-client
WORKDIR $WORKDIR
COPY Gemfile* ./
RUN bundle install
COPY . $WORKDIR

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
