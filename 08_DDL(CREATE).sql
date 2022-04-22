/*
    <DDL(Data Defintion Language)>
        데이터 정의 언어로 오라클에서 제공하는 객체를 만들고CREATE, 변경하고ALTER, 삭제DROP하는 등
        실제 데이터 값이 아닌 구조 자체를 정의하는 언어로 DB 관리자, 설계자가 주로 사용한다.       
*/

/*
    <CREATE>
        데이터베이스 객체를 생성하는 구문 
        
        * 테이블 생성 
            행과 열로 구성되는 가장 기본적인 데이터베이스 객체로 데이터베이스 내에서 모든 데이터는 테이블에 저장된다.
            
            [표현식]
            CREATE TABLE 테이블명 (
                컬럼명 자료형(크기) [제약조건],
                컬럼명 자료형(크기) [제약조건],
                .......
            );
*/

-- 회원에 대한 데이터를 담을 수 있는 MEMBER 테이블 생성
CREATE TABLE MEMBER(
    MEMBER_ID VARCHAR2(20),
    MEMBER_PWD VARCHAR2(20),
    MEMBER_NAME VARCHAR2(20),
    MEMBER_DATE DATE DEFAULT SYSDATE     --> 기본값 지정해 줄 수 있다. 자동으로 입력
);

-- DROP TABLE MEMBER;

-- 만든 테이블 확인
DESC MEMBER;           -- 테이블 구조 보기 DESCRIPTION 
SELECT * FROM MEMBER;

/*
    데이터 딕셔너리 : 메타 데이터
        자원을 효율적으로 관리하기 위한 다양한 객체들의 정보를 저장하는 시스템 테이블
        데이터 딕셔너리는 사용자가 객체를 생성하거나 객체를 변경하는 등의 작업을 할 때 
                            데이터베이스 서버에 의해서 자동으로 갱신되는 테이블이다.
        데이터에 관한 데이터가 저장되어 있다고 해서 메타데이터라고도 한다. 
       ::: 실습환경스크립트에서 설정 확인 할 수 있다.
*/
-- USER_TABLES : 사용자가 가지고 있는 테이블들의 전반적인 구조를 확인하는 뷰테이블이다.
SELECT * FROM USER_TABLES WHERE TABLE_NAME = 'MEMBER';

-- DML(INSERT) 사용해서 만들어진 테이블에 샘플데이터 추가하기
-- INSERT INTO 테이블명[(컬럼명, ..., 컬럼명)] VALUES(컬럼값, 컬럼값, ...);

INSERT INTO MEMBER VALUES('USER1', 'PASSWORD1', '홍길동', '2020-10-20');
INSERT INTO MEMBER VALUES('USER2', 'PASSWORD2', '김영희', SYSDATE);
INSERT INTO MEMBER(MEMBER_ID, MEMBER_PWD, MEMBER_NAME) VALUES('USER3', 'PASSWORD2', '박철수');

SELECT * FROM MEMBER
ORDER BY MEMBER_ID;

-----------------------------------------------
/*
    <제약조건 CONSTRAINTS>
        사용자가 원하는 조건의 데이터만 유지하기 위해 특정 컬럼에 설정하는 제약
        테이블 작성시 각 컬럼에 대해 저장될 값에 대한 제약조건을 설정할 수 있다. 
        (ALTER 구문을 통해서도 제약조건을 설정하고 변경, 삭제할 수 있다.)
        데이터 무결성 보장을 목적으로 한다. 
        들어온 데이터에 문제가 없는지 자동으로 검사 
        
        * 종류 : NOT NULL, UNIQUE, CHECK, PRIMARY KEY, FOREIGN KEY 
        
        * 제약조건을 부여하는 표현식 
            1) 컬럼레벨
                CREATE TABLE 테이블명 (
                    컬럼명 자료형(크기) [CONSTRAINTS 제약조건명] 제약조건,   : 제약조건명 지정하지 않으면 임의의 이름으로 들어간다. SYS_C007018 등으로
                    컬럼명 자료형(크기) [제약조건],
                    .......
                );
                
            2) 테이블레벨
                CREATE TABLE 테이블명 (
                    컬럼명 자료형(크기) [제약조건],
                    컬럼명 자료형(크기) [제약조건],
                    .......
                    [CONSTRAINTS 제약조건명] 제약조건(컬럼명)
                );
*/ 

