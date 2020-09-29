
require 'open-uri'
require 'nokogiri'
require 'mechanize'
require 'byebug'
require 'json'

agent = Mechanize.new
url = 'https://www.film.ru/movies/kinoman'
html = open(url)

doc = Nokogiri::HTML(html)

movies = []
doc.css('.movies-center').each do |movie|

  @name_film = movie.at('h1').text.strip
  @info = movie.at('h3').text.split(',').map(&:strip)
  @time = movie.at_css('.movies-center-table strong').text
  @priemera = movie.css('.movies-center-table div strong').text.split("\n").map(&:strip)
  @priemera =  @priemera[4].tap { |d| Date.parse(d) }

end

doc.css('.movies-left').each do |movie|
  @img_url = movie.at('img')['src']
  agent.get(@img_url).save "img/movie_img.jpg"
end

movies.push(
  name: @name_film,
  information: @info,
  time_movie: @time,
  priemera_movie: @priemera,
  img_url: @img_url
)

puts JSON.pretty_generate(movies)
