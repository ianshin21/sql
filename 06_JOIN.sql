/*
            <JOIN>
        두 개 이상의 테이블에서 데이터를 조회하고자 할 때 사용하는 구문
        무작정 테이터를 가져오는 게 아니라 각 테이블간에 공통된 컬럼으로 데이터를 합쳐서 하나의 결과로 조회한다. 
*/
-- 각 사원들의 사번, 사원명, 부서코드, 부서명
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;

-- DEPARTMENT 테이블에서 /부서ID, 부서명 조회 / 전체 컬럼 조회
SELECT *
FROM DEPARTMENT;

-- 조인을 사용해서 같이 조회 가능
/*
    1. 등가조인(EQUAL JOIN) / 내부조인 (INNER JOIN)
        연결시키는 컬럼의 값이 일치하는 행들만 조인되어 조회 (일치하는 값이 없는 행은 조회되지 않음)
        
        오라클 전용 구문
            FROM 절에 조회하고자 하는 테이블들을 나열(',' 구분자로)
            WHERE 절에 매칭시킬 컬럼명에 대한 조건을 제시함
*/
--  1) 연결할 두 컬럼명이 다른 경우
-- EMPLOYEE 테이블과 DEPARTMENT 테이블을 조인하여 사번, 사원명, 부서코드, 부서명을 연결해서 조회 
-- 일치하는 값이 없는 행은 조회에서 제외된다. 
--          (DEPT_CODE가 NULL이거나, DEPT_ID가 D3, D4, D7인 경우 : 사원 배정이 없는 부서)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;

-- 2) 연결할 두 컬럼명이 같은 경우 
-- EMPLOYEE 테이블과 JOB테이블을 연결하여 조인하여 사번, 사원명, 직급코드, 직급명(결국 이걸 연결한다.)을 조회 
-- 방법 1. 테이블명을 이용하는 방법 
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- 방법 2. 테이블의 별칭을 사용하는 방법 : 각 테이블마다 별칭을 부여할 수 있다. : 컬럼명이 다른 경우에도 사용 가능
SELECT E.EMP_ID, E.EMP_NAME, E.JOB_CODE, J.JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;

/*
        1. 등가조인(EQUAL JOIN) / 내부조인 (INNER JOIN)
            ANSI 표준 구문
                FROM 절에 기준이 되는 테이블을 하나 기술한 후
                JOIN 절에서 같이 조회하고자 하는 테이블을 기술 후 매칭 시킬 컬럼에 대한 조건 기술
                USING구문과 ON구문
*/
--  1) 연결할 두 컬럼명이 다른 경우
-- EMPLOYEE 테이블과 DEPARTMENT 테이블을 조인하여 사번, 사원명, 부서코드, 부서명 조회 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

-- 2) 연결할 두 컬럼명이 같은 경우 
-- EMPLOYEE 테이블과 JOB테이블을 연결하여 조인하여 사번, 사원명, 직급코드, 직급명(결국 이걸 연결한다.)을 조회 
-- 방법 1) USING 사용
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE);   -- USIGN과 같은 컬럼이라고 인식

-- 방법 2) 별칭 사용 
SELECT E.EMP_ID, E.EMP_NAME, E.JOB_CODE, J.JOB_NAME
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);

SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
FROM EMPLOYEE 
JOIN JOB ON (EMPLOYEE.JOB_CODE = JOB.JOB_CODE);

-- 방법 3) 자연조인, NATURAL 조인 : 참고만하세요~~~~ 
--          찾아서 자동으로 연결하는데, 같은 이름 컬럼이 많으면 혼돈이 오기 때문에 잘 안씀
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE 
NATURAL JOIN JOB;

-- EMPLOYEE 테이블과 JOB 테이블을 조인하여 직급이 대리인 사원의 사번, 사원명,  직급명, 급여를 조회
-- 오라클
SELECT E.EMP_ID, EMP_NAME, SALARY, J.JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE AND JOB_NAME = '대리';

-- 안시
SELECT E.EMP_ID, EMP_NAME, SALARY, J.JOB_NAME
FROM EMPLOYEE E
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE J.JOB_NAME = '대리';


------------------ 실습 문제 -------------------------
SELECT * FROM DEPARTMENT;

SELECT * 
FROM LOCATION;

-- 1. 위 테이블을 참고해서 부서코드, 부서명, 지역코드, 지역명을 조회
-- 오라클
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_NAME
FROM DEPARTMENT, LOCATION
WHERE LOCATION_ID = LOCAL_CODE;

