package test

import (
	"io/ioutil"
	"net/http"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestAppInfra(t *testing.T) {
	// Terraform options
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "..",
		Vars: map[string]interface{}{"region": "us-east-1"},
	})

	// Terraform Init & Apply
	t.Run("Terraform Init & Apply", func(t *testing.T) {
		terraform.InitAndApply(t, terraformOptions)
	})

	// Some infra output validation
	t.Run("Test Infra Output", func(t *testing.T) {
		output := terraform.Output(t, terraformOptions, "app_endpoint")
		if "app.userleap.de-vi.me" != output {
			t.Errorf("Output not as expected. %s != \"app.userleap.de-vi.me\"", output)
		}
	})

	// Test App Endpoint
	t.Run("Test App Endpoint", func(t *testing.T) {
		output := terraform.Output(t, terraformOptions, "app_endpoint")
		resp, err := http.Get("https://" + output)
		if err != nil {
			t.Errorf("Error in get request to app: %s ", err)
		}
		if resp == nil {
			t.Errorf("Got no response from app")
		} else {
			if resp.StatusCode != 200 {
				t.Errorf("Invalid response code. %d != 200", resp.StatusCode)
			}
			body, err := ioutil.ReadAll(resp.Body)
			if err != nil {
				t.Errorf("Error in http response parsing: %s ", err)
			}
			if string(body) != "<html><h1>IT WORKS!</h1></html>" {
				t.Errorf("Unexpected http response. \"%s\" != \"<html><h1>IT WORKS!</h1></html>\"", string(body))
			}
		}
	})
	// Terraform destroy after all tests
	t.Run("Test Destroy", func(t *testing.T) {
		terraform.Destroy(t, terraformOptions)
	})
}
