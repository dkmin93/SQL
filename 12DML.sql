--DML문
--INSERT
DESC DEPARTMENTS;
-- 테이블의 구조를 빠르게 확인할 수 있다. NOT NULL은 데이터가 반드시 들어가야한다는 뜻이다. VARCHAR2은 문자타입

--1ST 컬럼을 정확히 일치시키는 경우
INSERT INTO DEPARTMENTS VALUES(280, 'DEVELOPER', NULL, 1700);
SELECT * FROM DEPARTMENTS;
--DML문은 트랜잭션이 항상 적용이 된다. 일시적으로 적용 된 것이다.
ROLLBACK; --아직 커밋되지 않았다면 롤백 기능으로 되돌릴 수 있다.

--2ND 컬럼을 지정해서 넣는 경우
INSERT INTO DEPARTMENTS(DEPARTMENT_ID, DEPARTMENT_NAME, LOCATION_ID) VALUES(280, 'DEVELOPER', 1700);
INSERT INTO DEPARTMENTS(DEPARTMENT_ID, DEPARTMENT_NAME, LOCATION_ID, MANAGER_ID) VALUES(290, 'DBA', 1700, 100);

--INSERT 구문도 서브쿼리가 들어갈 수 있다.
--실습을 위한 사본테이블 생성
CREATE TABLE EMPS AS (SELECT * FROM EMPLOYEES WHERE 1 = 2); --EMPS 테이블을 만드는데 데이터는 복제안한다. 는 의미
DESC EMPS;
SELECT * FROM EMPS;

--1ST
INSERT INTO EMPS (EMPLOYEE_ID, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID)
(SELECT EMPLOYEE_ID, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID FROM EMPLOYEES WHERE JOB_ID LIKE '%MAN');

--2ND
INSERT INTO EMPS (EMPLOYEE_ID, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID)
VALUES((SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE FIRST_NAME = 'Lex'), 'EXAMPLE', 'EXAMPLE', SYSDATE, 'EXAMPLE');

------------------------------------------------------------------------------------------------------------------

--UPDATE 구문
SELECT * FROM EMPS WHERE EMPLOYEE_ID = 120; --업데이트 하기전에 먼저 찍어 보기. 조건절을 빼먹으면 대형사고가 날 수 있다.
UPDATE EMPS SET FIRST_NAME = 'HONG', SALARY = 3000, COMMISSION_PCT = 0.1 WHERE EMPLOYEE_ID = 120;
UPDATE EMPS SET FIRST_NAME = 'HONG';
ROLLBACK;

--UPDATE문 서브쿼리
UPDATE EMPS
SET (MANAGER_ID, JOB_ID, SALARY) = 
    (SELECT MANAGER_ID, JOB_ID, SALARY FROM EMPLOYEES WHERE EMPLOYEE_ID = 201)
WHERE EMPLOYEE_ID = 120;

------------------------------------------------------------------------------------------------------------------

--DELETE 구문
SELECT * FROM EMPS WHERE EMPLOYEE_ID =120; --마찬가지로 딜리트 하기 전에 먼저 찍어 보기. 조건절 빼먹으면 대형사고
DELETE FROM EMPS WHERE EMPLOYEE_ID = 120;

--DELETE 서브쿼리
DELETE FROM EMPS WHERE JOB_ID = (SELECT JOB_ID FROM EMPS WHERE EMPLOYEE_ID = 121);

--모든 데이터가 전부 지워질 수 있는 것은 아니다
SELECT * FROM DEPARTMENTS;
SELECT * FROM EMPLOYEES;
-- 50번 부서는 EMPLOYEES 테이블에서 참조되고 있기 때문에 삭제가 일어나면 참조 무결성 제약을 위배되기 때문에 삭제가 불가능하다
DELETE FROM DEPARTMENTS WHERE DEPARTMENT_ID = 50;

----------------------------------------------------------------------------------------------------------------

--MERGE 구문 데이터가 있으면 UPDATE 없으면 INSERT를 수행하는 병합구문
SELECT * FROM EMPS;

MERGE INTO EMPS E1 --MERGE를 시킬 타겟 타이블
USING (SELECT * FROM EMPLOYEES WHERE JOB_ID LIKE '%MAN') E2 --병합할 테이블을 서브쿼리로 넣어준다
ON (E1.EMPLOYEE_ID = E2.EMPLOYEE_ID) -- E1과 E2 데이터가 연결되는 조건 
WHEN MATCHED THEN -- 일치하지 않을 때 UPDATE를 수행할 작업
    UPDATE SET E1.SALARY = E2.SALARY,
                E1.COMMISSION_PCT = E2.COMMISSION_PCT
WHEN NOT MATCHED THEN --일치하지 않을 때 INSERT를 수행할 작업
    INSERT(EMPLOYEE_ID, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID)
    VALUES(E2.EMPLOYEE_ID, E2.LAST_NAME, E2.EMAIL, E2.HIRE_DATE, E2.JOB_ID);

--2ND  MERGE문으로 직접 특정 데이터에 값을 넣고자 할 때 사용할 수 있다
MERGE INTO EMPS E1
USING DUAL
ON (E1.EMPLOYEE_ID = 200) --EMPS 테이블의 사원번호가 120인 데이터에만 대해서 수정을 하겠다
WHEN MATCHED THEN
    UPDATE SET E1.SALARY = 10000,
               E1.HIRE_DATE = SYSDATE
WHEN NOT MATCHED THEN
    INSERT(LAST_NAME, EMAIL, HIRE_DATE, JOB_ID)
    VALUES('EXAMPLE', 'EXAMPLE', SYSDATE, 'EXAMPLE');
    
SELECT * FROM EMPS;

----------------------------------------------------------------------------------------------------------

--사본테이블 만들기 (연습용으로 사용)
CREATE TABLE EMP1 AS (SELECT * FROM EMPLOYEES); --테이블 구조 + 데이터 까지 복사
SELECT * FROM EMP1;

--마지막에 WHERE을 두고 임의의 FALSE값을 넣을 경우 데이터는 제외하고 테이블 구조만 복사한다.
CREATE TABLE EMP2 AS (SELECT * FROM EMPLOYEES WHERE 1 = 2); 
SELECT * FROM EMP2;

--테이블 삭제 
DROP TABLE EMP1;
DROP TABLE EMP2;

------------------------------------------------------------------------------------------------

--문제 1.
--DEPTS테이블을 데이터를 포함해서 생성하세요.
--DEPTS테이블의 다음을 INSERT 하세요.
SELECT * FROM DEPARTMENTS;

CREATE TABLE DEPTS AS(SELECT * FROM DEPARTMENTS);
SELECT * FROM DEPTS;
INSERT INTO DEPTS VALUES(280, '개발', NULL, 1800);
INSERT INTO DEPTS VALUES(290, '회계부', NULL, 1800);
INSERT INTO DEPTS VALUES(300, '재정', 301, 1800);
INSERT INTO DEPTS VALUES(310, '인사', 302, 1800);
INSERT INTO DEPTS VALUES(320, '영업', 303, 1700);

ROLLBACK;

--문제 2.
--DEPTS테이블의 데이터를 수정합니다
--1. department_name 이 IT Support 인 데이터의 department_name을 IT bank로 변경
--2. department_id가 290인 데이터의 manager_id를 301로 변경
--3. department_name이 IT Helpdesk인 데이터의 부서명을 IT Help로 , 매니저아이디를 303으로, 지역아이디를 1800으로 변경하세요
--4. 부서번호 (290, 300, 310, 320) 의 매니저아이디를 301로 한번에 변경하세요.
SELECT * FROM DEPTS;
UPDATE DEPTS SET DEPARTMENT_NAME = 'IT bank' WHERE DEPARTMENT_NAME = 'IT Support';
UPDATE DEPTS SET MANAGER_ID = 301 WHERE DEPARTMENT_ID = 290;
UPDATE DEPTS SET DEPARTMENT_NAME = 'IT Help', manager_id = 303, LOCATION_ID = 1800 WHERE DEPARTMENT_NAME = 'IT Helpdesk';
UPDATE DEPTS SET manager_id = 301 WHERE DEPARTMENT_ID IN (290, 300, 310, 320);

