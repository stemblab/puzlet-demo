$blab.slider = (spec) -> new $blab.Slider spec

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
    
    $("#"+@container).append @outer
    
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
      slide: (e, ui) => @setVal(ui.value)
      change: (e, ui) =>  # Unused because responds to slide method
    
    #@setVal @init
    #console.log "VAL", @value
    
  initialize: -> @setVal @init
    
  setVal: (v) ->
    @textDiv.html @text(v)
    #@val v
    @value = v
    return unless $blab.widgets
    $blab.compileWidget()
#    widget = $blab.widgets[@id]
#    widget.val = v
#    $blab.compileWidget(widget)  # ZZZ reinstate after second compile
  
  getVal: -> @value
    
  # API
  set: (v) -> @container.slider("value", v)
