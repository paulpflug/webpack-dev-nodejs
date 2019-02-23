readConf = require("read-conf")
path = require("path")
try 
  webpack = require("webpack")
catch e
  
  entry = require.resolve("webpack", { paths: [path.join(process.cwd(), "node_modules")] })
  webpack = require(entry)

MemoryFS = require "memory-fs"

requireStr = require("require-from-string")

sourceMap = require "source-map"
oldStackTrace = Error.prepareStackTrace
module.exports = ({name}) =>

  mfs = new MemoryFS()
  first = true
  watcher = null
  {close} = await readConf 
    name: name or "webpack.config"
    watch: true
    folders: ["./build","./"]
    prop: "webpackConf"
    cancel: ({watcher}) =>
      new Promise (resolve) => watcher.close(resolve) if watcher?
    cb: (base) =>
      {webpackConf} = base
      webpackConf.mode = "development"
      webpackConf.devtool = "source-map"
      compiler = webpack webpackConf
      compiler.outputFileSystem = mfs
      watcher = compiler.watch webpackConf.watchOptions, (err, stats) =>
        unless first
          console.log "\n\x1b[7mWEBPACK-DEV-NODEJS - reloading\x1b[0m"
        first = false
        if err?
          console.log err.stack or err
          console.log err.details if err.details
        else
          info = stats.toJson()
          if stats.hasErrors()
            
            console.log(info.errors)
          else 
            out = info.outputPath
            ctx = stats.compilation.options.context
            getNewStackTrace = (filename) =>
              smc = await new sourceMap.SourceMapConsumer(mfs.readFileSync(filename+".map","utf-8"))
              return (error, stackTrace) =>
                errLines = stackTrace.map (callSite) =>
                  source = callSite.getFileName()
                  line = callSite.getLineNumber()
                  column = callSite.getColumnNumber()
                  if source == filename
                    org = smc.originalPositionFor line: line, column: column
                    if org.source?
                      org.source = org.source.replace("webpack:///webpack","webpack-generated").replace("webpack://",ctx) 
                  else
                    org = source: source, line: line, column: column
                  return "    at " + (callSite.getFunctionName() or "(anonymous)") + " (#{org.source}:#{org.line}:#{org.column})"
                desc = oldStackTrace(error, stackTrace)
                errLines.unshift desc.slice 0, desc.indexOf("\n")
                return errLines.join("\n")
            for asset in info.assets
              filename = path.resolve(out,asset.name)
              if filename.match /\.js$/
                try
                  requireStr mfs.readFileSync(filename,"utf-8"), filename
                catch e
                  Error.prepareStackTrace = await getNewStackTrace(filename)
                  console.error e.stack
                  Error.prepareStackTrace = oldStackTrace
      return null
