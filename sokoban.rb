#!/usr/bin/env ruby

require 'curses'
# require 'pry-byebug'

include Curses

class Man 
end

class Crate
end

class Tile
  attr_accessor :char
  def initialize(char)
    @char = char
  end

  def self.build_new(char)
    case char
    when "#"
      Wall.new(char)
    when "."
      Storage.new(char)
    when "@"
      o = OpenFloor.new(' ')
      o.man = Man.new
      yield(:man)
      o
    when "o"
      o = OpenFloor.new(' ')
      o.crate = Crate.new
      o
    else
      OpenFloor.new(char)
    end
  end

  def to_s
    char
  end
end

class Wall < Tile
  def has_crate?
    false
  end

  def is_wall?
    true
  end

  def is_empty?
    false
  end

  def is_storage?
    false
  end
end

class OpenFloor < Tile
  attr_accessor :man, :crate 

  def to_s
    return "@" if man
    return "o" if crate
    super
  end

  def has_crate?
    !!self.crate
  end

  def is_empty?
    !has_crate?
  end

  def is_wall?
    false
  end

  def is_storage?
    false
  end
end

class Storage < Tile
  attr_accessor :man, :crate

  def to_s
    return "+" if man
    return "*" if crate
    super
  end

  def has_crate?
    !!self.crate
  end

  def is_empty?
    !has_crate?
  end

  def is_wall?
    false
  end

  def is_storage?
    true
  end
end

class Board
  attr_accessor :grid, :current_x, :current_y
  def initialize(lines)
    @grid = {}
    y = 0
    lines.each do |line|
      @grid[y] ||= {}
      x = 0
      line.each_char do |char|
        @grid[y][x] = Tile.build_new(char) do |man|
          @current_x = x 
          @current_y = y
        end
        x += 1
      end
      y += 1
    end
  end

  def render  
    grid.each do |y, x_hash|
      setpos(y + 3, 0)
      str = ""
      x_hash.each do |x, tile|
        str << tile.to_s
      end
      addstr(str)
    end
    setpos(2, 0)
    addstr("Crates Left: #{crates_left}")
    refresh
  end

  def move(dx, dy)
    current_tile = grid[current_y][current_x] 
    new_tile = grid[current_y + dy][current_x + dx]
    return false if new_tile.is_wall?

    if new_tile.has_crate?
      # look at the next tile, no move if it's a wall or has crate
      next_tile = grid[current_y + dy*2][current_x + dx*2]
      return false unless next_tile.is_empty?
      # move the crate
      new_tile.crate = nil 
      next_tile.crate = Crate.new
    end
    # move the man
    current_tile.man = nil 
    new_tile.man = Man.new 
    # move the pointer
    self.current_y = self.current_y + dy
    self.current_x = self.current_x + dx
  end

  def up
    move(0, -1)
  end

  def right
    move(1, 0)
  end

  def down
    move(0, 1)
  end

  def left
    move(-1, 0)
  end

  def complete
    crates_left == 0
  end

  def crates_left
    total = 0
    # scan through all the tiles 
    grid.each do |k, v|
      v.each do |x, tile|
        total += 1 if tile.has_crate? && !tile.is_storage?
      end
    end
    total
  end
end

class Sokoban
  attr_accessor :levels, :current_level, :board

  def initialize(levels)
    @levels = levels
    @current_level = 1
  end

  def start
    lines = levels.take(current_level).last.reject { |l| l.chomp.empty? }.map { |l| l.chomp }
    self.board = Board.new(lines)
    clear
    setpos(0, 0)
    addstr("R to restart, N for next, B for back, arrow keys to play.")
    setpos(1, 0)
    addstr("Current Level: #{current_level}")
    board.render 
    while !board.complete
      get_move
      board.render 
    end
    success
    next_level
  end

  def success
    clear
    setpos(0, 0)
    addstr("Well done! Press any key to continue.")
    getch 
  end

  def next_level
    self.current_level += 1 unless current_level == levels.to_a.length
    start
  end

  def get_move
    move = getch
    case move
    when KEY_UP
      board.up
    when KEY_RIGHT
      board.right 
    when KEY_DOWN
      board.down 
    when KEY_LEFT
      board.left
    when 'r', 'R'
      start
    when 'n', 'N'
      self.current_level += 1 unless current_level == levels.to_a.length
      start
    when 'b', 'B'
      self.current_level -= 1 unless current_level == 1
      start
    end
  end
end

levels = File.readlines('levels.txt').slice_before { |line| line.chomp.empty? }

stdscr.keypad = true
init_screen
game = Sokoban.new(levels)
game.start

close_screen


