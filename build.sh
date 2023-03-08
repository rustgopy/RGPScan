GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -trimpath -o RGPScanLinuxAmd64
GOOS=linux GOARCH=386 go build -ldflags="-s -w" -trimpath -o RGPScanLinux386
GOOS=windows GOARCH=amd64 go build -ldflags="-s -w" -trimpath -o RGPScanAmd64.exe
GOOS=windows GOARCH=386 go build -ldflags="-s -w" -trimpath -o RGPScan386.exe


upx -9 RGPScanLinuxAmd64
upx -9 RGPScanLinux386
upx -9 RGPScanAmd64.exe
upx -9 RGPScan386.exe