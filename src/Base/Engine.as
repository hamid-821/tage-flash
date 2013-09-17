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
		public static var SEPARATOR:String = "---------------------------------------------------------------------";
		
		public static var inst:Engine;
		
		public var items:Vector.<Item>;
		
		public var scenes:Vector.<Scene>;
		public var npcs:Vector.<NPC>;
		//public var timers:Vector.<Timer>;
		
		/* variables related to current game state */
		private var _character:Character;
		private var _scene:Scene;
		public var interactionHandler:ActionHandler; // pass the incoming command to this handler directly
		
		public function Engine() 
		{
			inst = this;
			init();
			
			
			setHelperActions();
		}
		
		public function printLine(string:String):void {
			dispatchEvent(new OutputMessageEvent(string+"\n"));
		}
		
		public function print(string:String):void {
			dispatchEvent(new OutputMessageEvent(string));
		}
		
		public function setState(newScene:Scene, char:Character=null, actionHandler:ActionHandler=null):void {
			var oldScene:Scene = this.scene;
			
			if (oldScene != null) {
				oldScene.onLeave(newScene);
			}
			this.scene = newScene;
			scene.onEnter(oldScene);
			
			if (char != null) {
				this.character = char;
			}
			
			this.interactionHandler = (actionHandler == null ? this : actionHandler);
			parseCommand("describe");
		}
		
		public function setAction2(func:Function, pattern:String, ...Items):void {
			for (var i:int = 0; i < Items.length; i++) {
				var vari:String = ("\$" + (i + 1));
				pattern = Util.replaceAll(pattern, vari, "(" + (Items[i] as Item).getRegexName() + ")");
			}
			
			var func2:Function = function() {
				for each(var item:Item in Items) {
					if (item.owner == null) {
						printLine("I can't do it.");
						return;
					} else if (item.owner == Engine.inst.character || item.owner == Engine.inst.scene || Engine.inst.scene.findItem(item.name)) {
						continue;
					} else {
						printLine("I can't do it.");
						return;
					}
				}
				func();
			}
			
			setAction(pattern+"$" , func2);
		}
		
		public function setAction1(item:Item, pattern:String, func:Function):void {
			var func2:Function = function() {
				if (item.owner == null) {
					printLine("I can't do it.");
					return;
				} else if (item.owner == Engine.inst.character || item.owner == Engine.inst.scene || Engine.inst.scene.findItem(item.name)) {
					func();
				} else {
					printLine("I can't do it.");
					return;
				}
			}
			setAction(pattern + " (" + item.getRegexName() + ")$" , func2);
		}
		
		private function actionGo(command:String, match:Array) {
			if (match[2] == "") {
				this.printLine("Go to where?");
				return;
			}
			
			var verb:String = match[1];
			var placestr:String = match[2].substr(1, int.MAX_VALUE);
			
			var place:Scene = scene.findNeighborScene(placestr);
			if (place != null) {
				this.setState(place, this.character, this);
			} else {
				this.printLine("I can't go there.");
			}
		}
		private function actionPickup(command:String, match:Array) {
			if (match[2] == "") {
				this.printLine("Pick up what?");
				return;
			}
			
			var verb:String = match[1];
			var objname:String = match[2].substr(1, int.MAX_VALUE);
			
			var obj:Item = scene.findItem(objname);
			if (obj == null) {
				this.printLine("I can't find it.");
				return;
			}
			if (obj.overridePickup) return;
			
			if (obj.isVisible && obj != null) {
				if (!obj.isPickable) {
					this.printLine("I can't pick that up.");
				}
				else if (!obj.isPickedUp) {
					this.printLine("Picked up the " + obj.name + ".");
					this.character.addInventory(obj);
				} else {
					this.printLine("I already got that.");
				}
			} else {
				this.printLine("I can't find it.");
			}
		}
		
		private function actionDescribeEnvironment(command:String, match:Array) {
			if (!scene.firstTime) {
					scene.firstTime = true;
					describe(true);
				} else {
					describe(false);
				}
		}
		private function actionDescribe(command:String, match:Array) {
			if (match[2] == "") {
				if (!scene.firstTime) {
					scene.firstTime = true;
					describe(true);
				} else {
					describe(false);
				}
			}
			else {
				var objname:String = match[2].substr(1, int.MAX_VALUE);
				var obj:Item = scene.findItem(objname);
				var obj2:NPC = scene.findNPC(objname);
				var obj3:Character = this.character;
				
				if (obj == null) {
					obj = obj2;
					if (obj == null) {
						obj = obj3;
						if (!obj3.hasAlias(objname)) {
							obj = null;
						}
					} 
				}
				if (obj == null) {
					this.printLine("I can't find that.");
					return;
				} 
				else {
					this.printLine(obj.fullDescription);
				}
			}
		}
		
		public function describe(long:Boolean = false):void {
			this.printLine(scene.name.toUpperCase());
			long ? this.printLine(scene.descriptionLong) : this.printLine(scene.descriptionShort);
			
			for each(var object:Item in scene.items.concat(scene.npcs)) {
				if(object.isVisible)
					this.printLine("There is " + object.aliases[0] + " here.");
			}
			
			for each(var sc:Scene in scene.neighborScenes) {
				if(sc.isVisible)
					this.printLine("There is a path to " + sc.name + " here.");
			}
		}
		
		private function actionHelp(command:String, match:Array):void {
			this.printLine(SEPARATOR);
			this.printLine("COMMANDS:\nhelp: brings up this text.\ndescribe/look: gives a description of your environment.\ndescribe/look at [object_name]: describes the specified object.\ninventory: lists your inventory.\ntake/pick up/grab [object_name]: picks up the specified object.\ntalk to [npc_name]: starts talking to the npc.\n\nThere are also other commands, which you can find out by guessing. They are mostly simple, so don't try too complicated stuff.");
			this.printLine(SEPARATOR);
		}
		private function actionTalk(command:String, match:Array):void {
			var npcName:String;
			
			try {
				npcName = match[5].substr(1, int.MAX_VALUE);
			} catch (e:*) {
				npcName = "";
			}
			
			if (command == "talk" || command == "speak") {
				this.printLine("Bla bla bla.");
			} else if (npcName == "") {
				this.printLine("Talk to whom?");
			} else {
				var npc:NPC = scene.findNPC(npcName);
				if (npc != null) {
					npc.startChat();
				} else {
					this.printLine("I can't find it.");
				}
			}
		}
		
		private function actionInventory(command:String, match:Array):void {
			this.character.printInventory();
		}
		
		private function setHelperActions():void {
			setAction("(grab|pick up|take)(.*)", actionPickup);
			setAction("(describe|look at)(.+)", actionDescribe);
			setAction("(describe|look)$", actionDescribeEnvironment);
			setAction("help$", actionHelp);
			setAction("inventory$", actionInventory);
			setAction("(talk|speak)(( (to|with)(.*))|)", actionTalk);
			setAction("(go to|walk to)(.*)", actionGo);
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
		
		/*public function addCharacter(...Characters):void {
			for each(var item:Character in Characters) {
				characters.push(item);
			}
		}
		public function removeCharacter(character:Character):void {
			Util.remove(characters, character);
		}*/
		
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
			//characters = new Vector.<Character>();
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
				//characters.push(obj);
				character = obj as Character;
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
				//Util.remove(characters, obj);
				if (character == obj)
					character = null;
			} else if (obj is Scene) {
				Util.remove(scenes, obj);
			} else if (obj is NPC) {
				Util.remove(npcs, obj);
			}
		}
		
		public function get scene():Scene 
		{
			return _scene;
		}
		
		public function set scene(value:Scene):void 
		{
			_scene = value;
		}
		
		public function get character():Character 
		{
			return _character;
		}
		
		public function set character(value:Character):void 
		{
			_character = value;
		}
		
	}

}