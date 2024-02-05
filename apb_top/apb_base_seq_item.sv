//Define a uvm_sequence_item class named apb_base_seq_item
//apb_base_sequence_item derived from base uvm_sequence_item
`define ADDR_WIDTH 8               // APB PADDR BUS width           
`define DATA_WIDTH 8               // APB PWDATA and PRDATA Bus width

class apb_base_seq_item extends uvm_sequence_item;
     
	//typedef for Read/Write transaction type
  typedef enum {READ, WRITE} apb_transfer_direction_t;		
		
	//	Data Members	
	rand bit   [`ADDR_WIDTH-1:0] 	    addr;      //address
 	rand logic [`DATA_WIDTH-1:0] 	    wdata;     //data- for write response
 	rand logic [`DATA_WIDTH-1:0] 	    rdata;     //data- for read response
	rand int 					              	delay;     //delay
	randc apb_transfer_direction_t  	apb_tr;    //command type
	
	// constraints
	constraint c_addr { addr[1:0] == 0; }
	constraint c_delay { delay inside {[1:2]}; }
 
  //Register with uvm factory 
  `uvm_object_utils_begin(apb_base_seq_item)
    `uvm_field_int(delay, UVM_ALL_ON)
    `uvm_field_enum(apb_transfer_direction_t, apb_tr, UVM_ALL_ON)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(rdata, UVM_ALL_ON)
    `uvm_field_int(wdata, UVM_ALL_ON)
  `uvm_object_utils_end
    
  //constructor
  function new (string name = "apb_base_seq_item");
	  super.new(name);
  endfunction
  
  //print results for master transactions
  function string apb_master();
	  return $sformatf("APB_MASTER_TRANSFER : DIR=%s ADDR=%0h  WDATA=%0h RDATA=%0h",apb_tr,addr,wdata,rdata);
  endfunction

  //print for slave transactions
  function string apb_slave();
	  return $sformatf("APB_SLAVE_TRANSFER :  DIR=%s ADDR=%0h WDATA=%0h RDATA=%0h",apb_tr,addr,wdata,rdata);
  endfunction


endclass  //end of the class
