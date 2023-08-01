package main

import (
	"database/sql"
	"encoding/json"
	"log"
	"net/http"
	"os"

	_ "github.com/mattn/go-sqlite3"
)

var db *sql.DB
var err error

func main() {
	setupDB()
	runHTTPServer()
}

type httpSDData struct {
	Targets []string          `json:"targets"`
	Labels  map[string]string `json:"labels"`
}

func setupDB() {
	os.Remove("./http_sd.db")

	db, err = sql.Open("sqlite3", "./http_sd.db")
	if err != nil {
		log.Fatalln(err)
	}

	tableCreate := `
    create table hosts (id integer not null primary key, name text, ip text);
    delete from hosts;
    `

	_, err = db.Exec(tableCreate)
	if err != nil {
		log.Fatalf("%q: %s\n", err, tableCreate)
	}

	tx, err := db.Begin()
	if err != nil {
		log.Fatalln(err)
	}
	tableInserts, err := tx.Prepare(`insert into hosts (name, ip) values (?, ?)`)
	if err != nil {
		log.Fatalln(err)
	}
	for name, ip := range map[string]string{"web1.example.com": "192.168.1.39", "web2.example.com": "192.168.1.40"} {
		_, err := tableInserts.Exec(name, ip)
		if err != nil {
			log.Fatalf("%q: Couldn't insert %s %s\n", err, name, ip)
		}
	}
	if err = tx.Commit(); err != nil {
		log.Fatalln(err)
	}
	log.Println("Bootstrapped database.")
}

func runHTTPServer() {
	handler := func(w http.ResponseWriter, r *http.Request) {
		res := []httpSDData{}
		i := 0
		rows, err := db.Query(`select name, ip from hosts`)
		if err != nil {
			log.Fatalf("Couldn't query hosts table: %q", err)
		}
		defer rows.Close()
		for rows.Next() {
			var host string
			var ip string
			err = rows.Scan(&host, &ip)
			if err != nil {
				log.Fatalln(err)
			}
			res = append(res, httpSDData{})
			res[i].Targets = append(res[i].Targets, ip)
			res[i].Labels = map[string]string{"instance": host}
			i++
		}
		encRes, err := json.Marshal(res)
		if err != nil {
			log.Fatalln(err)
		}
		w.Header().Set("Content-Type", "application/json")
		_, err = w.Write(encRes)
		if err != nil {
			log.Fatalln(err)
		}
	}
	http.HandleFunc("/targets", handler)
	http.ListenAndServe("0.0.0.0:8888", nil)
}
