# Prog. Version..: '5.30.06-13.03.12(00000)'     #
# Program name...: aws_create_wo_work_report_data.4gl
# Descriptions...: 提供建立報工單資料的服務 asft300
# Date & Author..: 2011/01/17 By Lilan  
# Memo...........:
# Modify.........: 新建立 FUN-B10037
#
# Modify.........: No:FUN-C70037 12/08/16 By lixh1 CALL s_minp增加傳入日期參數
# Modify.........: No.FUN-CA0008 13/01/07 By Nina  新增可支援整合成本中心架構
#

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

DEFINE  g_srf  RECORD LIKE srf_file.*
DEFINE  g_srg  RECORD LIKE srg_file.*
DEFINE  g_costcenter  LIKE type_file.chr1  #FUN-CA0008 add
DEFINE l_document LIKE smy_file.smyslip    #FUN-CA0008 add

#[
# Description....: 提供建立報工單資料的服務(入口 function)
# Date & Author..: 2011/01/17 By Lilan
# Parameter......: none
# Return.........: none
# Memo...........: 新建立 FUN-B10037
# Modify.........:
#]
FUNCTION aws_create_wo_work_report_data()
    
    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增單據資料                                                             #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_wo_work_report_data_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION


# Description....: 依據傳入資訊新增 ERP 報工單資料
# Date & Author..: 
# Parameter......: none
# Return.........: 報工單號
# Memo...........:
# Modify.........:
#
FUNCTION aws_create_wo_work_report_data_process()
    DEFINE l_i        LIKE type_file.num10,
           l_j        LIKE type_file.num10
    DEFINE l_sql      STRING
    DEFINE l_cnt      LIKE type_file.num10,
           l_cnt1     LIKE type_file.num10,
           l_cnt2     LIKE type_file.num10
    DEFINE l_node1    om.DomNode,
           l_node2    om.DomNode
    DEFINE l_flag     LIKE type_file.num10
    DEFINE l_return   RECORD                           #回傳值必須宣告為一個 RECORD 變數, 且此 RECORD 需包含所有要回傳的欄位名稱與定義
                         srf01   LIKE srf_file.srf01   #回傳的欄位名稱
                      END RECORD
    DEFINE l_status   LIKE srf_file.srfconf
    DEFINE l_cmd      STRING
    DEFINE l_prog     STRING

    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的報工單資料                                        #
    #--------------------------------------------------------------------------#
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("srf_file")   #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF

    SELECT * INTO g_sma.*
      FROM sma_file
     WHERE sma00='0'

    BEGIN WORK

    FOR l_i = 1 TO l_cnt1
        INITIALIZE g_srf.* TO NULL
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "srf_file")        #目前處理單檔的 XML 節點
        LET l_status = aws_ttsrv_getParameter("status")

        LET g_costcenter = aws_ttsrv_getParameter("costcenter")         #FUN-CA0008 add

        LET g_srf.srf01 = aws_ttsrv_getRecordField(l_node1, "srf01")    #取得此筆單檔資料的欄位值
        LET g_srf.srf02 = aws_ttsrv_getRecordField(l_node1, "srf02")
        LET g_srf.srf03 = aws_ttsrv_getRecordField(l_node1, "srf03")
        LET g_srf.srf04 = aws_ttsrv_getRecordField(l_node1, "srf04")
        LET g_srf.srf05 = aws_ttsrv_getRecordField(l_node1, "srf05")


       #單據編號檢查
       #s_check_no(系統別,新單號,舊單號,單據性質,單據編號是否重複要檢查的table名稱,
       #           單據編號對應要檢查的key欄位名稱,工廠別)
       #Return Code....: li_result      結果(TRUE/FALSE)
       #                 ls_no          單據編號
        CALL s_check_no("ASF",g_srf.srf01,"","J","srf_file","srf01","") 
             RETURNING l_flag,g_srf.srf01

        IF NOT l_flag THEN
           LET g_status.code = "apm-920"   #報工單自動取號失敗
           EXIT FOR
        END IF

        LET l_document = g_srf.srf01       #FUN-CA0008 add 紀錄單據編號

        #自動編號
        #s_auto_assign_no(系統別,單號,日期,單據性質,單據編號是否重複要檢查的table名稱,
        #                 單據編號對應要檢查的key欄位名稱,工廠別,RUNCARD,備用)
        #Return Code....: li_result   結果(TRUE/FALSE)
        #                 ls_no       單據編號
        CALL s_auto_assign_no("ASF",g_srf.srf01,g_srf.srf02,"J","srf_file","srf01","","","")
             RETURNING l_flag, g_srf.srf01

        IF NOT l_flag THEN
           LET g_status.code = "apm-920"   #報工單自動取號失敗
           EXIT FOR
        END IF

        #------------------------------------------------------------------#
        # 設定報工單頭預設值與傳入資料的檢查                               #
        #------------------------------------------------------------------#
        CALL aws_create_wo_srf_chk() 
        IF NOT cl_null(g_errno) THEN
           LET g_status.code = g_errno
           EXIT FOR
        END IF

        CALL aws_create_wo_srf_def()

        #------------------------------------------------------------------#
        # RECORD資料傳到NODE                                               #
        #------------------------------------------------------------------#
        CALL aws_ttsrv_setRecordField_record(l_node1,base.Typeinfo.create(g_srf))

        LET l_sql = aws_ttsrv_getRecordSql(l_node1, "srf_file", "I", NULL)   #I 表示取得 INSERT SQL

        #----------------------------------------------------------------------#
        # 執行單頭 INSERT SQL                                                  #
        #----------------------------------------------------------------------#
        EXECUTE IMMEDIATE l_sql
        IF SQLCA.SQLCODE THEN
           LET g_status.code = SQLCA.SQLCODE
           LET g_status.sqlcode = SQLCA.SQLCODE
           EXIT FOR
        END IF
        
        #----------------------------------------------------------------------#
        # 處理單身資料                                                         #
        #----------------------------------------------------------------------#
        LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "srg_file")       #取得目前單頭共有幾筆單身資料
        IF l_cnt2 = 0 THEN
           LET g_status.code = "mfg-009"   #必須有單身資料
           EXIT FOR
        END IF

        CALL cl_flow_notify(g_srf.srf01,'I')  #新增資料到 p_flow
        
        FOR l_j = 1 TO l_cnt2
            INITIALIZE g_srg.* TO NULL
            LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "srg_file")   #目前單身的 XML 節點

            #------------------------------------------------------------------#
            # NODE資料傳到RECORD                                               #
            #------------------------------------------------------------------#
            LET g_srg.srg01 = g_srf.srf01                                 #單號
            LET g_srg.srg02 = l_j                                         #項次
            LET g_srg.srg03 = aws_ttsrv_getRecordField(l_node2, "srg03")
            LET g_srg.srg04 = aws_ttsrv_getRecordField(l_node2, "srg04")
            LET g_srg.srg05 = aws_ttsrv_getRecordField(l_node2, "srg05")  #良品數
            LET g_srg.srg06 = aws_ttsrv_getRecordField(l_node2, "srg06")  #不良品數
            LET g_srg.srg07 = aws_ttsrv_getRecordField(l_node2, "srg07")  #報廢數
            LET g_srg.srg08 = aws_ttsrv_getRecordField(l_node2, "srg08")  #報工時間起(暫為空白)
            LET g_srg.srg09 = aws_ttsrv_getRecordField(l_node2, "srg09")  #報工時間迄(暫為空白) 
            LET g_srg.srg10 = aws_ttsrv_getRecordField(l_node2, "srg10")  #工時
            LET g_srg.srg13 = aws_ttsrv_getRecordField(l_node2, "srg13")        
            LET g_srg.srg16 = aws_ttsrv_getRecordField(l_node2, "srg16")  #工單編號
            LET g_srg.srg19 = aws_ttsrv_getRecordField(l_node2, "srg19")  #機時

            IF cl_null(g_srg.srg16) THEN
               LET g_status.code = 'asf-967'    #工單編號不可為空
               EXIT FOR
            END IF

            #------------------------------------------------------------------#
            # 輸入欄位的檢查與設定欄位預設值                                   #
            #------------------------------------------------------------------#
            CALL aws_create_wo_srg16_chk()      #工單編號的檢查
            IF NOT cl_null(g_errno) THEN
               LET g_status.code = g_errno
               EXIT FOR
            END IF

            CALL aws_create_wo_qty_chk()        #傳入數量(總量)的檢查
            IF NOT cl_null(g_errno) THEN
               LET g_status.code = g_errno
               EXIT FOR
            END IF

            CALL aws_create_wo_srg_def() 
                 

            #------------------------------------------------------------------#
            # RECORD資料傳到NODE2                                              #
            #------------------------------------------------------------------#
            CALL aws_ttsrv_setRecordField_record(l_node2,base.Typeinfo.create(g_srg))

            LET l_sql = aws_ttsrv_getRecordSql(l_node2, "srg_file", "I", NULL) #I 表示取得 INSERT SQL
            
            #------------------------------------------------------------------#
            # 執行單身 INSERT SQL                                              #
            #------------------------------------------------------------------#
            EXECUTE IMMEDIATE l_sql
            IF SQLCA.SQLCODE THEN
               LET g_status.code = SQLCA.SQLCODE
               LET g_status.sqlcode = SQLCA.SQLCODE
               EXIT FOR
            END IF
        END FOR
        IF g_status.code != "0" THEN   #如果單身處理有任何錯誤, 則離開
           EXIT FOR
        ELSE
           IF g_smy.smydmy4='Y' THEN   #單據需自動確認
              UPDATE srf_file SET srfconf = 'Y' 
               WHERE srf01 = g_srf.srf01
              IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                 LET g_status.code = 'aws-086'
                 LET g_status.sqlcode = SQLCA.SQLCODE
                 EXIT FOR
              END IF
              
              CALL aws_create_wo_upd_sfb()
              IF NOT cl_null(g_errno) THEN
                 LET g_status.code = g_errno
                 EXIT FOR
              END IF
           END IF
        END IF
    END FOR
    
    IF g_status.code = "0" THEN
       LET l_return.srf01 = g_srf.srf01
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF

    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳自動取號結果
