# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abmp631 
# Descriptions...: FAS 產品組合作業
# Date & Author..: 91/12/04 By Lee
# Modify.........: No:7643 03/08/25 By Mandy 新增 aimi100料號時應default ima30= 
# Modify.........: No:8350 03/10/02 By Melody g_ima37 NOT MATCHES '[0-5]' 秀的訊息錯誤
# Modify.........: MOD-470495 04/07/22 By Mandy 1.單身料號依序選取後回主料畫面時,單頭料號顥示異常
# Modify.........:                              2.料號全部選取完成,產生新料號時會出現abm-741的error
# Modify.........: No.MOD-490217 04/09/13 by yiting 料號欄位使用LIKE方式
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-550093 05/06/01 By kim 配方BOM,特性代碼
# Modify.........: No.TQC-630105 06/03/14 By Joe 單身筆數限制
# Modify.........: No.TQC-620111 06/04/07 By pengu 無法產生FAS料號及BOM,
# Modify.........: No.MOD-650015 06/06/13 By douzh cl_err----->cl_err3
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/14 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-680122 06/12/06 By pengu 程式DEFINE錯誤,常導致一些無法預期的異常
# Modify.........: No.CHI-720002 07/02/14 By jamie ima130 接default '1',不該直接使用母件料號的值
# Modify.........: No.MOD-790002 07/09/03 By Joe 程式段INSERT時,增加欄位(PK)預設值
# Modify.........: No.MOD-780061 07/10/17 By pengu INSERT ima_file時ima911欄位未default值
# Modify.........: No.FUN-7B0018 08/03/04 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-830132 08/03/28 By hellen 將imaicd_file變成icd專用
# Modify.........: No.FUN-830116 08/04/18 By jan 增加bmb33賦值
# Modify.........: No.FUN-840194 08/06/24 By sherry 增加變動前置時間批量（ima061）
# Modify.........: No.FUN-910053 09/02/12 By jan INSERT INTO bmb_file 的bmb14 改為  0
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0099 09/11/17 By douzh 加上栏位为空的判断
# Modify.........: No:TQC-980010 09/12/30 By baofei INSERT INTO bmb_file bmb05改為NULL 
# Modify.........: No:FUN-A20044 10/03/19 By vealxu ima26x 調整
# Modify.........: No:FUN-A80150 10/09/20 By sabrina 在insert into ima_file之前，當ima156/ima158為null時要給"N"值
# Modify.........: No.FUN-AA0014 10/10/06 By Nicola 預設ima927
# Modify.........: No.FUN-AA0059 10/10/26 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-AB0025 10/11/10 By vealxu 全系統增加料件管控		
# Modify.........: No.FUN-AB0025 10/11/11 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No:FUN-C20065 12/02/10 By lixh1 在insert into ima_file之前，當ima159為null時要給'3'
# Modify.........: No.TQC-C20131 12/02/13 By zhuhao 在insert into ima_file之前給ima928賦值
# Modify.........: No:FUN-C50036 12/05/21 By yangxf 新增ima160字段，给预设值
# Modify.........: No:MOD-CA0213 12/11/06 By Elise abmp631a多傳一參數
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today
# Modify.........: No.FUN-C40006 13/01/10 By Nina 只要程式有UPDATE bma_file 的任何一個欄位時,多加bmadate=g_today
# Modify.........: No.FUN-C40007 13/01/10 By Nina 只要程式有UPDATE bmb_file 的任何一個欄位時,多加bmbdate=g_today

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_use         LIKE type_file.chr1,        # 判斷該最終規格料件編號是否已存在,(Y/N) #No.FUN-680096 VARCHAR(1)
    g_cpart       LIKE rpc_file.rpc01,        # 品號
    g_FASno       LIKE cbc_file.cbc04,       # 最終規格料件編號 #No.MOD-490217
    g_FASno_new   LIKE cbc_file.cbc04,       # 最終規格料件編號 #No.MOD-490217
    g_bma06    LIKE bma_file.bma06,           # 特性代碼   #No.TQC-680122 modify
    g_date        LIKE type_file.dat,         # 需求日期 #No.FUN-680096  DATE
    g_wc,g_sql    string,  #No.FUN-580092 HCN
    g_ima021      ARRAY[30] of LIKE ima_file.ima021,  #No.FUN-680096 VARCHAR(30)
    g_bmb         DYNAMIC ARRAY OF RECORD     # 單身 program array
        bmb02     LIKE bmb_file.bmb02,        # 順序
        bmb03     LIKE bmb_file.bmb03,        # 元件代號
        ima02     LIKE ima_file.ima02,        # 品名 #MOD-470495
        bmb06     LIKE bmb_file.bmb06,        # 單位組成用量
        bmb10     LIKE bmb_file.bmb10         # 發料單位
       #bmb29     LIKE bmb_file.bmb29         #FUN-550093    #No.TQC-620111 mark
        END RECORD,
    g_bmb_t RECORD                            # 單身上一筆資料
        bmb02     LIKE bmb_file.bmb02,        # 順序
        bmb03     LIKE bmb_file.bmb03,        # 元件代號
        ima02     LIKE ima_file.ima02,        # 品名 #MOD-470495
        bmb06     LIKE bmb_file.bmb06,        # 單位組成用量
        bmb10     LIKE bmb_file.bmb10         # 發料單位
       #bmb29     LIKE bmb_file.bmb29         #FUN-550093  #No.TQC-620111 mark
        END RECORD,
    g_bmb_o RECORD LIKE bmb_file.*,           # 報價產品組合檔其他資料
    g_ima37        LIKE ima_file.ima37,       # OPC
    g_ima63        LIKE ima_file.ima63,       # 發料單位
    g_ima02        LIKE ima_file.ima02,       # 品名
    g_got          LIKE type_file.num5,       # 選擇回來的項目數 #No.FUN-680096 SMALLINT
    l_ac           LIKE type_file.num5,       # 目前處理的ARRAY CNT  #No.FUN-680096 SMALLINT
    l_flag         LIKE type_file.chr1,       #No.FUN-680096 VARCHAR(1)
    g_change_lang  LIKE type_file.chr1,       #是否有做語言切換 #No.FUN-680096 VARCHAR(1)
    l_sl           LIKE type_file.num5,       # 目前處理的SCREEN LINE #No.FUN-680096 SMALLINT
    g_rec_b        LIKE type_file.num5,       #No.FUN-680096 SMALLINT
    g_cbc   RECORD LIKE cbc_file.*
 
