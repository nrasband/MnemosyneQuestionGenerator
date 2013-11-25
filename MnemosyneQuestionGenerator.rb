# This script generates questions and answers randomly based on index.

# Generate a 2 to 8 digit hexadecimal number
# The user must enter the answer in decimal.
def generateRandomHexToDecimalQuestion
  random_value = (Random.rand * 65535).to_i
  printf("What is 0x%x in decimal? ", random_value)
  answer = gets.chomp
  if random_value.to_s == answer
    puts "Correct!"
  else
    puts "Incorrect. The answer was #{random_value}."
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
  else
    puts "Invalid index."
  end
end
