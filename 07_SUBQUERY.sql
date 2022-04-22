/*
    <SUBQUERY>
        하나의 SQL문 안에 포함된 또 다른 SQL문을 뜻한다. 
        메인쿼리[기존쿼리]를 보조하는 역할을 하는 쿼리문
*/
--서브쿼리 예시 1 : 노옹철 사원과 같은 부서원들을 조회

-- 1) 노응철 사원의 부서코드 조회
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철';
-- 2) 부서코드가 노옹철 사원의 부서코드와 동일한 사원들을 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- 3)위의 2단계를 하나의 쿼리로 작성
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '노옹철');
                    
-- 서브쿼리 예시 2
-- 전직원의 평균급여 보다 더 많은 급여를 받고 있는 직원을 조회
-- 사번, 이름, 직급코드, 급여 조회

-- 1) 전직원의 평균급여 조회
SELECT AVG(SALARY)
FROM EMPLOYEE;

-- 2) 급여가 1)의 조회 결과로 나온 급여 이상인 직원들의 정보 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3047662.60869565217391304347826086956522;

-- 3)위의 2단계를 서브쿼리를 사용하여 하나의 쿼리문으로 작성
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= (SELECT AVG(SALARY)
                FROM EMPLOYEE);

---------------------------------------------------------------------------
/*
    <서브쿼리 구분>
        서브쿼리를 수행한 결과값이 몇행 몇열이냐에 따라 분류
        
        1. 단일행 서브쿼리     : 서브쿼리의 조회 결과 값의 개수가 하나일 때
        2. 다중행 서브쿼리     : 서브쿼리의 조회 결과 값의 행의 수가 여러개일 때
        3. 다중열 서브쿼리     : 서브쿼리의 조회 결과 값이 하나의 행이지만 컬럼의 개수가 여러개일 때
        4. 다중행 다중열 서브쿼리 : 서브쿼리의 조회 결과 값이 여러행, 여러열일 때
        
        * 서브쿼리 유형에 따라 서브쿼리 앞에 붙는 연산자가 달라진다. 
*/

/*
    1. 단일행 서브쿼리
        서브쿼리의 조회 결과 값의 개수가 1개일 때 (단일행, 단일열)
        일반 연산자(단일행 연산자) 사용 가능 (=, !=, ^=, <>=, <,  >, >=, ....)
*/

-- 1) 전 직원의 평균 급여보다 급여를 적게 받는 직원들의 이름, 직급코드, 급여 조회
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY < (SELECT AVG(SALARY)
                FROM EMPLOYEE)
ORDER BY SALARY;                  
                    
-- 2) 최저 급여를 받는 직원의 사번, 이름, 직급코드, 급여, 입사일 조회 
-- 최저 급여 조회 
SELECT MIN(SALARY)
FROM EMPLOYEE;

-- 서브쿼리를 사용하여 하나의 쿼리문으로 작성
SELECT EMP_ID, EMP_NAME, JOB_CODE, HIRE_DATE, SALARY
FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY)          --  결과값 1행 1열
                FROM EMPLOYEE);

-- 3) 노옹철 사원의 급여보다 더 많이 받는 직원의 사번, 이름, 부서명, 직급코드, 급여 조회
-- ANSI로 작성
SELECT SALARY
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철';

SELECT E.EMP_ID 사번, E.EMP_NAME 사원명, D.DEPT_TITLE 부서명, E.JOB_CODE 직급, E.SALARY 급여
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
WHERE SALARY > (SELECT SALARY
            FROM EMPLOYEE
            WHERE EMP_NAME = '노옹철')
ORDER BY JOB_CODE;
                
-- 오라클로 작성
SELECT  E.EMP_ID 사번, 
        E.EMP_NAME 사원명, 
        D.DEPT_TITLE 부서명, 
        E.JOB_CODE 직급, 
        E.SALARY 급여
FROM EMPLOYEE E, DEPARTMENT D 
WHERE (E.DEPT_CODE = D.DEPT_ID) 
        AND SALARY > (SELECT SALARY
                        FROM EMPLOYEE
                        WHERE EMP_NAME = '노옹철');
                        
