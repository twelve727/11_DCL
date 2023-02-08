/*/-- SELECT문 해석순서 매우 중요
 * 
 * 5 : SELECT 컬럼명 AS 별칭, 계산식,함수식
 * 1: FROM 참조할 테이블 명
 * 2: WHERE 컬럼명 | 함수식 비교연산자 비교값
 * 3 : GROUP BY 그룹을 묶은 컬럼명 
 * 4 : HAVING 그룹함수식 혹은 비교연산자 비교값
 * 6 : ORDER BY 컬럼명 | 별칭 | 컬럼순번 정렬방식 [ NULLS FIRT / LAST ]
 * 
 */ 
 
-- GROUP BY절 : 같은 값들이 여러개 기록된 컬럼을 가지고
-- 같은 값들을 하나의 그룹으로 묶음

-- GROUP BY 컬럼명 | 함수식
-- 여러개의 값을 묶어서 하나로 처리할 목적으로 사용함
-- 그룹으로 묶은 값에 대해서 SELECT절에서 그룹함수를 사용함


-- EMPLOYEE 테이블에서 부서코드, 부서별 급여 합 조회

-- 1) 부서코드만 조회
SELECT DEPT_CODE FROM EMPLOYEE;


-- 2) 전체급여 합 조회
SELECT SUM(SALARY) FROM EMPLOYEE;



SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE; -> DEPT_CODE가 같은 행 끼리 하나의 그룹이 됨

-- EMPLOYEE 테이블에서 직급 코드가 같은 사람의, 평균, 인원수 를 직급코드 오름차순으로 조회
SELECT JOB_CODE, ROUND(AVG(SALARY)), COUNT(*)
FROM EMPLOYEE
GROUP BY JOB_CODE 
ORDER BY JOB_CODE;

SELECT JOB_CODE FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 성별(남/여)와 각 성별 별 인원수, 급여 합을
-- 인원 수 오름 차순으로 조회

SELECT DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2,' '여') 성별,
	COUNT(*) "인원 수",
	SUM(SALARY) "급여 합"
FROM EMPLOYEE
GROUP BY  DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2,' '여') -- 별칭 사용이X (SELECT절 해석 X)
ORDER BY "인원 수"; -- 별칭사용 O ( SELECT절 해석 완료)


------------------------------------------------------------


-- EMPLOYEE 테이블에서 부속 코드가 D5,D6인 부서의 평균 급여, 인원 수 조회

SELECT  DEPT_CODE, ROUND(AVG(SALARY)) , COUNT(*)
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5','D6')
GROUP BY DEPT_CODE;

-- EMPLOYEE 테이블에서 2000년도 이후(포함) 입사자들의 급여 합을 조회
--


-- EMPLOYEE 테이블에서 직급 코드가 같은 사람의, 평균, 인원수 를 직급코드 오름차순으로 조회
-- 직급 코드 오름차순

SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
WHERE EXTRACT(YEAR FROM HIRE_DATE) >= 2000 
-- HIRE_DATE >= TO_DATE('2000-01-01')
-- TO_NUMBER(STUBSTR(TO_CHAR(HIRE_DATE),1,4,)) >= 2000
GROUP BY JOB_CODE
ORDER BY 1;

-- EMPLOYEE 테이블에서 부서별로 같은 직급인 사원의 수를 조회
-- 부서코드 오름차순, 직급코드 내림차순
SELECT DEPT_CODE, JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE -- DEPT_CODE로 그룹을 나누고
							 -- 나눠진 그룹 내에서 JOB_CODE로 또 그룹을 분류
						 	 -- 세분화

ORDER BY DEPT_CODE, JOB_CODE DESC;


-- GROUP BY 사용 시 주의사항

--> SELECT문에 GROUP BY절을 사용할 경우
-- SELECT절에 명시한 조회하려는 컬럼 중
-- 그룹 함수가 적용되지 않은 컬럼을
-- 모두 GROUP BY 절에 작성해야한다.

---------------------------------------------------------

-- 부서 별 평균 급여가 300만원 이상인 부서를 조회(부서코드 오름차순)

SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE
-- WHERE SALARY >= 3000000 --> 한 사람의 급여가 300만 이상이라는 조건
GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 3000000 --> DEPT_CODE 그룹 중 급여 평균이 300만원 이상인 그룹만 남음
ORDER BY DEPT_CODE;

-- DEPT_CODE 그룹핑 중 -- 조건 맞는애(문제)를 걸러낸다 -- HAVING 사용


-- EMPLOYEE 테이블에서 직급별 인원수가 5명 이하인 직급코드, 인원 수 조회 (직급코드는 오름차순)

SELECT JOB_CODE, COUNT(*) 
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING COUNT(*) <= 5 -- HAVING 절에는 [그룹함수]가 반드시 작성된다는 특징!!!
ORDER BY 1;


-------------------------------SELECT문 끝--------------------------------------


-- 각 절들의 의미 + 해석순서 맨 위 제일 중요

1. 참조테이블 작성 ( EMPLOYEE )
2. 원하는 행들 골라냄
3. 그룹을 묶음 ( 주민번호로 남자 색출 )
4. 묶은 그룹중 평균 몇 합계 몇? 거르기 ( 색출된 남자들 중 300만원 이상 )
5. 나타 낼 컬럼들 나열
6. 정렬

+ 테이블 열어서 체크하며 보기

/*/-- SELECT문 해석순서 매우 중요
 * 
 * 5 : SELECT 컬럼명 AS 별칭, 계산식,함수식
 * 1: FROM 참조할 테이블 명
 * 2: WHERE 컬럼명 | 함수식 비교연산자 비교값
 * 3 : GROUP BY 그룹을 묶은 컬럼명 
 * 4 : HAVING 그룹함수식 혹은 비교연산자 비교값
 * 6 : ORDER BY 컬럼명 | 별칭 | 컬럼순번 정렬방식 [ NULLS FIRT / LAST ]
 * 
 */ 