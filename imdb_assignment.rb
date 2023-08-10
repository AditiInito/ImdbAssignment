require "httparty"
require "nokogiri"
require 'faraday'

class MoviesImdb
    attr_accessor :name, :link, :cast
    def initialize (name, link)
        @name=name
        @link=link
        @cast=[]
    end
end

def scrape_movie_details(movie)
    cast = []
    resp = Faraday.get(movie.link)
    doc = Nokogiri::HTML(resp.body)
    doc.css(".fUguci").each do |actor|
        cast << actor.text
    end
    movie.cast << cast
end

response = Faraday.get("https://www.imdb.com/chart/top")
document = Nokogiri::HTML(response.body)
html_products = document.css("li.ipc-metadata-list-summary-item")

top_movies = []
threads=[]
html_products.each do |html_product|
    threads << Thread.new do
        name = html_product.css("a").css("h3").first.text
        page = html_product.css("a").first.attribute("href").value
        page_link = "https://www.imdb.com" + page
        # top_movies << [name, page_link]
        movie=MoviesImdb.new(name, page_link)
        top_movies << movie
    end
end
threads.each(&:join)

loop do
    puts "Enter the number (or 'end' to exit): "
    input = gets.chomp

    break if input.downcase == 'end'

    number_of_movies = input.to_i

    if number_of_movies > 0
        threads = []
        top_movies.first(number_of_movies).each do |movie|
            threads << Thread.new { scrape_movie_details(movie) }
        end
        threads.each(&:join)
        (0...number_of_movies).each do |i|
            puts top_movies[i].name
        end

        puts "enter the actor: "
        name = gets.chomp
        puts "enter the number of movies: "
        movies_of_actor = gets.chomp.to_i

        (0...movies_of_actor).each do |i|
            puts top_movies[i].name if top_movies[i].cast[0].include?(name)
        end
    else
        puts "Invalid input. Please enter a positive number or 'end'."
    end
end
