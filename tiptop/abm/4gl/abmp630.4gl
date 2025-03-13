# Prog. Version..: '5.30.06-13.04.01(00010)'     #
#
# Pattern name...: abmp630 
# Descriptions...: FAS 產品組合作業
# Date & Author..: 91/12/04 By Lee
# Modify.........: No:7643 03/08/25 By Mandy 新增 aimi100料號時應default ima30= 
# Modify.........: No:8350 03/10/02 By Melody g_ima37 NOT MATCHES '[0-5]' 秀的訊息錯誤
# Modify.........: #No.MOD-490217 04/09/13 by yiting 料號欄位使用like方式
# Modify.........: No.FUN-550093 05/06/01 By kim 配方BOM,特性代碼
# Modify.........: No.FUN-560119 05/06/20 By saki 料件編號長度限制
# Modify.........: No.FUN-590040 05/09/09 By ching Fix品名DISPLAY
# Modify.........: No.TQC-5A0023 05/10/13 By rosayu 單身輸入 FAS 元件料號 ,不存在ima_file 的料,出現 ams-004 無此倉庫別
# Modify.........: No.MOD-5A0325 05/10/31 By Sarah 當組合選完後,會呈現在第一個SCREEN,此時按右側的放棄,程式不應產生BOM,料件
# Modify.........: No.TQC-630105 06/03/14 By Joe 單身筆數限制
# Modify.........: No.TQC-620111 06/04/07 By pengu 單頭加配方BOM,特性代碼
# Modify.........: No.TQC-660046 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/14 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-680122 06/12/06 By pengu 程式DEFINE錯誤,常導致一些無法預期的異常
# Modify.........: No.CHI-720002 07/02/14 By jamie ima130 接default '1',不該直接使用母件料號的值
# Modify.........: No.TQC-750173 07/05/30 By rainy 無使用特性BOM功能, 但本劃面有出現 '特性代碼'欄位
#                                                 已選擇所有必要項, 但仍出現 ams-108訊息 
# Modify.........: No.MOD-790002 07/09/03 By Joe 程式段INSERT時,增加欄位(PK)預設值
# Modify.........: No.MOD-780061 07/10/17 By pengu INSERT ima_file時ima911欄位未default值
# Modify.........: No.FUN-7B0018 08/03/04 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-830132 08/03/27 By hellen 將imaicd_file變成icd專用
# Modify.........: No.FUN-830116 08/04/18 By jan 增加bmb33賦值
# Modify.........: No.FUN-840194 08/06/24 By sherry 增加變動前置時間批量（ima061）
# Modify.........: No.FUN-910053 09/02/12 By jan INSERT INTO bmb_file 的bmb14 改為0
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0099 09/11/17 By douzh 加上栏位为空的判断
# Modify.........: No:TQC-980010 09/12/30 By baofei INSERT INTO bmb_file bmb05改為NULL
# Modify.........: No.FUN-A20044 10/03/19 By vealxu ima26x 調整
# Modify.........: No:FUN-A80150 10/09/20 By sabrina 在insert into ima_file之前，當ima156/ima158為null時要給"N"值
# Modify.........: No.FUN-AA0014 10/10/06 By Nicola 預設ima927
# Modify.........: No.FUN-AA0059 10/10/26 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-AB0025 10/11/10 By vealxu 全系統增加料件管控		
# Modify.........: No.FUN-AB0025 10/11/11 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.MOD-B40091 11/04/14 By destiny abmp630a加传一个参数             
# Modify.........: No:FUN-B70060 11/07/18 By zhangll 控管料號前不能有空格
# Modify.........: No:FUN-C20065 12/02/10 By lixh1 在insert into ima_file之前，當ima159為null時要給'3'
# Modify.........: No.TQC-C20131 12/02/13 By zhuhao 在insert into ima_file之前給ima928賦值 
# Modify.........: No:FUN-C50036 12/05/21 By yangxf 新增ima160字段，给预设值
# Modify.........: No.FUN-C40007 13/01/10 By Nina 只要程式有UPDATE bmb_file 的任何一個欄位時,多加bmbdate=g_today
# Modify.........: No.CHI-D10044 13/03/04 By bart s_uima146()參數變更

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_use      LIKE type_file.chr1,     #判斷該最終規格料件編號是否已存在,(Y/N)  #No.FUN-680096 VARCHAR(1)
    g_cpart    LIKE rpc_file.rpc01,     #品號
    g_FASno    LIKE ima_file.ima01,     #最終規格料件編號  #No.MOD-490217
    g_date     LIKE type_file.dat,      #需求日期   #No.FUN-680096 DATE
    g_bma06    LIKE bma_file.bma06,     # 特性代碼   #No.TQC-680122 modify
    g_wc,g_sql string,  #No.FUN-580092 HCN
    g_bmb      DYNAMIC ARRAY OF RECORD  # 單身 program array
        bmb02      LIKE bmb_file.bmb02, # 順序
        bmb03      LIKE bmb_file.bmb03, # 元件代號
        ima02      LIKE ima_file.ima02, # 品名   #FUN-590040
        bmb06      LIKE bmb_file.bmb06, # 單位組成用量
        bmb10      LIKE bmb_file.bmb10  # 發料單位
        END RECORD,
    g_bmb_t RECORD                      # 單身上一筆資料
        bmb02 LIKE bmb_file.bmb02,      # 順序
        bmb03 LIKE bmb_file.bmb03,      # 元件代號
        ima02      LIKE ima_file.ima02, # 品名   #FUN-590040
        bmb06 LIKE bmb_file.bmb06,      # 單位組成用量
        bmb10 LIKE bmb_file.bmb10       # 發料單位
        END RECORD,
    g_bmb_o RECORD LIKE bmb_file.*,     # 報價產品組合檔其他資料
    g_ima37        LIKE ima_file.ima37, # OPC
    g_ima63        LIKE ima_file.ima63, # 發料單位
    g_ima02        LIKE ima_file.ima02, # 品名
    g_got          LIKE type_file.num5,  #No.FUN-680096 SMALLINT
    l_ac           LIKE type_file.num5,   # 目前處理的ARRAY CNT    #No.FUN-680096 SMALLINT
    l_sl          LIKE type_file.chr1,    # 目前處理的SCREEN LINE  #No.FUN-680096 VARCHAR(1)
    l_flag         LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
    g_change_lang  LIKE type_file.chr1,   #是否有做語言切換 #No.FUN-680096 VARCHAR(1)
    g_cbc   RECORD LIKE cbc_file.*
