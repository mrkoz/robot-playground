/** Includes **/
include <sn_tools.scad>

/**
Parts to cut 
=================
A: 1 piece wall 240*180
B: 2 piece wall 480*180

floor corner 480^2 - 4
floor edge 480^2 - 16
floor mid 480^2 - 16
bowtie 72
**/

/** Scripting stuff **/
  batch_rendering = false;
  if (!batch_rendering) render_workspace();

  module render_workspace() {
    $fn = 60;
    // ppg_make_floor();
    // ppg_parts_to_laser();

    // ppg_make_floor_panel(light=true, cutout=[cutout_non,cutout_non,cutout_add,cutout_add]);



    // ppg_make_outer_wall();
    // T([wall_panel_W/2,wall_panel_W/2,0]) ppg_make_wall_cutter();
    // red()
    // Ty(20)
    // Rz(90)
    // ppg_make_wall_panel(double_panel=true);

    // Tx(wall_panel_W/2) ppg_make_wall_panel(double_panel=false);
    // Tx(-wall_panel_W/2) ppg_make_wall_panel(double_panel=false);

    // --- outcomes ---
    // Retainers
    // ppg_retainers();

    // Laser parts - walls and floor

    // projection() 
    // projection() ppg_parts_to_laser_1();
    // projection() ppg_parts_to_laser_2();
    // projection() ppg_parts_to_laser_3();
    // projection() ppg_parts_to_laser_4();
    projection() ppg_parts_to_laser_5();

  }

/** params **/
  panel_thickness = 5;
  floor_panel_W = 240;
  wall_panel_W = 240;
  wall_panel_H = 180;
  wall_panel_tab_W = 10;

  floor_grid = 12;

  retainer_H = 4 * panel_thickness;
  retainer_D = 3 * panel_thickness;
  retainer_sub_L = 30 + 2 * panel_thickness;
  retainer_dob_L = 2 * retainer_sub_L - 2 * panel_thickness;

  cutout_non = 0;
  cutout_cut = 1;
  cutout_add = 2;

module ppg_retainers() {
  D() {
    Tz(wall_panel_H/2 - retainer_H/2 + panel_thickness)
    U() {
      // straight
      makeRoundedBox([retainer_dob_L,retainer_D,retainer_H], d=panel_thickness);

      // corner
      T([-wall_panel_W, wall_panel_W, 0]){
        Tx(retainer_sub_L/2 - 1.5 * panel_thickness) makeRoundedBox([retainer_sub_L,retainer_D,retainer_H], d=panel_thickness);
        Rz() Tx(-(retainer_sub_L/2 - 1.5 * panel_thickness)) makeRoundedBox([retainer_sub_L,retainer_D,retainer_H], d=panel_thickness);
      }

      // plus
      Tx(wall_panel_W){
        makeRoundedBox([retainer_dob_L,retainer_D,retainer_H], d=panel_thickness);
        Rz() makeRoundedBox([retainer_dob_L,retainer_D,retainer_H], d=panel_thickness);
      }

      // tee
      Tx(-wall_panel_W){
        Tx(retainer_sub_L/2 - panel_thickness) makeRoundedBox([retainer_sub_L,retainer_D,retainer_H], d=panel_thickness);
        Rz() makeRoundedBox([retainer_dob_L,retainer_D,retainer_H], d=panel_thickness);
      }

    }
    U() {
      Mx() Tx(wall_panel_W) {
        My()Ty(wall_panel_W) ccube([panel_thickness, panel_thickness, wall_panel_H]);
        ccube([panel_thickness, panel_thickness, wall_panel_H]);
      }
      My()Ty(wall_panel_W) ppg_make_wall_panel(double_panel=true, end_cut = false);
      Mx()T([wall_panel_W,0, 0]) Rz() ppg_make_wall_panel(double_panel=true, end_cut = false);
      Tx(wall_panel_W) ppg_make_wall_panel(double_panel=true, end_cut = false);
      ppg_make_wall_panel(double_panel=true, end_cut = false);
    }
  }

}

module ppg_parts_to_laser() {
  // A: 1 piece wall 240*180
  // T([-wall_panel_W -1, -wall_panel_W/2 -1, 0]) Rx() ppg_make_wall_panel();
  // B: 2 piece wall 480*180
  // T([-wall_panel_W -1, -wall_panel_W*1.5 -1, 0]) Rx()ppg_make_wall_panel(double_panel=true, end_cut = true);

