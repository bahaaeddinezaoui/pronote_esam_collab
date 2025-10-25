<?php
header('Content-Type: application/json');

// --- DATABASE CONNECTION ---
$servername = "localhost";
$username_db = "root";
$password_db = "";
$dbname = "pronote";

$conn = new mysqli($servername, $username_db, $password_db, $dbname);

if ($conn->connect_error) {
    die(json_encode(["error" => "Database connection failed"]));
}

// --- SEARCH QUERY ---
$q = isset($_GET['q']) ? trim($_GET['q']) : '';
$sections = isset($_GET['sections']) ? $_GET['sections'] : [];

if ($q === '' || empty($sections)) {
    echo json_encode(["error" => "Invalid input: query or sections missing"]);
    exit;
}

// Debugging: Log input parameters
error_log("Query: $q");
error_log("Sections: " . print_r($sections, true));

// Prepare placeholders for the IN clause
$placeholders = implode(',', array_fill(0, count($sections), '?'));

try {
    // Prepare the SQL query
    $sql = "SELECT STUDENT_FIRST_NAME, STUDENT_LAST_NAME, STUDENT_SERIAL_NUMBER
            FROM STUDENT
            WHERE STUDENT_FIRST_NAME LIKE CONCAT('%', ?, '%')
            AND SECTION_ID IN ($placeholders)
            ORDER BY STUDENT_FIRST_NAME ASC
            LIMIT 10";

    $stmt = $conn->prepare($sql);

    if (!$stmt) {
        throw new Exception("Failed to prepare statement: " . $conn->error);
    }

    // Bind parameters dynamically
    $types = str_repeat('s', count($sections) + 1); // One for the query and the rest for sections
    $params = array_merge([$q], $sections);

    $stmt->bind_param($types, ...$params);

    $stmt->execute();
    $result = $stmt->get_result();

    $students = [];
    while ($row = $result->fetch_assoc()) {
        $students[] = $row;
    }

    echo json_encode($students);
    $stmt->close();
} catch (Exception $e) {
    error_log("Error: " . $e->getMessage());
    echo json_encode(["error" => "An error occurred while processing the request: " . $e->getMessage()]);
}

$conn->close();
?>