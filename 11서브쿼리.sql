--단일행 서브쿼리 SELECT한 결과가 1행인 서브쿼리
--서브쿼리는 ()로 묶는다. 연산자보다는 오른쪽에 나온다.

SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'Nancy';

SELECT *
FROM EMPLOYEES WHERE SALARY >= (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'Nancy');

--직원번호가 103번인 사람과 동일한 직무를 가진 사람
SELECT JOB_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = 103;
SELECT * FROM EMPLOYEES WHERE JOB_ID = (SELECT JOB_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = 103);

--주의할점 단일행 서브쿼리는 반드시 하나의 행을 리턴을 해야 한다
--서브 쿼리가 반환하는 행이 여러행이라면 다중행 연사자를 쓰면 된다
SELECT FIRST_NAME, SALARY FROM EMPLOYEES;

SELECT *
FROM EMPLOYEES
WHERE SALARY >= (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David');

--------------------------------------------------------------------------------------------------
--다중행 서브쿼리 여러행이 리턴되는 서브쿼리
SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David';

-- > ANY 최솟값 보다 큰 데이터 (4800, 6500, 9500)
SELECT *
FROM EMPLOYEES
WHERE SALARY > ANY (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David');

-- < ANY 최댓값 9500 보다 작은 데이터
SELECT *
FROM EMPLOYEES
WHERE SALARY < ANY (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David');

-- > ALL 최댓값 9500보다 큰 데이터
SELECT *
FROM EMPLOYEES
WHERE SALARY > ALL (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David');

-- < ALL 최솟값 4800 보다 작은 데이터
SELECT *
FROM EMPLOYEES
WHERE SALARY < ALL (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David');

--IN은 정확히 일치하는 데이터가 나온다
SELECT *
FROM EMPLOYEES
WHERE SALARY IN (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David');

-----------------------------------------------------------------------------------------------
--문제 1.
--EMPLOYEES 테이블에서 모든 사원들의 평균급여보다 높은 사원들을 데이터를 출력 하세요 ( AVG(컬럼) 사용)
--EMPLOYEES 테이블에서 모든 사원들의 평균급여보다 높은 사원들을 수를 출력하세요
--EMPLOYEES 테이블에서 job_id가 IT_PFOG인 사원들의 평균급여보다 높은 사원들을 데이터를 출력하세요.
SELECT *
FROM EMPLOYEES
WHERE SALARY > ANY (SELECT AVG(SALARY) FROM EMPLOYEES);

SELECT COUNT(*)
FROM EMPLOYEES
WHERE SALARY > ANY (SELECT AVG(SALARY) FROM EMPLOYEES);

SELECT *
FROM EMPLOYEES
WHERE SALARY > ANY (SELECT AVG(SALARY) FROM EMPLOYEES WHERE JOB_ID = 'IT_PROG');

--문제 2.
--DEPARTMENTS테이블에서 manager_id가 100인 사람의 department_id(부서아이디) 와
--EMPLOYEES테이블에서 department_id(부서아이디) 가 일치하는 모든 사원의 정보를 검색하세요.
SELECT * FROM DEPARTMENTS;
SELECT * FROM EMPLOYEES;

SELECT *
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE MANAGER_ID = 100);

--문제 3.
--EMPLOYEES테이블에서 “Pat”의 manager_id보다 높은 manager_id를 갖는 모든 사원의 데이터를 출력하세요
--EMPLOYEES테이블에서 “James”(2명)들의 manager_id와 같은 모든 사원의 데이터를 출력하세요.
--Steven과 동일한 부서에 있는 사람들을 출력해주세요.
--Steven의 급여보다 많은 급여를 받는 사람들은 출력하세요.
SELECT *FROM EMPLOYEES;

SELECT *
FROM EMPLOYEES
WHERE MANAGER_ID > (SELECT MANAGER_ID FROM EMPLOYEES WHERE FIRST_NAME = 'Pat');

SELECT *
FROM EMPLOYEES
WHERE MANAGER_ID IN (SELECT MANAGER_ID FROM EMPLOYEES WHERE FIRST_NAME = 'James');

SELECT *
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM EMPLOYEES WHERE FIRST_NAME = 'Steven');

SELECT *
FROM EMPLOYEES
WHERE SALARY > ANY (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'Steven');

------------------------------------------------------------------------------------------------------
--스칼라 서브쿼리 SELECT절에 들어오는 서브쿼리. 조인 기능을 대체할 수 있다.
SELECT FIRST_NAME
      ,(SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID)
FROM EMPLOYEES E
ORDER BY FIRST_NAME;

--윗 구문을 JOIN구문으로 작성하면
SELECT FIRST_NAME
      ,DEPARTMENT_NAME
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
ORDER BY FIRST_NAME;


--스칼라 쿼리는 한번에 하나의 컬럼을 가지고 온다. 그러므로 많은 열을 가지고 올때는 가독성이 떨어질 수 있다.
SELECT FIRST_NAME
      ,(SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID)
      ,(SELECT MANAGER_ID FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID)
FROM EMPLOYEES E;

--스칼라 쿼리는 다른 테이블의 1개의 컬럼만 가지고 올 때 조인보다 유리할 수 있다.
--JOBS테이블의 JOB_TITLE을 가지고오고 DEPARTMENTS 테이블의 DEPARTMENT_ID를 조회
SELECT FIRST_NAME
      ,(SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID)
      ,(SELECT JOB_TITLE FROM JOBS J WHERE J.JOB_ID = E.JOB_ID)
FROM EMPLOYEES E;

------------------------------------------------------------------------------------------------------

--문제 4.
--EMPLOYEES테이블 DEPARTMENTS테이블을 left 조인하세요
--조건) 직원아이디, 이름(성, 이름), 부서아이디, 부서명 만 출력합니다.
--조건) 직원아이디 기준 오름차순 정렬
SELECT EMPLOYEE_ID AS 직원아이디
      ,CONCAT(E.FIRST_NAME, E.LAST_NAME) AS 이름
      ,D.DEPARTMENT_ID AS 부서아이디
      ,D.DEPARTMENT_NAME AS 부서명
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
ORDER BY EMPLOYEE_ID;

--문제 5. 문제 4의 결과를 (스칼라 쿼리)로 동일하게 조회하세요
SELECT EMPLOYEE_ID AS 직원아이디
      ,CONCAT(E.FIRST_NAME, E.LAST_NAME) AS 이름
      ,(SELECT DEPARTMENT_ID FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID) AS 부서아이디
      ,(SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID) AS 부서명
FROM EMPLOYEES E
ORDER BY E.EMPLOYEE_ID;

--문제 6.
--DEPARTMENTS테이블 LOCATIONS테이블을 left 조인하세요
--조건) 부서아이디, 부서이름, 스트릿_어드레스, 시티 만 출력합니다
--조건) 부서아이디 기준 오름차순 정렬
SELECT * FROM DEPARTMENTS;
SELECT * FROM LOCATIONS;

