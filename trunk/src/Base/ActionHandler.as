package Base 
{
	import Base.Etc.HashMap;
	import Base.Etc.Util;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author 
	 */
	public class ActionHandler extends EventDispatcher
	{
		public var actions:HashMap;
		public var owner:*;
		public var engine:Engine;
		
		public function ActionHandler() 
		{
			initActionHandler();
		}
		
		public function initActionHandler():void {
			engine = Engine.inst;
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
				engine.printLine("I can't do that.");
				trace("ERROR: ActionHandler: parse");
			}
		}
		
	}

}