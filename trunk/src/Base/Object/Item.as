package Base.Object 
{
	import Base.ActionHandler;
	import Base.Engine;
	import Base.Etc.HashMap;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 */
	public class Item extends ActionHandler
	{
		public var items:Vector.<Item>;
		public var aliases:Vector.<String>;
		public var description:String;
		public var owner:*;
		
		public var isVisible:Boolean;
		public var isPickable:Boolean;
		public var isPickedUp:Boolean;
		public var prop:HashMap; // custom properties
		
		public var engine:Engine;
		
		public function Item(register:Boolean = true) 
		{
			engine = Engine.inst;
			
			if (register) {
				engine.register(this);
			}
			
			init();
		}
		
		public function init():void {
			baseInit();
		}
		
		protected function baseInit():void {
			items = new Vector.<Item>();
			aliases = new Vector.<String>();
			owner = null;
			description = "";
			isVisible = true;
			isPickable = true;
			isPickedUp = false;
			prop = new HashMap();
		}
		
	}

}