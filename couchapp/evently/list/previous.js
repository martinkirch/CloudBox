function(e)
{
	var widget = $(this);
	
	var currentSong = widget.data('currentSong');
	if(!currentSong) return;
	
	var previousElement = $('#song_'+currentSong._id).prev('.song');
	if(previousElement.length == 0) return;
	
	widget.trigger('play', previousElement.data('doc'));
}