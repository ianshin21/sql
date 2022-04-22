/*
    <함수> 
        컬럼값을 읽어서 계산한 결과를 반환함 
            - 단일행 함수 : N개의 값을 읽어서 N개의 결과를 리턴 (매 행 함수 실행 결과 반환)
            - 그룹 함수 : N개의 값을 읽어서 1개의 결과를 리턴 (하나의 그룹별로 함수 실행 결과 반환)
            - SELECT 절에 단일행 함수와 그룹 함수를 함께 사용하지 못한다. (결과 행의 개수가 다르기 때문)
            - 함수를 기술 할 수 있는 위치는 SELECT절, WHERE절, ORDER절, GROUP BY 절, HAVING절
*/

--------------------------- 단일행 함수 -----------------------
/*
    <문자 관련 함수>
        1). LENGTH / LENGTHB
            LENGTH(컬럼|'문자값') : 글자수 반환
            LENGTHB(컬럼|'문자값') : 글자의 바이트 수
    
        * DUAL 테이블
            - SYS 사용자가 소유하는 테이블
            - SYS 사용자가 소유하지만 어느 사용자나 접근이 가능하다.
            - 한 행, 한 컬럼을 가지고 있는 더미(DUMMY) 테이블이다
            - 사용자가 함수(계산)을 사용할 때 임시로 사용하는 테이블이다.
*/

SELECT LENGTH('오라클'), LENGTHB('오라클')
FROM DUAL;

SELECT EMP_NAME, LENGTH(EMP_NAME), LENGTHB(EMP_NAME),
        EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL)
FROM EMPLOYEE;

/*
        2) INSTR
            지정한 위치부터 숫자번째로 나타내는 문자의 시작 위치 반환
            [표현법]
                INSTR(컬럼명|'문자값', '문자',[찾을 위치의 시작값, [순번]])
                
                찾을 위치의 시작값 
                    1 : 앞에서부터 찾는다.
                    -1 : 뒤에서부터 찾는다
*/
SELECT INSTR('AABAACAABBAA', 'B') FROM DUAL;   --3번째 자리 B
SELECT INSTR('AABAACAABBAA', 'B', 1, 1) FROM DUAL;  -- 3번째 자리 B
SELECT INSTR('AABAACAABBAA', 'B', -1) FROM DUAL;    -- 10번째 자리 B
SELECT INSTR('AABAACAABBAA', 'B', 1, 2) FROM DUAL;  -- 9번째 자리 B
SELECT INSTR('AABAACAABBAA', 'B', -1, 3) FROM DUAL;  -- 3번째 자리 B

/* 
    3) LPAD / RPAD 
        [표현법] 
            LPAD /RPAD(컬럼|'문자값', 최종적으로 반환할 문자의 길이(바이트), [덧붙이고자 하는 문자])
            
        - 제시한 컬럼|'문자값'에 임의의 문자를 왼쪽 또는 오른쪽에 덧붙여 최종 N길이 만큼의 문자열을 반환
        - 문자에 대해 통일감있게 표시하고자 할 때 사용한다.
*/
-- 20만큼의 길이 중 EMAIL 값은 오른쪽으로 정렬하고 공백을 왼쪽으로 채운다. (숫자값이 모자라면 문자열이 잘려나감)
SELECT LPAD(EMAIL, 20)
FROM EMPLOYEE;

SELECT LPAD(EMAIL, 20, '#')
FROM EMPLOYEE;

-- 20만큼의 길이 중 EMAIL 값은 왼쪽으로 정렬하고 공백을 #으로 채운다. (숫자값이 모자라면 문자열이 잘려나감)
SELECT RPAD(EMAIL, 20, '#')
FROM EMPLOYEE;

SELECT RPAD('991201-1', 14, '#') FROM DUAL;

-- 주민등록번호 첫번째 자리부터 성별까지를 추출한 결과 값에 오른쪽에 * 문자 채워서 최종적으로 14글자 반환
SELECT EMP_NAME, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*')
FROM EMPLOYEE;

