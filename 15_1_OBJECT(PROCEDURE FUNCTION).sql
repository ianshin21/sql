/*
    <PROCEDURE>
        PL/SQL문을 저장하는 객체
        필요할 때마다 복잡한 구문을 다시 입력할 필요없이 간단하게 호출해서 실행 결과를 얻을 수 있다.
        특정 로직을 처리하기만 하고 결과 값을 반환하지는 않는다.
        
        [표현법]
            CREATE OR REPLACE PROCEDURE 프로시저명
                (매개변수명1 [IN|OUT|IN OUT] 데이터타입 [:=DEFAULT 값],
                 매개변수명2 [IN|OUT|IN OUT] 데이터타입 [:=DEFAULT 값],
                 ...)
            IS 
                선언부
            BEGIN 
                실행부
            [EXCEPTION
                예외처리부]
            END{프로시저명];
            /
            
        [실행방법]
            EXECUTE(EXEC) 프로시저명;
*/

-- 테스트용 테이블 생성
CREATE TABLE EMP_DUP
AS SELECT * FROM EMPLOYEE;

SELECT * FROM EMP_DUP;

-- 테스트 테이블의 데이터를 삭제하는 프로시저 (DEL_ALL_EMP)만들기 
CREATE OR REPLACE PROCEDURE DEL_ALL_EMP
IS
BEGIN 
    DELETE FROM EMP_DUP;    --DML 작성 가능
    COMMIT;     -- TCL 작성 가능
END;
/

SELECT * FROM USER_SOURCE;

EXECUTE DEL_ALL_EMP;

-------------------------------------------------------------------
-- 1) 매개변수가 있는 프로시저
--      프러시저 실행시 매개변수로 인자값을 전달해줘야 한다. 
CREATE OR REPLACE PROCEDURE DEL_EMP_ID
    (P_EMP_ID EMPLOYEE.EMP_ID%TYPE)
IS
BEGIN 
    DELETE FROM EMPLOYEE
    WHERE EMP_ID = P_EMP_ID;
END;
/

SELECT * FROM EMPLOYEE;

-- 매개변수가 있는 프로시저 실행
--EXEC DEL_EMP_ID;        -- 매개변수 없어서 에러 발생
EXEC DEL_EMP_ID('900');

EXEC DEL_EMP_ID;    -- 프로시저에 디풀트로 200 번 넣고 (&TYPE := 200) 컴파일 한 다음, 
                    --이걸 실행하면 그냥 200번 없어짐

-- 사용자가 입력한 값도 전달 가능
-- EXEC DEL_EMP_ID('&emp_id');  -- 이건 아닌 것 같음???  why????
EXEC DEL_EMP_ID('&사번');

ROLLBACK;

-----------------------------------------------------------
-- 2) IN/OUT 매개변수있는 프로시저 생성
--      IN 매개변수 : 프로시저 내부에서 사용될 변수
--      OUT 매개변수 : 프로시저 호출부(외부)에서 사용될 값을 담아줄 변수 
SET AUTOPRINT ON;

CREATE OR REPLACE PROCEDURE SELECT_EMP_ID(
    V_EMP_ID IN EMPLOYEE.EMP_ID%TYPE,
    V_EMP_NAME OUT EMPLOYEE.EMP_NAME%TYPE,
    V_SALARY OUT EMPLOYEE.SALARY%TYPE,
    V_BONUS OUT EMPLOYEE.BONUS%TYPE
)
IS
BEGIN
    SELECT EMP_NAME, SALARY, NVL(BONUS, 0)
    INTO V_EMP_NAME, V_SALARY, V_BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = V_EMP_ID;
END;
/

-- * 바인드 변수 (VARIABLE OR VAR)
-- SQL 문장을 실행할 때 SQL에 사용 값을 전달할 수 있는 통로 역할을 하는 변수 
-- 위 프로시저 실행시 조회 결과가 저장될 바인드 변수를 생성해야 한다. 

