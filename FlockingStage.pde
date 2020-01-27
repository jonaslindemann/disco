public class FlockingStage extends EffectStage {
    
    Node _rootNode;
    Flocking _flocking;
    
    public FlockingStage(PApplet parent, ControlParams params, AudioPlayer player)
    {
        super(parent, params, player);
    }
    
    void setup()
    {
        scene().setRadius(20.0);
        scene().fit();
        
        _rootNode = new Node(scene());    
        
        _flocking = new Flocking(_rootNode, parent(), params(), player());
        _flocking.init();        
        
    }
    
    void activate()
    {
        params().setParamProp(14, 0, 0.0, 0.5, 0.25);  // target size
        params().setParamProp(15, 0, 0.0, 0.5, 0.1);    // shrink    
    }
    
    void reverse()
    {
        _flocking.reverse();    
    }
    
    void update()
    {        
        _flocking.setShrink(params().value(15));
        _flocking.setFftScale(params().value(14));
        _flocking.updateAnim();        
    }
}
