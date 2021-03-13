class Rect {
  
  float x, y, w, h;
  
  Rect(float xr, float yr, float wr, float hr) {
    x = xr;
    y = yr;
    w = wr;
    h = hr;
  }
  
  boolean isCollide(Rect r) {
    return r.x < (x + w) && (r.x+r.w) > x && r.y < (y + h) && (r.y+r.h) > y;  
  }
}

class Button {
  
  Rect r;
  PImage img;
  boolean clicked;
  boolean hover;
  
  Button(PImage timg, float tx, float ty) {
    img = timg;
    r = new Rect(tx, ty, img.width, img.height);
    clicked = false;
    hover = false;
  }
  
  void display() {
    image(img, r.x, r.y);
  }
  
  void update() {
    hover = mouseX >= r.x && mouseX < r.x+r.w && mouseY >= r.y && mouseY < r.y+r.h;
    clicked = hover && mousePressed && (mouseButton == LEFT);
  }
}

PImage mirrorX(PImage src) {
  PImage dst = createImage(src.width, src.height, ARGB);
  src.loadPixels();
  dst.loadPixels();
  for(int y = 0; y < src.height; y++ ) {
    for(int x = 0; x < src.width; x++ ) {
      dst.pixels[y*src.width+x] = src.pixels[y*src.width+src.width-x-1];      
    }
  }
  dst.updatePixels();
  return(dst);
} 

class Tile {
  
  Rect r;
  PImage img;
  
  Tile(PImage timg, float tx, float ty, float tw, float th) {
    img = timg;
    r = new Rect(tx, ty, tw, th);
  }
  
  void display() {
    image(img, r.x, r.y, r.w, r.h);
  }
}

class World {
  
  ArrayList<Tile> tiles;
  ArrayList<Enemy> enemies;
  ArrayList<Lava> lavas;
  ArrayList<Exit> exits;
  ArrayList<Coin> coins;
  ArrayList<Platform> platforms;
  World(int cols, int rows, int[][] data) {
    tiles = new ArrayList<Tile>();
    enemies = new ArrayList<Enemy>();
    lavas = new ArrayList<Lava>();
    exits = new ArrayList<Exit>();
    coins = new ArrayList<Coin>();
    platforms = new ArrayList<Platform>();
    PImage[] imgs = new PImage[2];
    imgs[0] = loadImage("dirt.png");
    imgs[1] = loadImage("grass.png");
    for(int i = 0; i < cols; i++) {
      for(int j = 0; j < rows; j++) {
        int val = data[j][i];
        if (val == 1 || val == 2) {
          Tile tempTile = new Tile(imgs[val-1], i*tileSize, j*tileSize, tileSize, tileSize);
          tiles.add(tempTile);
        }
        if (val == 3) {
          Enemy tempEnemy = new Enemy(i*tileSize, j*tileSize+5);
          enemies.add(tempEnemy);
        }
        if (val == 4) {
          Platform tempPlatform = new Platform(i*tileSize, j*tileSize, 1, 0);
          platforms.add(tempPlatform);
        }
        if (val == 5) {
          Platform tempPlatform = new Platform(i*tileSize, j*tileSize, 0, 1);
          platforms.add(tempPlatform);
        }
        if (val == 6) {
          Lava tempLava = new Lava(i*tileSize, j*tileSize + tileSize/2);
          lavas.add(tempLava);
        }
        if (val == 7) {
          Coin tempCoin = new Coin(i*tileSize+tileSize/4, j*tileSize+tileSize/4 );
          coins.add(tempCoin);
        }
        if (val == 8) {
          Exit tempExit = new Exit(i*tileSize, j*tileSize - tileSize/2);
          exits.add(tempExit);
        }
      }
    }
  }
  
  void update() {
    for(Enemy enemy: enemies) {
      enemy.update();
    }
    for(Platform platform: platforms) {
      platform.update();
    }
  }
  
  void display() {
    for (Tile tile: tiles) {
      tile.display();
    }
    for(Enemy enemy: enemies) {
      enemy.display();
    }
    for(Lava lava: lavas) {
      lava.display();
    }
    for(Exit exit: exits) {
      exit.display();
    }
    for(Coin coin: coins) {
      coin.display();
    }
    for(Platform platform: platforms) {
      platform.display();
    }
  }
  
}

class Platform {
  
  float counter = 0;
  float direction = 1;
  float move_x;
  float move_y;
  PImage img;
  Rect r;
  
  Platform(float px, float py, float pmove_x, float pmove_y) {
    img = loadImage("platform.png");
    r = new Rect(px, py, tileSize, tileSize/2);
    move_x = pmove_x;
    move_y = pmove_y;
  }
  
  void update() {
    r.x += direction * move_x;
    r.y += direction * move_y;
    counter += 1;
    if (abs(counter) > 40) {
      direction *= -1;
      counter *= -1;
    }
  }
  
  void display() {
    image(img, r.x, r.y, r.w, r.h);
  }
}

class Enemy {
  
  Rect r;
  PImage img;
  float counter = 0;
  float direction = 1;
  float limit = 40;
  float step = 1;
  
  Enemy(float x, float y) {
    img = loadImage("blob.png");
    r = new Rect(x, y, img.width, img.height);
  }
  
