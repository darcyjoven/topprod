# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_shipping_order.4gl
# Descriptions...: 提供建立出貨單資料的服務
# Date & Author..: No.FUN-840012 08/05/12 By Nicola
# Memo...........:
# Modify.........: No.FUN-930101 09/03/17 By sabrina (1)原先出貨類別只能建立〝一般出貨〞，改為所有出貨類別都能建立
#                                                    (2)新增多角貿易出貨單&代採買出貨單建立
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-AC0002 10/12/13 By Summer 增加分錄底稿二
 
DATABASE ds
 
#No.FUN-840012
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
DEFINE g_cnt   LIKE type_file.num5
 
#[
# Description....: 提供建立出貨單資料的服務(入口 function)
# Date & Author..: No.FUN-840012 08/05/12 By Nicola
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_shipping_order()
 
   WHENEVER ERROR CONTINUE
 
   CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
 
   #--------------------------------------------------------------------------#
   # 新增出貨單資料                                                       #
   #--------------------------------------------------------------------------#
   IF g_status.code = "0" THEN
      CALL aws_create_shipping_order_process()
   END IF
 
   CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
 
END FUNCTION
 
#[
# Description....: 依據傳出資訊新增 ERP 出貨單資料
# Date & Author..: No.FUN-840012 08/05/12 By Nicola
# Parameter......: 
# Return.........: 出貨單號
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_shipping_order_process()
    DEFINE l_i        LIKE type_file.num10,
           l_j        LIKE type_file.num10
    DEFINE l_sql      STRING
    DEFINE l_cnt1     LIKE type_file.num10,
           l_cnt2     LIKE type_file.num10
    DEFINE l_node1    om.DomNode,
           l_node2    om.DomNode
    DEFINE l_flag     LIKE type_file.num10
    DEFINE l_return   RECORD                           #回傳值必須宣告為一個 RECORD 變數, 且此 RECORD 需包含所有要回傳的欄位名稱與定義
                         oga01   LIKE oga_file.oga01   #回傳的欄位名稱
                      END RECORD
    DEFINE l_oga      RECORD LIKE oga_file.*
    DEFINE l_ogb      RECORD LIKE ogb_file.*
    DEFINE l_status   LIKE type_file.chr1
    DEFINE l_cmd      STRING
    DEFINE l_prog     STRING
    DEFINE l_oaytype  LIKE oay_file.oaytype       #FUN-930101 add    #抓取單據性質 
    DEFINE l_poz00    LIKE poz_file.poz00         #FUN-930101 add    #poz00 1：銷售段 2：代採買
 
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的出貨單資料                                    #
    #--------------------------------------------------------------------------#
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("oga_file")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF
 
    BEGIN WORK
 
    SELECT * INTO g_sma.*
      FROM sma_file
     WHERE sma00='0'
 
    FOR l_i = 1 TO l_cnt1
        INITIALIZE l_oga.* TO NULL
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "oga_file")        #目前處理單檔的 XML 節點
        LET l_status = aws_ttsrv_getParameter("status")
 
       #LET l_oga.oga00 = "1"                 #FUN-930101 mark 所有的出貨類別都要能讀取
        LET l_oga.oga00 = aws_ttsrv_getRecordField(l_node1, "oga00")    #取得出貨類別    #FUN-930101 add
        LET l_oga.oga01 = aws_ttsrv_getRecordField(l_node1, "oga01")    #取得此筆單檔資料的欄位值
        LET l_oga.oga011 = aws_ttsrv_getRecordField(l_node1, "oga011")  #出貨通知單號
        LET l_oga.oga02 = aws_ttsrv_getRecordField(l_node1, "oga02")    #單據日期
        LET l_oga.oga09 = aws_ttsrv_getRecordField(l_node1, "oga09")    #取得單據別(一般or多角)       #FUN-930101 
 
     #FUN-930101---add---start---   #判斷oga09是多角貿易還是代採買
        IF l_oga.oga09 = '4' THEN
           SELECT DISTINCT poz00 INTO l_poz00
             FROM oea_file, poz_file, ogb_file
            WHERE oea904 = poz01
              AND oea01 = ogb31
              AND ogb31 IN(SELECT ogb31 FROM ogb_file
                            WHERE ogb01 = l_oga.oga011)
           IF l_poz00 = '2' THEN
              LET l_oga.oga09 = '6'
           END IF
        END IF
     #FUN-930101---add---end---
 
        IF cl_null(l_oga.oga02) OR l_oga.oga02=0 THEN
           LET l_oga.oga02  = g_today
        END IF
 
     #FUN-930101---add---start---
     #抓取單據性質
      IF NOT cl_null(l_oga.oga01) THEN
         SELECT oaytype INTO l_oaytype FROM oay_file WHERE oayslip = l_oga.oga01
      END IF
     #FUN-930101---add---end---
 
        #----------------------------------------------------------------------#
        # 檢查單據日期                                                         #
        #----------------------------------------------------------------------#
        CALL aws_create_shipping_order_check_oga02(l_oga.*)
        IF NOT cl_null(g_errno) THEN
           LET g_status.code = g_errno
           EXIT FOR
        END IF
 
        #----------------------------------------------------------------------#
        # 出貨單自動取號                                                   #
        #----------------------------------------------------------------------#
       #CALL s_check_no("axm",l_oga.oga01,"","50","oga_file","oga01","")  #FUN-930101 mark
        CALL s_check_no("axm",l_oga.oga01,"",l_oaytype,"oga_file","oga01","")  #FUN-930101 add 依單據性質不同判斷為何種出貨類別
              RETURNING l_flag,l_oga.oga01
        IF NOT l_flag THEN
           LET g_status.code = "mfg0014"   #出貨單自動取號失敗
           EXIT FOR
        END IF
 
        CALL s_auto_assign_no("axm",l_oga.oga01,l_oga.oga02,"","oga_file","oga01","","","")
             RETURNING l_flag,l_oga.oga01
        IF NOT l_flag THEN
           LET g_status.code = "sub-145"   #出貨單自動取號失敗
           EXIT FOR
        END IF
 
        #------------------------------------------------------------------#
        # 設定出貨單頭預設值                                           #
        #------------------------------------------------------------------#
        CALL aws_create_shipping_order_set_oga(l_oga.*) RETURNING l_oga.*
        IF NOT cl_null(g_errno) THEN
           LET g_status.code = g_errno
           EXIT FOR
        END IF
 
        #------------------------------------------------------------------#
        # RECORD資料傳到NODE                                               #
        #------------------------------------------------------------------#
        CALL aws_ttsrv_setRecordField_record(l_node1,base.Typeinfo.create(l_oga))
 
        LET l_sql = aws_ttsrv_getRecordSql(l_node1, "oga_file", "I", NULL)   #I 表示取得 INSERT SQL
 
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
        LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "ogb_file")       #取得目前單頭共有幾筆單身資料
        IF l_cnt2 = 0 THEN 
           LET g_status.code = "mfg-009"   #必須有單身資料
           EXIT FOR
        END IF
 
        CALL cl_flow_notify(l_oga.oga01,'I')  #新增資料到 p_flow
 
        FOR l_j = 1 TO l_cnt2
            INITIALIZE l_ogb.* TO NULL
            LET l_node2 = aws_ttsrv_getDetailRecord(l_node1,l_j,"ogb_file")   #目前單身的 XML 節點
 
            #------------------------------------------------------------------#
            # NODE資料傳到RECORD                                               #
            #------------------------------------------------------------------#
            LET l_ogb.ogb01=l_oga.oga01
           #LET l_ogb.ogb03=l_j
 
            LET l_ogb.ogb03 = aws_ttsrv_getRecordField(l_node2, "ogb03")
            LET l_ogb.ogb04 = aws_ttsrv_getRecordField(l_node2, "ogb04")
            LET l_ogb.ogb09 = aws_ttsrv_getRecordField(l_node2, "ogb09")
            LET l_ogb.ogb091= aws_ttsrv_getRecordField(l_node2, "ogb091")
            LET l_ogb.ogb092= aws_ttsrv_getRecordField(l_node2, "ogb092")
            LET l_ogb.ogb12 = aws_ttsrv_getRecordField(l_node2, "ogb12")
            LET l_ogb.ogb31 = aws_ttsrv_getRecordField(l_node2, "ogb31")
            LET l_ogb.ogb32 = aws_ttsrv_getRecordField(l_node2, "ogb32")
 
            #------------------------------------------------------------------#
            # 單身欄位檢查                                                         #
            #------------------------------------------------------------------#
            CALL aws_create_shipping_order_check_ogb(l_oga.*,l_ogb.*)
                 RETURNING l_ogb.*
            IF NOT cl_null(g_errno) THEN
               LET g_status.code=g_errno
               EXIT FOR
            END IF
 
            #------------------------------------------------------------------#
            # RECORD資料傳到NODE2                                              #
            #------------------------------------------------------------------#
            CALL aws_ttsrv_setRecordField_record(l_node2,base.Typeinfo.create(l_ogb))
 
            IF cl_null(l_ogb.ogb091) THEN 
               LET l_ogb.ogb091=" "
               CALL aws_ttsrv_setRecordField(l_node2, "ogb091", " ")
            END IF
            IF cl_null(l_ogb.ogb092) THEN 
               LET l_ogb.ogb092=" "
               CALL aws_ttsrv_setRecordField(l_node2, "ogb092", " ")
            END IF
 
            LET l_sql = aws_ttsrv_getRecordSql(l_node2, "ogb_file", "I", NULL) #I 表示取得 INSERT SQL
 
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
        END IF
    END FOR
 
    CALL aws_create_shipping_order_gen_sheet(l_oga.*)
    
    #全部處理都成功才 COMMIT WORK
    IF g_status.code = "0" THEN
       LET l_return.oga01 = l_oga.oga01
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
 
  #FUN-930101---add---start---
   #IF l_status='Y' THEN
   #   LET l_cmd="axmt620 '",l_oga.oga01 CLIPPED,"' 'M'"
   #   CALL cl_cmdrun_wait(l_cmd)
   #   CALL aws_ttsrv_cmdrun_checkStatus(l_prog)
   #END IF
 
   #依不同的類別執行不同的程式
    IF l_status='Y' THEN
       IF l_oga.oga09 MATCHES '[246]' THEN
          IF l_oga.oga09 = '2' THEN      #一般出貨單
             LET l_cmd="axmt620 '",l_oga.oga01 CLIPPED,"' 'M'"
             CALL cl_cmdrun_wait(l_cmd)
             CALL aws_ttsrv_cmdrun_checkStatus(l_prog)
          ELSE                           #多角出貨單
             IF l_oga.oga09 = '4' THEN
                LET l_cmd="axmt820 '",l_oga.oga01 CLIPPED,"' 'M'"
                CALL cl_cmdrun_wait(l_cmd)
                CALL aws_ttsrv_cmdrun_checkStatus(l_prog)
             ELSE                         #代採買出貨單
                LET l_cmd="axmt821 '",l_oga.oga01 CLIPPED,"' 'M'"
                CALL cl_cmdrun_wait(l_cmd)
                CALL aws_ttsrv_cmdrun_checkStatus(l_prog)
             END IF
          END IF
       END IF
    END IF
  #FUN-930101---add---end---
 
    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳自動取號結果
 
