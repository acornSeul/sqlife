/*
 * Tableau Server의 웹편집 기록을 확인하기 위함
 * 작성일자 : 2024-05-20
 * */
SELECT 
	hr.controller 
	, CASE hr."action" 
		WHEN 'show' THEN '웹 편집'
		WHEN 'publish' THEN '게시'
	END AS "action"
--	, hr.http_referer 
	, hr.created_at
	, w.id AS workbook_id
	, W.repository_url 
	, CASE 
		WHEN w."name" IS NOT NULL THEN CONCAT('https://tableau.hotel.lotte.net/#/workbooks/', w.id, '/views')
		ELSE '* 삭제된 통합문서'
	END AS workbook_url
	, COALESCE(u."name", '* 삭제된 계정') AS user_name
	, COALESCE(w."name", '* 삭제된 통합문서') AS workbook_name
	, CASE WHEN w."name" IS NULL THEN 'Y' ELSE 'N' END AS delete_yn
FROM 
	http_requests hr LEFT JOIN
	-- 사용자 정보 추가
	(
		SELECT u.id
		, su."name" 
		FROM users u INNER JOIN system_users su 
			ON u.system_user_id  = su.id 
	)u ON hr.user_id = u.id
	-- 통합문서 정보 추가
	LEFT JOIN workbooks w ON SPLIT_PART(hr.currentsheet, '/', 1) = w.repository_url 
WHERE 
	(SPLIT_PART(controller, '/', 2) = 'authoring' OR "action" = 'publish') -- 웹편집 및 게시만
	AND http_referer != 'https://tableau.hotel.lotte.net/' -- 홈페이지 접속 제외
ORDER BY 
	hr.created_at DESC
