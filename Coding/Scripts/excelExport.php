<?php
session_start();

$filename = "webtoolOutput";

header("Content-Type: application/xls");
header("Content-Disposition: attachment; filename=$filename.xls");
header("Pragma: no-cache");
header("Expires: 0");

$data = <<<HTML

<html xmlns:x="urn:schemas-microsoft-com:office:excel">
<head>
  <!--[if gte mso9]>
  <xml>
    <x:ExcelWorkbook>
      <x:ExcelWorksheets>
        <x:ExcelWorksheet>
          <x:Name>Sheet 1</x:Name>
            <x:WorksheetOptions>
              <x:Print>
                <x:ValidPrinterInfo/>
              </x:Print>
          </x:WorksheetOptions>
        </x:ExcelWorksheet>
      <//x:ExcelWorksheets>
    </x:ExcelWorkbook>
  </xml>
  <!--[endif]-->
</head>

<body>
  <table>{$_SESSION["basket"]}</table>
</body>
</html>
HTML;

echo $data;