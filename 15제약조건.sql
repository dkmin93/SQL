--제약 조건 컬럼에 원치 않는 데이터가 입력 삭제 수정 되는 것을 방지하기 위한 조건
--PRIMARY KEY 테이블의 고유키, 중복이 불가능하고 NULL값 입력도 안되며 테이블에 오로지 1개
--UNIQUE 중복이 불가능하지만 PK랑은 다르게 NULL 값 입력이 가능하다
--NOT NULL NULL을 허용하지 않는다.
--FOREIGN KEY 참조하는 테이블의 PK를 넣어놓은 컬럼 중복이 가능하며 NULL값 입력도 가능
--CHECK 컬럼에 대한 데이트 제한 (WHERE절과 유사하다)

--제약 조건을 확인하는 명령문 OR 마우스로 확인
SELECT * FROM USER_CONSTRAINTS;

--1ST 열레벨로 정의하기
DROP TABLE DEPTS;
CREATE TABLE DEPTS(
    DEPT_NO NUMBER(2)       CONSTRAINT DEPTS_DEPT_NO_PK PRIMARY KEY,
    DEPT_NAME VARCHAR2(30)  CONSTRAINT DEPTS_DEPT_NAME_NN NOT NULL, 
    DEPT_DATE               DEFAULT SYSDATE, --값이 들어가지 않을 때 자동으로 지정되는 기본값
    DEPT_PHONE VARCHAR2(30)  CONSTRAINT DEPTS_DEPT_PHONE_UK UNIQUE, 
    DEFT_GENDER CHAR(1)    CONSTRAINT DEPTS_DEPT_GENDER_CK CHECK(DEPT_GENDER IN ('F', 'M')),
    LOCA_ID NUMBER(4)       CONSTRAINT DEPTS_LOCA_ID_FK REFERENCES LOCATIONS(LOCATION_ID)
);

--(CONSTRAINTS는 생략 가능)
DROP TABLE DEPTS;
CREAT TABLE DEPTS(
    DEPT_NO NUMBER(2)       PRIMARY KEY,
    DEPT_NAME VARCHAR2(30)  NOT NULL                        --강의영상보고 복기
    DEPT_DATE DATE
    DEPT_PHONE VARCHAR2(30)
    DEFT_GENDER CHAR(1) CHECK(DEPT_CENDER IN ('F', 'M')),
    LOCA_ID NUMBER(4) REFERENCES LOCATIONS(LOCATION_ID)
);

DESC DEPTS;

INSERT INTO DEPTS(DEPR_NO, DEPT_NAME, DEPT_PHONE, DEPT_GENDER, LOCA_ID)
VALUES(1, NULL, '010...', 'F', 1700); -- NOT NULL 제약 위배
INSERT INTO DEPTS(DEPR_NO, DEPT_NAME, DEPT_PHONE, DEPT_GENDER, LOCA_ID)
VALUES(1, 'HONG', '010...', 'X', 1700); -- CHECK 제약 위배
INSERT INTO DEPTS(DEPR_NO, DEPT_NAME, DEPT_PHONE, DEPT_GENDER, LOCA_ID)
VALUES(1, 'HONG', '010...', 'F', 100); --FK제약 위배
INSERT INTO DEPTS(DEPR_NO, DEPT_NAME, DEPT_PHONE, DEPT_GENDER, LOCA_ID)
VALUES(2, 'HONG', '010...', 'F', 1700); --유니크 제약 위배

--개체 무결성 : 기본키는 NOT NULL일 수 없고 중복될 수도 없다는 규칙
--참조 무결성 : FK가 아닌 값. 즉 참조하는 테이블의 PK만 FK컬럼에 들어갈 수 있다는 규칙
--도메인 무결성 : CHECK, UNIQUE 제약을 위배할 수 없다는 규칙






