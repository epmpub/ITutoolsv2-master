package main

import (
	"github.com/gofiber/fiber/v2"
)

func main() {

	app := fiber.New()

	// Home Page
	app.Static("/", "../public")

	//-------------------------------------------------------
	//post hardware inventory information to clickhouse
	app.Post("/hardware_inventory", CreateHardwareInventory())

	app.Get("/hardware_inventory", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/hardware_inventory/hardware_inventory.ps1")
	})

	//-------------------------------------------------------
	//windows application system security log to clickhouse

	app.Post("/app_sys_sec", AppSysSec())

	app.Get("/app_sys_sec", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/app_sys_sec/app_sys_sec.ps1")
	})

	//-------------------------------------------------------

	//post tcpvcon to clickhouse
	app.Post("/tcpvcon", Tcpvcon())

	// tcpvcon to clickhouse
	app.Get("/tcpvcon", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/tcpvcon/tcpvcon.ps1")
	})

	// set collect log scheduler
	app.Get("/setup_task", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/tools/set-scheduler.ps1")
	})

	//-------------------------------------------------------

	// for powershell script call API , sysmon type id=1,3,22 to ClickHouse
	//TODO ID=22

	//-------------------------------------------------------

	//deploy sysmon tools
	app.Get("/sysmon", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/sysmon/GetSysmon.ps1")
	})

	app.Post("/sysmon_id1", SysmonID1())

	// winevent sysmon type id=3 to ClickHouse

	app.Post("/sysmon_id3", SysmonID3())

	//sysmon log to clickhouse (id:1,3,22)

	app.Get("/sysmon/1", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/sysmon/sysmon2ckid1.ps1")
	})

	app.Get("/sysmon/3", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/sysmon/sysmon2ckid3.ps1")
	})

	app.Get("/sysmon/22", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/sysmon/sysmon2ckid22.ps1")
	})

	//-------------------------------------------------------

	//upload autorun data to mangodb
	app.Post("/autorun2mongodb", Autorun2mongodb())

	//-------------------------------------------------------

	//upload autorun data to clickhouse
	app.Post("/autorun", Autorun())

	// for autorun data
	app.Get("/autorun", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/autorun/autorun.ps1")
	})

	//-------------------------------------------------------

	//main menu
	app.Get("/win", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/others/win.ps1")
	})

	//consolidate security for windows server
	app.Get("/harden", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/harden/WindowsHarden.ps1")
	})

	//setup task for collect log
	app.Get("/new_task", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/tools/new_task.ps1")
	})

	// clean event log
	app.Get("/clearlog", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/tools/winCleanEventLog.ps1")
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
