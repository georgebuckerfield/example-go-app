package main

import (
	"fmt"
	"html/template"
	"log"
	"net/http"
	"os"
	//"golang.org/x/net/html"
)

type page struct {
	Title string
}

func main() {
	fmt.Println("starting basic http server")

	wd, err := os.Getwd()
	if err != nil {
		log.Fatal("unable to get current directory")
	}

	tmpl := template.Must(template.ParseFiles(fmt.Sprintf("%s/main.html", wd)))

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Printf("received request from %s\n", r.RemoteAddr)
		main := page{
			Title: "Homepage",
		}
		tmpl.Execute(w, main)
	})

	log.Fatal(http.ListenAndServe(":5000", nil))
}