DEFINE   g_forupd_sql    STRING                  #SELECT ... FOR UPDATE SQL
DEFINE   g_chr           LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose   #No.FUN-680096 SMALLINT

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT

   LET g_cbc.cbc02=ARG_VAL(1)  #訂單單號
   LET g_cbc.cbc03=ARG_VAL(2)  #項次

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF

   IF s_shut(0) THEN 
      EXIT PROGRAM 
   END IF

   IF g_sma.sma895='1' THEN
      CALL cl_err('','abm-738',1)
      EXIT PROGRAM
   END IF #FAS 產品料號產生方式
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690107
 
   CALL p631_ins_cbc()
   CALL abmp631(0,0)
   LET g_cbc.cbc04=g_FASno_new
 
   IF cl_null(g_cbc.cbc02) THEN 
      DELETE FROM cbc_file WHERE cbc01=g_cbc.cbc01
   ELSE
      UPDATE cbc_file SET cbc04=g_FASno_new
       WHERE cbc01=g_cbc.cbc01
      IF SQLCA.SQLCODE OR STATUS THEN
         CALL cl_err3("upd","cbc_file",g_cbc.cbc01,"",SQLCA.SQLCODE,"","upd cbc: ",0)  # TQC-660046
      END IF
   END IF
 
 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
END MAIN
 
FUNCTION abmp631(p_row,p_col)
DEFINE
    p_row,p_col  LIKE type_file.num5,      # window 位置 #No.FUN-680096 SMALLINT
    l_ima RECORD LIKE ima_file.*
DEFINE l_imaicd  RECORD LIKE imaicd_file.* #No.FUN-7B0018   
 
    LET p_row = 4 LET p_col = 22
 
    OPEN WINDOW p631_w AT p_row,p_col WITH FORM "abm/42f/abmp630" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL cl_set_comp_visible("bma06",g_sma.sma118='Y') #No.TQC-620111
 
