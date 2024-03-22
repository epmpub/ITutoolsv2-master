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
			log.Info("err:", err)
		}
		log.Info("Hardware-inventory->:" + cklog.Message)
		HardWareInventory2ClickHouse(cklog)

		return c.Send(c.BodyRaw())
	}
}

func AppSysSec() func(c *fiber.Ctx) error {

	return func(c *fiber.Ctx) error {
		//write log to clickhouse server
		var cklog ToCKLog
		err := json.Unmarshal(c.BodyRaw(), &cklog)
		if err != nil {
			log.Info("err:", err)
		}
		log.Info("app_sys_sec->:" + cklog.Message)

		insert_app_sys_sec2ClickHouse(cklog)

		return c.Status(200).JSON("OK")
	}
}

func SysmonID1() func(c *fiber.Ctx) error {

	return func(c *fiber.Ctx) error {
		//write log to clickhouse server
		var cklog ToCKLog
		err := json.Unmarshal(c.BodyRaw(), &cklog)
		if err != nil {
			log.Info("err:", err)
		}
		log.Info("sysmon_id_1->:" + cklog.Message)
		insertWineventLog2ClickHouse(cklog, 1)

		return c.Status(200).JSON("OK")
	}
}

func SysmonID3() func(c *fiber.Ctx) error {

	return func(c *fiber.Ctx) error {
		var cklog ToCKLog
		err := json.Unmarshal(c.BodyRaw(), &cklog)
		if err != nil {
			log.Info("err:", err)
		}
		log.Info("sysmon_id_3->:" + cklog.Message)
		insertWineventLog2ClickHouse(cklog, 3)
		return c.Send(c.BodyRaw())
	}
}

func Autorun2mongodb() func(c *fiber.Ctx) error {

	return func(c *fiber.Ctx) error {
		var autorunData interface{}
		err := json.Unmarshal(c.BodyRaw(), &autorunData)
		if err != nil {
			log.Info("err:", err)
		}
		insertAutoRun2MongoDB(autorunData)
		return c.Send(c.BodyRaw())
	}
}

func Autorun() func(c *fiber.Ctx) error {

	return func(c *fiber.Ctx) error {
		var autorunData ToCKLog
		err := json.Unmarshal(c.BodyRaw(), &autorunData)
		if err != nil {
			log.Info("err:", err)
		}
		log.Info("autorun->:" + autorunData.Message)
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
			log.Info("err:", err)
		}
		log.Info("Tcpvcon->:" + cklog.Message)
		insertTcpvcon2ClickHouse(cklog)

		return c.Send(c.BodyRaw())
	}
}
