# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_so_info_data.4gl
# Descriptions...: 提供取得 ERP 訂單資訊資料服務
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
 
#[
# Description....: 提供取得 ERP 訂單資訊資料服務(入口 function)
# Date & Author..: 2007/07/13 by Mandy #FUN-770051
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_so_info_data()
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 取得ERP訂單資訊資料                                                      #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_so_info_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序    
END FUNCTION
 
 
#[
# Description....: 取得ERP訂單資訊資料
# Date & Author..: 2007/07/13 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_so_info_data_process()
   #訂單單號,客戶代碼,客戶簡稱,訂單日期,預計出貨日,交易代碼,交易條件,產品編號,產品名稱,數量 ,已出貨數
   #oea01   ,oea03   ,oea032  ,oea02   ,oeb15     ,oea32   ,''      ,oeb04   ,oeb06   ,oeb12,oeb24
    DEFINE l_fld       RECORD 
              fld01   LIKE oea_file.oea01,       #訂單單號
              fld02   LikE oea_file.oea03,       #客戶代碼
              fld03   LIKE oea_file.oea032,      #客戶簡稱
              fld04   LIkE oea_file.oea02,       #訂單日期
              fld05   LIKE oeb_file.oeb15,       #預計出貨日
              fld06   LIKE oea_file.oea32,       #交易代碼
              fld07   LIKE oag_file.oag02,       #交易條件
              fld08   LIKE oeb_file.oeb04,       #產品編號
              fld09   LIKE oeb_file.oeb06,       #產品名稱
              fld10   LIKE oeb_file.oeb12,       #數量
              fld11   LIKE oeb_file.oeb24        #已出貨數
           END RECORD 
    DEFINE l_node      om.DomNode
    DEFINE l_sql       STRING
    DEFINE l_i         LIKE type_file.num5       #筆數
 
#mandy--------str---
   #--------------------------------------------------------------------------#
   #依據資料條件(condition),抓取訂單資訊資料                                  #
   #--------------------------------------------------------------------------#
   #訂單單號,客戶代碼,客戶簡稱,訂單日期,預計出貨日,交易代碼,交易條件,產品編號,產品名稱,數量 ,已出貨數
   #oea01   ,oea03   ,''      ,oea02   ,oeb15     ,oea32   ,''      ,oeb04   ,oeb06   ,oeb12,oeb24
   #只需抓出最近的前10筆訂單單身資料
   
    LET l_sql = "SELECT oea01,oea03,oea032,oea02,oeb15,oea32,'',oeb04,oeb06,oeb12,oeb24,oeb03",
                "  FROM oea_file,oeb_file",
                " WHERE oea01=oeb01 ",
                "   AND oea00 <>'0' ",
                "   AND oeaconf = 'Y' ",
                "   AND oeahold IS NULL ",
                " ORDER BY oea02 DESC,oea01 DESC,oeb03"
 
    DECLARE getSOInfoData_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    LET l_i = 0
    FOREACH getSOInfoData_curs INTO l_fld.*
        LET l_i = l_i + 1
        SELECT oag02 INTO l_fld.fld07 
          FROM oag_file
         WHERE oag01 = l_fld.fld06
        
        LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_fld), "tmp_file")
        #只需抓出最近的前10筆訂單單身資料
        IF l_i = 10 THEN
            EXIT FOREACH
        END IF
        
    END FOREACH
#mandy--------end---
 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION
