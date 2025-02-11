--INNER JOIN(내부조인)
SELECT * FROM INFO;
SELECT * FROM AUTH;

SELECT * FROM INFO INNER JOIN AUTH ON INFO.AUTH_ID = AUTH.AUTH_ID; --붙을 수 없는 데이터는 전부 누락

--컬럼 지정 AUTH_ID는 양쪽 테이블에 다 있기 때문에 출력할때 테이블명.컬럼명으로 지정해야한다.
SELECT ID, TITLE, CONTENT, AUTH.AUTH_ID, NAME, JOB
FROM INFO INNER JOIN AUTH ON INFO.AUTH_ID = AUTH.AUTH_ID;

--테이블 ALIAS
SELECT I.ID, I.AUTH_ID, A.NAME
FROM INFO I
INNER JOIN AUTH A
ON I.AUTH_ID = A.AUTH_ID;

--USING절 양쪽 테이블에 동일 키 이름으로 연결할 때 사용이 가능하다
SELECT *
FROM INFO I
INNER JOIN AUTH A
USING (AUTH_ID);

--LEFT OUTER JOIN 왼쪽 테이블이 기준이 되고 왼쪽 테이블은 다 나온다
SELECT *
FROM INFO I
LEFT OUTER JOIN AUTH A
ON I.AUTH_ID = A.AUTH_ID; -- 붙을 수 없는 데이터는 NULL처리되어 나온다

--RIGHT OUTER JOIN 오른쪽 테이블이 기준이되고, 오른족 테이블은 다 나온다
SELECT *
FROM INFO I
RIGHT OUTER JOIN AUTH A
ON I.AUTH_ID = A.AUTH_ID; -- 마찬가지로 붙을 수 없는 데이터는 NULL처리되어 나온다

--FULL OUTER JOIN 양쪽 테이블이 전부 누락 없이 다 나온다
SELECT *
FROM INFO I
FULL OUTER JOIN AUTH A
ON I.AUTH_ID = A.AUTH_ID;

--번외 CROSS조인 잘못된 조인의 형태 (오라클에서 "카디시안 프로덕트"라고 부른다)
SELECT *
FROM INFO I
CROSS JOIN AUTH A;

----------------------------------------------------------------------------------------------------------
SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;
SELECT * FROM LOCATIONS;

SELECT *
FROM EMPLOYEES E
INNER JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

--조인이 3개 이상도 가능하다
SELECT *
FROM EMPLOYEES E
INNER JOIN DEPARTMENTS D --처음 조인을 걸은 행의 갯수를 따라간다
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
LEFT JOIN LOCATIONS L
ON D.LOCATION_ID = L.LOCATION_ID;

------------------------------------------------------------------------------------------------------
--문제 1.
--EMPLOYEES 테이블과, DEPARTMENTS 테이블은 DEPARTMENT_ID로 연결되어 있습니다.
--EMPLOYEES, DEPARTMENTS 테이블을 엘리어스를 이용해서 
--각각 INNER , LEFT OUTER, RIGHT OUTER, FULL OUTER 조인 하세요. (달라지는 행의 개수 확인)
SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;

SELECT *
FROM EMPLOYEES E
INNER JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID; --이너 조인 행 106개

SELECT *
FROM EMPLOYEES E
LEFT OUTER JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID; --래프트 아우터 조인 행 107개

SELECT *
FROM EMPLOYEES E
RIGHT OUTER JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID; --라이트 아우터 조인 행 122개

SELECT *
FROM EMPLOYEES E
FULL JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID; --풀 아웃 조인 행 123개

--문제 2.
--EMPLOYEES, DEPARTMENTS 테이블을 INNER JOIN하세요
--조건)employee_id가 200인 사람의 이름, department_id를 출력하세요
--조건)이름 컬럼은 first_name과 last_name을 합쳐서 출력합니다
SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;

SELECT CONCAT(FIRST_NAME, LAST_NAME) AS 이름
      ,E.DEPARTMENT_ID
      ,EMPLOYEE_ID
FROM EMPLOYEES E
INNER JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE EMPLOYEE_ID = 200;

--문제 3.
--EMPLOYEES, JOBS테이블을 INNER JOIN하세요
--조건) 모든 사원의 이름과 직무아이디, 직무 타이틀을 출력하고, 이름 기준으로 오름차순 정렬
--HINT) 어떤 컬럼으로 서로 연결되 있는지 확인
SELECT * FROM EMPLOYEES;
SELECT * FROM JOBS;

SELECT CONCAT(FIRST_NAME, LAST_NAME) AS 이름
      ,E.JOB_ID AS 직무아이디
      ,J.JOB_TITLE AS 직무타이틀
