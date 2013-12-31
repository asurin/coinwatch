require 'cryptsy/api'
require 'curses'

DOGE_XR_DETAILS = [{primary_currency_code: 'DOGE', secondary_currency_code: 'BTC'}]
CRYPTSY = {public: '', private: ''}
MPOS = {id:61442, key: ''}
WALLET = ''

cryptsy = Cryptsy::API::Client.new(CRYPTSY[:public], CRYPTSY[:private])
while true
  doge_info = cryptsy.getmarkets['return'].select do |currency|
    DOGE_XR_DETAILS.detect { |desired| currency['primary_currency_code'] == desired[:primary_currency_code] && currency['secondary_currency_code'] == desired[:secondary_currency_code] }
  end
  doge_to_btc_value = doge_info.first['last_trade'].to_f
  pool_stats = JSON.parse(Net::HTTP.get_response(URI.parse("https://www.suchcoins.com/index.php?page=api&action=getuserbalance&api_key=#{MPOS[:key]}&id=#{MPOS[:id]}")).body)['getuserbalance']['data']
  btc_to_usd_value = JSON.parse(Net::HTTP.get_response(URI.parse('http://data.mtgox.com/api/1/BTCUSD/ticker')).body)['return']['avg']['value'].to_f
  wallet = Net::HTTP.get_response(URI.parse("http://dogechain.info/chain/Dogecoin/q/addressbalance/#{WALLET}")).body.to_f
  confirmed_doge = pool_stats['confirmed'] + wallet
  unconfirmed_doge = pool_stats['unconfirmed']
  print "\r#{confirmed_doge} (+#{unconfirmed_doge}) DOGE @ %.10f tracks as $#{((confirmed_doge * doge_to_btc_value) * btc_to_usd_value).round(3)} (+$#{((unconfirmed_doge * doge_to_btc_value) * btc_to_usd_value).round(3)}) [#{Time.now.strftime("%H:%M:%S.%L %d/%m/%Y")}]" % doge_to_btc_value
  sleep 5
end