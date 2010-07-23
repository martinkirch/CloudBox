function(e,data)
{
	var prefix = $$(this).app.db.uri;
	var doc;
	
	for (var i=0; i < data.length; i++)
	{
		doc = data[i];
		
		if(doc._attachments)
		{
			for (var name in doc._attachments)
			{
				if(!doc.url && name.substring(name.length - 3) == 'mp3')
				{
					doc.url = prefix + encodeURIComponent(doc._id) + '/' + encodeURIComponent(name);
				}
				else if(!doc.coverUrl && name.substring(0,5) == 'cover')
				{
					doc.coverUrl = prefix + encodeURIComponent(doc._id) + '/' + encodeURIComponent(name);
				}
			}
		}
		
		$('#song_'+doc._id).data('doc', doc);
	};
}