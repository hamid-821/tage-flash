package Base.Object 
{
	import Base.ActionHandler;
	import Base.Engine;
	import Base.Etc.Util;
	/**
	 * ...
	 * @author 
	 */
	public class Scene extends ActionHandler
	{
		//public var name:String;
		//public var aliases:Vector.<Alias>;
		public var descriptionShort:String;
		public var descriptionLong:String;
		
		public var items:Vector.<Item>;
		
		public var npcs:Vector.<NPC>;
		public var neighborScenes:Vector.<Scene>;
		
		public var firstTime:Boolean = false;
		
		public var isVisible:Boolean;
		
		public var onEnter:Function = function() {};
		public var onLeave:Function = function() {};
		
		//public var character:Character;
		//public var characters:Vector.<Character>; //?
		
		public function Scene(register:Boolean = true) 
		{
			engine = Engine.inst;
			
			if (register) {
				engine.register(this);
			}
			
			init();
		}
		
		public function init():void {
			//name = "";
			descriptionLong = "";
			descriptionShort = "";
			firstTime = false;
			items = new Vector.<Item>();
			//characters = new Vector.<Character>();
			npcs = new Vector.<NPC>();
			neighborScenes = new Vector.<Scene>();
			isVisible = true;
		}
		
		public function findItem(alias:String):Item {
			for each(var i:Item in items) {
				if (i.hasAlias(alias)) {
					return i;
				}
				var temp:Item = i.findItem(alias);
				if (temp != null) {
					return temp;
				}
			}
			
			var temp:Item = engine.character.findItem(alias);
			if (temp != null) {
				return temp;
			}
			var temp:Item = engine.character.findInventory(alias);
			if (temp != null) {
				return temp;
			}
			return null;
		}
		
		/*public function findCharacter(alias:String):Character {
			for each(var i:Character in characters) {
				if (i.hasAlias(alias)) {
					return i;
				}
			}
			return null;
		}*/
		
		public function findNPC(alias:String):NPC {
			for each(var i:NPC in npcs) {
				if (i.hasAlias(alias)) {
					return i;
				}
			}
			return null;
		}
		
		public function addItem(...Items):void {
			for each(var item:Item in Items) {
				item.remove();
				items.push(item);
				item.owner = this;
			}
		}
		public function removeItem(item:Item):void {
			if(Util.remove(items, item))
				item.owner = null;
		}
		
		/*public function addCharacter(...Characters):void {
			for each(var item:Character in Characters) {
				characters.push(item);
				item.owner = this;
			}
		}*/
		/*public function removeCharacter(character:Character):void {
			if(Util.remove(characters, character))
				character.owner = null;
		}*/
		
		public function addNPC(...Npcs):void {
			for each(var item:NPC in Npcs) {
				npcs.push(item);
				item.owner = this;
			}
		}
		
		public function removeNPC(npc:NPC):void {
			if(Util.remove(npcs, npc))
				npc.owner = null;
		}
		
		public function addNeighborScene(...Scenes):void {
			for each(var item:Scene in Scenes) {
				neighborScenes.push(item);
			}
		}
		public function removeNeighborScene(scene:Scene):void {
			Util.remove(neighborScenes, scene);
		}
		public function findNeighborScene(name:String):Scene {
			for each(var s:Scene in this.neighborScenes) {
				if (s.hasAlias(name)) {
					return s;
				}
			}
			return null;
		}
	}

}