import processing.net.*;

Server myServer;


//arreglo de coordeadas x
int[] xs=new int[12];
//arreglo de coordenadas y
int[] ys=new int[12];

//arreglo de alturas de carros y cicla
int[] altos=new int[12];
//arreglo de anchuras de carros y cicla
int[] anchos=new int[12];
//arreglo de velocidades
int[] velocidad=new int[4];


//inicialización de atributos
void minarArreglos()
{
  
  //objeto vehículo cliente valores iniciales
  altos[0] = 40;
  anchos[0]=20;
  xs[0]=1290;
  ys[0]=20;

  //objeto ciclista cliente valores iniciales
  anchos[11]= 15;
  altos[11]=30;
  //poscición inicial
  xs[11] =310;
  ys[11] = 760;
  velocidad[3] = 2;

  //carro 1
  velocidad[2]=3;
  xs[1]=1440;
  ys[1]=220;
  anchos[1]=40;     
  altos[1]=20;

  //carro2
  velocidad[1]=2;
  xs[2]=-40;
  ys[2]=260;
  anchos[2]=40;     
  altos[2]=20;

  //carro3
  xs[3]=-240;
  ys[3]=260;
  anchos[3]=40;     
  altos[3]=20;

  //carro4
  xs[4]=-620;
  ys[4]=260;
  anchos[4]=40;     
  altos[4]=20;

  //carro5
  xs[5]=-620-1440;
  ys[5]=260;
  anchos[5]=40;     
  altos[5]=20;
  //carro6
  xs[6]=220;
  ys[6]=-40;
  anchos[6]=20;     
  altos[6]=40;

  //carro7
  xs[7]=260;
  ys[7]=840;
  anchos[7]=20;     
  altos[7]=40;

  //carro8
  xs[8]=260;
  ys[8]=840;
  velocidad[0]=1;
  anchos[8]=20;     
  altos[8]=40;

  //carro9
  xs[9]=-1400;
  ys[9]=-800;
  anchos[9]=40;     
  altos[9]=20;

  //carro10
  xs[10]=1230;
  ys[10]=-40;
  anchos[10]=20;     
  altos[10]=40;
}
//rgb semáforo
int r=0;
int g=0;
int b=0;
boolean stop;

//control de tiempo
int tiempo = 0;
int victoria=0;
//cliente 1
int cliente1;
//cliente 2
int cliente2;
//número de clientes conectados al servidor
int numClients=0;

void setup() {
  size(1400, 800); 
  minarArreglos();
  // Starts a myServer on port 5204
  myServer = new Server(this, 5204);
}