END FUNCTION


#報工單單頭欄位輸入值的檢查
FUNCTION aws_create_wo_srf_chk()
  DEFINE l_eciacti   LIKE eci_file.eciacti
  DEFINE l_ecgacti   LIKE ecg_file.ecgacti
  DEFINE l_smy80     LIKE smy_file.smy80

    LET g_errno = NULL

    IF cl_null(g_srf.srf02) THEN
       LET g_srf.srf02 = g_today
    END IF

   #關帳日期
    IF NOT cl_null(g_sma.sma53) AND g_srf.srf02 <= g_sma.sma53 THEN
       LET g_errno = "axm-164"
    END IF
   
   #機台編號 
    IF cl_null(g_errno) THEN
      #FUN-CA0008 add str---
       IF cl_null(g_srf.srf03) THEN
          IF g_costcenter = 'Y' THEN
             SELECT smy80 INTO l_smy80 FROM smy_file WHERE smyslip = l_document
             IF l_smy80 IS NULL THEN
                LET g_errno = 'aws-816'  #整合成本中心,預設機器編號需設置
             ELSE
                LET g_srf.srf03 = l_smy80
             END IF
          ELSE
             LET g_errno = 'aws-813'  #未整合成本中心,機台編號不可為空
          END IF
       ELSE
      #FUN-CA0008 add end---
          SELECT eciacti INTO l_eciacti
            FROM eci_file 
           WHERE eci01 = g_srf.srf03
          CASE WHEN SQLCA.SQLCODE = 100  
                    LET g_errno = 'aws-059'
               WHEN l_eciacti='N' 
                    LET g_errno = '9028'
          END CASE
       END IF  #FUN-CA0008 add
    END IF

   #班別
    IF cl_null(g_errno) THEN
       SELECT ecgacti INTO l_ecgacti 
         FROM ecg_file 
        WHERE ecg01 = g_srf.srf04
       CASE WHEN SQLCA.SQLCODE = 100  
                 LET g_errno = 'aec-001'
            WHEN l_ecgacti='N' 
                 LET g_errno = '9028'
       END CASE
    END IF

