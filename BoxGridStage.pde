public class BoxGridStage extends EffectStage {
    
    Node _rootNode;
    GlobalTarget _target;
    BoxGrid _box;
    
    public BoxGridStage(PApplet parent, ControlParams params, AudioPlayer player)
    {
        super(parent, params, player);
    }
    
    void setup()
    {
        scene().setRadius(20.0);
        scene().fit();
        
        _rootNode = new Node(scene());    
        
        _box = new BoxGrid(_rootNode, parent(), params(), player());
        _target = new GlobalTarget(_box);
        _target.setRadius(20.0);
        _box.setGlobalTarget(_target);
        _box.setGridSize(10, 10, 10);
        _box.setShrink(0.5);
        _box.setSize(20.0, 20.0, 20.0);
        _box.update();        
    }
    
    void draw()
    {
        
    }
    
    void activate()
    {
        params().setParamProp(14, 0, 0.0, 300.0, 5.0);  // target size
        params().setParamProp(15, 0, 0.0, 1.0, 0.5);    // shrink
    }   
    
    void update()
    {
        _target.setRadius(params().value(14));
        
        float x = 10.0 * cos(millis()/1000.0);
        float y = 10.0 * sin(millis()/1000.0);
        float z = sqrt(pow(x,2)+pow(y,2)) * cos(millis()/300.0);
        
        _target.setTranslation(x, y, z);
        _box.setShrink(params().value(15));
        _box.updateAnim();        
    }
}
