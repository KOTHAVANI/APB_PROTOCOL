//apb_master configuration classs	
class apb_master_config extends uvm_object;
  
  //register the class with uvm factory
	`uvm_object_utils(apb_master_config)
	uvm_active_passive_enum is_active = UVM_ACTIVE;
	
  //constructor
  function new (string name = "apb_master_config");
    //call the base class constructor
	  super.new(name);
  endfunction	

endclass // end of the class
