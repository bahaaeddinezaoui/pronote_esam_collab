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

// --- SEARCH QUERY ---
$q = isset($_GET['q']) ? trim($_GET['q']) : '';

if ($q === '') {
    echo json_encode([]);
    exit;
}

// Prevent SQL injection using prepared statements
    $stmt = $conn->prepare("
        SELECT TEACHER_SERIAL_NUMBER, TEACHER_FIRST_NAME, TEACHER_LAST_NAME
    FROM TEACHER
    WHERE TEACHER_FIRST_NAME LIKE CONCAT('%', ?, '%')
       OR TEACHER_LAST_NAME LIKE CONCAT('%', ?, '%')
    ORDER BY TEACHER_LAST_NAME ASC
    LIMIT 5
");
$stmt->bind_param("ss", $q, $q);
$stmt->execute();

$result = $stmt->get_result();

$teachers = [];
while ($row = $result->fetch_assoc()) {
    $teachers[] = $row;
}

echo json_encode($teachers);
$stmt->close();
$conn->close();
?>
