package initializes

import (
	"github.com/rustgopy/RGPScan/initializes/initialize_cms"
	"github.com/rustgopy/RGPScan/initializes/initialize_http_client"
)

func InitAll() {
	initialize_http_client.InitHttpClient()
	initialize_cms.InitCMS()
}