END FUNCTION

#設定報工單單頭欄位預設值
FUNCTION aws_create_wo_srf_def()

    LET g_srf.srf07 = '2'
    LET g_srf.srfspc = '0'
    LET g_srf.srfuser = g_user
    LET g_srf.srfgrup = g_grup
    LET g_srf.srfmodu = g_user
    LET g_srf.srfdate = g_today
    LET g_srf.srfconf = 'N'
    LET g_srf.srfplant = g_plant
    LET g_srf.srflegal = g_legal

END FUNCTION


#報工單單身欄位輸入值的檢查--工單編號
FUNCTION aws_create_wo_srg16_chk()
  DEFINE l_sfb01      LIKE sfb_file.sfb01
  DEFINE l_sfb02      LIKE sfb_file.sfb02,   
         l_sfb39      LIKE sfb_file.sfb39,   
         l_sfb87      LIKE sfb_file.sfb87,   
         l_sfb81      LIKE sfb_file.sfb81,   
         l_sfb04      LIKE sfb_file.sfb04,   
         l_sfb28      LIKE sfb_file.sfb28
  DEFINE l_sfbacti    LIKE sfb_file.sfbacti  

    LET g_errno = NULL

    SELECT sfb01,sfbacti,sfb02,sfb39,sfb87,sfb81,sfb04,sfb28   
      INTO l_sfb01,l_sfbacti,l_sfb02,l_sfb39,l_sfb87,l_sfb81,
           l_sfb04,l_sfb28  
      FROM sfb_file
     WHERE sfb01 = g_srg.srg16

    IF cl_null(l_sfb01) THEN
       LET g_errno = 'afa-908'                          #此工單編號不存在工單檔中
       RETURN
    END IF

    IF l_sfbacti != 'Y' THEN
       LET g_errno = 'aic-061'                          #工單無效
       RETURN 
    END IF

    IF l_sfb02 = '15' THEN
       LET g_errno = 'asr-047'                          #不可為試產工單
       RETURN
    END IF

    IF l_sfb02 = '13' THEN
       LET g_errno = 'asr-054'                          #不可為預測工單
       RETURN
    END IF

    IF l_sfb04 = '8' AND l_sfb28='3' THEN
       LET g_errno = 'asf-041'                          #工單已結案
       RETURN
    END IF

    IF l_sfb02 = '7' OR l_sfb02 = '8' THEN
       LET g_errno = 'axc-209'                          #不可為委外工單
       RETURN
    END IF

    IF l_sfb87 <> 'Y' THEN
       LET g_errno = 'asf-019'                          #工單未確認
       RETURN
    END IF

    IF l_sfb81 > g_srf.srf02 THEN
       LET g_errno = 'axc-210'                          #報工日期必須大於等於開單日期
       RETURN
    END IF

   #依[完工方式]帶出:產品編號,檢驗否,成本中心
    CASE l_sfb39
       WHEN "1"
          SELECT sfb05,sfb94,sfb98 
            INTO g_srg.srg03,g_srg.srg15,g_srg.srg930
            FROM sfb_file
           WHERE sfb01 = g_srg.srg16
             AND sfb081 > 0
             AND sfbacti = 'Y'
          IF SQLCA.sqlcode THEN
             LET g_errno = 'asr-046'                    #需為已發料,已確認,有效之工單
             RETURN
          END IF
       WHEN "2"
          SELECT sfb05,sfb94,sfb98 
            INTO g_srg.srg03,g_srg.srg15,g_srg.srg930
            FROM sfb_file
           WHERE sfb01 = g_srg.srg16
    END CASE

   #帶出生產單位
    IF NOT cl_null(g_srg.srg03) THEN
       SELECT ima55 INTO g_srg.srg04 
         FROM ima_file 
        WHERE ima01 = g_srg.srg03
    END IF
