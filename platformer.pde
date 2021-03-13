// Tarpan87, 2021

boolean keyUp, keyDown, keyRight, keyLeft;
World world;
Player player;
Button resetButton;
int gameState; //0 - running, 1 - gameOver, 2 - win
int tileSize;
int score;

int[][] worldField = {
{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, 
{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 1}, 
{1, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 2, 2, 1}, 
{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 7, 0, 4, 0, 0, 0, 1}, 
{1, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 1}, 
{1, 7, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
{1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 7, 0, 0, 0, 0, 1}, 
{1, 0, 2, 0, 0, 7, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
{1, 0, 0, 2, 0, 0, 4, 0, 0, 0, 3, 0, 0, 0, 3, 0, 0, 0, 0, 1}, 
{1, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 1}, 
{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 7, 0, 0, 0, 0, 2, 0, 1}, 
{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 2, 0, 2, 2, 2, 2, 2, 1}, 
{1, 0, 0, 0, 0, 0, 2, 2, 2, 6, 6, 6, 6, 6, 1, 1, 1, 1, 1, 1}, 
{1, 0, 0, 0, 0, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, 
{1, 0, 0, 0, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, 
{1, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
}; 

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      keyUp = true;
    }
    if (keyCode == DOWN) {
      keyDown = true;
    }
    if (keyCode == LEFT) {
      keyLeft = true;
    }
    if (keyCode == RIGHT) {
      keyRight = true;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) {
      keyUp = false;
    }
    if (keyCode == DOWN) {
      keyDown = false;
    }
    if (keyCode == LEFT) {
      keyLeft = false;
    }
    if (keyCode == RIGHT) {
      keyRight = false;
    }
  }
}

void setup() {
  size(800, 800);
  tileSize = 40;
  gameState = 0;
  score = 0;
  world = new World(20, 20, worldField);
  player = new Player(50,650);
  resetButton = new Button(loadImage("restart_btn.png"), width/2 - 80, height/2 + 50);
  frameRate(60);
}

void draw() {
  if (gameState == 2) {
    background(230);
    fill(0, 102, 153);
    textSize(64);
    text("You Win!", 250, 350);
    resetButton.update();
    if (resetButton.clicked) {
      setup();
    }
    resetButton.display();
  }
  else if ((gameState == 1) && !player.rising) {
    background(230);
    fill(0, 102, 153);
    textSize(64);
    text("Game Over", 200, 350);
    resetButton.update();
    if (resetButton.clicked) {
      setup();
    }
    resetButton.display();
  }
  else {
    background(230);
    world.update();
    world.display();
    player.update();
    player.display();  
  }


}
