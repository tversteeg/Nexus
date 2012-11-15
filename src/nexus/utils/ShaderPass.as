package nexus.utils {
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType
	import flash.display3D.Context3DTextureFormat
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.textures.Texture;
	import nexus.adobe.utils.AGALMiniAssembler;
	/**
	 * ...
	 * @author Thomas Versteeg
	 */
	public class ShaderPass {
		private var _program:Program3D;
		private var _renderTexture:Boolean;
		private var _tex:Texture;
		private var _vs:String;
		private var _fs:String;
		private var _w:int, _h:int;
		
		//TODO: Add description
		public function ShaderPass(rendersToTexture:Boolean, width:int = 1, height:int = 1) {
			_renderTexture = rendersToTexture;
			_w = width;
			_h = height;
		}
		
		public function addShader(vertexShader:String, fragmentShader:String):void {
			_vs = vertexShader;
			_fs = fragmentShader;
		}
		
		public function setup(context:Context3D):void {
			if (_renderTexture) {
				_tex = context.createTexture(_w, _h, Context3DTextureFormat.BGRA, true)
			}
			var vert:AGALMiniAssembler = new AGALMiniAssembler();
			var frag:AGALMiniAssembler = new AGALMiniAssembler();
			vert.assemble(Context3DProgramType.VERTEX, _vs);
			frag.assemble(Context3DProgramType.FRAGMENT, _fs);
			_program = context.createProgram();
			_program.upload(vert.agalcode, frag.agalcode);
		}
		
		public function render(stageObject:Object, context:Context3D, indexBuffer:IndexBuffer3D, numTriangles:int = 1):void {
			if (!_renderTexture) {
				context.setRenderToBackBuffer();
			}else {
				context.setRenderToTexture(_tex, false, stageObject.antiAliasing);
			}
			context.clear(stageObject.r, stageObject.g, stageObject.b, 0);
			context.setProgram(_program);
			context.drawTriangles(indexBuffer, 0, numTriangles);
			
			if (!_renderTexture) {
				context.present();
			}
		}
		
		public function getTexture():Texture {
			return _tex;
		}
		
	}

}