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
					Asynch3	<=	Asynch2;
					
					Bsynch1	<=	B;
					Bsynch2	<=	Bsynch1;
					Bsynch3	<=	Bsynch2;
					
					Selsynch1	<=	Sel;
					Selsynch2	<=	Selsynch1;
					Selsynch3	<=	Selsynch2;
					
					CarryInsynch1	<=	CarryIn;
					CarryInsynch2	<=	CarryInsynch1;
					CarryInsynch3	<=	CarryInsynch2;
end


 //*************************************************************
 //				ALU Operation
 //*************************************************************
always @(Asynch3 or Bsynch3 or Selsynch3 or CarryInsynch3 ) begin

		case(Selsynch3[4:3])
				
				TransferA	:	begin
		
						if (Selsynch3[2] == 1'b1) begin
		
									case(Selsynch3[1:0])
				
										TransferA	:		Y	<=	Asynch3;	
										AddC		:		Y	<=	Asynch3 + Bsynch3 + CarryInsynch3;	
										Add			:		Y	<=	Asynch3 + Bsynch3;	
										TransferB	:		Y	<=	Bsynch3;	
										default		:		Y	<=  8'hxx;
						
									endcase
				
			
						end
						else begin
					
									case(Selsynch3[1:0])
				
										And			:		Y	<=	Asynch3 & Bsynch3;	
										Or			:		Y	<=	Asynch3 | Bsynch3;
										Xor			:		Y	<=	Asynch3 ^ Bsynch3;
										ComplementA	:		Y	<=	~ Asynch3;
										default		:		Y	<=  8'hxx;
				
									endcase
						end
		
				
					end
				 			
				ShiftLeftA	:		Y	<=	Asynch3 << 1;	
				ShiftRightA	:		Y	<=	Asynch3 >> 1;	
				Transfer0s	:		Y	<=	8'h00;
				default		:		Y	<=  8'hxx;
				
				
				endcase
		
end

endmodule