#import "template.typ": template
#import "@preview/fletcher:0.5.1" as fletcher: diagram, node, edge
#import fletcher.shapes: house, hexagon

// Load template & set header
#show: template.with(
  title: [Fraud Detection of Cryptocurrencies],
  authors: (
    (
      name: "Gabriel Torres Gamez",
      organization: [Fachhochschule Nordwestschweiz],
      email: "gabriel.torresgamez@students.fhnw.ch"
    ),
    (
      name: "Aaron Brülisauer",
      organization: [Fachhochschule Nordwestschweiz],
      email: "aaron.brülisauer@students.fhnw.ch"
    ),
    (
      name: "Florian Baumgartner",
      organization: [Fachhochschule Nordwestschweiz],
      email: "florin.baumgartner@students.fhnw.ch"
    ),
    (
      name: "Can-Elian Barth",
      organization: [Fachhochschule Nordwestschweiz],
      email: "canelian.barth@students.fhnw.ch"
    ),
  ),
  abstract: [
    #lorem(200)
  ],
)

// Start of body
= Introduction

#lorem(100)

#lorem(120)
#colbreak()

== Overview


#lorem(50)

#v(4pt)

#figure([
  #let blob(pos, label, tint: white, ..args) = node(
  	pos, align(center, label),
  	width: 26mm,
  	fill: tint.lighten(60%),
  	stroke: 1pt + tint.darken(20%),
  	corner-radius: 5pt,
  	..args,
  )
  #diagram(
  	spacing: 8pt,
  	cell-size: (8mm, 10mm),
  	edge-stroke: 1pt,
  	edge-corner-radius: 5pt,
  	mark-scale: 70%,
  
  	blob((0,1), [Add & Norm], tint: yellow, shape: hexagon),
  	edge(),
  	blob((0,2), [Multi-Head\ Attention], tint: orange),
  	blob((0,4), [Input], shape: house.with(angle: 30deg),
  		width: auto, tint: red),
  
  	for x in (-.3, -.1, +.1, +.3) {
  		edge((0,2.8), (x,2.8), (x,2), "-|>")
  	},
  	edge((0,2.8), (0,4)),
  
  	edge((0,3), "l,uu,r", "--|>"),
  	edge((0,1), (0, 0.35), "r", (1,3), "r,u", "-|>"),
  	edge((1,2), "d,rr,uu,l", "--|>"),
  
  	blob((2,0), [Softmax], tint: green),
  	edge("<|-"),
  	blob((2,1), [Add & Norm], tint: yellow, shape: hexagon),
  	edge(),
  	blob((2,2), [Feed\ Forward], tint: blue),
  )
  #v(8pt)
],
  caption: [A curious figure. @noauthor_chatgpt_2024],
  placement: none
) <figure_id>

#lorem(50)

= Methods
#lorem(300)

= Results
#lorem(200)

= Insights
#lorem(200)

= Acknowledgments
#lorem(50)