//Define a uvm agent class named apb_slave agent
class apb_slave_agent extends uvm_agent;
  //register the class with uvm factory
	`uvm_component_utils(apb_slave_agent)

	
	// Configuration member
	apb_slave_config m_cfg;		
	
	//	Component Members
	apb_base_seq_item 							s_apb_base_seq_item;
	apb_slave_driver  							m_apb_slave_driver;
	apb_slave_seq								    m_apb_slave_seq;
	apb_slave_sequencer							m_sequencer;
	apb_slave_monitor							  m_apb_slave_monitor;
	
  //constrctor
  function new(string name = "apb_slave_agent", uvm_component parent);
    //call the base class constructor
	  super.new(name, parent);
  endfunction
  
  //build phase
  function void build_phase(uvm_phase phase);
	  super.build_phase(phase);
	
	  // get configuration object
	  if (m_cfg == null) begin
	  	if (!uvm_config_db#(apb_slave_config)::get(this, "", "apb_slave_config", m_cfg))
			  `uvm_warning(get_full_name(), "Config not set for slave agent, using default is_active field")
	    end	
	
	    s_apb_base_seq_item		= apb_base_seq_item::type_id::create("s_apb_base_seq_item");
    	m_apb_slave_seq				= apb_slave_seq::type_id::create("m_apb_slave_seq");	
    	m_apb_slave_monitor			= apb_slave_monitor::type_id::create("m_apb_slave_monitor",this);

	  if(m_cfg.is_active == UVM_ACTIVE) begin
		    m_apb_slave_driver		= apb_slave_driver::type_id::create("m_apb_slave_driver",this);
	    	m_sequencer 			= apb_slave_sequencer::type_id::create("m_sequencer",this); 
   	end	
	
  endfunction
  
  //connect driver and sequencer port to export
  function void connect_phase(uvm_phase phase);
	  super.connect_phase(phase);	
	  if(m_cfg.is_active == UVM_ACTIVE) begin
      //connect the driver to the sequencer
	  	m_apb_slave_driver.seq_item_port.connect(m_sequencer.seq_item_export);
	  end	
	
  endfunction	

endclass // end of the class
