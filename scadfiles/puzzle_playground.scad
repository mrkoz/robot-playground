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

    ppg_retainers();

    // Laser parts - walls and floor

    // projection() ppg_parts_to_laser();

  }

/** params **/
  panel_thickness = 5;
  floor_panel_W = 480;
  wall_panel_W = floor_panel_W/2;
  wall_panel_H = 180;
  wall_panel_tab_W = 10;

  floor_grid = 6;

  retainer_H = 4 * panel_thickness;
  retainer_D = 3 * panel_thickness;
  retainer_sub_L = 30 + 2 * panel_thickness;
  retainer_dob_L = 2 * retainer_sub_L - 2 * panel_thickness;

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
  T([-wall_panel_W -1, -wall_panel_W/2 -1, 0]) Rx() ppg_make_wall_panel();
  // B: 2 piece wall 480*180
  T([-wall_panel_W -1, -wall_panel_W*1.5 -1, 0]) Rx()ppg_make_wall_panel(double_panel=true, end_cut = true);

  // floor corner 480^2 - 4
  T([floor_panel_W/2, floor_panel_W/2]) ppg_make_floor_panel(light=false, cutout=[false,true,true,false], wall_cutout = true);
  // floor edge 480^2 - 16
  T([-floor_panel_W/2, floor_panel_W/2]) ppg_make_floor_panel(light=true, cutout=[true,true,false,true], wall_cutout = true);
  // floor mid 480^2 - 16
  T([floor_panel_W/2, -floor_panel_W/2]) ppg_make_floor_panel(light=false, cutout=[true,true,true,true], wall_cutout = true);
  // bowtie 72
  T([-50, -100, 0]) ppg_make_floor_cutout_shape();

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

  module ppg_make_floor_panel(light=false, cutout=[true,true,true,true], wall_cutout = true) {
    Tz(-panel_thickness/3) {
      if (light) white() {
        D() {
          ccube([floor_panel_W - 0.01, floor_panel_W - 0.01, panel_thickness/2]);
          U() {
            ppg_make_floor_cutout(cutout=cutout);
            if (wall_cutout) { 
              T([-wall_panel_W/2,wall_panel_W/2,wall_panel_H/2 + panel_thickness/2]) ppg_make_wall_panel_row(num_segments = 2);
              Rz(90)T([-wall_panel_W/2,wall_panel_W/2,wall_panel_H/2 + panel_thickness/2]) ppg_make_wall_panel_row(num_segments = 2);
              T([-wall_panel_W/2,-wall_panel_W/2,wall_panel_H/2 + panel_thickness/2]) ppg_make_wall_panel_row(num_segments = 2);
              Rz(90)T([-wall_panel_W/2,-wall_panel_W/2,wall_panel_H/2 + panel_thickness/2]) ppg_make_wall_panel_row(num_segments = 2);
            }
          }
        }
      }
      else black() {
        D() {
          ccube([floor_panel_W - 0.01, floor_panel_W - 0.01, panel_thickness/2]);
          U() {
            ppg_make_floor_cutout(cutout=cutout);
            if (wall_cutout) { 
              T([-wall_panel_W/2,wall_panel_W/2,wall_panel_H/2 + panel_thickness/2]) ppg_make_wall_panel_row(num_segments = 2);
              Rz(90)T([-wall_panel_W/2,wall_panel_W/2,wall_panel_H/2 + panel_thickness/2]) ppg_make_wall_panel_row(num_segments = 2);
              T([-wall_panel_W/2,-wall_panel_W/2,wall_panel_H/2 + panel_thickness/2]) ppg_make_wall_panel_row(num_segments = 2);
              Rz(90)T([-wall_panel_W/2,-wall_panel_W/2,wall_panel_H/2 + panel_thickness/2]) ppg_make_wall_panel_row(num_segments = 2);
            }
          }
        }
      }
    }
  }

  module ppg_make_floor_cutout(cutout=[true,true,true,true]) {
    if (cutout[0]) Ty(floor_panel_W/2) ppg_make_floor_cutout_shape();
    if (cutout[1]) Rz(90)Ty(floor_panel_W/2) ppg_make_floor_cutout_shape();
    if (cutout[2]) Ty(-floor_panel_W/2) ppg_make_floor_cutout_shape();
    if (cutout[3]) Rz(90)Ty(-floor_panel_W/2) ppg_make_floor_cutout_shape();
  }

  floor_cutout_end = [40,10,panel_thickness + 1];
  floor_cutout_mid = [20,10,panel_thickness + 1];
  floor_cutout_L = 60;

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
    w_offset_X = ((num_segments) * -floor_panel_W/2) + floor_panel_W/2;
    w_offset_Y = ((num_segments) * -floor_panel_W/2);

    My() T([w_offset_X,w_offset_Y,0])ppg_make_wall_panel_row(num_segments);

    // east / west
    Rz(90) My() T([w_offset_X,w_offset_Y,0])ppg_make_wall_panel_row(num_segments);
  }

  module ppg_make_wall_cutter() {
    num_segments = floor_grid -1;
    w_offset_X = ((num_segments) * -floor_panel_W/2) + floor_panel_W/2;
    w_offset_Y = ((num_segments) * -floor_panel_W/2);
    T([w_offset_X, w_offset_Y, 0])
    for (y = [0:(floor_grid-1) * 2]) {
      Ty(y * wall_panel_W)
      ppg_make_wall_panel_row(num_segments, end_cut=false);
    }
    
    Rz(90) T([w_offset_X, w_offset_Y, 0])
    for (y = [0:(floor_grid-1) * 2]) {
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
