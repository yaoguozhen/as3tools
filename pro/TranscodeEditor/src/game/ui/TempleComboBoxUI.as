/**Created by Morn,Do not modify.*/
package game.ui {
	import morn.core.components.*;
	public class TempleComboBoxUI extends View {
		public var btn:Button;
		public var listBox:Box;
		public var list:FrameClip;
		public var scrollBar:VScrollBar;
		public var selectedFilesLabel:Label;
		private var uiXML:XML =
			<View>
			  <Button skin="png.comp.button_temple" x="0" y="0" var="btn" labelColors="0xb6b6b6,0xb6b6b6,0xb6b6b6" labelSize="12" width="202" height="30"/>
			  <Box x="2" y="30" var="listBox">
			    <FrameClip skin="assets.frameclip_templeComboboxItem" var="list" name="list" width="199" height="133.75" mouseChildren="true" mouseEnabled="true"/>
			    <VScrollBar skin="png.comp.vscroll" x="178" y="2" width="19" height="131" var="scrollBar"/>
			  </Box>
			  <Label text="label" x="5" y="6" color="0xb6b6b6" width="175" height="18" var="selectedFilesLabel"/>
			</View>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}