function(e)
{
	var widget = $(this);
	
	var currentSong = widget.data('currentSong');
	if(!currentSong) return;
	
	var nextElement = $('#song_'+currentSong._id).next('.song');
	if(nextElement.length == 0) return;
	
	widget.trigger('play', nextElement.data('doc'));
}