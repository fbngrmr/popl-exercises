package main

func getMagic() string {
	return "P2"
}

func nextColor(r *bufio.Reader) (Color, error) {
	var color Color
	color.r, err = nextInt(r)
	color.g = nextInt(r) 
	color.b = nextInt(r) 
	return color, err
}

func nextGray(r *bufio.Reader) (int, error) {

}

func writeColor(c Color) error {

}

func writeGray(c int) error {

}