--직원 정보를 저장한 EMP 테이블에서 사원명(ENAME)과 주민번호(ENO)를 함수를 사용하여 아래의 요구대로 조회되도록 
--SELECT 구문을 기술하시오. (25점)
--'- 주민번호는 '891224-1******' 의 형식으로 출력되게 하시오
-- 조회결과에 컬럼명은 별칭 처리하시오. => ENAME 사원명, ENO 주민번호
SELECT EMP_NAME AS 사원명, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*') AS 주민번호
FROM EMPLOYEE;



/*
    4) LTRIM / RTRIM 
        [표현법]
            LTRIM/RTIM(컬럼|'문자값', [제거하고자 하는 문자값])
            
        문자열의 왼쪽 혹은 오른쪽에서 제거하고자 하는 문자들을 찾아서 제거한 나머지를 반환한다. 
*/

SELECT LTRIM('    K H') FROM DUAL;  --제거하고자 하는 문자 생략시 기본값으로 공백 제거
SELECT LTRIM('000123456', '0') FROM DUAL;
SELECT LTRIM('123123KH', '123') FROM DUAL;
SELECT LTRIM('123123KH123', '123') FROM DUAL;
SELECT RTRIM('KH    ') FROM DUAL; 
SELECT RTRIM('0012300456000', '0') FROM DUAL;

/*
    5) TRIM 
        문자열 앞/뒤/양쪽에 있는 지정한 문자를 제거한 나머지를 반환
        
        [표현법]
            TRIM([[LEADING|TRAILING|BOTH] 제거하고자 하는 문자 FROM] 컬럼|'문자값')
*/
SELECT TRIM('    KH   ') FROM DUAL;
SELECT TRIM('Z' FROM 'ZZZKHZZZ') FROM DUAL;

SELECT TRIM(LEADING 'Z' FROM 'ZZZKHZZZ') FROM DUAL;
SELECT TRIM(TRAILING 'Z' FROM 'ZZZKHZZZ') FROM DUAL;
SELECT TRIM(BOTH 'Z' FROM 'ZZZKHZZZ') FROM DUAL;

/*
    6) SUBSTR
        문자열에서 지정한 위치부터 지정한 개수 만큼의 문자열을 추출해서 반환한다.
        [표현법]
            SUBSTR(컬럼|'문자값', POSITION, [LENGTH])
*/
SELECT SUBSTR('SHOWMETHEMONEY', 7) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', 5, 2) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', -8, 3) FROM DUAL;
SELECT SUBSTR('쇼우 미 더 머니', 2, 5) FROM DUAL;

-- EMPLOYEE 테이블에서 주민번호에서 성별 나타내는 부분만 잘라보기
SELECT EMP_NAME, SUBSTR(EMP_NO, 8, 1) AS "성별코드"
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 여자사원만 조회
SELECT EMP_NAME, SUBSTR(EMP_NO, 8, 1) AS "성별"  
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '2';

-- EMPLOYEE 테이블에서 남자사원만 조회
SELECT EMP_NAME, '남' AS "성별"  
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '1';

-- EMPLOYEE 테이블에서 사원명, 이메일, 아이디(이메일에서 '@' 앞의 문자값만 출력)를 조회
SELECT EMP_NAME, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@') - 1)
FROM EMPLOYEE;

/*
    7) LOWER / UPPER / INITCAP
        [표현법] 
            LOWER/UPPER/INITCAP(컬럼|'문자값')
        LOWER : 모두 소문자로
        UPPER : 모두 대문자로
        INITCAP : 단어 앞글자마다 대문자로
*/
SELECT LOWER('Welcome To My World!') FROM DUAL;
SELECT UPPER('Welcome To My World!') FROM DUAL;
SELECT INITCAP('welcome to my world!') FROM DUAL;

/*
    8) CONCAT
        [표현법] 
            CONCAT(컬럼|'문자값', 컬럼|'문자값')
        
        문자열 두 개를 전달받아 하나로 합친 후 반환한다. 
*/

SELECT CONCAT('가나다라', ' ABCD') FROM DUAL;
SELECT '가나다라'||' ABCD' FROM DUAL;  -- 연결 연산자와 동일한 내용 수행

