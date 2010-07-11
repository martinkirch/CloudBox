function(e,data)
{
	var prefix = $$(this).app.db.uri;
	var doc;
	
	for (var i=0; i < data.length; i++)
	{
		doc = data[i];
		
		if(!doc.url && doc._attachments)
			for (var name in doc._attachments)
				if(name.substring(name.length - 3) == 'mp3')
				{
					doc.url = prefix + encodeURIComponent(doc._id) + '/' + encodeURIComponent(name);
				}
		alert(doc.url);
		$('#song_'+doc._id).data('doc', doc);
	};
}