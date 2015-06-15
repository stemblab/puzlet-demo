$blab.newTable = (id, v) ->
  console.log "V", v
  widgets = $blab.widgets
  
  console.log "NEW TABLE - COUNT", $blab.widgetCount
  idSpecified = id
  unless idSpecified
    id = $blab.widgetCount
    $blab.widgetCount++
  
  unless widgets[id]
    
    code = """
    $blab.table
      id: "#{id}"
      headings: ["Column 1", "Column 2"]
    """
    
    #console.log "CODE", code
    #$coffee.evaluate(code)
    #$blab.resources.find("widgets.coffee").containers.fileNodes[0].setCode(code)
    #$blab.resources.find("widgets.coffee").containers.setEditorContent code
    #console.log "resource", 
    
    #console.log "widgets.coffee", resource
    
    if idSpecified
      resource = $blab.resources.find("widgets.coffee")
      resource.containers.fileNodes[0].editor.set(resource.content + "\n\n" + code)
      console.log "*** compile widgets.coffee"
      setTimeout (-> resource.compile()), 500
    else
      makeTable = ->
        $blab.table
          id: "#{id}"
          headings: ["Column 1", "Column 2"]
        
      setTimeout(makeTable, 700)
      
  widgets[id]?.setVal(v)
    
  #widgets[id]?.getVal() ? 5
  

$blab.table = (spec) ->
#  console.log "slider", $blab.widgets[spec.id]
  
  new $blab.Table spec

class $blab.Table
  
  constructor: (@spec) ->
    
    {@container, @id, @headings} = @spec
#    {@container, @prompt, @id, @init, @min, @max, @step, @text} = @spec
#    {@container, @prompt, @id, @init, @min, @max, @step, @text} = @spec
#    {@id, @init, @min, @max, @step, @val} = @spec
    
    @sliderContainer = $("#"+@id)
    if @sliderContainer.length
      #console.log "CONTAINER", @container, @container.slider()
      @sliderContainer.slider?("destroy")
      @outer = @sliderContainer.parent()
      #console.log "OUTER", @outer
      @outer?.remove()
    
    @outer = $ "<div>", class: "slider-container"
    #@sliderPrompt = $ "<div>", class: "slider-prompt"
    #@sliderPrompt.append @prompt
    #@outer.append @sliderPrompt  #@prompt+" "
    @sliderContainer = $ "<div>", class: "mvc-slider", id: @id
    @outer.append @sliderContainer
    #@textDiv = $ "<div>", class: "slider-text"
    #@outer.append(" ").append @textDiv
    
    $($blab.widgetContainer).append @outer
    #$(@container).append @outer
    
    #console.log "outer", $(@id.parent())
    
    #@container.append """
    #<div id="slider-container">
    ##{@prompt}
    #<div class="mvc-slider" id="@id"></div>
    #<div class="slider-text" id="freq-slider-text"></div>
    #"""
    # = $ "<div>", class: "slider-container"

    #<div id="slider-container">
    #Frequency:
    #<div class="mvc-slider" id="freq-slider"></div>
    #<div class="slider-text" id="freq-slider-text"></div>
    #</div>
    
    $blab.widgets[@id] = this
    
    #@container = $ @containerId

    #@slider?.destroy()
    #@container.empty()
    
    @table = $ "<table>" #, html: ""
  
    
    @sliderContainer.append @table
    
    #@setVal @init
    #console.log "VAL", @value
    
  initialize: -> #@setVal @init
    
  setVal: (v) ->
    @table.empty()
    tr = $ "<tr>"
    @table.append tr
    for h in @headings
      tr.append "<th>#{h}</th>"
    #console.log "v", v
    #return
    
    row = []
    #console.log "*****V", v
    for x, idx in v[0]
      #row.push [x, v[1][idx]]
      console.log idx, x, v[1][idx]
      tr = $ "<tr>"
      @table.append tr
      for i in [0...v.length] 
        tr.append "<td>"+v[i][idx]+"</td>"
        #tr.append "<td>"+v[1][idx]+"</td>"
      #tr.append "</tr>"
    #for c, col in v
    #  row[col] = []
    #  for x in v
    #    row[col].push x
      #for x in v
      #@table.append "<tr><td>"+x
    #@textDiv.html @text(v)
    #@val v
    @value = v
    #return unless $blab.widgets
    #$blab.compileWidget()
#    widget = $blab.widgets[@id]
#    widget.val = v
#    $blab.compileWidget(widget)  # ZZZ reinstate after second compile
  
  #getVal: -> @value
    
  # API
  #set: (v) -> @sliderContainer.slider("value", v)