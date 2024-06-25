/*
 * 필요에 따라 site_id, content 테이블, authorizable_type 변경 필요
 * 
 * View : 보기
 * Filter : 필터
 * View Comment : 댓글 보기
 * Add Comment : 댓글 추가
 * Export Image : 이미지/PDF 다운로드
 * Export Data : 요약 데이터 다운로드
 * Share Customized : 사용자 지정 항목 공유
 * View Underlying Data : 전체 데이터 다운로드
 * Web Authoring : 웹 편집
 * Explain Data : 데이터 설명 실행
 * Download File : 복사본 다운로드/저장
 * Write : 덮어쓰기
 */
SELECT 
	pm.authorizable_type AS contents_type
	, pm.name AS contents_name
	, pm.grantee_type AS user_group_type
	, pm.user_group_name 
	-- 권한 레벨 설정 > 1 : 권한 O / -1 : 권한 거부 / 0 : 설정 X
	, COALESCE(MAX(CASE WHEN c.id = '1' THEN pm.permission_lvl  END), '0') AS view
	, COALESCE(MAX(CASE WHEN c.id = '3' THEN pm.permission_lvl END), '0') AS filter
	, COALESCE(MAX(CASE WHEN c.id = '10' THEN pm.permission_lvl END), '0') AS view_comments
	, COALESCE(MAX(CASE WHEN c.id = '9' THEN pm.permission_lvl END), '0') AS add_comment
	, COALESCE(MAX(CASE WHEN c.id = '7' THEN pm.permission_lvl END), '0') AS export_image
	, COALESCE(MAX(CASE WHEN c.id = '8' THEN pm.permission_lvl END), '0') AS export_data
	, COALESCE(MAX(CASE WHEN c.id = '21' THEN pm.permission_lvl END), '0') AS share_customized
	, COALESCE(MAX(CASE WHEN c.id = '4' THEN pm.permission_lvl END), '0') AS view_underlying_data
	, COALESCE(MAX(CASE WHEN c.id = '33' THEN pm.permission_lvl END), '0') AS web_authoring
	, COALESCE(MAX(CASE WHEN c.id = '46' THEN pm.permission_lvl END), '0') AS explain_data
	, COALESCE(MAX(CASE WHEN c.id = '17' THEN pm.permission_lvl END), '0') AS download_file
	, COALESCE(MAX(CASE WHEN c.id = '2' THEN pm.permission_lvl END), '0') AS WRITE
	, COALESCE(MAX(CASE WHEN c.id = '45' THEN pm.permission_lvl END), '0') AS create_refresh_metrics
	, COALESCE(MAX(CASE WHEN c.id = '18' THEN pm.permission_lvl END), '0') AS MOVE
	, COALESCE(MAX(CASE WHEN c.id = '13' THEN pm.permission_lvl END), '0') AS DELETE
	, COALESCE(MAX(CASE WHEN c.id = '14' THEN pm.permission_lvl END), '0') AS set_permission
	, COALESCE(MAX(CASE WHEN c.id = '44' THEN pm.permission_lvl END), '0') AS save_as
	, COALESCE(MAX(CASE WHEN c.id = '32' THEN pm.permission_lvl END), '0') AS CONNECT
	, COALESCE(MAX(CASE WHEN c.id = '37' THEN pm.permission_lvl END), '0') AS execute