-- 안시
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_NAME
FROM DEPARTMENT 
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE;

-- 2. EMPLOYEE 테이블과 DEPARTMENT 테이블을 조인해서 보너스를 받는 사원들의 사번, 사원명, 보너스, 부서명을 조회
-- 오라클
SELECT EMP_ID, EMP_NAME, BONUS, /*DEPT_CODE,*/ DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID AND BONUS IS NOT NULL
ORDER BY 1;

-- 안시 
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE 
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID 
WHERE BONUS IS NOT NULL
ORDER BY 1;


-- 3. EMPLOYEE 테이블과 DEPARTMENT 테이블을 조인해서 인사관리부가 아닌 사원들의 사원명, 급여 조회
--오라클
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT 
--WHERE DEPT_CODE = DEPT_ID AND DEPT_TITLE != '인사관리부';
--WHERE DEPT_CODE(+) = DEPT_ID AND DEPT_TITLE != '인사관리부';   -- NULL 포함
WHERE DEPT_CODE = DEPT_ID AND DEPT_ID != 'D1';

-- 안시
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE DEPT_ID != 'D1';


-- 4. EMPLOYEE 테이블과 DEPARTMENT 테이블, JOB 테이블을 조인해서 사번, 사원명, 부서명, 직급명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE, DEPARTMENT, JOB
WHERE DEPT_CODE = DEPT_ID AND EMPLOYEE.JOB_CODE = JOB.JOB_CODE
ORDER BY 1;

-- ANSI
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON  DEPT_CODE = DEPT_ID             -- 안시에서는 순서 지킬 것
--JOIN JOB ON EMPLOYEE.JOB_CODE = JOB.JOB_CODE
JOIN JOB USING(JOB_CODE)
ORDER BY 1;

------------------------------------------------------------------
/*
        <OUTER JOIN>
        두 테이블간의 JOIN시 일치하지 않는 행도 포함시켜서 조회 가능
        단, 반드시 LEFT/RIGHT 방향을 지정해줘야 한다. (기준이 되는 테이블을 지정)
*/

-- OUTER JOIN과 비교할 INNER JOIN 구해 놓기
-- EMPLOYEE 테이블과 DEPARTMENT 테이블 조인해서 사원명, 부서명, 급여, 연봉
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);
-- 부서가 지정되지 않은 사원 2명에 대한 정보가 조회되지 않음
-- 부서가 지정되어 있어도 DEPARTMENT 테이블에 부서에 대한 정보가 없으면 조회되지 않는다. 

-- 1) LEFT [OUTER] JOIN : 두 테이블 중 왼편에 기술된 테이블의 컬럼을 기준으로 JOIN
--   >> ANSI 구문 
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE
LEFT OUTER JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);
-- 부서코드가 없던 사원의 정보도 나오게 된다. 이오리, 하동운    --> 테이블 기준 : 테이블에 방향성을 준다.

--   >> 오라클 구문                                       --> 컬럼 기준 : 해당 컬럼이 있는 테이블의 컬럼
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);       -- 오른쪽 테이블 컬럼에 + 표시 

-- 2) RIGHT [OUTER] JOIN : 두 테이블 중 오른쪽에 기술된 테이블의 컬럼을 기준으로 JOIN
--   >> ANSI
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE
RIGHT OUTER JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

-- 오라클 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE, DEPARTMENT 
WHERE DEPT_CODE(+) = DEPT_ID;

-- 3) FULL [OUTER] JOIN : 두 ㅓ테이블이 가진 모든 행을 조회할 수 있다.
--      단, 오라클 구문으로는 할 수 없다. 
--   >> ANSI 
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE
FULL OUTER JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

--   >> 오라클 구문 : 에러 발생
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE, DEPARTMENT 
WHERE DEPT_CODE(+) = DEPT_ID(+);

--------------------------------------------------------------------
/*
        <카테시안곱/CROSS JOIN>
            조인되는 모든 테이블의 각 행들이 서로서로 모두 매핑된 테이터가 검색된다.(곱집합)
            두 테이블의 행들이 모두 곱해진 행들의 조합이 출력 -> 방대한 테이터 출력 -> 과부하의 위험
*/

--  >> ANSI 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
CROSS JOIN DEPARTMENT
ORDER BY EMP_NAME; 

--  >> 오라클 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT;  -- 23 * 9 => 207

