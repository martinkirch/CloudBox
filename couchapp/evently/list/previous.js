function(e)
{
	var currentSong = $('.nowPlaying');
	if(!currentSong) return;
	
	var previousElement = currentSong.prev('.song');
	if(previousElement.length == 0) return;
	
	$(this).trigger('play', previousElement.data('doc'));
}