package {
	import com.collision.Intersection;
	import com.math.matrix;
	import com.physics.World;
	import com.math.Math2;
	import com.events.MessageEvent;
	import com.shapes.Box;
	import com.shapes.MovieBox;
	import com.shapes.StaticBox;
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
		private var vars:Object;
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			vars = { antiAliasing:2, mipmap:false, backColor:0xCCCCCC, maxCap:2000/*, fragment:
				"tex ft0, v0, fs0 <2d,linear, nearest, nomip>\n"+
				"mul ft0, ft0, v0.zzzz\n" +
				"sub ft1.xy, v0.xy, fc0.xy\n" +
				"mul ft1.x, ft1.x, ft1.x\n"+
				"mul ft1.y, ft1.y, ft1.y\n" +
				"add ft1.y, ft1.x, ft1.y\n" +
				"sqrt ft2.xyz, ft1.yyy \n" +
				"mul ft0.xyz, ft2.xyz, ft0\n" +
				"mov oc, ft0 \n"*/}
			
			w = new World(800, 600, 1/30);
			w.addSpriteSheet(sheet1, sheetPos1);
			w.initialize(stage, vars);
			w.addEventListener(MessageEvent.CONTENT_ACTIVE, wActive, false, 0 , true);
			w.preparePool(1000, StaticBox, 2);
			w.preparePool(1000, Box, 3);
			
			addChild(t);
			addChild(s);
			t.selectable = false;
			t.width = 200;
			t.height = 100;
			t.y = 100;
			
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(e:Event):void {
			w.updateTimeStep({fragment:new <Number>[mouseX/800, mouseY/600, 0, 1]});
			var i:int, l:int = objectList.length, o:Object;
			for (i = 0; i < l; i++) {
				o = objectList[i];
				if (o.active) {
					o.x += o.vx;
					o.y += o.vy;
					o.alpha -= 0.01;
					if (o.alpha <= 0 || o.x < 0 || o.x > 800 || o.y < 0 || o.y > 600 ) {
						o.die();
						objectList.splice(i, 1);
						i--;
						l = objectList.length;
					}
				}
			}
			for (var j:int = 0; j < 25; j++) {
				if(Math.random()>0.5){
					var s:StaticBox = w.addSprite(2, StaticBox);
					s.x = mouseX;
					s.y = mouseY;
					s.vx = (mouseX - oldMouse.x) + Math.random() * 10 - 5;
					s.vy = (mouseY - oldMouse.y) + Math.random() * 10 - 5;
					objectList[l + j] = s;
				}else {
					var s2:Box = w.addSprite(3, Box);
					s2.x = mouseX;
					s2.y = mouseY;
					s2.vx = (mouseX - oldMouse.x) + Math.random() * 10 - 5;
					s2.vy = (mouseY - oldMouse.y) + Math.random() * 10 - 5;
					objectList[l + j] = s2;
				}
			}
			l = objectList.length;
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