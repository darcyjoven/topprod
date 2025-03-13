# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_shipping_orders_without_orders.4gl
# Descriptions...: 提供建立出貨單資料的服務
# Date & Author..: No.FUN-B10004 11/01/05 By Mandy
# Memo...........:
# Modify.........: No.FUN-BB0022 11/11/04 By Abby oga69(輸入日期)需承接CRM拋轉的oga69,若oga69 is null,則預設帶系統日期
# Modify.........: No.FUN-C20054 12/02/08 By Lilan 新增欄位:ogaslk02
# Modify.........: No.FUN-C80107 12/09/18 By suncx 新增可按倉庫進行負庫存判斷
# Modify.........: No:FUN-D30024 13/03/12 By fengrui 負庫存依據imd23判斷
# Modify.........: No:TQC-D40078 13/04/27 By fengrui 負庫存函数添加营运中心参数
#}


DATABASE ds
 
#No.FUN-B10004
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
DEFINE g_cnt    LIKE type_file.num5
#DEFINE g_sma894 LIKE type_file.chr1  #FUN-C80107 #FUN-D30024 mark
DEFINE g_imd23  LIKE type_file.chr1   #FUN-D30024 add
 
#[
# Description....: 提供建立出貨單資料的服務(入口 function)
# Date & Author..: No.FUN-B10004 11/01/05 By Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_shipping_orders_without_orders()
 
   WHENEVER ERROR CONTINUE
 
   CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
 
   #--------------------------------------------------------------------------#
   # 新增出貨單資料                                                       #
   #--------------------------------------------------------------------------#
   IF g_status.code = "0" THEN
      CALL aws_create_shipping_orders_without_orders_process()
   END IF
 
   CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
 
END FUNCTION
 
