# Tencent is pleased to support the open source community by making Polaris available.
#
# Copyright (C) 2019 THL A29 Limited, a Tencent company. All rights reserved.
#
# Licensed under the BSD 3-Clause License (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://opensource.org/licenses/BSD-3-Clause
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

$ErrorActionPreference = "Stop"

function uninstallPolarisServer {
    Write-Output "uninstall polaris server ... "
    $target_polaris_server_pkg = (Get-ChildItem "polaris-server-release*.zip")[0].Name
    $polaris_server_dirname = ([io.fileinfo]$target_polaris_server_pkg).basename
    $exists = (Test-Path ".\\$polaris_server_dirname")
    Write-Output "exists $exists"
    if ($exists) {
        Push-Location $polaris_server_dirname/tool
        Write-Output "start to execute polaris-server uninstall script"
        Start-Process -FilePath ".\\stop.bat" -NoNewWindow -Wait
        Pop-Location
        $cur_path=(Get-Location)
        Write-Output "cur path is $cur_path"
        Write-Output "start to remove $polaris_server_dirname"
        Remove-Item ".\\${polaris_server_dirname}" -Recurse
    }
    Write-Output "uninstall polaris server success"
}

function uninstallPolarisConsole {
    Write-Output "uninstall polaris console ... "
    $target_polaris_console_pkg =  (Get-ChildItem "polaris-console-release*.zip")[0].Name
    $polaris_console_dirname = ([io.fileinfo]$target_polaris_console_pkg).basename
    $exists = (Test-Path $polaris_console_dirname)
    if ($exists) {
        Push-Location $polaris_console_dirname/tool
        Write-Output "start to execute polaris-console uninstall script"
        Start-Process -FilePath ".\\stop.bat" -NoNewWindow -Wait
        Pop-Location
        Write-Output "start to remove $polaris_console_dirname"
        Remove-Item ${polaris_console_dirname} -Recurse
    }
    Write-Output "uninstall polaris console success"
}

function uninstallPrometheus {
    Write-Output "uninstall prometheus ... "
    Get-Process | ForEach-Object($_.name) {
        if($_.name -eq "prometheus"){
            $process_pid = $_.Id
            Write-Output "start to kill prometheus process $process_pid"
            Stop-Process -Id $process_pid
        }
    }
    $target_prometheus_pkg =  (Get-ChildItem "prometheus-*.zip")[0].Name
    $prometheus_dirname = ([io.fileinfo]$target_prometheus_pkg).basename
    $exists = (Test-Path $prometheus_dirname)
    if ($exists) {
        Start-Sleep -Seconds 2
        Remove-Item ${prometheus_dirname} -Recurse
    }
    Write-Output "uninstall prometheus success"
}

function uninstallPushGateway {
    Write-Output "uninstall pushgateway ... "
    Get-Process | ForEach-Object($_.name) {
        if($_.name -eq "pushgateway"){
            $process_pid = $_.Id
            Write-Output "start to kill pushgateway process $process_pid"
            Stop-Process -Id $process_pid
        }
    }
    $target_pgw_pkg =  (Get-ChildItem "pushgateway-*.zip")[0].Name
    $pgw_dirname = ([io.fileinfo]$target_pgw_pkg).basename
    $exists = (Test-Path $pgw_dirname)
    if ($exists) {
        Start-Sleep -Seconds 2
        Remove-Item ${pgw_dirname} -Recurse
        return
    }
    Write-Output "uninstall pushgateway success"
}

# 卸载server
uninstallPolarisServer
# 安装console
uninstallPolarisConsole
# 安装Prometheus
uninstallPrometheus
# 安装PushGateWay
uninstallPushGateway