WHILE TRUE
    BEGIN WORK
    WHILE TRUE
        CLEAR FORM
        LET g_success='Y'
        LET g_change_lang = FALSE
        CALL p631_i()
        IF g_change_lang = TRUE THEN 
            CONTINUE WHILE
        END IF
        
        IF NOT INT_FLAG THEN
            IF g_use='N' THEN #不存在,則新增一筆資料
               # Prog. Version..: '5.30.06-13.03.12(0,0,g_cpart,'a',g_FASno,g_use,g_date)          #MOD-CA0213 mark 
                CALL p631a(0,0,g_cpart,'a',g_FASno,g_use,g_date,g_bma06)  #MOD-CA0213
                    RETURNING g_got
                IF g_success='N' THEN EXIT WHILE END IF
                #1.BOM單頭
               #No.B474 
               #INSERT INTO bma_file(bma01,bma02,bma03,bma04,
                INSERT INTO bma_file(bma01,bma02,bma03,bma04,bma05,bma06, #FUN-550093
               #No.B474
                    bmauser,bmagrup,bmamodu,bmadate,bmaacti,bmaoriu,bmaorig)
               #    VALUES(g_FASno,'','','',g_user,g_grup,
                    VALUES(g_FASno,'','','',NULL,g_bma06,g_user,g_grup,    #No.TQC-620111 modify
               #No.B474..end             
                    '',TODAY,'Y', g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
               #No.+037 010329 by plum
               #IF STATUS THEN
               #   CALL cl_err('ins bma:',STATUS,1) LET g_success='N' EXIT WHILE
                IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#                  CALL cl_err('ins bma: ',SQLCA.SQLCODE,1) #No.TQC-660046
                   CALL cl_err3("ins","bma_file",g_FASno,"",SQLCA.SQLCODE,"","ins bma: ",1) 
                   LET g_success='N' EXIT WHILE
                END IF
               #No.+037..end
                #2.料件主檔,SC='F'(FAS)
                SELECT * INTO l_ima.*
                	FROM ima_file
                	WHERE ima01=g_cpart
                LET l_ima.ima01=g_FASno
                LET l_ima.ima06='0'
                LET l_ima.ima08='T'
                LET l_ima.ima13=g_cpart
                LET l_ima.ima16=99
#                LET l_ima.ima26=0     #FUN-A20044
#                LET l_ima.ima261=0    #FUN-A20044
#                LET l_ima.ima262=0    #FUN-A20044
                LET l_ima.ima139='N'
                LET l_ima.ima146='0'
                LET l_ima.ima93='Y'
                LET l_ima.ima910=g_bma06 #FUN-550093  #No.TQC-620111 modify
                LET l_ima.ima911 = 'N'       #No.MOD-780061 add
                LET l_ima.ima30=g_today #No:7643
                LET l_ima.ima901=g_today
                LET l_ima.imauser=g_user
                LET l_ima.imagrup=g_grup
                LET l_ima.imamodu=''
                LET l_ima.imaacti='Y'
                LET l_ima.imadate=g_today
                LET l_ima.ima130='1'   #CHI-720002 add
                LET l_ima.ima601=1     #No.FUN-840194
                IF cl_null(l_ima.ima926) THEN LET l_ima.ima926 ='N' END IF                  #No.FUN-9B0099
                IF STATUS THEN
   #                CALL cl_err('sel ima:',STATUS,1)      # TQC-660046  
                    CALL cl_err3("sel","ima_file",g_cpart,"",STATUS,"","sel ima: ",1)  # TQC-660046
                    LET g_success='N' EXIT WHILE
                END IF
                LET l_ima.imaoriu = g_user      #No.FUN-980030 10/01/04
                LET l_ima.imaorig = g_grup      #No.FUN-980030 10/01/04
               #FUN-A80150---add---start---
                IF cl_null(l_ima.ima156) THEN 
                   LET l_ima.ima156 = 'N'
                END IF
                IF cl_null(l_ima.ima158) THEN 
                   LET l_ima.ima158 = 'N'
                END IF
               #FUN-A80150---add---end---
                LET l_ima.ima927='N'   #No:FUN-AA0014
               #FUN-C20065 ----------Begin-----------
                IF cl_null(l_ima.ima159) THEN
                   LET l_ima.ima159 = '3'
                END IF
               #FUN-C20065 ----------End-------------
                IF cl_null(l_ima.ima928) THEN LET l_ima.ima928 = 'N' END IF      #TQC-C20131  add
                IF cl_null(l_ima.ima160) THEN LET l_ima.ima160 = 'N' END IF      #FUN-C50036  add
                INSERT INTO ima_file VALUES (l_ima.*)
               #IF STATUS AND STATUS<>-239 THEN #TQC-790102
                IF STATUS AND NOT cl_sql_dup_value(SQLCA.SQLCODE)  THEN #TQC-790102
   #               CALL cl_err('ins ima:',STATUS,1)         # TQC-660046   
                   CALL cl_err3("ins","ima_file",l_ima.ima01,"",STATUS,"","ins ima: ",1)  # TQC-660046
                   LET g_success='N' EXIT WHILE
                #No.FUN-7B0018 080304 add --begin
                ELSE
#                  IF NOT s_industry('std') THEN    #No.FUN-830132 mark
                   IF s_industry('icd') THEN        #No.FUN-830132 add
                      INITIALIZE l_imaicd.* TO NULL
                      LET l_imaicd.imaicd00 = l_ima.ima01
                      IF NOT s_ins_imaicd(l_imaicd.*,'') THEN
                         LET g_success = 'N'
                         EXIT WHILE
                      END IF
                   END IF
                #No.FUN-7B0018 080304 add --end  
                END IF
            ELSE
               LET g_success='N'   #MOD-CA0213 add
            END IF
        END IF
       #IF g_success='N' THEN EXIT WHILE END IF               #MOD-CA0213 mark
        IF INT_FLAG THEN LET g_success='N' EXIT WHILE END IF  #MOD-CA0213
        CALL p631_b_fill('1=1')
        LET g_FASno_new=p631_get_cbb()     # 取得FAS part no
        IF cl_null(g_FASno_new)   #無法組合新料號
           THEN
           CALL cl_err('','abm-741',1)
           LET g_success='N'
           EXIT WHILE
        END IF
        CALL p631_upd_FASno()
        DISPLAY g_FASno_new TO g_FASno ATTRIBUTES(REVERSE)
        LET g_FASno=g_FASno_new
        CALL p631_b()
        IF INT_FLAG THEN LET g_success='N' EXIT WHILE END IF
        EXIT WHILE
    END WHILE
    IF INT_FLAG THEN EXIT WHILE END IF
    IF g_success = 'Y' THEN
       COMMIT WORK
       CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
    ELSE
       ROLLBACK WORK
       CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
    END IF
    IF l_flag THEN
       CLEAR FORM
       CONTINUE WHILE
    ELSE
       EXIT WHILE
    END IF
END WHILE
    LET INT_FLAG=0
    CLOSE WINDOW p631_w
END FUNCTION
 
FUNCTION p631_i()
   DEFINE   l_ima   RECORD LIKE ima_file.*
 
#  LET g_use='Y'
   LET g_use='N'

# 給FAS default 料號
#  #SET ISOLATION TO DIRTY READ
#   SELECT MAX(cbc01)+1 INTO g_cbc.cbc01 FROM cbc_file
#  #SET ISOLATION TO COMMITTED READ
#   IF cl_null(g_cbc.cbc01) OR g_cbc.cbc01=0 THEN
#      LET g_cbc.cbc01=1 USING "&&&&&&&&&&&&&&&&&&&&"
#   ELSE
#      LET g_cbc.cbc01=g_cbc.cbc01 USING "&&&&&&&&&&&&&&&&&&&&"
#   END IF
#   LET g_cbc.cbc04=''
#   INSERT INTO cbc_file VALUES(g_cbc.*)

   LET g_FASno=g_cbc.cbc01 USING "&&&&&&&&&&&&&&&&&&&&"
   LET g_date=TODAY
   LET g_cpart=NULL
   LET g_bma06= ' '     #No.TQC-620111
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
   INPUT BY NAME g_cpart,g_bma06,g_date WITHOUT DEFAULTS    #No.TQC-620111 add
 
      AFTER FIELD g_cpart
         IF g_cpart IS NULL THEN
            NEXT FIELD g_cpart 
         END IF
         #FUN-AB0025 --------------add start-----------
         IF NOT s_chk_item_no(g_cpart,'') THEN
            CALL cl_err('',g_errno,1)
            NEXT FIELD g_cpart
         END IF
         #FUN-AB0025 --------------add end--------------
         SELECT * INTO l_ima.* FROM ima_file WHERE ima01=g_cpart
         IF STATUS THEN
#           CALL cl_err('sel ima:',STATUS,0) #No.TQC-660046
            CALL cl_err3("sel","ima_file",g_cpart,"",STATUS,"","sel ima:",0)  # TQC-660046
            NEXT FIELD g_cpart
         END IF
         IF l_ima.ima08<>'C' THEN
            CALL cl_err('sel ima:','ams-509',0)
            NEXT FIELD g_cpart
         END IF
         DISPLAY BY NAME l_ima.ima02
       #------------No.TQC-620111 add
        AFTER FIELD g_bma06
           IF cl_null(g_bma06) THEN
              LET g_bma06 = ' '
           END IF
       #------------No.TQC-620111 end
{
      AFTER FIELD g_FASno
         IF g_FASno IS NULL THEN
            LET g_use='N'
#           NEXT FIELD g_FASno
         END IF
         SELECT ima01 FROM ima_file WHERE ima01=g_FASno
         IF SQLCA.sqlcode THEN
            LET g_use='N'
         ELSE
            EXIT INPUT
         END IF 
}
      AFTER FIELD g_date
         IF g_date IS NULL THEN
            NEXT FIELD g_date
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            LET g_success='N'
            RETURN 
         END IF
       #------------No.TQC-620111 add
           IF cl_null(g_bma06) THEN
              LET g_bma06 = ' '
           END IF
       #------------No.TQC-620111 end
 
        ON ACTION controlp                  
           CASE 
              WHEN INFIELD(g_cpart) 
#FUN-AA0059 --Begin--
               #  CALL cl_init_qry_var()
               #  LET g_qryparam.form ="q_ima"
               #  LET g_qryparam.default1 = g_cpart 
               #  LET g_qryparam.where = " ima08 = 'C' "
               #  CALL cl_create_qry() RETURNING g_cpart 
                 CALL q_sel_ima(FALSE, "q_ima", "ima08 = 'C'",g_cpart, "", "", "", "" ,"",'' )  RETURNING g_cpart
#FUN-AA0059 --End--
#                 CALL FGL_DIALOG_SETBUFFER( g_cpart )
                 DISPLAY g_cpart TO g_cpart
                 NEXT FIELD g_cpart
           END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          LET g_change_lang = TRUE
          EXIT INPUT
      ON ACTION exit                            #加離開功能
          LET INT_FLAG = 1
          EXIT INPUT
   END INPUT
 
   IF STATUS THEN 
      CALL cl_err('input:',STATUS,1)
   END IF
   IF INT_FLAG THEN
      LET g_success='N' 
   END IF
END FUNCTION
 
FUNCTION p631_b()
DEFINE
    l_modify_flag   LIKE type_file.chr1,   # 單身更改否        #No.FUN-680096 VARCHAR(1)
    l_lock_sw       LIKE type_file.chr1,   # 單身鎖住否        #No.FUN-680096 VARCHAR(1)
    l_n             LIKE type_file.num5,   # 檢查重複用        #No.FUN-680096 SMALLINT
    l_ac_t          LIKE type_file.num5,   # 未取消的ARRAY CNT     #No.FUN-680096 SMALLINT
    l_jump          LIKE type_file.num5,   # 測試是否跳過after row #No.FUN-680096 SMALLINT
    l_exit_sw       LIKE type_file.chr1,   # Esc結束INPUT ARRAY 否 #No.FUN-680096 VARCHAR(1)
#   l_bmb19_t       LIKE bmb_file.bmb19,   #金額
    l_bmb02         LIKE bmb_file.bmb02,   #序號
    l_insert        LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
    l_update        LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
    l_chr           LIKE type_file.chr1    #No.FUN-680096 VARCHAR(1)
DEFINE l_bmb05      LIKE bmb_file.bmb05    #TQC-980010  
 
    LET l_insert='Y'
    LET l_update='Y'
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT * FROM bmb_file ",
                        "  WHERE bmb01 = ? ",     # 單號
                          " AND bmb02 = ? ",     # 序號
                          " FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p631_b_curl CURSOR FROM g_forupd_sql            # LOCK CURSOR
 
    LET l_ac_t = 0
    WHILE TRUE
        LET l_exit_sw = "y"                      # 正常結束,除非 ^N
 
        INPUT ARRAY g_bmb WITHOUT DEFAULTS FROM s_bmb.*
                          # TQC-630105 ----start add by Joe 
                          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec)
                          # TQC-630105 ----end add by Joe 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET g_bmb_t.* = g_bmb[l_ac].*           # BACKUP
            IF l_ac < l_ac_t THEN
                let l_jump = 1
                NEXT FIELD ma02                   # 跳下一ROW
            ELSE
                LET l_ac_t = 0
                let l_jump = 0
            END IF
            LET l_modify_flag = 'N'               # DEFAULT
            LET l_lock_sw = 'N'                   # DEFAULT
            LET l_sl = SCR_LINE()
            LET l_n  = ARR_COUNT()
            IF g_bmb_t.bmb03 IS NOT NULL THEN
 
                LET p_cmd='u'
                OPEN p631_b_curl USING g_FASno, g_bmb_t.bmb02 
                IF STATUS THEN
                   CALL cl_err("OPEN p631_b_curl:", STATUS, 1)
                   CLOSE p631_b_curl
                   ROLLBACK WORK
                   RETURN
                END IF
 
                FETCH p631_b_curl INTO g_bmb_o.* 
                IF STATUS THEN
                    CALL cl_err(g_bmb_t.bmb03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                ELSE
                    LET g_bmb[l_ac].bmb02=g_bmb_o.bmb02
                    LET g_bmb[l_ac].bmb03=g_bmb_o.bmb03
                    LET g_bmb[l_ac].bmb06=g_bmb_o.bmb06
                    LET g_bmb[l_ac].bmb10=g_bmb_o.bmb10
                    LET g_bmb[l_ac].ima02=NULL
                END IF
            ELSE
                LET p_cmd='a'  #輸入新資料
                CALL p631_init()
#               LET l_bmb19_t=0
                INITIALIZE g_bmb[l_ac].* TO NULL      # 900423
            END IF
            IF l_ac <= l_n then                   # DISPLAY NEWEST
                CALL p631_bmb02(' ')
                DISPLAY g_bmb[l_ac].* TO s_bmb[l_sl].*
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
#           NEXT FIELD bmb02
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bmb[l_ac].* TO NULL      # 900423
            LET g_bmb_t.* = g_bmb[l_ac].*         # 新輸入資料
            CALL p631_init()
#           LET l_bmb19_t=0
            DISPLAY g_bmb[l_ac].* TO s_bmb[l_sl].* # DISPLAY dgeeault
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bmb02
 
        BEFORE FIELD bmb02                        # dgeeault 序號
            IF g_bmb[l_ac].bmb02 IS NULL or g_bmb[l_ac].bmb02 = 0 THEN
                SELECT max(bmb02) INTO g_bmb[l_ac].bmb02 FROM bmb_file
                    WHERE bmb01 = g_FASno
                IF g_bmb[l_ac].bmb02 IS NULL THEN
                    LET g_bmb[l_ac].bmb02 = 0
                END IF
                LET g_bmb[l_ac].bmb02 = g_bmb[l_ac].bmb02 + g_sma.sma19
                DISPLAY g_bmb[l_ac].bmb02 TO s_bmb[l_sl].bmb02
            END IF
 
        AFTER FIELD bmb02                         # check 序號是否重複
            IF g_bmb[l_ac].bmb02 IS NULL THEN
                NEXT FIELD bmb02
            END IF
            IF g_bmb[l_ac].bmb02 != g_bmb_t.bmb02 OR g_bmb_t.bmb02 IS NULL THEN
                SELECT count(*) INTO l_n FROM bmb_file
                    WHERE bmb01 = g_FASno AND
                          bmb02 = g_bmb[l_ac].bmb02
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_bmb[l_ac].bmb02 = g_bmb_t.bmb02
                   DISPLAY g_bmb[l_ac].bmb02 TO s_bmb[l_sl].bmb02
                   NEXT FIELD bmb02
                END IF
             END IF
 
        BEFORE FIELD bmb03
            LET l_modify_flag = 'Y'
            IF (g_bmb_t.bmb03 IS NOT NULL AND l_update='N')       #無更改權限
                OR (g_bmb_t.bmb03 IS NULL AND l_insert='N') THEN  #無輸入權限
                LET l_modify_flag = 'N'
            END IF
            IF (l_lock_sw = 'Y') THEN            # 已鎖住
                LET l_modify_flag = 'N'
            END IF
#           IF (g_gka.gkaupsw = 'Y' ) THEN           # 已確認
#               LET l_modify_flag = 'N'
#               CALL cl_err("","9022",0)
#           END IF
#           IF (g_gka.gkavosw = 'Y') THEN            # 已作廢
#               LET l_modify_flag = 'N'
#               CALL cl_err("",9004,0)
#           END IF
            IF (l_modify_flag = 'N') THEN
                LET g_bmb[l_ac].bmb03 = g_bmb_t.bmb03
                DISPLAY g_bmb[l_ac].bmb03 TO s_bmb[l_sl].bmb03
                NEXT FIELD bmb03
            END IF
 
        AFTER FIELD bmb03  #品號
            IF g_bmb[l_ac].bmb03 IS NULL THEN
                NEXT FIELD bmb03
            END IF
                CALL p631_bmb02('a')
                IF g_chr = 'E' THEN                  # 無此品號
                    CALL cl_err('I/M',"ams-004",0)
                    LET g_bmb[l_ac].bmb03 = g_bmb_t.bmb03
                    NEXT FIELD bmb03
                END IF
                IF g_ima37 NOT MATCHES '[0-4]' THEN #OPC
                   #CALL cl_err(g_ima37,"ams-004",0)
                    CALL cl_err(g_ima37,"mfg1003",0)   #No:8350
                    NEXT FIELD bmb03
                END IF
                LET g_bmb[l_ac].bmb10=g_ima63
                DISPLAY g_bmb[l_ac].bmb10 TO s_bmb[l_sl].bmb10
 
        BEFORE DELETE                            # 是否取消單身
            IF g_bmb_t.bmb02 > 0 OR g_bmb_t.bmb02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
#                    LET l_exit_sw = "n"
#                    LET l_ac_t = l_ac
#                    EXIT INPUT
                     CANCEL DELETE
                END IF
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM bmb_file
                WHERE bmb01= g_FASno AND  #主件
                      bmb02= g_bmb_t.bmb02 #序號
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_bmb_t.bmb02,SQLCA.sqlcode,0) #No.TQC-660046
                CALL cl_err3("del","bmb_file",g_FASno,g_bmb_t.bmb02,SQLCA.sqlcode,"","",0)  # TQC-660046
                LET l_exit_sw = "n"
                LET l_ac_t = l_ac
                EXIT INPUT
            END IF
