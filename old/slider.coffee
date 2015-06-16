#!vanilla

Widgets = $blab.Widgets

class Slider
  
  @handle: "slider"
  @api: "$blab.Widgets.Registry.Slider"
  
  @initVal: 5
  
  @initSpec: (id) -> """
    id: "#{id}"
    min: 0, max: 10, step: 0.1, init: #{Slider.initVal}
    prompt: "#{id}:"
    text: (v) -> v
  """
  
  # ZZZ can be determined in Widgets?
  @layoutPreamble:
    "#{@handle} = (spec) -> new #{@api}(spec)"
    
  @computePreamble:
    "#{@handle} = (id) -> #{@api}.compute(id)"
  
  @compute: (id) ->
    Widgets.fetch(Slider, id)?.getVal() ? Slider.initVal
  
  constructor: (@spec) ->
    
    {@id, @min, @max, @step, @init, @prompt, @text} = @spec
    
    @sliderContainer = $("#"+@id)
    if @sliderContainer.length
      @sliderContainer.slider?("destroy")
      @outer = @sliderContainer.parent()
      @outer?.remove()
    
    @outer = $ "<div>", class: "slider-container"
    @sliderPrompt = $ "<div>", class: "slider-prompt"
    @sliderPrompt.append @prompt
    @outer.append @sliderPrompt
    @sliderContainer = $ "<div>", class: "mvc-slider", id: @id
    @outer.append @sliderContainer
    @textDiv = $ "<div>", class: "slider-text"
    @outer.append(" ").append @textDiv
    
    Widgets.append @id, this, @outer  # not now: Superclass method
    
    @slider = @sliderContainer.slider
      #orientation: "vertical"
      range: "min"
      min: @min
      max: @max
      step: @step
      value: @init
      slide: (e, ui) =>
        @setVal(ui.value)
        Widgets.compute()  # Superclass method
      change: (e, ui) =>  # Unused because responds to slide method
    
  initialize: -> @setVal @init
    
  setVal: (v) ->
    @textDiv.html @text(v)
    @value = v
  
  getVal: -> @value
  

Widgets.register Slider
