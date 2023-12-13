package util

import (
	"sort"
	"strconv"
)

const NumberChars = "1234567890"

func ConvertNumeric(s string) (i int) {
	i, err := strconv.Atoi(s)
	PanicOnError(err)
	return
}

func MaxInt(a, b int) int {
	if a > b {
		return a
	} else {
		return b
	}
}

func MinInt(a, b int) int {
	if a < b {
		return a
	} else {
		return b
	}
}

func MapStringsToIntegers(ss []string) []int {
	integers := make([]int, len(ss))
	for i, s := range ss {
		integers[i] = ConvertNumeric(s)
	}
	return integers
}

func IntSliceContainsInt(slice []int, number int) bool {
	idx := sort.SearchInts(slice, number)
	return idx < len(slice) && slice[idx] == number
}

func ChunkIntSlice(slice []int, chunkSize int) [][]int {
	var chunks [][]int
	for {
		if len(slice) == 0 {
			break
		}

		// necessary check to avoid slicing beyond
		// slice capacity
		if len(slice) < chunkSize {
			chunkSize = len(slice)
		}

		chunks = append(chunks, slice[0:chunkSize])
		slice = slice[chunkSize:]
	}

	return chunks
}