package Base.Object 
{
	import Base.ActionHandler;
	import Base.Engine;
	/**
	 * ...
	 * @author 
	 */
	public class Scene extends ActionHandler
	{
		public var name:String;
		public var descriptionShort:String;
		public var descriptionLong:String;
		
		public var items:Vector.<Item>;
		public var characters:Vector.<Character>; //?
		public var npcs:Vector.<NPC>;
		public var neighborScenes:Vector.<Scene>;
		
		public var engine:Engine;
		
		public function Scene(register:Boolean = true) 
		{
			engine = Engine.inst;
			
			if (register) {
				engine.register(this);
			}
			
			init();
		}
		
		public function init():void {
			name = "";
			descriptionLong = "";
			descriptionShort = "";
			items = new Vector.<Item>();
			characters = new Vector.<Character>();
			npcs = new Vector.<NPC>();
			neighborScenes = new Vector.<Scene>();
		}
		
	}

}