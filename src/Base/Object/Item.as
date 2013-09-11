package Base.Object 
{
	import Base.ActionHandler;
	import Base.Chat.Dialogue;
	import Base.Engine;
	import Base.Etc.HashMap;
	import Base.Etc.Util;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author 
	 */
	public class Item extends ActionHandler
	{
		public var items:Vector.<Item>;
		public var aliases:Vector.<Alias>;
		private var _description:String;
		public var shortDescription:String;
		public var customDescription:String = "";
		
		public var isVisible:Boolean;
		public var isPickable:Boolean;
		public var isPickedUp:Boolean;
		//public var isSeen:Boolean = false; // whether the object is seen or not
		public var overridePickup:Boolean = false; // would you like to override the default "pickup" behaviour of the engine, or not
		public var prop:HashMap; // custom properties
		public var count:int;
		public var dialogue:Dialogue;
		
		private var lifetime:int; //in milliseconds
		private var lifetimeFunc:Function;
		private var timer:Timer;
		
		public var dialogues:Vector.<Dialogue>;
		public var oldHandler:ActionHandler = null;
		
		public function Item(register:Boolean = true) 
		{
			engine = Engine.inst;
			
			if (register) {
				engine.register(this);
			}
			
			init();
		}
		
		public function setDialogue(d:Dialogue):void {
			this.dialogue = d;
			d.owner = this;
		}
		
		public function startChat():void {
			oldHandler = engine.interactionHandler;
			engine.interactionHandler = dialogue;
			
			dialogue.startDialogue();
		}
		
		public function endChat():void {
			engine.interactionHandler = oldHandler;
		}
		
		/** count = 0 means infinity */
		public function startTimer(lifetime:int, func:Function, count:int):void {
			try {
				timer.stop();
			} catch (e:*) {
				
			}
			engine.removeTimer(timer);
			timer = new Timer(lifetime, count);
			timer.addEventListener(TimerEvent.TIMER, func);
			timer.start();
			engine.addTimer(timer);
		}
		
		public function stopTimer():void {
			try {
				timer.stop();
			} catch (e:*) {
				
			}
		}
		
		public function get fullDescription():String {
			var s:String = description;
			s += "\n" + itemsDescription;
			
			if (s.charAt(s.length - 1) == "\n") {
				s = s.substr(0, s.length - 1);
			}
			return s;
		}
		
		public function get description():String {
			return shortDescription + " " + customDescription;
		}
		
		public function get itemsDescription():String {
			var s:String = "";
			for each(var o:Item in items) {
				if(o.isVisible)
					s += "There is " + o.aliases[0] + " here.\n";
			}
			return s.substr(0, s.length - 1);
		}
		
		
		public function get name():String {
			return aliases[0].name;
		}
		
		public function setProp(name:*, value:*):void {
			prop.put(name, value);
		}
		
		public function getProp(name:*):* {
			return prop.getValue(name);
		}
		
		public function getRegexName():String {
			var s:String = aliases[0].name;
			
			for (var i:int = 1; i < aliases.length; i++) {
				s += "|" + aliases[i].name;
			}
			return s;
		}
		
		/** returns name with the article. */
		public function get fullName():String {
			return aliases[0].toString();
		}
		
		public function addItem(...Items):void {
			//items.concat(Items);
			for each(var item:Item in Items) {
				item.remove();
				items.push(item);
				item.owner = this;
			}
		}
		
		public function findItem(alias:String):Item {
			for each(var item:Item in items) {
				if (item.hasAlias(alias)) {
					return item;
				}
			}
			return null;
		}
		
		public function removeItem(item:Item):void {
			if (Util.remove(items, item))
				item.owner = null;
		}
		
		public function remove():void {
			if (owner is Character) {
				owner.removeItem(this);
				owner.removeInventory(this);
			} else if (owner is Scene) {
				owner.removeItem(this);
			} else if (owner is Item) { //base class so put as last option!!!
				owner.removeItem(this);
			} 
			owner = null;
		}
		
		/** Please give aliases with articles, such as "a cat", "an umbrella", etc.
		 * If you just give it like e.g. "umbrella" only, the program will use the "a" article by default.
		 * The articles are used while describing each object. */
		public function addAlias(...Aliases):void {
			for each(var name:String in Aliases) {
				var match:Array = name.match("(a|an) (.+)");
				if (match != null) {
					aliases.push(new Alias(match[2].toLowerCase(), match[1].toLowerCase()));
				} else {
					aliases.push(new Alias(name.toLowerCase()));
				}
			}
		}
		
		public function hasAlias(alias:String):Boolean {
			for each(var s:Alias in aliases) {
				if (s.name == alias) {
					return true;
				}
			}
			return false;
		}
		
		public function init():void {
			baseInit();
		}
		
		protected function baseInit():void {
			items = new Vector.<Item>();
			aliases = new Vector.<Alias>();
			owner = null;
			shortDescription = "";
			customDescription = "";
			isVisible = true;
			isPickable = true;
			isPickedUp = false;
			//isSeen = false;
			prop = new HashMap();
			count = 1;
			dialogues = new Vector.<Dialogue>();
			dialogue = null;
			overridePickup = false;
		}
		
	}

}