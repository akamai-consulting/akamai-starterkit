Putting all this together meant we had to stumble into quirks headaches and issues so you wouldn't have to.  Some of those learnings are being explicitly documented here so that problems we solved in-code are obvious for future generations 


## Parser for Edge Worker bundles is finicky
If you are building a tgz for edge workers know that the parser will error if the archive has any enclosing directory info wrapping the bundle.json and main.js.  You MUST run the command from inside the directory.
The following will work:
- `tar -czvf ../terraform/edge-worker-bundle.tgz *`
- `tar -czvf ../terraform/edge-worker-bundle.tgz bundle.json main.js`

However the following will NOT work:
- `tar -czvf filename2.tgz edge-worker/bundle.json edge-worker/main.js`
- `tar -czvf foo.tar.gz -C edge-worker .`

TLDR if you run `tar -tzvf foo.tar.gz` and see any leading `./` or other leading directories the edgeworker validator will fail.  

## Akamai API Key has expired
If your akamai api key has expired then you need to regenerate a new one and update it in your terraform configs.


## Rebuilding your DevContainer
So you have changed something in the local dev container or maybe you got an update from your upstream repository.  You can apply the changes to your local development environment by going to the VSCode command Palette and typing `> dev containers: Rebuild Container`.  Note in some cases I have seen it necessary to run `> dev containers: Rebuild Container Without Cache`

