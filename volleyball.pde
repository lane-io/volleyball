import fisica.*;

FWorld world;

FBox leftWall, leftFloor, rightWall, rightFloor, net, ceiling;
FCircle leftPlayer, rightPlayer, ball;
//FBlob leftPlayer, rightPlayer;
//FCircle ball;
float ballPositionPicker, ballPosition;
int leftScore, rightScore;

boolean leftCanJump, rightCanJump;

boolean wkey, akey, skey, dkey;
boolean upkey, leftkey, downkey, rightkey;

int mode;

PImage background, leftGameOver, rightGameOver;

final int game = 0;
final int gameover1 = 1;
final int gameover2 = 2;

void setup() {
  size(800, 600);

  background = loadImage ("volleyballBackground.png");
  leftGameOver = loadImage ("leftPlayerBackground.png");
  rightGameOver = loadImage ("rightPlayerBackground.png");

  ballPositionPicker = random(0, 2);

  if (ballPositionPicker <= 1) {
    ballPosition = 200;
  } else {
    ballPosition = 600;
  }

  Fisica.init(this);
  world = new FWorld();
  world.setGravity(0, 2000);

  leftWall = new FBox (50, 600);
  leftWall.setPosition (-25, 300);
  leftWall.setStatic(true);
  leftWall.setFill(0);
  world.add(leftWall);

  leftFloor = new FBox (400, 100);
  leftFloor.setPosition (200, 550);
  leftFloor.setStatic(true);
  leftFloor.setFill(0);
  leftFloor.setFriction(0);
  world.add(leftFloor);

  rightWall = new FBox (50, 600);
  rightWall.setPosition (825, 300);
  rightWall.setStatic(true);
  rightWall.setFill(0);
  world.add(rightWall);

  rightFloor = new FBox (400, 100);
  rightFloor.setPosition (600, 550);
  rightFloor.setStatic(true);
  rightFloor.setFill(0);
  rightFloor.setFriction(0.1);
  world.add(rightFloor);

  ceiling = new FBox (900, 50);
  ceiling.setPosition (-50, -50);
  ceiling.setStatic(true);
  ceiling.setFill(0);
  world.add(ceiling);

  net = new FBox (5, 90);
  net.setPosition (400, 475);
  net.setStatic(true);
  net.setFill(0);
  world.add(net);

  ball = new FCircle (50);
  ball.setPosition (ballPosition, 200);
  noStroke();
  ball.setFill(255);
  ball.setDensity(0.5);
  ball.setRestitution(1.0);
  world.add(ball);

  leftPlayer = new FCircle (70);
  leftPlayer.setPosition (200, 400);
  leftPlayer.setFill(0);
  leftPlayer.setRestitution(0.7);
  world.add(leftPlayer);

  rightPlayer = new FCircle (70);
  rightPlayer.setPosition (600, 400);
  rightPlayer.setFill(0);
  rightPlayer.setRestitution(0.7);
  world.add(rightPlayer);

  //leftPlayer = new FBlob ();
  //leftPlayer.setAsCircle(200, 400, 80);
  //leftPlayer.setFill(0);
  //world.add(leftPlayer);

  //rightPlayer = new FBlob ();
  //rightPlayer.setAsCircle(600, 400, 80);
  //rightPlayer.setFill(0);
  //world.add(rightPlayer);
}

void draw() {

  if (mode == 0) {
    game();
  } else if (mode == 1) {
    gameover1();
  } else if (mode == 2) {
    gameover2();
  }
}

void game() {

  background(255, 255, 255, 100);

  image(background, -100, -100, 1100, 700);

  ballPositionPicker = random(0, 2);

  if (ballPositionPicker <= 1) {
    ballPosition = 200;
  } else {
    ballPosition = 600;
  }

  textAlign(CENTER);
  textSize(15);
  fill(255);
  text("SCORE : " + leftScore, 200, 50);
  text("SCORE : " + rightScore, 600, 50);

  leftCanJump = false;
  ArrayList<FContact> leftContacts = leftPlayer.getContacts();

  int i = 0;
  while (i < leftContacts.size()) {
    FContact c = leftContacts.get(i);
    if (c.contains(leftFloor)) leftCanJump = true;
    i++;
  }

  if (wkey && leftCanJump) leftPlayer.addImpulse(0, -6500);
  if (akey) leftPlayer.addImpulse(-500, 0);
  if (dkey) leftPlayer.addImpulse(500, 0);
  if (skey) leftPlayer.addImpulse(0, 1000);

  rightCanJump = false;
  ArrayList<FContact> rightContacts = rightPlayer.getContacts();

  int i2 = 0;
  while (i2 < rightContacts.size()) {
    FContact c = rightContacts.get(i2);
    if (c.contains(rightFloor)) rightCanJump = true;
    i2++;
  }

  if (upkey && rightCanJump) rightPlayer.addImpulse(0, -6500);
  if (leftkey) rightPlayer.addImpulse(-500, 0);
  if (rightkey) rightPlayer.addImpulse(500, 0);
  if (downkey) rightPlayer.addImpulse(0, 1000);

  ArrayList<FContact> rightScoreContacts = ball.getContacts();

  int i3 = 0;
  while (i3 < rightScoreContacts.size()) {
    FContact c = rightScoreContacts.get(i3);
    if (c.contains(rightFloor)) { 
      leftScore = leftScore + 1;
      ball.setPosition (ballPosition, 200);
      ball.setVelocity (0, 0);
      ball.setForce (0, 0);
      leftPlayer.setPosition (200, 460);
      rightPlayer.setPosition (600, 460);
    }
    i3++;
  }

  ArrayList<FContact> leftScoreContacts = ball.getContacts();

  int i4 = 0;
  while (i4 < leftScoreContacts.size()) {
    FContact c = leftScoreContacts.get(i4);
    if (c.contains(leftFloor)) { 
      rightScore = rightScore + 1;
      ball.setPosition (ballPosition, 200);
      ball.setVelocity (0, 0);
      ball.setForce (0, 0);
      leftPlayer.setPosition (200, 460);
      rightPlayer.setPosition (600, 460);
    }
    i4++;
  }

  if (leftPlayer.getX() >= 365) {
    leftPlayer.setPosition (365, leftPlayer.getY());
  }

  if (rightPlayer.getX() <= 435) {
    rightPlayer.setPosition (435, rightPlayer.getY());
  }

  if (leftScore == 5) {
    mode = gameover1;
    leftScore = 0;
    rightScore = 0;
  }

  if (rightScore == 5) {
    mode = gameover2;
    leftScore = 0;
    rightScore = 0;
  }

  world.step();
  world.draw();
}

void gameover1() {

  background(255, 255, 255, 100);

  image(leftGameOver, 0, -170, width, width);

  textAlign(CENTER);
  textSize(15);
  fill(255);
  text("GOOD JOB LEFT PLAYER", width/2, height/2);
}

void gameover2() {

  background(255, 255, 255, 100);

  image(rightGameOver, 0, -70, width, width);
  
  textAlign(CENTER);
  textSize(15);
  fill(255);
  text("GOOD JOB RIGHT PLAYER", width/2, height/2);
}
