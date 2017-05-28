
user_abc = ''
print "Write your alphabets.\n"
input = gets.chomp
while input != '0'
  print "what else? If no more, say '0'.\n"
  user_abc += input
  input = gets.chomp
end
user_abc = user_abc.split('')
sorted_abc = user_abc.sort! { |a, b| a <=> b }
p sorted_abc

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
# put words in the dictionary into a hash
words = {}
answer = []
File.open('/Users/julia/Documents/debian_us_eng_dictionary.words') do |file|
  file.each do |line|
    word = line.strip
    sorted_line = word.split('').sort! { |a, b| a <=> b }
    words[word] = sorted_line.join
    if diff(sorted_line, sorted_abc).empty? then answer << word end
  end
end
answer.select! {|n| n.length >= 5}
answer.sort! { |a,b| a.length <=> b.length }
p answer