END FUNCTION

#報工單單身欄位輸入值的檢查--良品數+不良品數+報廢數
FUNCTION aws_create_wo_qty_chk()
DEFINE l_tot           LIKE srg_file.srg05,
       l_qty           LIKE type_file.num10,
       l_sfb081        LIKE sfb_file.sfb081,
       l_str           STRING,
       l_sfb39         LIKE sfb_file.sfb39,      
       l_sfb           RECORD LIKE sfb_file.*,   
       l_min_set       LIKE sfb_file.sfb08,      
       l_cnt           LIKE type_file.num5       
DEFINE l_ima153        LIKE ima_file.ima153    

   LET g_errno = NULL
   LET l_qty = g_srg.srg05 + g_srg.srg06 + g_srg.srg07
   LET l_min_set=0

   SELECT sfb39 INTO l_sfb39 
     FROM sfb_file
    WHERE sfb01=g_srg.srg16
   IF l_sfb39 = '2' THEN                    #倒扣料不檢查數量
      RETURN 
   END IF

   SELECT SUM(srg05+srg06+srg07) INTO l_tot 
     FROM srf_file,srg_file
    WHERE srg01 = srf01
      AND srfconf <> 'X'
      AND NOT (srf01 = g_srf.srf01 AND       
               srg02 = g_srg.srg02)  
      AND srg16 = g_srg.srg16
   IF SQLCA.sqlcode OR (cl_null(l_tot)) THEN
      LET l_tot=0
   END IF

   SELECT * INTO l_sfb.* 
     FROM sfb_file
    WHERE sfb01 = g_srg.srg16
   IF l_sfb.sfb39 != '2' THEN
      #工單完工方式為'2' pull 不check min_set
       CALL s_get_ima153(l_sfb.sfb05) 
            RETURNING l_ima153  

   #   CALL s_minp(l_sfb.sfb01,g_sma.sma73,l_ima153,'','',0)               #FUN-C70037 mark
       CALL s_minp(l_sfb.sfb01,g_sma.sma73,l_ima153,'','',0,g_srf.srf02)   #FUN-C70037
            RETURNING l_cnt,l_min_set
       IF l_cnt !=0  THEN
          LET g_errno = 'asf-549'
          RETURN
       END IF

       #W/O 總入庫量大於最小套數
       IF l_sfb.sfb93='N' THEN
          IF (l_tot+l_qty) > l_min_set THEN
             LET g_errno = 'asf-668'
             RETURN
          END IF
       END IF
   END IF
