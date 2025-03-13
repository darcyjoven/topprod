# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_transaction_category.4gl
# Descriptions...: 提供--讀取帳款類別資料
# Date & Author..: 2010/01/13 by Mandy
# Memo...........:
# Modify.........: 新建立 FUN-A10069
# Modify.........: No.FUN-AA0022 10/10/13 By Mandy HR GP5.2 追版
# Modify.........: No.FUN-C50126 12/12/22 By Abby HRM功能改善:若無資料時,需show無資料,提醒User非Service連線未成功
#
#}

DATABASE ds

#FUN-A10069

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
GLOBALS "../4gl/aws_ttsrv2_global.4gl"  #TIPTOP Service Gateway 使用的全域變數檔 #FUN-AA0022 add

DEFINE g_table     STRING

#[
# Description....: 提供--讀取帳款類別資料服務(入口 function)
# Date & Author..: 2010/01/13 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_transaction_category()
    
    WHENEVER ERROR CONTINUE
    
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 
    
    #--------------------------------------------------------------------------#
    # 查詢 帳款類別名稱檔
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_transaction_category_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序    
END FUNCTION


#[
# Description....: 查詢 帳款類別名稱檔
# Date & Author..: 2010/01/13 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_transaction_category_process()
    DEFINE l_apr       RECORD LIKE apr_file.*
    DEFINE l_node      om.DomNode
    DEFINE l_sql       STRING
    DEFINE l_wc        STRING
    DEFINE l_cnt_is_0  LIKE type_file.chr1 #FUN-C50126 add
 
    LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition
   
    IF cl_null(l_wc) THEN
       LET l_wc = " 1=1" 
    END IF

    #FUN-AA0022---add----str---
    IF g_access.application = "HR" THEN
        LET l_wc = " apracti = 'Y' AND apr01 IN (SELECT apt01 FROM apt_file WHERE apt07 IS NOT NULL AND aptacti = 'Y') "
    END IF
    #FUN-AA0022---add----end---
    
    LET l_sql="SELECT * FROM apr_file WHERE ",l_wc,
              " ORDER BY apr01"
  
    DECLARE apr_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
 
    LET l_cnt_is_0 = 'Y'  #FUN-C50126  add   
    FOREACH apr_curs INTO l_apr.*
        
       LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_apr), "apr_file")   #加入此筆單檔資料至 Response 中
       LET l_cnt_is_0 = 'N'  #FUN-C50126  add
    END FOREACH

    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF

    #FUN-C50126---add---str---
    IF g_access.application = "HR" THEN
        IF l_cnt_is_0 = 'Y' THEN
            LET g_status.code = 'aws-809'   #TIPTOP 應付帳款系統帳款類別科目維護作業(aapi203)未設定OK ,非Service不通 !
            LET g_status.sqlcode = 'aws-809'
        END IF
    END IF
    #FUN-C50126---add---end---
END FUNCTION
