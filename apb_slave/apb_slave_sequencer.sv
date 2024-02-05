//Define apb_slave sequence
class apb_slave_sequencer extends uvm_sequencer#(apb_base_seq_item);
  
  //register the class with uvm factory
	`uvm_component_utils(apb_slave_sequencer)

  //constructor
	function new(string name = "apb_slave_sequencer", uvm_component parent = null);
    //call the base class constructorr
		super.new(name, parent);
    
	endfunction


endclass // end of the class
