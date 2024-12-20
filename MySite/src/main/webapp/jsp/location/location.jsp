<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Kakao 지도 - 한국폴리텍대학 성남캠퍼스</title>
<style>
    body {
        margin: 0;
        padding: 0;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        background-color: #e9f7ef; /* 연한 초록색 배경 */
        font-family: Arial, sans-serif;
    }

    #map {
        width: 90%; /* 화면의 90% 너비 */
        height: 80%; /* 화면의 80% 높이 */
        max-width: 1200px; /* 최대 너비 */
        max-height: 800px; /* 최대 높이 */
        border: 4px solid #4caf50; /* 초록색 테두리 */
        box-shadow: 0 8px 16px rgba(76, 175, 80, 0.4); /* 초록색 그림자 효과 */
        border-radius: 16px; /* 둥근 테두리 */
    }

    h1 {
        position: absolute;
        top: 20px;
        font-size: 24px;
        color: #4caf50;
        text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.2);
    }

    #homeButton {
        position: absolute;
        top: 20px;
        right: 20px;
        background-color: #4caf50;
        color: white;
        border: none;
        padding: 10px 20px;
        font-size: 16px;
        cursor: pointer;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        text-decoration: none;
    }

    #homeButton:hover {
        background-color: #45a049;
    }
</style>
</head>
<body>
    <h1>위치 - 한국폴리텍대학 성남캠퍼스</h1>
    <a id="homeButton" href="/MySite/index.do">홈으로 돌아가기</a>
    <div id="map"></div>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=10f4cba239788544f1e88a91e6c4a4db"></script>
    <script>
        var container = document.getElementById('map'); // 지도를 표시할 div
        var options = {
            center: new kakao.maps.LatLng(37.457, 127.149), // 성남캠퍼스 중심 좌표
            level: 4, // 지도 레벨 (확대 정도)
            draggable: true, // 지도 드래그 활성화
            scrollwheel: true // 스크롤 휠 활성화
        };

        // 지도 생성
        var map = new kakao.maps.Map(container, options);

        // 마커가 표시될 위치
        var markerPosition = new kakao.maps.LatLng(37.457, 127.149); // 마커 좌표

        // 마커 생성
        var marker = new kakao.maps.Marker({
            position: markerPosition
        });

        // 지도에 마커 표시
        marker.setMap(map);
    </script>
</body>
</html>