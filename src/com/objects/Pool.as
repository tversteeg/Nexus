package com.objects {
	import com.interfaces.IMapAble;
	import com.shapes.Box;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author Thomas Versteeg, 2012
	 */
	public class Pool {
		
		public function Pool() {
			_r = false;
			_c = 0;
			_t = 0;
		}
		
		private var _c:int;
		public function setCap(num:int):void {
			_l = new Vector.<IMapAble>(num, true);
			_c = num;
		}
		
		/**
		 * Checks if a sprite that's inactive exists, when there is none create a new one
		 * @param	shapeId the id of the sprite where it is positioned in the spritesheet
		 * @return a new Box wich is either respawned or new
		 */
		public function respawn(shapeId:int, className:Class, sheetId:int, init:Boolean = false):*{
			//TODO: Update params
			var i:int;
			var c:IMapAble;
			if(!init){
				for (i = 0; i < _t; i++) {
					c = _l[i];
					if (!c.active && c.shapeId == shapeId) {
						c.active = true;
						c.visible = true;
						c.respawned = true;
						c.mapId = i;
						_r = true;
						return c;
					}
				}
			}
			if (_c != 0 && _t >= _c) {
				throw new Error("Objects get out of cap", 1);
				return null;
			}
			c = new className();
			c.active = !init;
			c.visible = !init;
			c.shapeId = shapeId;
			c.sheetId = sheetId;
			c.mapId = _t;
			_l[_t] = c;
			_t++;
			
			return c;
		}
		
		private var _t:int;
		public function get length():int {
			return _t;
		}
		
		private var _r:Boolean;// Check if the pool is ready for drawing
		public function get ready():Boolean {
			return _r;
		}
		
		private var _l:Vector.<IMapAble> = new Vector.<IMapAble>();//The pool where the boxes are
		public function set children(v:Vector.<IMapAble>):void {
			_l = v;
		}
		public function get children():Vector.<IMapAble> {
			return _l;
		}
		
	}

}