function(e, doc)
{
	var widget = $(this);
	
	var currentSong = widget.data('currentSong');
	if(currentSong)
	{
		$('#song_'+currentSong._id).removeClass('nowPlaying');
	}
	
	currentSong = doc;
	widget.data('currentSong', currentSong);
	$('#song_'+currentSong._id).addClass('nowPlaying');
	
	
	// TO BE BOUND TO PLAYER WIDGET'S PLAY
}