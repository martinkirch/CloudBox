function(e) // TODO: search is triggered TWICE!
{
	var elem = $(this);
	
	if(elem.data('timer'))
		clearTimeout(elem.data('timer'));
	
	elem.data('timer', setTimeout(function(){
		elem.trigger('search', elem.val());
	}, 500));
}