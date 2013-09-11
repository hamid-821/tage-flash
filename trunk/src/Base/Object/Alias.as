package Base.Object 
{
	/**
	 * ...
	 * @author 
	 */
	public class Alias
	{
		public var name:String;
		public var article:String = "a"; //it is a or an
		
		public function Alias(Name:String, Article:String = "a") 
		{
			name = Name;
			article = Article;
		}
		
		public function toString():String {
			return article + " " + name;
		}
		
	}

}