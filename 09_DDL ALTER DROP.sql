-- DDL(Data Definition Language)
-- 객체를 만들고,바꾸고,삭제 하는 데이터 정의 언어
-- CREATE,ALTER,DROP
-- ALTER(바꾸다,수정하다,변조하다)

-- 테이블에서 수정할 수 있는것

-- 1. 제약조건( [기존 것 수정은 안되며] 추가/삭제만 가능 )
-- 2. 컬럼(추가,수정,삭제 다 가능)
-- 3. 이름변경(테이블명, 제약조건명, 컬럼명)

----------------------------------------------------------------------------------------------------------

-- 1. 제약조건(추가/삭제)

-- [작성법]
-- 1) 추가 : ALTER TABLE 테이블명
-- 			 ADD CONSTRAINT 제약조건명 제약조건(지정컬럼명)
-- 			 [REFERENCES 테이블명[(컬럼명)]]; <-- FK인 경우 추가

-- 2) 삭제 : ALTER TABLE 테이블명
--			 DROP CONSTRAINT 제약조건명;

--> 수정은 별도로 존재하지 않기 때문에, 삭제 후 추가를 이용하여 수정

-- DEPARTMENT 테이블 복사(컬럼명, 데이터타입, NOT NULL만 복사)
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY;

-- DEPT_COPY의 DEPT_TITLE 컬럼에 UNIQUE 제약조건을 추가해보자
ALTER TABLE DEPT_COPY
ADD CONSTRAINT DEPT_COPY_TITLE_U UNIQUE(DEPT_TITLE);
-- D,U = 제약조건명,제약조건



-- 삭제
ALTER TABLE DEPT_COPY
DROP CONSTRAINT DEPT_COPY_TITLE_U;

-- DEPT_COPY의 DEPT_TITLE 컬럼에 NOT NULL 제약조건 추가/삭제

ALTER TABLE DEPT_COPY
ADD CONSTRAINT DEPT_COPY_TITLE_U ??(DEPT_TITLE);
--  ORA-00904: : 부적합한 식별자
-- NOT NULL은 추가의 개념이 아님
-- EX) 컬럼엔 NOT NULL이 있는데, CONSTRAINTS엔 없듯이 성질이 다름

--> [NOT NULL] 제약조건은 새로운 조건을 추가하는 것이 아닌
-- 컬럼 자체에 [NULL 허용/비허용]을 제어하는 성질 변경의 형태로 인식

	--추가
-- MODIFY(수정하다) 구문을 사용하여 NULL 제어
ALTER TABLE DEPT_COPY 
MODIFY DEPT_TITLE NOT NULL;
-- 결과창의 DEPT_TITLE에 NOT NULL [v] 표시됨

	--삭제
ALTER TABLE DEPT_COPY 
MODIFY DEPT_TITLE NULL;
-- 결과창의 DEPT_TITLE에 NOT NULL [v] 표시 삭제됨


							--제약조건 끝--
-----------------------------------------------------------------------------------

-- 2. 컬럼(추가/수정/삭제) 다 됨


-- 컬럼추가(ADD)
-- ALTER TABLE 테이블명 ADD(컬럼명 데이터타입 [DEFAULT [값]);

-- 컬럼 수정(MODIFY)
-- ALTER TABLE 테이블명 MODIFY 컬럼명 데이터타입; --> DATA타입 변경
-- ALTER TABLE 테이블명 MODIFY 컬럼명 DEFAULT '값'; --> DEFAULT 값 변경
-- ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL / NULL; --> NULL 여부 변경

-- 컬럼 삭제(DROP)
-- ALTER TABLE 테이블명 DROP(삭제할컬럼명);
-- ALTER TABLE 테이블명 DROP COLUMN 삭제할컬럼명;
--> 의미는 같지만, 표기법을 마음에 드는것으로 사용하면 됨!



--> 컬럼 삭제 시 주의사항
-- 테이블이란? 행과 열로 이루어진 DB에서 가장 기본적인 객체로
-- 테이블에 데이터가 저장됨

-- 테이블은 최소 1개 이상의 컬럼이 존재해야 하기 때문에
-- 모든 컬럼을 다 삭제할 순 없다.

SELECT * FROM DEPT_COPY;
-- CNAME 컬럼추가
ALTER TABLE DEPT_COPY ADD(CNAME VARCHAR2(30));
SELECT * FROM DEPT_COPY;
-- CNAME [NULL] 추가됨



ALTER TABLE DEPT_COPY ADD(LNAME VARCHAR2(30) DEFAULT '한국');
SELECT * FROM DEPT_COPY;
-- LNAME 컬럼추가(기본값은 '한국')
-- LNAME 컬럼이 생성, DEFAULT 값 '한국' 자동삽입

-- D10 개발 1팀 추가
INSERT INTO DEPT_COPY 
VALUES('D10','개발1팀','L1', DEFAULT, DEFAULT);
--SQL Error [12899] [72000]: ORA-12899: "KH"."DEPT_COPY"."DEPT_ID" 열에 대한 값이 너무 큼
-- D10 3글자여서 안된다는뜻

-- DEPT_ID 컬럼 수정
ALTER TABLE DEPT_COPY MODIFY DEPT_ID VARCHAR2(3);
SELECT * FROM DEPT_COPY;

--LNAME의 기본값을 'KOREA'로 수정
ALTER TABLE DEPT_COPY MODIFY LNAME DEFAULT 'KOREA';
SELECT * FROM DEPT_COPY;
-- 기본값을 변경했다고 바로 기존데이터가 변하진 않음
-- 보기엔 변한게 없다. 바로 변하는것이 아닌, 앞으로 변하겠다는 뜻

-- LNAME '한국' -> 'KOREA'로 변경  ( UPDATE 구문 써야함)
UPDATE DEPT_COPY SET
LNAME = DEFAULT
WHERE LNAME = '한국';

SELECT * FROM DEPT_COPY;

COMMIT;

-- 모든컬럼 삭제
-- ALTER TABLE 테이블명 DROP(삭제할컬럼명);
-- ALTER TABLE 테이블명 DROP COLUMN 삭제할컬럼명;

ALTER TABLE DEPT_COPY DROP(LNAME);
ALTER TABLE DEPT_COPY DROP COLUMN CNAME;
ALTER TABLE DEPT_COPY DROP(LOCATION_ID);
ALTER TABLE DEPT_COPY DROP(DEPT_TITLE);
ALTER TABLE DEPT_COPY DROP(DEPT_ID);
-- DEPT_ID 삭제하려니 오류,
-- SQL Error [12983] [72000]: ORA-12983: 테이블에 모든 열들을 삭제할 수 없습니다
--> 컬럼은 하나 이상 남아있어야 하기 때문에

--테이블 삭제
DROP TABLE DEPT_COPY;
--SQL Error [942] [42000]: ORA-00942: 테이블 또는 뷰가 존재하지 않습니다
--삭제완료

					--컬럼 추가&수정&삭제 끝--
----------------------------------------------------------------------------------

CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;
--> 컬럼명, 데이터타입, NOT NULL 여부만 복사됨

-- DEPT_COPY 테이블에 PK 추가(컬럼 : DEPT_ID, 제약조건명 : D_COPY_PK)
ALTER TABLE DEPT_COPY ADD CONSTRAINT D_COPY_PK PRIMARY KEY(DEPT_ID);
SELECT * FROM DEPT_COPY

-- 3. 이름변경(테이블명,컬럼명,제약조건명)

-- 1) 컬럼명 변경(DEPT_TITLE)
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;
SELECT * FROM DEPT_COPY

