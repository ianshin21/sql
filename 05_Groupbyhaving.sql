
/*
                <GROUP BY>
        그룹 기준을 제시할 수 있는 구문
        여러개의 값들을 하나의 그룹으로 묶어서 처리할 목적으로 사용
*/
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL
GROUP BY DEPT_CODE;

-- 각 부서별 사원 수
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 각 부서별 급여합을 오름차순으로 정렬해서 조회
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
-- ORDER BY DEPT_CODE ASC;
ORDER BY DEPT_CODE NULLS FIRST;

-- 각 직급별 사원수를 오름차순으로 정렬해서 조회
SELECT JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

-- 각 직급별로 보너스 받는 사원 수
SELECT JOB_CODE, COUNT(BONUS) "보너스 받는 사원수"
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

-- 각 직급별 급여 평균
SELECT JOB_CODE, FLOOR(AVG(SALARY))
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;


---------------------시험 문제--------------------

-- 각 직급별로 보너스 받는 사원 수
SELECT EMP_NAME, JOB_CODE, COUNT(*) "보너스 받는 사원수"
FROM EMPLOYEE
WHERE BONUS IS NOT NULL
GROUP BY EMP_NAME, JOB_CODE
ORDER BY JOB_CODE;


-- 직원 테이블(EMP)에서 부서 코드별 그룹을 지정하여 부서코드, 그룹별 급여의 합계, 
-- 그룹별 급여의 평균(정수처리), 인원수를 조회하고 부서코드순으로 나열되어있는 코드 아래와 같이 제시되어있다. 
-- 아래의 SQL구문을 평균 월급이 2800000초과하는 부서를 조회하도록 수정하려고한다.


SELECT DEPT, SUM(SALARY) 합계 , FLOOR(AVG(SALARY)) 평균, COUNT(*) 인원수
FROM EMP
GROUP BY DEPT
ORDER BY DEPT ASC;

SELECT  DEPT_CODE 부서코드,
        SUM(SALARY) 급여합, 
        FLOOR(AVG(SALARY)) 평균급여, 
        COUNT(*) 사원수 
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING FLOOR(AVG(SALARY)) > 2800000
ORDER BY DEPT_CODE ASC;
------------------------------------------------------------------


-- 부서별 사원 수, 보너스 받는 사원수, 급여합, 평균급여, 최고급여, 최저급여  부서별 내림차순으로 조회
SELECT  DEPT_CODE 부서,
        COUNT(*) 사원수, 
        COUNT(BONUS) 보너스받는사원수, 
        TO_CHAR(SUM(SALARY), '999,999,999') 급여합, 
        TO_CHAR(FLOOR(AVG(SALARY)), '999,999,999') 평균급여, 
        TO_CHAR(MAX(SALARY), '999,999,999') 최고급여, 
        TO_CHAR(MIN(SALARY), '999,999,999') 최저급여
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE DESC;


-- 남자 사원의 수, 여자 사원의 수
--SELECT EMP_NO, SUBSTR(EMP_NO, 8, 1), COUNT(SUBSTR(EMP_NO, 8, 1))
SELECT DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남자', '2', '여자') AS "성별", 
        COUNT(*) AS "사원수"
FROM EMPLOYEE
GROUP BY DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남자', '2', '여자');     -- 컬럼, 계산식, 연산이 올 수 있다.

-- 여러 컬럼 제시해서 그룹 기준을 선정
SELECT DEPT_CODE, JOB_CODE, COUNT(*), SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY DEPT_CODE;

-----------------------------------------------------------------------------------
/*
            <HAVING>
        그룹에 대한 조건을 제시할 때 사용하는 구문 (주로 그룹함수한 결과를 가지고 비교 수행)
        
        *실행순서 & 정렬 순서* 
            5. SELECT          *|조회하고자 하는 컬럼명 AS 별칭|계산식|함수식
            1. FROM            조회하고자 하는 테이블명
            2. WHERE           조건식
            3. GROUP BY        그룹기준에 해당하는 컬럼명|계산식|함수식
            4. HAVING          그룹함수식에 대한 조건식
            6. ORDER BY        컬럼명|별칭|컬럼순번
*/

-- 각 부서별 평균 급여 조회
-- 평균 급여가 3000000 이상인 부서들만 조회
SELECT DEPT_CODE, FLOOR(AVG(SALARY))
FROM EMPLOYEE
--WHERE FLOOR(AVG(SALARY)) > 3000000   --에러 남
GROUP BY DEPT_CODE
HAVING FLOOR(AVG(SALARY)) >= 3000000
ORDER BY DEPT_CODE;

SELECT DEPT_CODE, FLOOR(AVG(SALARY))
FROM EMPLOYEE
WHERE SALARY > 3000000 
GROUP BY DEPT_CODE;

-- 직급별 급여합
-- 급여합이 천만원 이상인 직급들만 조회
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING SUM(SALARY) >= 10000000
ORDER BY JOB_CODE;

--부서별 보너스를 받는 사원이 없는 부서만을 조회
-- SELECT DEPT_CODE, COUNT(BONUS)
SELECT DEPT_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0
ORDER BY DEPT_CODE;

