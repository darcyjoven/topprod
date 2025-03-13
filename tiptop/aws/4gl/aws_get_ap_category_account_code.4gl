# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_ap_category_account_code.4gl
# Descriptions...: 提供--讀取帳款類別預設會計科目資料
# Date & Author..: 2012/06/04 by Mandy
# Memo...........:
# Modify.........: 新建立 FUN-C50126
#
#}

DATABASE ds

#FUN-A10069

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
GLOBALS "../4gl/aws_ttsrv2_global.4gl"  #TIPTOP Service Gateway 使用的全域變數檔 #FUN-AA0022 add

DEFINE g_table     STRING

#[
# Description....: 提供--讀取帳款類別預設會計科目資料服務(入口 function)
# Date & Author..: 2012/06/04 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_ap_category_account_code()
    
    WHENEVER ERROR CONTINUE
    
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 
    
    #--------------------------------------------------------------------------#
    # 查詢 帳款類別預設會計科目名稱檔
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_ap_category_account_code_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序    
END FUNCTION


#[
# Description....: 查詢 帳款類別預設會計科目名稱檔
# Date & Author..: 2012/06/04 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_ap_category_account_code_process()
   #DEFINE l_apt       RECORD LIKE apt_file.*
    DEFINE l_apt       RECORD    
                           apt01        LIKE apt_file.apt01  ,
                           apt02        LIKE apt_file.apt02  ,
                           apt03        LIKE apt_file.apt03  ,
                           apt031       LIKE apt_file.apt031 ,
                           apt032       LIKE apt_file.apt032 ,
                           apt033       LIKE apt_file.apt033 ,
                           apt034       LIKE apt_file.apt034 ,
                           apt035       LIKE apt_file.apt035 ,
                           apt036       LIKE apt_file.apt036 ,
                           apt037       LIKE apt_file.apt037 ,
                           apt038       LIKE apt_file.apt038 ,
                           apt039       LIKE apt_file.apt039 ,
                           apt04        LIKE apt_file.apt04  ,
                           apt05        LIKE apt_file.apt05  ,
                           aptacti      LIKE apt_file.aptacti,
                           aptuser      LIKE apt_file.aptuser,
                           aptgrup      LIKE apt_file.aptgrup,
                           aptmodu      LIKE apt_file.aptmodu,
                           aptdate      LIKE apt_file.aptdate,
                           apt041       LIKE apt_file.apt041 ,
                           aptud01      LIKE apt_file.aptud01,
                           aptud02      LIKE apt_file.aptud02,
                           aptud03      LIKE apt_file.aptud03,
                           aptud04      LIKE apt_file.aptud04,
                           aptud05      LIKE apt_file.aptud05,
                           aptud06      LIKE apt_file.aptud06,
                           aptud07      LIKE apt_file.aptud07,
                           aptud08      LIKE apt_file.aptud08,
                           aptud09      LIKE apt_file.aptud09,
                           aptud10      LIKE apt_file.aptud10,
                           aptud11      LIKE apt_file.aptud11,
                           aptud12      LIKE apt_file.aptud12,
                           aptud13      LIKE apt_file.aptud13,
                           aptud14      LIKE apt_file.aptud14,
                           aptud15      LIKE apt_file.aptud15,
                           apt06        LIKE apt_file.apt06  ,
                           apt061       LIKE apt_file.apt061 ,
                           aptoriu      LIKE apt_file.aptoriu,
                           aptorig      LIKE apt_file.aptorig,
                           apt07        LIKE apt_file.apt07  ,
                           apt08        LIKE apt_file.apt08  ,
                           pmc03        LIKE pmc_file.pmc03,
                           apydesc      LIKE apy_file.apydesc,
                           apydmy3      LIKE apy_file.apydmy3 #是否拋轉傳票                  
                       END RECORD
    DEFINE l_node      om.DomNode
    DEFINE l_sql       STRING
    DEFINE l_wc        STRING
    DEFINE l_cnt_is_0  LIKE type_file.chr1 
 
    LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition
   
    IF cl_null(l_wc) THEN
       LET l_wc = " 1=1" 
    END IF

    #For HR專屬的條件
    IF g_access.application = "HR" THEN
        LET l_wc = " apt07 IS NOT NULL AND aptacti = 'Y' "
    END IF
    #
    
    LET l_sql="SELECT * FROM apt_file WHERE ",l_wc,
              " ORDER BY apt01"
  
    DECLARE apt_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
    LET l_cnt_is_0 = 'Y'  
    FOREACH apt_curs INTO l_apt.*
       IF g_access.application = "HR" THEN
           LET l_apt.pmc03   = ''
           LET l_apt.apydesc = ''
           LET l_apt.apydmy3 = ''
           IF NOT cl_null(l_apt.apt07) THEN
               SELECT pmc03 INTO l_apt.pmc03 FROM pmc_file 
                WHERE pmc01 = l_apt.apt07
           END IF
           IF NOT cl_null(l_apt.apt08) THEN
               SELECT apydesc,apydmy3 
                 INTO l_apt.apydesc,l_apt.apydmy3
                 FROM apy_file 
                WHERE apyslip = l_apt.apt08
           END IF
       END IF
       LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_apt), "apt_file")   #加入此筆單檔資料至 Response 中
       LET l_cnt_is_0 = 'N'  
    END FOREACH

    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    IF g_access.application = "HR" THEN
        IF l_cnt_is_0 = 'Y' THEN
            LET g_status.code = 'aws-809'   #TIPTOP 應付帳款系統帳款類別預設會計科目科目維護作業(aapi203)未設定OK ,非Service不通 !
            LET g_status.sqlcode = 'aws-809'
        END IF
    END IF
END FUNCTION
#FUN-C50126
