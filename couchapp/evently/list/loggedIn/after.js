function(data)
{
	var prefix = $$(this).app.db.uri;
	var doc;
	for (var i=0; i < data.rows.length; i++)
	{
		doc = data.rows[i].value;
		doc.url = prefix+encodeURIComponent(doc._id)+'/'+encodeURIComponent(doc.filename);
		$('#song_'+doc._id).data('doc', doc);
	};
}