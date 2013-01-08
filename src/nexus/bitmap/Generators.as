package nexus.bitmap {
	import nexus.math.Math2;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Thomas Versteeg, 2012
	 */
	public final class Generators {
		
		/**
		 * Generates a cave to the bitmapData using perlinNoise
		 * @param	bmd the bitmapData the cave is generated with
		 * @param	currentPart the current percentage the cave is loaded, it is fully loaded when it is hundred
		 * @param	percentPart the size of each percentage part when it is loading
		 * @param 	numPoints the number of random objects that are spawned
		 * @param	mapSize the amount of details the cave has
		 * @param	borderSize the size of the edges
		 * @param	offset a higher color means more gaps and a lower color means less
		 * @return	returns a boolean, which is true when the cave is complete, and false when it's not
		 */
		public static function cave(bmd:BitmapData, currentPart:int = 100, percentPart:int = 100, numPoints:int = 20, mapSize:int = 5, borderSize:int = 2, offset:uint = 0xFF200000):Boolean {
			var seed:Number = Math2.random(10000);
			
			var p:Point = new Point(int(Math2.random(bmd.width)), int(Math2.random(bmd.height)));
			var r:Rectangle = bmd.getColorBoundsRect(0xFFFFFFFF, 0xFFFF0000);
			
			var exitSecond:int = 0, exitFirst:int = 0;
			var exitParts:int = percentPart * 200;
			
			var tw:Number = bmd.width - borderSize * 2
			var th:Number = bmd.height - borderSize * 2
			
			var tmpBmd:BitmapData = bmd.clone();
			tmpBmd.threshold(bmd, bmd.rect, new Point(0, 0), "!=", 0xFFFF0000, 0, 0xFFFFFFFF);
			var tmpBmd2:BitmapData = bmd.clone();
			tmpBmd2.threshold(bmd, bmd.rect, new Point(0, 0), "!=", 0xFF0000FF, 0, 0xFFFFFFFF);
			
			var ptx:int = bmd.width - borderSize;
			var pty:int = bmd.height * (percentPart / 100);
			var pty2:int = bmd.height * (currentPart / 100)
			
			bmd.lock();
			
			while ((r.width < tw || r.height < th) && exitSecond < 100) {
				
				bmd.perlinNoise(mapSize, mapSize, 1, Math2.random(100000), true, false, 7, true);
				bmd.threshold(bmd, bmd.rect, new Point(), "<", offset, 0xFF00FFFF);
				
				exitFirst = 0;
				
				while (bmd.getPixel32(p.x, p.y) != 0xFF00FFFF && exitFirst < 10) {
					p.x = int(Math2.random(ptx) + borderSize);
					p.y = int(Math2.random(pty) + pty2 + borderSize);
					exitFirst++;
				}
				
				bmd.floodFill(p.x, p.y, 0xFFFF0000);
				
				r = bmd.getColorBoundsRect(0xFFFFFFFF, 0xFFFF0000);
				exitSecond++;
			}
			
			bmd.draw(tmpBmd2);
			bmd.draw(tmpBmd);
			tmpBmd.dispose();
			
			var i:int = 0, j:int;
			exitSecond = 0;
			var exitThird:int = 0;
			while (i < numPoints && exitSecond < 100) {
				while (bmd.getPixel32(p.x, p.y) != 0xFFFF0000 && bmd.getPixel32(p.x, p.y-1)!= 0xFF00FFFF && exitThird < 100) {
					p.x = int(Math2.random(bmd.width));
					p.y = int(Math2.random(pty) + pty2 + borderSize);
					exitThird++;
				}
				bmd.setPixel32(p.x, p.y, 0xFF0000FF);
				i++;
				exitSecond++;
			}
			
			bmd.unlock();
			
			if (currentPart != 100) {
				return false;
			}
			
			bmd.threshold(bmd, bmd.rect, new Point(), "==", 0xFFFF0000, 0, 0xFFFFFFFF, true);
			return true;
		}
		
		public static function world(bmd:BitmapData, seed:int, scale:Number = 100, offset1:uint = 50, offset2:uint = 100):void {
			var color1:uint = (0xFF) << 24 | offset1 << 16 | offset1 << 8 | offset1;
			var color2:uint = (0xFF) << 24 | offset2 << 16 | offset2 << 8 | offset2;
			bmd.lock();
			bmd.perlinNoise(scale, scale, 3, seed, false, false, 7, true);
			bmd.threshold(bmd, bmd.rect, new Point(), "<=", color1, 0xFFFF0000, 0xFFFFFFFF, true)
			bmd.threshold(bmd, bmd.rect, new Point(), "<=", color2, 0xFF00FF00, 0xFFFFFFFF, true)
			bmd.threshold(bmd, bmd.rect, new Point(), ">", (0xFFFFFF) & offset2, 0xFF0000FF, 0x000000FF, true)
			bmd.unlock();
		}
		
		/**
		 * Fast line generator, based on EFLA: http://www.simppa.fi/blog/extremely-fast-line-algorithm-as3-optimized/
		 * @param	x
		 * @param	y
		 * @param	x2
		 * @param	y2
		 * @param	color
		 * @param	bmd
		 */
		public static function fastLine(x:int, y:int, x2:int, y2:int, color:uint, bmd:BitmapData):void{
			var shortLen:int = y2-y;
			var longLen:int = x2-x;
 
			if ((shortLen ^ (shortLen >> 31)) - (shortLen >> 31) > (longLen ^ (longLen >> 31)) - (longLen >> 31)){
				shortLen ^= longLen;
				longLen ^= shortLen;
				shortLen ^= longLen;
 
				var yLonger:Boolean = true;
			}else{
				yLonger = false;
			}
 
			var inc:int = longLen < 0 ? -1 : 1;
			var multDiff:Number = longLen == 0 ? shortLen : shortLen / longLen;
 
			if (yLonger){
				for (var i:int = 0; i != longLen; i += inc)
				{
					bmd.setPixel(x + i*multDiff, y+i, color);
				}
			}else{
				for (i = 0; i != longLen; i += inc){
					bmd.setPixel(x+i, y+i*multDiff, color);
				}
			}
		}
		
		public static function fastLine32(x:int, y:int, x2:int, y2:int, color:uint, bmd:BitmapData):void{
			var shortLen:int = y2-y;
			var longLen:int = x2-x;
 
			if ((shortLen ^ (shortLen >> 31)) - (shortLen >> 31) > (longLen ^ (longLen >> 31)) - (longLen >> 31)){
				shortLen ^= longLen;
				longLen ^= shortLen;
				shortLen ^= longLen;
 
				var yLonger:Boolean = true;
			}else{
				yLonger = false;
			}
 
			var inc:int = longLen < 0 ? -1 : 1;
			var multDiff:Number = longLen == 0 ? shortLen : shortLen / longLen;
 
			if (yLonger){
				for (var i:int = 0; i != longLen; i += inc)
				{
					bmd.setPixel32(x + i*multDiff, y+i, color);
				}
			}else{
				for (i = 0; i != longLen; i += inc){
					bmd.setPixel32(x+i, y+i*multDiff, color);
				}
			}
		}
		
	}

}