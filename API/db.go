package main

import (
	"context"
	"database/sql"
	"fmt"
	"log"
	"time"

	"github.com/ClickHouse/clickhouse-go"
	_ "github.com/ClickHouse/clickhouse-go"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

func insertTimeSerial(info interface{}) {
	ctx, cancel := context.WithTimeout(context.Background(), 20*time.Second)
	defer cancel()
	client, err := mongo.Connect(ctx, options.Client().ApplyURI("mongodb://172.17.0.209:27017"))
	if err != nil {
		fmt.Println("err:", err)
	}

	collection := client.Database("demo").Collection("tcpvcon")
	collection.InsertOne(context.TODO(), info)
	client.Disconnect(ctx)
	log.Println("mongodb insert done.")

}

func insertAutoRun2MongoDB(info interface{}) {
	ctx, cancel := context.WithTimeout(context.Background(), 20*time.Second)
	defer cancel()
	client, err := mongo.Connect(ctx, options.Client().ApplyURI("mongodb://172.17.0.209:27017"))
	if err != nil {
		fmt.Println("err:", err)
	}

	collection := client.Database("demo").Collection("autorun")
	collection.InsertOne(context.TODO(), info)
	client.Disconnect(ctx)
	log.Println("autorun  insert  mongodb done.")

}

func insertSysmonMonogo(info interface{}, id uint) {
	println(info)
	ctx, cancel := context.WithTimeout(context.Background(), 20*time.Second)
	defer cancel()
	client, err := mongo.Connect(ctx, options.Client().ApplyURI("mongodb://172.17.0.209:27017"))
	if err != nil {
		fmt.Println("err:", err)
	}

	switch id {
	case 1:
		collection := client.Database("demo").Collection("id1")
		collection.InsertOne(context.TODO(), info)
	case 3:
		collection := client.Database("demo").Collection("id3")
		collection.InsertOne(context.TODO(), info)
	case 22:
		collection := client.Database("demo").Collection("id22")
		collection.InsertOne(context.TODO(), info)
	}

	log.Println("mongodb insert wineven done.")
	client.Disconnect(ctx)
}

func insertTcpvcon2ClickHouse(logData interface{}) {
	connect, err := sql.Open("clickhouse", "tcp://localhost:9000?debug=false&username=default&password=Cpp...&database=demo")
	if err != nil {
		log.Fatal(err)
	}
	if err := connect.Ping(); err != nil {
		if exception, ok := err.(*clickhouse.Exception); ok {
			fmt.Printf("[%d] %s \n%s\n", exception.Code, exception.Message, exception.StackTrace)
		} else {
			fmt.Println(err)
		}
		// return
	}
	tx, err := connect.Begin()
	if err != nil {
		log.Fatal(err)
	}

	stmt, err := tx.Prepare("INSERT INTO tcpvcon2 (Id,Message) VALUES (?, ?)")
	if err != nil {
		log.Fatal(err)
	}

	logs := logData.(ToCKLog)
	if _, err := stmt.Exec(
		logs.Id,
		logs.Message,
	); err != nil {
		log.Fatal(err)
	}

	if err := tx.Commit(); err != nil {
		log.Fatal(err)
	}

	// close db connection;

	if err = connect.Close(); err != nil {
		log.Fatal("close db err:", err)
	}

}

func insertWineventLog2ClickHouse(logData ToCKLog, id uint) {
	connect, err := sql.Open("clickhouse", "tcp://localhost:9000?debug=true&username=default&password=Cpp...&database=demo")
	if err != nil {
		log.Fatal(err)
	}
	if err := connect.Ping(); err != nil {
		if exception, ok := err.(*clickhouse.Exception); ok {
			fmt.Printf("[%d] %s \n%s\n", exception.Code, exception.Message, exception.StackTrace)
		} else {
			fmt.Println(err)
		}
		// return
	}
	tx, err := connect.Begin()
	if err != nil {
		log.Fatal(err)
	}

	switch id {
	case 1:
		stmt, err := tx.Prepare("INSERT INTO winevent1 (Id,Message) VALUES (?, ?)")
		if err != nil {
			log.Fatal(err)
		}
		if _, err := stmt.Exec(
			logData.Id,
			logData.Message,
		); err != nil {
			log.Fatal(err)
		}

		if err := tx.Commit(); err != nil {
			log.Fatal(err)
		}

		if err = connect.Close(); err != nil {
			log.Fatal("close db err:", err)
		}
		log.Println("winvent1 insert to clickhouse")
	case 3:
		stmt, err := tx.Prepare("INSERT INTO winevent3 (Id,Message) VALUES (?, ?)")
		if err != nil {
			log.Fatal(err)
		}
		if _, err := stmt.Exec(
			logData.Id,
			logData.Message,
		); err != nil {
			log.Fatal(err)
		}

		if err := tx.Commit(); err != nil {
			log.Fatal(err)
		}

		if err = connect.Close(); err != nil {
			log.Fatal("close db err:", err)
		}
		log.Println("winvent3 insert to clickhouse")
	}

}
