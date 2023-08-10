require "httparty"
require "nokogiri"
require 'faraday'

def scrape_movie_details(movie)
    cast = []
    resp = Faraday.get(movie[1])
    doc = Nokogiri::HTML(resp.body)
    doc.css(".fUguci").each do |actor|
        cast << actor.text
    end
    movie << cast
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
        top_movies << [name, page_link]
    end
end
threads.each(&:join)

loop do
    puts "Enter the number (or 'end' to exit): "
    input = gets.chomp

    break if input.downcase == 'end'

    n = input.to_i

    if n > 0
        threads = []
        top_movies.first(n).each do |movie|
            threads << Thread.new { scrape_movie_details(movie) }
        end
        threads.each(&:join)
        (0...n).each do |i|
            puts top_movies[i][0]
        end

        puts "enter the actor: "
        name = gets.chomp
        puts "enter the number of movies: "
        m = gets.chomp.to_i

        (0...m).each do |i|
            puts top_movies[i][0] if top_movies[i][2].include?(name)
        end
    else
        puts "Invalid input. Please enter a positive number or 'end'."
    end
end
