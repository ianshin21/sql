
select (NULL + 2) from dual;


INSERT INTO MEMBER 
VALUES(
    SEQ_USER_NO.NEXTVAL, '삼돌이', 'samdol', '333', '5555', '서울시 동작구', 
      '010-1234-5678', SYSDATE, SYSDATE, DEFAULT, 'ROLE_MEMBER'
);

INSERT INTO MEMBER 
VALUES(
    SEQ_USER_NO.NEXTVAL, '고돌이', 'godol', '555', '5555', '서울시 동작구', 
      '010-1234-5678', SYSDATE, SYSDATE, DEFAULT, 'ROLE_ADMIN'
);

INSERT INTO MEMBER 
VALUES(
    SEQ_USER_NO.NEXTVAL, '나가리', 'nagary', '555', '5555', '서울시 동작구', 
      '010-1234-5678', SYSDATE, SYSDATE, DEFAULT, 'ROLE_MEMBER'
);

ALTER TABLE MEMBER MODIFY USER_TYPE VARCHAR2(20) DEFAULT 'ROLE_MEMBER';

  		INSERT INTO QUES 
  		VALUES(
  			SEQ_QUES_NO.NEXTVAL,
  			'제목',
  			'내용',
  			DEFAULT,
  			DEFAULT,
  			DEFAULT,
  			'아이디 관련',
  			'1111',
  			DEFAULT,
  			DEFAULT,
  			DEFAULT,
  			'21'
 		);


INSERT INTO QUES_REPLY 
VALUES(
   '10',
   '안녕',
   DEFAULT,
    DEFAULT,
    '21'
);

INSERT INTO QUES_REPLY 
VALUES(
   '9',
   '안녕',
   DEFAULT,
    DEFAULT,
    '21'
);

SELECT Q.QUES_NO,
		       Q.TITLE,
		       M.USER_ID,
		       Q.POST_DATE,
		       Q.QUES_TYPE,
               Q.QUES_PWD,
		       Q.VIEW_NO
		FROM QUES Q
		JOIN MEMBER M ON(Q.USER_NO = M.USER_NO);

SELECT 
    QUES_NO,
    CONTENT,
    POST_DATE,
    EDIT_DATE,
    USER_NO
FROM QUES_REPLY;


---------------------------------- 정일님과 나 : 수정 후 미 보고
ALTER TABLE QUES MODIFY GROUP_NO NULL;
ALTER TABLE REVIEW MODIFY GROUP_NO NULL;

ALTER TABLE QUES
ADD (USER_ID VARCHAR2(30));

ALTER TABLE QUES MODIFY VIEW_NO	NUMBER DEFAULT 0;

ALTER TABLE QUES MODIFY QUES_PWD VARCHAR2(30);

--드라이버 status 추가-- 원석님
ALTER TABLE DRIVER ADD STATUS VARCHAR2(3) DEFAULT 'Y' CHECK(STATUS IN('Y', 'N'));
------------------------------------------------

--  4/7 수정 
ALTER TABLE QUES ADD STATUS VARCHAR2(3) DEFAULT 'Y' CHECK(STATUS IN('Y', 'N'));


-----------------------------4/19 payment 다시 만듬

INSERT INTO PAYMENT 
VALUES(  '392', '29q', 'PETCAB', '사달이', '500', '33', 'y', 'card', 'inicis', '222', '44', 'kh.co.kr', '21'
);

CREATE TABLE PAYMENT (
	MERCHANT_UID	VARCHAR2(1000)	NOT NULL,
    IMP_UID	VARCHAR2(1000)	NOT NULL,
	NAME	VARCHAR2(100)	NOT NULL,
    BUYER_NAME VARCHAR2(100),
	PAID_AMOUNT	NUMBER	NOT NULL,
	APPLY_NUM	VARCHAR2(1000)	NULL,
	STATUS	VARCHAR2(100)	NOT NULL,
    PAY_METHOD	VARCHAR2(100),
	PG_PROVIDER	VARCHAR2(100)	NULL,
	PG_TID	VARCHAR2(100)	NULL,
	PAID_AT	NUMBER	NULL,
	RECEIPT_URL	VARCHAR2(100) NULL,	
	USER_NO	NUMBER	NOT NULL
);


ALTER TABLE PAYMENT ADD CONSTRAINT PK_PAYMENT PRIMARY KEY (
	MERCHANT_UID
);

ALTER TABLE PAYMENT ADD CONSTRAINT FK_MEMBER_TO_PAYMENT_1 FOREIGN KEY (
	USER_NO
)
REFERENCES MEMBER (
	USER_NO
);

COMMENT ON COLUMN PAYMENT.MERCHANT_UID IS '고유주문번호';
COMMENT ON COLUMN PAYMENT.IMP_UID IS '아임포트거래고유번호';
COMMENT ON COLUMN PAYMENT.NAME IS '주문명';
COMMENT ON COLUMN PAYMENT.BUYER_NAME IS '주문자';
COMMENT ON COLUMN PAYMENT.PAID_AMOUNT IS '결제금액';
COMMENT ON COLUMN PAYMENT.APPLY_NUM IS '카드사승인번호';
COMMENT ON COLUMN PAYMENT.STATUS IS '결제상태';
COMMENT ON COLUMN PAYMENT.PAY_METHOD IS '결제수단';
COMMENT ON COLUMN PAYMENT.PG_PROVIDER IS '결제승인/시도된PG사';
COMMENT ON COLUMN PAYMENT.PG_TID IS 'PG사거래고유번호';
COMMENT ON COLUMN PAYMENT.PAID_AT IS '결제승인시각';
COMMENT ON COLUMN PAYMENT.RECEIPT_URL IS '카드사승인번호';
COMMENT ON COLUMN PAYMENT.USER_NO IS '회원번호';

ALTER TABLE PAYMENT
MODIFY RECEIPT_URL VARCHAR(300)
;

ALTER TABLE PAYMENT
ADD PAYMENT_DATE DATE DEFAULT SYSDATE;
