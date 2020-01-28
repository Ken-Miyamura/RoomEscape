import processing.sound.*;

PFont myFont;
PImage doorImg, wallImg, insectImg, keyImg,birdImg,lightImg, fakeImg;
SoundFile jiggleSound, fakeSound, birdSound, semiSound, flySound, getSound, keySound, openSound, clearSound;
Item door, fake, light, insect, theKey, bird;
Inventory inventory = new Inventory();
boolean solvedFlg = false;
boolean searchFlg = false;
boolean insectFlg = false;
boolean birdFlg = false;
boolean keyFlg = false;
String message = "";

void setup() {
  size(480, 480);
  background(255, 255, 255);
  fill(0, 0, 0);
  noStroke();
  frameRate(40);
  myFont = createFont("YuGothic", 30, true);
  textFont(myFont);

  doorImg  = loadImage("door.jpg");
  fakeImg = loadImage("fake.png");
  lightImg = loadImage("light.png");
  wallImg = loadImage("MZ18063DSCF5893.jpg");
  insectImg = loadImage("semi.png");
  keyImg = loadImage("key.png");
  birdImg = loadImage("Design2.png");
  jiggleSound = new SoundFile(this, "donotopen1.mp3");
  fakeSound = new SoundFile(this, "magazine1.mp3");
  semiSound = new SoundFile(this, "minminzemi-cry.mp3");
  birdSound = new SoundFile(this, "duck1.mp3");
  flySound = new SoundFile(this, "flap1.mp3");
  keySound = new SoundFile(this, "putting_keys.mp3");
  getSound = new SoundFile(this, "trumpet1.mp3");
  openSound = new SoundFile(this, "entering_a_house1.mp3");
  clearSound = new SoundFile(this, "people_performance-cheer1.mp3");
  
  door = new Item(doorImg, 240, 240, 1.0);
  fake = new Item(fakeImg, 380, 180, 0.15);
  light = new Item(lightImg, -10, 10, 0.30);
  insect = new Item(insectImg, 170, 50, 0.2);
  theKey = new Item(keyImg, 370, 400, 0.14);
  bird = new Item(birdImg, 360, 10, 0.20);
}

void draw() {
  background(0);
  image(wallImg, 0, 0, 480, 480);
  door.draw();
  fake.draw();
  light.draw();
  
  if(searchFlg && !insectFlg) {
    insect.draw();
  }
  if(insectFlg && !birdFlg) {
    bird.draw();
  }  
  if (birdFlg && !keyFlg) {
    theKey.draw();
  }
  if (solvedFlg) {
    fill(255, 255, 0);
    textSize(60);
    text("イエエェェ〜イ！！", 30, 200);
    fill(255);
    textSize(40);
    text("開いた！", 230, 350);
  }
  fill(255);
  text(message, 20, 420);
  inventory.draw();
}

class Item {
  PImage img;
  int xpos;
  int ypos;
  float scale;

  Item(PImage _img, int _xpos, int _ypos, float _scale) {
    img = _img;
    xpos = _xpos;
    ypos = _ypos;
    scale = _scale;
  }

  void draw() {
    float imgWidth = img.width * scale;
    float imgHeight = img.height * scale;
    image(img, xpos, ypos, imgWidth, imgHeight);
  }

  boolean isIn(int x, int y) {
    if (x >= xpos && x <= xpos + img.width * scale &&
      y >= ypos && y <= ypos + img.height * scale) {
      return true;
    } else {
      return false;
    }
  }
}

class Inventory {
  int itemMax = 2;
  Item[] items = new Item[itemMax];
  int found = 0;
  
  void put(Item i) {
    if(found < itemMax) {
      items[found] = i;
      found++;
    }
  }
  
  void draw() {
    fill(255);
    stroke(255, 215, 0);
    strokeWeight(3);
    for(int i = 0; i < itemMax; i++) {
      rect(i * 30 + 50, 20, 30, 30);
      if(items[i] != null) {
        image(items[i].img, i * 30 + 50, 20, 28, 28);
      }
    }
  }
}
  

void mousePressed() {
  message = "";
  if (solvedFlg) {
    return;
  }

  if (door.isIn(mouseX, mouseY)) {
    if (keyFlg) {
      solvedFlg = true;
      openSound.play();
      clearSound.play();
    } else {
      jiggleSound.play();
      message = "鍵がかかってて開かない(泣)";
    }
  }
  
  if (fake.isIn(mouseX, mouseY)) {
      fakeSound.play();
      message = "なんか書いてあるが読めない";
    }

  if (light.isIn(mouseX, mouseY)) {
    if (!searchFlg) {
      searchFlg = true;
      semiSound.play();
      message = "街灯にセミが止まっていたようだ";
    }
  }
  
  if (insect.isIn(mouseX, mouseY)) {
    if (searchFlg && !insectFlg && !birdFlg) {
      insectFlg = true;
      birdSound.play();
      inventory.put(insect);
      message = "あ！鳥に喰われた！";
    }
  }
  
  if (bird.isIn(mouseX, mouseY)) {
    if (searchFlg && insectFlg && !birdFlg && !keyFlg) {
      birdFlg = true;
      flySound.play();
      keySound.play();
      message = "おや？鳥の糞から何か出てきた！";
    }
  }

  if (theKey.isIn(mouseX, mouseY)) {
    if (searchFlg && birdFlg && !keyFlg) {
      keyFlg = true;
      getSound.play();
      inventory.put(theKey);
      message = "ドアの鍵だ！！";
    }
  }
}
