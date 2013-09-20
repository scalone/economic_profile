# encondig utf-8

require "./config/boot.rb"

set :public_folder, "public"
set :root, File.dirname(__FILE__)
set :views, "app/views"

$graphs = []
Report.new("./assets/planilha definitiva.xls").graphs.each do |report|
  $graphs << report[0]
  graph report[0], :type => 'pie' do
    pie report[0], report[1]
  end
end

get "/" do
  @graphics = ""
  $graphs.each do |name|
    url = name.gsub(/[^a-zA-Z0-9_\s]/, '').gsub(/\s/, '_').downcase
    @graphics << "<br><br><br> <img width=\"800px\" src=\"/#{url}.svg\"></img>"
  end

  erb :home
end

get "/presentation" do
  @slides = Dir["public/imgs/Presentation*"].collect {|slide| slide.split("/").last }.sort
  erb :presentation
end
