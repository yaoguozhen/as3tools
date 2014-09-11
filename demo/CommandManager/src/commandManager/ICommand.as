package commandManager 
{
    public interface ICommand
	{
        function execute(paramObj:Object=null):void;
    }
}
