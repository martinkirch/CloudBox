function(data) {
	var doc;
	var i = 0;
	return {
		songs : data.rows.map(function(r) {
			doc = r.value;
			doc.rowClass = 'l'+(i%2);
			i++;
			return doc;
		})
	}
};