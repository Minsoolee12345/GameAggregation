<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
    <meta charset="UTF-8">
    <title>Python Coding Quiz</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="quiz-container">
        <h1>Python Coding Quiz</h1>
        <div id="question-container">
            <p id="question"></p>
            <div id="answer-buttons">
                <!-- Answer buttons will be inserted here dynamically -->
            </div>
        </div>
        <div id="score-container">
            <p>Your score: <span id="score">0</span></p>
        </div>
        <button id="next-button" onclick="nextQuestion()">Next Question</button>
    </div>
    <script src="script.js"></script>
</body>
</html>