DEFINE   g_forupd_sql    STRING                  #SELECT ... FOR UPDATE SQL
DEFINE   g_chr           LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680096 INTEGER
 
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

   IF g_sma.sma895='2' THEN
      CALL cl_err('','abm-739',1)
      EXIT PROGRAM
   END IF #FAS 產品料號產生方式
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690107

   CALL s_decl_bmb()
   CALL p630_ins_cbc()
   CALL abmp630(0,0)
   LET g_cbc.cbc04=g_FASno
 
   IF cl_null(g_cbc.cbc02) THEN
      DELETE FROM cbc_file WHERE cbc01=g_cbc.cbc01
   ELSE
      UPDATE cbc_file
         SET cbc04 = g_FASno
       WHERE cbc01 = g_cbc.cbc01
      IF STATUS OR SQLCA.SQLCODE THEN 
         CALL cl_err3("upd","cbc_file",g_cbc.cbc01,"",SQLCA.sqlcode,"","upd cbc",0)  #TQC-660046     
      END IF
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
END MAIN
 
FUNCTION abmp630(p_row,p_col)
DEFINE
    p_row,p_col LIKE type_file.num5,       #No.FUN-680096 SMALLINT
    l_ima       RECORD LIKE ima_file.*
#   l_time      LIKE type_file.chr8        #No.FUN-6A0060
DEFINE l_imaicd RECORD LIKE imaicd_file.*  #No.FUN-7B0018
 
    LET p_row = 2 LET p_col = 21
 
    OPEN WINDOW p630_w AT p_row,p_col WITH FORM "abm/42f/abmp630" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    #CALL cl_set_comp_visible("bma06",g_sma.sma118='Y') #No.TQC-620111
    CALL cl_set_comp_visible("g_bma06",g_sma.sma118='Y') #TQC-750173
    WHILE TRUE
        BEGIN WORK
        LET g_success='Y'
        LET g_change_lang = FALSE
        CALL p630_i()
        IF g_change_lang = TRUE THEN 
            CONTINUE WHILE
        END IF
        IF NOT INT_FLAG THEN
            IF g_use='N' THEN #不存在,則新增一筆資料
                #CALL p630a(p_row,p_col,g_cpart,'a',g_FASno,g_use,g_date)        #MOD-B40091
                CALL p630a(p_row,p_col,g_cpart,'a',g_FASno,g_use,g_date,g_bma06) #MOD-B40091
                    RETURNING g_got
                IF g_success='N' THEN EXIT WHILE END IF
                #1.BOM單頭
                INSERT INTO bma_file(bma01,bma02,bma03,bma04,bma06, 
                    bmauser,bmagrup,bmamodu,bmadate,bmaacti,bmaoriu,bmaorig,bma10)
                    VALUES(g_FASno,'','','',g_bma06,g_user,g_grup,   #No.TQC-620111 modify
                    '',TODAY,'Y', g_user, g_grup,'0')      #No.FUN-980030 10/01/04  insert columns oriu, orig
               #No.+037 010329 by plum
               #IF STATUS THEN
               #   CALL cl_err('ins bma:',STATUS,1) LET g_success='N' EXIT WHILE
                IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      #             CALL cl_err('ins bma: ',SQLCA.SQLCODE,1) #No.TQC-660046
                   CALL cl_err3("ins","bma_file",g_FASno,g_bma06,SQLCA.sqlcode,"","ins bma",1)  #NO.TQC-660046
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
#		LET l_ima.ima26=0    #FUN-A20044
#		LET l_ima.ima261=0   #FUN-A20044
#		LET l_ima.ima262=0   #FUN-A20044
		LET l_ima.ima139='N'
                LET l_ima.ima30=g_today #No:7643
                LET l_ima.ima910=g_bma06 #FUN-550093   # #No.TQC-620111 modify
                LET l_ima.ima911 = 'N'   #No.MOD-780061 add
		LET l_ima.ima93='Y'
		LET l_ima.imauser=g_user
		LET l_ima.imagrup=g_grup
		LET l_ima.imamodu=''
		LET l_ima.imaacti='Y'
		LET l_ima.ima130='1'   #CHI-720002 add
		LET l_ima.ima601=1     #No.FUN-840194
                IF cl_null(l_ima.ima926) THEN LET l_ima.ima926 ='N' END IF                  #No.FUN-9B0099
                IF STATUS THEN
