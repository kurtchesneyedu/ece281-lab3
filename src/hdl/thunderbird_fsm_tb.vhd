----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2024 09:08:54 AM
-- Design Name: 
-- Module Name: thunderbird_fsm_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity thunderbird_fsm_tb is
end thunderbird_fsm_tb;

architecture behavior of thunderbird_fsm_tb is
 
   -- Component Declaration for the Unit Under Test (UUT)
     component thunderbird_fsm 
     port( i_clk, i_reset  : in    std_logic;
           i_left, i_right : in    std_logic;
           o_lights_L      : out   std_logic_vector(2 downto 0);
           o_lights_R      : out   std_logic_vector(2 downto 0)
           );
   end component;
   

   --Inputs
   signal w_left : std_logic := '0';
   signal w_right : std_logic := '0';
   signal w_reset : std_logic := '0';
   signal w_clk : std_logic := '0';
   
   --Outputs
   signal w_lights_L : std_logic_vector(2 downto 0) := "000"; --(LSB is LA, MSB is LC)
   signal w_lights_R : std_logic_vector(2 downto 0) := "000"; --(LSB is RA, MSB is RC)
       
   -- Clock period definitions
   constant k_clk_period : time := 10 ns;

begin
     -- PORT MAPS ---------------------------------------------------
   -- Instantiate the Unit Under Test (UUT)
  uut: thunderbird_fsm port map (
         i_left => w_left,
         i_right => w_right,
         i_reset => w_reset,
         i_clk => w_clk,
         o_lights_L => w_lights_L,
         o_lights_R => w_lights_R
       );
   ----------------------------------------------------------------
 
   -- PROCESSES --------------------------------------------------- 
   -- Clock process
   clk_proc : process
   begin
       w_clk <= '0';
       wait for k_clk_period/2;
       w_clk <= '1';
       wait for k_clk_period/2;
   end process;
   
   -- Simulation process
   -- Use 220 ns for simulation
   sim_proc: process
   begin
       -- sequential timing        
       w_reset <= '1';
       wait for k_clk_period*1;
         assert w_lights_L = "000" report "bad reset left side" severity failure;
         assert w_lights_R = "000" report "bad reset right side" severity failure;
       
       w_reset <= '0';
       wait for k_clk_period*1;
       
       -- hazard light check
       w_left <= '1';
       w_right <= '1'; wait for k_clk_period;
         assert w_lights_L = "111" report "all left side should be on when hazard" severity failure;
         assert w_lights_R = "111" report "all right side should be on when hazard" severity failure;
       -- one period later all lights should be off (hazard flash functionality)
         wait for k_clk_period;
         assert w_lights_L = "000" report "all left should be off one period later for hazard" severity failure;
         assert w_lights_R = "000" report "all right should be off one period later for hazard" severity failure;
       -- reset
       w_reset <= '1'; w_left <= '0'; w_right <= '0';
         wait for k_clk_period*1;
       -- check right blinker functionality
       w_reset <= '0'; w_right <= '1'; wait for k_clk_period*1; -- light up RA
         assert w_lights_R = "001" report "error on RA" severity failure;
         assert w_lights_L = "000" report "error on left side when RA" severity failure;
       wait for k_clk_period; -- light up RA RB
         assert w_lights_R = "011" report "error on RA RB" severity failure;
         assert w_lights_L = "000" report "error on left side when RA RB" severity failure;
       wait for k_clk_period; -- light up RA RB RC
         assert w_lights_R = "111" report "error on RA RB RC" severity failure;
         assert w_lights_L = "000" report "error on left side when RA RB RC" severity failure;
       wait for k_clk_period; -- all right lights to 0
         assert w_lights_R = "000" report "error on right light reset" severity failure;
         assert w_lights_L = "000" report "error on left side when R reset" severity failure;
         
       -- reset
        w_reset <= '1'; w_left <= '0'; w_right <= '0';
          wait for k_clk_period*1;
        -- check left blinker functionality
        w_reset <= '0'; w_left <= '1'; wait for k_clk_period; -- light up LA
          assert w_lights_L = "001" report "error on LA" severity failure;
          assert w_lights_R = "000" report "error on right side when LA" severity failure;
        wait for k_clk_period; -- light up LA LB
          assert w_lights_L = "011" report "error on LA LB" severity failure;
          assert w_lights_R = "000" report "error on right side when LA LB" severity failure;
        wait for k_clk_period; -- light up LA LB LC
          assert w_lights_L = "111" report "error on LA LB LC" severity failure;
          assert w_lights_R = "000" report "error on right side when LA LB LC" severity failure;
        wait for k_clk_period; -- all right lights to 0
          assert w_lights_L = "000" report "error on left light reset" severity failure;
          assert w_lights_R = "000" report "error on right side when L reset" severity failure;
          
        -- checking async reset functionality
        w_reset <= '0'; w_left <= '1'; w_right <= '0';
          wait for k_clk_period*1.25; -- between clock periods to check lights still turn off
        w_reset <= '1';
          wait for k_clk_period*0.5;
          assert w_lights_L = "000" report "error on async reset L" severity failure;
          assert w_lights_R = "000" report "error on async reset R" severity failure;
       
        -- reset and turn everything off
          w_reset <= '0'; w_left <= '0'; w_right <= '0';
          wait for k_clk_period*2;
           assert w_lights_L = "000" report "error on left in default state" severity failure;
           assert w_lights_R = "000" report "error on right in default state" severity failure;
       wait;
   end process;
   ----------------------------------------------------------------
end;
