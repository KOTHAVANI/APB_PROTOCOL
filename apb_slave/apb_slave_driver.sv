//define uvm driver class named apb_slave_driver

class apb_slave_driver extends uvm_driver#(apb_base_seq_item);
	//register the class with uvm factory
  `uvm_component_utils(apb_slave_driver)
  
  //declare a virtual interface instance
	virtual apb_if 			  vif;
  //handle for base sequence
	apb_base_seq_item 		s_apb_base_seq_item;
	
//constructor  
function new(string name = "apb_slave_driver", uvm_component parent = null);
  //call the base class constructor  
	super.new(name, parent);
endfunction	

//build phase : set up the virtual interface connection
function void build_phase(uvm_phase phase);
  //call the base class build phase
	super.build_phase(phase);
	if (!uvm_config_db#(virtual apb_if)::get(this, "", "apb_vif", vif)) begin
		`uvm_fatal(get_full_name(), "No virtual interface specified for apb_slave_driver")
	end 
endfunction

//run_phase	
task run_phase(uvm_phase phase);
	super.run_phase(phase);
	
	vif.slave.PREADY  <= 0;	//init_signals();
	wait(!vif.PRESET_N);	  //wait_for_reset();
	slave_get_drive();
			
endtask
	
task slave_get_drive();
//forever loop to handle incoming sequence items
	forever begin
		s_apb_base_seq_item = apb_base_seq_item::type_id::create("s_apb_base_seq_item",this);
    //get the next transaction item from sequence			
		seq_item_port.get_next_item(s_apb_base_seq_item);
		
		wait(vif.slave.PSEL)
		
		vif.slave.PREADY <= 1;
		
		repeat(s_apb_base_seq_item.delay)
			@(posedge vif.PCLK);		
		
		if(!vif.slave.PWRITE)
			vif.slave.PRDATA <= s_apb_base_seq_item.rdata;
      else
			vif.slave.PWDATA <= s_apb_base_seq_item.wdata;

		
		@ (posedge vif.PCLK);
		vif.slave.PREADY <= 0;	

		//handshake done back to the sequencer
		seq_item_port.item_done();
		//uvm_report_info("APB_SLAVE_DRIVER", $sformatf("%s",s_apb_base_seq_item.apb_slave()));
		`uvm_info("apb_slave_driver", "finish drive", UVM_LOW)
    //s_apb_base_seq_item.print();

	end				
endtask
	
endclass // end of the class
