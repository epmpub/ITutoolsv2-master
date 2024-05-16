package main

import (
	"context"
	"database/sql"
	"fmt"
	"time"

	"github.com/ClickHouse/clickhouse-go"
	_ "github.com/ClickHouse/clickhouse-go"
	"github.com/gofiber/fiber/v2/log"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

func HardWareInventory2ClickHouse(logs ToCKLog) {
	connect, err := sql.Open("clickhouse", "tcp://localhost:9000?debug=false&username=default&password=Cpp...&database=demo")
	if err != nil {
		log.Info(err)
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
		log.Info(err)
	}

	stmt, err := tx.Prepare("INSERT INTO hardware_inventory (Id,Message) VALUES (?, ?)")
	if err != nil {
		log.Info(err)
	}

	if _, err := stmt.Exec(
		logs.Id,
		logs.Message,
	); err != nil {
		log.Info(err)
	}

	if err := tx.Commit(); err != nil {
		log.Info(err)
	}

	if err = connect.Close(); err != nil {
		log.Info("close db err:", err)
	}
	log.Debug("hardware inventory information insert clickhouse")
}

func SoftWareInventory2ClickHouse(logs ToCKLog) {
	connect, err := sql.Open("clickhouse", "tcp://localhost:9000?debug=false&username=default&password=Cpp...&database=demo")
	if err != nil {
		log.Info(err)
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
		log.Info(err)
	}

	stmt, err := tx.Prepare("INSERT INTO software_inventory (Id,Message) VALUES (?, ?)")
	if err != nil {
		log.Info(err)
	}

	if _, err := stmt.Exec(
		logs.Id,
		logs.Message,
	); err != nil {
		log.Info(err)
	}

	if err := tx.Commit(); err != nil {
		log.Info(err)
	}

	if err = connect.Close(); err != nil {
		log.Info("close db err:", err)
	}
	log.Debug("software inventory information insert clickhouse")
}

func mylog2ck(logData interface{}) {
	connect, err := sql.Open("clickhouse", "tcp://localhost:9000?debug=false&username=default&password=Cpp...&database=demo")
	if err != nil {
		log.Info(err)
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
		log.Info(err)
	}

	stmt, err := tx.Prepare("INSERT INTO mylog (Id,Message) VALUES (?, ?)")
	if err != nil {
		log.Info(err)
	}

	logs := logData.(ToCKLog)
	if _, err := stmt.Exec(
		logs.Id,
		logs.Message,
	); err != nil {
		log.Info(err)
	}

	if err := tx.Commit(); err != nil {
		log.Info(err)
	}

	if err = connect.Close(); err != nil {
		log.Info("close db err:", err)
	}
	log.Debug("My Log insert clickhouse")
}

func insert_app_sys_sec2ClickHouse(logData interface{}) {
	connect, err := sql.Open("clickhouse", "tcp://localhost:9000?debug=false&username=default&password=Cpp...&database=demo")
	if err != nil {
		log.Info(err)
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
		log.Info(err)
	}

	stmt, err := tx.Prepare("INSERT INTO app_sys_sec (Id,Message) VALUES (?, ?)")
	if err != nil {
		log.Info(err)
	}

	logs := logData.(ToCKLog)
	if _, err := stmt.Exec(
		logs.Id,
		logs.Message,
	); err != nil {
		log.Info(err)
	}

	if err := tx.Commit(); err != nil {
		log.Info(err)
	}

	if err = connect.Close(); err != nil {
		log.Info("close db err:", err)
	}
	log.Debug("app_sys_sec insert clickhouse")
}

// func insertTimeSerial(info interface{}) {
// 	ctx, cancel := context.WithTimeout(context.Background(), 20*time.Second)
// 	defer cancel()
// 	client, err := mongo.Connect(ctx, options.Client().ApplyURI("mongodb://172.17.0.209:27017"))
// 	if err != nil {
// 		fmt.Println("err:", err)
// 	}

// 	collection := client.Database("demo").Collection("tcpvcon")
// 	collection.InsertOne(context.TODO(), info)
// 	client.Disconnect(ctx)
// 	log.Debug("mongodb insert done.")

// }

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
	log.Debug("autorun  insert  mongodb done.")

}

// func insertSysmonMonogo(info interface{}, id uint) {
// 	println(info)
// 	ctx, cancel := context.WithTimeout(context.Background(), 20*time.Second)
// 	defer cancel()
// 	client, err := mongo.Connect(ctx, options.Client().ApplyURI("mongodb://172.17.0.209:27017"))
// 	if err != nil {
// 		fmt.Println("err:", err)
// 	}

// 	switch id {
// 	case 1:
// 		collection := client.Database("demo").Collection("id1")
// 		collection.InsertOne(context.TODO(), info)
// 	case 3:
// 		collection := client.Database("demo").Collection("id3")
// 		collection.InsertOne(context.TODO(), info)
// 	case 22:
// 		collection := client.Database("demo").Collection("id22")
// 		collection.InsertOne(context.TODO(), info)
// 	}

// 	log.Debug("mongodb insert wineven done.")
// 	client.Disconnect(ctx)
// }