#           CALL p631_uh(g_bmb[l_ac].bmb19,0)
            INITIALIZE g_bmb[l_ac].* TO NULL
            IF l_ac = l_n THEN
                CALL SET_COUNT(l_ac-1)
            END IF
 
        AFTER ROW
            if not l_jump then
                DISPLAY g_bmb[l_ac].* TO s_bmb[l_sl].*
                IF INT_FLAG THEN                 # 900423
                    CALL cl_err('',9001,0)
                    LET INT_FLAG = 0
                    LET g_bmb[l_ac].* = g_bmb_t.*
#                   CALL p631_uh(l_bmb19_t,g_bmb[l_ac].bmb19)
                    DISPLAY g_bmb[l_ac].* TO s_bmb[l_sl].*
                    EXIT INPUT
                END IF
                IF g_bmb[l_ac].bmb03 IS NULL THEN  # 重要欄位空白,無效
                    INITIALIZE g_bmb[l_ac].* TO NULL
                    DISPLAY g_bmb[l_ac].* TO s_bmb[l_sl].*
                END IF
                #MOD-790002.................begin
                IF cl_null(g_bmb[l_ac].bmb02)  THEN
                   LET g_bmb[l_ac].bmb02=' '
                END IF
                #MOD-790002.................end
                LET l_bmb05 = NULL    #TQC-980010 
                IF g_bmb[l_ac].bmb02 > 0 AND g_bmb[l_ac].bmb03 IS NOT NULL THEN
                    IF g_bmb_t.bmb03 IS NULL THEN  # 單身新增
                        INSERT INTO bmb_file(bmb01,bmb02,bmb03,bmb04,bmb05,
                            bmb06,bmb07,bmb08,bmb09,bmb10,bmb10_fac,
                            bmb10_fac2,bmb11,bmb13,
                            bmb14,bmb15,bmb16,bmb17,bmb18,bmb19,bmb20,
#                           bmb21,bmb22,bmb23)
                            # No.+114
                            bmb21,bmb22,bmb23,bmb28,bmb29,bmb33,bmb081,bmb082) #FUN-550093#No.FUN-830116  #MOD-CA0213 add bmb081,bmb082
                        #           1                 2                 3
                        VALUES(g_FASno,g_bmb[l_ac].bmb02,g_bmb[l_ac].bmb03,
                        #        4  5                 6  7
              #           '01/01/01','',g_bmb[l_ac].bmb06,1,  #TQC-980010 
                         '01/01/01',l_bmb05,g_bmb[l_ac].bmb06,1,           #TQC-980010  
                        #8,9,               10,f0,f1,11,13
                         0,0,g_bmb[l_ac].bmb10, 1, 1,'','',
                        #14, 15, 16, 17,18,19,                20, 21 ,22,23
#                        '1','1','1','1',0,'N',g_bmb[l_ac].bmb02,'N','N',0)
                        # No.+114
#                        '1','1','1','1',0,'N',g_bmb[l_ac].bmb02,'N','N',0,0,g_bma06,0) #FUN-550093   #No.TQC-620111 modify #No.FUN-830116 #FUN-910053 mark
                         '0','1','1','1',0,'N',g_bmb[l_ac].bmb02,'N','N',0,0,g_bma06,0,0,1) #FUN-910053  #MOD-CA0213 add 0,1
                        IF SQLCA.sqlcode THEN
