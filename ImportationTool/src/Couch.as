package
{
	import CouchRequest;
	import CouchEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLVariables;
	
	public class Couch extends EventDispatcher
	{
		private var _db:String;
		private var _host:String;
		private var _port:Number;
		private var _couchURL:String;
		
		private var _bootstrapped:Boolean;
		public static const BOOTSTRAPED:String = "Couch.BOOTSTRAPED";
		
		/*** setup ***/
		
		public function Couch(db:String, host:String='localhost', port:Number=5984)
		{
			_bootstrapped = false;
			
			_db = db;
			_host = host;
			_port = port;
			_couchURL = 'http://'+_host+':'+_port+'/';
			
			bootstrap();
		}
		
		private function bootstrap():Boolean
		{
			if(_bootstrapped) return true;
			
			var req:CouchRequest = new CouchRequest(_couchURL);
			req.addEventListener(CouchEvent.COMPLETE, bootstrapComplete);
			req.load();
			
			return false;
		}
		
		private function bootstrapComplete(e:CouchEvent):void
		{
			if(_bootstrapped) return;
			
			if(e.data.hasOwnProperty('couchdb'))
			{
				_bootstrapped = true;
				
				trace("Couch::bootstrapComplete - Time to relax.");
				
				dispatchEvent(new Event(BOOTSTRAPED));
			}
			else
			{
				trace("Couch::bootstrapComplete - FAILED");
			}
		}
		
		private function serverReplied(e:CouchEvent):void
		{
			if(e.target.context is Function)
				e.target.context(e);
			else
				dispatchEvent(e.clone());
		}
		
		/**
		 * @return DB's uri
		 */
		public function getDBURL():String
		{
			return _couchURL + _db + '/';
		}
		
		
		public function uuids(callback:Function = null):void
		{
			if(!bootstrap())
			{
				addEventListener(BOOTSTRAPED, function t(e:Event):void{ uuids(callback); removeEventListener(BOOTSTRAPED,t); });
			}
			else
			{
				var req:CouchRequest = new CouchRequest(_couchURL+'_uuids');
				req.context = callback;
				req.addEventListener(CouchEvent.COMPLETE, serverReplied);
				req.load();
			}
		}
		
		public function put(doc:Object, id:String, rev:String = null, callback:Function = null):void
		{
			if(!bootstrap())
			{
				addEventListener(BOOTSTRAPED, function t(e:Event):void{ put(doc, id, rev, callback); removeEventListener(BOOTSTRAPED,t); });
			}
			else
			{
				var req:CouchRequest = new CouchRequest(this);
				req.addEventListener(CouchEvent.COMPLETE, serverReplied);
				req.context = callback;
				req.method = 'PUT';
				req.data = doc;
				req.load();
			}
		}
		
		/**
		 * You may call mycouch.get(new CouchDocument(mycouch,id,[rev]))
		 */
		public function get(doc:CouchDocument, callback:Function = null):void
		{
			if(!bootstrap())
			{
				addEventListener(BOOTSTRAPED, function t(e:Event):void{ get(doc, callback); removeEventListener(BOOTSTRAPED,t); });
			}
			else
			{
				var req:CouchRequest = new CouchRequest(getDBURL() + doc._id);
				
				if ( callback != null )
					req.addEventListener(CouchEvent.COMPLETE, callback);
				else
					req.addEventListener(CouchEvent.COMPLETE, serverReplied);
				
				req.context = doc;
				req.load();
			}
		}
		
		public function allDocs(callback:Function = null, limit:Number = 0, offset:Number = 0, descending:Boolean = false):void
		{
			if(!bootstrap())
			{
				addEventListener(BOOTSTRAPED, function t(e:Event):void{ allDocs(callback, limit, offset, descending); removeEventListener(BOOTSTRAPED,t); });
			}
			else
			{
				var req:CouchRequest = new CouchRequest(getDBURL() + '_all_docs');
				req.context = callback;
				req.addEventListener(CouchEvent.COMPLETE, serverReplied);
				
				var data:URLVariables = new URLVariables();
				
				if ( limit )
					data.limit = limit;
				
				if ( offset )
					data.offset = offset;
				
				if ( descending )
					data.descending = 'true';
				
				req.data = data;
				req.load();
			}			
		}
	}
}