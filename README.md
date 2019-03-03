# rakutentech.github.io

TODO: add a description of the repository here

## To install the development environment

The only prerequisite is to have Node.js installed. You can download it from https://nodejs.org/en/download/

After that, clone the repository with

```
git clone ...
```

then move into the project folder and install the dependencies:

```
cd rakutentech.github.io
npm install
```

now you are ready to run the development server with

```
cmd/start
```

this will download other dependencies, start a server and open a new page in the browser.
Now you can start your favorite editor and start changing the application. Every time you save the window in the browser will automatically refresh.

When you are happy with the result you can just commit your changes in the remote repository through a pull request. As soon as the changes are merged into the master branch they will be available online.

The main fails that you may need to edit are in the src folder. If you want to modify the footer, for example, edit the file ViewFooter.elm. For the header: ViewHeader.elm, etc.

## Optimizer (optional step)

If you prefer to minify the Javascript file, remember to run this command before committing your modifications:

```
cmd/optimize
```

## Debug mode

If you are debugging the application you may compile it in debug mode using the command

```
cmd/start-debug
```

After running this command, remember to run either `cmd/start` or `cmd/optimize` before submitting your modifications to production.

## How the app works

The app automatically get the list of the repositories from Github. It also has a list of hard coded repositories in the file `Repos.elm`. Then it concatenated the two list together and show them in the page.

## Files details

### Folder cmd

Contain all the commands that can be executed

### Folder docs

Contains all static file that are needed for the application to run. This folder is the one that automatically picked up github when the project is published

### Folder

### Folder scr

* Conf.elm : Configuration values such as colors and sizes
* Repos.elm : A list of repositories that are not under the `rakutentech` github account
* ViewBody.elm : This file contain the tagline that appear at the top of the page and the paragraph underneath
* ViewFooter.elm : The footer
* ViewHeader.elm : The header
* ViewRepo.elm : This contain how the repo data is displayed in each card
* Internal (folder) : This folder contain the rest of the application that usually don't need to be modified unless new feature need to be added to the site
