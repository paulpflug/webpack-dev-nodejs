#!/usr/bin/env node
var args, i, len, options, arg
options = {}
args = process.argv.slice(2)
for (i = 0, len = args.length; i < len; i++) {
  arg = args[i]
  if (arg[0] == "-") {
    switch (arg) {
      case '-c':
      case '--config':
        options.name = args[++i]
        break
      case '-s':
      case '--stack-limit':
        options.stackLimit = Number(args[++i])
        break
      case '-h':
      case '--help':
        console.log('usage: webpack-dev-nodejs <options> (alternative entry)')
        console.log('')
        console.log('options:')
        console.log('-c, --config (config file)  alternative webpack.config')
        console.log('-s, --stack-limit (lines)   limit the stack-trace to (lines)')
        console.log('')
        console.log('config file defaults to "webpack.config.[js|json|coffee|ts]"')
        console.log('in "build/" and "/"')
        console.log('alternative entry will replace the entry option in webpack.config')
        console.log('example:')
        console.log('webpack-dev-nodejs dev/env.js')
        process.exit()
        break
    }
  } else {
    options.entry = arg
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