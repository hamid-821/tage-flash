package Base.Object 
{
	import Base.ActionHandler;
	import Base.Chat.Dialogue;
	/**
	 * ...
	 * @author 
	 */
	public class NPC extends Item
	{
		/*public var dialogues:Vector.<Dialogue>;
		public var oldHandler:ActionHandler = null;*/
		
		public function NPC(register:Boolean = true) 
		{
			super(register);
			
			isPickable = false;
			dialogues = new Vector.<Dialogue>();
		}
		
		/*public function startChat():void {
			oldHandler = engine.interactionHandler;
			engine.interactionHandler = dialogues[0];
			
			dialogues[0].startDialogue();
		}
		
		public function endChat():void {
			engine.interactionHandler = oldHandler;
		}*/
		
	}

}