require "./config/boot.rb"

graph "Our Business", :prefix => '/graphs' do
  area "Buys", [1,5,2,3,4]
  bar "Sales", [5,2,6,2,1]
end

get "/" do
  "<img src=\"http://localhost:9292/graphs/our_business.svg\" >"
end
