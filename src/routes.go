package main

import (
	"encoding/json"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/log"
)

func CreateHardwareInventory() func(c *fiber.Ctx) error {

	return func(c *fiber.Ctx) error {
		//write log to clickhouse server
		var cklog ToCKLog
		err := json.Unmarshal(c.BodyRaw(), &cklog)
		if err != nil {
			log.Error("err:", err)
		}
		log.Error("Hardware-inventory->:" + cklog.Message)
		HardWareInventory2ClickHouse(cklog)

		return c.Send(c.BodyRaw())
	}
}

func CreateSoftwareInventory() func(c *fiber.Ctx) error {

	return func(c *fiber.Ctx) error {
		//write log to clickhouse server
		var cklog ToCKLog
		err := json.Unmarshal(c.BodyRaw(), &cklog)
		if err != nil {
			log.Error("err:", err)
		}
		// log.Error("Software-inventory->:" + cklog.Message)
		SoftWareInventory2ClickHouse(cklog)

		return c.Send(c.BodyRaw())
	}
}

func AppSysSec() func(c *fiber.Ctx) error {

	return func(c *fiber.Ctx) error {
		//write log to clickhouse server
		var cklog ToCKLog
		err := json.Unmarshal(c.BodyRaw(), &cklog)
		if err != nil {
			log.Error("err:", err)
		}

		insert_app_sys_sec2ClickHouse(cklog)

		return c.Status(200).JSON("OK")
	}
}

func MyLog() func(c *fiber.Ctx) error {

	return func(c *fiber.Ctx) error {
		//write log to clickhouse server
		var cklog ToCKLog
		err := json.Unmarshal(c.BodyRaw(), &cklog)
		if err != nil {
			log.Error("err:", err)
		}

		mylog2ck(cklog)

		return c.Status(200).JSON("OK")
	}
}

func SysmonID1() func(c *fiber.Ctx) error {

	return func(c *fiber.Ctx) error {
		//write log to clickhouse server
		var cklog ToCKLog
		err := json.Unmarshal(c.BodyRaw(), &cklog)
		if err != nil {
			log.Error("err:", err)
		}
		log.Error("sysmon_id_1->:" + cklog.Message)
		insertWineventLog2ClickHouse(cklog, 1)

		return c.Status(200).JSON("OK")
	}
}

func SysmonID3() func(c *fiber.Ctx) error {

	return func(c *fiber.Ctx) error {
		var cklog ToCKLog
		err := json.Unmarshal(c.BodyRaw(), &cklog)
		if err != nil {
			log.Error("err:", err)
		}
		log.Error("sysmon_id_3->:" + cklog.Message)
		insertWineventLog2ClickHouse(cklog, 3)
		return c.Send(c.BodyRaw())
	}
}

func SysmonID5() func(c *fiber.Ctx) error {

	return func(c *fiber.Ctx) error {
		var cklog ToCKLog
		err := json.Unmarshal(c.BodyRaw(), &cklog)
		if err != nil {
			log.Error("err:", err)
		}
		log.Error("sysmon_id_5->:" + cklog.Message)
		insertWineventLog2ClickHouse(cklog, 5)
		return c.Send(c.BodyRaw())
	}
}

func SysmonID11() func(c *fiber.Ctx) error {

	return func(c *fiber.Ctx) error {
		var cklog ToCKLog
		err := json.Unmarshal(c.BodyRaw(), &cklog)
		if err != nil {
			log.Error("err:", err)
		}
		log.Error("sysmon_id_11->:" + cklog.Message)
		insertWineventLog2ClickHouse(cklog, 11)
		return c.Send(c.BodyRaw())
	}
}

func SysmonID12() func(c *fiber.Ctx) error {

	return func(c *fiber.Ctx) error {
		var cklog ToCKLog
		err := json.Unmarshal(c.BodyRaw(), &cklog)
		if err != nil {
			log.Error("err:", err)
		}
		log.Error("sysmon_id_12->:" + cklog.Message)
		insertWineventLog2ClickHouse(cklog, 12)
		return c.Send(c.BodyRaw())
	}
}

func SysmonID22() func(c *fiber.Ctx) error {

	return func(c *fiber.Ctx) error {
		var cklog ToCKLog
		err := json.Unmarshal(c.BodyRaw(), &cklog)
		if err != nil {
			log.Error("err:", err)
		}
		log.Error("sysmon_id_22->:" + cklog.Message)
		insertWineventLog2ClickHouse(cklog, 22)
		return c.Send(c.BodyRaw())
	}
}

func SysmonID27() func(c *fiber.Ctx) error {

	return func(c *fiber.Ctx) error {
		var cklog ToCKLog
		err := json.Unmarshal(c.BodyRaw(), &cklog)
		if err != nil {
			log.Error("err:", err)
		}
		log.Error("sysmon_id_22->:" + cklog.Message)
		insertWineventLog2ClickHouse(cklog, 27)
		return c.Send(c.BodyRaw())
	}
}

func Autorun2mongodb() func(c *fiber.Ctx) error {

	return func(c *fiber.Ctx) error {
		var autorunData interface{}
		err := json.Unmarshal(c.BodyRaw(), &autorunData)
		if err != nil {
			log.Error("err:", err)
		}
		insertAutoRun2MongoDB(autorunData)
		return c.Send(c.BodyRaw())
	}
}

func Autorun() func(c *fiber.Ctx) error {

	return func(c *fiber.Ctx) error {

		var autorunData ToCKLog
		err := json.Unmarshal(c.BodyRaw(), &autorunData)

		//chinese character !!

		if err != nil {
			log.Debug("err:", err)
		}
		insertAutorun2ClickHouse(autorunData)
		return c.Status(200).JSON("OK")
	}
}

func Tcpvcon() func(c *fiber.Ctx) error {

	return func(c *fiber.Ctx) error {
		//write log to clickhouse server
		var cklog ToCKLog
		err := json.Unmarshal(c.BodyRaw(), &cklog)
		if err != nil {
			log.Error("err:", err)
		}
		log.Error("Tcpvcon->:" + cklog.Message)
		insertTcpvcon2ClickHouse(cklog)

		return c.Send(c.BodyRaw())
	}
}
