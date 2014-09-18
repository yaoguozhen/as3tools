package zhen.guo.yao.component.ylist
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import zhen.guo.yao.component.yscrollbar.YScrollBar;
	
	/**
	 * ...
	 * @author yaoguozhen
	 */
	public class YList extends EventDispatcher 
	{
		private var _itemClass:Class;//Item 的类名
		private var _lastItem;//上一个item。生成item时，用来按顺序排列
		private var _list:MovieClip;//list元件
		private var _itemContainer:Sprite;//item的容器
		
		private var _vScrollBar:YScrollBar;
		
		private var _selectedItem;
		
		public function YList():void
		{
			_itemClass = YListDefaultItem;
			
			_itemContainer = new Sprite();
			
			_vScrollBar = new YScrollBar();
			_vScrollBar.valueChangeHandler=vScrollBarValueChangeHandler;
		}
		private function itemContainerClickHandler(evn:MouseEvent):void
		{
			var item = evn.target;
			item.mouseAction(MouseEvent.CLICK);
			
			if ("selected" in item)
			{
			
			}
			else
			{
				trace("【警告】list 的 item 没有 selected 属性，将不能设置选中状态");
				return ;
			}
			
			if (_selectedItem)
			{
				if (_selectedItem == item)
				{
					
				}
				else
				{
					_selectedItem.selected = false;
					_selectedItem = item;
					_selectedItem.selected = true;
				}
			}
			else
			{
				_selectedItem = item;
				_selectedItem.selected = true;
			}
		}
		private function itemContainerMouseOverHandler(evn:MouseEvent):void
		{
			var item = evn.target;
			item.mouseAction(MouseEvent.ROLL_OVER);
		}
		private function itemContainerMouseOutHandler(evn:MouseEvent):void
		{
			var item = evn.target;
			item.mouseAction(MouseEvent.ROLL_OUT);
		}
		private function _setDataSource(data:Object):void
		{			
			/* 判断是否生成成功 */
			var creatSuccess:Boolean = creatItems(data);
			if (!creatSuccess)
			{
				return ;
			}
			
			/* 设置滚动条 */
			_vScrollBar.init(_list.vScrollBar, YScrollBar.V);
			var per:Number = _itemContainer.height / _list.listMask.height;
			var maxValue:Number = 0;
			var minValue:Number = 0;
			if (per > 1)
			{
				maxValue = _itemContainer.height - _list.listMask.height;
			}
			_vScrollBar.refresh(per, maxValue, minValue);
			
			/* 如果item没有mouseAction方法，则不监听鼠标事件 */
			if ("mouseAction" in _lastItem)
			{
				_itemContainer.addEventListener(MouseEvent.CLICK, itemContainerClickHandler);
				_itemContainer.addEventListener(MouseEvent.MOUSE_OVER, itemContainerMouseOverHandler);
				_itemContainer.addEventListener(MouseEvent.MOUSE_OUT, itemContainerMouseOutHandler);
			}
			else
			{
				trace("【警告】list 的 item 没有 mouseAction方法，将不能相应任何鼠标事件");
			}
		}
		private function creatItems(data:Object):Boolean
		{
			for each (var i in data)
			{
				var item = new _itemClass();
				if ("dataSource" in item)
				{
					item.dataSource = i;
				}
				else
				{
					throw new Error("【错误】list 的 item 没有 dataSource 方法，将不能显示数据");
					return false
				}
				
				item.mouseChildren = false;
				if (_lastItem)
				{
					item.y = _lastItem.y + _lastItem.height;
				}
				_lastItem = item;
				_itemContainer.addChild(item);
			}
			
			return true;
		}
		private function vScrollBarValueChangeHandler(value:Number):void
		{
			_itemContainer.y = _list.listMask.y - value;
		}
		
		/**
		 * 初始化list
		 * @param	skin list的mc
		 */
		public function  init(skin:MovieClip):void
		{
			_list = skin;
			
			_list.addChild(_itemContainer);
			_itemContainer.x = _list.listMask.x;
			_itemContainer.y = _list.listMask.y;
			
			_itemContainer.mask = _list.listMask;
		}
		/**
		 * 添加数据。
		 * 默认数据类型：
		 *     array：[[label,value],[label,value],。。。。。]
		 *     xmlList: <item label="" value=""/><item label="" value=""/>......
		 *     json: [{label:1,value:1},{label:2,value:2}......]
		 */
		public function set dataSource(data:Object):void
		{
			_setDataSource(data);
		}
		/**
		 * 自定义item渲染
		 * 1. 必须是显示对象
		 * 2. 必须有如下接口
		 *     function set dataSource(data:Object):void 设置数据
		 *     function set selected(b:Boolean):void 设置是否选中
		 *     function mouseAction(action:String):void 设置鼠标动作
		 *     function resize(w:Number):void 需要重设宽度时，设置宽度
		 */
		public function set itemRender(itemClass:Class):void
		{
			_itemClass = itemClass;
		}
		/**
		 * 当前选中的item
		 */
		public function get selectedItem():void
		{
			return _selectedItem;
		}
	}
	
}