FROM EMPLOYEES E
INNER JOIN JOBS J
ON E.JOB_ID = J.JOB_ID
ORDER BY 이름;

--문제 4.
--JOBS테이블과 JOB_HISTORY테이블을 LEFT_OUTER JOIN 하세요.
SELECT * FROM JOBS;
SELECT * FROM JOB_HISTORY;

SELECT *
FROM JOBS J
LEFT OUTER JOIN JOB_HISTORY JH
ON J.JOB_ID = JH.JOB_ID;


--문제 5.
--Steven King의 부서명을 출력하세요.
SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;

SELECT CONCAT(FIRST_NAME, LAST_NAME) AS 이름
      , DEPARTMENT_NAME AS 부서명
FROM EMPLOYEES E
LEFT OUTER JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE FIRST_NAME = 'Steven' AND LAST_NAME = 'King';

--문제 6.
--EMPLOYEES 테이블과 DEPARTMENTS 테이블을 Cartesian Product(Cross join)처리하세요
SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;

SELECT *
FROM EMPLOYEES E
CROSS JOIN DEPARTMENTS D;

--문제 7.
--EMPLOYEES 테이블과 DEPARTMENTS 테이블의 부서번호를 조인하고 SA_MAN 사원만의 사원번호, 이름, 
--급여, 부서명, 근무지를 출력하세요. (Alias를 사용)
SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;
SELECT * FROM LOCATIONS;

SELECT EMPLOYEE_ID AS 사원번호
      ,FIRST_NAME AS 이름
      ,SALARY AS 급여
      ,JOB_ID AS 직무
      ,D.DEPARTMENT_NAME AS 부서명
      ,L.STREET_ADDRESS AS 근무지
FROM EMPLOYEES E
LEFT OUTER JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
LEFT OUTER JOIN LOCATIONS L
ON D.LOCATION_ID = L.LOCATION_ID
WHERE JOB_ID = 'SA_MAN';
      
        
--문제 8.
--employees, jobs 테이블을 조인 지정하고 job_title이 'Stock Manager', 'Stock Clerk'인 직원 정보만 출력하세요.
SELECT * FROM EMPLOYEES;
SELECT * FROM JOBS;

SELECT *
FROM EMPLOYEES E
LEFT OUTER JOIN JOBS J
ON E.JOB_ID = J.JOB_ID
WHERE JOB_TITLE = 'Stock Manager' or JOB_TITLE = 'Stock Clerk';


--문제 9.
--departments 테이블에서 직원이 없는 부서를 찾아 출력하세요. LEFT OUTER JOIN 사용
SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;
SELECT * FROM REGIONS;

SELECT *
FROM DEPARTMENTS D
LEFT JOIN EMPLOYEES E
ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
WHERE EMPLOYEE_ID IS NULL;

--문제 10. 
--join을 이용해서 사원의 이름과 그 사원의 매니저 이름을 출력하세요
--힌트) EMPLOYEES 테이블과 EMPLOYEES 테이블을 조인하세요.
SELECT * FROM EMPLOYEES;

SELECT E1.FIRST_NAME AS 사원
      ,E2.FIRST_NAME AS 상급자
FROM EMPLOYEES E1
LEFT JOIN EMPLOYEES E2
ON E1.MANAGER_ID = E2.MANAGER_ID;

--문제 11. 
--EMPLOYEES 테이블에서 left join하여 관리자(매니저)와, 매니저의 이름, 매니저의 급여 까지 출력하세요
--조건) 매니저 아이디가 없는 사람은 배제하고 급여는 역순으로 출력하세요
SELECT * FROM EMPLOYEES;

SELECT E1.FIRST_NAME AS 사원
      ,E1.SALARY AS 사원급여
      ,E2.FIRST_NAME AS 매니저
      ,E2.SALARY AS 매니저급여
FROM EMPLOYEES E1
LEFT JOIN EMPLOYEES E2
ON E1.MANAGER_ID = E2.MANAGER_ID
WHERE E2.MANAGER_ID IS NOT NULL
ORDER BY E2.SALARY DESC;


--보너스 문제 12.
--윌리엄스미스(William smith)의 직급도(상급자)를 구하세요.
SELECT * FROM EMPLOYEES;

SELECT CONCAT(E1.FIRST_NAME, E1.LAST_NAME) AS 사원
      ,CONCAT(E2.FIRST_NAME, E2.LAST_NAME) AS 상급자
FROM EMPLOYEES E1
LEFT JOIN EMPLOYEES E2
ON E1.MANAGER_ID = E2.MANAGER_ID
WHERE E1.EMPLOYEE_ID = 171;


