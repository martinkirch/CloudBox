function(e, doc)
{
	var player = $(this).data('player');
	
	if(doc)
	{
		player.src = doc.url;
		player.load();
	}
	
	if(player.play)
		player.play();
}