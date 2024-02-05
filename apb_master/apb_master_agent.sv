//Define a apb master monitor class from uvm monitor
class apb_master_monitor extends uvm_monitor;
  
  //register the class with uvm factory
	`uvm_component_utils(apb_master_monitor)

  //declare a virtual interface instance 
	virtual apb_if vif;

  //analysis port : parameterized to apb_base_sequence item transaction
	uvm_analysis_port#(apb_base_seq_item) ap;	
	apb_base_seq_item tr;
		
//constructor
function new(string name, uvm_component parent);
  //call the base class constructor
	super.new(name, parent);
	ap = new("ap", this);
endfunction: new

//build phase - get handle to virtual interface 
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if (!uvm_config_db#(virtual apb_if)::get(this, "", "apb_vif", vif)) begin
		`uvm_fatal(get_full_name(), "No virtual interface specified for apb_master_driver")
	end 
		
endfunction

// Task: run_phase
task run_phase(uvm_phase phase);
	//forever loop to monitor signals and send transactions	
	forever begin
		wait (vif.master.PSEL === 1'b1);
		
		tr = apb_base_seq_item::type_id::create("tr", this);
    tr.apb_tr = (this.vif.master.PWRITE) ? apb_base_seq_item::WRITE : apb_base_seq_item::READ;
		tr.addr = this.vif.master.PADDR;
		
		@ (posedge vif.PCLK);
		wait (this.vif.master.PENABLE === 1'b1 && this.vif.master.PREADY === 1'b1);
		
		if(this.vif.master.PWRITE) 	
			tr.wdata = this.vif.master.PWDATA; 
		else 
			tr.rdata = this.vif.master.PRDATA;
		
		wait  (this.vif.master.PENABLE === 1'b0)
		uvm_report_info("APB_MASTER_MONITOR", $sformatf("%s",tr.apb_master()));		
		ap.write(tr); //Write to analysis port
		tr.print();

	end
endtask	

endclass // end of the class
