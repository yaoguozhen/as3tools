/**Created by Morn,Do not modify.*/
package game.ui {
	import morn.core.components.*;
	public class CheckBoxItemUI extends View {
		private var uiXML:XML =
			<View>
			  <Box x="2" y="2"/>
			</View>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}