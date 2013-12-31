#!/usr/bin/env ruby

class Tile

   attr_accessor :x, :y

   def initialize(x, y)
      @x, @y = x, y
   end #initialize

   def to_s
      "(#{@x}, #{@y})"
   end #to_s

   def ==(other)
      @x==other.x && @y==other.y
   end #==

   def eql?(other)
      @x==other.x && @y==other.y
   end #eql?

   def hash
      [@x, @y]
   end #hash

end #class tile

class Minesweeper

   attr_accessor :done

   def initialize(x, y, mines)
      @x = x
      @y = y

      @mines = []
      for i in 0..y-1
         for j in 0..x-1
            tile = Tile.new(j, i)
            @mines.push(tile)
         end
      end
      @mines = @mines.shuffle
      @mines = @mines.first(mines)

      @moves = {}

      @done = false
   end #initialize

   def getMove
      if @moves.size == ((@x*@y)-@mines.length)
         puts "YOU WIN"
         @done = true
         return
      end

      puts "x:"
      x = gets.chomp.to_i
      puts "y:"
      y = gets.chomp.to_i 
      tile = Tile.new(x, y)

      if @moves.include?(tile.hash)
         puts "Tile already uncovered"
         return
      end

      if @mines.include?(tile)
         puts "YOU LOSE"
         @moves[tile.hash] = -1
         @done = true
         puts to_s
         return 
      end
      
      recurse(tile)
   end #getMove

   def recurse(tile)
      if @moves.include?(tile.hash)
         return
      end

      count = count(tile)
      @moves[tile.hash] = count

      if count == 0
         around = tilesAround(tile)
         around.each do |t|
            recurse(t)
         end
      end
   end #recurse

   def count(tile)
      around = tilesAround(tile)

      count = 0 
      around.each do |tile|
         if @mines.include?(tile)
            count = count + 1
         end
      end

      count
   end #count

   def tilesAround(tile)
      tiles = []
      up = tile.y-1
      down = tile.y+1
      right = tile.x+1
      left = tile.x-1

      if left >= 0
         tiles.push(Tile.new(left, tile.y))
         if down < @y
            tiles.push(Tile.new(left, down))
         end
         if up >= 0
            tiles.push(Tile.new(left, up))
         end
      end
      if right < @x
         tiles.push(Tile.new(right, tile.y))
         if down < @y
            tiles.push(Tile.new(right, down))
         end
         if up >= 0
            tiles.push(Tile.new(right, up))
         end
      end
      if down < @y
         tiles.push(Tile.new(tile.x, down))
      end
      if up >= 0
         tiles.push(Tile.new(tile.x, up))
      end

      tiles
   end #tilesAround
 
   def to_s
      s = "   "
      for i in 0..@x-1
         s = s + "#{i} "
      end
      s = s + "\n"

      for i in 0..@y-1
         s = s + "#{i}  "
         for j in 0..@x-1
            tile = Tile.new(j, i)
            if @moves.include?(tile.hash)
               val = @moves.fetch(tile.hash)
               if val != -1
                  s = s + "#{val} "
               else
                  s = s + "* "
               end
            else
               s = s + "+ "
            end
         end
         s = s + "\n"
      end
      s
   end #to_s 

end #class minesweeper




# GAME LOOP #

game = Minesweeper.new(10, 10, 10)
while !game.done
   puts game
   game.getMove
end
