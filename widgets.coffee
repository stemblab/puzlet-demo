$blab.slider
  id: "freq-slider"
  min: 0.1
  max: 10
  step: 0.1
  init: 4.2
  container: "widgets"
  prompt: "Frequency:"
  text: (v) -> v + " Hz"
  
$blab.initWidgets()