  sp = 0;
  // floor corner 240^2 - 4
  T([-(floor_panel_W + sp), (floor_panel_W + sp)]) ppg_make_floor_panel(light=true,  cutout=[cutout_non, cutout_add, cutout_add, cutout_non]); // * 1 
  T([(floor_panel_W + sp), (floor_panel_W + sp)]) ppg_make_floor_panel(light=true,   cutout=[cutout_non, cutout_non, cutout_add, cutout_cut]); // * 1 
  T([(floor_panel_W + sp), -(floor_panel_W + sp)]) ppg_make_floor_panel(light=true,  cutout=[cutout_cut, cutout_non, cutout_non, cutout_cut]); // * 1 
  T([-(floor_panel_W + sp), -(floor_panel_W + sp)]) ppg_make_floor_panel(light=true, cutout=[cutout_cut, cutout_add, cutout_non, cutout_non]); // * 1 
  // floor edge 240^2 - 24
  T([0,  (floor_panel_W + sp)]) ppg_make_floor_panel(light=false,                    cutout=[cutout_non, cutout_add, cutout_add, cutout_cut]); // * 6 
  T([-(floor_panel_W + sp), 0]) ppg_make_floor_panel(light=false,                    cutout=[cutout_cut, cutout_add, cutout_add, cutout_non]); // * 6 
  T([ (floor_panel_W + sp), 0]) ppg_make_floor_panel(light=false,                    cutout=[cutout_cut, cutout_non, cutout_add, cutout_cut]); // * 6 
  T([0, -(floor_panel_W + sp)]) ppg_make_floor_panel(light=false,                    cutout=[cutout_cut, cutout_add, cutout_non, cutout_cut]); // * 6 
  // floor mid 240^2 - 36
  ppg_make_floor_panel(light=true,                                                   cutout=[cutout_cut, cutout_add, cutout_add, cutout_cut]); // * 36

  // cuts
  /*
 1. 2 * 4 corners
 2. 7 * 4 sides
 3. 4 * 4 mids 16
 4. 13 * 2 mids 26
  */

  // bowtie 72
  // T([-50, -100, 0]) ppg_make_floor_cutout_shape();

}

module ppg_parts_to_laser_1() {
  sp = 0;
  T([-(floor_panel_W/2 + sp),  (floor_panel_W/2 + sp)]) ppg_make_floor_panel(light=true, cutout=[cutout_non, cutout_add, cutout_add, cutout_non]); // * 1 
  T([ (floor_panel_W/2 + sp),  (floor_panel_W/2 + sp)]) ppg_make_floor_panel(light=true, cutout=[cutout_non, cutout_non, cutout_add, cutout_cut]); // * 1 
  T([ (floor_panel_W/2 + sp), -(floor_panel_W/2 + sp)]) ppg_make_floor_panel(light=true, cutout=[cutout_cut, cutout_non, cutout_non, cutout_cut]); // * 1 
  T([-(floor_panel_W/2 + sp), -(floor_panel_W/2 + sp)]) ppg_make_floor_panel(light=true, cutout=[cutout_cut, cutout_add, cutout_non, cutout_non]); // * 1 

}

module ppg_parts_to_laser_2() {
  sp = 0;
  T([-(floor_panel_W/2 + sp),  (floor_panel_W/2 + sp)]) ppg_make_floor_panel(light=false, cutout=[cutout_cut, cutout_add, cutout_add, cutout_non]); // * 6 
  T([ (floor_panel_W/2 + sp),  (floor_panel_W/2 + sp)]) ppg_make_floor_panel(light=false, cutout=[cutout_non, cutout_add, cutout_add, cutout_cut]); // * 6 
  T([ (floor_panel_W/2 + sp), -(floor_panel_W/2 + sp)]) ppg_make_floor_panel(light=false, cutout=[cutout_cut, cutout_non, cutout_add, cutout_cut]); // * 6 
  T([-(floor_panel_W/2 + sp), -(floor_panel_W/2 + sp)]) ppg_make_floor_panel(light=false, cutout=[cutout_cut, cutout_add, cutout_non, cutout_cut]); // * 6 
}

