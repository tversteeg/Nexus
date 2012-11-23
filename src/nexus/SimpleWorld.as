package nexus{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import nexus.utils.Camera2D;
	import nexus.utils.ShaderPass;
	import nexus.math.Math2;
	import nexus.World;
	
	/**
	 * ...
	 * @author Thomas Versteeg
	 */
	public class SimpleWorld extends World {
		private var _normalOn:Boolean = false;
		private var _firstPass:ShaderPass
		private var _normPass:ShaderPass;
		private var _showPass:ShaderPass;
		private var _w:int, _h:int;
		private var _lightSize:Number = 1;
		
		public var stageCamera:Camera2D;
		
		public function SimpleWorld(stage:Stage, spriteSheet:DisplayObject, spritesPosition:String, normalMap:DisplayObject=null) {
			super(stage.stageWidth, stage.stageHeight, stage.frameRate);
			super.initialize(stage, { antiAliasing:0, mipmap:false, backColor:0xCCCCCC } )
			super.addSpriteSheet(spriteSheet, spritesPosition, normalMap)
			
			_w = stage.stageWidth;
			_h = stage.stageHeight;
			
			stageCamera = new Camera2D(_w, _h);
			
			_firstPass = super.addPass(true);
			if (normalMap != null) {
				_normalOn = true;
				_normPass = super.addPass(true)
				_showPass = super.addPass(false, "m44 op, va0, vc0 \nmov v0, va1.xy \nmov v0.z, va0.z \n", "tex ft0, v0, fs0 <2d,linear,nomip> \ntex ft1, v0, fs1 <2d,linear,nomip> \nmov ft2.x, fc1.y \nadd ft2.x, ft2.x, ft2.x \nmul ft1, ft1, ft2.x \nsub ft1, ft1, fc1.yyy \nnrm ft1.xyz, ft1.xyz \nmov ft2.z, ft1.w \nsub ft2.xy, fc0.xy, v0.xy \ndp3 ft2.w, ft2.xyz, ft1.xyz \nmul ft1.xyz, ft2.www, ft0.xyz \nsub ft3.xy, v0.xy, fc0.xy \nmul ft3.y, fc0.w, ft3.y \ndp3 ft3.xy, ft3.xy, ft3.xy \nsqt ft3.xy, ft3.xy \nmul ft3.x, ft3.x, fc0.z \nmin ft3.x, ft3.x, fc1.w \nsat ft2.z, ft2.w \npow ft2.z, ft2.z, fc1.z \nmin ft2.z, ft2.z, fc1.x \nadd ft1.xyz, ft2.zzz, ft1.xyz \nsub ft1.xyz, ft1.xyz, ft3.xxx \nmov oc, ft1");
			}else {
				_showPass = super.addPass(false)
			}
			
		}
		
		public function position(x:Number, y:Number):void {
			stageCamera.x = x;
			stageCamera.y = y;
			camera(stageCamera);
		}
		
		public function render(lightPoint:Point = null):void {
			super.renderStageToPass(_firstPass, false);
			if(_normalOn){
				super.renderStageToPass(_normPass, true);
				super.renderTextureToPass(_firstPass.getTexture(), _normPass.getTexture(), _showPass, { fragment:new<Number>[lightPoint.x/_w, lightPoint.y/_h, _lightSize, _h/_w],fragment2:new <Number>[0.1, 1, 10, 0.5]})
			}else {
				super.renderTextureToPass(_firstPass.getTexture(), null, _showPass)
			}
		}
		
		public function set lightSize(v:Number):void {
			_lightSize = v;
		}
		
	}

}