VAR VAR_EMP_NAME VARCHAR2(30);
VAR VAR_SALARY NUMBER;
VAR VAR_BONUS NUMBER;

-- 바인드 변수는 ':변수명' 형태로 참조 가능
EXEC SELECT_EMP_ID('200', :VAR_EMP_NAME, :VAR_SALARY, :VAR_BONUS);

-- 바인드 변수의 값을 출력하기 위해서는 PRINT 명령어를 사용 
-- 만약에 출력이 안되면  SET AUTOPRINT ON; 을 실행시켜야 한다. 
PRINT VAR_EMP_NAME;
PRINT VAR_SALARY;
PRINT VAR_BONUS;


--------------------------------------------------------------------
/*
    <FUNCTION>
        프로시저와 다르게 OUT변수를 사용하지 않아도 실행결과를 되돌려 받을 수 있다. (RETURN)
        
        [표현법]
            CREATE OR REPLACE FUNCTION
                (매개변수1 타입,
                 매개변수2 타입,
                 ...)
            RETURN 데이터타입
            IS 
                선언부
            BEGIN 
                실행부
                RETURN 반환값;     -- 프로시저랑 다르게 RETURN 구문이 추가됨
           [EXCEPTION
                예외처리부]
            END{함수명];
            /
 
*/

-- 사번을 입력받아 해당 사원의 보너스를 포함하는 연봉을 계산하고 리턴하는 함수 생성
CREATE OR REPLACE FUNCTION BONUS_CALC (
    V_EMP_ID EMPLOYEE.EMP_ID%TYPE)
RETURN NUMBER
IS
    V_SAL EMPLOYEE.SALARY%TYPE;
    V_BONUS EMPLOYEE.BONUS%TYPE;
    V_CALC_SAL NUMBER;
BEGIN
    SELECT SALARY, NVL(BONUS, 0)
    INTO V_SAL, V_BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = V_EMP_ID;
    
    V_CALC_SAL := (V_SAL + (V_SAL * V_BONUS)) * 12;
    
    RETURN V_CALC_SAL;
END;
/

SELECT * FROM USER_SOURCE;

VARIABLE VAR_CALC_SALARY NUMBER;

-- 함수 호출
-- EXEC BONUS_CALC(&사번); -- 반환하는 값이 있기 때문에 아래처럼 반환값을 받아줘야 한다. 
EXEC :VAR_CALC_SALARY := BONUS_CALC('&사번');

PRINT VAR_CALC_SALARY;

-- 함수를 SELECT문에서 사용하기 (함수는 RETURN 값이 잇어 SELECT 문에서 사용 가능 (EXEC 생략 가능))
SELECT EMP_ID, EMP_NAME, SALARY, BONUS, BONUS_CALC(EMP_ID)
FROM EMPLOYEE
WHERE BONUS_CALC(EMP_ID) > 30000000;

---------------------------------------------------------------------
/*
    <CURSOR>
        SQL 문의 처리 결과(처리 결과가 여러 행(ROW))를 담고 있는 공간에 대한 포인터(참조)
        커서 사용시 여러 ROW로 나타난 처리 결과에 순차적으로 접근 가능
            -->*** SELECT 결과가 단일행일 경우 INTO절을 이용해 변수에 저장 가능하지만 ***
                    결과가 다중행일 경우 CURSOR를 이용하면 행(ROW) 단위로 처리 가능
                    
        커서 종류
        묵시적/명시적 커서 두 종류가 존재 
        
        * 커서 속성 
            - 커서명%ROWCOUNT : SQL 처리 결과로 얻어온 ROW 수 --> 0 시작, FETCH시마다 1씩 증가
            - 커서명%FOUND     : 커서 영역의 남아있는 ROW 수가 한 개 이상일 경우 TRUE, 아니면 FALSE
            - 커서명%NOTFOUND  : 커서 영역의 남아있는 ROW 수가 없으면 TRUE, 아니면 FALSE
            - 커서명%ISOPEN    : 커서가 OPEN 상태인 경우 TRUE, (묵시적 커서는 항상 FALSE)
            (묵시적 커서의 경우 커서명은 = SQL)
        
        1) 묵시적 커서 
            오라클에서 자동으로 생성되어 사용하는 커서 --> 커서명 : SQL 
            PL/SQL 블록엣 실행하는 SQL문 실행시마다 자동으로 만들어져서 사용된다. 
            사용자는 생성 유무를 알 수 업지만, 커서 속성을 활용하여 커서의 정보를  얻어올 수 있다. 
*/

