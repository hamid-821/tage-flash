package Base.Chat 
{
	/**
	 * ...
	 * @author 
	 */
	public class Dialogue 
	{
		public var states:Vector.<State> = new Vector.<State>();
		
		protected var currentState:State;
		
		protected var isActive:Boolean = false;
		
		public function addState(...States):void {
			for each(var s:State in States)
				states.push(s);
		}
		
		public function Dialogue() 
		{
			
		}
		
		public function startDialogue():String {
			currentState = states[0];
			isActive = true;
			return currentState.print();
		}
		
		public function endDialogue():void {
			isActive = false;
		}
		
		public function nextState(answerIndex:int):String {
			if (currentState == null) {
				trace("ERROR: Dialogue: nextState: currentState is null");
			} else {
				var ans:Answer = currentState.getAnswer(answerIndex);
				if (ans != null) {
					ans.action();
					currentState = ans.nextState;
					if (currentState != null) {
						currentState.action();
						return currentState.print();
					}
				}
			}
			return "ERROR: Dialogue: nextState";
		}
		
	}

}