  void update() {
    if (abs(counter) >= limit) {
      direction *= -1;
    } 
    r.x += step*direction; 
    counter += direction;
  }
  
  void display() {
    image(img, r.x, r.y);
  }
}

class Lava {
  Rect r;
  PImage img;
  
  Lava(float x, float y) {
    img = loadImage("lava.png");
    r = new Rect(x, y, tileSize, tileSize/2);
  }
  
  void display() {
    image(img, r.x, r.y, r.w, r.h);
  }
}

class Exit {
  Rect r;
  PImage img;
  
  Exit(float x, float y) {
    img = loadImage("exit.png");
    r = new Rect(x, y, tileSize, tileSize*1.5);
  }
  
  void display() {
    image(img, r.x, r.y, r.w, r.h);
  }
}

class Coin {
  Rect r;
  PImage img;
  boolean hide;
  
  Coin(float x, float y) {
    img = loadImage("coin.png");
    r = new Rect(x, y, tileSize/2, tileSize/2);
    hide = false;
  }
  
  void display() {
    if (!hide) {
      image(img, r.x, r.y, r.w, r.h);
    }
  }
}

class Player {
  
  PImage[] imgs_right;
  PImage[] imgs_left;
  PImage imgGhost;
  PImage image;
  Rect r;
  float vel_y = 0;
  boolean jumped = false;
  int counter = 0;
  int index = 0;
  int direction = 1;
  boolean dead = false;
  boolean rising = false;
  Player(float x, float y) {
    imgs_right = new PImage[4];
    imgs_left = new PImage[4];
    imgGhost = loadImage("ghost.png");
    for(int i=1; i<5; i++) {
      imgs_right[i-1] = loadImage("guy"+nf(i)+".png");
      imgs_left[i-1] = mirrorX(imgs_right[i-1]);
    }
    image = imgs_right[index];
    r = new Rect(x, y, 30, 60);
  }
  
  void update() {
    float dx = 0;
    float dy = 0;
    float step = 6;
    boolean flip = false;
    int walk_cooldown = 5;
    if (gameState != 1) {
      if (keyUp && !jumped) {
        vel_y = -15;
        jumped = true;
      }
      if (keyLeft) {
        if (direction == 1) {
          flip = true;
        }
        direction = -1;
        counter += 1;
        dx -= step;
      }
      if (keyRight) {
        counter += 1;
        if (direction == -1) {
          flip = true;
        }
        direction = 1;
        dx += step;
      }
      if (!(keyRight ^ keyLeft) || flip) {
        counter = 0;
        index = 0;
      }
      if (counter > walk_cooldown) {
        counter = 0;
        index += 1;
        if (index >= imgs_right.length) {
          index = 0;
        }
      }
      image = ((direction == 1)?imgs_right:imgs_left)[index]; 
      vel_y += 0.75;
      vel_y = (vel_y > 10)?10:vel_y;
      dy += vel_y;
    //
      jumped = true;
      for(Tile tile : world.tiles) {
        Rect tempr;
        tempr = new Rect(r.x+dx, r.y, r.w, r.h);
        if (tile.r.isCollide(tempr)) {
          dx = 0;
        }
        tempr = new Rect(r.x, r.y+dy, r.w, r.h);
        if (tile.r.isCollide(tempr)) {
          if (vel_y < 0) {
            dy = tile.r.y + tile.r.h - r.y;
            vel_y = 0;
          } else {
            dy = tile.r.y - r.y - r.h;
            vel_y = 0;
            jumped = false;
          }
        }
      }
      for(Enemy enemy: world.enemies) {
        if (enemy.r.isCollide(r)) {
          gameState = 1;
          dead = true;
          rising = true;
        }
      }
      for(Lava lava: world.lavas) {
        if (lava.r.isCollide(r)) {
          gameState = 1;
          dead = true;
          rising = true;
        }
      }
      for(Exit exit: world.exits) {
        if (exit.r.isCollide(r)) {
          gameState = 2;
        }
      }
      for(Coin coin: world.coins) {
        if(!coin.hide && coin.r.isCollide(r)) {
          coin.hide = true;
          score += 1;
        }
      }
      for(Platform platform: world.platforms) {
        Rect tempr;
        tempr = new Rect(r.x+dx, r.y, r.w, r.h);
        if (platform.r.isCollide(tempr)) {
          dx = 0;
        }
        tempr = new Rect(r.x, r.y+dy, r.w, r.h);
        if (platform.r.isCollide(tempr)) {
          if (abs((r.y+dy)-(platform.r.y+platform.r.h)) < 20) {
            dy = (platform.r.y+platform.r.h) - r.y;
            vel_y = 0;
          }
          if (abs((r.y+r.h+dy)-platform.r.y) < 20) {
            dy = 0;
            r.y = platform.r.y-r.h-1; 
            jumped = false;
          }
          if (platform.move_x != 0) {
            r.x += platform.direction;
          }
        }
      }
    } else {
      image = imgGhost;
      r.w = image.width;
      r.h = image.height;
      rising = (r.y+r.h > 0);
      if (rising){
        dy = -3;
      }
    }
    //
    r.x += dx;
    r.y += dy;
    if (r.y + r.h > height) {
      r.y = height-r.h;
    }
  }
  
  void display() {
    image(image, r.x, r.y, r.w, r.h);
  }
}
