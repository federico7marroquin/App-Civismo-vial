import processing.net.*; 


Client myClient; 
int dataIn; 

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

//rgb semáforo
int r=0;
int g=0;
int b=0;
boolean stop;

//control de tiempo
int tiempo = 0;
int victoria=0;
int inicio=0;
void setup() { 
  size(1400, 800); 
  myClient = new Client(this, "127.0.0.1", 5204);
} 

void draw() {
  
   
  background(#B1B2B4); 
  cargarCiudad();
  tiempo++;
  avatarJugadores();
  crearVehiculos();
  recibirVariables();
  interaccionKeyboard();
   if(victoria ==1){
    textSize(45);
    text("CONGRATULATIONS...", 450, 300); 
    fill(0, 102, 153);
  }
}

//instancia los avatares y puntos objetivos
void avatarJugadores() {
  fill(#D47F96);
  rect(xs[11], ys[11], anchos[11], altos[11]); //rectangulo
  fill(#000099);
  rect(xs[0], ys[0], anchos[0], altos[0]); //rectangulo
  fill(#D47F96);
  ellipse(1000, 20, 25, 25);
  fill(#000099);
  ellipse(20, 525, 25, 25);
}

//sincroniza el tablero de juegos de los jugadores.
//funciona de forma similar a un protocolo de la capa de transporte
//encapsula los datos en un String y lo envía a los clientes
//los clientes desencapsulan los datos y minan las estructuras de datos dadas. 
void recibirVariables() {
  String msm="";
  if (myClient.available() > 0) { 
    msm = myClient.readString();
  } 
  String[] mensaje= split(msm, " ");
  if (mensaje.length==58) {
    for (int i=1; i<13; i++) {
      xs[i-1]=int(mensaje[i]);
      ys[i-1]=int(mensaje[i+12]);
      anchos[i-1]=int(mensaje[i+24]);
      altos[i-1]=int(mensaje[i+36]);
    }
    //for (int i=25; i<34; i++) {
    //  anchos[i-25]=int(mensaje[i]);
    //  altos[i-25]=int(mensaje[i+9]);
    // }
    for (int i=49; i<53; i++) {
      velocidad[i-49]=int(mensaje[i]);
    }
    r=int(mensaje[53]);
    g=int(mensaje[54]);
    b=int(mensaje[55]);
    stop=boolean(mensaje[56]);
    tiempo=int(mensaje[57]);
  }if (msm.equals("CONGRATULATIONS")) {
        victoria=1;
  }
}
//modela los vehículos particulares
void crearVehiculos() {
  fill(#ff6600);
  rect(xs[1], ys[1], anchos[1], altos[1]); //rectangulo
  fill(#3366ff);
  rect(xs[9]-340, ys[9]+300, anchos[9], altos[9]); //rectangulo 
  for (int i=0; i<2; i++) {
    fill(#3366ff);
    rect(xs[2]-i*340, ys[2]+i*300, anchos[2], altos[2]); //rectangulo 
    fill(#ffff00);
    rect(xs[3]+i*340, ys[3]+i*300, anchos[3], altos[3]); //rectangulo
    fill(#ff5050);
    rect(xs[4]-i*340, ys[4]+i*300, anchos[4], altos[4]); //rectangulo
    fill(#339966);
    rect(xs[5]-i*340, ys[5]+i*300, anchos[5], altos[5]); //rectangulo
  }

  fill(#663300);
  rect(xs[7]+3*340, ys[7], anchos[7], altos[7]); //rectangulo
  fill(#669999);
  rect(xs[8]+3*340, ys[8], anchos[8], altos[8]); //rectangulo

  fill(#f5075e);
  rect(xs[10], ys[10], anchos[10], altos[10]); //rectangulo

  for (int i=0; i<3; i++) {
    fill(#ff9900);
    rect(xs[6]+i*340, ys[6], anchos[6], altos[6]); //rectangulo
    fill(#663300);
    rect(xs[7]+i*340, ys[7], anchos[7], altos[7]); //rectangulo
    fill(#669999);
    rect(xs[8]+i*340, ys[8], anchos[8], altos[8]); //rectangulo
  }
}

//configuración de movimiento
void interaccionKeyboard()
{
  if (keyPressed==true)
  {
    if (key=='w'||key=='W')
    {
      ys[11]-= 3;
      anchos[11]= 15;
      altos[11] = 30;
      myClient.write(ys[11]+" "+anchos[11]+" "+altos[11]);
    }
    if (key=='s'||key=='S')
    {
      ys[11]+= 3;
      anchos[11]= 15;
      altos[11] = 30;
      myClient.write(ys[11]+" "+anchos[11]+" "+altos[11]);
    }
    if (key=='a'||key=='A')
    {
      xs[11]-= 3;
      anchos[11]= 30;
      altos[11] = 15;
      myClient.write(xs[11]+" "+anchos[11]+" "+altos[11]);
    }
    if (key=='d'||key=='D')
    {
      xs[11]+= 3;
      anchos[11]= 30;
      altos[11] = 15;
      myClient.write(xs[11]+" "+anchos[11]+" "+altos[11]);
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
