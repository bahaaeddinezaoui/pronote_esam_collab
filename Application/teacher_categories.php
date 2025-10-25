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

$serial = isset($_GET['serial']) ? trim($_GET['serial']) : '';

if ($serial === '') {
    echo json_encode([]);
    exit;
}

// Fetch categories that this teacher teaches via: TEACHES -> STUDIES -> SECTION -> CATEGORY
$stmt = $conn->prepare("\n    SELECT DISTINCT c.CATEGORY_ID, c.CATEGORY_NAME
    FROM TEACHES t
    JOIN STUDIES s ON t.MAJOR_ID = s.MAJOR_ID
    JOIN SECTION sec ON s.SECTION_ID = sec.SECTION_ID
    JOIN CATEGORY c ON sec.CATEGORY_ID = c.CATEGORY_ID
    WHERE t.TEACHER_SERIAL_NUMBER = ?
    ORDER BY c.CATEGORY_NAME ASC
    LIMIT 5
\n");

$stmt->bind_param("s", $serial);
$stmt->execute();

$result = $stmt->get_result();

$cats = [];
while ($row = $result->fetch_assoc()) {
    $cats[] = $row;
}

// Debug logging
error_log("Categories for teacher " . $serial . ": " . json_encode($cats));

echo json_encode($cats);
$stmt->close();
$conn->close();
?>