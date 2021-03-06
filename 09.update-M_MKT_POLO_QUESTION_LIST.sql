USE WISE_STAGING
GO
DECLARE @ALIAS VARCHAR(100)='_MAIND_CUST_ACQ' 


 /*SURVEY*/
UPDATE A
SET ANSWER_TYPE=ISNULL(ANSWER_TYPE,'EXPRESSION')
,LOV = 'SELECT TOP 1 C.NAME
					FROM CONFINS.DBO.REF_ZIPCODE RZ WITH (NOLOCK)  
					JOIN CONFINS.DBO.REF_PROV_DISTRICT B WITH (NOLOCK) ON B.REF_PROV_DISTRICT_ID = RZ.REF_PROV_DISTRICT_ID  
					JOIN CONFINS.DBO.REF_PROV_DISTRICT C WITH (NOLOCK) ON C.REF_PROV_DISTRICT_ID = B.PARENT_ID  
					WHERE RZ.IS_ACTIVE = ''1'' AND RZ.CITY NOT IN (''KOTA'',''KABUPATEN'') and C.NAME=@SURVEY_PROVINCE'
FROM M_MKT_POLO_QUESTION_LIST A
WHERE QUESTION_IDENTIFIER in ('SURVEY_PROVINCE'+@ALIAS)

UPDATE A
SET ANSWER_TYPE=ISNULL(ANSWER_TYPE,'EXPRESSION')
,LOV = 'SELECT TOP 1 RZ.CITY	
					FROM CONFINS.DBO.REF_ZIPCODE RZ WITH (NOLOCK)  
					JOIN CONFINS.DBO.REF_PROV_DISTRICT B WITH (NOLOCK) ON B.REF_PROV_DISTRICT_ID = RZ.REF_PROV_DISTRICT_ID  
					WHERE RZ.IS_ACTIVE = ''1'' AND RZ.CITY NOT IN (''KOTA'',''KABUPATEN'') and  RZ.CITY=@SURVEY_CITY'
FROM M_MKT_POLO_QUESTION_LIST A
WHERE QUESTION_IDENTIFIER in ('SURVEY_CITY'+@ALIAS)

UPDATE A
SET ANSWER_TYPE=ISNULL(ANSWER_TYPE,'EXPRESSION')
,LOV = 'SELECT  TOP 1  RZ.KECAMATAN
					FROM CONFINS.DBO.REF_ZIPCODE RZ WITH (NOLOCK)  
					JOIN CONFINS.DBO.REF_PROV_DISTRICT B WITH (NOLOCK) ON B.REF_PROV_DISTRICT_ID = RZ.REF_PROV_DISTRICT_ID  
					WHERE RZ.IS_ACTIVE = ''1'' AND RZ.CITY NOT IN (''KOTA'',''KABUPATEN'')  and   RZ.KECAMATAN=@SURVEY_SUB_DISTRICT'
FROM M_MKT_POLO_QUESTION_LIST A
WHERE QUESTION_IDENTIFIER in ('SURVEY_SUB_DISTRICT'+@ALIAS)


UPDATE A
SET ANSWER_TYPE=ISNULL(ANSWER_TYPE,'EXPRESSION')
,LOV = 'SELECT TOP 1 RZ.KELURAHAN
					FROM CONFINS.DBO.REF_ZIPCODE RZ WITH (NOLOCK)  
					JOIN CONFINS.DBO.REF_PROV_DISTRICT B WITH (NOLOCK) ON B.REF_PROV_DISTRICT_ID = RZ.REF_PROV_DISTRICT_ID  
					WHERE RZ.IS_ACTIVE = ''1'' AND RZ.CITY NOT IN (''KOTA'',''KABUPATEN'') and  RZ.KELURAHAN=@SURVEY_VILLAGE'
FROM M_MKT_POLO_QUESTION_LIST A
WHERE QUESTION_IDENTIFIER in ('SURVEY_VILLAGE'+@ALIAS)


UPDATE A
SET ANSWER_TYPE=ISNULL(ANSWER_TYPE,'EXPRESSION')
,LOV = 'SELECT TOP 1 RZ.ZIPCODE
					FROM CONFINS.DBO.REF_ZIPCODE RZ WITH (NOLOCK)  
					JOIN CONFINS.DBO.REF_PROV_DISTRICT B WITH (NOLOCK) ON B.REF_PROV_DISTRICT_ID = RZ.REF_PROV_DISTRICT_ID  
					WHERE RZ.IS_ACTIVE = ''1'' AND RZ.CITY NOT IN (''KOTA'',''KABUPATEN'') and RZ.ZIPCODE=@SURVEY_CITY_ID'
FROM M_MKT_POLO_QUESTION_LIST A
WHERE QUESTION_IDENTIFIER in ('SURVEY_CITY_ID'+@ALIAS)


