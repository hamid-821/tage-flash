package Base 
{
	import Base.Etc.HashMap;
	import Base.Etc.Util;
	/**
	 * ...
	 * @author 
	 */
	public class ActionHandler 
	{
		public var actions:HashMap;
		
		public function ActionHandler() 
		{
			init();
		}
		
		public function init():void {
			actions = new HashMap();
		}
		
		/** name can be a string, pattern or regex. 
		 * action should be a function with two arguments; first is command string, 
		 * and second is match array for the results of pattern matching. */
		public function setAction(name:*, action:Function):void {
			actions.put(name, action);
		}
		
		public function parse(command:String):void {
			command = Util.formatString(command);
			
			var flag:Boolean = false;
			for each(var k:* in actions.getKeys()) {
				var match:Array = command.match(k);
				if (match != null) {
					actions.getValue(k)(command, match);
					flag = true;
				}
			}
			if (!flag) {
				trace("ERROR: ActionHandler: parse");
			}
		}
		
	}

}