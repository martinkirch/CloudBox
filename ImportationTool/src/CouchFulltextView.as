package
{
	import Couch;
	import CouchView;
	
	public class CouchFulltextView extends CouchView
	{	
		static public var DB_HANDLER_NAME:String = '_fti';
		
		public function CouchFulltextView(couch:Couch, designDoc:String, indexName:String)
		{
			super(couch, designDoc, indexName);
			
			_reqURL = couch.getDBURL() + DB_HANDLER_NAME + '/' + designDoc + '/' + indexName;
		}
		
		override protected function get DOC_FIELD_NAME():String    { return 'doc'; }
		override protected function get OFFSET_FIELD_NAME():String { return 'skip'; }
		
		/**
		 * params (optionels) : 
		 * callback (JSONP callback wrapper)
		 * debug (true disables response caching)
		 * force_json =true forces all response to "application/json" regardless of the Accept header
		 * include_docs whether to include the source docs (defaults to true)
		 * limit  the maximum number of results to return
		 * skip the number of results to skip
		 * sort the comma-separated fields to sort on. Prefix with / for ascending order and \ for descending order (ascending is the default if not specified).
		 * stale  when =ok couchdb-lucene may not perform any refreshing on the index
		*/
		public function search(query:String, userParams:Object = null):void
		{
			var params:Object = userParams ? userParams : new Object();
			
			if(!params.hasOwnProperty('include_docs'))
				params.include_docs = true;
			
			params.q = query;
			
			get(params);
		}
	}
}