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
		// log.Info(cklog.Id)
		// log.Info(cklog.Message)
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
		log.Info(cklog.Id)
		log.Info(cklog.Message)

		insert_app_sys_sec2ClickHouse(cklog)

		return c.Send(c.BodyRaw())
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
		log.Info(cklog.Id)
		log.Info(cklog.Message)
		insertWineventLog2ClickHouse(cklog, 1)

		return c.Send(c.BodyRaw())
	}
}

func SysmonID3() func(c *fiber.Ctx) error {

	return func(c *fiber.Ctx) error {
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
		insertAutorun2ClickHouse(autorunData)
		return c.Send(c.BodyRaw())
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
		log.Info(cklog.Id)
		log.Info(cklog.Message)
		insertTcpvcon2ClickHouse(cklog)

		return c.Send(c.BodyRaw())
	}
}
