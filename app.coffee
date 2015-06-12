$blab.registered ?= false

$blab.OLD_registerWidgets = ->
  
  return if $blab.registered
  
  precompile = {}
  
  for key, widget of $blab.widgets
    for file in widget.files
      p = precompile[file] ?= {preamble: "", postamble: ""}
      p.preamble += "#{widget.symbol} = $blab.widgets['#{key}'].val\n" if widget.type is "source"
      p.postamble += "\n$('##{key}').text(#{widget.symbol})" if widget.type is "sink"  # ZZZ Need to generalize
      
  $blab.precompile(precompile)
  
  $blab.registered = true


$blab.registerWidgets = ->
  
  return if $blab.registered
  
  precompile = {}
  
  precompile["foo.coffee"] =
    preamble: "slider = (id) -> $blab.widgets[id].val\ntable = (id, v) -> $('#y0').text(v)\n"
    postamble: ""
  
  $blab.precompile(precompile)
  
  $blab.registered = true

$blab.compileWidget = (widget) ->
  
  for file in widget.files
    resource = $blab.resources.find(file)
    #console.log "------------- compileWidget", file, resource
    resource?.compile()
  #$.event.trigger("preCompileCoffee", {resource: $blab.resources.find("widgets.coffee")})  # ZZZ hack