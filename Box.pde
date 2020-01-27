public class Box extends Node {

    float _w, _h, _d;
    int _color;
    float _colorTreshold;
    
    PVector _vel;
    PVector _acc;
    PVector _target;
    PVector _pos;
    PVector _explAcc;

    float _maxSpeed;
    float _maxForce;
    float _maxSpeedAvoid;
    float _maxForceAvoid;
    
    PApplet _applet;
    
    PVector _desired;
    PVector _steer;   
    PVector _desired2;
    PVector _steer2;   
    
    GlobalTarget _globalTarget;

    public Box(Node parent, PApplet applet) 
    {
        super(parent);
        
        _applet = applet;
        
        _color = color(255, 0, 0);
        _w = 1.0;
        _h = 1.0;
        _d = 1.0;
        _colorTreshold = 0.0;
        
        _pos = new PVector(0.0, 0.0, 0.0);
        _vel = new PVector(0.0, 0.0, 0.0);
        _acc = new PVector(0.0, 0.0, 0.0);
        _target = new PVector(0.0, 0.0, 0.0);
        _explAcc = new PVector(0.0, 0.0, 0.0);

        _target.x = this.translation().x();
        _target.y = this.translation().y();
        _target.z = this.translation().z();
        
        _maxSpeed = 2.0;
        _maxForce = 1.0;

        _maxSpeedAvoid = 5.0;
        _maxForceAvoid = 5.0;
        
        
        
        _desired = new PVector();
        _steer = new PVector();

        _desired2 = new PVector();
        _steer2 = new PVector();
        
    }
    
    void setTarget(float x, float y, float z)
    {
        _target.x = x;    
        _target.y = y;    
        _target.z = z;    
    }
    
    void setGlobalTarget(GlobalTarget t)
    {
        _globalTarget = t;    
    }
    
    void explode(PVector f)
    {
        _explAcc.set(f);
    }
    
    void applyForce(PVector f)
    {
        _acc.add(f);        
    }
    
    PVector seekTarget()
    {
        _desired = PVector.sub(_target, _pos);
        float d = _desired.mag();
        float speed = _maxSpeed;
        
        if (d<20.0)
            speed = _applet.map(d, 0.0, 20.0, 0.0, _maxSpeed); 
        
        _desired.setMag(speed);
        
        _steer = PVector.sub(_desired, _vel);
        _steer.limit(_maxForce);
        
        return _steer;
    }
    
    PVector avoidTarget()
    {
        PVector target = new PVector();
        target.set(_globalTarget.position().x(), _globalTarget.position().y(), _globalTarget.position().z()); 
       
        _desired = PVector.sub(target, _pos);
        float d = _desired.mag();
        float speed = 0.0;
        
        if (d<_globalTarget.radius())
            speed = _applet.map(d, 0.0, _globalTarget.radius(), _maxSpeedAvoid, 0.0); 
        
        _desired.setMag(-speed);
        
        _steer = PVector.sub(_desired, _vel);
        _steer.limit(_maxForceAvoid);
        
        return _steer;
    }    
       
    void updateBehavior()
    {
        PVector steer = seekTarget();
        applyForce(steer);
        steer = avoidTarget();
        applyForce(steer);
        applyForce(_explAcc);
        _explAcc.set(0.0, 0.0, 0.0);
    }
    
    void updateAnim()
    {
        _pos.x = this.translation().x();
        _pos.y = this.translation().y();
        _pos.z = this.translation().z();
        
        updateBehavior();
        
        _pos.add(_vel);
        _vel.add(_acc);
        _acc.mult(0.0);
        
        this.setTranslation(_pos.x, _pos.y, _pos.z);
    }
  
    void setSize(float w, float h, float d)
    {
        _w = w;
        _h = h;
        _d = d;
    }
  
    void setColor(int tint)
    {
        _color = tint;
    }
    
    void setColorTreshold(float treshold)
    {
        _colorTreshold = treshold;
    }

    @Override
    public void graphics(PGraphics pg) 
    {
        pg.pushStyle();
        pg.noStroke();
        pg.fill(_color);
        pg.box(_w, _h, _d);
        //pg.stroke(0);
        //pg.box(_w, _h, _d);
        pg.popStyle();
    }

    public void updateOrientation(Vector v) 
    {
        Vector to = Vector.subtract(v, position());
        setOrientation(new Quaternion(new Vector(0, 1, 0), to));
    }
}
