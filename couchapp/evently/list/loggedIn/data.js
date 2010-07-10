function(data) {
	var doc;
	return {
		songs : data.rows.map(function(r) {
			doc = r.value;
			return doc;
		})
	}
};