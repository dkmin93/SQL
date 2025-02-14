SELECT * FROM HR.EMPLOYEES;
--사용자 계정 확인
SELECT * FROM ALL_USERS;
--현재 사용자의 권한 확인
SELECT * FROM USER_SYS_PRIVS;

--사용자 계정을 생성 (관리자만 가능)
CREATE USER USER01 IDENTIFIED BY USER01;

--데이터베이스에 접속 하려면 접속 권한
--테이블 생성을 하려면 뷰 생성 권한
--뷰 생성을 하려면 뷰 생성 권한
--시퀀스 생성을 하려면 시퀀스 생성 권한
--프로시저 생성을 하려면 프로시저 생성 권한
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE SEQUENCE, CREATE PROCEDURE TO USER01; 

--테이블스페이스는 테이블에 데이터가 실제로 저장되는 물리적인 공간을 말한다.
ALTER USER USER01 DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;

--권한 회수 REVOKE ~ FROM
REVOKE CREATE SESSION FROM USER01;

--계정 삭제
DROP USER USER01 CASCADE; --계정이 테이블과 데이터를 가지고 있으면 테이블을 포함해서 싹 다 삭제가 일어난다

-----------------------------------------------------------------------------------------------------------
--롤 을 이용한 권한부여
CREATE USER01 IDENTIFIED BY USER01;
GRANT RESOURCE, CONNECT TO USER01; --리소스롤 (테이블,뷰,시퀀스,프로시저 등의 권한의 그룹)
ALTER USER USER01 DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
DROP USER SUER01;