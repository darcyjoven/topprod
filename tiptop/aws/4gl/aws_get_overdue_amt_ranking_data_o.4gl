# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_overdue_amt_ranking_data.4gl
# Descriptions...: 提供取得 ERP 逾期帳款排行資料服務
# Date & Author..: 2007/07/17 by Mandy
# Memo...........:
# Modify.........: 新建立 FUN-770051
# Modify.........: No.FUN-840004 08/06/17 By Echo 新架構的 Services 與舊架構必須進行區別，
#                                                 因此需調整舊 Services 的程式名稱
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#FUN-760069 #FUN-840004
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
DEFINE g_table     STRING
 
#[
# Description....: 提供取得 ERP 逾期帳款排行資料服務(入口 function)
# Date & Author..: 2007/07/17 by Mandy #FUN-770051
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_getOverdueAmtRankingData_g()
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_initial()   # 服務初始化動作
 
    #--------------------------------------------------------------------------#
    # 檢查登入資訊                                                             #
    #--------------------------------------------------------------------------#
    IF NOT aws_ttsrv_checkSignIn(g_getOverdueAmtRankingData_in.signIn) THEN    
       LET g_status.code = "aws-100"   #登入檢查錯誤
    END IF
    
    #--------------------------------------------------------------------------#
    # 取得ERP逾期帳款排行資料
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_getOverdueAmtRankingData_get()
    END IF
    
    LET g_getOverdueAmtRankingData_out.status = aws_ttsrv_getStatus()
 
END FUNCTION
 
 
#[
# Description....: 取得ERP逾期帳款排行資料
# Date & Author..: 2007/07/17 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_getOverdueAmtRankingData_get()
    DEFINE l_fld       RECORD 
              fld01   LIKE oma_file.oma03,       #帳款客戶編號
              fld02   LIKE oma_file.oma032,      #帳款客戶簡稱 
              fld03   LIKE type_file.num20       #逾期帳款金額(單位:百萬元)
           END RECORD 
    DEFINE l_oma       RECORD LIKE oma_file.*    #應收/待抵帳款單頭檔
    DEFINE l_net       LIKE oox_file.oox10       
    DEFINE l_tmp03     LIKE oma_file.oma57
    DEFINE l_ranking   LIKE type_file.num5       #顯示排名數
    DEFINE l_i         LIKE type_file.num5       #筆數
    DEFINE l_node      om.DomNode
    DEFINE l_sql       STRING
 
    LET g_table = "oma_file"
 
    #--------------------------------------------------------------------------#
    # 填充服務所使用 TABLE, 其欄位名稱及相對應他系統欄位名稱                   #
    #--------------------------------------------------------------------------#
    IF NOT aws_ttsrv_getServiceColumn(g_service) THEN
       LET g_status.code = "aws-102"   #讀取服務設定錯誤
       RETURN
    END IF
 
#mandy--------str---
   #--------------------------------------------------------------------------#
   #抓取逾期帳款排行資料
   #--------------------------------------------------------------------------#
 
   DROP TABLE tmp_file
    CREATE TEMP TABLE tmp_file(                                                                                                       
       tmp01   LIKE oma_file.oma03,       #帳款客戶編號
       tmp02   LIKE oma_file.oma032,      #帳款客戶簡稱 
       tmp03   LIKE oma_file.oma57 )      #逾期帳款金額
    CREATE INDEX tmp_01 ON tmp_file (tmp01)
    LET g_today = TODAY
    LET l_sql = "SELECT * ",
                "  FROM oma_file",
                " WHERE omaconf = 'Y' ",
                "   AND omavoid = 'N' ",
                "   AND oma00 IN ('11','12','13') ", #帳款類別屬於12/13/14 
                "   AND oma02 < '",g_today,"'"       #系統日期 - 應收款日>0
 
    DECLARE get_oma_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    SELECT * INTO g_ooz.* FROM ooz_file WHERE ooz00='0'
    FOREACH get_oma_curs INTO l_oma.*
        CALL s_ar_oox03(l_oma.oma01) RETURNING l_net
        LET l_tmp03 = l_oma.oma56t - l_oma.oma57 - l_net
        IF cl_null(l_tmp03) THEN LET l_tmp03 = 0 END IF
        IF l_tmp03 < 0 THEN LET l_tmp03 = 0 END IF
 
        INSERT INTO tmp_file VALUES (l_oma.oma03,l_oma.oma032,l_tmp03)
        
    END FOREACH
 
   #LET l_sql = "SELECT tmp01,tmp02,SUM(tmp03)", #測試時,可暫時先不除,因為測試的數據不大
    LET l_sql = "SELECT tmp01,tmp02,SUM(tmp03)/1000000 ",
                "  FROM tmp_file ",
                "GROUP BY tmp01,tmp02 ",
                "ORDER BY 3 DESC "
 
    DECLARE get_tmp_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
 
    LET l_ranking  = g_getOverdueAmtRankingData_in.ranking
    LET l_i = 0
    FOREACH get_tmp_curs INTO l_fld.*
        LET l_i = l_i + 1
        #------------------------------------------------------------------#
        # 解析 RecordSet, 回傳於 Table 欄位                                #
        #------------------------------------------------------------------#
        LET l_node = aws_ttsrv_setDataSetRecord(base.TypeInfo.create(l_fld), l_node, g_table)
 
        #只需抓出最近的前幾名的逾期帳款排行資料
        IF l_i = l_ranking THEN
            EXIT FOREACH
        END IF
        
    END FOREACH
 
#mandy--------end---
 
 
    #--------------------------------------------------------------------------#
    # Response Xml 文件改成字串                                                #
    #--------------------------------------------------------------------------#
    LET g_getOverdueAmtRankingData_out.recd = aws_ttsrv_xmlToString(l_node)
END FUNCTION
