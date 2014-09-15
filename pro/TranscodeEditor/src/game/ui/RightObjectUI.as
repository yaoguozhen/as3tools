/**Created by Morn,Do not modify.*/
package game.ui {
	import morn.core.components.*;
	public class RightObjectUI extends View {
		public var preMsg:View;
		public var downloadBtn:Button;
		public var lightNumBox:Box;
		public var lightNum1:Label;
		public var lightNum2:Label;
		public var lightNum3:Label;
		public var lightNum4:Label;
		public var lightNum5:Label;
		public var light1:Button;
		public var light2:Button;
		public var light3:Button;
		public var light4:Button;
		public var light5:Button;
		public var cannotPreviewBox:Box;
		public var cannotPreviewLabel:Label;
		public var preBox:Box;
		public var videoPreviewLabel:Label;
		public var videoIndex:Label;
		private var uiXML:XML =
			<View var="preMsg">
			  <Image url="png.comp.rightobject" x="0" y="0"/>
			  <Button skin="png.comp.button_download" x="211" y="202" var="downloadBtn"/>
			  <Box x="63" y="31" var="lightNumBox" mouseChildren="false" mouseEnabled="false">
			    <Label text="1" x="2" color="0xffb4" size="18" var="lightNum1"/>
			    <Label text="2" x="16" y="39" color="0xffb4" size="18" var="lightNum2"/>
			    <Label text="3" x="20" y="80" color="0xffb4" size="18" var="lightNum3"/>
			    <Label text="4" x="15" y="121" color="0xffb4" size="18" var="lightNum4"/>
			    <Label text="5" y="163" color="0xffb4" size="18" var="lightNum5"/>
			  </Box>
			  <Button skin="png.comp.button_1" x="40" y="25" var="light1" name="light1"/>
			  <Button skin="png.comp.button_2" x="61" y="65" var="light2" name="light2"/>
			  <Button skin="png.comp.button_3" x="72" y="105" var="light3" name="light3"/>
			  <Button skin="png.comp.button_4" x="60" y="146" var="light4" name="light4"/>
			  <Button skin="png.comp.button_5" x="37" y="187" var="light5" name="light5"/>
			  <Box x="139" y="28" var="cannotPreviewBox">
			    <Label text="该格式视频不支持预览" color="0xffffff" size="14" bold="false" var="cannotPreviewLabel" x="1" y="112"/>
			    <Image url="png.comp.tanhao"/>
			  </Box>
			  <Box x="144" y="56" var="preBox">
			    <Image url="png.comp.preimage" x="26"/>
			    <Label text="Video Preview" x="41" y="85" color="0xffffff" size="14" var="videoPreviewLabel"/>
			    <Label text="NO.1" y="85" color="0xffffff" bold="true" size="14" var="videoIndex"/>
			  </Box>
			</View>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}