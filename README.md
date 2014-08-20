# media-frontend

media.ccc.de webfrontend

## Install

### Ruby Version

ruby 2.1

### Instructions

Install required ruby packages with bundler:

    gem install bundler
    bundle install


Create config file

    cp nanoc.yaml.example nanoc.yaml


### Database Creation

Import a database dump

    zcat testdata.sql.gz | sqlite3 development.sqlite3

## Nanoc

[Nanoc](http://nanoc.ws) is a static site generator

### Compile static pages

    nanoc compile

### Start a webserver to view pages in a browser

    nanoc view

### Watch output directory for changes    

   guard

# JRuby

export JRUBY_OPTS="--2.0 -J-Xmn512m -J-Xms2048m -J-Xmx2048m -J-server"


~/.jrubyrc

  compat.version=2.0
