// 100문제 준비
const allQuestions = [
    { question: "다음 중 print(2 + 3 * 4)의 출력값은?", answers: [
        { text: "14", correct: true },
        { text: "20", correct: false },
        { text: "12", correct: false },
        { text: "11", correct: false }
    ]},
    { question: "다음 중 파이썬에서 함수 정의를 할 때 사용하는 키워드는?", answers: [
        { text: "def", correct: true },
        { text: "function", correct: false },
        { text: "func", correct: false },
        { text: "define", correct: false }
    ]},
    { question: "파이썬에서 'len' 함수의 역할은?", answers: [
        { text: "객체의 길이를 반환", correct: true },
        { text: "소문자로 변환", correct: false },
        { text: "두 숫자를 더함", correct: false },
        { text: "객체가 존재하는지 확인", correct: false }
    ]},
    // 100문제 추가
    { question: "파이썬에서 지수 연산을 수행하는 연산자는?", answers: [
        { text: "**", correct: true },
        { text: "^", correct: false },
        { text: "^^", correct: false },
        { text: "exp", correct: false }
    ]},
    { question: "print(5 // 2)의 출력값은?", answers: [
        { text: "2", correct: true },
        { text: "2.5", correct: false },
        { text: "5", correct: false },
        { text: "0", correct: false }
    ]},
    { question: "다음 중 파이썬에서 'self' 키워드는 무엇을 나타내는가?", answers: [
        { text: "클래스의 현재 인스턴스", correct: true },
        { text: "전역 변수", correct: false },
        { text: "파이썬 내장 함수", correct: false },
        { text: "메서드의 인자", correct: false }
    ]},
    // 100문제 전부 추가
];

// 100문제 중 랜덤으로 20문제 뽑기
function getRandomQuestions(allQuestions, numQuestions) {
    const shuffled = [...allQuestions].sort(() => Math.random() - 0.5); // 문제 섞기
    return shuffled.slice(0, numQuestions); // 첫 20문제 선택
}

let currentQuestionIndex = 0;
let score = 0;
const selectedQuestions = getRandomQuestions(allQuestions, 20); // 20문제 선택

// 게임 시작 함수
function startGame() {
    nextQuestion();
}

// 문제 진행 함수
function nextQuestion() {
    if (currentQuestionIndex >= selectedQuestions.length) {
        endGame();
        return;
    }

    const questionContainer = document.getElementById("question-container");
    const answerButtons = document.getElementById("answer-buttons");

    // 답변 버튼 초기화
    answerButtons.innerHTML = "";

    // 현재 문제 가져오기
    const currentQuestion = selectedQuestions[currentQuestionIndex];
    document.getElementById("question").innerText = currentQuestion.question;

    // 답변 버튼 표시
    currentQuestion.answers.forEach(answer => {
        const button = document.createElement("button");
        button.innerText = answer.text;
        button.addEventListener("click", () => selectAnswer(answer));
        answerButtons.appendChild(button);
    });
}

// 정답 선택 함수
function selectAnswer(answer) {
    if (answer.correct) {
        score += 10;  // 정답일 경우 10점 추가
        document.getElementById("score").innerText = score; // 점수 업데이트
    }
    currentQuestionIndex++;
    nextQuestion();
}

// 게임 종료 함수
function endGame() {
    const score = document.getElementById("score").innerText;
    const url = `/game?score=${score}`; // 점수 서버로 전송
    window.location.href = url;  // 결과 페이지로 이동
}

// 게임 시작
startGame();
