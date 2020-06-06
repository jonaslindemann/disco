public class FlockingStage extends EffectStage {
    
    Node _rootNode;
    Flocking _flocking;
    
    public FlockingStage(PApplet parent, ControlParams params, AudioInput player)
    {
        super(parent, params, player, "flocking_stage");
    }
    
    void doSetup()
    {
        scene().setRadius(20.0);
        scene().fit();
        
        _rootNode = new Node(scene());    
        
        _flocking = new Flocking(_rootNode, parent(), params(), player());
        _flocking.init();        
        
    }
    
    void doActivate()
    {
        params().setParamProp(14, 0, 0.0, 0.5, 0.25);  // target size
        params().setParamProp(15, 0, 0.0, 1.0, 0.2);    // shrink    
        params().setParamProp(16, 0, 0.0, 2.0, 0.5);    // shrink    
    }
     
    void reverse()
    {
        _flocking.reverse();    
    }
    
    void doUpdate()
    {        
        _flocking.setShrink(params().value(15));
        _flocking.setFftScale(params().value(14));
        _flocking.setScale(params().value(16));
        _flocking.updateAnim();        
    }
}
