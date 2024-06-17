package main

import (
	"database/sql"
	"fmt"

	"github.com/ClickHouse/clickhouse-go"
	"github.com/gofiber/fiber/v2/log"
)

func HardWareInventory2ClickHouse(logs ToCKLog) {
	connStringv1 := "tcp://localhost:9000?&database=demo&username=default&password=Cpp...&secure=false&compress=false&debug=false"
	// connStringv2 := "clickhouse://default:Cpp...@localhost:9000/demo"
	connect, err := sql.Open("clickhouse", connStringv1)
	if err != nil {
		log.Info(err)
	}
	if err := connect.Ping(); err != nil {
		if exception, ok := err.(*clickhouse.Exception); ok {
			fmt.Printf("[%d] %s \n%s\n", exception.Code, exception.Message, exception.StackTrace)
		} else {
			fmt.Println(err)
		}
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
}

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
