$blab.precompile
  "foo.coffee":
    preamble: "somePrecodedVariable = rand()\nf = $blab.freq\n"
    postamble: "\n$('#b').text(b[0])"