public class BoxGrid extends Node {

    float _w, _h, _d;
    int _rows, _cols, _layers;
    float _rowSpacing, _colSpacing, _layerSpacing;
    float _shrink;
    int _color;
    Node _nodeParent;
    
    Box[][][] _nodeArr;
    
    PApplet _applet;
    ControlParams _params;
    GlobalTarget _globalTarget;
    AudioInput _player;
    FFT _fft;

    public BoxGrid(Node parent, PApplet applet, ControlParams params, AudioInput player) 
    {
        super(parent);
        
        _applet = applet; //<>// //<>// //<>//
        _params = params;
        _player = player;
        
        _fft = new FFT( _player.bufferSize(), _player.sampleRate() );
  
        // calculate the averages by grouping frequency bands linearly. use 30 averages.
        _fft.linAverages( 30 );
        
        _color = color(255, 0, 0);
        
        _nodeParent = parent;
        
        _globalTarget = null;
              
        _rows = 1;
        _cols = 1;
        _layers = 1;
        
        _shrink = 1.0;
        
        // |----|----|----|
        
        _rowSpacing = 2*_h;
        _colSpacing = 2*_w;
        _layerSpacing = 2*_d;
    }
   
    void initGridNode()
    {
        _nodeArr = new Box[_rows][_cols][_layers]; //<>// //<>// //<>// //<>//
        
        float xMin = -_w/2.0+_w*0.5/_cols;
        float yMin = -_h/2.0+_h*0.5/_rows;
        float zMin = -_d/2.0+_d*0.5/_layers;
        
        _rowSpacing = _h/(_rows);
        _colSpacing = _w/(_cols);
        _layerSpacing = _d/(_layers);             
        
        if ((_cols>1)&&(_rows>1)&&(_layers>1))
        {
            for (int layer = 0; layer<_layers; layer++)
                for (int col = 0; col<_cols; col++)
                    for (int row = 0; row<_rows; row++)
                    {
                        Box box = new Box(this, _applet);
                        box.setSize(_w*_shrink/_cols, _h*_shrink/_rows, _d*_shrink/_layers);
                        box.setGlobalTarget(_globalTarget);

                        //box.setTranslation(xMin + col*_colSpacing, yMin + row*_rowSpacing, zMin + layer*_layerSpacing);
                        //box.setTarget(xMin + col*_colSpacing, yMin + row*_rowSpacing, zMin + layer*_layerSpacing);

                        box.setTranslation(_applet.random(-_w*10.0, _w*10.0), _applet.random(-_h*10.0, _h*10.0), _applet.random(-_h*10.0, _h*10.0));
                        box.setTarget(xMin + col*_colSpacing, yMin + row*_rowSpacing, zMin + layer*_layerSpacing);
                        
                        box.setColor(_color);
                        _nodeArr[row][col][layer] = box;
                    }
        }
    }
    
    void explode(float acc)
    {
        PVector explVec = new PVector();
        
        for (int layer = 0; layer<_layers; layer++)
            for (int col = 0; col<_cols; col++)
                for (int row = 0; row<_rows; row++)
                {
                    Box box = _nodeArr[row][col][layer];
                    explVec.set(box.translation().x(), box.translation().y(), box.translation().z());
                    explVec.normalize();
                    explVec.mult(acc + _applet.random(0.2*acc));
                    box.explode(explVec);
                }                
    }
    
    void setColor(int row, int col, int layer, int c)
    {
        _nodeArr[row][col][layer].setColor(c);     
    }
    
    void setGlobalTarget(GlobalTarget t)
    {
        _globalTarget = t;
    }
    
    void randomColors()
    {
            for (int layer = 0; layer<_layers; layer++)
                for (int col = 0; col<_cols; col++)
                    for (int row = 0; row<_rows; row++)
                    {
                        Box box = _nodeArr[row][col][layer];
                        box.setColor(color(_applet.random(255), _applet.random(255), _applet.random(255)));
                    }        
    }
        
    void updateAnim()
    {
        _fft.forward(_player.mix);
        
        float nscl = 0.15;
        float tscl = _fft.getAvg(0)*0.05 + millis()/5000.0;
        for (int layer = 0; layer<_layers; layer++)
            for (int col = 0; col<_cols; col++)
                for (int row = 0; row<_rows; row++)
                {
                    Box box = _nodeArr[row][col][layer];
                    //box.setSize(_fft.getAvg(0), _fft.getAvg(0), _fft.getAvg(0));
                    box.setSize(_w*_shrink/_cols, _h*_shrink/_rows, _d*_shrink/_layers);
                    box.updateAnim();
                    box.setColor(
                        color(
                            255*_applet.noise(row*nscl+tscl, col*nscl+tscl, layer*nscl+tscl), 
                            255*_applet.noise(row*nscl+tscl, col*nscl+tscl, layer*nscl+tscl-3.0), 
                            255*_applet.noise(row*nscl+tscl, col*nscl+tscl, layer*nscl+tscl+4.0)));
                }                
    }
    
    void setColorTreshold(float treshold)
    {
        for (int layer = 0; layer<_layers; layer++)
            for (int col = 0; col<_cols; col++)
                for (int row = 0; row<_rows; row++)
                {
                    Box box = _nodeArr[row][col][layer];
                    box.setColorTreshold(treshold);
                }                
    }

    void setSize(float w, float h, float d)
    {
        _w = w;
        _h = h;
        _d = d;
        
        _rowSpacing = _h/(_rows);
        _colSpacing = _w/(_cols);
        _layerSpacing = _d/(_layers);
    }
  
    void setColor(int tint)
    {
        _color = tint;
    }
    
    void setSpacing(float rowSpacing, float colSpacing, float layerSpacing)
    {
        _rowSpacing = rowSpacing;        
        _colSpacing = colSpacing;        
        _layerSpacing = layerSpacing;        
    }

    void setGridSize(int rows, int cols, int layers)
    {
        _rows = rows;
        _cols = cols;
        _layers = layers;
        
        this.initGridNode();
    }
    
    void setShrink(float shrink)
    {
        _shrink = shrink;
    }
        
    void update()
    {
        initGridNode();        
    }

    public void updateOrientation(Vector v) 
    {
        Vector to = Vector.subtract(v, position());
        setOrientation(new Quaternion(new Vector(0, 1, 0), to));
    }
}