---------------------------------------------------------
/*
    <NON EQUAL JOIN(비등가조인)>
        "="(등호)를 사용하지 않는 조인문
        지정한 컬럼 값이 일치하는 경우가 아닌, 값의 "범위"에 포함되는 행들을 연결하는 방식
        ANSI구문으로는 JOIN ON 구문으로만 사용이 가능하다. (USING 사용불가)
*/
-- EMPLOYEE 테이블과 SAL_GRADE 테이블을 비등가조인하여 사원명, 급여, 급여등급 조회
SELECT * FROM SAL_GRADE;

--  >> ANSI 구문
SELECT EMP_NAME, SALARY, SAL_LEVEL
FROM EMPLOYEE
JOIN SAL_GRADE ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);

--  >> 오라클 구문
SELECT EMP_NAME, SALARY, SAL_LEVEL
FROM EMPLOYEE, SAL_GRADE 
WHERE (SALARY BETWEEN MIN_SAL AND MAX_SAL);

-----------------------------------------------------------
/*
        <SELF JOIN>
            같은 테이블을 다시 한번 조인하는 경우에 사용 (자기 자신과 조인을 맺는다).
            셀프조인에는 반드시 별칭 사용
*/
SELECT EMP_ID, EMP_NAME, MANAGER_ID
FROM EMPLOYEE;

-- EMPLOYEE 테이블을 SELF JOIN 하여 사원번호, 사원명, 부서코드, 사수번호, 사수명 조회
-- ANSI 구문
SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE, E.MANAGER_ID, M.EMP_NAME
FROM EMPLOYEE E
LEFT OUTER JOIN EMPLOYEE M ON(E.MANAGER_ID = M.EMP_ID);

-- 오라클 구문
SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE, E.MANAGER_ID, M.EMP_NAME
FROM EMPLOYEE E, EMPLOYEE M 
where E.MANAGER_ID = M.EMP_ID(+);


---------------------------------------------------------------------
/*
        <다중 조인>
            N개의 테이블 JOIN 
*/
-- EMPLOYEE, DEPARTMENT, LOCATION 테이블을 다중 JOIN하여 사번, 사원명, 부서명, 지역명 조회
SELECT * FROM EMPLOYEE;     -- DEPT_CODE
SELECT * FROM DEPARTMENT;   -- DEPT_ID      LOCATION_ID
SELECT * FROM LOCATION;     --              LOCAL_CODE

-- ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE 
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);
-- ANSI에서 다중 조인은 순서가 중요하다. 그러나 ANSI를 많이 사용하도록 한다. 

-- 오라클 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE, DEPARTMENT, LOCATION
WHERE DEPT_CODE = DEPT_ID AND LOCATION_ID = LOCAL_CODE;
-- 순서 상관 없다. 

------------------------------------------------------------------
/*
        <실습 문제>
*/
-- 1. 직급이 대리이면서 ASIA 지역에서 근무하는 직원들의 
-- 사번, 사원명, 직급명, 부서명, 근무지역명, 급여를 조회 / 별칭 붙여서
SELECT * FROM EMPLOYEE;     -- JOB_CODE     DEPT_CODE
SELECT * FROM JOB;          -- JOB_CODE     
SELECT * FROM DEPARTMENT;   --               DEPT_ID    LOCATION_ID
SELECT * FROM LOCATION;     --                          LOCAL_CODE

--  >> ANSI
SELECT  E.EMP_ID 사번, 
        E.EMP_NAME 사원명, 
        J.JOB_NAME 직급명, 
        D.DEPT_TITLE 부서명, 
        L.LOCAL_NAME 근무지역명, 
        E.SALARY 급여
FROM EMPLOYEE E 
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE) 
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID) 
JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
WHERE (JOB_NAME = '대리') AND (LOCAL_NAME LIKE 'ASIA%'); 

--  >> 오라클
SELECT  E.EMP_ID 사번, 
        E.EMP_NAME 사원명, 
        J.JOB_NAME 직급명, 
        D.DEPT_TITLE 부서명, 
        L.LOCAL_NAME 근무지역명, 
        E.SALARY 급여
FROM EMPLOYEE E, JOB J, DEPARTMENT D, LOCATION L
WHERE (E.JOB_CODE = J.JOB_CODE) AND (E.DEPT_CODE = D.DEPT_ID) AND (D.LOCATION_ID = L.LOCAL_CODE)
        AND (JOB_NAME = '대리') AND (LOCAL_NAME LIKE 'ASIA%'); 


