package {
	import com.collision.Intersection;
	import com.math.matrix;
	import com.physics.World;
	import com.math.Math2;
	import com.events.MessageEvent;
	import com.shapes.Box;
	import com.utils.Stats;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Thomas Versteeg, 2012
	 */
	public class Main extends Sprite {
		
		[Embed(source="Test.png")]
		private const Sheet:Class;
		
		[Embed(source="Test.json",mimeType="application/octet-stream")]
		private const Position:Class;
		
		public var sheet1:Bitmap = new Sheet();
		public var sheetPos1:String = new Position();
		
		public var w:World;
		
		private var t:TextField = new TextField();
		private var objectList:Vector.<Object> = new Vector.<Object>();
		
		private var s:Stats = new Stats();
		
		private var oldMouse:Point = new Point();
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			w = new World(800, 600, 1/30);
			w.addSpriteSheet(sheet1, sheetPos1);
			w.initialize(stage, { antiAliasing:2, mipmap:false, backColor:0xCCCCCC } );
			w.addEventListener(MessageEvent.CONTENT_ACTIVE, wActive, false, 0 , true);
			
			addChild(t);
			addChild(s);
			t.selectable = false;
			t.width = 200;
			t.height = 100;
			t.y = 100;
			
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(e:Event):void {
			w.updateTimeStep();
			var i:int, l:int = objectList.length, o:Object;
			for (i = 0; i < l; i++) {
				o = objectList[i];
				if (o.active) {
					o.x += o.vx;
					o.y += o.vy;
					o.rotation += o.ro;
					o.alpha -= 0.01;
					o.scaleX = o.scaleY -= 0.01;
					if (o.alpha <= 0 || o.x < 0 || o.x > 800 || o.y < 0 || o.y > 600 ) {
						o.die();
						objectList.splice(i, 1);
						i--;
						l = objectList.length;
					}
				}
			}
			if (w.initialized) {
				for (var j:int = 0; j < 5; j++){
					var s:Object = w.addSprite(Math.random()*16, Box);
					s.x = mouseX;
					s.y = mouseY;
					s.centerX = s.width >> 1;
					s.centerY = s.height >> 1;
					s.vx = (mouseX - oldMouse.x) + Math.random() * 10 - 5;
					s.vy = (mouseY - oldMouse.y) + Math.random() * 10 - 5;
					s.ro = Math.random() * 1 - 0.5;
					s.scaleX = s.scaleY = Math.random() * 1 + 0.5;
					objectList[l + j] = s;
				}
				l = objectList.length;
			}
			t.text = "Objects: " + l;
			t.appendText("\nTotal list length: " + w._po.children.length);
			t.appendText("\nTotal vertices: " + w._v.length);
			
			oldMouse.x = mouseX;
			oldMouse.y = mouseY;
		}
		
		private function wActive(e:MessageEvent):void {
			switch(e.message) {
				case "init":
					trace("Engine initialized");
					break;
			}
		}
		
	}
	
}