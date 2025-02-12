--트랜잭션 (작업의 논리적인 단위)
--DML 구문에 대해서만 트랜잭션을 적용할 수 있다.

--오토 커밋 상태를 확인. 실수를 할 수 있으므로 보통은 OFF 상태로 둬야 한다
SHOW AUTOCOMMIT;
SET AUTOCOMMIT ON;
SET AUTOCOMMIT OFF;

--------------------------------------------------------------------------------------------------------

--SAVE POINT (실제로 많이 쓰진 않는다) 시점을 기록하는 용도
COMMIT;
SELECT * FROM DEPTS;

--현재 시점을 세이브포인트로 기록한다
DELETE FROM DEPTS WHERE DEPARTMENT_ID = 10;
SAVEPOINT DEL10; --DEL10이 세이프 포인트 이름
DELETE FROM DEPTS WHERE DEPARTMENT_ID = 20;
SAVEPOINT DEL20;

--세이브 포인트를 지정한 바로 이전 시점으로 돌아간다.
ROLLBACK TO DEL20;
SELECT * FROM DEPTS;
ROLLBACK TO DEL10;
ROLLBACK; --마지막 커밋 이후 돌아간다

--커밋 (데이터 변경을 실제로 반영한다) 커밋 이후에는 되돌릴 수 없다.
INSERT INTO DEPTS VALUES(280, 'AAA', NULL, 1800);
COMMIT;











