/*
TITLE: Galactic Tactics
AUTHOR: Kyle Koon
DATE DUE: 4/23/21
DATE SUBMITTED: 5/3/21
COURSE TITLE: Game Design
MEETING TIME(S): Mon. and Wed. at 2pm
DESCRIPTION: This program creates the Galactic Tactics game. In this game, the user left-clicks on a ship during their turn to select it. After
selection, the player can either right-click or press the left or right arrow key. A right-click will cause the selected ship to move one tile
forward in the direction that it is facing. Pressing the right arrow key will rotate the selected ship 90 degrees clockwise. Pressing the left arrow
key will rotate the selected ship 90 degrees counterclockwise. On each turn, a player gets to do two actions. Moving and changing heading count as two
separate actions.
HONOR CODE: On my honor, I neither gave nor received unauthorized aid on this assignment. Signature: Kyle Koon
*/


int scene = 1; //keeps track of the current scene number
//images that will be used throughout the game
PImage backGrnd;
PImage grunt;
PImage sideShooter;
PImage bomber;
PImage sniper;
PImage mothership;
PImage homeScreen;
PImage quit;

int numTiles = 121; //this is the number of tiles that will be on the board
int numRows = (int)Math.sqrt(numTiles);
int numColumns = numRows;
Tile[] tiles = new Tile[numTiles]; //will store an array of Tile objects

//declares all the ship objects
Ship BomberA_1;
Ship GruntA_1;
Ship MothershipA_1;
Ship SideShooterA_1;
Ship SniperA_1;

Ship BomberA_2;
Ship GruntA_2;
Ship SideShooterA_2;
Ship SniperA_2;

Ship BomberB_1;
Ship GruntB_1;
Ship MothershipB_1;
Ship SideShooterB_1;
Ship SniperB_1;

Ship BomberB_2;
Ship GruntB_2;
Ship SideShooterB_2;
Ship SniperB_2;

Ship[] player1Ships = new Ship[9]; //will store an array of ships for player1
Ship[] player2Ships = new Ship[9]; //will store an array of ships for player2

boolean selected = false; //monitors whether a ship has been selected or not

int actions = 2; //the number of actions that each player gets on their turn
//keeps track of which player's turn it is
boolean player1Turn = true;
boolean player2Turn = false;

int[] leftBorders = {0, 11, 22, 33, 44, 55, 66, 77, 88, 99, 110}; //the tile addresses of the left border of the game board
int[] rightBorders = {10, 21, 32, 43, 54, 65, 76, 87, 98, 109, 120}; //the tile addresses of the right border of the game board

Ship CurrentShip; //will store the currently selected ship object

class Tile{ //used to create the game board
  private float x;
  private float y;
  private float w;
  private float h;
  boolean occupied;
  private int tileNum;

  Tile(int tempTileNum, float tempX, float tempY, float tempW, float tempH){
    tileNum = tempTileNum;
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
  }
  
  int getTileNum(){
    return tileNum;
  }
  
  float getX(){
    return x;
  }
  
  float getY(){
    return y;
  }
  
  boolean isOccupied(){
    return occupied;
  }
  
  void Occupy(boolean state){
    occupied = state;
  }
  
  void drawTile(){
    noFill();
    rect(x, y, w, h); //draws the outline of the game tiles
  }
}

class Ship{ //creates the game pieces
  private float x;
  private float y;
  Tile tile;
  private PImage shipImg;
  String heading;
  
  Ship(PImage tempImg, Tile tempTile, String tempHeading){
    x = tempTile.getX();
    y = tempTile.getY();
    shipImg = tempImg;
    tile = tempTile;
    heading = tempHeading;
  }
  
  Tile getTile(){
    return tile;
  }
  
  PImage getImage(){
    return shipImg;
  }
  
  String getHeading(){
    return heading;
  }
  
  void changeHeading(String newHeading){
    heading = newHeading;
  }
  
  void move(Tile dest){ //changes the ship's coordinates to the new tile
    x = dest.getX();
    y = dest.getY();
    tile = dest;
  }
  
  void drawShip(){
    image(shipImg,x,y);
  }
}

