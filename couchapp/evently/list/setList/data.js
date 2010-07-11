function(e, data) {
	var doc;
	var i = 0;
	
	return {
		songs : data.map(function(r) {
			doc = r;
			doc.rowClass = 'l' + (i++ % 2);
			return doc;
		})
	}
};