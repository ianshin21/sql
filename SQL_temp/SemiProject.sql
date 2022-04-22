CREATE USER SEMIPROJECT IDENTIFIED BY SEMI;
GRANT RESOURCE, CONNECT TO SEMIPROJECT;


---------------------------------------------
--MEMBER 테이블 
--------------------------------------------

CREATE TABLE MEMBER (
    MEMBER_NO NUMBER PRIMARY KEY,
    MEMBER_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEMBER_PWD VARCHAR2(20) NOT NULL,
    MEMBER_NAME VARCHAR2(20) NOT NULL, 
    PHONE VARCHAR2(15) NOT NULL,
    EMAIL VARCHAR2(100) NOT NULL,
    ADDRESS VARCHAR2(100)NOT NULL,
    TRUTH_GRADE NUMBER,
    MEMBER_GRADE NUMBER,
    MEMBER_PROFILE VARCHAR2(50)
); 

COMMENT ON COLUMN MEMBER.MEMBER_NO IS '회원번호';
COMMENT ON COLUMN MEMBER.MEMBER_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEMBER_PWD IS '회원비밀번호';
COMMENT ON COLUMN MEMBER.MEMBER_NAME IS '회원이름';
COMMENT ON COLUMN MEMBER.PHONE IS '회원전화';
COMMENT ON COLUMN MEMBER.EMAIL IS '회원이메일';
COMMENT ON COLUMN MEMBER.ADDRESS IS '회원 주소';
COMMENT ON COLUMN MEMBER.TRUTH_GRADE IS '회원신뢰도';
COMMENT ON COLUMN MEMBER.MEMBER_GRADE IS '회원등급';
COMMENT ON COLUMN MEMBER.MEMBER_PROFILE IS '회원프로필';

CREATE SEQUENCE SEQ_UNO;

INSERT INTO MEMBER 
VALUES(SEQ_UNO.NEXTVAL, 'ANYNO', '1234', '관리자', 
    '010-1234-5678', 'admin@iei.or.kr', '서울시 강남구 역삼동', NULL, NULL, '이달의 판매왕'
);

INSERT INTO MEMBER 
VALUES(SEQ_UNO.NEXTVAL, 'ANYNON', '2345', '관리자동생', 
    '010-1234-5678', 'admin@iei.or.kr', '서울시 강남구 역삼동', NULL, NULL, '저번달 판매왕'
);

DROP TABLE PRODUCT_REGISTRY;

--------------------------------------------
--PRODUCT_REGISTRY 테이블 

CREATE TABLE PRODUCT_REGISTRY (
    PRODUCT_NO NUMBER PRIMARY KEY,
    PRODUCT_NAME VARCHAR2(50) NOT NULL, 
    PRODUCT_PRICE NUMBER NOT NULL,
    PRODUCT_PICTURE_URL VARCHAR2(50) NOT NULL, 
    PRODUCT_TEXT VARCHAR2(500) NOT NULL,
    VISIT_COUNT NUMBER DEFAULT 0,
    UPLOAD_DATE DATE DEFAULT SYSDATE,
    TRADE_AREA VARCHAR2(100),
    LIKE_COUNT NUMBER DEFAULT 0
); 

COMMENT ON COLUMN PRODUCT_REGISTRY.PRODUCT_NO IS '상품번호';
COMMENT ON COLUMN PRODUCT_REGISTRY.PRODUCT_NAME IS '상품이름';
COMMENT ON COLUMN PRODUCT_REGISTRY.PRODUCT_PRICE IS '상품가격';
COMMENT ON COLUMN PRODUCT_REGISTRY.PRODUCT_PICTURE_URL IS '상품사진';
COMMENT ON COLUMN PRODUCT_REGISTRY.PRODUCT_TEXT IS '상품설명';
COMMENT ON COLUMN PRODUCT_REGISTRY.VISIT_COUNT IS '상품조회수';
COMMENT ON COLUMN PRODUCT_REGISTRY.UPLOAD_DATE IS '상품등록날짜';
COMMENT ON COLUMN PRODUCT_REGISTRY.TRADE_AREA IS '거래지역';
COMMENT ON COLUMN PRODUCT_REGISTRY.LIKE_COUNT IS '찜개수';

