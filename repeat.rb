
require('./main')

def challenge
  page_init
  10.times{ post_word }
  post_info
end

1.times {challenge}