void draw() {
  

  if (numClients!=2) {
    textSize(45);
    text("Esperando Jugadores...", 450, 300); 
    fill(0, 102, 153);
  } else {
    tiempo++;
    background(#B1B2B4); 
    sincronizarTablero();
    cargarCiudad();
    controlarSemaforo();
    programarVehiculos();
    captarMovimiento();
    avatarJugadores();
    detectarColision();
    meta();
    if(victoria ==1){
    textSize(45);
    text("CONGRATULATIONS...", 450, 300); 
    fill(0, 102, 153);
  }
  }
}

//sincroniza el tablero de juegos de los jugadores.

void sincronizarTablero() {
  String x="";
  String y="";
  String ancho="";
  String alto="";
  String velo="";
  String semaforo= r+" "+g+" "+b+" "+stop+" ";

  for (int i=0; i<12; i++) {
    x+=xs[i]+" ";
    y+=ys[i] +" ";
  }
  for (int i=0; i<12; i++) {
    ancho+=anchos[i]+" ";
    alto+=altos[i]+" ";
  }
  for (int i=0; i<4; i++) {
    velo+=velocidad[i]+" ";
  }
  String variables="vehículos "+x+y+ancho+alto+velo+semaforo+tiempo;
  myServer.write(variables);
}

//recibe las coordenadas actualizadas del avatar de cada jugador
void captarMovimiento() {

  Client thisClient = myServer.available();
  if (thisClient!=null) {

    String ubicacion = thisClient.readString();
    int[] list = int(split(ubicacion, " "));
    if (list.length==3) {

      if (list[1]==30) {
        xs[11]=list[0];
        anchos[11]=30;
        altos[11]=15;
      } else if (list[1]==15) {
        ys[11]=list[0];
        anchos[11]=15;
        altos[11]=30;
      } else if (list[1]==20) {
        ys[0]=list[0];
        anchos[0]=20;
        altos[0]=40;
      } else if (list[1]==40) {
        xs[0]=list[0];
        anchos[0]=40;
        altos[0]=20;
      }
    }
  }
}

//instancia los avatares y puntos objetivos
void avatarJugadores(){
  fill(#D47F96);
  rect(xs[11], ys[11], anchos[11], altos[11]); //rectangulo
  fill(#000099);
  rect(xs[0], ys[0], anchos[0], altos[0]); //rectangulo
  fill(#D47F96);
  ellipse(1000, 20, 25, 25);
  fill(#000099);
  ellipse(20, 525, 25, 25);
}

//programación de la rutina y comportamiento
void programarVehiculos()
{
  
  fill(#ff6600);
  rect(xs[1], ys[1], anchos[1], altos[1]); //rectangulo

  if (xs[1]>950) {
    xs[1]-=velocidad[2];
  }
  if (xs[1]<=950) {
    ys[1]-=velocidad[2];
    anchos[1]=20;
    altos[1]=40;
  } 
  if (tiempo==1&&ys[1]<0) {
    xs[1]= 1440;
    ys[1]=220;
    anchos[1]=40;
    altos[1]=20;
  }

  fill(#3366ff);
  rect(xs[9]-340, ys[9]+300, anchos[9], altos[9]); //rectangulo 
  if (stop==false) {
    xs[9]=1465;
    ys[9]=260;
  }
  for (int i=0; i<2; i++) {
    fill(#3366ff);
    rect(xs[2]-i*340, ys[2]+i*300, anchos[2], altos[2]); //rectangulo 
    fill(#ffff00);
    rect(xs[3]+i*340, ys[3]+i*300, anchos[3], altos[3]); //rectangulo
    fill(#ff5050);
    rect(xs[4]-i*340, ys[4]+i*300, anchos[4], altos[4]); //rectangulo
    fill(#339966);
    rect(xs[5]-i*340, ys[5]+i*300, anchos[5], altos[5]); //rectangulo

    xs[9]+=velocidad[1];
    if (stop==true&&xs[2]<1470) {
      xs[2]+=velocidad[1];
    }

    if (tiempo==1&&xs[2]>1460) {
      xs[2]+=velocidad[1];
      xs[2]= -40;
      ys[2]=260;
    }

    xs[3]+=velocidad[1];
    if (tiempo==1&&xs[3]>1400) {
      xs[3]= -240;
      ys[3]=260;
    }

    if (tiempo>0&&tiempo<360) {
      xs[4]+=velocidad[1];
      xs[5]+=velocidad[1];
    }
    if (xs[4]>1400&&tiempo==1) {
      xs[4]= -620;
      ys[4]=260;
    }
    if (xs[5]>1400&&tiempo==170) {
      xs[5]= -620-1440;
      ys[4]=260;
    }
  }

  fill(#663300);
  rect(xs[7]+3*340, ys[7], anchos[7], altos[7]); //rectangulo
  fill(#669999);
  rect(xs[8]+3*340, ys[8], anchos[8], altos[8]); //rectangulo

  fill(#f5075e);
  rect(xs[10], ys[10], anchos[10], altos[10]); //rectangulo
  if (ys[10]<135&& stop==true) {
    ys[10]+= velocidad[2];
  }
  if (stop==true&&anchos[10]==40) {
    xs[10]-= velocidad[2];
  }
  if (xs[10]<0) {
    xs[10]=1230;
    ys[10]=-40;
    anchos[10]=20;     
    altos[10]=40;
  }
  if (stop== false) {
    if (ys[10]>510&&xs[10]>1040) {
      xs[10]-= velocidad[2];
      anchos[10]=40;
      altos[10]=20;
    } else if (anchos[10]==20) {
      ys[10]+= velocidad[2];
    }
  }

  for (int i=0; i<3; i++) {
    fill(#ff9900);
    rect(xs[6]+i*340, ys[6], anchos[6], altos[6]); //rectangulo
    fill(#663300);
    rect(xs[7]+i*340, ys[7], anchos[7], altos[7]); //rectangulo
    fill(#669999);
    rect(xs[8]+i*340, ys[8], anchos[8], altos[8]); //rectangulo

    if (tiempo>400) {
      ys[8]-=velocidad[0];
    }
    if (ys[6]<135&& stop==true) {
      ys[6]+= velocidad[0];
    }
    if (stop== false) {

      ys[6]+= velocidad[0];
    }


    if (ys[7]>800-170&& stop==true) {
      ys[7]-= velocidad[0];
    }
    if (stop== false) {
      ys[7]-= velocidad[0];
    }

    if (tiempo==1) {
      ys[6]= -40;
      ys[7]=840;
      ys[8]=840;
    }
  }
}



//carga el tablero de juego localmente
void cargarCiudad() {
  //tablero de juego
  for (int i=0; i< width; i+=340) {
    for (int j=0; j<height; j+=300) {
      //color manzana/andenes
      fill(#DABFA1); 
      //andenes
      rect(i, j, 200, 200); 
      //color edificio
      fill(#81B531); //color edificio
      //edificios
      rect(i+30, j+30, 140, 140); 
      // color ciclovia
      fill(#7F8086); 
      //ciclovia
      rect(i+300, j, 40, 200);
      for (int k=0; k<180; k+=20) {
        fill(#FFFFFF); //color lineas blancas
        //lineas verticales
        if (k>0) {
          rect(i+247, j+k+3, 5, 12);
          //lineas horizontales
          rect(i+k, j+247, 12, 5);
        }
        //lineas ciclovia
        rect(i+318, j+k+8, 4, 8);


        if (k<=80&&j<=400) {
          //cebras
          //horizontales arriba
          fill(r, g, b); 

          rect(i+203+k, j+185, 5, 15); 
          rect(i+213+k, j+185, 5, 15);
          //horizontales abajo
          rect(i+203+k, j+300, 5, 15); 
          rect(i+213+k, j+300, 5, 15);

          //verticales arriba
          fill(g, r, b); 
          rect(i+185, j+203+k, 15, 5); 
          rect(i+185, j+213+k, 15, 5);
          //verticales abajo
          rect(i+340, j+204+k, 15, 5); 
          rect(i+340, j+214+k, 15, 5);
        }
      }
    }
  }
}

//controlador de semáforo
void controlarSemaforo() {

  //en rojo
  if ( tiempo < 300) 
  {  
    stop=true;
    r=255;
    g=0;
  }
  //en amarillo
  else if ((tiempo>300&&tiempo<400)||(tiempo>700&&tiempo<800)) {
    //stop=false;
    r=255;
    g=255;
  }
  //en verde
  else if (tiempo>400&&tiempo<700) {
    stop=false;
    r=0;
    g=255;
  }
  //reinicio
  else if (tiempo>800) {
    tiempo=0;
  }
}

//gestiona las colisiones de los jugadores
void detectarColision() {
      int izquierda=xs[11];
      int derecha=izquierda+anchos[11];
      int superior=ys[11];
      int inferior=superior+altos[11];
      
      int left=xs[0];
      int right=left+anchos[0];
      int up=ys[0];
      int down=up+altos[0];
  for(int i=0;i<xs.length-1;i++){
      int izx=xs[i];
      int derx=izx+anchos[i];
      int supy=ys[i];
      int infy=supy-altos[i];
      if((derecha>=izx&&izquierda<derx&&superior>infy&&inferior<supy)
      ||(derecha>=izx+340&&izquierda<derx+340&&superior>infy&&inferior<supy)
      ||(derecha>=izx+340*2&&izquierda<derx+340*2&&superior>infy&&inferior<supy)
      ||(derecha>=izx+340*3&&izquierda<derx+340*3&&superior>infy&&inferior<supy)
      ||(derecha>=izx+340&&izquierda<derx+340&&superior>infy+300&&inferior<supy+300)
      ||(right>=izx&&left<derx&&up>infy&&up<supy)
      ||(right>=izx+340&&left<derx+340&&up>infy&&down<supy)
      ||(right>=izx+340*2&&left<derx+340*2&&up>infy&&down<supy)
      ||(right>=izx+340*3&&left<derx+340*3&&up>infy&&down<supy)
      ||(right>=izx+340&&left<derx+340&&up>infy+300&&down<supy+300)){
        
        minarArreglos();
        tiempo =0;
        
       
      
      }
  }
  
}
void meta(){
  if(ys[11]<0 && xs[0]<0){
    myServer.write("CONGRATULATIONS");
   victoria=1;
  }
}
//contabiliza la cantidad de jugadores conectados
void serverEvent(Server someServer, Client someClient) {

  numClients++;
}
