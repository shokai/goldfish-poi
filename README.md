goldfish poi
============
copy and paste


Install Dependencies
--------------------

    % brew install memcached libmemcached
    % gem install bundler
    % bundle install


Config
------

    % cp sample.config.yaml config.yaml
   
edit config.


Run Push Server
---------------

    % ruby workers/push-server.rb -help
    % ruby workers/push-server.rb -p 8932 -timeout 60


Run App Server
--------------

    % ruby development.ru

or, use Passenger