CREATE SEQUENCE SEQ_PNO;



INSERT INTO PRODUCT_REGISTRY 
VALUES(SEQ_PNO.NEXTVAL, 'TICO-1990', 500, 'https://fonts.google.com', 
    '엔틱한 빈티지', DEFAULT, SYSDATE, '서울시 강남구 역삼동', DEFAULT
);


COMMIT;

SELECT * FROM PRODUCT_REGISTRY;

--------------------------------------------
--GROUP_PURCHASE_REGISTRY 테이블 

CREATE TABLE GROUP_PURCHASE_REGISTRY (
    G_PRODUCT_NO NUMBER PRIMARY KEY,
    PRODUCT_NAME VARCHAR2(50) NOT NULL, 
    PRODUCT_PRICE NUMBER NOT NULL,
    PRODUCT_PICTURE_URL VARCHAR2(50) NOT NULL, 
    PRODUCT_TEXT VARCHAR2(500) NOT NULL,
    VISIT_COUNT NUMBER DEFAULT 0,
    UPLOAD_DATE DATE DEFAULT SYSDATE,
    TRADE_AREA VARCHAR2(100),
    LIKE_COUNT NUMBER DEFAULT 0,
    QUANTITY NUMBER NOT NULL,
    END_DATE DATE
);

COMMENT ON COLUMN GROUP_PURCHASE_REGISTRY.G_PRODUCT_NO IS '상품번호';
COMMENT ON COLUMN GROUP_PURCHASE_REGISTRY.PRODUCT_NAME IS '상품이름';
COMMENT ON COLUMN GROUP_PURCHASE_REGISTRY.PRODUCT_PRICE IS '상품가격';
COMMENT ON COLUMN GROUP_PURCHASE_REGISTRY.PRODUCT_PICTURE_URL IS '상품사진';
COMMENT ON COLUMN GROUP_PURCHASE_REGISTRY.PRODUCT_TEXT IS '상품설명';
COMMENT ON COLUMN GROUP_PURCHASE_REGISTRY.VISIT_COUNT IS '상품조회수';
COMMENT ON COLUMN GROUP_PURCHASE_REGISTRY.UPLOAD_DATE IS '상품등록날짜';
COMMENT ON COLUMN GROUP_PURCHASE_REGISTRY.TRADE_AREA IS '거래지역';
COMMENT ON COLUMN GROUP_PURCHASE_REGISTRY.LIKE_COUNT IS '찜개수';
COMMENT ON COLUMN GROUP_PURCHASE_REGISTRY.QUANTITY IS '수량';
COMMENT ON COLUMN GROUP_PURCHASE_REGISTRY.END_DATE IS '공구종료';

CREATE SEQUENCE SEQ_GPNO;

INSERT INTO GROUP_PURCHASE_REGISTRY 
VALUES(SEQ_GPNO.NEXTVAL, 'WATERMELON', 5000, 'https://fonts.google.com', 
    '시원하게 한 입', DEFAULT, SYSDATE, '서울시 강남구 역삼동', DEFAULT, 1000, '21/01/30'
);

--------------------------------------------
-- ORDER_HISTORY  테이블

CREATE TABLE ORDER_HISTORY (
    ORDER_NO NUMBER PRIMARY KEY,
    PRODUCT_NAME VARCHAR2(50) NOT NULL, 
    PRODUCT_PRICE NUMBER NOT NULL,
    PRODUCT_PICTURE_URL VARCHAR2(50) NOT NULL, 
    ORDER_DATE DATE DEFAULT SYSDATE,
    PURCHASE_OR_SALE VARCHAR2(20) NOT NULL
);

