package zhen.guo.yao.yshapecreater  
{
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author t
	 */
	public class YShapeCreater 
	{
		/************
		 * 生成矩形
		 * @param w 矩形宽
		 * @param h 矩形高
		 * @param fillColor 填充色
		 * @param fillAlpha 透明度
		 * @param frameThickness 边框宽度
		 * @param frameColor 边框颜色
		 * *********/
		public static function creatRect(w:Number,h:Number, fillColor:Number=0xff0000,fillAlpha:Number=1,frameThickness:Number=0,frameColor:Number=0x000000):Sprite
		{
			var sprite:Sprite = new Sprite();
			if (frameThickness > 0)
			{
				sprite.graphics.lineStyle(frameThickness, frameColor);
			}
			sprite.graphics.beginFill(fillColor,fillAlpha);
			sprite.graphics.drawRect(0, 0, w, h);
			return sprite;
		}
		/************
		 * 生成圆形
		 * @param r 圆形半径
		 * @param fillColor 填充色
		 * @param fillAlpha 透明度
		 * @param frameThickness 边框宽度
		 * @param frameColor 边框颜色
		 * *********/
		public static function creatCircle(r:Number, fillColor:Number=0xff0000,fillAlpha:Number=1,frameThickness:Number=0,frameColor:Number=0x000000):Sprite
		{
			var sprite:Sprite = new Sprite();
			if (frameThickness > 0)
			{
				sprite.graphics.lineStyle(frameThickness, frameColor);
			}
			sprite.graphics.beginFill(fillColor,fillAlpha);
			sprite.graphics.drawCircle(0,0,r);
			return sprite;
		}
		/********************
		* 生成扇形
		* @param r 半径
		* @param angle 扇形角度
		* @param startAngle 起始角度
		* @param fillColor 填充颜色
		* @param frameColor 边框颜色
		********************/
		public static function creatSector(r:Number,angle:Number,startAngle:Number=0,fillColor:Number=0x000000,frameColor:Number=0x000000):Sprite 
		{
			var mc:Sprite=new Sprite()
			mc.graphics.beginFill(fillColor,50);
   			mc.graphics.lineStyle(0,frameColor);
    		mc.graphics.moveTo(0,0);
    		angle=(Math.abs(angle)>360)?360:angle;
    		var n:Number=Math.ceil(Math.abs(angle)/45);
    		var angleA:Number=angle/n;
    		angleA=angleA*Math.PI/180;
    		startAngle=startAngle*Math.PI/180;
    		mc.graphics.lineTo(0+r*Math.cos(startAngle),0+r*Math.sin(startAngle));
    		for (var i=1; i<=n; i++)
			{
        		startAngle+=angleA;
        		var angleMid=startAngle-angleA/2;
        		var bx=0+r/Math.cos(angleA/2)*Math.cos(angleMid);
        		var by=0+r/Math.cos(angleA/2)*Math.sin(angleMid);
        		var cx=0+r*Math.cos(startAngle);
        		var cy=0+r*Math.sin(startAngle);
        		mc.graphics.curveTo(bx,by,cx,cy);
    		}
    		if (angle!=360) 
			{
        		mc.graphics.lineTo(0,0);
    		}
    		mc.graphics.endFill();
    		return mc
		}
	}

}