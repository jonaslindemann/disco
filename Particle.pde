public class Particle extends Node {

    int _color;
    float _w, _h, _d;
    
    PVector _vel;
    PVector _acc;
    PVector _target;
    Particle _avoid;
    PVector _pos;
    PVector _orgPos;
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
        
    public Particle(Node parent, PApplet applet) 
    {
        super(parent);
        
        _applet = applet;
        
        _color = color(255, 255, 0);
        
        _pos = new PVector(0.0, 0.0, 0.0);
        _vel = new PVector(0.0, 0.0, 0.0);
        _acc = new PVector(0.0, 0.0, 0.0);
        _target = new PVector(0.0, 0.0, 0.0);
        _avoid = null;
        _explAcc = new PVector(0.0, 0.0, 0.0);
        _orgPos = new PVector(0.0, 0.0, 0.0);

        _target.x = this.translation().x();
        _target.y = this.translation().y();
        _target.z = this.translation().z();
        
        _maxSpeed = 2.0;
        _maxForce = 1.0;

        _maxSpeedAvoid = 10.0;
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
    
    void setAvoid(Particle p)
    {
        _avoid = p;    
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
        if (_avoid == null)
            return new PVector(0.0, 0.0, 0.0);
            
        PVector target = new PVector();
        target.set(_avoid.translation().x(), _avoid.translation().y(), _avoid.translation().z()); 
       
        _desired = PVector.sub(target, _pos);
        float d = _desired.mag();
        float speed = 0.0;
        
        if (d<20.0)
            speed = _applet.map(d, 0.0, 20.0, _maxSpeedAvoid, 0.0); 
        
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
    
    void setPos(float x, float y, float z)
    {
        _pos.x = x;    
        _pos.y = y;    
        _pos.z = z;
        _orgPos.x = _pos.x;
        _orgPos.y = _pos.y;
        _orgPos.z = _pos.z;
        
        this.setTranslation(_pos.x, _pos.y, _pos.z);
    }
    
    PVector pos()
    {
        return _pos;    
    }
    
    PVector target()
    {
        return _target;    
    }
    
    PVector startPos()
    {
        return _orgPos;
    }
    
    void setTarget(PVector target)
    {
        _target = target;    
        _pos.x = _orgPos.x;
        _pos.y = _orgPos.y;
        _pos.z = _orgPos.z;
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
    
    void setColor(int tint)
    {
        _color = tint;
    }
    
    void setSize(float w, float h, float d)
    {
        _w = w;
        _h = h;
        _d = d;
    }    
    
    @Override
    public void graphics(PGraphics pg) 
    {
        pg.pushStyle();
        pg.noStroke();
        //pg.stroke(0);
        pg.fill(_color);
        pg.sphereDetail(4);
        //pg.sphere(0.2);
        //pg.stroke(0);
        pg.box(_w, _h, _d);
        pg.popStyle();
    }

    public void updateOrientation(Vector v) 
    {
        Vector to = Vector.subtract(v, position());
        setOrientation(new Quaternion(new Vector(0, 1, 0), to));
    }
}
