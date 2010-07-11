function(e)
{
	var currentSong =$('.nowPlaying');
	if(!currentSong) return;
	
	var nextElement = currentSong.next('.song');
	if(nextElement.length == 0) return;
	
	$(this).trigger('play', nextElement.data('doc'));
}