SELECT DEPARTMENT_ID
      ,DEPARTMENT_NAME
      ,L.STREET_ADDRESS
      ,L.CITY
FROM DEPARTMENTS D
LEFT JOIN LOCATIONS L
ON D.LOCATION_ID = L.LOCATION_ID
ORDER BY DEPARTMENT_ID;

--문제 7.
--문제 6의 결과를 (스칼라 쿼리)로 동일하게 조회하세요
SELECT DEPARTMENT_ID
      ,DEPARTMENT_NAME
      ,(SELECT STREET_ADDRESS FROM LOCATIONS L WHERE L.LOCATION_ID = D.LOCATION_ID)
      ,(SELECT CITY FROM LOCATIONS L WHERE L.LOCATION_ID = D.LOCATION_ID)
FROM DEPARTMENTS D
ORDER BY DEPARTMENT_ID;


--문제 8.
--LOCATIONS테이블 COUNTRIES테이블을 스칼라 쿼리로 조회하세요.
--조건) 로케이션아이디, 주소, 시티, country_id, country_name 만 출력합니다
--조건) country_name기준 오름차순 정렬
SELECT * FROM LOCATIONS;
SELECT * FROM COUNTRIES;

SELECT LOCATION_ID AS 지역번호
      ,STREET_ADDRESS AS 주소
      ,CITY AS 도시
      ,(SELECT COUNTRY_ID FROM COUNTRIES C WHERE C.COUNTRY_ID = L.COUNTRY_ID) AS 국가번호
      ,(SELECT COUNTRY_NAME FROM COUNTRIES C WHERE C.COUNTRY_ID = L.COUNTRY_ID) AS 나라명
