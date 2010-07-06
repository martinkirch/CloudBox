package
{	
	import flash.events.Event;
	
	public class CouchEvent extends Event
	{
		public static const COMPLETE:String = "CouchEvent.COMPLETE";
		
		public var data:Object;
		
		public function CouchEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			super(type,bubbles,cancelable);
		}
		
		override public function clone():Event
		{
			var e:CouchEvent = new CouchEvent(type, bubbles, cancelable);
			e.data = data;
			return e;
		}
	}
}