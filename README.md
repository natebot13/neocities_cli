A command line interface for my dart [Neocities API](https://github.com/natebot13/neocities_dart).

Meant to be globally activated, by simply running:

`dart pub global activate neocities_cli`

Then start using it:

```
$ neocities
A dart command line interface for neocities.org

Usage: neocities <command> [arguments]

Global options:
-h, --help        Print this usage information.
-u, --username
-p, --password
-k, --key

Available commands:
  delete   Delete files from your site
  info     Show the info of a site
  key      Get the api key for your site
  list     List the files in your site
  rename   Rename a file
  upload   Upload files to your site

Run "neocities help <command>" for more information about a command.
```

```
$ neocities info example
{
  "sitename": "example",
  "views": 7758,
  "hits": 8674,
  "created_at": "Sat, 20 Jul 2013 09:33:19 ",
  "last_updated": "Sat, 13 Dec 2014 19:02:19 ",
  "domain": null,
  "tags": []
}
```

To use the authenticated API, either add your username and password to the command, or generate and use an API key.

```
$ neocities --key key1234neocities info
{
  "sitename": "yoursite",
  "views": 1337,
  "hits": 1337,
  "created_at": "...",
  "last_updated": "...",
  "domain": null,
  "tags": []
}
```