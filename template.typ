// Workaround for the lack of an `std` scope.
#let std-bibliography = bibliography

// This function gets your whole document as its `body` and formats
// it as an article in the style of the IEEE.
#let template(
  // The paper's title.
  title: [Paper Title],

  // An array of authors. For each author you can specify a name,
  // department, organization, location, and email. Everything but
  // but the name is optional.
  authors: (),

  // The paper's abstract. Can be omitted if you don't have one.
  abstract: none,

  // The article's paper size. Also affects the margins.
  paper-size: "a4",

  // The result of a call to the `bibliography` function or `none`.
  bibliography: bibliography("refs.bib"),

  // The paper's content.
  body
) = {
  // Set document metadata.
  set document(title: title, author: authors.map(author => author.name))

  // Set the body font.
  set text(font: "TeX Gyre Termes", size: 10pt)

  // Enums numbering
  set enum(numbering: "1)a)i)")

  // Tables & figures
  set figure(placement: top)
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: table): set text(size: 8pt)
  show figure.caption.where(kind: table): smallcaps
  show figure.where(kind: table): set figure(numbering: "I")

  show figure.where(kind: image): set figure(supplement: [Fig.], numbering: "1")
  show figure.caption: set text(size: 8pt)

  // Code blocks
  show raw: set text(font: "TeX Gyre Cursor", size: 1em / 0.8)

  // Configure the page.
  set page(
    paper: paper-size,
    margin: (
        x: (50pt / 216mm) * 100%,
        top: (55pt / 279mm) * 100%,
        bottom: (64pt / 279mm) * 100%,
      ),
    footer: context [
        #set align(center)
        #counter(page).display(
          "1 of 1",
          both: true,
      )
    ]
  )

  // Configure equation numbering and spacing.
  set math.equation(numbering: "(1)")
  show math.equation: set block(spacing: 0.65em)

  // Configure appearance of equation references
  show ref: it => {
    if it.element != none and it.element.func() == math.equation {
      // Override equation references.
      link(it.element.location(), numbering(
        it.element.numbering,
        ..counter(math.equation).at(it.element.location())
      ))
    } else {
      // Other references as usual.
      it
    }
  }

  // Configure lists.
  set enum(indent: 10pt, body-indent: 9pt)
  set list(indent: 10pt, body-indent: 9pt)

  // Configure headings.
  set heading(numbering: "I.A.a)")
  show heading: it => locate(loc => {
    // Find out the final number of the heading counter.
    let levels = counter(heading).at(loc)
    let deepest = if levels != () {
      levels.last()
    } else {
      1
    }

    set text(10pt, weight: 400)
    if it.level == 1 [
      // First-level headings are centered smallcaps.
      // We don't want to number of the acknowledgment section.
      #let is-ack = it.body in ([Acknowledgment], [Acknowledgement])
      #set align(center)
      #set text(if is-ack { 10pt } else { 12pt })
      #show: smallcaps
      #v(20pt, weak: true)
      #if it.numbering != none and not is-ack {
        numbering("I.", deepest)
        h(7pt, weak: true)
      }
      #it.body
      #v(12pt, weak: true)
    ] else if it.level == 2 [
      // Second-level headings are run-ins.
      #set par(first-line-indent: 0pt)
      #set align(center)
      #set text(style: "italic")
      #v(12pt, weak: true)
      #if it.numbering != none {
        numbering("A.", deepest)
        h(7pt, weak: true)
      }
      #it.body
      #v(10pt, weak: true)
    ] else [
      // Third level headings are run-ins too, but different.
      #set align(center)
      #v(10pt, weak: true)
      #if it.level == 3 {
        numbering("a)", deepest)
        h(3.5pt, weak: true)
      }
      #(it.body)
      #v(10pt, weak: true)
    ]
  })

  // Style bibliography.
  show std-bibliography: set text(8pt)
  set std-bibliography(title: text(10pt)[References], style: "ieee")

  // Display the paper's title.
  v(0pt)
  align(center, text(28pt, title))
  v(0pt)

  // Display the authors list.
  for i in range(calc.ceil(authors.len() / 2)) {
    let end = calc.min((i + 1) * 2, authors.len())
    let is-last = authors.len() == end
    let slice = authors.slice(i * 2, end)
    grid(
      columns: slice.len() * (1fr,),
      gutter: -80pt,
      ..slice.map(author => align(center, {
        text(12pt, author.name)
        if "organization" in author [
          \ #emph(author.organization)
        ]
        if "email" in author {
          if type(author.email) == str [
            \ #link("mailto:" + author.email)
          ] else [
            \ #author.email
          ]
        }
      }))
    )

    if not is-last {
      v(16pt, weak: true)
    }
  }
  v(30pt, weak: true)

  // Start two column mode and configure paragraph properties.
  set par(justify: true, first-line-indent: 1em)
  show par: set block(spacing: 0.65em)

  // Display abstract.
  if abstract != none [
    #text(10pt, weight: 700)[#h(1em) Abstract #h(1em)]
    #abstract
    #v(20pt)
  ]

  columns(2, gutter: 12pt)[
    // Display the paper's contents.
    #body
  
    // Display bibliography.
    #bibliography
  ]
}

