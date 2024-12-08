<?php 
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");

require 'db_connection.php';

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Retrieve data from POST
    $nama = $_POST['nama'];
    $email = $_POST['email'];
    $password = $_POST['password'];

    // Hash the password
    $hashed_password = password_hash($password, PASSWORD_DEFAULT);

    // Generate unique ID
    $id = 'E' . str_pad(rand(0, 9999), 4, '0', STR_PAD_LEFT);

    // Prepare the SQL query
    $query = "INSERT INTO user (id, nama, email, password) VALUES (?, ?, ?, ?)";

    // Initialize prepared statement
    if ($stmt = $conn->prepare($query)) {
        // Bind parameters to the query
        $stmt->bind_param('ssss', $id, $nama, $email, $hashed_password); // 'ssss' means all are strings

        // Execute the statement
        if ($stmt->execute()) {
            // Respond with success if the insertion is successful
            echo json_encode([
                'status' => 'success', 
                'message' => 'Pendaftaran Berhasil !!!', 
                'id' => $id
            ]);
        } else {
            // Log error and respond with failure message
            error_log("Database Error: " . $stmt->error);
            echo json_encode([
                'status' => 'error', 
                'message' => 'Pendaftaran Gagal'
            ]);
        }

        // Close the statement
        $stmt->close();
    } else {
        // Handle failure to prepare the statement
        echo json_encode([
            'status' => 'error',
            'message' => 'Failed to prepare SQL statement'
        ]);
    }

    // Close the connection
    $conn->close();
} else {
    // Handle if the request method is not POST
    echo json_encode([
        'status' => 'error',
        'message' => 'Invalid request method. Please use POST.'
    ]);
}
?>
