#!/usr/bin/env ruby

require 'pp'
require 'gosu'

class MyWindow < Gosu::Window
  def initialize
    super(800,800,false)
    self.caption = "Snake"
    @board_length = 100
    @font = Gosu::Font.new(self,"Arial",14)
    @square_length = 8 
    @board = [] 
    @movement_delay = 0.05
    @last_moved = Time.now
    for i in 0..@board_length
      row = []
      for j in 0..@board_length
        row.push 0
      end
      @board.push row
    end
    @snake = [[@board_length/2,@board_length/2],[@board_length/2+1,@board_length/2],[@board_length/2+2,@board_length/2]]
    @snake_direct = "up"
    @bit = [Random.rand(@board_length), Random.rand(@board_length)]
    @last = [@board_length/2+2,@board_length/2]
    @score = 0
  end

  def update()
    if button_down? Gosu::KbLeft
      if @snake_direct != "right"
        @snake_direct = "left"
      end
    end
    if button_down? Gosu::KbRight
      if @snake_direct != "left"
        @snake_direct = "right"
      end
    end
    if button_down? Gosu::KbUp
      if @snake_direct != "down"
        @snake_direct = "up"
      end
    end
    if button_down? Gosu::KbDown
      if @snake_direct != "up"
        @snake_direct = "down"
      end
    end
    if Time.now - @last_moved > @movement_delay
      if button_down? Gosu::KbEscape
        close
      end
      if @snake_direct == "up"
        if @snake[0][0] == 0
          close
        end
        new_head = [@snake[0][0]-1,@snake[0][1]]
      end
      if @snake_direct == "left"
        if @snake[0][1] == 0
          close
        end
        new_head = [@snake[0][0],@snake[0][1]-1]
      end
      if @snake_direct == "right"
        if @snake[0][1] == @board_length-1
          close
        end
        new_head = [@snake[0][0],@snake[0][1]+1]
      end
      if @snake_direct == "down"
        if @snake[0][0] == @board_length-1
          close
        end
        new_head = [@snake[0][0]+1,@snake[0][1]]
      end
      @snake.pop
      @snake = [new_head] + @snake
      @last = @snake[@snake.length-1]
      @last_moved = Time.now
    end
    if @snake[0][0] == @bit[0] and @snake[0][1] == @bit[1]
      @score += 1
      @movement_delay -= 0.001
      @snake.push @last
      in_snake = true
      while in_snake
        @bit = [Random.rand(@board_length), Random.rand(@board_length)]
        if not @snake.include? @bit
          in_snake = false
        end
      end
    end
  end

  def draw()
    clearBoard()
    @snake.each do |point| 
      @board[point[0]][point[1]] = 1
    end
    @board[@bit[0]][@bit[1]] = 2
    black = Gosu::Color.argb(0xff000000)
    green = Gosu::Color.argb(0xff00ff00)
    red = Gosu::Color.argb(0xffff0000)
    for i in 0..@board_length
      for j in 0..@board_length
        if @board[i][j] == 0
          draw_quad(j*@square_length,i*@square_length,black,j*@square_length+@square_length,i*@square_length,black,j*@square_length+@square_length,i*@square_length+@square_length,black,j*@square_length,i*@square_length+@square_length,black)
        end
        if @board[i][j] == 1
          draw_quad(j*@square_length,i*@square_length,green,j*@square_length+@square_length,i*@square_length,green,j*@square_length+@square_length,i*@square_length+@square_length,green,j*@square_length,i*@square_length+@square_length,green)
        end
        if @board[i][j] == 2
          draw_quad(j*@square_length,i*@square_length,red,j*@square_length+@square_length,i*@square_length,red,j*@square_length+@square_length,i*@square_length+@square_length,red,j*@square_length,i*@square_length+@square_length,red)
        end
      end
    end
    @font.draw("#{@score}",10,10,1.0,1.0,1.0,Gosu::Color::WHITE)
  end

  def clearBoard()
    for i in 0..@board_length
      for j in 0..@board_length
        @board[i][j] = 0
      end
    end
  end
end

window = MyWindow.new
window.show