module ppg_parts_to_laser_3() {
  sp = 0;
  T([-(floor_panel_W/2 + sp),  (floor_panel_W/2 + sp)]) ppg_make_floor_panel(light=true, cutout=[cutout_cut, cutout_add, cutout_add, cutout_cut]); // * 36
  T([ (floor_panel_W/2 + sp),  (floor_panel_W/2 + sp)]) ppg_make_floor_panel(light=true, cutout=[cutout_cut, cutout_add, cutout_add, cutout_cut]); // * 36
  T([ (floor_panel_W/2 + sp), -(floor_panel_W/2 + sp)]) ppg_make_floor_panel(light=true, cutout=[cutout_cut, cutout_add, cutout_add, cutout_cut]); // * 36
  T([-(floor_panel_W/2 + sp), -(floor_panel_W/2 + sp)]) ppg_make_floor_panel(light=true, cutout=[cutout_cut, cutout_add, cutout_add, cutout_cut]); // * 36
}

module ppg_parts_to_laser_4() {
  sp = 0;
  T([-(floor_panel_W/2 + sp),  (floor_panel_W/2 + sp)]) ppg_make_floor_panel(light=true, cutout=[cutout_cut, cutout_add, cutout_add, cutout_cut]); // * 36
  T([ (floor_panel_W/2 + sp),  (floor_panel_W/2 + sp)]) ppg_make_floor_panel(light=true, cutout=[cutout_cut, cutout_add, cutout_add, cutout_cut]); // * 36
}

module ppg_parts_to_laser_5() {
  sp = 0;
  T([-(floor_panel_W/2 + sp),  (floor_panel_W/2 + sp)]) ppg_make_floor_panel(light=true, cutout=[cutout_non, cutout_add, cutout_add, cutout_non]); // * 36
  T([ (floor_panel_W/2 + sp),  (floor_panel_W/2 + sp)]) ppg_make_floor_panel(light=true, cutout=[cutout_non, cutout_add, cutout_add, cutout_cut]); // * 36
  T([ (floor_panel_W/2 + sp), -(floor_panel_W/2 + sp)]) ppg_make_floor_panel(light=true, cutout=[cutout_cut, cutout_add, cutout_add, cutout_cut]); // * 36
  T([-(floor_panel_W/2 + sp), -(floor_panel_W/2 + sp)]) ppg_make_floor_panel(light=true, cutout=[cutout_cut, cutout_add, cutout_add, cutout_non]); // * 36
}

/** floor **/
  module ppg_make_floor() {
    f_offset= (floor_grid - 1) * -floor_panel_W/2;
    T([f_offset, f_offset, -wall_panel_H/2])
    for (x = [0:floor_grid-1]) {
      for (y = [0:floor_grid-1]) {
        T([x * floor_panel_W, y * floor_panel_W, 0]) {
          D() {
            ppg_make_floor_panel(cutout = [ y != floor_grid -1, x != 0, y != 0,  x != floor_grid-1], light = (x + y) % 2 == 0);
          }
        }
      }
    }
  }

  module ppg_make_floor_panel(light=false, cutout=[cutout_non,cutout_non,cutout_add,cutout_add]) {
    Tz(-panel_thickness/3) {
      if (light) white() {
        D() {
          U() {
            ccube([floor_panel_W - 0.01, floor_panel_W - 0.01, panel_thickness/2]);
            ppg_make_floor_cutout_add(cutout=cutout);
          }
          U() {
            ppg_make_floor_cutout(cutout=cutout);
          }
        }
      }
      else black() {
        D() {
          U() {
            ccube([floor_panel_W - 0.01, floor_panel_W - 0.01, panel_thickness/2]);
            ppg_make_floor_cutout_add(cutout=cutout);
          }
          U() {
            ppg_make_floor_cutout(cutout=cutout);
          }
        }
      }
    }
  }

  module ppg_make_floor_cutout(cutout=[true,true,true,true]) {
    if (cutout[0] == cutout_cut) Ty(floor_panel_W/2) S([1.0001, 1.0001, 1.0001]) ppg_make_floor_cutout_shape();
    if (cutout[1] == cutout_cut) Rz(-90)Ty(floor_panel_W/2) S([1.0001, 1.0001, 1.0001]) ppg_make_floor_cutout_shape();
    if (cutout[2] == cutout_cut) Ty(-floor_panel_W/2) S([1.0001, 1.0001, 1.0001]) ppg_make_floor_cutout_shape();
    if (cutout[3] == cutout_cut) Rz(-90)Ty(-floor_panel_W/2) S([1.0001, 1.0001, 1.0001]) ppg_make_floor_cutout_shape();

    Mx() Tx(wall_panel_W/2) Tz(wall_panel_H/2 + panel_thickness/2)ppg_make_wall_panel(double_panel=false);
    Rz()Mx() Tx(wall_panel_W/2) Tz(wall_panel_H/2 + panel_thickness/2)ppg_make_wall_panel(double_panel=false);
  }

  module ppg_make_floor_cutout_add(cutout=[true,true,true,true]) {
    if (cutout[0] == cutout_add) Ty(floor_panel_W/2) ppg_make_floor_cutout_shape();
    if (cutout[1] == cutout_add) Rz(-90)Ty(floor_panel_W/2) ppg_make_floor_cutout_shape();
    if (cutout[2] == cutout_add) Ty(-floor_panel_W/2) ppg_make_floor_cutout_shape();
    if (cutout[3] == cutout_add) Rz(-90)Ty(-floor_panel_W/2) ppg_make_floor_cutout_shape();
  }

  floor_cutout_end = [40,4,panel_thickness + 1];
  floor_cutout_mid = [30,10,panel_thickness + 1];
  floor_cutout_L = 20;

  module ppg_make_floor_cutout_shape() {
     progressive_hull() {
      Ty(floor_cutout_L/2) ccube(floor_cutout_end);
      ccube(floor_cutout_mid);
      Ty(-floor_cutout_L/2) ccube(floor_cutout_end);
    }
  }

