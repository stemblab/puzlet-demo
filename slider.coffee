class SpeedSlider
	
	v: 4.2
	
	constructor: (@callback) ->
		
		@container = $ "#speedSlider"
		
		@container.slider
			#orientation: "vertical"
			range: "min"
			min: 0.1
			max: 10
			step: 0.1
			value: @v
			slide: (e, ui) => @setSpeed(ui.value)
			change: (e, ui) =>  # Unused because responds to slide method
		
		@setSpeed @v
		
	setSpeed: (@v) ->
		@setText @v
		@callback @v
		
	setText: (v) -> $("#speedText").html v+" Hz"
	
	# API
	set: (v) -> @container.slider("value", v)
	
new SpeedSlider (v) ->
  $blab.freq = v
  r = $blab.resources.find "foo.coffee"
  #console.log "r", r
  r?.containers?.fileNodes[0].editor.run()
  #$.event.trigger "runCode"
  #$blab.rayleigh?.setWaveSpeed(v)