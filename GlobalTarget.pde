class GlobalTarget extends Node {
    
    float _radius;
    int _color;   
    
    GlobalTarget(Node parent)
    {
        super(parent);
        _radius = 20.0;
        _color = color(255, 255, 255);
    }
        
    float radius()
    {
        return _radius;    
    }
    
    void setRadius(float r)
    {
        _radius = r;    
    }
    
    @Override
    public void graphics(PGraphics pg) 
    {
        pg.pushStyle();
        pg.noStroke();
        pg.fill(_color);
        pg.sphere(1.0);
        pg.popStyle();
    }   
}
