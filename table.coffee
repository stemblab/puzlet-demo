Widgets = $blab.Widgets

class Table
  
  @handle: "table"
  @api: "$blab.Widgets.Registry.Table"
  
  @initSpec: (id) -> """
    id: "#{id}"
    headings: ["Column 1", "Column 2"]
  """
  
  @layoutPreamble:
    "#{@handle} = (spec) -> new #{@api}(spec)"
  
  @computePreamble:
    "#{@handle} = (id, v...) -> #{@api}.compute(id, v)"
  
  @compute: (id, v) ->
    Widgets.fetch(Table, id)?.setVal(v)
  
  constructor: (@spec) ->
    
    {@id, @headings} = @spec
    
    @table = $("#"+@id)
    @table.remove() if @table.length
    @table = $ "<table>", id: @id, class: "widget"
    
    Widgets.append @id, this, @table
    
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


Widgets.register Table