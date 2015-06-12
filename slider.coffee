class $blab.Slider
  
  constructor: (@spec) ->
    
    {@id, @init, @min, @max, @step, @val} = @spec
    
    @container = $ "#"+@id
    @container.empty()
    
    @container.slider
      #orientation: "vertical"
      range: "min"
      min: @min
      max: @max
      step: @step
      value: @init
      slide: (e, ui) => @setVal(ui.value)
      change: (e, ui) =>  # Unused because responds to slide method
    
    @setVal @init
    
  setVal: (v) ->
    @val v
    return unless $blab.widgets
    widget = $blab.widgets[@id]
    widget.val = v
    $blab.compileWidget(widget)  # ZZZ reinstate after second compile
    
  # API
  set: (v) -> @container.slider("value", v)
