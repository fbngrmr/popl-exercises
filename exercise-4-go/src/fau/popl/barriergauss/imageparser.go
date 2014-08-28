package main

import (
		"strings"
		"errors"
		"bufio"
		"os"
)
 
func parseFileName(fileName string) (string, error) {
	sepPos := strings.LastIndex(fileName, ".")
	extension := fileName[sepPos:]

	if(extension == ".pgm") {
		return "PGM", nil
	} else if(extension == ".ppm") {
		return "PPM", nil
	} else {
		return "", errors.New("IllegalArgument: Unknown ImageType")
	}
}

func readGrayImage(fileName string) ([][]int, error) {
    fileType, _ := parseFileName(fileName)

    switch fileType {
    	case "PGM":
    		return colors, nil
    	case "PPM":
    		return colors, nil
    }

    return nil, errors.New("Cannot extract data" + fileName)
}

func readImage(fileName string) ([][]Color, error) {
    fileType, _ := parseFileName(fileName)

    switch fileType {
    	case "PGM":
    		return colors, nil
    	case "PPM":
    		return colors, nil
    }

    return nil, errors.New("Cannot extract data" + fileName)
}

//

func parse(r *bufio.Reader, next func(r *bufio.Reader) (Color)) ([][]Color, error) {
	if checkMagic(r) {
		// Skip line
		readRune(r)
		width := nextInt(r)
		height := nextInt(r)
		nextInt(r) // max

		// 2-dimensional array
	    ret := make([][]Color, width)
	    for i := range ret {
	        ret[i] = make([]Color, height)
	    }

	    for h := 0; h < height; h++ {
	    	for w := 0; w < width; w++ {
	    		ret[w][h] = nextColor(r);
	    	}
	    }

	    return ret, nil
	}

	return nil, errors.New("Cannot parse data" + fileName)
}

func parseGray(r *bufio.Reader, next func(r *bufio.Reader) (int)) ([][]int, error) {
	if checkMagic(r) {
		// Skip line
		readRune(r)
		width := nextInt(r)
		height := nextInt(r)
		nextInt(r) // max

		// 2-dimensional array
	    ret := make([][]int, width)
	    for i := range ret {
	        ret[i] = make([]int, height)
	    }

	    for h := 0; h < height; h++ {
	    	for w := 0; w < width; w++ {
	    		ret[w][h] = nextGray(r);
	    	}
	    }

		return ret, nil
	} 

	return nil, errors.New("Cannot parse data" + fileName)
}

func writeGrayImage(fileName string, image int[][]) error {
	fileType, _ := parseFileName(fileName)

    switch fileType {
    	case "PGM":
    		return colors, nil
    	case "PPM":
    		return colors, nil
    }

    return nil, errors.New("Cannot write data" + fileName)
}

func writeImage(fileName string, image Color[][]) error {
    fileType, _ := parseFileName(fileName)

    switch fileType {
    	case "PGM":
    		return colors, nil
    	case "PPM":
    		return colors, nil
    }

    return nil, errors.New("Cannot write data" + fileName)
}

func checkMagic(s *bufio.Reader, magic string) (bool, error) {
	buf := make([]byte, len(magic))

	_, err := r.Read(buf)

	return string(buf) == magic, err
}

func nextInt(r *bufio.Reader) (int, error) {
	ret := 0
	ack, err := readRune(r)

	for {
		if(err == io.EOF || (ack > '0' && ack < '9')) {
			break
		} else {
			ack, err = readRune(r)
		}
	}

	for {
		if(ack >= '0' && ack <= '9') {
			ret = 10 * ret + int(ack - '0')
			ack, err = readRune(r)
		} else {
			break
		}
	}

	return ret, err
}

func writeInt(value int, w *bufio.Writer) error {
	_, err := w.WriteString(" " + strconv.Itoa(value))
	return error
}

func serialize(c [][]Color, w *bufio.Writer) (*bufio.Writer, error) {
	max := 255;

	width := len(image)
	height := len(image[0])

	w.WriteString("P6\n")

	w.WriteString(strconv.Itoa(width))
	w.WriteString(strconv.Itoa(height)  + "\n")

	w.WriteString(string(max) + "\n")

	for h := 0; h < height; h++ {
    	for w := 0; w < width; w++ {
    		writeColor(ret[w][h]);
    	}
    	w.WriteString("\n")
    }

	w.Flush()

	return w, nil
}

func serializeGray(c [][]int, w *bufio.Writer) (*bufio.Writer, error) {
	max := 255;

	width := len(image)
	height := len(image[0])

	w.WriteString("P6\n")

	w.WriteString(strconv.Itoa(width))
	w.WriteString(strconv.Itoa(height)  + "\n")

	w.WriteString(string(max) + "\n")

	for h := 0; h < height; h++ {
    	for w := 0; w < width; w++ {
    		writeGray(ret[w][h]);
    	}
    	w.WriteString("\n")
    }

	w.Flush()

	return w, nil
}