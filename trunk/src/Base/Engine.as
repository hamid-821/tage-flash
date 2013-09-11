package Base 
{
	import Base.Etc.Util;
	import Base.Object.Character;
	import Base.Object.Item;
	import Base.Object.NPC;
	import Base.Object.Scene;
	/**
	 * ...
	 * @author 
	 */
	public class Engine extends ActionHandler
	{
		public static var inst:Engine;
		
		public var items:Vector.<Item>;
		public var characters:Vector.<Character>;
		public var scenes:Vector.<Scene>;
		public var npcs:Vector.<NPC>;
		
		/* variables related to current game state */
		public var character:Character;
		public var scene:Scene;
		public var interactionHandler:ActionHandler; // pass the incoming command to this handler directly
		
		public function Engine() 
		{
			inst = this;
			init();
		}
		
		public function init():void {
			items = new Vector.<Item>();
			characters = new Vector.<Character>();
			scenes = new Vector.<Scene>();
			npcs = new Vector.<NPC>();
		}
		
		public function register(obj:*):void {
			if (obj is Item) {
				items.push(obj);
			} else if (obj is Character) {
				characters.push(obj);
			} else if (obj is Scene) {
				scenes.push(obj);
			} else if (obj is NPC) {
				npcs.push(obj);
			} else {
				trace("ERROR: Engine: register");
			}
		}
		
		public function unregister(obj:*):void {
			if (obj is Item) {
				Util.remove(items, obj);
			} else if (obj is Character) {
				Util.remove(characters, obj);
			} else if (obj is Scene) {
				Util.remove(scenes, obj);
			} else if (obj is NPC) {
				Util.remove(npcs, obj);
			}
		}
		
	}

}