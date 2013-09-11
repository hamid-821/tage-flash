package Base.Chat 
{
	import Base.Engine;
	/**
	 * ...
	 * @author 
	 */
	public class Answer 
	{
		public var isVisible:Boolean = true;
		public var text:* = "";
		
		public var action:Function; //?
		public var nextState:State = null;
		public var parentState:State = null;
		
		/** t can be a string or a function that returns a string. */
		public function Answer(t:* = "", _parentState:State = null, _nextState:State = null, _isVisible:Boolean = true, _action:Function = null) 
		{
			text = t;
			isVisible = _isVisible;
			action = _action;
			nextState = _nextState;
			parentState = _parentState;
			
			if (parentState != null) {
				parentState.addAnswer(this);
			}
			
			if (_action == null) {
				action = function() { };
			}
		}
		
		public function print():String {
			if (isVisible) {
				return text;
			}
			return "";
		}
		
	}

}