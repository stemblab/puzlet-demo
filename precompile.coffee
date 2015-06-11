$blab.precompile
  "foo.coffee":
    preamble: "somePrecodedVariable = rand()\n"
    postamble: "\n$('#b').text(b[0])"