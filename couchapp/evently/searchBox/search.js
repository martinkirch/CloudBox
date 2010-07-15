function(e, query)  // TODO : maybe there's a better way to query couchdb-lucene... ?
{
	if(!query || query == '')
		return;
	
	var app = $$(this).app;
	var widget = $(this);
	
	// TODO : protect "query". lucene is sensitive
	var reqUrl = app.db.uri + '_fti/' + app.ddoc._id + '/songs?q=' + encodeURIComponent(query) + '&include_docs=true';
	
	$.ajax(
	{
		type: "GET",
		url: reqUrl,
		complete : function(req)
		{
			var resp = $.httpData(req, "json");
			
			if (req.status >= 400)
				alert("Error while requesting couchdb-lucene : "+resp.reason);
			else
			{
				var doc;
				
				var list = resp.rows.map(function(r) {
						doc = r.doc;
						return doc;
					});
				
				widget.trigger('setList', [list]);
			}
		}
	});
}