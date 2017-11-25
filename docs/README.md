# XHentai

A simple downloading and reading toolkit for local network.

Based on Ruby, XHentai should include two main modules.

## Downloader

A downloader based on Machanize with a plugin system, which allows users and developers create their own downloader for different websites.

The plugins should be chosen automatically with the hostname or pattern of URLs.

On the other hand, the downloader should save the meta-information and progress for each task, so that they could be recovered if they were interrupted accidently.

The progress should be stored in the database. However, the downloaded files should be standalone and NOT relay on any database. In the meta-information file, the order of images should be offered, and other information like tags and authors should also be stored.



# TODO


TODO:

* Downloader Server & Client
* Progress management
* Database
* Recover

## Viewer

A simple server based on Sinatra supports viewing, searching, sorting, multi-user basic access authentication and task submission.

### Frontend

The frontend of viewer should be a Single Page Application based on React or Vue, including at least a gallery page, a viewer page and a searching page.

TODO:

* Night Mode
* Friendly UI for touch screens
* Switching pages with keyboard and single hand(for both left and right hand)

### Backend