#[
# Description....: 依據傳出資訊新增 ERP 出貨單資料
# Date & Author..: No.FUN-B10004 11/01/05 By Mandy
# Parameter......: 
# Return.........: 出貨單號
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_shipping_orders_without_orders_process()
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

    SELECT * INTO g_oaz.*
      FROM oaz_file
     WHERE oaz00='0'
 
    FOR l_i = 1 TO l_cnt1
        INITIALIZE l_oga.* TO NULL
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "oga_file")        #目前處理單檔的 XML 節點
        LET l_status = aws_ttsrv_getParameter("status")
 
        LET l_oga.oga00 = aws_ttsrv_getRecordField(l_node1, "oga00")    #出貨別
        LET l_oga.oga01 = aws_ttsrv_getRecordField(l_node1, "oga01")    #出貨單號
        LET l_oga.oga011 = aws_ttsrv_getRecordField(l_node1,"oga011")   #出貨通知單號
        LET l_oga.oga02 = aws_ttsrv_getRecordField(l_node1, "oga02")    #單據日期
        LET l_oga.oga03 = aws_ttsrv_getRecordField(l_node1, "oga03")    #帳款客戶編號
        LET l_oga.oga033= aws_ttsrv_getRecordField(l_node1, "oga032")   #帳款客戶統一編號
        LET l_oga.oga14 = aws_ttsrv_getRecordField(l_node1, "oga14")    #人員編號
        LET l_oga.oga21 = aws_ttsrv_getRecordField(l_node1, "oga21")    #稅別
        LET l_oga.oga23 = aws_ttsrv_getRecordField(l_node1, "oga23")    #幣別
        LET l_oga.oga32 = aws_ttsrv_getRecordField(l_node1, "oga32")    #收款條件編號
        LET l_oga.oga70 = aws_ttsrv_getRecordField(l_node1, "oga70")    #調撥單號
        LET l_oga.oga69 = aws_ttsrv_getRecordField(l_node1, "oga69")    #輸入日期  #FUN-BB0022 add

        #單頭重要資料檢查
        IF NOT aws_create_shipping_orders_without_orders_chk_imp_oga(l_oga.*) THEN
            LET g_status.code = "mfg6138" #重要欄位不可空白
            EXIT FOR
        END IF
 
        IF cl_null(l_oga.oga02) OR l_oga.oga02=0 THEN
           LET l_oga.oga02  = g_today
        END IF
        #----------------------------------------------------------------------#
        # 檢查單據日期                                                         #
        #----------------------------------------------------------------------#
        CALL aws_create_shipping_orders_without_orders_check_oga02(l_oga.*)
        IF NOT cl_null(g_errno) THEN
           LET g_status.code = g_errno
           EXIT FOR
        END IF
 
        #----------------------------------------------------------------------#
        # 出貨單自動取號                                                   #
        #----------------------------------------------------------------------#
        CALL s_check_no("axm",l_oga.oga01,"","50","oga_file","oga01","")
              RETURNING l_flag,l_oga.oga01
        IF NOT l_flag THEN
           LET g_status.code = "mfg0014"   #無此單別
           EXIT FOR
        END IF
 
        CALL s_auto_assign_no("axm",l_oga.oga01,l_oga.oga02,"50","oga_file","oga01","","","")
             RETURNING l_flag,l_oga.oga01
        IF NOT l_flag THEN
           LET g_status.code = "sub-145"   #自動編號錯誤!
           EXIT FOR
        END IF

        #------------------------------------------------------------------#
        # 設定出貨單頭預設值                                               #
        #------------------------------------------------------------------#
        CALL aws_create_shipping_orders_without_orders_set_oga(l_oga.*) RETURNING l_oga.*
        IF NOT cl_null(g_errno) THEN
           LET g_status.code = g_errno
           EXIT FOR
        END IF

        #------------------------------------------------------------------#
        # 檢查出貨單頭欄位
        #------------------------------------------------------------------#
        CALL aws_create_shipping_orders_without_orders_chk_oga(l_oga.*) RETURNING l_oga.*
        IF NOT Cl_null(g_errno) THEN
           LET g_status.code = g_errno
           EXIT FOR
        END IF
 
        #------------------------------------------------------------------#
        # RECORD資料傳到NODE                                               #
        #------------------------------------------------------------------#
        CALL aws_ttsrv_setRecordField_record(l_node1,base.Typeinfo.create(l_oga))

        IF cl_null(l_oga.oga85) THEN 
           LET l_oga.oga85 = " "
           CALL aws_ttsrv_setRecordField(l_node1, "oga85"," ")
        END IF
 
        CALL aws_ttsrv_setRecordField(l_node1, "ogaslk02"," ")  #FUN-C20054 add

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
        LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "ogb_file")       #取得目前單身共有幾筆單身資料
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
 
            LET l_ogb.ogb04 = aws_ttsrv_getRecordField(l_node2, "ogb04")
            LET l_ogb.ogb05 = aws_ttsrv_getRecordField(l_node2, "ogb05")
            LET l_ogb.ogb09 = aws_ttsrv_getRecordField(l_node2, "ogb09")
            LET l_ogb.ogb091= aws_ttsrv_getRecordField(l_node2, "ogb091")
            LET l_ogb.ogb12 = aws_ttsrv_getRecordField(l_node2, "ogb12")
            LET l_ogb.ogb13 = aws_ttsrv_getRecordField(l_node2, "ogb13")
            LET l_ogb.ogb14 = aws_ttsrv_getRecordField(l_node2, "ogb14")
            LET l_ogb.ogb14t= aws_ttsrv_getRecordField(l_node2, "ogb14t")
            LET l_ogb.ogb31 = aws_ttsrv_getRecordField(l_node2, "ogb31")
            LET l_ogb.ogb32 = aws_ttsrv_getRecordField(l_node2, "ogb32")

            #單身重要資料檢查
            IF NOT aws_create_shipping_orders_without_orders_chk_imp_ogb(l_ogb.*) THEN
                LET g_status.code = "mfg6138" #重要欄位不可空白
                EXIT FOR
            END IF
            #------------------------------------------------------------------#
            # 單身欄位檢查                                                         #
            #------------------------------------------------------------------#
            CALL aws_create_shipping_orders_without_orders_chk_ogb(l_oga.*,l_ogb.*)
                 RETURNING l_ogb.*
            IF NOT cl_null(g_errno) THEN
               LET g_status.code=g_errno
               EXIT FOR
            END IF
 
            SELECT max(ogb03)+1 
              INTO l_ogb.ogb03
              FROM ogb_file 
             WHERE ogb01 = l_oga.oga01
            IF l_ogb.ogb03 IS NULL THEN
                LET l_ogb.ogb03 = 1
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
    IF g_status.code = "0" THEN
        CALL aws_create_shipping_orders_without_orders_t650_bu(l_oga.*)
    END IF
    LET l_return.oga01 = l_oga.oga01
    IF g_status.code = "0" THEN
        IF g_oay.oayconf='Y' THEN #單據需自動確認
            CALL t650sub_y(l_oga.oga01)
            IF g_success = 'Y' THEN
                COMMIT WORK
                CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
            ELSE
                LET g_status.code = g_errno
                ROLLBACK WORK
            END IF
        ELSE
            COMMIT WORK
            CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))
        END IF
    ELSE
        ROLLBACK WORK
    END IF
