module atm (input clk,
                     input rst,
                     input BTN3, BTN2, BTN1,
                     input [3:0] SW,
                     output reg [7:0] LED,                                     // LED[7] is the left most-LED
                     output reg [6:0] digit4, digit3, digit2, digit1  // digit4 is the left-most SSD
                    );
  
	 reg [3:0] password;
    reg [15:0] balance; 
	 reg [3:0] current_state;
	 reg [3:0] next_state;
	 reg start_timer, start_timer1;
    wire time_up, time_up1;
	 
	 parameter [3:0] IDLE = 4'b0000;
	 parameter [3:0] PASS_ENT_3 = 4'b0001;
	 parameter [3:0] PASS_ENT_2 = 4'b0010;
	 parameter [3:0] PASS_ENT_1 = 4'b0011;
	 parameter [3:0] LOCK = 4'b0100;
	 parameter [3:0] ATM_MENU = 4'b0101;
	 parameter [3:0] MONEY = 4'b0110;
	 parameter [3:0] WARNING = 4'b0111;
	 parameter [3:0] PASS_CHG_3 = 4'b1000;
	 parameter [3:0] PASS_CHG_2 = 4'b1001;
	 parameter [3:0] PASS_CHG_1 = 4'b1010;
	 parameter [3:0] PASS_NEW = 4'b1011;
			// additional registers

	always @ (posedge clk or posedge rst)
	begin
		if(rst)
			begin
			current_state <= IDLE;
			end
		else 
			current_state <= next_state;
	end
	
	// sequential part - state transitions
	always @ (posedge clk or posedge rst)
	begin
		
	end

	// combinational part - next state definitions
	always @ (*)
	begin
		if(rst)
			next_state = IDLE;
		else
		begin
		case(current_state)
			IDLE: 
			if(BTN3 == 1) 
				next_state = PASS_ENT_3;
			else
				next_state = IDLE;
				
			PASS_ENT_3: 
			if(BTN1 == 1 && BTN3 == 0)
				next_state = IDLE;
			else if(BTN1 == 0 && BTN3 == 1 && SW == password)
				next_state = ATM_MENU;
			else if(BTN1 == 0 && BTN3 == 1 && SW != password)
				next_state = PASS_ENT_2;
			else
				next_state = PASS_ENT_3;
			
			PASS_ENT_2:
			if(BTN1 == 1 && BTN3 == 0)
				next_state = IDLE;
			else if(BTN1 == 0 && BTN3 == 1 && SW != password)
				next_state = PASS_ENT_1;
			else if(BTN1 == 0 && BTN3 == 1 && SW == password)
				next_state = ATM_MENU;
			else
				next_state = PASS_ENT_2;
				
			PASS_ENT_1:
			if(BTN1 ==  1 && BTN3 == 0)
				next_state = IDLE;
			else if(BTN1 == 0 && BTN3 == 1 && SW != password)
				next_state = LOCK;
			else if(BTN1 == 0 && BTN3 == 1 && SW == password)
				next_state = ATM_MENU;
			else
				next_state = PASS_ENT_1;
			
			LOCK:
				if(time_up == 1)
					next_state = IDLE;
				else
					next_state = LOCK;
					
			ATM_MENU:
				if(BTN1 == 1 && BTN2 == 0 && BTN3 == 0)
					next_state = IDLE;
				else if(BTN1 == 0 && BTN2 == 1 && BTN3 == 0)
					next_state = PASS_CHG_3;
				else if(BTN1 == 0 && BTN2 == 0 && BTN3 == 1)
					next_state = MONEY;
				else
					next_state = ATM_MENU;
			MONEY:
				if(BTN1 == 1 && BTN2 == 0 && BTN3 == 0)
					next_state = ATM_MENU;
				else if(BTN1 == 0 && BTN2 == 0 && BTN3 == 1)
					begin
					//balance = balance + SW;
					next_state = MONEY;
					end
				else if(BTN1 == 0 && BTN2 == 1 && BTN3 == 0)
					begin
					if(balance < SW)
						next_state = WARNING;
					else
						begin
						next_state = MONEY;
						end
					end
				else
					next_state = MONEY;
        
		  WARNING:
			if(time_up1 == 1)
				next_state = MONEY;
			else
				next_state = WARNING;
				
			PASS_CHG_3:
			if(BTN1 == 1 && BTN3 == 0)
				next_state = ATM_MENU;
			else if(BTN1 == 0 && BTN3 == 1 && password != SW)
				next_state = PASS_CHG_2;
			else if(BTN1 == 0 && BTN3 == 1 && password == SW)
				next_state = PASS_NEW;
			else
				next_state = PASS_CHG_3;
				
			PASS_CHG_2:
			if(BTN1 == 1 && BTN3 == 0)
				next_state = ATM_MENU;
			else if(BTN1 == 0 && BTN3 == 1 && password != SW)
				next_state = PASS_CHG_1;
			else if(BTN1 == 0 && BTN3 == 1 && password == SW)
				next_state = PASS_NEW;
			else
				next_state = PASS_CHG_2;
				
			PASS_CHG_1:
			if(BTN1 == 1 && BTN3 == 0)
				next_state = ATM_MENU;
			else if(BTN1 == 0 && BTN3 == 1 && password != SW)
				next_state = LOCK;
			else if(BTN1 == 0 && BTN3 == 1 && password == SW)
				next_state = PASS_NEW;
			else
				next_state = PASS_CHG_1;
				
			PASS_NEW:
			if(BTN3 == 1)
				begin
					next_state = ATM_MENU;
				end
			else
				next_state = PASS_NEW;
										
		endcase
		end
	end
	
	// sequential part - control registers
	always @ (posedge clk or posedge rst)
	begin
			// your code goes here	
	end 	
	
	

