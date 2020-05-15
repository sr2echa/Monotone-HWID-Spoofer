$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

function Get-RandomString {
    param([int]$Length,
          [int]$upperCase,
		  [int]$onlyNumber)

	if ($onlynumber -eq 1) {
		$set = "0123456789".ToCharArray()
	}
	else {
		$set = "abcdef0123456789".ToCharArray()
	}
	
    $result = ""
    for ($x = 0; $x -lt $Length; $x++) {
        $result += $set | Get-Random
    }

    if ($upperCase -eq 1) { return $result.ToUpper() }
    else { return $result }

}

function Set-HWProfileID {

    $registryPath = "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\IDConfigDB\Hardware Profiles\0001"
    $registryKeyName = "HwProfileGuid"

    $HwProfile = Get-ItemProperty -Path $registryPath -Name $registryKeyName

    $len = $HwProfile.HwProfileGuid.Length
    $Rand1 = Get-RandomString -Length 8 -upperCase 0 -onlyNumber 0
    $Rand2 = Get-RandomString -Length 4 -upperCase 0 -onlyNumber 0
    $Rand3 = Get-RandomString -Length 4 -upperCase 0 -onlyNumber 0
    $Rand4 = Get-RandomString -Length 4 -upperCase 0 -onlyNumber 0
    $Rand5 = Get-RandomString -Length 12 -upperCase 0 -onlyNumber 0
    $RandID = "{$Rand1-$Rand2-$Rand3-$Rand4-$Rand5}"

    Set-ItemProperty -Path $registryPath -Name $registryKeyName -Value $RandID

}

function Set-MachineGUID {

    $registryPath = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Cryptography"
    $registryKeyName = "MachineGuid"

    $HwProfile = Get-ItemProperty -Path $registryPath -Name $registryKeyName

    $len = $HwProfile.HwProfileGuid.Length
    $Rand1 = Get-RandomString -Length 8 -upperCase 0 -onlyNumber 0
    $Rand2 = Get-RandomString -Length 4 -upperCase 0 -onlyNumber 0
    $Rand3 = Get-RandomString -Length 4 -upperCase 0 -onlyNumber 0
    $Rand4 = Get-RandomString -Length 4 -upperCase 0 -onlyNumber 0
    $Rand5 = Get-RandomString -Length 12 -upperCase 0 -onlyNumber 0
    $RandID3 = "$Rand1-$Rand2-$Rand3-$Rand4-$Rand5"

    Set-ItemProperty -Path $registryPath -Name $registryKeyName -Value $RandID3

}

function Set-VolID {

    
    $volidPath = "$scriptPath\Volumeid64.exe"
    $volID1 = Get-RandomString -Length 4 -upperCase 1 -onlyNumber 0
    $volID2 = Get-RandomString -Length 4 -upperCase 1 -onlyNumber 0
    $volidArgs = "C: $volID1-$volID2"
    $volidArgs1 = "$volID1-$volID2"

    $ps = New-Object System.Diagnostics.Process
    $ps.StartInfo.FileName = $volidPath
    $ps.StartInfo.Arguments = $volidArgs
    $ps.StartInfo.RedirectStandardOutput = $False
    $ps.StartInfo.UseShellExecute = $True
    $ps.StartInfo.WindowStyle = "Hidden"
    $ps.StartInfo.CreateNoWindow = $True
    $psReturnCOde = $ps.Start()

    if (-Not $ps.WaitForExit(10000)) { $ps.kill() }
    
}

try
    {
        Write-Host "The operation completed successfully."
        Set-HWProfileID
    }
    catch
    {
        Write-Host "ERROR: Could not change HWProfile GUID (run Script as Administrator)"
    }
try
    {
        Write-Host "The operation completed successfully."
        Set-MachineGUID
        Write-Host "The operation completed successfully."
    }
    catch
    {
        Write-Host "ERROR: Could not change Volume GUID (run Script as Administrator)"
    }

    