//Define a uvm environment class named apb_env
import uvm_pkg::*;
`include "uvm_macros.svh" 
import apb_pkg::*;

class apb_env extends uvm_env;
  
  //register the class with uvm factory
	`uvm_component_utils(apb_env)

	//	Component Members
	apb_master_agent  master_agent;
	apb_slave_agent  slave_agent;
  apb_virtual_sequencer v_seqr;
  
  //virtual interface for apb interface
	virtual apb_if  vif;
  
  //constructor for the class
  function new(string name = "apb_env", uvm_component parent = null);
    //call the base class constructor
	  super.new(name, parent);
  endfunction
  
  //Build phase - construct agents, virtual sequencer and get virtual interface handle
  function void build_phase(uvm_phase phase);
	  super.build_phase(phase);
    //create an instance of the master agnet
  	master_agent = apb_master_agent::type_id::create("master_agent", this);
    v_seqr = apb_virtual_sequencer::type_id::create("v_seqr" , this);
    //create an instance of the slave agent
	  slave_agent  = apb_slave_agent::type_id::create("slave_agent", this);		
  	if (!uvm_config_db#(virtual apb_if)::get(null, "", "apb_vif", vif)) begin
		  `uvm_fatal(get_full_name(), "No virtual interface specified for env")
	  end		
  endfunction
  
  //connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    uvm_config_db#(apb_master_sequencer)::set(this,"*","master_seqr",master_agent.m_sequencer);
    uvm_config_db#(apb_slave_sequencer)::set(this,"*","slave_seqr",slave_agent.m_sequencer);
  endfunction
  
  //print topology
  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction
  
endclass  //end of the class