END FUNCTION
 
#[
# Description....: 出貨單設定欄位預設值
# Date & Author..: No.FUN-B10004 11/01/05 By Mandy
# Parameter......: l_oga - 收貨單單頭
# Return.........: l_oga - 收貨單單頭
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_shipping_orders_without_orders_set_oga(l_oga)
   DEFINE l_oga   RECORD LIKE oga_file.*
   DEFINE l_oga_u RECORD LIKE oga_file.*
   DEFINE l_ogb31 LIKE ogb_file.ogb31
   DEFINE l_ogb32 LIKE ogb_file.ogb32
 
   LET g_errno = ''
   #--------------------------------------------------------------------------#
   # 設定出貨單單頭欄位預設值                                             #
   #--------------------------------------------------------------------------#
 
   LET l_oga.oga00  = '1'                                           #1:一般出貨
   LET l_oga.oga06  = g_oaz.oaz41
   LET l_oga.oga07  = 'N'     
   LET l_oga.oga08  = '1'  #內銷
   LET l_oga.oga09  = '3'
   LET l_oga.oga161 = 0
   LET l_oga.oga162 = 100
   LET l_oga.oga163 = 0
   LET l_oga.oga20  = 'Y'
   LET l_oga.oga50  = 0
   LET l_oga.oga52  = 0
   LET l_oga.oga53  = 0
   LET l_oga.oga54  = 0
   LET l_oga.oga55   = '' 
   LET l_oga.oga903 = 'N'
   LET l_oga.oga905  = 'N'
   LET l_oga.ogaconf= 'N'
   LET l_oga.oga30  = 'N'
   LET l_oga.oga65  = 'N'
   LET l_oga.ogapost= 'N'
   LET l_oga.ogaprsw= 0
   LET l_oga.ogauser= g_user
   LET l_oga.ogaoriu= g_user
   LET l_oga.ogaorig= g_grup
   LET g_data_plant = g_plant 
   LET l_oga.ogagrup= g_grup
   LET l_oga.ogadate= g_today
   LET l_oga.ogaplant = g_plant 
   LET l_oga.ogalegal = g_legal 
   LET l_oga.oga99   = ''
   LET l_oga.oga85 = ' '
   LET l_oga.oga94 = 'N'
   LET l_oga.oga57 = '1'

   RETURN l_oga.*
 
END FUNCTION
 
