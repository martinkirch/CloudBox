/**
 * HTML5 <audio>, encapsulated, with custom controls
 */
var Player = {
	player: null,
	status: 'stop',
	
	init : function()
	{
		Player.player = document.getElementById('player');
		
		$(Player.player).bind('ended', function(event)
		{
			event.preventDefault();
			App.next();
		});
		
		$('#nextButton').click(function(event)
		{
			event.preventDefault();
			App.next();
		});
		$('#prevButton').click(function(event)
		{
			event.preventDefault();
			App.prev();
		});
	},
	
	stop : function()
	{
		if(Player.player.stop)
		{
			Player.player.stop();
			Player.status = 'stop';
		}
	},
	
	play : function()
	{
		if(Player.player.play)
		{
			Player.player.play();
			Player.status = 'play';
		}
	},
	
	pause : function()
	{
		if(Player.player.pause)
		{
			Player.player.pause();
			Player.status = 'pause';
		}
	},
	
	togglePlayPause : function()
	{
		if(Player.status == 'pause')
			Player.play();
		else
			Player.pause();
	},
	
	setCurrentSong : function(doc)
	{
		var status = Player.status;
		Player.stop();
		
		if(doc)
		{
			Player.player.src = doc.url;
			Player.player.load();
			
			if(status == 'play')
				Player.play();
		}
	}
};