## Figs
[![Gem Version](https://badge.fury.io/rb/figs.png)](http://badge.fury.io/rb/figs)
[![Build Status](https://travis-ci.org/NYULibraries/figs.png?branch=master)](https://travis-ci.org/NYULibraries/figs)
[![Code Climate](https://codeclimate.com/github/NYULibraries/figs.png)](https://codeclimate.com/github/NYULibraries/figs)
[![Coverage Status](https://coveralls.io/repos/NYULibraries/figs/badge.png)](https://coveralls.io/r/NYULibraries/figs)
[![Dependency Status](https://gemnasium.com/NYULibraries/figs.png)](https://gemnasium.com/NYULibraries/figs)

Railsless, herokuless, configurable, barebones figaro with a knack of using git repos for configuration files.

Simple app configuration

## What is this for?

Figs is for configuring apps, especially open source apps, much like Figaro. Whereas Figaro is great in that it works seamlessly with Rails 3 and 4, Figs also works with non Rails apps providing the same great ENV support, although in a slightly different way.

However, much like Figaro, Figs allows you to Open Source your app while keeping private things private.

## How does it work?

Figs is identical to Figaro in every way barring a few key differences. It uses `ENV` to store any string key-value pairs. However, sometimes its necessary to store more complex objects, such as arrays. `ENV` doesn't allow for objects, so we provide a souped-up wrapper called `Figs::Env` for this purpose! All key-value pairs are converted to strings and stored in `ENV`, but non-converted pairs can be accessed anytime using  the Figs.env method.

## Example.

Add Figs to your Gemfile then `bundle` command to install it:

```ruby
gem "figs"
```

Then you'll have to figsify your project so Figs can find where you keep your environment variables. If a location is not specified, a template will be created in the root directory as application.yml.

```
figsify
```
or

```
figsify config/settings1.yml config/settings2.yml config/settings3.yml
```
And finally 

```
figsify git@github.com:GITHUBNAME/REPONAME.git filename1.yml config/filename2.yml
```

Now Figs will know where to find your environment vars!

Then in ruby

```ruby
Figs.load()

Settings.secret = ENV["SECRET"]
# OR
Settings.servers = Figs.env["server"]
```

## Thank you!

Figs was made possible by the kind folks at [Figaro](https://github.com/laserlemon/figaro)
