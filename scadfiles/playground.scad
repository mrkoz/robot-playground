/** Includes **/
include <sn_tools.scad>

/** Scripting stuff **/
  batch_rendering = false;
  if (!batch_rendering) render_workspace();

  module render_workspace() {
    $fn = 60;
    /* hacking */
    
      // rotateX(90) {
        // rpg_locking_pedistal();
        // translateX(-30)
        // rpg_locking_back_tab();
        // translateX(-70)
        // rpg_locking_clip();
        // translateX(-100)
        // rpg_locking_back_tab();
      // }

      // rotateX(90) rotateZ(90) 
      // rpg_clamp_flat_inner(simple=true);
      // translateX(150) rotateX(90) rotateZ(90) rpg_clamp_flat_inner(simple=true);
      // translateX(180) rotateX(90) rotateZ(90) rpg_clamp_flat_inner(simple=true);
      // translate([0, 120, -20]) 
      // rpg_clamp_flat_foot(simple=true);
      // // translateY(-130) rpg_clamp_corner(simple=true);
      // translate([0, -130, -20]) rpg_clamp_corner_foot(simple=true);
      // rpg_clamp_pedistol();
      // translate([0, 0, -30]) 
      // rpg_clamp_pedistol_base();
      // rpg_short_clamp();
      // rpg_short_clamp_corner();
      // rpg_short_clamp();
      // rpg_short_clamp_cross();


    /* for print */

    // ----  all mini-clamps
    // rpg_short_clamps_for_print();
    // ----  cross
    // rpg_short_clamps_for_print(cross=true, corner=false, join=false);
    // ---- corner
    // rpg_short_clamps_for_print(cross=false, corner=true, join=false);
    // ---- joiner
    // rpg_short_clamps_for_print(cross=false, corner=false, join=true);

    // ---- pedistol
    // rotateX(90) rpg_clamp_pedistol();
    // ---- pedistol base
    // rotateX(90) rpg_clamp_pedistol_base();

    /* visuals */
      // ---- for show
      // playground_four_four();
  }

  module rpg_short_clamps_for_print(cross=true, corner=true, join=true) {
    difference() {
      union() {
        translateY(50) {
          if (cross) translateX(80) rpg_short_clamp_cross();
          if (corner) translateX(-80) rpg_short_clamp_corner();
          if (join) translateX(0) rpg_short_clamp();
        }
        rotateX(180)
        translateY(50) {
          if (cross) translateX(80) rpg_short_clamp_cross();
          if (corner) translateX(-80) rpg_short_clamp_corner();
          if (join) translateX(0) rpg_short_clamp();
        }
      }
      translateZ(-100) {
        ccube([450, 250, 55]);
      }
    }
  }

/******* Vars *******/
  pedistal_size = [100, 100, 200];
  pedistal_thickness = 7.5;
  cut_inset_Y = 25;
  cut_inset_Z = 40;
/******* Parts for visibility *******/
  // Not-Printing
  module playground_four_four() {
    // corflute
    white() {
      mirrorX() translateX(2500) ccube([5, 5000, 200]);
      mirrorY() translateY(2500) ccube([5000, 5, 200]);
    }

    // pedistols
    blue()
    mirrorX() mirrorY() {
      translate([500,2540,0]) {
        rotateZ(-90) {
          rpg_clamp_pedistol();
          rpg_clamp_pedistol_base();
        }
        translate([1000, 0, 0]) {
          rotateZ(-90) {
            rpg_clamp_pedistol();
            rpg_clamp_pedistol_base();
          }
        }
      }

      translate([-2540,500,0]) {
        rpg_clamp_pedistol();
        rpg_clamp_pedistol_base();
        translate([0, 1000, 0]) {
          rpg_clamp_pedistol();
          rpg_clamp_pedistol_base();
        }
      }
    }
    green()
    // corners
    mirrorX() mirrorY()
    translate([-2500, -2500, 0]) {
      rpg_short_clamp_corner();
    }

    red()
    mirrorX() mirrorY() {
      // joiners (330)
      translate([-2167, -2500, 0])
      for (i = [1:14]) {
        if (i%3 != 0)
        translateX((i-1) * 333) {
          // rpg_clamp_flat_inner(simple=true);
          // rpg_clamp_flat_foot(simple=true);
          rpg_short_clamp();
        }
      }
      rotateZ(90)
      translate([-2167, -2500, 0])
      for (i = [1:14]) {
        if (i%3 != 0)
        translateX((i-1) * 333) {
          // rpg_clamp_flat_inner(simple=true);
          // rpg_clamp_flat_foot(simple=true);
          rpg_short_clamp();
        }
      }
    }

  }
