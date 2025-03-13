# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_wo_stock_qty.4gl
# Descriptions...: 提供取得 ERP WO 可入庫量、已入庫量、預設倉庫、預設儲位
# Date & Author..: 2008/04/17 by kim (FUN-840012)
# Memo...........:
# Modify.........:
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60027 10/06/22 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A60081 10/06/25 By vealxu MAX(ecm03)相關
# Modify.........: No:FUN-C70037 12/08/16 By lixh1 CALL s_minp增加傳入日期參數
 
DATABASE ds
 
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
           
 
#[
# Description....: 提供取得 ERP WO 可入庫量、已入庫量、預設倉庫、預設儲位資料服務(入口 function)
# Date & Author..: 2008/04/17 by kim  (FUN-840012)
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_wo_stock_qty()
 
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP WO 可入庫量資料                                                 #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_wo_stock_qty_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
#[
# Description....: 查詢 ERP WO 可入庫量、已入庫量、預設倉庫、預設儲位資料
# Date & Author..: 2008/04/17 by kim (FUN-840012)
# Parameter......: no
# Return.........: no
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_wo_stock_qty_process()
    DEFINE l_sfv11     LIKE sfv_file.sfv11
    DEFINE l_sfv17     LIKE sfv_file.sfv17
    DEFINE l_sfb05     LIKE sfb_file.sfb05
    DEFINE l_sfv09     LIKE sfv_file.sfv09
    DEFINE l_sfv09_2   LIKE sfv_file.sfv09
    DEFINE tmp_qty     LIKE sfv_file.sfv09
    DEFINE l_min_set   LIKE sfq_file.sfq03
    DEFINE l_min_set2  LIKE sfq_file.sfq03
    DEFINE l_over_qty  LIKE sfv_file.sfv09
    DEFINE l_sql       STRING
    DEFINE l_cnt       LIKE type_file.num5
    DEFINE l_return    RECORD       #回傳值必須宣告為一個 RECORD 變數, 且此 RECORD 需包含所有要回傳的欄位名稱與定義
                          stkqty     LIKE sfv_file.sfv09,   #實際可入庫量(有考慮額度) 
                          maxqty     LIKE sfv_file.sfv09,   #單據可入庫量(未考慮額度)
                          inqty      LIKE sfv_file.sfv09,   #已入庫量
                          stock      LIKE sfv_file.sfv05,   #倉庫
                          loc        LIKE sfv_file.sfv06    #儲位
                       END RECORD
    DEFINE l_ecm311    LIKE ecm_file.ecm311
    DEFINE l_ecm315    LIKE ecm_file.ecm315
    DEFINE g_sfb       RECORD LIKE sfb_file.*
    DEFINE l_ecm_out   LIKE sfv_file.sfv09
    DEFINE l_qcf091    LIKE qcf_file.qcf091
    DEFINE l_min_qty   LIKE sfv_file.sfv09
    DEFINE l_ecm012    LIKE ecm_file.ecm012   #FUN-A60081
    DEFINE l_ecm03     LIKE ecm_file.ecm03    #FUN-A60081
 
 
    LET l_sfv11 = aws_ttsrv_getParameter("sfv11")    #工單單號
    LET l_sfv17 = aws_ttsrv_getParameter("sfv17")    #FQC單號
    
    
    IF (cl_null(l_sfv11)) AND (NOT cl_null(l_sfv17)) THEN  #有FQC單,無工單單號
       SELECT qcf02 INTO l_sfv11
         FROM qcf_file
        WHERE qcf01 = l_sfv17
    END IF
    
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
 
    SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01=l_sfv11
 
    IF g_sfb.sfb39 != '2' THEN
       #工單完工方式為'2' pull 不check min_set
       #最小套=min_set
       LET l_min_set = 0
 
       #default 時不考慮超限率sma74
    #  CALL s_minp(g_sfb.sfb01,g_sma.sma73,0,'','','')    #FUN-A60027 add 2'' #FUN-C70037  mark
       CALL s_minp(g_sfb.sfb01,g_sma.sma73,0,'','','','') #FUN-C70037  
            RETURNING l_cnt,l_min_set
 
      #FUN-840012
      #IF g_cnt !=0  THEN
      #   CALL cl_err('s_minp()','asf-549',0)
      #   RETURN FALSE
      #END IF
 
      # sma73 工單完工數量是否檢查發料最小套數
      # sma74 工單完工量容許差異百分比
 
      IF g_sma.sma73='Y' THEN  #
         LET l_over_qty=((l_min_set*g_sma.sma74)/100)
      ELSE
         LET l_over_qty=0
      END IF
 
      IF l_over_qty IS NULL THEN LET l_over_qty=0 END IF
 
      # sum(已存在入庫單入庫數量) by W/O (不管有無過帳)
      SELECT SUM(sfv09) INTO tmp_qty FROM sfv_file,sfu_file
       WHERE sfv11 = g_sfb.sfb01
         AND sfv01 = sfu01
         AND sfu00 = '1'   #類別 1.入庫  2.入庫退回
         AND sfuconf <> 'X'
 
      IF tmp_qty IS NULL OR SQLCA.sqlcode THEN LET tmp_qty=0 END IF
 
      #LET g_sfv[l_ac].sfv09=l_min_set - tmp_qty
 
      LET l_min_set=l_min_set + l_over_qty
 
      LET l_sfv09=l_min_set-tmp_qty
      
      LET l_sfv09_2=l_min_set-tmp_qty-l_over_qty
 
      IF g_sfb.sfb93='Y' THEN # 製程否
         #取最終製程之總轉出量(良品轉出量+Bonus)
          CALL s_schdat_max_ecm03(g_sfb.sfb01) RETURNING l_ecm012,l_ecm03   #FUN-A60081    
         SELECT ecm311,ecm315 INTO l_ecm311,l_ecm315
           FROM ecm_file
          WHERE ecm01=g_sfb.sfb01
           #AND ecm03= (SELECT MAX(ecm03) FROM ecm_file  #FUN-A60081 mark
           #             WHERE ecm01=g_sfb.sfb01)        #FUN-A60081 mark
            AND ecm03 = l_ecm03 AND ecm012 = l_ecm012    #FUN-A60081 
         IF STATUS THEN LET l_ecm311=0 END IF
         IF STATUS THEN LET l_ecm315=0 END IF
 
         LET l_ecm_out=l_ecm311 + l_ecm315
 
         #若走製程應以製程轉出數為準,而非最小套數
         LET l_sfv09=l_ecm_out - tmp_qty
 
         LET l_sfv09_2=l_ecm_out - tmp_qty - l_over_qty
 
      END IF
 
 
      #是否使用FQC功能
      IF g_sfb.sfb94='Y' AND g_sma.sma896='Y' THEN
         # sum(已存在入庫單入庫數量) by W/O (不管有無過帳)
         SELECT SUM(sfv09) INTO tmp_qty FROM sfv_file,sfu_file
          WHERE sfv17 = l_sfv17
            AND sfv01 = sfu01
            AND sfu00 = '1'   #類別 1.入庫  2.入庫退回
            AND sfuconf <> 'X'
 
         IF tmp_qty IS NULL THEN LET tmp_qty=0 END IF
 
         SELECT qcf091 INTO l_qcf091 FROM qcf_file   #QC
          WHERE qcf01 = l_sfv17
            AND qcf09 <> '2'
            AND qcf14 = 'Y'
         IF STATUS OR l_qcf091 IS NULL THEN
            LET l_qcf091 = 0
         END IF
 
         IF g_sma.sma54='Y' AND g_sfb.sfb93='Y' THEN
            IF cl_null(l_ecm_out) THEN LET l_ecm_out=0 END IF
            IF l_min_set > l_ecm_out THEN 
               LET l_min_qty= l_ecm_out
            ELSE
               LET l_min_qty= l_min_set
            END IF
            IF l_min_qty > l_qcf091 THEN
               LET l_sfv09=l_qcf091-tmp_qty
            END IF
         ELSE
            IF l_min_set > l_qcf091 THEN
               LET l_sfv09=l_qcf091-tmp_qty
            END IF
         END IF
 
         #不考慮額度
         LET l_min_set2=l_min_set-l_over_qty
         IF g_sma.sma54='Y' AND g_sfb.sfb93='Y' THEN
            IF cl_null(l_ecm_out) THEN LET l_ecm_out=0 END IF
            IF l_min_set2 > l_ecm_out THEN 
               LET l_min_qty= l_ecm_out
            ELSE
               LET l_min_qty= l_min_set2
            END IF
            IF l_min_qty > l_qcf091 THEN
               LET l_sfv09_2=l_qcf091-tmp_qty
            END IF
         ELSE
            IF l_min_set > l_qcf091 THEN
               LET l_sfv09_2=l_qcf091-tmp_qty
            END IF
         END IF
         IF cl_null(l_sfv09_2) THEN
            LET l_sfv09_2=0
         END IF
      END IF
    END IF    
 
    LET l_return.stkqty = l_sfv09
    LET l_return.maxqty = l_sfv09_2
    LET l_return.inqty  = tmp_qty
 
    SELECT ima35,ima36 INTO l_return.stock,l_return.loc 
      FROM ima_file WHERE ima01=g_sfb.sfb05
 
    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
 
END FUNCTION
