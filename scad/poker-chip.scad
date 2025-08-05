// Standard poker chips are 39, 43, 47, or 49mm.
size = 39; // [30:60]

// Standard poker chips are 3.5mm thick.
thickness = 3.5;  // [2:.5:6]
d_nozzle = 0.25;
t_emboss = 0.2;

// Width of the outer rim, used to imprint text
rim = 3; // [4:10]

// Circle parameters
circle_offset = size/2 - rim -.5;

quality = 100; // [20:Draft, 40:Standard, 100:High]

bevel_style = "n"; // [a:Angled, r:Rounded, n:None]
bevel = bevel_style == "n" ? 0 : .25;
bevel_facets = bevel_style == "a" ? 4 : 16;

rim_symbol = "\u2588"; // [\u25CF:Circle, \u25A0:Square, \u25B2:Triangle, \u2660:Spade, \u2663:Club, \u2665:Heart, \u2666:Diamond, \u2588:Cut Edge, none:None]

makeToken();

module makeToken() {
  makeTop();
  rotate([180])makeBottom();
}

module makePattern() {
  //make pattern around the circle
  square_offset = circle_offset + 2*d_nozzle;
  x_cube = 2.0;
  y_cube = size/2 - square_offset;
  for (i = [0:20:360]) {
    rotate([0,0,i]) translate([0, square_offset+y_cube/2, t_emboss/2]) {
      cube([x_cube, y_cube, t_emboss], center = true);
    }
  }
}

module makeCircle() {
    //stick a circle on it
    rotate_extrude($fn = quality) translate([circle_offset,0]) square([2*d_nozzle, t_emboss]);
}

module makeTop() {
  union() {
    color("Blue",0.5)cylinder(h=thickness/2 - t_emboss, d=size, $fn=quality);
    translate([0,0,thickness/2 - t_emboss]) {
      makeCircle();
      makePattern();

      // Add a symbol in the center
      scale([1,1]) tetraqr(1);
    }
  }
}

module makeBottom() {
  union() {
    color("Blue",0.5)cylinder(h=thickness/2 - t_emboss, d=size, $fn=quality);
    
    translate([0,0,thickness/2 - t_emboss]) {
      makeCircle();
      makePattern();
    
      // Add a symbol in the center
      rotate([0, 0, 180])
      scale([.9,.9]) tetralogo();
    }
  }
}

/* Standard tetraqr logo stamp */
module tetraqr() {
  translate([-20,-18.5,0])linear_extrude(t_emboss) import("../image/qr.svg");
}

module tetralogo() {
   translate([-18,-20,0])linear_extrude(t_emboss) import("../image/tetra_logo2.svg",convexity=30);
}