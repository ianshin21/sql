/*
    <DML(DATA MANIPULATION LANGUAGE)>
        데이터 조작 언어로 테이블에 값을 삽입INSERT 하거나, 수정UPDATE 하거나, 삭제DELETE 하는 구문이다.
        
    <INSERT>
        테이블에 새로운 행을 추가하는 구문
        
        [표현식]
            1) INSERT INTO 테이블명 VALUES(값, 값, 값, ...);
                테이블에 있는 모든 컬럼에 대한 값을 INSERT 하고자 할 때 사용한다. 
                컬럼 순번을 지켜서 VALUES에 값을 나열해야 한다.
            2) INSERT INTO 테이블명 (컬럼명, 컬럼명, ....) VALUES(값, 값, 값, ...);
                테이블에 내가 선택한 컬럼에 대한 값만 INSERT 하고자 할 때 사용한다. 
                선택 안 된 컬럼들은 기본적으로 NULL 값이 들어감. (NOT NULL 조건이 걸려있는 컬럼은 반드시 선택해서 직접 값을 제시해줘야 한다.)
                단, 기본값(DEFAULT)이 지정되어 있으면 NULL이 아닌 기본값이 들어간다. 
            3) INSERT INTO 테이블명 (서브쿼리);
                VALUES를 대신해서 서브쿼리로 조회한 결과 값을 통채로 INSERT 한다. 즉, 여러 행을 INSERT 시킬 수 있다.
                서브쿼리의 결과값이 INSERT 문에 지정된 컬럼의 개수와 데이터 타입이 같아야 한다. 
*/

-- 표현식 1번 사용
INSERT INTO EMPLOYEE
VALUES(900, '장채현', '901123-1080503', 'jang_ch@kh.or.kr', '01055569512', 'D1', 'J8',
        4300000, 0.2, '200', SYSDATE, NULL, DEFAULT);

SELECT * FROM EMPLOYEE;

-- 표현식 2번 사용 
INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, DEPT_CODE, JOB_CODE, HIRE_DATE)
VALUES(901, '문인수', '010909-1199887', 'D1', 'J7', SYSDATE);
 
-- 표현식 3번 사용 
-- 새로운 테이블 세팅
CREATE TABLE EMP_01 (
    EMP_ID NUMBER,
    EMP_NAME VARCHAR(30),
    DEPT_TITLE VARCHAR(20)
);

INSERT INTO EMP_01 (
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE
    FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
);

SELECT * FROM EMP_01;

----------------------------------------------------------------------------------------
/*
    <INSERT ALL>
        두개 이상의 테이블에 각각 INSERT 하는데 동일한 서브쿼리가 사용되는 경우 
        INSERT ALL을 이용해서 여러 테이블에 한번에 데이터 삽입이 가능
        
        [표현식]
            INSERT ALL
            INTO 테이블명1 VALUES(컬럼명, 컬럼명, ....)
            INTO 테이블명2 VALUES(컬럼명, 컬럼명, ...)
                서브쿼리;
                
            INSERT ALL
            WHEN 조건1 THEN
                INTO 테이블명1 VALUES(컬럼명, 컬럼명, ....)
            WHEN 조건2 THEN
                INTO 테이블명2 VALUES(컬럼명, 컬럼명, ....)
            서브쿼리;
*/

-- 예시 1을 테스트할 테이블 만들기 (테이블 구조만 복사)
CREATE TABLE EMP_DEPT
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
    FROM EMPLOYEE
    WHERE 1=0;

CREATE TABLE EMP_MANAGER
AS SELECT EMP_ID, EMP_NAME, MANAGER_ID
    FROM EMPLOYEE
    WHERE 1=0;

SELECT * FROM EMP_DEPT;

SELECT * FROM EMP_MANAGER;

SELECT* FROM EMPLOYEE WHERE DEPT_CODE = 'D1';

-- EMP_DEPT 테이블에 EMPLOYEE테이블의 부서코드가 D1인 직원의 사번, 이름, 소속부서, 입사일을 삽입하고
-- EMP_MANAGER테이블에 EMPLOYEE테이블의 부서코드가 D1인 직원의 사번, 이름, 관리자 사번을 조회하여 삽입

