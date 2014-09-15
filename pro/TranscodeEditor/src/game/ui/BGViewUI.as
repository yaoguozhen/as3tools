/**Created by Morn,Do not modify.*/
package game.ui {
	import morn.core.components.*;
	public class BGViewUI extends View {
		private var uiXML:XML =
			<View>
			  <Image url="png.comp.bg" x="0" y="0"/>
			</View>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}