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
		
	//	parameter 			TransferA		=	2'b00,		
		parameter 			ShiftLeftA		=	2'b01,
		parameter 			ShiftRightA		=	2'b10,
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
		output   reg	[7:0]		Y							//output Y of alu
);



 //*************************************************************
 //				regiter declaration for synchronization
 //*************************************************************
 
		reg				[7:0]		Asynch1,Asynch2,Asynch3;
		reg				[7:0]		Bsynch1,Bsynch2,Bsynch3;
		reg							CarryInsynch1,CarryInsynch2,CarryInsynch3;
		reg				[4:0]		Selsynch1,Selsynch2,Selsynch3;
		
 
 
 
 
  //*************************************************************
 //				synchronizer 
 //*************************************************************

always @(posedge clk) begin

					Asynch1	<=	A;
					Asynch2	<=	Asynch1;
					//Asynch3	<=	Asynch2;
					
					Bsynch1	<=	B;
					Bsynch2	<=	Bsynch1;
					//Bsynch3	<=	Bsynch2;
					
					Selsynch1	<=	Sel;
					Selsynch2	<=	Selsynch1;
					//Selsynch3	<=	Selsynch2;
					
					CarryInsynch1	<=	CarryIn;
					CarryInsynch2	<=	CarryInsynch1;
					//CarryInsynch3	<=	CarryInsynch2;
end


 //*************************************************************
 //				ALU Operation
 //*************************************************************
always @(posedge clk) begin

		case(Selsynch2[4:3])
				
				TransferA	:	begin
		
						if (Selsynch2[2] == 1'b1) begin
		
									case(Selsynch2[1:0])
				
										TransferA	:		Y	<=	Asynch2;	
										AddC		:		Y	<=	Asynch2 + Bsynch2 + CarryInsynch2;	
										Add			:		Y	<=	Asynch2 + Bsynch2;	
										TransferB	:		Y	<=	Bsynch2;	
										default		:		Y	<=  8'hxx;
						
									endcase
				
			
						end
						else begin
					
									case(Selsynch2[1:0])
				
										And			:		Y	<=	Asynch2 & Bsynch2;	
										Or			:		Y	<=	Asynch2 | Bsynch2;
										Xor			:		Y	<=	Asynch2 ^ Bsynch2;
										ComplementA	:		Y	<=	~ Asynch3;
										default		:		Y	<=  8'hxx;
				
									endcase
						end
		
				
					end
				 			
				ShiftLeftA	:		Y	<=	Asynch2 << 1;	
				ShiftRightA	:		Y	<=	Asynch2 >> 1;	
				Transfer0s	:		Y	<=	8'h00;
				default		:		Y	<=  8'hxx;
				
				
				endcase
		
end

endmodule