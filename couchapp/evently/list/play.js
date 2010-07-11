function(e, doc)
{
	$('.nowPlaying').removeClass('nowPlaying');
	$('#song_'+doc._id).addClass('nowPlaying');
	
	// TO BE BOUND TO PLAYER WIDGET'S PLAY
}