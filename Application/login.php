<?php
session_start();

// Set timezone
date_default_timezone_set('Africa/Algiers');

// --- DATABASE CONNECTION ---
$servername = "localhost";
$username_db = "root";
$password_db = "";
$dbname = "pronote";

$conn = new mysqli($servername, $username_db, $password_db, $dbname);

if ($conn->connect_error) {
    die("Database connection failed: " . $conn->connect_error);
}

// --- READ FORM INPUT ---
$username = $_POST['username'];
$password = $_POST['password'];

// --- FETCH USER ---
$sql = "SELECT * FROM USER_ACCOUNT WHERE USERNAME = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $username);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 1) {
    $user = $result->fetch_assoc();

    // Check password (assuming PASSWORD_HASH contains a bcrypt hash)
    if (password_verify($password, $user['PASSWORD_HASH'])) {
        // Save user info in session
        $_SESSION['user_id'] = $user['USER_ID'];
        $_SESSION['role'] = $user['ROLE'];

        // Redirect based on role
        if ($user['ROLE'] === 'Class') {
            header("Location: session_information.html");
            exit();
        } elseif ($user['ROLE'] === 'Admin') {
            header("Location: admin_check_classes.html");
            exit();
        } else {
            echo "<script>alert('Unknown role: " . htmlspecialchars($user['ROLE']) . "');</script>";
        }
    } else {
        echo "<script>alert('Invalid password.'); window.history.back();</script>";
    }
} else {
    echo "<script>alert('User not found.'); window.history.back();</script>";
}

$conn->close();
?>
