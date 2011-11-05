fs     = require 'fs'
path   = require 'path'
{exec} = require 'child_process'
util   = require 'util'

# ANSI Terminal Colors.
bold  = '\033[0;1m'
red   = '\033[0;31m'
green = '\033[0;32m'
reset = '\033[0m'

src      = 'coffee-scripts'
dist     = 'public/javascripts'

targets =
  'kinetic' : [
    'main_functions',
    'animations',
    'echonest-functions'
  ]

task "build", "Build all targets", ->
  for target, srcFiles of targets
    build target, srcFiles

for target, srcFiles of targets
  task "build:#{target}", "Build #{target}", ->
    build target, srcFiles

watchDir = (targets, dir, action) ->
  util.log "Watching for changes in #{dir}"

  for target, srcFiles of targets
    unless isNaN(target)
      srcFiles = [srcFiles] #hacking in nature :) - pls refactor me

    for file in srcFiles
      fs.watchFile "#{dir}/#{file}.coffee", (curr, prev) ->
        if +curr.mtime isnt +prev.mtime
          util.log "Spotted change in #{dir}/#{file}.coffee"
          invoke action

option '-t', '--tests', 'also watch test files for changes'
task 'watch', "Watch #{src} directory and rebuild on notification of any changes", (options) ->
  watchDir targets, src, 'build'
  if options.tests then watchDir getTestTargets(), 'spec', 'test:build'

# Run a CoffeeScript through our node/coffee interpreter.
run = (args) ->
  proc =         spawn 'bin/coffee', args
  proc.stderr.on 'data', (buffer) -> console.log buffer.toString()
  proc.on        'exit', (status) -> process.exit(1) if status != 0

# Log a message with a color.
log = (message, color, explanation) ->
  console.log color + message + reset + ' ' + (explanation or '')

build = (target, srcFiles, srcDir = src) ->
  msg = "* #{target} *"
  line = ('*' for c in [1..4+target.length]).join("")

  util.log line
  util.log msg
  util.log line

  targetCoffee = "#{dist}/#{target}.coffee"
  targetJS     = "#{dist}/#{target}.js"
  opts = "--bare --output #{dist} --compile #{targetCoffee}"

  util.log "Building #{targetJS}"
  console.log srcFiles
  appContents = new Array remaining = srcFiles.length
  util.log "Concatenating #{srcFiles.length} files to #{targetJS}"

  for file, index in srcFiles then do (file, index) ->
      fs.readFile "#{srcDir}/#{file}.coffee"
                , 'utf8'
                , (err, fileContents) ->
          util.log err if err

          appContents[index] = fileContents
          util.log "[#{index + 1}] #{file}.coffee"
          process() if --remaining is 0

  process = ->
    fs.writeFile targetCoffee
               , appContents.join('\n\n')
               , 'utf8'
               , (err) ->
        util.log err if err

    exec "coffee #{opts}", (err, stdout, stderr) ->
      util.log err if err
      message = "Compiled #{targetJS}"
      util.log message
      fs.unlink targetCoffee, (err) -> util.log err if err

  util.log "\n\n"
