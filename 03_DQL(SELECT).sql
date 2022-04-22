
-- 세로줄 제거 (환경 설정 -> 코드 편집기 -> 표시
/*
    <SELECT> 
        - 데이터를 조회할 때 사용하는 구문
        - SELECT를 통해서 조회된 결과물을 RESULT SET 이라고 한다. 즉 조회된 행들의 집합
        [표현법]
            SELECT 컬럼, 컬럼, ... 컬럼
                FROM 테이블명;
                
            조회하고자 하는 컬럼들은 반드시 FROM절에 기술한 테이블에 존재하는 컬럼!!
*/

-- EMPLOYEE 테이블에 전체 사원의 모든 컬럼(*) 정보 조회
SELECT * FROM EMPLOYEE;

-- EMPLOYEE 전체 사원들의 사번, 이름, 급여만 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE;

--------------- 실습 문제 --------------------
-- 쿼리는 대소문자 구분 없음, 그러나 가급적 대문자 사용
--- 1. JOB 테이블의 모든 컬럼 정보 조회
SELECT * FROM JOB;

--- 2. JOB 테이블의 직급명 컬럼만 조회
SELECT JOB_NAME FROM JOB;

--- 3. DEPARTMENT 테이블의 모든 컬럼 정보 조회
SELECT * FROM DEPARTMENT;

--- 4.EMPLOYEE 테이블의 사원명, 이메일, 전화번호, 입사일(HIRE_DATE) 정보만 조회
SELECT EMP_NAME, EMAIL, PHONE, (HIRE_DATE) FROM EMPLOYEE;

--- 5.EMPLOYEE 테이블의 입사일, 사원명, 급여 조회 
SELECT HIRE_DATE, EMP_NAME, SALARY
FROM EMPLOYEE;

--------------- 실습 문제 --------------------
/*
    <컬럼값을 통한 산술연산>
        SELECT 절 컬럼명 입력 부분에 산술연산을 이용, 결과 조회 가능
*/

-- EMPLOYEE 테이블에서 직원명, 직원의 연봉(연봉 = 급여 * 12)
SELECT EMP_NAME, SALARY * 12
FROM EMPLOYEE;

-- 산술 연산 중 NULL값이 있으면 그 연산의 결과는 NULL
SELECT EMP_NAME, SALARY * 12, (SALARY + BONUS * SALARY) * 12
FROM EMPLOYEE;

SELECT EMP_NAME, SALARY * 12, (SALARY + NVL(BONUS, 0) * SALARY) * 12
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 직원, 입사일, 근무일수(오늘 날짜 - 입사일)
-- DATE 형식끼리도 연산이 가능하기 때문 
-- SYSDATE는 오늘날짜를 출력한다.
SELECT EMP_NAME, HIRE_DATE, SYSDATE - HIRE_DATE
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, FLOOR(SYSDATE - HIRE_DATE) AS 근무일수, '일'
FROM EMPLOYEE;

--------------------------------------------------

/*
    <컬럼명에 별칭 지정하기>
        [표현법] 
            컬럼명 AS 별칭 / 컬럼명 AS "별칭" / 컬럼명 별칭 / 컬럼명 "별칭"
            
        별칭을 부여할 때 띄어쓰기, 혹은 특수문자가 포함될 경우, 반드시 (" ")로 감싸주어야 한다. 
*/
SELECT EMP_NAME AS 이름, SALARY * 12 연봉, (SALARY + BONUS * SALARY) * 12 AS "총소득(원)"
FROM EMPLOYEE;

SELECT EMP_NAME AS 이름, SALARY * 12 연봉, (SALARY + NVL(BONUS, 0) * SALARY) * 12 AS "총소득(원)"
FROM EMPLOYEE;

----------------------------------------------------
/*
    <리터럴> 
        임의로 지정된 문자, 문자열을 (' ')에 넣어 SELECT절에 사용하면 테이블에 존재하는 테이터처럼 조회가 가능하다.
        리터럴은 RESULT SET의 모든 행에 반복적으로 출력된다. 
*/ 
SELECT EMP_NAME, SALARY, '원' AS "단위(원)"
FROM EMPLOYEE;

-----------------------------------------------------
/*
    <DISTINCT>
        컬럼에 포함된 중복값을 한번씩만 표시하고자 할 때 사용
        SELECT 절에 딱 한번만 기술할 수 있다.
        컬럼이 여러 개이면 컬럼값이 모두 같아야 중복값으로 판단되어 중복이 제거된다. 
*/
-- EMPLOYEE 테이블에서 직원코드 조회
SELECT JOB_CODE
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 직원코드 (중복 제거) 조회
SELECT DISTINCT JOB_CODE
FROM EMPLOYEE;

---------------------------------------
/*
    <where 절>
    - 조회하고자 하는 테이블에서 해당 조건에 만족하는 결과만을 조회하고자 할 때 사용한다. 
    - 조건식에는 다양한 연산자를 사용할 수 있다.
    
    [표현법]
    SELECT 컬럼, 컬럼 ...., 컬럼
    FROM 테이블명
    WHERE 조건식;
    
    <비교연산자>
        >, < >=, <= : 대소비교
        =           : 동등비교
        !=, ^=, <>  : 같지 않음
*/
-- EMPLOYEE 테이블에서 부서코드가 D9와 일치하는 사원들의 모든 정보
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- EMPLOYEE 테이블에서 부서코드가 D9가 아닌 사원들의 사번, 사원명, 부서코드

SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
-- WHERE DEPT_CODE != 'D9';
-- WHERE DEPT_CODE ^= 'D9';
WHERE DEPT_CODE <> 'D9';

-- 급여가 400이상인 직원들의 :대소비교
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 4000000;

-- 논리 연산 AND, OR 

-- EMPLOYEE 테이블에서 부서코드 D9, 급여가 300이상인 직원들의 사번, 직원명, 부서코드, 급여 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6' AND SALARY >= 3000000;

-- EMPLOYEE 테이블에서 부서코드 D5이거나, 급여가 500이상인 직원들의 사번, 직원명, 부서코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' OR SALARY >= 5000000;

-- EMPLOYEE 테이블에서 급여가 350이상 600 이하인 직원들의 사번, 직원명, 부서코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3500000 AND SALARY <= 6000000;

/*
    <BETWEEN AND>
        조건절엣 사용되는 구문
        몇 이상 몇 이하인 범위에 대한 조건을 제시할 때 사용
        
        [표현법]
            비교대상 컬럼명 BETWEEN 하한값 AND 상한값
*/
-- EMPLOYEE 테이블에서 급여가 350이상 600 이하인 직원들의 사번, 직원명, 부서코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY BETWEEN 3500000 AND 6000000;

-- EMPLOYEE 테이블에서 입사일이 '90/01/01' ~ '01/01/01'인 사원의 모든 컬럼 조회
SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/01/01'
ORDER BY HIRE_DATE;

-- 반대로 위의 범위에 입사한 사원들이 아닌 그 외에 입사한 사원 조회
SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE NOT BETWEEN '90/01/01' AND '01/01/01'
ORDER BY HIRE_DATE;

/* LIKE : 비교하는 컬럼값이 지정된 특정 패턴에 만족하는 경우 TRUE 리턴
        '%' : 0 글자 이상
    LIKE '문자%' : 컬럼값 중 '문자'로 시작하는 모든 행 조회
    LIKE '%문자' : 컬럼값 중 '문자'로 끝나는 모든 행 조회
    LIKE '%문자%' : 컬럼값 중 '문자'가 포함된 모든 행 조회
        '_' : 1 글자
    LIKE '_문자' : 컬럼값 중 '문자' 앞에 무조건 한 글자가 오는 모든 행 조회
    LIKE '__문자%' : 컬럼값 중 '문자' 앞에 무조건 두 글자가 오는 모든 행 조회
*/

-- EMPLOYEE 테이블에서 성이 전씨인 사원
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '전%';

-- EMPLOYEE 테이블에서 이름 중 '하'가 포함된 사원
SELECT EMP_NAME, EMP_NO, DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%';

-- 전화번호 4번째 자리가 9로 시작하는 사원
-- 와일드 카드  '_'는 한 글자, '%'는 한 글자 이상
SELECT EMP_ID, EMP_NAME, PHONE, EMAIL
FROM EMPLOYEE
WHERE PHONE LIKE '___9%';

-- 이메일 중 _ 앞글자가 3자리인 이메일 주소를 가진 사원
-- 어떤 게 와일드카드인지 어떤 게 데이터 값인지 구분
-- 데이터로 처리할 값 앞에 임의의 문자를 제시하고 임의의 문자를 ESCAPE OPTION에 등록한다. 
SELECT EMP_ID, EMP_NAME, PHONE, EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE '___$_%' ESCAPE'$';

-- EMPLOYEE 테이블에서 김씨 성이 아닌 사원
SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME NOT LIKE '김%';

/*
    <IS NULL / IS NOT NULL>
        컬럼 값에 NULL이 있을 경우 NULL 값 비교에 사용됨
        
        비교대상 컬럼명 IS NULL : 컬럼값이 NULL인 경우 TRUE 
        비교대상 컬럼명 IS NOT NULL : 컬럼값이 NULL이 아닌 경우 TRUE
*/
-- -- EMPLOYEE 테이블에서 보너스를 받지 않는 사원
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
-- WHERE BONUS = NULL; => NULL은 값이 아니기 때문에 비교 연산자로 비교할 수 없다
WHERE BONUS IS NULL;

-- EMPLOYEE 테이블에서 부서배치를 받진 않았지만 보너스를 받는 사원
SELECT EMP_NAME, DEPT_CODE, BONUS
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL AND BONUS IS NOT NULL;

/* 
    <IN>
    비교대상 컬럼값 목록 중에 일치하는 값이 있을 때 TRUE 반환
    [표현법] 비교대상 컬럼명 IN('값', '값', '값')
*/
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6', 'D8');
-- WHERE DEPT_CODE = 'D5' OR DEPT_CODE = 'D6' OR DEPT_CODE = 'D8';

/*
    <연결 연산자>
        여러 컬럼값들을 하나의 컬럼인 것처럼 연결하거나, 컬럼과 리터럴을 연결할 수도 있다.
*/
-- EMPLOYEE 테이블에서 사번, 사워명, 급여를 연결 
SELECT EMP_ID || EMP_NAME || SALARY
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 사원명, 급여를 리터럴과 연결해서 조회
SELECT EMP_NAME || '님의 급여는 ' || SALARY || '원 입니다' AS "급여 정보"
FROM EMPLOYEE;

/*
    <연산자 우선순위>
*/
SELECT *
FROM EMPLOYEE
WHERE (JOB_CODE = 'J7' OR JOB_CODE = 'J2') AND SALARY >= 2000000;

/* 
    <ORDER BY>
        SELECT문 가장 마지막에 기입하는 구문으로 실행 또한 가장 마지막에 진행된다. 
        [표현법] 
            SELECT 컬럼, 컬럼, 컬럼
            FORM 테이블명
            WHERE 조건식
            ORDER BY 정렬시키고자 하는 컬럼명|별칭|컬럼순번 [ASC|DESC] [NULLS FIRST|NULLS LAST]
                - ASC : 오름차순 정렬 (ASC 또는 DESC 생략시 기본값)
                - DESC : 내림차순 정렬
                - NULLS FIRST : 정렬하고자 하는 컬럼값에 NULL이 있는 경우 해당 데이터값을 맨 앞으로
                - NULLS LAST : 정렬하고자 하는 컬럼값에 NULL이 있는 경우 해당 데이터값을 맨 뒤로 
*/

SELECT *
FROM EMPLOYEE
-- ORDER BY BONUS;
-- ORDER BY BONUS ASC; -- 오름차순으로 정렬은 기본적으로 NULLS LAST 
ORDER BY BONUS NULLS FIRST;
--ORDER BY BONUS DESC; -- 내림차순 정렬은 기본적으로 NULLS FIRST

SELECT *
FROM EMPLOYEE
ORDER BY BONUS DESC, SALARY; -- 정렬 기준을 여러개 제시 가능하다.

-- EMPLOYEE 테이블에서 연봉별 내림차순 정렬된 사원의 사원명, 연봉 조회
SELECT EMP_NAME, SALARY * 12 AS "연봉"
FROM EMPLOYEE
--ORDER BY SALARY * 12 DESC;
-- ORDER BY 연봉 DESC;    -- 별칭을 사용해서
ORDER BY 2 DESC;    -- 순번을 사용해서 







