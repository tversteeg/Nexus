package com.collision {
	import com.math.Vector2;
	/**
	 * ...
	 * @author Thomas Versteeg Et Al, 2012
	 */
	public class IntersectionData {
		
		public function IntersectionData() {
		}
		
		private var _o:Number = 0;//Amount the intersection overlaps
		public function get overlap():Number {
			return _o;
		}
		
		public function set overlap(n:Number):void {
			_o = n;
		}
		
		private var _s:Vector2 = new Vector2();//How the collision must be separated
		public function get seperation():Vector2 {
			return _s;
		}
		
		public function set seperation(n:Vector2):void {
			_s = n;
		}
		
		private var _u:Vector2 = new Vector2();//The angle between the collision
		public function get unitVector():Vector2 {
			return _u;
		}
		
		public function set unitVector(n:Vector2):void {
			_u = n;
		}
		
		private var _c:Boolean = false;//Check if the shapes collided
		public function get collided():Boolean {
			return _c;
		}
		
		public function set collided(c:Boolean):void{
			_c = c;
		}
		
	}

}