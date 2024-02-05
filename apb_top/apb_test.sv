//Top level test class that instanties environment , configurations and start stimulus
import uvm_pkg::*;
`include "uvm_macros.svh"
import apb_pkg::*;
`include "apb_env.sv"

class apb_test extends uvm_test;

	//Register with factory
	`uvm_component_utils(apb_test)
  
  //instance for environment class
	apb_env  env;	
	// configuration object
	apb_master_config 	m_apb_master_config;
	apb_slave_config 	m_apb_slave_config;
	
	virtual apb_if vif;
		
	apb_master_seq master_seq;
	apb_slave_seq  slave_seq;	
  
  //constructor for the class
  function new(string name = "apb_test", uvm_component parent = null);
  //call the base class constructor
	  super.new(name, parent);
  endfunction
  
  //Build phase - Construct the cfg and env class using factory
  //Get the virtual interface handle from Test and then set it config db for the env component
  function void build_phase(uvm_phase phase);
	  super.build_phase(phase);
    env = apb_env::type_id::create("env", this);	
	  m_apb_master_config = apb_master_config::type_id::create("m_apb_master_config"); 		
	  m_apb_slave_config  = apb_slave_config::type_id::create("m_apb_slave_config"); 		
		
	  uvm_config_db#(apb_master_config)::set(null, "","apb_master_config", m_apb_master_config);
	  uvm_config_db#(apb_slave_config)::set(null, "" ,"apb_slave_config", m_apb_slave_config);
	
	  if (!uvm_config_db#(virtual apb_if)::get(this, "", "apb_vif", vif)) begin
		  `uvm_fatal(get_full_name(), "No virtual interface specified for this test instance")
	  end 
  endfunction
  
  //run phase - create master & slave sequences and start  
  task run_phase( uvm_phase phase );
	  super.run_phase(phase);
	  //create an instances for the master and slave sequences
	  master_seq = apb_master_seq::type_id::create("master_seq");
	  slave_seq = apb_slave_seq::type_id::create("slave_seq");
		//raise objection to keep the simulation running
	  phase.raise_objection( this, "Starting apb_test run phase" );
    //start the sequence on sequencer with in the agent
	  repeat(1) begin
		  fork
			  master_seq.start(env.master_agent.m_sequencer);
			  slave_seq.start(env.slave_agent.m_sequencer);	
		  join
	  end	
	  #100ns;
    //drop objection to allow the simulation to proceed
	  phase.drop_objection( this , "Finished apb_test in run phase" );
  endtask	

endclass // end of the class
