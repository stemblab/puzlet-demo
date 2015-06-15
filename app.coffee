$blab.widgets = widgets = {}

$blab.registered ?= false

$blab.widgetCount = 0

layout = {}
$blab.layout = (l) ->
  layout = l
  

doLayout = ->
  w = $("#widgets")
  w.empty()
  for label, row of layout
    console.log label, row
    r = $ "<div>", id: label
    w.append r
    for col in row
      c = $ "<div>", class: col
      r.append c
    r.append($ "<div>", class: "clear")

$(document).on "preCompileCoffee", (evt, data) ->
  console.log "preCompileCoffee", data.resource.url 
  $blab.widgetCount = 0
  if data.resource.url is "widgets.coffee"
    w = $("#widgets")
    w.empty()
    doLayout()
    
    #r = $ "<div>", id: "row1"
    #w.append r
    #r.append($ "<div>", class: "left").append($ "<div>", class: "right")
    $blab.widgets = widgets = {}

$(document).on "compiledCoffeeScript", (evt, data) ->
  #console.log "+++Compiled", data
  $blab.initWidgets() if data.url is "widgets.coffee"

$blab.initWidgets = ->
  # Ignore this code - it will be replaced
  
  console.log "LAYOUT", layout
  #doLayout()
  
  $blab.widgets['y0'] = $("#y0") # ZZZ temp
  $blab.widgetPrecode()
  for key, widget in $blab.widgets
    widget?.initialize() unless key is 'y0'
    #$blab.widgets['z-slider']?.initialize()
  
  $blab.compileWidget()


$blab.widgetPrecode = ->
  
  #return if $blab.registered
  
  precompile = {}
  
  precompile["foo.coffee"] =
    preamble: "slider = (id) -> $blab.newSlider(id)\ntable = (id, v...) -> $blab.newTable(id, v)\n"
#    preamble: "slider = (id) -> $blab.newSlider(id)\ntable = (id, v) ->\n  $('#'+id).text(v)\n  null\n"
    postamble: ""
  
  $blab.precompile(precompile)
  
  $blab.registered = true
  
#$blab.widgetPrecode()

$blab.compileWidget = (widget) ->
  
  #console.log "**** compile widget"
  
  # TEMP
  resource = $blab.resources.find("foo.coffee")
  resource?.compile()
  return
  
  for file in widget.files
    resource = $blab.resources.find(file)
    #console.log "------------- compileWidget", file, resource
    resource?.compile()
  #$.event.trigger("preCompileCoffee", {resource: $blab.resources.find("widgets.coffee")})  # ZZZ hack

#---------------------------------------  
# ZZZ to delete/move
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