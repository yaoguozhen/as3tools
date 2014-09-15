/**Created by Morn,Do not modify.*/
package game.ui {
	import morn.core.components.*;
	public class BallUI extends View {
		public var times:Box;
		public var videoDuration:Label;
		public var useTime:Label;
		public var doing:FrameClip;
		public var doPer:Label;
		public var firstLabel:Image;
		private var uiXML:XML =
			<View font="黑体">
			  <Image url="png.comp.ball" x="0" y="0"/>
			  <Box x="81" y="63" visible="false" var="times">
			    <Label text="00:00:00" y="37" color="0xffffff" size="40" var="videoDuration" font="Arial"/>
			    <Label text="00:00:00" y="127" color="0xffffff" size="40" var="useTime" x="0" font="Arial"/>
			    <Image url="png.comp.sucaishichang" x="31"/>
			    <Image url="png.comp.zhuanmahaoshi" x="33" y="91"/>
			  </Box>
			  <FrameClip skin="assets.frameclip_circle" x="1" y="1" visible="true" var="doing" autoPlay="false"/>
			  <Label text="0%" x="114" y="271" var="doPer" color="0x87fc09" size="22" align="center" autoSize="center"/>
			  <Image url="png.comp.balllabel" x="75" y="124" var="firstLabel"/>
			</View>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}