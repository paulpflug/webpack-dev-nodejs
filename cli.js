#!/usr/bin/env node
var args, i, len, options, arg
options = {}
args = process.argv.slice(2)
for (i = 0, len = args.length; i < len; i++) {
  arg = args[i]
  if (arg[0] == "-") {
    switch (arg) {
      case '-h':
      case '--help':
        console.log('usage: webpack-dev-nodejs (config file)')
        console.log('')
        console.log('config file is optional and defaults to "webpack.config.[js|json|coffee|ts]"')
        console.log('in "build/" and "/"')
        process.exit()
        break
    }
  } else {
    options.name = arg
  }
}
var start
try {
  require("coffeescript/register")
  start = require("./src/webpack-dev-nodejs.coffee")
} catch (e) {
  if (e.code != "MODULE_NOT_FOUND") {
    console.log(e)
  } else {
    console.log(e)
    start = require("./webpack-dev-nodejs.js")
  }
}
start(options)