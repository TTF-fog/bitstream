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

  localparam [7:0] Circle[0:7] = '{
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
  
  reg  [8:0] state = 9'b000000000;
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
 genvar c;
generate
  for (c = 0; c < 11; c = c+1) begin : BUTTON_POPULATE
    assign btn_pressed[c] = btn_in[c] & ~last_btn[c];
  end
endgenerate

  reg turn = 1'b0;
  
  wire turn_t, turn_u, turn_r, turn_n, turn_colon, current_item;
  assign turn_t = glyph_active(30, 455, T, 3);
  assign turn_u = glyph_active(60, 455, U, 3);
  assign turn_r = glyph_active(90, 455, R_letter, 3);
  assign turn_n = glyph_active(120, 455, N, 3);
  assign turn_colon = glyph_active(150, 455, Colon, 3);
  assign current_item = glyph_active(180, 455, turn ? Circle : Cross, 3);
  
  wire [8:0] cell_active;
  localparam CELL_SIZE = 80;   
  localparam CELL_SPACING = 250; 
  localparam CELL_SPACING_Y = 180; 
  localparam GRID_ORIGIN_X = 30;
  localparam GRID_ORIGIN_Y = 30;
  wire [3:0] sel_index = high_index(selected);
  
  genvar i;
  generate
  for (i=0; i<9; i=i+1) begin : CELL_DRAW
    localparam integer row = i / 3;
    localparam integer col = i % 3;
    wire glyph_on;
    assign glyph_on = glyph_active(
        GRID_ORIGIN_X + col*CELL_SPACING,
        GRID_ORIGIN_Y + row*CELL_SPACING_Y,
        state[i] ? (placed[i] ? Circle : Cross) : Blank, 10
    );
    assign cell_active[i] = glyph_on;
  end
endgenerate

genvar a;
  generate
  for (a=0; a<9; a=a+1) begin : SEL_DRAW
    localparam integer row = a / 3;
    localparam integer col = a % 3;
    wire glyph_on;
    assign glyph_on = glyph_active(
        GRID_ORIGIN_X + col*CELL_SPACING - 20,
        GRID_ORIGIN_Y + row*CELL_SPACING_Y - 20,
        selected[a] ? Sel : Blank, 15
    );
    assign sel_active[a] = glyph_on;  
  end
endgenerate

always @(posedge clk) begin
  R <= 2'b00;
  G <= 2'b00;
  B <= 2'b00;

  if (video_active) begin
    R <= 2'b11;
    G <= 2'b00;
    B <= 2'b00;
   
   if (|cell_active) begin
        {R,G,B} <= 6'b111111;
        end
       
    if ( (pix_y >= 330 && pix_y <= 340) || (pix_y >= 450) ||
         (pix_x >= 480 && pix_x <= 500) ||           
         (pix_x >= (639-500) && pix_x <= (639-480)) ||
         (pix_y >= (479-340) && pix_y <= (479-330)) ) 
    begin
      R <= 2'b00;
      G <= 2'b00;
      B <= 2'b11; 
    end
    /*
    7 = uparrow
    4 = rightarrow
    1 = Left Trigger
    0 = Right Trigger
    3 = A
    11 = Unknown
    10 = Y
    */
    //scroll around the grid
    if (btn_pressed[9]) begin //left arrow
      selected <= {selected[0], selected[8:1]};
    end
    
     if (|sel_active) begin
        G <= 2'b11;
        end
        
     if (turn_t || turn_u || turn_r || turn_n || turn_colon || current_item) begin
      {R, G, B} <= 6'b111111;
    end

      if (btn_pressed[3]) begin //A
        if (!state[sel_index]) begin
          state[sel_index] <= 1'b1;
          placed[sel_index] <= turn ? 1'b1 : 1'b0;
          turn <= !turn;
        end
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