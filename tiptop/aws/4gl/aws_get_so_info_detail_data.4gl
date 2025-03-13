# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_so_info_detail_data.4gl
# Descriptions...: 提供取得 ERP 訂單資訊明細資料服務
# Date & Author..: 2007/07/13 by Mandy
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
# Description....: 提供取得 ERP 訂單資訊明細資料服務(入口 function)
# Date & Author..: 2007/07/13 by Mandy #FUN-770051
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_so_info_detail_data()
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 取得ERP訂單資訊明細資料                                                      #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_so_info_detail_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序    
END FUNCTION
 
 
#[
# Description....: 取得ERP訂單資訊明細資料
# Date & Author..: 2007/07/13 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_so_info_detail_data_process()
    DEFINE l_fld       RECORD 
              fld01   LIKE oea_file.oea01,       #訂單編號
              fld02   LIKE oea_file.oea02,       #訂單日期
              fld03   LIKE oea_file.oea03,       #帳款客戶
              fld04   LIKE oea_file.oea032,      #客戶簡稱
              fld05   LIKE oea_file.oea04,       #送貨客戶
              fld06   LIKE occ_file.occ02,       #客戶簡稱
              fld07   LIKE oeb_file.oeb03,       #項次
              fld08   LIKE oeb_file.oeb04,       #產品編號
              fld09   LIKE oeb_file.oeb06,       #品名
              fld10   LIKE ima_file.ima021,      #規格
              fld11   LIKE oeb_file.oeb05,       #單位
              fld12   LIKE oeb_file.oeb12,       #數量
              fld13   LIKE oeb_file.oeb13,       #單價
              fld14   LIKE oeb_file.oeb14,       #金額
              fld15   LIKE oeb_file.oeb15,       #預交日
              fld16   LIKE oga_file.oga01,       #出貨單號
              fld17   LIKE ogb_file.ogb03,       #項次
              fld18   LIKE oga_file.oga02,       #出貨日期
              fld19   LIKE ogb_file.ogb12,       #出貨數量
              fld20   LIKE ogb_file.ogb13,       #單價
              fld21   LIKE oma_file.oma01,       #立帳單號
              fld22   LIKE omb_file.omb03,       #項次
              fld23   LIKE oma_file.oma10        #發票號碼
           END RECORD 
    DEFINE l_oga            RECORD
                            oga01    LIKE oga_file.oga01,
                            ogb03    LIKE ogb_file.ogb03,
                            oga02    LIKE oga_file.oga02,
                            ogb12    LIKE ogb_file.ogb12,
                            ogb13    LIKE ogb_file.ogb13
                            END RECORD 
    DEFINE l_oma            RECORD
                            oma01    LIKE oma_file.oma01,
                            omb03    LIKE omb_file.omb03,
                            oma10    LIKE oma_file.oma10
                            END RECORD
    DEFINE l_node      om.DomNode
    DEFINE l_sql       STRING
    DEFINE l_wc        STRING
    DEFINE l_cnt       LIKE type_file.num5       #筆數
 
    LET g_table = "tmp_file"   
 
#mandy--------str---
   #--------------------------------------------------------------------------#
   #依據資料條件(condition),抓取訂單資訊明細資料                                  
   #--------------------------------------------------------------------------#
   LET l_wc  = aws_ttsrv_getParameter("condition")
    IF cl_null(l_wc) THEN
       LET l_wc = " 1=1 "
    END IF
    LET l_sql = "SELECT ",
                " oea01,oea02,oea03,oea032,oea04,''   ,oeb03,oeb04,oeb06,''    ,oeb05,oeb12,oeb13,oeb14,oeb15 ",
                "  FROM oea_file,oeb_file",
                " WHERE oea01=oeb01 ",
                "   AND oea00 <>'0' ",
                "   AND oeaconf = 'Y' ",
                "   AND oeahold IS NULL ",
                "   AND ",l_wc,
                " ORDER BY oea02,oea01,oeb03"
 
    DECLARE getSOInfoDetailData_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    LET l_cnt = 0
    INITIALIZE l_fld.* TO NULL
    INITIALIZE l_oga.* TO NULL
    INITIALIZE l_oma.* TO NULL
    FOREACH getSOInfoDetailData_curs INTO l_fld.*
    	  IF SQLCA.SQLCODE THEN
           LET g_status.code = SQLCA.SQLCODE
           LET g_status.sqlcode = SQLCA.SQLCODE
           RETURN
        END IF
        
        SELECT occ02 INTO l_fld.fld06
          FROM occ_file
         WHERE occ01 = l_fld.fld05
        SELECT ima021 INTO l_fld.fld10
          FROM ima_file
         WHERE ima01 = l_fld.fld08
 
        #出貨單資料==>
        SELECT COUNT(*) INTO l_cnt
          FROM oga_file,ogb_file
         WHERE oga01=ogb01 
           AND ogb31=l_fld.fld01
           AND ogb32=l_fld.fld07
           AND ogaconf='Y'
           AND oga09 NOT IN ('1','5','7','9')  
        IF l_cnt >=1 THEN
            DECLARE get_oga_curs CURSOR FOR
            SELECT oga01,oga02,ogb03,ogb12,ogb13,oga23 
              FROM oga_file,ogb_file
             WHERE oga01=ogb01 
               AND ogb31=l_fld.fld01
               AND ogb32=l_fld.fld07
               AND ogaconf='Y'
               AND oga09 NOT IN ('1','5','7','9')  
               ORDER BY oga01,ogb03
            FOREACH get_oga_curs INTO l_oga.*
                LET l_fld.fld16 = l_oga.oga01       #出貨單號
                LET l_fld.fld17 = l_oga.ogb03       #項次
                LET l_fld.fld18 = l_oga.oga02       #出貨日期
                LET l_fld.fld19 = l_oga.ogb12       #出貨數量
                LET l_fld.fld20 = l_oga.ogb13       #單價
                #帳款資料==>
                LET l_cnt = 0
                SELECT COUNT(*) INTO l_cnt
                  FROM oma_file,omb_file
                 WHERE oma01=omb01 
                   AND omb31=l_oga.oga01
                   AND omb32=l_oga.ogb03 
                   AND omaconf='Y'
                IF l_cnt >= 1 THEN
                    DECLARE get_oma_curs CURSOR FOR
                    SELECT oma01,omb03,oma10 
                      FROM oma_file,omb_file
                     WHERE oma01=omb01 
                       AND omb31=l_oga.oga01
                       AND omb32=l_oga.ogb03 
                       AND omaconf='Y'
                       ORDER BY oma01,omb03
                    FOREACH get_oma_curs INTO l_oma.*
                        LET l_fld.fld21 = l_oma.oma01
                        LET l_fld.fld22 = l_oma.omb03
                        LET l_fld.fld23 = l_oma.oma10
                        
                        LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_fld), g_table)                        
                        INITIALIZE l_oma.* TO NULL
                    END FOREACH
                ELSE
                    
                    LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_fld), g_table)
                END IF
                INITIALIZE l_oga.* TO NULL
            END FOREACH
        ELSE
            LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_fld), g_table)
        END IF
        INITIALIZE l_fld.* TO NULL
    END FOREACH
#mandy--------end---
 
   
END FUNCTION