END FUNCTION
 
#[
# Description....: 出貨單設定欄位預設值
# Date & Author..: No.FUN-840012 08/05/12 By Nicola
# Parameter......: l_oga - 收貨單單頭
# Return.........: l_oga - 收貨單單頭
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_shipping_order_set_oga(l_oga)
   DEFINE l_oga   RECORD LIKE oga_file.*
   DEFINE l_oga_u RECORD LIKE oga_file.*
   DEFINE l_ogb31 LIKE ogb_file.ogb31
   DEFINE l_ogb32 LIKE ogb_file.ogb32
 
   LET g_errno=NULL
   #--------------------------------------------------------------------------#
   # 設定出貨單單頭欄位預設值                                             #
   #--------------------------------------------------------------------------#
 
   LET l_oga.oga08  = '1'
  #LET l_oga.oga09  = '2'      #FUN-930101 mark 不設定為"一般出貨"
   LET l_oga.oga14  = g_user
   LET l_oga.oga15  = g_grup
   LET l_oga.oga20  = 'Y'
   LET l_oga.oga211 = 0
   LET l_oga.oga30  = 'N'
   LET l_oga.oga50  = 0
   LET l_oga.oga52  = 0
   LET l_oga.oga53  = 0
   LET l_oga.oga54  = 0
   LET l_oga.oga65  = 'N'
   LET l_oga.oga161 = 0
   LET l_oga.oga162 = 100
   LET l_oga.oga163 = 0
   LET l_oga.oga903 = 'N'
   LET l_oga.oga1014= 'N'
   LET l_oga.oga1015= '0'
   LET l_oga.ogaconf= 'N'
   LET l_oga.ogaspc = '0'
   LET l_oga.ogapost= 'N'
   LET l_oga.ogaprsw= 0
   LET l_oga.ogauser= g_user
   LET g_data_plant = g_plant #FUN-980030
   LET l_oga.ogagrup= g_grup
   LET l_oga.ogadate= g_today
 
   LET l_oga_u.* = l_oga.*
 
   IF l_oga.oga09 MATCHES '[246]' THEN    #FUN-930101 add
      IF l_oga.oga09 = '2' THEN      #FUN-930101 一般出貨單
         SELECT * INTO l_oga.* FROM oga_file
          WHERE oga01 = l_oga.oga011
            AND oga09 = '1'
            AND ogaconf='Y'
         IF STATUS THEN
            LET g_errno=SQLCA.sqlcode
            RETURN 
         END IF
#FUN-930101---add---start---
      ELSE         #多角&代採買出貨單
         SELECT * INTO l_oga.* FROM oga_file
          WHERE oga01 = l_oga.oga011
            AND oga09 = '5'
            AND ogaconf='Y'
         IF STATUS THEN
            LET g_errno=SQLCA.sqlcode
            RETURN
         END IF
      END IF
   END IF
#FUN-930101---add---end---
 
   LET l_oga.oga06  = g_oaz.oaz41
   LET l_oga.oga55   = '' 
   LET l_oga.oga99   = ''
   LET l_oga.oga905  = 'N'
   LET l_oga.oga09   = l_oga_u.oga09
   LET l_oga.oga01   = l_oga_u.oga01
   LET l_oga.oga02   = l_oga_u.oga02
   LET l_oga.oga69   = l_oga.oga02
   LET l_oga.oga011  = l_oga_u.oga011
   LET l_oga.oga903  = 'N'
   LET l_oga.ogaconf = 'N'
   LET l_oga.ogapost = 'N'
   LET l_oga.ogauser = l_oga_u.ogauser
   LET l_oga.ogagrup = l_oga_u.ogagrup
   LET l_oga.ogamodu = l_oga_u.ogamodu
   LET l_oga.ogadate = l_oga_u.ogadate
 
   CALL s_curr3(l_oga.oga23,l_oga.oga02,g_oaz.oaz52) RETURNING l_oga.oga24
 
   DECLARE oga_curs CURSOR FOR SELECT ogb31,ogb32 FROM ogb_file
                                WHERE ogb01 = l_oga.oga01
 
   FOREACH oga_curs INTO l_ogb31,l_ogb32
      LET g_cnt = 0
 
      IF l_oga.oga09 MATCHES '[246]' THEN    #FUN-930101 add
         IF l_oga.oga09 = '2' THEN           #FUN-930101 add #一般出貨單
            SELECT COUNT(*) INTO g_cnt FROM oga_file,ogb_file
             WHERE oga01 = l_oga.oga011
               AND oga01 = ogb01
               AND oga09 = '1'
               AND ogb31 = l_ogb31
               AND ogb32 = l_ogb32
    #FUN-930101---add---start---
         ELSE                  #多角&代採買出貨單
            SELECT COUNT(*) INTO g_cnt FROM oga_file,ogb_file
             WHERE oga01 = l_oga.oga011
               AND oga01 = ogb01
               AND oga09 = '5'
               AND ogb31 = l_ogb31
               AND ogb32 = l_ogb32
         END IF
      END IF
    #FUN-930101---add---end---
 
      #本訂單號不存在出貨通知單內
      IF g_cnt=0 AND l_ogb31[1,4] != 'MISC' THEN
         LET g_errno = "axm-224"
         RETURN
      END IF
   END FOREACH
 
   LET l_oga.oga13=NULL
   SELECT occ67 INTO l_oga.oga13 FROM occ_file
    WHERE occ01 = l_oga.oga03
 
   RETURN l_oga.*
 
