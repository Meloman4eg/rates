# encoding: utf-8
require 'rubygems'
require 'sms_ru'
require 'clockwork'
require 'mechanize'
include Clockwork

def get_rate(currency)
  agent = Mechanize.new

  agent.get("http://www.finmarket.ru/currency/#{currency}/") do |page|
    price = page.search("div.valvalue").text
    dynamic = page.search("span.green").text + page.search("span.red").text
    return "1 #{currency} = #{price} рублей (#{dynamic})"
  end
end

handler do |job|
  sms = SmsRu::SMS.new(api_id: "3a5d1480-46b4-fd04-e9ca-bfc280b2018e")
  message = get_rate('USD') +'
' + get_rate('EUR')
  sms.send(to: "79603703758", text: message)
end

every(1.day, 'send_sms', :at => '07:00')