#                           CALL cl_err(g_bmb[l_ac].bmb03,SQLCA.sqlcode,0) #No.TQC-660046
                            CALL cl_err3("ins","bmb_file",g_FASno,g_bmb[l_ac].bmb02,SQLCA.sqlcode,"","",0)  # TQC-660046
                            LET g_bmb[l_ac].* = g_bmb_t.*
                            DISPLAY g_bmb[l_ac].* TO s_bmb[l_sl].*
                        ELSE
                            MESSAGE 'INSERT ok'
                            CALL ui.Interface.refresh()
                        END IF
                    END IF
                END IF
                IF g_bmb[l_ac].bmb02 > 0 AND g_bmb[l_ac].bmb03 IS NOT NULL THEN
                    IF g_bmb_t.bmb03 IS NOT NULL AND
                        (l_modify_flag = 'Y' OR
                          g_bmb[l_ac].bmb03 != g_bmb_t.bmb03) THEN
 
                        UPDATE bmb_file
                           SET bmb02 = g_bmb[l_ac].bmb02,
                               bmb03 = g_bmb[l_ac].bmb03,
                               bmb06 = g_bmb[l_ac].bmb06,
                               bmb10 = g_bmb[l_ac].bmb10,
                               bmbdate=g_today     #FUN-C40007 add
                         WHERE CURRENT OF p631_b_curl
 
                        IF SQLCA.sqlcode THEN
 #                          CALL cl_err(g_bmb[l_ac].bmb02,SQLCA.sqlcode,0) #No.TQC-660046
                            CALL cl_err3("upd","bmb_file",g_bmb_t.bmb02,g_bmb_t.bmb03,SQLCA.sqlcode,"","",0)  # TQC-660046
                            LET g_bmb[l_ac].* = g_bmb_t.*
                            DISPLAY g_bmb[l_ac].* TO s_bmb[l_sl].*
                        ELSE
                            MESSAGE 'update OK'
                            CALL ui.Interface.refresh()
                        END IF
                    END IF
                END IF
                LET g_bmb_t.* = g_bmb[l_ac].*          # 900423
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION re_fas_combine
                 # Prog. Version..: '5.30.06-13.03.12(0,0,g_cpart,'u',g_FASno,'Y',g_date)          #MOD-CA0213 mark   
                  CALL p631a(0,0,g_cpart,'u',g_FASno,'Y',g_date,g_bma06)  #MOD-CA0213
                      RETURNING g_got
                  IF g_got > 0 THEN
                     LET l_exit_sw = 'n'
                     LET l_ac_t = l_ac
                     CALL p631_b_fill('1=1')
                     EXIT INPUT
                  END IF
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(bmb03) #品號
#                 CALL q_ima(3,3,g_bmb[l_ac].bmb03) RETURNING g_bmb[l_ac].bmb03
#                 CALL FGL_DIALOG_SETBUFFER( g_bmb[l_ac].bmb03 )
#FUN-AB0025 ------------------Begin--------------------
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.form = 'q_ima'
               #   LET g_qryparam.default1 = g_bmb[l_ac].bmb03
               #   CALL cl_create_qry() RETURNING g_bmb[l_ac].bmb03
                   CALL q_sel_ima(FALSE, "q_ima", "", g_bmb[l_ac].bmb03, "", "", "", "" ,"",'' )  RETURNING g_bmb[l_ac].bmb03
