USE WISE_STAGING
GO

DECLARE @count INT = 0	--jangan dirubah
	,@counter INT = 1	--jangan dirubah
	,@questionCode VARCHAR(1000)
	,@countErr INT
	,@table VARCHAR(100)
DECLARE @flagGroup_H INT
	,@flagGroup_D INT
	,@flagMasterLabel INT
	,@flagMasterList INT
	,@alias VARCHAR(100)
	,@flagShowError INT
	,@flagShowAllLabel INT
	,@flagUpdUsrCrt INT
	,@updateMandatory INT

DECLARE @usrCrt VARCHAR(100)
	,@dtmCrt DATETIME
DECLARE @GroupName VARCHAR(100)

/*setting Flag 1=true, 0=false*/
BEGIN
	SELECT @flagGroup_H		= 1						-- perlu add group H ? jika true, wajib mengisi variable @GroupName
		  ,@flagGroup_D		= 1						-- perlu add group D ?
		  ,@flagMasterLabel = 1						-- perlu add master label ?
		  ,@flagMasterList	= 1						-- perlu add master list ?
		  ,@alias			= '_UPD_STATUS_WISE'		-- diawali dengan underscore _ untuk penamaan Question Identifier
		  ,@flagShowError	= 1						-- show Error ketika proses selesai
		  ,@flagShowAllLabel= 1						-- show Semua data yang berhasil di regist ketika proses selesai
		  ,@flagUpdUsrCrt	= 0						-- untuk update usrt menjadi 'Webpooling' ketika proses selesai
		  ,@updateMandatory = 0						-- set semua field sebagai Mandatory
END

/*setting user date*/
BEGIN
	SET @usrCrt = 'Maindealer'+@alias	--jangan dirubah
	SET @dtmCrt = getdate()					--jangan dirubah
END

/*setting Group H*/
SET @GroupName = 'maindealer_upd_status_wise' -- nama group baru 

BEGIN TRAN

CREATE TABLE #ListLogErr (
	num INT
	,[Table] VARCHAR(100)
	,QuestionCode VARCHAR(100)
	,ErrMssg VARCHAR(max)
	)

/*daftar Label yang akan ditambahkan*/
BEGIN 
 
	SELECT REPLACE('ID_NAME',' ','')QuestionCode    , REPLACE('idName',' ','')QuestionApi,1 as seq  INTO #tempLabelCode  UNION
	SELECT REPLACE('ORDER_ID',' ','')    , REPLACE('orderId',' ',''),2 UNION
	SELECT REPLACE('OFFICE_CODE',' ','')    , REPLACE('officeCode',' ',''),3 UNION
	SELECT REPLACE('STATUS_MSS_WISE',' ','')    , REPLACE('statusWise',' ',''),4 UNION
	SELECT REPLACE('AGRMNT_NO',' ','')    , REPLACE('agrmntNo',' ',''),5 UNION
	SELECT REPLACE('PO_NO',' ','')    , REPLACE('poNo',' ',''),6 UNION
	SELECT REPLACE('PO_DATE',' ','')    , REPLACE('poDate',' ',''),7 UNION
	SELECT REPLACE('PO_DP',' ','')    , REPLACE('poDp',' ',''),8 UNION
	SELECT REPLACE('PO_TENOR',' ','')    , REPLACE('poTenor',' ',''),9 UNION
	SELECT REPLACE('TYPE_ID',' ','')    , REPLACE('assetCode',' ',''),10 UNION
	SELECT REPLACE('INSTALMENT_AMT',' ','')    , REPLACE('instalmentAmt',' ',''),11
END

/*populate data*/
SELECT ROW_NUMBER() OVER (
		ORDER BY seq ASC
		) AS num
	,QuestionCode
	,QuestionApi  
INTO #labelCode
FROM #tempLabelCode

SELECT *
INTO #labelCodeList
FROM #labelCode

SELECT *
INTO #labelQGroupD
FROM #labelCode

