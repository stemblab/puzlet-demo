$blab.registerWidgets = ->
  
  precompile = {}
  
  for key, widget of $blab.widgets
    for file in widget.files
      p = precompile[file] ?= {preamble: "", postamble: ""}
      p.preamble += "#{widget.symbol} = $blab.widgets['#{key}'].val\n" if widget.type is "source"
      p.postamble += "\n$('##{key}').text(#{widget.symbol})" if widget.type is "sink"  # ZZZ Need to generalize
      
  $blab.precompile(precompile)


$blab.compileWidget = (widget) ->
  $blab.resources.find(file)?.compile() for file in widget.files 