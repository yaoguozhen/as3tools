/**Created by Morn,Do not modify.*/
package game.ui {
	import morn.core.components.*;
	import transcode.view.ExistFileComboBox;
	import transcode.view.TempleComboBox;
	public class SelectVideoUI extends View {
		public var sectionCheckBox:CheckBox;
		public var radiogroup_0:RadioButton;
		public var radiogroup_1:RadioButton;
		public var templeComboBox:TempleComboBox;
		public var existFileComboBox:ExistFileComboBox;
		private var uiXML:XML =
			<View>
			  <CheckBox label="切片转码" skin="png.comp.checkbox" x="649" y="10" labelColors="0xb6b6b6,0xffffff,0xffffff" var="sectionCheckBox" name="sectionCheckBox"/>
			  <RadioButton label="选择文件" skin="png.comp.radio" labelColors="0xb6b6b6,0xffffff,0xffffff" value="0" name="radiogroup_0" x="1" y="6" var="radiogroup_0"/>
			  <RadioButton label="已有视频" skin="png.comp.radio" x="83" labelColors="0xb6b6b6,0xffffff,0xffffff" value="1" name="radiogroup_1" y="6" var="radiogroup_1"/>
			  <TempleComboBox x="433" y="3" runtime="transcode.view.TempleComboBox" var="templeComboBox"/>
			  <ExistFile x="166" y="1" runtime="transcode.view.ExistFileComboBox" var="existFileComboBox"/>
			</View>;
		override protected function createChildren():void {
			viewClassMap = {"ExistFile":ExistFileComboBox,"TempleComboBox":TempleComboBox};
			createView(uiXML);
		}
	}
}