IF @flagGroup_H=1
BEGIN
	PRINT 'insert H'

	INSERT INTO [M_MKT_POLO_QUESTIONGROUP_H] (
		QUESTIONGROUP_NAME
		,IS_ACTIVE
		,USR_CRT
		,DTM_CRT
		)
	SELECT @GroupName QUESTIONGROUP_NAME
		,'1' IS_ACTIVE
		,@usrCrt USR_CRT
		,@dtmCrt DTM_CRT
END

PRINT 'insert label'

SELECT @count = count(1)
FROM #LabelCode

PRINT 'REGIST LABEL, Total Label : ' + cast(@count AS VARCHAR(10))

IF @flagMasterLabel=1
BEGIN
	WHILE @counter <= @count
	BEGIN
		PRINT '===================[ ' + cast(@counter AS VARCHAR(100)) + 'of ' + cast(@count AS VARCHAR(100)) + ' ]==================='

		BEGIN TRY
			SET @table = 'M_MKT_POLO_QUESTION_LABEL'

			SELECT @questionCode = QuestionCode
			FROM #LabelCode
			WHERE num = @counter

			INSERT INTO M_MKT_POLO_QUESTION_LABEL (
				QUESTION_CODE
				,QUESTION_LABEL
				,USR_CRT
				,DTM_CRT
				)
			SELECT QuestionCode QUESTION_CODE
				,REPLACE(QuestionCode, '_', ' ') QUESTION_LABEL
				,@usrCrt USR_CRT
				,@dtmCrt DTM_CRT
			FROM #LabelCode
			WHERE num = @counter

			SET @counter += 1
		END TRY

		BEGIN CATCH
			INSERT INTO #ListLogErr
			VALUES (
				@counter
				,@table
				,@questionCode
				,ERROR_MESSAGE()
				)

			DELETE
			FROM #LabelCode
			WHERE num = @counter
		END CATCH
	END
END

SELECT @count = count(1)
	,@counter = 1
FROM #LabelCodeList
IF @flagMasterList=1
BEGIN
	WHILE @counter <= @count
	BEGIN
		PRINT '===================[ ' + cast(@counter AS VARCHAR(100)) + 'of ' + cast(@count AS VARCHAR(100)) + ' ]==================='

		BEGIN TRY
			SET @table = 'M_MKT_POLO_QUESTION_LIST'

			INSERT [dbo].[M_MKT_POLO_QUESTION_LIST] (
				[M_MKT_POLO_QUESTION_LABEL_ID]
				,[QUESTION_IDENTIFIER]
				,[ANSWER_TYPE]
				,[IS_ACTIVE]
				,[USR_CRT]
				,[DTM_CRT]
				)
			SELECT [M_MKT_POLO_QUESTION_LABEL_ID]
				,UPPER(QUESTION_CODE) + @alias [QUESTION_IDENTIFIER]
				,NULL [ANSWER_TYPE]
				,1 [IS_ACTIVE]
				,@usrCrt USR_CRT
				,@dtmCrt DTM_CRT
			FROM M_MKT_POLO_QUESTION_LABEL
			WHERE QUESTION_CODE = (
					SELECT QuestionCode
					FROM #LabelCodeList
					WHERE num = @counter
					)

			SET @counter += 1
		END TRY

		BEGIN CATCH
			INSERT INTO #ListLogErr
			VALUES (
				@counter
				,@table
				,@questionCode
				,ERROR_MESSAGE()
				)

			DELETE
			FROM #LabelCodeList
			WHERE num = @counter
		END CATCH
	END
END

SELECT @count = count(1)
	,@counter = 1
FROM #labelQGroupD