func insertTcpvcon2ClickHouse(logData interface{}) {
	connect, err := sql.Open("clickhouse", "tcp://localhost:9000?debug=false&username=default&password=Cpp...&database=demo")
	if err != nil {
		log.Info(err)
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
		log.Info(err)
	}

	stmt, err := tx.Prepare("INSERT INTO tcpvcon2 (Id,Message) VALUES (?, ?)")
	if err != nil {
		log.Info(err)
	}

	logs := logData.(ToCKLog)
	if _, err := stmt.Exec(
		logs.Id,
		logs.Message,
	); err != nil {
		log.Info(err)
	}

	if err := tx.Commit(); err != nil {
		log.Info(err)
	}

	// close db connection;

	if err = connect.Close(); err != nil {
		log.Info("close db err:", err)
	}

}

func insertAutorun2ClickHouse(logs ToCKLog) {
	connect, err := sql.Open("clickhouse", "tcp://localhost:9000?debug=false&username=default&password=Cpp...&database=demo")
	if err != nil {
		log.Info(err)
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
		log.Info(err)
	}

	stmt, err := tx.Prepare("INSERT INTO autorun (Id,Message) VALUES (?, ?)")
	if err != nil {
		log.Info(err)
	}

	if _, err := stmt.Exec(
		logs.Id,
		logs.Message,
	); err != nil {
		log.Info(err)
	}

	if err := tx.Commit(); err != nil {
		log.Info(err)
	}

	// close db connection;

	if err = connect.Close(); err != nil {
		log.Info("close db err:", err)
	}

}

func insertWineventLog2ClickHouse(logData ToCKLog, id uint) {
	connect, err := sql.Open("clickhouse", "tcp://localhost:9000?debug=false&username=default&password=Cpp...&database=demo")
	if err != nil {
		log.Info(err)
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
		log.Info(err)
	}

	switch id {
	case 1:
		stmt, err := tx.Prepare("INSERT INTO winevent1 (Id,Message) VALUES (?, ?)")
		if err != nil {
			log.Info(err)
		}
		if _, err := stmt.Exec(
			logData.Id,
			logData.Message,
		); err != nil {
			log.Info(err)
		}

		if err := tx.Commit(); err != nil {
			log.Info(err)
		}

		if err = connect.Close(); err != nil {
			log.Info("close db err:", err)
		}
		log.Debug("winvent1 insert to clickhouse")
	case 3:
		stmt, err := tx.Prepare("INSERT INTO winevent3 (Id,Message) VALUES (?, ?)")
		if err != nil {
			log.Info(err)
		}
		if _, err := stmt.Exec(
			logData.Id,
			logData.Message,
		); err != nil {
			log.Info(err)
		}

		if err := tx.Commit(); err != nil {
			log.Info(err)
		}

		if err = connect.Close(); err != nil {
			log.Info("close db err:", err)
		}
	case 5:
		stmt, err := tx.Prepare("INSERT INTO winevent5 (Id,Message) VALUES (?, ?)")
		if err != nil {
			log.Info(err)
		}
		if _, err := stmt.Exec(
			logData.Id,
			logData.Message,
		); err != nil {
			log.Info(err)
		}

		if err := tx.Commit(); err != nil {
			log.Info(err)
		}

		if err = connect.Close(); err != nil {
			log.Info("close db err:", err)
		}
	case 11:
		stmt, err := tx.Prepare("INSERT INTO winevent11 (Id,Message) VALUES (?, ?)")
		if err != nil {
			log.Info(err)
		}
		if _, err := stmt.Exec(
			logData.Id,
			logData.Message,
		); err != nil {
			log.Info(err)
		}

		if err := tx.Commit(); err != nil {
			log.Info(err)
		}

		if err = connect.Close(); err != nil {
			log.Info("close db err:", err)
		}
	case 12:
		stmt, err := tx.Prepare("INSERT INTO winevent12 (Id,Message) VALUES (?, ?)")
		if err != nil {
			log.Info(err)
		}
		if _, err := stmt.Exec(
			logData.Id,
			logData.Message,
		); err != nil {
			log.Info(err)
		}

		if err := tx.Commit(); err != nil {
			log.Info(err)
		}

		if err = connect.Close(); err != nil {
			log.Info("close db err:", err)
		}
	case 22:
		stmt, err := tx.Prepare("INSERT INTO winevent22 (Id,Message) VALUES (?, ?)")
		if err != nil {
			log.Info(err)
		}
		if _, err := stmt.Exec(
			logData.Id,
			logData.Message,
		); err != nil {
			log.Info(err)
		}

		if err := tx.Commit(); err != nil {
			log.Info(err)
		}

		if err = connect.Close(); err != nil {
			log.Info("close db err:", err)
		}

	case 27:
		stmt, err := tx.Prepare("INSERT INTO winevent27 (Id,Message) VALUES (?, ?)")
		if err != nil {
			log.Info(err)
		}
		if _, err := stmt.Exec(
			logData.Id,
			logData.Message,
		); err != nil {
			log.Info(err)
		}

		if err := tx.Commit(); err != nil {
			log.Info(err)
		}

		if err = connect.Close(); err != nil {
			log.Info("close db err:", err)
		}

	}

}
