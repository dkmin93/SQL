--형변환 함수
--자동 형변환을 제공합니다. NUMBER <-> 문자, DATE <-> 문자
SELECT * FROM EMPLOYEES WHERE SALARY >= '10000'; --자동으로 형변환을 해줬기 때문
SELECT HIRE_DATE FROM EMPLOYEES WHERE HIRE_DATE = '05/09/30';

--강제 형변환
--TO_CHAR = 날짜 -> 문자로 강제 형변환 (날짜 포멧형식으로 쓰인다)
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS') FROM DUAL; --SYSDATE는 일까지 출력되지만 사실상 현재 시간 분 초의 값도 가지고 있기 때문에 형변환을 통해 출력이 가능하다
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일"') FROM DUAL; --데이터 포맷형식이 아닌 값은 ""로 묶어주면 같이 출력할 수 있다.
SELECT FIRST_NAME, TO_CHAR(HIRE_DATE, 'YY--MM-DD AM') FROM EMPLOYEES;

--TO_CHAR = 숫자 -> 문자로 강제 형변환 (숫자 포멧형식 쓰인다)
SELECT TO_CHAR(20000, '99999999999999999') FROM DUAL; -- 9는 자릿수
SELECT TO_CHAR(20000, '099999999999999999')  FROM DUAL; --남는 자리는 0으로 채운다
SELECT TO_CHAR(20000, '9999') FROM DUAL; --자릿수를 초과해버리면 #으로 처리된다
SELECT TO_CHAR(20000.123, '99999.999') AS "2000" FROM DUAL; --소숫점 자리수 맞추기
SELECT TO_CHAR(20000, 'L999,999,999.99') FROM DUAL; -- L을 붙이면 지역 화폐기호가 나온다.

-- TO_NUMBER = 문자 -> 숫자로 강제 형변환
SELECT '2000' + 2000 FROM DUAL; --자동형변환 문자를 자동으로 숫자형으로 바꿔줘서 가능
SELECT TO_NUMBER('$2,000', '$9,999') + 2000 FROM DUAL; -- 숫자로 형변환

-- TO_DATE 문자 -> 날짜로 강제 형변환
SELECT TO_DATE('2023-02-07', 'YYYY-MM-DD') FROM DUAL;
SELECT TO_DATE('2024-02-07', 'YYYY-MM-DD') - HIRE_DATE FROM EMPLOYEES;
SELECT TO_DATE('2024년 02월 07일', 'YYYY"년" MM"월" DD"일"') FROM DUAL;

-------------------------------------------------------------------------------------------

--NULL 처리 함수
--NVL(타겟, NULL일 경우 대체할 값)
SELECT NVL(3000, 0), NVL(NULL, 0) FROM DUAL; -- NULL이 연산에 들어가면 NULL이 나온다.
SELECT FIRST_NAME, SALARY, COMMISSION_PCT, SALARY + SALARY * NVL(COMMISSION_PCT, 0) AS 실제급여 FROM EMPLOYEES;

--NVL2(타겟, NULL이 아닐 때, NULL일 때)
SELECT NVL2(NULL, 'NOT NULL', 'NULL') FROM DUAL;
SELECT FIRST_NAME, COMMISSION_PCT, NVL2(COMMISSION_PCT, SALARY + SALARY * COMMISSION_PCT, SALARY) FROM EMPLOYEES;

--DECODE(값, 비교값, 결과값, ................, ELSE문)
SELECT DECODE('D', 'A', 'A입니다', 'B', 'B입니다', 'C', 'C입니다', '나머지입니다') FROM DUAL;
SELECT DECODE(JOB_ID, 'IT_PROG', SALARY * 1.1, 'FI_MGR', SALARY * 1.2, 'AD_VP', SALARY * 1.3, SALARY), JOB_ID FROM EMPLOYEES;

--CASE ~ WHEN ~ THEN ~ ELSE ~ END
SELECT FIRST_NAME, JOB_ID, SALARY, CASE JOB_ID WHEN 'IT_PROG' THEN SALARY * 1.1 WHEN 'FI_MGR' THEN SALARY * 1.3 WHEN 'AD_VP' THEN SALARY * 1.3 ELSE SALARY END FROM EMPLOYEES;

--2번째 방법 WHEN 조건식을 넣을 수도 있다
SELECT FIRST_NAME, JOB_ID, SALARY, CASE WHEN JOB_ID = 'IT_PROG' THEN SALARY * 1.1 WHEN JOB_ID = 'FI_MGR' THEN SALARY * 1.2 WHEN JOB_ID = 'AD_VP' THEN SALARY * 1.3 ELSE SALARY END FROM EMPLOYEES;