// combinational - outputs
	always @ (posedge clk or posedge rst)
	begin
	if(rst)
		LED <= 8'b00000000;
	else
		begin
			case(current_state)
			IDLE:
				begin
				LED <= 8'b00000001;
				digit4 <= 7'b0110001;
				digit3 <= 7'b0001000;
				digit2 <= 7'b0111001;
				digit1 <= 7'b1000010;
				end
			PASS_ENT_3:
				begin
				LED <= 8'b10000000;
				digit4 <= 7'b0011000;
				digit3 <= 7'b0110000;
				digit2 <= 7'b1111110;
				digit1 <= 7'b0000110;
				end
			PASS_ENT_2:
				begin
				LED <= 8'b11000000;
				digit4 <= 7'b0011000;
				digit3 <= 7'b0110000;
				digit2 <= 7'b1111110;
				digit1 <= 7'b0010010;
				end
			PASS_ENT_1:
				begin
				LED <= 8'b11100000;
				digit4 <= 7'b0011000;
				digit3 <= 7'b0110000;
				digit2 <= 7'b1111110;
				digit1 <= 7'b1001111;
				end
			LOCK:
				begin
				LED <= 8'b11111111;
				digit4 <= 7'b0111000;
				digit3 <= 7'b0001000;
				digit2 <= 7'b1001111;
				digit1 <= 7'b1110001;
				end
			ATM_MENU:
				begin
				LED <= 8'b00010000;
				digit4 <= 7'b0000001;
				digit3 <= 7'b0011000;
				digit2 <= 7'b0110000;
				digit1 <= 7'b1101010;
				end
			MONEY:
				begin
				LED <= 8'b00001000;
				if(balance[3:0]==4'b0000)
				digit1<=7'b0000001;
				else if(balance[3:0]==4'b0001)
				digit1<=7'b1001111;
				else if(balance[3:0]==4'b0010)
				digit1<=7'b0010010;
				else if(balance[3:0]==4'b0011)
				digit1<=7'b0000110;
				else if(balance[3:0]==4'b0100)
				digit1<=7'b1001100;
				else if(balance[3:0]==4'b0101)
				digit1<=7'b0100100;
				else if(balance[3:0]==4'b0110)
				digit1<=7'b0100000;
				else if(balance[3:0]==4'b0111)
				digit1<=7'b0001111;
				else if(balance[3:0]==4'b1000)
				digit1<=7'b0000000;
				else if(balance[3:0]==4'b1001)
				digit1<=7'b0000100;
				else if(balance[3:0]==4'b1010)
				digit1<=7'b0001000;
				else if(balance[3:0]==4'b1011)
				digit1<=7'b1100000;
				else if(balance[3:0]==4'b1100)
				digit1<=7'b0110001;
				else if(balance[3:0]==4'b1101)
				digit1<=7'b0000010;
				else if(balance[3:0]==4'b1110)
				digit1<=7'b0110000;
				else if(balance[3:0]==4'b1111)
				digit1<=7'b0111000;
				
				if(balance[7:4]==4'b0000)
				digit2<=7'b0000001;
				else if(balance[7:4]==4'b0001)
				digit2<=7'b1001111;
				else if(balance[7:4]==4'b0010)
				digit2<=7'b0010010;
				else if(balance[7:4]==4'b0011)
				digit2<=7'b0000110;
				else if(balance[7:4]==4'b0100)
				digit2<=7'b1001100;
				else if(balance[7:4]==4'b0101)
				digit2<=7'b0100100;
				else if(balance[7:4]==4'b0110)
				digit2<=7'b0100000;
				else if(balance[7:4]==4'b0111)
				digit2<=7'b0001111;
				else if(balance[7:4]==4'b1000)
				digit2<=7'b0000000;
				else if(balance[7:4]==4'b1001)
				digit2<=7'b0000100;
				else if(balance[7:4]==4'b1010)
				digit2<=7'b0001000;
				else if(balance[7:4]==4'b1011)
				digit2<=7'b1100000;
				else if(balance[7:4]==4'b1100)
				digit2<=7'b0110001;
				else if(balance[7:4]==4'b1101)
				digit2<=7'b0000010;
				else if(balance[7:4]==4'b1110)
				digit2<=7'b0110000;
				else if(balance[7:4]==4'b1111)
				digit2<=7'b0111000;
				
				if(balance[11:8]==4'b0000)
				digit3<=7'b0000001;
				else if(balance[11:8]==4'b0001)
				digit3<=7'b1001111;
				else if(balance[11:8]==4'b0010)
				digit3<=7'b0010010;
				else if(balance[11:8]==4'b0011)
				digit3<=7'b0000110;
				else if(balance[11:8]==4'b0100)
				digit3<=7'b1001100;
				else if(balance[11:8]==4'b0101)
				digit3<=7'b0100100;
				else if(balance[11:8]==4'b0110)
				digit3<=7'b0100000;
				else if(balance[11:8]==4'b0111)
				digit3<=7'b0001111;
				else if(balance[11:8]==4'b1000)
				digit3<=7'b0000000;
				else if(balance[11:8]==4'b1001)
				digit3<=7'b0000100;
				else if(balance[11:8]==4'b1010)
				digit3<=7'b0001000;
				else if(balance[11:8]==4'b1011)
				digit3<=7'b1100000;
				else if(balance[11:8]==4'b1100)
				digit3<=7'b0110001;
				else if(balance[11:8]==4'b1101)
				digit3<=7'b0000010;
				else if(balance[11:8]==4'b1110)
				digit3<=7'b0110000;
				else if(balance[11:8]==4'b1111)
				digit3<=7'b0111000;
				
				if(balance[15:12]==4'b0000)
				digit4<=7'b0000001;
				else if(balance[15:12]==4'b0001)
				digit4<=7'b1001111;
				else if(balance[15:12]==4'b0010)
				digit4<=7'b0010010;
				else if(balance[15:12]==4'b0011)
				digit4<=7'b0000110;
				else if(balance[15:12]==4'b0100)
				digit4<=7'b1001100;
				else if(balance[15:12]==4'b0101)
				digit4<=7'b0100100;
				else if(balance[15:12]==4'b0110)
				digit4<=7'b0100000;
				else if(balance[15:12]==4'b0111)
				digit4<=7'b0001111;
				else if(balance[15:12]==4'b1000)
				digit4<=7'b0000000;
				else if(balance[15:12]==4'b1001)
				digit4<=7'b0000100;
				else if(balance[15:12]==4'b1010)
				digit4<=7'b0001000;
				else if(balance[15:12]==4'b1011)
				digit4<=7'b1100000;
				else if(balance[15:12]==4'b1100)
				digit4<=7'b0110001;
				else if(balance[15:12]==4'b1101)
				digit4<=7'b0000010;
				else if(balance[15:12]==4'b1110)
				digit4<=7'b0110000;
				else if(balance[15:12]==4'b1111)
				digit4<=7'b0111000;
				end
			WARNING:
				begin
				LED <= 8'b11111111;
				digit4 <= 7'b1111110;
				digit3 <= 7'b1101010;
				digit2 <= 7'b0001000;
				digit1 <= 7'b1111110;
				end				
			PASS_CHG_3:
				begin
				LED <= 8'b00000100;
				digit4 <= 7'b0011000;
				digit3 <= 7'b0110001;
				digit2 <= 7'b1111110;
				digit1 <= 7'b0000110;
				end
			PASS_CHG_2:
				begin
				LED <= 8'b00000110;
				digit4 <= 7'b0011000;
				digit3 <= 7'b0110001;
				digit2 <= 7'b1111110;
				digit1 <= 7'b0010010;
				end
			PASS_CHG_1:
				begin
				LED <= 8'b00000111;
				digit4 <= 7'b0011000;
				digit3 <= 7'b0110001;
				digit2 <= 7'b1111110;
				digit1 <= 7'b1001111;
				end
			PASS_NEW:
				begin
				LED <= 8'b00000010;
				digit4 <= 7'b0011000;
				digit3 <= 7'b0001000;
				digit2 <= 7'b0100100;
				digit1 <= 7'b0100100;
				end
		endcase
		end
	end

		// additional always statements

 always @ (posedge clk or posedge rst)
 begin 
	if(rst)
		begin
		start_timer <= 0;
		balance <= 0;
		password <= 0;
		end
	else
		begin
		if(current_state == LOCK)
			start_timer <= 1;
		else
			start_timer <= 0;
		if(current_state == MONEY && BTN1 == 0 && BTN2 == 0 && BTN3 == 1)
			balance <= balance + SW;
		if(current_state == MONEY && BTN1 == 0 && BTN2 == 1 && BTN3 == 0 && balance >= SW)
			balance <= balance - SW;
		if(current_state == PASS_NEW && BTN3 == 1)
			password <= SW;
		end
 end
 
 always @ (posedge clk or posedge rst)
 begin 
	if(rst)
		start_timer1 <= 0;
	else
		begin
		if(current_state == WARNING)
			start_timer1 <= 1;
		else
			start_timer1 <= 0;
		end
 end

timer timeup(clk,rst,start_timer,time_up);
timer1 timeup1(clk,rst,start_timer1,time_up1);
endmodule


module timer(clk, rst, start_timer, time_up);

input clk,rst;
input start_timer;
output reg time_up;

reg [31:0] counter;

always @(posedge clk or posedge rst) begin
	if(rst) begin
		counter <= 0;
		time_up <= 0;
	end
	else begin
		if(start_timer) begin
			if(counter < 32'd50)
				counter <= counter + 1;
			else
				counter <= counter;
		end
		else begin
			counter <= 0;
		end
		
		time_up <= (counter == 32'd50);
		end
	end
endmodule

module timer1(clk, rst, start_timer1, time_up1);

input clk,rst;
input start_timer1;
output reg time_up1;

reg [31:0] counter;

always @(posedge clk or posedge rst) begin
	if(rst) begin
		counter <= 0;
		time_up1 <= 0;
	end
	else begin
		if(start_timer1) begin
			if(counter < 32'd25)
				counter <= counter + 1;
			else
				counter <= counter;
		end
		else begin
			counter <= 0;
		end
		
		time_up1 <= (counter == 32'd25);
		end
	end
endmodule