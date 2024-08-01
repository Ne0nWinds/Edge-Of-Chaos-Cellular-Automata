param(
	[switch]$Optimize,
	[switch]$DisableDebug
)

pushd
cd $PSScriptRoot

if (-not (Test-Path build)) {
	mkdir build
}
if (-not (Test-Path build\win32)) {
	mkdir build\win32
}

$defines = ""
if (-not $DisableDebug) {
	$defines = @(
		"-D_DEBUG",
		"-g"
	);
}

$optimizeFlags = "";
if ($Optimize) {
	$optimizeFlags = "-O2"
}
clang $optimizeFlags -Wall -Wno-unused-function main.c win32/*.c $defines -mfma -mavx2 -mbmi -nostdlib -o "build/win32/main.exe" "-Wl,/ENTRY:AppMain,/SUBSYSTEM:WINDOWS,/opt:ref" -Xlinker "/STACK:0x100000,0x100000"

popd
