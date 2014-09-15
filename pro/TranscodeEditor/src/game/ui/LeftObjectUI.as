/**Created by Morn,Do not modify.*/
package game.ui {
	import morn.core.components.*;
	public class LeftObjectUI extends View {
		public var msg:Box;
		public var videoDuration:Label;
		public var videoRate:Label;
		public var videoRatio:Label;
		public var videoCodeType:Label;
		public var audioCodeType:Label;
		public var lightBox:Box;
		private var uiXML:XML =
			<View font="Times New Roman">
			  <Image url="png.comp.leftobject" x="0" y="0"/>
			  <Box x="32" y="31" var="msg">
			    <Label text="label12333" x="158" color="0xffd200" size="18" var="videoDuration" stroke="0xf95000,0.2,5,5,10,60" font="Arial" y="1"/>
			    <Label text="label" x="138" y="41" size="18" color="0xffd200" var="videoRate" stroke="0xf95000,0.2,5,5,10,60" font="Arial"/>
			    <Label text="label" x="138" y="83" color="0xffd200" size="18" var="videoRatio" stroke="0xf95000,0.2,5,5,10,60" font="Arial"/>
			    <Label text="label" x="138" y="124" color="0xffd200" size="18" var="videoCodeType" stroke="0xf95000,0.2,5,5,10,60" font="Arial"/>
			    <Label text="label" x="158" y="166" color="0xffd200" size="18" var="audioCodeType" stroke="0xf95000,0.2,5,5,10,60" font="Arial"/>
			    <Box var="lightBox">
			      <Image url="png.comp.LightPoint" x="23"/>
			      <Image url="png.comp.LightPoint" x="7" y="40"/>
			      <Image url="png.comp.LightPoint" y="82"/>
			      <Image url="png.comp.LightPoint" x="7" y="125"/>
			      <Image url="png.comp.LightPoint" x="25" y="166"/>
			    </Box>
			  </Box>
			</View>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}