/** William Ersing
 *  PHY 436
 *  Dispersion Program */
 
 
import g4p_controls.*;
import org.gwoptics.graphics.graph2D.Graph2D;
import org.gwoptics.graphics.graph2D.LabelPos;
import org.gwoptics.graphics.graph2D.traces.Line2DTrace;
import org.gwoptics.graphics.graph2D.traces.ILine2DEquation;

float sep;
float m1;
float m2;
float springCon;
boolean chkM = false;
boolean chkD = false;
int graphToggle = 0;
float sliderY = 450;
float chkX = 700;
float theta = -PI;

Graph2D[] graph = new Graph2D[2];
Line2DTrace[] trace = new Line2DTrace[3];
GCustomSlider[] sdr = new GCustomSlider[4];
Accoustic1 acc1 = new Accoustic1();
Accoustic2 acc2 = new Accoustic2();
Optic2 opt2 = new Optic2();
GCheckbox chkMono, chkDia;
GButton btnSep, btnSpr, btnM1, btnM2, btnDisp, btnVib;

/** Calculations for Monoatomic accoustic graph */
public class Accoustic1 implements ILine2DEquation{
  public double computePoint(double x,int pos) {
    double c1 = 2*springCon/m1;
    double c2 = 4/Math.pow(m1, 2);
    return 2*Math.sqrt((springCon/m1)*Math.pow(Math.sin(sep*x/2), 2));
  }
}

/** Calculations for diatomic optic graph */
public class Optic2 implements ILine2DEquation{
  public double computePoint(double x,int pos) {
    double c1 = (springCon*(m1+m2)) / (m1*m2);
    double c2 = Math.pow((m1+m2) / (m1*m2), 2);
    double c3 = 4/ (m1*m2);
    return Math.sqrt(c1 + springCon*(Math.sqrt(c2-c3*Math.pow(Math.sin(sep*x/2), 2))));
  }
}

/** Calculations for diatomic accoustic graph */
public class Accoustic2 implements ILine2DEquation{
  public double computePoint(double x,int pos) {
    double c1 = (springCon*(m1+m2)) / (m1*m2);
    double c2 = Math.pow((m1+m2) / (m1*m2), 2);
    double c3 = 4/ (m1*m2);
    return Math.sqrt(c1 - springCon*(Math.sqrt(c2-c3*Math.pow(Math.sin(sep*x/2), 2))));
  }
}

void setup() {
  size(800, 700);
  smooth();

  graph[0] = new Graph2D(this, 600, 300, false);
  graph[1] = new Graph2D(this, 600, 300, false);
  for(int i = 0; i < graph.length; i++) {
    graph[i].position.x = 90;
    graph[i].position.y = 40;
  }
    
    graph[0].setYAxisMin(0);
    graph[0].setYAxisMax(20);
    graph[0].setXAxisMin(-PI);
    graph[0].setXAxisMax(PI);
    graph[0].setXAxisLabel("Wavenumber, k");
    graph[0].setYAxisLabel("Frequency, \u03C9");
    graph[0].setXAxisTickSpacing(PI/2);
    graph[0].setYAxisTickSpacing(5);

    graph[1].setYAxisMin(0);
    graph[1].setYAxisMax(0);
    graph[1].setXAxisMin(0);
    graph[1].setXAxisMax(0);
    graph[1].setXAxisLabel("");
    graph[1].setYAxisLabel("");
    graph[1].setXAxisTickSpacing(0);
    graph[1].setYAxisTickSpacing(0);
    
    trace[0] = new Line2DTrace(new Accoustic1());
    trace[1] = new Line2DTrace(new Optic2());
    trace[2] = new Line2DTrace(new Accoustic2());

    trace[0].setTraceColour(255,0,0);
    trace[1].setTraceColour(0,0,255);
    trace[2].setTraceColour(30,100,0);

  
  for(int i = 0; i < sdr.length; i++) {
    sdr[i] = new GCustomSlider(this, 150*i+55, sliderY, 205, 120, "red_yellow18px");
    sdr[i].setTextOrientation(G4P.ORIENT_RIGHT);
    sdr[i].setPrecision(2);
    sdr[i].setShowLimits(true); 
    sdr[i].setShowValue(true); 
    sdr[i].setShowTicks(true); 
    sdr[i].setStickToTicks(false); 
    sdr[i].setRotation(4.712389, GControlMode.CENTER);
    }
    sdr[0].setLimits(1.00, 1.00, 10.0);
    sdr[1].setLimits(10.00, 10.00, 500.0);
    sdr[2].setLimits(1.00, 1.00, 285.0);
    sdr[3].setLimits(1.00, 1.00, 285.0);
    sdr[0].setNbrTicks(3);
    
    chkMono = new GCheckbox(this, chkX, 230, 89, 15, "Monatomic");
    chkDia = new GCheckbox(this, chkX, 260, 89, 15, "Diatomic");
    
    btnSep = new GButton(this, 117, sliderY+170, 80, 40, "Atomic Separation");
    btnSpr = new GButton(this, 267, sliderY+170, 80, 40, "Force Constant");
    btnM1 = new GButton(this, 417, sliderY+170, 80, 40, "Mass\n#1");
    btnM2 = new GButton(this, 567, sliderY+170, 80, 40, "Mass\n#2");
    
    
    btnDisp = new GButton(this, 700, 40, 80, 40, "Dispersion Relation");
    btnDisp.setLocalColorScheme(5);
    btnVib = new GButton(this, 700, 90, 80, 40, "Lattice Vibrations");
    btnVib.setLocalColorScheme(5);
}

