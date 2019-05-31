{resolve} = require "path"

module.exports =
  entry:
    index: "./dev/entry.js"
  output:
    filename: "[name].js"
    path: resolve("./dev")
  