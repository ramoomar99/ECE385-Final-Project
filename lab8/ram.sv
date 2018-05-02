/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  frameROM
(

		input [18:0] read_address1, read_address2, start_address, pipe_address,
		input Clk,
		output logic [3:0] start_data, pipe_data,
		output logic [23:0] data_Out1, data_Out2
);

// mem has width of 24 bits and a total of 4980 addresses
logic [23:0] stick_figure [0:75599];
logic [3:0] start_screen [0:307199];
logic [3:0] pipe [0:7649];

initial
begin
	 $readmemh("Sprites/stick_figure_sprite.txt", stick_figure);
	 $readmemh("Sprites/Start_Screen.txt", start_screen);
	 $readmemh("Sprites/pipe.txt", pipe);
end


always_ff @ (posedge Clk) 
begin
	data_Out1 <= stick_figure[read_address1];
	data_Out2 <= stick_figure[read_address2];
	start_data <= start_screen[start_address];
	pipe_data <= pipe[pipe_address];
end

endmodule
