<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div style="background-color: #dcdcdc; border-radius: 15px; padding: 20px; max-width: 600px; margin: 0 auto;">
<h3>지렁이 게임 (Snake Game)</h3><br>

지렁이 게임은 플레이어가 지렁이를 조종하여 먹이를 먹고 성장시키는 간단한 게임입니다. 플레이어는 화면에 나타나는 먹이를 먹어 지렁이를 길게 만들며 최고 점수를 도전할 수 있습니다.<br>
<h4>플레이어 지렁이</h4>
<div style="background-color: green; width: 25px; height: 25px "></div>
플레이어가 조작하는 지렁이입니당

<h4>먹이</h4>
<div style="background-color: red; width: 25px; height: 25px "></div>
빨간색 사과입니당

<h4>돌</h4>
※먹지마세요※
<div style="background-color: black; width: 25px; height: 25px "></div>
생성되기 1초 전에 회색으로 표시됩니당
<div style="background-color: grey; width: 25px; height: 25px "></div>
<h4>조작 방법</h4><br>

화살표 키를 사용해 지렁이의 이동 방향을 상하좌우로 변경시킬 수 있습니다.<br>
→ : 오른쪽 방향 전환<br>← : 왼쪽 방향 전환<br>↑ : 위쪽 방향 전환<br>↓ : 아래쪽 방향 전환<br>

<h4>먹이와 성장</h4><br>
화면에 나타나는 먹이를 먹을 때마다 지렁이의 길이가 증가하며, 점수도 올라갑니다. 먹이를 많이 먹을수록 지렁이가 길어져 게임 난이도가 높아집니다. 얼마나 긴 지렁이를 만들 수 있을지 도전해 보세요!<br>

<h4>난이도</h4>
설정 버튼을 눌러 난이도를 선택할 수 있습니당
<h5>쉬움</h5>
기본 조작방법과 흐름을 이해하기 좋은 난이도입니다.
<h5>보통</h5>
기본 난이도로 일반적인 지렁이 게임을 플레이해보기 좋은 난이도입니다.
<h5>어려움</h5>
다른 난이도에 비해 장애물의 생성속도와 지렁이의 이동속도가 빨라지며 생존하기 어려운 난이도 입니다.
</div>