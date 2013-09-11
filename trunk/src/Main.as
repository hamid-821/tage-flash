package  
{
	import Base.Chat.Answer;
	import Base.Chat.Dialogue;
	import Base.Chat.State;
	import Base.Engine;
	import Base.Etc.HashMap;
	import Base.Object.Item;
	import flash.display.Sprite;
	import Visual.Console;
	import Visual.NewMessageEvent;
	/**
	 * ...
	 * @author 
	 */
	public class Main extends Sprite
	{
		var console:Console;
		
		public function Main() 
		{
			console = new Console();
			addChild(console);
			console.addEventListener(NewMessageEvent.NEW_MESSAGE, newMessage);
			
		}
		
		public function newMessage(e:NewMessageEvent):void {
			var text:String = e.text;
			console.println("> " + text);
		}
		
	}

}