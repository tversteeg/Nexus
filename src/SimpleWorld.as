package  {
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Point;
	import nexus.utils.ShaderPass;
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
		
		public function SimpleWorld(stage:Stage, spriteSheet:DisplayObject, spritesPosition:String, normalMap:DisplayObject=null) {
			super(stage.stageWidth, stage.stageHeight, stage.frameRate);
			super.initialize(stage, { antiAliasing:0, mipmap:false, backColor:0xCCCCCC } )
			super.addSpriteSheet(spriteSheet, spritesPosition, normalMap)
			
			_w = stage.stageWidth;
			_h = stage.stageHeight;
			
			_firstPass = super.addPass(true);
			if (normalMap != null) {
				_normalOn = true;
				_normPass = super.addPass(true)
				_showPass = super.addPass(false, "dp4 op.x, va0, vc0 \ndp4 op.y, va0, vc1 \nmov op.z, vc2.z \nmov op.w, vc3.w \nmov v0, va1.xy \nmov v0.z, va0.z \n", "tex ft0, v0, fs0 <2d,linear,nomip> \ntex ft1, v0, fs1 <2d,linear,nomip> \nmul ft0, ft0, v0.zzz \nsub ft2.xy, v0.xy, fc0.xy \nmul ft2.y, fc0.w, ft2.y \ndp3 ft2.xy, ft2.xy, ft2.xy \nsqt ft2.xy, ft2.xy \nmul ft2.x, ft2.x, fc0.z \nsub ft0.xyz, ft0.xyz, ft2.xxx \nsub ft2.xy, v0.xy, fc0.xy \nmov ft2.z, fc1.w \nnrm ft2.xyz, ft2.xyz \nmul ft2.xy, ft2.xy, fc1.zz \nmul ft1.xy, ft1.xy, ft2.xy \nnrm ft1.xyz, ft1.xyz \ndp3 ft1.xyz, ft1.xyz, fc1.xxy \nmax ft1.xyz, ft1.xyz, fc1.xxx \nmul ft0.xyz, ft0.xyz, ft1.xyz \nmov oc, ft0");
			}else {
				_showPass = super.addPass(false)
			}
			
		}
		
		public function render(lightPoint:Point):void {
			super.renderStageToPass(_firstPass, false);
			if(_normalOn){
				super.renderStageToPass(_normPass, true);
				super.renderTextureToPass(_firstPass.getTexture(), _normPass.getTexture(), _showPass, { fragment:new<Number>[lightPoint.x/_w, lightPoint.y/_h, _lightSize, 0.5],fragment2:new <Number>[0, 1, 2 , 0.1]})
			}else {
				super.renderTextureToPass(_firstPass.getTexture(), null, _showPass)
			}
		}
		
		public function set lightSize(v:Number):void {
			_lightSize = v;
		}
		
	}

}