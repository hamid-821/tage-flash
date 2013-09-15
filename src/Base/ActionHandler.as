package Base 
{
	import Base.Etc.HashMap;
	import Base.Etc.Util;
	import Base.Object.Alias;
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
		public var aliases:Vector.<Alias>;
		
		public function ActionHandler() 
		{
			initActionHandler();
		}
		
		public function get name():String {
			return aliases[0].name;
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
		
		public function initActionHandler():void {
			engine = Engine.inst;
			actions = new HashMap();
			aliases = new Vector.<Alias>();
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
				(this is Engine) ? (this as Engine).printLine("I can't do that.") : engine.printLine("I can't do that.");
				trace("ERROR: ActionHandler: parse");
			}
		}
		
	}

}