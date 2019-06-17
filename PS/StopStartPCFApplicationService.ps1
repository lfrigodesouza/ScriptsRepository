If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))

{   
$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process powershell -Verb runAs -ArgumentList $arguments
Break
}
$ServiceName = 'PCFApplicationServer'
$arrService = Get-Service -Name $ServiceName
if($arrService.Status -eq 'Running')
{

	$confirmation = Read-Host "O serviço está executando. Deseja pará-lo? (S/n)"
	if($confirmation -eq 's' -or  $confirmation -eq '') {
		echo 'Stopping service...'
        $id = Get-WmiObject -Class Win32_Service -Filter "Name LIKE '$ServiceName'" | Select-Object -ExpandProperty ProcessId
        $process = Get-Process -Id $id
		$process.Kill()
	}
}else {
	$confirmation = Read-Host "O serviço está parado. Deja iniciá-lo? (S/n)"
	if($confirmation -eq 's' -or $confirmation -eq '') {
		echo 'Starting service...'
		$arrService | Start-Service
	}    
}