FROM LOCATIONS L
ORDER BY 나라명;

---------------------------------------------------------------------------------------------------------

--인라인 뷰 FROM절 하위에 서브쿼리가 들어간다
--SELECT절에서 만든 가상 컬럼에 대해서 조회를 해 나갈 때 사용한다.

SELECT *
FROM (SELECT *
        FROM (SELECT *
              FROM EMPLOYEES)
              
);

--ROWNUM은 조회된 순서에 따라 변호가 붙으로므로 ORDER BY를 시키면 순서가 뒤바뀐다.
SELECT EMPLOYEE_ID,
       FIRST_NAME,
       SALARY
FROM EMPLOYEES
ORDER BY SALARY DESC;

--인라인 뷰
SELECT ROWNUM,
       EMPLOYEE_ID
       FIRST_NAME,
       SALARY
    
FROM EMPLOYEES
ORDER BY SALARY DESC;

--인라인뷰로 ROWNUM 붙이기
SELECT ROWNUM
      ,EMPLOYEE_ID
      ,FIRST_NAME
      ,SALARY
FORM (SELECT *
      FROM EMPLOYEES
      ORDER BY SALARY DESC
      )
WHERE ROWNUM > 10 AND ROWNUM <= 20; --10~20번째 데이터가 나와야하는데, ROWNUM은 1부터만 조회가 가능하다
    

    
    
--인라인뷰로 FROM 절에 필요한 컬럼을 가상의 컬럼으로 만들어 놓고, 조회
SELECT *
FROM (
    SELECT * ROWNUM AS RN,
       --A.FIRST_NAME || A.LAST_NAME AS NAME,
       --SALARY
       A.*
    FROM (
          SELECT *
          FROM EMPLOYEES
          ORDER BY SALARY DESC
    ) A --테이블 앨리어스
  )  
WHERE RN > 10 AND RN <=20;

--인라인뷰 EX
--근속년수 컬럼, COMMISSION이 더해진 급여 컬럼을 가상으로 만들고 조회
SELECT *
FROM (
    SELECT FIRST_NAME || ' ' || LAST_NAME AS 이름,
       TRUNC((SYSDATE - HIRE_DATE) / 365) AS 근속년수,
       SALARY + SALARY * NVL(COMMISSION_PCT, 0) AS 급여
    FROM EMPLOYEES
    ORDER BY 근속년수
);

--------------------------------------------------------------------------------------------------

--문제 9.
--EMPLOYEES테이블 에서 first_name기준으로 내림차순 정렬하고, 41~50번째 데이터의 행 번호, 이름을 출력하세요
SELECT *
FROM(
    SELECT ROWNUM AS RN,
        A.*
    FROM (
        SELECT *  
        FROM EMPLOYEES
        ORDER BY FIRST_NAME DESC
    ) A
    )
WHERE RN > 40 AND RN <= 50;


--문제 11.
--COMMITSSION을 적용한 급여를 새로운 컬럼으로 만들고, 이 데이터에서 10000보다 큰 사람들을 뽑아 보세요. (인라인뷰를 쓰면 됩니다)
SELECT *
FROM (
     SELECT FIRST_NAME
           ,SALARY + SALARY * NVL(COMMISSION_PCT, 0) AS 급여
     FROM EMPLOYEES
    )
    WHERE 급여 >= 10000;


--문제 12.
--조인의 최적화
SELECT CONCAT(FIRST_NAME, LAST_NAME) AS NAME,
       D.DEPARTMENT_ID
FROM EMPLOYEES E
JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE EMPLOYEE_ID = 200;

--이론적으로 위 구문의 실행방식은 EMPLOYEES - DEPARTMENTS 테이블을 먼저 조인하고, 후에 WHERE조건을 실행하게 됩니다.
--항상 이런것은 아닙니다. (이것은 데이터베이스 검색엔진(옵티마이저)에 의해 바뀔 수도 있습니다)
--그렇다면 SUBQUERY절로 WHERE구문을 작성하고, JOIN을 붙이는 것도 가능하지 않을까요?
--
--=> 부서아이디가 200인 데이터를 인라인뷰로 조회한 후에 JOIN을 붙여보세요.


