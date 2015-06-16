Widget = $blab.Widget

class Slider extends Widget
  
  @handle: "slider"
  
  @initVal: 5
  
  @spec: (id) -> """
    id: "#{id}"
    min: 0, max: 10, step: 0.1, init: #{Slider.initVal}
    prompt: "Set value:"
    text: (v) -> v
  """
  
  @layoutPreamble:
    "slider = (spec) -> new $blab.Widgets.Slider(spec)"
    
  @computePreamble:
    "slider = (id) -> $blab.Widgets.Slider.compute(id)"
  
  @compute: (id) ->
    Widget.fetch(Slider, id)?.getVal() ? Slider.initVal
  
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
    
    @register @outer  # Superclass method
    
    @slider = @sliderContainer.slider
      #orientation: "vertical"
      range: "min"
      min: @min
      max: @max
      step: @step
      value: @init
      slide: (e, ui) =>
        @setVal(ui.value)
        @compute()  # Superclass method
      change: (e, ui) =>  # Unused because responds to slide method
    
  initialize: -> @setVal @init
    
  setVal: (v) ->
    @textDiv.html @text(v)
    @value = v
  
  getVal: -> @value
  

$blab.Widgets.Slider = Slider
