<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <link rel="stylesheet" type="text/css" href="build/mirador/css/mirador-combined.css">
    <title>Mirador Viewer</title>
    <style type="text/css">
     #viewer {
       width: 50%;
       height: 100%;
       position: fixed;
     }
    </style>
  </head>
  <body>
    <h1>IIIF VIEWER</h1>
    <div id="viewer"></div>

    <script src="build/mirador/mirador.js"></script>
    <script type="text/javascript">

     $(function() {
       // Called without "let" or "var"
       // so we can play with it in the browser
       myMiradorInstance = Mirador({
         "id": "viewer",
         "layout": "1x1",
         "data": [
           { "manifestUri": "https://iiif.lib.harvard.edu/manifests/drs:48309543", "location": "Harvard University"},
           { "manifestUri": "https://iiif.lib.harvard.edu/manifests/drs:5981093", "location": "Harvard University"},
           { "manifestUri": "https://iiif.lib.harvard.edu/manifests/via:olvwork576793", "location": "Harvard University"},
           { "manifestUri": "https://iiif.lib.harvard.edu/manifests/drs:14033171", "location": "Harvard University"},
           { "manifestUri": "https://iiif.lib.harvard.edu/manifests/drs:46909368", "location": "Harvard University"},
           { "manifestUri": "https://iiif.lib.harvard.edu/manifests/drs:48331776", "location": "Harvard University"},
           { "manifestUri": "http://iiif.harvardartmuseums.org/manifests/object/299843", "location": "Harvard University"},
           { "manifestUri": "http://iiif.harvardartmuseums.org/manifests/object/304136", "location": "Harvard University"},
           { "manifestUri": "http://iiif.harvardartmuseums.org/manifests/object/198021", "location": "Harvard University"},
           { "manifestUri": "http://iiif.harvardartmuseums.org/manifests/object/320567", "location": "Harvard University"},
           { "manifestUri": "https://purl.stanford.edu/qm670kv1873/iiif/manifest", "location": "Stanford University"},
           { "manifestUri": "https://purl.stanford.edu/jr903ng8662/iiif/manifest", "location": "Stanford University"},
           { "manifestUri": "https://purl.stanford.edu/ch264fq0568/iiif/manifest", "location": "Stanford University"},
           { "manifestUri": "https://purl.stanford.edu/wh234bz9013/iiif/manifest", "location": "Stanford University"},
           { "manifestUri": "https://purl.stanford.edu/rd447dz7630/iiif/manifest", "location": "Stanford University"},
           { "manifestUri": "http://dms-data.stanford.edu/data/manifests/Stanford/ege1/manifest.json", "location": "Stanford University"},
           { "manifestUri": "http://dams.llgc.org.uk/iiif/4574752/manifest.json", "location": "National Library of Wales"},
           { "manifestUri": "http://dev.llgc.org.uk/iiif/ww1posters.json", "location": "National Library of Wales"},
           { "manifestUri": "http://dams.llgc.org.uk/iiif/newspaper/issue/3320640/manifest.json", "location": "National Library of Wales"},
           { "manifestUri": "http://dams.llgc.org.uk/iiif/2.0/1465298/manifest.json", "location": "National Library of Wales"},
           { "manifestUri": "http://manifests.ydc2.yale.edu/manifest/Admont23", "location": "Yale University"},
           { "manifestUri": "http://manifests.ydc2.yale.edu/manifest/Admont43", "location": "Yale University"},
           { "manifestUri": "http://manifests.ydc2.yale.edu/manifest/BeineckeMS10", "location": "Yale University"},
           { "manifestUri": "https://manifests.britishart.yale.edu/manifest/5005", "location": "Yale Center For British Art"},
           { "manifestUri": "https://manifests.britishart.yale.edu/manifest/1474", "location": "Yale Center For British Art"},
           { "manifestUri": "http://iiif.bodleian.ox.ac.uk/iiif/manifest/51a65464-6408-4a78-9fd1-93e1fa995b9c.json", "location": "Bodleian Libraries"},
           { "manifestUri": "http://iiif.bodleian.ox.ac.uk/iiif/manifest/f19aeaf9-5aba-4cee-be32-584663ff1ef1.json", "location": "Bodleian Libraries"},
           { "manifestUri": "http://iiif.bodleian.ox.ac.uk/iiif/manifest/3b31c0a9-3dab-4801-b3dc-f2a3e3786d34.json", "location": "Bodleian Libraries"},
           { "manifestUri": "http://iiif.bodleian.ox.ac.uk/iiif/manifest/e32a277e-91e2-4a6d-8ba6-cc4bad230410.json", "location": "Bodleian Libraries"},
           { "manifestUri": "http://gallica.bnf.fr/iiif/ark:/12148/btv1b84539771/manifest.json", "location": 'BnF'},
           { "manifestUri": "http://gallica.bnf.fr/iiif/ark:/12148/btv1b10500687r/manifest.json", "location": 'BnF'},
           { "manifestUri": "http://gallica.bnf.fr/iiif/ark:/12148/btv1b55002605w/manifest.json", "location": 'BnF'},
           { "manifestUri": "http://gallica.bnf.fr/iiif/ark:/12148/btv1b55002481n/manifest.json", "location": 'BnF'},
           { "manifestUri": "http://www.e-codices.unifr.ch/metadata/iiif/sl-0002/manifest.json", "location": 'e-codices'},
           { "manifestUri": "http://www.e-codices.unifr.ch/metadata/iiif/bge-cl0015/manifest.json", "location": 'e-codices'},
           { "manifestUri": "http://www.e-codices.unifr.ch/metadata/iiif/fmb-cb-0600a/manifest.json", "location": 'e-codices'},
           { "manifestUri": "https://data.ucd.ie/api/img/manifests/ucdlib:33064", "location": "University College Dublin"},
           { "manifestUri": "https://data.ucd.ie/api/img/manifests/ucdlib:40851", "location": "University College Dublin"},
           { "manifestUri": "https://data.ucd.ie/api/img/manifests/ucdlib:30708", "location": "University College Dublin"},
           { "manifestUri": "http://dzkimgs.l.u-tokyo.ac.jp/iiif/zuzoubu/12b02/manifest.json", "location": "University of Tokyo"},
           { "manifestUri": "http://www2.dhii.jp/nijl/NIJL0018/099-0014/manifest_tags.json", "location": "NIJL"},
           { "manifestUri": "https://digi.vatlib.it/iiif/MSS_Vat.lat.3225/manifest.json", "location": "Vatican Library"},
           { "manifestUri": "http://media.nga.gov/public/manifests/nga_highlights.json", "location": "National Gallery of Art"},
           { "manifestUri": "http://demos.biblissima-condorcet.fr/iiif/metadata/BVMM/chateauroux/manifest.json", "location": "Biblissima"},
           { "manifestUri": "https://manifests.britishart.yale.edu/Osbornfa1", "location": "Yale Beinecke"},
           /* { "manifestUri": "http://demos.biblissima-condorcet.fr/iiif/metadata/florus-dispersus/manifest.json", "location": "Biblissima"}*/
           { "manifestUri": "https://media.nga.gov/public/manifests/multispectral_demo.json", "location": "National Gallery of Art"},
           { "manifestUri": "https://scta.info/iiif/codex/sorb/manifest"},
           { "manifestUri": "https://scta.info/iiif/graciliscommentary/lon/manifest"},
           { "manifestUri": "https://scta.info/iiif/plaoulcommentary/sorb/manifest"}
         ],
         "windowObjects": [{
           loadedManifest: "https://iiif.lib.harvard.edu/manifests/drs:48309543",
           viewType: "ThumbnailsView"
         }],
         "annotationEndpoint": { "name":"Local Storage", "module": "LocalStorageEndpoint" },
         "sidePanelOptions" : {
           "tocTabAvailable": false,
           "layersTabAvailable": false,
           "searchTabAvailable": false,
           "annotations" : false
         },
      });
     });
    </script>
    <!-- This enables live reloading of assets for improved developer experience. -->
    <!-- Remove if copying this page as a basis for another project. -->
    <script src="//localhost:35729/livereload.js"></script>
  </body>
</html>
