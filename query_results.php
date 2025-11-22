<?php
$host = 'localhost';
$db   = 'blueberrypearl_aquarium';
$user = 'root';
$pass = '';
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;dbname=$db;charset=$charset";
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
];

try {
    $pdo = new PDO($dsn, $user, $pass, $options);
} catch (PDOException $e) {
    echo "DB connection failed: " . $e->getMessage();
    exit;
}

/* ----------------------------------------
   DEFINE ALL YOUR QUERIES HERE
-----------------------------------------*/
$queries = [
    1 => [
        "label" => "Avg Ticket Price per Event",
        "sql" => "SELECT 
                    ev.EventName,
                    AVG(v.TicketPrice) AS AvgTicketPrice
                  FROM Event ev
                  JOIN SignUp s ON ev.EventID = s.EventID
                  JOIN Visitor v ON s.VisitorID = v.VisitorID
                  GROUP BY ev.EventID"

    ],
    2 => [
        "label" => "Habitats w/ the most Animals",
        "sql" => "SELECT
                    h.HabitatName,
                    COUNT(a.AnimalID) AS TotalAnimals
                  FROM Habitat h
                  LEFT JOIN Animal a ON h.HabitatID = a.HabitatID
                  GROUP BY h.HabitatName
                  ORDER BY TotalAnimals DESC"
    ],
    3 => [
        "label" => "Num of Vistors per Event",
        "sql" => "SELECT ev.EventID, ev.EventName, ev.EventDate, COUNT(s.VisitorID) AS NumVisitors
                  FROM Event ev
                  LEFT JOIN SignUp s ON s.EventID = ev.EventID
                  GROUP BY ev.EventID, ev.EventDate
                  ORDER BY NumVisitors "
    ],
    4 => [
        "label" => "Busiest Employee",
        "sql" => "SELECT 
                        e.FirstName,
                        e.LastName,
                        ev.EventName,
                        COUNT(s.SignUpID) AS TotalVisitors
                    FROM Event ev
                    JOIN Employee e ON ev.EmployeeID = e.EmployeeID
                    LEFT JOIN SignUp s ON ev.EventID = s.EventID
                    GROUP BY ev.EventID
                    ORDER BY TotalVisitors DESC"
    ],
    5 => [
        "label" => "Animals per Country",
        "sql" => "SELECT
                    c.CountryName,
                    COUNT(a.AnimalID) AS TotalAnimals
                  FROM Country c
                  LEFT JOIN Animal a ON c.CountryID = a.CountryID
                  GROUP BY c.CountryName
                  ORDER BY TotalAnimals DESC"
    ],
    6 => [
        "label" => "Total Revenue per Event",
        "sql" => "SELECT 
                    ev.EventName,
                    SUM(v.TicketPrice) AS RevenueFromAttendees
                  FROM Event ev
                  JOIN SignUp s ON ev.EventID = s.EventID
                  JOIN Visitor v ON s.VisitorID = v.VisitorID
                  GROUP BY ev.EventID
                  ORDER BY RevenueFromAttendees DESC "
    ],
    7 => [
        "label" => "Total Number of Animals each Emp has",
        "sql" => "SELECT
                    e.EmployeeID,
                    e.FirstName,
                    e.Lastname,
                    COUNT(DISTINCT f.AnimalID) AS AnimalsFed
                  FROM Employee e
                  JOIN Feeding f ON e.EmployeeID = f.EmployeeID
                  GROUP BY e.EmployeeID
                  ORDER BY AnimalsFed DESC"
    ]
];

// Detect selected query
$selected = $_GET['q'] ?? null;
$rows = [];

if ($selected && isset($queries[$selected])) {
    $stmt = $pdo->query($queries[$selected]['sql']);
    $rows = $stmt->fetchAll();
}
?>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Dynamic SQL Queries</title>

