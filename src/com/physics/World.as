package com.physics {
	import com.adobe.utils.*;
	import com.bitmap.*;
	import com.events.*;
	import com.math.Vector2;
	import com.objects.*;
	import com.shapes.*;
	import flash.display.*;
	import flash.display3D.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	/**
	 * ...
	 * @author Thomas Versteeg, 2012
	 */
	public class World extends EventDispatcher{
		private var _sl:Vector.<SpriteSheet> = new Vector.<SpriteSheet>();
		private var _s:Stage;
		private var _c3d:Context3D, _sh:Program3D, _vb:VertexBuffer3D, _ib:IndexBuffer3D, _ub:VertexBuffer3D;
		private var _bt:int, _at:int, _ot:int, _st:int, _td:int, _e:int, _w:int, _h:int;
		private var _p:Number
		private var _o:Object;
		private var _mvm:Matrix3D;
		public var _po:Pool = new Pool();
		public var _v:Vector.<Number>, _i:Vector.<uint>, _uv:Vector.<Number>;
		private var _uvb:Boolean = true, _ini:Boolean = false;
		
		/**
		 * Creates a new world class, this is essentially your new stage
		 * @param	frameRate the framerate that is used to calculate physics solving when there is a framedrop
		 * @param	width the width of target stage
		 * @param 	height the height of the target stage
		 */
		public function World(width:int, height:int, frameRate:Number = 1 / 30) {
			_p = 1000 / frameRate;
			_w = width;
			_h = height;
		}
		
		/**
		 * Adds a sprite sheet to the list
		 * @param	sheet the sprite sheet, it can be anything that could be drawn
		 * @param	position the position string in the form of an JSON
		 */
		public function addSpriteSheet(sheet:DisplayObject, position:String):void {
			//TODO: Create byte code instead of JSON
			var s:SpriteSheet = new SpriteSheet(sheet, position);
			var i:int = _sl.length;
			_sl[i] = s;
		}
		
		/**
		 * Creates a new sprite call this function like this: var example:Box = worldClass.addSprite(1, Box, 0);
		 * @param	shape the number of the sprite on the spritesheet
		 * @param	type the type of class you want to create, example Box
		 * @param	sheet the sprite sheet your sprite is in
		 * @return the sprite that is drawn on the stage with the update functions
		 */
		public function addSprite(shape:int, type:Class, sheet:int = 0):Object {
			//TODO: Create a stack where the sprites are put when there is no stage3D available
			//TODO: Make the var b:Box = addSprite() work
			var s:Object = _po.respawn(shape, type, sheet);
			var p:Point = _sl[sheet].getSize(shape);
			s.width = p.x, s.height = p.y;
			s.x = 0;
			s.y = 0;
			s.alpha = 1;
			
			if(!s.respawned){
				var fi:uint = s.mapId * 4
				_v.push(0, 0, 1, 0, 0,1, 0, 0,1, 0, 0,1);
				_i.push(fi, fi + 1, fi + 2, fi, fi + 2, fi + 3);
				var cuv:Vector.<Number > = _sl[sheet].getUVs(shape);
				var i:int, l:int = _uv.length;
				for (i = 0; i < 8; i++) {
					_uv[l + i] = cuv[i];
				}
			}
			_uvb = true;
			return s;
		}
		
		public function removeSprite(sprite:Object):void{
			sprite.active = false;
			sprite.visible = false;
		}
		
		/**
		 * Begins with loading the stage3D and then loads the shaders
		 * @param	stage the main Stage, everything will be projected in the lowest layer here
		 * @param	variables a optional Object containing global variables like gravity and anti aliasing
		 */
		public function initialize(stage:Stage, variables:Object = null):void {
			_s = stage;
			_o = variables;
			
			if (!_o.hasOwnProperty("antiAliasing")) {
				_o.antiAliasing = 0;
			}
			if (!_o.hasOwnProperty("mipmap")) {
				_o.mipmap = false;
			}
			if (_o.hasOwnProperty("backColor")) {
				_o.r = ((_o.backColor >> 16) & 0xff) / 255;
				_o.g = ((_o.backColor >> 8) & 0xff) / 255;
				_o.b = (_o.backColor & 0xff) / 255;
			}
			
			_v = new Vector.<Number>();
			_i = new Vector.<uint>();
			_uv = new Vector.<Number>();
			
			stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, context3DEvent);
			stage.stage3Ds[0].requestContext3D(Context3DRenderMode.AUTO);
		}
		
		/**
		 * Updates the engine where the physics get recalculated if it lags behind
		 */
		public function updateTimeStep():void {
			_bt = getTimer();
			_ot = (_bt - _at) - _st;
			
			updateFrame();
			drawFrame();
			
			_at = getTimer();
			_td = _at - _bt;
			_st = (_p - _td) - _ot;
			if (_st <= 0) {
				_e-= _st;
				_st = 2;
			}
			
			while (_e > _p) {
				updateFrame();
				_e-= _p;
			}
			
		}
		
		/**
		 * Updates the positions and physics of the objects
		 */
		public function updateFrame():void {
			
		}
		
		/**
		 * Draws the objects to the stage
		 */
		public function drawFrame():void {
			//TODO: Give every drawObject a drawPriority, and draw the highest priority latest
			_c3d.clear(_o.r, _o.g, _o.b);
			
			var l:int = _po.children.length;
			
			if (l > 0){
				_c3d.setProgram(_sh);
				_c3d.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
				_c3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _mvm, true);
				
				setTextures();
				
				//TODO: Add alpha to boxes
				
				var i:int, j:int, cdx:int, b:Box, li:Vector.<Point>, al:Number;
				for (i = 0; i < l; i++) {
					b = _po.children[i];
					cdx = b.mapId * 12;
					if (b.visible && b.active) {
						al = b.alpha;
						li = b.list;
						_v[cdx] = li[3].x;
						_v[cdx + 1] = li[3].y;
						_v[cdx + 2] = al;

						_v[cdx + 3] = li[0].x;
						_v[cdx + 4] = li[0].y;
						_v[cdx + 5] = al;

						_v[cdx + 6] = li[1].x;
						_v[cdx + 7] = li[1].y;
						_v[cdx + 8] = al;

						_v[cdx + 9] = li[2].x;
						_v[cdx + 10] = li[2].y;
						_v[cdx + 11] = al;
					}else {
						for (j = 0; j < 12; j++) {
							_v[cdx + j] = 0;
						}
					}
				}
				
				if (_uvb) {
					_vb = _c3d.createVertexBuffer(_v.length / 3, 3);
					_ib = _c3d.createIndexBuffer(_i.length);
					_ub = _c3d.createVertexBuffer(_uv.length >> 1, 2);
					_ib.uploadFromVector(_i, 0, _i.length);
					_ub.uploadFromVector(_uv, 0, _uv.length >> 1);
					_uvb = false;
				}
				
				_vb.uploadFromVector(_v, 0, _v.length / 3);
				_c3d.setVertexBufferAt(0, _vb, 0, Context3DVertexBufferFormat.FLOAT_3);
				_c3d.setVertexBufferAt(1, _ub, 0,  Context3DVertexBufferFormat.FLOAT_2);

				_c3d.drawTriangles(_ib, 0, _po.children.length << 1);
			}
			_c3d.present();
		}
		
		/**
		 * Sets the stage3D stage to a position
		 * @param	x the top left X position
		 * @param	y the top left Y position
		 * @param	width the width of the stage
		 * @param	height the height of the stage
		 */
		public function camera(x:Number, y:Number, width:int, height:int):void {			
			_mvm = new Matrix3D();
			_mvm.appendTranslation(-width >> 1, -height >>1, 0);
			_mvm.appendScale(2/width, -2/height , 1);
		}
		
		/**
		 * Returns a boolean that is true when the stage3d is loaded
		 */
		public function get initialized():Boolean {
			return _ini;
		}
		
		private function context3DEvent(e:Event):void {
			_c3d = _s.stage3Ds[0].context3D;
			setupShaders();
			uploadTextures();
			camera(0, 0, _w, _h);
			dispatchEvent(new MessageEvent(MessageEvent.CONTENT_ACTIVE, "init"));
			_ini = true;
		}
		
		private function setupShaders():void{
			_c3d.configureBackBuffer(_w, _h, _o.antiAlias, false);
			
			var vert:AGALMiniAssembler = new AGALMiniAssembler();
			vert.assemble( Context3DProgramType.VERTEX,
			        "dp4 op.x, va0, vc0 \n"+
			        "dp4 op.y, va0, vc1 \n"+ 
			        "mov op.z, vc2.z    \n"+
			        "mov op.w, vc3.w    \n"+
			        "mov v0, va1.xy     \n"+
			        "mov v0.z, va0.z    \n");

			var frag:AGALMiniAssembler = new AGALMiniAssembler();
			frag.assemble( Context3DProgramType.FRAGMENT,
					"tex ft0, v0, fs0 <2d,linear, nearest, nomip>\n"+
					"mul ft0, ft0, v0.zzzz\n"+
					"mov oc, ft0 \n");

			_sh = _c3d.createProgram();
			_sh.upload(vert.agalcode, frag.agalcode);
		}
		
		private function uploadTextures():void {
			var i:int, l:int = _sl.length;
			for (i = 0; i < l; i++) {
				_sl[i].uploadTexture(_c3d, _o.mipmap);
			}
		}
		
		private function setTextures():void {
			var i:int, l:int = _sl.length;
			for (i = 0; i < l; i++) {
				_c3d.setTextureAt(i, _sl[i].texture);
			}
		}
		
	}

}