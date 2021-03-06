LIBRARY       IEEE; 
USE           IEEE.STD_LOGIC_1164.ALL;
use           ieee.std_logic_unsigned.all;
use           IEEE.NUMERIC_STD.all;

entity gestionAnemometre is 

port (

--entrees 
clk_50M 			: in std_logic; -- horloge
raz_n           	: in std_logic;	-- reset
in_freq_anemometre  : in std_logic; -- freq du vent
continu				: in std_logic;	-- mode de fonctionnement
start_stop			: in std_logic; -- start/stop
--sorties
data_valid			: out std_logic; -- validation donnee
data_anemometre		: out std_logic_vector (7 downto 0); -- valeur anemo
AffCentaine, AffDizane, AffUnite 		 : out  STD_LOGIC_VECTOR(0 to 6)
);

end gestionAnemometre;

architecture behv of gestionAnemometre is 
signal valeur_present   : std_logic_vector (25 downto 0):=(others => '0');
signal valeur_precedent : std_logic_vector (25 downto 0):=(others => '0');
signal valeur_calcule : std_logic_vector (25 downto 0):=(others => '0');
signal debut_periode: std_logic;
signal clk_1Hz : std_logic;
signal count_1Hz   : std_logic_vector (25 downto 0):=(others => '0');
signal buff		:   std_logic_vector (7 downto 0);
signal centaine, dizaine, unite : std_logic_vector (7 downto 0):=(others => '0');

BEGIN
-- process pour comptage avec horloge de 50M
compteur: process (clk_50M)
begin
	if rising_edge(clk_50M) then
	    if(valeur_present = X"2FAF080") then 
	         valeur_present <= (others => '0'); --"00000000000000000000000000";
				
	    else
		 if(debut_periode='1') then
		valeur_present <= valeur_present + X"1";
		end if;
	end if;
	end if;
end process;

div_clk: process (clk_50M)
begin
	if rising_edge(clk_50M) then
	    if(count_1Hz = X"2FAF080") then 
	         count_1Hz <= (others => '0');
				clk_1Hz<=not(clk_1Hz);
				buff<=std_logic_vector(to_unsigned( to_integer( 50000000 / unsigned (valeur_calcule)) ,8 ) );
	    else
		count_1Hz <= count_1Hz + X"1";
	end if;
	end if;
	if((buff>=X"00") or( buff<=X"FA")) then
 

    data_valid<='1';
else
data_valid<='0';
end if;

end process;


mesure_periode: process (in_freq_anemometre)
begin 
	if rising_edge(in_freq_anemometre) then
	debut_periode<='1';
		if (valeur_precedent < valeur_present) then
		valeur_calcule <= valeur_present - valeur_precedent;
		elsif (valeur_precedent > valeur_present ) then
        valeur_calcule <= valeur_precedent - valeur_present;
        end if;
        valeur_precedent <= valeur_present;
     end if;
end process;
 data_anemometre <= buff;

centaine <= std_logic_vector(to_unsigned(to_integer( unsigned(buff) / 100), 8));
dizaine  <= std_logic_vector(to_unsigned(to_integer( unsigned ( buff) /10  mod 10), 8));
unite    <= std_logic_vector(to_unsigned(to_integer(unsigned ( buff) mod 10 ), 8)) ;

AffCentaine <=  "0000001" when centaine =X"00"   else
                "1001111" when centaine =X"01"   else
                "0010010" when centaine =X"02"   else
                "0000110" when centaine =X"03"   else
                "1001100" when centaine =X"04"   else
                "0100100" when centaine =X"05"   else
                "0100000" when centaine =X"06"   else
                "0001111" when centaine =X"07"   else
                "0000000" when centaine =X"08"   else
                "0000100" when centaine =X"09"   else
                "1111111";
                
AffDizane <=    "0000001" when dizaine =X"00"   else
                "1001111" when dizaine =X"01"   else
                "0010010" when dizaine =X"02"   else
                "0000110" when dizaine =X"03"   else
                "1001100" when dizaine =X"04"   else
                "0100100" when dizaine =X"05"   else
                "0100000" when dizaine =X"06"   else
                "0001111" when dizaine =X"07"   else
                "0000000" when dizaine =X"08"   else
                "0000100" when dizaine =X"09"   else
                "1111111";
                
AffUnite <=     "0000001" when unite =X"00"   else
                "1001111" when unite =X"01"   else
                "0010010" when unite =X"02"   else
                "0000110" when unite =X"03"   else
                "1001100" when unite =X"04"   else
                "0100100" when unite =X"05"   else
                "0100000" when unite =X"06"   else
                "0001111" when unite =X"07"   else
                "0000000" when unite =X"08"   else
                "0000100" when unite =X"09"   else
                "1111111";
               







END behv;