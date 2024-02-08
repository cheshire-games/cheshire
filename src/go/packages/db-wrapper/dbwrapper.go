package dbwrapper

import (
	"context"
	"github.com/jackc/pgx/v5"
	"os"
)

var Ctx context.Context

func init() {
	Ctx = context.Background()
}

func Connect() (*pgx.Conn, error) {
	conn, err := pgx.Connect(Ctx, os.Getenv("DB_CONN"))
	if err != nil {
		return nil, err
	}
	return conn, nil
}
