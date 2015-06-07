Push Server
===========
POI Push Server


Dependencies
------------

- Ruby 1.8.7+

install

    % gem install bundler
    % bundle install


Run Push Server
---------------

    % bundle exec ruby push-server.rb -help
    % bundle exec ruby push-server.rb -p 8932 -timeout 60

API
---

put clipboard data

    % curl -d '#{data}' http://localhost:8932/#{tag_id}


get clipboard data (comet)

    % curl http://localhost:8932/#{tag_id}
