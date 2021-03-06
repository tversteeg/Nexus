function getPluginInfo(lang)
{
//	fl.trace("==== getPluginInfo");
//	fl.trace(lang);
//	fl.trace("---- getPluginInfo");

	pluginInfo = new Object();
	pluginInfo.id = "JSON-Nexus";
	pluginInfo.name = "JSON-Nexus";
	pluginInfo.ext = "json";
	pluginInfo.capabilities = new Object();
	pluginInfo.capabilities.canRotate = true;
	pluginInfo.capabilities.canTrim = true;
	pluginInfo.capabilities.canShapePad = true;
	pluginInfo.capabilities.canBorderPad = true;
	pluginInfo.capabilities.canStackDuplicateFrames = true;
	
	return pluginInfo;
}

var hitFrame = false;

function AddKey(key)
{
	return "\t\"" + key + "\": ";
}

function AddKeyStr(key, val)
{
	var s = AddKey(key);
	s += "\"";
	s += val;
	s += "\",\n";
	
	return s;
}

function AddKeySize(key, width, height, doComma)
{
	var s = AddKey(key);
	s += "{\"w\":";
	s += width;
	s += ",\"h\":";
	s += height;
	s += doComma ? "},\n" : "}\n";

	return s;
}

function AddKeyNum(key, val, doComma)
{
	var s = AddKey(key);
	s += "\"";
	s += val;
	s += doComma ? "\", " : "\"";

	return s;
}

function AddKeyRect(key, val)
{
	var s = AddKey(key);
	s += "{\"x\":";
	s += val.x;
	s += ",\"y\":";
	s += val.y;
	s += ",\"w\":";
	s += val.w;
	s += ",\"h\":";
	s += val.h;
	s += "}";

	return s;
}

function AddKeyBool(key, val)
{
	var s = AddKey(key);
	s += val;
	s += ",\n";

	return s;
}

function beginExport(meta)
{
//	fl.trace("==== beginExport");
//	fl.trace(meta.app);
//	fl.trace(meta.version);
//	fl.trace(meta.image);
//	fl.trace(meta.format);
//	fl.trace(meta.size.w);
//	fl.trace(meta.size.h);
//	fl.trace(meta.scale);
//	fl.trace("---- beginExport");
	
	hitFrame = false;

	return "{\"frames\": [\n";
}

function frameExport(frame)
{
//	fl.trace("==== frameExport");
//	fl.trace(frame.id);
//	fl.trace(frame.frame.x);
//	fl.trace(frame.frame.y);
//	fl.trace(frame.frame.w);
//	fl.trace(frame.frame.h);
//	fl.trace(frame.offsetInSource.x);
//	fl.trace(frame.offsetInSource.y);
//	fl.trace(frame.sourceSize.w);
//	fl.trace(frame.sourceSize.h);
//	fl.trace(frame.rotated);
//	fl.trace(frame.trimmed);
//	fl.trace(frame.frameNumber);
//	fl.trace(frame.symbolName);
//	fl.trace(frame.frameLabel);
//	fl.trace(frame.lastFrameLabel);
//	fl.trace("---- frameExport");
	
	var s;
	if (hitFrame)
		s = "\n,{\n";
	else
		s = "\n{\n";
	s += AddKeyRect("frame", frame.frame);
	s+= ",\n";
	var spriteSourceSize = new Object();
	spriteSourceSize.x = frame.offsetInSource.x;
	spriteSourceSize.y = frame.offsetInSource.y;
	spriteSourceSize.w = frame.sourceSize.w;
	spriteSourceSize.h = frame.sourceSize.h;
	s += AddKeyRect("offset", spriteSourceSize);
	s += "}";

	hitFrame = true;

	return s;
}

function endExport(meta)
{
//	fl.trace("==== endExport");
//	fl.trace(meta.app);
//	fl.trace(meta.version);
//	fl.trace(meta.image);
//	fl.trace(meta.format);
//	fl.trace(meta.size.w);
//	fl.trace(meta.size.h);
//	fl.trace(meta.scale);
//	fl.trace("---- endExport");
	
	var s = "],\n\"meta\": {\n";
	s += AddKeyStr("app", meta.app);
	s += AddKeyStr("version", meta.version);
	s += AddKeyStr("image", meta.image);
	s += AddKeyStr("format", meta.format);
	s += AddKeySize("size", meta.sheetWidth, meta.sheetHeight, true);
	s += AddKeyNum("scale", 1.0, false);
	s += "\n}\n}\n";

	return s;
}
