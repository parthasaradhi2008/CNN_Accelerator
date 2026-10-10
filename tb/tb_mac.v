`timescale 1ns/1ps
module tb_mac;
   parameter W_bits=8;
   parameter acc_bits=32;
   reg clk,rst_n,clear,en;
   reg signed [W_bits-1:0] w,a;
   wire signed [acc_bits-1:0] acc;
mac#(
   .W_bits(W_bits),
   .acc_bits(acc_bits)
) dut (
   .clk(clk),
   .rst_n(rst_n),
   .en(en),
   .clear(clear),
   .w(w),
   .a(a),
   .acc(acc)
   );
integer tests=0,errors=0;
integer i;
integer fd, scan_result;
reg [7:0] w_hex, a_hex;
reg [31:0] expected_hex;
integer j;
reg signed [acc_bits-1:0] expected;
initial begin
    $dumpfile("mac.vcd");
    $dumpvars(0, tb_mac);
end
always begin
    #5 clk=~clk;
end
initial begin 
   clk=0;
   rst_n=0;
   en=1;
   clear=0;
   w='0;
   a='0;
   expected = 0;
   #20
//   EDGE CASE TESTS
   rst_n=1;
   en=1;
   clear=0;
   w=0;
   a=-120;
   tests=tests+1;
   @(posedge clk)
   #1
   if (clear)   expected = 0;
   else if (en) expected = expected + w*a;
   if (acc !== expected) begin
      $display("ERROR Test 1: Expected %0d, got %0d", expected, acc);
      errors = errors + 1;
   end
   rst_n=1; 
   en=1;
   clear=0;
   w=-128;
   a=-128;
   tests=tests+1;
   @(posedge clk)
   #1
   if (clear)   expected = 0;
   else if (en) expected = expected + w*a;
   if (acc !== expected) begin
      $display("ERROR Test 2: Expected %0d, got %0d", expected, acc);
      errors = errors + 1;
   end
   rst_n=1;
   en=1;
   clear=0;
   w=1;
   a=1;
   tests=tests+1;
   @(posedge clk)
   #1
   if (clear)   expected = 0;
   else if (en) expected = expected + w*a;
   if (acc !== expected) begin
      $display("ERROR Test 3: Expected %0d, got %0d", expected, acc);
      errors = errors + 1;
   end
   rst_n=1;
   en=1;
   clear=0;
   w=127;
   a=127;
   tests=tests+1;
   @(posedge clk)
   #1
   if (clear)   expected = 0;
   else if (en) expected = expected + w*a;
   if (acc !== expected) begin
      $display("ERROR Test 4: Expected %0d, got %0d", expected, acc);
      errors = errors + 1;
   end
   rst_n=1; 
   en=1;
   clear=0;
   w=127;
   a=-128;
   tests=tests+1;
   @(posedge clk)
   #1
   if (clear)   expected = 0;
   else if (en) expected = expected + w*a;
   if (acc !== expected) begin
      $display("ERROR Test 5: Expected %0d, got %0d", expected, acc);
      errors = errors + 1;
   end
   // test for functioning of clear
   clear = 1; en = 1; w = 10; a = 10;
   expected = 0;
   tests = tests + 1;
   @(posedge clk); #1;
   if (acc !== expected) begin
      $display("ERROR Explicit Clear Mid-stream: Expected %0d, got %0d", expected, acc);
      errors = errors + 1;
   end
   //test for functioning of enable
   clear = 0; en = 0; w = 50; a = 50; 
   tests = tests + 1;
   @(posedge clk); #1;
   if (acc !== expected) begin
      $display("ERROR en=0 Hold Test: Expected %0d, got %0d", expected, acc);
      errors = errors + 1;
   end
   // test for functioning of asynchronous rst_n
   en = 1; w = 5; a = 5;
   @(posedge clk); #1;
   expected = expected + (w * a); 
   #3;
   rst_n = 0;
   expected = 0;
   #1;
   tests = tests + 1;
   if (acc !== 0) begin
      $display("ERROR Async Reset: Expected 0 immediately on rst_n=0, got %0d", acc);
      errors = errors + 1;
   end
   #10;
   rst_n = 1;
   clear = 1;
   @(posedge clk); #1;
//     RANDOM 2000 CASE TESTS
   expected =0;
   for (i = 0; i < 2000; i = i + 1) begin
      w=$signed($urandom);
      a=$signed($urandom);
      en=($urandom %4!=0);
      clear=($urandom %16==0);
      if (clear) expected=0;
      else if (en) expected=expected+(w*a);
      tests=tests+1;
      @(posedge clk)
      #1
      if (acc !== expected) begin
         $display("ERROR Random Test %0d: Expected %0d, got %0d",i,expected,acc);
         errors = errors + 1;
      end
   end
//       PYTHON-GENERATED VECTOR TESTS
en = 0;
clear = 1;
@(posedge clk);
#1;
clear = 0;
fd = $fopen("data/mac_vectors.txt", "r");
if (fd == 0) begin
    $display("ERROR: Cannot open mac_vectors.txt");
    errors = errors + 1;
end
else begin
    j = 0;
    while (!$feof(fd)) begin
        scan_result = $fscanf(fd, "%h %h %h\n",
                               w_hex, a_hex, expected_hex);
        if (scan_result == 3) begin
            w = $signed(w_hex);
            a = $signed(a_hex);
            en = 1;
            clear = 0;
            @(posedge clk);
            #1;
            if (acc !== $signed(expected_hex)) begin
                $display("ERROR Python vector %0d: Expected %0d, got %0d",
                         j, $signed(expected_hex), acc);
                errors = errors + 1;
            end
            tests = tests + 1;
            j = j + 1;
        end
    end
    $fclose(fd);
    en = 0;
    $display("Python vectors checked: %0d", j);
end
$display ("\n--- SIMULATION SUMMARY---");
$display ("tests=%0d|errors=%0d",tests,errors);
if (errors==0) $display ("Congratulations!No errors encountered");
else $display ("Errors encountered! check you're design");
$finish;
end
endmodule