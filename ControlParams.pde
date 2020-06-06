import java.lang.reflect.Method;

class ControlParams {

    int[] paramVal;
    int[] paramNum;
    int[] paramType;

    float[] valueMax;
    float[] valueMin;
    float[] value;
    
    MidiBus _midiBus;
    PApplet _parent;
    
    Method controlButtonPressedEvent;
    
    ControlParams(PApplet parent, MidiBus bus)
    {
        _parent = parent;
        _midiBus = bus;        
        
        paramVal = new int[128];
        paramNum = new int[128];
        paramType = new int[128];
        valueMax = new float[128];
        valueMin = new float[128];
        value = new float[128];
        
        for (int i=0; i<64; i++)
        {
            paramNum[i] = -1;
            paramVal[i] = 0;
            paramType[i] = 0;
            valueMax[i] = 1.0;
            valueMin[i] = -1.0;
            value[i] = 0.0;
        }
        
        try 
        {
            controlButtonPressedEvent = _parent.getClass().getMethod("controlButtonPressed", int.class);
        }
        catch (Exception e)
        {
            println("controlButtonEvent not found");    
            e.printStackTrace();
        }
    }
    
    void setParamProp(int n, int ptype, float minVal, float maxVal, float defVal)
    {
        paramNum[n] = n;
        paramType[n] = ptype;
        valueMax[n] = maxVal;
        valueMin[n] = minVal;
        value[n] = defVal;
        midiBus.sendControllerChange(0, n, ctlValue(n));
    }
    
    void setButtonProp(int n)
    {
        setParamProp(n, 1, 0.0, 1.0, 0.0);    
    }
    
    void setButtonProps(int start, int end)
    {
        for (int i=start; i<=end; i++)
            setButtonProp(i);
    }
    
    void updateParams(int channel, int number, int v)
    {       
        if (paramNum[number]>=0)
        {
            if (paramType[number] == 0)
            {
                println("Controller ", number, " value = ", v);
                paramVal[number] = v;
            
                float valueRange = valueMax[number] - valueMin[number];
                        
                value[number] = valueMin[number] + v * valueRange / 127.0;
            
                if (value[number]>valueMax[number])
                    value[number] = valueMax[number];
                if (value[number]<valueMin[number])
                    value[number] = valueMin[number];
            }
            if (paramType[number] == 1)
            {
                if (v == 127)
                {
                    println("Controller ", number, " pressed");
                    if (controlButtonPressedEvent!=null)
                    {
                        try 
                        {
                            controlButtonPressedEvent.invoke(_parent, number);
                        }
                        catch (Exception e)
                        {
                            
                        }
                    }
                }
            }
        }
    }
    
    int ctlValue(int idx)
    {
        float x = (value[idx] - valueMin[idx]) / (valueMax[idx] - valueMin[idx]);
        return int(x*127.0);
    }
    
    float value(int idx)
    {
        return value[idx];    
    }
    
    void setValue(int idx, float v)
    {
        value[idx] = v;   
        _midiBus.sendControllerChange(0, idx, ctlValue(idx));
    }
}
