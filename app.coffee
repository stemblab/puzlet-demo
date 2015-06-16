#!vanilla

class Widgets

  @filename: "layout.coffee"  # should be layout.coffee
  
  @Registry: {}
  
  @register: (Widget) -> @Registry[Widget.name] = Widget
    
  @widgets: {}
  @count: 0
  
  @initialize: ->
    
    @Layout = Layout
    
    $(document).on "preCompileCoffee", (evt, data) =>
      url = data.resource.url
      console.log "preCompileCoffee", url 
      @count = 0  # ZZZ Bug?  only for foo.coffee or widgets.coffee
      return unless url is @filename
      @Layout.render()
      @precode()
      @widgets = {}
    
    $(document).on "compiledCoffeeScript", (evt, data) =>
      return unless data.url is Widgets.filename
      widget?.initialize?() for key, widget in @widgets
      Computation.init()
  
  @append: (id, widget, element) ->
    @widgets[id] = widget
    @Layout.append element
    
  @fetch: (Widget, id) ->
    idSpecified = id?
    unless idSpecified
      id = @count
      @count++
    w = @widgets[id]
    return w if w
    # Create new widget
    if idSpecified then @createFromId(Widget, id) else @createFromCounter(Widget, id)
    null  # Widget must set default val
    
  @createFromId: (Widget, id) ->
    resource = $blab.resources.find(Widgets.filename)
    name = Widget.handle
    spec = Widget.initSpec(id)
    s = spec.split("\n").join("\n  ")
    code = "#{name}\n  #{s}"
    resource.containers.fileNodes[0].editor.set(resource.content + "\n\n" + code)
    setTimeout (-> resource.compile()), 500
    
  @createFromCounter: (Widget, id) ->
    spec = Widget.initSpec(id)
    make = -> new Widget eval(CoffeeScript.compile(spec, bare: true))
    setTimeout(make, 700)
    
  @compute: -> Computation.compute()
  
  @precode: ->
    
    preamble = Layout.shortcuts + "\n"
    preamble += Widget.layoutPreamble+"\n" for n, Widget of @Registry
    
    precompile = {}
    precompile[@filename] =
      preamble: preamble
      postamble: ""
    
    $blab.precompile(precompile)


class Computation
  
  @filename: "compute.coffee"
  
  @init: ->
    @precode()
    @compute()
    
  @compute: ->
    resource = $blab.resources.find(@filename)
    resource?.compile()
    
  @precode: ->
    
    preamble = ""
    preamble += Widget.computePreamble+"\n" for WidgetName, Widget of Widgets.Registry
    
    precompile = {}
    precompile[@filename] =
      preamble: preamble
      postamble: ""
    
    $blab.precompile(precompile)


class Layout
  
  @shortcuts: """
    layout = (spec) -> $blab.Widgets.Layout.set(spec)
    pos = (spec) -> $blab.Widgets.Layout.pos(spec)
    text = (spec) -> $blab.Widgets.Layout.text(spec)
  """
  
  @spec: {}
  @currentContainer: null
  
  @set: (@spec) ->
  
  @pos: (@currentContainer) ->
    
  @render: ->
    widgets = $("#widgets")
    widgets.empty()
    for label, row of @spec
      r = $ "<div>", id: label
      widgets.append r
      for col in row
        c = $ "<div>", class: col
        r.append c
      r.append($ "<div>", class: "clear")
        
  @append: (element) -> $(@currentContainer).append element
  
  @text: (t) -> @append t


Widgets.initialize()

# Export
$blab.Widgets = Widgets 