-- 4) 전지연 사원이 속해있는 부서원들 조회 ( 단, 전지연을 제외)
-- 사번, 사원명, 전화번호, 직급명, 부서명, 입사일

-- ANSI
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '전지연';

SELECT E.EMP_ID, E.EMP_NAME, E.PHONE, D.DEPT_TITLE, J.JOB_NAME, E.HIRE_DATE
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE E.DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '전지연') AND E.EMP_NAME != '전지연';

-- 오라클 구문
SELECT  E.EMP_ID 사번, 
        E.EMP_NAME 사원명, 
        E.PHONE 전번, 
        J.JOB_NAME 직급명, 
        D.DEPT_TITLE 부서명, 
        E.HIRE_DATE 입사일
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE (E.DEPT_CODE = D.DEPT_ID) 
        AND (E.JOB_CODE = J.JOB_CODE)
        AND E.DEPT_CODE = (SELECT DEPT_CODE
                        FROM EMPLOYEE
                        WHERE EMP_NAME = '전지연')
        AND E.EMP_NAME != '전지연';


-- 4) (부서별 급여합이 가장 큰 급여)의 부서의 부서코드, 급여합 조회
-- * 서브쿼리는 WHERE 절 뿐만 아니라, SELECT/FROM/HAVING 절 등 다양한 곳에서 사용 가능
SELECT MAX(SUM(SALARY)) 
FROM EMPLOYEE
GROUP BY DEPT_CODE;


SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))       --> 결과값 1행 1열
                        FROM EMPLOYEE
                         GROUP BY DEPT_CODE);

-- 1. SELECT DEPT_CODE, SUM(SALARY) 구문을 먼저 작성한다. 구하려는 값이 정확히 무엇인가?
-- 2. MAX(SUM(SALARY))를 구한다.    : 비교하고자 하는 대상이 뭔가?
-- 3. 원 구문에서 비교자가 무엇인가? SUM(SALARY)
-- SUM(SALARY) 는 GROUP BY에의해 생성된 것이므로 GROUP BY를 수식하는 HAVING절이 필요하다. 

----------------------------------------------------------------------------
/*
    2. 다중행 서브쿼리
        서브쿼리의 조회 결과 값의 개수가 여러행일 때 
        
        IN / NOT IN (서브쿼리) : 여러개의 결과값 중에서 한 개라도 일치하는 값이 있거나 없다면 TRUE를 리턴한다.
            SALARY IN (.....)
        ANY : 여러개의 값들 중에서 한 개라도 만족하면 TRUE. IN과 다른 점은 비교연산자를 사용한다는 점
            SALARY = ANY (.....) : IN과 같은 결과 
            SALARY != ANY (.....) : NOT IN과 같은 결과 
            SALARY > ANY (.....)    : 최소값 보다 크면 TRUE 리턴
            SALARY < ANY (.....)    : 최대값 보다 작으면 TRUE 리턴
        ALL : 여러개 값들 모두와 비교하여 만족해야만 TRUE 리턴
            SALARY > ALL (.....)    : 최대값 보다 크면 TRUE 리턴
            SALARY < ALL (.....)    : 최소값 보다 작으면 TRUE 리턴
*/

-- 1) 각 부서별 최고 급여를 받는 직원의 이름, 직급코드, 부서코드, 급여 조회
SELECT MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;


SELECT EMP_NAME, JOB_CODE, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY IN (SELECT MAX(SALARY)
                FROM EMPLOYEE
                GROUP BY DEPT_CODE)
ORDER BY DEPT_CODE;

-- * 다중행 다중열 예시 미리보기 : 다른 부서에 같은 급여를 받는 사원이 있다면 문제 
SELECT DEPT_CODE, MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT EMP_NAME, JOB_CODE, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE (DEPT_CODE, SALARY) IN (SELECT DEPT_CODE, MAX(SALARY)
                FROM EMPLOYEE
                GROUP BY DEPT_CODE)
ORDER BY DEPT_CODE;
---------------------------------------------------------------------------

-- 2) 대리 직급임에도 과장 직급들의 최소 급여보다 많이 받는 직원 조회
-- 사번, 이름, 직급명, 급여 조회

