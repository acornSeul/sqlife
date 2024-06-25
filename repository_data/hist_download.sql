/*
 * 통합문서, 이미지, 엑셀, PPT, PDF 의 다운로드 기록을 확인하기 위한 쿼리
 * 작성일자 : 2024-05-17
 * */

-- 통합문서 외 다운로드 기록
SELECT 
	hr.http_request_uri  AS reqeust_uri
	, CASE SPLIT_PART(controller, '/', 7)
		WHEN 'power-point-export-server' THEN 'PPT 다운로드'
		WHEN 'export-pdf-server' THEN 'PDF 다운로드'
		WHEN 'export-image-server' THEN '이미지 다운로드'
		WHEN 'export-crosstab-to-excel-server' THEN '엑셀 다운로드'
	END AS action_type
	, hr.created_at
	, COALESCE(u.name, '* 삭제 계정') AS name
	, w.name AS workbooks
	--, hr."action" 
	--, hr.remote_ip
	--, hr.user_ip
	--, hr.port
FROM 
	http_requests hr LEFT JOIN
	-- 사용자 정보 추가
	(
		SELECT u.id
		, su."name" 
		FROM users u INNER JOIN system_users su 
			ON u.system_user_id  = su.id 
	)u 
	ON hr.user_id = u.id
	-- workbook 정보 추가
	LEFT JOIN workbooks w ON SPLIT_PART(hr.currentsheet, '/', 1) = w.repository_url 
WHERE
	1=1
	AND "action" = 'sessions'
	AND SPLIT_PART(controller, '/', 7) 
		IN ('power-point-export-server' -- PPT 다운로드
			, 'export-pdf-server' -- PDF 다운로드
			, 'export-image-server' -- 이미지 다운로드
			, 'export-crosstab-to-excel-server' -- 엑셀 다운로드
			)

UNION ALL
			
-- 통합문서 다운로드 기록
SELECT 
	hw.repository_url AS request_uri
	, '통합문서 다운로드' AS action_type 
	, he.created_at
	, COALESCE(hu.name, '* 삭제 계정') AS name
	, hw."name" AS workbooks
FROM 
	historical_events he 
		-- event_type 추가
		LEFT JOIN historical_event_types het ON he.historical_event_type_id = het.type_id 
		-- workbook 정보 추가
		LEFT JOIN hist_workbooks hw ON he.hist_workbook_id = hw.id
		-- 사용자 정보 추가
		LEFT JOIN hist_users hu ON he.hist_actor_user_id = hu.id 
WHERE 
	1=1
	AND he.historical_event_type_id = 99
