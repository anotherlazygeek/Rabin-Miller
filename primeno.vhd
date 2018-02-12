library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.MATH_REAL.all;

entity primeno is
port(	
	q: out std_logic_VECTOR (31 downto 0)
);
end primeno;  

architecture behav1 of primeno is

function MOD_3 (a, b, c : UNSIGNED (31 downto 0)) return UNSIGNED is
	
  VARIABLE x : UNSIGNED (31 downto 0) := TO_UNSIGNED(1, 32);
  VARIABLE y : UNSIGNED (31 downto 0) := a;
  VARIABLE b_temp : UNSIGNED (31 downto 0) := b;

begin

while b_temp > 0 loop
  if b_temp MOD 2 = 1 then
    x := (x * y) MOD c;
	 y := (y * y) MOD c;
	 b_temp:=(b_temp-1)/2;
  else 
    y := (y * y) MOD c;
  b_temp := b_temp / 2;
  end if;
end loop;
return x MOD c;

end MOD_3 ;

function MILLER_RABIN (prime : STD_LOGIC_VECTOR (31 downto 0)) return STD_LOGIC is

  VARIABLE t : INTEGER := 7;
  VARIABLE temp, r, a, x, j, n: UNSIGNED (31 downto 0); 
  VARIABLE small_random : UNSIGNED (31 downto 0); 
  VARIABLE large_random : UNSIGNED (31 downto 0); 
  VARIABLE s1, s2 : POSITIVE;
  VARIABLE random : REAL;

begin

n := UNSIGNED(prime);

if n MOD 2 = 0 OR n MOD 3 = 0 then
  return '0';    -- Not divisible by 2 or 3
else
  -- calculate n - 1 = 2^s * r such that r is odd
  r := n - 1;
  while r MOD 2 = 0 loop
    r := r / 2;
  end loop;

  for I in 1 to t loop
     choose random a, 2 <= a <= n-2
     for I in 0 to 31 loop
      UNIFORM(s1, s2, random); 
      large_random :=to_unsigned(INTEGER(random * REAL(32768)),32);
      large_random (I*32 + 31 downto I*32) := small_random;
    end loop;

    a := large_random;
    temp := r;
    x := MOD_3(a ,temp, n); 

    while (temp /= (n - 1) AND x /= 1 AND x /= (n - 1)) loop
      x := (x * x) MOD n;
		temp := resize(temp*2,temp'length);
    end loop;

		if x /= (n - 1) AND temp MOD 2 = 0 then
			return '0';
		end if; 

  end loop;

  return '1';
end if;
	return '1';
end MillER_RABIN;

function GEN_1024_PRIME return STD_LOGIC_VECTOR is

  VARIABLE s1, s2 : POSITIVE;
  VARIABLE random : REAL;
  VARIABLE small_random : STD_LOGIC_VECTOR (31 downto 0); 
  VARIABLE large_random : STD_LOGIC_VECTOR (31 downto 0); 
  VARIABLE prime : STD_LOGIC := '0';

begin

while prime /= '1' loop
  for I in 0 to 31 loop
    UNIFORM(s1, s2, random); 
    large_random := STD_LOGIC_VECTOR(to_unsigned(INTEGER(random * REAL(2140493648)), 32));
    large_random (I*32 + 31 downto I*32) := small_random;
  end loop;

  large_random(0) := '1';
  large_random(31) := '1';
  prime := MILLER_RABIN (large_random);
  
end loop;

return large_random;

end GEN_1024_PRIME;

begin 
q<= GEN_1024_PRIME;
end behav1;