$database = "master"
$root = Get-Item -Path (@{$true="$($database):\content"; $false="$($database):\content"}[(Test-Path -Path "$($database):\content")])

$versionOptions = [ordered]@{
    "Latest"="1"
}

$props = @{
    Parameters = @(
        @{Name="root"; Title="Choose the root"; Tooltip="Only items in this branch will be returned."; Columns=9},
        @{Name="searchVersion"; Value="1"; Title="Version"; Options=$versionOptions; Tooltip="Choose a version."; Columns="3"; Placeholder="All"}
    )
    Title = "Totall Broken Links"
    Description = "Choose the criteria for the report."
    Width = 550
    Height = 300
    ShowHints = $true
}

$result = Read-Variable @props

if($result -eq "cancel"){
    exit
}


filter HasBrokenLink {
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [Sitecore.Data.Items.Item]$Item,
        
        [Parameter()]
        [bool]$IncludeAllVersions
    )
    
    if($Item) {
        try {
            $item.Links.GetBrokenLinks($IncludeAllVersions) > $null
        }
        catch{
            Write-Warning "Totally Broken Item: $($Item.ID)"
        }
    }
}

Get-ChildItem -Path $root.ProviderPath -Recurse | HasBrokenLink -IncludeAllVersions (!$searchVersion)