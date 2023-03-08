package plugin_scan_poc_xray

import (
	"github.com/rustgopy/RGPScan/core/plugins/plugin_scan_poc_xray/lib"
	"github.com/rustgopy/RGPScan/models"
	"net/http"
)

func ScanPocXray(oReq *http.Request, p *models.DataPocXray) (bool, error, string) {
	return lib.ExecutePoc(oReq, p)
}