-- 제약조건 확인 
SELECT * FROM USER_CONSTRAINTS;  -- 사용자가 작성한 제약조건을 확인하는 뷰 (데이터 딕셔너리 중 하나)

SELECT * FROM USER_CONS_COLUMNS;        -- 제약조건이 걸려있는 컬럼을 확인하는 뷰


/*
    <NOT NULL 제약조건>
        해당 컬럼에 반드시 값이 있어야만 하는 경우 사용 (NULL 값이 들어와서는 안 될 경우)
        삽입 / 수정시 NULL값을 허용하지 않도록 제한한다. 
*/
-- 기존 MEMBER 테이블에는 값에 NULL이 있어도 삽입 가능
INSERT INTO MEMBER VALUES(NULL, NULL, NULL, NULL);

SELECT * FROM MEMBER;

-- NOT NULL 제약조건을 설정한 테이블 만들기
-- 테이블 생성시 컬럼에 제약조건을 거는 방식이 크게 2가지(컬럼레벨/테이블레벨)가 있다
-- 단, NOT NULL 제약조건은 컬럼레벨에서만 가능하다. 

CREATE TABLE MEMBER_NOTNULL(
    MEMBER_ID VARCHAR2(20) NOT NULL,
    MEMBER_PWD VARCHAR2(20) NOT NULL,
    MEMBER_NAME VARCHAR2(20) NOT NULL,
    MEMBER_DATE DATE DEFAULT SYSDATE     
);

-- NOT NULL 제약 조건에 위배되어 오류 발생
INSERT INTO MEMBER_NOTNULL VALUES(NULL, NULL, NULL, NULL);

-- NOT NULL 제약 조건에 걸려있는 컬럼에는 반드시 값이 있어야한다.
INSERT INTO MEMBER_NOTNULL VALUES('USER1', 'PWD1', '아무개', NULL);

DESC MEMBER_NOTNULL;
SELECT * FROM MEMBER_NOTNULL;

--------------------------------------------------------------------------------
/*
    <UNIQUE 제약조건>
        컬럼값에 중복값을 제한하는 제약조건
        삽입/수정시 기존에 있는 데이터 값 중에 중복값이 있을 경우 추가되지 않는다.
        컬럼/테이블레벨 방식 둘다 사용가능
*/ 

-- 다음은 아이디가 중복되었음에도 성공적으로 데이터가 삽입된다. 
INSERT INTO MEMBER_NOTNULL VALUES('USER1', 'PWD1', '아무개', NULL);
INSERT INTO MEMBER_NOTNULL VALUES('USER1', 'PWD1', '아무개', NULL);
SELECT * FROM MEMBER_NOTNULL;

CREATE TABLE MEMBER_UNIQUE(
    MEMBER_NO NUMBER NOT NULL,
    MEMBER_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEMBER_PWD VARCHAR2(20) NOT NULL,
    MEMBER_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(50),
    MEMBER_DATE DATE DEFAULT SYSDATE     
);
SELECT * FROM MEMBER_UNIQUE;
INSERT INTO MEMBER_UNIQUE VALUES(1, 'USER1', 'PWD1', '아무개', '남', '010-4179-4342', 'ismoon@iei.or.kr', SYSDATE);
-- INSERT 성공
INSERT INTO MEMBER_UNIQUE VALUES(2, 'USER1', 'PWD1', '아무개', '남', '010-4179-4342', 'ismoon@iei.or.kr', SYSDATE);   
-- UNIQUE 제약조건에 위배되었으므로 INSERT 실패 : 오류보고/CONSTRAINT_NAME에서 에러 번호도 확인 (KH.SYS_C007041) 그러나 ->
-- 오류 구문으로 제약조건을 알려주지만 컬럼을 알려주지 않음 . 쉽게 파악하기 어렵다.

SELECT * FROM MEMBER_UNIQUE;

CREATE TABLE MEMBER_UNIQUE2(
    MEMBER_NO NUMBER NOT NULL,
    MEMBER_ID VARCHAR2(20) NOT NULL,
    MEMBER_PWD VARCHAR2(20) NOT NULL,
    MEMBER_NAME VARCHAR2(20) CONSTRAINT MEMBER_UNIQUE2_MEMBER_NAME_NN NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(50),
    MEMBER_DATE DATE DEFAULT SYSDATE,    
    
    CONSTRAINT MEMBER_UNIQUE2_MEMBER_ID_UQ UNIQUE (MEMBER_ID)
);

