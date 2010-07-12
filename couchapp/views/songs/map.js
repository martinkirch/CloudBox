function(doc)
{
	if (doc.type == "song")
	{
		emit(doc._id, null);
	}
};