END FUNCTION

#設定報工單單身欄位預設值
FUNCTION aws_create_wo_srg_def()
  
   IF cl_null(g_srg.srg05) THEN 
      LET g_srg.srg05 = '0'
   END IF

   IF cl_null(g_srg.srg06) THEN 
      LET g_srg.srg06 = '0'
   END IF

   IF cl_null(g_srg.srg07) THEN 
      LET g_srg.srg07 = '0'
   END IF

   IF cl_null(g_srg.srg08) THEN
      LET g_srg.srg08 = ' '
   END IF

   IF cl_null(g_srg.srg09) THEN
      LET g_srg.srg09 = ' '
   END IF

   IF cl_null(g_srg.srg11) THEN
      LET g_srg.srg12 = ' '
   END IF

   IF cl_null(g_srg.srg12) THEN
      LET g_srg.srg12 = ' '
   END IF

   IF cl_null(g_srg.srg13) THEN
      LET g_srg.srg13 = '1'
   END IF

   LET g_srg.srg15 = 'Y'

   IF cl_null(g_srg.srg17) THEN
      LET g_srg.srg17 = ' '
   END IF

   IF cl_null(g_srg.srg18) THEN
      LET g_srg.srg18 = ' '
   END IF

   IF cl_null(g_srg.srg930) THEN
      LET g_srg.srg930 = ' '
   END IF

    LET g_srg.srgplant = g_plant
    LET g_srg.srglegal = g_legal

END FUNCTION

FUNCTION aws_create_wo_upd_sfb()
   DEFINE l_i           LIKE type_file.num5
   DEFINE l_srg16       LIKE srg_file.srg16

     LET g_errno = NULL
     DECLARE updsfb_cur CURSOR FOR  
             SELECT srg16 FROM srg_file WHERE srg01 = g_srf.srf01

     FOREACH updsfb_cur INTO l_srg16
      #回寫工單實際開工日(報工日期)
       UPDATE sfb_file SET sfb25 = g_srf.srf02
        WHERE sfb01 = l_srg16
          AND sfb39 = '2'
       IF SQLCA.sqlcode THEN
          LET g_errno = 'aws-057'
          RETURN
       END IF

      #目前傳送數量皆為"0"，故無須回寫
      #回寫工單報廢數量
      #UPDATE sfb_file
      #   SET sfb12 = sfb12 + l_srg.srg07
      # WHERE sfb01 = l_srg16
      #IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      #   LET g_errno = 'aws-058'
      #   RETURN
      #END IF
     END FOREACH
END FUNCTION
