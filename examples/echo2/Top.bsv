// bsv libraries
import SpecialFIFOs::*;
import Vector::*;
import StmtFSM::*;
import FIFO::*;

// portz libraries
import AxiMasterSlave::*;
import Directory::*;
import CtrlMux::*;
import Portal::*;
import Leds::*;


// generated by tool
import SayWrapper::*;
import SayProxy::*;

// defined by user
import Say::*;

module mkPortalTop(StdPortalTop);

   // instantiate user portals
   SayProxy sayProxy <- mkSayProxy(7);
   Say say <- mkSay(sayProxy.ifc);
   SayWrapper sayWrapper <- mkSayWrapper(1008,say);
   Vector#(2,StdPortal) portals;
   portals[0] = sayWrapper.portalIfc;
   portals[1] = sayProxy.portalIfc; 
   
   // instantiate system directory
   Directory dir <- mkDirectory(portals);
   Vector#(1,StdPortal) directories;
   directories[0] = dir.portalIfc;
   
   // when constructing ctrl and interrupt muxes, directories must be the first argument
   let ctrl_mux <- mkAxiSlaveMux(directories,portals);
   let interrupt_mux <- mkInterruptMux(portals);
   
   interface ReadOnly interrupt = interrupt_mux;
   interface StdAxi3Slave ctrl = ctrl_mux;
   interface Axi3Master m_axi = ?;
   interface LEDS leds = ?;

endmodule