INSERT INTO MEMBER_UNIQUE2 VALUES(1, 'USER1', 'PWD1', '아무개', '남', '010-4179-4342', 'ismoon@iei.or.kr', SYSDATE);
-- INSERT 성공
INSERT INTO MEMBER_UNIQUE2 VALUES(2, 'USER1', 'PWD1', '아무개', '남', '010-4179-4342', 'ismoon@iei.or.kr', SYSDATE);   
--(KH.MEMBER_UNIQUE2_MEMBER_ID_UQ) 제약조건에 걸려서 INSERT 안됨


------------------------------------------------------------------------------
/*
    <CHECK 제약조건>
        컬럼에 기록되는 값에 조건 설정을 할 수 있다.
        CHECK (컬럼명 비교연산자 (비교값, 비교값))   -- 비교값은 리터럴만 사용 가능하다. 변하는 값이나 함수 사용하지 못한다.
                                                        D연산자 사용 가능 : SALARY 같은 경우 BETWEEN AND, >, < ANY 등등
*/
INSERT INTO MEMBER_UNIQUE2 VALUES(2, 'USER2', 'PWD1', '아무개', '여', '010-4179-4342', 'ismoon@iei.or.kr', SYSDATE);   
INSERT INTO MEMBER_UNIQUE2 VALUES(3, 'USER3', 'PWD1', '아무개', '강', '010-4179-4342', 'ismoon@iei.or.kr', SYSDATE);   
-- 성별 유효한 값이 아닌 값도 들어감 '강' 
SELECT * FROM MEMBER_UNIQUE2;


CREATE TABLE MEMBER_CHECK(
    MEMBER_NO NUMBER NOT NULL,
    MEMBER_ID VARCHAR2(20) NOT NULL,
    MEMBER_PWD VARCHAR2(20) NOT NULL,
    MEMBER_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(50),
    MEMBER_DATE DATE DEFAULT SYSDATE,    

    UNIQUE (MEMBER_ID)
);

INSERT INTO MEMBER_CHECK VALUES(2, 'USER2', 'PWD1', '아무개', '여', '010-4179-4342', 'ismoon@iei.or.kr', SYSDATE);
-- INSERT 성공
INSERT INTO MEMBER_CHECK VALUES(3, 'USER3', 'PWD1', '아무개', '강', '010-4179-4342', 'ismoon@iei.or.kr', SYSDATE);   
-- '강' 때문에 오류남 : GENDER 컬럼에 CHECK 제약조건으로 '남' 또는 '여'만 기록 가능하도록 설정되었기 때문

SELECT * FROM MEMBER_CHECK;

--------------------------------------------------------------------------------
/*
    <PRIMARY KEY 기본키 제약조건>
        테이블에서 한 행의 정보를 식별하기 위해 사용할 컬럼에 부여하는 제약조건 
            각 행들을 구분할 수 있는 식별자 역할
            PRIMARY KEY로 제약조건을 하게 되면 자동으로 해당 컬럼에 NOT NULL + UNIQUE 제약조건이 걸린다. 
            한 테이블에 한 개만 설정할 수 있다. 
        컬럼레벨, 테이블레벨 방식 둘 다 설정 가능하다. 
        
        (자연키, 대리키(PRIMARY KEY가) 그런 얘기 .....)
*/

CREATE TABLE MEMBER_PRIMARYKEY(
    MEMBER_NO NUMBER CONSTRAINT MEMBER_NO_PK PRIMARY KEY,
    MEMBER_ID VARCHAR2(20) NOT NULL,
    MEMBER_PWD VARCHAR2(20) NOT NULL,
    MEMBER_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(50),
    MEMBER_DATE DATE DEFAULT SYSDATE,    
    UNIQUE (MEMBER_ID)
);

INSERT INTO MEMBER_PRIMARYKEY VALUES(1, 'USER1', 'PWD1', '홍길동', '남', 'NULL', 'NULL', SYSDATE);
INSERT INTO MEMBER_PRIMARYKEY VALUES(2, 'USER2', 'PWD2', '이순신', '남', 'NULL', 'NULL', SYSDATE);  
INSERT INTO MEMBER_PRIMARYKEY VALUES(3, 'USER3', 'PWD3', '유관순', '여', 'NULL', 'NULL', SYSDATE);

