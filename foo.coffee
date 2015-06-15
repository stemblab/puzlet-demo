a = [1, 2, 3]

b = a + pi

t = 0.1 * linspace(-pi, pi, 200)

#f = 5
f = slider "freq-slider"
s = slider "noise-var"
p = slider()
q = slider "and-another"
y = sin(2*pi*f*t) + s*rand([t.length])

table "y0", y[0]

plot t, y