-- 과장 직급들의 급여 조회
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장';      --2200000, 2500000, 3760000

-- 직급이 대리인 직원들 중에서 위의 목록들 값들 중 하나라도 비교해서 큰 경우 
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리' AND SALARY > ANY(2200000, 2500000, 3760000);
-- SALARY > 2200000 OR SALARY > 2500000 OR SALARY > 3760000
-- WHERE JOB_NAME = '대리' AND SALARY > IN(2200000, 2500000, 3760000); -- IN은 같은 경우 조회

-- 서브쿼리로 합체
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리' AND SALARY > ANY(SELECT SALARY
                                        FROM EMPLOYEE
                                        JOIN JOB USING(JOB_CODE)
                                        WHERE JOB_NAME = '과장');

-- 3) 과장 직급임에도 차장 직급의 최대 급여보다 더 많이 받는 직원
-- 사번, 이름, 직급명, 급여 조회
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME ='차장';       --  2800000, 1550000, 2490000, 2480000

SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장' AND SALARY > ALL(SELECT SALARY
                                        FROM EMPLOYEE
                                        JOIN JOB USING(JOB_CODE)
                                        WHERE JOB_NAME ='차장');
-- SALARY > 2800000 AND SALARY > 1550000 AND SALARY > 2490000 AND SALARY > 2480000


------------------------------------------------------------------------------
/*
    <다중열 서브쿼리>
        조회 결과 값이 한 행이지만 나열된 컬럼 수가 여러개일 때
*/

-- 1) 하이유 사원과 같은 부서코드, 같은 직급코드에 해당하는 사원 이름, 부서코드, 직급코드 조회

-- 하이유 사원의 부서코드와 직급코드 조회
SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '하이유';   --D5, J5

SELECT EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND JOB_CODE = 'J5';

-- 각각 단일행 서브쿼리로 작성
SELECT EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE             -- 단일행 서브쿼리
                    FROM EMPLOYEE 
                    WHERE EMP_NAME = '하이유')
AND JOB_CODE = (SELECT JOB_CODE                 -- 단일행 서브쿼리
                    FROM EMPLOYEE 
                    WHERE EMP_NAME = '하이유');

SELECT EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) IN (SELECT DEPT_CODE, JOB_CODE          -- '='보다 'IN'이 효율적이다.
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '하이유')
        AND EMP_NAME != '하이유';
        
-- 2) 사원 중 박나라 사원과 직급코드가 일치하면서 같은 사수를 가지고 있는 사원을 조회
-- 사번, 이름, 직급코드, 사수 사번
SELECT JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE EMP_NAME = '박나라';

SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (JOB_CODE, MANAGER_ID) IN (SELECT JOB_CODE, MANAGER_ID
                                    FROM EMPLOYEE
                                    WHERE EMP_NAME = '박나라')
ORDER BY EMP_ID;


-------------------------------------------------------------------------
/*
    <다중행, 다중열 서브쿼리>
        서브쿼리의 조회 결과값이 여러행 여러열인 경우 : 컬럼의 개수와 행의 개수가 여러 개인 서브쿼리
*/
-- 직급별 최소 급여를 받는 직원의 사번, 이름, 직급코드, 급여 조회

-- 직급별 최소 급여 조회
SELECT JOB_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE = 'J2' AND SALARY = 3700000
    OR JOB_CODE = 'J3' AND SALARY = 3400000;  -- .......

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY)       -- 여기서는 '='를 사용하면 오류
                            FROM EMPLOYEE
                            GROUP BY JOB_CODE)
ORDER BY JOB_CODE;

-- 각 부서별 최소 급여를 받는 사원의 사번, 이름, 직급코드, 급여 조회   -- NVL도 활용
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
ORDER BY DEPT_CODE;

SELECT DEPT_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;


SELECT EMP_ID, EMP_NAME, NVL(DEPT_CODE, '부서없음'), JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (NVL(DEPT_CODE, '부서없음'), SALARY) IN (SELECT NVL(DEPT_CODE, '부서없음'), MIN(SALARY)
                                FROM EMPLOYEE
                                GROUP BY DEPT_CODE)
