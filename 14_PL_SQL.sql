/*
    <PL/SQL>
        오라클 자체에 내장되어 있는 절차적언어(프로그래밍 언어)
        SQL문장 내에서 변수의 정의, 조건처리(IF), 반복처리(LOOP, FOR, WHILE) 등을 지원, SQL의 단점을 보완
        다수의 SQL 문을 한번에 실행 가능하다. 
        
        [PL/SQL의 구조]
            1) 선언부 (DECLARE SECTION)        : DECLARE로 시작, 변수나 상수를 선언 및 초기화하는 부분
            2) 실행부 (EXECUTABLE SECTION)     : BEGIN으로 시작, 제어문(조건문, 반복문) 등의 로직을 기술하는 부분
            3) 예외처리브 ( EXCEPTION SECTION)  : EXCEPTION으로 시작, 예외발생시 해결하기 위한 구문을 기술하는 부분
*/

-- 화면에 HELLO ORACLE 출력

-- PUT_LINE을 이용해서 화면에 구문을 출력하기 위해서 실행한다. ON으로 (한번만 실행하면 된다.)
SET SERVEROUTPUT ON;

BEGIN 
    DBMS_OUTPUT.PUT_LINE('HELLO ORACLE');
END;
/

------------------------------------------------------------------------
/*
     1) 선언부 (DECLARE SECTION)
        변수 및 상수 선언해 놓는 공간(초기화도 가능)
        일반타입변수, 래퍼런스타입변수, ROWTYPE 변수
        
    1-1) 일반타입변수 선언 및 초기화 
        [표현법]
            변수명(CONSTANT]자료형(크기)[:=값];
*/
DECLARE 
    EID NUMBER;
    ENAME VARCHAR2(30);
    PI CONSTANT NUMBER :=3.14;
