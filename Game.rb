require 'pry'
class Cell
attr_accessor :cell_state
    def initialize(state)
        @cell_state=state
    end
    
     def get_adjoining_cell_number(grid,x,y,x_min,y_min,x_dim,y_dim)
    alive=0
    if y-1>=y_min
      alive=alive + grid[x][y-1].cell_state
    end
    
    if y+1 < y_dim
      alive=alive + grid[x][y+1].cell_state
    end
    
    if x-1 >= x_min 
      alive = alive + grid[x-1][y].cell_state
    end
    
    if x+1 < x_dim
      alive= alive + grid[x+1][y].cell_state
    end
    
    if x-1 >= x_min && y-1 >= y_min
      alive=alive + grid[x-1][y-1].cell_state
    end
    
    if x-1 >= x_min && y+1 < y_dim
      alive= alive + grid[x-1][y+1].cell_state
    end
    
    if x+1 < x_dim && y-1 >= y_min
      alive=alive + grid[x+1][y-1].cell_state
    end
    
    if x+1 < x_dim && y+1 < y_dim
      alive=alive + grid[x+1][y+1].cell_state
    end
    
    return alive
  end
   
   def get_cell_state
    if @cell_state==0
      return " "
    else
      return "o"
    end
   end
        
end

class Grid
  
  attr_accessor :grid, :x_dim, :y_dim, :x_min, :y_min
  
  def change_grid new_grid_object
    i=0
    #binding.pry
    @grid.each do |x|
      if i<@x_min
        i=i+1 
        next
      elsif i>=@x_dim
        break
      end
      j=0
      x.each do |y|
        if j<@y_min
          j=j+1
          next
        elsif j>=@y_dim
          break
        end
        #binding.pry
        if (@grid[i][j].cell_state==0)
          if (@grid[i][j].get_adjoining_cell_number(@grid,i,j,@x_min,@y_min,@x_dim,@y_dim) == 3 )
            new_grid_object.grid[i][j].cell_state=1
            @x_min=@x_min-1
            @y_min=@y_min-1
            @x_dim=@x_dim+1
            @y_dim=@y_dim+1
            #binding.pry
          end
        else
          if (@grid[i][j].get_adjoining_cell_number(@grid,i,j,@x_min,@y_min,@x_dim,@y_dim) < 2 || @grid[i][j].get_adjoining_cell_number(@grid,i,j,@x_min,@y_min,@x_dim,@y_dim) >= 4)
              new_grid_object.grid[i][j].cell_state=0
          end
        end
        j=j+1
      end
      i=i+1
    end
    new_grid_object.update_grid(self)
    return new_grid_object
  end
  
  def display_grid
    i=-1
    top=get_top-1
    left=get_left-1
    right=get_right.to_i+1
    bottom=get_bottom.to_i+1
    #binding.pry
    @grid.each do |line|
       if i<top-1
        i=i+1 
        next
       elsif i>=bottom+1
        break
       end
      j=0
      line.each do |char|
         if j<left-1
          j=j+1
          next
        elsif j>=right+1
          break
        end
        print char.get_cell_state
        j=j+1
      end
      print "\n"
      i=i+1
    end
  end
  
  def clear_grid
    @grid.each do |x|
      x.each do |y|
        y.cell_state=0
      end
    end
  end
  
  def get_top
    i=0
    @grid.each do |x|
      j=0
      x.each do |y|
        if y.cell_state==1
          return i
        end
        j=j+1
      end
      i=i+1
    end  
  end
  
   def get_left
    for i in 0..y_dim-1
      for j in 0..x_dim-1
        if @grid[j][i].cell_state==1
          return i
        end
      end 
    end
  end
  
  def get_bottom
    (0..x_dim).to_a.reverse.each do |i|
      (0..y_dim).to_a.reverse.each do |j|
        if @grid[i][j].cell_state==1
          return i
        end
      end
    end
  end
  
   def get_right
    (0..y_dim).to_a.reverse.each do |i|
      (0..x_dim).to_a.reverse.each do |j|
        if @grid[j][i].cell_state==1
          return i
        end
      end
    end
  end
  
  
  def copy_grid grid_object
    i=0
    @grid.each do |x|
      j=0
       if i<@x_min
        i=i+1 
        next
      elsif i>=@x_dim
        break
      end
      x.each do |y|
         if j<@y_min
          j=j+1
          next
        elsif j>=@y_dim
          break
        end
        y.cell_state=grid_object.grid[i][j].cell_state
        j=j+1
      end
      i=i+1
    end
  end
  
  def update_grid(grid_object)
    @x_min=grid_object.x_min
    @y_min=grid_object.y_min
    @x_dim=grid_object.x_dim
    @y_dim=grid_object.y_dim
  end
  
  def shift_down
  end
  
  def shift_up
  end
  
  def shift_left
  end
  
  def shift_right
  end
  
  
end

class Game
    def initialize gen
        @generations=gen
    end
end


class Main  
    def multiline
        text="                            \n"
        while (txt = gets) != "*\n"
            text<<" " + txt
        end
        text << "                           \n"
        return text
    end

    def split_by_lines(string)
        lines=string.split(/\n/)
    end
    
    def split_by_nothing(string)
        chars=string.split(//)
    end
    
    def array_from_strings(lines)
        array=Array.new{Array.new}
        i=0
        lines.each do |line|
            array[i]=split_by_nothing(line)
            i=i+1
        end
        return array
    end
    
    def grid_from_array(array, x_min,y_min,x_dim,y_dim)
        grid=Array.new(x_dim+1000){Array.new(y_dim+1000){Cell.new(0)}}
        i=x_min
        array.each do |line|
            if i>=x_dim
              break
            end
            j=y_min
            line.each do |char|
               if j>=y_dim
                  break
                end
                if char=="o"
                    grid[i][j]=Cell.new(1)
                else
                    grid[i][j]=Cell.new(0)
                end
                    j=j+1
            end
            i=i+1
        end
        return grid
    end

end

controller=Main.new
puts "Enter number of generations"
gen=gets.to_i
puts "Enter the grid"
text=controller.multiline
lines=controller.split_by_lines text
array=controller.array_from_strings(lines)

xmin=100
ymin=100
grid_object=Grid.new
grid_object.grid=controller.grid_from_array(array, xmin,ymin,xmin+array.length,ymin+array[0].length)
grid_object.x_min=xmin
grid_object.y_min=ymin
grid_object.x_dim=grid_object.x_min + array.length
grid_object.y_dim=grid_object.y_min + array[0].length
new_grid_object=Grid.new
new_grid_object.grid=controller.grid_from_array(array, xmin,ymin,xmin+array.length,ymin+array[0].length)
new_grid_object.x_min=xmin
new_grid_object.y_min=ymin
new_grid_object.x_dim=new_grid_object.x_min + array.length
new_grid_object.y_dim=new_grid_object.y_min + array[0].length

#grid_object.display_grid

#binding.pry
gen.times do |x|
  temp_grid_object=grid_object
  #binding.pry
  grid_object=grid_object.change_grid(new_grid_object)
  #binding.pry
  new_grid_object=temp_grid_object
  #binding.pry
  temp_grid_object.copy_grid(grid_object)
  #binding.pry
  grid_object.display_grid
  sleep 0.5
end
