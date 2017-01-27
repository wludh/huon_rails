[![Build Status](https://travis-ci.org/wludh/huon_rails.svg?branch=master)](https://travis-ci.org/wludh/huon_rails)

# README

The Huon project is a Ruby on Rails app currently hosted on Heroku. The following readme will set a new contributor up for working on the project and walk through the repository's contents.

You will also want to examine the [technical report for the project](tech-report.md) to get a sense of how all the various technologies associated with the application fit together.

## Installation and Setup

Note: the following instructions follow procedures for Mac OS. Get in touch if trying to install for Windows, which will have slightly different steps.

First, make a copy of the app and change into the app's project folder:

```bash
$ git clone https://github.com/wludh/huon_rails.git
$ cd huon_rails
```

To run the app locally you will first need to install rails via [RVM](https://rvm.io/). Once you follow the installation steps for rails, install the ruby version needed for the project. Then install dependencies from the gemfile, which will install Rails as well.

```bash
$ rvm install 2.2.3
$ rvm use 2.2.3
$ bundle install
```

Python can be installed via [homebrew](http://brew.sh/). You might have to install some dependencies, which can be installed via pip. You should only need to install pyzotero:

```bash
$ brew install python
$ pip2 install pyzotero
```

## Updating and Deploying to Staging Server

To run the app locally:

```bash
$ rails s
```

This will make the site viewable at localhost:3000/

Once you have the project, you'll be making changes to files. But that's just part of the process - we employ version control with GitHub to make sure that things are organized and documented for worst-case scenarios. To archive your changes in our GitHub repository, first edit and save your files. Then the process is pretty straightforward:

```bash
$ git add .
$ git commit -m 'a message that describes what I did'
$ git push origin master
```

This will update the contents of the GitHub repository to match your most recent changes. Each time you sit down to work, though, you will also need to make sure that you have the most recent version of the materials:

```bash
$ git pull
```

Sometimes things go wrong, and don't hesitate to get in touch if you have questions.

At present, the site consists of a staging server hosted on Heroku. Deploying to Heroku is as easy as treating Heroku as a git remote and pushing to it after going through the standard git workflow. First make a change, and then upload your changes to the server like so:

```bash
$ git add .
$ git commit -m 'a message that describes what I did'
$ git push heroku master
```

This assumes that you have a remote named 'heroku' that points to the staging site that lives on heroku. If you have not added it, you can do so:

```bash
$ git remote add heroku https://git.heroku.com/huon-rails.git
```

If you have not been added as a contributor to the heroku remote, you will need to get in touch with Brandon at walshb [at] wlu [dot] edu to get added. You will also need to install the [Heroku Command Line Interface](https://devcenter.heroku.com/articles/heroku-cli).

## Testing

The project incorporates a testing environment to ensure that it continues to function as we work. To run the test suite and make sure everything is running as expected:

```bash
$ rspec spec
```
Though keep in mind that this only checks to make sure that the current tests work as they are written as of September 26, 2016. So if new features are added that are not covered by the tests, things could quietly break and the tests would not tell you.

/spec contains the tests written for the project that ensure updates haven't broken any components. Testing with Rails is a bit complicated and likely out of the purview of someone who is just coming to the project for the first time. We will try to have test coverage up to date by the time is completed so that you don't need to any more, but any signifcant new features will need to have associated tests so that they can be integrated into the workflow. Until then, you can just run the test suite to make sure everything works.

## Zotero

Zotero bibliography is rendered from a python 2 script. Longterm it should be refactored in as part of the rails app itself (would enable you to update without having to run from the command line). But as is, it can be run from the base of the application's directory as a python 2 script:

```$ python zot_bib_web/zot.py```

Running this command will pull down the zotero bibliography and regenerate the HTML necessary for it. Also includes COINs metadata. They get dumped into a partial at app/views/shared/_zot_bibliography.html.erb. This partial gets included in app/views/pages/bibliography.html.erb.

/zot_bib_web contains the modified Python package that uses the Zotero API to draw in and collect the materials for the bibliography page. You won't need to edit these files unless you want to change how the bibliography page gets constructed or how the data collection works.

## Other Notable Files
Rails stores different elements of your code in different places to streamline the development process. The meat of your Rails project lives in the /app folder. This contains the logic for your project, the views that create the individual pages of your site, and the database structuring if you have one associated with your project (we do not).

### Assets
* /app/assets/images - contains all images used.
* /app/assets/javascripts - contains all javascript used on the site
    * /app/assets/javascripts/sitewide - contains the javascript file for the browse page.
* /app/assets/stylesheets - contains all stylesheets used. app.css is imported last, so it should override anything you don't want from the others.

### Logic
* /app/controllers/pages_controller.rb -
The master file for all the logic underlying the site and its pages. Each page is routed to and through a particular method here. So you will copy the methods at the bottom if you need to add new pages. Most importantly, this is where the various pieces of the parser are assembled. They are all explicitly declared as helper methods, meaning that they can be accessed from views as embedded ruby.

### Views
The site (and Rails more generally) generates by combining a number of pieces or **partials** of files located in app/views - so you'll need to know where the various pieces are to adjust the piece of the whole you're looking at. Much of rails consists of just knowing where to look to modify the particular piece of the site that you're interested in. So when going to a page on our app, Rails looks for the controller method and then loads up the associated view using the defined logic.
* /app/views/layouts - This folder contains the footer, nav bar, and reading interface templates that will be filled in with page-specific content when you load a page.
* /app/views/pages - contains the individual manuscript pages, the hell scene markup, the bibliography, and the homepage.
* /app/views/shared - contains the pieces of the bibliography page that get loaded into the shell more generally. These pieces are overwritten everytime you run zot.py to update them from the zotero collection.
* /config contains all of the configuration settings for the app more generally, but, in general, you shouldn't need to adjust these.
* /lib/assets - contains all of the TEI files for both the manuscripts and their associated notes. Any changes you make here will be respected elsewhere on other pages, as the parser loads the TEI files from this folder. So any edits to the TEI in the future will be made here.
