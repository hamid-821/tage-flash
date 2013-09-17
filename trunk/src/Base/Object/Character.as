package Base.Object 
{
	import Base.Etc.Util;
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
			
			isPickable = false;
			inventory = new Vector.<Item>();
			addAlias("me", "myself");
		}
		
		/*override public function init():void {
			baseInit();
			isPickable = false;
			inventory = new Vector.<Item>();
		}*/
		
		public function printInventory():void {
			if (inventory.length == 0) {
				engine.printLine("I have nothing.");
			} else {
				engine.print("I have " + inventory[0].fullName);
				for (var i:int = 1; i < inventory.length; i++ ) {
					engine.print(", " + inventory[i].fullName);
				}
				engine.printLine(".");
			}
		}
		
		public function addInventory(...Items):void {
			//inventory.concat(Items);
			for each(var item:Item in Items) {
				inventory.push(item);
				item.remove();
				item.owner = this;
				item.isPickedUp = true;
			}
		}
		public function removeInventory(item:Item):void {
			if (Util.remove(inventory, item)) {
				item.owner = null;
				item.isPickedUp = false;
			}
		}
		
		public function findInventory(alias:String):Item {
			for each(var item:Item in inventory) {
				if (item.hasAlias(alias)) {
					return item;
				}
			}
			return null;
		}
	}

}