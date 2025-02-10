Add the base collection folder in zotero configurations.

In zotero 7 install zotmoov extension. Configure let the default subfolder naming `%c` which means path of the collection (in zotmoov). In zotero, the renaming rule which I use is:

```
{{ authors case="lower" "join="_"  suffix="_"}}{{ year suffix="_" }}{{ title truncate="100"  case="snake"}}
```

I also added the plugin `Better BibTex`, no special config has been done, but I have selected the directory for the continous export. To do the continous export, export as normal, but select the better bibtex biblatex option.

