package main

import (
		"errors"
		"bufio"
)

func getMagic() string {
	return "P2"
}

func nextColor(r *bufio.Reader) (Color, error) {
	var current_int int
	var err error
	var color Color

	current_int, err = nextInt(r)
	color.r = current_int

	current_int, err = nextInt(r)
	color.g = current_int

	current_int, err = nextInt(r)
	color.b = current_int

	return color, err
}

func nextGray(r *bufio.Reader) (int, error) {
	return nextInt(r)
}

func writeColor(c Color) error {
	return errors.New("Not implemented yet")
}

func writeGray(c int, w *bufio.Writer) error {
	err := writeInt(c, w)

	return err
}