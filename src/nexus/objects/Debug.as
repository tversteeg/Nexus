package nexus.shapes {
	import nexus.math.Vector2;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Thomas Versteeg Et Al, 2012
	 */
	public class Debug extends Sprite{
		
		/**
		 * Create a debug class which can draw the
		 * shapes and collisions
		 */
		public function Debug() {
			
		}
		
		public function clear():void {
			graphics.clear();
		}
		
		/**
		 * Draws a box on the sprite
		 * @param	box the box you want to draw, it uses the transformed points
		 * @param	collided when collided is true draw the box red
		 * @param	withAABB draw the outer box when this is true
		 */
		public function drawBox(box:Box, collided:Boolean = false, withAABB:Boolean = false):void {
			if(!collided){
				graphics.lineStyle(1, 0xAAFFAA, 1);
				graphics.beginFill(0xAAFFAA, 0.3);
			}else {
				graphics.lineStyle(1, 0xFFAAAA, 1);
				graphics.beginFill(0xFFAAAA, 0.3);
			}
			var l:Vector.<Vector2> = box.list;
			var cl:Vector.<Vector2> = box.centerList;
			graphics.moveTo(l[0].x, l[0].y);
			graphics.lineTo(l[1].x, l[1].y);
			graphics.lineTo(l[2].x, l[2].y);
			graphics.lineTo(l[3].x, l[3].y);
			graphics.lineTo(l[0].x, l[0].y);
			graphics.endFill();
			graphics.lineTo(l[2].x, l[2].y);
			graphics.moveTo(l[1].x, l[1].y);
			graphics.lineTo(l[3].x, l[3].y);
			
			graphics.lineStyle(1, 0xFFAAAA, 1);
			graphics.moveTo(cl[0].x, cl[0].y);
			graphics.lineTo(cl[2].x, cl[2].y);
			graphics.moveTo(cl[1].x, cl[1].y);
			graphics.lineTo(cl[3].x, cl[3].y);
			
			if (withAABB) {
				graphics.lineStyle(1, 0, 0.25);
				graphics.moveTo(box.upperBound.x, box.upperBound.y);
				graphics.lineTo(box.lowerBound.x, box.upperBound.y);
				graphics.lineTo(box.lowerBound.x, box.lowerBound.y);
				graphics.lineTo(box.upperBound.x, box.lowerBound.y);
				graphics.lineTo(box.upperBound.x, box.upperBound.y);
			}
		}
		
		/**
		 * Draws a list of boxes
		 * @param	the full list of boxes, the order doesn't matter
		 * @param	withAABB draw the outer box when this is true
		 */
		public function drawBoxList(list:Vector.<Box>, withAABB:Boolean = false):void {
			var i:int;
			var l:int = list.length;
			var b:Box;
			for (i = 0; i < l; i++) {
				b = list[i];
				if(b.collidable && b.active){
					drawBox(b, b.collided, withAABB);
				}
			}
		}
		
	}

}