#FUN-AB0025 ------------------End----------------------
#                  CALL FGL_DIALOG_SETBUFFER( g_bmb[l_ac].bmb03 )
                   DISPLAY g_bmb[l_ac].bmb03 TO bmb03           #No.MOD-490371
                  NEXT FIELD bmb03
            END CASE
 
        ON ACTION CONTROLN
            CALL p631_b_askkey()
            LET l_exit_sw = "n"
            EXIT INPUT
 
        ON ACTION CONTROLO                        # 沿用欄位
            IF l_ac > 1 THEN 
                CASE 
                    WHEN infield(bmb02)
                        let l_bmb02 = g_bmb[l_ac].bmb02
                        LET g_bmb[l_ac].* = g_bmb[l_ac-1].*
                        let g_bmb[l_ac].bmb02 = l_bmb02
                       #DISPLAY g_bmb[l_ac].* TO s_bmb[l_sl].*
                        NEXT FIELD bmb02
                    WHEN INFIELD(bmb03)
                        let g_bmb[l_ac].bmb03 = g_bmb[l_ac-1].bmb03
                         DISPLAY g_bmb[l_ac].bmb03 TO bmb03           #No.MOD-490371
                        NEXT FIELD bmb03
                    WHEN INFIELD(bmb06)
                        let g_bmb[l_ac].bmb06 = g_bmb[l_ac-1].bmb06
                         DISPLAY g_bmb[l_ac].bmb06 TO bmb06            #No.MOD-490371
                        NEXT FIELD bmb06
                    WHEN INFIELD(bmb10)
                        let g_bmb[l_ac].bmb10 = g_bmb[l_ac-1].bmb10
                         DISPLAY g_bmb[l_ac].bmb10 TO bmb10           #No.MOD-490371
                        NEXT FIELD bmb10
                END CASE
            END IF
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                       #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033       
 
        END INPUT
        IF INT_FLAG THEN LET g_success='N' RETURN END IF
        IF l_exit_sw = "y" THEN
            EXIT WHILE                           # ESC 或 DEL 結束 INPUT
        END IF
        CONTINUE WHILE                       # ^N 結束 INPUT
    END WHILE
 
    CLOSE p631_b_curl
END FUNCTION
 
FUNCTION  p631_bmb02(p_cmd)
DEFINE
    p_cmd     LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
    l_ima02   LIKE ima_file.ima02,
    l_imaacti LIKE ima_file.imaacti
 
    LET g_chr = ' '
    SELECT ima02,ima37,ima63,imaacti
        INTO g_bmb[l_ac].ima02,g_ima37,g_ima63,l_imaacti
        FROM ima_file
        WHERE ima01 = g_bmb[l_ac].bmb03
    IF SQLCA.sqlcode THEN
        LET g_chr = 'E'
        LET g_bmb[l_ac].ima02=NULL
    ELSE
        IF l_imaacti='N' THEN
            LET g_chr='E'
        END IF
    END IF
    IF p_cmd = 'a' THEN
         DISPLAY g_bmb[l_ac].ima02 TO ima02          #No.MOD-490371
    END IF
END FUNCTION
 
FUNCTION p631_b_askkey()
    DEFINE
        l_wc   LIKE type_file.chr1000  #No.FUN-680096  VARCHAR(200)
 
   CLEAR FORM
   CALL g_bmb.clear()
   CONSTRUCT l_wc ON bmb02,bmb03,bmb06,bmb10
        FROM s_bmb[1].bmb02,s_bmb[1].bmb03,s_bmb[1].bmb06,
             s_bmb[1].bmb10
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
   END CONSTRUCT
   LET l_wc = l_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL p631_b_fill(l_wc)
END FUNCTION
 
FUNCTION p631_b_fill(p_wc)                   # BODY FILL UP
    DEFINE
        l_ac   LIKE type_file.num5,         #No.FUN-680096 SMALLINT
        p_wc   LIKE type_file.chr1000       #No.FUN-680096 VARCHAR(200)
 
    LET g_sql =
         "SELECT bmb02,bmb03,ima02,bmb06,bmb10,ima021", #MOD-470495
        " FROM bmb_file, OUTER ima_file",
        " WHERE bmb01 ='",g_FASno,"'", #料件編號
        " AND (bmb04 <='",g_date,                   #bugno:6595
        "' OR bmb04 IS NULL) AND (bmb05 >'",g_date,
        "' OR bmb05 IS NULL)",
        " AND ima_file.ima01=bmb_file.bmb03",#BUG-470495 #品號
        " AND ",p_wc CLIPPED,
         " ORDER BY bmb02" #MOD-470495
 
    PREPARE p631_pb FROM g_sql
    DECLARE p631_b_curs                       #CURSOR
        CURSOR FOR p631_pb
     CALL g_bmb.clear() #MOD-470495
    #LET l_ac = 1  
    #FOREACH p631_b_curs INTO g_bmb[l_ac].*,g_ima021[l_ac]     # 單身 ARRAY 填充
    # TQC-630105 ----start add by Joe
    LET g_cnt = 1
    FOREACH p631_b_curs INTO g_bmb[g_cnt].*,g_ima021[g_cnt]   
    # TQC-630105 ----end add by Joe
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOReach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        #LET l_ac = l_ac + 1  # TQC-630105 ----add by Joe
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    #LET g_rec_b=l_ac-1
    #CALL SET_COUNT(l_ac - 1)                     # 告訴I.單身筆數
    # TQC-630105 ----start add by Joe
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt - 1)                     # 告訴I.單身筆數
    # TQC-630105 ----end add by Joe