void draw() {
  background(130,180,215);
  noStroke();
  fill(200);
    rect(90,40,600,300);
    
  sep = sdr[0].getValueF();
  springCon = sdr[1].getValueF();
  m1 = sdr[2].getValueF()*0.166;
  m2 = sdr[3].getValueF()*0.166;
  if(graphToggle == 0) {
    graph[0].draw();
    textAlign(CENTER);
    fill(0);
    textSize(30);
    text("Dispersion Relation", width / 2, 30);
  }
  else if(graphToggle == 1) {
    graph[1].draw();
    textAlign(CENTER);
    fill(0);
    textSize(30);
    text("Lattice Vibrations", width / 2, 30);
    theta += 0.02;
    noStroke();
    fill(0);
    float x = theta;
    for (int i = 1; i <= 14; i++) {
      float y = sin(x)*30 - 150;
      ellipse(i*40 +90,y + height/2,24,24);
      x += 0.063*PI;
    }
  }
}

public void handleToggleControlEvents(GToggleControl option, GEvent event) {
  if (option == chkMono && chkM == false) {
    chkM = true;
    graph[0].addTrace(trace[0]);
  }
  else if(option == chkMono && chkM == true) {
    chkM = false;
    graph[0].removeTrace(trace[0]);
  }
  if (option == chkDia && chkD == false) {
    chkD = true;
    graph[0].addTrace(trace[1]);
    graph[0].addTrace(trace[2]);
  }
  else if(option == chkDia && chkD == true) {
    chkD = false;
    graph[0].removeTrace(trace[1]);
    graph[0].removeTrace(trace[2]);
  }
}

public void handleSliderEvents(GValueControl slider, GEvent event) { 
  if (slider == sdr[0]) {
    if(chkM == true) {
      graph[0].removeTrace(trace[0]);
      graph[0].addTrace(trace[0]);
    }
    if(chkD == true) {
      graph[0].removeTrace(trace[1]);
      graph[0].removeTrace(trace[2]);
      graph[0].addTrace(trace[1]);
      graph[0].addTrace(trace[2]);
    }
  }
  else if (slider == sdr[1]) {
    if(chkM == true) {
      graph[0].removeTrace(trace[0]);
      graph[0].addTrace(trace[0]);
    }
    if(chkD == true) {
      graph[0].removeTrace(trace[1]);
      graph[0].removeTrace(trace[2]);
      graph[0].addTrace(trace[1]);
      graph[0].addTrace(trace[2]);
    }
  }    
  else if (slider == sdr[2]) {
    if(chkM == true) {
      graph[0].removeTrace(trace[0]);
      graph[0].addTrace(trace[0]);
    }
    if(chkD == true) {
      graph[0].removeTrace(trace[1]);
      graph[0].removeTrace(trace[2]);
      graph[0].addTrace(trace[1]);
      graph[0].addTrace(trace[2]);
    }
  }
  else if (slider == sdr[3]) {
    if(chkD == true) {
      graph[0].removeTrace(trace[1]);
      graph[0].removeTrace(trace[2]);
      graph[0].addTrace(trace[1]);
      graph[0].addTrace(trace[2]);
    }
  }
}

public void handleButtonEvents(GButton button, GEvent event) { 
  if (button == btnSep) {
    int mtype = G4P.PLAIN;
    String message = "Use this slide bar to vary the atomic separation";
    String title = "Atomic Separation (\u212B)";
    G4P.showMessage(this, message, title, mtype);
  }
  if (button == btnSpr) {
    int mtype = G4P.PLAIN;
    String message = "Use this slide bar to vary the the force constant";
    String title = "Force Constant (N/m)";
    G4P.showMessage(this, message, title, mtype);
  }
  if (button == btnM1) {
    int mtype = G4P.PLAIN;
    String message = "Use this slide bar to vary mass #1";
    String title = "Mass #1 (amu)";
    G4P.showMessage(this, message, title, mtype);
  }
  if (button == btnM2) {
    int mtype = G4P.PLAIN;
    String message = "Use this slide bar to vary Mass #2";
    String title = "Mass #2 (amu)";
    G4P.showMessage(this, message, title, mtype);
  }
  if (button == btnDisp) {
    graphToggle = 0;
  }
  if (button == btnVib) {
    graphToggle = 1;
  }
}
