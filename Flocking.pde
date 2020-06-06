public class Flocking extends Node {

    Node _nodeParent;    
    PApplet _applet;
    ControlParams _params;
    AudioInput _player;
    FFT _fft;
    
    int _rows;
    int _cols;
    float _w;
    float _d;
    float _rowSpacing;
    float _colSpacing;
    float _shrink;
    float _scale;
    float _fftScale;
    
    int _currentRow;
    
    ArrayList<Particle> _particles;
    
    Particle[][] _partArr;    

    public Flocking(Node parent, PApplet applet, ControlParams params, AudioInput player) 
    {
        super(parent);
        
        _applet = applet;
        _params = params;
        _player = player;
        _fft = new FFT( _player.bufferSize(), _player.sampleRate() );
        _nodeParent = parent;
        
        _rows = 100;
        _cols = 100;

        _fft.linAverages( _cols );
        
        _currentRow = 0;
    
        _w = 20.0;
        _d = 20.0;
        _scale = 0.5;
        
        _fftScale = 1.0;
        
        _particles = new ArrayList<Particle>();
        
    }
     
    void init()
    {
        _rowSpacing = _d / (_rows - 1);
        _colSpacing = _w / (_cols - 1);       
       
        float xMin = -_w/2.0+_w*0.5/_cols;
        float zMin = -_d/2.0+_d*0.5/_rows;
        
        _partArr = new Particle[_rows][_cols];
                
        if ((_cols>1)&&(_rows>1))
        {
            for (int row = 0; row<_rows; row++)
                for (int col = 0; col<_cols; col++)
                {
                    Particle p = new Particle(this, _applet);

                    p.setPos(_applet.random(-_w*10.0, _w*10.0), _applet.random(-_w*10.0, _w*10.0), _applet.random(-_w*10.0, _w*10.0));
                    p.setTarget(xMin + col*_colSpacing, 0.0, zMin + row*_rowSpacing);
                    
                    _particles.add(p);
                    _partArr[row][col] = p;
                }
        }
        
        /*
        for (Particle p : _particles)
        {
            p.setAvoid(_particles.get(int(_applet.random(_particles.size()))));
        }
        */
    }
    
    void setScale(float scl)
    {
        _scale = scl;    
    }
    
    void reverse()
    {
        for (Particle p : _particles)
        {
            PVector pos = new PVector();
            pos.x = p.pos().x;
            pos.y = p.pos().y;
            pos.z = p.pos().z;
            p.setTarget(p.startPos());
            p.setPos(pos.x, pos.y, pos.z);
        }
    }
        
        
    void updateAnim()
    {
        _fft.forward(_player.mix);
        
        float nscl = 0.05;
        float tscl = _fft.getAvg(0)*0.2 + millis()/5000.0;
        
        for (Particle p : _particles)
            p.updateAnim();
                    
        /*
        for (int col=0; col<_cols; col++)
        {
            Particle p = _partArr[_currentRow][col];
            PVector pos = p.target();
            //pos.add(0.0, -_fft.getAvg(col),0.0);
            //_partArr[_currentRow][col].setPos(pos.x, pos.y, pos.z);
            p.setTarget(pos.x, pos.y -_fft.getAvg(abs(_cols/2 - col))*_fftScale, pos.z);
        }
        */
        
        for (int col=0; col<_cols; col++)
            for (int row=0; row<_rows; row++)
            {
                Particle p = _partArr[row][col];
                p.setSize(_shrink, _shrink, _shrink);
                p.setColor(
                    color(
                        383*_applet.noise(row*nscl+tscl, col*nscl+tscl, col*nscl+tscl), 
                        192*_applet.noise(row*nscl+tscl, col*nscl+tscl, col*nscl+tscl-3.0), 
                        192*_applet.noise(row*nscl+tscl, col*nscl+tscl, col*nscl+tscl+4.0)));
                        
                PVector pos = p.pos();
                        
               p.setPos(pos.x, pos.y + _scale*(0.5-_applet.noise(row*nscl+tscl, col*nscl+tscl, col*nscl+tscl)), pos.z);
               
               float scl = _shrink * _applet.noise(row*nscl+tscl, col*nscl+tscl, col*nscl+tscl+4.0);
               
               p.setSize(scl, scl, scl);
            }
        
        
        _currentRow++;
        
        if (_currentRow>=_rows)
            _currentRow = 0;
        
    }
    
    void setShrink(float shrink)
    {
        _shrink = shrink;
    }
    
    void setFftScale(float scale)
    {
        _fftScale = scale;    
    }
    
    void update()
    {

    }
}
