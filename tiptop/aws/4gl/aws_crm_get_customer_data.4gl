# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_crm_get_customer_data.4gl
# Descriptions...: 提供取得 ERP 客戶資料服務
# Date & Author..: 2009/04/15 by sabrina
# Memo...........:
# Modify.........: FUN-930139 2010/08/13 by Lilan 追版(GP5.1==>GP5.2)
#
#}

DATABASE ds

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

#[
# Description....: 提供取得 ERP 客戶資料服務(入口 function)
# Date & Author..: 2009/04/15 by sabrina
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_crm_get_customer_data()

    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()   #呼叫服務前置處理程序

    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                        #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_crm_get_customer_data_process()
    END IF
    
    CALL aws_ttsrv_postprocess()    #呼叫服務後置處理程序
END FUNCTION


#[
# Description....: 查詢 ERP 客戶編號
# Date & Author..: 2009/04/15 by sabrina
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_crm_get_customer_data_process()
    DEFINE l_occ       RECORD 
                       occ01   LIKE occ_file.occ01,
                       occ02   LIKE occ_file.occ02,
                       occ04   LIKE occ_file.occ04,
                       gen03   LIKE gen_file.gen03,
                       occ42   LIKE occ_file.occ42,
                       occ32   LIKE occ_file.occ32,
                       occ62   LIKE occ_file.occ62,
                       CreditBalance LIKE occ_file.occ63,
                       occ64   LIKE occ_file.occ64,
                       gec06   LIKE gec_file.gec06,
                       gec07   LIKE gec_file.gec07,
                       occ44   LIKE occ_file.occ44,
                       occ45   LIKE occ_file.occ45,
                       occ38   LIKE occ_file.occ38,
                       gec05   LIKE gec_file.gec05,
                       occ61   LIKE occ_file.occ61
                       END RECORD 
    DEFINE l_occ01     LIKE occ_file.occ01                   
    DEFINE l_node      om.DomNode
    DEFINE l_sql       STRING
    DEFINE l_cnt       smallint
    DEFINE l_wc        STRING

    LET l_occ01 = aws_ttsrv_getParameter("occ01")   #取由呼叫端呼叫時給予的 SQL Condition

    SELECT COUNT(*) INTO l_cnt FROM occ_file
     WHERE occ01 = l_occ01

    IF l_cnt=0 THEN
    	 LET g_status.code = "mfg2732"   #無此客戶
       RETURN
    END IF     
    
    LET l_sql = " SELECT occ01,occ02,occ04,gen03,occ42,occ32,occ62,0,occ64,gec06,gec07",
                " ,occ44,occ45,occ38,gec05,occ61 ",
                " FROM occ_file LEFT OUTER JOIN gen_file ON occ_file.occ04=gen_file.gen01 ",
                " LEFT OUTER JOIN gec_file ON occ_file.occ41=gec_file.gec01 and gec_file.gec011='2' ",
                " WHERE occ_file.occacti = 'Y' AND occ_file.occ01=? ORDER BY occ_file.occ01 "                 
                 
    DECLARE occ_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
    FOREACH occ_curs USING l_occ01 INTO l_occ.*    	  

        CALL s_ccc(l_occ01,'3','') RETURNING l_occ.CreditBalance #信用餘額
        LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_occ), "occ_file")
    END FOREACH

    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF

END FUNCTION
#FUN-930139
