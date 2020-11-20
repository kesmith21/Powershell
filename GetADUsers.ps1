Import-Module activedirectory

$dtable = New-Object System.Data.DataTable
$dtable.Columns.Add("Name", "System.String") | Out-Null
$dtable.Columns.Add("GivenName", "System.String") | Out-Null
$dtable.Columns.Add("Surname", "System.String") | Out-Null
$dtable.Columns.Add("UserPrincipalName", "System.String") | Out-Null

$Results = get-aduser -filter * |
Select-Object Name, GivenName, Surname, UserPrincipalName


foreach ($item in $Results) {
    
    $nRow = $dtable.NewRow()
            $nRow.Name = $item.Name
            $nRow.GivenName = $item.GivenName
            $nRow.Surname = $item.Surname
            $nRow.UserPrincipalName = $item.UserPrincipalName
            $dtable.Rows.Add($nRow)

    }

$dtable

$connectionString = 'Data Source=xxx;Initial Catalog=ICS_Reporting;User=xx;Pwd=xxx'
$cn2 = new-object system.data.SqlClient.SQLConnection($connectionString);
$cmd = new-object system.data.sqlclient.sqlcommand("truncate table ADUsers_1", $cn2);


$cn2.Open();
$cmd.ExecuteNonQuery()

#Bulk copy object instantiation
$bulkCopy = new-object ("Data.SqlClient.SqlBulkCopy") $connectionString
#Define the destination table 
$bulkCopy.DestinationTableName = "ADUsers_1"
#load the data into the target
$bulkCopy.WriteToServer($dtable)
$bulkCopy.Close()

$cn2.Close();
