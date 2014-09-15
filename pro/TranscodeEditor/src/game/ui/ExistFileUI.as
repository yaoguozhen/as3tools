/**Created by Morn,Do not modify.*/
package game.ui {
	import morn.core.components.*;
	import transcode.view.ExistFileItemRender;
	public class ExistFileUI extends View {
		public var listBox:Box;
		public var listBG:Image;
		public var list:List;
		public var btn:Button;
		public var selectedFilesLabel:Label;
		private var uiXML:XML =
			<View>
			  <Box x="0" y="31" var="listBox">
			    <Image url="png.comp.comboboxbg" width="132" var="listBG" name="listBG"/>
			    <List x="6" y="2" repeatX="1" repeatY="5" var="list" name="list" spaceY="8">
			      <LabelItem name="render" runtime="transcode.view.ExistFileItemRender" buttonMode="true"/>
			      <VScrollBar skin="png.comp.vscroll" x="104" name="scrollBar" height="119" width="19" y="0"/>
			    </List>
			  </Box>
			  <Button skin="png.comp.button_exist_combobox" x="0" y="1" var="btn" name="btn" labelColors="0xb6b6b6,0xb6b6b6,0xb6b6b6"/>
			  <Label text="label" x="3" y="6" color="0xb6b6b6" width="104" height="18" var="selectedFilesLabel"/>
			</View>;
		override protected function createChildren():void {
			viewClassMap = {"LabelItem":ExistFileItemRender};
			createView(uiXML);
		}
	}
}