/*
 * 프로젝트 별, 통합문서 별 사용하는 데이터원본을 확인하기 위함
 * datasource_type
 *  1) sqlproxy : customSQL 사용
 *  2) excel-direct : 엑셀 파일 로컬 연결
 *  3) federated : join 한 데이터
 *  4) db명 (presto, postgres, googledrive 등) : 각 db 연결
 *  5) textscan : csv, txt 파일 연결
 *  6) hyper : hyper 파일 연결
 * */

-- 재귀쿼리 사용
WITH project AS (
	WITH RECURSIVE recur as (
		-- 시작 쿼리 : 최상위 프로젝트
		SELECT 
			id
			, "name"
			, parent_project_id
			, 1 as "lvl"
			, "name" :: TEXT AS paths
		FROM 
			PROJECTS P 
		WHERE 
			parent_project_id IS NULL
		UNION ALL
		
		-- 반복구조 : 하위 프로젝트
		SELECT 
			p.id
			, p."name"
			, p.PARENT_PROJECT_ID 
			, r.lvl + 1
			, r.paths || ' / ' || p."name"
		FROM 
			recur r
			INNER JOIN PROJECTS P ON r.id = p.PARENT_PROJECT_ID
	)
	SELECT *
			, TRIM(SPLIT_PART(paths, '/', 1)) AS project1 
			, TRIM(SPLIT_PART(paths, '/', 2)) AS project2
			, TRIM(SPLIT_PART(paths, '/', 3)) AS project3
			, TRIM(SPLIT_PART(paths, '/', 4)) AS project4
			, TRIM(SPLIT_PART(paths, '/', 5)) AS project5
			, TRIM(SPLIT_PART(paths, '/', 6)) AS project6
	FROM 
		recur
)
SELECT 
	p.id AS project_id
	, p.name AS project_name
	, p.lvl AS project_lvl
	, p.paths AS project_paths
	, p.project1
	, p.project2
	, p.project3
	, p.project4
	, p.project5
	, p.project6
	, w.name AS workbook_name
	, w.created_at AS wb_created_date
	, w.updated_at AS wb_updated_date
	, COALESCE(d.name, '') AS datasource_name
	, COALESCE(d.db_class, '') AS datasource_type
	, d.hidden_name AS hidden_name
FROM project p 
	LEFT JOIN workbooks w ON p.id = w.project_id
	LEFT JOIN datasources d ON d.parent_workbook_id = w.id
WHERE 
	1=1
