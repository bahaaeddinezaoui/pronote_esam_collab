<?php
header('Content-Type: application/json');

// --- DATABASE CONNECTION ---
$servername = "localhost";
$username_db = "root";
$password_db = "";
$dbname = "pronote";

$conn = new mysqli($servername, $username_db, $password_db, $dbname);

if ($conn->connect_error) {
    die(json_encode([]));
}

$major = isset($_GET['major']) ? trim($_GET['major']) : '';
$category = isset($_GET['category']) ? trim($_GET['category']) : '';

if ($major === '' || $category === '') {
    echo json_encode([]);
    exit;
}

// Find sections in the given category that study the given major and count students in each section
$stmt = $conn->prepare("  
    SELECT sec.SECTION_ID, sec.SECTION_NAME, sec.CATEGORY_ID, s.MAJOR_ID, COUNT(st.STUDENT_SERIAL_NUMBER) AS TOTAL_STUDENTS
    FROM SECTION sec
    JOIN STUDIES s ON sec.SECTION_ID = s.SECTION_ID
    LEFT JOIN STUDENT st ON sec.SECTION_ID = st.SECTION_ID
    WHERE sec.CATEGORY_ID = ? AND s.MAJOR_ID = ?
    GROUP BY sec.SECTION_ID, sec.SECTION_NAME, sec.CATEGORY_ID, s.MAJOR_ID
    ORDER BY sec.SECTION_NAME ASC
");

// Debug values
error_log("Category ID: " . $category);
error_log("Major ID: " . $major);

if (!$stmt) {
    // prepare failed — return empty array and optionally include error for debugging
    echo json_encode([]);
    $conn->close();
    exit;
}

// Bind as strings to be tolerant of incoming parameter types (category may arrive as string)
$stmt->bind_param("ss", $category, $major);
$stmt->execute();

$result = $stmt->get_result();

$sections = [];
while ($row = $result->fetch_assoc()) {
    $sections[] = $row;
}

// Debug output
error_log("Query results: " . json_encode($sections));

if (empty($sections)) {
    echo json_encode(["message" => "No session is available!"]);
} else {
    echo json_encode($sections);
}

$stmt->close();
$conn->close();
?>