package Base.Chat 
{
	import Base.Engine;
	/**
	 * ...
	 * @author 
	 */
	public class State 
	{
		public var text:* = "";
		public var isVisible:Boolean = true;
		public var answers:Vector.<Answer> = new Vector.<Answer>();
		public var action:Function;
		
		public function addAnswer(...Answers):void {
			for each(var ans:Answer in Answers)
				answers.push(ans);
		}
		
		public function getAnswer(i:int):Answer {
			var c:int = 1;
			for each(var ans:Answer in answers) {
				if (c == i) {
					return ans;
				}
				if (ans.isVisible) {
					c++;
				}
			}
			return null;
		}
		
		/** t can be a string or a function that returns a string. */
		public function State(t:* = "", is_visible:Boolean = true, _action:Function = null) 
		{
			text = t;
			isVisible = is_visible;
			action = _action;
			
			if (action == null) {
				action = function() { };
			}
		}
		
		public function print():String {
			var s:String = "";
			if (isVisible) {
				s += text + "\n";
			}
			
			var c:int = 1;
			for each(var ans:Answer in answers) {
				if (ans.isVisible) {
					s += c++ + ": " + ans.print() + "\n";
				}
			}
			
			return s;
		}
		
	}

}