SET SERVEROUTPUT ON;

-- 묵시적 커서 확인
-- BONUS가 NULL 인 사원의 BONUS를 0으로 수정 
SELECT * FROM EMPLOYEE;
COMMIT;

BEGIN
    UPDATE EMPLOYEE
    SET BONUS = 0
    WHERE BONUS IS NULL;
    
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || '행 수정됨');
END;
/

SELECT * FROM EMPLOYEE;

ROLLBACK;

--------------------------------------------------------------------
/*
         2) 명시적 커서 
            사용자가 직접 선언해서 사용할 수 있는 이름있는 커서 
            
            [사용방법]
                1) CURSOR --> 커서 선언
                2) OPEN   --> 커서 오픈
                3) FETCH  --> 커서에서 데이터 추출 (한 행씩 데이터를 가져온다.) 
                4) CLOSE  --> 커서 닫기
                
            [표현식]
                CURSOR 커서명 IS [SELECT 문] 
                
                OPEN 커서명;
                FETCH 커서명 INTO 변수;
                CLOSE 커서명; 
*/

--급여가 300만원 이상인 사원의 사번, 이름, 급여 출력 (PL/SQL)
DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    
    CURSOR C1 IS            -- 커서 생성 : 아래의 서브쿼리의 결과를 커서 영역에 담아둔다. 
        SELECT EMP_ID, EMP_NAME, SALARY
        FROM EMPLOYEE
        WHERE SALARY > 3000000;
BEGIN
    OPEN C1;
    
    LOOP 
        FETCH C1 INTO EID, ENAME, SAL;      -- 서브쿼리의 결과에서 한 ROW씩 차레대로 데이터를 가져온다.
        
        EXIT WHEN C1%NOTFOUND;          -- 루프 종료 조건 (%NOTFOUND : 커서 영역에 남아있는 행이 없으면 TRUE)
        
        DBMS_OUTPUT.PUT_LINE(EID || ' ' || ENAME || ' ' || SAL);
    END LOOP;
    
    CLOSE C1;       -- 커서 종료 

END;
/

-- FOR IN LOOP를 이용한 커서 사용 
-- LOOP 시작시 자동으로 커서 OPEN, 
-- 반복 할 때마다 FETCH도 자동으로 실행
-- LOOP 종료시 자동으로 CLOSE 한다. 

CREATE OR REPLACE PROCEDURE CURSOR_DEPT
IS 
    DEPT DEPARTMENT%ROWTYPE;
    
    CURSOR C1 IS
        SELECT * FROM DEPARTMENT;
BEGIN 
    FOR DEPT IN C1
    LOOP
         DBMS_OUTPUT.PUT_LINE(DEPT.DEPT_ID || ' ' || DEPT.DEPT_TITLE || ' ' || DEPT.LOCATION_ID);
    END LOOP;

END;
/

SELECT * FROM USER_SOURCE;

EXEC CURSOR_DEPT;

-- CURSOR를 별도로 생성하지 않고 바로 SELECT문을 작성
CREATE OR REPLACE PROCEDURE CURSOR_DEPT
IS 
    DEPT DEPARTMENT%ROWTYPE;
BEGIN
    FOR DEPT IN (SELECT * FROM DEPARTMENT)
    LOOP
        DBMS_OUTPUT.PUT_LINE(DEPT.DEPT_ID || ' ' || DEPT.DEPT_TITLE || ' ' || DEPT.LOCATION_ID);
    END LOOP;
END;
/

EXEC CURSOR_DEPT;











