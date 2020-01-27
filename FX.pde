class FX {
    PShader _shader;
    PGraphics _graphics;
    String _filename;
    
    FX(String filename)
    {
        _shader = loadShader(filename);
        _graphics = createGraphics(width, height, P3D);
        _graphics.shader(_shader);
    }
    
    PGraphics apply(PGraphics g0, PGraphics g1)
    {
        return null;
    }
    
    PGraphics graphics()
    { 
        return _graphics;
    }
    
}

class EdgeFX extends FX {
    
    EdgeFX()
    {
        super("edge.glsl");
        _shader.set("aspect", 1.0/width, 1.0/height);
    }
    
    PGraphics apply(PGraphics g0, PGraphics g1)
    {
        _graphics.beginDraw();
        _shader.set("tex", g1);
        _graphics.image(g0, 0, 0);
        _graphics.endDraw();
        return _graphics;
    }
}

class PixelateFX extends FX {
    
    PixelateFX()
    {
        super("pixelate.glsl");
        _shader.set("xPixels", 192.0);
        _shader.set("yPixels", 108.0);
    }
    
    PGraphics apply(PGraphics g0, PGraphics g1)
    {
        _graphics.beginDraw();
        _shader.set("tex", g1);
        _graphics.image(g0, 0, 0);
        _graphics.endDraw();
        return _graphics;
    }
}

class RaysFX extends FX {
    
    RaysFX()
    {
        super("raysfrag.glsl");
        _shader.set("lightPositionOnScreen", 0.5, 0.5);
        _shader.set("lightDirDOTviewDir", 0.7);
    }
    
    PGraphics apply(PGraphics g0, PGraphics g1)
    {
        _graphics.beginDraw();
        _shader.set("otex", g1);
        _shader.set("rtex", g1);
        _graphics.image(g0, 0, 0);
        _graphics.endDraw();
        return _graphics;
    }
}

class KaleidoFX extends FX {
    
    KaleidoFX()
    {
        super("kaleido.glsl");
        _shader.set("segments", 2.0);
    }
    
    PGraphics apply(PGraphics g0, PGraphics g1)
    {
        _graphics.beginDraw();
        _shader.set("tex", g1);
        _graphics.image(g0, 0, 0);
        _graphics.endDraw();
        return _graphics;
    }
}

class NoiseFX extends FX {
    
    NoiseFX()
    {
        super("noise.glsl");
        _shader.set("frequency", 4.0);
        _shader.set("amplitude", 0.1);
        _shader.set("speed", 0.1);
    }
    
    PGraphics apply(PGraphics g0, PGraphics g1)
    {
        _graphics.beginDraw();
        _shader.set("time", millis() / 1000.0);       
        _shader.set("tex", g1);
        _graphics.image(g0, 0, 0);
        _graphics.endDraw();
        return _graphics;
    }
}

class HorizontalFX extends FX {
    
    HorizontalFX()
    {
        super("horizontal.glsl");
        _shader.set("h", 0.005);
        _shader.set("r", 0.5);
    }
    
    PGraphics apply(PGraphics g0, PGraphics g1)
    {
        _graphics.beginDraw();
        _shader.set("tDiffuse", g1);
        _shader.set("tex", g1);
        _graphics.image(g0, 0, 0);
        _graphics.endDraw();
        return _graphics;
    }
}

class ShaderToyFX extends FX {
    
    float _previousTime = 0.0;   
    boolean _mouseDragged = false;
    PVector _lastMousePosition;
    float _mouseClickState = 0.0;   

    ShaderToyFX(String filename)
    {
        super(filename);
        _shader.set("iResolution", float(width), float(height), 0.0);
        _lastMousePosition = new PVector(float(mouseX),float(mouseY));
    }
    
    void updateInputs()
    {
        
    }

    PGraphics apply(PGraphics g0, PGraphics g1)
    {
        _graphics.beginDraw();
        
        float currentTime = millis()/1000.0;
        
        _shader.set("iTime", currentTime);
        _shader.set("iChannel0", g1);
        _shader.set("iFrame", frameCount);
        _shader.set("iFrameRate", frameRate);

        float timeDelta = currentTime - _previousTime;
        _previousTime = currentTime;
        _shader.set("iDeltaTime", timeDelta);
        

        if(mousePressed) 
        { 
            _lastMousePosition.set(float(mouseX),float(mouseY));
            _mouseClickState = 1.0;
        } 
        else 
        {
            _mouseClickState = 0.0;
        }
        
        _shader.set( "iMouse", _lastMousePosition.x, _lastMousePosition.y, _mouseClickState, _mouseClickState);
        
        this.updateInputs();
        
        _graphics.image(g0, 0, 0);
        _graphics.endDraw();
        
        return _graphics;
    }
}

class ChromaBlurFX extends ShaderToyFX {
    
    float _maxDistort;
    
    ChromaBlurFX()
    {
        super("blur_chroma.glsl");
        _maxDistort = 0.5;        
    }
    
    void updateInputs()
    {
        _shader.set("iMaxDistort", _maxDistort);
    }
    
}

class ScanlineFX extends ShaderToyFX {
    
    float _maxDistort;
    
    ScanlineFX()
    {
        super("scanline.glsl");
        _maxDistort = 0.5;        
    }
    
    void updateInputs()
    {
        _shader.set("iMaxDistort", _maxDistort);
    }
}

class GlitchFX extends ShaderToyFX {

    GlitchFX()
    {
        super("glitch.glsl");
    }
    
    void updateInputs()
    {
    }   
}
