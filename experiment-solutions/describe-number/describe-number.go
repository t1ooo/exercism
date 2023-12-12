package go1a

import "strconv"
import "strings"

type Unit struct {
	unit int;
	desc string
}

var units = []Unit {
	{144, "gross"},
	{20, "score"},
	{12, "dozen"},
}

// Describe provides an assortment of human-readable representation of numbers.
func Describe(number int) string {
	var r []string;
	for _,v := range units {
		if number % v.unit == 0 {
			s := strconv.Itoa(number / v.unit) + " " + v.desc
			r = append(r, s)
		}
	}
	r = append(r, strconv.Itoa(number))
	return strings.Join(r, " or ")
}
