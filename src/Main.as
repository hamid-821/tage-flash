package  
{
	import Base.Chat.Answer;
	import Base.Chat.Dialogue;
	import Base.Chat.State;
	import Base.Engine;
	import Base.Etc.HashMap;
	import Base.Object.Character;
	import Base.Object.Item;
	import Base.Object.Scene;
	import Base.OutputMessageEvent;
	import flash.display.Sprite;
	import Visual.Console;
	import Visual.NewMessageEvent;
	/**
	 * ...
	 * @author 
	 */
	public class Main extends Sprite
	{
		var console:Console;
		
		var engine:Engine = new Engine();
		
		public var SEPARATOR:String = "---------------------------------------------------------------------";
		
		public function Main() 
		{
			console = new Console();
			addChild(console);
			console.addEventListener(NewMessageEvent.NEW_MESSAGE, newMessage);
			engine.addEventListener(OutputMessageEvent.OUTPUT_MESSAGE, outputMessage);
			
			
			var scene:Scene = new Scene();
			scene.name = "room";
			scene.descriptionShort = "I'm in a small room.";
			scene.descriptionLong = "I'm in a small room. I don't remember how I ended up here.";
			
			var table:Item = new Item();
			table.addAlias("table");
			table.shortDescription = "It's a table.";
			scene.addItem(table);
			
			var pencil:Item = new Item();
			pencil.addAlias("a pencil", "a pen");
			pencil.shortDescription = "It's a pencil. Hmm.";
			table.addItem(pencil);
			
			var note:Item = new Item();
			note.addAlias("note", "notes", "paper");
			note.shortDescription = "It's a note. Maybe it has some clues on why I am here and what is going on.";
			table.addItem(note);
			
			scene.setAction1(note, "(use|read)", function() {
				engine.printLine("Dear Sir,\n\nYou are probably wondering why you are here. Sorry for the inconvenience, but we had to bring you here for a special purpose. Please do not try to run away, for soon you will get to know the reason and the necessity of your presence.\n\nBest,\nAdministration");
			});
			
			var cupboard:Item = new Item();
			cupboard.addAlias("cupboard");
			cupboard.shortDescription = "It's a cupboard.";
			scene.addItem(cupboard);
			cupboard.setProp("open", false);
			scene.setAction1(cupboard, "close", function() {
				if (cupboard.getProp("open") == false) {
					engine.printLine("It's already closed.");
				} else {
					cupboard.setProp("open", false);
					cupboard.customDescription = "";
					engine.printLine("Closed the cupboard.");
					for each(var i:Item in cupboard.items) {
						i.isVisible = false;
					}
				}
			});
			scene.setAction1(cupboard, "open", function() {
				if (cupboard.getProp("open") == true) {
					engine.printLine("It's already open.");
				} else {
					cupboard.setProp("open", true);
					cupboard.customDescription = "It's open.";
					engine.printLine("Opened the cupboard.");
					for each(var i:Item in cupboard.items) {
						i.isVisible = true;
					}
					engine.printLine(cupboard.itemsDescription);
				}
			});
			
			var clothes:Item = new Item();
			clothes.addAlias("cloth", "clothes");
			clothes.shortDescription = "They are my clothes! No wonder why I was naked before.";
			scene.setAction1(clothes, "(use|put on|wear)", function() {
				if (!clothes.isVisible) {
					engine.printLine("I can't find the object.");
				}
				else {
					engine.printLine("I put on my clothes. It feels better to be dressed, even if I'm alone.");
					clothes.remove();
					engine.unregister(clothes);
				}
			});
			clothes.isVisible = false;
			cupboard.addItem(clothes);
			
			var door:Item = new Item();
			door.addAlias("door");
			door.shortDescription = "It's a door.";
			door.customDescription = "It seems like it's locked.";
			door.setProp("open", false);
			scene.addItem(door);
			
			scene.setAction1(door, "(open|use|unlock)", function() {
				engine.printLine("I can't unlock it with my bare hands. The instructions on the lock says that the door can be unlocked with a pencil. How convenient.");
			});
			
			var openDoorFunc:Function = function() { 
				if (door.getProp("open") == true) {
					engine.printLine("The door is already open.");
				} 
				else if (pencil.isPickedUp == false) { 
					engine.printLine("I don't have the object.");
				}
				else {
					door.setProp("open", true);
					engine.printLine("Tadaa! The door is open!");
					door.customDescription = "It's open.";
				}
			};
			scene.setAction2(openDoorFunc, "(open|unlock) $1 with $2", door, pencil);
			scene.setAction2(openDoorFunc, "(use) $1 with $2", pencil, door);
				
			var character:Character = new Character();
			character.addAlias("me", "myself", "Guybrush", "Guybrush Threepwood");
			character.shortDescription = "I'm in my mid-twenties and I look so good that it is probably the reason why they have locked me up in here; to save the world from getting blind by my awesome look.";
			
			scene.addCharacter(character);
			scene.character = character;
			
			engine.setState(scene, character, scene);
			engine.printLine("Welcome to the demo game. Type \"help\" to display the help text. Type \"describe\" to begin playing by describing your environment.");
			engine.printLine(SEPARATOR);
			engine.parseCommand("describe");
		}
		
		public function newMessage(e:NewMessageEvent):void {
			var text:String = e.text;
			console.println("> " + text);
			engine.parseCommand(text);
		}
		
		public function outputMessage(e:OutputMessageEvent):void {
			var text:String = e.message;
			console.print(text);
		}
		
	}

}