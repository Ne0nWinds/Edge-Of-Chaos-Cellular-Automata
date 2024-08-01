param(
	[switch]$Optimize
)

fxc /T vs_5_0 "win32/blit.vertex.hlsl" /Fo "build/win32/blit.vertex.cso" > $null
fxc /T ps_5_0 "win32/blit.pixel.hlsl" /Fo "build/win32/blit.pixel.cso" > $null

$flags = @("/Od", "/Zi");
if ($Optimize) {
	$flags = "";
}
fxc $flags /T cs_5_0 "win32/advance.compute.hlsl" /Fo "build/win32/advance.compute.cso" > $null
fxc /T cs_5_0 "win32/reset.compute.hlsl" /Fo "build/win32/reset.compute.cso" > $null
