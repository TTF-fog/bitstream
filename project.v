`default_nettype none
module tt_um_vga_example (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);
  assign uio_out = 0;
  assign uio_oe  = 0;
  wire _unused_ok = &{ena, ui_in[7], ui_in[4:0], uio_in};
  
  wire hsync;
  wire vsync;
  reg [1:0] R;
  reg [1:0] G;
  reg [1:0] B;
  wire video_active;
  wire [9:0] pix_x;
  wire [9:0] pix_y;
  
  assign uo_out = {hsync, B[0], G[0], R[0], vsync, B[1], G[1], R[1]};
  
  hvsync_generator vga_sync_gen (
      .clk(clk),
      .reset(~rst_n),
      .hsync(hsync),
      .vsync(vsync),
      .display_on(video_active),
      .hpos(pix_x),
      .vpos(pix_y)
  );
  
  wire inp_b, inp_y, inp_select, inp_start, inp_up, inp_down, inp_left, inp_right, inp_a, inp_x, inp_l, inp_r,  present;
    gamepad_pmod_single driver (
      .rst_n(rst_n),
      .clk(clk),
      .pmod_data(ui_in[6]),
      .pmod_clk(ui_in[5]),
      .pmod_latch(ui_in[4]),
      .b(inp_b),
      .y(inp_y),
      .select(inp_select),
      .start(inp_start),
      .up(inp_up),
      .down(inp_down),
      .left(inp_left),
      .right(inp_right),
      .a(inp_a),
      .x(inp_x),
      .l(inp_l),
      .r(inp_r)
  );

localparam [7:0] Cross[0:7] = '{
    8'b00011000,  
    8'b00011000,  
    8'b00011000,  
    8'b11111111,  
    8'b11111111,  
    8'b00011000, 
    8'b00011000, 
    8'b00011000   
};

localparam [7:0] T[0:7] = '{
    8'b11111111,  
    8'b00011000,  
    8'b00011000,  
    8'b00011000,  
    8'b00011000,  
    8'b00011000, 
    8'b00011000, 
    8'b00011000   
};

localparam [7:0] U[0:7] = '{
    8'b11000011,  
    8'b11000011,  
    8'b11000011,  
    8'b11000011,  
    8'b11000011,  
    8'b11000011, 
    8'b11000011, 
    8'b01111110   
};

localparam [7:0] R_letter[0:7] = '{
    8'b11111110,  
    8'b11000011,  
    8'b11000011,  
    8'b11111110,  
    8'b11111000,  
    8'b11001100, 
    8'b11000110, 
    8'b11000011   
};

localparam [7:0] N[0:7] = '{
    8'b11000011,  
    8'b11100011,  
    8'b11110011,  
    8'b11111011,  
    8'b11011111,  
    8'b11001111, 
    8'b11000111, 
    8'b11000011   
};

localparam [7:0] E[0:7] = '{
    8'b11111111,  
    8'b11111111,  
    8'b10000000,  
    8'b11111111,  
    8'b11111111,  
    8'b10000000, 
    8'b11111111, 
    8'b11111111 
};

localparam [7:0] C[0:7] = '{
    8'b01111110,  
    8'b11000011,  
    8'b10000000,  
    8'b10000000,  
    8'b10000000,  
    8'b10000000, 
    8'b11000011, 
    8'b01111110   
};

localparam [7:0] I[0:7] = '{
    8'b11111111,  
    8'b00011000,  
    8'b00011000,  
    8'b00011000,  
    8'b00011000,  
    8'b00011000, 
    8'b00011000, 
    8'b11111111   
};

localparam [7:0] L[0:7] = '{
    8'b10000000,
    8'b10000000,
    8'b10000000,
    8'b10000000,
    8'b10000000,
    8'b10000000,
    8'b10000000,
    8'b11111111
};

localparam [7:0] W[0:7] = '{
    8'b11000011,  
    8'b11000011,  
    8'b11000011,  
    8'b11000011,  
    8'b11011011,  
    8'b11011011, 
    8'b11111111, 
    8'b01100110   
};

localparam [7:0] S[0:7] = '{
    8'b01111110,  
    8'b11000011,  
    8'b11000000,  
    8'b01111110,  
    8'b00000011,  
    8'b00000011, 
    8'b11000011, 
    8'b01111110   
};

localparam [7:0] Exclamation[0:7] = '{
    8'b00011000,  
    8'b00011000,  
    8'b00011000,  
    8'b00011000,  
    8'b00011000,  
    8'b00000000, 
    8'b00011000, 
    8'b00011000   
};

localparam [7:0] Colon[0:7] = '{
    8'b00000000,  
    8'b00011000,  
    8'b00011000,  
    8'b00000000,  
    8'b00000000,  
    8'b00011000, 
    8'b00011000, 
    8'b00000000   
};

  parameter [7:0] Circle[0:7] = '{
      8'b01111110,
      8'b11000011,
      8'b10000001,
      8'b10000001,
      8'b10000001,
      8'b10000001,
      8'b11000011,
      8'b01111110
  };
  
  localparam [7:0] Blank[0:7] = '{
      8'b00000000,
      8'b00000000,
      8'b00000000,
      8'b00000000,
      8'b00000000,
      8'b00000000,
      8'b00000000,
      8'b00000000
  };
  
   localparam [7:0] Sel[0:7] = '{
      8'b11111111,
      8'b10000001,
      8'b10000001,
      8'b10000001,
      8'b10000001,
      8'b10000001,
      8'b10000001,
      8'b11111111
  };
  
  reg  [8:0] state = 9'b00000000;
  reg  [8:0] placed = 9'b000000000;
  reg [8:0] selected = 9'b00000001; 
  wire [8:0] sel_active;
  wire [11:0] btn_in = {
  inp_b, inp_y, inp_select, inp_start,
  inp_up, inp_down, inp_left, inp_right,
  inp_a, inp_x, inp_l, inp_r
};
reg [11:0] last_btn;
wire [11:0] btn_pressed;
wire [1:0] win;
 genvar c;
generate
  for (c = 0; c < 11; c = c+1) begin : BUTTON_POPULATE
    assign btn_pressed[c] = btn_in[c] & ~last_btn[c];
  end//
endgenerate

  reg turn = 1'b0;
  
  wire turn_t, turn_u, turn_r, turn_n, turn_colon, current_item;
  reg [9:0] t_x = 30;
  reg[9:0] t_y = 455;
  assign turn_t = glyph_active(t_x, t_y, T, 3);
  assign turn_u = glyph_active(60, 455, U, 3);
  reg [9:0] r_x = 90;
  reg [9:0] r_y = 455;
  assign turn_r = glyph_active(r_x, r_y, R_letter, 3);

assign win = check_for_win(placed,state);
parameter circle_win_x = 160;
parameter circle_win_y = 220;
reg [9:0] i_x = 190;
reg [9:0] i_y = 220;
reg [9:0] e_x = 310;
reg [9:0] e_y = 220;
wire circle_wins_c = glyph_active(circle_win_x + 0*30, circle_win_y, C, 3);
wire circle_wins_i1 = glyph_active(i_x, i_y, I, 3);
wire circle_wins_c2 = glyph_active(circle_win_x + 3*30, circle_win_y, C, 3);
wire circle_wins_l = glyph_active(circle_win_x + 4*30, circle_win_y, L, 3);
wire circle_wins_e = glyph_active(e_x , e_y, E, 3);
wire circle_wins_w = glyph_active(circle_win_x + 7*30, circle_win_y, W, 3);
wire circle_wins_i2 = glyph_active(circle_win_x + 8*30, circle_win_y, I, 3);
wire circle_wins_s = glyph_active(circle_win_x + 10*30, circle_win_y, S, 3);
wire circle_wins_excl = glyph_active(circle_win_x + 11*30, circle_win_y, Exclamation, 3);
reg [5:0] turn_color = 6'b111111;
wire [10:0] Circle_spelling = {circle_wins_excl, circle_wins_s, circle_wins_i2, circle_wins_w, 
                              circle_wins_e, circle_wins_l, circle_wins_c2, circle_wins_i1, circle_wins_c};


reg [7:0] cross_win_x = 8'd160;
parameter cross_win_y = 220;
wire cross_wins_r = glyph_active(cross_win_x + 1*30, cross_win_y, R_letter, 3);
wire cross_wins_o = glyph_active(cross_win_x + 2*30, cross_win_y, Circle, 3);  // Using
wire cross_wins_s1 = glyph_active(cross_win_x + 3*30, cross_win_y, S, 3);
wire cross_wins_s2 = glyph_active(cross_win_x + 4*30, cross_win_y, S, 3);
wire [10:0] Cross_spelling = {circle_wins_excl, circle_wins_s , circle_wins_i2, circle_wins_w, cross_wins_s2, cross_wins_s1, cross_wins_o, cross_wins_r, circle_wins_c};
  reg [9:0] n_x = 10'd120;
  reg [9:0] n_y = 10'd455;
  assign turn_n = glyph_active(n_x, n_y, N, 3);
  assign turn_colon = glyph_active(150, 455, Colon, 3);
  assign current_item = glyph_active(180, 455, turn ? Circle : Cross, 3);
  wire [8:0] cell_active; 
  localparam CELL_SPACING = 250; 
  localparam CELL_SPACING_Y = 180; 
  localparam GRID_ORIGIN_X = 30;
  localparam GRID_ORIGIN_Y = 30;
  wire [3:0] sel_index = high_index(selected);
wire [8:0] cell_glyph_on;
genvar i;
generate
  for (i=0; i<9; i=i+1) begin : CELL_DRAW
    localparam integer row = i / 3;
    localparam integer col = i % 3;
    
    // Only call glyph_active if cell is occupied
    assign cell_glyph_on[i] = state[i] ? glyph_active(
        GRID_ORIGIN_X + col*CELL_SPACING,
        GRID_ORIGIN_Y + row*CELL_SPACING_Y,
        placed[i] ? Circle : Cross, 10
    ) : 1'b0;
  end
endgenerate

assign cell_active = cell_glyph_on;

wire sel_glyph_on;
assign sel_glyph_on = (|selected) ? glyph_active(
    GRID_ORIGIN_X + (sel_index % 3) * CELL_SPACING - 20,
    GRID_ORIGIN_Y + (sel_index / 3) * CELL_SPACING_Y - 20,
    Sel, 15
) : 1'b0;
assign sel_active = {9{sel_glyph_on}} & selected;

always @(posedge clk) begin
  R <= 2'b00;
  G <= 2'b00;
  B <= 2'b01;

  if (video_active) begin
    R <= 2'b00;
    G <= 2'b00;
    B <= 2'b01;
   
   if (|cell_active) begin
        {R,G,B} <= 6'b111111;
        end
       
    if ( (pix_y >= 330 && pix_y <= 340) || (pix_y >= 450) ||
         (pix_x >= 480 && pix_x <= 500) ||           
         (pix_x >= (639-500) && pix_x <= (639-480)) ||
         (pix_y >= (479-340) && pix_y <= (479-330)) ) 
    begin
      R <= 2'b00;
      G <= 2'b01;
      B <= 2'b00; 
    end
    /*
    7 = uparrow
    4 = rightarrow
    1 = Left Trigger
    0 = Right Trigger
    3 = A
    11 = Unknown
    10 = Y
    9 = Select
    8 = Start
    6 = Down Arrow
    5 = Left Arrow
    2 = X
    */
    //scroll around the grid
    if (btn_pressed[5]) begin //left arrow
      selected <= {selected[0], selected[8:1]};
    end 
    if (btn_pressed[4]) begin
        selected <= {selected[7:0], selected[8]};
    end
    if (btn_pressed[6]) begin
      selected <= { selected[5:0], selected[8:6] };
    end
    if (btn_pressed[7]) begin
      selected <= { selected[2:0], selected[8:3] };
    end
    if (btn_pressed[0]) begin 
      state <= {9{1'b0}};
      placed <= {9{1'b0}};
    end
     if (|sel_active) begin
        G <= 2'b11;
        end
      
      
       turn_color <= 6'b111111;
       n_x <= 10'd120;
       r_x <= 10'd90;
       r_y <= 10'd455;
       n_y <= 10'd455;
       t_x <= 30;
       t_y <= 455;
       //out of sight out of mind
       i_x <= 1900;
       i_y <= 2200;
    e_x <= 31009; 
 e_y <= 22000;
      if (btn_pressed[9]) begin //Select
      
        if (!state[sel_index]) begin
          state[sel_index] <= 1'b1;
          placed[sel_index] <= turn ? 1'b1 : 1'b0;
          turn <= !turn;
        end
      end
    if (win[0]) begin
      i_x <= 190;
       i_y <= 220;
        r_x <= 220;
        r_y <= 220;
       e_x <= 310;
     e_y <= 220;
        {R,G,B} <= 6'b1;
        turn_color <= 6'b001100;
        n_y <= 220; //it's a rendering priority issue
        n_x <= 430;
        
    if (win[1]) begin
      if (|Circle_spelling) begin
        
      G <= 6'b111111;
      end
    end else begin
       
      if (|Cross_spelling) begin
         i_x <= 900;
       i_y <= 900;
        r_x <= 900;
        r_y <=900;
       e_x <= 900;
     e_y <= 900;
       G <= 6'b111111;
      end
    end
  
    end else if (state == {9{1'b1}}) begin //everything is placed, but weesa nosa have a winsa
        i_x <= 260;
        i_y <= 220;
        t_x <= 220;
        t_y <= 220;
         e_x <= 300;
         e_y <= 220;
        {R,G,B} <= 6'b000001;
        turn_color <= 6'b110000;
      end
     if (turn_t || turn_u || turn_r || turn_n || turn_colon || current_item || circle_wins_i1 || circle_wins_e) begin
      {R, G, B} <= turn_color;
    end

last_btn <= btn_in;
  end
end

function [3:0] high_index;
    input [8:0] select;
    begin
      integer i;
      high_index = -1;
      for (i = 0; i < 9; i = i +1) begin
        if (select[i]) begin
          high_index = i;
        end
    end
    end
    endfunction
function [1:0] check_for_win;
    input [8:0] placed;
    input [8:0] state;
    begin

       reg win_top_horizontal = 1'b0;
       reg win_mid_horizontal = 1'b0;
       reg win_low_horizontal = 1'b0;
       reg win_left_vertical = 1'b0;
       reg win_mid_vertical = 1'b0;
       reg win_right_vertical = 1'b0;
       
       reg win_main_diagonal = 1'b0;
       reg win_anti_diagonal = 1'b0;
       //absolute dumpsture fire but thhis was the best thing i could think off
       reg sign = 1'b0;
       reg any_win = 1'b0;
      if (state[0] && state[1] && state[2]) begin
        win_top_horizontal = (placed[0] == placed[1]) && (placed[0] == placed[2]);
      end
      if (state[3] && state[4] && state[5]) begin
        win_mid_horizontal = (placed[3] == placed[4]) && (placed[4] == placed[5]);
      end
      if (state[6] && state[7] && state[8]) begin
        win_low_horizontal = (placed[6] == placed[7]) && (placed[7] == placed[8]);
      end

      if (state[0] && state[3] && state[6]) begin
        win_left_vertical = (placed[0] == placed[3]) && (placed[0] == placed[6]);
      end
      if (state[1] && state[4] && state[7]) begin
        win_mid_vertical = (placed[1] == placed[4]) && (placed[1] == placed[7]);
      end
      if (state[2] && state[5] && state[8]) begin
        win_right_vertical = (placed[2] == placed[5]) && (placed[2] == placed[8]);
      end
    
      if (state[0] && state[4] && state[8]) begin
        win_main_diagonal = (placed[0] == placed[4]) && (placed[0] == placed[8]);
      end
      if (state[2] && state[4] && state[6]) begin
        win_anti_diagonal = (placed[2] == placed[4]) && (placed[2] == placed[6]);
      end
    
      any_win = win_top_horizontal | win_mid_horizontal | win_low_horizontal |
                win_left_vertical | win_mid_vertical | win_right_vertical |
                win_main_diagonal | win_anti_diagonal;
    
      if (win_top_horizontal) sign = placed[0];
      else if (win_mid_horizontal) sign = placed[3];
      else if (win_low_horizontal) sign = placed[6];
      else if (win_left_vertical) sign = placed[0];
      else if (win_mid_vertical) sign = placed[1];
      else if (win_right_vertical) sign = placed[2];
      else if (win_main_diagonal) sign = placed[0];
      else if (win_anti_diagonal) sign = placed[2];
      else sign = 1'b0;
      
      check_for_win = {sign, any_win};
    end
    endfunction

function glyph_active;
    input [9:0] x0, y0;
    input [7:0] glyph[0:7];
    reg [9:0] x_rel, y_rel;
    reg [7:0] row;
    input reg [9:0] scale;
    begin
      reg [9:0] scale_factor = 8 * scale;
      if ((pix_x >= x0) && (pix_x < x0 + scale_factor) && (pix_y >= y0) && (pix_y < y0 + scale_factor)) begin
        x_rel = (pix_x - x0) / scale;  
        y_rel = (pix_y - y0) / scale;
        row = glyph[y_rel];
        glyph_active = row[7-x_rel];
      end else begin
        glyph_active = 0;
      end
    end
endfunction

endmodule

module gamepad_pmod_driver #(
    parameter BIT_WIDTH = 24
) (
    input wire rst_n,
    input wire clk,
    input wire pmod_data,
    input wire pmod_clk,
    input wire pmod_latch,
    output reg [BIT_WIDTH-1:0] data_reg
);

  reg pmod_clk_prev;
  reg pmod_latch_prev;
  reg [BIT_WIDTH-1:0] shift_reg;

  reg [1:0] pmod_data_sync;
  reg [1:0] pmod_clk_sync;
  reg [1:0] pmod_latch_sync;

  always @(posedge clk) begin
    if (~rst_n) begin
      pmod_data_sync  <= 2'b0;
      pmod_clk_sync   <= 2'b0;
      pmod_latch_sync <= 2'b0;
    end else begin
      pmod_data_sync  <= {pmod_data_sync[0], pmod_data};
      pmod_clk_sync   <= {pmod_clk_sync[0], pmod_clk};
      pmod_latch_sync <= {pmod_latch_sync[0], pmod_latch};
    end
  end

  always @(posedge clk) begin
    if (~rst_n) begin
      data_reg <= {BIT_WIDTH{1'b1}};
      shift_reg <= {BIT_WIDTH{1'b1}};
      pmod_clk_prev <= 1'b0;
      pmod_latch_prev <= 1'b0;
    end
    begin
      pmod_clk_prev   <= pmod_clk_sync[1];
      pmod_latch_prev <= pmod_latch_sync[1];

      if (pmod_latch_sync[1] & ~pmod_latch_prev) begin
        data_reg <= shift_reg;
      end

      if (pmod_clk_sync[1] & ~pmod_clk_prev) begin
        shift_reg <= {shift_reg[BIT_WIDTH-2:0], pmod_data_sync[1]};
      end
    end
  end

endmodule

module gamepad_pmod_decoder (
    input wire [11:0] data_reg,
    output wire b,
    output wire y,
    output wire select,
    output wire start,
    output wire up,
    output wire down,
    output wire left,
    output wire right,
    output wire a,
    output wire x,
    output wire l,
    output wire r,
    output wire is_present
);

  wire reg_empty = (data_reg == 12'hfff);
  assign is_present = reg_empty ? 0 : 1'b1;
  assign {b, y, select, start, up, down, left, right, a, x, l, r} = reg_empty ? 0 : data_reg;

endmodule

module gamepad_pmod_single (
    input wire rst_n,
    input wire clk,
    input wire pmod_data,
    input wire pmod_clk,
    input wire pmod_latch,

    output wire b,
    output wire y,
    output wire select,
    output wire start,
    output wire up,
    output wire down,
    output wire left,
    output wire right,
    output wire a,
    output wire x,
    output wire l,
    output wire r,
    output wire is_present
);

  wire [11:0] gamepad_pmod_data;

  gamepad_pmod_driver #(
      .BIT_WIDTH(12)
  ) driver (
      .rst_n(rst_n),
      .clk(clk),
      .pmod_data(pmod_data),
      .pmod_clk(pmod_clk),
      .pmod_latch(pmod_latch),
      .data_reg(gamepad_pmod_data)
  );

  gamepad_pmod_decoder decoder (
      .data_reg(gamepad_pmod_data),
      .b(b),
      .y(y),
      .select(select),
      .start(start),
      .up(up),
      .down(down),
      .left(left),
      .right(right),
      .a(a),
      .x(x),
      .l(l),
      .r(r),
      .is_present(is_present)
  );

endmodule