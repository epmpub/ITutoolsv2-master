package main

import (
	"encoding/json"
	"fmt"

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
		HardWareInventory2ClickHouse(cklog)
		return c.Status(200).JSON("OK")
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
		SoftWareInventory2ClickHouse(cklog)

		return c.Status(200).JSON("OK")
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

		fmt.Println(cklog.Id)
		fmt.Println(cklog.Message)

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
		insertWineventLog2ClickHouse(cklog, 3)
		return c.Status(200).JSON("OK")
	}
}

func SysmonID5() func(c *fiber.Ctx) error {

	return func(c *fiber.Ctx) error {
		var cklog ToCKLog
		err := json.Unmarshal(c.BodyRaw(), &cklog)
		if err != nil {
			log.Error("err:", err)
		}
		insertWineventLog2ClickHouse(cklog, 5)
		return c.Status(200).JSON("OK")
	}
}

func SysmonID11() func(c *fiber.Ctx) error {

	return func(c *fiber.Ctx) error {
		var cklog ToCKLog
		err := json.Unmarshal(c.BodyRaw(), &cklog)
		if err != nil {
			log.Error("err:", err)
		}
		insertWineventLog2ClickHouse(cklog, 11)
		return c.Status(200).JSON("OK")
	}
}

func SysmonID12() func(c *fiber.Ctx) error {

	return func(c *fiber.Ctx) error {
		var cklog ToCKLog
		err := json.Unmarshal(c.BodyRaw(), &cklog)
		if err != nil {
			log.Error("err:", err)
		}
		insertWineventLog2ClickHouse(cklog, 12)
		return c.Status(200).JSON("OK")
	}
}

func SysmonID22() func(c *fiber.Ctx) error {

	return func(c *fiber.Ctx) error {
		var cklog ToCKLog
		err := json.Unmarshal(c.BodyRaw(), &cklog)
		if err != nil {
			log.Error("err:", err)
		}
		insertWineventLog2ClickHouse(cklog, 22)
		return c.Status(200).JSON("OK")
	}
}

func SysmonID27() func(c *fiber.Ctx) error {

	return func(c *fiber.Ctx) error {
		var cklog ToCKLog
		err := json.Unmarshal(c.BodyRaw(), &cklog)
		if err != nil {
			log.Error("err:", err)
		}
		insertWineventLog2ClickHouse(cklog, 27)
		return c.Status(200).JSON("OK")
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
		insertTcpvcon2ClickHouse(cklog)

		return c.Status(200).JSON("OK")
	}
}
