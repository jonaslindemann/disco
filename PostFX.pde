public class PostFX {
    
    Scene _scene;
    ControlParams _params;
    
    NoiseFX _noiseFX;
    EdgeFX _edgeFX;
    RaysFX _raysFX;
    HorizontalFX _horizontalFX;
    KaleidoFX _kaleidoFX;
    PixelateFX _pixelateFX;
    ChromaBlurFX _chromaBlurFX;
    ScanlineFX _scanlineFX;
    GlitchFX _glitchFX;
    
    ArrayList<FX> _fx;
    
    boolean _preApplyDone;
    
    public PostFX(Scene scene, ControlParams params)
    {
        _scene = scene;
        _params = params;
        _preApplyDone = false;
        
        _fx = new ArrayList<FX>();
        
        // Preallocate effects
        
        _noiseFX = new NoiseFX();
        _edgeFX = new EdgeFX(); 
        _raysFX = new RaysFX();
        _horizontalFX = new HorizontalFX();
        _kaleidoFX = new KaleidoFX();
        _pixelateFX = new PixelateFX();
        _chromaBlurFX = new ChromaBlurFX();
        _scanlineFX = new ScanlineFX();
        _glitchFX = new GlitchFX();
    }
    
    void addNoiseFX()
    {
        _fx.add(_noiseFX);
    }
    
    void removeNoiseFX()
    {
        ArrayList<FX> fxToRemove;
        
        fxToRemove = new ArrayList<FX>();
        
        for (int i=0; i<_fx.size(); i++)
        {
            FX fx = _fx.get(i);
            if (fx instanceof NoiseFX)
                fxToRemove.add(fx);
        }
        
        removeFX(fxToRemove);
    }            
    
    void addEdgeFX()
    {
        _fx.add(_edgeFX);
    }
    
    void removeEdgeFX()
    {
        ArrayList<FX> fxToRemove;
        
        fxToRemove = new ArrayList<FX>();
        
        for (int i=0; i<_fx.size(); i++)
        {
            FX fx = _fx.get(i);
            if (fx instanceof EdgeFX)
                fxToRemove.add(fx);
        }
        
        removeFX(fxToRemove);
    }            

    void addRaysFX()
    {
        _fx.add(_raysFX);
    }
    
    void removeRaysFX()
    {
        ArrayList<FX> fxToRemove;
        
        fxToRemove = new ArrayList<FX>();
        
        for (int i=0; i<_fx.size(); i++)
        {
            FX fx = _fx.get(i);
            if (fx instanceof RaysFX)
                fxToRemove.add(fx);
        }
        
        removeFX(fxToRemove);
    }           

    void addHorizontalFX()
    {
        _fx.add(_horizontalFX);
    }
    
    void removeHorizontalFX()
    {
        ArrayList<FX> fxToRemove;
        
        fxToRemove = new ArrayList<FX>();
        
        for (int i=0; i<_fx.size(); i++)
        {
            FX fx = _fx.get(i);
            if (fx instanceof HorizontalFX)
                fxToRemove.add(fx);
        }
        
        removeFX(fxToRemove);
    }            

    void addKaleidoFX()
    {
        _fx.add(_kaleidoFX);
    }
    
    void removeKaleidoFX()
    {
        ArrayList<FX> fxToRemove;
        
        fxToRemove = new ArrayList<FX>();
        
        for (int i=0; i<_fx.size(); i++)
        {
            FX fx = _fx.get(i);
            if (fx instanceof KaleidoFX)
                fxToRemove.add(fx);
        }
        
        removeFX(fxToRemove);
    }            
    
    void addPixelateFX()
    {
        _fx.add(_pixelateFX);
    }
    
    void removePixelateFX()
    {
        ArrayList<FX> fxToRemove;
        
        fxToRemove = new ArrayList<FX>();
        
        for (int i=0; i<_fx.size(); i++)
        {
            FX fx = _fx.get(i);
            if (fx instanceof PixelateFX)
                fxToRemove.add(fx);
        }
        
        removeFX(fxToRemove);
    }        

    void addChromaBlurFX()
    {
        _fx.add(_chromaBlurFX);    
    }

    void removeChromaBlurFX()
    {
        ArrayList<FX> fxToRemove;
        
        fxToRemove = new ArrayList<FX>();
        
        for (int i=0; i<_fx.size(); i++)
        {
            FX fx = _fx.get(i);
            if (fx instanceof ChromaBlurFX)
                fxToRemove.add(fx);
        }
        
        removeFX(fxToRemove);
    }        
    
    void addScanlineFX()
    {
        _fx.add(_scanlineFX);    
    }

    void removeScanlineFX()
    {
        ArrayList<FX> fxToRemove;
        
        fxToRemove = new ArrayList<FX>();
        
        for (int i=0; i<_fx.size(); i++)
        {
            FX fx = _fx.get(i);
            if (fx instanceof ScanlineFX)
                fxToRemove.add(fx);
        }
        
        removeFX(fxToRemove);
    }    

    void addGlitchFX()
    {
        _fx.add(_glitchFX);    
    }
    
    void removeGlitchFX()
    {
        ArrayList<FX> fxToRemove;
        
        fxToRemove = new ArrayList<FX>();
        
        for (int i=0; i<_fx.size(); i++)
        {
            FX fx = _fx.get(i);
            if (fx instanceof GlitchFX)
                fxToRemove.add(fx);
        }
        
        removeFX(fxToRemove);
    }    

    void clear()
    {
        _fx.clear();    
    }
    
    void clearLast()
    {
        if (_fx.size()>0)
            _fx.remove(_fx.size()-1);
    }
    
    void removeFX(ArrayList<FX> fxList)
    {
        for (int i=0; i<fxList.size(); i++)
        {
            FX fx = fxList.get(i);
            _fx.remove(fx);
        }        
    }
    
    void addAllFX()
    {
        _fx.add(_noiseFX);
        _fx.add(_edgeFX); 
        _fx.add(_raysFX);
        _fx.add(_horizontalFX);
        _fx.add(_kaleidoFX);
        _fx.add(_pixelateFX);
        _fx.add(_chromaBlurFX);
        _fx.add(_scanlineFX);
        _fx.add(_glitchFX);            
    }
    
    PGraphics preApplyAll(PGraphics g0, PGraphics g1)
    {
        if (!_preApplyDone)
            this.addAllFX();
        
        PGraphics g = g1;
        
        if (!_preApplyDone)
        {
            println("Pre-initialising shaders...");
            
            for (int i=0; i<_fx.size(); i++)
            {
                FX fx = _fx.get(i);
                g = fx.apply(g0, g);
            }
            
            this.clear();
            
            _preApplyDone = true;
        }
        
        return g;
    }
    
    PGraphics apply(PGraphics g0, PGraphics g1)
    {
        PGraphics g = g1;
        
        for (int i=0; i<_fx.size(); i++)
        {
            FX fx = _fx.get(i);
            g = fx.apply(g0, g);
        }
        
        return g;
    }
}