END FUNCTION
 
#[
# Description....: 由出通單單身帶資料進出貨單單身並檢查欄位資料
# Date & Author..: No.FUN-840012 08/05/12 By Nicola
# Parameter......: l_oga-出貨單頭,l_ogb - 出貨單身
# Return.........: l_ogb-出貨單單身值 ; use g_errno 判斷檢查是否有誤
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_shipping_order_check_ogb(l_oga,l_ogb)
   DEFINE l_oga      RECORD LIKE oga_file.*
   DEFINE l_ogb      RECORD LIKE ogb_file.*
   DEFINE l_ogb_u    RECORD LIKE ogb_file.*
   DEFINE l_ogb12a   LIKE ogb_file.ogb12
   DEFINE l_ogb12b   LIKE ogb_file.ogb12
   DEFINE t_azi03    LIKE azi_file.azi03
   DEFINE t_azi04    LIKE azi_file.azi04
 
   LET g_errno=NULL
 
   LET l_ogb_u.* = l_ogb.*
 
   DECLARE ogb_curs CURSOR FOR SELECT * FROM ogb_file
                                WHERE ogb01 = l_oga.oga011
                                  AND ogb31 = l_ogb.ogb31
                                  AND ogb32 = l_ogb.ogb32
 
   OPEN ogb_curs
   FETCH ogb_curs INTO l_ogb.*
 
   LET l_ogb.ogb01 = l_oga.oga01
 
   IF l_ogb.ogb04 <> l_ogb_u.ogb04 THEN
      LET g_errno='apm-921'
      RETURN l_ogb.*
   END IF
 
   LET l_ogb.ogb03 = l_ogb_u.ogb03
   LET l_ogb.ogb09 = l_ogb_u.ogb09
   LET l_ogb.ogb091 = l_ogb_u.ogb091
   LET l_ogb.ogb092 = l_ogb_u.ogb092
   LET l_ogb.ogb12 = l_ogb_u.ogb12
 
   IF cl_null(l_ogb.ogb091) THEN LET  l_ogb.ogb091=' ' END IF
   IF cl_null(l_ogb.ogb092) THEN LET  l_ogb.ogb092=' ' END IF
 
   #檢查料件庫存資料
   IF l_ogb.ogb17 = 'N' AND l_ogb.ogb04 NOT MATCHES 'MISC*' THEN
      SELECT img09 INTO l_ogb.ogb15 FROM img_file
       WHERE img01 = l_ogb.ogb04
         AND img02 = l_ogb.ogb09
         AND img03 = l_ogb.ogb091
         AND img04 = l_ogb.ogb092 
      IF SQLCA.sqlcode OR STATUS = 100 THEN
         LET g_errno = "mfg6069"
         RETURN l_ogb.*
      END IF
   END IF
 
   IF l_ogb.ogb05 = l_ogb.ogb15 THEN
      LET l_ogb.ogb15_fac =1
   ELSE
      #檢查該發料單位與主檔之單位是否可以轉換
      CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_ogb.ogb15)
          RETURNING g_cnt,l_ogb.ogb15_fac
       IF g_cnt = 1 THEN
          LET g_errno ='mfg3075'
          RETURN l_ogb.*
       END IF
   END IF
 
   SELECT COUNT(*) INTO g_cnt FROM img_file
    WHERE img01 = l_ogb.ogb04   #料號
      AND img02 = l_ogb.ogb09   #倉庫
      AND img03 = l_ogb.ogb091  #儲位
      AND img04 = l_ogb.ogb092  #批號
      AND img18 < l_oga.oga02
   IF g_cnt > 0 THEN
      LET g_errno = "aim-400"
      RETURN l_ogb.*
   END IF
 
   #對應到的出貨通知單上的數量
   LET l_ogb12a = 0
 
   IF l_oga.oga09 MATCHES '[246]' THEN    #FUN-930101 add
      IF l_oga.oga09 = '2' THEN           #FUN-930101 #一般出貨單
         SELECT SUM(ogb12) INTO l_ogb12a
           FROM ogb_file,oga_file
          WHERE ogb01 = oga01
            AND oga09 = '1'
            AND oga01 = l_oga.oga011
           #AND ogb03 = l_ogb.ogb03    #FUN-930101 mark 符合出貨單分項出貨 
            AND ogb31 = l_ogb.ogb31
            AND ogb32 = l_ogb.ogb32
            AND ogb04 = l_ogb.ogb04 
            AND ogaconf != 'X'
   #FUN-930101---add---start---
      ELSE          #多角&代採買出貨單
         SELECT SUM(ogb12) INTO l_ogb12a
           FROM ogb_file,oga_file
          WHERE ogb01 = oga01
            AND oga09 = '5'
            AND oga01 = l_oga.oga011
            AND ogb31 = l_ogb.ogb31
            AND ogb32 = l_ogb.ogb32
            AND ogb04 = l_ogb.ogb04
            AND ogaconf != 'X'
      END IF
   END IF
   #FUN-930101---add---end---
 
   IF cl_null(l_ogb12a)  THEN LET l_ogb12a = 0 END IF
 
   # 此出貨通知單已耗用在出貨單的量
   LET l_ogb12b = 0
 
   IF l_oga.oga09 MATCHES '[246]' THEN   #FUN-930101 add
      IF l_oga.oga09 = '2' THEN          #FUN-930101 add #一般出貨單
         SELECT SUM(ogb12) INTO l_ogb12b
           FROM ogb_file,oga_file
            WHERE ogb01 = oga01
              AND oga09 = '2'
              AND oga011 = l_oga.oga011
             #AND ogb03 = l_ogb.ogb03     #FUN-930101 mark 符合出貨單分項出貨
              AND ogb31 = l_ogb.ogb31
              AND ogb32 = l_ogb.ogb32
              AND ogb04 = l_ogb.ogb04
              AND ogaconf != 'X'
  #FUN-930101---add---start---
      ELSE         #多角&代採買出貨單
         SELECT SUM(ogb12) INTO l_ogb12b
           FROM ogb_file,oga_file
          WHERE ogb01 = oga01
            AND oga09 = l_oga.oga09
            AND oga011 = l_oga.oga011
            AND ogb31 = l_ogb.ogb31
            AND ogb32 = l_ogb.ogb32
            AND ogb04 = l_ogb.ogb04
            AND ogaconf != 'X'
      END IF
   END IF
  #FUN-930101---add---end---
 
   IF cl_null(l_ogb12b)  THEN LET l_ogb12b = 0 END IF
 
   IF l_ogb.ogb12 > (l_ogb12a - l_ogb12b) THEN
      LET g_errno = "axm-128"
      RETURN l_ogb.*
   END IF
 
   LET l_ogb.ogb16 = l_ogb.ogb12 * l_ogb.ogb15_fac
 
   IF l_oga.oga213 = 'N' THEN
      LET l_ogb.ogb14 =l_ogb.ogb12 * l_ogb.ogb13
      LET l_ogb.ogb14t=l_ogb.ogb14 * (1 + l_oga.oga211 / 100)
   ELSE
      LET l_ogb.ogb14t=l_ogb.ogb12 * l_ogb.ogb13
      LET l_ogb.ogb14 =l_ogb.ogb14t / (1 + l_oga.oga211 / 100)
   END IF
 
   SELECT azi03,azi04 INTO t_azi03,t_azi04
     FROM azi_file
    WHERE azi01=l_oga.oga23
 
   CALL cl_digcut(l_ogb.ogb14,t_azi04) RETURNING l_ogb.ogb14
 
   CALL cl_digcut(l_ogb.ogb14t,t_azi04)RETURNING l_ogb.ogb14t
 
   LET l_ogb.ogb1014 = 'N'
 
   LET l_ogb.ogb916 = l_ogb.ogb05
   LET l_ogb.ogb917 = l_ogb.ogb12
 
   IF cl_null(l_ogb.ogb12) THEN
     LET l_ogb.ogb12 = 0
   END IF
 
   IF cl_null(l_ogb.ogb13) THEN
     LET l_ogb.ogb13 = 0
   END IF
 
   IF cl_null(l_ogb.ogb14) THEN
     LET l_ogb.ogb14 = 0
   END IF
 
   IF cl_null(l_ogb.ogb14t) THEN
     LET l_ogb.ogb14t = 0
   END IF
 
   IF cl_null(l_ogb.ogb15_fac) THEN
      LET l_ogb.ogb15_fac = 1
   END IF
 
   IF cl_null(l_ogb.ogb16) THEN
      LET l_ogb.ogb16 = 0
   END IF
 
   IF cl_null(l_ogb.ogb18) THEN
      LET l_ogb.ogb18 = 0
   END IF
 
   IF cl_null(l_ogb.ogb60) THEN
      LET l_ogb.ogb60 = 0
   END IF
 
   IF cl_null(l_ogb.ogb63) THEN
      LET l_ogb.ogb63 = 0
   END IF
 
   IF cl_null(l_ogb.ogb64) THEN
      LET l_ogb.ogb64 = 0
   END IF
 
   IF cl_null(l_ogb.ogb1006) THEN
      LET l_ogb.ogb1006 = 100
   END IF
 
   RETURN l_ogb.*
 