SELECT DEPT_CODE
FROM EMPLOYEE
WHERE BONUS IS NULL         -- 의미 없음
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;
----------------------------------------------------------------------------------
/*
            <집계 함수>
        그룹별 산출한 결과 값의 중간 집계를 계산해주는 함수
        ROLLUP, CUBE
*/

-- 각 직급별 급여합
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

-- 마지막 행에 전체 총급여합까지 함께 조회
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE)
ORDER BY JOB_CODE;

SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(JOB_CODE)
ORDER BY JOB_CODE;

-- 부서코드도 같고 직급코드도 같은 사원들을 그룹지어서 해당 급여합
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY 1;

-- ROLLUP(컬럼1, 컬럼2, ...) -> 컬럼1을 기준으로 중간 집계를 내는 함수
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY 1;

-- CUBE(컬럼1, 컬럼2, ... ) -> 컬럼1을 기준으로 중간 집계를 내고  
--              컬럼2를 기준으로 다시 중간집계 내고, 전달되는 컬럼 모두 집계
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1;

/*
            <GROUPING>
        ROLLUP이나 CUBE에 의해 산출된 값이 해당 컬럼의 집합의 산출 결과이면 0을 반환, 아니면 1을 반환
*/
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY),
        GROUPING(DEPT_CODE) 부서별그룹묶인상태,
        GROUPING(JOB_CODE) 직급별그룹묶인상태
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY 1;

SELECT DEPT_CODE, JOB_CODE, SUM(SALARY),
        GROUPING(DEPT_CODE) 부서별그룹묶인상태,
        GROUPING(JOB_CODE) 직급별그룹묶인상태
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1;

/*
            <집합연산자>
        여러개의 쿼리문을 가지고 하나의 쿼리문으로 만드는 연산자
        
        UNION       : 합집합
        UNION ALL   : 합집합 + 중복 허용
        INTERSECT   : 교집합
        MINUS       : 차집합
*/
-- EMPLOYEE 테이블에서 부서코드가 D5인 사원들만 조회 -> 6명
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-- EMPLOYEE 테이블에서 급여가 3백 초과 사원  -> 8명
SELECT *
FROM EMPLOYEE
WHERE SALARY >= 3000000;

-- EMPLOYEE 테이블에서 부서코드가 D5인 사원 OR 급여가 3백 초과 사원 

SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

UNION

SELECT *
FROM EMPLOYEE
WHERE SALARY >= 3000000;

-- 아래와 동일    : F10 으로 확인 UNION은 OR에 비해 COST가 많이 든다. 잘 사용하지 않는다. 
SELECT *
FROM EMPLOYEE
WHERE SALARY >= 3000000 OR DEPT_CODE = 'D5';

-- 2. UNION ALL
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

UNION ALL

SELECT *
FROM EMPLOYEE
WHERE SALARY >= 3000000;

-- 3. INTERSECT
-- EMPLOYEE 테이블에서 부서코드가 D5인 사원 AND 급여가 3백 초과 사원 
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

INTERSECT

SELECT *
FROM EMPLOYEE
WHERE SALARY >= 3000000;

-- 아래와 동일    : F10 으로 확인 INTERSECT은 AND에 비해 COST가 많이 든다. 잘 사용하지 않는다. 
SELECT *
FROM EMPLOYEE
WHERE SALARY >= 3000000 AND DEPT_CODE = 'D5';

-- 4. MINUS
-- EMPLOYEE 테이블에서 부서코드가 D5인 사원 중에서 급여가 3백 초과 사원 제외
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

MINUS

SELECT *
FROM EMPLOYEE
WHERE SALARY >= 3000000;

-- 아래와 동일    
SELECT *
FROM EMPLOYEE
WHERE SALARY < 3000000 AND DEPT_CODE = 'D5';

------------------------------------------------------------
/*
                <GROUPING SET>
*/
SELECT DEPT_CODE, JOB_CODE, MANAGER_ID, FLOOR(AVG(SALARY))
FROM EMPLOYEE
GROUP BY GROUPING SETS((DEPT_CODE, JOB_CODE, MANAGER_ID),
                    (DEPT_CODE, MANAGER_ID), (JOB_CODE, MANAGER_ID));

-- 1.
SELECT DEPT_CODE, JOB_CODE, MANAGER_ID, FLOOR(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE, MANAGER_ID
ORDER BY DEPT_CODE, JOB_CODE;

-- 2. 
SELECT DEPT_CODE, MANAGER_ID, FLOOR(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE, MANAGER_ID
ORDER BY DEPT_CODE;

-- 3. 
SELECT JOB_CODE, MANAGER_ID, FLOOR(AVG(SALARY))
FROM EMPLOYEE
GROUP BY JOB_CODE, MANAGER_ID
ORDER BY JOB_CODE;

-- 위 1, 2, 3을 모두 합친 것과 같고 
-- 위 1, 2, 3,을 컬럼을 다 맞추어서 UNION ALL 하는 것과 같다.




