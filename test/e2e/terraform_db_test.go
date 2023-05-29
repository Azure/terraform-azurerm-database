package e2e

import (
	"fmt"
	"os"
	"testing"
	"time"

	test_helper "github.com/Azure/terraform-module-test-helper"
	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformDatabase(t *testing.T) {
	vars := make(map[string]any)
	identityId := os.Getenv("MSI_ID")
	if identityId != "" {
		vars["msi_id"] = identityId
	}
	opt := terraform.Options{
		Vars: vars,
	}
	test_helper.RunE2ETest(t, "../../",
		"examples/basic",
		opt,
		assertDbFunctional)
}

func assertDbFunctional(t *testing.T, output test_helper.TerraformOutput) {
	var dbConfig DBConfig
	dbConfig.server = output["sql_server_fqdn"].(string)
	dbConfig.user = output["sql_admin_username"].(string)
	dbConfig.password = output["sql_password"].(string)
	dbConfig.database = output["database_name"].(string)

	// It can take a minute or so for the database to boot up, so retry a few times
	maxRetries := 15
	timeBetweenRetries := 5 * time.Second
	description := fmt.Sprintf("Executing commands on database %s", dbConfig.server)

	// Verify that we can connect to the database and run SQL commands
	_, err := retry.DoWithRetryE(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		// Connect to specific database, i.e. mssql
		db, err := DBConnectionE(t, "mssql", dbConfig)
		if err != nil {
			return "", err
		}

		// Create a table
		creation := "create table person (id integer, name varchar(30), primary key (id))"
		DBExecution(t, db, creation)

		// Insert a row
		expectedID := 12345
		expectedName := "azure"
		insertion := fmt.Sprintf("insert into person values (%d, '%s')", expectedID, expectedName)
		DBExecution(t, db, insertion)

		// Query the table and check the output
		query := "select name from person"
		DBQueryWithValidation(t, db, query, "azure")

		// Drop the table
		drop := "drop table person"
		DBExecution(t, db, drop)
		fmt.Println("Executed SQL commands correctly")

		defer func() {
			_ = db.Close()
		}()

		return "", nil
	})
	assert.NoError(t, err)
}
