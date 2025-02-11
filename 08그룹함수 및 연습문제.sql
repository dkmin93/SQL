--그룹함수 - 행에 대한 기초 통계값
--SUM, AVG, MAX, MIN, COUNT 전부 NULL이 아닌 데이터에 대해서 통계를 구한다.
SELECT SUM(SALARY), AVG(SALARY), MAX(SALARY), MIN(SALARY), COUNT(SALARY) FROM EMPLOYEES;

--MIN, MAX 날짜, 문자열에도 적용이 된다.
SELECT MIN(HIRE_DATE), MAX(HIRE_DATE), MIN(FIRST_NAME), MAX(FIRST_NAME) FROM EMPLOYEES;

--COUNT 함수는 2가지 사용방법이 있다
SELECT COUNT(COMMISSION_PCT) FROM EMPLOYEES; --35, NULL이 아닌 데이터에 대해서 집계
SELECT COUNT(*) FROM EMPLOYEES; -- 107, 전체행수(NULL 포함)

--주의할점 : 그룹함수는 일반 컬럼과 동시에 사용이 불가능하다
SELECT FIRST_NAME, AVG(SALARY) FROM EMPLOYEES; -- 출력 불가능

--그룹함수 뒤에 over()를 붙이면 전체행이 출력이 되고, 그룹함수 사용이 가능하다
SELECT FIRST_NAME, AVG(SALARY) OVER(), COUNT(*) OVER() FROM EMPLOYEES;

-------------------------------------------------------------------------------------------------------------
--GROUP BY 절 컬럼기준으로 그룹을 묶어준다
SELECT DEPARTMENT_ID FROM EMPLOYEES GROUP BY DEPARTMENT_ID;

--그룹함수를 함께 사용할 수 있다
SELECT DEPARTMENT_ID, SUM(SALARY), AVG(SALARY), MIN(SALARY), MAX(SALARY), COUNT(*)
FROM EMPLOYEES GROUP BY DEPARTMENT_ID;
--주의할점 GROUP BY절에 지정되지 않은 컬럼은 SELECT절에 사용할 수 없다.
SELECT DEPARTMENT_ID,
       FIRST_NAME --불가능
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID;

--2개 이상의 그룹화
SELECT DEPARTMENT_ID, JOB_ID, AVG(SALARY)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID, JOB_ID
ORDER BY DEPARTMENT_ID;
--
SELECT DEPARTMENT_ID, JOB_ID, COUNT(*), COUNT(*) OVER() AS 전체행수
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID, JOB_ID
ORDER BY DEPARTMENT_ID;

-- WHERE절에 그룹의 조건을 넣는 것이 아니다.
SELECT DEPARTMENT_ID, SUM(SALARY)
FROM EMPLOYEES
WHERE SUM(SALARY) >= 50000 -- GROUP BY 조건을 쓰는 곳은 HAVING이라고 있다.
GROUP BY DEPARTMENT_ID;

------------------------------------------------------------------------------
--HAVING : 그룹 BY의 조건
--WHERE - 일반행 조건
SELECT DEPARTMENT_ID, AVG(SALARY), COUNT(*)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) >= 5000  AND COUNT(*) >= 1;

--각 부서별 샐러ㅣ맨들의 급여 평균
SELECT JOB_ID, AVG(SALARY)
FROM EMPLOYEES
WHERE JOB_ID LIKE 'SA%'
GROUP BY JOB_ID
HAVING AVG(SALARY) >= 10000
ORDER BY AVG(SALARY) DESC;

----------------------------------------------------------------------------------------------------
--시험 대비
--ROLLUP 보통 GROUP BY와 함께 사용되고 상위 그룹의 소계를 구한다.
SELECT DEPARTMENT_ID, AVG(SALARY)
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID);

--
SELECT DEPARTMENT_ID, JOB_ID, AVG(SALARY)
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID)
ORDER BY DEPARTMENT_ID, JOB_ID;

--CUBE - 롤업에 의해서 구해진 값 + 서브그룹의 통계가 추가된다
SELECT DEPARTMENT_ID, JOB_ID, AVG(SALARY)
FROM EMPLOYEES
GROUP BY CUBE(DEPARTMENT_ID, JOB_ID)
ORDER BY DEPARTMENT_ID, JOB_ID;

