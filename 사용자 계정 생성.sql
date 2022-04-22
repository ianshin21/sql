
-- sys / SYSTEM 접속 비밀번호 : oracle

-- sys 혹은 SYSTEM 관리자계정에서 실행 
SELECT * FROM DBA_USERS;

-- 시스템(관리자계정에서) 계정에서 발생(실행) -> 그런다음 접속(창)으로 로그인
CREATE USER WEB IDENTIFIED BY WEB;
GRANT RESOURCE, CONNECT TO WEB;

DROP USER (계정 이름);


-- 사용자 계정 생성하는 구문(관리자 계정만이 할 수 있다)
-- [표현법] CREATE USER 계정명 IDENTIFIED BY 계정 비밀번호;
CREATE USER KH IDENTIFIED BY KH;

-- 위에서 만든 사용자 계정에서 최소한의 권한(데이터 관리, 접속) 부여
GRANT RESOURCE, CONNECT TO KH;



-- 사용자에 부여할 권한 : CONNECT,RESOURCE

-- 권한을 부여받을 사용자 : MYMY

CREATE USER MYMY IDENTIFIED BY MINE;
--위와 같이 사용자계정을 생성한 다음  
--아래와 같인 권한을 부여한다.
GRANT RESOURCE, CONNECT TO MYMY;

-- 그런 다음 접속 + 를 크릭하여 들어가서 NAME -> 사용자 이름 -> 비밀번호 입력 후 테스트 -> 접속
-- 필요업는 접속은 DELETE



-- index 조회
SELECT * FROM USER_IND_COLUMNS;

SELECT ROWID, EMP_ID, EMP_NAME
FROM EMPLOYEE;

SELECT ROWID, DEPT_ID
FROM DEPARTMENT;




-- VIEW 조회 
SELECT * 
FROM USER_VIEWS;

SELECT VIEW_NAME, TEXT
FROM USER_VIEWS;

-- 처음 VIEW 생성시 관리자 계정으로 sys/SYSTEM 에서 CREATE VIEW 을 주어야 한다.
--GRANT CREATE VIEW TO KH;   이렇게 실행시키면 됨  -- 비밀번호 oracle


--현재 계정이 가지고 있는 시퀀스들에 대한 정보
SELECT * FROM USER_SEQUENCES;


-- 프로시저, 펑션(함수), 트리거
DESC USER_SOURCE;       -- DESCRIPTION 테이블 구조보기

SELECT * FROM USER_SOURCE;



-- SYNONYM
-- 비공개 동의어

GRANT CREATE SYNONYM TO EMPLOYEE;   -- (SYSTEM 계정)에서

CREATE SYNONYM EMP FOR EMPLOYEE;    -- (EMPLOYEE)가 있는 KH 계정에서

SELECT * FROM EMPLOYEE;
SELECT * FROM EMP;


-- 공개 동의어

CREATE PUBLIC SYNONYM DEPT FOR kh.DEPARTMENT;    -- (SYSTEM 계정)에서

SELECT * FROM kh.DEPARTMENT;                     -- (SYSTEM 계정)에서
SELECT * FROM DEPT;

SELECT * FROM DEPARTMENT;            -- (EMPLOYEE)가 있는 KH 계정에서
SELECT * FROM DEPT;



-- 제약조건 확인 
SELECT * FROM USER_CONSTRAINTS;  -- 사용자가 작성한 제약조건을 확인하는 뷰 (데이터 딕셔너리 중 하나)

SELECT * FROM USER_CONS_COLUMNS;        -- 제약조건이 걸려있는 컬럼을 확인하는 뷰






























