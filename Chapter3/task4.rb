alphabet = ('a'..'z').to_a
vowels = %w[a e i o u]
vowel_hash = {}

alphabet.each_with_index { |char, index| vowel_hash[char] = index + 1 if vowels.include? char }

print vowel_hash
