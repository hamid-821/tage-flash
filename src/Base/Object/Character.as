package Base.Object 
{
	/**
	 * ...
	 * @author 
	 */
	public class Character extends Item
	{
		public var inventory:Vector.<Item>;
		
		public function Character(register:Boolean = true) 
		{
			super(register);
		}
		
		override public function init():void {
			baseInit();
			isPickable = false;
			inventory = new Vector.<Item>();
		}
	}

}