void mousePressed(){
  if(scene == 3 && mouseButton==LEFT){
    //checks if the user has pressed the quit button
    if(mouseX > 900 && mouseX < 1100){
      if(mouseY > 700 && mouseY < 800){
        exit();
      }
    }
    
    if(player1Turn){
      int i = 0; //keeps track of the current tile number
      while(i < 9){ //iterates through the tiles
        if(mouseX > player1Ships[i].x && mouseX < player1Ships[i].x + 75) { //if the x position of where the user clicked is within the current tile
          if(mouseY > player1Ships[i].y && mouseY < player1Ships[i].y + 75){ //if the y position of where the user clicked is within the current tile
            selected = true;
            CurrentShip = player1Ships[i];
          }
        }
        i+=1; //we check the next tile
      }
    }
    else{ //runs on player2's turn
      int i = 0; //keeps track of the current tile number
      while(i < 9){ //iterates through the tiles
        if(mouseX > player2Ships[i].x && mouseX < player2Ships[i].x + 75) { //if the x position of where the user clicked is within the current tile
          if(mouseY > player2Ships[i].y && mouseY < player2Ships[i].y + 75){ //if the y position of where the user clicked is within the current tile
            selected = true;
            CurrentShip = player2Ships[i];
          }
        }
        i+=1; //we check the next tile
      }
    }
  }
  if(selected && mouseButton == RIGHT){ //runs if the user right clicks after selecting a ship
    moveShip(CurrentShip); //the ship moves one tile forward in the direction it is facing
    if(actions == 0){ //runs if the player has run out of moves on their turn
      selected = false;
      //swaps turns
      player1Turn = !player1Turn;
      player2Turn = !player2Turn;
      actions = 2; //resets action count
    }
  }
}

void keyPressed(){
  if(key == '\n' && scene == 1 || scene == 2){ //changes scenes when the user presses enter during the first two scenes
    scene++;
  }
  if(selected && key == CODED){ //a ship must be selected first
    if(keyCode == RIGHT){ //pressing the right arrow key
      String newHead = rightHeading(CurrentShip.getHeading());
      CurrentShip.changeHeading(newHead); //sets the ships heading attribute
      rotateRight(CurrentShip, 90); //rotates the image of the ship clockwise
      actions-=1; //decreases action count
      if(actions == 0){ //resets for the next player
        selected = false;
        player1Turn = !player1Turn;
        player2Turn = !player2Turn;
        actions = 2;
      }
    }
    else if(keyCode == LEFT){ //pressing the left arrow key
      String newHead = leftHeading(CurrentShip.getHeading());
      CurrentShip.changeHeading(newHead); //sets the ships heading attribute
      rotateRight(CurrentShip, 270); //rotates the image of the ship counterclockwise
      actions-=1; //decreases action count
      if(actions == 0){ //resets for the next player
        selected = false;
        player1Turn = !player1Turn;
        player2Turn = !player2Turn;
        actions = 2;
      }
    }
  }
}

void drawTiles(){ //draws the game tiles to the screen
  for(int i = 0; i < numTiles; i++){ //iterates through each of the tiles
    stroke(0,255,0);
    tiles[i].drawTile(); //draws the current tile onto the screen
  }
}

void rotateRight(Ship ship, int deg){ //rotates the image of the selected ship clockwise by "deg" degrees
  PImage shipImg = ship.getImage();
  int xOff = shipImg.width/2;
  int yOff = shipImg.height/2;
  Tile currentTile = ship.getTile();
  float destX = currentTile.getX();
  float destY = currentTile.getY();
  pushMatrix();
  translate(destX+xOff,destY+yOff);
  rotate(radians(deg));
  image(shipImg,-xOff,-yOff);
  popMatrix();
}

String rightHeading(String currentHead){ //returns the new heading direction that is 90 degrees clockwise from current heading
  String[] headings = {"north", "east", "south", "west"};
  int newHeadingIndex = -1;
  for(int i = 0; i < headings.length; i++){ //iterates through the headings
    if(headings[i].equals(currentHead)){
      //gets the heading that is 90 degrees to the right of the current heading. north -> east, west -> north
      if(i == headings.length-1){
        newHeadingIndex = 0;
      }
      else{
        newHeadingIndex = i+1;
      }
    }
  }
  return headings[newHeadingIndex];
}


String leftHeading(String currentHead){ //returns the new heading direction that is 90 degrees counterclockwise from current heading
  String[] headings = {"north", "east", "south", "west"};
  int newHeadingIndex = -1;
  for(int i = 0; i < headings.length; i++){
    if(headings[i].equals(currentHead)){
      if(i == 0){
        newHeadingIndex = headings.length-1;
      }
      else{
        newHeadingIndex = i-1;
      }
    }
  }
  return headings[newHeadingIndex];
}

int[] Angles(Ship[] ships){ //returns the current angles of the ship images based on their headings
  int[] angles = new int[ships.length];
  int angle = 0;
  for(int i = 0; i < ships.length; i++){
    if(ships[i].getHeading() == "north"){
      angle = 0;
    }
    else if(ships[i].getHeading() == "east"){
      angle = 90;
    }
    else if(ships[i].getHeading() == "south"){
      angle = 180;
    }
    else{
      angle = 270;
    }
    angles[i] = angle;
  }
  return angles;
}

