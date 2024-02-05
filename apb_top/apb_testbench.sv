//Define the testbench module
//mention timescale
`timescale 1ns/1ns
//include uvm macros file, interface of apb design and package
`include "uvm_macros.svh"
`include "apb_if.sv"
`include "apb_pkg.sv"
//import the uvm package and package file
import uvm_pkg::*;
import apb_pkg::*;
//include test file
`include "apb_test.sv"
 
module testbench;

  //control signals
	logic pclk;
	logic presetn; 
  //signals
	logic [31:0] paddr;
	logic        psel;
	logic        penable;
	logic        pwrite;
	logic [31:0] prdata;
	logic [31:0] pwdata;
  
  //initialize the clock and reset signals
	initial begin
		pclk=0;
	end
	
	initial begin
		presetn=1; 
		#40; 
		presetn=0;
	end	

	//Generate a clock
	always begin
		#10 pclk = ~pclk;
	end	
	
	// instantiate a physical interface foe apb interface
	apb_if  apb_if(pclk,presetn);
  
	initial begin
    //uvm configuration : set the interface instance as the virtual interface
		uvm_config_db#(virtual apb_if)::set( null, "", "apb_vif", apb_if);
		run_test("apb_test"); //include test class name
	end
	
endmodule // end of the module
