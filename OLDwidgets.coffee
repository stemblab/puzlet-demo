# Widgets - frequency slider and output value
$blab.widgets =
  "freq-slider":
    type: "source"
    symbol: "f"
    files: ["foo.coffee"]
  "y0":
    type: "sink"
    symbol: "y0"
    files: ["foo.coffee"]  # Can have only one file for sink?

$blab.widgets["freq-slider"].slider = new $blab.Slider
  id: "freq-slider"
  min: 0.1
  max: 10
  step: 0.1
  init: 4.2
  val: (v) -> $("#freq-slider-text").html v+" Hz"
  
$blab.registerWidgets() #unless $blab.CoffeeResource.preCompileCode.length

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

