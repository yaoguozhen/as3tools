package mvc {

    /**
     * 
     * @author .....Li灬Star
     */
    public interface ICommand {

        function execute(type:String, obj:Object=null):void;

    }
}