/******* locking uprights *******/

  module rpg_locking_clip(oversize_cut = false) {
    rpg_locking_pedistal(oversize_cut=true);
  }

  module rpg_locking_pedistal(oversize_cut = false) {
    union() {
      difference() {
        ccube(pedistal_size);
        union() {
          translate([-36.5, 0, 10]) ccube([10, 101, 190]);
          translate([-46.5, 0, 25]) ccube([11, 101, 190]);
          // inner chop
          if (!oversize_cut) {
            difference() {
              translateX(10) ccube(addXYZ(pedistal_size,-(2*pedistal_thickness + 20),(2*pedistal_thickness), -(2*pedistal_thickness)));
              translate([-24, 0, 98])ccube([30, 121, 20]);
            }
          } else {
            difference() {
              translateX(14) ccube(addXYZ(pedistal_size,-(2*pedistal_thickness + 11),(2*pedistal_thickness), +1));
              translate([-24, 0, 98])ccube([30, 121, 20]);
            }
          }

          // tab cutout
          translate([-18.3, 0, 90])ccube([8, 62, 15]);
          //top left cutout
          translate([-30, 0, 98])ccube([30, 101, 9]);

          rpg_ar_block();
        }
      }
          rpg_locking_pedistal_mounts(over_D = 0);
      
    }
  }

  module rpg_locking_pedistal_mounts(over_D = 0, height = pedistal_thickness+2, cutout=false) {
    translateZ(10) {
      mirrorY() {
        hull() {
          translate([-pedistal_size[0]/2 + pedistal_thickness/2 +10.5, pedistal_size[1]/2-cut_inset_Y, pedistal_size[2]/2-cut_inset_Z])
          rotateY(90)ccylinder(d=12 + over_D, h = height);
          if (cutout)
            translate([-pedistal_size[0]/2 + pedistal_thickness/2 +10.5, pedistal_size[1]/2-cut_inset_Y, pedistal_size[2]/2-cut_inset_Z - 10])
            rotateY(90)ccylinder(d=12 + over_D, h = height);
        }
        hull() {
          translate([-pedistal_size[0]/2 + pedistal_thickness/2 +10.5, pedistal_size[1]/2-cut_inset_Y, 0])
          rotateY(90)ccylinder(d=12 + over_D, h = height);
          if (cutout)
            translate([-pedistal_size[0]/2 + pedistal_thickness/2 +10.5, pedistal_size[1]/2-cut_inset_Y, -10])
            rotateY(90)ccylinder(d=12 + over_D, h = height);
        }
        hull() {
          translate([-pedistal_size[0]/2 + pedistal_thickness/2 +10.5, pedistal_size[1]/2-cut_inset_Y, -(pedistal_size[2]/2-cut_inset_Z)])
          rotateY(90)ccylinder(d=12 + over_D, h = height);
          if (cutout)
            translate([-pedistal_size[0]/2 + pedistal_thickness/2 +10.5, pedistal_size[1]/2-cut_inset_Y, -(pedistal_size[2]/2-cut_inset_Z) - 10])
            rotateY(90)ccylinder(d=12 + over_D, h = height);
        }
      }
    }
  }


  module rpg_locking_back_tab() {
    difference() {
      translate([-38.3, 0, 11])
      union() {
        // upright
        translateZ(-3)
        ccube([6, 100, 184]);
        // cross
        translate([10.5, 0, 86]) ccube(setXZ(pedistal_size, 25, 6));
        // tab
        translate([20, 0, 79.5])ccube([6, 60, 15]);

      }
      union() {
        rpg_locking_pedistal_mounts(over_D = 10, height =20, cutout=true);
      }
    }
  }

// rpg clamping uprights

rpg_clamp_panel_thickness = 5;
rpg_clamp_undersize = 0.1;
rpg_clamp_space = rpg_clamp_panel_thickness - rpg_clamp_undersize;
rpg_clamp_wall_thickness = 6;
rpg_inner_panel_thickness = rpg_clamp_wall_thickness * 2 + rpg_clamp_space;


