<#

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


function new-user{
    if(!(get-localuser).name -like "admin")
        {
	"Creating User..."
        $password = ConvertTo-SecureString "empiredidnothingwrong" -AsPlainText -Force
        New-LocalUser "admin" -Password $Password -FullName "webuser" | out-null
        }
    }


function gen-cert{
    if((Get-NetTCPConnection).LocalPort -ne 443)
        {
	"Generating Self-Signed Certificate..."
        Install-WindowsFeature -Name Web-server -IncludeAllSubFeature
        import-module webadministration
        Set-Location IIS:\SslBindings
        New-WebBinding -Name "Default Web Site" -IP "*" -Port 4434 -Protocol https
        $newCert = New-SelfSignedCertificate -DnsName "localhosst" -CertStoreLocation cert:\LocalMachine\my | out-null
        $newCert | New-Item 0.0.0.0!4434 | out-null

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
        }
    }



function watcher{
    start-job -ScriptBlock{
        Sleep 30
	    $file1 = Get-ChildItem $env:USERPROFILE\Desktop\PoSh_git\admin\master
	    $file2 = Get-Item $env:USERPROFILE\Desktop\PoSh_git\admin\stager
	
        foreach($f1 in $file1)
            {
            if($file2.LastWriteTime -gt $f1.LastWriteTime)
                {
                & $f1.FullName | ConvertTo-Html | out-file $env:USERPROFILE\Desktop\PoSh_git\admin\stager\index.htm -Append
                "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" | out-file $env:USERPROFILE\Desktop\PoSh_git\admin\stager\index.htm -Append
                Copy-Item $env:USERPROFILE\Desktop\PoSh_git\admin\stager\index.htm C:\inetpub\wwwroot\admin\admin
                }
            else
                {
	            new-item $env:USERPROFILE\Desktop\PoSh_git\admin\stager\index.htm
                }
            }
        } | out-null

    }

new-user
gen-cert
Set-WebConfiguration system.webServer/security/authentication/anonymousAuthentication -PSPath IIS:\ -Location "Default web site" -Value @{enabled="false"} 
Set-WebConfiguration system.webServer/security/authentication/basicAuthentication -PSPath IIS:\ -Location "Default web site" -Value @{enabled="true"} 
Get-WebBinding -Port 80 -Name "Default Web Site" | Remove-WebBinding 
Get-Website 'Default Web Site' | Stop-Website
Get-Website 'Default Web Site' | Start-Website
if(!(test-path C:\inetpub\wwwroot\admin)){new-item C:\inetpub\wwwroot\admin -ItemType directory | out-null}
if(!(test-path C:\inetpub\wwwroot\admin\admin)){new-item C:\inetpub\wwwroot\admin\admin -ItemType directory | out-null}
watcher




