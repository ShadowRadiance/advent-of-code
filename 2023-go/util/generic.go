package util

import "github.com/shadowradiance/advent-of-code/2023-go/util/constraints"

func Filter[T any](ss []T, test func(T) bool) (ret []T) {
	for _, item := range ss {
		if test(item) {
			ret = append(ret, item)
		}
	}
	return
}

func Accumulate[T any](values []T, operation func(a T, b T) T) T {
	if len(values) < 1 {
		panic("util.Accumulate: empty list")
	}

	var total = values[0]
	for _, value := range values[1:] {
		total = operation(total, value)
	}
	return total
}

func Transform[T any, U any](values []T, operation func(item T) U) []U {
	// example: Transform(blocks, func(s string) int { return s(item) })
	result := make([]U, 0)
	for _, value := range values {
		result = append(result, operation(value))
	}
	return result
}
func TransformWithIndex[T any, U any](values []T, operation func(item T, index int) U) []U {
	// example: Transform(blocks, func(s string) int { return s(item) })
	result := make([]U, 0)
	for index, value := range values {
		result = append(result, operation(value, index))
	}
	return result
}

func All[T any](values []T, predicate func(value T) bool) bool {
	for _, value := range values {
		if !predicate(value) {
			return false
		}
	}
	return true
}

func Any[T any](values []T, predicate func(value T) bool) bool {
	for _, value := range values {
		if predicate(value) {
			return true
		}
	}
	return false
}

func None[T any](values []T, predicate func(value T) bool) bool {
	for _, value := range values {
		if predicate(value) {
			return false
		}
	}
	return true
}

func Abs[T constraints.Signed](value T) T {
	if value < 0 {
		return -value
	}
	return value
}

func MapValues[M ~map[K]V, K comparable, V any](m M) (values []V) {
	values = make([]V, len(m))
	i := 0
	for _, v := range m {
		values[i] = v
		i++
	}
	return
}

func MapKeys[M ~map[K]V, K comparable, V any](m M) (keys []K) {
	keys = make([]K, len(m))
	i := 0
	for k := range m {
		keys[i] = k
		i++
	}
	return
}
