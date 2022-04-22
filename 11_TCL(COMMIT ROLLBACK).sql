/*
    <TCL : TRANSACTION CONTROLL LANGUAGE>
        트랜젝션을 제어하는 언어
    
    * 트랜잭션 
        - 하나의 논리적인 작업 단위를 트랜잭션이라고 한다. 
            ATM에서 현금 인출
                1. 카드 입력
                2. 메뉴 선택
                3. 금액 확인 및 인증
                4. 실제 계좌 금액만큼 인출
                5. 실제 현금 인출
                6. 완료
        - 각각의 업무들을 묶어서 하나의 작업 단위로 만들어 버리는 것을 트랜잭션이라도 한다. 
        
        - 데이터의 변경사항(DML)들을 묶어서 하나의 트랜잭션에 담아 처리
            COMMIT 하기 전까지의 변경사항들을 하나의 트랜잭션에 담게 된다. 
        - 트랜잭션 대상이 되는 SQL : INSERT, UPDATE, DELETE  (DML)
        - COMMIT(트랜잭션 종료처리 후 저장), ROLLBACK(트랜잭션 취소), SAVEPOINT(임시저장) 을 통해서 트랜잭션을 제어한다.
        
        COMMIT 
            메모리 버퍼에서 임시 저장된 데이터를 DB에 반영
            모든 작업들을 정상적으로 처리하겠다고 확정하는 명령어, 트랜잭션 과정을 종료하게 된다.
        ROLLBACK 
            메모리 버퍼에 임시 저장된 데이터를 삭제한 후 마지막 COMMIT 시점으로 돌아간다.
        SAVEPOINT
            저장점을 정의해 두면 ROLLBACK 진행할 때 전체 작업을 ROLLBACK 하는 게 아닌 SAVEPOINT 까지 일부만 롤백
                SAVEPOINT 포인트명;  -- 저장점 지정
                ROLLBACK TO 포인트명; -- 해당 포이트 지점까지으 트랜잭션만 롤백한다.
*/

SELECT * FROM EMP_01;

-- EMP_ID가 900, 901인 사원지우기 
DELETE FROM EMP_01
WHERE EMP_ID = 900 OR EMP_ID = 901;

-- 두 개의 행이 삭제된 시점에 SAVEPOINT 지정
SAVEPOINT SP1;

-- 200번 사원 지우고 
DELETE FROM EMP_01
WHERE EMP_ID = 200;

-- ROLLBACK
ROLLBACK TO SP1;    -- 200번만 복구

ROLLBACK;           -- 900, 901번 까지 복구

DELETE FROM EMP_01
WHERE EMP_ID IN (217, 216, 900, 901);

COMMIT;

ROLLBACK;      --커밋했으므로 되돌릴 수 없다. 

-- 218 이오리 지우기 
DELETE FROM EMP_01
WHERE EMP_ID = 218;

CREATE TABLE TEST(
    TID NUMBER
);

ROLLBACK;       -- DDL 구문으로 인해 218 삭제가 자동 커밋되었고 ROLLBACK 해도 돌아오지 않음
 
SELECT * FROM EMP_01;











