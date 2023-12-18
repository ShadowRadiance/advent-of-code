package util

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

	var total T = values[0]
	for _, value := range values[1:] {
		total = operation(total, value)
	}
	return total
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