FUNCTION aws_create_shipping_orders_without_orders_chk_oga(l_oga)
   DEFINE l_oga     RECORD LIKE oga_file.*
   DEFINE l_oga_u   RECORD LIKE oga_file.*
   DEFINE l_occ     RECORD LIKE occ_file.*
   DEFINE exT       LIKE type_file.chr1
   DEFINE l_gen03   LIKE gen_file.gen03
   DEFINE l_gemacti LIKE gem_file.gemacti
   DEFINE l_gec011  LIKE gec_file.gec011
   DEFINE l_exdate  LIKE oga_file.oga021    

   LET g_errno = ''
 
   LET l_oga_u.* = l_oga.*

   #=>oga03帳款客戶編號
   SELECT * INTO l_occ.* FROM occ_file
    WHERE occ01 = l_oga.oga03
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='anm-045' #無此客戶代號, 請重新輸入
       WHEN l_occ.occacti <> 'Y'    LET g_errno='atm-008' #該客戶未確認！
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF NOT cl_null(g_errno) THEN
       RETURN l_oga.*
   END IF
 
   IF cl_null(l_oga.oga04) THEN
      LET l_oga.oga04 = l_occ.occ09
   END IF
   IF cl_null(l_oga.oga18) THEN
      LET l_oga.oga18 = l_occ.occ07
   END IF
   IF cl_null(l_oga.oga13) THEN
      LET l_oga.oga13 = l_occ.occ67
   END IF 
   IF cl_null(l_oga.oga05) THEN
       LET l_oga.oga05 = l_occ.occ08
   END IF
   IF cl_null(l_oga.oga14) THEN
       IF NOT cl_null(l_occ.occ04) THEN
           LET l_oga.oga14 = l_occ.occ04
       ELSE
           LET g_errno = 'aws-704' #客戶基本資料檔內負責業務員為空!
           RETURN l_oga.*
       END IF
   END IF
   IF cl_null(l_oga.oga21) THEN
       LET l_oga.oga21 = l_occ.occ41
   END IF
   IF cl_null(l_oga.oga23) THEN
       LET l_oga.oga23 = l_occ.occ42
   END IF
   IF cl_null(l_oga.oga25) THEN
       LET l_oga.oga25 = l_occ.occ43
   END IF
   IF cl_null(l_oga.oga31) THEN
       LET l_oga.oga31 = l_occ.occ44  
   END IF
   IF cl_null(l_oga.oga32) THEN
       LET l_oga.oga32 = l_occ.occ45
   END IF

   IF l_oga.oga08='1' THEN
      LET exT=g_oaz.oaz52
   ELSE
      LET exT=g_oaz.oaz70
   END IF
 
   IF NOT cl_null(l_oga.oga021) THEN
      LET l_exdate = l_oga.oga021    #結關日期
   ELSE
      LET l_exdate = l_oga.oga02     #出貨日期
   END IF 
   CALL s_curr3(l_oga.oga23,l_exdate,exT) RETURNING l_oga.oga24
 

   #=>oga14人員編號
    SELECT gen03 
      INTO l_gen03
      FROM gen_file 
     WHERE gen01 = l_oga.oga14
    IF SQLCA.sqlcode THEN
        LET g_errno = 'mfg3096' #無此人員代碼,請重新輸入
        RETURN l_oga.*
    END IF
    LET l_oga.oga15 = l_gen03
    IF l_oga.oga03[1,4] != 'MISC' THEN
       LET l_oga.oga032 = l_occ.occ02 
    END IF

    SELECT gemacti INTO l_gemacti
      FROM gem_file
     WHERE gem01 = l_oga.oga15
    CASE
        WHEN SQLCA.sqlcode=100   LET g_errno='aap-039' #無此部門編號, 請重新輸入!
        WHEN l_gemacti <> 'Y'    LET g_errno='asf-472' #此部門代號已無效,請重新輸入
        OTHERWISE
             LET g_errno=SQLCA.sqlcode USING '------'
    END CASE
    IF NOT cl_null(g_errno) THEN
        RETURN l_oga.*
    END IF

    #=>oga21稅別
    SELECT gec04,gec05,gec07,gec011
      INTO l_oga.oga211,l_oga.oga212,l_oga.oga213,l_gec011
      FROM gec_file 
     WHERE gec01  = l_oga.oga21
       AND gec011 = '2'
    CASE
        WHEN SQLCA.sqlcode=100   LET g_errno='mfg3044' #無此稅別代號,請重新輸入!
        OTHERWISE
             LET g_errno=SQLCA.sqlcode USING '------'
    END CASE
    IF NOT cl_null(g_errno) THEN
        RETURN l_oga.*
    END IF

    #=>oga23幣別
    SELECT * FROM azi_file 
     WHERE azi01 = l_oga.oga23
    IF SQLCA.sqlcode THEN
        LET g_errno = 'agl-251' #幣別資料不正確
        RETURN l_oga.*
    END IF
    
    #=>oga32收款條件編號
    SELECT * FROM oag_file
     WHERE oag01 = l_oga.oga32
    IF SQLCA.sqlcode THEN
        LET g_errno = 'axr-955' #無此收款條件!
        RETURN l_oga.*
    END IF

   #FUN-BB0022 add str---
    IF cl_null(l_oga.oga69) THEN
       LET l_oga.oga69 = g_today
    END IF
   #FUN-BB0022 add end---

    RETURN l_oga.*
 
