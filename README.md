# webpack-dev-nodejs

Run webpacked nodejs apps directly from shell in-memory, with auto-reloading, clever cache invalidation and source-maps.

## Install

```sh
npm install --save-dev webpack-dev-nodejs webpack-node-externals
```
usage of [webpack-node-externals](https://github.com/liady/webpack-node-externals) is recommended, but not required.

## Usage
direct:
```
usage: webpack-dev-nodejs <options> (alternative entry)

options:
-c, --config (config file)  alternative webpack.config
-s, --stack-limit (lines)   limit the stack-trace to (lines)

config file defaults to "webpack.config.[js|json|coffee|ts]"
in "build/" and "/"
alternative entry will replace the entry option in webpack.config
example:
webpack-dev-nodejs dev/env.js
```
via npm
```json
# package.json
{
  "scripts": {
    "watch": "webpack-dev-nodejs --stack-limit 5 ./dev/env.js"
  }
}
```
run: 'npm run watch'

## minimal webpack.config.js

```js
// ./webpack.config.js
var nodeExternals = require('webpack-node-externals');
module.exports = {
  entry: {
    index: "./src/index.js"
  },
  output: {
    filename: "bundle.js",
    path: __dirname
  },
  target: 'node', // in order to ignore built-in modules like path, fs, etc.
  externals: [nodeExternals()] // in order to ignore all modules in node_modules folder
}
```



## License
Copyright (c) 2019 Paul Pflugradt
Licensed under the MIT license.