USE WISE_STAGING
GO



IF (
		SELECT count(1)
		FROM CONFINS.dbo.Mst_file_parameter WITH (NOLOCK)
		WHERE PARAMETER_NAME = 'PATH_LOG_ERROR_MARKETPLACE'
		) > 0
BEGIN
	/*update log path temp*/
	UPDATE A
	SET PARAMETER_VALUE = 'media\Error_Log',
	CREATED_DATE = getdate(),
	CREATED_USER = 'Maindealer'
	FROM CONFINS.dbo.Mst_file_parameter a
	WHERE PARAMETER_NAME = 'PATH_LOG_ERROR_MARKETPLACE'
END
ELSE
BEGIN
	INSERT INTO CONFINS.dbo.Mst_file_parameter (
		PARAMETER_NAME
		,PARAMETER_VALUE
		,NOTES
		,CREATED_USER
		,CREATED_DATE
		)
	VALUES (
		'PATH_LOG_ERROR_MARKETPLACE'
		,'media\Error_Log'
		,'Path untuk menyimpan file log error Marketplace'
		,'Maindealer'
		,getdate()
		)
END


IF (
		SELECT count(1)
		FROM CONFINS.dbo.Mst_file_parameter WITH (NOLOCK)
		WHERE PARAMETER_NAME = 'PATH_LOG_TEMP_FILE_MARKETPLACE'
		) > 0
BEGIN
	/*update log path temp*/
	UPDATE A
	SET PARAMETER_VALUE = 'media\marketplace',
	CREATED_DATE = getdate(),
	CREATED_USER = 'Maindealer'
	FROM CONFINS.dbo.Mst_file_parameter a
	WHERE PARAMETER_NAME = 'PATH_LOG_TEMP_FILE_MARKETPLACE'
END
ELSE
BEGIN
	INSERT INTO CONFINS.dbo.Mst_file_parameter (
		PARAMETER_NAME
		,PARAMETER_VALUE
		,NOTES
		,CREATED_USER
		,CREATED_DATE
		)
	VALUES (
		'PATH_LOG_TEMP_FILE_MARKETPLACE'
		,'media\marketplace'
		,'Path untuk menyimpan temporary image Marketplace'
		,'Maindealer'
		,getdate()
		)
END