<?php
// Database connection
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "pronote";

$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get data from the AJAX request
$teacher_serial_number = $_POST['teacher_serial_number'];
$study_session_date = $_POST['study_session_date'];
$study_session_start_time = $_POST['study_session_start_time'];
$study_session_end_time = $_POST['study_session_end_time'];

// Generate a new study_session_id (incrementing)
$result = $conn->query("SELECT MAX(STUDY_SESSION_ID) AS max_id FROM STUDY_SESSION");
$row = $result->fetch_assoc();
$new_study_session_id = $row['max_id'] + 1;

// Insert the data into the study_session table
$sql = "INSERT INTO STUDY_SESSION (STUDY_SESSION_ID, TEACHER_SERIAL_NUMBER, STUDY_SESSION_DATE, STUDY_SESSION_START_TIME, STUDY_SESSION_END_TIME)
        VALUES ('$new_study_session_id', '$teacher_serial_number', '$study_session_date', '$study_session_start_time', '$study_session_end_time')";

if ($conn->query($sql) === TRUE) {
    echo "Study session inserted successfully";
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}

$conn->close();
?>