BEGIN 
    EID := 888;
    ENAME := '배장남';
    
    DBMS_OUTPUT.PUT_LINE('EID : '||EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : '||ENAME);
    DBMS_OUTPUT.PUT_LINE('PI : '||PI);
END;
/

----------------------------------------------------------------
/*
    1-2) 레퍼런스 타입변수 선언 및 초기화 
        [표현법]
            변수명 테이블명.컬럼명%TYPE;
            (테이블명에 해당 테이블의 컬럼에 데이터타입을 참조해서 그 타입으로 변수를 지정하겠다.)
*/
DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
-- 사원명이 노옹철인 사원의 사번, 사원명, 급여정보를 각각 EID, ENAME, SAL 라는 변수에 대입한다. 
-- 주의할 점 (SELECT INTO를 이용해서 조회결과를 각 변수에 대입시키고자 한다면 반드시 한개의 행으로 조회되야 한다.
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO EID, ENAME, SAL
    FROM EMPLOYEE
--  WHERE EMP_NAME = '노옹철';
    WHERE EMP_NAME = '&NAME';
    -- &(앰퍼샌드) 기호는 대체변수(값을 입력)를 입력하기 위한 창이 뜨게 하는 구문
    
    DBMS_OUTPUT.PUT_LINE('EID : '||EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : '||ENAME);
    DBMS_OUTPUT.PUT_LINE('SAL : '||SAL);
END;
/

----------------------------실습문제 -----------------------
--레퍼런스타입 변수로 EID, ENAME, JCODE, DTITLE, SAL 를 선언하고
-- 각 자료형은 EMPLOYEE 테이블의 EMP_ID, EMP_NAME, JOB_CODE, SALARY 컬럼 타입
--            DEPARTMENT 테이블의 DEPT_TITLE 컬럼 타입 참조 
-- 사용자가 입력한 사번과 일치하는 사원을 조회 (사번, 사원명, 직급코드, 부서명, 급여)한 후 조회 결과를 각변수에 대입 후 출력

DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    JCODE EMPLOYEE.JOB_CODE%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;

BEGIN
    SELECT EMP_ID, EMP_NAME, JOB_CODE, DEPT_TITLE, SALARY
    INTO EID, ENAME, JCODE, DTITLE, SAL
    FROM EMPLOYEE E
    JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
    WHERE EMP_ID = '&사번';
                    -- ' ' 상관없다.
    DBMS_OUTPUT.PUT_LINE('EID : '||EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : '||ENAME);
    DBMS_OUTPUT.PUT_LINE('JCODE : '||JCODE);
    DBMS_OUTPUT.PUT_LINE('DTITLE : '||DTITLE);
    DBMS_OUTPUT.PUT_LINE('SAL : '||SAL);

END;
/
-----------------------------------------------------------
/*
    1-3) ROW타입 변수 선언 및 초기화 
*/

DECLARE 
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO E
    FROM EMPLOYEE
    WHERE EMP_NAME = '&사원명';
    
    DBMS_OUTPUT.PUT_LINE('사번 : '||E.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('이름 : '||E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('주민번호 : '||E.EMP_NO);
    DBMS_OUTPUT.PUT_LINE('급여 : '||E.SALARY);
END;
/

-------------------------------------------------------------------
/*
    2) 실행부 (EXECUTABLE SSECTION)
    2-1) 조건문
    
    IF 조건문 THEN 실행내용 END IF; (단일 IF문)
*/

-- 사번을 입력 받은 후 해당 사원의 사번, 이름, 급여, 보너스율을 출력하기 
-- 단, 보너스를 받지 않는 사원은 출력전에 '보너스를 지급받지 않는 사원입니다.' 출력

DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS, 0)
    INTO EID, ENAME, SAL, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    DBMS_OUTPUT.PUT_LINE('사번 : '|| EID);
    DBMS_OUTPUT.PUT_LINE('이름 : '|| ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : '|| SAL || '원');
    
    IF(BONUS = 0)
        THEN DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('보너스율 : ' || BONUS * 100 || '%');
END;
/

-- IF 조건식 THEN 실행내용 ELSE 실행내용 END IF;  (IF ~~ ELSE문)
-- 사번을 입력받아서 해당 사원의 사번, 이름, 부서명, 국가코드를 조회한 후 출력한다.
-- 단, 국가코드가 'KO'이면 국내팀, 그외는 해외팀으로 

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    NCODE LOCATION.NATIONAL_CODE%TYPE;
    TEAM VARCHAR2(20);

BEGIN
    SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, L.NATIONAL_CODE
    INTO EID, ENAME, DTITLE, NCODE
    FROM EMPLOYEE E, DEPARTMENT D, LOCATION L
    WHERE E.DEPT_CODE = D.DEPT_ID AND D.LOCATION_ID = L.LOCAL_CODE
            AND E.EMP_ID = '&사번';
            
    IF (NCODE = 'KO')
        THEN TEAM := '국내팀';
    ELSE 
        TEAM := '해외팀';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('사번 : '|| EID);
    DBMS_OUTPUT.PUT_LINE('이름 : '|| ENAME);
    DBMS_OUTPUT.PUT_LINE('부서명 : '|| DTITLE);
    DBMS_OUTPUT.PUT_LINE('소속 : '|| TEAM);
   
END;
/

-- IF 조건식1 THEN 실행내용1 ELSIF 조건식2 THEN 실행내용2 ELSE 실행내용 END IF;  (IF ~~ ELSE IF문)
DECLARE
    SCORE NUMBER;
    GRADE CHAR(1);
BEGIN
    SCORE :='&점수';
    
    IF (SCORE >= 90)
        THEN GRADE := 'A';
    ELSIF (SCORE >=80)
        THEN GRADE := 'B';
    ELSIF (SCORE >=70)
        THEN GRADE := 'C';
    ELSIF (SCORE >=60)
        THEN GRADE := 'D';
    ELSE 
        GRADE := 'F';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('당신의 점수는 ' || SCORE || '점이고, 학점은 '||GRADE||'학점입니다.');

END;
/

----------------실습문제 ---------------------
--사용자에게 입력받은 사원과 일치하는 사원의 급여 조회 후 (SAL변수에 대입)
-- 500만원 이상이면 '고급'
-- 300만원 이상이면 '중급'
-- 300 미만이면 '초급'
-- '해당 사원의 급여 등급은 XX입니다.'

DECLARE
    SAL EMPLOYEE.SALARY%TYPE;
    GRADE VARCHAR2(10);
BEGIN
    SELECT SALARY
    INTO SAL
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    IF (SAL >= 5000000) THEN GRADE := '고급';
    ELSIF (SAL >= 3000000) THEN GRADE := '중급';
    ELSE GRADE := '초급';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('해당 사원의 급여등급은 '|| GRADE || '입니다');
    
END;
/


-- 보너스
DECLARE
    SAL EMPLOYEE.SALARY%TYPE;
    GRADE VARCHAR2(20);
BEGIN
    SELECT SALARY
    INTO SAL
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    SELECT SAL_LEVEL
    INTO GRADE
    FROM SAL_GRADE
    WHERE SAL BETWEEN MIN_SAL AND MAX_SAL;
    
    
    DBMS_OUTPUT.PUT_LINE('해당 사원의 급여등급은 '|| GRADE || '입니다.');
    
END;
/

-- CASE 비교할 대상자 WHEN 동등비교할 값1 THEN 결과값1 WHEN 동등비교할 값2 THEN 결과값2 ELSE 결과값 END;
-- JOIN 하지 않고 DEPT_TITLE 출력하는 법
-- 사번 입력 받은 후에 사원의 모든 컬럼 데이터를 EMP에 대입하고 DEPT_CODE에 따라 알맞는 부서를 출력하세요.

DECLARE 
    EMP EMPLOYEE%ROWTYPE;
    DNAME VARCHAR2(30);
BEGIN 
    SELECT *
    INTO EMP
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DNAME := CASE EMP.DEPT_CODE 
            WHEN 'D1' THEN '인사관리부'
            WHEN 'D2' THEN '회계관리부'
            WHEN 'D3' THEN '마케팅부'
            WHEN 'D4' THEN '국내영업부'
            WHEN 'D5' THEN '해외영업1부'
            WHEN 'D6' THEN '해외영업2부'
            WHEN 'D7' THEN '해외영업3부'
            WHEN 'D8' THEN '기술지원부'
--           WHEN 'D9' THEN '총무부'
            ELSE '총무부'
        END;
        
    DBMS_OUTPUT.PUT_LINE('사번 : '|| EMP.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('이름 : '|| EMP.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('부서코드 : '|| EMP.DEPT_CODE);
    DBMS_OUTPUT.PUT_LINE('부서명 : '|| DNAME);

END;
/

---------------------------------------------------------------
/*
    2-2) 반복문
    
    BASIC LOOP
        [표현법]
            LOOP 
                반복적으로 실행할 구문
           
                [반복문을 빠져나갈 조건문작성]
                    1) IF 조건식 THEN EXIT; END IF;
                    2) EXIT WHEN 조건식;
            END LOOP;
*/

-- 1 ~ 5까지 순차적으로 1씩 증가하는 값을 출력
DECLARE 
    N NUMBER := 1;
BEGIN 
    LOOP 
        DBMS_OUTPUT.PUT_LINE(N);
        
        N := N + 1;
        
--        IF N > 5 THEN EXIT;   END IF;
        EXIT WHEN N > 5; 
    END LOOP;
END;
/

/*
    WHILE LOOP
        [표현식]
            WHILE 반복문이 수행될 조건
            LOOP
                반복적으로 실행할 구문;
            END LOOP;
*/

-- WHILE 문으로 구구단 (2 ~ 9단) 출력
DECLARE 
    RESULT NUMBER;
    DAN NUMBER := 2;
    SU NUMBER;

BEGIN
    WHILE DAN <= 9
    LOOP 
        SU := 1;
        WHILE SU <=9
        LOOP
            RESULT := DAN * SU;           
            DBMS_OUTPUT.PUT_LINE(DAN || ' X ' || SU || ' = ' || RESULT);           
            SU := SU + 1;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');           
        DAN := DAN + 1;
    END LOOP;
END;
/

/*
    FOR LOOP
        [표현식]
            FOR 변수 IN [REVERSE] 초기값..최종값
            LOOP 
                반복적으로 실행할 구문;
*/
-- 1 ~ 5까지 
BEGIN
    FOR N IN 1..5 
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
    END LOOP;
END;
/

-- 역순으로 
BEGIN
    FOR N IN REVERSE 1..5 
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
    END LOOP;
END;
/

--- 중첩 FOR 문 사용해서 구구단 (2 ~ 9) 출력하기. 단, 짝수단만 출력
DECLARE 
    RESULT NUMBER;
BEGIN
    FOR DAN IN 2..9 
    LOOP
        IF (MOD(DAN, 2) = 0)
            THEN
                FOR SU IN 1..9
                LOOP
                    RESULT := DAN * SU;           
                    DBMS_OUTPUT.PUT_LINE(DAN || ' X ' || SU || ' = ' || RESULT);                  
                END LOOP;
                DBMS_OUTPUT.PUT_LINE('');
        END IF;
    END LOOP;
END;
/

--보너스 :  반복문을 이용한 데이터 삽입  / SELECT 구문뿐 아니라 DML 구문 사용 예
-- COMMIT, ROLLBACK, SAVEPOINT 등도 사용 가능

CREATE TABLE TEST2 (
    NUM NUMBER,
    TODAY DATE
);

TRUNCATE TABLE TEST2;
SELECT * FROM TEST2;

BEGIN
    FOR I IN 1..10
    LOOP
        INSERT INTO TEST2 VALUES(I, SYSDATE);
        IF (MOD(I, 2) = 0)
            THEN COMMIT;
        ELSE
            ROLLBACK;
        END IF;
    END LOOP;
END;
/

-----------------------------------------------------------------------
/*
     3) 예외처리브 ( EXCEPTION SECTION)  : EXCEPTION으로 시작, 예외발생시 해결하기 위한 구문을 기술하는 부분
            예외 (EXCEPTION) : 실행 중 발생하는 오류
            
            [표현식]
                EXCEPTION 
                    WHEN 예외명1 THEN 예외처리구문1;
                    WHEN 예외명1 THEN 예외처리구문1;
                    ...
                    WHEN OTHERS THEN 예외처리구문;
                    
                * 오라클에 미리 정의되어 있는 예외(시스템 예외)
                    - NO_DATA_FOUND : SELECT 문 수행 결과 한 행도 없을 경우
                    - TOO_MANY-ROWS : 한 행이 리턴되야 하는데 SELECT문에서 여러행을 반환할 때
                    - ZERO_DIVIDE : 0으로 나눌 때
                    - DUP_VAL_ON_INDEX ; UNIQUE 제약조건을 가진 컬럼에 중복된 데이터가 INSERT 될 때
*/

-- 사용자가 입력한 수로 나눗셈 연산한 결과 출력 
DECLARE 
    RESULT NUMBER;
BEGIN 
    RESULT := 10 / &숫자;
    DBMS_OUTPUT.PUT_LINE('결과 : '|| RESULT);
EXCEPTION 
    WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('나누기 연산시 0으로 나눌 수 없습니다.');
END;
/

-- UNIQUE 제약조건 위배시
BEGIN 
    UPDATE EMPLOYEE
    SET EMP_ID = 200
    WHERE EMP_NAME = '&이름';
EXCEPTION 
    WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('이미 존재하는 사번입니다.');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다.');
END;
/
-- UNIQUE 제약조건 위배시
BEGIN
    UPDATE EMPLOYEE
    SET EMP_ID = 200
    WHERE EMP_NAME = '&이름';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('이미 존재하는 사번입니다.');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다.');
END;
/
-- TOO_MANY_ROWS : 한 행이 리턴되야 하는데 SELECT문에서 여러행을 반환할 때
DECLARE 
    EID EMPLOYEE.EMPID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME
    INTO EID, ENAME
    FROM EMPLOYEE
    WHERE MANAGER_ID = &사수번호;
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('조회 결과가 없습니다.');
    WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('너무 많은 행이 조회되었습니다.');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다.');
END;
/

-- 너무 많은 행이 조회가 되었을 때
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME
    INTO EID, ENAME
    FROM EMPLOYEE
    WHERE MANAGER_ID = &사수번호;
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('조회 결과가 없습니다.');
    WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('너무 많은 행이 조회되었습니다.');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다.');
END;
/

