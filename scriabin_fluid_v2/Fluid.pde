
final int SCALE = 7;
final int N= 128;

final int iter = 5;
float t = 0;
int cx = int(0.5*width);
int cy = int(0.5*height);

int IX(int x, int y){
  return x + y * N;
}

float RAD(int x, int y){
  return atan2(cy-y,cx-x);
}

class Fluid {
    
  int size;
  float dt;
  float diff;
  float visc;
    
  float[] s;
  float[] density;
  
  float[] sat;
  float[] past_sat;
  
  float[] hue;
  float[] past_hue;
  
  float[] bright;
  float[] past_bright;
    
  float[] Vx;
  float[] Vy;

  float[] Vx0;
  float[] Vy0;
  
  Fluid(float dt, float diffusion, float viscosity) {
    
    this.size = N;
    this.dt = dt;
    this.diff = diffusion;
    this.visc = viscosity;
    
    this.s = new float[N*N];
    this.density =new float[N*N];
    
    this.sat = new float[N*N];
    this.past_sat = new float[N*N];
    
    this.hue = new float[N*N];
    this.past_hue = new float[N*N];
    
    this.bright = new float[N*N];
    this.past_bright = new float[N*N];
    
    this.Vx = new float[N*N];
    this.Vy = new float[N*N];
    
    this.Vx0 = new float[N*N];
    this.Vy0 = new float[N*N];
    
    for (int i = 0; i < N; i++){
      for (int j = 0; j < N; j++){
         this.bright[IX(i,j)] = 255;
         this.density[IX(i,j)] = 0;
         
      }
    }
  
  }
  
  void setNote(int x, int y, float[] amount){
    int index= IX(x, y);
    this.density[index] = amount[0];
    this.sat[index] = amount[1];
    this.hue[index] = amount[2];
    this.bright[index] = amount[3];

  }
  
  void addDensity(int x, int y, float amount){
    int index= IX(x, y);
    this.density[index] += amount;

  }
  
  void addSat(int x, int y, float amount){
    int index= IX(x, y);
    this.sat[index] += amount;

  }
  
  void addHue(int x, int y, float amount){
    int index= IX(x, y);
    this.hue[index] += amount;

  }
  
    void addBright(int x, int y, float amount){
    int index= IX(x, y);
    this.bright[index] += amount;

  }
  
  void addVelocity(int x, int y, float amountX, float amountY){
    int index= IX(x, y);
    this.Vx[index] += amountX;
    this.Vy[index] += amountY;

  }
  
  void renderD(){
    colorMode(HSB,360,100,100);
    for (int i = 0; i < N; i++){
      for (int j = 0; j < N; j++){
        float x = i * SCALE;
        float y = j * SCALE;
        
        float h = this.hue[IX(i,j)];
        float s = this.sat[IX(i,j)];
        float b = this.bright[IX(i,j)];
        
        float v = map(this.density[IX(i,j)],0,127,0.5,2);
        fill(int(h),int(s),int(b));
        noStroke();
        square(x,y,SCALE*v);
      }
    }
  }
  
  void fadeD(){
    for (int i = 0; i < this.density.length; i++){
      float d = density[i];
      float h = hue[i];
      float s = sat[i];
      float b = bright[i];
      density[i] =  constrain(d-0.0001,0,255);
      hue[i] =  constrain(h,0,360);
      sat[i] =  constrain(s,0,100);
      bright[i] =  constrain(b,0,100);
    }
  }
  
  void diffuse (int b, float[] x, float[] x0, float diff, float dt){
    float a = dt * diff * (N - 2) * (N - 2);
    lin_solve(b, x, x0, a, 1 + 6 * a );
  }
  
  
  void lin_solve(int b, float[] x, float[] x0, float a, float c){
    float cRecip = 1.0 / c;
    for (int k = 0; k < iter; k++) {
      for (int j = 1; j < N - 1; j++) {
        for (int i = 1; i < N - 1; i++) {
          x[IX(i, j)] = (x0[IX(i, j)] 
                           + a*(    x[IX(i+1, j)]
                           +x[IX(i-1, j)]
                           +x[IX(i  , j+1)]
                           +x[IX(i  , j-1)]
                           )) * cRecip;
        }
      }
      set_bnd(b, x);
    }
  }
  
  void project(float[] velocX, float[] velocY, float[] p, float[] div){
  
    for (int j = 1; j < N - 1; j++) {
      for (int i = 1; i < N - 1; i++) {
        div[IX(i, j)] = -0.5f*(
                         velocX[IX(i+1, j )]
                        -velocX[IX(i-1, j )]
                        +velocY[IX(i  , j+1 )]
                        -velocY[IX(i  , j-1 )]
                    )/N;
                p[IX(i, j)] = 0;
      }
    }
 
    set_bnd(0, div); 
    set_bnd(0, p);
    lin_solve(0, p, div, 1, 6);
    
    for (int j = 1; j < N - 1; j++) {
      for (int i = 1; i < N - 1; i++) {
        velocX[IX(i, j)] -= 0.5f * (  p[IX(i+1, j)]
                            -p[IX(i-1, j)]) * N;
        velocY[IX(i, j)] -= 0.5f * (  p[IX(i, j+1)]
                            -p[IX(i, j-1)]) * N;
         
      }
    }
 
    set_bnd(1, velocX);
    set_bnd(2, velocY);
}


