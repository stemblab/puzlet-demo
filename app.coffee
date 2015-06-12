$blab.widgets = widgets = {}

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


$blab.initWidgets = ->
  # Ignore this code - it will be replaced
  $blab.widgets['y0'] = $("#y0") # ZZZ temp
  $blab.widgetPrecode()
  $blab.widgets['freq-slider']?.initialize()


$blab.widgetPrecode = ->
  
  #return if $blab.registered
  
  precompile = {}
  
  precompile["foo.coffee"] =
    preamble: "slider = (id) -> $blab.newSlider(id)\ntable = (id, v) ->\n  $('#'+id).text(v)\n  null\n"
    postamble: ""
  
  $blab.precompile(precompile)
  
  $blab.registered = true
  
#$blab.widgetPrecode()

$blab.compileWidget = (widget) ->
  
  # TEMP
  resource = $blab.resources.find("foo.coffee")
  resource?.compile()
  return
  
  for file in widget.files
    resource = $blab.resources.find(file)
    #console.log "------------- compileWidget", file, resource
    resource?.compile()
  #$.event.trigger("preCompileCoffee", {resource: $blab.resources.find("widgets.coffee")})  # ZZZ hack