# Sokoban

## About

Best of Ruby Quiz, Chapter 11

This quiz is to implement the game of Sokoban with the interface of your choosing and any extra features you would like to have.

Sokoban (which translates to Warehouse Man) has simple rules, which basically amount to this: push crates into their storage spots in the warehouse.

The elements of the levels are simple: there’s a man, some crates and walls, open floor, and storage. Different level designers use various characters to represent these items in level data files. Here’s one possible set of symbols:

```
@       for the man
o       for crates
#       for walls
<space> for open floor
.       for storage
```

Now because a man or a crate can also be on a storage space, we need special conditions to represent those setups:

```
*       for crate on storage
+       for man on storage
```

Using this, we can build an extremely simple level:

```
#####
#.o@#
#####
```
This level is completely surrounded by walls, as all Sokoban levels must be. Walls are, of course, impassable. In the center we have from left to right: a storage space, a crate (on open floor), and the man (also on open floor).

The game is played by moving the man up, down, left and right. When the man moves toward a crate, he may push it along in front of him as long as there is no wall or second crate behind the one being pushed. A level is solved when all crates are on storage spaces.

Given those rules, we can solve our level with a single move to the left, yielding the following:

```
#####
#*@ #
#####
```

## Requirements

Ruby 2.2.2

## Notes

#### Some research about how to replace command line output from Ruby:

- To replace a single line, use print and subsequently "\r"
- To replace multiple lines, use Curses

## Usage

run `bundle install`

## Understanding the Question

## Results

```
R to restart, N for next, B for back, arrow keys to play.
Current Level: 3
Crates Left: 10
############
#..  #     ###
#..  # o  o  #
#..  #o####  #
#..    @ ##  #
#..  # #  o ##
###### ##o o #
  # o  o o o #
  #    #     #
  ############
```

## Review

Arrived at a solution, but quite verbose.

Consider separating out some responsibilities from the Board class. Right now it's taking on too much.

## License

This code is released under the [MIT License](http://www.opensource.org/licenses/MIT)


