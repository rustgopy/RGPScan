GOOS=darwin GOARCH=amd64 go build -ldflags="-s -w" -trimpath -o RGPScanMacAmd64
GOOS=darwin GOARCH=arm64 go build -ldflags="-s -w" -trimpath -o RGPScanMacArm64
GOOS=linux GOARCH=arm64 go build -ldflags="-s -w" -trimpath -o RGPScanLinuxArm64

upx -9 RGPScanMacAmd64