#                  CALL cl_err('sel ima:',STATUS,1)  #No.TQC-660046
                   CALL cl_err3("sel","ima_file",g_cpart,"",STATUS,"","sel ima:",1)  #NO.TQC-660046  
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
               #No.+037 010329 by plum
               #IF STATUS THEN
               #   CALL cl_err('ins ima:',STATUS,1) LET g_success='N' EXIT WHILE
                IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
  #                 CALL cl_err('ins ima: ',SQLCA.SQLCODE,1) #No.TQC-660046
                   CALL cl_err3("ins","ima_file",l_ima.ima01,"",SQLCA.sqlcode,"","ins ima",1)  #NO.TQC-660046
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
               #No.+037..end
                IF g_sma.sma845='Y'   #低階碼可否部份重計
                   THEN
                   #CALL s_uima146(l_ima.ima01)  #CHI-D10044
                   CALL s_uima146(l_ima.ima01,0)  #CHI-D10044
                   MESSAGE ""
                   CALL ui.Interface.refresh()
                END IF
            ELSE 
            	 LET g_success='N' #MOD-B40091    
            END IF
        END IF
        #IF g_success='N' THEN EXIT WHILE END IF
        IF INT_FLAG THEN LET g_success='N' EXIT WHILE END IF #MOD-B40091
        CALL p630_b_fill('1=1')
        CALL p630_b()
        IF INT_FLAG THEN LET g_success='N' EXIT WHILE END IF
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
   #IF g_success='Y'
   #   THEN COMMIT WORK
   #   ELSE ROLLBACK WORK
   #END IF
    LET INT_FLAG=0
    CLOSE WINDOW p630_w
END FUNCTION
 
