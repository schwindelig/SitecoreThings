$totalCalls = 10000
$url = "http://localhost"

Write-Host "Requesting $url $totalCalls times"

$total = 0;
for($i = 0; $i -ne $totalCalls; $i++) {

	$time = Measure-Command{
	    $result = Invoke-WebRequest $url -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue
	}

	$output = "$(Get-Date): $($time.TotalSeconds) seconds (HTTP $($result.StatusCode))"

	if($time.TotalSeconds -ge 1)
	{
		Write-Warning $output 
	}
	else
	{
		Write-Host $output
	}
	$total += $time.TotalSeconds
}

$average = $total / $totalCalls
Write-Host "Average:" $average "seconds"