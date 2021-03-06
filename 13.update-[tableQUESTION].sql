use WISE_STAGING

update M_MKT_POLO_QUESTION_LIST set IS_MANDATORY=1 where QUESTION_IDENTIFIER like '%_upd_status_mss%'
			
update M_MKT_POLO_QUESTION_LIST set IS_MANDATORY=1 where QUESTION_IDENTIFIER in ('id_name_UPD_STATUS_WISE','ORDER_ID_UPD_STATUS_WISE','STATUS_MSS_WISE_UPD_STATUS_WISE')


update M_MKT_POLO_QUESTION_LABEL set RESPONSE_NUMERIC='09' where QUESTION_CODE IN ('INSTALMENT_AMT','PO_DP','PO_TENOR')
			
update M_MKT_POLO_QUESTION_LABEL set RESPONSE_NUMERIC = null,RESPONSE_DATE='11' where QUESTION_CODE='po_date'