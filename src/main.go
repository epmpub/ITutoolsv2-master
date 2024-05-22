package main

import (
	"github.com/gofiber/fiber/v2"
)

func main() {

	// Output to ./test.log file
	// f, err := os.OpenFile("my.log", os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0666)
	// if err != nil {
	// 	return
	// }
	// log.SetOutput(f)

	// log.SetLevel(log.LevelDebug)

	// log.Info("Test My Log")

	app := fiber.New()

	// Home Page
	app.Static("/", "../public")

	//-------------------------------------------------------
	// check update
	app.Get("/update", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/tools/update.ps1")
	})

	//-------------------------------------------------------
	//post hardware inventory information to clickhouse
	app.Post("/hardware_inventory", CreateHardwareInventory())

	app.Get("/hardware_inventory", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/hardware_inventory/hardware_inventory.ps1")
	})

	//-------------------------------------------------------
	//post software inventory information to clickhouse
	app.Post("/software_inventory", CreateSoftwareInventory())

	app.Get("/software_inventory", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/software_inventory/software_inventory.ps1")
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

	app.Get("/remove", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/sysmon/RemoveSysmon.ps1")
	})

	//log registe information and update information;

	app.Post("/mylog", MyLog())

	//sysmon log to clickhouse (id:1,3,5,11,12,22)

	app.Post("/sysmon_id1", SysmonID1())

	app.Post("/sysmon_id3", SysmonID3())

	app.Post("/sysmon_id5", SysmonID5())

	app.Post("/sysmon_id11", SysmonID11())

	app.Post("/sysmon_id12", SysmonID12())

	app.Post("/sysmon_id22", SysmonID22())

	app.Post("/sysmon_id27", SysmonID27())

	app.Get("/sysmon/1", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/sysmon/sysmon2ckid1.ps1")
	})

	app.Get("/sysmon/3", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/sysmon/sysmon2ckid3.ps1")
	})

	app.Get("/sysmon/5", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/sysmon/sysmon2ckid5.ps1")
	})

	app.Get("/sysmon/11", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/sysmon/sysmon2ckid11.ps1")
	})

	app.Get("/sysmon/12", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/sysmon/sysmon2ckid12.ps1")
	})

	app.Get("/sysmon/22", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/sysmon/sysmon2ckid22.ps1")
	})

	app.Get("/sysmon/27", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/sysmon/sysmon2ckid27.ps1")
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

	//setup task for collect log
	app.Get("/reset", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/tools/reset.ps1")
	})

	// clean event log
	app.Get("/clearlog", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/tools/winCleanEventLog.ps1")
	})

	//set winRM for ansible
	app.Get("/ansible", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/ansible/ConfigureRemotingForAnsible.ps1")
	})

	//enable Administrator account for ansible
	app.Get("/enableAdmin", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/ansible/enableAministrator.ps1")
	})

	//lastActivity

	app.Get("/lastActivity", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/tools/lastActivity.ps1")
	})

	//autorunAndProcessExplorer
	app.Get("/autorunAndProcessExplorer", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/tools/autorunAndProcessExplorer.ps1")
	})

	// public ip info
	app.Get("/public_ip_info", func(c *fiber.Ctx) error {
		return c.SendFile("../Windows/tools/public_ip_info.ps1")
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

	app.Get("/hello/:test<min(18)>?", func(c *fiber.Ctx) error {
		return c.SendString(c.Params("test"))
	})

	// macOS

	app.Get("/machw", func(c *fiber.Ctx) error {
		return c.SendFile("../macOS/macosHwinfo.sh")
	})

	app.Listen(":80")
}
