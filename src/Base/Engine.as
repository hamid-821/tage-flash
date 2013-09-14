package Base 
{
	import Base.Etc.Util;
	import Base.Object.Character;
	import Base.Object.Item;
	import Base.Object.NPC;
	import Base.Object.Scene;
	import flash.utils.Timer;
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
		//public var timers:Vector.<Timer>;
		
		/* variables related to current game state */
		public var character:Character;
		public var scene:Scene;
		public var interactionHandler:ActionHandler; // pass the incoming command to this handler directly
		
		public function Engine() 
		{
			inst = this;
			init();
		}
		
		public function printLine(string:String):void {
			dispatchEvent(new OutputMessageEvent(string+"\n"));
		}
		
		public function print(string:String):void {
			dispatchEvent(new OutputMessageEvent(string));
		}
		
		public function setState(newScene:Scene, character:Character, interactionHandler:ActionHandler):void {
			var oldScene:Scene = this.scene;
			
			if (oldScene != null) {
				oldScene.onLeave(newScene);
			}
			this.scene = newScene;
			scene.onEnter(oldScene);
			this.character = character;
			this.interactionHandler = interactionHandler;
			parseCommand("describe");
		}
		
		public function parseCommand(command:String):void {
			interactionHandler.parse(command);
		}
		
		public function addItem(...Items):void {
			for each(var item:Item in Items) {
				items.push(item);
			}
		}
		public function removeItem(item:Item):void {
			Util.remove(items, item);
		}
		
		public function addCharacter(...Characters):void {
			for each(var item:Character in Characters) {
				characters.push(item);
			}
		}
		public function removeCharacter(character:Character):void {
			Util.remove(characters, character);
		}
		
		public function addNPC(...Npcs):void {
			for each(var item:NPC in Npcs) {
				npcs.push(item);
			}
		}
		
		public function removeNPC(npc:NPC):void {
			Util.remove(npcs, npc);
		}
		
		public function addScene(...Scenes):void {
			for each(var item:Scene in Scenes) {
				scenes.push(item);
			}
		}
		
		public function removeScene(scene:Scene):void {
			Util.remove(scenes, scene);
		}
		
		public function findItem(alias:String):Item {
			for each(var i:Item in items) {
				if (i.hasAlias(alias)) {
					return i;
				}
			}
			return null;
		}
		
		public function findNPC(alias:String):NPC {
			for each(var i:NPC in npcs) {
				if (i.hasAlias(alias)) {
					return i;
				}
			}
			return null;
		}
		
		/*public function addTimer(t:Timer):void {
			timers.push(t);
		}
		public function removeTimer(t:Timer):void {
			Util.remove(timers, t);
		}*/
		public function stopAllTimers(scene:Scene = null):void {
			for each(var t:Item in items) {
				if (scene != null) {
					if (scene.findItem(t.name) != null) {
						t.stopTimer();
					}
				}
			}
			for each(var t:Item in npcs) {
				if (scene != null) {
					if (scene.findItem(t.name) != null) {
						t.stopTimer();
					}
				}
			}
			if (character != null) {
				character.stopTimer();
			}
		}
		
		public function startAllTimers(scene:Scene = null):void {
			for each(var t:Item in items) {
				if (scene != null) {
					if (scene.findItem(t.name) != null) {
						t.startTimer();
					}
				}
			}
			for each(var t:Item in npcs) {
				if (scene != null) {
					if (scene.findItem(t.name) != null) {
						t.startTimer();
					}
				}
			}
			if (character != null) {
				character.startTimer();
			}
		}
		
		public function init():void {
			items = new Vector.<Item>();
			characters = new Vector.<Character>();
			scenes = new Vector.<Scene>();
			npcs = new Vector.<NPC>();
			stopAllTimers();
			//timers = new Vector.<Timer>();
			
			character = null;
			scene = null;
			interactionHandler = null;
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