INSERT INTO MEMBER_PRIMARYKEY VALUES(3, 'USER4', 'PWD4', '아무개', '여', 'NULL', 'NULL', SYSDATE);   -- 기본키 중복으로 오류
INSERT INTO MEMBER_PRIMARYKEY VALUES(NULL, 'USER5', 'PWD5', '이무기', '남', 'NULL', 'NULL', SYSDATE);   --- 기본키가 NULL이라 오류

SELECT * FROM MEMBER_PRIMARYKEY;

-- 복합 키 : 테이블 레벨에서 지정
CREATE TABLE MEMBER_PRIMARYKEY2(
    MEMBER_NO NUMBER,
    MEMBER_ID VARCHAR2(20),
    MEMBER_PWD VARCHAR2(20) NOT NULL,
    MEMBER_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(50),
    MEMBER_DATE DATE DEFAULT SYSDATE,    
    CONSTRAINT MEMBER_NO_NAME_PK PRIMARY KEY (MEMBER_NO, MEMBER_ID)    -- 컬럼 묶어서 하나의 기본키 설정 -> 복합키
);

INSERT INTO MEMBER_PRIMARYKEY2 VALUES(1, 'USER1', 'PWD1', '홍길동', '남', 'NULL', 'NULL', SYSDATE);
INSERT INTO MEMBER_PRIMARYKEY2 VALUES(1, 'USER2', 'PWD2', '이순신', '남', 'NULL', 'NULL', SYSDATE);  
INSERT INTO MEMBER_PRIMARYKEY2 VALUES(2, 'USER3', 'PWD3', '유관순', '여', 'NULL', 'NULL', SYSDATE);
-- NO, ID 중 하나만 같으면 OK
INSERT INTO MEMBER_PRIMARYKEY2 VALUES(1, 'USER1', 'PWD4', '아무개', '여', 'NULL', 'NULL', SYSDATE); 
-- 회원번호 회원 아이디가 세트로 동일 값이 이미 존재하기 땜에 에러 : 기본키 중복으로 오류
INSERT INTO MEMBER_PRIMARYKEY2 VALUES(NULL, 'USER5', 'PWD5', '이무기', '남', 'NULL', 'NULL', SYSDATE);   --- 기본키가 NULL이라 오류
-- 기본키로 설정된 컬럼은 NULL값이 있으면 에러 발생

SELECT * FROM MEMBER_PRIMARYKEY2;


/*
4.	
도서들에 대한 데이터를 담기위한 도서 테이블 (TB_BOOK)
컬럼 : BOOK_NO (도서번호) -- 기본키(제약조건명: BOOK_PK)
BOOK_TITLE (도서명) -- NOT NULL(제약조건명: BOOK_NN_TITLE)
BOOK_AUTHOR(저자명) -- NOT NULL(제약조건명: BOOK_NN_AUTHOR)
BOOK_PRICE(가격)
BOOK_STOCK(재고) -- 기본값 10로 지정
BOOK_PUB_NO(출판사번호) -- 외래키(제약조건명: BOOK_FK) (TB_PUBLISHER 테이블을 참조)
이때 참조하고 있는 부모데이터 삭제 시 자식 데이터의 데이터는 NULL값이 되도록 옵션 지정(40점)
*/
   
DROP TABLE TB_BOOK;

CREATE TABLE TB_BOOK(
    BOOK_NO NUMBER CONSTRAINT BOOK_PK PRIMARY KEY,
    BOOK_TITLE VARCHAR2(30) CONSTRAINT BOOK_NN_TITLE NOT NULL,
    BOOK_AUTHOR VARCHAR2(30) CONSTRAINT BOOK_NN_AUTHOR NOT NULL,
    BOOK_PRICE VARCHAR2(10),
    BOOK_STOCK NUMBER DEFAULT 10, 
    BOOK_PUB_NO NUMBER --CONSTRAINT BOOK_FK REFERENCES TB_PUBLISHER ON DELETE SET NULL
);




----------------------------------------------------------------------------
/*
    <FOREIGN KEY 외래키 제약조건>
        다른 테이블에 존재하는 값만을 가져야 하는 컬럼에 부여하는 제약조건 (단, NULL 값도 가질 수 있다.)
        - 다른 테이블을 참조한다고 표현한다. 
        - FOREIGN KEY 제약조건에 의해서 테이블간에 관계가 형성된다. 
        
        - FOREIGN KEY 제약조건 지정 방식
            컬럼레벨
                컬럼명 자료형(크기) [CONSTRAINT 제약조건명] REFERENCES 참조할 테이블명 [(기본키)] [삭제룰]
            테이블레벨
                [CONSTRAINT 제약조건명] FOREIGN KEY(적용할 컬럼명) REFERENCES 참조할 테이블명 [(기본키)] [삭제룰]
*/

