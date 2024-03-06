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

}

func insertMyLog(logData MyLog) {
	ctx, cancel := context.WithTimeout(context.Background(), 20*time.Second)
	defer cancel()
	client, err := mongo.Connect(ctx, options.Client().ApplyURI("mongodb://172.17.0.209:27017"))
	if err != nil {
		fmt.Println("err:", err)
	}

	collection := client.Database("MyLog").Collection("log")
	collection.InsertOne(context.TODO(), logData)
}

func insertMyLog2ClickHouse(logData ToCKLog) {
	connect, err := sql.Open("clickhouse", "tcp://172.17.0.210:9000?debug=true&username=default&password=Cpp...&database=demo")
	if err != nil {
		log.Fatal(err)
	}
	if err := connect.Ping(); err != nil {
		if exception, ok := err.(*clickhouse.Exception); ok {
			fmt.Printf("[%d] %s \n%s\n", exception.Code, exception.Message, exception.StackTrace)
		} else {
			fmt.Println(err)
		}
		return
	}
	tx, err := connect.Begin()
	if err != nil {
		log.Fatal(err)
	}
	stmt, err := tx.Prepare("INSERT INTO tcpvcon2 (Id,Message) VALUES (?, ?)")
	if err != nil {
		log.Fatal(err)
	}

	// if _, err := stmt.Exec(
	// 	logData.Timestamp,
	// 	logData.Level,
	// 	logData.HostName,
	// 	logData.Message,
	// ); err != nil {
	// 	log.Fatal(err)
	// }
	if _, err := stmt.Exec(
		logData.Id,
		logData.Message,
	); err != nil {
		log.Fatal(err)
	}

	if err := tx.Commit(); err != nil {
		log.Fatal(err)
	}

}
