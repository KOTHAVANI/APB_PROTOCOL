//Define virtual sequencer 
class apb_virtual_sequencer extends uvm_sequencer;
  
  //register the class with uvm factory
  `uvm_component_utils(apb_virtual_sequencer)
  apb_master_sequencer m_seqr;
  apb_slave_sequencer  s_seqr;
  
  //constructor of the class
  function new(string name, uvm_component parent);
    //call the base class constructor
    super.new(name,parent);
  endfunction
  
  //end of elaboration phase
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    if (!uvm_config_db#(apb_master_sequencer)::get(this, "", "master_seqr", m_seqr))
        `uvm_fatal("VSQR/CFG/NOAHB", "No master sequencer specified for this instance");

    if (!uvm_config_db#(apb_slave_sequencer)::get(this, "", "slave_seqr", s_seqr))
        `uvm_fatal("VSQR/CFG/NOETH", "No slave sequencer specified for this instance");

 endfunction
 
endclass // end of the class
