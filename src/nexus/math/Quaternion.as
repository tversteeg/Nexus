package nexus.math {
	/**
	 * ...
	 * @author Thomas Versteeg, 2012
	 */
	public class Quaternion {
		
		/**
		 * Creates a Quaternion, a useful class that can replace Euler angles
		 * @param	x the x Axis
		 * @param	y the y Axis
		 * @param	w the rotation
		 */
		public function Quaternion(x:Number = 0, y:Number = 0, w:Number = 1) {
			_a = new Vector2(x, y);
			_w = w;
		}
		
		/**
		 * Normalizes the Quaternion, bringing the length back to one
		 */
		public function normalize():void{
			var m:Number = Math.sqrt(w * w + _a.x * _a.x + _a.y + _a.y);
			w /= m;
			_a.x /= m;
			_a.y /= m;
		}
		
		/**
		 * Creates a new Quaternion that is a multiplication between this Quaternion and q
		 * @param	q the Quaternion this Quaternion is multiplied with
		 * @return	a new Quaternion
		 */
		public function multiply(q:Quaternion):Quaternion {
			var qt:Quaternion = new Quaternion();
			qt.w = _w * q.w - _a.x * q.x - _a.y * q.y;
			qt.x = _w * q.x + _a.x * q.w + _a.y - q.y;
			qt.y = _w * q.y - _a.x + _a.y * q.w + q.x;
			return qt;
		}
		
		/**
		 * Multiplies this Quaternion with another Vector, then returns a new one
		 * @param	v the Vector that gets multiplied
		 * @return a new Vector
		 */
		public function multiplyVec(v:Vector2):Vector2 {
			var vt:Vector2 = v.copy();
			v.normalize();
			
			var qt:Quaternion = new Quaternion(), rqt:Quaternion = new Quaternion();
			qt.x = vt.x;
			qt.y = vt.y;
			qt.w = 0;
			
			rqt = qt.multiply (conjugate());
			rqt = multiply(rqt);
			
			return new Vector2(rqt.x, rqt.y);
		}
		
		/**
		 * Creates an inverse of this Quaternion
		 * @return a new Quaternion, the inverse of this one
		 */
		public function conjugate():Quaternion {
			return new Quaternion( -_a.x, -_a.y, -_w);
		}
		
		/**
		 * Create a Quaternion from a axis-angle
		 * @param	v the axis vector
		 * @param	angle the angle pointed in that way
		 */
		public function fromAxis(v:Vector2, angle:Number):void {
			angle *= 0.5;
			var tv:Vector2 = v.copy();
			tv.normalize();
			
			var sinAngle:Number = Math.sin(angle);
			
			_a.x = tv.x * sinAngle;
			_a.y = tv.y * sinAngle;
			_w = Math.cos(angle);
		}
		
		public function fromEuler(pitch:Number, yaw:Number):void {
			var p:Number = pitch * Math2.DEGREETORAD * 0.5;
			var y:Number = yaw * Math2.DEGREETORAD * 0.5;
		}
		
		protected var _a:Vector2; //Axis
		public function set x(x:Number):void {
			_a.x = x;
		}
		public function get x():Number {
			return _a.x;
		}
		public function set y(y:Number):void {
			_a.y = y;
		}
		public function get y():Number {
			return _a.y;
		}
		protected var _w:Number;//Amount of rotation
		public function set w(w:Number):void {
			_w = w;
		}
		public function get w():Number {
			return _w;
		}
		
	}

}