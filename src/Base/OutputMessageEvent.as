package Base 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class OutputMessageEvent extends Event 
	{
		public var message:String = "";
		public static var OUTPUT_MESSAGE:String = "output message event";
		
		public function OutputMessageEvent(message:String = "") 
		{ 
			super(OUTPUT_MESSAGE, false, false);
			this.message = message;
		} 
		
		public override function clone():Event 
		{ 
			return new OutputMessageEvent(message);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("OutputMessageEvent", "type", "bubbles", "cancelable", "eventPhase", "message"); 
		}
		
	}
	
}