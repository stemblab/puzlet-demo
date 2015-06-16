class Widgets
  
  @filename: "widgets.coffee"  # should be layout.coffee
  
  constructor: (@layout) ->  # ZZZ pass render?
    
    @widgets = {}
    @count = 0
    
    $(document).on "preCompileCoffee", (evt, data) =>
      url = data.resource.url
      console.log "preCompileCoffee", url 
      @count = 0
      return unless url is "widgets.coffee"
      @layout.render()
      @layoutPrecode()
      @widgets = {}
    
    $(document).on "compiledCoffeeScript", (evt, data) =>
      @init() if data.url is "widgets.coffee"
    
  init: ->
    @computePrecode()
    for key, widget in @widgets #$blab.widgets
      widget?.initialize()
    @compute()
    
  register: (id, obj, element) ->
    @layout.append element
    @widgets[id] = obj
    
  add: (Widget, id) ->
    
    idSpecified = id
    unless idSpecified
      id = @count
      @count++
  
    name = Widget.handle
    spec = Widget.spec(id)
    s = spec.split("\n").join("\n  ")
    code = "#{name}\n  #{s}"
  
    make = ->
      new Widget eval(CoffeeScript.compile(spec, bare: true))
  
    unless @widgets[id]
      if idSpecified
        resource = $blab.resources.find("widgets.coffee")
        resource.containers.fileNodes[0].editor.set(resource.content + "\n\n" + code)
        setTimeout (-> resource.compile()), 500
      else
        setTimeout(make, 700)
      
    @widgets[id]
    
  compute: ->
    # ZZZ TEMP - wired to foo.coffee
    resource = $blab.resources.find("foo.coffee")
    resource?.compile()
  
  layoutPrecode: ->
    
    precompile = {}
    precompile["widgets.coffee"] =
      preamble:  """
      #{Layout.shortcuts}
      #{$blab.Widgets.Slider.layoutPreamble}
      #{$blab.Widgets.Table.layoutPreamble}
      
      """
      postamble: ""
      
    $blab.precompile(precompile)
    
  computePrecode: ->
    
    precompile = {}
  
    precompile["foo.coffee"] =
      preamble: """
      #{$blab.Widgets.Slider.computePreamble}
      #{$blab.Widgets.Table.computePreamble}
      
      """
      
      postamble: ""
    
    $blab.precompile(precompile)


class Widget
  
  @makeWidget: (C, id) -> theWidgets.add(C, id)
    
  register: (element) ->
    theWidgets.register @id, this, element
    
  compute: ->
    theWidgets.compute()  # for foo.coffee


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
theWidgets = new Widgets layout  # ZZZ pass render here?


# Export (for Widget sublasses)
$blab.Widget = Widget

$blab.Widgets = {}  # Subclasses of Widget - ZZZ different name?
  
$blab.layout = layout
