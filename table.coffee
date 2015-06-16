#!vanilla

Widgets = $blab.Widgets

class Table
  
  @handle: "table"
  @api: "$blab.Widgets.Registry.Table"
  
  @initSpec: (id) -> """
    id: "#{id}"
    headings: ["Column 1", "Column 2"]
    widths: ["100px", "100px"]
  """
  
  @layoutPreamble:
    "#{@handle} = (spec) -> new #{@api}(spec)"
  
  @computePreamble:
    "#{@handle} = (id, v...) -> #{@api}.compute(id, v)"
  
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


Widgets.register Table