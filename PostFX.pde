public class PresetFX {
    
    ArrayList<FX> _fxPreset;
    ArrayList<FX> _fxArr;
    int _nbr;
    
    public PresetFX(int nbr, ArrayList<FX> fxArr)
    {
        _fxPreset = new ArrayList<FX>();
        _fxArr = fxArr;
        _nbr = nbr;
    }
    
    void setNumber(int nbr)
    {
        _nbr = nbr;    
    }
    
    int number()
    {
        return _nbr;    
    }
    
    void clear()
    {
        _fxPreset.clear();    
    }
    
    void store(ArrayList<FX> fxArr)
    {
        this.clear();
        
        for (int i=0; i<fxArr.size(); i++)
            _fxPreset.add(fxArr.get(i));    
    }
    
    void apply(ArrayList<FX> _fx)
    {
        _fx.clear();
        
        for (int i=0; i<_fxPreset.size(); i++)
        {
            FX fx = _fxPreset.get(i);
            _fx.add(fx);
        }        
    }
    
    void save()
    {
        JSONObject json = new JSONObject();
        JSONArray presetList = new JSONArray();
        
        for (int i=0; i<_fxPreset.size(); i++)
        {
            FX fx = _fxPreset.get(i);
            presetList.append(fx.tag());
        }        
        
        json.setJSONArray("preset_list", presetList);
        saveJSONObject(json, "data/presetfx"+str(_nbr)+".json");
    }
    
    boolean fileExists(String path)
    {
        File file=new File(path);
        boolean exists = file.exists();
        if (exists) 
        {
            return true;
        }
        else 
        {
            return false;
        }
    }        
    
    void load()
    {
        String filename = dataPath("presetfx"+str(_nbr)+".json");
        
        if (!fileExists(filename))
        {
            println("Couldn't load "+filename);
            return;
        }
        
        JSONObject json = loadJSONObject(filename);
        JSONArray presetList = json.getJSONArray("preset_list");
        
        this.clear();
        
        for (int i=0; i<presetList.size(); i++)
        {
            _fxPreset.add(_fxArr.get(presetList.getInt(i)));
        }        
    }
}

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
    ThermalFX _thermalFX;
    Glitch2FX _glitch2FX;
    QuantizationFX _quantizationFX;
    HalftoneFX _halftoneFX;
    
    ArrayList<FX> _fx;
    ArrayList<FX> _fxArr;
    ArrayList<PresetFX> _fxPreset;
      
    boolean _preApplyDone;
    
    public PostFX(Scene scene, ControlParams params)
    {
        _scene = scene;
        _params = params;
        _preApplyDone = false;
        
        _fx = new ArrayList<FX>();
        _fxArr = new ArrayList<FX>();
        _fxPreset = new ArrayList<PresetFX>();
        
        // Preallocate effects
        
        _noiseFX = new NoiseFX();
        _noiseFX.setTag(0);
        _edgeFX = new EdgeFX(); 
        _edgeFX.setTag(1);
        _raysFX = new RaysFX();
        _raysFX.setTag(2);
        _horizontalFX = new HorizontalFX();
        _horizontalFX.setTag(3);
        _kaleidoFX = new KaleidoFX();
        _kaleidoFX.setTag(4);
        _pixelateFX = new PixelateFX();
        _pixelateFX.setTag(5);
        _chromaBlurFX = new ChromaBlurFX();
        _chromaBlurFX.setTag(6);
        _scanlineFX = new ScanlineFX();
        _scanlineFX.setTag(7);
        _glitchFX = new GlitchFX();
        _glitchFX.setTag(8);
        _thermalFX = new ThermalFX();
        _thermalFX.setTag(9);
        _glitch2FX = new Glitch2FX();
        _glitch2FX.setTag(10);
        _quantizationFX = new QuantizationFX();
        _quantizationFX.setTag(11);
        _halftoneFX = new HalftoneFX();
        _halftoneFX.setTag(12);
        
        _fxArr.add(_noiseFX);
        _fxArr.add(_edgeFX); 
        _fxArr.add(_raysFX);
        _fxArr.add(_horizontalFX);
        _fxArr.add(_kaleidoFX);
        _fxArr.add(_pixelateFX);
        _fxArr.add(_chromaBlurFX);
        _fxArr.add(_scanlineFX);
        _fxArr.add(_glitchFX);  
        _fxArr.add(_thermalFX);
        _fxArr.add(_glitch2FX);
        _fxArr.add(_quantizationFX);
        _fxArr.add(_halftoneFX);
        
        this.setupPresets();
    }
    
    void setupPresets()
    {
        println("Loading presets...");
        for (int i=0; i<10; i++)
        {
            PresetFX presetFX = new PresetFX(i, _fxArr);
            presetFX.load();
            _fxPreset.add(presetFX);
        }
    }
    
    void storePreset(int idx)
    {
        _fxPreset.get(idx).store(_fx);        
    }
    
    void applyPreset(int idx)
    {
        _fxPreset.get(idx).apply(_fx);    
    }
    
    void savePresets()
    {
        for (int i=0; i<10; i++)
            _fxPreset.get(i).save();
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
    
    void addGlitch2FX()
    {
        _fx.add(_glitch2FX);    
    }
    
    void removeGlitch2FX()
    {
        ArrayList<FX> fxToRemove;
        
        fxToRemove = new ArrayList<FX>();
        
        for (int i=0; i<_fx.size(); i++)
        {
            FX fx = _fx.get(i);
            if (fx instanceof Glitch2FX)
                fxToRemove.add(fx);
        }
        
        removeFX(fxToRemove);
    }

    void addThermalFX()
    {
        _fx.add(_thermalFX);    
    }
    
    void removeThermalFX()
    {
        ArrayList<FX> fxToRemove;
        
        fxToRemove = new ArrayList<FX>();
        
        for (int i=0; i<_fx.size(); i++)
        {
            FX fx = _fx.get(i);
            if (fx instanceof ThermalFX)
                fxToRemove.add(fx);
        }
        
        removeFX(fxToRemove);
    }
    
    void addQuantizationFX()
    {
        _fx.add(_quantizationFX);    
    }
    
    void removeQuantizationFX()
    {
        ArrayList<FX> fxToRemove;
        
        fxToRemove = new ArrayList<FX>();
        
        for (int i=0; i<_fx.size(); i++)
        {
            FX fx = _fx.get(i);
            if (fx instanceof QuantizationFX)
                fxToRemove.add(fx);
        }
        
        removeFX(fxToRemove);
    }    
   
    void addHalftoneFX()
    {
        _fx.add(_halftoneFX);    
    }
    
    void removeHalftoneFX()
    {
        ArrayList<FX> fxToRemove;
        
        fxToRemove = new ArrayList<FX>();
        
        for (int i=0; i<_fx.size(); i++)
        {
            FX fx = _fx.get(i);
            if (fx instanceof HalftoneFX)
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
        _fx.add(_thermalFX);
        _fx.add(_glitch2FX);
        _fx.add(_quantizationFX);
        _fx.add(_halftoneFX);
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
            fx.updateInputs();
            g = fx.apply(g0, g);
        }
        
        return g;
    }
}
