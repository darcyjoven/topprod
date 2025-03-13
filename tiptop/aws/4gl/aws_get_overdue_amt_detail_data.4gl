# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_overdue_amt_detail_data.4gl
# Descriptions...: 提供取得 ERP 逾期帳款排行明細資料服務
# Date & Author..: 2007/07/19 by Mandy
# Memo...........:
# Modify.........: 新建立 FUN-770051
# Modify.........: No.FUN-860037 08/06/20 By Kevin 升級到aws_ttsrv2
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#FUN-760069
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
DEFINE g_table     STRING
 
#[
# Description....: 提供取得 ERP 逾期帳款排行明細資料服務(入口 function)
# Date & Author..: 2007/07/19 by Mandy #FUN-770051
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_overdue_amt_detail_data()
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 取得ERP逾期帳款排行明細資料                                                       #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_overdue_amt_detail_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 取得ERP逾期帳款排行明細資料
# Date & Author..: 2007/07/19 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_overdue_amt_detail_data_process()
    DEFINE l_fld       RECORD 
              fld01    LIKE oma_file.oma03,       #帳款客戶編號
              fld02    LIKE oma_file.oma032,      #帳款客戶簡稱 
              fld03    LIKE type_file.num20,      #逾期帳款總金額
              fld11    LIKE type_file.num20,
              fld12    LIKE type_file.num20,
              fld13    LIKE type_file.num20,
              fld14    LIKE type_file.num20,
              fld15    LIKE type_file.num20,
              fld16    LIKE type_file.num20,
              fld17    LIKE type_file.num20,
              fld18    LIKE type_file.num20,
              fld19    LIKE type_file.num20,
              fld20    LIKE type_file.num20,
              fld21    LIKE type_file.num20
           END RECORD 
    DEFINE l_oma       RECORD LIKE oma_file.*    #應收/待抵帳款單頭檔
    DEFINE l_oma03     LIKE oma_file.oma03
    DEFINE l_net       LIKE oox_file.oox10       
    DEFINE l_tmp03     LIKE oma_file.oma57
    DEFINE l_d         ARRAY[10] OF LIKE type_file.num5  #逾期帳款區間D1~D10
    DEFINE l_rang_amt  ARRAY[11] OF LIKE type_file.num20 #逾期帳款區間金額
    DEFINE l_tot_amt   ARRAY[11] OF LIKE type_file.num20 #逾期帳款區間總金額
    DEFINE l_sum_amt   LIKE type_file.num20              #逾期帳款總金額
    DEFINE l_days      LIKE type_file.num5       #天數
    DEFINE l_i         LIKE type_file.num5       #計算用
    DEFINE l_j         LIKE type_file.num5       #計算用
    DEFINE l_count     LIKE type_file.num5       #輸入幾個區間
    DEFINE l_node      om.DomNode
    DEFINE l_sql       STRING
    DEFINE l_wc        STRING
 
    LET g_table = "tmp_file"
 
    