IF @flagGroup_D=1
BEGIN
	WHILE @counter <= @count
	BEGIN
		PRINT '===================[ ' + cast(@counter AS VARCHAR(100)) + 'of ' + cast(@count AS VARCHAR(100)) + ' ]==================='

		BEGIN TRY
			SET @table = 'M_MKT_POLO_QUESTIONGROUP_D'

			INSERT [dbo].[M_MKT_POLO_QUESTIONGROUP_D] (
				[M_MKT_POLO_QUESTIONGROUP_H_ID]
				,[QUESTION_IDENTIFIER]
				,[QUESTION_API]
				,[SEQUENCE]
				,[IS_ACTIVE]
				,[USR_CRT]
				,[DTM_CRT]
				)
			SELECT [M_MKT_POLO_QUESTIONGROUP_H_ID]
				,(
					SELECT QUESTION_CODE + @alias
					FROM M_MKT_POLO_QUESTION_LABEL
					WHERE QUESTION_CODE = (
							SELECT QuestionCode
							FROM #labelQGroupD
							WHERE num = @counter
							)
					) [QUESTION_IDENTIFIER]
				,(
					SELECT QuestionApi
					FROM #labelQGroupD
					WHERE num = @counter
					) [QUESTION_API]
				,@counter [SEQUENCE]
				,1 [IS_ACTIVE]
				,@usrCrt [USR_CRT]
				,@dtmCrt [DTM_CRT]
			FROM [M_MKT_POLO_QUESTIONGROUP_H]
			WHERE [QUESTIONGROUP_NAME] = @GroupName

			SET @counter += 1
		END TRY

		BEGIN CATCH
			INSERT INTO #ListLogErr
			VALUES (
				@counter
				,@table
				,@questionCode
				,ERROR_MESSAGE()
				)

			DELETE
			FROM #labelQGroupD
			WHERE num = @counter
		END CATCH
	END
END

PRINT 'insert done'

SELECT @countErr = count(1)
FROM #ListLogErr

SELECT 'Regist Label Done, Success :  Error : ' + cast(@countErr AS VARCHAR(10)) as Result

IF @flagShowError=1
SELECT * FROM #ListLogErr 

IF @flagShowAllLabel=1
BEGIN
	SELECT USR_CRT NEW,'M_MKT_POLO_QUESTION_LABEL'[TABLE], QUESTION_CODE, QUESTION_LABEL FROM WISE_STAGING..M_MKT_POLO_QUESTION_LABEL WHERE USR_CRT=@usrCrt
	SELECT USR_CRT NEW,'M_MKT_POLO_QUESTION_LIST'[TABLE], QUESTION_IDENTIFIER, M_MKT_POLO_QUESTION_LABEL_ID FROM WISE_STAGING..M_MKT_POLO_QUESTION_LIST WHERE USR_CRT=@usrCrt
	SELECT USR_CRT NEW,'M_MKT_POLO_QUESTIONGROUP_H'[TABLE], QUESTIONGROUP_NAME FROM WISE_STAGING..M_MKT_POLO_QUESTIONGROUP_H WHERE USR_CRT=@usrCrt
	SELECT USR_CRT NEW,'M_MKT_POLO_QUESTIONGROUP_D'[TABLE], QUESTION_IDENTIFIER, QUESTION_API FROM WISE_STAGING..M_MKT_POLO_QUESTIONGROUP_D WHERE USR_CRT=@usrCrt
END

IF @flagUpdUsrCrt=1
BEGIN
	UPDATE A
	SET USR_CRT='Webpooling'
	FROM WISE_STAGING..M_MKT_POLO_QUESTION_LABEL A WHERE USR_CRT=@usrCrt

	UPDATE A
	SET USR_CRT='Webpooling'
	FROM WISE_STAGING..M_MKT_POLO_QUESTION_LIST A WHERE USR_CRT=@usrCrt

	UPDATE A
	SET USR_CRT='Webpooling'
	FROM WISE_STAGING..M_MKT_POLO_QUESTIONGROUP_H A WHERE USR_CRT=@usrCrt

	UPDATE A
	SET USR_CRT='Webpooling'
	FROM WISE_STAGING..M_MKT_POLO_QUESTIONGROUP_D A WHERE USR_CRT=@usrCrt
END

IF @updateMandatory = 1
BEGIN
	UPDATE A
	SET A.IS_MANDATORY=1
	FROM M_MKT_POLO_QUESTION_LIST A
	WHERE A.QUESTION_IDENTIFIER IN (SELECT QuestionCode+@alias FROM #labelCodeList)
	
END


DROP TABLE #ListLogErr
DROP TABLE #tempLabelCode
DROP TABLE #labelCode
DROP TABLE #labelCodeList
DROP TABLE #labelQGroupD

COMMIT TRAN