rpg_pedistol_foot_Y = 60;
rpg_pedistol_undersize_Y = 100 - rpg_pedistol_foot_Y;

  module rpg_clamp_pedistol(cutout_oversize=0) {
    union() {
      translate([-30, 0, 100 -(rpg_clamp_wall_thickness * 1.5)])
      ccube([rpg_clamp_wall_thickness + cutout_oversize, 35 + cutout_oversize, 3*rpg_clamp_wall_thickness + 0.1]);
      difference() {
        union() {
          // front and top
          ccube([100 + cutout_oversize, 100, 200 + 0.01]);
        }
        union() {
          // ar block 
          rpg_ar_block();
          // tail cut
          translate([-rpg_clamp_wall_thickness - cutout_oversize/2, 0, -rpg_clamp_wall_thickness]) {
              ccube([100.1, 100.1, 200.1]);
          }
          mirrorY() {
            translate([50 - rpg_clamp_wall_thickness/2, 35, -100 + rpg_clamp_wall_thickness/2])
            ccube([rpg_clamp_wall_thickness + 0.01 + cutout_oversize*2, 35.01 - cutout_oversize, rpg_clamp_wall_thickness + 0.02]);
          }
        }
      }
    }
  }
  
  module rpg_clamp_pedistol_base() {
    sizeX = 100 - rpg_clamp_wall_thickness - rpg_clamp_space;
    sizeY = 60;
    sizeZ = 200;

    difference() {
      union() {
        translate([-(rpg_clamp_wall_thickness + rpg_clamp_space)/2, 0, -rpg_clamp_wall_thickness/2])
        ccube([sizeX, sizeY , sizeZ  - rpg_clamp_wall_thickness]);
        translate([50 - rpg_clamp_space/2,0,-100+rpg_clamp_wall_thickness/2])
        ccube([rpg_clamp_wall_thickness * 3 + rpg_clamp_space + 0.01, sizeY, rpg_clamp_wall_thickness]);
      }
      union() {
        translate([-(rpg_clamp_wall_thickness + rpg_clamp_space)/2, 0, -rpg_clamp_wall_thickness/2])
          ccube([sizeX - rpg_clamp_wall_thickness * 2, sizeY + 0.01 , sizeZ  - rpg_clamp_wall_thickness * 3]);

          rpg_clamp_pedistol(cutout_oversize=1.5);

      }
    }

  }

  module rpg_clamp_corner(with_cutout=true, simple=false) {
    union() {
      translateY(39.5)
      rotateZ(90)
      rpg_clamp_flat_inner(with_cutout = with_cutout, simple=simple);
      translateX(39.5)
      rpg_clamp_flat_inner(with_cutout = with_cutout, simple=simple);
    }
  }

  module rpg_clamp_corner_foot(simple=false) {
    difference() {
      union() {
        translateZ(-100 + 2.5) {
          translateY(32.5) ccube([40, 50, 20]);
          translateX(32.5) ccube([50, 40, 20]);
        }
      }
      union() {
        // panel spacer
        rpg_clamp_corner(with_cutout = false, simple=simple);
      }
    }
  }

  module rpg_clamp_flat_inner(with_cutout = true, simple=false, oversize=0) {
    Ysize = 40.01 + oversize;
    difference() {
      union() {
        ccube([40.01, rpg_inner_panel_thickness + oversize, 200]);
        translateZ((200 - 30)/2) rotate([-90,0,90])make_triangle(size=[25 + oversize,30 + oversize,Ysize]);
        translateZ(-(200 - 30)/2) rotate([90,0,90])make_triangle(size=[25 + oversize,30 + oversize,Ysize]);
        if (!simple) {
          mirrorX() translate([15,0,rpg_clamp_wall_thickness/2])
          make_bevelled_box([rpg_clamp_wall_thickness * 2, rpg_inner_panel_thickness + rpg_clamp_wall_thickness * 2, 200 + rpg_clamp_wall_thickness], bevel = rpg_clamp_wall_thickness /1.01);
        }
      }
      #union() {
        // panel spacer
        if (with_cutout) {
          translateZ(-rpg_clamp_panel_thickness/2)
          ccube([61, rpg_clamp_space, 200 - rpg_clamp_panel_thickness + 0.1]);
        }
      }
    }
  }
  module rpg_clamp_flat_foot(simple=false) {
    difference() {
      union() {
        translateZ(-100 + 2.5)
        ccube([40, rpg_clamp_wall_thickness * 6 + rpg_clamp_space, 20]);
      }
      union() {
        // panel spacer
        rpg_clamp_flat_inner(with_cutout = false, simple=simple, oversize=0.5);
      }
    }
  }

// really short joiners

module rpg_short_clamp() {
  oversize=0;
  Ysize = 40.01 + oversize;
  difference() {
    union() {
      ccube([28.01, rpg_inner_panel_thickness + oversize, 200]);

      mirrorX() translate([14,0,rpg_clamp_wall_thickness/2])
      make_bevelled_box([rpg_clamp_wall_thickness * 2, rpg_inner_panel_thickness + rpg_clamp_wall_thickness * 2, 200 + rpg_clamp_wall_thickness], bevel = rpg_clamp_wall_thickness /1.01);
    }
    union() {
      // panel spacer
      ccube([61, rpg_clamp_space, 200 - rpg_clamp_panel_thickness * 2 + 0.1]);
      // cutter
      ccube([50, 50, 150]);
    }
  }
}

module rpg_short_clamp_corner() {
  translate([22.5,0,0])
  rpg_short_clamp();
  translate([0,22.5,0])
  rotateZ(90) rpg_short_clamp();

}
module rpg_short_clamp_cross() {
  rpg_short_clamp_corner();
  rotateZ(180) rpg_short_clamp_corner();
}

// rpg bits


  module rpg_ar_block() {
    translateX(58)
    make_bevelled_box(size=[20,75,75], bevel=5);
  }