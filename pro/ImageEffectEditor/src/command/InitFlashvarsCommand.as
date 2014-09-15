package command {
    
    import mvc.*;

    /**
     * 
     * @author .....Li灬Star
     */
    public class InitFlashvarsCommand extends Command implements ICommand {

        private var appMain:ImageEffectEditor;

		/**
		 * 
		 * @param type
		 * @param obj
		 */
		public function execute(type:String, obj:Object=null):void{
			if(obj){
				appMain =obj.app;
				Root.init(appMain.stage, appMain.root.loaderInfo, appMain);
				
				sendNotification("initViewCommand"); 
			}
        }
    }
}
