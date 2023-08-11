class North
    attr_accessor :left, :right, :current_j, :move_forward, :move_backward
    def initialize (current_j)
        @left="West"
        @right="East"
        @current_j=current_j
    end
    def move_forward
        @current_j+=1
    end
    def move_backward
        @current_j-=1
    end
end

class South
    attr_accessor :left, :right, :current_j, :move_forward, :move_backward
    def initialize (current_j)
        @left="East"
        @right="West"
        @current_j=current_j
    end
    def move_forward
        @current_j-=1
    end
    def move_backward
        @current_j+=1
    end
end

class East
    attr_accessor :left, :right, :current_i, :move_forward, :move_backward
    def initialize (current_i)
        @left="North"
        @right="South"
        @current_i=current_i
    end
    def move_forward
        @current_i+=1
    end
    def move_backward
        @current_i-=1
    end
end

class West
    attr_accessor :left, :right, :current_i, :move_forward, :move_backward
    def initialize (current_i)
        @left="South"
        @right="North"
        @current_i=current_i
    end
    def move_forward
        @current_i-=1
    end
    def move_backward
        @current_i+=1
    end
end


def movement (n, instructions)
    i=1
    j=1
    direction="North"
    instructions.split("").each do |instruction|
        if instruction=="U"
            if direction=="North"
                move=North.new(j)
                new_val=move.move_forward
                if new_val.between?(1,n)
                    j=new_val
                else
                    return -1
                end
            end
            if direction=="South"
                move=South.new(j)
                new_val=move.move_forward
                if new_val.between?(1,n)
                    j=new_val
                else
                    return -1
                end
            end
            if direction=="East"
                move=East.new(i)
                new_val=move.move_forward
                if new_val.between?(1,n)
                    i=new_val
                else
                    return -1
                end
            end
            if direction=="West"
                move=West.new(i)
                new_val=move.move_forward
                if new_val.between?(1,n)
                    i=new_val
                else
                    return -1
                end
            end
        elsif instruction=="D"
            if direction=="North"
                move=North.new(j)
                new_val=move.move_backward
                if new_val.between?(1,n)
                    j=new_val
                else
                    return -1
                end
            end
            if direction=="South"
                move=South.new(j)
                new_val=move.move_backward
                if new_val.between?(1,n)
                    j=new_val
                else
                    return -1
                end
            end
            if direction=="East"
                move=East.new(i)
                new_val=move.move_backward
                if new_val.between?(1,n)
                    i=new_val
                else
                    return -1
                end
            end
            if direction=="West"
                move=West.new(i)
                new_val=move.move_backward
                if new_val.between?(1,n)
                    i=new_val
                else
                    return -1
                end
            end
        elsif instruction=="L"
            if direction=="North"
                move=North.new(j)
                direction=move.left
            elsif direction=="South"
                move=South.new(j)
                direction=move.left
            elsif direction=="East"
                move=East.new(i)
                direction=move.left
            elsif direction=="West"
                move=West.new(i)
                direction=move.left
            end
        elsif instruction=="R"
            if direction=="North"
                move=North.new(j)
                direction=move.right
            elsif direction=="South"
                move=South.new(j)
                direction=move.right
            elsif direction=="East"
                move=East.new(i)
                direction=move.right
            elsif direction=="West"
                move=West.new(i)
                direction=move.right
            end
        end
    end
    puts direction + i.to_s + j.to_s
end


puts "enter grid dimension: "
n=gets.chomp()
puts "enter the instructions: "
instructions=gets.chomp()

movement(n.to_i, instructions)

