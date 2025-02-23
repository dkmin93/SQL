--SEQUENCE 시퀀스 (순차적으로 증가하는 값)
--보통 PK를 지정하는데 사용한다
SELECT * FROM USER_SEQUENCES;

--생성
CREATE SEQUENCE DEPTS_SEQ; -- 기본값으로 지정이 되면서 시퀀스가 생성된다

DROP SEQUENCE DEPTS_SEQ;  --시퀀스 삭제

CREATE SEQUENCE DEPTS_SEQ
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 10
    MINVALUE 1
    NOCYCLE -- 시퀀스가 MAX에 도달했을 때 재사용 X
    NOCACHE; -- 시퀀스는 메모리(캐시)에 두지 않음

DROP TABLE DEPTS;
CREATE TABLE DEPTS (
    DEPT_NO NUMBER(2) PRIMARY KEY,
    DEPT_NAME VARCHAR2(30)
                    );

--시퀀스 사용 방법 2가지
SELECT DEPTS_SEQ.CURRVAL FROM DUAL; --NEXTVAL이 최소 1번은 실행이 되어야만 CURRVAL을 사용할 수 있다.
SELECT DEPTS_SEQ.NEXTVAL FROM DUAL; --한번 NEXTVAL이 일어나면 후진은 불가능하다.

INSERT INTO DEPTS VALUES (DEPTS_SEQ.NEXTVAL, 'EXAMPLE'); --MAXVALULE에 도달하면 더 이상 사용이 불가능

SELECT * FROM DEPTS;

--시퀀스의 수정
ALTER SEQUENCE DEPTS_SEQ MAXVALUE 1000;
ALTER SEQUENCE DEPTS_SEQ INCREMENT BY 10;

--시퀀스가 이미 테이블에서 사용 중에 있으면 시퀀스는 DROP하면 절대로 네버 네버 안된다.
--주기적으로 시퀀스를 초기화 해야 한다면? (꼼수)
--시퀀스 증가값을 -현재값으로 바꾸고 전진을 시킨다. 원하는 작업을 하고 다시 시퀀스 증가값을 양수값으로 바꾼다
SELECT DEPTS_SEQ.CURRVAL FROM DUAL;
ALTER SEQUENCE DEPTS_SEQ INCREMENT BY -10 MINVALUE 0; 
SELECT DEPTS_SEQ.NEXTVAL FROM DUAL;
ALTER SEQUENCE DEPTS_SEQ INCREMENT BY 1;
--시퀀스가 초기화 됨
SELECT DEPTS_SEQ.NEXTVAL FROM DUAL;

--------------------------------------------------------------------------------------------------------------
--문제1
CREATE TABLE EMPS (
    EMPS_NO VARCHAR2(30) PRIMARY KEY,
    EMPS_NAME VARCHAR2(30)
                    );
--이 테이블에 PK를 2025-00001 형식으로 INSERT 하려고한다
--다음 값은 2025-00002 형식이 된다.
--시퀀스를 만들고 INSERT 넣을 때, 위 형식처럼 값이 들어갈 수 있도록 INSERT를 넣기
CREATE SEQUENCE EMPS_SEQ
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 99999
    MINVALUE 1
    NOCYCLE
    NOCACHE;

SELECT EMPS_SEQ.CURRVAL FROM DUAL;
SELECT EMPS_SEQ.NEXTVAL FROM DUAL;

INSERT INTO EMPS VALUES ('2025-' || TO_CHAR(LPAD(EMPS_SEQ.NEXTVAL, 5, 0)), 'EXAMPLE');

SELECT * FROM EMPS;

--선생님 솔루션
CREATE SEQUENCE EMPS_SEQ NOCACHE;
INSERT INTO VALUES(TO_CHAR(SYSDATE, 'YYYY') || '-' || LPAD(EMPS_SEQ.NEXTVAL, 5, 0), 'EXAMPLE');

--------------------------------------------------------------------------------------------------------------
--인덱스 (검색 속도를 빠르게 해주는 힌트 역할을 한다)
--INDEX의 종류로는 고유인덱스, 비고유인덱스가 있다.
--고유인덱스(PK,UK를)를 만들 때 자동으로 생성되는 인덱스이다
--비고유인덱스는 일반 컬럼에 지정해서 조회를 빠르게 할 수 있는 인덱스이다.
--단, 인덱스는 조회를 빠르게 할 수 있는 수단이지만 너무 무작위로 사용할 경우 성능저하를 일으킬 수도 있다
--주로 사용되는 컬럼에서 SELECT절이 속도 저하가 있다면 일단 먼저 고려해볼 사항이 인덱스 기능이다.
DROP TABLE EMPS;
CREATE TABLE EMPS AS (SELECT * FROM EMPLOYEES);
SELECT * FROM EMPS WHERE FIRST_NAME = 'Nancy';
--FIRST_NAME 컬럼에 인덱스 부착
CREATE INDEX EMPS_IDX ON EMPS(FIRST_NAME);
SELECT * FROM EMPS WHERE FIRST_NAME = 'Nancy';

--인덱스 삭제 (삭제를 하더라도 테이블에 영향을 미치지 않습니다)
DROP INDEX EMPS_IDX;
--결합인덱스 (여러 컬럼을 묶어서 생성할 수 있다 슈퍼키처럼 2개 이상의 인덱스를 묶을 수도 있다)
CREATE INDEX EMPS_ODX ON EMPS(FIRST_NAME, LAST_NAME);
SELECT * FROM EMPS WHERE FIRST_NAME = 'Nancy'; --인덱스 힌트를 받음
SELECT * FROM EMPS WHERE FIRST_NAME = 'Nancy' AND LAST_NAME = 'Greenberg'; --인덱스 힌트를 받음
SELECT * FROM EMPS WHERE LAST_NAME = 'Greenberg';

--고유인덱스
CREATE UNIQUE INDEX 인덱스명 ON 테이블명(부착할 컬럼); -- PK, UK를 만들 때 자동 생성해준다. (PK,UK를 조회할 때 인덱스 효과를 받는다)

SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID = 100;


