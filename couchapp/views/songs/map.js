// TODO: emit null et faire la requete avec with_docs
function(doc)
{
	if (doc.type == "song")
	{
		emit(doc._id, doc);
	}
};