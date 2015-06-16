class Widgets
  
  filename: "widgets.coffee"  # should be layout.coffee
  
  constructor: (@layout, @computation) ->  # ZZZ pass render?
    
    @widgets = {}
    @count = 0
    
    $(document).on "preCompileCoffee", (evt, data) =>
      url = data.resource.url
      console.log "preCompileCoffee", url 
      @count = 0  # ZZZ Bug?  only for foo.coffee or widgets.coffee
      return unless url is @filename
      @layout.render()
      @precode()
      @widgets = {}
    
    $(document).on "compiledCoffeeScript", (evt, data) =>
      return unless data.url is @filename
      widget?.initialize?() for key, widget in @widgets
      @computation.init()
    
  register: (id, obj, element) ->
    @widgets[id] = obj
    @layout.append element
    
  fetch: (Widget, id) ->
    idSpecified = id?
    unless idSpecified
      id = @count
      @count++
    if @widgets[id]
      @widgets[id]
    else
      # Create new widget
      if idSpecified then @createFromId(Widget, id) else @createFromCounter(Widget, id)
      null  # Widget must set default val
    
  createFromId: (Widget, id) ->
    resource = $blab.resources.find(@filename)
    name = Widget.handle
    spec = Widget.spec(id)
    s = spec.split("\n").join("\n  ")
    code = "#{name}\n  #{s}"
    resource.containers.fileNodes[0].editor.set(resource.content + "\n\n" + code)
    setTimeout (-> resource.compile()), 500
    
  createFromCounter: (Widget, id) ->
    spec = Widget.spec(id)
    make = -> new Widget eval(CoffeeScript.compile(spec, bare: true))
    setTimeout(make, 700)
    
  compute: -> @computation.compute()
  
  precode: ->
    precompile = {}
    precompile[@filename] =
      preamble:  """
      #{Layout.shortcuts}
      #{$blab.Widgets.Slider.layoutPreamble}
      #{$blab.Widgets.Table.layoutPreamble}
      
      """
      postamble: ""
    $blab.precompile(precompile)


class Widget
  
  @fetch: (C, id) -> widgets.fetch(C, id)
    
  register: (element) -> widgets.register @id, this, element
    
  compute: -> widgets.compute()


class Computation
  
  constructor: ->
    
  init: ->
    @precode()
    @compute()
    
  compute: ->
    # ZZZ TEMP - wired to foo.coffee
    resource = $blab.resources.find("foo.coffee")
    resource?.compile()
    
  precode: ->
    precompile = {}
    precompile["foo.coffee"] =
      preamble: """
      #{$blab.Widgets.Slider.computePreamble}
      #{$blab.Widgets.Table.computePreamble}
      
      """
      
      postamble: ""
    $blab.precompile(precompile)


class Layout
  
  @shortcuts: """
    layout = (spec) -> $blab.layout.set(spec)
    pos = (spec) -> $blab.layout.pos(spec)
    text = (spec) -> $blab.layout.text(spec)
  """
  
  constructor: ->
    @layout = {}
    @currentContainer = "#row1 .left"
  
  set: (@layout) ->
  
  pos: (@currentContainer) ->
    
  render: ->
    w = $("#widgets")
    w.empty()
    for label, row of @layout
      r = $ "<div>", id: label
      w.append r
      for col in row
        c = $ "<div>", class: col
        r.append c
      r.append($ "<div>", class: "clear")
        
  append: (element) -> $(@currentContainer).append element
  
  text: (t) -> @append t


layout = new Layout
computation = new Computation
widgets = new Widgets layout, computation  # ZZZ pass render here?


# Export (for Widget sublasses)
$blab.Widget = Widget

$blab.Widgets = {}  # Subclasses of Widget - ZZZ different name?
  
$blab.layout = layout
