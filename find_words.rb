#
# user_abc = ''
# print "Write your alphabets.\n"
# input = gets.chomp
# while input != '0'
#   print "what else? If no more, say '0'.\n"
#   user_abc += input
#   input = gets.chomp
# end
def sort_input(letter)
  user_abc = letter.downcase.split('')
  count = user_abc.count('q')
  count.times{
    user_abc.delete_at(user_abc.find_index('u')) if user_abc.include?('q')
  }
  sorted_abc = user_abc.sort! { |a, b| a <=> b }
  sorted_abc
end

# 差分をもとめる
def diff(from, ary)
  temp = from.dup # selfの破壊を防ぐため。
  ary.each do |val|
    idx = temp.index(val)
    next if idx.nil? # ary2の要素がary1にないときはパス。
    temp.delete_at(idx)
  end
  temp
end

def score(word)
  sum = 0
  array = word.split('')
  count = array.length
  sum += count * 1 unless count.zero?
  count = array.count do |chr|
    chr == 'j' || chr == 'k' || chr == 'x' || chr == 'z' || chr == 'q'
  end
  sum += count * 2 unless count.zero?
  count = array.count do |chr|
    chr == 'c' || chr == 'f' || chr == 'h' ||
      chr == 'l' || chr == 'm' || chr == 'p' ||
      chr == 'v' || chr == 'w' || chr == 'y'
  end
  sum += count * 1 unless count.zero?
  sum
end
# put words in the dictionary into a hash


def find_words(letter)
  words = {}
  answer = []
  File.open('/Users/julia/Documents/debian_us_eng_dictionary.words') do |file|
    file.each do |line|
      word = line.strip
      word.downcase!
      sorted_line = word.split('').sort! { |a, b| a <=> b }
      words[word] = sorted_line.join
      answer << word if diff(sorted_line, sort_input(letter)).empty?
    end
  end
  answer
end

def select_best_word(letter)
  answer = find_words(letter).select { |n| n.length >= 5 }
  if answer.select { |n| n.length >= 10 }.nil?
    answer.select! { |n| n.length >= 10 }
  end
  answer.sort! { |a, b| b.length <=> a.length }
  answer = answer.max_by { |word| score(word) }
  answer
end
