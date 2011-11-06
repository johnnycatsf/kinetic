ABOUT
=====

Kinetic is a web application that uses The Echo Nest's API to generate kinetic
typographic visualization of user-specified text to conform with a selected
piece of music. Kinetic was created as part of Music Hack Day 2011 in Boston
(Nov. 5-6).

HUH?
====

Kinetic Typography is the art of animating dull, static text to give it more
emotional power. Kinetic makes the process of generating kinetic typography
really easy. You choose a piece of music, write or paste in a piece of text,
and our web app does the rest, animating the words along with the music. You
can then share the visualization with your friends, using a simple url.

EXAMPLES
========
We will have an instance of Kinetic running on Heroku soon, and you will be
able to see some awesome examples. In the meantime, your best bet is to install
and serve Kinetic locally.

INSTALLING
==========

Requirements
-------------
You will need Ruby 1.8.7 and Rails 3.0.5. We suggest that you get those using
    bash < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
    rvm install 1.8.7
    rvm --default use 1.8.7
    gem install rails

All of the javascript is written in coffee script, which you can install using
the instructions at http://jashkenas.github.com/coffee-script/#installation

Cloning the Repo:
-----------------
If you have git installed, you can run
    git clone git://github.com/rkstedman/kinetic.git
otherwise, you can download the repository manually.

Installing required gems
-------------------------
Go into the top level directory and run the following commands:
    gem install bundle # one time command
    bundle install # this will automatically install all of the needed gems

Compiling to javascript
-----------------------
cake build # use this to compile the coffee script files

cake watch # use this after you have compiled for the first time to build
           # continuously, when the .coffee files change

RUNNING LOCALLY
================
Make sure that you are connected to the internet so that the Echo Nest API requests will work.

Then go into the top level directory and run
    rails server

Then open a browser and visit "localhost:3000"