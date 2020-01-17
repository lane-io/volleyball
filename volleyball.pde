import fisica.*;

FWorld world;

FBox leftWall, leftFloor, rightWall, rightFloor, net;
//FCircle leftPlayer, rightPlayer, ball;
FBlob leftPlayer, rightPlayer, ball;

boolean leftCanJump, rightCanJump;

boolean wkey, akey, skey, dkey;
boolean upkey, leftkey, downkey, rightkey;

void setup() {
  size(800, 600);

  Fisica.init(this);
  world = new FWorld();
  world.setGravity(0, 900);

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

  net = new FBox (5, 90);
  net.setPosition (400, 475);
  net.setStatic(true);
  net.setFill(0);
  world.add(net);

  //leftPlayer = new FCircle (50);
  //leftPlayer.setPosition (200, 400);
  //leftPlayer.setFill(0);
  //world.add(leftPlayer);

  //rightPlayer = new FCircle (50);
  //rightPlayer.setPosition (600, 400);
  //rightPlayer.setFill(0);
  //world.add(rightPlayer);

  leftPlayer = new FBlob ();
  leftPlayer.setAsCircle(200, 400, 70);
  leftPlayer.setFill(0);
  world.add(leftPlayer);

  rightPlayer = new FBlob ();
  rightPlayer.setAsCircle(600, 400, 70);
  rightPlayer.setFill(0);
  world.add(rightPlayer);
}

void draw() {
  background(255, 255, 255, 100);

  leftCanJump = false;
  ArrayList<FContact> leftContacts = leftPlayer.getContacts();

  int i = 0;
  while (i < leftContacts.size()) {
    FContact c = leftContacts.get(i);
    if (c.contains(leftFloor)) leftCanJump = true;
    i++;
  }

  if (wkey && leftCanJump) leftPlayer.addImpulse(0, -1000);
  if (akey) leftPlayer.addImpulse(-100, 0);
  if (dkey) leftPlayer.addImpulse(100, 0);

  rightCanJump = false;
  ArrayList<FContact> rightContacts = rightPlayer.getContacts();

  int ii = 0;
  while (ii < rightContacts.size()) {
    FContact c = rightContacts.get(ii);
    if (c.contains(rightFloor)) rightCanJump = true;
    ii++;
  }

  if (upkey && rightCanJump) rightPlayer.addImpulse(0, -5000);
  if (leftkey) rightPlayer.addImpulse(-100, 0);
  if (rightkey) rightPlayer.addImpulse(100, 0);

  world.step();
  world.draw();
}