END FUNCTION
 
#當輸入新資料時, 作資料的預設處理
FUNCTION p631_init()
    LET g_bmb[l_ac].bmb06 = 0.0   #組成用量
    INITIALIZE g_bmb_o.* TO NULL
    LET g_bmb_o.bmb21='N'         #元件代號是否列印在文件上
    LET g_bmb_o.bmb22='N'         #元件價格是否列印在文件上
    LET g_bmb_o.bmb19='N'         #元件價格是否列印在文件上
    LET g_bmb_o.bmb07=1.0         #原料成本
    LET g_bmb_o.bmb09=0.0         #人工成本
    LET g_bmb_o.bmb10_fac=1.0         #製造費用
    LET g_bmb_o.bmb10_fac2=1.0         #製造費用
    LET g_bmb_o.bmb18=0.0         #本幣原始單價
    LET g_bmb_o.bmb20=0.0         #折扣率
END FUNCTION
 
{
FUNCTION p631_uh(l_bmb19,p_bmb19)
    DEFINE
        l_bmb19      LIKE bmb_file.bmb19,  #舊的值
        p_bmb19      LIKE bmb_file.bmb19   #新的值
 
    IF l_bmb19 IS NULL THEN LET l_bmb19 = 0 END IF
    IF p_bmb19 IS NULL THEN LET p_bmb19 = 0 END IF
    IF g_price IS NULL THEN LET g_price = 0 END IF
    LET g_price = g_price + p_bmb19 - l_bmb19
   DISPLAY 'Price=(',g_price USING '####&.&&&', ')' AT 1,60 
        
END FUNCTION
}
 
FUNCTION p631_get_cbb()
 DEFINE l_FASno LIKE cbc_file.cbc04, #No.MOD-490217
       l_cba RECORD LIKE cba_file.*,
       l_cbb RECORD LIKE cbb_file.*,
       l_b ARRAY[20] OF LIKE type_file.num5,    #No.FUN-680096 SMALLINT
       l_cbbcon like cbb_file.cbbcon,
       l_cbb01  like cbb_file.cbb01, 
       l_cbb02  like cbb_file.cbb02, 
       l_cbb03  like cbb_file.cbb03, 
       l_cbb04  like cbb_file.cbb04, 
       l_i LIKE type_file.num5,          #No.FUN-680096 SMALLINT
       l_j LIKE type_file.num5,          #No.FUN-680096 SMALLINT
       l_m LIKE type_file.num5,          #No.FUN-680096 SMALLINT
       l_n LIKE type_file.num5,          #No.FUN-680096 SMALLINT
       l_found LIKE type_file.num5,      #No.FUN-680096 SMALLINT
       l_count LIKE type_file.num5       #No.FUN-680096 SMALLINT
   LET l_FASno = NULL
# get 編碼原則(段數,位數) -------
   SELECT * INTO l_cba.* FROM cba_file
    WHERE cbacon=g_cpart
   IF STATUS THEN 
#     CALL cl_err('sel cba_file',STATUS,1) #No.TQC-660046
      CALL cl_err3("sel","cba_file",g_cpart,"",STATUS,"","sel cba_file",1)  # TQC-660046
      LET g_success = 'N'
      LET l_FASno = NULL
      RETURN l_FASno
   END IF
 
# 各段之起始位置 ---
   LET l_b[1]=1
   LET l_b[2]=l_b[1]+l_cba.cba01
   LET l_b[3]=l_b[2]+l_cba.cba02
   LET l_b[4]=l_b[3]+l_cba.cba03
   LET l_b[5]=l_b[4]+l_cba.cba04
   LET l_b[6]=l_b[5]+l_cba.cba05
   LET l_b[7]=l_b[6]+l_cba.cba06
   LET l_b[8]=l_b[7]+l_cba.cba07
   LET l_b[9]=l_b[8]+l_cba.cba08
   LET l_b[10]=l_b[9]+l_cba.cba09
   LET l_b[11]=l_b[10]+l_cba.cba10
   LET l_b[12]=l_b[11]+l_cba.cba11
   LET l_b[13]=l_b[12]+l_cba.cba12
   LET l_b[14]=l_b[13]+l_cba.cba13
   LET l_b[15]=l_b[14]+l_cba.cba14
   LET l_b[16]=l_b[15]+l_cba.cba15
   LET l_b[17]=l_b[16]+l_cba.cba16
   LET l_b[18]=l_b[17]+l_cba.cba17
   LET l_b[19]=l_b[18]+l_cba.cba18
   LET l_b[20]=l_b[19]+l_cba.cba19
 
# define cursor by same group form 碼別資料----------
   DECLARE p631_cbb_cnt CURSOR WITH HOLD FOR 
   SELECT cbbcon,cbb01,cbb02,cbb03,cbb04,count(*) FROM cbb_file
    WHERE cbbcon=g_cpart
      AND cbb03<>'ALL'
  #GROUP BY 1,2,3,4,5
    GROUP BY cbbcon,cbb01,cbb02,cbb03,cbb04 #MOD-470495
 
   LET l_FASno=' '
 
# get 碼別資料 by group -----
   FOREACH p631_cbb_cnt INTO l_cbbcon,l_cbb01,l_cbb02,l_cbb03,l_cbb04,l_count
 
      DECLARE p631_cbb_cur CURSOR FOR SELECT * FROM cbb_file
       WHERE cbbcon=g_cpart
         AND cbb01=l_cbb01
         AND cbb02=l_cbb02
         AND cbb03=l_cbb03
         AND cbb04=l_cbb04
      IF STATUS THEN 
         CALL cl_err('declare cur',STATUS,1)
         LET g_success = 'N'
         LET l_FASno = NULL
         RETURN l_FASno
      END IF
 
      LET l_found=0
 
      FOREACH p631_cbb_cur INTO l_cbb.*
          FOR g_i=1 TO g_rec_b
              IF g_bmb[g_i].bmb03=l_cbb.cbb05
              THEN
                 LET l_found=l_found+1
                 EXIT FOR
              END IF
          END FOR
      END FOREACH
      IF STATUS THEN 
         CALL cl_err('foreach',STATUS,1)
         LET g_success = 'N'
         LET l_FASno = NULL
         RETURN l_FASno
      END IF
 
