 /*
    <DDL (ALTER, DROP)>
               데이터 정의 언어로 오라클에서 제공하는 객체를 만들고CREATE, 변경하고ALTER, 삭제DROP하는 등
        실제 데이터 값이 아닌 구조 자체를 정의하는 언어로 DB 관리자, 설계자가 주로 사용한다.       
        
        ADD         COLUMN                     제약조건 NOT NULL외 4가지 추가
        MODIFY      COLUMN:자료형, DEFAULT      제약조건 NOT NULL 추가, 삭제
        DROP        COLUMN                     제약조건 NOT NULL외 4가지 삭제                  DROP TABLE 테이블명
        RENAME      COLUMN명, TABLE명, 제약조건명
        
        
        
        
    <ALTER>
        객체를 수정하는 구문       
        테이블을 수정하는 구문 위주로 작성
        
        [표현식]
            ALTER TABLE 테이블명 수정할 내용;
            
            - 수정할 내용-
            1) 컬럼 추가/수정/삭제
            2) 제약조건 추가/삭제 --> 수정은 불가 (삭제 후 새로 제약조건 추가해야 한다.)
            3) 테이블명/컬럼명/제약조건명 변경
*/
-- 실습에 사용할 테이블 생성
CREATE TABLE DEPT_COPY
AS SELECT *
    FROM DEPARTMENT;
    
SELECT * FROM DEPT_COPY;

-- 1) 컬럼 추가/수정/삭제
-- 1-1) 컬럼 추가(ADD) : ADD 컬럼명 테이터타입 [DEFAULT 기본값]
ALTER TABLE DEPT_COPY ADD CNAME VARCHAR(20);    
-- CNAME 컬럼이 추가, 컬럼은 맨뒤에 추가된다. 
-- 새로운 컬럼이 만들어지면 기본으로 NULL 값이 채워진다. 
ALTER TABLE DEPT_COPY ADD LNAME VARCHAR2(40) DEFAULT '한국';
    
ALTER TABLE DEPT_COPY DROP COLUMN LNAME;        -- VARCHAR 땜에 지우고 다시 생성 
    
ALTER TABLE DEPT_COPY ADD LNAME VARCHAR2(40) DEFAULT '한국';
-- LNAME 컬럼을 기본값을 지정한 채로 추가

SELECT * FROM DEPT_COPY;

-- 1-2) 컬럼 수정 (MODIFY)
--      데이터타입 변경시   : MODIFY 컬럼명 바꾸고자 하는 데이터타입
--      기본값 변경시      : MODIFY 컬럼명 DEFAULT 바꾸고자 하는 기본값
    
-- DEPT_ID 컬럼의 데이터타입을 CHAR(3)으로 변경 
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3);

-- 다중 수정 
ALTER TABLE DEPT_COPY 
    MODIFY DEPT_TITLE VARCHAR(40)
    MODIFY LOCATION_ID VARCHAR(2)
    MODIFY LNAME DEFAULT '미국';
    
-- 1-3) 컬럼 삭제 (DROP COLUMN) : DROP COLUMN 삭제하고자 하는 컬럼명
--      데이터 값이 기록되어 있어도 같이 삭제된다.(단, 삭제된 컬럼 복구는 불가능) 
--      테이블에는 최소 한개의 컬럼은 존재해야 한다. 
--      참조되고 있는 컬럼이 있다면 DROP 불가능

CREATE TABLE DEPT_COPY2 
AS SELECT *
    FROM DEPT_COPY;
    
SELECT * FROM DEPT_COPY2;
-- DEPT_ID 컬럼 지우기 
ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_ID;

ROLLBACK;       -- DDL 구문은 복구 불가능

ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_TITLE;
ALTER TABLE DEPT_COPY2 DROP COLUMN CNAME;
ALTER TABLE DEPT_COPY2 DROP COLUMN LNAME;
ALTER TABLE DEPT_COPY2 DROP COLUMN LACATION_ID;     -- 최소 한 개의 컬럼은 남아 있어야 한다. 


