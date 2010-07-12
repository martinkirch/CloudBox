// TODO: emit null et faire la requete avec include_docs=true
function(doc)
{
	if (doc.type == "song")
	{
		emit(doc._id, null);
	}
};