/*
    <SEQUENCE>
        정수값을 자동으로 순차적으로 생성해준다. 
        
        [표현식]
            CREATE SEQUENCE 시퀀스명
            [STRAT WITH 숫자]             : 처음 발생시킬 시작값 지정
            [INCREMENT BY 숫자]           : 다음 발생할 값에 대한 증가치
            [MAXVALUE 숫자]               : 발생시킬 최대값 지정
            [MINVALUE 숫자]               : 발생시킬 최소값 지정
            [CYCLE|NOCYCLE]               : 값의 순환 여부 지정
            [CACHE 바이트크기|NOCACHE]     : 캐시메모리 할당 (기본값 20바이트)
            
            * 캐시메모리 
                - 미리 다음값들을 생성해서 저장해둔다.
                - 매번 호출할 때마다 새로 생성 하는 것이 아니라 캐시메모리 공간에 미리 생성된 값들을 사용한다. 
                
            [사용구문]
                시퀀스명.CURRVAL    : 현재 시퀀스의 값
                시퀀스명.NEXTVAL    : 시퀀스값을 증가시키고 증가된 시퀀스값을 리턴
                                    (기존 시퀀스값에서 INCREMENT 만큼 증가된 값)
*/

CREATE SEQUENCE SEQ_EMPNO
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;

--현재 계정이 가지고 있는 시퀀스들에 대한 정보
SELECT * FROM USER_SEQUENCES;

SELECT SEQ_EMPNO.CURRVAL FROM DUAL;    
-- NEXTVAL 수행하기 전에 CURRVAL 먼저 실행하면 에러 
-- NEXTVAL 한번이라도 수행하지 않는 이상 CURRVAL 를 가져올 수 없다
-- CURRVAL은 마지막으로 성공적으로 수행된 NEXTVAL 값을 저장해서 보여주는 값이다. 

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;     -- 300
SELECT SEQ_EMPNO.CURRVAL FROM DUAL;     -- 300
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;     --ERROR : 지정한 MAXVALUE 값을 초과했기 때문
SELECT SEQ_EMPNO.CURRVAL FROM DUAL;     -- 계속 310을 찍는다.

/*
    <시퀀스 변경>
    [표현식]
        ALTER SEQUNCE 시퀀스명
        [INCREMENT BY 숫자]           : 다음 발생할 값에 대한 증가치
        [MAXVALUE 숫자]               : 발생시킬 최대값 지정
        [MINVALUE 숫자]               : 발생시킬 최소값 지정
        [CYCLE|NOCYCLE]               : 값의 순환 여부 지정
        [CACHE 바이트크기|NOCACHE]     : 캐시메모리 할당 (기본값 20바이트)
        
        * START WITH 값 변경은 불가하기 때문에 변경하려면 삭제DROP 후 다시 생성해야 함
*/
ALTER SEQUENCE SEQ_EMPNO
INCREMENT BY 10
MAXVALUE 400;

SELECT * FROM USER_SEQUENCES;

SELECT SEQ_EMPNO.CURRVAL FROM DUAL;     -- 310
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;     -- 실행할 때 마다 10씩 증가 

DROP SEQUENCE SEQ_EMPNO;

----------------------------------------------------------

CREATE SEQUENCE SEQ_EID
START WITH 300;

SELECT *FROM USER_SEQUENCES;

-- 매번 새로운 사번이 발생되는 시퀀스 사용
INSERT INTO EMPLOYEE
VALUES(SEQ_EID.NEXTVAL, '홍길동', '666666-6666666', 'HONG@IEI.CO.KR',
        '01011111111', 'D2', 'J2', 5000000, 0.1, NULL, SYSDATE, NULL, DEFAULT);

INSERT INTO EMPLOYEE
VALUES(SEQ_EID.NEXTVAL, '겅유', '111111-6666666', 'GUNG@IEI.CO.KR',
        '01011111111', 'D2', 'J2', 6000000, 0.1, NULL, SYSDATE, NULL, DEFAULT);
        
ROLLBACK;

-----------------------------------------------------------------------------------













