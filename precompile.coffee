$blab.CoffeeResource.registerPrecompileCode
  "foo.coffee":
    preamble: "somePrecodedVariable = rand()\n"
    postamble: "\n$('#b').text(b[0])"