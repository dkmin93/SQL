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
    DEPT_DATE DATE               DEFAULT SYSDATE, --값이 들어가지 않을 때 자동으로 지정되는 기본값
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

-------------------------------------------------------------------------------------------------
--2ND 테이블 레벨 제약조건
DROP TABLE DEPTS;

CREATE TABLE DEPTS (
    DEPT_NO NUMBER(2),      
    DEPT_NAME VARCHAR2(30) NOT NULL,  
    DEPT_DATE DATE,              
    DEPT_PHONE VARCHAR2(30),  
    DEFT_GENDER CHAR(1),    
    LOCA_ID NUMBER(4),
    CONSTRAINT DEPTS_DEPT_NO_PN PRIMARY KEY (DEPT_NO), --슈퍼키 지정은 테이블 레벨로 가능하다
    CONSTRAINT DEPTS_DEPT_PHONE_UK UNIQUE KEY (DEPT_PHONE),
    CONSTRAINT DEPTS_GENDER_CK CHECK (DEPT_GENDER IN ('F', 'M')),
    CONSTRAINT DEPTS_LOCA_ID_FK FOREIGN KEY (LOCA_ID) REFERENCES LOCATIONS(LOCATION_ID)
                    );

----------------------------------------------------------------------------------------------------------------
--3RD (제약 조건의 추가 삭제), 수정은 불가능

CREATE TABLE DEPTS (
    DEPT_NO NUMBER(2),      
    DEPT_NAME VARCHAR2(30),  
    DEPT_DATE DATE             DEFAULT SYSDATE,              
    DEPT_PHONE VARCHAR2(30),  
    DEFT_GENDER CHAR(1),    
    LOCA_ID NUMBER(4)
                    );
ALTER TABLE DEPTS ADD CONSTRAINT DEPT_NO_PK PRIMARY KEY (DEPT_NO); --PK추가
--NOT NULL은 MODIFY구문으로 열 변경으로 추가한다
ALTER TABLE DEPTS MODIFY DEPT_NAME VARCHAR2(30) NOT NULL; -- NOT NULL은 MODIFY 구문으로 열 변경으로 추가한다
ALTER TABLE DEPTS ADD CONSTRAINT DEPT_PHONE_UK UNIQUE (DEPT_PHONE); --UK추가
ALTER TABLE DEPTS ADD CONSTRAINT DEPT_GENDER_CK CHECK(DEPT_GENDER IN ('F', 'M')); --CK추가
ALTER TABLE DEPTS ADD CONSTRAINT DEPT_LOCA_ID_FK FOREIGN KEY (LOCA_ID) REFERENCES LOCATIONS(LOCATINON_ID);

--제약조건의 삭제
ALTER TABLE DEPTS DROP PRIMARY KEY; --이렇게 지울 수 있다
ALTER TABLE DEPTS DROP CONSTRAINT DEPT_LOCA_ID_FK; --이름으로도 지울 수 있다

--테이블의 제약조건을 SQL문으로 확인
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'DEPTS';

--------------------------------------------------------------------------------------------------------------
--문제1. --영상보고 복기
--다음과 같은 테이블을 생성하고 데이터를 insert해보세요.
--테이블 제약조건은 아래와 같습니다. 
--조건) M_NAME 는 가변문자형 20byte, 널값을 허용하지 않음
--조건) M_NUM 은 숫자형 5자리, PRIMARY KEY 이름(mem_memnum_pk) 
--조건) REG_DATE 는 날짜형, 널값을 허용하지 않음, UNIQUE KEY 이름:(mem_regdate_uk)
--조건) SALARY 숫자형 10자리, CHECK제약 (0 보다 크다)
--조건) LOCA 숫자형 4자리, FOREIGN KEY – 참조 locations테이블(location_id) 이름:(mem_loca_loc_locid_fk)

CREATE TABLE M (      
    M_NAME VARCHAR2(20) CONSTRAINT M_M_NAME_NN NOT NULL, 
    M_NUM NUMBER(5) CONSTRAINT M_M_NUM_PK PRIMARY KEY,
    REG_DATE DATE NOT NULL,              
    GENDER CHAR(1) CONSTRAINT M_GENDER_CK CHECK(M_GENDER IN ('F', 'M')),   
    LOCA NUMBER(4) CONSTRAINT M_LOCA_FK REFERENCES LOCATIONS(LOCATION_ID),
    SALARY NUMBER(10) CONSTRAINT M_SALARY_CK CHECK(M_SALARY > 0)
    CONSTRAINT D_REG_DATE_UK UNIQUE KEY (REG_DATE)
                );
INSERT INTO M(M_NAME, M_NUM, REG_DATE, GENDER, LOCA)
VALUES(AAA, 1, '2018-07-01', 'M', 1800);
INSERT INTO M(M_NAME, M_NUM, REG_DATE, GENDER, LOCA)
VALUES(BBB, 2, '2018-07-02', 'F', 1900);
INSERT INTO M(M_NAME, M_NUM, REG_DATE, GENDER, LOCA)
VALUES(CCC, 3, '2018-07-03', 'M', 2000);
INSERT INTO M(M_NAME, M_NUM, REG_DATE, GENDER, LOCA)
VALUES(DDD, 4, SYSDATE, 'M', 2000);
            

--문제2.
--도서테이블, 도서 대여 이력 테이블을 생성하려 합니다.
--도서 테이블은
--도서번호(문자) PK, 도서명(문자), 출판사(문자), 입고일(날짜)
--도서 대여 이력 테이블은
--대여번호(숫자) PK, 도서번호(문자) FK, 대여일(날짜), 반납일(날짜), 반납여부(Y/N)
--를 가집니다.
--적절한 테이블을 생성해 보세요.

DROP TABLE BOOK;

CREATE TABLE BOOK (
    BOOKNUM VARCHAR2(20) PRIMARY KEY,
    BOOKNAME VARCHAR2(20),
    BP VARCHAR2(10),
    BDATE DATE DEFAULT SYSDATE
                    );

CREATE TABLE BOOKRENTAL (
    RENTALNUM NUMBER(10) CONSTRAINT BOOKRENTAL_RENTALNUM_PK PRIMARY KEY,
    BOOKNUM VARCHAR2(20) CONSTRAINT BOOKRENTAL_BOOKNUM_FK REFERENCES BOOK(BOOKNUM),
    BDATE DATE NOT NULL,
    RENTALDATE DATE DEFAULT SYSDATE,
    RENTALCHECK CHAR(1) CONSTRAINT BOOKRENTAL_RENTALCHECK_CK CHECK(RENTALCHECK IN ('Y', 'N'))
                    );


