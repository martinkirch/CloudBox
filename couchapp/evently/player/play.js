function(e, doc)
{
	var player = $(this).data('player');
	var cover = $('img', this);
	
	if(player.stop)
		player.stop();
	
	if(doc)
	{
		player.src = doc.url;
		player.load();
		
		if(doc.coverUrl)
			cover.attr('src', doc.coverUrl);
		
		cover.css('visibility', doc.coverUrl ? 'visible' : 'hidden');
	}
	
	if(player.play)
		player.play();
}