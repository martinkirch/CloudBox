function(e)
{
	// we will need to access the raw AUDIO element contained in the widget	
	var div = this.get()[0];
	$(this).data('player',div.getElementsByTagName('audio')[0]);
}