package nexus.physics.shapes {
	import flash.geom.Point;
	import nexus.interfaces.IPhysAble;
	import nexus.shapes.Box;
	
	/**
	 * ...
	 * @author Thomas Versteeg
	 */
	public class PhysBox extends Box implements IPhysAble {
		private var _mass:Number;// m
		
		private var _rotation:Number;// θ
		private var _angularVelocity:Number;// θ'
		
		private var _position:Point; // x & y, center of mass
		private var _velocity:Point;// x' & y'
		
		private var _oldRotation:Number; // θ"
		private var _oldPosition:Point; // x" & y"
		
		private var _isPoly:Boolean;
		
		public function PhysBox(x:Number=0, y:Number=0, width:Number=0, height:Number=0, rotation:Number=0) {
			super(x, y, width, height, rotation);
			
		}
		
		public function update():void {
			//_velocity.x = 
		}
		
		public function thrustFromPoint(contactPoint:Point):void {
			//I = m (w2 + h2)/12 
			var momentOfInertia:Number = mass * (width * width + height * height) / 12;
			
			//Fx = Tx = m x"
			var forceX:Number = mass * (_oldPosition.x - _position.x);
			//Fy = Ty = m y"
			var forceY:Number = mass * (_oldPosition.y - _position.y);
			
			//Rx = x - Px
			var distanceX = _position.x - contactPoint.x;
			//Ry = y - Py
			var distanceY = _position.y - contactPoint.y;
			
			//τ = I θ" = R×T
			var torque:Number = distanceX * forceY - distanceY * forceX;
			
			_oldPosition = _position;
			_oldRotation = _rotation;
		}
		
		/* INTERFACE nexus.interfaces.IPhysAble */
		
		public function set mass(value:Number):void {
			_mass = value;
		}
		
		public function get mass():Number {
			return _mass;
		}
		
		public function set velocity(value:Point):void {
			_velocity = value;
		}
		
		public function get velocity():Point {
			return _velocity;
		}
		
		public function set position(value:Point):void {
			_position = value;
		}
		
		public function get position():Point {
			return _position;
		}
		
		public function set isPoly(value:Boolean):void {
			_isPoly = value;
		}
		
		public function get isPoly():Boolean {
			return _isPoly;
		}
		
	}

}