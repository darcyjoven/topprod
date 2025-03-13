# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_purchase_stock_in_qty.4gl
# Descriptions...: 提供取得 ERP po 已收量、未收量及允收數量、倉庫/儲位資料
# Date & Author..: 2008/04/08 by kim (FUN-840012)
# Memo...........:
# Modify.........:
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
           
 
#[
# Description....: 提供取得 ERP po 已收量、未收量及允收數量、倉庫/儲位資料服務(入口 function)
# Date & Author..: 2008/04/08 by kim  (FUN-840012)
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_purchase_stock_in_qty()
 
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP po 資料                                                         #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_purchase_stock_in_qty_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
FUNCTION aws_get_purchase_stock_in_qty_process()
    CALL aws_get_purchase_stock_qty_process('1')
END FUNCTION
 
#[
# Description....: 查詢 ERP po 已收量、未收量及允收數量、倉庫/儲位資料
# Date & Author..: 2008/04/08 by kim (FUN-840012)
# Parameter......: p_rvu00 - '1':入庫 ; '2':驗退 ;'3':倉退
# Return.........: for '1':入庫 : 收貨單之 已入庫量,未入庫量,允收數量,收貨 倉庫/儲位資料
#                  for '2':驗退 : 收貨單之 已入庫量,可入庫量,允收數量,倉庫/儲位/批號
#                  for '3':倉退 : 收貨單之 已入庫量,可入庫量,允收數量,倉庫/儲位/批號
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_purchase_stock_qty_process(p_rvu00)
    DEFINE p_rvu00     LIKE rvu_file.rvu00
    DEFINE l_rvb01     LIKE rvb_file.rvb01
    DEFINE l_rvb02     LIKE rvb_file.rvb02
    DEFINE l_sql       STRING
    DEFINE l_wc        STRING
    DEFINE l_i         LIKE type_file.num10
    DEFINE l_rvb       RECORD LIKE rvb_file.*
    DEFINE l_rvv17     LIKE rvv_file.rvv17
    DEFINE l_rvv17_2_other   LIKE rvv_file.rvv17
    DEFINE l_rvv17_3_other   LIKE rvv_file.rvv17
    DEFINE l_inqty     LIKE rvb_file.rvb30
    DEFINE l_okqty     LIKE rvb_file.rvb30
    DEFINE l_rvb30     LIKE rvb_file.rvb30
    DEFINE l_rvb39     LIKE rvb_file.rvb39
    DEFINE l_return    RECORD       #回傳值必須宣告為一個 RECORD 變數, 且此 RECORD 需包含所有要回傳的欄位名稱與定義
                          rvb30     LIKE rvb_file.rvb30,   #已入庫量
                          rvb31     LIKE rvb_file.rvb31,   #可入庫量
                          rvb33     LIKE rvb_file.rvb33,   #允收數量
                          rvb36     LIKE rvb_file.rvb36,   #倉庫
                          rvb37     LIKE rvb_file.rvb37,   #儲位
                          rvb38     LIKE rvb_file.rvb38    #批號
                       END RECORD
   DEFINE l_rvv17_2    LIKE rvv_file.rvv17
   DEFINE l_rvv82_2    LIKE rvv_file.rvv82
   DEFINE l_rvv85_2    LIKE rvv_file.rvv85
   DEFINE l_qcs091     LIKE qcs_file.qcs091
   DEFINE l_qcs22      LIKE qcs_file.qcs22
   DEFINE l_qcs32      LIKE qcs_file.qcs32
   DEFINE l_qcs35      LIKE qcs_file.qcs35
   DEFINE l_qcs38      LIKE qcs_file.qcs38
   DEFINE l_qcs41      LIKE qcs_file.qcs41
   DEFINE l_okqty_rvv82 LIKE rvv_file.rvv82
   DEFINE l_okqty_rvv85 LIKE rvv_file.rvv85
   DEFINE l_rvv82       LIKE rvv_file.rvv82
   DEFINE l_rvv85       LIKE rvv_file.rvv85
 
 
    LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition
    LET l_rvb01 = aws_ttsrv_getParameter("rvb01")
    LET l_rvb02 = aws_ttsrv_getParameter("rvb02")
    IF cl_null(l_wc) THEN LET l_wc=" 1=1" END IF
 
    LET l_sql = "SELECT rvb_file.* FROM rva_file,rvb_file WHERE ",
                l_wc,
                " AND rva01=rvb01",
                " AND rvb01 = '",l_rvb01,"' ",
                " AND rvb02 = '",l_rvb02,"' "               
                 
    DECLARE rvb_curs CURSOR FROM l_sql 
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF  
 
    OPEN rvb_curs
    FETCH rvb_curs INTO l_rvb.*
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       CLOSE rvb_curs
       RETURN
    END IF
    CLOSE rvb_curs    
    
    LET l_return.rvb36 = l_rvb.rvb36
    LET l_return.rvb37 = l_rvb.rvb37
    LET l_return.rvb38 = l_rvb.rvb38
 
    CASE p_rvu00
       WHEN "1"
          IF cl_null(l_rvb.rvb30) THEN LET l_rvb.rvb30 = 0 END IF
          IF cl_null(l_rvb.rvb31) THEN LET l_rvb.rvb31 = 0 END IF
          IF cl_null(l_rvb.rvb33) THEN LET l_rvb.rvb33 = 0 END IF
 
          LET l_return.rvb30 = l_rvb.rvb30  #已入庫量
          LET l_return.rvb31 = l_rvb.rvb31  #可入庫量
          LET l_return.rvb33 = l_rvb.rvb33  #允收數量
 
 
       WHEN "2"
          ##其他驗退的數量
          #SELECT SUM(rvv17) INTO l_rvv17_2_other FROM rvv_file,rvu_file
          # WHERE rvv04=l_rvb.rvb01 AND rvv05=l_rvb.rvb02
          #   AND rvv03='2'
          #   AND rvv01=rvu01
          #   AND rvuconf !='X'
          # IF cl_null(l_rvv17_2_other) THEN
          #    LET l_rvv17_2_other=0
          # END IF
          ##修改可驗退數量控管
          ##1.若走IQC   可驗退量=SUM(IQC送驗量) - SUM(IQC合格量) - 已驗退量
          ##2.若不走IQC 可驗退量=實收數量 - 已入庫量 - 已驗退量
          #
          #SELECT rvb07,rvb33,rvb30,rvb39
          #  INTO l_inqty,l_okqty,l_rvb30,l_rvb39  
          #  FROM rvb_file,rva_file 
          # WHERE rvb01=l_rvb.rvb01 
          #   AND rvb02=l_rvb.rvb02
          #   AND rvb01=rva01
          #   AND rvaconf !='X' #作廢資料要剔除
          #
          #IF cl_null(l_inqty) THEN LET l_inqty=0 END IF
          #IF cl_null(l_okqty) THEN LET l_okqty=0 END IF
          #IF cl_null(l_rvb30) THEN LET l_rvb30=0 END IF
          #
          #LET l_return.rvb30 = l_rvv17_2_other
          #LET l_return.rvb31 = l_inqty-l_okqty-l_rvv17_2_other-l_rvb30
          #LET l_return.rvb33 = l_okqty
 
          SELECT sma886 INTO g_sma.sma886
            FROM sma_file
           WHERE sma00='0'
 
          SELECT SUM(rvv17)
            INTO l_rvv17_2 FROM rvu_file,rvv_file
           WHERE rvv04=l_rvb.rvb01 AND rvv05=l_rvb.rvb02
             AND rvv03='2'
             AND rvu01=rvv01
             AND rvuconf<>'X'
 
          IF cl_null(l_rvv17_2) THEN LET l_rvv17_2=0 END IF
 
         
          IF l_rvb.rvb39='Y' AND g_sma.sma886[8,8] = 'Y' THEN
            SELECT SUM(qcs091),SUM(qcs22)
              INTO l_qcs091,l_qcs22
               FROM qcs_file WHERE  qcs01 = l_rvb.rvb01
               AND qcs02 = l_rvb.rvb02
               AND qcs14 = 'Y'               #確認否
              #AND qcs09 = '1'               #合格否    #No.MOD-7A0072 add
         
            IF cl_null(l_qcs091) THEN LET l_qcs091 = 0 END IF
            IF cl_null(l_qcs22)  THEN LET l_qcs22 = 0 END IF
           #IF g_sma.sma886[8,8] = 'Y'  THEN      #MOD-830209 add
           #   #若勾選允收數與IQC勾稽 , 驗退量以qcs_file為主
           #   #若不勾選允收數與IQC勾稽 , 驗退量以rvb_file為主
               LET l_rvv17=l_qcs22-l_rvv17_2-l_qcs091
           #ELSE
           #   LET l_rvv17=l_rvb.rvb07-l_rvv17_2-l_rvb.rvb30
           #END IF   
          ELSE
            LET l_rvv17=l_rvb.rvb07-l_rvv17_2-l_rvb.rvb30
          END IF
          LET l_return.rvb30 = l_rvv17_2   #已驗退量
          LET l_return.rvb31 = l_rvv17     #可驗退量
          LET l_return.rvb33 = l_rvb.rvb33 #允收數量
 
       WHEN "3"
          #其他驗退的數量
          SELECT SUM(rvv17) INTO l_rvv17_3_other FROM rvv_file,rvu_file
           WHERE rvv04=l_rvb.rvb01 
             AND rvv05=l_rvb.rvb02
             AND rvv03='3'
             AND rvv01=rvu01
             AND rvuconf !='X'
          IF cl_null(l_rvv17_3_other) THEN
             LET l_rvv17_3_other=0
          END IF
          SELECT rvb30,rvb33 INTO l_inqty,l_okqty FROM rvb_file,rva_file
           WHERE rvb01=l_rvv.rvv04 
             AND rvb02=l_rvv.rvv05
             AND rvb01=rva01
             AND rvaconf !='X' #作廢資料要剔除
          IF cl_null(l_inqty) THEN LET l_inqty=0 END IF
          LET l_return.rvb30 = l_rvv17_3_other           #已入庫量
          LET l_return.rvb31 = l_inqty-l_rvv17_3_other   #可入庫量
          LET l_return.rvb33 = l_rvb.rvb33               #允收數量
 
    END CASE
   
    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
 
END FUNCTION
