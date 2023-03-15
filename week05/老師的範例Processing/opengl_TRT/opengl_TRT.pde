//2020-04-22 ��烐�喳�𡁜虾 Visualize T-R-T 閫�敹萇�撌亙��
// Left: 400x400 OpenGL drawing area, ��𣂼���憭𡁶𧞄6�见蔗�𠧧��隞�,隞亙�滨𧞄�𢒰��䔶�
// Right: OpenGL coding area
//2020-04-23 撖虫�𦭛rello-like��board蝘餃��
//2020-04-22 Idea: 蝒��嗆�喳�,�虾��𡑒岫�� �𤓖�血�硋飛銋讠� Ivan Sutherland �� sketchpad
//2020-04-22 Idea: �鍂 Processing撖怠枂 Text Editor,
//  �虾scroll�虾蝮格𦆮�����, �䲮靘輻�蝔见�讐Ⅳ���䲮靘輯矽��摨譌���䲮靘踵㺿���彍
//Q: Code Board�銁drag��, Object��蝒��嗅�𧼮�𢠃�𤩺�舘�𦠜�𣂷�漤�𤩺��, 敺�����, 閬��䰻 myDrawNew()
class Board {
  String code;
  int x=0, y=0;//position雿滨蔭
  int w=100;//textWidth(code)撖砍漲
  int h=40;//text height + 20, ex. textSize(32)���鍂 40 擃睃漲
  boolean bMoving=false;//�糓�炏甇�◤mouseDragged��𡝗𠗊銝�
  boolean bChoosing=false;
  int ancherX, ancherY;//�鍂靘���𤤿�𤧥ouseDragged��,��劐�见縧��ancher暺�,銝餉�雿輻鍂 ancherY
  float tx=0,ty=0,tz=0;
  int id=0;//myDrawObject(id)
  boolean bLower=false;//憒���𨀣糓閬�鋡急�牐�见縧���踎摮�,撠梯身摰� bLower
  int glType=0;//0:glPushMatrix(), 1:glPopMatrix(), 2:glTranslatef(), 3:glScalef(), 4:myDrawObject(), 5:glPopMatrix()
  Board(String _code, int _glType, int _x, int _y){
    glType = _glType;
    code=new String(_code);
    x=_x; 
    y=_y;
    w=int(textWidth(code));
  }
  Board(String _code, int _x, int _y) {
    code=new String(_code);
    x=_x; 
    y=_y;
    w=int(textWidth(code));
  }
  Board() {
    code=new String();
  }
  Board(Board sample) {
    code=new String(sample.code);
    x=sample.x;
    y=sample.y;
    w=sample.w;
    h=sample.h;
    bMoving=sample.bMoving;
    ancherX=sample.ancherX;
    ancherY=sample.ancherY;
  }
  boolean insideBoard(int px, int py) {//test if (px,py) inside the board
    if ( x<=px && px<=x+w && y<=py && py<y+h ) return true;//��敺�1��<=蝑㕑�笔⏛���,隞亙�滚�𡁻��
    return false;
  }
  boolean insideRange(int px, int py){
    if( x<=px && px<=x+300 && y<=py && py<y+h ) return true;//��敺�1��<=蝑㕑�笔⏛���,隞亙�滚�𡁻��
    return false;
  }
  void draw() {
    if (bChoosing) {
      pushMatrix();
      translate(x+w/2, y+h/2);
      if(bMoving) rotateZ(radians(-5));//�銁��𡝗𠗊蝘餅踎摮鞉�,蝔齿��-5摨�,���虾�𥕢�鈭�
      fill(255, 0, 0, 128); 
      stroke(0); 
      rect(-w/2, -h/2, w, h);
      fill(0); 
      text(code, -w/2, -h/2);
      popMatrix();
    } else {
      int dy=0;
      if(bLower) dy=h;
      noFill();
      stroke(0); 
      rect(x, y+dy, textWidth(code), 40);
      fill(0); 
      text(code, x, y+dy);
    }
  }
  void updateCode(){
    if(glType==1){
      code = "glTranslate("+nf(tx,1,2)+","+nf(-ty,1,2)+");";
    }
  }
}
String []code={"glPushMatrix", "glTranslate", "glRotatef", "glScalef;", "myDrawObj();", "glPopMatrix"};
ArrayList<Board> currentCode;
Board movingBoard=null;
ArrayList<PVector> curve=null;
ArrayList<ArrayList<PVector>> all;
color [] objC={#FF3700, #FFAF00, #FFF700, #2DFF00, #009FFF, #FF00EF};
int [] bornAngle=new int[6];
int topC=0;
int rotAngle=0;
boolean bKeepRotating=false;
void setup() {
  size(900, 400, P3D);hint(DISABLE_DEPTH_TEST);
  textSize(32);
  textAlign(LEFT, TOP);
  all = new ArrayList<ArrayList<PVector>>();
  currentCode = new ArrayList<Board>();
  int i=0;
  currentCode.add( new Board("glPushMatrix();", 0, 420, 50+40*i++) );
  currentCode.add( new Board("glTranslatef(0,0,0);", 1, 440, 50+40*i++) );
  currentCode.add( new Board("glRotatef(angle,0,0,1);", 2, 440, 50+40*i++) );
  currentCode.add( new Board("glTranslatef(0,0,0);", 1, 440, 50+40*i++) );
  currentCode.add( new Board("glPopMatrix();", 5, 420, 50+40*i++) );
}
void draw() {
  background(255);
  drawAxis(400, 400);
  myDrawNew();//drawObjects();
  drawCode();
  if (bKeepRotating) rotAngle++;
  fill(0); 
  if(rotAngle<10) text("angle=  "+(rotAngle)%360, 730,0);
  else if(rotAngle<100) text("angle= "+(rotAngle)%360, 730,0);
  else text("angle="+(rotAngle)%360, 730,0);
  noFill(); rect(750,350,textWidth("ToDraw"),50);
  fill(255,0,0); text("ToDraw",750,350);
}
void drawCode() {
  for (Board b : currentCode) {
    b.draw();
  }
  if (movingBoard!=null) {
    movingBoard.draw();
  }
}
void drawAxis(int w, int h) {
  fill(0);
  rect(0, 0, w, h);
  stroke(255);
  fill(255);
  line(0, h/2, w, h/2);
  line(w, h/2, w-20, h/2-10);
  line(w, h/2, w-20, h/2+10);
  text("x", w-textWidth("x"), h/2);

  line(w/2, 0, w/2, h);
  line(w/2, 0, w/2+10, 20);
  line(w/2, 0, w/2-10, 20);
  text("y", w/2-textWidth("y"), 0);
  text("0", w/2-textWidth("0"), h/2);
}
void myDrawNew(){
  pushMatrix();
  translate(200,200);//敺𧼮椰銝𡃏�� �𦆮��麫xis��銝剖�  
  for(Board b : currentCode){
    //0:glPushMatrix(), 1:glPopMatrix(), 2:glTranslatef(), 3:glScalef(), 4:myDrawObject(), 5:glPopMatrix()
    if(b.glType==0) pushMatrix();
    if(b.glType==1){ellipse(0,0,3,3); translate(b.tx*200, b.ty*200, b.tz*200);}
    if(b.glType==2) rotateZ(radians(rotAngle));
    //if(b.glType==3) scale(b.tx,b.ty,b.tz);
    if(b.glType==4) myDrawObject(b.id);
    if(b.glType==5) popMatrix();
  }
  if(movingBoard!=null){
    myDrawObject(movingBoard.id);
  }
  popMatrix();
  fill(255, 128);//�蹱糓甇�銁�𧞄����隞�
  strokeWeight(1);
  if (curve!=null) {
    beginShape();
    for (PVector pt : curve) {
      vertex(pt.x, pt.y);
    }
    endShape();
  }
}
void myDrawObject(int obj){
  if(obj >= all.size() ) return ;
  ArrayList<PVector> one = all.get(obj);

  fill(#ff0000); ellipse(0,0, 10,10);//�𧞄�枂��隞嗡葉敹�
  fill(objC[obj], 200);
  pushMatrix();
    translate(-200,-200);//��𦠜𨭬镼踵𦆮撌虫�𡃏�垍�(0,0)雿滨蔭
    beginShape();
    for(PVector pt : one){
      vertex(pt.x, pt.y);
    }
    endShape(CLOSE);
  popMatrix();
}
void drawObjects() {
  strokeWeight(2);
  for (int c=0; c<all.size(); c++) {//all.size() is always less than 6
    ArrayList<PVector> one = all.get(c);
    pushMatrix();
    translate(200, 200);
    rotateZ(radians(rotAngle-bornAngle[c]));//隤閧�笔��,��齿���惩�亥�匧��
    translate(-200, -200);
    fill(objC[c], 200);
    beginShape();
    for (PVector pt : one) {
      vertex(pt.x, pt.y);
    }
    endShape(CLOSE);
    popMatrix();
  }
  fill(255, 128);
  strokeWeight(1);
  if (curve!=null) {
    beginShape();
    for (PVector pt : curve) {
      vertex(pt.x, pt.y);
    }
    endShape();
  }
}
int nowState=0;//1: draw curve, 2: select code, 3: translate
Board candidate=null;
void mousePressed() {
  candidate=null;
  for(Board b : currentCode){
    if(b.bChoosing==true){
      candidate=b;
      if(b.glType==1) nowState=3;//for translate
    }
  }//�躰ㄐ閬��肽��銝�銝�, ��烐�梶�㛖訜 bChoosing�糓translate��, ��𠵆ragged�嚉靘�憓𧼮�慯ranslate��tx,ty
  //�蹱��䠷�閬��𡖂銝��𠻺ragged
  
  for (int i=0; i<currentCode.size(); i++) {
    Board now = currentCode.get(i);
    now.bChoosing=false;
    if ( now.insideBoard(mouseX, mouseY) && now.glType!=0 && now.glType!=5 ) {
      nowState=2;
      movingBoard = currentCode.get(i);
      movingBoard.bMoving=true;
      now.bChoosing=true;
      movingBoard.ancherX=mouseX-movingBoard.x;
      movingBoard.ancherY=mouseY-movingBoard.y;
      for(int k=i+1; k<currentCode.size(); k++){
        Board next = currentCode.get(k);
        next.y -= next.h;
        next.bLower=true;
      }
      currentCode.remove(i);
      //break;
    }
  }
  if (mouseX<400 & nowState==3){  } //�蹱糓閬�蝘餃�� candidate鋆∠�tx,ty
  else if (mouseX<400 & topC<6) nowState=1;//in the drawing area
  
  if (nowState==1) {
    curve = new ArrayList<PVector>();
  }
}
void mouseDragged() {
  if (nowState==3) {
    candidate.tx += (mouseX-pmouseX)/200.0;
    candidate.ty += (mouseY-pmouseY)/200.0;
    candidate.updateCode();
  }
  if (nowState==1) {
    curve.add(new PVector(mouseX, mouseY));
  } else if (nowState==2) {
    movingBoard.y += (mouseY-movingBoard.y-movingBoard.ancherY);
    for(int i=0; i<currentCode.size(); i++){
      Board b = currentCode.get(i);
      b.bLower=false;
      if(b.insideRange(mouseX,mouseY)){
        for(int k=i; k<currentCode.size();k++){
          currentCode.get(k).bLower=true;
        }
        break;
      }
    }
  }
}
void mouseReleased() {
  if (nowState==3) nowState=0;
  if (nowState==1) {
    all.add(curve);
    curve=null;
    nowState=0;
    bornAngle[topC]=rotAngle;
    Board obj = new Board("myDrawObject("+topC+");", 4, 440, 50);
    obj.id=topC;
    currentCode.add(0, obj); 
    for(int i=1; i<currentCode.size();i++){
      Board b = currentCode.get(i);
      b.y += b.h;
    }
    topC++;
  } else if (nowState==2) {
    for(int i=0;i<currentCode.size();i++){
      Board b = currentCode.get(i);
      if(b.insideRange(mouseX,mouseY)){
        for(int k=i;k<currentCode.size();k++){
          Board b2=currentCode.get(k);
          b2.bLower=false;
          b2.bChoosing=false;
          b2.bMoving=false;
          b2.y+=b2.h;
        }
        movingBoard.y=b.y-b.h;
        movingBoard.bMoving=false;
        currentCode.add(i, movingBoard);
        movingBoard=null;
        nowState=0;
        break;
      }//problem: �銁�𦆮��𧢲�, movingBoard憒���𨅯銁銝𧢲䲮,����匧�誯��
    }
    if(nowState==2){//瘝埝�㗇𦆮�銁隞颱�蓥��𨂽oard��雿滨蔭,��隞交�埝�鍦銁��漤𢒰
      Board last = currentCode.get(currentCode.size()-1);
      movingBoard.y = last.y + last.h;
      movingBoard.bMoving=false;
      currentCode.add(movingBoard);
      movingBoard=null;
      nowState=0;
    }
  }
}
void keyPressed() {
  if (key==' ') bKeepRotating = !bKeepRotating;
  if (key=='1' && movingBoard==null) {
    movingBoard=new Board("glPushMatrix();", mouseX, mouseY);
  }
}