FUNCTION p630_i()
   DEFINE   l_ima         RECORD LIKE ima_file.*
   DEFINE   lc_sma119     LIKE sma_file.sma119, #No.FUN-560119
            li_len        LIKE type_file.num5   #No.FUN-680096 SMALLINT
 
   CLEAR FORM
   LET g_use='Y'
   LET g_date=TODAY
   LET g_cpart = NULL
   LET g_FASno = NULL
 
   #No.FUN-560119 --start--
   SELECT sma119 INTO lc_sma119 FROM sma_file
   CASE lc_sma119
      WHEN "0"
         LET li_len = 20
      WHEN "1"
         LET li_len = 30
      WHEN "2"
         LET li_len = 40
   END CASE
   #No.FUN-560119 ---end---
 
   LET g_bma06= ' '     #No.TQC-620111
#  CALL cl_set_head_visible("","YES")    #No.FUN-6B0033
   INPUT BY NAME g_cpart,g_FASno,g_bma06,g_date WITHOUT DEFAULTS    #No.TQC-620111 add
 
      #No.FUN-560119 --start--
      BEFORE INPUT
         CALL cl_chg_comp_att("formonly.g_cpart","WIDTH|GRIDWIDTH|SCROLL",li_len || "|" || li_len || "|0")
         CALL cl_chg_comp_att("formonly.g_fasno","WIDTH|GRIDWIDTH|SCROLL",li_len || "|" || li_len || "|0")
      #No.FUN-560119 ---end---
 
      AFTER FIELD g_cpart
         IF g_cpart IS NULL THEN  
            NEXT FIELD g_cpart 
         END IF
        #FUN-AB0025 --------------add start--------------
         IF NOT s_chk_item_no(g_cpart,'') THEN
            CALL cl_err('',g_errno,1)
            NEXT FIELD g_cpart
         END IF 
        #FUN-AB0025 --------------add end----------------- 
         SELECT * INTO l_ima.* FROM ima_file WHERE ima01=g_cpart
         IF STATUS THEN
#            CALL cl_err('sel ima:',STATUS,0)  #No.TQC-660046
            CALL cl_err3("sel","ima_file",g_cpart,"",STATUS,"","sel ima:",0)  #NO.TQC-660046
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
 
      AFTER FIELD g_FASno
         IF g_FASno IS NULL THEN
            NEXT FIELD g_FASno
         END IF
         #FUN-B70060 add
         IF g_FASno[1,1] = ' ' THEN
            CALL cl_err(g_FASno,"aim-671",0)
            NEXT FIELD g_FASno
         END IF
         #FUN-B70060 add--end
         SELECT ima01 FROM ima_file WHERE ima01=g_FASno
         IF SQLCA.sqlcode THEN
            LET g_use='N'
         ELSE
            EXIT INPUT
         END IF 
 
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
         IF g_FASno IS NULL THEN
            NEXT FIELD g_FASno
         END IF 
 
        ON ACTION controlp                  
           CASE 
              WHEN INFIELD(g_cpart) 
#FUN-AA0059 --Begin--
               #  CALL cl_init_qry_var()
               #  LET g_qryparam.form ="q_ima"
               #  LET g_qryparam.default1 = g_cpart 
               #  LET g_qryparam.where = " ima08 = 'C' "
               #  CALL cl_create_qry() RETURNING g_cpart 
                 CALL q_sel_ima(FALSE, "q_ima", " ima08 = 'C'", g_cpart, "", "", "", "" ,"",'' )  RETURNING g_cpart
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
         CALL cl_show_fld_cont()   #FUN-550037(smin)
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
 
FUNCTION p630_b()
DEFINE
    l_modify_flag  LIKE type_file.chr1,   # 單身更改否        #No.FUN-680096 VARCHAR(1)
    l_lock_sw      LIKE type_file.chr1,   # 單身鎖住否        #No.FUN-680096 VARCHAR(1)
    l_n            LIKE type_file.num5,   # 檢查重複用        #No.FUN-680096 SMALLINT
    l_ac_t         LIKE type_file.num5,   # 未取消的ARRAY CNT      #No.FUN-680096 SMALLINT
    l_jump         LIKE type_file.num5,   # 測試是否跳過after row  #No.FUN-680096 SMALLINT
    l_exit_sw      LIKE type_file.chr1,   # Esc結束INPUT ARRAY 否  #No.FUN-680096 VARCHAR(1)
