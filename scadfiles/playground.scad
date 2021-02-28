/** Includes **/
include <sn_tools.scad>

/** Scripting stuff **/
  batch_rendering = false;
  if (!batch_rendering) render_workspace();

  module render_workspace() {
    $fn = 60;
    /* tools */
    /* hacking */
    /* visuals */
    rotateX(90) {
      rpg_pedistal();
      translateX(-30)
      rpg_back_tab();
      translateX(-70)
      rpg_clip();
      translateX(-100)
      rpg_back_tab();
    }
  }
/******* Vars *******/
  pedistal_size = [100, 100, 200];
  pedistal_thickness = 7.5;
  cut_inset_Y = 25;
  cut_inset_Z = 40;
/******* Parts for visibility *******/
  // Not-Printing
/******* uprights *******/

module rpg_clip(oversize_cut = false) {
  rpg_pedistal(oversize_cut=true);
}

module rpg_pedistal(oversize_cut = false) {
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
        rpg_pedistal_mounts(over_D = 0);
    
  }
}

module rpg_pedistal_mounts(over_D = 0, height = pedistal_thickness+2, cutout=false) {
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

module rpg_ar_block() {
  translateX(58)
  make_bevelled_box(size=[20,75,75], bevel=5);
}

module rpg_back_tab() {
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
      rpg_pedistal_mounts(over_D = 10, height =20, cutout=true);
    }
  }
}