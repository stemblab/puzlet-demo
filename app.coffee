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
    
  @fetch: (W, id) ->
    idSpecified = id?
    unless idSpecified
      id = @count
      @count++
    widget = @widgets[id]
    if widget
      widget
    else
      # Create new widget
      if idSpecified then @createFromId(W, id) else @createFromCounter(W, id)
      null  # Widget must set default val
    
  @createFromId: (W, id) ->
    resource = $blab.resources.find(Widgets.filename)
    name = W.handle
    spec = W.initSpec(id)
    s = spec.split("\n").join("\n  ")
    code = "#{name}\n  #{s}"
    resource.containers.fileNodes[0].editor.set(resource.content + "\n\n" + code)
    setTimeout (-> resource.compile()), 500
    
  @createFromCounter: (W, id) ->
    spec = W.initSpec(id)
    make = -> new W eval(CoffeeScript.compile(spec, bare: true))
    setTimeout(make, 700)
    
  @compute: -> Computation.compute()
  
  @precode: ->
    
    preamble = Layout.shortcuts + "\n"
    preamble += W.layoutPreamble+"\n" for n, W of @Registry
    
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
    preamble += W.computePreamble+"\n" for n, W of Widgets.Registry
    
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
    w = $("#widgets")
    w.empty()
    for label, row of @spec
      r = $ "<div>", id: label
      w.append r
      for col in row
        c = $ "<div>", class: col
        r.append c
      r.append($ "<div>", class: "clear")
        
  @append: (element) -> $(@currentContainer).append element
  
  @text: (t) -> @append t


Widgets.initialize()

# Export
$blab.Widgets = Widgets 

