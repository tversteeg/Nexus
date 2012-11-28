package nexus.utils {
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import nexus.math.Math2
	/**
	 * ...
	 * @author Thomas Versteeg
	 */
	public class Camera2D {
		
		protected var _renderMatrix:Matrix3D = new Matrix3D();
		protected var _projectionMatrix:Matrix3D = new Matrix3D();
		protected var _viewMatrix:Matrix3D = new Matrix3D();
		
		protected var _width:int;
		protected var _height:int;
		
		protected var _x:Number = 0;
		protected var _y:Number = 0;
		protected var _zoom:Number;
		
		protected var _maxBoundX:Number;
		protected var _maxBoundY:Number;
		protected var _minBoundX:Number;
		protected var _minBoundY:Number;
		
		protected var _recalculate:Boolean = true;
		
		public function Camera2D(width:int, height:int, zoom:Number = 1) {
			resize(width, height);
			_zoom = zoom;
			
			_maxBoundX = Number.POSITIVE_INFINITY;
			_maxBoundY = Number.POSITIVE_INFINITY;
			
			_minBoundX = Number.NEGATIVE_INFINITY;
			_minBoundY = Number.NEGATIVE_INFINITY;
		}
		
		public function resize(width:Number, height:Number):void {
			_width = width;
			_height = height;
			
			_projectionMatrix = makeMatrix(width, height);
			
			_recalculate = true;
		}
		
		protected function makeMatrix(width:Number, height:Number, zNear:Number = 0, zFar:Number = 1):Matrix3D {
			return new Matrix3D(Vector.<Number>([
				2 / width, 0, 0, 0,
				0, 2 / height, 0, 0,
				0, 0, 1 / (zFar - zNear), 0,
				0, 0, zNear / (zNear - zFar), 1
			]));
		}
		
		public function get viewMatrix():Matrix3D {
			if (_recalculate) {
				_recalculate = false;
				
				_viewMatrix.identity();
				_viewMatrix.appendScale(_zoom, -_zoom, 1);
				var hw:Number = _width * 0.5;
				var hh:Number = _height * 0.5;
				//_viewMatrix.appendTranslation( Math2.clamp(-hw + _x, _minBoundX - hw , -_maxBoundX + hw ), Math2.clamp(hh + _y , _maxBoundY - hh, _minBoundY + hh), 0);
				_viewMatrix.appendTranslation(-_x, _y, 0)
				//TODO: Add rotation
				//_viewMatrix.appendRotation(_rotation, Vector3D.Z_AXIS);
				
				_renderMatrix.identity();
				
				_renderMatrix.append(_viewMatrix);
				_renderMatrix.append(_projectionMatrix);
			}
			
			return _renderMatrix;
		}
		
		public function set maxBounds(value:Point):void {
			_maxBoundX = value.x;
			_maxBoundY = value.y;
			_recalculate = true;
		}
		
		public function get maxBounds():Point {
			return new Point(_maxBoundX, _maxBoundY);
		}
		
		public function set minBounds(value:Point):void {
			_minBoundX = value.x;
			_minBoundY = value.y;
			_recalculate = true;
		}
		
		public function get minBounds():Point {
			return new Point(_minBoundX, _minBoundY);
		}
		
		public function get x():Number {
			return _x
		}
		
		public function get realX():Number {
			return _x - _width * 0.5;
		}
		
		public function set x(value:Number):void {
			var hw:Number = _width * 0.5;
			_x = Math2.clamp(value, _maxBoundX - hw, _minBoundX + hw);
			_recalculate = true;
		}
		
		public function get y():Number {
			return _y
		}
		
		public function get realY():Number {
			return _y - _height * 0.5;
		}
		
		public function set y(value:Number):void {
			var hh:Number = _height * 0.5;
			_y = Math2.clamp(value, _maxBoundY - hh, _minBoundY + hh);
			_recalculate = true;
		}
		
		public function get zoom():Number {
			return _zoom;
		}
		
		public function set zoom(value:Number):void {
			_zoom = value;
			_recalculate = true;
		}
		
		public function get width():int {
			return _width;
		}
		
		public function set width(value:int):void {
			_width = value;
			_recalculate = true;
		}
		
		public function get height():int {
			return _height;
		}
		
		public function set height(value:int):void {
			_height = value;
			_recalculate = true;
		}
		
	}

}