--문제 3.
--삭제의 조건은 항상 primary key로 합니다, 여기서 primary key는 department_id라고 가정합니다.
--1. 부서명 영업부를 삭제 하세요
--2. 부서명 NOC를 삭제하세요
SELECT * FROM DEPTS;
SELECT * FROM DEPTS WHERE DEPARTMENT_NAME = '영업';
DELETE FROM DEPTS WHERE DEPARTMENT_NAME = '영업';
DELETE FROM DEPTS WHERE DEPARTMENT_NAME = 'NOC';

--문제4
--1. Depts 사본테이블에서 department_id 가 200보다 큰 데이터를 삭제해 보세요.
--2. Depts 사본테이블의 manager_id가 null이 아닌 데이터의 manager_id를 전부 100으로 변경하세요.
--3. Depts 테이블은 타겟 테이블 입니다.
--4. Departments테이블은 매번 수정이 일어나는 테이블이라고 가정하고 Depts와 비교하여
--일치하는 경우 Depts의 부서명, 매니저ID, 지역ID를 업데이트 하고, 새로유입된 데이터는 그대로 추가해주는 merge문을 작성하세요.
SELECT * FROM DEPTS;
DELETE FROM DEPTS WHERE DEPARTMENT_ID > 200;
UPDATE DEPTS SET manager_id = 100 WHERE manager_id IS NOT NULL;

MERGE INTO DEPTS D1
USING (SELECT * FROM DEPARTMENTS) D2
ON (D1.DEPARTMENT_ID = D2.DEPARTMENT_ID)
WHEN MATCHED THEN
    UPDATE SET D1.DEPARTMENT_NAME = D2.DEPARTMENT_NAME,
                D1.manager_id = D2.manager_id,
                D1.LOCATION_ID = D2.LOCATION_ID
WHEN NOT MATCHED THEN
--    INSERT(DEPARTMENT_ID, DEPARTMENT_NAME, manager_id, LOCATION_ID)   컬럼이 일치하는 경우엔 생략해도 된다. 다를 경우에만 인설트에서 지정
    VALUES(D2.DEPARTMENT_ID, D2.DEPARTMENT_NAME, D2.manager_id, D2.LOCATION_ID);


--문제 5
--1. jobs_it 사본 테이블을 생성하세요 (조건은 min_salary가 6000보다 큰 데이터만 복사합니다)
--2. jobs_it 테이블에 아래 데이터를 추가하세요
--3. Jobs_it은 타겟 테이블 입니다
--jobs테이블은 매번 수정이 일어나는 테이블이라고 가정하고 jobs_it과 비교하여
--min_salary컬럼이 0보다 큰 경우 기존의 데이터는 min_salary, max_salary를 업데이트 하고 새로 유입된
--데이터는 그대로 추가해주는 merge문을 작성하세요.
SELECT * FROM JOBS;
CREATE TABLE JOBS_IT AS(SELECT * FROM JOBS WHERE MIN_SALARY > 6000);
SELECT * FROM JOBS_IT;
INSERT INTO JOBS_IT VALUES('IT_DEV', '아이티개발팀', 6000, 20000);
INSERT INTO JOBS_IT VALUES('NET_DEV', '네트워크개발팀', 5000, 20000);
INSERT INTO JOBS_IT VALUES('SEC_DEV', '보안개발팀', 6000, 19000);



MERGE INTO JOBS_IT J1
USING (SELECT * FROM JOBS WHERE min_salary > 0) J2
ON (J1.JOB_ID = J2.JOB_ID)
WHEN MATCHED THEN
    UPDATE SET J1.min_salary = J2.min_salary,
                J1.max_salary = J2.max_salary
WHEN NOT MATCHED THEN
    INSERT(JOB_ID, JOB_TITLE, min_salary, max_salary)
    VALUES(J2.JOB_ID, J2.JOB_TITLE, J2.min_salary, J2.max_salary);

SELECT * FROM JOBS_IT;