-- 2. 70년대생이면서 여자이고, 성이 전씨인 직원들의 
--      사원명, 주민번호, 부서명, 직급명을 조회하세요.
SELECT * FROM EMPLOYEE;     -- JOB_CODE     DEPT_CODE
SELECT * FROM DEPARTMENT;   --               DEPT_ID    
SELECT * FROM JOB;          -- JOB_CODE     

--  >> ANSI
SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN JOB J USING (JOB_CODE)
WHERE SUBSTR(EMP_NO, 1, 1) = '7' AND SUBSTR(EMP_NO, 8, 1) = '2' AND EMP_NAME LIKE '전%';

--  >> 오라클
SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E, DEPARTMENT D, JOB J 
WHERE   (E.DEPT_CODE = D.DEPT_ID) 
    AND (E.JOB_CODE = J.JOB_CODE) 
    AND SUBSTR(EMP_NO, 1, 1) = '7' 
    AND SUBSTR(EMP_NO, 8, 1) = '2' 
    AND EMP_NAME LIKE '전%';
    
    
-- 3. 보너스를 받는 직원들의
--      사원명, 보너스, 연봉, 부서명, 근무지역명을 조회하세요. 
--      부서코드가 없는 사원도 출력될 수 있게 OUTER JOIN 사용
SELECT * FROM EMPLOYEE;     --              DEPT_CODE
SELECT * FROM DEPARTMENT;   --               DEPT_ID    LOCATION_ID
SELECT * FROM LOCATION;     --                          LOCAL_CODE

--  >> ANSI
SELECT E.EMP_NAME 사원명, 
        E.BONUS 보너스, 
        TO_CHAR(E.SALARY * 12, '999,999,999') 연봉,
        D.DEPT_TITLE 부서명, 
        L.LOCAL_NAME 근무지역명
FROM EMPLOYEE E
LEFT OUTER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
LEFT OUTER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
WHERE BONUS IS NOT NULL;

--  >> 오라클
SELECT E.EMP_NAME, 
        E.BONUS, E.SALARY * 12, 
        D.DEPT_TITLE, 
        L.LOCAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L
WHERE E.DEPT_CODE = D.DEPT_ID(+) 
        AND D.LOCATION_ID = L.LOCAL_CODE(+) 
        AND BONUS IS NOT NULL;

-- 4. 한국과 일본에서 근무하는 직원들의 
--      사원명, 부서명, 근무지역명, 근무국가명을 조회하세요.
SELECT * FROM EMPLOYEE;     --     DEPT_CODE
SELECT * FROM DEPARTMENT;   --     DEPT_ID    LOCATION_ID
SELECT * FROM LOCATION;     --                LOCAL_CODE    NATIONAL_CODE
SELECT * FROM NATIONAL;     --                              NATIONAL_CODE

--  >> ANSI
SELECT E.EMP_NAME, D.DEPT_TITLE, L.LOCAL_NAME, N.NATIONAL_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
--WHERE N.NATIONAL_NAME = '한국' OR N.NATIONAL_NAME = '일본';
WHERE N.NATIONAL_NAME IN('한국', '일본');

--  >> 오라클
SELECT E.EMP_NAME, D.DEPT_TITLE, L.LOCAL_NAME, N.NATIONAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N  
WHERE (E.DEPT_CODE = D.DEPT_ID) AND (D.LOCATION_ID = L.LOCAL_CODE) 
        AND (L.NATIONAL_CODE = N.NATIONAL_CODE)
--        AND (N.NATIONAL_NAME = '한국' OR N.NATIONAL_NAME = '일본');
        AND (N.NATIONAL_NAME IN('한국', '일본'));

-- 5. 각 부서별 평균 급여를 조회하여 부서명, 평균급여(정수처리)를 조회하세요.
--      단, 부서배치가 안된 사원들의 평균도 같이 나오게끔 해주세요. 
SELECT * FROM EMPLOYEE;     --     DEPT_CODE
SELECT * FROM DEPARTMENT;   --     DEPT_ID    

--  >> ANSI
SELECT NVL(DEPT_TITLE, '부서없음') 부서명, FLOOR(AVG(SALARY)) 급여평균
FROM EMPLOYEE E
LEFT OUTER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
GROUP BY NVL(DEPT_TITLE, '부서없음') 
ORDER BY NVL(DEPT_TITLE, '부서없음');

--  >> 오라클
SELECT DEPT_TITLE, ROUND(AVG(SALARY))
FROM EMPLOYEE E, DEPARTMENT D  
WHERE E.DEPT_CODE = D.DEPT_ID(+)
GROUP BY DEPT_TITLE;


