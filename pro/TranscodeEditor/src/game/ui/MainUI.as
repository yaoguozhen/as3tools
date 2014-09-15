/**Created by Morn,Do not modify.*/
package game.ui {
	import morn.core.components.*;
	import game.ui.BallUI;
	import game.ui.LeftObjectUI;
	import game.ui.RightObjectUI;
	import game.ui.SelectVideoUI;
	import game.ui.StartBtnUI;
	import game.ui.TransTemplateUI;
	import game.ui.aaUI;
	public class MainUI extends View {
		private var uiXML:XML =
			<View width="1002" height="613">
			  <aa x="20" y="27"/>
			  <Image url="png.comp.bg" x="0" y="0"/>
			  <SelectVideo x="234" y="25"/>
			  <TransTemplate x="678" y="26"/>
			  <LeftObject x="38" y="151.5"/>
			  <RightObject x="602" y="151.5"/>
			  <Ball x="339" y="115"/>
			  <StartBtn x="430" y="463"/>
			</View>;
		override protected function createChildren():void {
			viewClassMap = {"Ball":BallUI,"LeftObject":LeftObjectUI,"RightObject":RightObjectUI,"SelectVideo":SelectVideoUI,"StartBtn":StartBtnUI,"TransTemplate":TransTemplateUI,"aa":aaUI};
			createView(uiXML);
		}
	}
}