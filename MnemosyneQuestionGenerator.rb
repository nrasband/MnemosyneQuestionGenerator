# This script generates questions and answers randomly based on index.

### Helper methods ###

# Transpose the index to allow the MSB to be the left-most bit.
def transposeIndex(index, max_index)
  return max_index - index
end

# Given a binary string representing a 32-bit two's complement number,
# convert it to a decimal value.
def computeIntValueOf32BitBinaryString(binary)
  # Start out with 0 and then add positive numbers to it.
  result = 0

  # Start out with the most negative number if "1" is the MSB.
  if binary[0] == "1"
    result = -0x80000000
  end
  
  enum = binary.enum_for(:each_char)
  enum.each_with_index do |val, index|
    next if index == 0 # Skip index 0
    power = transposeIndex(index, 31)
    result = result + (2**power) * val.to_i   
  end
  
  # Return the computed result.
  return result
end

### Question methods ###

# Generate a 2 to 4 digit hexadecimal number
# The user must enter the answer in decimal.
def generateRandomHexToDecimalQuestion
  random_value = (Random.rand * 65535).to_i
  printf("What is 0x%x in decimal? ", random_value)
  answer = gets.chomp
  if random_value.to_s == answer
    puts "Correct!"
  else
    puts "Incorrect. The answer is #{random_value}."
  end
end

# Generate up to an 8 digit binary number to be converted to decimal.
def generateRandomBinaryToDecimalQuestion
  random_value = (Random.rand * 255).to_i
  printf("What is %b in decimal? ", random_value);
  answer = gets.chomp
  if random_value.to_s == answer
    puts "Correct!"
  else
    puts "Incorrect. The answer is #{random_value}."
  end
end

# Generate a 32-bit negative number (using 2's complement)
# and have the user convert it from hex to decimal.
def generateRandomNegativeTwosComplement()
  random_value = (Random.rand * 0x80000000).to_i
  random_value = random_value | 0x80000000
  printf("What is 0x%x (32-bit two's complement) in decimal? ", random_value)

  # I am converting this into a binary string so that I can manually
  # compute the decimal representation (since Ruby uses Fixnums).
  binary_string = random_value.to_s(2)

  int_val = computeIntValueOf32BitBinaryString(binary_string)
  answer = gets.chomp
  if int_val.to_s == answer
    puts "Correct!"
  else
    puts "Incorrect. The answer is #{int_val}"
  end
end

# Generate a random 32-bit binary number
# representing a floating point value.
def generateRandomFloatingPointValue() 
  sign_bit = Random.rand < 0.5 ? 0 : 1
  exponent = 0

  # Form a random 8 bit exponent.
  0.upto(7) do |i|
    bit = Random.rand < 0.5 ? 0 : 1
    # Shift the bit to the left by i.
    bit = bit << i
    # Bitwise or with the exponent
    exponent = exponent | bit
  end

  # Form the upper 5 most significant bits of the mantissa.
  mantissa = 0
  19.upto(23) do |i|
    bit = Random.rand < 0.5 ? 0 : 1
    # Shift the bit to the left by i.
    bit = bit << i
    # Bitwise or with the mantissa
    mantissa = mantissa | bit
  end

  value = sign_bit << 31
  value = value | (exponent << 23)
  value = value | mantissa

  printf("What is the decimal value for IEEE-754 floating point 0x%x? ", value)
  answer = gets.chomp

  # Calculate the decimal value for "value".
  s = sign_bit == 1 ? -1 : 1
  e = exponent.to_i
  mantissa = mantissa >> 18
  m = 0.0
  5.downto(1) do |i|
    m = m + (1.0 / (i*2)) * (0x1 & mantissa)
    mantissa = mantissa >> 1 
  end

  v = s * (2**(e - 127)) * (1+m)

  # Compare answer to value.
  if v.to_s == answer
      puts "Correct!"
  else
      puts "Incorrect! The answer is #{v}"
  end
end
  
# Loop until the player quits.
loop do
  # Prompt the user for an index.
  print "Enter the index from Mnemosyne or 'q' to quit: "

  # Retrieve the index and get rid of any newlines.
  index = gets.chomp

  # Exit the program if the user enters a lower or uppercase 'q'
  exit if index.downcase == 'q'
  # Call the correct method to generate the correct random question.
  case index
  when "1"
    generateRandomHexToDecimalQuestion()
  when "2"
    generateRandomBinaryToDecimalQuestion()
  when "3"
    generateRandomNegativeTwosComplement()
  when "4"
    generateRandomFloatingPointValue()
  else
    puts "Invalid index."
  end
end
