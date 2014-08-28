package main

import (
		"strings"
		"errors"
		"bufio"
		"bytes"
		"io"
		"strconv"
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

    fileHandler_read, err := os.Open(fileName)
	defer fileHandler_read.Close()

    if err != nil {
        return nil, errors.New("IOException")
    }

	reader := bufio.NewReader(fileHandler_read)

    switch fileType {
    	case "PGM":
    		pgm := PGMParser{"P2", []float32{0.3, 0.59, 0.11}}
    		return parseGray(&pgm, reader)
    	case "PPM":
    		ppm := PPMParser{"P6"}
    		return parseGray(&ppm, reader)
    }

    return nil, errors.New("Cannot extract data" + fileName)
}

func readImage(fileName string) ([][]Color, error) {
    fileType, _ := parseFileName(fileName)

    fileHandler_read, err := os.Open(fileName)
	defer fileHandler_read.Close()

    if err != nil {
        return nil, errors.New("IOException")
    }

	reader := bufio.NewReader(fileHandler_read)

    switch fileType {
    	case "PGM":
    		pgm := PGMParser{"P2", []float32{0.3, 0.59, 0.11}}
    		return parse(&pgm, reader)
    	case "PPM":
    		ppm := PPMParser{"P6"}
    		return parse(&ppm, reader)
    }

    return nil, errors.New("Cannot extract data" + fileName)
}



// func parse(r *bufio.Reader, next func(r *bufio.Reader) (Color)) ([][]Color, error) {
func parse(pxmParser PXMParser, r *bufio.Reader) ([][]Color, error) {
	var current_int int
	var current_color Color
	magic, _ := checkMagic(r, pxmParser.getMagic())
	if magic {
		// Skip line
		readRune(r)
		current_int, _ = nextInt(r)
		width := current_int
		current_int, _ = nextInt(r)
		height := current_int
		nextInt(r) // max

		// 2-dimensional array
	    ret := make([][]Color, width)
	    for i := range ret {
	        ret[i] = make([]Color, height)
	    }

	    for h := 0; h < height; h++ {
	    	for w := 0; w < width; w++ {
	    		current_color,_ = pxmParser.nextColor(r);
	    		ret[w][h] = current_color
	    	}
	    }

	    return ret, nil
	}

	return nil, errors.New("Cannot parse data")
}

// func parseGray(r *bufio.Reader, next func(r *bufio.Reader) (int)) ([][]int, error) {
func parseGray(pxmParser PXMParser, r *bufio.Reader) ([][]int, error) {
	var current_int int
	var current_gray int
	magic, _ := checkMagic(r, pxmParser.getMagic())
	if magic {
		// Skip line
		readRune(r)

		current_int, _ = nextInt(r)
		width := current_int
		current_int, _ = nextInt(r)
		height := current_int

		nextInt(r) // max

		// 2-dimensional array
	    ret := make([][]int, width)
	    for i := range ret {
	        ret[i] = make([]int, height)
	    }

	    for h := 0; h < height; h++ {
	    	for w := 0; w < width; w++ {
	    		current_gray,_ = pxmParser.nextGray(r)
	    		ret[w][h] = current_gray
	    	}
	    }

		return ret, nil
	} 

	return nil, errors.New("Cannot parse data")
}

func writeGrayImage(fileName string, image [][]int) error {
	fileType, _ := parseFileName(fileName)

	fileHandler_write, err := os.Create(fileName)
	defer fileHandler_write.Close()

    if err != nil {
        return errors.New("IOException")
    }

	writer := bufio.NewWriter(fileHandler_write)

    switch fileType {
    	case "PGM":
    		pgm := PGMParser{"P2", []float32{0.3, 0.59, 0.11}}
    		_, err := serializeGray(&pgm, image, writer)
    		return err
    	case "PPM":
    		ppm := PPMParser{"P6"}
    		_, err := serializeGray(&ppm, image, writer)
    		return err
    }

    return errors.New("Cannot write data" + fileName)
}

func writeImage(fileName string, image [][]Color) error {
    fileType, _ := parseFileName(fileName)

	fileHandler_write, err := os.Create(fileName)
	defer fileHandler_write.Close()

    if err != nil {
        return errors.New("IOException")
    }

	writer := bufio.NewWriter(fileHandler_write)

    switch fileType {
    	case "PGM":
    		pgm := PGMParser{"P2", []float32{0.3, 0.59, 0.11}}
    		_, err := serialize(&pgm, image, writer)
    		return err
    	case "PPM":
    		ppm := PPMParser{"P6"}
    		_, err := serialize(&ppm, image, writer)
    		return err
    }

    return errors.New("Cannot write data" + fileName)
}

func checkMagic(r *bufio.Reader, magic string) (bool, error) {
	buf := make([]byte, len(magic))

	_, err := r.Read(buf)

	return string(buf) == magic, err
}

func readRune(r *bufio.Reader) (rune, error) {
	buf := make([]byte, 1)

	_, err := r.Read(buf)

	return bytes.Runes(buf)[0], err
}

func nextInt(r *bufio.Reader) (int, error) {
	ret := 0
	ack, err := readRune(r)

	for {
		if(err == io.EOF || (ack >= '0' && ack <= '9')) {
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
	_, err := w.WriteString(strconv.Itoa(value))
	return err
}

func serialize(pxmParser PXMParser, image [][]Color, writer *bufio.Writer) (*bufio.Writer, error) {
	max := "255";

	width := len(image)
	height := len(image[0])

	magic := pxmParser.getMagic()
	writer.WriteString(magic + "\n")

	writer.WriteString(strconv.Itoa(width) + " ")
	writer.WriteString(strconv.Itoa(height)  + "\n")

	writer.WriteString(max + "\n")

	for h := 0; h < height; h++ {
    	for w := 0; w < width; w++ {
    		pxmParser.writeColor(image[w][h], writer);
    	}
    	writer.WriteString("\n")
    }

	writer.Flush()

	return writer, nil
}

func serializeGray(pxmParser PXMParser, image [][]int, writer *bufio.Writer) (*bufio.Writer, error) {
	max := "255";

	width := len(image)
	height := len(image[0])

	magic := pxmParser.getMagic()
	writer.WriteString(magic + "\n")

	writer.WriteString(strconv.Itoa(width) + " ")
	writer.WriteString(strconv.Itoa(height)  + "\n")

	writer.WriteString(max + "\n")

	for h := 0; h < height; h++ {
    	for w := 0; w < width; w++ {
    		pxmParser.writeGray(image[w][h], writer);
    		writer.WriteString("\n")
    	}
    }

	writer.Flush()

	return writer, nil
}