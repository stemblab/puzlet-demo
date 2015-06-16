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


class Table
  
  @handle: "table"
  @api: "$blab.Widgets.Registry.Table"
  
  @initSpec: (id) -> """
    id: "#{id}"
    headings: ["Column 1", "Column 2"]
    widths: ["100px", "100px"]
  """
  
  @layoutPreamble: "#{@handle} = (spec) -> new #{@api}(spec)"
  
  @computePreamble: "#{@handle} = (id, v...) ->\n  #{@api}.compute(id, v)\n  null"
  
  @compute: (id, v) ->
    Widgets.fetch(Table, id, v...)?.setVal(v)
  
  constructor: (@spec) ->
    
    {@id, @headings, @widths} = @spec
    
    @table = $("#"+@id)
    @table.remove() if @table.length
    @table = $ "<table>", id: @id, class: "widget"
    
    Widgets.append @id, this, @table
    
  initialize: -> #@setVal @init
    
  setVal: (v) ->
    @table.empty()
    tr = $ "<tr>"
    @table.append tr
    for h, idx in @headings
      w = @widths[idx]
      tr.append "<th width='#{w}'>#{h}</th>"
    
    row = []
    for x, idx in v[0]
      tr = $ "<tr>"
      @table.append tr
      for i in [0...v.length] 
        tr.append "<td>"+@format(v[i][idx])+"</td>"
    @value = v
    
  format: (x) ->
    Math.round(x*10000)/10000


class Plot
  
  @handle: "plot"
  @api: "$blab.Widgets.Registry.Plot"
  
  @initSpec: (id) -> """
    id: "#{id}"
    width: "300px", height: "200px"
  """
  
  @layoutPreamble: "#{@handle} = (spec) -> new #{@api}(spec)"
  
  @computePreamble: "#{@handle} = (id, v...) ->\n  #{@api}.compute(id, v)\n  null"
  
  @compute: (id, v) ->
    Widgets.fetch(Plot, id, v...)?.setVal(v)
  
  constructor: (@spec) ->
    
    {@id, @width, @height} = @spec
    
    @plot = $("#"+@id)
    @plot.remove() if @plot.length
    @plot = $ "<div>",
      id: @id
      css:
        width: @width
        height: @height
    
    Widgets.append @id, this, @plot
    
  initialize: -> #@setVal @init
    
  setVal: (v) ->
    @plot.empty()
    @value = v
    #@plot.text v
    
    params = {}
    params.series ?= {color: "#55f"}
    #console.log "****** plot v", v
    x = v[0]
    y = v[1]
    $.plot @plot, [numeric.transpose([x, y])], params


Widgets.register [Slider, Table, Plot]

