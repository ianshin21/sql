/*
 
    <TRIGGER>
        내가 지정한 테이블에 INSERT, UPDATE, DELETE 등의 DML 구문에 의해 변경될 경우 (테이블에 이벤트 발생)
        자동으로 실행될 내용을 정의해 놓는 객체 
        
        * 트리거 종류 
            1) SQL 문의 실행 시기에 따른 분류
                - BEFORE TRIGGER : 해당 SQL문 실행 전에 트리거 실행
                - AFTER TRIGGER  : 해당 SQL문 실행 후에 크리거 실행
                
            2) SQL 문에 의해 영향을 받는 각 행에 따른 분류
                - 문장 트리거 : 해당 SQL 문에 대해 한번만 트리거 실행
                - 행 트리거   : 해당 SQL 문에 영향을 받는 행마다 트리거 실행
                                트리거 생성 구문 작성시 FOR EACH ROW 옵션을 기술해야 한다. 
                                > :OLD : 입력전 자료, 수정전 자료, 삭제전 자료
                                > :NEW : 입력된 자료, 수정후 자료, 
                                
        [표현식]
            CREATE OR REPLACE TRIGGER 트리거명
            BEFORE|AFTER INSERT|UPDATE|DELETE ON 테이블명
            [FOR EACH ROW]
            [DECLARE
                선언부]
            BEGIN
                실행부 (위 선언부에 지정된 이벤트 발생시 자동으로 실행할 구문)
            [EXCEPTION
                예외처리부]
            END;
            /
*/

CREATE OR REPLACE TRIGGER TRG_01
AFTER INSERT
ON EMPLOYEE
BEGIN
    DBMS_OUTPUT.PUT_LINE('신입사원이 입사했습니다.');
END;
/

INSERT INTO EMPLOYEE 
VALUES (905, '길성춘', '690512-1151432', 'gil_sj@kh.or.kr',
            '01035464455', 'D5', 'J3', 3000000, 0.1, 200, SYSDATE, NULL, DEFAULT);
            
            
SELECT * FROM EMPLOYEE;

INSERT INTO EMPLOYEE 
VALUES (906, '김성춘', '690512-1151432', 'gil_sj@kh.or.kr',
            '01035464455', 'D5', 'J3', 3000000, 0.1, 200, SYSDATE, NULL, DEFAULT);
------------------------------------------------------------------

-- 문장 트리거, 행트리거 실험
CREATE OR REPLACE TRIGGER TRG_02
AFTER UPDATE 
ON EMPLOYEE
BEGIN
    DBMS_OUTPUT.PUT_LINE('업데이트 실행');
END;
/

CREATE OR REPLACE TRIGGER TRG_03
AFTER UPDATE
ON EMPLOYEE
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('변경전 : ' || :OLD.DEPT_CODE || '변경후 : ' || :NEW.DEPT_CODE);
END;
/

UPDATE EMPLOYEE
SET DEPT_CODE = 'D0'
WHERE DEPT_CODE = 'D8';

ROLLBACK;

----------------------------------------------------------
-- 상품 입고 출고 관련 예시 
-- 필요한 테이블 / 시퀀스 생성 

-- 1. 상품에 대해 데이터를 보관할 테이블 (PRODUCT)
CREATE TABLE PRODUCT (
    PCODE NUMBER PRIMARY KEY,
    PNAME VARCHAR2(30),
    BRAND VARCHAR2(30),
    PRICE NUMBER,
    STOCK NUMBER DEFAULT 0
);

-- 상품 코드가 중복되지 않게 새로운 번호를 발생하는 시퀀스 
CREATE SEQUENCE SEQ_PCODE;

INSERT INTO PRODUCT
VALUES(SEQ_PCODE.NEXTVAL, '갤럭시노트20', '삼성', 1500000, DEFAULT);

INSERT INTO PRODUCT
VALUES(SEQ_PCODE.NEXTVAL, '아이폰12프로', '애플', 1300000, DEFAULT);

INSERT INTO PRODUCT
VALUES(SEQ_PCODE.NEXTVAL, '대륙폰', '샤오미', 500000, DEFAULT);

SELECT * FROM PRODUCT;

-- 상품 입출고시 상세 이력 테이블 (PRODETAIL)
--  (어떤 상품이 어떤 날 몇 개가 입고 또는 출고 되었는지 기록하는 테이블)
CREATE TABLE PRODETAIL (
    DCODE NUMBER PRIMARY KEY,       -- 상세코드 (입출력 이력코드)
    PDATE DATE,                     -- 상품 입출고일
    AMOUNT NUMBER,                  -- 수량
    STATUS VARCHAR2(10),             -- 상태 (입고/출고)
    PCODE NUMBER, 
    CHECK(STATUS IN ('입고', '출고')),
    FOREIGN KEY(PCODE) REFERENCES PRODUCT
);

CREATE SEQUENCE SEQ_DCODE;

INSERT INTO PRODETAIL
VALUES(SEQ_DCODE.NEXTVAL, SYSDATE, 10, '입고', 1);

SELECT * FROM PRODETAIL;

UPDATE PRODUCT 
SET STOCK = STOCK + 10
WHERE PCODE = 1;

-- PRODETAIL 테이블에 데이터 삽입시 PRODUCT  테이블에 재고 수량이 업데이터 되도록 트리거 생성
CREATE OR REPLACE TRIGGER TRG_PRODETAIL
AFTER INSERT ON PRODETAIL 
FOR EACH ROW
BEGIN 
    DBMS_OUTPUT.PUT_LINE(:NEW.STATUS || ' ' || :NEW.AMOUNT || ' ' || :NEW.PCODE);
    
    -- 상품이 입고된 경우 --> 재고 증가
    IF (:NEW.STATUS = '입고')
        THEN 
            UPDATE PRODUCT
            SET STOCK = STOCK + :NEW.AMOUNT
            WHERE PCODE = :NEW.PCODE;
    END IF;
    
    -- 상품이 출고된 경우 --> 재고 감소
    IF (:NEW.STATUS = '출고')
        THEN 
            UPDATE PRODUCT
            SET STOCK = STOCK - :NEW.AMOUNT
            WHERE PCODE = :NEW.PCODE;
    END IF;
END;
/


INSERT INTO PRODETAIL
VALUES(SEQ_DCODE.NEXTVAL, SYSDATE, 100, '입고', 3);

INSERT INTO PRODETAIL
VALUES(SEQ_DCODE.NEXTVAL, SYSDATE, 10, '출고', 1);


SELECT * FROM PRODETAIL;

SELECT * FROM PRODUCT;