#   l_bmb19_t      LIKE bmb_file.bmb19,   #金額
    l_bmb02        LIKE bmb_file.bmb02,   #序號
    l_insert       LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
    l_update       LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
    p_cmd          LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
    l_chr          LIKE type_file.chr1    #No.FUN-680096 VARCHAR(1)
DEFINE lc_sma119   LIKE sma_file.sma119,  #No.FUN-560119
       li_len      LIKE type_file.num5    #No.FUN-680096 SMALLINT
DEFINE l_bmb05     LIKE bmb_file.bmb05    #TQC-980010 
 
    LET l_insert='Y'
    LET l_update='Y'
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT * FROM bmb_file ",
                        "  WHERE bmb01 = ? ",            # 單號
                          " AND bmb02 = ? ",            # 序號
                          " FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p630_b_curl CURSOR FROM g_forupd_sql            # LOCK CURSOR
 
    LET l_ac_t = 0
    WHILE TRUE
        LET l_exit_sw = "y"                      # 正常結束,除非 ^N
 
        #No.FUN-560119 --start--
        SELECT sma119 INTO lc_sma119 FROM sma_file
        CASE lc_sma119
           WHEN "0"
              LET li_len = 20
           WHEN "1"
              LET li_len = 30
           WHEN "2"
              LET li_len = 40
        END CASE
        #No.FUN-560119 ---end---
 
        INPUT ARRAY g_bmb WITHOUT DEFAULTS FROM s_bmb.* 
 
        #No.FUN-560119 --start--
        BEFORE INPUT
           CALL cl_chg_comp_att("bmb03","WIDTH|GRIDWIDTH|SCROLL",li_len || "|" || li_len || "|0")
        #No.FUN-560119 ---end--
 
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
 
                OPEN p630_b_curl USING g_FASno, g_bmb_t.bmb02
 
                IF STATUS THEN
                   CALL cl_err("OPEN p630_b_curl:", STATUS, 1)
                   CLOSE p630_b_curl
                   ROLLBACK WORK
                   RETURN
                END IF
 
                FETCH p630_b_curl INTO g_bmb_o.* 
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
                CALL p630_init()
#               LET l_bmb19_t=0
                INITIALIZE g_bmb[l_ac].* TO NULL      # 900423
            END IF
            IF l_ac <= l_n then                   # DISPLAY NEWEST
                CALL p630_bmb02(' ')
                DISPLAY g_bmb[l_ac].* TO s_bmb[l_sl].*
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bmb02
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bmb[l_ac].* TO NULL      # 900423
            LET g_bmb_t.* = g_bmb[l_ac].*         # 新輸入資料
            CALL p630_init()
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
                CALL p630_bmb02('a')
                IF g_chr = 'E' THEN                  # 無此品號
                    #CALL cl_err('I/M',"ams-004",0) #TQC-5A0023 mark
                    CALL cl_err(g_bmb[l_ac].bmb03,"ams-003",0) #TQC-5A0023 add
                    LET g_bmb[l_ac].bmb03 = g_bmb_t.bmb03
                    NEXT FIELD bmb03
                END IF
                IF g_ima37 NOT MATCHES '[0-4]' THEN #OPC
                   #CALL cl_err(g_ima37,"ams-004",0)
                    CALL cl_err(g_ima37,"mfg1003",0)  #No:8350
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
 
            IF g_sma.sma845='Y'   #低階碼可否部份重計
               THEN
               LET g_success='Y'
               #CALL s_uima146(g_bmb_t.bmb03)  #CHI-D10044
               CALL s_uima146(g_bmb_t.bmb03,0)  #CHI-D10044
               MESSAGE ""
               CALL ui.Interface.refresh()
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
                CALL cl_err3("del","bmb_file",g_FASno,g_bmb_t.bmb02,SQLCA.sqlcode,"","",0)  #NO.TQC-660046
                LET l_exit_sw = "n"
                LET l_ac_t = l_ac
                EXIT INPUT
            END IF
#           CALL p630_uh(g_bmb[l_ac].bmb19,0)
 
