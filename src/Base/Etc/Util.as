package Base.Etc 
{
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author 
	 */
	public class Util 
	{
		
		public function Util() 
		{
			
		}
		
		public static function remove(vec:*, ob:*):void {
			var i:int = 0;
			for each(var o:* in vec) {
				if (o == ob) {
					vec.splice(i, 1);
					return;
				}
				i++;
			}
		}
		
		public static function has(vec:*, ob:*):Boolean {
			for each(var o:* in vec) {
				if (o == ob) {
					return true;
				}
			}
			return false;
		}
		
		public static function findStringInArray(arr:Array, str:String):int {
			var i:int;
			for (i = 0; i < arr.length; i++) {
				if (arr[i] == str) {
					return i;
				}
			}
			return -1;
		}
		
		public static function isNumber(str:String):Boolean {
			return str.match("[0-9]+") != null;
		}
		public static function formatString(command:String):String {
			command = command.toLowerCase();
			command = deleteDoubleSpaces(command);
			command = trimBeginEndSpace(command);
			command = removeThe(command);
			
			/*while (command.indexOf(" the ") != -1) {
				command = command.replace(" the ", " ");
			}*/
			
			return command;
		}

		public static function removeThe(str:String):String {
			return str.replace(/ the /g, " ");
		}
		public static function deleteDoubleSpaces(str:String):String {
			return str.replace(/ +/g, " ");
			/*while (true) {
				var ind:int = str.indexOf("  ");
				if (ind != -1) {
					str = str.split("  ").join(" ");
				} else {
					break;
				}
			}
			return str;*/
		}
		public static function trimBeginEndSpace(str:String):String {
			return str.replace(/\s*([^\s].*[^\s])\s*/g, "$1");
			/*while (true) {
				var lastchar:String = str.charAt(str.length - 1);
				if (lastchar == " ") {
					str = str.substr(0, str.length - 1);
				} else {
					return str;
				}
			}
			return "";*/
		}
		
		public static function getClass(obj:Object):Class {
			return Class(getDefinitionByName(getQualifiedClassName(obj)));
		}
   
		public static function getProperties(obj:Object):Array {
			var arr:Array = new Array();
			
			for each(var x:XML in describeType(obj).descendants("variable")) {
				var name:String = x.@name;
				arr.push(name);
			}
			return arr;
		}
		
		public static function clone(obj:*):* {
			var C:Class = getClass(obj);
			
			var o = new C();
			
			for each(var x:XML in describeType(obj).descendants("variable")) {
				var name:String = x.@name;
				var type:String = x.@type;
				
				if (type.match("(Vector|Array)") != null) {
					for each(var temp:* in obj[name]) {
						o[name].push(temp.clone());
					}
				} else {
					o[name] = obj[name];
				}
			}
			
			return o;
		}
		
	}

}