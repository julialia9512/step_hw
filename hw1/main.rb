# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'
require 'mechanize'

require 'net/http'
require 'uri'

require('./find_words')

# use nokogiri
# charset = nil
# html = open(url) do |f|
#   charset = f.charset # 文字種別を取得
#   f.read # htmlを読み込んで変数htmlに渡す
# end
#
# # htmlをパース(解析)してオブジェクトを生成
# doc = Nokogiri::HTML.parse(html, nil, charset)
# div = doc.xpath('//div')
# $letter = doc.css('.letter').inner_text
# p $letter

# スクレイピング先のURL
$url = 'https://icanhazwordz.appspot.com/'
def page_init
  agent = Mechanize.new
  # agent.log = Logger.new
  $page = agent.get($url)
end

  # page.search('form').each { |doc|  puts doc} #for debug
def get_letter
  letter = $page.search('div.letter').inner_text
  letter
end
def get_seed
  seed = $page.search("//form/input[@name = 'Seed']").attribute('value').text
  seed
end
def get_started
  started = $page.search("//form/input[@name = 'Started']").attribute('value').text
  started
end

def post_word
  answer = select_best_word(get_letter)
  p answer
  # my_url = URI.parse($url)
  # puts res.body
  # http = Net::HTTP.new $url
  # name が f1 な <form> を探す
  $page.form_with{|form|
    form.field_with(:name => "Seed").value = get_seed
    form.field_with(:name => "Started").value = get_started
    form.field_with(:name => "move").value = answer
    # フォームに submit ボタンがあれば「押」して送信
    $page = form.click_button
  }
  puts $page.search('p')
  # puts $page.search('form')
  # p response = http.request(req)
end

def post_info
  $page.form_with { |form|
    form.field_with(:name => 'NickName' ).value = 'juli'
    form.radiobuttons_with(:name => 'Agent' )[1].check
    form.field_with(:name => 'Name').value = 'julia'
    form.field_with(:name => 'Email').value = 'https://github.com/julialia9512/step_hw1'
    form.click_button
  }
end