COMMENT ON COLUMN ORDER_HISTORY.ORDER_NO IS '주문번호';
COMMENT ON COLUMN ORDER_HISTORY.PRODUCT_NAME IS '상품이름';
COMMENT ON COLUMN ORDER_HISTORY.PRODUCT_PRICE IS '상품가격';
COMMENT ON COLUMN ORDER_HISTORY.PRODUCT_PICTURE_URL IS '상품사진';
COMMENT ON COLUMN ORDER_HISTORY.ORDER_DATE IS '주문판매일';
COMMENT ON COLUMN ORDER_HISTORY.PURCHASE_OR_SALE IS '구매/판매구분';

CREATE SEQUENCE SEQ_ONO;

INSERT INTO ORDER_HISTORY 
VALUES(SEQ_ONO.NEXTVAL, 'WATERMELON', 5000, 'https://fonts.google.com', SYSDATE, '구매');


--------------------------------------------
-- COMMUNITY_BOARD  테이블

CREATE TABLE COMMUNITY_BOARD (
    CONTENT_NO NUMBER PRIMARY KEY,
    TITLE VARCHAR2(500) NOT NULL, 
    CONTENT VARCHAR2(1000) NOT NULL,
    MAKE_DATE DATE DEFAULT SYSDATE,
    VISIT_COUNT NUMBER DEFAULT 0
);

COMMENT ON COLUMN COMMUNITY_BOARD.CONTENT_NO IS '게시글번호';
COMMENT ON COLUMN COMMUNITY_BOARD.TITLE IS '제목';
COMMENT ON COLUMN COMMUNITY_BOARD.CONTENT IS '내용';
COMMENT ON COLUMN COMMUNITY_BOARD.MAKE_DATE IS '생성일';
COMMENT ON COLUMN COMMUNITY_BOARD.VISIT_COUNT IS '조회수';

CREATE SEQUENCE SEQ_BNO;

INSERT INTO COMMUNITY_BOARD 
VALUES(SEQ_BNO.NEXTVAL, '빠른 배송에 감사드리며', '눈이 내리네 불펜 전력을 강화해야겠다고 생각한 SK는...', SYSDATE, DEFAULT);


--------------------------------------------
-- COMMENT_LIST  테이블

CREATE TABLE COMMENT_LIST (
    COMMENT_NO NUMBER PRIMARY KEY,
    CONTENT VARCHAR2(500) NOT NULL,
    WRITE_TIME DATE DEFAULT SYSDATE
);

COMMENT ON COLUMN COMMENT_LIST.COMMENT_NO IS '댓글번호';
COMMENT ON COLUMN COMMENT_LIST.CONTENT IS '내용';
COMMENT ON COLUMN COMMENT_LIST.WRITE_TIME IS '생성일시';

CREATE SEQUENCE SEQ_CNO;

INSERT INTO COMMENT_LIST 
VALUES(SEQ_CNO.NEXTVAL, '감사에 감사 드려요~~~', SYSDATE);


--------------------------------------------------
-- FILE  테이블

CREATE TABLE UPLOAD_FILE (
    FILE_NO NUMBER PRIMARY KEY,
    FILE_NAME VARCHAR2(50) NOT NULL,
    FILE_TYPE VARCHAR2(20)
);

COMMENT ON COLUMN UPLOAD_FILE.FILE_NO IS '파일번호';
COMMENT ON COLUMN UPLOAD_FILE.FILE_NAME IS '파일이름';
COMMENT ON COLUMN UPLOAD_FILE.FILE_TYPE IS '파일타입';

CREATE SEQUENCE SEQ_FNO;

INSERT INTO UPLOAD_FILE 
VALUES(SEQ_FNO.NEXTVAL, '2월 공동구매 물품 목록', 'PDF');

COMMIT;

