package com.shapes {
	import com.interfaces.IMapAble;
	import com.math.Math2;
	import flash.geom.Point;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author Thomas Versteeg Et Al, 2012
	 */
	public dynamic class Box implements IMapAble{
		
		protected var _m:Matrix;// Transform matrix
		
		private var _pl:Vector.<Point>;// List holding corner Points
		private var _tl:Vector.<Point>;// pl where the Points have had a transformation matrix
		
		protected var _tr:Boolean;// Check if the matrix must be updated
		
		/**
		 * Creates a box which can transform its corner Points
		 * for use in intersection and drawing
		 * @param	x the x position of the box
		 * @param	y the y position of the box
		 * @param	width the width of the box
		 * @param	height the height of the box
		 * @param	rotation the rotation of the box
		 */
		public function Box(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0, rotation:Number = 0) {
			_pl = new Vector.<Point>(4, true);
			_tl = new Vector.<Point>(4, true);
			_x = x;
			_y = y;
			_w = width;
			_h = height;
			_r = rotation;
			_sx = _sy = 1;
			_al = 1;
			_tr = false;
			_res = false;
			
			_m = new Matrix();
			_m.translate(-_cx, -_cy);
			_m.rotate(_r);
			_m.scale(_sx, _sy);
			_m.translate(_x, _y);
			
			_pl[0] = new Point(0, 0);
			_pl[1] = new Point(_w, 0);
			_pl[2] = new Point( _w,  _h);
			_pl[3] = new Point( 0, _h);
			_tl[0] = new Point(0, 0);
			_tl[1] = new Point(0, 0);
			_tl[2] = new Point(0, 0);
			_tl[3] = new Point(0, 0);
		}
		
		/**
		 * Deactivates the object so it can be respawned by the pool
		 */
		public function die():void {
			_v = false;
			_a = false;
		}
		
		/**
		 * Sets the vertices on their position with the center as registration Point 
		 */
		private function setVertices():void {
			_pl[0].x = 0;
			_pl[0].y = 0;
			_pl[1].x =  _w;
			_pl[1].y = 0;
			_pl[2].x =  _w;
			_pl[2].y =  _h;
			_pl[3].x = 0;
			_pl[3].y =  _h;
		}
		
		/**
		 * Resets the matrix, so the positions and rotations can be added again
		 */
		public function resetMatrix():void {
			_m.identity();
		}
		
		/**
		 * Updates the matrix so movieClips can be drawn again
		 */
		public function updateMatrix():void {
			_m.identity();
			_m.translate(-_cx, -_cy);
			_m.rotate(_r);
			_m.scale(_sx, _sy);
			_m.translate(_x, _y);
		}
		
		/**
		 * Gets the list where the edge Points have been tranformed
		 */
		public function get list():Vector.<Point> {
			if (!_tr) {
				_m.identity();
				_m.translate(-_cx, -_cy);
				_m.rotate(_r);
				_m.scale(_sx, _sy);
				_m.translate(_x, _y);
				
				var i:int, p:Point;
				for (i = 0; i < 4; i++) {
					_tl[i].x = _pl[i].x * _m.a + _pl[i].y * _m.c + _m.tx;
					_tl[i].y = _pl[i].x * _m.b + _pl[i].y * _m.d + _m.ty;
				}
				_tr = true;
			}
			return _tl;
		}
		
		public function update():Boolean {
			return false;
		}
		
		/**
		 * Gets the list of the center Points where the Points have been tranformed, the center Points are the Points between 2 edges
		 */
		/*public function get centerList():Vector.<Point> {
			_m.identity();
			_m.translate(-_cx, -_cy);
			_m.rotate(_r);
			_m.scale(_sx, _sy);
			_m.translate(_x, _y);
			
			var i:int, l:int = _cl.length, p:Point = new Point();
			for (i = 0; i < l; i++) {
				p.x = _cl[i].x * _m.a + _cl[i].y * _m.c + _m.tx;
				p.y = _cl[i].x * _m.b + _cl[i].y * _m.d + _m.ty;
				_ctl[i] = p;
			}
			return _ctl;
		}*/
		
		protected var _r:Number;// Rotation
		public function set rotation(rotation:Number):void {
			_r = rotation;
			_tr = false;
		}
		
		public function get rotation():Number {
			return _r;
		}
		
		protected var _ub:Point = new Point();//Upperbound for AABB
		public function get upperBound():Point {
			_ub.x = Math2.min(_tl[0].x, Math2.min(_tl[1].x, Math2.min(_tl[2].x, _tl[3].x)));
			_ub.y = Math2.min(_tl[0].y, Math2.min(_tl[1].y, Math2.min(_tl[2].y, _tl[3].y)));
			_lb.x = Math2.max(_tl[0].x, Math2.max(_tl[1].x, Math2.max(_tl[2].x, _tl[3].x)));
			_lb.y = Math2.max(_tl[0].y, Math2.max(_tl[1].y, Math2.max(_tl[2].y, _tl[3].y)));
			return _ub;
		}
		
		protected var _lb:Point = new Point();//Lowerbound for AABB
		public function get lowerBound():Point {
			_ub.x = Math2.min(_tl[0].x, Math2.min(_tl[1].x, Math2.min(_tl[2].x, _tl[3].x)));
			_ub.y = Math2.min(_tl[0].y, Math2.min(_tl[1].y, Math2.min(_tl[2].y, _tl[3].y)));
			_lb.x = Math2.max(_tl[0].x, Math2.max(_tl[1].x, Math2.max(_tl[2].x, _tl[3].x)));
			_lb.y = Math2.max(_tl[0].y, Math2.max(_tl[1].y, Math2.max(_tl[2].y, _tl[3].y)));
			return _lb;
		}
		
		protected var _a:Boolean = true;//Active
		public function set active(a:Boolean):void {
			_a = a;
		}
		public function get active():Boolean {
			return _a;
		}
		
		protected var _w:Number;// Width
		public function set width(w:Number):void {
			_w = w;
			_tr = false;
			
			setVertices();
		}
		
		public function get width():Number {
			return _w;
		}
		
		protected var _h:Number;// Height
		public function set height(h:Number):void {
			_h = h;
			_tr = false;
			
			setVertices();
		}
		
		public function get height():Number {
			return _h;
		}
		
		protected var _sx:Number;// Scale X
		public function set scaleX(x:Number):void {
			_sx = x;
			_tr = false;
		}
		
		public function get scaleX():Number {
			return _sx;
		}
		
		protected var _sy:Number;// Scale Y
		public function set scaleY(y:Number):void {
			_sy = y;
			_tr = false;
		}
		
		public function get scaleY():Number {
			return _sy;
		}
		
		protected var _cx:Number = 0;// Center X
		public function set centerX(x:Number):void {
			_cx = x;
			_tr = false;
		}
		
		public function get centerX():Number {
			return _cx;
		}
		
		protected var _cy:Number = 0;// Center Y
		public function set centerY(y:Number):void {
			_cy = y;
			_tr = false;
		}
		
		public function get centerY():Number {
			return _cy;
		}
		
		protected var _x:Number;// X position
		public function set x(x:Number):void {
			_x = x;
			_tr = false;
		}
		
		public function get x():Number {
			return _x;
		}
		
		protected var _y:Number;// Y position
		public function set y(y:Number):void {
			_y = y;
			_tr = false;
		}
		
		public function get y():Number {
			return _y;
		}
		
		protected var _sid:int;// Shape ID
		public function set shapeId(id:int):void {
			_sid = id;
		}
		public function get shapeId():int {
			return _sid;
		}
		
		protected var _mid:int;// Map ID
		public function set mapId(id:int):void {
			_mid = id;
		}
		public function get mapId():int {
			return _mid;
		}
		
		protected var _shid:int;// Sheet ID
		public function set sheetId(id:int):void {
			_shid = id;
		}
		public function get sheetId():int {
			return _shid;
		}
		
		protected var _v:Boolean;// Visible
		public function set visible(v:Boolean):void {
			_v = v;
		}
		public function get visible():Boolean {
			return _v;
		}
		
		protected var _al:Number;// Alpha
		public function set alpha(a:Number):void {
			_al = a;
		}
		public function get alpha():Number {
			return _al;
		}
		
		protected var _cd:Boolean;// Collidable
		public function set collidable(v:Boolean):void {
			_cd = v;
		}
		public function get collidable():Boolean {
			return _cd;
		}
		
		protected var _res:Boolean// Respawned
		public function set respawned(v:Boolean):void {
			_res = v;
		}
		public function get respawned():Boolean {
			return _res;
		}
	}

}