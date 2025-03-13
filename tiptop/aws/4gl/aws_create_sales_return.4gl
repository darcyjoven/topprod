# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_sales_return.4gl
# Descriptions...: 提供建立銷退單資料的服務
# Date & Author..: No.FUN-840012 08/05/12 By Nicola
# Memo...........:
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#No.FUN-840012
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
DEFINE g_cnt   LIKE type_file.num5
 
#[
# Description....: 提供建立銷退單資料的服務(入口 function)
# Date & Author..: No.FUN-840012 08/05/12 By Nicola
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_sales_return()
 
   WHENEVER ERROR CONTINUE
 
   CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
 
   #--------------------------------------------------------------------------#
   # 新增銷退單資料                                                       #
   #--------------------------------------------------------------------------#
   IF g_status.code = "0" THEN
      CALL aws_create_sales_return_process()
   END IF
 
   CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
 
END FUNCTION
 
#[
# Description....: 依據傳出資訊新增 ERP 銷退單資料
# Date & Author..: No.FUN-840012 08/05/12 By Nicola
# Parameter......: 
# Return.........: 銷退單號
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_sales_return_process()
    DEFINE l_i        LIKE type_file.num10,
           l_j        LIKE type_file.num10
    DEFINE l_sql      STRING
    DEFINE l_cnt1     LIKE type_file.num10,
           l_cnt2     LIKE type_file.num10
    DEFINE l_node1    om.DomNode,
           l_node2    om.DomNode
    DEFINE l_flag     LIKE type_file.num10
    DEFINE l_return   RECORD                           #回傳值必須宣告為一個 RECORD 變數, 且此 RECORD 需包含所有要回傳的欄位名稱與定義
                         oha01   LIKE oha_file.oha01   #回傳的欄位名稱
                      END RECORD
    DEFINE l_oha      RECORD LIKE oha_file.*
    DEFINE l_ohb      RECORD LIKE ohb_file.*
    DEFINE l_status   LIKE type_file.chr1
    DEFINE l_cmd      STRING
    DEFINE l_prog     STRING
 
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的銷退單資料                                    #
    #--------------------------------------------------------------------------#
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("oha_file")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
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
        INITIALIZE l_oha.* TO NULL
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "oha_file")        #目前處理單檔的 XML 節點
        LET l_status = aws_ttsrv_getParameter("status")
 
        LET l_oha.oha01 = aws_ttsrv_getRecordField(l_node1, "oha01")  #取得此筆單檔資料的欄位值
        LET l_oha.oha02 = aws_ttsrv_getRecordField(l_node1, "oha02")  #單據日期
        LET l_oha.oha16 = aws_ttsrv_getRecordField(l_node1, "oha16")  #出貨單號
 
        IF cl_null(l_oha.oha02) OR l_oha.oha02=0 THEN
           LET l_oha.oha02  = g_today
        END IF
 
        #----------------------------------------------------------------------#
        # 檢查單據日期                                                         #
        #----------------------------------------------------------------------#
        CALL aws_create_sales_return_check_oha02(l_oha.*)
        IF NOT cl_null(g_errno) THEN
           LET g_status.code = g_errno
           EXIT FOR
        END IF
 
        #----------------------------------------------------------------------#
        # 銷退單自動取號                                                   #
        #----------------------------------------------------------------------#
        CALL s_check_no("axm",l_oha.oha01,"","60","oha_file","oha01","")
              RETURNING l_flag,l_oha.oha01
        IF NOT l_flag THEN
           LET g_status.code = "mfg0014"   #銷退單自動取號失敗
           EXIT FOR
        END IF
 
        CALL s_auto_assign_no("axm",l_oha.oha01,l_oha.oha02,"","oha_file","oha01","","","")
             RETURNING l_flag,l_oha.oha01
        IF NOT l_flag THEN
           LET g_status.code = "sub-145"   #銷退單自動取號失敗
           EXIT FOR
        END IF
 
        #------------------------------------------------------------------#
        # 設定銷退單頭預設值                                           #
        #------------------------------------------------------------------#
        CALL aws_create_sales_return_set_oha(l_oha.*) RETURNING l_oha.*
        IF NOT cl_null(g_errno) THEN
           LET g_status.code = g_errno
           EXIT FOR
        END IF
 
        #------------------------------------------------------------------#
        # RECORD資料傳到NODE                                               #
        #------------------------------------------------------------------#
        CALL aws_ttsrv_setRecordField_record(l_node1,base.Typeinfo.create(l_oha))
 
        LET l_sql = aws_ttsrv_getRecordSql(l_node1, "oha_file", "I", NULL)   #I 表示取得 INSERT SQL
 
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
        LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "ohb_file")       #取得目前單頭共有幾筆單身資料
        IF l_cnt2 = 0 THEN 
           LET g_status.code = "mfg-009"   #必須有單身資料
           EXIT FOR
        END IF
 
        CALL cl_flow_notify(l_oha.oha01,'I')  #新增資料到 p_flow
 
        FOR l_j = 1 TO l_cnt2
            INITIALIZE l_ohb.* TO NULL
            LET l_node2 = aws_ttsrv_getDetailRecord(l_node1,l_j,"ohb_file")   #目前單身的 XML 節點
 
            #------------------------------------------------------------------#
            # NODE資料傳到RECORD                                               #
            #------------------------------------------------------------------#
            LET l_ohb.ohb01=l_oha.oha01
            LET l_ohb.ohb03=l_j
 
            LET l_ohb.ohb04 = aws_ttsrv_getRecordField(l_node2, "ohb04")
            LET l_ohb.ohb09 = aws_ttsrv_getRecordField(l_node2, "ohb09")
            LET l_ohb.ohb091= aws_ttsrv_getRecordField(l_node2, "ohb091")
            LET l_ohb.ohb092= aws_ttsrv_getRecordField(l_node2, "ohb092")
            LET l_ohb.ohb12 = aws_ttsrv_getRecordField(l_node2, "ohb12")
            LET l_ohb.ohb31 = aws_ttsrv_getRecordField(l_node2, "ohb31")
            LET l_ohb.ohb32 = aws_ttsrv_getRecordField(l_node2, "ohb32")
 
            #------------------------------------------------------------------#
            # 單身欄位檢查                                                         #
            #------------------------------------------------------------------#
            CALL aws_create_sales_return_check_ohb(l_oha.*,l_ohb.*)
                 RETURNING l_ohb.*
            IF NOT cl_null(g_errno) THEN
               LET g_status.code=g_errno
               EXIT FOR
            END IF
 
            #------------------------------------------------------------------#
            # RECORD資料傳到NODE2                                              #
            #------------------------------------------------------------------#
            CALL aws_ttsrv_setRecordField_record(l_node2,base.Typeinfo.create(l_ohb))
 
            IF cl_null(l_ohb.ohb091) THEN 
               LET l_ohb.ohb091=" "
               CALL aws_ttsrv_setRecordField(l_node2, "ohb091", " ")
            END IF
            IF cl_null(l_ohb.ohb092) THEN 
               LET l_ohb.ohb092=" "
               CALL aws_ttsrv_setRecordField(l_node2, "ohb092", " ")
            END IF
 
            LET l_sql = aws_ttsrv_getRecordSql(l_node2, "ohb_file", "I", NULL) #I 表示取得 INSERT SQL
 
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
 
    #全部處理都成功才 COMMIT WORK
    IF g_status.code = "0" THEN
       LET l_return.oha01 = l_oha.oha01
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
 
    IF l_status='Y' THEN
       LET l_cmd="axmt700 '",l_oha.oha01 CLIPPED,"' 'M'"
       CALL cl_cmdrun_wait(l_cmd)
       CALL aws_ttsrv_cmdrun_checkStatus(l_prog)
    END IF
 
    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳自動取號結果
 