SELECT CONCAT('가나다라', ' ABCD') FROM DUAL;   -- 문자열 두 개만 연결 가능
SELECT '가나다라'||' ABCD'||'EFG' FROM DUAL;  -- 연결 연산자와 동일한 내용 수행, 여러 문자열 연결 가능

SELECT CONCAT(EMP_ID, EMP_NAME)
FROM EMPLOYEE;

/* 
    9) REPLACE 
        [표현법] 
            REPLACE(컬럼|'문자값', 변경하려고 하는 문자STR1, 새로운 문자STR2)
            
        컬럼 또는 문자값에서 기존 문자를 새로운 문자로 변경
*/
SELECT REPLACE('서울시 강남구 역삼동', '역삼동', '삼성동') FROM DUAL;

-- EMPLOYEE 테이블에서 이메일을 읽어와서 kh.or.kr을 gmail.com으로 변경해서 조회
SELECT EMP_NAME, REPLACE(EMAIL, 'kh.or.kr', 'gmail.com')
FROM EMPLOYEE;

-----------------------------------------------------------------
/*
            <숫자 관련 함수>
    1) ABS 
        절대값을 구하는 함수 
        [표현법]
            ABS(NUMBER]
*/
SELECT ABS(-10.9) FROM DUAL;
SELECT ABS(10.9) FROM DUAL;

/*
    2) MOD 
        두 수를 나눈 나머지를 반환해 주는 함수 (자바의 % 연산)
        [표현법] 
            MOD(NUMBER, NUMBER)
*/
SELECT 10 + 3, 10 - 3, 10 * 3, 10 / 3 FROM DUAL;
SELECT MOD (-8, 3) FROM DUAL;
SELECT MOD (10, -3) FROM DUAL;

/*
    3) ROUND
*/


/*
    4) CEIL
        소수점 아래를 올림하는 함수
    
*/
SELECT CEIL(123.456) FROM DUAL;      -- 포지션 값 주면 애러
SELECT CEIL(-10.6) FROM DUAL;
/*
    5) FLOOR 
        소수점 아래를 버림하는 함수
            [표현법]
                FLOOR(NUMBR)
*/
SELECT FLOOR(123.456) FROM DUAL;        -- 포지션 값 주면 애러
SELECT FLOOR(123.756) FROM DUAL;        -- 포지션 값 주면 애러

/*
    6) TRUNC
        [표현법
        위치를 지정하여 버림이 가능한 함수 
        위치 : 기본 0(.), 양수(소수점 기준으로 오른쪽)와 음수(소수점 기준으로 왼쪽)로 입력 가능
*/
SELECT TRUNC(123.456) FROM DUAL;
SELECT TRUNC(123.456, 1) FROM DUAL;
SELECT TRUNC(123.456, -1) FROM DUAL;

----------------------------------------------------------------

/*
    <날짜 관련 함수>
    
    1) SYSDATE
        시스템의 현재 날짜 반환
*/
SELECT SYSDATE FROM DUAL;

/*
    2) MONTHS_BETWEEN
        입력받는 두 날짜 사이의 개월 수를 반환
        [표현법] 
            MONTH_BETWEEN(DATE1, DATE2)
*/
--- EMPLOYEE 테이블에서 직원명, 입사일, 근무 개월 수
SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) || '개월차' AS "근무 개월 수"
FROM EMPLOYEE;

/*
    3) ADD_MONTHS
        특정 날짜에 입력받는 숫자만큼의 개월 수를 더한 날짜를 리턴
        [표현법]
            ADD_MONTHS(DATE, NUMBER)
*/
SELECT ADD_MONTHS(SYSDATE, 6) FROM DUAL;

--- EMPLOYEE 테이블에서 직원명, 입사일, 입사 후 6개월이 된 날짜 조회
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 6) 
FROM EMPLOYEE;

-- 시험문제에서 날짜 정렬 확인
SELECT EMP_NAME, HIRE_DATE 
FROM EMPLOYEE
ORDER BY HIRE_DATE DESC;

