public class EffectStage {
    
    PApplet _parent;
    Scene _scene;
    ControlParams _params;
    AudioPlayer _player;
    
    public EffectStage(PApplet parent, ControlParams params, AudioPlayer player)
    {
        _parent = parent;
        _params = params;
        _player = player;
        _scene = new Scene(_parent, P3D);
    }
    
    void activate()
    {
    }
    
    void setup()
    {
    }
    
    void draw()
    {
        
    }
    
    void update()
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
    
    AudioPlayer player()
    {
        return _player;   
    }
   
}
