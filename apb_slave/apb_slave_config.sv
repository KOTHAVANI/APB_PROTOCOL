	//apb_slave_configuration_class
class apb_slave_config extends uvm_object;

  //reister the class with uvm factory
	`uvm_object_utils(apb_slave_config)
	
	//	Data Members
  uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  //constructor
  function new (string name = "apb_slave_config");
	  super.new(name);
  endfunction	

endclass // end of the class