END FUNCTION
#[
# Description....: 由出通單單身帶資料進出貨單單身並檢查欄位資料
# Date & Author..: No.FUN-B10004 11/01/05 By Mandy
# Parameter......: l_oga-出貨單頭,l_ogb - 出貨單身
# Return.........: l_ogb-出貨單單身值 ; use g_errno 判斷檢查是否有誤
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_shipping_orders_without_orders_chk_ogb(l_oga,l_ogb)
   DEFINE l_oga      RECORD LIKE oga_file.*
   DEFINE l_ogb      RECORD LIKE ogb_file.*
   DEFINE l_ogb_u    RECORD LIKE ogb_file.*
   DEFINE l_ima02    LIKE ima_file.ima02
   DEFINE l_ima021   LIKE ima_file.ima021
   DEFINE l_ima25    LIKE ima_file.ima25
   DEFINE l_ima31    LIKE ima_file.ima31
   DEFINE l_ima35    LIKE ima_file.ima35
   DEFINE l_ima36    LIKE ima_file.ima36
   DEFINE l_imaacti  LIKE ima_file.imaacti
   DEFINE l_img10    LIKE img_file.img10
   DEFINE l_n        LIKE type_file.num5
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_ogb12a   LIKE ogb_file.ogb12
   DEFINE l_ogb12b   LIKE ogb_file.ogb12
   DEFINE t_azi03    LIKE azi_file.azi03
   DEFINE t_azi04    LIKE azi_file.azi04
   DEFINE l_factor   LIKE img_file.img21
 
   LET g_errno=NULL
 
   LET l_ogb_u.* = l_ogb.*
  ##ogb04產品編號
   IF NOT s_chk_item_no(l_ogb.ogb04,"") THEN
       RETURN l_ogb.*
   END IF
   IF l_ogb.ogb04[1,4]<> 'MISC' THEN
       SELECT ima02,ima021,ima31,ima35,ima36,imaacti,ima25
         INTO l_ima02,l_ima021,l_ima31,l_ima35,l_ima36,l_imaacti,l_ima25
         FROM ima_file 
        WHERE ima01 = l_ogb.ogb04
       CASE
           WHEN SQLCA.sqlcode=100   LET g_errno='aco-001' #無此產品編號!
           WHEN l_imaacti <> 'Y'    LET g_errno='art-182' #該產品未被審核
           OTHERWISE
                LET g_errno=SQLCA.sqlcode USING '------'
       END CASE
   ELSE
       LET l_n = 0 
       SELECT COUNT(*) INTO l_n
         FROM ima_file
        WHERE ima01='MISC'
       IF l_n=0 THEN
           LET g_errno = 'aim-806' #料件主檔中無『MISC 料號』請先建立一筆『MISC 料號』!
       END IF
   END IF
   IF NOT cl_null(g_errno) THEN
       RETURN l_ogb.*
   END IF
   IF cl_null(l_ogb.ogb05) THEN
       LET l_ogb.ogb05 = l_ima31
   END IF
   LET l_factor = 1
   CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_ima25)
         RETURNING l_cnt,l_factor
   IF l_cnt = 1 THEN
      LET l_factor = 1
   END IF
   LET l_ogb.ogb05_fac = l_factor
   IF cl_null(l_ogb.ogb06) THEN
       LET l_ogb.ogb06 = l_ima02
   END IF
   LET l_ogb.ogb08 = g_plant
   IF cl_null(l_ogb.ogb09) THEN
       LET l_ogb.ogb09 = ' '
   END IF
   IF cl_null(l_ogb.ogb091) THEN
       LET l_ogb.ogb091 = ' '
   END IF
   LET l_ogb.ogb092 = ' '
   SELECT obk03 
     INTO l_ogb.ogb11
     FROM obk_file
    WHERE obk01 = l_ogb.ogb04 
      AND obk02 = l_oga.oga03
   LET l_ogb.ogb15 = l_ogb.ogb05
   LET l_ogb.ogb15_fac = 1
   LET l_ogb.ogb16 = l_ogb.ogb12 * l_ogb.ogb15_fac

   #ogb05銷售單位
   SELECT COUNT(*) 
     INTO l_cnt 
     FROM gfe_file
    WHERE gfe01 = l_ogb.ogb05
   IF l_cnt = 0 THEN
       LET g_errno = 'mfg3377' #[單位]在檔案中不存在!
       RETURN l_ogb.*
   END IF
   
   #ogb17多倉儲批出貨否
   LET l_ogb.ogb17 = 'N'
   LET l_ogb.ogb18 = 0
   LET l_ogb.ogb60 = 0
   LET l_ogb.ogb63 = 0
   LET l_ogb.ogb64 = 0
   LET l_ogb.ogbplant = g_plant
   LET l_ogb.ogblegal = g_legal
   LET l_ogb.ogb44 = '1'
   LET l_ogb.ogb47 = '0'
   #AFTER FIELD ogb09後的判斷---str---
   IF l_ogb.ogb09 IS NULL THEN LET l_ogb.ogb09=' ' END IF
   IF g_oaz.oaz103 <> 'Y' THEN 
      IF NOT cl_null(l_ogb.ogb09) AND
         l_ogb.ogb17 = 'N' AND
         l_ogb.ogb04 NOT MATCHES 'MISC*' THEN
         LET l_ogb.ogb091 =' '
         LET l_ogb.ogb092 =' '
         SELECT img10 INTO l_img10 FROM img_file
          WHERE img01=l_ogb.ogb04
            AND img02=l_ogb.ogb09
            AND img03=l_ogb.ogb091
            AND img04=l_ogb.ogb092
         IF SQLCA.sqlcode THEN
             LET g_errno = '-1281' #該料號+倉庫+ 儲位不存在現行庫存 img_file 中
             RETURN l_ogb.*
         END IF
      END IF
   END IF
   IF NOT cl_null(l_ogb.ogb09) THEN
       IF NOT s_chk_ware(l_ogb.ogb09) THEN
           RETURN l_ogb.*
       END IF
      LET g_cnt=0
      SELECT count(*) INTO g_cnt  FROM imd_file
       WHERE imd01=l_ogb.ogb09
          AND imdacti='Y'
      IF g_cnt=0 THEN
          LET g_errno = 'axm-993'
          RETURN l_ogb.*
      END IF
   END IF
   #AFTER FIELD ogb09後的判斷---end---

   #AFTER FIELD ogb091後的判斷---str---
        #調整和axmt620一樣,在過帳才去check有無庫存,有無此料/倉/儲/批
        #檢查料號預設倉儲及單別預設倉儲
        IF l_ogb.ogb091 IS NULL THEN LET l_ogb.ogb091=' ' END IF
        IF l_ogb.ogb092 IS NULL THEN LET l_ogb.ogb092=' ' END IF 
        IF l_ogb.ogb091 IS NOT NULL AND NOT cl_null(l_ogb.ogb09) THEN     
           IF NOT s_chksmz(l_ogb.ogb04, l_oga.oga01,
                           l_ogb.ogb09, l_ogb.ogb091) THEN
               RETURN l_ogb.*
           END IF
        END IF
        IF NOT cl_null(l_ogb.ogb09) AND
            l_ogb.ogb17 = 'N' AND
            l_ogb.ogb04 NOT MATCHES 'MISC*' THEN
            SELECT img10 INTO l_img10 FROM img_file
             WHERE img01=l_ogb.ogb04
               AND img02=l_ogb.ogb09
               AND img03=l_ogb.ogb091
               AND img04=l_ogb.ogb092
            IF SQLCA.sqlcode THEN
                LET g_errno = '-1281' #該料號+倉庫+ 儲位不存在現行庫存 img_file 中
                RETURN l_ogb.*
            END IF
        END IF
   #AFTER FIELD ogb091後的判斷---end---

   #ogb12實際出貨數量(銷售單位)
   IF l_ogb.ogb12 <= 0 THEN
       LET g_errno = 'aws-701' #數量不可小於等於零
       RETURN l_ogb.*
   END IF
   IF cl_null(l_ogb.ogb916) THEN
      LET l_ogb.ogb916 = l_ogb.ogb05
      LET l_ogb.ogb917 = l_ogb.ogb12
   END IF
   IF l_ogb.ogb12 > l_img10 THEN
     #FUN-D30024--modify--str--
     #INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
     #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],l_ogb.ogb09) RETURNING g_sma894            #FUN-C80107
     ##IF g_sma.sma894[2,2]='N' OR g_sma.sma894[2,2] IS NULL THEN                               #FUN-C80107 mark
     #IF g_sma894 = 'N' THEN                                                                    #FUN-C80107
      INITIALIZE g_imd23 TO NULL                               
      CALL s_inv_shrt_by_warehouse(l_ogb.ogb09,g_plant) RETURNING g_imd23  #TQC-D40078 g_plant
      IF g_imd23 = 'N' THEN                                    
     #FUN-D30023--modify--end--
         LET g_errno = 'axm-280' #出貨數量不可大於庫存可用數量!
      END IF
   END IF
   
   #ogb13原幣單價
   IF l_ogb.ogb13 < 0 THEN
       LET g_errno = 'aws-702' #單價不可空白或小於 0 請重新輸入
       RETURN l_ogb.*
   END IF
   SELECT azi03,azi04 
     INTO t_azi03,t_azi04 
     FROM azi_file
    WHERE azi01 = l_oga.oga23
   LET l_ogb.ogb13 = cl_digcut(l_ogb.ogb13,t_azi03)
   IF cl_null(l_ogb.ogb37) OR l_ogb.ogb37 = 0 THEN
      LET l_ogb.ogb37 = l_ogb.ogb13
   END IF
   IF cl_null(l_ogb.ogb916) THEN
      LET l_ogb.ogb916 = l_ogb.ogb05
      LET l_ogb.ogb917 = l_ogb.ogb12
   END IF
   IF l_oga.oga213 = 'N' THEN
      LET l_ogb.ogb14 =l_ogb.ogb917*l_ogb.ogb13
      LET l_ogb.ogb14t=l_ogb.ogb14*(1+l_oga.oga211/100)
      CALL cl_digcut(l_ogb.ogb14,t_azi04) 
           RETURNING l_ogb.ogb14
      CALL cl_digcut(l_ogb.ogb14t,t_azi04)
           RETURNING l_ogb.ogb14t
   ELSE
      LET l_ogb.ogb14t=l_ogb.ogb917*l_ogb.ogb13
      LET l_ogb.ogb14 =l_ogb.ogb14t/(1+l_oga.oga211/100)
      CALL cl_digcut(l_ogb.ogb14t,t_azi04)
           RETURNING l_ogb.ogb14t
      CALL cl_digcut(l_ogb.ogb14,t_azi04)
           RETURNING l_ogb.ogb14
   END IF
   LET l_ogb.ogb1005 = '1'
   LET l_ogb.ogb1002 = 'N'
   LET l_ogb.ogb930 = s_costcenter(l_oga.oga15) 
   LET l_ogb.ogb1014 = 'N'
   LET l_ogb.ogb1012 = 'N'

   RETURN l_ogb.*
 
