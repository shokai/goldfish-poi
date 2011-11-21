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

    % ruby development.ru

or, use Passenger


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


