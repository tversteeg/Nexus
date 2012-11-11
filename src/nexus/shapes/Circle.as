package nexus.shapes {
	import nexus.interfaces.IMapAble;
	import nexus.math.Vector2;
	
	/**
	 * ...
	 * @author Thomas Versteeg, 2012
	 */
	public class Circle extends Box implements IMapAble {
		
		private var _r:Number; //Radius
		
		public function Circle(x:Number=0, y:Number=0, width:Number=0, height:Number=0, rotation:Number=0) {
			super(x, y, width, height, rotation);
			
		}
		
		public function set radius(r:Number):void {
			_r = r;
		}
		public function get radius():Number {
			return _r;
		}
		
	}

}