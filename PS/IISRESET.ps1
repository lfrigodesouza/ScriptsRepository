If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))

{   
$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process powershell -Verb runAs -ArgumentList $arguments
Break
}
IISRESET
#Script para mover os arquivos de log para uma pasta com data-hora
$logdir="C:\PCF\LOG\4"
$newdir="$logdir\$(get-date -Format 'yyyyMMdd_HHmmss')"
push-location $logdir;
Write-Host $newdir
New-Item $newdir -type directory
get-childitem *.log,*.err,*.txt | foreach-object {move-item $_ -destination $newdir}
Move-Item -Path "$logdir\Site*" $newdir -Force

#Script para apagar as pastas, mantendo somente as 3 ultimas
#Mantem 3 dias de log em arquivo
gci $logdir -Recurse -Filter "201*" |
where{$_.PsIsContainer -and $_.lastwritetime -le (get-date).adddays(-4)}|
sort CreationTime|
Remove-Item -Force -Recurse
