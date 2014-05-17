# ember-cli-rails

A rails template and build script for working with [ember-cli](https://github.com/stefanpenner/ember-cli)
and deploying with a rails api / backend. The goal is to allow ember-cli to be 
in charge of building and testing your ember app, and rails to be in charge of 
building and testing your rails app.


## Dependencies

You will need the usual dev setup ruby, rails, bundler, node && npm. Once you
have those, you will also need `bower` and `ember-cli`

install `bower` via npm

```bash
$ npm install -g bower
```

install `ember-cli` via npm

```bash
$ npm install -g ember-cli
```

## Usage

clone the repo

```bash
$ git clone git@github.com:knomedia/ember-cli-rails.git
```

Assuming you are in the same directory as the `ember-cli-rails` repo, create a
new rails app like:

```bash
$ rails new app -m ember-cli-rails/template.rb
```

If you are in another location, change the path to the template file as needed.

You now have a rails project with an ember-cli project within it.

The template will set a catch-all rails route that serves up the ember app.
**You'll need to update your ember app config to set `location: 'hash'` manually
for this to work.** As you add api endpoints to rails be sure to place them
before the catch all route.

## Daily development

To work on the project, cd into the project root and:

```bash
$ bin/rails s
```

In another tab cd into your ember app (it'll be inside the rails root and 
labled with your app-name-ember). From within the ember-app directory run the
development ember server

```bash
$ ember serve --proxy http://localhost:3000
```

This will proxy api calls to your rails backend. For more information see the 
[ember-cli docs)](http://iamstef.net/ember-cli/)


## Deployment

From time to time, or whenever time to deploy, cd to your rails root and run:

```bash
$ ./bin/build.sh
```

This will utilize `ember-cli` to build your ember app, and copy files over to 
your rails `public/` directory.