void moveShip(Ship ship){ //moves the ship to the appropriate destination tile based on their heading
  if(ship.getHeading().equals("north")){
    int currentTileNum = ship.getTile().getTileNum();
    int destTileNum = currentTileNum - 11;
    if(!(destTileNum < 0)){ //makes sure that the ship will not try moving outside the game world
      if(!tiles[destTileNum].isOccupied()){ //makes sure that the destination tile does not already have a ship in it
        actions-=1;
        ship.move(tiles[destTileNum]);
        tiles[currentTileNum].Occupy(false);
        tiles[destTileNum].Occupy(true);
      }
    }
  }
  
  if(ship.getHeading().equals("south")){
    int currentTileNum = ship.getTile().getTileNum();
    int destTileNum = currentTileNum + 11;
    if(!(destTileNum > 120)){   
      if(!tiles[destTileNum].isOccupied()){
        actions-=1;
        ship.move(tiles[destTileNum]);
        tiles[currentTileNum].Occupy(false);
        tiles[destTileNum].Occupy(true);
      }
    }
  }
  
  if(ship.getHeading().equals("west")){
    int currentTileNum = ship.getTile().getTileNum();
    int destTileNum = currentTileNum - 1;
    boolean badMove = false;
    for(int i = 0; i < rightBorders.length; i++){
      if(destTileNum == rightBorders[i]){
        badMove = true;
      }
    }
    if(!badMove){
      if(!tiles[destTileNum].isOccupied()){
        actions-=1;
        ship.move(tiles[destTileNum]);
        tiles[currentTileNum].Occupy(false);
        tiles[destTileNum].Occupy(true);
      }
    }
  }
  
  if(ship.getHeading().equals("east")){
    int currentTileNum = ship.getTile().getTileNum();
    int destTileNum = currentTileNum + 1;
    boolean badMove = false;
    for(int i = 0; i < leftBorders.length; i++){
      if(destTileNum == leftBorders[i]){
        badMove = true;
      }
    }
    if(!badMove){
      if(!tiles[destTileNum].isOccupied()){
        actions-=1;
        ship.move(tiles[destTileNum]);
        tiles[currentTileNum].Occupy(false);
        tiles[destTileNum].Occupy(true);
      }
    }
  }
}
  

void scene1(){ //intro scene
  image(homeScreen,0,0);
  textAlign(CENTER);
  textSize(75);
  fill(255);
  text("Galactic Tactics",width/2+10,250);
  textSize(30);
  text("Press Enter to Continue!",width/2+10,300);
  image(sniper,300,650);
  image(bomber,500,700);
  image(mothership,700,650);
  image(grunt,100,600);
  image(sideShooter,950,600);
}


void scene2(){ //rules scene
  image(backGrnd,0,0);
  textAlign(CENTER);
  textSize(75);
  fill(255);
  text("Rules:",width/2,100);
  textAlign(LEFT);
  textSize(30);
  text("1. Select a ship by left-clicking on it \n"
  + "2. Right-click to move the ship forward one tile \n"
  + "3. Press the right arrow key to rotate the selected ship 90 degrees right \n"
  + "4. Press the left arrow key to rotate 90 degrees left \n"
  + "5. Each player gets two actions on a turn \n"
  + "6. Moving and rotating count as individual actions \n"
  + "7. Left-click on the quit button to exit the game",25,200);
  textAlign(CENTER);
  textSize(50);
  text("Press Enter to Play", width/2, 650);
}

void scene3(){ //gameplay scene
  image(backGrnd,0,0);
  drawTiles(); //draws the tiles to the sceen
  //gets the current angles for all the ships
  int[] angles1 = Angles(player1Ships);
  int[] angles2 = Angles(player2Ships);
  
  //draws all the ships with the appropriate heading
  for(int i = 0; i < player1Ships.length; i++){
    rotateRight(player1Ships[i], angles1[i]);
  }
  for(int i = 0; i < player2Ships.length; i++){
    rotateRight(player2Ships[i], angles2[i]);
  }
  
  textSize(50);
  fill(255);
  if(player1Turn){
    text("Player1", width-100, 100);
  }
  else{
    text("Player2", width-100, 100);
  }
  textSize(30);
  text("Actions:" + actions, width-100, 150); //displays the number of actions remaining
  image(quit,900,700); //displays the quit button
}

