package main

import (
		"bufio"
)

type PGMParser struct { 
    magic string
    ratio []float32
}

func (pgm *PGMParser) getMagic() string {
    return pgm.magic
}

func (pgm *PGMParser) nextColor(r *bufio.Reader) (Color, error) {
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

func (pgm *PGMParser) nextGray(r *bufio.Reader) (int, error) {
	return nextInt(r)
}

func (pgm *PGMParser) writeColor(c Color, w *bufio.Writer) error {
	val := int(pgm.ratio[0]) * c.r + int(pgm.ratio[1]) * c.g + int(pgm.ratio[2]) * c.b
	err := writeInt(val, w);
	return err
}

func (pgm *PGMParser) writeGray(c int, w *bufio.Writer) error {
	err := writeInt(c, w)

	return err
}