# Cloudbox

__Cloudbox is a cloudy jukebox (hence the name)__

Actually, it's a couchapp using HTML5's audio tag. In the back-end the basic principle is "a song = a couchDB document". An AIR application is provided to help you to fill your couch with your existing MP3 collection.

Music on a couch... relaxing ;)

## Requirements

* CouchDB >=0.11 with couchdb-lucene (mapped as http://myhost/mydb/_fti)
* Couchapp >=0.6
* Adobe AIR runtime (+ Adobe's AIR SDK >=1.5 if you want to compile the importation tool)

Normally any HTML5-compliant browser can run the application. Actually it works well on Safari 5, but Firefox 3.6 and 4 can't read the MP3 from Couchdb, Chrome 5 can "sometimes".