void setup(){
  size(1100,900);
  
  backGrnd = loadImage("galaxy.jpg");
  backGrnd.resize(width,height);

  bomber = loadImage("bomber.png");
  bomber.resize(75,75);
  
  grunt = loadImage("grunt.png");
  grunt.resize(75,75);
  
  mothership = loadImage("mothership.png");
  mothership.resize(75,75);
  
  sideShooter = loadImage("sideShooter.png");
  sideShooter.resize(75,75);
  
  sniper = loadImage("sniper.png");
  sniper.resize(75,75);
  
  homeScreen = loadImage("homeScreenGalaxy.jpg");
  homeScreen.resize(width,height);
  
  quit = loadImage("quit.png");
  quit.resize(200,100);
  
  float xIncrement = (width-200)/numRows; //calculates the distance between left edges of adjacent tiles
  float yIncrement = height/numColumns; //calculates the distance between top edges of adjacent tiles
  
  int q = 0; //the index of the tiles array
  for(int i = 0; i < numColumns; i++){ //iterate through each row
    for(int j = 0; j < numRows; j++){ //iterate through each column
      tiles[q] = new Tile(q, xIncrement*j,yIncrement*i,xIncrement,yIncrement); //creates a numbered tile object with correct coordinates
      q++; //increase index so we can create a new tile
    }
  }
  
  //creates the ship objects
  BomberA_1 = new Ship(bomber, tiles[77], "east");
  GruntA_1 = new Ship(grunt, tiles[33], "east");
  MothershipA_1 = new Ship(mothership, tiles[115], "north");
  SideShooterA_1 = new Ship(sideShooter, tiles[66], "east");
  SniperA_1 = new Ship(sniper, tiles[44], "east");
  
  //occupies the tiles where the ships are initially set
  BomberA_1.getTile().Occupy(true);
  GruntA_1.getTile().Occupy(true);
  MothershipA_1.getTile().Occupy(true);
  SideShooterA_1.getTile().Occupy(true);
  SniperA_1.getTile().Occupy(true);

  BomberA_2 = new Ship(bomber, tiles[117], "north");
  GruntA_2 = new Ship(grunt, tiles[113], "north");
  SideShooterA_2 = new Ship(sideShooter, tiles[116], "north");
  SniperA_2 = new Ship(sniper, tiles[114], "north");
  
  BomberA_2.getTile().Occupy(true);
  GruntA_2.getTile().Occupy(true);
  SideShooterA_2.getTile().Occupy(true);
  SniperA_2.getTile().Occupy(true);
  
  //places player1's ships into an array
  player1Ships[0] = GruntA_1;
  player1Ships[1] = SniperA_1;
  player1Ships[2] = SideShooterA_1;
  player1Ships[3] = BomberA_1;
  player1Ships[4] = GruntA_2;
  player1Ships[5] = SniperA_2;
  player1Ships[6] = MothershipA_1;
  player1Ships[7] = SideShooterA_2;
  player1Ships[8] = BomberA_2;
 
  
  //repeats the above process for player 2
  BomberB_1 = new Ship(bomber, tiles[87], "west");
  GruntB_1 = new Ship(grunt, tiles[43], "west");
  MothershipB_1 = new Ship(mothership, tiles[5], "south");
  SideShooterB_1 = new Ship(sideShooter, tiles[76], "west");
  SniperB_1 = new Ship(sniper, tiles[54], "west");
  
  BomberB_1.getTile().Occupy(true);
  GruntB_1.getTile().Occupy(true);
  MothershipB_1.getTile().Occupy(true);
  SideShooterB_1.getTile().Occupy(true);
  SniperB_1.getTile().Occupy(true);
  
  BomberB_2 = new Ship(bomber, tiles[7], "south");
  GruntB_2 = new Ship(grunt, tiles[3], "south");
  SideShooterB_2 = new Ship(sideShooter, tiles[6], "south");
  SniperB_2 = new Ship(sniper, tiles[4], "south");
  
  BomberB_2.getTile().Occupy(true);
  GruntB_2.getTile().Occupy(true);
  SideShooterB_2.getTile().Occupy(true);
  SniperB_2.getTile().Occupy(true);
  
  player2Ships[0] = GruntB_1;
  player2Ships[1] = SniperB_1;
  player2Ships[2] = SideShooterB_1;
  player2Ships[3] = BomberB_1;
  player2Ships[4] = GruntB_2;
  player2Ships[5] = SniperB_2;
  player2Ships[6] = MothershipB_1;
  player2Ships[7] = SideShooterB_2;
  player2Ships[8] = BomberB_2; 
}

void draw(){ //draws the different scenes based on the current value of the scene variable
  switch(scene){
    case 1:
      scene1();
      break;
    case 2:
      scene2();
      break;
    case 3:
      scene3();
      break;
  }
}
