### APB Protocol Verification VIP

This GitHub repository focuses on the verification of the APB (Advanced Peripheral Bus) protocol, emphasizing master to slave read and write transfers without the Device Under Test (DUT). The verification environment utilizes the apb_if interface, featuring an address width of 8 and a data width of 8.


## Introduction

The advanced peripheral bus (APB) is part of the advanced microcontroller bus architecture AMBA protocol family. It defines a low-cost interface that is optimized for minimal power Consumption and reduced interface complexity. The APB protocol is not pipelined, use it to connect to low-bandwidth peripherals that do not Require the high performance of the AXI protocol. The APB protocol relates a signal transition to the rising edge of the clock, to simplify the Integration of APB peripherals into any design flow. Every transfer takes at least two cycles.

### Components:

# apb_if:
  - Interface with address and data widths of 8.
  - Includes master and slave clocking blocks.
  - Utilizes modport to define directions for master and slave ports.
  - 
# apb_test :

- Test is a place where we start the sequences on sequencer. In base test we will set all the parameters of configuration database class according to our requirements. We will also get the interface set in top and again set it to the interface handles in local configuration database classes. The base test also creates the environment. All these things happen in build phase of base test. The further child tests will be made from this base test class. In child test we just create the handle of virtual sequence and start it on virtual sequencer, before starting the sequence an objection is raised and this objection is dropped again after starting the sequence. If we don’t raise the objections, the simulator will think that there is no run phase to execute, so the simulator can jump directly to extract phase. The total number of raised objections should be equal to the number of dropped objections. 

# apb_base_seq_item:
  - Defines the base sequence item for master and slave transactions.
  - Includes constraints for address and delay.
  - Provides methods to print values for both master and slave transfers.

# apb_env :
  - Includes the APB package, master agent, slave agents, and virtual sequencer.
  - Establishes the topology of the verification environment.
  - Facilitates seamless communication between the master and slave agents.

# Master Driver :
  - Drives logic to the slave agent.
  - Initiates psel, address, pwrite, penable signals.
  - Waits for the pready signal from the slave.
  - Performs write operation when pwrite = 1 and read operation when pwrite = 0.

 # Slave Driver :
  - Drives the pready signal to the master agent.
  - Initiates read and write operations based on the pwrite signal.
  - Manages signals such as psel, address, penable, etc.

 # Monitor :
  - Declares an analysis port for communication. The Analysis Port in the Master Monitor Class facilitates communication of analyzed data to other components or external        observers for further processing or logging.

# Configuration Block:

  - The Configuration Block determines whether the master agent is active or passive, utilizing the UVM active enumeration through the ACTIVE_MACRO.

# Sequence:

  - The actual driven data is randomized in the sequence. From the sequence, this randomized data is given to driver via sequencer. The Sequence defines the sequence body in   a task, repeating transactions for 10 times. The `uvm_do macro can be used for conciseness.

# Sequencer:

  - The sequencer in UVM just acts as a gateway between sequence and driver. This is the only “non-virtual” class in our UVM test bench architecture. The sequencer is also parameterized by transaction class. The sequencer takes the randomized data from sequence and passes it to the driver to which it is connected, thus it connects several sequences to driver. The Sequencer is responsible for connecting the Master Sequence and Master Driver using the UVM Sequencer. This ensures proper coordination and execution of transactions.



