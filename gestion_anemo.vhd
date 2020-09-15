LIBRARY       IEEE; 
USE           IEEE.STD_LOGIC_1164.ALL;
use           ieee.std_logic_unsigned.all;
use           IEEE.NUMERIC_STD.all;

entity gestion_anemo is 

port (

--entrees 
clk_50M 			: in std_logic; -- horloge
raz_n           	: in std_logic;	-- reset
in_freq_anemometre  : in std_logic; -- freq du vent
continu				: in std_logic;	-- mode de fonctionnement
start_stop			: in std_logic; -- start/stop
--sorties
data_valid			: out std_logic; -- validation donnee
data_anemometre		: out std_logic_vector (25 downto 0) -- valeur anemo

);

end gestion_anemo;

architecture behv of gestion_anemo is 
signal valeur_present   : std_logic_vector (25 downto 0):=(others => '0');
signal valeur_precedent : std_logic_vector (25 downto 0):=(others => '0');
signal valeur_calcule : std_logic_vector (25 downto 0);
BEGIN
-- process pour comptage avec horloge de 50M
process (clk_50M)
begin
	if rising_edge(clk_50M) then
	    if(valeur_present = X"2FAF080") then 
	         valeur_present <= (others => '0'); --"00000000000000000000000000";
	    else
		valeur_present <= valeur_present + X"1";
	end if;
	end if;
end process;

--deuxieme process
process (in_freq_anemometre)
begin 
	if rising_edge(in_freq_anemometre) then
		if (valeur_precedent < valeur_present) then
		valeur_calcule <= valeur_present - valeur_precedent;
		elsif (valeur_precedent > valeur_present ) then
        valeur_calcule <= valeur_precedent - valeur_present;
        end if;
        valeur_precedent <= valeur_present;
     end if;
end process;

data_anemometre <= (valeur_calcule);  --(X"2FAF080") / 

END behv;

