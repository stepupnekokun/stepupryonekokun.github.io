# 20231015 v1.0 ���[�J�����s��z��

$ChangeHostName = 's75mp213'
# $ChangeHostUser = 'Administrator'
# $ChangeHostPass = 'pass_s75mp213'

$TestIPaddress = '172.16.124.180'
$TestHostName = 's75mp180'
$TestHostUser = 'Administrator'
$TestHostPass = 'pass_s75mp180'



# �p�X���[�h��ύX
$CnvrtTestHostPass = ConvertTo-SecureString -AsPlainText -Force -String $TestHostPass
Set-LocalUser -Name $ChangeHostName -Password $CnvrtTestHostPass 

# �m�[�h�}�l�[�W���̒�~
$ServiceName = 'Oracle Weblogic base_domain NodeManager'
$GetService = Get-Service $ServiceName
if ($GetService.status -eq 'Running'){
    Stop-Service $ServiceName -Force
}


# StopComponent.cmd oh1 �����s >>>>>>>>>>>>>>>>>>>>>>>>>>>>



# �z�X�g���ύX�@�ċN�����Ȃ� -restart
Rename-Computer -NewName $TestHostName -DomainCredential $TestHostUser\$TestHostPass -Force
# �h���C�����i���@-DomainCredential Domain01\Admin01
# Get-Credential

# IP�A�h���X�ύX https://www.vwnet.jp/windows/PowerShell/2019052501/SetIPAddress.htm
Get-NetAdapter -Name '�C�[�T�l�b�g�P' | New-NetIPAddress -AddressFamily IPv4 -IPAddress $TestIPaddress



#  httpd.conf dads.conf  rename >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



# �m�[�h�}�l�[�W���̋N��
$ServiceName = 'Oracle Weblogic base_domain NodeManager'
$GetService = Get-Service $ServiceName
if ($GetService.status -eq 'Stopped'){
    Start-Service $ServiceName -Force
}



# StartComponent.cmd oh1 �����s >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



# �f�[�^�x�[�X�ƃ��X�i�[�̒�~
lsnrctl stop
sqlplus /nolog
conn sys/pass_s75mp213 as sysdba
shutdown immediate


# tnsnames.ora listener.ora rename >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


# �ύX�O�t�H���_�폜 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



# OracleServiceORCL�̒�~
$ServiceName = 'OracleServiceORCL'
$GetService = Get-Service $ServiceName
if ($GetService.status -eq 'Running'){
    Stop-Service $ServiceName -Force
}


# OracleServiceORCL �̎��i����ύX
$NewCredential = Get-Credential
$ServiceName = 'OracleServiceORCL'
Set-Service -Name $ServiceName -Credential $NewCredential

# OracleServiceORCL ���N��
$GetService = Get-Service $ServiceName
if ($GetService.status -eq 'Stopped'){
    Stop-Service $ServiceName -Force
}


# OracleOraDB19Home1TNSListener �̎��i����ύX
$ServiceName = 'OracleOraDB19Home1TNSListener'
Set-Service -Name $ServiceName -Credential $NewCredential

# OracleOraDB19Home1TNSListener ���N��
$GetService = Get-Service $ServiceName
if ($GetService.status -eq 'Stopped'){
    Stop-Service $ServiceName -Force
}


# oracle �p�X���[�h��ύX >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


# �^�X�N�X�P�W���[���C���|�[�g�t�H���_ / �t�@�C���擾�o�b�`�t�@�C���@�폜 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

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
