package  zhen.guo.yao.yeventmanager 
{
        import flash.events.IEventDispatcher;
        /**
         * 事件管理类
         * @author Robin
         */
        public class YEventManager 
        {
                private static var _list:Array = [];

                /**
                 * 添加监听事件
                 * @param target 监听对象
                 * @param eventType 监听事件
                 * @param listener 监听器
                 */
                public static function addEventListener(target:IEventDispatcher, eventType:String, listener:Function):void
                {
					if (target&&listener&&eventType&&eventType.length>0)
                    {
						// 首先判断对象是否给该事件添加过该监听器,
						// 如果添加过，则忽略，
						// 否则添加
						var n:uint = _list.length;
						var hasAdded:Boolean = false;
						for (var i:int = 0; i < n;i++ )
						{
							var item:EventModel = _list[i];
							if (item)
							{
								if (item.target == target && item.eventType == eventType && item.listener == listener)
								{
									hasAdded = true;
									return;
								}
							}
						}
						//如果没有添加过
						if (hasAdded == false)
						{
							var eventMode:EventModel = new EventModel(target, eventType, listener);
							target.addEventListener(eventType,listener,false,0,true)
							_list.push(eventMode);
						}
					}
                }
                
                /**
                 * 删除监听事件
                 * @param target 监听对象
                 * @param eventType 监听事件
                 * @param listener 监听器
                 */
                public static function removeEventListener(target:IEventDispatcher, eventType:String, listener:Function):void
                {
					var n:uint = _list.length;
                    for (var i:int =0; i <n; i++ )
                    {
                        var item:EventModel = _list[i];
                        if (item)
                        {
                            if (item.target == target && item.eventType == eventType && item.listener == listener)
                            {
                                if (item.target)
                                {
                                    item.target.removeEventListener(item.eventType, item.listener);
                                    _list.splice(i, 1);
                                    break;
                                }
                            }
                        }
					}
				}
                
                /**
                 * 删除指定对象的所有监听事件
                 * @param target 制定对象
                 */
                public static function removeTargetAllEventListener(target:IEventDispatcher):void
                {
					    var n:uint = _list.length - 1;
                        for (var i:int = n; i >= 0; i-- )
                        {
                                var item:EventModel = _list[i];
                                if (item)
                                {
                                        if (item.target == target)
                                        {
                                                if (item.target)
                                                {
                                                        item.target.removeEventListener(item.eventType, item.listener);
                                                }
                                                _list.splice(i, 1);
												item.dispose();
												item = null;
                                        }
                                }
                        }
                }
                
                /**
                 * 删除所有监听事件
                 */
                public static function removeAllEventListener():void
                {
                        if (_list == null) 
                        {
                                return;
                        }
                        while (_list.length > 0)
                        {
                                var item:EventModel = _list.shift();
                                if (item)
                                {
                                        var target:IEventDispatcher = item.target;
                                        var eventType:String = item.eventType;
                                        var listener:Function = item.listener;
                                        target.removeEventListener(eventType, listener);
                                        item.dispose();
                                        item = null;
                                }
                        }
                }
                /**
                 * 对象被销毁时，调用该方法
                 */
                public static function dispose():void
                {
                        removeAllEventListener();
                        _list = null;
                }
                
        }

}

import flash.events.IEventDispatcher;

class EventModel 
{
        private var _target:IEventDispatcher;
        private var _eventType:String;
        private var _listener:Function;
        
        public function EventModel(target:IEventDispatcher, eventType:String, listener:Function) {
                _target = target;
                _eventType = eventType;
                _listener = listener;
        }
        
        public function get target():IEventDispatcher
        {
                return _target;
        }
        
        public function get eventType():String
        {
                return _eventType;
        }
        
        public function get listener():Function
        {
                return _listener;
        }
        
        public function dispose():void
        {
                _target = null;
                _eventType = null;
                _listener = null;
        }
}