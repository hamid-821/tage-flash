package Visual
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author 
	 */
	public class Console extends Sprite
	{
		var itf:TextField = new TextField();
		var otf:TextField = new TextField();
		
		public function Console() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			handleVisuals();
		}
		
		public function handleVisuals():void {
			itf.width = otf.width = 700;
			itf.height = 50; otf.height = 400;
			itf.multiline = false;
			otf.multiline = true; otf.wordWrap = true;
			
			itf.x = 50; itf.y = 475;
			otf.x = 50; otf.y = 50;
			itf.border = otf.border = true;
			itf.type = "input";
			itf.addEventListener(KeyboardEvent.KEY_DOWN, inputEntered);
			addChild(itf);
			itf.defaultTextFormat = (new TextFormat("Courier New", 16));
			otf.defaultTextFormat = (new TextFormat("Courier New", 16));
			addChild(otf);
			
			stage.focus = itf;
		}
		
		public function inputEntered(event:KeyboardEvent):void {
			if (event.keyCode == 13) {
				var command:String = itf.text;
				itf.text = "";
				
				dispatchEvent(new NewMessageEvent(command));
			}
		}
		
		public function print(text:String):void {
			otf.appendText(text);
			otf.scrollV = otf.numLines;
		}
		
		public function println(text:String):void {
			otf.appendText(text+"\n");
			otf.scrollV = otf.numLines;
		}
		
	}

}