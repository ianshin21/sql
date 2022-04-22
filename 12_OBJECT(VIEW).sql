/*
    <VIEW>
    SELECT 문을 저장할 수 있는 객체 (논리적인 가상테이블)
    데이터는 없고 테이블에 대한 SQL만 저장되어 있어 VIEW에 접근할 때 SQL을 수행하면서 결과 값을 가져온다.
    매번 자주 사용하는 쿼리문을 정의해두면 마치 테이블처럼 사용할 수 있다. 
    
    [표현식]
        CREATE [OR REPLACE] VIEW 뷰명
        AS 서브쿼리; 
        
        [OR REPLACE] : 뷰 생성시 기존에 중복된 뷰가 있다면 해당 뷰를 변경하고,
                        기존에 중복된 뷰가 없다면 새로 뷰를 생성하는 키워드
*/
-- 처음 생성시 관리자 계정으로 sys/SYSTEM 에서 CREATE VIEW 을 주어야 한다.
--GRANT CREATE VIEW TO KH;   이렇게 실행시키면 됨  -- 비밀번호 oracle

CREATE OR REPLACE VIEW VM_EMPLOYEE 
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME, JOB_CODE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
    JOIN NATIONAL USING(NATIONAL_CODE);

SELECT * FROM VM_EMPLOYEE;

-- 한국에 근무하는 사원들의 사번, 이름, 부서명, 급여 조회
SELECT * 
FROM VM_EMPLOYEE
WHERE NATIONAL_NAME = '한국';

-- 해당 계정이 가지고 있는 VIEW들에 대한 내용 조회시 사용하는 데이터 딕셔너리이다. 
SELECT * FROM USER_VIEWS;       -- 사용자가 만든 VIEW들 조회 

-- 데이터 딕셔너리 sys 계정에서 확인 
-- SELECT * FROM USER_CONS_COLUMN;
-- SELECT * FROM USER_VIEWS;


-- 러시아에서 근무하는 사원들 조회
SELECT * 
FROM VM_EMPLOYEE
WHERE NATIONAL_NAME = '러시아';

-- 기존 테이블에 변화가 생기면 VIEW에도 변화가 생김
SELECT * FROM EMPLOYEE;
SELECT * FROM VM_EMPLOYEE;

UPDATE EMPLOYEE
SET EMP_NAME = '정중앙'
WHERE EMP_ID = '205';

------------------------------------------------------------------------------

-- 생성된 뷰 컬럼에 별칭 부여
-- 서브쿼리의 SELECT 절에 함수나 산술연산이 기술되어 있는 경우 반드시 별칭 지정

-- 사원의 사번, 사원명, 직급명, 성별, 근무년 조회할 수 있는 뷰를 생성
CREATE OR REPLACE VIEW VM_EMP_JOB
AS SELECT EMP_ID, 
        EMP_NAME, 
        DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') 성별,
        EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM HIRE_DATE) 근무연수
FROM EMPLOYEE;

CREATE OR REPLACE VIEW VM_EMP_JOB(사번, 사원명, 성별, 근무년수) -- 이렇게 별칭 부여하려면 모든 컬럼에 별칭 부여해야 한다. 
AS SELECT EMP_ID, 
        EMP_NAME, 
        DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여'),
        EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM HIRE_DATE)
FROM EMPLOYEE;

SELECT * FROM VM_EMP_JOB;

-- 뷰를 삭제할 때 
DROP VIEW VM_EMP_JOB;

------------------------------------------------------------

-- 생성된 뷰를 이용해서 DML(INSERT, UPDATE, DELETE) 사용하기 
-- 뷰를 통해서 변경하게 되면 실제 데이터가 담겨있는 기본 테이블에도 적용이 된다. 

CREATE OR REPLACE VIEW VM_JOB
AS SELECT * FROM JOB;

-- VIEW에 INSERT
INSERT INTO VM_JOB VALUES('J8', '인턴');

-- VIEW에 UPDATE
UPDATE VM_JOB
SET JOB_NAME = '알바'
WHERE JOB_CODE = 'J8';

-- VIEW에 DELETE
DELETE FROM VM_JOB
WHERE JOB_CODE = 'J8';

SELECT * FROM VM_JOB;
SELECT * FROM JOB;

------------------------------------------------------------------------
/*
    <DML명령어로 VIEW 조작이 불가능한 경우>
        1. 뷰 정의에 포함되지 않은 컬럼을 조작하는 경우
        2. 뷰에 포함되지 않은 컬럼 중에 기본테이블 상에 NOT NULL 제약조건이 지정된 경우
        3. 산술 표현식으로 정의된 경우
        4. 그룹함수나 GROUP BY절을 포함한 경우
        5. DISTINCT를 포함한 경우
        6. JOIN을 이용해 여러 테이블을 연결한 경우
*/

-- 1. 뷰 정의에 포함되지 않은 컬럼을 조작하는 경우 :  INSERT/UPDATE/DELETE하는 경우 에러 발생
CREATE OR REPLACE VIEW VM_JOB2
AS SELECT JOB_CODE
    FROM JOB;