## No:     modify 1998/12/08 ------------------------
        AFTER DELETE
{
            INITIALIZE g_bmb[l_ac].* TO NULL
            IF l_ac = l_n THEN
                CALL SET_COUNT(l_ac-1)
            END IF
}
          LET l_jump = '1'
          LET l_n = ARR_COUNT()
          INITIALIZE g_bmb[l_n+1].* TO NULL
 
 
        AFTER ROW
            if not l_jump then
                DISPLAY g_bmb[l_ac].* TO s_bmb[l_sl].*
                IF INT_FLAG THEN                 # 900423
                    CALL cl_err('',9001,0)
                   #LET INT_FLAG = 0   #MOD-5A0325 mar mark
                    LET g_bmb[l_ac].* = g_bmb_t.*
#                   CALL p630_uh(l_bmb19_t,g_bmb[l_ac].bmb19)
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
                            bmb21,bmb22,bmb23,bmb28,bmb29,bmb33,bmb081,bmb082) #FUN-550093 #No.FUN-830116  #MOD-B40091
                        #           1                 2                 3
                        VALUES(g_FASno,g_bmb[l_ac].bmb02,g_bmb[l_ac].bmb03,
                        #        4  5                 6  7
             #            '01/01/01','',g_bmb[l_ac].bmb06,1,   ##TQC-980010
                         '01/01/01',l_bmb05,g_bmb[l_ac].bmb06,1,           #TQC-980010 
                        #8,9,               10,f0,f1,11,13
                         0,0,g_bmb[l_ac].bmb10, 1, 1,'','',
                        #14, 15, 16, 17,18,19,                20, 21 ,22,23
#                        '1','1','1','1',0,'N',g_bmb[l_ac].bmb02,'N','N',0)
                        # No.+114
#                        '1','1','1','1',0,'N',g_bmb[l_ac].bmb02,'N','N',0,0,g_bma06,0) #FUN-550093    #No.TQC-620111 modify #No.FUN-830116 #FUN-910053 MARK
                         '0','1','1','1',0,'N',g_bmb[l_ac].bmb02,'N','N',0,0,g_bma06,0,0,1) #FUN-910053  #MOD-B40091
                        IF SQLCA.sqlcode THEN
 #                           CALL cl_err(g_bmb[l_ac].bmb03,SQLCA.sqlcode,0) #No.TQC-660046
                            CALL cl_err3("ins","bmb_file",g_FASno,g_bmb[l_ac].bmb02,SQLCA.sqlcode,"","",0)  #NO.TQC-660046
                            LET g_bmb[l_ac].* = g_bmb_t.*
                            DISPLAY g_bmb[l_ac].* TO s_bmb[l_sl].*
                        ELSE
                            MESSAGE 'INSERT ok'
                            CALL ui.Interface.refresh()
                            IF g_sma.sma845='Y'   #低階碼可否部份重計
                               THEN
                               LET g_success='Y'
                               #CALL s_uima146(g_bmb[l_ac].bmb03)  #CHI-D10044
                               CALL s_uima146(g_bmb[l_ac].bmb03,0)  #CHI-D10044
                               MESSAGE ""
                               CALL ui.Interface.refresh()
                            END IF
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
                         WHERE CURRENT OF p630_b_curl
 
                        IF SQLCA.sqlcode THEN
  #                          CALL cl_err(g_bmb[l_ac].bmb02,SQLCA.sqlcode,0) #No.TQC-660046
                            CALL cl_err3("upd","bmb_file",g_bmb[l_ac].bmb02,g_bmb[l_ac].bmb03,SQLCA.sqlcode,"","",0)  #NO.TQC-660046
                            LET g_bmb[l_ac].* = g_bmb_t.*
                            DISPLAY g_bmb[l_ac].* TO s_bmb[l_sl].*
                        ELSE
                            IF g_sma.sma845='Y'   #低階碼可否部份重計
                               THEN
                               LET g_success='Y'
                               #CALL s_uima146(g_bmb_t.bmb03)  #CHI-D10044
                               #CALL s_uima146(g_bmb[l_ac].bmb03)  #CHI-D10044
                               CALL s_uima146(g_bmb_t.bmb03,0)  #CHI-D10044
                               CALL s_uima146(g_bmb[l_ac].bmb03,0)  #CHI-D10044
                               MESSAGE ""
                               CALL ui.Interface.refresh()
                            END IF
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
                  #CALL p630a(0,0,g_cpart,'u',g_FASno,'Y',g_date) RETURNING g_got         #MOD-B40091
                  CALL p630a(0,0,g_cpart,'u',g_FASno,'Y',g_date,g_bma06) RETURNING g_got  #MOD-B40091
                  IF g_got > 0 THEN
                     LET l_exit_sw = 'n'
                     LET l_ac_t = l_ac
                     CALL p630_b_fill('1=1')
                     EXIT INPUT
                  END IF
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(bmb03) #品號
#                 CALL q_ima(3,3,g_bmb[l_ac].bmb03) RETURNING g_bmb[l_ac].bmb03
#                 CALL FGL_DIALOG_SETBUFFER( g_bmb[l_ac].bmb03 )
#FUN-AB0025 --------------Begin---------------------
                #  CALL cl_init_qry_var()
                #  LET g_qryparam.form = 'q_ima'
                #  LET g_qryparam.default1 = g_bmb[l_ac].bmb03
                #  CALL cl_create_qry() RETURNING g_bmb[l_ac].bmb03
                  CALL q_sel_ima(FALSE, "q_ima", "", g_bmb[l_ac].bmb03, "", "", "", "" ,"",'' )  RETURNING g_bmb[l_ac].bmb03