END FUNCTION
 
#[
# Description....: 銷退單設定欄位預設值
# Date & Author..: No.FUN-840012 08/05/12 By Nicola
# Parameter......: l_oha - 收貨單單頭
# Return.........: l_oha - 收貨單單頭
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_sales_return_set_oha(l_oha)
   DEFINE l_oha   RECORD LIKE oha_file.*
   DEFINE l_oga   RECORD LIKE oga_file.*
 
   LET g_errno=NULL
   #--------------------------------------------------------------------------#
   # 設定銷退單單頭欄位預設值                                             #
   #--------------------------------------------------------------------------#
 
   LET l_oha.oha05  ='1'
   LET l_oha.oha08  ='1'
   LET l_oha.oha09  ='1'
   LET l_oha.oha14  =g_user
   LET l_oha.oha15  =g_grup
   LET l_oha.oha41='N'
   LET l_oha.oha42='N'
   LET l_oha.oha43='N'
   LET l_oha.oha44='N'
   LET l_oha.oha45 = null               #No Use
   LET l_oha.oha46 = null               #No Use
   LET l_oha.oha47 = null               #運送車號
   LET l_oha.oha50  =0
   LET l_oha.oha53  =0
   LET l_oha.oha54  =0
   LET l_oha.oha55  ='0'
   LET l_oha.oha211 =0
   LET l_oha.oha1015='N'
   LET l_oha.oha1017='0'
   LET l_oha.oha1008='0'
   LET l_oha.ohaconf='N'
   LET l_oha.ohapost='N'
   LET l_oha.ohaprsw=0
   LET l_oha.ohauser=g_user
   LET g_data_plant = g_plant #FUN-980030
   LET l_oha.ohagrup=g_grup
   LET l_oha.ohadate=g_today
   LET l_oha.ohamksg='N'
 
   SELECT * INTO l_oga.* FROM oga_file
    WHERE oga01 = l_oha.oha16
      AND oga09='2'
 
   IF STATUS THEN
      LET g_errno = STATUS
      RETURN l_oha.*
   END IF
 
   IF l_oga.ogaconf != 'Y' THEN 
      LET g_errno = "axm-184"
      RETURN l_oha.*
   END IF
 
   IF l_oga.ogapost = 'N' THEN    #未扣帳
      LET g_errno = "axm-299"
      RETURN l_oha.*
   END IF
 
   IF l_oga.oga10 IS NULL THEN
      LET g_errno = "mfg-029"
      RETURN l_oha.*
   END IF
 
   IF cl_null(l_oga.oga16) THEN
      DECLARE ogb31_cs CURSOR FOR SELECT ogb31
                                    FROM ogb_file
                                   WHERE ogb01 = l_oga.oga01
      FOREACH ogb31_cs INTO l_oga.oga16
         EXIT FOREACH
      END FOREACH
   END IF
 
   LET l_oha.oha03   = l_oga.oga03
   LET l_oha.oha032  = l_oga.oga032
   LET l_oha.oha04   = l_oga.oga04
   LET l_oha.oha08   = l_oga.oga08        #內/外銷
   LET l_oha.oha10   = NULL               #帳單編號
   LET l_oha.oha14   = l_oga.oga14
   LET l_oha.oha15   = l_oga.oga15
   LET l_oha.oha21   = l_oga.oga21
   LET l_oha.oha211  = l_oga.oga211
   LET l_oha.oha212  = l_oga.oga212
   LET l_oha.oha213  = l_oga.oga213
   LET l_oha.oha23   = l_oga.oga23
   LET l_oha.oha1005 = l_oga.oga1005 
   LET l_oha.oha1001 = l_oga.oga18   
   LET l_oha.oha1011 = l_oga.oga1011
   LET l_oha.oha1010 = l_oga.oga1010
   LET l_oha.oha1003 = l_oga.oga1003
   LET l_oha.oha1009 = l_oga.oga1009
   LET l_oha.oha1002 = l_oga.oga1002
   LET l_oha.oha1014 = l_oga.oga1004
 
   IF l_oga.oga24=0 OR l_oga.oga24 IS NULL THEN
      CALL s_curr3(l_oha.oha23,l_oha.oha02,g_oaz.oaz52)
              RETURNING l_oha.oha24
   ELSE
      LET l_oha.oha24 = l_oga.oga24
   END IF
 
   LET l_oha.oha25 = l_oga.oga25
   LET l_oha.oha26 = l_oga.oga26
   LET l_oha.oha31 = l_oga.oga31
 
   RETURN l_oha.*
 