/*
    4) NEXT_DAY
        특정 날짜에서 구하려는 요일 중 가장 가까운 요일의 날짜 반환
        [표현법]
            NEXT_DAY(DATE, 요일(문자|숫자)
*/
--- 현재 날짜에서 가장 가까운 월요일 조회
SELECT SYSDATE, NEXT_DAY(SYSDATE, '월요일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '금') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 1) FROM DUAL;
-- SELECT SYSDATE, NEXT_DAY(SYSDATE, 'MONDAY') FROM DUAL;  -- 현재 언어가 한국어라서 에러
-- ALTER SESSION SET NLS_LANGUAGE = AMERICAN;   -- 언어 변경
ALTER SESSION SET NLS_LANGUAGE = KOREAN;   -- 언어 변경

/*
    5) LAST_DAY
        해당하는 월의 마지막 날짜를 반환
        [표현법]
            LAST_DAY(DATE)
*/
SELECT LAST_DAY(SYSDATE) FROM DUAL;

--- EMPLOYEE 테이블에서 직원명, 입사일, 입사월의 마지막 날짜 조회
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE)
FROM EMPLOYEE;

/*
    6) EXTRACT 
        특정 날짜에서 년도, 월, 일 정보를 추출 반환
        [표현법]
            EXTRACT(YEAR|MONTH|DAY FROM DATE)
*/
--- EMPLOYEE 테이블에서 직원명, 입사년도, 입사월, 입사일 조회
SELECT EMP_NAME, 
        EXTRACT(YEAR FROM HIRE_DATE) AS "입사년도",
        EXTRACT(MONTH FROM HIRE_DATE) AS "입사월",
        EXTRACT(DAY FROM HIRE_DATE) AS "입사일"
FROM EMPLOYEE
ORDER BY "입사년도", 3,  EXTRACT(DAY FROM HIRE_DATE);

-- 날짜 포멧 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH:MI:SS';
ALTER SESSION SET NLS_DATE_FORMAT = 'YY/MM/DD';

SELECT SYSDATE FROM DUAL;

---------------------------------------------------------------------------
/* 
        <형변환 함수>
    
    1) TO_CHAR
        날짜형 또는 숫자형 데이터를 문자 타입으로 변환해서 반환하는 함수
        [표현법]
            TO_CHAR(날짜|숫자, [포멧])
*/
--- 숫자 -> 문자
SELECT TO_CHAR(1234) FROM DUAL;
SELECT TO_CHAR(1234, '999999') FROM DUAL;  -- 6칸 공간 확보하고 오른쪽 정렬, 빈칸은 공백
SELECT TO_CHAR(1234, '000000') FROM DUAL;   -- 6칸 공간 확보하고 오른쪽 정렬, 빈칸은 0
SELECT TO_CHAR(1234, 'L000000') FROM DUAL;   -- 6칸 공간 확보하고 오른쪽 정렬, 빈칸은 0, 앞에 '원' 표시
SELECT TO_CHAR(1234, 'L') FROM DUAL;   
SELECT TO_CHAR(1234, '$999999') FROM DUAL;   
SELECT TO_CHAR(1234, 'L999,999') FROM DUAL;   

--- --- EMPLOYEE 테이블에서 직원명 급여 조회 
SELECT EMP_NAME, TO_CHAR(SALARY, 'L999,999,999') "급여정보"
FROM EMPLOYEE
ORDER BY "급여정보" DESC;

---날짜 -> 문자
SELECT SYSDATE FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'AM HH:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'PM HH24:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'MON DY YYYY') FROM DUAL;

--- EMPLOYEE 테이블에서 직원명, 입사일 조회
SELECT EMP_NAME, TO_CHAR(HIRE_DATE, 'YYYY"년" MM"월" DD"일" (DY)') AS 입사일
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE
FROM EMPLOYEE;


--문자열 데이터 '190505' 를 '2019년 5월 5일' 로 표현될 수 있도록 
-- 형변환 함수들을 사용하여 SELECT 구문을 작성하시오. (25점)
SELECT TO_CHAR(TO_DATE('190505', 'YYMMDD'), 'YYYY"년" FMMM"월" DD"일"') FROM DUAL;



