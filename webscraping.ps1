$w = Invoke-WebRequest -Uri "http://xxxx/pcms/Andon.aspx?view=xxxx" -SessionVariable DemoSession
$w = Invoke-WebRequest "http://xxxx/pcms/Andon.aspx?view=xxxx" -Method Post -Body $w -WebSession $DemoSession


# DataTable definition
$dtable = New-Object System.Data.DataTable
$dtable.Columns.Add("K", "System.String") | Out-Null
$dtable.Columns.Add("V", "System.String") | Out-Null

foreach ($x in $w.AllElements)
    {

            if ($x.ID)
            {
            $nRow = $dtable.NewRow()
            $nRow.K = $x.ID
            $nRow.V = $x.InnerText
            $dtable.Rows.Add($nRow)
            }
        
        }

#Define Connection string
$connectionString = 'Data Source=server-new;Initial Catalog=database;User=user;Pwd=password'
#truncate table

$cn2 = new-object system.data.SqlClient.SQLConnection($connectionString);
$cmd = new-object system.data.sqlclient.sqlcommand("truncate table TaskManagerDump", $cn2);
#$cmd = new-object system.data.sqlclient.sqlcommand("select * from TaskManagerDump", $cn2);

$cn2.Open();
if ($cmd.ExecuteNonQuery() -ne -1)
{
    echo "Failed";
}


#Bulk copy object instantiation
$bulkCopy = new-object ("Data.SqlClient.SqlBulkCopy") $connectionString
#Define the destination table 
$bulkCopy.DestinationTableName = "TaskManagerDump"
#load the data into the target
$bulkCopy.WriteToServer($dtable)
$bulkCopy.Close()

$cn2.Close();
