package Base.Chat 
{
	import Base.ActionHandler;
	import Base.Etc.Util;
	/**
	 * ...
	 * @author 
	 */
	public class Dialogue extends ActionHandler
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
			setAction(".*", parseCommand);
		}
		
		public function parseCommand(cmd:String, match:Array):void {
			if (!Util.isNumber(cmd)) {
				engine.printLine("What?");
			}
			else {
				nextState(int(cmd));
				//var str:String = nextState(int(cmd));
				//engine.printLine(str);
			}
		}
		
		public function startDialogue():void {
			currentState = states[0];
			isActive = true;
			engine.printLine(currentState.print());
			currentState.action();
		}
		
		public function endDialogue():void {
			isActive = false;
		}
		
		public function nextState(answerIndex:int):String {
			var oldState:State = currentState;
			
			if (currentState == null) {
				trace("ERROR: Dialogue: nextState: currentState is null");
			} else {
				var ans:Answer = currentState.getAnswer(answerIndex);
				if (ans != null) {
					ans.action();
					currentState = ans.nextState;
					if (currentState != null) {
						engine.printLine(currentState.print());
						currentState.action();
					}
				}
			}
			return "";
			trace("ERROR: Dialogue: nextState");
		}
		
	}

}