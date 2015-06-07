App Server
==========
POI App Server


Dependencies
------------

- Ruby 1.8.7+
- Memcached

install

    % brew install memcached libmemcached
    % gem install bundler
    % bundle install


Run App Server
--------------

    % RACK_ENV=production
    # or
    % RACK_ENV=development

    % bundle exec rackup config.ru -p 8931

=> http://localhost:8931


API
---

get data from TAG

    % curl http://localhost:8931/tag/#{tag_id}


post data to TAG

    % curl -d '#{data}' http://localhost:8931/tag/#{tag_id}


copy TAG's data to POI

    % curl -d 'poi=#{poi_id}' http://localhost:8931/tag/#{tag_id}/copy


paste POI's data to TAG

    % curl -d 'poi=#{poi_id}' http://localhost:8931/tag/#{tag_id}/paste


