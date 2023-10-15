# 20231015 v1.0 ローカル実行を想定

$ChangeHostName = 's75mp213'
# $ChangeHostUser = 'Administrator'
# $ChangeHostPass = 'pass_s75mp213'

$TestIPaddress = '172.16.124.180'
$TestHostName = 's75mp180'
$TestHostUser = 'Administrator'
$TestHostPass = 'pass_s75mp180'



# パスワードを変更
$CnvrtTestHostPass = ConvertTo-SecureString -AsPlainText -Force -String $TestHostPass
Set-LocalUser -Name $ChangeHostName -Password $CnvrtTestHostPass 

# ノードマネージャの停止
$ServiceName = 'Oracle Weblogic base_domain NodeManager'
$GetService = Get-Service $ServiceName
if ($GetService.status -eq 'Running'){
    Stop-Service $ServiceName -Force
}


# StopComponent.cmd oh1 を実行 >>>>>>>>>>>>>>>>>>>>>>>>>>>>



# ホスト名変更　再起動しない -restart
Rename-Computer -NewName $TestHostName -DomainCredential $TestHostUser\$TestHostPass -Force
# ドメイン資格情報　-DomainCredential Domain01\Admin01
# Get-Credential

# IPアドレス変更 https://www.vwnet.jp/windows/PowerShell/2019052501/SetIPAddress.htm
Get-NetAdapter -Name 'イーサネット１' | New-NetIPAddress -AddressFamily IPv4 -IPAddress $TestIPaddress



#  httpd.conf dads.conf  rename >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



# ノードマネージャの起動
$ServiceName = 'Oracle Weblogic base_domain NodeManager'
$GetService = Get-Service $ServiceName
if ($GetService.status -eq 'Stopped'){
    Start-Service $ServiceName -Force
}



# StartComponent.cmd oh1 を実行 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



# データベースとリスナーの停止
lsnrctl stop
sqlplus /nolog
conn sys/pass_s75mp213 as sysdba
shutdown immediate


# tnsnames.ora listener.ora rename >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


# 変更前フォルダ削除 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



# OracleServiceORCLの停止
$ServiceName = 'OracleServiceORCL'
$GetService = Get-Service $ServiceName
if ($GetService.status -eq 'Running'){
    Stop-Service $ServiceName -Force
}


# OracleServiceORCL の資格情報を変更
$NewCredential = Get-Credential
$ServiceName = 'OracleServiceORCL'
Set-Service -Name $ServiceName -Credential $NewCredential

# OracleServiceORCL を起動
$GetService = Get-Service $ServiceName
if ($GetService.status -eq 'Stopped'){
    Stop-Service $ServiceName -Force
}


# OracleOraDB19Home1TNSListener の資格情報を変更
$ServiceName = 'OracleOraDB19Home1TNSListener'
Set-Service -Name $ServiceName -Credential $NewCredential

# OracleOraDB19Home1TNSListener を起動
$GetService = Get-Service $ServiceName
if ($GetService.status -eq 'Stopped'){
    Stop-Service $ServiceName -Force
}


# oracle パスワードを変更 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


# タスクスケジューラインポートフォルダ / ファイル取得バッチファイル　削除 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

## s75mp180
Remove-Item -Path F:\Task_Imp_Rcv -Force

Remove-Item -Path F:\GetBatchDmp.bat -Force
Remove-Item -Path F:\GetOrclFile.bat -Force

Remove-Item -Path F:\Rcv\Eds_Auto_bat\Rvc_DB.bat -Force
Remove-Item -Path F:\Rcv\Eds_Eng\Rvc_DB_Eng.bat -Force
Remove-Item -Path F:\Rcv\Setubi1\Rvc_DB_Setubi1.bat -Force
Remove-Item -Path F:\Rcv\Setubi2\Rvc_DB_Setubi2.bat -Force

## s75mp213
Remove-Item -Path F:\Task_Exp_Send -Force

Remove-Item -Path G:\backup\eng_exp.bat
Remove-Item -Path G:\backup\probexp.bat

exit
