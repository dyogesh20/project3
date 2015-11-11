`timescale 1ns / 100ps
module alu #(
//**************************************************************
 //			parameter for selection of airthmatic operations
 //*************************************************************

		parameter 			TransferA		=	2'b00,		
		parameter 			AddC			=	2'b01,
		parameter 			Add				=	2'b10,
		parameter 			TransferB		=	2'b11,
		
//**************************************************************
 //			parameter for selection of logical operations
 //*************************************************************
 
		parameter 			And				=	2'b00,		
		parameter 			Or				=	2'b01,
		parameter 			Xor				=	2'b10,
		parameter 			ComplementA		=	2'b11,

//**************************************************************
 //			parameter for selection of shift operations
 //*************************************************************		
		
		parameter 			TransferA		=	2'b00,		
		parameter 			ShiftLeftA		=	2'b01,
		parameter 			ShiftLeftA		=	2'b10,
		parameter 			Transfer0s		=	2'b11


)(
 
 //*************************************************************
 //				intereference input and output
 //*************************************************************
		
		input			[7:0]		A,							//input A
		input      		[7:0]		B,							//input B
		input      		[4:0]		Sel,						//sel input for selection of operation
		input      					clk,						//clock input for alu
		input      					CarryIn,					//carry input
		output     		[7:0]		Y							//output Y of alu
);

always @(posedge clk) begin

		if (Sel[2] == 1'b1) begin
		
				case(Sel[1:0])
				
						TransferA	:		Y	<=	A;	
						AddC		:		Y	<=	A + B + CarryIn;	
						Add			:		Y	<=	A + B;	
						TransferB	:		Y	<=	B;	
						
				endcase
				
			
		end
		else begin
					
				case(Sel[1:0])
				
						And			:		Y	<=	A & B;	
						Or			:		Y	<=	A | B;
						Xor			:		Y	<=	A ^ B;
						ComplementA	:		Y	<=	~ A;
				
				endcase
		end
		
				case(Sel[4:3])
				
				 		TransferA	:		Y	<=	A;		
						ShiftLeftA	:		Y	<=	A << 1;	
						ShiftLeftA	:		Y	<=	A >> 1;	
						Transfer0s	:		Y	<=	8'h00;	
				
				
				endcase
		
end

endmodule