package commandManager
{
	public class Models
	{		
		private static var views:Object={};
		
		public function Models()
		{

		}
		public static function registerView(viewName:String, view:Object):void
		{
			if (views[viewName] == null)
			{
				views[viewName]=view;
			}
			else
			{
				throw new Error(viewName+" 视图已被注册");
			}
		}
		public static function getView(viewName:String):Object
		{
			if (views[viewName] == null)
			{
				throw new Error(viewName+" 视图没有被注册");
			}
			else
			{
				return views[viewName];
			}
			return null;
		}

	}
}
