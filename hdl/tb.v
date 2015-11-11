`timescale 1ns / 100ps

// tb.v - testbench for the Project 3 ALU
//
// Copyright Sarvesh H Kulkarni, 2015
// 
// Created By:		Sarvesh H Kulkarni
// Last Modified:	9-May-2015 (SHK)
//
// Revision History:
// -----------------
// May-2015		SHK		Created this module for ECE 540, Spring 2015
//
// Description:
// ------------
// This module is to be used as the testbench for validating functionality of your Project 3 behavioral code through behavioral simulation.
// This testbench instantiates the ALU module that needs to be tested. The instantiation module name on Line 55 is the only item that you should need to edit in this file.
// Deliverables should include the alutest.out file (generated by this testbench) showing a failing vector count of 0.
// The output of your ALU is compared against the expected output and a count of the failing vectors is kept. The test vector generation is randomized using the Verilog $random function.
// The expected output is generated by forwarding the inputs to a combinational implementation of the ALU's truth table.
//   
///////////////////////////////////////////////////////////////////////////

module p3test;

reg clk;
reg [7:0] A, A_pp1, A_pp2, A_pp3;
reg [7:0] B, B_pp1, B_pp2, B_pp3;
reg CarryIn, CarryIn_pp1, CarryIn_pp2, CarryIn_pp3;
reg [4:0] Sel, Sel_pp1, Sel_pp2, Sel_pp3;
reg [7:0] Y_expect;
wire [7:0] Y;
integer i, r_seed, pass_count, fail_count;
integer fhandle;
reg [31:0] random_number, random_number_legalized;

initial
  begin
    clk = 1'h0;
    A = 8'h00;
    B = 8'h00;
    CarryIn = 1'h0;
    Sel = 5'h0;
    i = 0;
    r_seed = 2;                      // Seed used by $random to generate random vectors to test the ALU.
    pass_count = 0;
    fail_count = 0;
    fhandle = $fopen("alutest.out"); // File handle to redirect the output to file alutest.out.
  end

// The 200MHz clock
always #2.5 clk = ~clk;

// Instantiate your module under test. Update the module name with your chosen name.
alu ialu (
  .A(A),
  .B(B),
  .Sel(Sel),
  .clk(clk),
  .CarryIn(CarryIn),
  .Y(Y)
);

// Compare your ALU's output with the expected output and log the result to alutest.out
always @ (posedge clk)
  begin
    #1;
    if(Y === Y_expect)
      begin
        $fdisplay (fhandle, "time = %t A = %b B = %b CarryIn = %b Sel = %b Y = %b Y_EXPECTED = %b >> PASS\n", $realtime, A_pp3, B_pp3, CarryIn_pp3, Sel_pp3, Y, Y_expect);
        pass_count <= pass_count + 1;
      end
    else
      begin
        $fdisplay (fhandle, "time = %t A = %b B = %b CarryIn = %b Sel = %b Y = %b Y_EXPECTED = %b >> FAIL\n", $realtime, A_pp3, B_pp3, CarryIn_pp3, Sel_pp3, Y, Y_expect);
        fail_count <= fail_count + 1;
      end
  end

// Generate the expected output which is used to validate the actual output from your ALU.
// This logic creates a second pipeline running parallel to your ALU and models the ALU truth table in a combinational block.
always @ (posedge clk)
  begin
    A_pp1 <= A;
    A_pp2 <= A_pp1;
    A_pp3 <= A_pp2;
    B_pp1 <= B;
    B_pp2 <= B_pp1;
    B_pp3 <= B_pp2;
    CarryIn_pp1 <= CarryIn;
    CarryIn_pp2 <= CarryIn_pp1;
    CarryIn_pp3 <= CarryIn_pp2;
    Sel_pp1 <= Sel;
    Sel_pp2 <= Sel_pp1;
    Sel_pp3 <= Sel_pp2;
  end

// Combinational model of the ALU.
always @ (A_pp3 or B_pp3 or CarryIn_pp3 or Sel_pp3)
  begin
    case (Sel_pp3)
    5'b00000 : Y_expect = A_pp3;
    5'b00001 : Y_expect = A_pp3 + B_pp3 + CarryIn_pp3;
    5'b00010 : Y_expect = A_pp3 + B_pp3;
    5'b00011 : Y_expect = B_pp3;
    5'b00100 : Y_expect = A_pp3 & B_pp3;
    5'b00101 : Y_expect = A_pp3 | B_pp3;
    5'b00110 : Y_expect = A_pp3 ^ B_pp3;
    5'b00111 : Y_expect = ~A_pp3;
    5'b01000 : Y_expect = A_pp3 << 1;
    5'b10000 : Y_expect = A_pp3 >> 1;
    5'b11000 : Y_expect = 8'h0;
    default: Y_expect = 8'bxxxxxxxx;
    endcase
  end

// This logic uses the $random function in Verilog to generate test vectors for your ALU.
initial
  begin
    #17 Sel = 5'h0; B = 8'h00; CarryIn = 1'h0;
    for(i = 0; i <= 99; i = i + 1)
      begin
        random_number = $random(r_seed);
        #5 {A, B, CarryIn, Sel} = {random_number_legalized[31:24], random_number_legalized[23:16], random_number_legalized[8], random_number_legalized[4:0]};
      end
    #15;
    $fdisplay (fhandle, "*** SUMMARY: Count of vectors failing = %d\n", fail_count);
    $stop;
   end

// Map illegal instruction codes returned by $random to all 0.
always @ (random_number)
  begin
    random_number_legalized[31:5] = random_number[31:5];
    case(random_number[4:0])
    5'b01001 : random_number_legalized[4:0] = 5'b0;
    5'b01010 : random_number_legalized[4:0] = 5'b0;
    5'b01011 : random_number_legalized[4:0] = 5'b0;
    5'b01100 : random_number_legalized[4:0] = 5'b0;
    5'b01101 : random_number_legalized[4:0] = 5'b0;
    5'b01110 : random_number_legalized[4:0] = 5'b0;
    5'b01111 : random_number_legalized[4:0] = 5'b0;
    5'b10001 : random_number_legalized[4:0] = 5'b0;
    5'b10010 : random_number_legalized[4:0] = 5'b0;
    5'b10011 : random_number_legalized[4:0] = 5'b0;
    5'b10100 : random_number_legalized[4:0] = 5'b0;
    5'b10101 : random_number_legalized[4:0] = 5'b0;
    5'b10110 : random_number_legalized[4:0] = 5'b0;
    5'b10111 : random_number_legalized[4:0] = 5'b0;
    5'b11001 : random_number_legalized[4:0] = 5'b0;
    5'b11010 : random_number_legalized[4:0] = 5'b0;
    5'b11011 : random_number_legalized[4:0] = 5'b0;
    5'b11100 : random_number_legalized[4:0] = 5'b0;
    5'b11101 : random_number_legalized[4:0] = 5'b0;
    5'b11110 : random_number_legalized[4:0] = 5'b0;
    5'b11111 : random_number_legalized[4:0] = 5'b0;
    default : random_number_legalized[4:0] = random_number[4:0];
    endcase
  end

endmodule