END FUNCTION
 
FUNCTION aws_create_shipping_orders_without_orders_check_oga02(l_oga)
   DEFINE l_oga RECORD LIKE oga_file.*
   DEFINE l_yy LIKE sma_file.sma51
   DEFINE l_mm LIKE sma_file.sma52
   DEFINE l_bookno1 LIKE aza_file.aza81     
   DEFINE l_bookno2 LIKE aza_file.aza82    
   DEFINE l_flag    LIKE type_file.chr1
 
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
      CALL s_get_bookno(YEAR(l_oga.oga02)) RETURNING l_flag,l_bookno1,l_bookno2                                                         
      IF l_flag =  '1' THEN  #抓不到帳別                                                                                                
         LET g_errno='aoo-081'
         RETURN
      END IF                                                                                                                            
   END IF
 
END FUNCTION
 
FUNCTION aws_create_shipping_orders_without_orders_chk_imp_oga(l_oga)
   DEFINE l_oga RECORD LIKE oga_file.*

   IF cl_null(l_oga.oga00) THEN
       RETURN FALSE
   END IF
   IF cl_null(l_oga.oga01) THEN
       RETURN FALSE
   END IF
   IF cl_null(l_oga.oga02) THEN
       RETURN FALSE
   END IF
   IF cl_null(l_oga.oga03) THEN
       RETURN FALSE
   END IF
   IF cl_null(l_oga.oga70) THEN
       RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION aws_create_shipping_orders_without_orders_chk_imp_ogb(l_ogb)
   DEFINE l_ogb RECORD LIKE ogb_file.*

   IF cl_null(l_ogb.ogb04) THEN
       RETURN FALSE
   END IF
   IF cl_null(l_ogb.ogb12) THEN
       RETURN FALSE
   END IF
   IF cl_null(l_ogb.ogb13) THEN
       RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION aws_create_shipping_orders_without_orders_t650_bu(l_oga)
   DEFINE l_oga RECORD LIKE oga_file.*
 
   LET l_oga.oga50 = NULL
   SELECT SUM(ogb14) INTO l_oga.oga50 FROM ogb_file WHERE ogb01 = l_oga.oga01
   IF cl_null(l_oga.oga50) THEN LET l_oga.oga50 = 0 END IF
 
   LET l_oga.oga52 = l_oga.oga50 * l_oga.oga161/100
   LET l_oga.oga53 = l_oga.oga50 * (l_oga.oga162+l_oga.oga163)/100

   UPDATE oga_file SET oga50=l_oga.oga50,
                       oga52=l_oga.oga52,
                       oga53=l_oga.oga53
    WHERE oga01 = l_oga.oga01
   IF SQLCA.sqlcode OR SQLCA.SQLerrd[3] = 0 THEN
       LET g_status.code = SQLCA.sqlcode
   END IF
 
END FUNCTION
