package main

import (
	"encoding/json"
	"os"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/log"
)

type MyLog struct {
	Timestamp time.Time `json:"timestamp" bson:"timestamp"`
	Level     string    `json:"level" bson:"level"`
	HostName  string    `json:"hostname"`
	Message   string    `json:"message"`
}

type ToCKLog struct {
	Id      string `json:"id" bson:"id"`
	Message string `json:"message"`
}

func main() {

	app := fiber.New()

	// Home Page
	app.Static("/", "../public")
	app.Post("/mongodb", func(c *fiber.Ctx) error {
		//insert data to mongodb
		var data interface{}
		err := json.Unmarshal(c.BodyRaw(), &data)
		if err != nil {
			log.Info("err:", err)
		}
		insertTimeSerial(data)

		return c.Send(c.BodyRaw())
	})

	//windows application system security log to clickhouse
	app.Post("/app_sys_sec", func(c *fiber.Ctx) error {
		//write log to clickhouse server
		var cklog ToCKLog
		err := json.Unmarshal(c.BodyRaw(), &cklog)
		if err != nil {
			log.Info("err:", err)
		}
		log.Info(cklog.Id)
		log.Info(cklog.Message)

		insert_app_sys_sec2ClickHouse(cklog)

		return c.Send(c.BodyRaw())
	})

	// tcpvcon to ClickHouse

	app.Post("/ck", func(c *fiber.Ctx) error {
		//write log to clickhouse server
		var cklog ToCKLog
		err := json.Unmarshal(c.BodyRaw(), &cklog)
		if err != nil {
			log.Info("err:", err)
		}
		log.Info(cklog.Id)
		log.Info(cklog.Message)
		insertTcpvcon2ClickHouse(cklog)

		return c.Send(c.BodyRaw())
	})

	// Windows OS support

	//main menu
	app.Get("/win", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/win.ps1")
	})

	app.Get("/app_sys_sec", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/app_sys_sec.ps1")
	})

	app.Get("/installSysmon", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/winSysmon.ps1")
	})

	app.Get("/winevent", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/winEvent.ps1")
	})

	//for powershell call, sysmon log to clickhouse (id:1,3,22)

	app.Get("/sysmon/1", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/sysmon2ckid1.ps1")
	})

	app.Get("/sysmon/3", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/sysmon2ckid3.ps1")
	})

	app.Get("/sysmon/22", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/sysmon2ckid22.ps1")
	})

	// for powershell script call API , sysmon type id=1,3,22 to ClickHouse

	app.Post("/sysmon_id1", func(c *fiber.Ctx) error {
		//write log to clickhouse server
		var cklog ToCKLog
		err := json.Unmarshal(c.BodyRaw(), &cklog)
		if err != nil {
			log.Info("err:", err)
		}
		log.Info(cklog.Id)
		log.Info(cklog.Message)
		insertWineventLog2ClickHouse(cklog, 1)

		return c.Send(c.BodyRaw())
	})

	// winevent sysmon type id=3 to ClickHouse

	app.Post("/sysmon_id3", func(c *fiber.Ctx) error {
		//write log to clickhouse server
		var cklog ToCKLog
		err := json.Unmarshal(c.BodyRaw(), &cklog)
		if err != nil {
			log.Info("err:", err)
		}
		log.Info(cklog.Id)
		log.Info(cklog.Message)
		insertWineventLog2ClickHouse(cklog, 3)

		return c.Send(c.BodyRaw())
	})

	//upload autorun data to mangodb
	app.Post("/autorun2mongodb", func(c *fiber.Ctx) error {
		var autorunData interface{}
		err := json.Unmarshal(c.BodyRaw(), &autorunData)
		if err != nil {
			log.Info("err:", err)
		}
		insertAutoRun2MongoDB(autorunData)
		return c.Send(c.BodyRaw())
	})

	//upload wineventlog to mangodb ,1,3,22 Type log
	app.Post("/winevent/1", func(c *fiber.Ctx) error {
		var dataLog interface{}
		err := json.Unmarshal(c.BodyRaw(), &dataLog)
		if err != nil {
			log.Info("err:", err)
		}
		insertSysmonMonogo(dataLog, 1)
		return c.Send(c.BodyRaw())
	})

	app.Post("/winevent/3", func(c *fiber.Ctx) error {
		var dataLog interface{}
		err := json.Unmarshal(c.BodyRaw(), &dataLog)
		if err != nil {
			log.Info("err:", err)
		}
		insertSysmonMonogo(dataLog, 3)
		return c.Send(c.BodyRaw())
	})

	app.Post("/winevent/22", func(c *fiber.Ctx) error {
		var dataLog interface{}
		err := json.Unmarshal(c.BodyRaw(), &dataLog)
		if err != nil {
			log.Info("err:", err)
		}
		insertSysmonMonogo(dataLog, 22)
		return c.Send(c.BodyRaw())
	})

	// for autorun data
	app.Get("/autorun", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/autorun.ps1")
	})

	//consolidate security for windows server
	app.Get("/consolidate", func(c *fiber.Ctx) error {
		var fileName = "consolidate.txt"
		file, err := os.OpenFile(fileName, os.O_APPEND|os.O_WRONLY|os.O_CREATE, 0755)

		if err != nil {
			log.Error("create file with err:", err.Error())
		}
		// n, err := file.Write([]byte(c.IP()))
		info := time.Now().String() + "|" + c.IP() + "\r\n"
		n, err := file.WriteString(info)
		if err != nil {
			log.Error(err.Error())
		}
		log.Info("write counter :", n)

		file.Close()

		return c.SendFile("../Windows/winServerConsolidating.ps1")
	})

	// NEW A USER for test 360safe.
	app.Get("/newuser", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/winNewUser.ps1")
	})

	app.Get("/winlogbeat", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/winlogbeatSetup.ps1")
	})

	// display Sunflower Remote Controller and TODESK website
	app.Get("/help", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/winSupport.ps1")
	})

	// upload sysmon event log to clickhouse
	app.Get("/sysmon2ck", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/sysmon2ck.ps1")
	})

	// clean event log
	app.Get("/cleanlog", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/winCleanEventLog.ps1")
	})

	app.Get("/tcpvcon", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/tcpvcon.ps1")
	})

	app.Get("/tcpvcon2ck", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/tcpvcon2ck.ps1")
	})

	app.Get("/newtask", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/new-task.ps1")
	})

	app.Get("/newtask2ck", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/new-task2ck.ps1")
	})

	// Linux OS
	// linux main menu:
	app.Get("/linux", func(c *fiber.Ctx) error {
		return c.SendFile("../Linux/linux.sh")
	})

	app.Get("/linuxenroll", func(c *fiber.Ctx) error {
		return c.SendFile("../Linux/enroll.sh")
	})

	app.Get("/linuxinfo", func(c *fiber.Ctx) error {
		return c.SendFile("../Linux/linuxHwinfo.sh")
	})

	// macOS

	app.Get("/machw", func(c *fiber.Ctx) error {
		return c.SendFile("../macOS/macosHwinfo.sh")
	})

	app.Listen(":80")
}
