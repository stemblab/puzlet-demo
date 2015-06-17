t = linspace(-1, 1, 200)

f = slider "freq-slider"
s = slider "noise-var"
q = slider "another"
y = sin(2*pi*f*t) + s*rand([t.length])

z = y+6

table "my-table", t[0..3], y[0..3]

plot "sinusoid", t, [y, z]
