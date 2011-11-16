class Metro.Command.Server
  constructor: (argv) ->
    @program = program = require('commander')
    
    program
      .option('-e, --environment [value]', 'output parsed comments for debugging')
      .option('-p, --port <n>', 'port for the application')
      .parse(argv)
  
  run: ->
    program     = @program
    Metro.env   = program.environment || "development"
    Metro.port  = program.port      = if program.port then parseInt(program.port) else (process.env.PORT || 1597)
    
    Metro.Application.initialize()
    Metro.Application.run()
  
module.exports = Metro.Command.Server
