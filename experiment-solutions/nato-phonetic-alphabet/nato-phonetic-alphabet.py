"""
Conversion functions for the NATO Phonetic Alphabet.
"""

# To save a lot of typing the code words are presented here
# as a dict, but feel free to change this if you'd like.
ALPHANUM_TO_NATO = {
    "A": "ALFA",
    "B": "BRAVO",
    "C": "CHARLIE",
    "D": "DELTA",
    "E": "ECHO",
    "F": "FOXTROT",
    "G": "GOLF",
    "H": "HOTEL",
    "I": "INDIA",
    "J": "JULIETT",
    "K": "KILO",
    "L": "LIMA",
    "M": "MIKE",
    "N": "NOVEMBER",
    "O": "OSCAR",
    "P": "PAPA",
    "Q": "QUEBEC",
    "R": "ROMEO",
    "S": "SIERRA",
    "T": "TANGO",
    "U": "UNIFORM",
    "V": "VICTOR",
    "W": "WHISKEY",
    "X": "XRAY",
    "Y": "YANKEE",
    "Z": "ZULU",
    "0": "ZERO",
    "1": "ONE",
    "2": "TWO",
    "3": "TREE",
    "4": "FOUR",
    "5": "FIVE",
    "6": "SIX",
    "7": "SEVEN",
    "8": "EIGHT",
    "9": "NINER",
}

def transmit(message: str) -> str:
    """
    Convert a message to a NATO code word transmission.
    """
    result = []
    for ch in message.upper():
    	if ch in ALPHANUM_TO_NATO:
    			result.append(ALPHANUM_TO_NATO[ch])
    return " ".join(result)

def receive(transmission: str) -> str:
		"""
		Convert a NATO code word transmission to a message.
		"""
		result = []
		for word in transmission.split(" "):
			if word in ALPHANUM_TO_NATO.values():
				result.append(dict_key(ALPHANUM_TO_NATO, word))
		return "".join(result)

def dict_key(dict, value):
	for k,v in dict.items():
		if value == v:
			return k
	return None