-- 2) 제약조건명 변경(D_COPY_PK -> DEPT_COPY_PK)
-- CONSTRAINT A TO B

ALTER TABLE DEPT_COPY RENAME CONSTRAINT D_COPY_PK TO DEPT_COPY_PK;
SELECT * FROM DEPT_COPY

-- 3) 테이블명 변경(DEPT_COPY -> DCOPY)
-- RENAME TO 변경할 테이블명;
ALTER TABLE DEPT_COPY RENAME TO DCOPY;
SELECT * FROM DCOPY;
--확인가능

				 	--컬럼명,제약조건명,테이블명 변경 끝--
----------------------------------------------------------------------------------

-- 4. 테이블 삭제

-- DROP TABLE 테이블명 [CASCADE CONSTRAINT];

-- 1) 관계가 형성되지 않은 테이블(DCOPY) 삭제
DROP TABLE DCOPY;

-- 외래키(FOREIGN KEY)가 설정되어있지 않음
-- 컬럼에 값이 있을 경우 허용



-- 2) 관계가 형성된 테이블 삭제
CREATE TABLE TB1(
	TB1_PK NUMBER PRIMARY KEY,
	TB1_COL NUMBER);

CREATE TABLE TB2(
	TB2_PK NUMBER PRIMARY KEY,
	TB2_COL NUMBER REFERENCES TB1); 
	--FOREIGN KEY 제약조건 설정해보기
	--결과창에서 확인

-- TB1에 샘플데이터 넣기
INSERT INTO TB1 VALUES(1, 100);
INSERT INTO TB1 VALUES(2, 200);
INSERT INTO TB1 VALUES(3, 300);

COMMIT;

-- TB2에 샘플데이터 넣기
INSERT INTO TB2 VALUES(11, 1);
INSERT INTO TB2 VALUES(12, 2);
INSERT INTO TB2 VALUES(13, 3);

SELECT * FROM TB1;
SELECT * FROM TB2;

-- TB1 삭제해보기
DROP TABLE TB1;
--SQL Error [2449] [72000]: ORA-02449: 외래 키에 의해 참조되는 고유/기본 키가 테이블에 있습니다

--> 해결방법 3가지
-- 1. 자식,부모 테이블 순서로 삭제(TB2 지운 후 TB1 지우면 됨)
-- 2. ALTER를 이용하여 FK 제약조건 삭제 후 TB1 삭제
-- 3. DROP TABLE 삭제옵션 CASCADE CONSTRAINT 사용
--> (종속된)CASCADE (제약조건)CONSTRAINTS : 삭제하려는 테이블과 연결된 FK 제약조건을 모두 삭제

DROP TABLE TB1 CASCADE CONSTRAINTS;
--> TB1 사라짐, 삭제성공


					--테이블 삭제 끝--
-------------------------------------------------------------------------

-- DDL 주의사항!!

-- 1. DDL은 COMMIT/ROLLBACK이 되지 않는다.
-- = 트랜잭션 제어가 되지 않는다.
--> ALTER, DROP을 신중하게 진행해야 함

-- 2. DDL과 DML 구문을 섞어서 수행하면 안된다.
--> DDL은 수행 시 존재하고 있는 트랜잭션을 모두 DB에 강제 COMMIT시킴
--> DDL이 종료된 후, DML구문을 수행할 수 있도록 권장

SELECT * FROM TB2;
COMMIT;

INSERT INTO TB2 VALUES(14,4);
INSERT INTO TB2 VALUES(15,5);
SELECT * FROM TB2;

-- INSERT 구문은 DML임

-- 컬럼명 변경 DDL 시작
ALTER TABLE TB2 RENAME COLUMN TB2_COL TO TB2_COLCOL;
--(COMMIT) 바로 된게 생략되었음
ROLLBACK;
SELECT * FROM TB2;














