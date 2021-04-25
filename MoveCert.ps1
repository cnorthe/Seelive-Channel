#Change these values
$servername = $env:COMPUTERNAME

if (Test-Path -path Cert:\LocalMachine\Root\905F942FD9F28F679B378180FD4F846347F645C1)
    {
        $cert = Get-Item -Path Cert:\LocalMachine\Root\905F942FD9F28F679B378180FD4F846347F645C1
        $store = Get-Item -Path Cert:\LocalMachine\Root
        $store.open("ReadWrite")
        $store.Remove($cert)
        $store.Close()
        $untrusted = Get-Item -Path Cert:\LocalMachine\Disallowed
        $untrusted.open("ReadWrite")
        $untrusted.add($cert)
        $untrusted.close()
    }
Else
    {
        write-host "The certificate is not in the Root Folder on server $servername"
    }