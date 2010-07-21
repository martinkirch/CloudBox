package
{
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	public class FakeFileReference extends FileReference
	{
		private var _data:ByteArray;
		private var _name:String;
		
		public function FakeFileReference(bytes:ByteArray, filename:String)
		{
			super();
			_data = bytes;
			_name = filename;
		}
		
		public override function get data():ByteArray
		{
			return _data;
		}
		
		public override function get name():String
		{
			return _name;
		}
		
		public override function get size():Number
		{
			if(_data)
				return _data.length;
			else
				return 0;
		}
	}
}