#######################
<#
.SYNOPSIS
Creates a DataTable for an object
.DESCRIPTION
Creates a DataTable based on an objects properties.
.INPUTS
Object
    Any object can be piped to Out-DataTable
.OUTPUTS
   System.Data.DataTable
.EXAMPLE
$dt = Get-Alias | Out-DataTable
This example creates a DataTable from the properties of Get-Alias and assigns output to $dt variable
.NOTES
Adapted from script by Marc van Orsouw see link
Version History
v1.0   - Chad Miller - Initial Release
v1.1   - Chad Miller - Fixed Issue with Properties
v1.2  -  Chad Miller - Added setting column datatype by property as suggested by emp0
v1.3  -  Chad Miller - Correct issue with setting datatype on empty properties
.LINK
http://thepowershellguy.com/blogs/posh/archive/2007/01/21/powershell-gui-scripblock-monitor-script.aspx
#>
function Out-DataTable
{
    [CmdletBinding()]
    param([Parameter(Position=0, Mandatory=$true, ValueFromPipeline = $true)] [PSObject[]]$InputObject)

    Begin
    {
        $dt = new-object Data.datatable  
        $First = $true 
    }
    Process
    {
        foreach ($object in $InputObject)
        {
            $DR = $DT.NewRow()  
            foreach($property in $object.PsObject.get_properties())
            {  
                if ($first)
                {  
                    $Col =  new-object Data.DataColumn  
                    $Col.ColumnName = $property.Name.ToString()  
                    if ($property.value)
                    { $Col.DataType = $property.value.gettype() }
                    $DT.Columns.Add($Col)
                }  
                if ($property.IsArray)
                { $DR.Item($property.Name) =$property.value | ConvertTo-XML -AS String -NoTypeInformation -Depth 1 }  
                else { $DR.Item($property.Name) = $property.value }  
            }  
            $DT.Rows.Add($DR)  
            $First = $false
        }
    } 
     
    End
    {
        Write-Output @(,($dt))
    }

} #Out-DataTable