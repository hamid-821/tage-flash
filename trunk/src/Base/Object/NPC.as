package Base.Object 
{
	import Base.Chat.Dialogue;
	/**
	 * ...
	 * @author 
	 */
	public class NPC extends Item 
	{
		public var dialogues:Vector.<Dialogue>;
		
		public function NPC(register:Boolean = true) 
		{
			super(register);
		}
		
		override public function init():void {
			baseInit();
			isPickable = false;
			dialogues = new Vector.<Dialogue>();
		}
		
	}

}