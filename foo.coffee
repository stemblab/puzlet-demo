a = [1, 2, 3]

b = a + pi

t = 0.1 * linspace(-pi, pi, 200)

f = slider "freq-slider"
y = sin(2*pi*f*t)
y0 = y[0]

table "y0", y0

plot t, y