#FUN-AB0025 --------------End-----------------------
#                  CALL FGL_DIALOG_SETBUFFER( g_bmb[l_ac].bmb03 )
                  DISPLAY g_bmb[l_ac].bmb03 TO s_bmb[l_sl].bmb03
                  NEXT FIELD bmb03
 
               OTHERWISE 
                  EXIT CASE
 
            END CASE
 
      # ON ACTION CONTROLN
      #     CALL p630_b_askkey()
      #     LET l_exit_sw = "n"
      #     EXIT INPUT
 
        ON ACTION CONTROLO                        # 沿用欄位
            IF l_ac > 1 THEN 
                CASE 
                    WHEN infield(bmb02)
                        let l_bmb02 = g_bmb[l_ac].bmb02
                        LET g_bmb[l_ac].* = g_bmb[l_ac-1].*
                        let g_bmb[l_ac].bmb02 = l_bmb02
                        DISPLAY g_bmb[l_ac].* TO s_bmb[l_sl].*
                        NEXT FIELD bmb02
                    WHEN INFIELD(bmb03)
                        let g_bmb[l_ac].bmb03 = g_bmb[l_ac-1].bmb03
                        DISPLAY g_bmb[l_ac].bmb03 TO s_bmb[l_sl].bmb03
                        NEXT FIELD bmb03
                    WHEN INFIELD(bmb06)
                        let g_bmb[l_ac].bmb06 = g_bmb[l_ac-1].bmb06
                        DISPLAY g_bmb[l_ac].bmb06 TO s_bmb[l_sl].bmb06
                        NEXT FIELD bmb06
                    WHEN INFIELD(bmb10)
                        let g_bmb[l_ac].bmb10 = g_bmb[l_ac-1].bmb10
                        DISPLAY g_bmb[l_ac].bmb10 TO s_bmb[l_sl].bmb10
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
 
#     ON ACTION controls                       #No.FUN-6B0033
#        CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
    
  
        END INPUT
        IF INT_FLAG THEN LET g_success='N' RETURN END IF
        IF l_exit_sw = "y" THEN
            EXIT WHILE                           # ESC 或 DEL 結束 INPUT
        END IF
        CONTINUE WHILE                       # ^N 結束 INPUT
    END WHILE
 
    CLOSE p630_b_curl
END FUNCTION
 
FUNCTION  p630_bmb02(p_cmd)
DEFINE
    p_cmd     LIKE type_file.chr1,       #No.FUN-680096 VARCHAR(1)
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
        DISPLAY g_bmb[l_ac].ima02 TO s_bmb[l_sl].ma02
    END IF
END FUNCTION
 
FUNCTION p630_b_askkey()
    DEFINE
        l_wc     LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(200)
 
   CLEAR FORM
   CALL g_bmb.clear()
