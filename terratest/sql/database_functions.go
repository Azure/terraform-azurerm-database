package test

import (
	"database/sql"
	"fmt"
	"testing"

	// Microsoft SQL Database driver
	_ "github.com/denisenkom/go-mssqldb"
)

// DBConfig using server name, user name, password and database name
type DBConfig struct {
	server   string
	user     string
	password string
	database string
}

// Connect to the database using database configuration and database type, i.e. mssql, and then return the database. If there's any error, fail the test.
func dbConnection(t *testing.T, dbType string, dbConfig DBConfig) *sql.DB {
	db, err := dbConnectionE(t, dbType, dbConfig)
	if err != nil {
		t.Fatal(err)
	}
	return db
}

// Connect to the database using database configuration and database type, i.e. mssql. Return the database or an error.
func dbConnectionE(t *testing.T, dbType string, dbConfig DBConfig) (*sql.DB, error) {
	config := fmt.Sprintf("server = %s; user id = %s; password = %s; database = %s", dbConfig.server, dbConfig.user, dbConfig.password, dbConfig.database)
	db, err := sql.Open(dbType, config)
	if err != nil {
		return nil, err
	}
	return db, nil
}

// Execute specific SQL commands, i.e. insertion. If there's any error, fail the test.
func dbExecution(t *testing.T, db *sql.DB, command string) {
	_, err := dbExecutionE(t, db, command)
	if err != nil {
		t.Fatal(err)
	}
}

// Execute specific SQL commands, i.e. insertion. Return the result or an error.
func dbExecutionE(t *testing.T, db *sql.DB, command string) (sql.Result, error) {
	result, err := db.Exec(command)
	if err != nil {
		return nil, err
	}
	return result, nil
}

// Query from database, i.e. selection, and then return the result. If there's any error, fail the test.
func dbQuery(t *testing.T, db *sql.DB, command string) *sql.Rows {
	rows, err := dbQueryE(t, db, command)
	if err != nil {
		t.Fatal(err)
	}
	return rows
}

// Query from database, i.e. selection. Return the result or an error.
func dbQueryE(t *testing.T, db *sql.DB, command string) (*sql.Rows, error) {
	rows, err := db.Query(command)
	if err != nil {
		return nil, err
	}
	return rows, nil
}

// Query from database and validate whether the result meets the requirement. If there's any error, fail the test.
func dbQueryWithValidation(t *testing.T, db *sql.DB, command string, expected string) {
	err := dbQueryWithValidationE(t, db, command, expected)
	if err != nil {
		t.Fatal(err)
	}
}

// Query from database and validate whether the result meets the requirement. If not, return an error.
func dbQueryWithValidationE(t *testing.T, db *sql.DB, command string, expected string) error {
	rows := dbQuery(t, db, command)
	var name string
	for rows.Next() {
		err := rows.Scan(&name)
		if err != nil {
			return err
		}
		if name != expected {
			return validationFailed{actual: name, expected: expected}
		}
	}
	defer rows.Close()
	return nil
}

// validationFailed is an error that occurs if the validation fails.
type validationFailed struct {
	actual   string
	expected string
}

func (err validationFailed) Error() string {
	return fmt.Sprintf("Validation failed: expected text is %s but actual text is %s.", err.expected, err.actual)
}