--COALESCE(값, 값, ...) NULL이 아닌 첫번째 인자값을 반환하는 함수
SELECT COALESCE( 'A', 'B', 'C') FROM DUAL;
SELECT COALESCE( NULL, 'B', 'C') FROM DUAL;
SELECT COALESCE( NULL , NULL, 'C') FROM DUAL;
SELECT COALESCE( NULL , NULL, NULL) FROM DUAL;
SELECT COALESCE(COMMISSION_PCT,0), NVL(COMMISSION_PCT, 0) FROM EMPLOYEES;

-----------------------------------------------------------------------------------------------------------
--문제 1.
--1) 오늘의 환율이 1302.69원 입니다 SALARY컬럼을 한국돈으로 변경해서 소수점 2자리수까지 출력 하세요.
SELECT TO_CHAR(SALARY * 1302.69 , 'L999,999,999.99') FROM EMPLOYEES;
--2) '20250207' 문자를 '2025년 02월 07일' 로 변환해서 출력하세요.
SELECT TO_CHAR(TO_DATE('20250207', 'YYYYMMDD'), 'YYYY"년"MM"월"DD"일"') AS "DATE" FROM DUAL;

--문제 2.
--현재일자를 기준으로 EMPLOYEE테이블의 입사일자(hire_date)를 참조해서 근속년수가 10년 이상인
--사원을 다음과 같은 형태의 결과를 출력하도록 쿼리를 작성해 보세요. 
--조건 1) 근속년수가 높은 사원 순서대로 결과가 나오도록 합니다.
SELECT EMPLOYEE_ID AS 사원번호, CONCAT(FIRST_NAME, LAST_NAME) AS 사원명, HIRE_DATE AS 입사일자, TRUNC((SYSDATE - HIRE_DATE)/365) AS 근속년수 FROM EMPLOYEES ORDER BY 근속년수 DESC;

--문제 3.
--EMPLOYEE 테이블의 manager_id컬럼을 확인하여 first_name, manager_id, 직급을 출력합니다.
--100이라면 ‘부장’ 
--120이라면 ‘과장’
--121이라면 ‘대리’
--122라면 ‘주임’
--나머지는 ‘사원’ 으로 출력합니다.
--조건 1) 부서가 50인 사람들을 대상으로만 조회합니다
--조건 2) DECODE구문으로 표현해보세요.
--조건 3) CASE구문으로 표현해보세요.

--DECODE구문
SELECT FIRST_NAME, MANAGER_ID, DECODE(MANAGER_ID, 100, '부장', 120, '과장', 121, '대리', 122, '주임', '사원')AS 직급 FROM EMPLOYEES WHERE department_id = 50;

--CASE구문
SELECT FIRST_NAME, MANAGER_ID, CASE MANAGER_ID WHEN 100 THEN '부장' WHEN 120 THEN '과장' WHEN 121 THEN '대리' WHEN 122 THEN '주임' ELSE '사원' END AS 직급 FROM EMPLOYEES WHERE department_id = 50;

--문제 4. 
--EMPLOYEES 테이블의 이름, 입사일, 급여, 진급대상, 급여상태 를 출력합니다.
--조건1) HIRE_DATE를 XXXX년XX월XX일 형식으로 출력하세요. 
--조건2) 급여는 커미션값이 퍼센트로 더해진 값을 출력하고, 1300을 곱한 원화로 바꿔서 출력하세요.
--조건3) 진급대상은 5년 마다 이루어 집니다. 근속년수가 5의 배수라면 진급대상으로 출력합니다.
--조건4) 부서가 NULL이 아닌 데이터를 대상으로 출력합니다.
--조건5) 급여상태는 10000이상이면 '상' 10000~5000이라면 '중', 5000이하라면 '하' 로 출력해주세요.
SELECT CONCAT(FIRST_NAME, LAST_NAME) AS 이름, TO_CHAR(HIRE_DATE, 'YYYY"년" MM"월" DD"일"') AS 입사일, TO_CHAR((SALARY + SALARY * NVL2(COMMISSION_PCT,COMMISSION_PCT,0)) * 1300, 'L999,999,999') AS 급여, CASE WHEN MOD(TRUNC((SYSDATE - HIRE_DATE)/365), 5) = 0 THEN '진급대상' ELSE '대상아님' END AS 진급대상, CASE WHEN SALARY >= 10000 THEN '상' WHEN SALARY <= 5000 THEN '하' ELSE '중' END AS 급여상태 FROM EMPLOYEES WHERE DEPARTMENT_ID IS NOT NULL;