INSERT ALL 
INTO EMP_DEPT VALUES(EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
INTO EMP_MANAGER VALUES(EMP_ID, EMP_NAME, MANAGER_ID)
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
    FROM EMPLOYEE
    WHERE DEPT_CODE ='D1';

SELECT * FROM EMP_DEPT;

SELECT * FROM EMP_MANAGER;

-- 예시 2를 테스트할 테이블 만들기 (테이블 구조만 복사)
CREATE TABLE EMP_OLD
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMPLOYEE
    WHERE 1=0;
    
CREATE TABLE EMP_NEW
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMPLOYEE
    WHERE 1=0;

SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;

-- EMPLOYEE테이블의 입사일 기준으로 2000년 1월 1일 이전에 입사한 사원의 사번, 이름,입사일, 급여를 조회해서 EMP_OLD테이블에 삽입하고 
-- 그 후에 입사한 사원의 정보는 EMP_NEW 테이블에 삽입

INSERT ALL
WHEN HIRE_DATE < '2000/01/01' THEN
INTO EMP_OLD VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
WHEN HIRE_DATE >= '2000/01/01' THEN
INTO EMP_NEW VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
     SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMPLOYEE;

SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;

-----------------------------------------------------------------------------
/*
    <UPDATE>
    테이블에 기록된 데이터를 수정하는 구문
    
    [표현식]
        UPDATE 테이블명
        SET 컬럼명 = 바꿀값,
            컬럼명 = 바꿀값,   ...-> 여러개의 컬럼값 동시에 변경 가능( , 로 나열)
        [WHERE 조건] --> 생략해도 되지만 없으면 전체 모든 행의 데이터가 변경됨. 주의.        
*/

-- 테스트 진행할 테이블 생성

CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;


CREATE TABLE EMP_SALARY
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, BONUS
    FROM EMPLOYEE;

SELECT * FROM DEPT_COPY;
SELECT * FROM EMP_SALARY;

-- DEPT_ID가 'D9'인 부서명을 '전략기획팀'으로
UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획팀'
WHERE DEPT_ID = 'D9';


-- 모든 사원의 급여를 기존 급여의 10% 인상한 금액(기존급여*1.1)으로 변경
-- WHERE 절 없이 사용하는 경우도 있음
UPDATE EMP_SALARY
SET SALARY = SALARY*1.1;


-- UPDATE시에 서브커리를 사용가능하다. 즉, 서브쿼리를 수행한 결과 값으로 변경하겠다.
--방명수 사원의 급여를 유재식 사원과 같게 하는 거

-- 단일행 서브쿼리를 각각의 컬럼에 적용
UPDATE EMP_SALARY
SET SALARY = (SELECT SALARY
                FROM EMP_SALARY
                WHERE EMP_NAME = '유재식'), 
    BONUS = (SELECT BONUS
                FROM EMP_SALARY
                WHERE EMP_NAME = '유재식')
WHERE EMP_NAME = '방명수';

-- 다중열 서브쿼리를 사용해서 SALARY, BONUS 컬럼을 변경
UPDATE EMP_SALARY
SET (SALARY, BONUS) = (SELECT SALARY, BONUS
                FROM EMP_SALARY
                WHERE EMP_NAME = '유재식') 
WHERE EMP_NAME = '방명수';


-- 노옹철’, ‘전형돈’, ‘정중하’, ‘하동운 사원들의 급여와 보너스를 유재식 사원과 동일하게 변경
UPDATE EMP_SALARY
SET (SALARY, BONUS) = (SELECT SALARY, BONUS
                FROM EMP_SALARY
                WHERE EMP_NAME = '유재식') 
WHERE EMP_NAME IN ('노옹철', '전형돈', '정중하', '하동운');

-- EMP_SALARY테이블에서 아시아 지역에 근무하는 직원의 보너스 포인트를 0.3으로 변경

-- ASIA 지역에서 근무하는 직원들에 대한 정보 조회
SELECT *
FROM EMP_SALARY E
JOIN DEPT_COPY D ON E.DEPT_CODE = D.DEPT_ID
JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
WHERE LOCAL_NAME LIKE 'ASIA%';

UPDATE EMP_SALARY
SET BONUS = 0.3
WHERE EMP_ID IN (SELECT EMP_ID
                FROM EMP_SALARY E
                JOIN DEPT_COPY D ON E.DEPT_CODE = D.DEPT_ID
                JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
                WHERE LOCAL_NAME LIKE 'ASIA%');

SELECT * FROM DEPT_COPY;
SELECT * FROM EMP_SALARY;

-- UPDATE 시 변경할 값은 해당 컬럼에 대한 제약조건에 위배되면 안된다. 
-- 사번이 200번인 사원의 사원번호를 NULL로 변경, 다음은 에러남 : NOT NULL 제약조건에 위배
UPDATE EMP_COPY
SET EMP_ID=NULL
WHERE EMP_ID=200;

---------------------------------------------------------------------
/*
    <DELETE>
        테이블에 기록된 데이터를 삭제하는 구문(행단위로 삭제한다.)
        
        [표현식]
            DELETE FROM 테이블명
            [WHERE 조건];    -- WHERE 절 제시 안하면 전체 행 다 삭제된다.
*/

COMMIT;

-- 장채현 사원의 데이터를 지우기
DELETE FROM EMPLOYEE
WHERE EMP_NAME = '장채현';

SELECT *FROM EMPLOYEE;

ROLLBACK;   -- 마지막 커밋 시점으로 돌아간다. 

DELETE FROM EMPLOYEE
WHERE EMP_NAME = '문인수';

COMMIT;

--DEPT_ID가 D3인 부서를 삭제
DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D3';

SELECT * FROM DEPARTMENT;

ROLLBACK;

/*
    <TRUNCATE>
    테이블의 전체 행을 삭제할 때 사용하는 구문 
    DELETE보다 수행 속도가 더 빠르다.
    별도의 조건 제시 불가능하다.
    DELETE와는 달리 ROLLBACK 불가능
    
    [표현식] 
        TRUNCATE TABLE 테이블명
*/

SELECT * FROM EMP_SALARY;

DELETE FROM EMP_SALARY;

ROLLBACK;           -- 롤백 됨

TRUNCATE TABLE EMP_SALARY;

ROLLBACK;           

SELECT * FROM EMP_SALARY;   -- ROLLBACK 불가


-------------------------------------------------------------------------