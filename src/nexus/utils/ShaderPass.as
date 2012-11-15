package nexus.utils {
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType
	import flash.display3D.Context3DTextureFormat
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.textures.Texture;
	import flash.utils.ByteArray;
	import nexus.adobe.utils.AGALMiniAssembler;
	/**
	 * ...
	 * @author Thomas Versteeg
	 */
	public class ShaderPass {
		private static const _agal:AGALMiniAssembler = new AGALMiniAssembler();
		private var _program:Program3D;
		private var _context:Context3D;
		private var _renderTexture:Boolean;
		private var _tex:Texture;
		
		//TODO: Add description
		public function ShaderPass(context:Context3D, rendersToTexture:Boolean, width:Number = 1, height:Number = 1) {
			_context = context;
			_renderTexture = rendersToTexture;
			if(_renderTexture) _tex = _context.createTexture(width, height, Context3DTextureFormat.BGRA, true)
		}
		
		public function setup(vertexShader:String, fragmentShader:String):void {
			var vs:ByteArray = _agal.assemble(Context3DProgramType.VERTEX, vertexShader)
			var fs:ByteArray = _agal.assemble(Context3DProgramType.FRAGMENT, fragmentShader)
			_program = _context.createProgram();
			_program.upload(vs, fs);
		}
		
		public function render(indexBuffer:IndexBuffer3D):void {
			if (!_renderTexture) {
				_context.setRenderToBackBuffer();
			}else {
				_context.setRenderToTexture(_tex, false);
			}
			
			_context.clear(0, 0, 0, 0);
			_context.setProgram(_program);
			_context.drawTriangles(indexBuffer);
		}
		
		public function getTexture():Texture {
			return _tex;
		}
		
	}

}