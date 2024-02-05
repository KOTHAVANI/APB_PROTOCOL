//define  apb_slave_sequence class
class apb_slave_seq extends uvm_sequence#(apb_base_seq_item);
  
  //register the class with uvm factory
	`uvm_object_utils(apb_slave_seq)
	
  //constructor
  function new(string name ="apb_slave_seq");
	  super.new(name);
  endfunction
  
  //task for defing the sequence body
  task body();
    //declare an instance of the apb_base_sequence_item transaction
	  apb_base_seq_item s_apb_base_seq_item;
	  //create 10 random apb_slave_sequences of the apb_base_seq_item transaction
	  repeat(10) begin
      //create a new instance of the apb_base_seq_tem transaction
		  s_apb_base_seq_item = apb_base_seq_item::type_id::create("s_apb_base_seq_item");
		  /*start_item(s_apb_base_seq_item);          //start the transaction item
		  assert (s_apb_base_seq_item.randomize());   //randomize the transaction item
		  finish_item(s_apb_base_seq_item);*/         //finish the transaction item
      
      `uvm_do(s_apb_base_seq_item)
  	end
  endtask

endclass // end of the class
