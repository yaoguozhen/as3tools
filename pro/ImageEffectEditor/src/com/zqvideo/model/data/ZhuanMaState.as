package com.zqvideo.model.data
{
	public class ZhuanMaState
	{
		public static const ToTransCode:int=1; //转码中
		public static const FinishTransCode:int=2; //已转码
		public static const FastCoding:int=3; //快编中
		public static const FastCoded:int=4; //已快编
		
		public static const Synthesis:int=5; //合成中
		public static const Synthesized:int=6; //已合成
		public static const ToAuidt:int=7; //待审核
		public static const AuidtFail:int=8; //未通过
		public static const toPublish:int=9; //待发布
		public static const Published:int=10; //已发布
		
		public static const FailTransCode:int=11; //转码失败
		public static const FailFastCoded:int=12; //快编失败
		public static const FailSynthesized:int=13; //合成失败
		public static const FastCodedTransCoding:int=14; //快编转码中
		public static const SynthesisTransCoding:int=15; //合成转码中
		
		public static const Regained:int=16; //已下架
		public static const Matted:int=17; //抠像过
		public static const NotMatted:int=18; //未抠像过
		public static const ImgToVideoWaiting:int=19; //等待视频合成
		public static const ImgToVideoTransCoding:int=20; //等待转码
		public static const ImgToVideoFail:int=21; //视频合成失败
		public static const PublishedNow:int=22; //发布中
		public static const RegainedNow:int=23; //下架中
		public static const PublishedFail:int=24; //发布失败
		public static const RegainedFail:int=25; //下架失败
		
		
		public static  var alertObj:Object={};
		
		public function ZhuanMaState()
		{
			
		}
		
	}
}