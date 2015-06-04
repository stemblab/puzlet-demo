id1 = "temp1"
id2 = "temp2"

# TODO: factory methods

isMain = true

OLD_predefinedCoffee = """
	pi = Math.PI
"""

OLD_predefinedCoffeeLines = OLD_predefinedCoffee.split "\n"

OLD_initMath = ->
	window._$_ = PaperScript._$_
	window.$_ = PaperScript.$_

OLD_preProcess = (code) ->
	
	lf = "\n"
	
	isMainStr = if isMain then 'true' else 'false'
	preamble = ["__isMain__ = #{isMainStr}#{lf}"]
	
	codeLines = code.split lf
	firstLine = codeLines[0]
	
	vanilla = firstLine is "#!vanilla"
	unless vanilla
		initMath()
		preamble = preamble.concat predefinedCoffeeLines
		
		for l, i in codeLines
			codeLines[i] = "_disable_operator_overloading();" if l is "#!no-math-sugar"
			codeLines[i] = "_enable_operator_overloading();" if l is "#!math-sugar"
		
	codeLines = preamble.concat(codeLines)
	code = codeLines.join lf
	
OLD_postProcess = (js) ->
	js = PaperScript.compile js #unless vanilla  # $blab.overloadOps no longer used.
	js
	
plotLines = (resultArray) ->
    n = null
    numLines = resultArray.length
    for b, idx in resultArray
        n = idx if (typeof b is "string") and b.indexOf("eval_plot") isnt -1
    d = if n then (n - numLines + 8) else 0
    l = if d and d>0 then d else 0
    return "" unless l>0
    lfs = ""
    lfs += @lf for i in [1..l]
    lfs

compiler = $coffee.compiler(id: id1)
compilerEval = $coffee.evaluator(id: id2)
#compiler = $coffee.compiler(id: id1, preProcess: preProcess, postProcess: postProcess)
#compilerEval = $coffee.evaluator(id: id2, preProcess: preProcess, postProcess: postProcess)

code1 = "a = 4; window.$rand = Math.random() + a;"
code2 = "console.log $coffee.eval\na = 3\nx = 2+a+1\n"
#code2 = "console.log $coffee.eval\na = 3\nx = 2+a+pi\n"

compiler.compile code1
compiler.resultStr

compilerEval.compile code2
result = compilerEval.result + plotLines(compilerEval.resultArray)

#console.log "compiler", compiler
#console.log "evaluator", compilerEval
console.log "results", $rand, result
#console.log "$coffee", $coffee

# $blab.evaluatingResource = this
# $.event.trigger("compiledCoffeeScript", {url: @url})