SELECT *
FROM (
    SELECT *
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = 200
) A --테이블 앨리어스
JOIN DEPARTMENTS D
ON A.DEPARTMENT_ID = D.DEPARTMENT_ID;



--문제13
--EMPLOYEES테이블, DEPARTMENTS 테이블을 left조인하여, 입사일 오름차순 기준으로 10-20번째 데이터만 출력합니다.
--조건) rownum을 적용하여 번호, 직원아이디, 이름, 입사일, 부서이름 을 출력합니다.
--조건) hire_date를 기준으로 오름차순 정렬 되어야 합니다. rownum이 망가지면 안되요.
SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;

--내가 푼거
SELECT *
FROM(
    SELECT ROWNUM AS RN,
        A.*
    FROM (
        SELECT EMPLOYEE_ID
            ,FIRST_NAME
            ,HIRE_DATE
            ,(SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID)
        FROM EMPLOYEES E
        ORDER BY HIRE_DATE
    ) A
    )
WHERE RN > 10 AND RN <= 20;

--선생님 솔루션
SELECT *
FROM ( SELECT ROWNUM RN
      ,EMPLOYEE_ID
      ,FIRST_NAME || LAST_NAME AS NAME
      ,HIRE_DATE
      ,DEPARTMENT_NAME
FROM (  SELECT *
        FROM EMPLOYEES E
        LEFT JOIN DEPARTMENTS D
        ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
        ORDER BY HIRE_DATE
)    
)
WHERE RN > 10 AND RN <= 20;

--문제14
--SA_MAN 사원의 급여 내림차순 기준으로 ROWNUM을 붙여주세요.
--조건) SA_MAN 사원들의 ROWNUM, 이름, 급여, 부서아이디, 부서명을 출력하세요.

--처음 답
SELECT *
FROM(
    SELECT ROWNUM AS RN,
        A.*
    FROM (
        SELECT EMPLOYEE_ID
            ,FIRST_NAME
            ,SALARY
            ,JOB_ID
            ,DEPARTMENT_ID
            ,(SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID )
        FROM EMPLOYEES E
        WHERE JOB_ID = 'SA_MAN'
        ORDER BY SALARY DESC
    ) A
    
    );


--문제15
--DEPARTMENTS테이블에서 각 부서의 부서명, 매니저아이디, 부서에 속한 인원수 를 출력하세요.
--조건) 인원수 기준 내림차순 정렬하세요.
--조건) 사람이 없는 부서는 출력하지 뽑지 않습니다.
--힌트) 부서의 인원수 먼저 구한다. 이 테이블을 조인한다.

--선생님표 솔루션
SELECT *
FROM DEPARTMENTS D
JOIN (
    SELECT DEPARTMENT_ID
   ,COUNT(*) AS 인원수
    FROM EMPLOYEES
    GROUP BY DEPARTMENT_ID
) A
ON D.DEPARTMENT_ID = A.DEPARTMENT_ID
ORDER BY 인원수 DESC;



--문제16
--부서의 모든 컬럼, 주소, 우편번호, 부서별 평균 연봉을 구해서 출력하세요.
--조건) 부서별 평균이 없으면 0으로 출력하세요
SELECT * FROM DEPARTMENTS; --모든 컬럼
SELECT * FROM LOCATIONS; --주소 우편번호 DEPARTMENT랑 조인해야함
SELECT * FROM EMPLOYEES; -- 그룹바이 AVG연봉

--처음답
--
SELECT * 
FROM ( -- 부서의모든컬럼 + 주소,우편번호 + AVG연봉 인 가상의 테이블
    SELECT AVG(SALARY) FROM 가상의 테이블 WHERE --평균값이 NULL이면 0으로 출력 GROUP BY DEPARTMENT_ID
)





--문제17
--문제 16결과에 대해 DEPARTMENT_ID기준으로 내림차순 정렬해서 ROWNUM을 붙여 1-10데이터 까지만
--출력하세요