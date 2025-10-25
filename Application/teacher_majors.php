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

// teacher serial expected
$serial = isset($_GET['serial']) ? trim($_GET['serial']) : '';

if ($serial === '') {
    echo json_encode([]);
    exit;
}

// Fetch majors that this teacher teaches
$stmt = $conn->prepare("\n    SELECT m.MAJOR_ID, m.MAJOR_NAME
    FROM TEACHES t
    JOIN MAJOR m ON t.MAJOR_ID = m.MAJOR_ID
    WHERE t.TEACHER_SERIAL_NUMBER = ?
    ORDER BY m.MAJOR_NAME ASC
    LIMIT 5
\n");

$stmt->bind_param("s", $serial);
$stmt->execute();

$result = $stmt->get_result();

$majors = [];
while ($row = $result->fetch_assoc()) {
    $majors[] = $row;
}

echo json_encode($majors);
$stmt->close();
$conn->close();
?>