ORDER BY DEPT_CODE NULLS FIRST;


-- 1. 각 부서별 최고 급여를 받는 사원을 조회하려고 아래와 같이 SQL구문을 작성하였다.
-- 출력을 해보니 부서를 배정받고 있지않은 사원은 빠져있는 것을 확인하였다.
-- 부서가 없는 사원을 찾기위해서 사용할 함수를 [원인](10점)에 기술하고, 해결방법을 적용한
-- SQL구문을 [조치내용](30점)에 기술하시오.(40점)

SELECT EMP_ID, EMP_NAME, NVL(DEPT_CODE, '부서없음'), SALARY
FROM EMPLOYEE
WHERE (NVL(DEPT_CODE, '부서없음'), SALARY) IN (SELECT NVL(DEPT_CODE, '부서없음'), MAX(SALARY)
                                FROM EMPLOYEE
                                GROUP BY DEPT_CODE)
ORDER BY DEPT_CODE;

-------------------------------------------------------------------------------
/*
    <인라인 뷰>
        FROM절에 서브쿼리를 제시하고, 서브쿼리를 수행한 결과를 테이블 대신에 사용한다. 
*/
-- 1. 인라인뷰를 활용한 TOP-N 분석
-- 전 직원 중에 급여가 가장 높은 상위 5명 순위, 이름, 급여 조회
--  * ROWNUM : 오라클에서 제공해 주는 컬럼, 조회되는 순서대로 1부터 순번을 부여해주는 컬럼 
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC;
--       ROWNUM에 의해 순서가 결정되고 다시 ORDER BY에 의해 정렬되다 보니 ROWNUM의 순번이 뒤죽박죽됨
--      FROM -> SELECT -> ORDER BY

-- ORDER BY한 결과값을 가지고 ROWNUM을 부여하면 된다. (인라인 뷰 사용)

SELECT ROWNUM 순위, EMP_NAME 이름, SALARY 급여    -- 여기서 ROWNUM 생략 가능
FROM (SELECT *
        FROM EMPLOYEE
        ORDER BY SALARY DESC)
;

SELECT ROWNUM 순위, EMP_NAME 이름, SALARY 급여    -- 여기서 ROWNUM 생략 가능
FROM (SELECT *
        FROM EMPLOYEE
        ORDER BY SALARY DESC)
WHERE ROWNUM <= 5;

SELECT * 
FROM (SELECT ROWNUM 순위, EMP_NAME 이름, SALARY 급여    
     FROM (SELECT *
        FROM EMPLOYEE
        ORDER BY SALARY DESC)
) WHERE ROWNUM <= 5;

-------------------------------------------------------------------------------
/*
    <RANK 함수>
        RANK() OVER(정렬기준)       : 동일한 순위 이후의 등수를 동일한 인원 수 만큼 건너뛰고 순위 계산
        DENSE_RANK() OVER(정렬기준) : 동일한 순위 이후의 등수를 무조건 1씩 증가 (공동 1위가 2명이면 그 다음 순위는 2위)
*/
-- 사원별 급여가 높은 순대로 순위를 매겨서 순위, 사원명, 급여 조회
SELECT RANK() OVER(ORDER BY SALARY DESC) 순위,
        EMP_NAME, 
        SALARY
FROM EMPLOYEE;
-- 공동 19위 2명 뒤에 순위는 21위

SELECT DENSE_RANK() OVER(ORDER BY SALARY DESC) 순위,
        EMP_NAME, 
        SALARY
FROM EMPLOYEE;
-- 공동 19위 2명 뒤에 순위는 20위

-- 상위 5명만 조회
 /*   SELECT RANK() OVER(ORDER BY SALARY DESC) 순위,
            EMP_NAME, 
            SALARY
    FROM EMPLOYEE
    WHERE ........;  -- 아무리 해도 안됨
*/

SELECT 순위, 사원명, 급여
FROM (SELECT RANK() OVER(ORDER BY SALARY DESC) 순위,
        EMP_NAME 사원명, 
        SALARY 급여
        FROM EMPLOYEE
)
WHERE 순위 <= 5;