--- 년도 포멧
-- 년도에 관련된 포멧문자는 'Y' 'R'이 있다.
-- YY는 무조건 현재 세기를 반영
-- RR는 50미만이면 현재 세기를 반영, 50이상이면 이전 세기 반영
-- 20 18 90 --> YY  2020, 2018, 2090
-- 20 18 90 --> RR  2020, 2018, 1990

SELECT TO_CHAR(SYSDATE, 'YYYY'),
        TO_CHAR(SYSDATE, 'RRRR'),
        TO_CHAR(SYSDATE, 'YY'),
        TO_CHAR(SYSDATE, 'RR'),
        TO_CHAR(SYSDATE, 'YEAR')
FROM DUAL;
        

--- 월에 대한 포멧
SELECT TO_CHAR(SYSDATE, 'MM'),
        TO_CHAR(SYSDATE, 'MON'),
        TO_CHAR(SYSDATE, 'MONTH'),
        TO_CHAR(SYSDATE, 'RM')          --로마 기호로
FROM DUAL;

--- 일에 대한 포멧
SELECT TO_CHAR(SYSDATE, 'DDD'),   -- 1년을 기준으로 몇일째
        TO_CHAR(SYSDATE, 'DD'),   -- 달을 지준으로
        TO_CHAR(SYSDATE, 'D')     -- 주를 기준으로
FROM DUAL;

--- 요일에 대한 포멧
SELECT TO_CHAR(SYSDATE, 'DY'),
        TO_CHAR(SYSDATE, 'DAY')
FROM DUAL;


/* 
    2) TO_DATE
        숫자형 똔느 문자형 데이터를 날짜 타입으로 변환해서 반환하는 함수
        [표현식]
            TO_DATE(숫자|문자, [포멧])
*/
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
ALTER SESSION SET NLS_DATE_FORMAT = 'YY/MM/DD';

-- 숫자 -> 날짜
SELECT TO_DATE(20201111) FROM DUAL;
SELECT TO_DATE(20201111222530) FROM DUAL;

-- 문자 -> 날짜
SELECT TO_DATE('20201111') FROM DUAL;
SELECT TO_DATE('20201111 222530') FROM DUAL;
SELECT TO_DATE('20201111', 'YYYYMMDD') FROM DUAL;
SELECT TO_DATE('20201111 222530', 'YYYYMMDD HH24MISS') FROM DUAL;

-- YY와 RR 비교
SELECT TO_DATE('140630', 'YYMMDD') FROM DUAL;
SELECT TO_DATE('980630', 'YYMMDD') FROM DUAL;   --YY는 무조건 현재 세기

SELECT TO_DATE('140630', 'YYMMDD') FROM DUAL;
SELECT TO_DATE('980630', 'RRMMDD') FROM DUAL;   -- RR는 50미만이면 현재 세기를 반영, 50이상이면 이전 세기 반영

--- EMPLOYEE 테이블에서 1998년 1월 1일 이후에 입사한 사원의 사번, 이름, 입사일 조회
SELECT EMP_NAME, EMP_ID, HIRE_DATE
FROM EMPLOYEE
WHERE HIRE_DATE > TO_DATE('980101', 'RRMMDD')
-- WHERE HIRE_DATE > TO_DATE('19980101', 'YYYYMMDD')
--WHERE HIRE_DATE > '19980101'
ORDER BY HIRE_DATE;


/*
    3) TO_NUMBER
        문자형 데이터를 숫자타입으로 변환해서 반환하는 함수
        [표현법]
            TO_NUMBER('문자값' [표멧]
*/
SELECT TO_NUMBER('0123456789') FROM DUAL;   
-- SELECT TO_NUMBER('0123456789A') FROM DUAL;    -- 숫자 아닌 값이 있으면 에러

SELECT '123' + '456' FROM DUAL;     -- 자동 형변환 후 숫자로 계산, 숫자 아닌 값이 있으면 에러

