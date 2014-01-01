import random

class Tile:
   def __init__(self, x, y):
      self.x = x
      self.y = y

   def __str__(self):
      return "(" + str(self.x) + " ," + str(self.y) + ")"

   def __eq__(self, other):
      return self.x == other.x and self.y == other.y
   
   def __ne__(self, other):
      return not self.__eq__(other)

class Minesweeper:

   done = False
   moves = {}

   def __init__(self, x, y, mines):
      self.x = x
      self.y = y

      self.mines = []
      for x in range(0, self.x):
         for y in range(0, self.y):
            tile = Tile(x, y)
            self.mines.append(tile)
      random.shuffle(self.mines)
      self.mines = self.mines[0:10]

   def getMove(self):
      if len(self.moves) == (self.x*self.y)-len(self.mines):
         print("YOU WIN")
         self.done = True
         return

      x = int(input("x:"))
      y = int(input("y:"))
      tile = Tile(x, y)

      if str(tile) in self.moves:
         print("Tile already uncovered")
      
      if tile in self.mines:
         print("YOU LOSE")
         self.moves[str(tile)] = -1
         self.done = True
         print(self)
         return
      
      self.recurse(tile)

   def recurse(self, tile):
      if str(tile) in self.moves:
         return
      
      count = self.count(tile)
      self.moves[str(tile)] = count

      if count == 0:
         around = self.tilesAround(tile)
         for t in around:
            self.recurse(t)


   def count(self, tile):
      around = self.tilesAround(tile)

      count = 0
      for tile in around:
         if tile in self.mines:
            count += 1

      return count

   def tilesAround(self, tile):
      tiles = []
      up = tile.y-1
      down = tile.y+1
      right = tile.x+1
      left = tile.x-1

      if down < self.y:
         tiles.append(Tile(tile.x, down))
      if up >= 0:
         tiles.append(Tile(tile.x, up))
      if left >= 0:
         tiles.append(Tile(left, tile.y))
         if down < self.y:
            tiles.append(Tile(left, down))
         if up >= 0:
            tiles.append(Tile(left, up))
      if right < self.x:
         tiles.append(Tile(right, tile.y))
         if down < self.y:
            tiles.append(Tile(right, down))
         if up >= 0:
            tiles.append(Tile(right, up))
      
      return tiles

   def __str__(self):
      s = "  "
      for i in range(0, self.x):
         s += str(i) + " "

      s += "\n"

      for i in range(0, self.y):
         s += str(i) + " "
         for j in range(0, self.x):
            tile = Tile(j,i)
            if str(tile) in self.moves:
               val = self.moves[str(tile)]
               if val != -1:
                  s += str(val) + " "
               else:
                  s += "* "
            else:
               s += "+ "
         s += "\n"
      return s

game = Minesweeper(10, 10, 10)
while not game.done:
   print(game)
   game.getMove()
