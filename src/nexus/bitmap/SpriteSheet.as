package nexus.bitmap {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Thomas Versteeg, 2012
	 */
	public class SpriteSheet {
		private var _s:BitmapData;// Sheet Bitmap;
		private var _t:Texture;// Texture
		private var _po:Object;// Position Data extracted
		private var _r:Vector.<Rectangle> = new Vector.<Rectangle>();// Contains the rectangles created by the uv
		private var _c:Vector.<Rectangle> = new Vector.<Rectangle>();// Contains the offests created by the uv
		
		/**
		 * Create a new spriteSheet from any DisplayObject, and slices it up with the JSON file
		 * @param	sheet the sheet, it can be any form as long as it's drawable
		 * @param	position the position JSON file, it must have the coordinates as used in the plugin
		 */
		public function SpriteSheet(sheet:DisplayObject, position:String) {
			_s = new BitmapData(sheet.width, sheet.height, true, 0);
			_s.draw(sheet);
			
			_po = JSON.parse(position);
			createUVs();
		}
		
		/**
		 * Uploads the texture to the graphical card without mipmap
		 * @param	context3D the context3D supplied by the world where it must be uploaded to
		 * @param   mipmap a boolean to upload multiple textures, when you scale the object it's better for performance
		 */
		public function uploadTexture(context3D:Context3D, mipmap:Boolean = false):void {
			if (_t == null) {
				_t = context3D.createTexture(_s.width, _s.height, Context3DTextureFormat.BGRA, false);
			}
			if (mipmap) {
				var mw:int = _s.width;
				var mh:int = _s.height;
				var ml:int = 0;
				var mi:BitmapData = new BitmapData( _s.width, _s.height, true, 0);
				var st:Matrix = new Matrix();
				while ( mw > 0 && mh > 0 ) {
					mi.draw( _s, st, null, null, null, true );
					_t.uploadFromBitmapData( mi, ml );
					st.scale( 0.5, 0.5 );
					ml++;
					mw >>= 1;
					mh >>= 1;
				}
				mi.dispose();
			}else {
				_t.uploadFromBitmapData(_s,0);
			}
		}
		
		/**
		 * Returns the UV coordinates of the specified sprite
		 * @param	spriteId the id of the sprite
		 * @return	a list containing the UV coordinates
		 */
		public function getUVs(spriteId:int):Vector.<Number>{
			var re:Rectangle = _r[spriteId];
			
			var l:Number = re.x/_s.width;
			var u:Number= re.y/_s.height;
			var r:Number = (re.x + re.width)/_s.width
			var d:Number = (re.y + re.height)/_s.height

			return new <Number>[l, d, l, u, r, u, r, d];
		}
		
		/**
		 * Returns the total of sprites in the sprite sheet
		 * @return a integer which stands for the total number of sprites
		 */
		public function getTotalSprites():int {
			return _r.length;
		}
		
		/**
		 * Returns the rectangle of the specified sprite
		 * @param	spriteId the id of the sprite
		 * @return	a rectangle for the shape
		 */
		public function getRect(spriteId:int):Rectangle {
			return _r[spriteId];
		}
		
		/**
		 * Returns the position of the specified sprite
		 * @param	spriteId the id of the sprite
		 * @return	a position point
		 */
		public function getPos(spriteId:int):Point {
			return new Point(_r[spriteId].x,_r[spriteId].y);
		}
		
		/**
		 * Returns the size of the specified sprite
		 * @param	spriteId the id of the sprite
		 * @return	a size point where the x coordinate is width and the y coordinate height
		 */
		public function getSize(spriteId:int):Point {
			return new Point(_r[spriteId].width,_r[spriteId].height);
		}
		
		/**
		 * Returns the sprite as bitmap, useful for debugging purposes
		 * @param	spriteId the id of the sprite
		 * @return	the sprite as bitmap
		 */
		public function getBitmap(spriteId:int):Bitmap{
			var tempBmd:BitmapData = new BitmapData(_r[spriteId].width,_r[spriteId].height, true,0);
			var tempBitmap:Bitmap = new Bitmap(tempBmd);
			
			var tm:Matrix = new Matrix();
			tm.translate(-_r[spriteId].x,-_r[spriteId].y);
			tempBmd.draw(_s, tm);
			return tempBitmap;
		}
		
		/**
		 * Returns the sprite as bitmapData, useful for debugging purposes
		 * @param	spriteId the id of the sprite
		 * @return	the sprite as bitmapData
		 */
		public function getBitmapData(spriteId:int):BitmapData{
			var tempBmd:BitmapData = new BitmapData(_r[spriteId].width,_r[spriteId].height, true,0);
			
			var tm:Matrix = new Matrix();
			tm.translate(-_r[spriteId].x,-_r[spriteId].y);
			tempBmd.draw(_s, tm);
			return tempBmd;
		}
		
		private function createUVs():void {
			var i:String, v:Object, c:int = 0;
			for (i in _po.frames) {
				v = _po.frames[i];
				_r[i]= new Rectangle(v.frame.x,v.frame.y,v.frame.w,v.frame.h);
				_c[i] = new Rectangle(v.offset.x, v.offset.y, v.offset.w, v.offset.h);
				c++;
			}
		}
		
		public function set sheetBitmap(b:BitmapData):void {
			_s = b;
		}
		public function get sheetBitmap():BitmapData {
			return _s;
		}
		
		public function set texture(t:Texture):void {
			_t = t;
		}
		public function get texture():Texture {
			return _t;
		}
		
	}

}