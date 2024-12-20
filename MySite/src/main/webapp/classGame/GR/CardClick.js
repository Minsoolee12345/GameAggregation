$(document).ready(function() {
    let firstCard = null;
    let secondCard = null;
    let lockBoard = false;
    const emojis = ['🌞', '❄', '🎁', '👍', '✨', '🎞', '🎵', '📷', '✉', '🍔', '🚲', '🌜'];
    let currentIndex = 0;

    function setCardClickEvent() {
        $('.card').on('click', function() {
            if (lockBoard || $(this).hasClass('flipped')) return;

            $(this).addClass('flipped');
            if (!firstCard) {
                firstCard = $(this);
            } else {
                secondCard = $(this);
                checkForMatch();
            }
        });
    }

    function checkForMatch() {
        lockBoard = true;
        if (firstCard.data('card') === secondCard.data('card')) {
            resetCards(true);
        } else {
            setTimeout(() => resetCards(false), 300);
        }
    }

    function resetCards(match) {
        if (!match) {
            firstCard.removeClass('flipped');
            secondCard.removeClass('flipped');
        }
        firstCard = null;
        secondCard = null;
        lockBoard = false;
    }

    // "다시 시작" 버튼
    $('#restart-button').on('click', function() {
        $('.card').removeClass('flipped');

        const cards = $('.card').toArray();
        cards.sort(() => Math.random() - 0.5);
        $('.game-board').empty().append(cards);

        setCardClickEvent();

        firstCard = null;
        secondCard = null;
        lockBoard = false;
    });

    // 난이도 증가 버튼 클릭 시 새로운 카드 추가
    $('#difficulty-button').on('click', function() {
        if (currentIndex >= emojis.length) {
            alert("게임 완료!");
            return;
        }

        const emoji1 = emojis[currentIndex];
        const emoji2 = emojis[currentIndex + 1];
        currentIndex += 2;

        const cardId = currentIndex / 2 + 6; // 새 카드 ID를 이전과 겹치지 않게 설정

        const card1 = $(`<div class="card" data-card="${cardId}">${emoji1}</div>`);
        const card2 = $(`<div class="card" data-card="${cardId}">${emoji1}</div>`);
        const card3 = $(`<div class="card" data-card="${cardId + 1}">${emoji2}</div>`);
        const card4 = $(`<div class="card" data-card="${cardId + 1}">${emoji2}</div>`);

        $('.game-board').append(card1, card2, card3, card4);

        setCardClickEvent();
    });

    setCardClickEvent();
});