#mandy--------str---
   #--------------------------------------------------------------------------#
   #抓取逾期帳款排行明細資料
   #--------------------------------------------------------------------------#   
    LET l_oma03 = aws_ttsrv_getParameter("oma03")
    LET l_d[1] = aws_ttsrv_getParameter("d1")
    LET l_d[2] = aws_ttsrv_getParameter("d2")
    LET l_d[3] = aws_ttsrv_getParameter("d3")
    LET l_d[4] = aws_ttsrv_getParameter("d4")
    LET l_d[5] = aws_ttsrv_getParameter("d5")
    LET l_d[6] = aws_ttsrv_getParameter("d6")
    LET l_d[7] = aws_ttsrv_getParameter("d7")
    LET l_d[8] = aws_ttsrv_getParameter("d8")
    LET l_d[9] = aws_ttsrv_getParameter("d9")
    LET l_d[10] = aws_ttsrv_getParameter("d10")    
    
    LET l_count = 0
    FOR l_i = 1 TO 10
        IF NOT cl_null(l_d[l_i]) THEN
            LET l_count = l_count + 1
        ELSE
            EXIT FOR
        END IF
    END FOR
    LET l_i = 10
 
    DROP TABLE tmp_file
    CREATE TEMP TABLE tmp_file(                                                                                                       
       tmp01   LIKE oma_file.oma03,       #帳款客戶編號
       tmp02   LIKE oma_file.oma032,      #帳款客戶簡稱 
       tmp03   LIKE oma_file.oma57,       #逾期帳款金額
       tmp04   LIKE type_file.num5)       #逾期天數
    CREATE INDEX tmp_01 ON tmp_file (tmp01)
    LET g_today = TODAY #在cl_setup()抓的變數,皆需寫在此程式
   #--------------------------------------------------------------------------#
   #依據資料條件(condition),抓明細資料                                  
   #--------------------------------------------------------------------------#
    LET l_wc = ' 1=1'
    IF NOT cl_null(l_oma03) THEN
       LET l_wc = l_wc CLIPPED," AND oma03 = '",l_oma03,"'"
    END IF
    LET l_sql = "SELECT * ",
                "  FROM oma_file",
                " WHERE ",l_wc CLIPPED,
                "   AND omaconf = 'Y' ",
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
        LET l_days = g_today - l_oma.oma02  
 
        INSERT INTO tmp_file VALUES (l_oma.oma03,l_oma.oma032,l_tmp03,l_days)
        
    END FOREACH
 
    LET l_sql = "SELECT tmp01,tmp02,SUM(tmp03)", 
                "  FROM tmp_file ",
                "GROUP BY tmp01,tmp02 "
 
    DECLARE get_tmp_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    INITIALIZE l_fld.* TO NULL
    LET l_sum_amt = 0
    FOREACH get_tmp_curs INTO l_fld.fld01,l_fld.fld02,l_fld.fld03
        FOR l_i = 1 TO l_count 
             IF l_i = 1 THEN
                 SELECT SUM(tmp03) INTO l_rang_amt[l_i]
                   FROM tmp_file
                  WHERE tmp01 = l_fld.fld01
                    AND tmp02 = l_fld.fld02
                    AND tmp04 < l_d[l_i] 
             ELSE
                 SELECT SUM(tmp03) INTO l_rang_amt[l_i]
                   FROM tmp_file
                  WHERE tmp01 = l_fld.fld01
                    AND tmp02 = l_fld.fld02
                    AND tmp04 >= l_d[l_i-1]
                    AND tmp04 < l_d[l_i]
             END IF
             IF cl_null(l_rang_amt[l_i]) THEN LET l_rang_amt[l_i] = 0 END IF
        END FOR
        SELECT SUM(tmp03) INTO l_rang_amt[l_i]
          FROM tmp_file
         WHERE tmp01 = l_fld.fld01
           AND tmp02 = l_fld.fld02
           AND tmp04 >= l_d[l_i-1]
        LET l_sum_amt = l_sum_amt + l_fld.fld03
        IF cl_null(l_rang_amt[l_i]) THEN LET l_rang_amt[l_i] = 0 END IF
        IF l_count >= 0 THEN
           LET l_fld.fld11 = l_rang_amt[1]
           IF cl_null(l_tot_amt[1]) THEN LET l_tot_amt[1] = 0 END IF
           LET l_tot_amt[1] = l_tot_amt[1] + l_rang_amt[1]
        END IF
        IF l_count >= 1 THEN
           LET l_fld.fld12 = l_rang_amt[2]
           IF cl_null(l_tot_amt[2]) THEN LET l_tot_amt[2] = 0 END IF
           LET l_tot_amt[2] = l_tot_amt[2] + l_rang_amt[2]
        END IF
        IF l_count >= 2 THEN
           LET l_fld.fld13 = l_rang_amt[3]
           IF cl_null(l_tot_amt[3]) THEN LET l_tot_amt[3] = 0 END IF
           LET l_tot_amt[3] = l_tot_amt[3] + l_rang_amt[3]
        END IF
        IF l_count >= 3 THEN
           LET l_fld.fld14 = l_rang_amt[4]
           IF cl_null(l_tot_amt[4]) THEN LET l_tot_amt[4] = 0 END IF
           LET l_tot_amt[4] = l_tot_amt[4] + l_rang_amt[4]
        END IF
        IF l_count >= 4 THEN
           LET l_fld.fld15 = l_rang_amt[5]
           IF cl_null(l_tot_amt[5]) THEN LET l_tot_amt[5] = 0 END IF
           LET l_tot_amt[5] = l_tot_amt[5] + l_rang_amt[5]
        END IF
        IF l_count >= 5 THEN
           LET l_fld.fld16 = l_rang_amt[6]
           IF cl_null(l_tot_amt[6]) THEN LET l_tot_amt[6] = 0 END IF
           LET l_tot_amt[6] = l_tot_amt[6] + l_rang_amt[6]
        END IF
        IF l_count >= 6 THEN
           LET l_fld.fld17 = l_rang_amt[7]
           IF cl_null(l_tot_amt[7]) THEN LET l_tot_amt[7] = 0 END IF
           LET l_tot_amt[7] = l_tot_amt[7] + l_rang_amt[7]
        END IF
        IF l_count >= 7 THEN
           LET l_fld.fld18 = l_rang_amt[8]
           IF cl_null(l_tot_amt[8]) THEN LET l_tot_amt[8] = 0 END IF
           LET l_tot_amt[8] = l_tot_amt[8] + l_rang_amt[8]
        END IF
        IF l_count >= 8 THEN
           LET l_fld.fld19 = l_rang_amt[9]
           IF cl_null(l_tot_amt[9]) THEN LET l_tot_amt[9] = 0 END IF
           LET l_tot_amt[9] = l_tot_amt[9] + l_rang_amt[9]
        END IF
        IF l_count >= 9 THEN
           LET l_fld.fld20 = l_rang_amt[10]
           IF cl_null(l_tot_amt[10]) THEN LET l_tot_amt[10] = 0 END IF
           LET l_tot_amt[10] = l_tot_amt[10] + l_rang_amt[10]
        END IF
        IF l_count >= 10 THEN
           LET l_fld.fld21 = l_rang_amt[11]
           IF cl_null(l_tot_amt[11]) THEN LET l_tot_amt[11] = 0 END IF
           LET l_tot_amt[11] = l_tot_amt[11] + l_rang_amt[11]
        END IF
 
        LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_fld), g_table)   #加入此筆單檔資料至 Response 中
        INITIALIZE l_fld.* TO NULL
        FOR l_j = 1 TO 11
             LET l_rang_amt[l_j]=NULL
        END FOR
 
    END FOREACH
 
    #總計部份==>
    #------------------------------------------------------------------#
    # 解析 RecordSet, 回傳於 Table 欄位                                #
    #------------------------------------------------------------------#
    LET l_fld.fld01 = 'TOTAL' 
    LET l_fld.fld02 = ''
    LET l_fld.fld03 = l_sum_amt
    LET l_fld.fld11 = l_tot_amt[1]
    LET l_fld.fld12 = l_tot_amt[2]
    LET l_fld.fld13 = l_tot_amt[3]
    LET l_fld.fld14 = l_tot_amt[4]
    LET l_fld.fld15 = l_tot_amt[5]
    LET l_fld.fld16 = l_tot_amt[6]
    LET l_fld.fld17 = l_tot_amt[7]
    LET l_fld.fld18 = l_tot_amt[8]
    LET l_fld.fld19 = l_tot_amt[9]
    LET l_fld.fld20 = l_tot_amt[10]
    LET l_fld.fld21 = l_tot_amt[11]
    LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_fld), g_table)   #加入此筆單檔資料至 Response 中    
 
#mandy--------end---
 
END FUNCTION
