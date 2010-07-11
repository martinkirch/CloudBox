function(data)
{
	var doc;
	
	var list = data.rows.map(function(r) {
			doc = r.value;
			return doc;
		}); // EPIC MUSTACHE!
	
	$(this).trigger('setList', [list]);
};