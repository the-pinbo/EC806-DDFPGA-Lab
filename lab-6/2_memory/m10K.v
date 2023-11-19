module m10k_memory(
	input clk,
	input [4:0]address,
	input [3:0]data_in,
	input write,
	output reg[3:0]data_out
);
	reg [3:0]mem_blk[31:0]; // Using verilog array
	reg write_sync;
	reg [4:0]address_sync;
	reg [3:0]data_in_sync;
	
	always @(posedge clk)begin
		write_sync <= write;
		address_sync <= address;
		data_in_sync <= data_in;
	end

	always @ (*)begin
		if(write_sync)
			mem_blk[address_sync] = data_in_sync;
		else
			data_out = mem_blk[address_sync];
	end
endmodule		
		