--GROUPING() 그룹절로 만들어진 경우에는 0을 반환, 롤업OR큐브로 만들어진 행인 경우네는 1을 반환
SELECT DECODE ( GROUPING(DEPARTMENT_ID), 1, '총계', DEPARTMENT_ID ) AS DEPARTMENT_ID,
       DECODE ( GROUPING(JOB_ID), 1, '소계', JOB_ID) AS JOB_ID,
    AVG(SALARY),
    GROUPING(DEPARTMENT_ID),
    GROUPING(JOB_ID)
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID)
ORDER BY DEPARTMENT_ID;

----------------------------------------------------------------------------------------------------------
--문제 1.
--사원 테이블에서 JOB_ID별 사원 수, 월급의 평균, JOB_ID별 가장빠른 입사일을 구하세요. 월급의 평균 순으로 내림차순 정렬하세요.
SELECT JOB_ID, COUNT(*) AS 사원수, AVG(SALARY) AS 급여평균, MIN(HIRE_DATE) AS 가장빠른입사일
FROM EMPLOYEES
GROUP BY JOB_ID
ORDER BY 급여평균 DESC;

--문제 2.
--사원 테이블에서 입사 년도 별 사원 수를 구하세요.
SELECT SUBSTR(HIRE_DATE, 1, 2) AS 입사년도, COUNT(*) AS 사원수
FROM EMPLOYEES
GROUP BY SUBSTR(HIRE_DATE, 1, 2);

--문제 3.
--급여가 1000 이상인 사원들의 부서별 평균 급여를 출력하세요. 단 부서 평균 급여가 2000이상인 부서만 출력
SELECT DEPARTMENT_ID,
       AVG(SALARY) AS 평균급여 
FROM EMPLOYEES 
WHERE SALARY >= 1000 
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) >= 2000;

--문제 3.
--부서아이디가 NULL이 아니고, 입사일은 05년도 인 사람들의 부서 급여평균과, 급여합계를 평균기준 내림차순 조회하세요.
----조건은 급여평균이 10000이상인 데이터만.
SELECT DEPARTMENT_ID,
       AVG(SALARY) AS 급여평균, 
       SUM(SALARY) AS 급여합계
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL AND SUBSTR(HIRE_DATE, 1, 2)='05'
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) >= 10000
ORDER BY 급여합계;

--문제 4.
--사원 테이블에서 commission_pct(커미션) 컬럼이 null이 아닌 사람들의
--department_id(부서별) salary(월급)의 평균, 합계, count를 구합니다.
--조건 1) 월급의 평균은 커미션을 적용시킨 월급입니다.
--조건 2) 평균은 소수 2째 자리에서 절삭 하세요.
SELECT DEPARTMENT_ID,
       TRUNC(AVG(SALARY + SALARY * COMMISSION_PCT), 2) AS 평균,
       SUM(SALARY) AS 합,
       COUNT(*)
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NOT NULL
GROUP BY DEPARTMENT_ID
HAVING DEPARTMENT_ID IS NOT NULL;

--문제 5.
--부서아이디가 NULL이 아니고, 입사일은 05년도 인 사람들의 부서 급여평균과, 급여합계를 평균기준 내림차순합니다
--조건) 평균이 10000이상인 데이터만
SELECT DEPARTMENT_ID, AVG(SALARY), SUM(SALARY)
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL AND SUBSTR(HIRE_DATE, 1, 2)='05'  
GROUP BY DEPARTMENT_ID
ORDER BY AVG(SALARY) DESC;

--문제 6.
--직업별 월급합, 총합계를 출력하세요
SELECT DECODE(GROUPING(JOB_ID), 1, '총계', JOB_ID) AS JOB_ID,
       SUM(SALARY) 
FROM EMPLOYEES
GROUP BY ROLLUP(JOB_ID);

--문제 7.
--부서별, JOB_ID를 그룹핑 하여 토탈, 합계를 출력하세요.
--GROUPING() 을 이용하여 소계 합계를 표현하세요
SELECT DECODE (GROUPING(DEPARTMENT_ID), 1, '합계', DEPARTMENT_ID ) AS DEPARTMENT_ID
       ,DECODE (GROUPING(JOB_ID), 1, '소계', JOB_ID) AS JOB_ID
       ,COUNT(*) AS TOTAL
       ,SUM(SALARY) AS SUM
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID)
ORDER BY SUM;
