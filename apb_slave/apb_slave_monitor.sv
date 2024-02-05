//Define a apb slave monitor class from uvm monitor
class apb_slave_monitor extends uvm_monitor;

  //register the class with uvm factory
	`uvm_component_utils(apb_slave_monitor)

  //declare a virtual interface instance   
	virtual apb_if vif;

  //analysis port : parameterized to apb_base_sequence item 
	uvm_analysis_port#(apb_base_seq_item) ap;
	
//constructor
function new(string name, uvm_component parent);
	super.new(name, parent);
	ap = new("ap", this);
endfunction

//build phase - get handle to virtual interface 
function void build_phase(uvm_phase phase);
	super.build_phase(phase);		
	if (!uvm_config_db#(virtual apb_if)::get(this, "", "apb_vif", vif)) begin
		`uvm_fatal(get_full_name(), "No virtual interface specified for apb_slave_driver")
	end 
endfunction

//task : run phase
task run_phase(uvm_phase phase);
		
	forever begin
		apb_base_seq_item tr;
	
		wait (vif.master.PSEL === 1'b1);
		
		tr = apb_base_seq_item::type_id::create("tr", this);
    tr.apb_tr = (this.vif.master.PWRITE) ? apb_base_seq_item::WRITE : apb_base_seq_item::READ;
		tr.addr = this.vif.master.PADDR;

		@ (posedge vif.PCLK);
		wait (this.vif.master.PENABLE === 1'b1 && this.vif.slave.PREADY === 1'b1);
			
		if(this.vif.master.PWRITE)
			tr.wdata = this.vif.master.PWDATA; 
		else 
			tr.rdata = this.vif.master.PRDATA;			
			
		wait  (this.vif.slave.PENABLE === 1'b0)
		uvm_report_info("APB_SLAVE_MONITOR", $sformatf("%s",tr.apb_slave()));
		ap.write(tr); // write to analysis port
    tr.print();

	end
endtask	

endclass // end of the class
