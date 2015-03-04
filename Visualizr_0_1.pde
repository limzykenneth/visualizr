import ddf.minim.analysis.*;
import ddf.minim.*;
import controlP5.*;

ControlP5 cp5;
ListBox l;
int test=0;

Minim minim;
AudioPlayer player;
FFT fft;
String path;

int theheight=256;
int thewidth=256;

void setup() {
  javax.swing.JOptionPane.showMessageDialog(null, "Welcome! Choose a music/sound on the next screen to visualize.\nPick method of visualization from the menu on the top left of the screen.", "Welcome",1);
  size(displayWidth, displayHeight);
  frameRate(60);
  
  //controlP5 list box initialization
  ControlP5.printPublicMethodsFor(ListBox.class);

  cp5 = new ControlP5(this);
  l = cp5.addListBox("myList")
         .setPosition(0, 15)
         .setSize(120, 120)
         .setItemHeight(15)
         .setBarHeight(15)
         .setColorBackground(color(200, 200, 200))
         .setColorActive(color(0))
         .setColorForeground(color(200, 200, 200))
         .setColorLabel(0)
         .toUpperCase(false)
         ;
          
  l.captionLabel().toUpperCase(true);
  l.captionLabel().set("Visualization");
  l.captionLabel().setColor(color(0));
  l.captionLabel().style().marginTop = 3;
  l.valueLabel().style().marginTop = 3;
  
  for (int i=0;i<4;i++) {
    ListBoxItem lbi = l.addItem("Type "+i, i);
    lbi.setColorBackground(color(255,255,255));
  }
         
  
  //music load and selection
  minim = new Minim(this);

  selectInput("Select an audio file or press cancel for default:", "fileSelected");
  player = minim.loadFile("default.mp3", 1024);


  fft = new FFT( player.bufferSize(), player.sampleRate() );
  
  colorMode(HSB, 360, 100, 100);
}


void fileSelected(File selection) {
  if (selection == null) {
    path = "default.mp3";
  } else {
    path = selection.getAbsolutePath();
  }
  player = minim.loadFile(path, 1024);
  player.play();
  player.loop();
}


void draw() {
  background(#FFFFFF);
  stroke(0);


  fft.forward( player.mix );

  int total=0;
  float[] bandList = new float[1024];
  float maxAmp=0;
  int maxIndex=0;

  for (int i = 0; i < fft.specSize (); i++)
  {

    //get all the amplitude of all frequency bands
    bandList[i]=fft.getBand(i);

    //get the index of the biggest amplitude
    if (bandList[i]>maxAmp) {
      maxAmp=bandList[i];
      maxIndex=i;
    }
  }



  //Display
  //text
  total=int(fft.indexToFreq(maxIndex));


  //let user choose which visualization to use
  switch(test){
    case 0: type_1(total); break;
    case 1: type_2(total); break;
    case 2: type_3(total); break;
    case 3: type_4(total); break;
  }

  //uncomment to ouput screenshots for every frame (resource intensive!)
  //saveFrame("output/frames####.tif");

  bandList=null;
}

void type_1(int level) {
  float rot=0;
  pushMatrix();
  translate(width/2, height/2);
  strokeWeight(1);
  for (int i = 0; i < player.bufferSize () - 1; i++)
  {
    rotate(rot);
    stroke((200*level/1024)+250, 100, 100*level/1024);
    line( 0, 20  - player.left.get(i)*150, 0, 20  - player.left.get(i+1)*150 );
    line( 0, 150 - player.right.get(i)*150, 0, 150 - player.right.get(i+1)*150 );
    rot+=TWO_PI/player.bufferSize();
  }
  popMatrix();
}

void type_2(int level) {
  float rot=0;
  pushMatrix();
  translate(width/2, height/2);
  for (int i = 0; i < player.bufferSize () - 1; i++)
  {
    rotate(rot);

    if (level>1000 && level<=2000) {
      strokeWeight(fft.getBand(i)+3);
    } else if (level>2000) {
      strokeWeight(fft.getBand(i)+5);
    } else {
      strokeWeight(fft.getBand(i));
    }

    stroke((200*level/1024)+250, 100, 100*level/1024);
    line( 0, 200, 1, 200 );
    line( 0, 100, 1, 100 );
    rot+=TWO_PI/player.bufferSize();
  }
  popMatrix();
}

void type_3(int level) {
  float rot=0;
  pushMatrix();
  translate(width/2, 3*height/4);
  rotate(PI/2);
  for (int i = 0; i < 128 - 1; i++)
  {
    rotate(radians(1.4));


    if (level>1000 && level<=2000) {
      strokeWeight(fft.getBand(i)+3);
    } else if (level>2000) {
      strokeWeight(fft.getBand(i)+5);
    } else {
      strokeWeight(fft.getBand(i));
    }

    stroke((200*level/1024)+250, 100, 100*level/1024);
    line( 0, 200, 1, 200 );
    line( 0, 100, 1, 100 );
    //rot+=radians(0.26);//(3*PI/2)/player.bufferSize();
  }
  popMatrix();
}

void type_4(int level){
  pushMatrix();
  translate(width/2,height/2);
  
  for (int i = 0; i < 128 - 1; i++)
  {
    rotate(radians(1.4));


    if (level>1000 && level<=2000) {
      strokeWeight(fft.getBand(i)+3);
    } else if (level>2000) {
      strokeWeight(fft.getBand(i)+5);
    } else {
      strokeWeight(fft.getBand(i));
    }

    stroke((200*level/1024)+250, 100, 100*level/1024);
    ellipse(i,i,level/4,level/4);
  }
  popMatrix();
}

//controlP5 supporting code

void controlEvent(ControlEvent theEvent) {
  // ListBox is if type ControlGroup.
  // 1 controlEvent will be executed, where the event
  // originates from a ControlGroup. therefore
  // you need to check the Event with
  // if (theEvent.isGroup())
  // to avoid an error message from controlP5.

  if (theEvent.isGroup()) {
    // an event from a group e.g. scrollList
    //println(theEvent.group().value()+" from "+theEvent.group());
  }
  
  if(theEvent.isGroup() && theEvent.name().equals("myList")){
    test = (int)theEvent.group().value();
    //println("test "+test);
}
}


//make sketch fullscreen

boolean sketchFullScreen() {
  return true;
}
