public class EffectStage {
    
    PApplet _parent;
    Scene _scene;
    ControlParams _params;
    AudioInput _player;
    Interpolator _eyeInterpolator;
    String _name;
    
    
    public EffectStage(PApplet parent, ControlParams params, AudioInput player, String name)
    {
        _name = name;
        _parent = parent;
        _params = params;
        _player = player;
        _scene = new Scene(_parent, P3D);
        _eyeInterpolator = new Interpolator(_scene.eye());
        _eyeInterpolator.enableRecurrence();
        _eyeInterpolator.task().setFrequency(60);
        _eyeInterpolator.setSpeed(0.4);
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
        
    void activate()
    {
        _eyeInterpolator.task().stop();
        _eyeInterpolator.run();
        doActivate();
    }
    
    void doActivate()
    {
        
    }
    
    void deactivate()
    {
        if (_eyeInterpolator.task().isActive())
        {
            _eyeInterpolator.task().stop();
        }
        doDeactivate();   
    }
    
    void doDeactivate()
    {
        
    }
    
    void setup()
    {
        doSetup();    
    }
    
    void doSetup()
    {
        
    }
    
    void draw()
    {
        doDraw();    
    }
    
    void doDraw()
    {
        
    }
    
    void update()
    {
        if (_eyeInterpolator.speed()>0.0)
        {
            if (_eyeInterpolator.time()>_eyeInterpolator.duration()-0.05)
            {
                _eyeInterpolator.setSpeed(-_eyeInterpolator.speed());
            }
        }
        else
        {
            if (_eyeInterpolator.time()<0.05)
            {
                _eyeInterpolator.setSpeed(-_eyeInterpolator.speed());
            }
        }
        
        doUpdate();
    }
    
    void doUpdate()
    {
        
    }
    
    void saveState()
    {
        println("Saving keyframe state for", this.name());
        
        JSONObject json = new JSONObject();

        // Save eye interpolator
        
        JSONArray jsonArray = new JSONArray();
               
        List<Float> sortedKeys = new ArrayList<Float>(_eyeInterpolator.keyFrames().size());
        sortedKeys.addAll(_eyeInterpolator.keyFrames().keySet());
        Collections.sort(sortedKeys); 
        
        for (int i=0; i<sortedKeys.size(); i++)
        {
            float value = sortedKeys.get(i); 
            Node node = _eyeInterpolator.keyFrames().get(value);
            
            JSONObject keyFrame = new JSONObject(); 
            
            keyFrame.setFloat("ox", node.orientation().x());
            keyFrame.setFloat("oy", node.orientation().y());
            keyFrame.setFloat("oz", node.orientation().z());
            keyFrame.setFloat("ow", node.orientation().w());            

            keyFrame.setFloat("x", node.position().x());
            keyFrame.setFloat("y", node.position().y());
            keyFrame.setFloat("z", node.position().z());
            
            jsonArray.setJSONObject(i, keyFrame);
        }
        
        json.setJSONArray("eye_interpolator", jsonArray);
        
        doSaveState(json);
        saveJSONObject(json, "data/"+this.name()+".json");
    }
    
    void doSaveState(JSONObject json)
    {
                
    }
    
    void loadState()
    {
        println("Loading keyframe state for", this.name());
              
        if (!fileExists(dataPath(this.name()+".json")))
            return;
        
        JSONObject json = loadJSONObject("data/"+this.name()+".json");
        
        JSONArray jsonArray = json.getJSONArray("eye_interpolator");
       
        // Read eye interpolator
        
        _eyeInterpolator.clear();        
        
        for (int i=0; i<jsonArray.size(); i++)
        {
            println("Adding keyframe");
            JSONObject keyFrame = jsonArray.getJSONObject(i);
            float ox = keyFrame.getFloat("ox");
            float oy = keyFrame.getFloat("oy");
            float oz = keyFrame.getFloat("oz");
            float ow = keyFrame.getFloat("ow");
            float x = keyFrame.getFloat("x");
            float y = keyFrame.getFloat("y");
            float z = keyFrame .getFloat("z");
            _scene.eye().setOrientation(ox, oy, oz, ow);
            _scene.eye().setPosition(x, y, z);
            _eyeInterpolator.addKeyFrame();
        }
        doLoadState(json);
    }
    
    void doLoadState(JSONObject json)
    {
        
    }
    
    Scene scene()
    {
        return _scene;    
    }
    
    PApplet parent()
    {
        return _parent;
    }
    
    ControlParams params()
    {
        return _params;    
    }
    
    AudioInput player()
    {
        return _player;   
    }
    
    Interpolator eyeInterpolator()
    {
        return _eyeInterpolator;    
    }
    
    String name()
    {
        return _name;    
    }
   
}
