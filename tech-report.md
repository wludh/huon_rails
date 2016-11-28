# Technical Report

What follows is a technical report of the Huon d'Auvergne Digital Edition. This report consists of two parts:

* A report on the pieces of the project and how they relate as they are currently implemented.
* A discussion of previous iterations, paths considered, and failed extensions.

Together, these two sections should give a sense of the context for the project, its background, and current setup. More detailed instructions about how to work with the current implementation of the project can be found in our [README](https://github.com/wludh/huon_rails/blob/master/README.rdoc) file in the base of the repository.

Note: As of this writing on 9/26/16, the project currently employs TEI Boilerplate to display manuscript editions without annotations. This version of the project is hosted on Washington and Lee's servers and is mapped to [http://www.huondauvergne.org/](http://www.huondauvergne.org/). What follows is a description of the next phase of the project, the upcoming release, which is currently hosted on a staging site at [huon-rails.herokuapp.com](https://huon-rails.herokuapp.com).

## Current Implementation

The project currently runs as a Ruby on Rails web application hosted and deployed through Heroku. While Heroku offers a number of paid plans, the free option works fine for our purposes and allows us to easily spin up test instances of the project for sharing among the collaborators. All code is version controlled in git and stored on a [GitHub repository](https://github.com/wludh/huon_rails/) for the project. Version controlling means that our project history is well documented and stable, as we can easily work on features and correct bugs without affecting the current release of the code. GitHub facilitates collaboration among the various people working on the project, as the code can be easily distributed among the various interested parties.

When loading a particular manuscript page, the Rails app first loads the shell of the webpage by calling a series of partials, or fragments of the page such as the header, footer, or body. The TEI edition of any given manuscript page is, itself, one such partial. Loading the entire edition at once would be both slow and unnecessary, so, prior to loading, the App splits the edition into a series of pieces according to its component line groupings. These line groups are then paginated through as though they were separate pages. The app then uses the Nokogiri gem to parse the TEI for the selected line group, jettison unused tags, and embed the edition as part of the page itself. Compartmentalizing things in this way means that, in practice, the TEI files are kept wholly separate from the structure of the page itself. The one can be updated without tampering with the other.

Each manuscript edition consists of the edited text as well as a variety of annotations to that text provided by experts. Each manuscript page is encoded in a [project-specific flavor of TEI](https://docs.google.com/document/d/1VnJdHR_ny91dijSDzgDZKx79sq6fkVrp4nyMkvJ6Fnw/edit). Each manuscript page has associated annotations stored in a separate TEI file. For example, [p.xml](https://github.com/wludh/huon_rails/blob/master/lib/assets/p.xml) refers to the Padua Manuscript, and [notes-p.xml](https://github.com/wludh/huon_rails/blob/master/lib/assets/notes-p.xml) contains the annotations for that same manuscript page. This decision separates out the two different pieces of each final edition: the manuscript persists as its own unique object and the annotations collectively exist as a related entity. This means that the manuscript editions can remain stable even as the annotations might be changed and added to over time. Annotations are linked to a particular line using a note tag. Take line number two from the Padua Manuscript, p.xml:

```XML
<l n="2">E pluy de tre any<note xml:id="#P2"/> stete in la çitie</l>
```
When parsing and preparing the page, these note tags are cross-referenced with the XML:id's to find their corresponding annotations in the notes XML file. So the above line has embedded in it a note tag, with an XML:id of P2. The parser then looks in the notes-p.xml file to find the referenced note with an XML:id of P2:

```XML
<note n="2" xml:id="P2" resp="LZM">'year'; OF an (TL); OI anno (BA); I anno (BA)</note>
```

Having successfully found its target note, the parser then pulls out the text of the note, the author of the annotation, and the note number, all of which gets rolled up into the reading interface for the user. In practice the reading interface looks like this:

![huon reading interface annotations example](/app/assets/images/huon-interface.png)

Note tag in the TEI gets converted into a superscript note number. Clicking on an annotation number loads, [through JavaScript](https://github.com/wludh/huon_rails/blob/master/app/assets/javascripts/sitewide/browse.js) a particular note in the left pane along with its author.

In addition to the four manuscript editions, the Huon d'Auvergene Digital Edition also implements [Versioning Machine 4.0](http://v-machine.org/) so as to compare, side by side, related passages from multiple manuscripts that possess significant changes.

![versioning machine interface](/app/assets/images/versioning-machine.png)

Versioning Machine allows all the manuscript elements to be compared side by side, but it causes problems if the different versions are too long. Normally, clicking on a particular line will highlight the related lines across manuscripts. But if the lines extend beyond the height of the window, the user would not really be able to see that something has been highlighted. To this end, we are currently exploring augmentations of Versioning Machine that would have a single click highlight and center all related lines in their relative views.

We maintain a [Zotero](https://zotero.org) collection that contains all the resources for the project. Zoter allows our resources to be shared with other scholars, and it also allows us to dynamically embed them on our own [bibliography page](https://huon-rails.herokuapp.com/bibliography). The [pyzotero](https://github.com/urschrei/pyzotero) Python package allows us to query the Zotero API to get up-to-date information about our collected resources. Rather than modifying the bibliography page manually every time we want to add new information, we need only run a few commands from the terminal. Furthermore, by modifying the extant pyzotero package, we embed COinS metadata for our resources on the page so that users visiting our project site can download references to these materials straight into their own citation manager. When running the implementation of pyzotero, the script updates the partial for the bibliography page with the new data, overwriting the old version of the page. These steps ensure that the project's work can be as transparent as possible and benefit as many researchers as possible. They also mean that scholars from outside the project can contribute to the bibliography page, as the Zotero collection can be modified by anyone approved by the project director.

## Alternatives

Initially, the project parsed TEI using [TEI Boilerplate](http://dcl.ils.indiana.edu/teibp/), a project that prepares TEI using an XSLT stylesheet that is applied client-side. We suspected it would be more efficient to develop a simple parser that parsed the line groups one at a time rather than all at once. Furthermore, TEI Boilerplate required that the TEI be well formed in order for it to display. While in production this makes sense, we found that this caused difficulties when developing and debugging the project. While such errors could be caught using Oxygen prior to uploading the TEI, Rails has the advantage of also providing robust error reporting of its own. If the parser expects a particular format for TEI, it will break the app entirely and throw an error message that points to a particular line. In the context of debugging, this is handy. The technical abilities of the team meant that it was also easier to build a basic parser in Ruby than to work with XSLT.

Before our current implementation of the annotations, we explored using [annotator.js](http://annotatorjs.org/) for accomplishing the same purpose. This posed several complications. For one, the annotations would need to be stored somewhere.  Annotator.js does offer an external annotation storage surface, but we prefered to keep these resources stored in-house so as to prevent adding another potential sustainability problem down the road. All the same, setting up a database for the annotations seemed overkill for our purposes, when we only had a specific use for them. The decision to store them in TEI hosted in the app itself seemed to respect their status as part of the edition and also align with our long-term plans to preserve the scholarly labor in a sustainable fashion.

The Zotero implementation as it currently exists is a bit clunky, as it requires the execution of a Python element to update the Rails app. This decision was made because of the ready availability of a Python package for parsing the Zotero API when no Ruby option existed. Given world enough and time, this process would be refactored into Ruby to prevent the step of installing extra software for a single part of the process. But, all the same, we don't anticipate the bibliography being updated very frequently after the project finishes.