package nexus {
	import flash.display3D.textures.Texture;
	import nexus.adobe.utils.*;
	import nexus.bitmap.*;
	import nexus.events.*;
	import nexus.interfaces.IMapAble;
	import nexus.math.Vector2;
	import nexus.math.Math2;
	import nexus.objects.*;
	import nexus.shapes.*;
	import flash.display.*;
	import flash.display3D.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	import nexus.utils.ShaderPass;
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
		private var _passes:Vector.<ShaderPass> = new Vector.<ShaderPass>();
		
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
		public function addSprite(shape:int, type:Class, sheet:int = 0):* {
			var s:* = _po.respawn(shape, type, sheet);
			var p:Point = _sl[sheet].getSize(shape);
			s.width = p.x, s.height = p.y;
			s.x = s.y = 0;
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
				_ini = true;
			}
			_uvb = true;
			return s;
		}
		
		/**
		 * Add the sprite version of a movieClip
		 * @param	shapes a list containing all the frames as identified by their shapeId
		 * @param	protoFrame the frame that is used for the collision
		 * @param	sheet the sprite sheet your sprites are in
		 * @return 	the sprites that are drawn on the stage with the update functions
		 */
		public function addMovie(shapes:Vector.<int>, protoFrame:int = 0, sheet:int = 0):MovieBox {
			var d:int = shapes[protoFrame];
			var s:MovieBox = _po.respawn(d, MovieBox, sheet);
			var p:Point = _sl[sheet].getSize(d);
			s.frameList = shapes;
			s.width = p.x, s.height = p.y;
			s.x = s.y = 0;
			s.alpha = 1;
			if(!s.respawned){
				var fi:uint = s.mapId * 4
				_v.push(0, 0, 1, 0, 0,1, 0, 0,1, 0, 0,1);
				_i.push(fi, fi + 1, fi + 2, fi, fi + 2, fi + 3);
				var cuv:Vector.<Number > = _sl[sheet].getUVs(d);
				var i:int, l:int = _uv.length;
				for (i = 0; i < 8; i++) {
					_uv[l + i] = cuv[i];
				}
			}
			_uvb = true;
			return s;
		}
		
		/**
		 * Prepares the object pool by creating the new objects in advance
		 * @param	amount the amount of objects created, this amount is multiplied by the arguments
		 * @param	type the type of object that must be instantiated
		 * @param	... args must be integers, the shapeId's that must be prepared
		 */
		public function preparePool(amount:int, type:Class, ... args):void {
			var i:int, j:int, k:int, fi:uint, cuv:Vector.<Number>, l:int = args.length, l2:int = _uv.length, s:*;
			for (i = 0; i < l; i++) {
				for (j = 0; j < amount; j++) {
					s = _po.respawn(args[i], type, 0, true);
					fi= s.mapId << 2
					_v.push(0, 0, 1, 0, 0,1, 0, 0,1, 0, 0,1);
					_i.push(fi, fi + 1, fi + 2, fi, fi + 2, fi + 3);
					cuv = _sl[0].getUVs(args[i]);
					for (k = 0; k < 8; k++) {
						_uv[l2 + k] = cuv[k];
					}
					l2 += 8;
				}
			}
		}
		
		/**
		 * Begins with loading the stage3D and then loads the shaders
		 * @param	stage the main Stage, everything will be projected in the lowest layer here
		 * @param	variables a optional Object containing global variables like gravity and anti aliasing
		 */
		public function initialize(stage:Stage, variables:Object = null):void {
			_s = stage;
			_o = variables;
			
			if (!"antiAliasing" in _o) {
				_o.antiAliasing = 0;
			}
			if (!"mipmap" in _o) {
				_o.mipmap = false;
			}
			if ("backColor" in _o) {
				_o.r = ((_o.backColor >> 16) & 0xff) / 255;
				_o.g = ((_o.backColor >> 8) & 0xff) / 255;
				_o.b = (_o.backColor & 0xff) / 255;
			}
			if ("maxCap" in _o) {
				_po.cap = _o.maxCap;
			}
			
			_v = new Vector.<Number>();
			_i = new Vector.<uint>();
			_uv = new Vector.<Number>();
			
			stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, context3DEvent);
			stage.stage3Ds[0].requestContext3D(Context3DRenderMode.AUTO);
		}
		
		/**
		 * Draws the objects to the stage
		 */
		public function renderAllToPass(pass:ShaderPass, constants:Object = null):void {
			//TODO: Give every drawObject a drawPriority, and draw the highest priority latest
			_c3d.clear(_o.r, _o.g, _o.b);
			
			var l:int = _po.length;
			
			if (l > 0 && _po.ready){
				_c3d.setProgram(_sh);
				_c3d.setCulling(Context3DTriangleFace.BACK);
				_c3d.setDepthTest(false, Context3DCompareMode.ALWAYS)
				_c3d.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
				_c3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _mvm, true);
				
				if (constants != null) {
					if("vertex" in constants){
						_c3d.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 1, constants.vertex);
					}
					if("fragment" in constants){
						_c3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, constants.fragment);
					}
				}
				
				setTextures();
				//TODO: Change vector to byte array
				var i:int, j:int, l2:int, cdx:int, b:IMapAble, li:Vector.<Point>, al:Number, cuv:Vector.<Number>;
				for (i = 0; i < l; i++) {
					b = _po.children[i];
					cdx = b.mapId * 12;
					if (b.visible && b.active) {
						if (b.update()) {
							_uvb = true;
							cuv = _sl[b.sheetId].getUVs(b.shapeId);
							l2 = b.mapId * 8;
							for (j = 0; j < 8; j++) {
								_uv[l2 + j] = cuv[j];
							}
						}
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

				_c3d.drawTriangles(_ib, 0, _po.length << 1);
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
		
		//TODO: Add description
		public function drawSpriteToSprite(xPosition:Number, yPosition:Number, rotation:Number, spriteIdDraw:int, spriteIdTo:int, sheetId:int = 0):void {
			var size:Point = _sl[sheetId].getSize(spriteIdTo);
			if (xPosition< 0 || xPosition > size.x || yPosition < 0 || yPosition > size.y) return;
			var tempPos:Point = _sl[sheetId].getPos(spriteIdTo);
			tempPos.x += xPosition;
			tempPos.y += yPosition;
			var m:Matrix = new Matrix();
			m.rotate(rotation);
			m.tx = tempPos.x;
			m.ty = tempPos.y;
			_sl[sheetId].sheetBitmap.draw(_sl[sheetId].getBitmapData(spriteIdDraw), m, null, null, _sl[sheetId].getRect(spriteIdTo), false);
		}
		
		public function getSpritePixel(xPosition:Number, yPosition:Number, spriteId:int, sheetId:int = 0):uint {
			var size:Point = _sl[sheetId].getSize(spriteId);
			if (xPosition< 0 || xPosition > size.x || yPosition < 0 || yPosition > size.y) return 0;
			var tempPos:Point = _sl[sheetId].getPos(spriteId);
			tempPos.x += xPosition;
			tempPos.y += yPosition;
			return _sl[sheetId].sheetBitmap.getPixel32(tempPos.x, tempPos.y);
		}
		
		public function setSpritePixel(xPosition:Number, yPosition:Number, color:uint, spriteId:int, sheetId:int = 0):void {
			var size:Point = _sl[sheetId].getSize(spriteId);
			if (xPosition< 0 || xPosition > size.x || yPosition < 0 || yPosition > size.y) return;
			var tempPos:Point = _sl[sheetId].getPos(spriteId);
			tempPos.x += xPosition;
			tempPos.y += yPosition;
			_sl[sheetId].sheetBitmap.setPixel32(tempPos.x, tempPos.y, color);
		}
		
		public function uploadTextures():void {
			var i:int, l:int = _sl.length;
			for (i = 0; i < l; i++) {
				_sl[i].uploadTexture(_c3d, _o.mipmap);
			}
		}
		
		public function addPass(vertexShader:String, fragmentShader:String, drawToTexture:Boolean = false):ShaderPass {
			var w:int = _w
			w--;
			w |= w >> 1;
			w |= w >> 2;
			w |= w >> 4;
			w |= w >> 8;
			w |= w >> 16;
			w++;
			var h:int = _h
			h--;
			h |= h >> 1;
			h |= h >> 2;
			h |= h >> 4;
			h |= h >> 8;
			h |= h >> 16;
			h++;
			var pass:ShaderPass = new ShaderPass(_c3d, drawToTexture, w, h);
			pass.setup(vertexShader, fragmentShader);
			var l:int = _passes.length
			_passes[l] = pass;
			return pass;
		}
		
		private function context3DEvent(e:Event):void {
			_c3d = _s.stage3Ds[0].context3D;
			setupShaders();
			uploadTextures();
			camera(0, 0, _w, _h);
			dispatchEvent(new MessageEvent(MessageEvent.CONTENT_ACTIVE, "init"));
			dispatchEvent(new MessageEvent(MessageEvent.CONTENT_ACTIVE, _c3d.driverInfo));
			_ini = true;
		}
		
		private function setupShaders():void{
			_c3d.configureBackBuffer(_w, _h, _o.antiAlias, false);
			
			var vert:AGALMiniAssembler = new AGALMiniAssembler();
			var frag:AGALMiniAssembler = new AGALMiniAssembler();
			if ("vertex" in _o) {
				vert.assemble( Context3DProgramType.VERTEX, _o.vertex);
			}else {
				vert.assemble( Context3DProgramType.VERTEX,
					"dp4 op.x, va0, vc0 \n"+
					"dp4 op.y, va0, vc1 \n"+ 
					"mov op.z, vc2.z    \n"+
					"mov op.w, vc3.w    \n"+
					"mov v0, va1.xy     \n"+
					"mov v0.z, va0.z    \n");
			}
			if ("fragment" in _o) {
				frag.assemble( Context3DProgramType.FRAGMENT, _o.fragment);
			}else {
				frag.assemble( Context3DProgramType.FRAGMENT,
					"tex ft0, v0, fs0 <2d,linear, nearest, "+ (_o.mipmap ? "mipnearest" : "nomip") +">\n"+
					"mul ft0, ft0, v0.zzzz\n"+
					"mov oc, ft0 \n");
			}
			
			_sh = _c3d.createProgram();
			_sh.upload(vert.agalcode, frag.agalcode);
		}
		
		private function setTextures():void {
			var i:int, l:int = _sl.length;
			for (i = 0; i < l; i++) {
				_c3d.setTextureAt(i, _sl[i].texture);
			}
		}
		
	}

}