  void advect(int b, float[] d, float[] d0,  float[] velocX, float[] velocY, float dt){
    float i0, i1, j0, j1;
    
    float dtx = dt * (N - 2);
    float dty = dt * (N - 2);
    
    float s0, s1, t0, t1;
    float tmp1, tmp2, x, y;
    
    float Nfloat = N;
    float ifloat, jfloat;
    int i, j;
    
    for(j = 1, jfloat = 1; j < N - 1; j++, jfloat++) { 
        for(i = 1, ifloat = 1; i < N - 1; i++, ifloat++) {
            tmp1 = dtx * velocX[IX(i, j)];
            tmp2 = dty * velocY[IX(i, j)];
            
            x    = ifloat - tmp1; 
            y    = jfloat - tmp2;
            
                
            if(x < 0.5f) x = 0.5f; 
            if(x > Nfloat + 0.5f) x = Nfloat + 0.5f; 
            i0 = floor(x); 
            i1 = i0 + 1.0f;
            if(y < 0.5f) y = 0.5f; 
            if(y > Nfloat + 0.5f) y = Nfloat + 0.5f; 
            j0 = floor (y);
            j1 = j0 + 1.0f; 
                
            s1 = x - i0; 
            s0 = 1.0f - s1; 
            t1 = y - j0; 
            t0 = 1.0f - t1;
                
            int i0i = int(i0);
            int i1i = int(i1);
            int j0i = int(j0);
            int j1i = int(j1);
                
            d[IX(i, j)] = s0 * ( t0 * d0[IX(i0i, j0i)] + t1 * d0[IX(i0i, j1i)]) +            
                          s1 * ( t0 * d0[IX(i1i, j0i)] + t1 * d0[IX(i1i, j1i)]);
            }
        }
    
    set_bnd(b, d);
}
  
  void set_bnd(int b, float[] x){
  
    for(int i = 1; i < N - 1; i++) {
        x[IX(i, 0)] = b == 2 ? -x[IX(i, 1)] : x[IX(i, 1)];
        x[IX(i, N-1)] = b == 2 ? -x[IX(i, N-2)] : x[IX(i, N-2)];
    }
 
    for(int j = 1; j < N - 1; j++) {
        x[IX(0  , j)] = b == 1 ? -x[IX(1  , j)] : x[IX(1  , j)];
        x[IX(N-1, j)] = b == 1 ? -x[IX(N-2, j)] : x[IX(N-2, j)];
    }

    x[IX(0, 0)]  = 0.5f * (x[IX(1, 0)] + x[IX(0, 1)]);
    x[IX(0, N-1)] = 0.5f * (x[IX(1, N-1)] + x[IX(0, N-2)]);
    x[IX(N-1, 0)] = 0.5f * (x[IX(N-2, 0)] + x[IX(N-1, 1)]);
    x[IX(N-1, N-1)] = 0.5f * (x[IX(N-2, N-1)] + x[IX(N-1, N-2)]);

  }
  
  void step(){
    float visc     = this.visc;
    float diff     = this.diff;
    float dt       = this.dt;
    float[] Vx      = this.Vx;
    float[] Vy      = this.Vy;
    float[] Vx0     = this.Vx0;
    float[] Vy0     = this.Vy0;
    float[] s       = this.s;
    float[] density = this.density;
    float[] sat     = this.sat;
    float[] past_sat = this.past_sat;
    float[] hue     = this.hue;
    float[] past_hue = this.past_hue;   
    float[] bright     = this.bright;
    float[] past_bright = this.past_bright;   

    diffuse(1, Vx0, Vx, visc, dt);
    diffuse(2, Vy0, Vy, visc, dt);
    
    project(Vx0, Vy0, Vx, Vy);
    
    advect(1, Vx, Vx0, Vx0, Vy0, dt);
    advect(2, Vy, Vy0, Vx0, Vy0, dt);
   
    project(Vx, Vy, Vx0, Vy0 );
    
    diffuse(0, s, density, diff, dt);
    advect(0, density, s, Vx, Vy, dt);
    
    diffuse(0, past_sat, sat, diff, 0.5*dt);
    advect(0, sat, past_sat, Vx, Vy, 0.5*dt);
    
    diffuse(0, past_hue, hue, diff, 0.5*dt);
    advect(0, hue, past_hue, Vx, Vy, dt);
    
    diffuse(0, past_bright, bright, diff, 0.5*dt);
    advect(0, bright, past_bright, Vx, Vy, dt);
}
  
}
