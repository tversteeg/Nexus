package nexus.utils {
	import nexus.adobe.images.PNGEncoder;
	import nexus.bitmap.SpriteSheet;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Thomas Versteeg
	 */
	public class DebugSpriteSheet {
		
		public static function saveAsPNG(sheet:DisplayObject, position:String, width:int, height:int):void {
			var s:SpriteSheet = new SpriteSheet(sheet, position);
			var bmd:BitmapData = new BitmapData(width, height, false, 0xFF00FF);
			var maxX:int = 0, maxY:int = 0, goY:int = 0, size:Point = new Point();
			var i:int, l:int = s.getTotalSprites();
			var num:TextField = new TextField(), ct:ColorTransform = new ColorTransform(1, 1, 1, 0.75);
			var b:Bitmap, m:Matrix = new Matrix();
			num.textColor = 0x00FF00;
			for (i = 0; i < l; i++) {
				b = s.getBitmap(i);
				size = s.getSize(i);
				b.x = maxX;
				b.y = goY;
				if (size.x < 10) size.x = 10;
				if (size.y < 10) size.y = 10;
				maxX = Math.max(maxX, b.x + size.x + 1);
				maxY = Math.max(maxY, b.y + size.y + 1);
				if (maxX > width) {
					maxX = 0;
					b.x = 0;
					goY = maxY;
					b.y = maxY;
				}
				m.identity();
				m.tx = b.x;
				m.ty = b.y;
				bmd.draw(b, m);
				
				num.text = i.toString();
				bmd.draw(num, m, ct);
			}
			var byte:ByteArray = PNGEncoder.encode(bmd);
			var fr:FileReference = new FileReference();
			fr.save(byte, "debug.png");
		}
		
	}

}