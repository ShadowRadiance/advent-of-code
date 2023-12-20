package aoc

import (
	"github.com/shadowradiance/advent-of-code/2023-go/days"
	"github.com/shadowradiance/advent-of-code/2023-go/days/day01"
	"github.com/shadowradiance/advent-of-code/2023-go/days/day02"
	"github.com/shadowradiance/advent-of-code/2023-go/days/day03"
	"github.com/shadowradiance/advent-of-code/2023-go/days/day04"
	"github.com/shadowradiance/advent-of-code/2023-go/days/day05"
	"github.com/shadowradiance/advent-of-code/2023-go/days/day06"
	"github.com/shadowradiance/advent-of-code/2023-go/days/day07"
	"github.com/shadowradiance/advent-of-code/2023-go/days/day08"
	"github.com/shadowradiance/advent-of-code/2023-go/days/day09"
	"github.com/shadowradiance/advent-of-code/2023-go/days/day10"
	"github.com/shadowradiance/advent-of-code/2023-go/days/day11"
	"github.com/shadowradiance/advent-of-code/2023-go/days/day12"
	"github.com/shadowradiance/advent-of-code/2023-go/days/day13"
)

func Available() []days.DayInterface {
	return []days.DayInterface{
		day01.Solution{},
		day02.Solution{},
		day03.Solution{},
		day04.Solution{},
		day05.Solution{},
		day06.Solution{},
		day07.Solution{},
		day08.Solution{},
		day09.Solution{},
		day10.Solution{},
		day11.Solution{},
		day12.Solution{},
		day13.Solution{},
	}
}