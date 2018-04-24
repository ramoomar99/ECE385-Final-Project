module player1(input frame_clk, Reset, Clk, press,
					input [7:0] keycode,
					input [9:0] DrawX, DrawY,
					output logic [9:0] p1x, p1y,
					output logic is_player,
					output logic [9:0] action, direction //1 is right, 0 is left. used to know whether or not to flip the sprite 
					);
					
					
parameter [9:0] px_center = 10'd280;
parameter [9:0] py_center = 10'd400;

parameter [9:0] px_min = 10'd0;       // Leftmost point on the X axis
parameter [9:0] px_max = 10'd639;     // Rightmost point on the X axis
parameter [9:0] py_min = 10'd1;       // Topmost point on the Y axis
parameter [9:0] py_max = 10'd479;     // Bottommost point on the Y axis
parameter [9:0] px_step = 10'd5;      // Step size on the X axis
parameter [9:0] py_step = 10'd5;      // Step size on the Y axis
parameter [9:0] Player_Width = 10'd60;        // Player Width
parameter [9:0] Player_Height = 10'd73;		//Player Height


/*
ACTION KEY
walking:
action = 0
action = 1
action = 9



*/



logic [9:0] px_pos, py_pos, px_mot, py_mot;
logic [9:0] px_pos_in, py_pos_in, px_mot_in, py_mot_in, dir_in, dir, act, act_in, counter;

//assign counter = 10'd0;



			//do we need this???
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end

	 always_ff @ (posedge Clk)
	 begin
		if(counter == 10'd60)
			counter <= 10'd0;
		else
			counter <= counter + 10'd1;
	 end
	 
	 
	 //reset control
	 always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
           px_pos <= px_center;
			  py_pos <= py_center; 
			  px_mot <= 10'd0;
			  py_mot <= 10'd0;
			  act <= 10'd9;
        end
        else
        begin
			  px_pos <= px_pos_in;
			  py_pos <= py_pos_in;
			  px_mot <= px_mot_in;
			  py_mot <= py_mot_in; 
			  p1x <= px_pos_in ;
			  p1y <= py_pos_in; 
			  dir <= dir_in;
			  direction <= dir_in;
			  action <= act_in;
			  act <= act_in;
			  //px_pos <= px_c;
			  //py_pos <= py_center; 
        end
    end
	 
	 always_comb
    begin
        // By default, keep motion and position unchanged
        px_pos_in = px_pos;
        py_pos_in = py_pos;
        px_mot_in = px_mot;
        py_mot_in = py_mot;
		  dir_in = dir;
		  act_in = act;
        
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
            // Be careful when using comparators with "logic" datatype because compiler treats 
            //   both sides of the operator as UNSIGNED numbers.
            // e.g. Ball_Y_Pos - Ball_Size <= Ball_Y_Min 
            // If Ball_Y_Pos is 0, then Ball_Y_Pos - Ball_Size will not be -4, but rather a large positive number.
				
				
				
				//update keypress
				//unique case(keycode[7:0])
				/*if(keycode == 8'h1d)			//w, up!!
				  begin
					px_mot_in = 10'd0;
					py_mot_in = (~(py_step) + 1'b1); //why + 1'b1?? Answer: 2's complmenet!
				  end*/
				  
				  //ARE WE DOING A CROUCH BUTTON?
				 //else if(keycode == 8'h16)			//s, Down!!
				  //begin
					//Ball_X_Motion_in = 10'd0;
					//Ball_Y_Motion_in = Ball_Y_Step;
				  //end
				  
				 if(keycode == 8'h1c && press == 1'b1)			//a, left!!
				  begin
				  //counter = counter + 10'd1;

				  if(act == 10'd9)
					act_in = 10'd0;
				  else if(act == 10'd0 && px_mot == (~(px_step) + 1'b1) && counter > 20)
					act_in = 10'd1;
				  else if(act == 10'd1 && px_mot == (~(px_step) + 1'b1) && counter > 40)
					act_in = 10'd9;
				  else
					act_in = act;
				  
					py_mot_in = 10'd0;
					px_mot_in = (~(px_step) + 1'b1);
					dir_in = 10'd0;
				  end
				 else if(keycode == 8'h23 && press == 1'b1)			//d, Right!!
				  begin
				  //counter = counter + 10'd1;
				  
				  if(act == 10'd9)
					act_in = 10'd0;
				  else if(act == 10'd0 && px_mot == px_step  && counter > 20)
					act_in = 10'd1;
				  else if(act == 10'd1 && px_mot == px_step && counter > 40)
					act_in = 10'd9;
				  else
					act_in = act;
				  
					py_mot_in = 10'd0;
					px_mot_in = px_step;
					dir_in = 10'd1;
					
				  end
				 else
				  begin
					/*if(py_mot_in == (~(py_step) + 1'b1)) //if the last motion was an up motion, the player must come back down (gravity)
						py_mot_in = py_step;
					else
						begin
						py_mot_in = 10'd0;
						end*/
					
					py_mot_in = 10'd0; //py_mot;	
					px_mot_in = 10'd0; //px_mot;
					dir_in = dir;
					act_in = 10'd9;
					
				  end
				
				
				
				
            if( py_pos + Player_Height >= py_max )  // person is at the bottom edge, stop y motion
				  begin
                py_mot_in = 10'd0;    
					 px_mot_in = 10'd0; 
				  end
				else if ( py_pos <= py_min )  // Player is at the top edge, go down
				  begin
                py_mot_in = py_step;
					 px_mot_in = 10'd0; //my addition
				  end
           
				//X boundary conditions 
				else if( px_pos + Player_Width >= px_max )  // Player is at the right edge, stop moving
				   begin
                px_mot_in = 10'd0;  
					 py_mot_in = 10'd0; 
					end
			   else if ( px_pos <= px_min )  // Ball is at the left edge, stop moving
				   begin
                px_mot_in = 10'd0;
					 py_mot_in = 10'd0; 
					end
					 
				
				 
        
            // Update the Players's position with its motion
            px_pos_in = px_pos + px_mot;
            py_pos_in = py_pos + py_mot;
				
        end
	  end
	  // Compute whether the pixel corresponds to Player or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int Width, Height;
    assign Width = Player_Width;
	 assign Height = Player_Height;
    always_comb begin
        if ( (DrawX >= px_pos) && (DrawX <= (px_pos + Width)) && (DrawY >= py_pos) && (DrawY <= py_pos + Height) ) 
            is_player = 1'b1;
        else
            is_player = 1'b0;
    end
	 
	 
endmodule
	 