#  CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
   CONSTRUCT l_wc ON bmb02,bmb03,bmb06,bmb10
        FROM s_bmb[1].bmb02,s_bmb[1].bmb03,s_bmb[1].bmb06,
             s_bmb[1].bmb10
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()   #FUN-550037(smin)
 
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
    CALL p630_b_fill(l_wc)
END FUNCTION
 
FUNCTION p630_b_fill(p_wc)                   # BODY FILL UP
    DEFINE
        l_ac  LIKE type_file.num5,     #No.FUN-680096 SMALLINT
        p_wc  LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(200)
 
    LET g_sql =
        "SELECT bmb02,bmb03,ima02,bmb06,bmb10",  #FUN-590040
        " FROM bmb_file, OUTER ima_file",
        " WHERE bmb01 ='",g_FASno,"'", #料件編號
        " AND (bmb04 <='",g_date,
        "' OR bmb04 IS NULL) AND (bmb05 >'",g_date,
        "' OR bmb05 IS NULL)",
        " AND ima_file.ima01=bmb_file.bmb03", #品號
        " AND ",p_wc CLIPPED,
        " ORDER BY 1"
    PREPARE p630_pb FROM g_sql
    DECLARE p630_b_curs                       #CURSOR
        CURSOR FOR p630_pb
    #FOR l_ac = 1 TO g_bmb.getLength()                   # 單身 ARRAY 乾洗
    #   INITIALIZE g_bmb[l_ac].* TO NULL
    #END FOR
    #LET l_ac = 1
    #FOREACH p630_b_curs INTO g_bmb[l_ac].*     # 單身 ARRAY 填充
    #    IF SQLCA.sqlcode THEN
    #        CALL cl_err('FOReach:',SQLCA.sqlcode,1)
    #        EXIT FOREACH
    #    END IF
    #    LET l_ac = l_ac + 1
    #    IF g_cnt > g_max_rec THEN
    #       CALL cl_err( '', 9035, 0 )
    #       EXIT FOREACH
    #    END IF
    #END FOREACH
    #CALL SET_COUNT(l_ac - 1)                     # 告訴I.單身筆數
    # TQC-630105----------start add by Joe
    CALL g_bmb.clear()
    LET g_cnt = 1
    FOREACH p630_b_curs INTO g_bmb[g_cnt].*     # 單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOReach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_bmb.deleteElement(g_cnt)
    CALL SET_COUNT(g_cnt - 1)                     # 告訴I.單身筆數
    # TQC-630105----------end add by Joe
END FUNCTION
 
#當輸入新資料時, 作資料的預設處理
FUNCTION p630_init()
    LET g_bmb[l_ac].bmb06 = 0.0   #組成用量
    INITIALIZE g_bmb_o.* TO NULL
    LET g_bmb_o.bmb21='N'         #元件代號是否列印在文件上
    LET g_bmb_o.bmb22='N'         #元件價格是否列印在文件上
    LET g_bmb_o.bmb19='N'         #元件價格是否列印在文件上
    LET g_bmb_o.bmb07=1.0         #原料成本
    LET g_bmb_o.bmb09='' 
    LET g_bmb_o.bmb10_fac=1.0         #製造費用
    LET g_bmb_o.bmb10_fac2=1.0         #製造費用
    LET g_bmb_o.bmb18=0.0         #本幣原始單價
    LET g_bmb_o.bmb20=0.0         #折扣率
END FUNCTION
 

#FUNCTION p630_uh(l_bmb19,p_bmb19)
#    DEFINE
#        l_bmb19      LIKE bmb_file.bmb19,  #舊的值
#        p_bmb19      LIKE bmb_file.bmb19   #新的值
# 
#    IF l_bmb19 IS NULL THEN LET l_bmb19 = 0 END IF
#    IF p_bmb19 IS NULL THEN LET p_bmb19 = 0 END IF
#    IF g_price IS NULL THEN LET g_price = 0 END IF
#    LET g_price = g_price + p_bmb19 - l_bmb19
#    DISPLAY 'Price=(',g_price USING '####&.&&&', ')' AT 1,60
#        
#END FUNCTION

FUNCTION p630_ins_cbc()
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
