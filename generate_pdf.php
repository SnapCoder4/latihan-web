<?php
// Include the main TCPDF library
require_once('TCPDF-main/tcpdf.php');

// Extend TCPDF class to create custom PDF
class MYPDF extends TCPDF
{
    // Colored table
    public function ColoredTable($header, $data)
    {
        // Colors, line width and bold font
        $this->SetFillColor(255, 0, 0);
        $this->SetTextColor(255);
        $this->SetDrawColor(128, 0, 0);
        $this->SetLineWidth(0.3);
        $this->SetFont('', 'B');

        // Header
        $w = array(40, 35, 40, 45);
        $num_headers = count($header);
        for ($i = 0; $i < $num_headers; ++$i) {
            $this->Cell($w[$i], 7, $header[$i], 1, 0, 'C', 1);
        }
        $this->Ln();

        // Color and font restoration
        $this->SetFillColor(224, 235, 255);
        $this->SetTextColor(0);
        $this->SetFont('');

        // Data
        $fill = 0;
        foreach ($data as $row) {
            $this->Cell($w[0], 6, $row['idjual'], 'LR', 0, 'L', $fill);
            $this->Cell($w[1], 6, $row['tgljual'], 'LR', 0, 'L', $fill);
            $this->Cell($w[2], 6, number_format($row['price']), 'LR', 0, 'R', $fill);
            $this->Cell($w[3], 6, number_format($row['quantity']), 'LR', 0, 'R', $fill);
            $this->Ln();
            $fill = !$fill;
        }
        $this->Cell(array_sum($w), 0, '', 'T');
    }
}

// Create new PDF document
$pdf = new MYPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'UTF-8', false);

// Set document information
$pdf->SetCreator(PDF_CREATOR);
$pdf->SetAuthor('Your Name');
$pdf->SetTitle('Data Transaksi');
$pdf->SetSubject('Transaksi PDF');
$pdf->SetKeywords('TCPDF, PDF, transaksi');

// Set default header data
$pdf->SetHeaderData(PDF_HEADER_LOGO, PDF_HEADER_LOGO_WIDTH, PDF_HEADER_TITLE, PDF_HEADER_STRING);

// Set header and footer fonts
$pdf->setHeaderFont(array(PDF_FONT_NAME_MAIN, '', PDF_FONT_SIZE_MAIN));
$pdf->setFooterFont(array(PDF_FONT_NAME_DATA, '', PDF_FONT_SIZE_DATA));

// Set margins
$pdf->SetMargins(PDF_MARGIN_LEFT, PDF_MARGIN_TOP, PDF_MARGIN_RIGHT);
$pdf->SetHeaderMargin(PDF_MARGIN_HEADER);
$pdf->SetFooterMargin(PDF_MARGIN_FOOTER);

// Set auto page breaks
$pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);

// Set some language-dependent strings (optional)
if (@file_exists(dirname(__FILE__) . '/lang/eng.php')) {
    require_once(dirname(__FILE__) . '/lang/eng.php');
    $pdf->setLanguageArray($l);
}

// Add a page
$pdf->AddPage();

// Column titles
$header = array('ID Transaksi', 'Tanggal Transaksi', 'Harga', 'Kuantitas');

// Connect to the database
require "db_connection.php"; // Pastikan Anda memiliki file ini untuk koneksi database

// Fetch data from the database
$sql = "SELECT idjual, tgljual, price, quantity FROM jual";
$result = $conn->query($sql);
$data = array();

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }
}

// Print colored table
$pdf->ColoredTable($header, $data);

// Close and output PDF document
$pdf->Output('data_transaksi.pdf', 'I');

// Close database connection
$conn->close();
