package unit

import (
	test_helper "github.com/Azure/terraform-module-test-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"os"
	"testing"
)

var dummyVariables = map[string]any{
	"db_name":            "db",
	"location":           "eastus",
	"sql_admin_username": "admin",
	"sql_password":       "password",
}

func TestMultipleVulnerabilityAssessments(t *testing.T) {
	vars := map[string]any{
		"mssql_server_security_alert_policies": map[string]any{
			"default0": map[string]any{
				"state": "Enabled",
				"vulnerability_assessments": map[string]any{
					"va0": map[string]any{
						"storage_container_path": "",
					},
					"va1": map[string]any{
						"storage_container_path": "",
					},
				},
			},
			"default1": map[string]any{
				"state": "Enabled",
				"vulnerability_assessments": map[string]any{
					"va0": map[string]any{
						"storage_container_path": "",
					},
					"va1": map[string]any{
						"storage_container_path": "",
					},
				},
			},
		},
	}
	varFile := test_helper.VarsToFile(t, vars)
	defer func() {
		_ = os.Remove(varFile)
	}()
	test_helper.RunUnitTest(t, "../../", "unit-fixture", terraform.Options{
		Vars:     dummyVariables,
		VarFiles: []string{varFile},
	}, func(t *testing.T, output test_helper.TerraformOutput) {
		assessments, ok := output["vulnerability_assessments"].(map[string]any)
		assert.True(t, ok)
		assert.Equal(t, 4, len(assessments))
		assert.Contains(t, assessments, "default0_va0")
		assert.Contains(t, assessments, "default0_va1")
		assert.Contains(t, assessments, "default1_va0")
		assert.Contains(t, assessments, "default1_va1")
	})
}