<style>
/* -------------------------------
   AQUARIUM BACKGROUND + BUBBLES
--------------------------------*/
body {
    margin: 0;
    padding: 20px;
    background: linear-gradient(to bottom, #004e92, #000428);
    overflow-x: hidden;
    font-family: Arial, sans-serif;
    color: white;
    position: relative;
}

/* Bubble container */
.bubble {
    position: absolute;
    bottom: -150px;
    width: 40px;
    height: 40px;
    background: rgba(255,255,255,0.25);
    border-radius: 50%;
    filter: blur(1px);
    animation: rise 8s infinite ease-in;
}

/* Bubble animation */
@keyframes rise {
    0% { transform: translateY(0) scale(0.8); opacity: 1; }
    100% { transform: translateY(-120vh) scale(1.4); opacity: 0; }
}

/* Random bubble positions & speeds */
.bubble:nth-child(1) { left: 10%; width: 25px; height: 25px; animation-duration: 10s; }
.bubble:nth-child(2) { left: 25%; width: 35px; height: 35px; animation-duration: 12s; }
.bubble:nth-child(3) { left: 40%; width: 20px; height: 20px; animation-duration: 9s; }
.bubble:nth-child(4) { left: 55%; width: 30px; height: 30px; animation-duration: 11s; }
.bubble:nth-child(5) { left: 65%; width: 45px; height: 45px; animation-duration: 13s; }
.bubble:nth-child(6) { left: 75%; width: 22px; height: 22px; animation-duration: 9.5s; }
.bubble:nth-child(7) { left: 85%; width: 28px; height: 28px; animation-duration: 12.5s; }
.bubble:nth-child(8) { left: 50%; width: 50px; height: 50px; animation-duration: 14s; }

/* -------------------------------
   TABLE + BUTTON STYLES
--------------------------------*/
button {
    padding: 12px 25px;
    margin: 8px;
    border: none;
    background: rgba(0, 180, 255, 0.8);
    color: white;
    border-radius: 8px;
    cursor: pointer;
    transition: 0.25s;
    font-size: 16px;
}

button:hover {
    background: rgba(0, 220, 255, 0.95);
    transform: scale(1.05);
}

table { 
    border-collapse: collapse; 
    width: 100%; 
    margin-top: 20px; 
    background: rgba(255, 255, 255, 0.07);
    border-radius: 10px;
    overflow: hidden;
}

th, td { 
    padding: 10px; 
    border: 1px solid rgba(255,255,255,0.25); 
    text-align: left; 
    color: white;
}

th { 
    background: rgba(255,255,255,0.15); 
}

</style>
</head>
<body>
<div class="bubble"></div>
<div class="bubble"></div>
<div class="bubble"></div>
<div class="bubble"></div>
<div class="bubble"></div>
<div class="bubble"></div>
<div class="bubble"></div>
<div class="bubble"></div>
<div class="bubble"></div>
<div class="bubble"></div>
<div class="bubble"></div>
<div class="bubble"></div>
<div class="bubble"></div>
<div class="bubble"></div>
<div class="bubble"></div>
<div class="bubble"></div>

<h2>Blueberrypearl Aquarium Statistics </h2>

<!-- Buttons -->
<?php foreach ($queries as $id => $q): ?>
    <form style="display:inline;" method="get">
        <input type="hidden" name="q" value="<?= $id ?>">
        <button type="submit"><?= htmlspecialchars($q['label']) ?></button>
    </form>
<?php endforeach; ?>

<hr>

<!-- Output Table -->
<?php if ($selected && $rows): ?>
    <h3>Results: <?= htmlspecialchars($queries[$selected]['label']) ?></h3>

    <table>
        <thead>
            <tr>
            <?php foreach (array_keys($rows[0]) as $col): ?>
                <th><?= htmlspecialchars($col) ?></th>
            <?php endforeach; ?>
            </tr>
        </thead>

        <tbody>
        <?php foreach ($rows as $r): ?>
            <tr>
                <?php foreach ($r as $value): ?>
                    <td><?= htmlspecialchars($value) ?></td>
                <?php endforeach; ?>
            </tr>
        <?php endforeach; ?>
        </tbody>
    </table>
<?php elseif ($selected): ?>
    <p>No results found.</p>
<?php endif; ?>

</body>
</html>
