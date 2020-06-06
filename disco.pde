import ddf.minim.analysis.*;
import ddf.minim.*;

import themidibus.*; //Import the library

import nub.primitives.*;
import nub.core.*;
import nub.processing.*;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;
import java.util.TreeSet;
import java.util.TreeMap;
import java.util.Map;
import java.util.Collections;
import java.util.SortedSet;
import java.util.List;

Minim minim;
AudioPlayer player;
AudioInput audioIn;

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
    player = minim.loadFile("disco2.mp3", 1024);
    audioIn = minim.getLineIn();
      
    MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.

    midiBus = new MidiBus(this, "KOMPLETE KONTROL A25 MIDI", "KOMPLETE KONTROL A25 MIDI"); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.
    //midiBus = new MidiBus(this, "TouchOSC Bridge", "TouchOSC Bridge"); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.
    //midiBus = new MidiBus(this, "loopMIDI Port 1", -1); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.
    
    params = new ControlParams(this, midiBus);
    params.setParamProp(14, 0, 0.0, 300.0, 5.0);  // target size
    params.setParamProp(15, 0, 0.0, 1.0, 0.8);    // shrink
    params.setParamProp(16, 0, -0.02, 0.02, 0.0); // rotation
    params.setParamProp(17, 0, -0.02, 0.02, 0.0); // rotation
    params.setParamProp(18, 0, -0.2, 0.2, 0.0); // rotation
    params.setButtonProps(30, 127);
       
    lightVector = new PVector();
    playing = false;
    
    // Scene setup
    
    boxGridStage = new BoxGridStage(this, params, audioIn);
    boxGridStage.setup();
    boxGridStage.loadState();
    
    flockingStage = new FlockingStage(this, params, audioIn);
    flockingStage.setup();
    flockingStage.loadState();
    
    effectStage = flockingStage;
     //<>// //<>//
    // Setup post effect chain
    
    postFX = new PostFX(effectStage.scene(), params);  
    
    frameRate(60);
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

    // Switchin Scene
        
    if (controlPressed == 100)
    {
        println("Switching to box grid.");
        effectStage = boxGridStage;
        effectStage.activate();
    }
    if (controlPressed == 101)
    {
        println("Switching to flocking.");
        effectStage = flockingStage;
        effectStage.activate();
    }
    
    // Camera controls
    
    if (controlPressed == 120)
    {
        println("Reset eye");
        Scene scene = effectStage.scene();
        scene.setRadius(20.0);
        scene.fit();
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
    
    
    //fill(255);
    //text(str(effectStage.eyeInterpolator().time()), 50, 50);    
}

void stop()
{
    println("stop()");
    boxGridStage.saveState();
    flockingStage.saveState();
    postFX.savePresets();
}

void controlButtonPressed(int number)
{
    controlPressed = number;  
    
    println("controlButtonPressed(",number,")");
    
    if (controlPressed == 60)
    {
        println("Start playing.");
        player.loop();
        playing = true;
    }
    if (controlPressed == 61)
    {
        //player.pause();
        playing = false;
    }    
    if (controlPressed == 62)
    {
        //player.rewind();
        playing = false;
    }    
}

void mouseDragged() 
{
  if (mouseButton == LEFT)
    effectStage.scene().mouseSpin();
  else if (mouseButton == RIGHT)
    effectStage.scene().mouseTranslate();
  else
      effectStage.scene().moveForward(mouseX - pmouseX);
    //effectStage.scene().scale(mouseX - pmouseX);
}

void mouseWheel(MouseEvent event) 
{
    effectStage.scene().moveForward(event.getCount() * 20);
}

void controllerChange(int channel, int number, int value) 
{
    params.updateParams(channel, number, value);
}

void noteOn(int channel, int pitch, int velocity)
{
    //println(channel+":"+pitch+":"+velocity);  
    //box.explode(velocity/8.0);
}


void keyPressed()
{ 
    println("key = "+str(int(key))+"keyCode = "+str(int(keyCode)));
    
    if (key == ESC)
        stop();
        
    if (key == '!')
        postFX.storePreset(1);
    if (key == '1')
        postFX.applyPreset(1);
        
    if (key == '"')
        postFX.storePreset(2);
    if (key == '2')
        postFX.applyPreset(2);

    if (key == '#')
        postFX.storePreset(3);
    if (key == '3')
        postFX.applyPreset(3);

    if (key == '¤')
        postFX.storePreset(4);
    if (key == '4')
        postFX.applyPreset(4);

    if (key == '%')
        postFX.storePreset(5);
    if (key == '5')
        postFX.applyPreset(5);

    if (key == '&')
        postFX.storePreset(6);
    if (key == '6')
        postFX.applyPreset(6);

    if (key == '/')
        postFX.storePreset(7);
    if (key == '7')
        postFX.applyPreset(7);

    if (key == '(')
        postFX.storePreset(8);
    if (key == '8')
        postFX.applyPreset(8);

    if (key == ')')
        postFX.storePreset(9);
    if (key == '9')
        postFX.applyPreset(9);

    if (key == '=')
        postFX.storePreset(0);
    if (key == '0')
        postFX.applyPreset(0);

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
    if (key == 'G')
        postFX.addGlitch2FX();
    if (key == 't')
        postFX.addThermalFX();
    if (key == 'q')
        postFX.addQuantizationFX();
    if (key == 'w')
        postFX.addHalftoneFX();
    if (key == 'c')
        postFX.clear();
    if (key == ' ')
    {
        // Start music
        player.loop();
        playing = true;

        effectStage = boxGridStage;
        effectStage.activate();
    }
    
    if (int(keyCode) == 97)
    {
        effectStage.deactivate();
        effectStage = boxGridStage;
        effectStage.activate();
    }
        
    if (int(keyCode) == 98)
    {
        effectStage.deactivate();
        effectStage = flockingStage;
        effectStage.activate();
    }
    
    if (key == '.')
    {
        println("Adding keyframe");
        effectStage.eyeInterpolator().addKeyFrame();
    }
    if (key == ',')
    {
        println("Adding keyframe");
        effectStage.eyeInterpolator().clear();
    }
    if (key == '-')
    {
        println("Adding keyframe");
        effectStage.eyeInterpolator().toggle();
    }
}
