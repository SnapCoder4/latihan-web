<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");

require "db_connection.php";

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Retrieve login credentials from POST data
    $id = $_POST['id'];
    $password = $_POST['password'];

    // Prepare the SQL query with a placeholder
    $query = "SELECT id, password FROM user WHERE id = ?";
    
    // Initialize prepared statement
    if ($stmt = $conn->prepare($query)) {
        // Bind the parameter to the placeholder
        $stmt->bind_param('s', $id); // 's' means the parameter is a string

        // Execute the query
        $stmt->execute();

        // Get the result
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            $user = $result->fetch_assoc();
            
            // Verify the provided password with the stored hashed password
            if (password_verify($password, $user['password'])) {
                // Return success if login is successful
                echo json_encode([
                    'status' => 'success',
                    'message' => 'Login Berhasil',
                ]);
            } else {
                // Return error if password is incorrect
                echo json_encode([
                    'status' => 'error',
                    'message' => 'Invalid ID or password',
                ]);
            }
        } else {
            // Return error if user ID does not exist
            echo json_encode([
                'status' => 'error',
                'message' => 'Invalid ID or password',
            ]);
        }

        // Close the statement
        $stmt->close();
    } else {
        echo json_encode([
            'status' => 'error',
            'message' => 'Failed to prepare SQL statement',
        ]);
    }
} else {
    // Return error if the request method is not POST
    echo json_encode([
        'status' => 'error',
        'message' => 'Invalid request method',
    ]);
}

$conn->close();
?>
