# Technical Report

What follows is a technical report of the Huon d'Auvergne Digital Edition. This report consists of two parts:

* A report on the pieces of the project and how they relate as they are currently implemented.
* A discussion of previous iterations, paths considered, and failed extensions.

Together, these two sections should give a sense of the context for the project, its background, and current setup. More detailed instructions about the current project can be found in our README file in the base of the repository.

## Current Implementation

The project currently runs as a Ruby on Rails web application.

Each manuscript page is encoded in TEI, and each manuscript page has associated annotations stored in a separate TEI file. For example, p.xml refers to the Padua Manuscript, and notes-p.xml contains the annotations for that same manuscript page. This decision separates out the two different pieces of each final edition: the manuscript persists as its own unique object and the annotations collectively exist as a related entity. This means that the manuscript editions can remain stable even as the annotations might be changed and added to over time. The project is currently hosted and deployed through Heroku.

TEI HERE

When loading a particular manuscript page, the Rails app first loads the shell of the page by calling a series of partials. The TEI edition is, itself, one such partial, and the app then uses the Nokogiri gem to parse the TEI itself, jettison unused tags, and embed the edition as part of the page itself. This means that, in practice, the TEI files are kept wholly separate from the structure of the page itself. The one can be updated without tampering with the other.

Each manuscript edition consists of the edited text as well as a variety of annotations to that text provided by experts. Annotations are linked to a particular line using a note tag. Take line number two from the Padua Manuscript, p.xml:

```XML
<l n="2">E pluy de tre any<note xml:id="#P2"/> stete in la çitie</l>
```
When parsing and preparing the page, these note tags are cross-referenced with the XML:id's to find their corresponding annotations in the notes XML file. So the above line has embedded in it a note tag, with an XML:id of P2. The parser then looks in the notes-p.xml file to find the referenced note:

```XML
<note n="2" xml:id="P2" resp="LZM">'year'; OF an (TL); OI anno (BA); I anno (BA)</note>
```

The parser then pulls out the text of the note, the author of the annotation, and the note number, all of which gets rolled up into the reading interface for the user. So in practice The reading interface looks like this:

![huon reading interface annotations example](/app/assets/images/huon-interface.png)

Note tag in the TEI gets converted into a superscript note number. Clicking on that number loads a particular note in the left pane along with its author.

In addition to the four manuscript editions, the Huon d'Auvergene Digital Edition also implements Versioning Machine so as to compare, side by side, related passages from multiple manuscripts that possess significant changes.

![versioning machine interface](/app/assets/images/versioning-machine.png)