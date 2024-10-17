Add the base collection folder in zotero configurations.

In zotero 7 install zotmoov extension. Configure let the default subfolder naming `%c` which means path of the collection. In zotero, the renaming rule which I use is:

```
{{ authors case="lower" "join="_"  suffix="_"}}{{ year suffix="_" }}{{ title truncate="100"  case="snake"}}
```