# 依該特性料件下之元件個數若等於 
# 所挑選料件中符合該特性料件各數者
      IF l_found=l_count
         THEN
         LET l_m=l_cbb.cbb01
         LET l_i=l_b[l_m]
         LET l_j=l_b[l_m]+l_cbb.cbb02-1
         LET l_FASno[l_i,l_j]=l_cbb.cbb04 CLIPPED
      END IF
   END FOREACH
 
# for cbb30 (feature part) = 'ALL' -------
   DECLARE p631_cbb_cur2 CURSOR WITH HOLD FOR SELECT * FROM cbb_file
    WHERE cbbcon=g_cpart
      AND cbb03='ALL'
   IF status THEN 
      CALL cl_err('declare cur',STATUS,1)
      LET g_success = 'N'
      LET l_FASno = NULL
      RETURN l_FASno
   END IF
 
   FOREACH p631_cbb_cur2 INTO l_cbb.*
       LET l_m=l_cbb.cbb01
       LET l_i=l_b[l_m]
       LET l_j=l_b[l_m]+l_cbb.cbb02-1
       LET l_FASno[l_i,l_j]=l_cbb.cbb04 CLIPPED
  END FOREACH
  IF status THEN 
     CALL cl_err('foreach',STATUS,1)
     LET g_success = 'N'
     LET l_FASno = NULL
     RETURN l_FASno
  END IF
   
   RETURN l_FASno
 
END FUNCTION
 
FUNCTION p631_upd_FASno()
DEFINE l_i      LIKE type_file.num5,          #No.FUN-680096 SMALLINT
       l_ima021 LIKE ima_file.ima021
 
   UPDATE bma_file SET bma01=g_FASno_new,
                       bmadate=g_today     #FUN-C40006 add
    WHERE bma01=g_FASno
  #No.+037 010329 by plum
  #IF STATUS THEN LET g_success='N' END IF
   IF SQLCA.SQLCODE OR STATUS THEN
#     CALL cl_err('UPDATE bma_file:',sqlca.sqlcode,0) #MOD-470495 #No.TQC-660046
      CALL cl_err3("upd","bma_file",g_FASno,"",sqlca.sqlcode,"","UPDATE bma_file:",0)  # TQC-660046
      LET g_success='N'
      RETURN
   END IF
  #No.+037..end
 
   UPDATE bmb_file SET bmb01=g_FASno_new,
                       bmbdate=g_today     #FUN-C40007 add
    WHERE bmb01=g_FASno
  #No.+037 010329 by plum
  #IF STATUS THEN LET g_success='N' END IF
   IF SQLCA.SQLCODE OR STATUS THEN
#      CALL cl_err('UPDATE bmb_file:',sqlca.sqlcode,0) #MOD-470495 #No.TQC-660046
       CALL cl_err3("upd","bmb_file",g_FASno,"",sqlca.sqlcode,"","UPDATE bmb_file:",0)  # TQC-660046
      LET g_success='N'
      RETURN
   END IF
  #No.+037..end
 
## 組合 新料件的 desc (ima021)
   IF g_rec_b > 0 
      THEN
      LET l_ima021=''
      FOR l_i = 1 TO g_rec_b
          IF l_i = 1 
             THEN
             LET l_ima021 = g_ima021[l_i] CLIPPED
          ELSE
             LET l_ima021 = l_ima021 CLIPPED,'/',g_ima021[l_i] CLIPPED
          END IF
      END FOR
   END IF
 
   UPDATE ima_file SET ima01=g_FASno_new,ima021=l_ima021,
                       imadate = g_today     #FUN-C30315 add
    WHERE ima01=g_FASno
  #No.+037 010329 by plum
  #IF STATUS THEN LET g_success='N' END IF
   IF SQLCA.SQLCODE OR STATUS THEN
#     CALL cl_err('UPDATE ima_file:',sqlca.sqlcode,0) #MOD-470495 #No.TQC-660046
      CALL cl_err3("upd","ima_file",g_FASno,"",sqlca.sqlcode,"","UPDATE ima_file:",0)  # TQC-660046
      LET g_success='N'
      RETURN
   END IF
  #No.+037..end
 
   UPDATE rpi_file SET rpi01=g_FASno_new
    WHERE rpi01=g_FASno
  #No.+037 010329 by plum
  #IF STATUS THEN LET g_success='N' END IF
   IF SQLCA.SQLCODE OR STATUS THEN
#      CALL cl_err('UPDATE rpi01:',sqlca.sqlcode,0) #MOD-470495 #No.TQC-660046
       CALL cl_err3("upd","rpi_file",g_FASno,"",sqlca.sqlcode,"","UPDATE rpi01:",0)  # TQC-660046
      LET g_success='N'
      RETURN
   END IF
  #No.+037..end
 
   UPDATE rpi_file SET rpi04=g_FASno_new
    WHERE rpi04=g_FASno
  #No.+037 010329 by plum
  #IF STATUS THEN LET g_success='N' END IF
   IF SQLCA.SQLCODE OR STATUS THEN
#        CALL cl_err('UPDATE rpi04:',sqlca.sqlcode,0) #MOD-470495 #No.TQC-660046
         CALL cl_err3("upd","rpi_file",g_FASno,"",sqlca.sqlcode,"","UPDATE rpi04:",0)  # TQC-660046
      LET g_success='N'
      RETURN
   END IF
  #No.+037..end
 
END FUNCTION
 
FUNCTION p631_ins_cbc()
# 給FAS default 料號
    #SET ISOLATION TO DIRTY READ
    SELECT MAX(cbc01)+1 INTO g_cbc.cbc01 
      FROM cbc_file
    #SET ISOLATION TO COMMITTED READ

    IF cl_null(g_cbc.cbc01) OR g_cbc.cbc01=0 THEN
       LET g_cbc.cbc01=1 USING "&&&&&&&&&&&&&&&&&&&&"
    ELSE
       LET g_cbc.cbc01=g_cbc.cbc01 USING "&&&&&&&&&&&&&&&&&&&&"
    END IF
    LET g_cbc.cbc04=''
    INSERT INTO cbc_file VALUES(g_cbc.*)
END FUNCTION