-- 뷰에 정의 되어있지 않은 컬럼 JOB_NAME을 조작하여 DML 작성
-- INSERT  
INSERT INTO VM_JOB2 VALUES('J8', '인턴');

-- UPSATE
UPDATE VM_JOB2 
SET JOB_NAME = '인턴'
WHERE JOB_CODE = 'J7'; 

--DELETE 
DELETE FROM VM_JOB2
WHERE JOB_NAME = '사원';

SELECT * FROM VM_JOB2;


--  2. 뷰에 포함되지 않은 컬럼 중에 기본테이블 상에 NOT NULL 제약조건이 지정된 경우
-- * 뷰에 포함되지 않은 NOT NULL제약조건이 있는 컬럼이 존재하면 INSERT시 에러 발생 * UPDATE/DELETE는 가능
-- JOB_NAME 뷰에서 JOB_NAME을 INSERT, UPDATE, DELETE 하느 경우

CREATE OR REPLACE VIEW VM_JOB3
AS SELECT JOB_NAME
    FROM JOB;

SELECT * FROM VM_JOB3;

-- INSERT
INSERT INTO VM_JOB3 VALUES('인턴');
-- 잡네임은 새로 생성된다 하더라도 JOB_CODE에는 NULL이 들어가야 하는데 
-- 기본 테이블인 JOB에 JOB_CODE에는 NOT NULL 제약조건이 지정되어있어 에러가 나는 것이다. 

-- UPDATE (기존의 '사원'을 '인턴'으로 변경) : 에러 안남 
UPDATE VM_JOB3
SET JOB_NAME = '인턴'
WHERE JOB_NAME = '사원';

--DELETE 
DELETE FROM VM_JOB3
WHERE JOB_NAME = '인턴';

SELECT * FROM VM_JOB3;
SELECT * FROM JOB;

ROLLBACK;


-- 3. 산술 표현식으로 정의된 경우 :  뷰에 산술 계산식이 포함된 경우 INSERT/UPDATE 시 에러 발생 * 단 DELETE는 가능
CREATE OR REPLACE VIEW VM_EMP_SAL
AS SELECT EMP_ID, EMP_NAME, SALARY, SALARY * 12 AS "연봉"
    FROM EMPLOYEE;

SELECT * FROM VM_EMP_SAL;

--INSERT
INSERT INTO VM_EMP_SAL VALUES (800, '문인수', 3000000, 3600000);  --virtual column not allowed here

-- UPDATE 
UPDATE VM_EMP_SAL
SET 연봉 = 80000000
WHERE EMP_ID = 200;             --virtual column not allowed here

-- 산술연산과 무관한 EMP_ID, EMP_NAME, SALARY들은 변경 가능
-- 205번 사원의 사원명을 '정중하'로 변경
UPDATE VM_EMP_SAL
SET EMP_NAME = '정중하'
WHERE EMP_ID = 205;

COMMIT;

-- DELETE
DELETE FROM VM_EMP_SAL
WHERE 연봉 = 96000000;            -- DELETE 되었음?

SELECT * FROM VM_EMP_SAL;
SELECT * FROM EMPLOYEE;

ROLLBACK;


-- 4. 그룹함수나 GROUP BY절을 포함한 경우 :  INSERT/UPDATE/DELETE 시 에러 발생
CREATE OR REPLACE VIEW VM_GROUPDEPT
AS SELECT DEPT_CODE, SUM(SALARY) 합계, FLOOR(AVG(SALARY)) 평균
    FROM EMPLOYEE
    GROUP BY DEPT_CODE;
    
--INSERT
INSERT INTO VM_GROUPDEPT VALUES('D0', 8000000, 4000000);  -- 에러

--UPDATE    : data manipulation operation not legal on this view
UPDATE VM_GROUPDEPT
SET DEPT_CODE = 'D0'
WHERE DEPT_CODE = 'D1';

--DELETE (부서코드 D1 지우기) :  not legal on this view
DELETE FROM VM_GROUPDEPT
WHERE DEPT_CODE = 'D1';


-- 5. DISTINCT를 포함한 경우 : INSERT/UPDATE/DELETE 시 에러 발생
CREATE OR REPLACE VIEW VM_DT_JOB
AS SELECT DISTINCT JOB_CODE
    FROM EMPLOYEE;
    
-- INSERT 
INSERT INTO VM_DT_JOB VALUES('J8');

-- UPDATE
UPDATE VM_DT_JOB
SET JOB_CODE = 'J8'
WHERE JOB_CODE = 'J7';

--DELETE 
DELETE FROM VM_DT_JOB
WHERE JOB_CODE = 'J2';

SELECT * FROM VM_DT_JOB;


--6. JOIN을 이용해 여러 테이블을 연결한 경우 :  INSERT/UPDATE 시 에러 발생 * 단 DELETE는 가능
CREATE OR REPLACE VIEW VM_JOINEMP
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
    
SELECT * FROM VM_JOINEMP;

-- INSERT
INSERT INTO VM_JOINEMP VALUES(800, '조세오', '총무부');

-- UPDATE 
UPDATE VM_JOINEMP
SET EMP_NAME = '서동일'
WHERE EMP_ID = 200;
-- 기본 테이블은 UPDATE 되고 

