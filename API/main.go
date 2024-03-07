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

var i int64

func main() {
	err := os.Mkdir("data", 0777)
	if err != nil {
		log.Error("err with:", err)
	}

	app := fiber.New()

	// Home Page
	app.Static("/", "../public")
	app.Post("/mongodb", func(c *fiber.Ctx) error {
		//insert data to mongodb
		var data interface{}
		err = json.Unmarshal(c.BodyRaw(), &data)
		if err != nil {
			log.Info("err:", err)
		}
		insertTimeSerial(data)

		return c.Send(c.BodyRaw())
	})

	// to ClickHouse

	app.Post("/ck", func(c *fiber.Ctx) error {
		//write log to clickhouse server
		var cklog ToCKLog
		err = json.Unmarshal(c.BodyRaw(), &cklog)
		if err != nil {
			log.Info("err:", err)
		}
		log.Info(cklog.Id)
		log.Info(cklog.Message)
		insertMyLog2ClickHouse(cklog)

		return c.Send(c.BodyRaw())
	})

	// Windows OS support

	//main menu
	app.Get("/win", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/win.ps1")
	})

	app.Get("/sysmon", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/winSysmon.ps1")
	})

	// TODO:remove sysmon

	//TODO:1 upload to webserv 2.FTP data;

	//deprecate API

	// app.Get("/autorun", func(c *fiber.Ctx) error {
	// 	return c.SendFile("../Windows/winAutorun.ps1")
	// })

	// install agent
	app.Get("/enroll", func(c *fiber.Ctx) error {
		var access_log_file = "access.log"
		file, err := os.OpenFile(access_log_file, os.O_APPEND|os.O_WRONLY|os.O_CREATE, os.ModeAppend)

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

		return c.SendFile("../Windows/gp_update.ps1")
	})

	//remove agent
	app.Get("/remove", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/winAgentRemove.ps1")
	})

	//consolidate security
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

	//FAILED
	// NEED TO SETUP CK SERVER PUBLIC;

	app.Get("/event", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/winEvent.ps1")
	})

	// SETUP CONSOLE ENCODING,Resolve chinese font display issure.
	app.Get("/console", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/winConsole.ps1")
	})

	// SETUP openssh-server for windows.
	app.Get("/ssh", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/winSetupSSH.ps1")
	})

	// BULK INSTALL SOFTWARE AND CONFIG;

	app.Get("/softs", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/winGetSoftware.ps1")
	})

	// NEW A USER;
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

	// clean event log
	app.Get("/cleanlog", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/winCleanEventLog.ps1")
	})

	// get hardware and software information;
	app.Get("/getinfo", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/winGetInfo.ps1")
	})

	// gp upate service
	app.Get("/gp_update", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/gp_update.ps1")
	})

	// forWin.exe update
	app.Get("/forWin_update", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/forWin_update.ps1")
	})

	// for Computer Information
	app.Get("/info", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/ComputerInfo.ps1")
	})

	// for Computer software deploy
	app.Get("/setup", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/controller.ps1")
	})

	// for collect Computer autorun data
	app.Get("/autorun", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/autorun.ps1")
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
