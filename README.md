# Pokemon application

This is the pokemon's battles application developed with
[*Ruby on Rails*]
<!-- Learn Web Development with Rails*](https://www.railstutorial.org/) -->
(6th Edition)
by [Yulio Aldi Widargo](https://www.michaelhartl.com/).

## Getting started

To get started with the app, clone the repo and then install the needed gems:

```
$ gem install bundler -v 2.2.17
$ bundle _2.2.17_ config set --local without 'production'
$ bundle _2.2.17_ install
```

Next, migrate the database:

```
$ rails db:migrate
```

Finally, run the test suite to verify that everything is working correctly:

```
$ rails test
```

If the test suite passes, you'll be ready to run the app in a local server:

```
$ rails server
```