UPDATE VM_JOINEMP
SET DEPT_TITLE = '총무1팀'
WHERE EMP_ID = 200;
-- 조인된 테이블은 UPDATE 안되고 : 총무팀은 혼자만이 아니다. 또한 DEPARTMENT 테이블 전체가 먼저 바뀌지 않은한 문제가 생긴다. 

-- DELETE
DELETE FROM VM_JOINEMP
WHERE EMP_ID = 200;

DELETE FROM VM_JOINEMP
WHERE DEPT_TITLE = '총무부';       -- 서브쿼리에 FROM절의 구문의 테이블에만 영향을 끼친다. 

SELECT * FROM EMPLOYEE;
SELECT * FROM VM_JOINEMP;
SELECT * FROM DEPARTMENT;

ROLLBACK;


-------------------------------------------------------------------------------
/*
    <VIEW 옵션>
    
        [상세표현식]
        CREATE [OR REPLACE] [FORCE|NOFORCE] VIEW 뷰명
        AS 서브쿼리
        [WITH CHECK OPTION]
        [WITH READ ONLY]; 
        
        1. OR REPLACE 옵션 : 기존에 동일한 뷰가 있을 경우 덮어쓰고, 존재하지 않으면 뷰를 새로 생성한다.
        2. FORCE/NOFORCE 옵션
                FORCE : 서브쿼리에 기술된(기본) 테이블이 존재하지 않는 테이블이여도 뷰가 생성된다.
                        -> 포스는 업무중에 접근 권한이 아직 주어지지 않은 테이블에 대해 뷰를 미리 만들고 싶을 때 쓴다.
                NOFORCE : 서브쿼리에 기술된(기본) 테이블이 존재해야만 뷰가 생성된다. (기본 값)
        3. WITH CHECK OPTION : 서브쿼리에 기술된 조건에 부합하지 않는 값으로 수정하는 경우 오류.
        4. WITH READ ONLY : 뷰에 대해 조회만 가능하고 삽입, 수정, 삭제 등은 불가능하게 함 DML 수행 불가
*/
-- 2. FORCE/NOFORCE 
-- NOFORCE 
CREATE OR REPLACE VIEW VM_EMP
AS SELECT TCODE, TNAME, TCONTENT
    FROM TT;
    
-- FORCE : 뷰가 만들어져도 실행은 안됨. 미리 뷰를 생성해두고자 할 때
CREATE OR REPLACE FORCE VIEW VM_EMP
AS SELECT TCODE, TNAME, TCONTENT
    FROM TT;
    
-- 일단 여기서는 생성만 되고 아래 SELECT는 애러 나다가 다시 밑에 테이블 생성 이후 SELECT 실행됨
SELECT * FROM VM_EMP;

CREATE TABLE TT(
    TCODE NUMBER,
    TNAME VARCHAR2(10),
    TCONTENT VARCHAR2(20)
);

SELECT * FROM VM_EMP;     


-- 3. WITH CHECK OPTION : 서브쿼리에 기술된 조건에 부합하지 않는 값으로 수정하는 경우 오류.

CREATE OR REPLACE VIEW VM_EMP2
AS SELECT *
    FROM EMPLOYEE
    WHERE SALARY >= 3000000;

SELECT * FROM VM_EMP2;

-- 200번 사원의 급여를 200만으로
UPDATE VM_EMP2
SET SALARY = 2000000
WHERE EMP_ID = 200;

SELECT * FROM EMPLOYEE;

ROLLBACK;


CREATE OR REPLACE VIEW VM_EMP2
AS SELECT *
    FROM EMPLOYEE
    WHERE SALARY >= 3000000
WITH CHECK OPTION;

SELECT * FROM VM_EMP2;

-- 다시 200번 사원의 급여를 200만으로 :에러남 ; 서브쿼리에 기술한 조건에 부합하지 않는 값으로 수정하는 경우
UPDATE VM_EMP2
SET SALARY = 2000000
WHERE EMP_ID = 200;


-- 다시 200번 사원의 급여를 400만으로 : 실행됨 ; 서브쿼리에 기술한 조건에 부합하는 값으로 수정하는 경우
UPDATE VM_EMP2
SET SALARY = 4000000
WHERE EMP_ID = 200;

ROLLBACK;


-- 4. WITH READ ONLY : 뷰에 대해 조회만 가능하고 삽입, 수정, 삭제 등은 불가능하게 함 DML 수행 불가
CREATE OR REPLACE VIEW VM_DEPT
AS SELECT *
    FROM DEPARTMENT
WITH READ ONLY;

SELECT * FROM VM_DEPT;

INSERT INTO VM_DEPT VALUES('D0', '해외영업4부', 'L6');   
    -- cannot perform a DML operation on a read-only view
    
UPDATE VM_DEPT
SET LOCATION_ID = 'L2'
WHERE DEPT_TITLE = '인사관리부';
    -- cannot perform a DML operation on a read-only view

DELETE FROM VM_DEPT
WHERE DEPT_TITLE = '인사관리부';
    -- cannot perform a DML operation on a read-only view









