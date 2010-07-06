var App = {
	player: null,
	
	_currentSong: null,
	
	init : function()
	{
		$('#header').fadeIn('slow');
		
		Player.init();
		
		$('#searchInput').click(function(){
			if(this.value == 'Search...')
				this.value = '';
		});
		
		$('#searchInput').keyup(function(){
			var elem = $(this);
			if(elem.data('timer'))
				clearTimeout(elem.data('timer'));
			
			elem.data('timer', setTimeout("App.search($('#searchInput').val())",1000));
		});
		
		App.search();
	},
	
	search : function(string)
	{
		var url = string ? ftiURL+'songs?q='+string+'&include_docs=true' : designURL+'_view/songs';
		
		var listContainer = $('#listContainer');
		$('#listContainer tr.song').remove();
		
		$.getJSON(url, function(data)
		{
			// TODO : utiliser $.map() pour éviter la closure
			for (var i=0; i < data.rows.length; i++) {
				var id = data.rows[i].id;
				var doc = data.rows[i].value || data.rows[i].doc;
				doc.id = id;
				doc.url = baseURL+id+'/'+doc.filename;
				
				listContainer.append(template('songRow', doc));
				$('#song_'+id).data('doc', doc);
				$('#song_'+id).click(function(document){ return function(){App.play(document)}}(doc));
				
			};
		});
	},
	
	/**
	 * @param mixed a complete song object OR its id
	 */
	setCurrentSong : function(doc)
	{
		if(typeof(doc) == 'string')
		{
			var loadedElem = $('#song_'+doc);
			
			if(loadedElem)
				App.setCurrentSong(loadedElem.data('doc'));
		}
		else if(doc)
		{
			if(App._currentSong && App._currentSong.id == doc.id)
				return;
			
			App._currentSong = doc;
			Player.setCurrentSong(doc);
		}
	},
	
	stop : function()
	{
		Player.stop();
	},
	
	play : function(id)
	{
		App.setCurrentSong(id);
		Player.play();
	},
	
	prev : function()
	{
		if(!App._currentSong) return;
		
		var prevElement = $('#song_'+App._currentSong.id).prev('.song');
		
		if(prevElement.length == 0) return;
		
		App.setCurrentSong(prevElement.data('doc'));
	},
	
	next : function()
	{
		if(!App._currentSong) return;
		
		var nextElement = $('#song_'+App._currentSong.id).next('.song');
		
		if(nextElement.length == 0) return;
		
		App.setCurrentSong(nextElement.data('doc'));
	}
};

$(document).ready(App.init);