END FUNCTION
 
FUNCTION aws_create_shipping_order_check_oga02(l_oga)
   DEFINE l_oga RECORD LIKE oga_file.*
   DEFINE l_yy LIKE sma_file.sma51
   DEFINE l_mm LIKE sma_file.sma52
 
   LET g_errno=NULL
   IF NOT cl_null(l_oga.oga02) THEN
      IF l_oga.oga02 <= g_oaz.oaz09 THEN #銷售系統關帳日
         LET g_errno='axm-164' 
         RETURN
      END IF
 
      IF g_oaz.oaz03 = 'Y' AND
         g_sma.sma53 IS NOT NULL AND l_oga.oga02 <= g_sma.sma53 THEN #製造系統關帳日
         LET g_errno='mfg9999'
         RETURN 
      END IF
 
      CALL s_yp(l_oga.oga02) RETURNING l_yy,l_mm
      IF ((l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52)) THEN
         LET g_errno='mfg6090' 
         RETURN
      END IF
   END IF
 
END FUNCTION
 
FUNCTION aws_create_shipping_order_gen_sheet(l_oga)
   DEFINE l_oga      RECORD LIKE oga_file.*
 
 
   IF l_oga.oga07='N' OR cl_null(l_oga.oga07) THEN
      LET g_errno = "axm-259"
      RETURN
   END IF
 
  #CHI-AC0002 mod --start--
  #CALL s_t600_gl(l_oga.oga01)
   CALL s_t600_gl(l_oga.oga01,'0')
   IF g_aza.aza63 = 'Y' THEN
      CALL s_t600_gl(l_oga.oga01,'1')
   END IF
  #CHI-AC0002 mod --end-- 
 
   RETURN
 
END FUNCTION
 