-- 회원등급에 대한 데이터를 보관하는 테이블 (부모테이블)
CREATE TABLE MEM_GRADE(
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30) NOT NULL
);

INSERT INTO MEM_GRADE VALUES(10, '일반회원');
INSERT INTO MEM_GRADE VALUES(20, '우수회원');
INSERT INTO MEM_GRADE VALUES(30, '특별회원');
INSERT INTO MEM_GRADE VALUES(50, '특특특별회원');

SELECT * FROM MEM_GRADE;

-- 자식테이블
CREATE TABLE MEMBER_FOREIGNKEY(
    MEMBER_NO NUMBER PRIMARY KEY,
    MEMBER_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEMBER_PWD VARCHAR2(20) NOT NULL,
    MEMBER_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER REFERENCES MEM_GRADE (GRADE_CODE),
    MEMBER_DATE DATE DEFAULT SYSDATE    
);

SELECT * FROM MEMBER_FOREIGNKEY;

INSERT INTO MEMBER_FOREIGNKEY VALUES(1, 'USER1', 'PWD1', '홍길동', '남', 'NULL', 'NULL', 10, SYSDATE);
INSERT INTO MEMBER_FOREIGNKEY VALUES(2, 'USER2', 'PWD2', '이순신', '남', 'NULL', 'NULL', 20, SYSDATE);  
INSERT INTO MEMBER_FOREIGNKEY VALUES(3, 'USER3', 'PWD3', '유관순', '여', 'NULL', 'NULL', 30, SYSDATE);
INSERT INTO MEMBER_FOREIGNKEY VALUES(4, 'USER4', 'PWD3', '유관순', '여', 'NULL', 'NULL', 40, SYSDATE);
-- MEM_GRADE 테이블 GRADE_CODE에는 40이라는 값이 없어서 INSERT 에러, 30으로 하면 들어감.

INSERT INTO MEMBER_FOREIGNKEY VALUES(5, 'USER5', 'PWD3', '유관순', '여', 'NULL', 'NULL', NULL, SYSDATE);
-- NULL 은 가능

-- ANSI JOIN
SELECT M.MEMBER_ID, M.MEMBER_NAME, M.PHONE, G.GRADE_NAME
FROM MEMBER_FOREIGNKEY M
LEFT OUTER JOIN MEM_GRADE G ON(M.GRADE_ID = G.GRADE_CODE);

-- 오라클 JOIN



-- MEM_GRADE 테이블에서 GRADE_CODE가 10인 데이터 지우기 
-- 자식테이블의 행들 중에 10을 사용하고 있기 때문에 삭제할 수 없다. 
-- 기본적으로 FOREIGN KEY 삭제 옵션이 ON DELETE RESTRICTED로 설정되어 있다. 
DELETE FROM MEM_GRADE WHERE GRADE_CODE = 10;

-- 자시테이블의 행들 중에 50에 해당 하는 것이 없어 삭제 가능
DELETE FROM MEM_GRADE WHERE GRADE_CODE = 50;

-- 해결방법
-- 자식테이블 생성할 때 부모테이블의 데이터가 삭제됏을 때 어떻게 처리할지 옵션으로 지정해 놓을 수 있다.
-- ON DELETE SET NULL   : 부모테이블의 데이터 삭제시 참조하고 있는 테이블의 컬럼값이 NULL로 변경된다.
-- ON DELETE CASCADE    : 부모테이블의 데이터 삭제시 참조하고 있는 테이블의 컬럼 값이 존재하던 행 전체가 삭제된다. 

DROP TABLE MEMBER_FOREIGNKEY;

CREATE TABLE MEMBER_FOREIGNKEY(
    MEMBER_NO NUMBER PRIMARY KEY,
    MEMBER_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEMBER_PWD VARCHAR2(20) NOT NULL,
    MEMBER_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER REFERENCES MEM_GRADE (GRADE_CODE) ON DELETE SET NULL,
    MEMBER_DATE DATE DEFAULT SYSDATE    
);

