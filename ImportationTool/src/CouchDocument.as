package
{
	import Couch;
	import CouchEvent;
	
	import flash.net.FileReference;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.utils.Proxy; 
	import flash.utils.flash_proxy;
	
	public dynamic class CouchDocument extends Proxy
	{
		// Don't forget to add properties names in {has,set,get,delete}Property
		
		public var _id:String;
		public var _rev:String;
		public var _pendingAttachments:Array; // actually read-only
		public var _data:Object; // actually read-only
		// TODO: est-ce qu'il y a un flag pour le read-only?
		// peut-on même faire read-only-from-package ?
		
		private var _couchDB:Couch;
		private var _dispatcher:EventDispatcher; // a kind of call-depencies-stack!
		private var _iterator:Array; // see nextNameIndex, nextName...
		
		public static const ID_RECEIVED:String = "CouchDocument.ID_RECEIVED";
		
		//////////////////////////////////////////////////////      INTERNALS
		
		
		public function CouchDocument(couch:Couch, id:String=null, rev:String=null)
		{
			_id = id;
			_rev = rev;
			_couchDB = couch;
			_dispatcher = new EventDispatcher();
			_pendingAttachments = null;
			_data = new Object();
			
			if(_id==null)
			{
				_couchDB.uuids(receiveUUID);
			}
		}
		
		private function receiveUUID(e:CouchEvent):void
		{
			_id = e.data.uuids[0];
			_dispatcher.dispatchEvent(new Event(ID_RECEIVED));
		}
		
		////////////////////////////////////////////////////// SMOOTH PUBLIC API
		
		public function attach(f:FileReference):void
		{
			_pendingAttachments = _pendingAttachments ? _pendingAttachments : new Array();
			_pendingAttachments.push(f);
		}
		
		/**
		 * reset _rev and document's data
		 */
		public function flush():void
		{
			_rev = null;
			_data = new Object();
		}
		
		
		////////////////////////////////////////////////////// COUCH ACTIONS
		
		public function save(callback:Function = null):void
		{
			if( _id == null)
			{
				_dispatcher.addEventListener(ID_RECEIVED, function t(e:Event):void{ save(callback); _dispatcher.removeEventListener(ID_RECEIVED,t); });
			}
			else
			{
				_couchDB.put(this, _id, _rev, callback);
			}
		}
		
		// TODO : virer ça pour que les gens appellent direct Couch::get ?
		public function get(callback:Function):void
		{
			if(_id==null)
			{
				// TODO : dispatchEvent(CouchEvent.NOT_FOUND)
				trace("CouchDocument::get() ERROR _id is still null! Aborting.");
			}
			else
			{
				_couchDB.get(this, callback);
			}
		}
		
		
		////////////////////////////////////////////////////// PROXY ENCAPSULATION
		
		
		override flash_proxy function setProperty(name:*, value:*):void
		{	
			switch (name)
			{
				case '_data':
				case '_pendingAttachments':
				case '_couchDB':
				case '_dispatcher':
				case '' :
				case null:
					return;
				case '_id':
				case '_rev':
					this[name] = value;
					return;
				default:
					this._data[name] = value;
					return;
			}
			
		}

		override flash_proxy function getProperty(name:*):* 
		{
			switch (name)
			{
				case '_couchDB':
				case '_dispatcher':
				case '' :
				case null:
					return null;
				case '_data':
				case '_id':
				case '_rev':
				case '_pendingAttachments':
					return this[name];
				default: return this._data[name];
			}
			
			return null;
		}
		
		override flash_proxy function hasProperty(name:*):Boolean
		{
			switch (name)
			{
				case '_id':
				case '_rev':
				case '_data':
				case '_couchDB':
				case '_dispatcher':
				case '_pendingAttachments':
					return true;
				default: return this._data.hasOwnProperty(name);
			}
			
			return false;
		}
		
		override flash_proxy function deleteProperty(name:*):Boolean
		{
			if(this.hasOwnProperty(name))
				return delete(this[name]);
			else
				return delete(this._data[name]);
		}
		
		override flash_proxy function nextNameIndex(index:int):int
		{
			if (index == 0) // first call - init iteration
			{
				_iterator = new Array();
				_iterator.push('_id');
				
				if(_rev != null)
					_iterator.push('_rev');
				
				for (var key:* in _data)
					_iterator.push(key);
			}

			return (index < _iterator.length) ? index+1 : 0;
		}
		
		override flash_proxy function nextName(index:int):String
		{
			return _iterator[index - 1];
		}
		
		override flash_proxy function nextValue(index:int):*
		{
			return this[_iterator[index - 1]];
		}
	}
}