/*LEGAL*/
UPDATE A
SET ANSWER_TYPE=ISNULL(ANSWER_TYPE,'EXPRESSION')
,LOV = 'SELECT TOP 1  C.NAME
					FROM CONFINS.DBO.REF_ZIPCODE RZ WITH (NOLOCK)  
					JOIN CONFINS.DBO.REF_PROV_DISTRICT B WITH (NOLOCK) ON B.REF_PROV_DISTRICT_ID = RZ.REF_PROV_DISTRICT_ID  
					JOIN CONFINS.DBO.REF_PROV_DISTRICT C WITH (NOLOCK) ON C.REF_PROV_DISTRICT_ID = B.PARENT_ID  
					WHERE RZ.IS_ACTIVE = ''1'' AND RZ.CITY NOT IN (''KOTA'',''KABUPATEN'') and C.NAME=@PROVINCE'
FROM M_MKT_POLO_QUESTION_LIST A
WHERE QUESTION_IDENTIFIER in ('PROVINCE'+@ALIAS)

UPDATE A
SET ANSWER_TYPE=ISNULL(ANSWER_TYPE,'EXPRESSION')
,LOV = 'SELECT TOP 1 RZ.CITY
					FROM CONFINS.DBO.REF_ZIPCODE RZ WITH (NOLOCK)  
					JOIN CONFINS.DBO.REF_PROV_DISTRICT B WITH (NOLOCK) ON B.REF_PROV_DISTRICT_ID = RZ.REF_PROV_DISTRICT_ID  
					WHERE RZ.IS_ACTIVE = ''1'' AND RZ.CITY NOT IN (''KOTA'',''KABUPATEN'') and  RZ.CITY=@CITY'
FROM M_MKT_POLO_QUESTION_LIST A
WHERE QUESTION_IDENTIFIER in ('CITY'+@ALIAS)

UPDATE A
SET ANSWER_TYPE=ISNULL(ANSWER_TYPE,'EXPRESSION')
,LOV = 'SELECT TOP 1 RZ.KECAMATAN
					FROM CONFINS.DBO.REF_ZIPCODE RZ WITH (NOLOCK)  
					JOIN CONFINS.DBO.REF_PROV_DISTRICT B WITH (NOLOCK) ON B.REF_PROV_DISTRICT_ID = RZ.REF_PROV_DISTRICT_ID  
					WHERE RZ.IS_ACTIVE = ''1'' AND RZ.CITY NOT IN (''KOTA'',''KABUPATEN'')  and   RZ.KECAMATAN=@SUB_DISTRICT'
FROM M_MKT_POLO_QUESTION_LIST A
WHERE QUESTION_IDENTIFIER in ('SUB_DISTRICT'+@ALIAS)


UPDATE A
SET ANSWER_TYPE=ISNULL(ANSWER_TYPE,'EXPRESSION')
,LOV =  'SELECT TOP 1 RZ.KELURAHAN
					FROM CONFINS.DBO.REF_ZIPCODE RZ WITH (NOLOCK)  
					JOIN CONFINS.DBO.REF_PROV_DISTRICT B WITH (NOLOCK) ON B.REF_PROV_DISTRICT_ID = RZ.REF_PROV_DISTRICT_ID  
					WHERE RZ.IS_ACTIVE = ''1'' AND RZ.CITY NOT IN (''KOTA'',''KABUPATEN'') and  RZ.KELURAHAN=@VILLAGE'
FROM M_MKT_POLO_QUESTION_LIST A
WHERE QUESTION_IDENTIFIER in ('VILLAGE'+@ALIAS)


UPDATE A
SET ANSWER_TYPE=ISNULL(ANSWER_TYPE,'EXPRESSION')
,LOV = 'SELECT TOP 1 RZ.ZIPCODE
					FROM CONFINS.DBO.REF_ZIPCODE RZ WITH (NOLOCK)  
					JOIN CONFINS.DBO.REF_PROV_DISTRICT B WITH (NOLOCK) ON B.REF_PROV_DISTRICT_ID = RZ.REF_PROV_DISTRICT_ID  
					WHERE RZ.IS_ACTIVE = ''1'' AND RZ.CITY NOT IN (''KOTA'',''KABUPATEN'') and RZ.ZIPCODE=@CITY_ID'
FROM M_MKT_POLO_QUESTION_LIST A
WHERE QUESTION_IDENTIFIER in ('CITY_ID'+@ALIAS)



/*SEND MSS ARRAY*/
DECLARE @ALIAS2 VARCHAR(100)='_MAIND_SEND_MSS' 

UPDATE A
SET ANSWER_TYPE=ISNULL(ANSWER_TYPE,'EXPRESSION')
,LOV = 'NAME_MARKETPLACE+'' - ''+ID_MARKETPLACE'
FROM M_MKT_POLO_QUESTION_LIST A
WHERE QUESTION_IDENTIFIER in ('DEALER_CODE'+@ALIAS2)

UPDATE A
SET ANSWER_TYPE=ISNULL(ANSWER_TYPE,'EXPRESSION')
,LOV = 'CAST(FLAG_MASTER AS CHAR(1))'
FROM M_MKT_POLO_QUESTION_LIST A
WHERE QUESTION_IDENTIFIER in ('FLAG_MASTER'+@ALIAS2)

UPDATE A
SET ANSWER_TYPE=ISNULL(ANSWER_TYPE,'EXPRESSION')
,LOV = 'FORMAT(BIRTH_DT ,''dd/MM/yyyy'')'
FROM M_MKT_POLO_QUESTION_LIST A
WHERE QUESTION_IDENTIFIER in ('BIRTH_DT'+@ALIAS2)