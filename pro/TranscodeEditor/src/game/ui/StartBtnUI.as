/**Created by Morn,Do not modify.*/
package game.ui {
	import morn.core.components.*;
	public class StartBtnUI extends View {
		public var startBtn:Button;
		public var pointBtn:Button;
		private var uiXML:XML =
			<View>
			  <Button skin="png.comp.button_start" x="0" y="0" var="startBtn"/>
			  <Button skin="png.comp.button_point" x="0" y="0" var="pointBtn"/>
			</View>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}