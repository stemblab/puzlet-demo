Widget = $blab.Widget

class Table extends Widget
  
  @handle: "table"
  
  @spec: (id) -> """
    id: "#{id}"
    headings: ["Column 1", "Column 2"]
  """
  
  @layoutPreamble:
    "table = (spec) -> new $blab.Widgets.Table(spec)"
    
  @computePreamble:
    "table = (id, v...) -> $blab.Widgets.Table.compute(id, v)"
  
  @compute: (id, v) ->
    Widget.fetch(Table, id)?.setVal(v)
  
  constructor: (@spec) ->
    
    {@id, @headings} = @spec
    
    @table = $("#"+@id)
    @table.remove() if @table.length
    @table = $ "<table>", id: @id, class: "widget"
    
    @register @table
    
  initialize: -> #@setVal @init
    
  setVal: (v) ->
    @table.empty()
    tr = $ "<tr>"
    @table.append tr
    for h in @headings
      tr.append "<th>#{h}</th>"
    
    row = []
    for x, idx in v[0]
      tr = $ "<tr>"
      @table.append tr
      for i in [0...v.length] 
        tr.append "<td>"+v[i][idx]+"</td>"
    @value = v


$blab.Widgets.Table = Table