END FUNCTION
 
#[
# Description....: 由出貨單單身帶資料進銷退單單身並檢查欄位資料
# Date & Author..: No.FUN-840012 08/05/12 By Nicola
# Parameter......: l_oha-銷退單頭,l_ohb - 銷退單身
# Return.........: l_ohb-銷退單單身值 ; use g_errno 判斷檢查是否有誤
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_sales_return_check_ohb(l_oha,l_ohb)
   DEFINE l_oha      RECORD LIKE oha_file.*
   DEFINE l_ohb      RECORD LIKE ohb_file.*
   DEFINE l_oga      RECORD LIKE oga_file.*
   DEFINE l_ogb      RECORD LIKE ogb_file.*
   DEFINE t_azi03    LIKE azi_file.azi03
   DEFINE t_azi04    LIKE azi_file.azi04
 
   LET g_errno=NULL
 
   LET l_ohb.ohb13=0
   LET l_ohb.ohb14=0
   LET l_ohb.ohb14t=0
   LET l_ohb.ohb1003=100
   LET l_ohb.ohb05_fac=1
   LET l_ohb.ohb15_fac=1
   LET l_ohb.ohb16=0
   LET l_ohb.ohb60=0
   LET l_ohb.ohb11='' 
   LET l_ohb.ohb930=s_costcenter(l_oha.oha15)
 
   IF NOT cl_null(l_oha.oha16) THEN
      IF l_ohb.ohb31 != l_oha.oha16 THEN
         LET g_errno = "axm-300"
         RETURN l_ohb.*
      END IF
   END IF
 
   SELECT oga_file.*,ogb_file.*
     INTO l_oga.*,l_ogb.*
     FROM oga_file,ogb_file
    WHERE oga01=l_ohb.ohb31
      AND ogb03=l_ohb.ohb32
      AND oga01 = ogb01
      AND oga09 = '2'
      AND ogb1005='1'
 
   IF STATUS THEN
      LET g_errno = STATUS
      RETURN l_ohb.*
   END IF
 
   IF l_oga.ogaconf != 'Y' THEN
      CALL cl_err('sel oga','axm-184',0)
      RETURN l_ohb.*
   END IF
 
   #帳單編號為null
   IF l_oha.oha09 MATCHES '[145]' AND l_oga.oga10 IS NULL THEN
      LET g_errno = "mfg-029"
      RETURN l_ohb.*
   END IF
 
   LET l_ohb.ohb05   = l_ogb.ogb05
   LET l_ohb.ohb05_fac= l_ogb.ogb05_fac
   LET l_ohb.ohb1007 = l_ogb.ogb1007
   LET l_ohb.ohb1008 = l_ogb.ogb1008
   LET l_ohb.ohb1009 = l_ogb.ogb1009
   LET l_ohb.ohb1010 = l_ogb.ogb1010
   LET l_ohb.ohb1011 = l_ogb.ogb1011
 
   IF cl_null(l_ohb.ohb091) THEN LET l_ohb.ohb091=' ' END IF
   IF cl_null(l_ohb.ohb092) THEN LET l_ohb.ohb092=' ' END IF
 
   #檢查料件庫存資料
   SELECT img09 INTO l_ohb.ohb15 FROM img_file
    WHERE img01 = l_ohb.ohb04
      AND img02 = l_ohb.ohb09
      AND img03 = l_ohb.ohb091
      AND img04 = l_ohb.ohb092 
   IF SQLCA.sqlcode OR STATUS = 100 THEN
      LET g_errno = "mfg6069"
      RETURN l_ohb.*
   END IF
 
   IF l_ohb.ohb05 = l_ohb.ohb15 THEN
      LET l_ohb.ohb15_fac =1
   ELSE
      #檢查該發料單位與主檔之單位是否可以轉換
      CALL s_umfchk(l_ohb.ohb04,l_ohb.ohb05,l_ohb.ohb15)
          RETURNING g_cnt,l_ohb.ohb15_fac
       IF g_cnt = 1 THEN
          LET g_errno ='mfg3075'
          RETURN l_ohb.*
       END IF
   END IF
 
   SELECT COUNT(*) INTO g_cnt FROM img_file
    WHERE img01 = l_ohb.ohb04   #料號
      AND img02 = l_ohb.ohb09   #倉庫
      AND img03 = l_ohb.ohb091  #儲位
      AND img04 = l_ohb.ohb092  #批號
      AND img18 < l_oha.oha02
   IF g_cnt > 0 THEN
      LET g_errno = "aim-400"
      RETURN l_ogb.*
   END IF
 
   IF l_ohb.ohb12 > l_ogb.ogb12 THEN
      LET g_errno = "axm-128"
      RETURN l_ohb.*
   END IF
 
   LET l_ohb.ohb16 = l_ohb.ohb12 * l_ohb.ohb15_fac
 
   IF l_oha.oha213 = 'N' THEN
      LET l_ohb.ohb14 =l_ohb.ohb12 * l_ohb.ohb13
      LET l_ohb.ohb14t=l_ohb.ohb14 * (1 + l_oha.oha211 / 100)
   ELSE
      LET l_ohb.ohb14t=l_ohb.ohb12 * l_ohb.ohb13
      LET l_ohb.ohb14 =l_ohb.ohb14t / (1 + l_oha.oha211 / 100)
   END IF
 
   SELECT azi03,azi04 INTO t_azi03,t_azi04
     FROM azi_file
    WHERE azi01=l_oha.oha23
 
   CALL cl_digcut(l_ohb.ohb14,t_azi04) RETURNING l_ohb.ohb14
 
   CALL cl_digcut(l_ohb.ohb14t,t_azi04)RETURNING l_ohb.ohb14t
 
   LET l_ohb.ohb916 = l_ohb.ohb05
   LET l_ohb.ohb917 = l_ohb.ohb12
 
   IF cl_null(l_ohb.ohb12) THEN
     LET l_ohb.ohb12 = 0
   END IF
 
   IF cl_null(l_ohb.ohb13) THEN
     LET l_ohb.ohb13 = 0
   END IF
 
   IF cl_null(l_ohb.ohb14) THEN
     LET l_ohb.ohb14 = 0
   END IF
 
   IF cl_null(l_ohb.ohb14t) THEN
     LET l_ohb.ohb14t = 0
   END IF
 
   IF cl_null(l_ohb.ohb15_fac) THEN
      LET l_ohb.ohb15_fac = 1
   END IF
 
   IF cl_null(l_ohb.ohb16) THEN
      LET l_ohb.ohb16 = 0
   END IF
 
   RETURN l_ohb.*
 
END FUNCTION
 
FUNCTION aws_create_sales_return_check_oha02(l_oha)
   DEFINE l_oha RECORD LIKE oha_file.*
   DEFINE l_yy LIKE sma_file.sma51
   DEFINE l_mm LIKE sma_file.sma52
 
   LET g_errno=NULL
 
   IF NOT cl_null(l_oha.oha02) THEN
      IF l_oha.oha02 <= g_oaz.oaz09 THEN #銷售系統關帳日
         LET g_errno='axm-164' 
         RETURN
      END IF
 
      CALL s_yp(l_oha.oha02) RETURNING l_yy,l_mm
 
      IF l_yy > g_sma.sma51 THEN
         LET g_errno = "mfg6091"
         RETURN
      END IF
 
      IF (l_yy = g_sma.sma51 AND l_mm > g_sma.sma52) THEN
         LET g_errno = "mfg6091"
         RETURN
      END IF
   END IF
 
END FUNCTION
 
