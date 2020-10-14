LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY circuit4066 IS
	PORT(D0, D1, D2, D3 : IN STD_LOGIC;
		canonical_out, kmap_out : OUT STD_LOGIC);
END circuit4066;

ARCHITECTURE Behaviour of circuit4066 is

BEGIN
	--unsimplified CSOP expression from truth table and minterms
	canonical_out <= 	(not d0 and not d1 and not d2 and not d3) or --m0
						(not d0 and not d1 and     d2 and not d3) or --m4
						(not d0 and     d1 and     d2 and not d3) or --m6
						(    d0 and not d1 and     d2 and     d3) or --m11
						(    d0 and     d1 and not d2 and     d3) or --m13
						(    d0 and     d1 and     d2 and     d3);	 --m15
								
	--Simplified Boolean expression from the Karnaugh map
	kmap_out <= (d1 and d0 and d3) or 
				(d3 and d2 and d0) or 
				(not d1 and not d0 and not d3) or 
				(not d3 and d2 and not d0);
					
END Behaviour;