--- EMPLOYEE 테이블에서 사원의 사번이 210보다 큰 사원의 모든 컬럼 조회
SELECT *
FROM EMPLOYEE
WHERE EMP_ID > 210;

SELECT '10,000,000' - '500,000' FROM DUAL;           -- 숫자 아닌 값 ','이 있으면 에러
SELECT TO_NUMBER('10,000,000', '999,999,999') - TO_NUMBER('500,000', '999,999') FROM DUAL; 

-------------------------------------------------------------------------------
/*
             <NULL 처리 함수>
    1) NVL
        NULL로 되어 있는 컬럼의 값을 인자로 지정한 값으로 변경하여 반환하는 함수
        [표현법]
            NVL(컬럼명, 컬럼값이 NULL일 경우 반환할 결과값)
            
    2) NVL2
        [표현법]
            NVL2(컬럼명, 바꿀값1, 바꿀값2)
            컬럼값이 존재하면 바꿀값1로, 컬럼값이 NULL이면 바꿀값2로 변경
            
    3) NULLIF
        [표현법] 
            NULLIF(비교대상1, 비교대상2)
            두 개의 값이 동일하면 NULL 반환, 두 개의 값이 동일하지 않으면 비교대상1 반환
*/
-- EMPLOYEE 테이블에서 사원명, BONUS 조회
SELECT EMP_NAME, NVL(BONUS, 0)
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 사원명, BONUS, BONUS가 포함된 연봉 조회
SELECT EMP_NAME, NVL(BONUS,0), (SALARY + SALARY * NVL(BONUS, 0)) * 12
--SELECT EMP_NAME, NVL(BONUS,0), (SALARY + SALARY * BONUS) * 12
FROM EMPLOYEE;

SELECT EMP_NAME, NVL(BONUS, 0), NVL2(BONUS, 0.1, 0), SALARY,
        NVL2(BONUS, (SALARY + (SALARY * BONUS)) * 12, SALARY * 12) AS 연봉
FROM EMPLOYEE;

SELECT NULLIF('123', '123') FROM DUAL;
SELECT NULLIF('123', '456') FROM DUAL;


------------------------------------------------------------------------------
/*
            <선택 함수>
        여러가지 경우에 선택을 할 수 있는 기능 제공
        
    1) DECODE
        [표현법]
            DECODE(컬럼명|계산식, 조건값1, 결과값1, 조건값2, 결과값2, ......, 결과값)
            
        비교하고자 하는 값이 조건값과 일치할 경우 그에 해당하는 결과값을 반환해 주는 함수 
*/

--- 사원, 사워명, 주민번호, 성별
SELECT EMP_NAME, EMP_ID, EMP_NO,
        DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남자', '2', '여자', '누구?') AS "성별"
FROM EMPLOYEE;

--직원의 급여를 인상하고자 한다
--직급코드가 J7인 직원은 급여의 8%를 인상하고,
--직급코드가 J6인 직원은 급여의 7%를 인상하고,
--직급코드가 J5인 직원은 급여의 5%를 인상한다.
--그 외 직급의 직원은 3%만 인상한다.
--직원 테이블(EMP)에서 직원명(EMPNAME), 직급코드(JOBCODE), 급여(SALARY), 인상급여(위 조건)을
--조회하세요(단, DECODE를 이용해서 출력하시오.)
SELECT EMP_NAME AS 직원명, JOB_CODE AS 직급코드, SALARY AS 급여,
       DECODE(JOB_CODE, 'J7', SALARY * 1.08,
                        'J6', SALARY * 1.07,
                        'J5', SALARY * 1.05,
                        SALARY * 1.03
            ) AS 인상급여 
FROM EMPLOYEE;



--- 실습문제 
-- 직급코드 J7인 사원은 급여를 10% 인상
-- 직급코드 J6인 사원은 급여를 15% 인상
-- 직급코드 J5인 사원은 급여를 20% 인상
--  그외의 사원은 급여 5%만 인상
-- 사원명, 직급코드, 기존 급여, 인상된 급여