/* capability에 있는 나머지 항목
 * 	, COALESCE(MAX(CASE WHEN c.id = '5' THEN pm.permission_lvl END), '0') AS exclude
	, COALESCE(MAX(CASE WHEN c.id = '6' THEN pm.permission_lvl END), '0') AS keep_only
	, COALESCE(MAX(CASE WHEN c.id = '11' THEN pm.permission_lvl END), '0') AS administrator
	, COALESCE(MAX(CASE WHEN c.id = '12' THEN pm.permission_lvl END), '0') AS create_groups
	, COALESCE(MAX(CASE WHEN c.id = '15' THEN pm.permission_lvl END), '0') AS rename
	, COALESCE(MAX(CASE WHEN c.id = '16' THEN pm.permission_lvl END), '0') AS transfer_ownership
	, COALESCE(MAX(CASE WHEN c.id = '19' THEN pm.permission_lvl END), '0') AS project_leader
	, COALESCE(MAX(CASE WHEN c.id = '20' THEN pm.permission_lvl END), '0') AS publish
	, COALESCE(MAX(CASE WHEN c.id = '22' THEN pm.permission_lvl END), '0') AS drawing
	, COALESCE(MAX(CASE WHEN c.id = '24' THEN pm.permission_lvl END), '0') AS add_tag
	, COALESCE(MAX(CASE WHEN c.id = '25' THEN pm.permission_lvl END), '0') AS add_favorite
	, COALESCE(MAX(CASE WHEN c.id = '26' THEN pm.permission_lvl END), '0') AS select_marks
	, COALESCE(MAX(CASE WHEN c.id = '27' THEN pm.permission_lvl END), '0') AS view_tooltips
	, COALESCE(MAX(CASE WHEN c.id = '28' THEN pm.permission_lvl END), '0') AS legend_highlighting
	, COALESCE(MAX(CASE WHEN c.id = '29' THEN pm.permission_lvl END), '0') AS link_to_external_urls
	, COALESCE(MAX(CASE WHEN c.id = '30' THEN pm.permission_lvl END), '0') AS content_administrator
	, COALESCE(MAX(CASE WHEN c.id = '31' THEN pm.permission_lvl END), '0') AS permalink
	, COALESCE(MAX(CASE WHEN c.id = '34' THEN pm.permission_lvl END), '0') AS inherited_project_leader 
	, COALESCE(MAX(CASE WHEN c.id = '35' THEN pm.permission_lvl END), '0') AS add_new_datasource
	, COALESCE(MAX(CASE WHEN c.id = '36' THEN pm.permission_lvl END), '0') AS create_data_alert
	, COALESCE(MAX(CASE WHEN c.id = '38' THEN pm.permission_lvl END), '0') AS web_authoring_for_flows
	, COALESCE(MAX(CASE WHEN c.id = '39' THEN pm.permission_lvl END), '0') AS ask_data
	, COALESCE(MAX(CASE WHEN c.id = '40' THEN pm.permission_lvl END), '0') AS create
	, COALESCE(MAX(CASE WHEN c.id = '41' THEN pm.permission_lvl END), '0') AS edit_published_connection
	, COALESCE(MAX(CASE WHEN c.id = '42' THEN pm.permission_lvl END), '0') AS personal_sapce
	, COALESCE(MAX(CASE WHEN c.id = '43' THEN pm.permission_lvl END), '0') AS write_personal_space
	, COALESCE(MAX(CASE WHEN c.id = '47' THEN pm.permission_lvl END), '0') AS operate_edge_pool
	, COALESCE(MAX(CASE WHEN c.id = '48' THEN pm.permission_lvl END), '0') AS can_veiw_all_content
	, COALESCE(MAX(CASE WHEN c.id = '49' THEN pm.permission_lvl END), '0') AS can_query_other_users*/
FROM 
   (SELECT *
	FROM 
		-- 권한 테이블
		(SELECT *
			, CASE 
				WHEN "permission" IN ('1', '3') THEN '1'
				WHEN "permission" IN ('2', '4') THEN '-1'									
			END AS permission_lvl
		FROM 
			next_gen_permissions) ngp
			-- 컨텐츠 정보 (workbooks, projects, datasources, flows..)
			LEFT JOIN flows contents 
			ON ngp.authorizable_id = contents.id
	
			-- 유저 및 그룹 정보
			INNER JOIN (
						SELECT 
							u.id -- 유저 ID
							, su.friendly_name  AS user_group_name -- 표시이름
							, 'User' AS TYPE
						FROM 
							users u 
							INNER JOIN system_users su 
							ON u.system_user_id  = su.id
							
						UNION ALL
						
						SELECT
							id -- 그룹 ID
							, "name" AS user_group_name -- 표시이름
							, 'Group' AS type
						FROM 
							"groups"
					)user_group
			ON ngp.grantee_id = user_group.id AND ngp.grantee_type = user_group.TYPE		
		WHERE 
			LOWER(authorizable_type) = 'flow'
			AND contents.site_id = '1'
		)pm 
		
		LEFT JOIN capabilities c 
		ON pm.capability_id = c.id
GROUP BY 1, 2, 3, 4
ORDER BY 
	pm.name, pm.grantee_type , pm.user_group_name
