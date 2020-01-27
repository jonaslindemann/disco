import ddf.minim.analysis.*;
import ddf.minim.*;

import themidibus.*; //Import the library

import nub.primitives.*;
import nub.core.*;
import nub.processing.*;

Minim minim;
AudioPlayer player;

MidiBus midiBus; 

ControlParams params;
PostFX postFX;

EffectStage effectStage;
BoxGridStage boxGridStage;
FlockingStage flockingStage;

PGraphics drawGraphics;
PVector lightVector;

int controlPressed;
boolean playing;

Vector xAxis() {
  return effectStage.scene().eye().worldDisplacement(new Vector(1, 0, 0));
}

Vector yAxis() {
  return effectStage.scene().eye().worldDisplacement(new Vector(0, 1, 0));
}

Vector zAxis() {
  return effectStage.scene().eye().worldDisplacement(new Vector(0, 0, 1));
}

void setup()
{
    //size(1920, 1080, P3D);
    fullScreen(P3D);
    
    minim = new Minim(this);    
    player = minim.loadFile("flash.mp3", 1024);
      
    MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.

    //midiBus = new MidiBus(this, "KOMPLETE KONTROL A25 MIDI", "KOMPLETE KONTROL A25 MIDI"); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.
    midiBus = new MidiBus(this, "TouchOSC Bridge", "TouchOSC Bridge"); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.
    
    params = new ControlParams(this, midiBus);
    params.setParamProp(14, 0, 0.0, 300.0, 5.0);  // target size
    params.setParamProp(15, 0, 0.0, 1.0, 0.5);    // shrink
    params.setParamProp(16, 0, -0.02, 0.02, 0.0); // rotation
    params.setParamProp(17, 0, -0.02, 0.02, 0.0); // rotation
    params.setParamProp(18, 0, -0.2, 0.2, 0.0); // rotation
    params.setButtonProps(30, 120);
       
    lightVector = new PVector();
    playing = false;
    
    // Scene setup
    
    boxGridStage = new BoxGridStage(this, params, player);
    boxGridStage.setup();
    
    flockingStage = new FlockingStage(this, params, player);
    flockingStage.setup();
    
    effectStage = flockingStage;
     //<>//
    // Setup post effect chain
    
    postFX = new PostFX(effectStage.scene(), params);  
}

void processMidiControls()
{
    if (controlPressed == 30)
        postFX.addEdgeFX();
    if (controlPressed == 31)
        postFX.addNoiseFX();
    if (controlPressed == 32)
        postFX.addRaysFX();
    if (controlPressed == 33)
        postFX.addHorizontalFX();
    if (controlPressed == 34)
        postFX.addKaleidoFX();
    if (controlPressed == 35)
        postFX.addPixelateFX();
    if (controlPressed == 36)
        postFX.addChromaBlurFX();
    if (controlPressed == 37)
        postFX.addScanlineFX();
    if (controlPressed == 38)
        postFX.addGlitchFX();
    if (controlPressed == 39)
        postFX.clear();
    if (controlPressed == 40)
        postFX.clearLast();
    if (controlPressed == 49)
        postFX.removeGlitchFX();
    if (controlPressed == 48)
        postFX.removeScanlineFX();
    if (controlPressed == 47)
        postFX.removeChromaBlurFX();
    if (controlPressed == 46)
        postFX.removePixelateFX();
    if (controlPressed == 45)
        postFX.removeKaleidoFX();
    if (controlPressed == 44)
        postFX.removeHorizontalFX();
    if (controlPressed == 43)
        postFX.removeRaysFX();
    if (controlPressed == 42)
        postFX.removeNoiseFX();
    if (controlPressed == 41)
        postFX.removeEdgeFX();
    if (controlPressed == 100)
    {
        effectStage = boxGridStage;
        effectStage.activate();
    }
    if (controlPressed == 101)
    {
        effectStage = flockingStage;
        effectStage.activate();
    }
        
    controlPressed = -1;    
}

void draw()
{
    // Check for MIDI inputs
    
    processMidiControls();
    
    // Update animation
    
    if (playing)
    {
        effectStage.update();
    }
    
    // Rendering chain
    
    Scene scene = effectStage.scene();
    
    PGraphics graphics = drawGraphics = scene.context();   
    
    scene.beginDraw();
        graphics.background(0);
        if (playing)
        {
            graphics.ambientLight(32, 32, 32);
            lightVector.set(sin(millis()*0.0002), cos(millis()*0.0001), sin(millis()*0.0003)); 
            graphics.directionalLight(255, 255, 255, lightVector.x, lightVector.y, lightVector.z);
            lightVector.set(sin(millis()*0.0001), cos(millis()*0.0002), sin(millis()*0.0005)); 
            graphics.directionalLight(255, 255, 255, lightVector.x, lightVector.y, lightVector.z);
            //box.setRotation(1.0, 0.0, 0.0, params.value(16));
            //box.setRotation(0.0, 1.0, 0.0, params.value(17));
            
            //scene.rotateCAD(params.value(16), params.value(17));
            scene.moveForward(params.value(18));
            scene.eye().orbit(xAxis(), params.value(16));
            scene.eye().orbit(yAxis(), params.value(17));
            scene.render();
        }
    scene.endDraw();
    
    if (!playing)
        drawGraphics = postFX.preApplyAll(graphics, drawGraphics);
    else
        drawGraphics = postFX.apply(graphics, drawGraphics);
       
    scene.display(drawGraphics);
}

void controlButtonPressed(int number)
{
    println("controlButtonPressed", number);
    controlPressed = number;  
    
    if (controlPressed == 60)
    {
        player.loop();
        playing = true;
    }
    if (controlPressed == 61)
    {
        player.pause();
        playing = false;
    }    
    if (controlPressed == 62)
    {
        player.rewind();
        playing = false;
    }    
}

void keyPressed()
{
    if (key == 'e')
        postFX.addEdgeFX();
    if (key == 'n')
        postFX.addNoiseFX();
    if (key == 'r')
        postFX.addRaysFX();
    if (key == 'h')
        postFX.addHorizontalFX();
    if (key == 'k')
        postFX.addKaleidoFX();
    if (key == 'p')
        postFX.addPixelateFX();
    if (key == 'b')
        postFX.addChromaBlurFX();
    if (key == 's')
        postFX.addScanlineFX();
    if (key == 'g')
        postFX.addGlitchFX();
    if (key == 'c')
        postFX.clear();
    if (key == ' ')
    {
        // Start music
        player.loop();
        playing = true;
    }
    
    if (key == '1')
    {
        effectStage = boxGridStage;
        effectStage.activate();
    }
        
    if (key == '2')
    {
        effectStage = flockingStage;
        effectStage.activate();
    }
}

void mouseDragged() 
{
  if (mouseButton == LEFT)
    effectStage.scene().mouseSpin();
  else if (mouseButton == RIGHT)
    effectStage.scene().mouseTranslate();
  else
    effectStage.scene().scale(mouseX - pmouseX);
}

void mouseWheel(MouseEvent event) 
{
    effectStage.scene().moveForward(event.getCount() * 20);
}

void controllerChange(int channel, int number, int value) 
{
    println(number, value);
    params.updateParams(channel, number, value);
}

void noteOn(int channel, int pitch, int velocity)
{
    println(channel+":"+pitch+":"+velocity);  
    //box.explode(velocity/8.0);
}
