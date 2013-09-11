package Visual 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class NewMessageEvent extends Event 
	{
		public var text:String = "";
		public static var NEW_MESSAGE:String = "new message";
		
		public function NewMessageEvent(text:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(NEW_MESSAGE, bubbles, cancelable);
			this.text = text;
			
		} 
		
		public override function clone():Event 
		{ 
			return new NewMessageEvent(text, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("NewMessageEvent", "text", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}