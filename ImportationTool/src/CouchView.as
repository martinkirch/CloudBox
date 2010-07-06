package
{
	import Couch;
	import CouchEvent;
	import CouchDocument;
	
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.net.URLVariables;
	
	public class CouchView extends EventDispatcher
	{
		protected var _couchDB:Couch;
		protected var _designDoc:String;
		protected var _name:String;
		protected var _reqURL:String;
		
		public var totalRows:Number;
		public var offset:Number;
		public var rows:Array;
		
		public function CouchView(couch:Couch, designDoc:String, viewName:String)
		{
			_couchDB = couch;
			_designDoc = designDoc;
			_name = viewName;
			_reqURL = _couchDB.getDBURL() + '_design/' + _designDoc + '/_view/' + _name + '/';
		}
		
		protected function get DOC_FIELD_NAME():String    { return 'value'; }
		protected function get OFFSET_FIELD_NAME():String { return 'offset'; }
		
		/**
		 * params (optionels) : 
		 * key=valeurdeclé
		 * startkey=valeurdeclé
		 * startkey_docid=docid
		 * endkey=valeurdeclé
		 * limit=nombre de lignes maximum à retourner
		 * update=false
		 * descending=true
		 * skip=lignes à passer
		*/
		public function get(params:Object = null):void
		{
			var req:CouchRequest = new CouchRequest(_reqURL);
			
			if(params)
			{
				var vars:URLVariables = new URLVariables();
				
				for (var param:String in params)
					vars[param] = params[param];
				
				req.data = vars;
			}
			
			req.addEventListener(CouchEvent.COMPLETE, getCompleted);
			req.load();
		}
		
		private function getCompleted(e:CouchEvent):void
		{
			if(e.data.hasOwnProperty('rows'))
			{
				offset = e.data[OFFSET_FIELD_NAME];
				totalRows = e.data.total_rows;
				
				rows = new Array();
				var row:CouchDocument;
				trace("CouchView::getCompleted() " + DOC_FIELD_NAME);
				for (var i:int = 0; i < e.data.rows.length; i++)
				{	
					row = new CouchDocument(_couchDB, e.data.rows[i].id);
					
					for (var field:String in e.data.rows[i][DOC_FIELD_NAME]){
						row[field] = e.data.rows[i][DOC_FIELD_NAME][field];
					}
					rows.push(row);
				}
				
				var cEvent:CouchEvent = new CouchEvent(CouchEvent.COMPLETE);
				cEvent.data = rows;
				dispatchEvent(cEvent);
			}
		}
	}
}