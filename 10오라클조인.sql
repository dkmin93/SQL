--오라클에서만 사용하는 조인 문법도 있다

--조인을 할 때 조인의 테이블 FROM에 ,로 나열
--WHERE절에서 조인의 조건을 기술한다

SELECT * FROM AUTH;
SELECT * FROM INFO;

--이너조인(내부조인)
SELECT *
FROM INFO I, AUTH A
WHERE I.AUTH_ID = A.AUTH_ID;

--아우터조인(외부조인) 붙일 쪽에다가 (+)를 붙인다
SELECT *
FROM INFO I, AUTH A
WHERE I.AUTH_ID = A.AUTH_ID(+); --LEFT JOIN

SELECT *
FROM INFO I, AUTH A
WHERE I.AUTH_ID(+) = A.AUTH_ID; --RIGHT JOIN
--오라클에서 FULL OUTER 조인은 없다

-- CROSS JOIN은 조인 조건을 적지 않으면 된다.
SELECT *
FROM INFO I, AUTH A; --CROSS JOIN