SELECT EMP_NAME AS "사원명", JOB_CODE AS "직급코드", SALARY AS "기존급여",
       DECODE(JOB_CODE, 'J7', SALARY * 1.1,
                        'J6', SALARY * 1.15,
                        'J5', SALARY * 1.2,
                        SALARY * 1.05
            ) AS "인상급여" 
FROM EMPLOYEE;



/*
    2) CASE 
        [표현식]
            CASE WHEN 조건식1 THEN 결과값1
            CASE WHEN 조건식2 THEN 결과값2
                ELSE 결과값
            END
*/

SELECT EMP_NAME, EMP_ID, EMP_NO,
        CASE WHEN SUBSTR(EMP_NO, 8, 1) = '1' THEN '남자'
            WHEN SUBSTR(EMP_NO, 8, 1) = '2' THEN '여자'
            ELSE '누구?'
        END AS "성별"
FROM EMPLOYEE;

--- 사원명, 급여, 급여등급(1~4 등급) 조회   * 큰 값이 맨 위에 있어야 함 *
SELECT EMP_NAME, SALARY,
        CASE WHEN SALARY > 5000000 THEN '1등급'
            WHEN SALARY > 3500000 THEN '2등급'
            WHEN SALARY > 2000000 THEN '3등급'
            ELSE '4등급'
        END AS "급여등급"
FROM EMPLOYEE
ORDER BY "급여등급", SALARY DESC;

---------------------------------------------------------------
/*
            <그룹 함수>
    
    1) SUM 
        [표현법] 
            SUM(숫자타입컬럼)
        해당 컬럼 값들의 총 합계를 반환하는 함수    
*/

--- EMPLOYEE 테이블의 전사원의 총 급여합
SELECT SUM(SALARY)
FROM EMPLOYEE;

--- 여자 사원의 총급여합
SELECT SUM(SALARY)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '2';

--- 부서코드가 D5인 사원들의 총 연봉합 
SELECT SUM(SALARY * 12)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

/*
    2) AVG 
        [표현법]
            AVG(숫자타입컬럼)
        해당 컬럼값들의 평균값을 구해서 반환하는 함수
*/
--- EMPLOYEE 테이블에서 전 사원의 급여 평균
SELECT FLOOR(AVG(SALARY))
FROM EMPLOYEE;

/*
    3) MIN /MAX 
        [표현법] 
            MIN/MAX[모든 타입컬럼]
        MIN : 해당 컬럼값들 중 가장 작은 값 반환
        MAX : 해당 컬럼값들 중 가장 큰 값을 반환
*/

SELECT MIN(EMP_NAME), MIN(EMAIL), MIN(SALARY), MIN(HIRE_DATE)
FROM EMPLOYEE;

SELECT MAX(EMP_NAME), MAX(EMAIL), MAX(SALARY), MAX(HIRE_DATE)
FROM EMPLOYEE;

/*
    4) COUNT 
        컬럼 또는 행의 개수를 세서 반환하는 함수
        [표현법]
            COUNT(*|컬럼명|DISTICT 컬럼명)
        COUNT(*) : 조회 결과에 해당하는 모든 행 개수를 반환
        COUNT(컬럼명) : 제시한 컬럼값이 NULL이 아닌 행의 개수를 반환
        COUNT(DISTINCT 컬럼명) : 해당 컬럼값의 중복을 제거한 후 행의 개수를 반환
*/

--- 전체 사원수
SELECT COUNT(*)
FROM EMPLOYEE;

SELECT COUNT(1)         -- 리터럴이 모든 행에 적용되기 때문에 1이 적용된 모든 행의 개수 반환
FROM EMPLOYEE;

SELECT COUNT('1')
FROM EMPLOYEE;

SELECT COUNT(NULL)      -- NULL이 아닌 행의 개수?
FROM EMPLOYEE;


--- 부서 배치가 된 사원의 수 
SELECT COUNT(DEPT_CODE)
FROM EMPLOYEE;

-- 사원이 배치된 부서의 수 
SELECT COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;

--- 현재 사원들이 분포되어 있는 직급의 수
SELECT COUNT(DISTINCT JOB_CODE)  
FROM EMPLOYEE;




