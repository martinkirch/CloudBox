function(e)
{
	$.log("keyup!");
	var elem = $(this);
	
	if(elem.data('value') == elem.val()) // no value change since last call
		return;
	elem.data('value', elem.val());
	
	if(elem.data('timer'))
		clearTimeout(elem.data('timer')),$.log("cleared");
	
	elem.data('timer', setTimeout(function(){
		$.log("triggered");
		elem.data('timer', null);
		elem.trigger('search', elem.val());
	}, 500));
}