
<#
.SYNOPSIS
    Pac Argument Completer
.DESCRIPTION
    Pac Argument Completer

    pac is a command line interface (CLI) tool that provides a set of commands to automate deployment and other actions against Power Platform environments and solutions.

    syntax: pac <command> [options] [parameters]
   
 .EXAMPLE

 #>
[scriptblock]$Completer = {
    param(
        $WordToComplete,
        $CommandAst,
        $CursorPosition
    )

    function __debug {
        if ($env:ARG_COMPLETION_DEBUG_FILE) {
            "$args" | Out-File -Append -FilePath "$((get-date).Ticks): $env:ARG_COMPLETION_DEBUG_FILE"
        }
    }

    $Commands = @(
        'admin'
        'application'
        'auth'
        'canvas'
        'catalog'
        'connection'
        'connector'
        'copilot'
        'data'
        'help'
        'modelbuilder'
        'org'
        'package'
        'pcf'
        'pipeline'
        'plugin'
        'power-fx'
        'powerpages'
        'solution'
        'telemetry'
        'test'
        'tool'
    )

    $Command = $CommandAst.CommandElements
    $Command = "$Command"
    
    __debug ""
    __debug "638418638969266821========= starting completion logic =========="
    __debug "WordToComplete: $WordToComplete Command: $Command CursorPosition: $CursorPosition"
    
    $Commands | Where-Object { $_ -like "$WordToComplete*" }
}

Register-ArgumentCompleter -CommandName 'pac' -ScriptBlock $Completer