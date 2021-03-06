﻿<#

#>

if(!(test-path $env:USERPROFILE\Desktop\PoSh_git)){new-item $env:USERPROFILE\Desktop\PoSh_git -ItemType Directory | out-null}
if(!(test-path $env:USERPROFILE\Desktop\PoSh_git\admin)){new-item $env:USERPROFILE\Desktop\PoSh_git\admin -ItemType directory | out-null}
if(!(test-path $env:USERPROFILE\Desktop\PoSh_git\admin\master)){new-item $env:USERPROFILE\Desktop\PoSh_git\admin\master -ItemType directory | out-null}
if(!(test-path $env:USERPROFILE\Desktop\PoSh_git\admin\branch)){new-item $env:USERPROFILE\Desktop\PoSh_git\admin\branch -ItemType directory | out-null}
if(!(test-path $env:USERPROFILE\Desktop\PoSh_git\admin\stage)){new-item $env:USERPROFILE\Desktop\PoSh_git\admin\stager -ItemType directory | out-null}


function push-git{
    copy-item $env:USERPROFILE\Desktop\PoSh_git\admin\branch $env:USERPROFILE\Desktop\PoSh_git\admin\master -Recurse -force
    }


function pull-git{
    copy-item $env:USERPROFILE\Desktop\PoSh_git\admin\master $env:USERPROFILE\Desktop\PoSh_git\admin\branch -Recurse -force    
    }

 
function gen-cert{
    if((Get-NetTCPConnection).LocalPort -ne 443)
        {
	"Generating Self-Signed Certificate..."
        Install-WindowsFeature -Name Web-server -IncludeAllSubFeature
        import-module webadministration
        Set-Location IIS:\SslBindings
        New-WebBinding -Name "Default Web Site" -IP "*" -Port 443 -Protocol https
        $newCert = New-SelfSignedCertificate -DnsName "localhost" -CertStoreLocation cert:\LocalMachine\my | out-null
        $newCert | New-Item 0.0.0.0!443 | out-null

        $srcStoreScope = "LocalMachine"
        $srcStoreName = "my"

        $srcStore = New-Object System.Security.Cryptography.X509Certificates.X509Store $srcStoreName, $srcStoreScope
        $srcStore.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadOnly)

        $cert = $srcStore.certificates -match "localhost"

        $dstStoreScope = "LocalMachine"
        $dstStoreName = "root"

        $dstStore = New-Object System.Security.Cryptography.X509Certificates.X509Store $dstStoreName, $dstStoreScope
        $dstStore.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
        $dstStore.Add($cert[0])

        $srcStore.Close | out-null
        $dstStore.Close | Out-Null
        set-location $env:USERPROFILE

        $CertShop=Get-ChildItem -Path Cert:\LocalMachine\My | where-Object {$_.subject -like "*localhost*"} | Select-Object -ExpandProperty Thumbprint
        get-item -Path "cert:\LocalMachine\My\$certShop" | new-item -path IIS:\SslBindings\0.0.0.0!443 | out-null
        }
    }




    

if(!(Get-WmiObject win32_useraccount | where-object{$_.name -eq "admin"}))
    {
	"Creating User..."
    secedit /export /cfg c:\secpol.cfg
    (Get-Content C:\secpol.cfg).replace("PasswordComplexity = 1", "PasswordComplexity = 0") | Out-File C:\secpol.cfg
    secedit /configure /db c:\windows\security\local.sdb /cfg c:\secpol.cfg /areas SECURITYPOLICY
    Remove-Item -force c:\secpol.cfg -confirm:$false
    gpupdate /force
    $password = ConvertTo-SecureString "empiredidnothingwrong" -AsPlainText -Force
    New-LocalUser "admin" -Password $Password -FullName "webuser" | out-null
    }


gen-cert
Set-WebConfiguration system.webServer/security/authentication/anonymousAuthentication -PSPath IIS:\ -Location "Default web site" -Value @{enabled="false"} 
Set-WebConfiguration system.webServer/security/authentication/basicAuthentication -PSPath IIS:\ -Location "Default web site" -Value @{enabled="true"} 
Get-WebBinding -Port 80 -Name "Default Web Site" | Remove-WebBinding 
if(!(test-path C:\inetpub\wwwroot\admin)){new-item C:\inetpub\wwwroot\admin -ItemType directory | out-null}
if(!(test-path C:\inetpub\wwwroot\admin\admin)){new-item C:\inetpub\wwwroot\admin\admin -ItemType directory | out-null}
$redirect = @"
<!DOCTYPE html>`n
<html>`n
<meta http-equiv="refresh" content="0; url=https://localhost/admin/admin/index.htm" />`n
<body>`n
</body>`n
</html>`n
"@
$redirect | out-file C:\inetpub\wwwroot\index.htm
Get-Website 'Default Web Site' | Stop-Website
Get-Website 'Default Web Site' | Start-Website

start-job -ScriptBlock{
    while($true){
    Sleep 30
	$file1 = Get-ChildItem $env:USERPROFILE\Desktop\PoSh_git\admin\master
	$file2 = Get-Item $env:USERPROFILE\Desktop\PoSh_git\admin\stager\index.htm -ErrorAction SilentlyContinue
	
    foreach($f1 in $file1)
        {
        if($file2.LastWriteTime -lt $f1.LastWriteTime)
            {
            & $f1.FullName | ConvertTo-Html | out-file $env:USERPROFILE\Desktop\PoSh_git\admin\stager\index.htm -Append
            "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" | out-file $env:USERPROFILE\Desktop\PoSh_git\admin\stager\index.htm -Append
            Copy-Item $env:USERPROFILE\Desktop\PoSh_git\admin\stager\index.htm C:\inetpub\wwwroot\admin\admin
            }
        else
            {
	        if(!(test-path $env:USERPROFILE\Desktop\PoSh_git\admin\stager\index.htm))
                {
                new-item $env:USERPROFILE\Desktop\PoSh_git\admin\stager\index.htm
                }
            }
        }
    } 
    }| out-null
 


