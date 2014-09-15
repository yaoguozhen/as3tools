package com.zqvideo.model.data
{
	public class LanguageParser
	{
		
		public function LanguageParser()
		{
			
		}
		
		public static function init():void{
			Root.LANGUAGE_DATA={
				flashVarsGetLose:["flashvars参数获取失败！"],
				JSCallLose:["JS Call通讯失败！"],
				configDataGetLose:["config文件获取失败！"],
				configDataGetSucceed:["config文件获取成功！"],
				configDataWarn:["config数据格式有错！"],
				assetsGetSucceed:["素材获取成功！"],
				assetsGetLose:["资源素材获取失败！"],
				homePageImageGetLose:["首页图片数据获取失败！"],
				editorPageImageGetLose:["编辑页面图片数据获取失败！"],
				sucaiPublishGetLose:["发布的素材数据获取失败！"],
				mustTwoImage:["请添加图片！"],
				selectMaxWarn:["对不起，最多只能选择6张图片！"],
				selectMinWarn:["请至少选择1张图片！"],
				effectSelectedWarn:["对不起，最多只能选择5个特效！"],
				imageLoadError:["图片加载错误！"],
				swfLoadError:["特效加载错误！"],
				sendSucceed:["恭喜您，生成成功！"],
				sendShiBai:["对不起，生成失败！"]
			};
			
		}
	}
}