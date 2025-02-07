--문자열 함수
SELECT 'abcDEF', LOWER('abcDEF'), UPPER('abcDEF'), INITCAP('ABCedf') FROM DUAL;
SELECT LOWER(FIRST_NAME), UPPER(FIRST_NAME), INITCAP(FIRST_NAME) FROM EMPLOYEES;

--LENGTH 길이 INSTR 문자열 찾기
SELECT FIRST_NAME, LENGTH(FIRST_NAME), INSTR(FIRST_NAME, 'a') FROM EMPLOYEES;

--SUBSTR(타겟, 시작위치, 자를 문자 갯수) 문자열 자르기 CONCAT 문자열 붙이기
SELECT FIRST_NAME, SUBSTR(FIRST_NAME, 1, 3) FROM EMPLOYEES;
SELECT CONCAT(FIRST_NAME, LAST_NAME), FIRST_NAME || LAST_NAME FROM EMPLOYEES;

--LPAD 왼쪽 공백을 특정 값으로 채운다
--RPAD 오른쪽 공백을 특정 값으로 채운다.
SELECT LPAD(FIRST_NAME, 10, '*')FROM EMPLOYEES;
SELECT RPAD(FIRST_NAME, 10, '-')FROM EMPLOYEES;

--TRIM 양쪽 공백 제거, LTRIM 왼쪽부터공백제거, RTRIM 오른쪽부터 공백제거
SELECT TRIM(' HELLO WORLD '), LTRIM(' HELLO WORLD '), RTRIM(' HELLO WORLD ') FROM DUAL;

SELECT LTRIM('HELLO WORLD', 'HELLO') FROM DUAL;

--REPLACE(타겟, 찾을문자, 변경문자)
SELECT REPLACE('피카츄 라이츄 파이리 꼬북이 버터플', '꼬북이', '어니부기') FROM DUAL;

--함수는 NESTED(중첩)이 가능하다
SELECT REPLACE(REPLACE('피카츄 라이츄 파이리 꼬북이 버터플', '꼬북이', '어니부기'), ' ', ' > ') FROM DUAL;

-----------------------------------------------------------------------------------------------------

--문제 1.
--EMPLOYEES 테이블 에서 이름, 입사일자 컬럼으로 변경해서 이름순으로 오름차순 출력 합니다.
SELECT CONCAT(CONCAT(FIRST_NAME, ' '), LAST_NAME ) AS 이름, REPLACE(HIRE_DATE, '/', '') AS 입사일자 FROM EMPLOYEES ORDER BY 이름;
--조건 1) 이름 컬럼은 first_name, last_name을 붙여서 출력합니다.
--조건 2) 입사일자 컬럼은 xx/xx/xx로 저장되어 있습니다. xxxxxx형태로 변경해서 출력합니다.
--
--
--문제 2.
--EMPLOYEES 테이블 에서 phone_numbe컬럼은 ###.###.####형태로 저장되어 있다
--여기서 처음 세 자리 숫자 대신 서울 지역변호 (02)를 붙여 전화 번호를 출력하도록 쿼리를 작성하세요
SELECT * FROM EMPLOYEES;
SELECT REPLACE(CONCAT('(02)', SUBSTR(PHONE_NUMBER, 5, 12)), '.', '-') FROM EMPLOYEES;
-- 끝값을 입력하지 않으면 지정된 시작위치부터 문자열의 끝까지 전부 잘라준다.
--
--문제 3. EMPLOYEES 테이블에서 JOB_ID가 it_prog인 사원의 이름(first_name)과 급여(salary)를 출력하세요.
--조건 1) 비교하기 위한 값은 소문자로 입력해야 합니다.(힌트 : lower 이용)
--조건 2) 이름은 앞 3문자까지 출력하고 나머지는 *로 출력합니다. 
--이 열의 열 별칭은 name입니다.(힌트 : rpad와 substr 또는 substr 그리고 length 이용)
--조건 3) 급여는 전체 10자리로 출력하되 나머지 자리는 *로 출력합니다. 
--이 열의 열 별칭은 salary입니다.(힌트 : lpad 이용)
SELECT RPAD(SUBSTR(FIRST_NAME, 1, 3),LENGTH(FIRST_NAME),'*') AS name , LPAD(SALARY, 10, '*') AS salary FROM EMPLOYEES WHERE LOWER(JOB_ID) = 'it_prog';