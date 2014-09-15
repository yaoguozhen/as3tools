/**Created by Morn,Do not modify.*/
package game.ui {
	import morn.core.components.*;
	public class LabelItemUI extends View {
		public var item:Label;
		private var uiXML:XML =
			<View>
			  <Label text="label1111111111111111111111111" x="0" y="0" var="item" color="0xb6b6b6" buttonMode="true" width="102" height="18"/>
			</View>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}