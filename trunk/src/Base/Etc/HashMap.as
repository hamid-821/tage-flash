package Base.Etc 
{
	/**
	 * ...
	 * @author 
	 */
	public class HashMap 
	{
		public var keys:Array = new Array();
		public var values:Array = new Array();
		
		public function HashMap() 
		{
			
		}
		
		public function put(key:*, value:*):void {
			var i:int = 0;
			for each(var object:* in keys) {
				if (object == key) {
					values[i] = value;
					return;
				}
				i++;
			}
			keys.push(key);
			values.push(value);
		}
		
		public function hasKey(key:*):Boolean {
			for each(var object:* in keys) {
				if (key == object) return true;
			}
			return false;
		}
		
		public function getKeys():Array {
			return keys;
		}
		
		public function getValues():Array {
			return values;
		}
		
		public function getValue(key:*):* {
			var i:int = 0;
			for each(var object:* in keys) {
				if (object == key) {
					return values[i];
				}
				i++;
			}
			return null;
		}
		
	}

}