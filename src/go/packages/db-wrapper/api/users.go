package api

import (
	"dbwrapper"
	"dbwrapper/sqlc"
)

func AddUser(createUserParams sqlc.CreateUserParams) (*sqlc.User, error) {
	conn, err := dbwrapper.Connect()
	if err != nil {
		return nil, err
	}
	defer conn.Close(dbwrapper.Ctx)

	queries := sqlc.New(conn)
	insertedUser, err := queries.CreateUser(dbwrapper.Ctx, createUserParams)
	if err != nil {
		return nil, err
	}
	return &insertedUser, nil
}

func UpdateUser(updateUserParams sqlc.UpdateUserParams) (*sqlc.User, error) {
	conn, err := dbwrapper.Connect()
	if err != nil {
		return nil, err
	}
	defer conn.Close(dbwrapper.Ctx)

	queries := sqlc.New(conn)
	updatedUser, err := queries.UpdateUser(dbwrapper.Ctx, updateUserParams)
	if err != nil {
		return nil, err
	}
	return &updatedUser, nil
}

func DeleteUser(username string) error {
	conn, err := dbwrapper.Connect()
	if err != nil {
		return err
	}
	defer conn.Close(dbwrapper.Ctx)

	queries := sqlc.New(conn)
	err = queries.DeleteUser(dbwrapper.Ctx, username)
	if err != nil {
		return err
	}
	return nil
}
