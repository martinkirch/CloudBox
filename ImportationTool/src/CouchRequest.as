package // TODO faire en sorte que cete classe ne puisse être utilisée que dans le package
{
	import Couch;
	import CouchEvent;
	import CouchDocument;
	
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLLoader;
	import flash.net.URLVariables;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.utils.ByteArray;
	import flash.net.FileReference;
	
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONParseError;
	
	public class CouchRequest extends EventDispatcher
	{		
		private var _request:URLRequest;
		private var _document:CouchDocument;
		private var _couch:Couch;
		private var _context:Object; // Free context var   /!\ has a special behavior if it's a CouchDocument
		
		public function CouchRequest(req:*=null)
		{
			if(req is Couch)
			{
				_request = new URLRequest();
				_couch = Couch(req);
			}
			else
			{
				_request = new URLRequest(req);
			}
			
			// TODO  _request.contentType = "application/json"; ??
		}
		
		public function load():void
		{	
			var loader:URLLoader = new URLLoader();

			loader.addEventListener(Event.COMPLETE, completed);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			try
			{
				loader.load(_request);
			} 
			catch (e:Error)
			{
				trace("CouchRequest::load - failed to send request to " + _request.url);
			}
		}
		
		private function applyResponseToDocument(received:Object = null):void
		{
			if(!received) return;
			if(!_document) return;
			
			switch(_request.method)
			{
				case 'PUT':
					if(!received.hasOwnProperty('ok') || !received.ok)
						return;
					
					if(received.hasOwnProperty('rev'))
						_document._rev = received.rev;
					
					break;
				
				default:  // and GET by the way
					_document.flush();
					for (var key:* in received)
						_document[key] = received[key];
			}
		}
		
		private function sendSubRequest():void
		{
			var f:FileReference = _document._pendingAttachments.pop();
			f.data.position = 0;
			
			// TODO protect name?
			var subRequest:CouchRequest = new CouchRequest(_couch);
			subRequest.url = _couch.getDBURL() + _document._id + '/' + f.name + ( _document._rev ? '?rev=' + _document._rev : '');
			subRequest.method = _request.method;
			subRequest.data = f.data;
			subRequest.context = f;
			
			subRequest.addEventListener(CouchEvent.COMPLETE, subRequestCompleted);
			
			try
			{	
				subRequest.load();
			}
			catch (e:Error)
			{
				trace("CouchRequest::completed() - error while sending sub-request to " + subRequest.url + "\n" + e);
			}
		}
		
		/*** Handlers ***/
		
		private function subRequestCompleted(e:CouchEvent):void
		{
			if(_document && _document._pendingAttachments)
			{
				if(e.target.context is FileReference)
				{
					var f:FileReference = FileReference(e.target.context);
					var attachment:Object = new Object();
					attachment.stub = true;
					attachment.content_type = "application/octet-stream"; // TODO
					attachment.length = f.size;
					
					// TODO
					// if(e.data.rev)
					// 	attachment.revpos = Number(e.data.rev) // faut extraire le 2 d'un 2-74c2cf7a55bd9d2f5398888681194cc8
					
					if(!_document._attachments)
						_document._attachments = new Object();
					
					_document._attachments[f.name] = attachment;
				}
				
				applyResponseToDocument(e.data);
				
				if(_document._pendingAttachments.length > 0)
				{
					sendSubRequest();
					return;
				}
			}
			
			var cEvent:CouchEvent = new CouchEvent(CouchEvent.COMPLETE);
			cEvent.data = e.data;
			dispatchEvent(cEvent);
		}
		
		private function completed(e:Event):void
		{
			var loader:URLLoader = URLLoader(e.target);
			var data:Object;
						
			trace("CouchRequest::completed " + _request.url + " - received : \n" + loader.data);
			
			try
			{
				data = JSON.decode(loader.data);
			}
			catch (err:JSONParseError)
			{
				trace("received from " + _request.url + " :\n" + loader.data);
				trace(err);
				return;
			}
			
			applyResponseToDocument(data);
			
			if(_document && _document._pendingAttachments && _document._pendingAttachments.length > 0)
			{
				sendSubRequest();
			}
			else
			{
				var cEvent:CouchEvent = new CouchEvent(CouchEvent.COMPLETE);
				cEvent.data = data;
				dispatchEvent(cEvent);
			}
		}
		
		private function securityErrorHandler(e:Event):void
		{
			trace("CouchRequest::securityErrorHandler handled " + e + " while requesting " + _request.url);
		}
		
		private function ioErrorHandler(e:Event):void
		{
			trace("CouchRequest::ioErrorHandler handled " + e + " while requesting " + _request.url);
		}
		
		/*** Getters and setters ***/
		
		public function get url():String { return _request ? _request.url : ""; }

		public function set url(u:String):void { _request.url = u; }
		
		public function get method():String { return _request ? _request.method : ""; }
		
		public function set method(m:String):void { _request.method = m; }
		
		public function get context():Object { return _context; }
		
		public function set context(d:Object):void
		{
			if(d is CouchDocument)
				_document = CouchDocument(d);
			
			_context = d;
		}
		
		public function get data():Object { return _request ? _request.data : new Object(); }
		
		public function set data(d:Object):void
		{
			if(d is CouchDocument)
			{
				_document = d as CouchDocument;
				_request.data = JSON.encode(_document._data);
				_request.url = _couch.getDBURL() + _document._id + ( _document._rev ? '?rev=' + _document._rev : '');
			}
			else if (d is ByteArray || d is URLVariables)
				_request.data = d;
			else
				_request.data = JSON.encode(d);
		}
	}
}