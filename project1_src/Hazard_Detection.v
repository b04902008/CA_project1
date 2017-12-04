module Hazard_Detection
(
	ID_EX_MemRead_i,
	ID_EX_Rt_i,
	IF_ID_Rs_i,
	IF_ID_Rt_i,
	stall_o
);

input			ID_EX_MemRead_i ;
input	[4:0]	ID_EX_Rt_i ;
input	[4:0]	IF_ID_Rs_i ;
input	[4:0]	IF_ID_Rt_i ;
input			stall_o ;

assign stall_o = ID_EX_MemRead_i & 
				((ID_EX_Rt_i == IF_ID_Rs_i) | (ID_EX_Rt_i == IF_ID_Rt_i)) ;

endmodule