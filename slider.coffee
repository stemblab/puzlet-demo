$blab.newSlider = (id) ->
  widgets = $blab.widgets
  
  console.log "NEW SLIDER - COUNT", $blab.widgetCount
  idSpecified = id
  unless idSpecified
    id = $blab.widgetCount
    $blab.widgetCount++
  
  unless widgets[id]
    
    code = """
    $blab.slider
      id: "#{id}"
      min: 0
      max: 10
      step: 0.1
      init: 5
      container: "#row1 .left"
      prompt: "Set value:"
      text: (v) -> v
    """
    
    console.log "CODE", code
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
      makeSlider = ->
        $blab.slider
          id: "#{id}"
          min: 0
          max: 10
          step: 0.1
          init: 5
          container: "#row1 .left"
          prompt: "Set value:"
          text: (v) -> v
        
      setTimeout(makeSlider, 700)
    
  widgets[id]?.getVal() ? 5
  

$blab.slider = (spec) ->
#  console.log "slider", $blab.widgets[spec.id]
  
  new $blab.Slider spec

class $blab.Slider
  
  constructor: (@spec) ->
    
    {@container, @prompt, @id, @init, @min, @max, @step, @text} = @spec
#    {@id, @init, @min, @max, @step, @val} = @spec
    
    @sliderContainer = $("#"+@id)
    if @sliderContainer.length
      #console.log "CONTAINER", @container, @container.slider()
      @sliderContainer.slider?("destroy")
      @outer = @sliderContainer.parent()
      #console.log "OUTER", @outer
      @outer?.remove()
    
    @outer = $ "<div>", class: "slider-container"
    @outer.append @prompt+" "
    @sliderContainer = $ "<div>", class: "mvc-slider", id: @id
    @outer.append @sliderContainer
    @textDiv = $ "<div>", class: "slider-text"
    @outer.append(" ").append @textDiv
    
    $(@container).append @outer
    
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
    
    @slider = @sliderContainer.slider
      #orientation: "vertical"
      #id: @id
      range: "min"
      min: @min
      max: @max
      step: @step
      value: @init
      slide: (e, ui) =>
        @setVal(ui.value)
        $blab.compileWidget()
      change: (e, ui) =>  # Unused because responds to slide method
    
    #@setVal @init
    #console.log "VAL", @value
    
  initialize: -> @setVal @init
    
  setVal: (v) ->
    @textDiv.html @text(v)
    #@val v
    @value = v
    return unless $blab.widgets
    #$blab.compileWidget()
#    widget = $blab.widgets[@id]
#    widget.val = v
#    $blab.compileWidget(widget)  # ZZZ reinstate after second compile
  
  getVal: -> @value
    
  # API
  set: (v) -> @sliderContainer.slider("value", v)
