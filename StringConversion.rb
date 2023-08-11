def get_number (name)
    sum=0
    name.split("").each do |letter|
        arr=*("A"..letter)
        sum+=arr.each_with_index.reduce(0){|sum, (l, i)| sum=sum*2+i+1}
    end
    sum
end

def get_name (n)
    string=""
    arr=*("A".."Z")
    arr.reverse_each do |letter|
        number=get_number(letter).to_i
        break if n==0
        if n>=number
            times=n/number
            (1..times).each do |i|
                string+=letter
            end
            n-=(times*number)
        end
    end
    puts string
end


puts "Enter number: "
n=gets.chomp().to_i
get_name(n)

puts "Enter text: "
name=gets.chomp()
p get_number(name)