/** walls **/
  module ppg_make_outer_wall() {
    num_segments = floor_grid -1;
    // north / south
    w_offset_X = ((num_segments) * -floor_panel_W) + floor_panel_W;
    w_offset_Y = ((num_segments) * -floor_panel_W);

    My() T([w_offset_X,w_offset_Y,0])ppg_make_wall_panel_row(num_segments);

    // east / west
    Rz(90) My() T([w_offset_X,w_offset_Y,0])ppg_make_wall_panel_row(num_segments);
  }

  module ppg_make_wall_cutter() {
    num_segments = floor_grid/2 -1;
    w_offset_X = ((num_segments) * -floor_panel_W) + floor_panel_W;
    w_offset_Y = ((num_segments) * -floor_panel_W);
    T([w_offset_X, w_offset_Y, 0])
    for (y = [0:(floor_grid/2-1) * 2]) {
      Ty(y * wall_panel_W)
      ppg_make_wall_panel_row(num_segments, end_cut=false);
    }
    
    Rz(90) T([w_offset_X, w_offset_Y, 0])
    for (y = [0:(floor_grid/2-1) * 2]) {
      Ty(y * wall_panel_W)
      ppg_make_wall_panel_row(num_segments, end_cut=false);
    }

    My() T([w_offset_X,w_offset_Y,0])ppg_make_wall_panel_row(num_segments);
  }

  module ppg_make_wall_panel_row(num_segments, end_cut=true) {
    for (x = [0:num_segments-1]) {
      T([x * floor_panel_W, 0, 0]) {
        ppg_make_wall_panel(double_panel=true, end_cut=end_cut);
      }
    }
  }

  module ppg_make_wall_panel(double_panel=false, end_cut = true) {
    if (!double_panel) {
      tabs = [
        (wall_panel_W/2 - wall_panel_tab_W/2 - (panel_thickness * 2)),
        ];
      D() {
        U() {
          // wall
          panel_width = (end_cut? wall_panel_W - panel_thickness : wall_panel_W);
          ccube([panel_width, panel_thickness, wall_panel_H]);
          Mx() for (x = tabs) {
            T([x,0,-panel_thickness])ccube([wall_panel_tab_W, panel_thickness, wall_panel_H]);
          }

        }
        U() {
          Mx() for (x = tabs) {
            T([x,0,-panel_thickness + wall_panel_H -1])makeRoundedBox_rotate_90_X([wall_panel_tab_W + 0.01, panel_thickness + 0.01, wall_panel_H]);
          }
        }
      }
    }
    else {
      tabs = [
        (wall_panel_tab_W/2 + (panel_thickness * 2)),
        (wall_panel_W - wall_panel_tab_W/2 - (panel_thickness * 2)),
        ];
      D() {
        U() {
          // wall
          panel_width = (end_cut? (wall_panel_W * 2) - panel_thickness : (wall_panel_W * 2));
          ccube([panel_width, panel_thickness, wall_panel_H]);
          Mx() for (x = tabs) {
            T([x,0,-panel_thickness])ccube([wall_panel_tab_W, panel_thickness, wall_panel_H]);
          }

        }
        U() {
          Mx() for (x = tabs) {
            T([x,0,-panel_thickness + wall_panel_H -1])makeRoundedBox_rotate_90_X([wall_panel_tab_W + 0.01, panel_thickness + 0.01, wall_panel_H]);
          }
        }
      }
    }
  }