INSERT INTO MEMBER_FOREIGNKEY VALUES(1, 'USER1', 'PWD1', '홍길동', '남', 'NULL', 'NULL', 10, SYSDATE);
INSERT INTO MEMBER_FOREIGNKEY VALUES(2, 'USER2', 'PWD2', '이순신', '남', 'NULL', 'NULL', 20, SYSDATE);  
INSERT INTO MEMBER_FOREIGNKEY VALUES(3, 'USER3', 'PWD3', '유관순', '여', 'NULL', 'NULL', 30, SYSDATE);

SELECT * FROM MEM_GRADE;        -- DELETE FROM MEM_GRADE WHERE GRADE_CODE = 10; 실행 이후 발생 하는 것을 여기서도 확인 가능 

SELECT * FROM MEMBER_FOREIGNKEY;

-- 문제없이 삭제되는 것 확인 가ㅡㅇ
-- 단 자식테이블을 조회해보면 삭제된 행을 참조하고 있던 컬럼이 NULL 로 변경 되어있다. 
DELETE FROM MEM_GRADE WHERE GRADE_CODE = 10;

ROLLBACK;

DROP TABLE MEMBER_FOREIGNKEY;

CREATE TABLE MEMBER_FOREIGNKEY(
    MEMBER_NO NUMBER PRIMARY KEY,
    MEMBER_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEMBER_PWD VARCHAR2(20) NOT NULL,
    MEMBER_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER REFERENCES MEM_GRADE (GRADE_CODE) ON DELETE CASCADE,
    MEMBER_DATE DATE DEFAULT SYSDATE    
);


INSERT INTO MEMBER_FOREIGNKEY VALUES(1, 'USER1', 'PWD1', '홍길동', '남', 'NULL', 'NULL', 10, SYSDATE);
INSERT INTO MEMBER_FOREIGNKEY VALUES(2, 'USER2', 'PWD2', '이순신', '남', 'NULL', 'NULL', 20, SYSDATE);  
INSERT INTO MEMBER_FOREIGNKEY VALUES(3, 'USER3', 'PWD3', '유관순', '여', 'NULL', 'NULL', 30, SYSDATE);


SELECT * FROM MEM_GRADE;        -- DELETE FROM MEM_GRADE WHERE GRADE_CODE = 10; 실행 이후 발생 하는 것을 여기서도 확인 가능 

SELECT * FROM MEMBER_FOREIGNKEY;

-- 문제없이 삭제되는 것 확인 가능
-- 단, 자식테이블을 조회해보면 삭제된 행을 참조하고 있던 컬럼의 행들이 모두 삭제된걸 확인 할 수 있다.
DELETE FROM MEM_GRADE WHERE GRADE_CODE = 10;

ROLLBACK;               -- MEM_CODE는 원상복귀ㅡ   MEMBER_FOREIGNKEY는 삭제된  상태 유지 

----------------------------------------------------------------------------------
/*
    <SUBQUERY를 이용한 테이블 생성>
        SUBQUERY를 사용해서 테이블 생성한다. 
        컬럼명 데이터타입, 값이 복사된다. 제약조건은 NOT NULL만 복사된다.
        
        [표현식]
            CREATE TABLE 테이블명
            AS 서브쿼리;
*/

-- EMPLOYEE 테이블을 복사한 새로운 테이블 생성
-- EMPLOYEE 테이블의 컬럼, 데이터값, NOT NULL 제약조건이 복사
CREATE TABLE EMPLOYEE_COPY
AS SELECT *
    FROM EMPLOYEE;

-- EMPLOYEE 테이블과 구조만 복사한 새로운 테이블 생성 
-- 1=0 이 FALSE 이기 때문에 구조만 복사되고 모든 행에 대해서 매번 FALSE 이기 때문에 데이터 값이 복사되지 않느다. 
CREATE TABLE EMPLOYEE_COPY2
AS SELECT *
    FROM EMPLOYEE
    WHERE 1=0;       

SELECT * FROM EMPLOYEE_COPY2;

-- EMPLOYEE 테이블의 사번, 이름, 급여 연봉 저장 
CREATE TABLE EMPLOYEE_COPY3
AS SELECT EMP_ID, EMP_NAME, SALARY, SALARY * 12 AS 연봉       -- SELECT 절에 산술연산 또는 함수식이 기술되는 경우 별칭 부여해야 한다.
    FROM EMPLOYEE;





