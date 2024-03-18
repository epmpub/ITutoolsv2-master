package main

import (
	"github.com/gofiber/fiber/v2"
)

type ToCKLog struct {
	Id      string `json:"id" bson:"id"`
	Message string `json:"message"`
}

func main() {

	app := fiber.New()

	// Home Page
	app.Static("/", "../public")

	//post hardware inventory information to clickhouse
	app.Post("/hardware_inventory", CreateHardwareInventory())

	//windows application system security log to clickhouse
	app.Post("/app_sys_sec", AppSysSec())

	//post tcpvcon to clickhouse
	app.Post("/tcpvcon", Tcpvcon())

	// for powershell script call API , sysmon type id=1,3,22 to ClickHouse
	//TODO ID=22

	app.Post("/sysmon_id1", SysmonID1())

	// winevent sysmon type id=3 to ClickHouse

	app.Post("/sysmon_id3", SysmonID3())

	//upload autorun data to mangodb
	app.Post("/autorun2mongodb", Autorun2mongodb())

	//upload autorun data to clickhouse
	app.Post("/autorun", Autorun())

	//main menu
	app.Get("/win", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/win.ps1")
	})

	//get hardware inventory information
	app.Get("/hardware_inventory", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/hardware_inventory.ps1")
	})

	//application system security log
	app.Get("/app_sys_sec", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/app_sys_sec.ps1")
	})

	//install sysmon tools
	app.Get("/installSysmon", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/winSysmon.ps1")
	})

	//sysmon log to clickhouse (id:1,3,22)

	app.Get("/sysmon/1", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/sysmon2ckid1.ps1")
	})

	app.Get("/sysmon/3", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/sysmon2ckid3.ps1")
	})

	app.Get("/sysmon/22", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/sysmon2ckid22.ps1")
	})

	// for autorun data
	app.Get("/autorun", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/autorun.ps1")
	})

	//consolidate security for windows server
	app.Get("/consolidate", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/winServerConsolidating.ps1")
	})

	// display Sunflower Remote Controller and TODESK website
	app.Get("/help", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/winSupport.ps1")
	})

	// clean event log
	app.Get("/cleanlog", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/winCleanEventLog.ps1")
	})

	// tcpvcon to clickhouse
	app.Get("/tcpvcon2ck", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/tcpvcon2ck.ps1")
	})

	// install task scheduler for mongodb
	app.Get("/newtask", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/new-task.ps1")
	})

	// install task scheduler for clickhouse
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
