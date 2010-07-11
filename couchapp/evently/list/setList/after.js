function(e,data)
{
	var prefix = $$(this).app.db.uri;
	var doc;
	
	for (var i=0; i < data.length; i++)
	{
		doc = data[i];
		
		if(!doc.url)
			doc.url = prefix+encodeURIComponent(doc._id)+'/'+encodeURIComponent(doc.filename);
		
		$('#song_'+doc._id).data('doc', doc);
	};
}