----------------------------------------------------------
/*
    2) 제약조건 추가/삭제
        2-1) 제약조건 추가
            PRIMARY KEY : ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] PRIMARY KEY(컬럼명);
            FOREIGN KEY : ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] FOREIGN KEY(컬럼명) REFERENCES 참조할 테이블명 [(컬럼명)];
            UNIQUE      : ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] UNIQUE(컬럼명);
            CHECK       : ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] CHECK(컬럼에 대한 조건);
            NOT NULL    : ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL;
*/

-- DEPT_COPY 테이블에 
-- DEPT_ID는 PK 제약조건 추가
-- DEPT_TITLE은 UNIQUE 제약조건 추가
-- LNAME은 NOT NULL 제약조건 추가
ALTER TABLE DEPT_COPY
ADD CONSTRAINT DEPT_COPY_DEPT_ID_PK PRIMARY KEY(DEPT_ID)
ADD CONSTRAINT DEPT_COPY_DEPT_TITLE_UQ UNIQUE(DEPT_TITLE)
MODIFY LNAME CONSTRAINT DEPT_COPY_LNAME_NN NOT NULL;

-- ALTER TABLE DEPARTMENT ADD PRIMARY KEY(DEPT_ID);  -- 잘못해서 지웠다 복구한 사람만

-- 2-2) 제약조건 삭제 
--      NOT NULL  : MODIFY 컬럼명 NULL
--      나머지     : DROP CONSTRAINT 제약조건명

-- DEPT_COPY_DEPT_ID는 PK 제약조건 지우기
ALTER TABLE DEPT_COPY DROP CONSTRAINT DEPT_COPY_DEPT_ID_PK;

--DEPT_COPY_DEPT_TITLE_UQ 제약조건 지우기
--DEPT_COPY_LNAME_NN 제약조건 지우기
ALTER TABLE DEPT_COPY
DROP CONSTRAINT DEPT_COPY_DEPT_TITLE_UQ
MODIFY LNAME NULL;

-- 제약조건 수정은 불가능하다. (삭제 후 다시 추가해줘야 한다. )

----------------------------------------------------------------------
/*
    3) 테이블명/컬럼명/제약조건명 변경 (RENAME)
*/
-- 3-1) 컬럼명 변경 : RENAME COLUMN 기존 컬럼명 TO 바꿀컬럼명
SELECT * FROM DEPT_COPY;

-- DEPT_TITLE --> DEPT_NAME으로 컬럼명 변경
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;


-- 3-2) 제약조건명 변경 : RENAME CONSTRAINT 기존제약조건명 TO 바꿀 제약조건명
--SYS_C007100 --> DCOPY_DID_NN
ALTER TABLE DEPT_COPY RENAME CONSTRAINT SYS_C007100 TO DCOPY_DID_NN;        

-- 3-3) 테이블명 변경 
-- ALTER TABLE 테입블명 RENAME [기존 테이블명] TO 바꿀 테이블명
-- RENAME 기존 테이블명 TO 바꿀 테이블명
-- DEPT_COPY --> DEPT_TEST 
ALTER TABLE DEPT_COPY RENAME TO DEPT_TEST;
-- RENAME DEPT_COPY TO DEPT_TEST;



------------------------------------------------------------
/*
    <DROP>
        데이더베이스 객체를 삭제하는 구문 
*/

-- 테이블 삭제 
DROP TABLE DEPT_TEST;

-- 단, 참조되고 있는 부모 테이블들은 함부로 삭제가 되지 않는다.
-- 만약에 삭제 하고자 한다면, 
-- 1. 자식 테이블을 면저 삭제한 후 부모테이블 삭제 
-- 2. 부모테이블 삭제하는데 제약조건도 함께 삭제 
DROP TABLE DEPT_TEST CASCADE CONSTRAINT;











