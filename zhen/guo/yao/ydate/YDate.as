package zhen.guo.yao.ydate
{
	public class YDate 
	{
		/*
		private static function checkDate(sDate:String, eDate:String):Boolean
		{
			if (sDate.length != eDate.length)
			{
				return false;
			}
			else
			{
				var startDate:Date = YDate.getDateByString(sDate);
				var endDate:Date = YDate.getDateByString(eDate);
				if (startDate >= endDate)
				{
					return false;
				}
			}
			
			return true
		}
		*/
		/**
		 * 检查是否小于10，如果是，则补上0
		 */
		private static function formatStr(str:String):String
		{
			if(str.length==1)
			{
				return "0"+str;
			}
			return str;
		}
		/*-----------------------------------------------------------------------------------------------------------------------公开方法-----------------*/
		/**
		 * 将字符格式日期转化为Date类型
		 * @param date 字符格式的日期
		 * @param symbol 分隔符
		 * @return  Date类型
		 */
		public static function getDateByString(date:String,symbol:String):Date
		{
			var array:Array = date.split(symbol);
			var newDate:Date;
			switch (array.length)
			{
				case 1:
					newDate = new Date(array[0],0,1);
					break;
				case 2:
					newDate = new Date(array[0], array[1]-1);
					break;
				case 3:
					newDate = new Date(array[0], array[1]-1, array[2]);
					break;	
			}
			return newDate;
		}
		/*
		//将Date格式日期生成为字符格式
		public static function getStringFormat(d:Date,changePart:String):String
		{
			var year:String=String(d.getFullYear());
			var month:String=formatStr(String(d.getMonth()+1));
			var date:String = formatStr(String(d.getDate()));
			
			switch(changePart)
			{
				case "d":
					return year + "-" + month + "-" + date;
					break;
				case "m":
					return year + "-" + month;
					break;	
				case "y":
					return year;
					break;	
			}
			return "wrong date";
		}
		*/
		/**
		 * 获得经过格式化的时间
		 * @param	time 以毫秒为单位的时间
		 * @param	long 是否强制返回带小时的时间格式。默认如果不足1小时，则返回"00:00"形式
		 * @return  经过格式化的时间
		 */
		public static function getStringTime(time:Number,long:Boolean=false):String
		{
			var f:String = "00:00:00";
			if (time >= 0)
			{
				time /= 1000;
				
				var h:String = formatStr(String(int(time / 3600)));
				var m:String = formatStr(String(int((time - Number(h) * 3600) / 60)));
				var s:String = formatStr(String(int(time - Number(h) * 3600 - Number(m) * 60)));
				
				if (long || h != "00")
				{
					f = h + ":" + m + ":" + s;
				}
				else
				{
					f=m + ":" + s;
				}
			}
			return f;
		}
		/**
		 * 返回字符形式的当前是时间
		 * 1  xxxx年xx月xx日 xx时xx分xx秒
		 * 2  xxxx年xx月xx日
		 * 3  xx时xx分xx秒
		 * 4  xxxx-xx-xx xx:xx:xx
		 * 5      年-月-日
		 * 6      时:分:秒
		 * @param	dateType 时间形式
		 * @return  字符形式的当前是时间
		 */
		public static function getCurrentStringDate(dateType:String):String
		{
			var myDate:Date=new Date();
			var year:String=String(myDate.getFullYear());
			var month:String=formatStr(String(myDate.getMonth()+1));
			var date:String=formatStr(String(myDate.getDate()));
			var hour:String=formatStr(String(myDate.getHours()));
			var minitus:String=formatStr(String(myDate.getMinutes()));
			var second:String=formatStr(String(myDate.getSeconds()));

			switch(dateType)
			{
				case "1":
					return year+"年"+month+"月"+date+"日"+" "+hour+"时"+minitus+"分"+second+"秒";
				    break;
				case "2":
				    return year+"年"+month+"月"+date+"日";
				    break;
				case "3":
				    return hour+"时"+minitus+"分"+second+"秒";
				    break;
				case "4":
				    return year+"-"+month+"-"+date+" "+hour+":"+minitus+":"+second;
				    break;
				case "5":
				    return year+"-"+month+"-"+date;
				    break;
				case "6":
				    return hour+":"+minitus+":"+second;
				    break;
			}
			return ""
		}
		/**
		 * 
		 * @param	sDate 起始日期
		 * @param	eDate 结束日期
		 * @param	changePart 变化的部分 d，m，y
		 * @return
		 */
		/*
		public static function getDataSet(sDate:String, eDate:String):Array
		{
			if (checkDate(sDate, eDate))
			{
				var dateSet:Array = [];
				
				//判断变化的部分
				var changePart:String
				var array:Array = sDate.split("-");
				switch (array.length)
				{
					case 1:
						changePart = "y";
						break;
					case 2:
						changePart = "m";
						break;
					case 3:
						changePart = "d";
						break;	
				}
				
				//将字符格式日期转化为Date类型
				var startDate:Date = YDate.getDateFormat(sDate);
				var endDate:Date = YDate.getDateFormat(eDate);
				
				//计算间隔数量
				var count:uint
				switch(changePart)
				{
					case "d":
						count = (Number(endDate) - Number(startDate)) / 1000 / 60 / 60 / 24 - 1;
						break;
					case "m":
						count = (Number(endDate) - Number(startDate)) / 1000 / 60 / 60 / 24 / 30 - 1;
						break;	
					case "y":
						count = (Number(endDate) - Number(startDate)) / 1000 / 60 / 60 / 24 / 30 / 12 - 1;
						break;	
				}
				//将日期添加入数组
				dateSet.push(sDate);
				for (var i:uint = 0; i < count; i++)
				{
					switch(changePart)
					{
						case "d":
							startDate.date += 1;
							break;
						case "m":
							startDate.month += 1;
							break;	
						case "y":
							startDate.fullYear += 1;
							break;	
					}
					dateSet.push(YDate.getStringFormat(startDate,changePart));
				}
				dateSet.push(eDate);
				
				return dateSet;
			}
			else
			{
				return [];
			}
			return [];
		}
		*/
	}
	
}