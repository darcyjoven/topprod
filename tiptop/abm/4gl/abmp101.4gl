# Prog. Version..: '5.30.06-13.04.01(00010)'     #
#
# Pattern name...: abmp101.4gl
# Descriptions...: 工程BOM 轉正式BOM   
# Date & Author..: 03/03/17 By Mandy
# Modify.........: No.MOD-470041 04/07/16 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-480233 04/08/10 Kammy 產生單身時應加 sma100 判斷
# Modify.........: No.MOD-490272 04/09/14 Kammy sma100='y'時，單身輸入正式
#                                               料號都不成功  
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.MOD-540087 05/04/12 By Mandy INSERT INTO ima_file的檢驗否欄位(ima24)請給default 'N'
# Modify.........: No.FUN-550079 05/05/18 By kim 配方BOM,加bmo06特性代碼
# Modify.........: No.FUN-560021 05/06/07 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.FUN-560030 05/06/13 By kim 測試BOM : bmo_file新增 bmo06 ,相關程式需修改
# Modify.........: No.FUN-560074 05/06/16 By pengu  CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-560119 05/06/20 By saki 料件編號長度限制
# Modify.........: No.MOD-590193 05/09/14 By kim 當單身只有一筆時,單頭資料input 完後產生單身資料時hold 住
# Modify.........: No.TQC-650066 06/05/16 By Claire ima79 mark
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/17 By hellen 新增單頭折疊功能
# Modify.........: No.MOD-6B0147 06/12/06 By Claire 應取正式料號來比對
# Modify.........: No.FUN-710014 07/02/08 By Carrier 錯誤訊息匯整 
# Modify.........: No.CHI-710051 07/06/07 By jamie 將ima21欄位放大至21
# Modify.........: No.CHI-790004 07/09/03 By kim 新增段PK值不可為NULL
# Modify.........: No.MOD-790002 07/09/03 By Joe 程式段INSERT時,增加欄位(PK)預設值
# Modify.........: No.MOD-780061 07/10/17 By pengu INSERT ima_file時ima911欄位未default值
# Modify.........: No.FUN-6B0033 06/11/17 By hellen 新增單頭折疊功能
# Modify.........: No.FUN-7B0018 08/03/04 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-830132 08/03/27 By hellen 將imaicd_file變成icd專用
# Modify.........: No.FUN-830116 08/04/18 By jan 增加bmb33賦值
# Modify.........: No.FUN-840194 08/06/24 By sherry 增加變動前置時間批量（ima061）
# Modify.........: No.FUN-8B0015 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910
# Modify.........: No.MOD-920026 09/02/03 By claire ima915沒有給值
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-950134 09/05/22 By Carrier rowid定義規範化
# Modify.........: No.TQC-960121 09/06/15 By Carrier insert ima_file前對某些not null值做判斷為空否
# Modify.........: No.MOD-960172 09/06/19 By Carrier insert ima_file前對ima918/ima919/ima921/ima922做賦值
# Modify.........: No.MOD-960298 09/06/25 By Carrier 插入bma_file是對bma10賦初值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0155 09/10/28 By liuxqa order by 修改。
# Modify.........: No:FUN-9C0077 09/12/16 By baofei 程序精簡
# Modify.........: No.MOD-9C0033 09/12/23 By sabrina imaacti的default給錯了。ima1010沒有給default值
# Modify.........: No.FUN-A20044 10/03/20 By vealxu ima26x 調整
# Modify.........: No:MOD-A40151 10/04/26 By Sarah 寫入bmd_file時,bmdacti,bmduser,bmdgrup,bmddate要給預設值
# Modify.........: No:FUN-A80150 10/09/20 By sabrina 在insert into ima_file之前，當ima156/ima158為null時要給"N"值
# Modify.........: No.FUN-AA0014 10/10/06 By Nicola 預設ima927
# Modify.........: No.FUN-AB0025 10/11/11 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.TQC-AB0050 10/11/14 By destiny 预设ima022,ima120 
# Modify.........: No.TQC-AC0018 10/12/02 By destiny 更新bec_file字段错误，应为bec06  
# Modify.........: No.TQC-AC0183 10/12/22 By liweie  新增bmp081,bmp082字段
# Modify.........: No:FUN-B70060 11/07/18 By zhangll 控管料號前不能有空格
# Modify.........: No:FUN-BB0083 11/12/14 By xujing 增加數量欄位小數取位
# Modify.........: No:FUN-C20065 12/02/10 By lixh1 在insert into ima_file之前，當ima159為null時要給'3'
# Modify.........: No.TQC-C20131 12/02/13 By zhuhao 在insert into ima_file之前給ima928賦值,insert into bmd_file 之前給bmd11賦值
# Modify.........: No:MOD-C20125 12/02/16 By ck2yuan q_bmo改用q_bmo4查詢
# Modify.........: No:FUN-C50036 12/05/21 By yangxf 新增ima160字段，给预设值
# Modify.........: No.CHI-D10044 13/03/04 By bart s_uima146()參數變更

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD                          #CHI-710051 
          bmo01  LIKE bmo_file.bmo01,   
          bmo011 LIKE bmo_file.bmo011,
          firm   LIKE bmo_file.bmo01,
          bdate  LIKE type_file.dat,      #No.FUN-680096 DATE
          edate  LIKE type_file.dat,      #No.FUN-680096 DATE
          bmo06  LIKE bmo_file.bmo06,     #FUN-550079
          a      LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
          b      LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
          c      LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
          d      LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
          f      LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
          e      LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1)
          END RECORD,
       g_bmq01       LIKE bmq_file.bmq01,
       g_bmo  RECORD LIKE bmo_file.*,
       g_bmp  DYNAMIC ARRAY OF RECORD
              bmp01   LIKE bmp_file.bmp01,   #上階料號
              v1      LIKE bmo_file.bmo011,  #上階版本
              desc1   LIKE ima_file.ima02,   #上階品名
              desc11  LIKE ima_file.ima021,  #上階規格
              bmp03   LIKE bmp_file.bmp03,   #本階料號
              v2      LIKE bmo_file.bmo011,  #本階版本
              desc2   LIKE ima_file.ima02,   #本階品名
              desc22  LIKE ima_file.ima021,  #本階規格
              item    LIKE ima_file.ima01,   #本階料件的正式料號
              levela  LIKE type_file.num5,   #No.FUN-680096 SMALLINT
              bmp28   LIKE bmp_file.bmp28    #FUN-550079
              END RECORD,
       g_bmp_t RECORD 
              bmp01   LIKE bmp_file.bmp01,   #上階料號
              v1      LIKE bmo_file.bmo011,  #上階版本
              desc1   LIKE ima_file.ima02,   #上階品名
              desc11  LIKE ima_file.ima021,  #上階規格
              bmp03   LIKE bmp_file.bmp03,   #本階料號
              v2      LIKE bmo_file.bmo011,  #本階版本
              desc2   LIKE ima_file.ima02,   #本階品名
              desc22  LIKE ima_file.ima021,  #本階規格
              item    LIKE ima_file.ima01,   #本階料件的正式料號
              levela  LIKE type_file.num5,   #No.FUN-680096 SMALLINT
              bmp28   LIKE bmp_file.bmp28    #FUN-550079
              END RECORD,
       b_bmp  DYNAMIC ARRAY OF RECORD
              sou    LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
              bmp02  LIKE bmp_file.bmp02, 
              bmp16  LIKE bmp_file.bmp16
              END RECORD,
       g_rec_b       LIKE type_file.num10,   #No.FUN-680096 INTEGER
       g_rec_b_bed   LIKE type_file.num10,   #No.FUN-680096 INTEGER
       g_rec_b_bmn   LIKE type_file.num10,   #No.FUN-680096 INTEGER
       g_imz  RECORD LIKE imz_file.*,        #INSERT ima_file時給default值  
       g_levela      LIKE type_file.num5,    #No.FUN-680096 SMALLINT
       g_ac          LIKE type_file.num5,    #No.FUN-680096 SMALLINT
       g_bed  DYNAMIC ARRAY OF RECORD
              bed03   LIKE bed_file.bed03,
              bed02   LIKE bed_file.bed02,
              bed04   LIKE bed_file.bed04,
              ima02   LIKE ima_file.ima02,   #替代料號品名
              ima021  LIKE ima_file.ima021,  #替代料號規格
              a       LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
              sitem   LIKE ima_file.ima01    #正式料號
              END RECORD,
       g_bed_t RECORD 
              bed03   LIKE bed_file.bed03,
              bed02   LIKE bed_file.bed02,
              bed04   LIKE bed_file.bed04,
              ima02   LIKE ima_file.ima02,   #替代料號品名
              ima021  LIKE ima_file.ima021,  #替代料號規格
              a       LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
              sitem   LIKE ima_file.ima01    #正式料號
              END RECORD,
       g_bmn  DYNAMIC ARRAY OF RECORD        #---->聯產品
              bmn02   LIKE bmn_file.bmn02,   #儲存該測試BOM聯產品項次
              bmn03   LIKE bmn_file.bmn03,   #儲存該主件聯產品料號
              ima02   LIKE ima_file.ima02,   #儲存該主件聯產品料號的品名規格
              a       LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
              sitem   LIKE ima_file.ima01    #正式料號(user給予的)
              END RECORD,
       g_bmn_t RECORD 
              bmn02   LIKE bmn_file.bmn02,   #儲存該測試BOM聯產品項次
              bmn03   LIKE bmn_file.bmn03,   #儲存該主件聯產品料號
              ima02   LIKE ima_file.ima02,   #儲存該主件聯產品料號的品名規格
              a       LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
              sitem   LIKE ima_file.ima01    #正式料號(user給予的)
              END RECORD,
      g_exit_while    LIKE type_file.chr1    #No.FUN-680096 VARCHAR(1)
 
DEFINE   g_cnt         LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i           LIKE type_file.num5     #count/index for any purpose   #No.FUN-680096 SMALLINT
DEFINE   g_change_lang LIKE type_file.chr1,    #是否有做語言切換  #No.FUN-680096 VARCHAR(1)
         l_flag        LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT	         		# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690107
 
 
   CALL s_decl_bmb()
   WHILE TRUE
     BEGIN WORK
     LET g_success = 'Y'
     LET g_change_lang = FALSE
     CLEAR FORM
     CALL p101() #主要移轉程式
     IF g_change_lang = TRUE THEN 
         CONTINUE WHILE
     END IF
     IF g_success = 'Y' THEN 
         CALL p101_out()
     ELSE
         IF g_exit_while = 'Y' THEN
             LET INT_FLAG = 0
             EXIT WHILE
         ELSE
             IF INT_FLAG THEN
                 LET INT_FLAG = 0
                 #放棄拋轉,請重新輸入!
                 CALL cl_err('','abm-116',0)
             END IF
             ROLLBACK WORK
             CONTINUE WHILE
         END IF
     END IF
     #-->正式資料拋轉
     IF cl_sure(0,0) THEN
        CALL cl_wait()
        IF g_success = 'Y' THEN
           CALL cl_err(tm.bmo01,'abm-113',1) 
           COMMIT WORK
           CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
        ELSE 
           CALL cl_err(tm.bmo01,'abm-114',1) 
           ROLLBACK WORK
           CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
        END IF
        IF l_flag THEN
           CONTINUE WHILE
        ELSE
           EXIT WHILE
        END IF
     ELSE
        CALL cl_err(tm.bmo01,'abm-114',1) 
        ROLLBACK WORK
     END IF
     ERROR ""
   END WHILE
   CLOSE WINDOW p101_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
END MAIN
   
FUNCTION p101_tm(p_row,p_col)
   DEFINE   p_row,p_col	  LIKE type_file.num5,   #No.FUN-680096 SMALLINT
            l_cnt         LIKE type_file.num5,   #No.FUN-680096 SMALLINT
            l_firm_y      LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
            l_bmq011      LIKE bmq_file.bmq011,
            l_bmq02       LIKE bmq_file.bmq02,
            l_bmq021      LIKE bmq_file.bmq021,
            l_ima02       LIKE ima_file.ima02,
            l_ima021      LIKE ima_file.ima021
   DEFINE   lc_sma119     LIKE sma_file.sma119,  #No.FUN-560119
            li_len        LIKE type_file.num5    #No.FUN-680096 SMALLINT
 
 
   LET p_row = 3  LET p_col = 18
 
   OPEN WINDOW p101_w AT p_row,p_col WITH FORM "abm/42f/abmp101" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL cl_set_comp_visible("bmo06,bmp28",g_sma.sma118='Y')
 
 
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.bdate = g_today
   LET l_firm_y = 'N'
   LET tm.a = 'Y'
   LET tm.b = 'Y'
   LET tm.c = 'Y'
   LET tm.d = 'Y'
   LET tm.f = 'Y'
   LET tm.e = 'N'
 
   CALL cl_set_comp_entry("bmo06,bmp28",g_sma.sma118='Y') #FUN-550079
   SELECT sma119 INTO lc_sma119 FROM sma_file
   CASE lc_sma119
      WHEN "0"
         LET li_len = 20
      WHEN "1"
         LET li_len = 30
      WHEN "2"
         LET li_len = 40
   END CASE
   CALL cl_set_head_visible("g01","YES")     #No.FUN-6B0033
 
   INPUT BY NAME tm.bmo01,tm.bmo011,tm.firm,tm.bmo06,tm.bdate,tm.edate,
                 tm.a,tm.b,tm.c,tm.d,tm.f,tm.e WITHOUT DEFAULTS 
 
      BEFORE INPUT
         CALL cl_chg_comp_att("formonly.bmo01","WIDTH|GRIDWIDTH|SCROLL",li_len || "|" || li_len || "|0")
         CALL cl_chg_comp_att("formonly.firm","WIDTH|GRIDWIDTH|SCROLL",li_len || "|" || li_len || "|0")
 
      AFTER FIELD bmo01
         SELECT COUNT(*) INTO g_cnt FROM bmo_file WHERE bmo01 = tm.bmo01
         IF g_cnt = 0 OR SQLCA.sqlcode THEN 
            CALL cl_err(tm.bmo01,'mfg2757',0)
            NEXT FIELD bmo01
         END IF
         #主件編號(bmo01)已存在正式bom中..
         IF g_sma.sma118<>'Y' THEN  #FUN-560030
            SELECT COUNT(*) INTO g_cnt FROM bma_file WHERE bma01 = tm.bmo01
            IF g_cnt > 0 THEN 
               CALL cl_err(tm.bmo01,'mfg2773',0)
               NEXT FIELD bmo01
            END IF
         END IF
         #檢查該主件已有正式料號(bmq011)否?
         SELECT bmq011,bmq02,bmq021 INTO tm.firm,l_bmq02,l_bmq021 
           FROM bmq_file WHERE bmq01 = tm.bmo01
         IF STATUS = 0 AND NOT cl_null(tm.firm) THEN 
            DISPLAY tm.firm TO firm 
            LET l_firm_y = 'Y'
         END IF
         DISPLAY l_bmq02  TO FORMONLY.bmq02   
         DISPLAY l_bmq021 TO FORMONLY.bmq021
 
         #若該主件已有正式料號,則不可修改正式料號,一主件只可有一種正式料號
          CALL cl_set_comp_entry("firm",cl_null(tm.firm))
 
      AFTER FIELD bmo06
         #主件編號(bmo01)已存在正式bom中..
         IF g_sma.sma118='Y' THEN  #FUN-560030
            IF tm.bmo06 IS NULL THEN
               LET tm.bmo06=' '
            END IF
            SELECT COUNT(*) INTO g_cnt FROM bma_file WHERE bma01 = tm.bmo01
                                                       AND bma06 = tm.bmo06
            IF g_cnt > 0 THEN 
               CALL cl_err(tm.bmo01,'mfg2773',0)
               NEXT FIELD bmo01
            END IF
 
            SELECT bmo_file.*
              INTO g_bmo.*
              FROM bmo_file 
             WHERE bmo01 = tm.bmo01 AND bmo011= tm.bmo011
               AND bmo06 = tm.bmo06
            
            IF SQLCA.sqlcode THEN 
               CALL cl_err('','mfg2757',0)
               NEXT FIELD bmo011
            END IF
            
            IF not cl_null(g_bmo.bmo05) THEN 
               CALL cl_err('','mfg2760',0)
               NEXT FIELD bmo011
            END IF
         END IF
     
      AFTER FIELD bmo011
         IF g_sma.sma118<>'Y' THEN  #FUN-560030
            SELECT bmo_file.* INTO g_bmo.* FROM bmo_file 
               WHERE bmo01 = tm.bmo01 AND bmo011= tm.bmo011
            IF SQLCA.sqlcode THEN 
               CALL cl_err('','mfg2757',0)
               NEXT FIELD bmo01 
            END IF
            IF not cl_null(g_bmo.bmo05) THEN 
               CALL cl_err('','mfg2760',0)
               NEXT FIELD bmo01 
            END IF
         END IF 
      BEFORE FIELD firm
         IF l_firm_y = 'Y' THEN 
            NEXT FIELD NEXT 
         END IF
 
      AFTER FIELD firm 
         IF cl_null(tm.firm) THEN
             NEXT FIELD firm
         END IF
         LET g_bmq01 = NULL
         SELECT bmq01 INTO g_bmq01 FROM bmq_file WHERE bmq011 = tm.firm
         IF NOT cl_null(g_bmq01) THEN
            #你所輸入的料號已是此料件的正式料號,請重新輸入!
            CALL cl_err(g_bmq01,'abm-115',0)
            NEXT FIELD firm
         END IF
         #FUN-B70060 add
         IF tm.firm[1,1] = ' ' THEN
            CALL cl_err(tm.firm,"aim-671",0)
            NEXT FIELD firm
         END IF
         #FUN-B70060 add--end
         IF g_sma.sma100='Y' AND NOT cl_null(tm.firm) THEN #E-BOM轉P-BOM時料件編號需存料件主檔中
            SELECT COUNT(*) INTO l_cnt FROM ima_file WHERE ima01 = tm.firm
            IF SQLCA.sqlcode OR l_cnt <= 0 THEN
               #E-BOM轉P-BOM時料件編號需存料件主檔中
               CALL cl_err(tm.firm,'abm-110',0)
               NEXT FIELD firm
            END IF
         END IF
         SELECT ima02,ima021 
           INTO l_ima02,l_ima021
           FROM ima_file
          WHERE ima01 = tm.firm
         DISPLAY l_ima02  TO FORMONLY.ima02
         DISPLAY l_ima021 TO FORMONLY.ima021
       
 
      AFTER FIELD edate 
         IF tm.edate IS NOT NULL AND tm.edate <=tm.bdate THEN 
            CALL cl_err(tm.edate,'mfg2604',0)
            NEXT FIELD bdate
         END IF
 
      AFTER FIELD a
         IF tm.a NOT MATCHES "[YN]" THEN
            NEXT FIELD a 
         END IF
 
      AFTER FIELD b
         IF tm.b NOT MATCHES "[YN]" THEN
            NEXT FIELD b
         END IF
 
      AFTER FIELD c
         IF tm.c NOT MATCHES "[YN]" THEN 
            NEXT FIELD c 
         END IF
 
      AFTER FIELD d
         IF tm.d NOT MATCHES "[YN]" THEN
            NEXT FIELD d 
         END IF
 
      AFTER FIELD f
         IF tm.f NOT MATCHES "[YN]" THEN
            NEXT FIELD f 
         END IF
 
      AFTER FIELD e
         IF tm.e NOT MATCHES "[YN]" THEN
            NEXT FIELD e 
         END IF
 
      AFTER INPUT   

         IF tm.bmo06 IS NULL THEN
            LET tm.bmo06=' '
         END IF
         IF INT_FLAG THEN 
            EXIT INPUT 
         END IF
         
        ON ACTION CONTROLP     #查詢條件 
            CASE
               WHEN INFIELD(bmo01) 

                  CALL cl_init_qry_var()
                 #LET g_qryparam.form = 'q_bmo'      #MOD-C20125 mark
                  LET g_qryparam.form = 'q_bmo4'     #MOD-C20125 add
                  LET g_qryparam.default1 = tm.bmo01
                  LET g_qryparam.default1 = tm.bmo011
                  CALL cl_create_qry() RETURNING tm.bmo01,tm.bmo011

                  DISPLAY BY NAME tm.bmo01 
                  DISPLAY BY NAME tm.bmo011 
                  NEXT FIELD bmo01
               WHEN INFIELD(bmo011) 

                  CALL cl_init_qry_var()
                 #LET g_qryparam.form = 'q_bmo'      #MOD-C20125 mark
                  LET g_qryparam.form = 'q_bmo4'     #MOD-C20125 add
                  LET g_qryparam.default1 = tm.bmo01
                  LET g_qryparam.default1 = tm.bmo011
                  CALL cl_create_qry() RETURNING tm.bmo01,tm.bmo011

                  DISPLAY BY NAME tm.bmo01 
                  DISPLAY BY NAME tm.bmo011 
                  NEXT FIELD bmo011
               WHEN INFIELD(firm) 
#FUN-AB0025 -------------------Begin------------------
                #  CALL cl_init_qry_var()
                #  LET g_qryparam.form = 'q_ima'
                #  LET g_qryparam.default1 = tm.firm
                #  CALL cl_create_qry() RETURNING tm.firm
                  CALL q_sel_ima(FALSE, "q_ima", "", tm.firm, "", "", "", "" ,"",'' )  RETURNING tm.firm 
#FUN-AB0025 -------------------End--------------------
                  DISPLAY tm.firm TO FORMONLY.firm
                  NEXT FIELD firm
               OTHERWISE EXIT CASE
             END CASE
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
        ON ACTION locale
            CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_change_lang = TRUE
            EXIT INPUT
        ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
   END INPUT
END FUNCTION
   
FUNCTION p101_b_fill(p_bmo01,p_bmo011,p_levela,p_acode) #做g_bmp資料的填充(abmp101單身) #FUN-560030
  DEFINE   l_sql     LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(900)
           l_ac      LIKE type_file.num5,    #No.FUN-680096 SMALLINT
           p_bmo01   LIKE bmo_file.bmo01,
           p_bmo011  LIKE bmo_file.bmo011,
           p_acode   LIKE bmo_file.bmo06,    #FUN-560030
           p_levela  LIKE type_file.num5     #No.FUN-680096 SMALLINT
 
   IF g_sma.sma100 = 'N' THEN
      LET l_sql = "SELECT 'N',bmp02,bmp16,  '','','','',",
                  "       bmp03 a,bmq05,bmq02,bmq021,bmp03,''   ,bmp28", #FUN-550079  #No.TQC-AB0050 add 别名 
                  "  FROM bmp_file,bmq_file ",
                  " WHERE bmp03 = bmq01 ",
                  "   AND (bmq011 IS NULL OR bmq011= ' ' )",
                  "   AND bmp01 = '",p_bmo01,"'",
                  "   AND bmp011= '",p_bmo011,"'",
                  "   AND bmp28='",p_acode,"'", #FUN-560030
                  " UNION ",
                  "SELECT 'Y',bmp02,bmp16,  '','','','',",
                  "       bmp03 a,ima05,ima02,ima021,bmp03,''   ,bmp28", #FUN-550079   #No.TQC-AB0050 add 别名
                  "   FROM bmp_file,ima_file ",
                  "  WHERE bmp03 = ima01 ",
                  "    AND bmp01 = '",p_bmo01,"'",
                  "    AND bmp011= '",p_bmo011,"'",
                  "   AND bmp28='",p_acode,"'", #FUN-560030
                  "  UNION ",
                  "SELECT 'Y',bmp02,bmp16,  '','','','',",
                  "       bmp03 a,bmq05,bmq02,bmq021,bmq011,''   ,bmp28", #FUN-550079    #No.TQC-AB0050 add 别名
                  "   FROM bmp_file,bmq_file ",
                  "  WHERE bmp03 = bmq01 ",
                  "    AND bmq011 IS NOT NULL  ",
                  "    AND bmq011 != ' ' ",
                  "    AND bmp01 = '",p_bmo01,"'",
                  "    AND bmp011= '",p_bmo011,"'",
                  "   AND bmp28='",p_acode,"'", #FUN-560030
                  #"  ORDER BY 1,8 "   #No.TQC-9A0155 mark
                 #"  ORDER BY bmp03 "  #NO.TQC-9A0155 mod
                  "  ORDER BY a "  #No.TQC-AB0050 mod
    ELSE
      LET l_sql = "SELECT 'Y',bmp02,bmp16,  '','','','',",
                  "       bmp03,ima05,ima02,ima021,bmp03,''   ,bmp28", #FUN-550079
                  "   FROM bmp_file LEFT OUTER JOIN ima_file ON bmp03=ima01 ",   #No.TQC-9A0155 mod
                  "   WHERE  bmp01 = '",p_bmo01,"'",
                  "    AND bmp011= '",p_bmo011,"'",
                  "   AND bmp28='",p_acode,"'", #FUN-560030
                  "  ORDER BY bmp03 "     #No.TQC-9A0155 mod
    END IF
 
    PREPARE p101_bmp FROM l_sql 
	DECLARE p101_bmpcur
        CURSOR WITH HOLD FOR p101_bmp
 
    CALL g_bmp.clear()
    CALL b_bmp.clear()
 
    LET l_ac = 1
    FOREACH p101_bmpcur INTO b_bmp[l_ac].*,g_bmp[l_ac].*
       IF SQLCA.sqlcode THEN 
          LET g_showmsg=p_bmo01,"/",p_bmo011,"/",p_acode
          CALL s_errmsg("bmp01,bmp011,bmp28",g_showmsg,"p101_bmpcur",SQLCA.sqlcode,0)
          EXIT FOREACH
       END IF
       LET g_bmp[l_ac].bmp01 = p_bmo01
       LET g_bmp[l_ac].v1    = p_bmo011
       LET g_bmp[l_ac].levela = p_levela
 
       SELECT ima02,ima021 
         INTO g_bmp[l_ac].desc1,g_bmp[l_ac].desc11
         FROM ima_file
        WHERE ima01 = g_bmp[l_ac].bmp01
       IF SQLCA.sqlcode = 100 THEN
           SELECT bmq02,bmq021 
             INTO g_bmp[l_ac].desc1,g_bmp[l_ac].desc11
             FROM bmq_file
            WHERE bmq01 = g_bmp[l_ac].bmp01
       END IF
       IF g_sma.sma100 = 'Y' THEN
          IF cl_null(g_bmp[l_ac].desc2) THEN
             SELECT bmq02,bmq021 INTO g_bmp[l_ac].desc2,g_bmp[l_ac].desc22
               FROM bmq_file WHERE bmq01 = g_bmp[l_ac].bmp03
          END IF
       END IF
 
       LET l_ac = l_ac + 1
      IF l_ac  > g_max_rec THEN
         CALL s_errmsg("","","",9035,0)
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_bmp.deleteElement(l_ac)
    CALL SET_COUNT(l_ac-1)               #告訴I.單身筆數
    LET g_rec_b = l_ac -1
    LET g_ac = g_rec_b
    CALL p101_array()
    IF INT_FLAG THEN 
        LET g_exit_while = 'N'
        LET g_success = 'N'
        RETURN
    END IF
END FUNCTION
   
FUNCTION p101_array() #INPUT abmp101.per 的單身正式料號
  DEFINE  l_ac_t         LIKE type_file.num5,   #No.FUN-680096 SMALLINT
          l_exit_sw      LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
          l_cnt          LIKE type_file.num5,   #No.FUN-680096 SMALLINT
          l_n            LIKE type_file.num5,   #目前處理的ARRAY CNT    #No.FUN-680096 SMALLINT
          l_ac           LIKE type_file.num5,   #目前處理的ARRAY CNT    #No.FUN-680096 SMALLINT
          l_sl           LIKE type_file.num5,   #目前處理的SCREEN LINE
          l_allow_insert LIKE type_file.num5,   #No.FUN-680096 SMALLINT
          l_allow_delete LIKE type_file.num5    #No.FUN-680096 SMALLINT
 
   CALL cl_opmsg('s')
   LET l_ac_t = 0
   WHILE TRUE
     LET l_exit_sw = "y"                #正常結束,除非 ^N
     LET l_allow_insert = FALSE
     LET l_allow_delete = FALSE
     INPUT ARRAY g_bmp WITHOUT DEFAULTS FROM s_bmp.*
              ATTRIBUTE(INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE ROW
          LET l_ac = ARR_CURR()
          LET l_sl = SCR_LINE()
          LET l_n  = ARR_COUNT()
          LET g_bmp_t.* = g_bmp[l_ac].*

 
 
      AFTER FIELD item
         IF cl_null(g_bmp[l_ac].item) THEN NEXT FIELD item END IF
         #FUN-B70060 add
         IF g_bmp[l_ac].item[1,1] = ' ' THEN
            CALL cl_err(g_bmp[l_ac].item,"aim-671",1)
            NEXT FIELD item
         END IF
         #FUN-B70060 add--end
         IF (NOT cl_null(g_bmp[l_ac].bmp03)) THEN
             LET g_bmq01 = NULL

             LET g_bmq01=NULL
             SELECT bmq011 INTO g_bmq01 FROM bmq_file   #MOD-6B0147 modify
                WHERE bmq01=g_bmp[l_ac].bmp03
             IF (NOT cl_null(g_bmq01)) AND (g_bmq01<>g_bmp[l_ac].item) THEN
                CALL cl_err(g_bmp[l_ac].bmp03,'abm-117',1)
                NEXT FIELD item
             END IF   
            #kim ... 正式料號只能由一個測試料號轉來
             LET l_cnt=0
             SELECT COUNT(*) INTO l_cnt FROM bmq_file
                WHERE bmq011=g_bmp[l_ac].item AND bmq01<>g_bmp[l_ac].bmp03
             IF l_cnt>0 THEN
                CALL cl_err(g_bmp[l_ac].bmp03,'abm-118',1)
                NEXT FIELD item
             END IF
         END IF
         IF (g_bmp[l_ac].item IS NOT NULL OR g_bmp[l_ac].item != ' ') THEN
             IF g_sma.sma100='Y' AND NOT cl_null(g_bmp[l_ac].item) THEN #E-BOM轉P-BOM時料件編號需存料件主檔中
                 SELECT COUNT(*) INTO l_cnt
                   FROM ima_file
                 WHERE ima01 = g_bmp[l_ac].item
                 IF SQLCA.sqlcode OR l_cnt <= 0 THEN
                     #E-BOM轉P-BOM時料件編號需存料件主檔中
                     CALL cl_err(g_bmp[l_ac].item,'abm-110',1) #MOD-590193 0->1
                     NEXT FIELD item
                 END IF
             END IF
         END IF
 
      AFTER ROW
         IF INT_FLAG THEN EXIT INPUT  END IF

         IF g_sma.sma100='Y' AND NOT cl_null(g_bmp[l_ac].item) THEN #E-BOM轉P-BOM時料件編號需存料件主檔中
             SELECT COUNT(*) INTO l_cnt
               FROM ima_file
             WHERE ima01 = g_bmp[l_ac].item
             IF SQLCA.sqlcode OR l_cnt <= 0 THEN
                 #E-BOM轉P-BOM時料件編號需存料件主檔中
                 CALL cl_err(g_bmp[l_ac].item,'abm-110',0)
                 NEXT FIELD item
             END IF
         END IF
           
        ON ACTION CONTROLP     #查詢條件 
            CASE
               WHEN INFIELD(item)
#FUN-AB0025 ------------------Begin----------------------
                #  CALL cl_init_qry_var()
                #  LET g_qryparam.form = 'q_ima'
                #  LET g_qryparam.default1 = g_bmp[l_ac].item
                #  CALL cl_create_qry() RETURNING g_bmp[l_ac].item
                   CALL q_sel_ima(FALSE, "q_ima", "", g_bmp[l_ac].item,"", "", "", "" ,"",'' )  RETURNING g_bmp[l_ac].item
#FUN-AB0025 ------------------End-------------------------
                   DISPLAY g_bmp[l_ac].item TO item             #No.MOD-490371
                  NEXT FIELD item
               OTHERWISE EXIT CASE
             END CASE
 
        ON ACTION expand_rep_sub
                    IF b_bmp[l_ac].bmp16 MATCHES "[12]" AND tm.d = 'Y' THEN
                        CALL p101s_b_fill(g_bmp[l_ac].*,b_bmp[l_ac].bmp02)
                        NEXT FIELD item
                    END IF
 
         AFTER INPUT
             FOR l_ac = 1 TO g_bmp.getLength()
                 IF cl_null(g_bmp[l_ac].bmp03) THEN
                      EXIT FOR
                 END IF
                 IF b_bmp[l_ac].bmp16 MATCHES "[12]" AND tm.d = 'Y' THEN
                     CALL p101s_b_fill(g_bmp[l_ac].*,b_bmp[l_ac].bmp02)
                 END IF
                 SELECT COUNT(*) INTO g_cnt FROM firm_tmp
                  WHERE bmp03 = g_bmp[l_ac].bmp03
                 IF g_cnt = 0 THEN
                     INSERT INTO firm_tmp VALUES (g_bmp[l_ac].bmp03,g_bmp[l_ac].item)
                 ELSE
                     UPDATE firm_tmp
                        SET item = g_bmp[l_ac].item
                      WHERE bmp03 = g_bmp[l_ac].bmp03
                 END IF
                 INSERT INTO bom_tmp VALUES(g_bmp[l_ac].*)
             END FOR
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
    
      ON ACTION controls                          #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("g01","AUTO")   #No.FUN-6B0033
 
   END INPUT
   
      IF l_exit_sw = "y" THEN
          EXIT WHILE                     #ESC 或 DEL 結束 INPUT
      ELSE
          CONTINUE WHILE                 #^N 結束 INPUT
      END IF
  END WHILE
END FUNCTION
   
FUNCTION p101_ins(p_bmo01,p_bmo011,p_firm,p_acode) #INSERT ,UPDATE 相關要移轉到正式BOM的資料
   DEFINE  # l_time LIKE type_file.chr8        #No.FUN-6A0060
          l_sql     LIKE type_file.chr1000,   # RDSQL STATEMENT        #No.FUN-680096 VARCHAR(600)
          l_bmp     RECORD LIKE bmp_file.*,
          l_bec     RECORD LIKE bec_file.*,
          l_k       LIKE type_file.num5,      #No.FUN-680096 SMALLINT
          l_cnt     LIKE type_file.num5,      #No.FUN-680096 SMALLINT
          p_bmo01   LIKE bmo_file.bmo01,
          p_bmo011  LIKE bmo_file.bmo011,
          p_firm    LIKE ima_file.ima01,
          p_acode   LIKE bmo_file.bmo06,      #FUN-550079
          l_ima910  LIKE ima_file.ima910      #FUN-550079
 
     IF p_acode IS NULL THEN
       LET p_acode=' '
     END IF
 
     #-->更新 工程BOM單頭檔(bmo_file) 
      UPDATE bmo_file SET bmo05 = tm.bdate    #生效日期
              WHERE bmo01 = p_bmo01
                AND bmo011 = p_bmo011 #FUN-550079
                AND bmo06 = p_acode #FUN-560030
           IF SQLCA.sqlerrd[3] = 0 THEN 
              LET g_showmsg=p_bmo01,"/",p_bmo011,"/",p_acode
              CALL s_errmsg("bmo01,bmo011,bmo06",g_showmsg,"ckp#01",SQLCA.sqlcode,1)
              LET g_success='N'
              RETURN
           END IF
 
     #-->更新 工程BOM單身檔(bmp_file)(生效日期) 
      UPDATE bmp_file SET bmp04 = tm.bdate    #生效日期
              WHERE bmp01 =p_bmo01
                AND bmp011=p_bmo011
                AND bmp28=p_acode #FUN-560030
           IF SQLCA.sqlerrd[3] = 0 THEN 
              LET g_showmsg=p_bmo01,"/",p_bmo011,"/",p_acode
              CALL s_errmsg("bmp01,bmp011,bmp28",g_showmsg,"ckp#1.2",SQLCA.sqlcode,1)
              LET g_success='N'
              RETURN
           END IF
 
     #-->產生BOM 單頭檔(bma_file)
       INSERT INTO bma_file (bma01,bma02,bma03,bma04,bma05,bmauser,bmagrup,  #No.MOD-470041
                            bmamodu,bmadate,bmaacti,bma06,bma10,bmaoriu,bmaorig)  #FUN-550079  #No.MOD-960298
           VALUES(p_firm,g_bmo.bmo02,g_bmo.bmo03,g_bmo.bmo04,NULL,g_bmo.bmouser, 
                  g_bmo.bmogrup,g_bmo.bmomodu,g_bmo.bmodate,g_bmo.bmoacti,p_acode,'0', g_user, g_grup)  #FUN-550079  #No.MOD-960298      #No.FUN-980030 10/01/04  insert columns oriu, orig
          IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
             LET g_showmsg=p_firm,"/",p_acode
             CALL s_errmsg("bma01,bma06",g_showmsg,"ckp#02",SQLCA.sqlcode,1)
             LET g_success = 'N'
             RETURN 
          END IF 
      SELECT COUNT(*) INTO g_cnt FROM ima_file WHERE ima01=p_firm
      IF g_cnt = 0 THEN
         CALL p101_ima(p_bmo01,p_firm,p_acode) #FUN-550079
      END IF
      CALL p101_up_bmq011(p_bmo01,p_firm) #BugNo:6542
      IF g_success ='N' THEN RETURN END IF
 
      FOR l_k = 1 TO g_rec_b
          IF g_success = "N" THEN 
             LET g_totsuccess = "N"
             LET g_success = "Y"
          END IF
        
          #因為在arry 中的測試料號可能會改成正式料號(可能和正式料和不同),
          #但必須要保留原來的元件料號,後續要 insert 的其他檔案必須以原來的
          #元件料號才能取到資料,
          SELECT  * INTO l_bmp.*  FROM bmp_file
                                 WHERE bmp01=tm.bmo01 AND bmp02=b_bmp[l_k].bmp02 AND bmp03=g_bmp[l_k].bmp03 AND bmp011=tm.bmo011 AND bmp28=tm.bmo06    #No.TQC-950134
          IF SQLCA.sqlcode THEN
             CALL s_errmsg("","","sel bmp",SQLCA.sqlcode,1)
             LET g_success = 'N' 
             CONTINUE FOR
          END IF
          LET l_bmp.bmp01   = p_firm    
          LET l_bmp.bmp04   = tm.bdate
          LET l_bmp.bmp05   = tm.edate
          LET l_bmp.bmpmodu = g_user   
          LET l_bmp.bmpdate = g_today  
          LET l_bmp.bmpcomm = 'abmp101'
          LET l_bmp.bmp28 = p_acode #FUN-550079 
          IF cl_null(l_bmp.bmp02)  THEN
             LET l_bmp.bmp02=' '
          END IF
          #-->產生(bmb_file)
           INSERT INTO bmb_file (bmb01,bmb02,bmb03,bmb04,bmb05,bmb06,  #No:BUG-470041  #No.MOD-480013
                                bmb07,bmb08,bmb081,bmb082,bmb09,bmb10,bmb10_fac,bmb10_fac2,  #TQC-AC0183 add bmb081,bmb082
                                bmb11,bmb13,bmb14,bmb15,bmb16,bmb17,bmb18,
                                bmb19,bmb20,bmb21,bmb22,bmb23,bmb24,bmb25,
                                 bmb26,bmb27,bmb28,bmbmodu,bmbdate,bmbcomm,bmb29,bmb30,bmb33)  #No.MOD-480013  #FUN-550079  #FUN-560030 #No.FUN-830116
              VALUES(l_bmp.bmp01,l_bmp.bmp02,g_bmp[l_k].item,l_bmp.bmp04,
                     l_bmp.bmp05,l_bmp.bmp06,l_bmp.bmp07,l_bmp.bmp08,l_bmp.bmp081,l_bmp.bmp082,  #TQC-AC0183 add bmp081,bmp082
                     l_bmp.bmp09,l_bmp.bmp10,l_bmp.bmp10_fac,l_bmp.bmp10_fac2,
                     l_bmp.bmp11,l_bmp.bmp13,l_bmp.bmp14,l_bmp.bmp15,
                     l_bmp.bmp16,l_bmp.bmp17,l_bmp.bmp18,l_bmp.bmp19,
                     l_bmp.bmp20,l_bmp.bmp21,l_bmp.bmp22,l_bmp.bmp23,
                     l_bmp.bmp24,l_bmp.bmp25,l_bmp.bmp26,l_bmp.bmp27,
                     0,g_user,g_today,'abmp101',l_bmp.bmp28,l_bmp.bmp29,0)  #FUN-550079  #FUN-560030 #No.FUN-830116
              IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                 LET g_showmsg=l_bmp.bmp01,"/",l_bmp.bmp02,"/",g_bmp[l_k].item,"/",l_bmp.bmp04,"/",l_bmp.bmp28
                 LET g_success = 'N'
                 CONTINUE FOR
              END IF     
 
          LET l_ima910 = g_bmp[l_k].bmp28
          IF l_ima910 IS NULL THEN
            LET l_ima910=' '
          END IF
 
          #-->產生(ima_file)
          SELECT COUNT(*) INTO g_cnt FROM ima_file 
           WHERE ima01=g_bmp[l_k].item
          IF b_bmp[l_k].sou = 'N' AND g_cnt = 0 THEN    
             CALL p101_ima(l_bmp.bmp03,g_bmp[l_k].item,l_ima910) #FUN-550079
          END IF
          CALL p101_up_bmq011(l_bmp.bmp03,g_bmp[l_k].item)
          IF g_success ='N' THEN 
             CONTINUE FOR
          END IF
 
          #-->低階碼可否部份重計
          IF g_sma.sma845='Y'
          THEN #LET g_success='Y'  #No.FUN-710014
               #CALL s_uima146(g_bmp[l_k].item)  #CHI-D10044
               CALL s_uima146(g_bmp[l_k].item,0)  #CHI-D10044
               MESSAGE ""
               CALL ui.Interface.refresh()
          END IF
 
          #-->產生插件位置(bmt_file) --> copy from bmu_file TO bmt_file
          IF tm.a = 'Y' THEN
              CALL p101_ins_bmt(l_bmp.*,g_bmp[l_k].item,p_bmo01,p_bmo011,p_firm,p_acode) #FUN-550079
              IF g_success ='N' THEN 
                 CONTINUE FOR
              END IF
          END IF
 
          #-->產生元件廠牌(bml_file) --> copy from bel_file TO bml_file
          IF tm.c = 'Y' THEN
              CALL p101_ins_bml(l_bmp.*,g_bmp[l_k].item,p_bmo01,p_bmo011,p_firm)
              IF g_success ='N' THEN 
                 CONTINUE FOR
              END IF
          END IF
 
          #-->產生BOM說明檔(bmc_file) -->copy from bec_file TO bmc_file
          IF tm.a = 'Y' THEN
              CALL p101_ins_bmc(l_bmp.*,g_bmp[l_k].item,p_bmo01,p_bmo011,p_firm,p_acode) #FUN-550079
              IF g_success ='N' THEN 
                 CONTINUE FOR
              END IF
          END IF
 
          #-->產生取替代檔(bmd_file) -->copy from bed_file TO bmd_file
          IF tm.d = 'Y' THEN
              CALL p101_ins_bmd(l_bmp.*,g_bmp[l_k].item,p_bmo01,p_bmo011,p_firm,l_bmp.bmp28) #FUN-550079
              IF g_success ='N' THEN 
                 CONTINUE FOR
              END IF
          END IF
 
       END FOR     
       IF g_totsuccess = 'N' THEN
          LET g_success = 'N'
       END IF
       #-->產生產品結構連產品資料檔(bmm_file) -->copy from bmn_file TO bmm_file
       CALL p101_ins_bmm(p_bmo01,p_bmo011,p_firm,l_ima910) #FUN-550079
END FUNCTION
   
FUNCTION p101_ima(p_item,p_firm,p_acode)  #FUN-550079 加 特性代碼 參數
  DEFINE  p_item   LIKE ima_file.ima01,
          p_firm   LIKE ima_file.ima01,
          p_acode  LIKE ima_file.ima910, #FUN-550079
          l_bmq    RECORD LIKE bmq_file.*,
          l_ima    RECORD LIKE ima_file.*,
          l_ans    LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          l_msg    LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(100)
  DEFINE  l_imaicd RECORD LIKE imaicd_file.* #No.FUN-7B0018
  DEFINE  l_flag   LIKE type_file.chr1       #No.FUN-7B0018
  
  #--->取測試料件基本資料
  SELECT * INTO l_bmq.* FROM bmq_file WHERE bmq01 = p_item  
  IF SQLCA.sqlcode THEN RETURN END IF 
 
  IF p_acode IS NULL THEN
    LET p_acode=' '
  END IF
 
  INITIALIZE l_ima.* TO NULL 
  IF cl_null(l_bmq.bmq06) THEN 
      #測試料件沒有輸入分群碼(bmq06),是否確定執行?
      ERROR ""
      IF NOT cl_confirm('abm-009') THEN #不執行
          LET g_success = 'N'
          RETURN
      ELSE
          #要執行
          CALL cl_wait()
          LET l_ima.ima01 = p_firm
          LET l_ima.ima02 = l_bmq.bmq02
          LET l_ima.ima021= l_bmq.bmq021
          LET l_ima.ima05 = l_bmq.bmq05
          LET l_ima.ima06 = l_bmq.bmq06
          LET l_ima.ima08 = l_bmq.bmq08
          LET l_ima.ima09 = l_bmq.bmq09
          LET l_ima.ima10 = l_bmq.bmq10
          LET l_ima.ima11 = l_bmq.bmq11
          LET l_ima.ima12 = l_bmq.bmq12
          LET l_ima.ima15 = l_bmq.bmq15
          LET l_ima.ima25 = l_bmq.bmq25
          LET l_ima.ima31 = l_bmq.bmq31
          LET l_ima.ima37 = l_bmq.bmq37
          LET l_ima.ima44 = l_bmq.bmq44
          LET l_ima.ima53 = l_bmq.bmq53
          LET l_ima.ima531= l_bmq.bmq531
          LET l_ima.ima55 = l_bmq.bmq55
          LET l_ima.ima63 = l_bmq.bmq63
          LET l_ima.ima91 = l_bmq.bmq91
          LET l_ima.ima103= l_bmq.bmq103
          LET l_ima.ima105= l_bmq.bmq105
          LET l_ima.ima107= l_bmq.bmq107
          LET l_ima.ima147= l_bmq.bmq147
          LET l_ima.ima903= l_bmq.bmq903
          LET l_ima.ima905= 'N'
          LET l_ima.ima31_fac= l_bmq.bmq31_fac
          LET l_ima.ima44_fac= l_bmq.bmq44_fac
          LET l_ima.ima55_fac= l_bmq.bmq55_fac
          LET l_ima.ima63_fac= l_bmq.bmq63_fac
          LET l_ima.ima86 = l_bmq.bmq25
          LET l_ima.ima07 = 'A'
          LET l_ima.ima14 = 'N'
          LET l_ima.ima16 = 99
          LET l_ima.ima18 = 0
          LET l_ima.ima20 = 0
          LET l_ima.ima22 = 0
#          LET l_ima.ima26 = 0    #FUN-A20044
#          LET l_ima.ima262 = 0   #FUN-A20044
#          LET l_ima.ima261 = 0   #FUN-A20044
          LET l_ima.ima27 = 0
          LET l_ima.ima271 = 0
          LET l_ima.ima28 = 0
          LET l_ima.ima29 = g_sma.sma30
          LET l_ima.ima30 = g_sma.sma30
          LET l_ima.ima32 = 0
          LET l_ima.ima33 = 0
          LET l_ima.ima38 = 0
          LET l_ima.ima130 ='1' 
          LET l_ima.ima140 ='N' 
          LET l_ima.ima121 =0 LET l_ima.ima122 =0 LET l_ima.ima123 =0
          LET l_ima.ima124 =0 LET l_ima.ima125 =0 LET l_ima.ima126 =0
          LET l_ima.ima127 =0 LET l_ima.ima128 =0 
          LET l_ima.ima40 = 0
          LET l_ima.ima41 = 0
          LET l_ima.ima42 = '0'
          LET l_ima.ima45 = 0
          LET l_ima.ima46 = 0
          LET l_ima.ima47 = 0
          LET l_ima.ima48 = 0
          LET l_ima.ima49 = 0
          LET l_ima.ima491 = 0
          LET l_ima.ima50 = 0
          LET l_ima.ima51 = 1
          LET l_ima.ima52 = 1
          LET l_ima.ima56 = 1
          LET l_ima.ima561 = 1 
          LET l_ima.ima562 = 0
          LET l_ima.ima58 = 0
          LET l_ima.ima59 = 0
          LET l_ima.ima60 = 0
          LET l_ima.ima61 = 0
          LET l_ima.ima62 = 0
          LET l_ima.ima64  = 0
          LET l_ima.ima641 = 0
          LET l_ima.ima65  = 0
          LET l_ima.ima66  = 0
          LET l_ima.ima68  = 0
          LET l_ima.ima69  = 0
          LET l_ima.ima70  = 'N'
          LET l_ima.ima71  = 0
          LET l_ima.ima72  = 0
          LET l_ima.ima75  = ''
          LET l_ima.ima76  = ''
          LET l_ima.ima77  = 0
          LET l_ima.ima78  = 0
          LET l_ima.ima80  = 0
          LET l_ima.ima81  = 0
          LET l_ima.ima82  = 0
          LET l_ima.ima83  = 0
          LET l_ima.ima84  = 0
          LET l_ima.ima85  = 0
          LET l_ima.ima910 = p_acode   #FUN-550079  #MOD-920026 mark;
          LET l_ima.ima915 = '0'       #MOD-920026 add
          LET l_ima.ima911 = 'N'       #No.MOD-780061 add
          LET l_ima.ima94  = ''
          LET l_ima.ima95  = 0
          LET l_ima.ima96  = 0
          LET l_ima.ima97  = 0
          LET l_ima.ima98  = 0
          LET l_ima.ima99  = 0
          LET l_ima.ima100 = 'N'
          LET l_ima.ima101 = '1'
          LET l_ima.ima102 = 0
          LET l_ima.ima139 = 'N' 
          LET l_ima.ima852 = 'N'
          LET l_ima.ima853 = 'N'
          LET l_ima.ima86_fac = 1
          LET l_ima.ima871 = 0
          LET l_ima.ima873 = 0
          LET l_ima.ima99  = 0
          LET l_ima.ima93  = "NNNNNNNN"
          LET l_ima.imauser = g_user
          LET l_ima.imagrup = g_grup  
          LET l_ima.imadate = g_today
          LET l_ima.ima901 = g_today               #料件建檔日期
          LET l_ima.imaacti='P'                    #MOD-9C0033 Y modify P
          LET l_ima.ima1010='0'                    #MOD-9C0033 add 
      END IF
  ELSE    #bmq06 IS NOT NULL
      SELECT *  INTO g_imz.*
        FROM  imz_file
       WHERE imz01   = l_bmq.bmq06
         AND imzacti = 'Y'
      IF NOT STATUS THEN 
          IF g_imz.imz99 IS NULL THEN LET g_imz.imz99 = 0 END IF
          IF g_imz.imz17 IS NULL THEN LET g_imz.imz17 = g_imz.imz31 END IF
 
          LET l_ima.ima01 = p_firm
          LET l_ima.ima02 = l_bmq.bmq02
          LET l_ima.ima021= l_bmq.bmq021
          LET l_ima.ima05 = l_bmq.bmq05
          LET l_ima.ima06 = l_bmq.bmq06
          LET l_ima.ima08 = l_bmq.bmq08
          LET l_ima.ima09 = l_bmq.bmq09
          LET l_ima.ima10 = l_bmq.bmq10
          LET l_ima.ima11 = l_bmq.bmq11
          LET l_ima.ima12 = l_bmq.bmq12
          LET l_ima.ima15 = l_bmq.bmq15
          LET l_ima.ima25 = l_bmq.bmq25
          LET l_ima.ima31 = l_bmq.bmq31
          LET l_ima.ima37 = l_bmq.bmq37
          LET l_ima.ima44 = l_bmq.bmq44
          LET l_ima.ima53 = l_bmq.bmq53
          LET l_ima.ima531= l_bmq.bmq531
          LET l_ima.ima55 = l_bmq.bmq55
          LET l_ima.ima63 = l_bmq.bmq63
          LET l_ima.ima91 = l_bmq.bmq91
          LET l_ima.ima103= l_bmq.bmq103
          LET l_ima.ima105= l_bmq.bmq105
          LET l_ima.ima107= l_bmq.bmq107 #BugNo:6165 插件位置
          LET l_ima.ima147= l_bmq.bmq147 #BugNo:6542 插件位置
          LET l_ima.ima903= l_bmq.bmq903
          LET l_ima.ima905= 'N'
          LET l_ima.ima31_fac= l_bmq.bmq31_fac
          LET l_ima.ima44_fac= l_bmq.bmq44_fac
          LET l_ima.ima55_fac= l_bmq.bmq55_fac
          LET l_ima.ima63_fac= l_bmq.bmq63_fac
          #***************
          #利用分群碼bmq06找到imz_file的相關資料給ima_file預設值 
          #**************
          LET l_ima.ima03 = g_imz.imz03
          LET l_ima.ima04 = g_imz.imz04
          LET l_ima.ima07 = g_imz.imz07
          LET l_ima.ima14 = g_imz.imz14
          LET l_ima.ima16 = 99
          LET l_ima.ima18 = 0
          LET l_ima.ima19 = g_imz.imz19
          LET l_ima.ima20 = 0
          LET l_ima.ima21 = g_imz.imz21
          LET l_ima.ima22 = 0
          LET l_ima.ima23 = g_imz.imz23
           LET l_ima.ima24 = 'N' #MOD-540087
#          LET l_ima.ima26 = 0   #FUN-A20044
#          LET l_ima.ima262= 0   #FUN-A20044
#          LET l_ima.ima261= 0   #FUN-A20044
          LET l_ima.ima27 = g_imz.imz27
          LET l_ima.ima27 = s_digqty(l_ima.ima27,l_ima.ima25) #FUN-BB0083
          LET l_ima.ima271= 0
          LET l_ima.ima28 = g_imz.imz28
          LET l_ima.ima28 = s_digqty(l_ima.ima28,l_ima.ima25) #FUN-BB0083
          LET l_ima.ima29 = g_sma.sma30
          LET l_ima.ima30 = g_sma.sma30
          LET l_ima.ima32 = 0
          LET l_ima.ima33 = 0
          LET l_ima.ima34 = g_imz.imz34
          LET l_ima.ima35 = g_imz.imz35
          LET l_ima.ima36 = g_imz.imz36
          LET l_ima.ima38 = g_imz.imz38
          LET l_ima.ima38 = s_digqty(l_ima.ima38,l_ima.ima25) #FUN-BB0083
          LET l_ima.ima39 = g_imz.imz39
          LET l_ima.ima130='1' 
          LET l_ima.ima140='N' 
          LET l_ima.ima121=0 LET l_ima.ima122 =0 LET l_ima.ima123 =0
          LET l_ima.ima124=0 LET l_ima.ima125 =0 LET l_ima.ima126 =0
          LET l_ima.ima127=0 LET l_ima.ima128 =0 
          LET l_ima.ima40 = 0
          LET l_ima.ima41 = 0
          LET l_ima.ima42 = g_imz.imz42
          LET l_ima.ima43 = g_imz.imz43
          LET l_ima.ima45 = g_imz.imz45
          LET l_ima.ima45 = s_digqty(l_ima.ima45,l_ima.ima44) #FUN-BB0083
          LET l_ima.ima46 = g_imz.imz46
          LET l_ima.ima46 = s_digqty(l_ima.ima46,l_ima.ima44) #FUN-BB0083
          LET l_ima.ima47 = g_imz.imz47
          LET l_ima.ima48 = g_imz.imz48
          LET l_ima.ima49 = g_imz.imz49
          LET l_ima.ima491= g_imz.imz491
          LET l_ima.ima50 = g_imz.imz50
          LET l_ima.ima51 = g_imz.imz51
          LET l_ima.ima51 = s_digqty(l_ima.ima51,l_ima.ima44) #FUN-BB0083
          LET l_ima.ima52 = g_imz.imz52
          LET l_ima.ima52 = s_digqty(l_ima.ima52,l_ima.ima44) #FUN-BB0083
          LET l_ima.ima54 = g_imz.imz54
          LET l_ima.ima56 = g_imz.imz56
          LET l_ima.ima56 = s_digqty(l_ima.ima56,l_ima.ima55) #FUN-BB0083
          LET l_ima.ima561= g_imz.imz561
          LET l_ima.ima561= s_digqty(l_ima.ima561,l_ima.ima55) #FUN-BB0083
          LET l_ima.ima562= g_imz.imz562
          LET l_ima.ima571= g_imz.imz571
          LET l_ima.ima58 = 0
          LET l_ima.ima59 = g_imz.imz59
          LET l_ima.ima60 = g_imz.imz60
          LET l_ima.ima61 = g_imz.imz61
          LET l_ima.ima62 = g_imz.imz62
          LET l_ima.ima64 = g_imz.imz64
          LET l_ima.ima64 = s_digqty(l_ima.ima64,l_ima.ima63) #FUN-BB0083
          LET l_ima.ima641= g_imz.imz641
          LET l_ima.ima641= s_digqty(l_ima.ima641,l_ima.ima63) #FUN-BB0083
          LET l_ima.ima65 = g_imz.imz65
          LET l_ima.ima65 = s_digqty(l_ima.ima65,l_ima.ima25) #FUN-BB0083
          LET l_ima.ima66 = g_imz.imz66
          LET l_ima.ima67 = g_imz.imz67
          LET l_ima.ima68 = g_imz.imz68
          LET l_ima.ima69 = g_imz.imz69
          LET l_ima.ima70 = g_imz.imz70
          LET l_ima.ima71 = g_imz.imz71
          LET l_ima.ima72 = 0
          LET l_ima.ima75 = ''
          LET l_ima.ima76 = ''
          LET l_ima.ima77 = 0
          LET l_ima.ima78 = 0
          LET l_ima.ima80 = 0
          LET l_ima.ima81 = 0
          LET l_ima.ima82 = 0
          LET l_ima.ima83 = 0
          LET l_ima.ima84 = 0
          LET l_ima.ima85 = 0
          LET l_ima.ima852= 'N'
          LET l_ima.ima853= 'N'
          LET l_ima.ima86 = g_imz.imz86
          LET l_ima.ima86_fac = g_imz.imz86_fac
          LET l_ima.ima87 = g_imz.imz87
          LET l_ima.ima871= g_imz.imz871
          LET l_ima.ima872= g_imz.imz872
          LET l_ima.ima873= g_imz.imz873
          LET l_ima.ima874= g_imz.imz874
          LET l_ima.ima88 = g_imz.imz88
          LET l_ima.ima88 = s_digqty(l_ima.ima88,l_ima.ima44) #FUN-BB0083
          LET l_ima.ima89 = g_imz.imz89
          LET l_ima.ima90 = g_imz.imz90
          LET l_ima.ima910 = p_acode     #FUN-550079  #MOD-920026 mark;
          LET l_ima.ima915= g_imz.imz72  #MOD-920026 add
          IF cl_null(l_ima.ima915) THEN LET l_ima.ima915='0' END IF #MOD-920026 add
          LET l_ima.ima911 = 'N'       #No.MOD-780061 add
          LET l_ima.ima93 = "NNNNNNNN"
          LET l_ima.ima94 = ''
          LET l_ima.ima95 = 0
          LET l_ima.ima96 = 0
          LET l_ima.ima97 = 0
          LET l_ima.ima98 = 0
          LET l_ima.ima99 = g_imz.imz99
          LET l_ima.ima99 = s_digqty(l_ima.ima99,l_ima.ima44) #FUN-BB0083
          LET l_ima.ima100= 'N'
          LET l_ima.ima101= '1'
          LET l_ima.ima102= 0
          LET l_ima.ima139= 'N' 
          LET l_ima.ima601= 1        #No.FUN-840194 
          LET l_ima.imauser= g_user
          LET l_ima.imagrup= g_grup  
          LET l_ima.imadate= g_today
          LET l_ima.ima901 = g_today               #料件建檔日期
          LET l_ima.imaacti='P'                    #MOD-9C0033 Y modify P
          LET l_ima.ima1010='0'                    #MOD-9C0033 add 
      END IF
  END IF
 
#  IF cl_null(l_ima.ima26 ) THEN LET l_ima.ima26  = 0 END IF   #FUN-A20044
#  IF cl_null(l_ima.ima261) THEN LET l_ima.ima261 = 0 END IF   #FUN-A20044
#  IF cl_null(l_ima.ima262) THEN LET l_ima.ima262 = 0 END IF   #FUN-A20044
  IF cl_null(l_ima.ima915) THEN LET l_ima.ima915 = '0' END IF
  IF cl_null(l_ima.ima916) THEN LET l_ima.ima916 = g_plant END IF
  IF cl_null(l_ima.ima150) THEN LET l_ima.ima150 = '0' END IF
  IF cl_null(l_ima.ima151) THEN LET l_ima.ima151 = 'N' END IF
  IF cl_null(l_ima.ima152) THEN LET l_ima.ima152 = '0' END IF
  IF cl_null(l_ima.ima926) THEN LET l_ima.ima926 = 'N' END IF
 
  IF cl_null(l_ima.ima918) THEN LET l_ima.ima918 = 'N' END IF
  IF cl_null(l_ima.ima919) THEN LET l_ima.ima919 = 'N' END IF
  IF cl_null(l_ima.ima921) THEN LET l_ima.ima921 = 'N' END IF
  IF cl_null(l_ima.ima922) THEN LET l_ima.ima922 = 'N' END IF
  IF cl_null(l_ima.ima924) THEN LET l_ima.ima924 = 'N' END IF
  IF cl_null(l_ima.ima926) THEN LET l_ima.ima926 = 'N' END IF
  #-->產生料件基本資料
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
  #No.TQC-AB0050--begin
  IF cl_null(l_ima.ima022) THEN 
     LET l_ima.ima022 =0 
  END IF
  LET l_ima.ima120=' ' 
  #No.TQC-AB0050--end
  LET l_ima.ima927='N'   #No:FUN-AA0014
#FUN-C20065 ----------Begin-----------
  IF cl_null(l_ima.ima159) THEN
     LET l_ima.ima159 = '3'
  END IF 
#FUN-C20065 ----------End-------------
  IF cl_null(l_ima.ima928) THEN LET l_ima.ima928 = 'N' END IF      #TQC-C20131  add
  IF cl_null(l_ima.ima160) THEN LET l_ima.ima160 = 'N' END IF      #FUN-C50036  add
  INSERT INTO ima_file VALUES(l_ima.*)
  IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
     CALL s_errmsg("ima01",l_ima.ima01,"ins ima",SQLCA.sqlcode,0)
  ELSE
     IF s_industry('icd') THEN        #No.FUN-830132 add
        INITIALIZE l_imaicd.* TO NULL
        LET l_imaicd.imaicd00 = l_ima.ima01
        LET l_flag = s_ins_imaicd(l_imaicd.*,'')
     END IF
  END IF

END FUNCTION
 
#-->產生插件位置(bmt_file) --> copy from bmu_file TO bmt_file
FUNCTION p101_ins_bmt(p_bmp,l_part,p_bmo01,p_bmo011,p_firm,p_acode)
DEFINE p_bmp RECORD like bmp_file.*,
       l_bmu RECORD LIKE bmu_file.*,
       l_bmt RECORD LIKE bmt_file.*,
       l_bmo06 LIKE bmo_file.bmo06, #FUN-550079
       l_part LIKE bmb_file.bmb03,  
       l_sql LIKE type_file.chr1000,   #No.FUN-680096 VARCHAR(400)
       l_cnt LIKE type_file.num5,      #No.FUN-680096 SMALLINT
       p_bmo01  LIKE bmo_file.bmo01,
       p_bmo011 LIKE bmo_file.bmo011,
       p_firm    LIKE ima_file.ima01,
       p_acode  LIKE bmt_file.bmt08 #FUN-550079
 
       IF p_acode IS NULL THEN
         LET p_acode=' '
       END IF
 
       LET l_sql = " SELECT bmu_file.* FROM bmu_file ",
                   " WHERE bmu01 = ","'",p_bmo01,"'",
                   "   AND bmu011= ","'",p_bmo011,"'",
                   "   AND bmu02 = ",p_bmp.bmp02,
                   "   AND bmu03 = ","'",p_bmp.bmp03,"'",
                   "   AND bmu08 ='",p_acode,"'" #FUN-560030
 
       PREPARE p101_pbmu FROM l_sql 
       DECLARE p101_bmu_cs CURSOR FOR p101_pbmu
       FOREACH p101_bmu_cs INTO l_bmu.*
           LET l_bmt.bmt01 = p_firm       #主件
           LET l_bmt.bmt02 = l_bmu.bmu02   #項次
           LET l_bmt.bmt03 = l_part        #元件 
           LET l_bmt.bmt04 = tm.bdate      #生效日期
           LET l_bmt.bmt05 = l_bmu.bmu05   #行序
           LET l_bmt.bmt06 = l_bmu.bmu06   #插件位置
           LET l_bmt.bmt07 = l_bmu.bmu07   #QPA
           LET l_bmt.bmt08 = p_acode       #FUN-550079
           IF cl_null(l_bmt.bmt02) THEN
              LET l_bmt.bmt02=0
           END IF
           INSERT INTO bmt_file VALUES(l_bmt.*) 
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
              LET g_showmsg=l_bmt.bmt01,"/",l_bmt.bmt02,"/",l_bmt.bmt03,"/",l_bmt.bmt04,"/",l_bmt.bmt05,"/",l_bmt.bmt08
              CALL s_errmsg("bmt01,bmt02,bmt03,bmt04,bmt05,bmt08",g_showmsg,"ins bmt_file",SQLCA.sqlcode,1)
              LET g_success = 'N'
              EXIT FOREACH 
           END IF     
        END FOREACH
END FUNCTION
 
#-->產生元件廠牌(bml_file) --> copy from bel_file TO bml_file
FUNCTION p101_ins_bml(p_bmp,l_part,p_bmo01,p_bmo011,p_firm)
DEFINE p_bmp RECORD LIKE bmp_file.*,
       l_bel RECORD LIKE bel_file.*,
       l_bml RECORD LIKE bml_file.*,
       l_part LIKE bmb_file.bmb03,
       l_sql LIKE type_file.chr1000,   #No.FUN-680096 VARCHAR(400)
       l_cnt LIKE type_file.num5,      #No.FUN-680096 SMALLINT
       p_bmo01   LIKE bmo_file.bmo01,
       p_bmo011  LIKE bmo_file.bmo011,
       p_firm    LIKE ima_file.ima01
 
       LET l_sql = " SELECT bel_file.* FROM bel_file ",
                   " WHERE bel02 = ","'",p_bmo01,"'",
                   "   AND bel011= ","'",p_bmo011,"'",
                   "   AND bel01=  ","'",p_bmp.bmp03,"'"
 
       PREPARE p101_pbel FROM l_sql 
       DECLARE p101_bel_cs CURSOR FOR p101_pbel
       FOREACH p101_bel_cs INTO l_bel.*
           LET l_bml.bml01 = l_part         #元件
           LET l_bml.bml02 = p_firm        #主件
           LET l_bml.bml03 = l_bel.bel03    #項次
           LET l_bml.bml04 = l_bel.bel04    #元件廠牌
           LET l_bml.bml05 = l_bel.bel05    #核准文號
           LET l_bml.bml06 = l_bel.bel06    #主要供應商
           INSERT INTO bml_file VALUES(l_bml.*)
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
              LET g_showmsg=l_bml.bml01,"/",l_bml.bml02,"/",l_bml.bml03
              CALL s_errmsg("bml01,bml02,bml03",g_showmsg,"ins bml_file",SQLCA.sqlcode,1)
              LET g_success = 'N'
              EXIT FOREACH 
           END IF     
       END FOREACH
END FUNCTION
 
#-->產生BOM說明檔(bmc_file) -->copy from bec_file TO bmc_file
FUNCTION p101_ins_bmc(p_bmp,l_part,p_bmo01,p_bmo011,p_firm,p_acode)
DEFINE p_bmp RECORD LIKE bmp_file.*,
       l_bec RECORD LIKE bec_file.*,
       l_bmc RECORD LIKE bmc_file.*,
       l_bmo06 LIKE bmo_file.bmo06, #FUN-550079
       l_part LIKE bmb_file.bmb03,
       l_sql LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(400)
       l_cnt LIKE type_file.num5,     #No.FUN-680096 SMALLINT
       p_bmo01   LIKE bmo_file.bmo01,
       p_bmo011  LIKE bmo_file.bmo011,
       p_firm    LIKE ima_file.ima01,
       p_acode   LIKE bmc_file.bmc06 #FUN-550079
 
       IF p_acode IS NULL THEN
         LET p_acode=' '
       END IF
 
       LET l_sql = " SELECT bec_file.* FROM bec_file",
                   " WHERE bec01 = ","'",p_bmo01,"'",
                   "   AND bec011= ","'",p_bmo011,"'",
                   "   AND bec02=  ",p_bmp.bmp02,
                   "   AND bec021=  ","'",p_bmp.bmp03,"'",
                  #"   AND bec08='",p_acode,"'" #FUN-560030 #TQC-AC0018
                   "   AND bec06='",p_acode,"'" #FUN-560030 #TQC-AC0018
 
       PREPARE p101_pbmc FROM l_sql 
       DECLARE p101_bmc_cs CURSOR FOR p101_pbmc
       FOREACH p101_bmc_cs INTO l_bec.*
           LET l_bmc.bmc01 = p_firm
           LET l_bmc.bmc02 = l_bec.bec02
           LET l_bmc.bmc021= l_part      
           LET l_bmc.bmc03 = tm.bdate
           LET l_bmc.bmc04 = l_bec.bec04
           LET l_bmc.bmc05 = l_bec.bec05
           LET l_bmc.bmc06 = p_acode       #FUN-550079
           INSERT INTO bmc_file VALUES(l_bmc.*) 
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
              LET g_showmsg=l_bmc.bmc01,"/",l_bmc.bmc02,"/",l_bmc.bmc021,"/",l_bmc.bmc03,"/",l_bmc.bmc04,"/",l_bmc.bmc06
              CALL s_errmsg("bmc01,bmc02,bmc021,bmc03,bmc04,bmc06",g_showmsg,"ins bmc:",SQLCA.sqlcode,1)
              LET g_success = 'N'
              EXIT FOREACH 
           END IF
       END FOREACH
END FUNCTION
 
#-->產生取替代檔(bmd_file) -->copy from bed_file TO bmd_file
FUNCTION p101_ins_bmd(p_bmp,l_part,p_bmo01,p_bmo011,p_firm,p_acode) #FUN-550079
DEFINE p_bmp RECORD LIKE bmp_file.*,
       l_bed RECORD LIKE bed_file.*,
       l_bmd RECORD LIKE bmd_file.*,
       p_acode LIKE ima_file.ima910, #FUN-550079
       l_part   LIKE bmb_file.bmb03,
       l_sql LIKE type_file.chr1000,  #No.FUN-680096 CGAR(400)
       l_cnt LIKE type_file.num5,     #No.FUN-680096 SMALLINT
       p_bmo01  LIKE bmo_file.bmo01,
       p_bmo011 LIKE bmo_file.bmo011,
       p_firm    LIKE ima_file.ima01,
       l_sitem   LIKE ima_file.ima01
 
       LET l_sql = " SELECT bed_file.* FROM bed_file",
                   " WHERE bed01 = ","'",p_bmo01,"'",  #主件
                   "   AND bed011= ","'",p_bmo011,"'", #版號
                   "   AND bed012= ",p_bmp.bmp02        #項次
       PREPARE p101_pbed FROM l_sql 
       DECLARE p101_bed_cs CURSOR FOR p101_pbed
       FOREACH p101_bed_cs INTO l_bed.*
           LET l_bmd.bmd01 = l_part         #元件
           LET l_bmd.bmd02 = l_bed.bed02    #檔案類別
           LET l_bmd.bmd03 = l_bed.bed03    #替代序號
           LET l_sitem = NULL
           SELECT sitem INTO l_sitem
             FROM bed_tmp
            WHERE bed01 = p_bmo01
              AND bed03 = l_bed.bed03
              AND bed04 = l_bed.bed04
           IF sqlca.sqlcode THEN
               SELECT bmq011 INTO l_sitem
                 FROM bmq_file
                WHERE bmq01 = l_bed.bed04
           END IF
           IF NOT cl_null(l_sitem) THEN
               SELECT COUNT(*) INTO g_cnt FROM ima_file
                WHERE ima01 = l_sitem
               IF g_cnt <= 0 THEN
                   CALL p101_ima(l_bed.bed04,l_sitem,p_acode)
               END IF
               CALL p101_up_bmq011(l_bed.bed04,l_sitem)
               LET l_bmd.bmd04 = l_sitem
           ELSE
               LET l_bmd.bmd04 = l_bed.bed04    
           END IF
           LET l_bmd.bmd05 = l_bed.bed05
           LET l_bmd.bmd06 = l_bed.bed06
           LET l_bmd.bmd07 = l_bed.bed07
           LET l_bmd.bmd08 = p_firm 
           LET l_bmd.bmd09 = l_bed.bed09
           LET l_bmd.bmdacti = 'Y'             #MOD-A40151 add
           LET l_bmd.bmdgrup = g_grup          #MOD-A40151 add
           LET l_bmd.bmduser = g_user          #MOD-A40151 add
           LET l_bmd.bmddate = g_today         #MOD-A40151 add
           LET l_bmd.bmdoriu = g_user      #No.FUN-980030 10/01/04
           LET l_bmd.bmdorig = g_grup      #No.FUN-980030 10/01/04
           IF cl_null(l_bmd.bmd11) THEN LET l_bmd.bmd11 = 'N' END IF      #TQC-C20131  add
           INSERT INTO bmd_file VALUES(l_bmd.*) 
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
              LET g_showmsg=l_bmd.bmd01,"/",l_bmd.bmd02,"/",l_bmd.bmd03,"/",l_bmd.bmd08
              CALL s_errmsg("bmd01,bmd02,bmd03,bmd08",g_showmsg,"ins bmd:",SQLCA.sqlcode,1)
              LET g_success = 'N'
              EXIT FOREACH 
           END IF
       END FOREACH
END FUNCTION
 
FUNCTION p101_up_bmq011(p_bmq01,p_bmq011)
  DEFINE p_bmq01    LIKE bmq_file.bmq01,
         p_bmq011   LIKE bmq_file.bmq011,
         l_cnt      LIKE type_file.num10   #No.FUN-680096 INTEGER
 
         SELECT COUNT(*) INTO l_cnt
           FROM bmq_file
          WHERE bmq01 = p_bmq01
         IF l_cnt > 0 THEN
             UPDATE bmq_file 
                SET bmq011 = p_bmq011
              WHERE bmq01= p_bmq01
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL s_errmsg("bmq01",p_bmq01,"update bmq011 error",SQLCA.sqlcode,1)
                 LET g_success = 'N'
             END IF
         END IF
END FUNCTION
FUNCTION p101_bom(p_bmp01,p_bmp011,p_levela,p_acode) #FUN-550079
    DEFINE p_bmp01  LIKE bmp_file.bmp01,
           p_bmp011 LIKE bmp_file.bmp011,
           p_levela LIKE type_file.num5,    #No.FUN-680096 SMALLINT
           p_acode  LIKE bmp_file.bmp28,    #FUN-550079
           l_levela LIKE type_file.num5,    #No.FUN-680096 SMALLINT
           l_bmp DYNAMIC ARRAY OF RECORD
             bmp02  LIKE bmp_file.bmp02,
             bmp03  LIKE bmp_file.bmp03,
             bmp16  LIKE bmp_file.bmp16,
             v2     LIKE type_file.chr4,    #No.FUN-680096 VARCHAR(4)
             levela  LIKE type_file.num5    #No.FUN-680096 SMLLINT
                   END RECORD,
           l_bmd04 ARRAY[602] OF LIKE bmd_file.bmd04,
           l_ac,l_ad,i,j,arrno   LIKE type_file.num10,  #No.FUN-680096 INTEGER
           l_item   LIKE ima_file.ima01,
           l_bmq011 LIKE bmq_file.bmq011
 DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0015
WHILE TRUE
    LET arrno=602
    DECLARE p101_bmp_cur CURSOR WITH HOLD FOR
     SELECT bmp02,bmp03,bmp16,'','' FROM bmp_file
      WHERE bmp01 = p_bmp01
        AND bmp011= p_bmp011
        AND bmp28 = p_acode #FUN-560030
      ORDER BY bmp02
 
    LET l_ac = 1
    FOREACH p101_bmp_cur INTO l_bmp[l_ac].*
        LET l_bmp[l_ac].levela = p_levela
         LET l_ima910[l_ac]=''
         SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=l_bmp[l_ac].bmp03
         IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
        LET l_ac = l_ac + 1
        IF l_ac > arrno THEN 
            EXIT FOREACH 
        END IF
    END FOREACH
    FOR i=1 TO l_ac-1
         SELECT COUNT(*) INTO g_cnt FROM bmo_file
          WHERE bmo01 = l_bmp[i].bmp03
            AND bmo06 = ' ' #FUN-560030
            AND bmo05 IS NULL
         IF g_cnt >= 1 THEN
             #此l_bmp[i].bmp03 BOM未拋轉
             CALL p101_input_p011(l_bmp[i].bmp03) RETURNING g_i,l_bmp[i].v2
             IF g_i THEN
                 LET g_exit_while = 'N'
                 LET g_success = 'N'
                 EXIT WHILE
             END IF
             IF tm.f = 'Y' THEN
                 CALL p101g_b_fill(l_bmp[i].bmp03,l_bmp[i].v2) #---->本階測試料件的聯產品
                 IF INT_FLAG THEN 
                     LET g_exit_while = 'N'
                     LET g_success = 'N'
                     EXIT WHILE
                 END IF
             END IF
             CALL p101_b_fill(l_bmp[i].bmp03,l_bmp[i].v2,l_bmp[i].levela,' ') #FUN-560030
             IF INT_FLAG THEN 
                 LET g_exit_while = 'N'
                 LET g_success = 'N'
                 EXIT WHILE
             END IF
             LET l_item = NULL
             SELECT item INTO l_item
               FROM firm_tmp
              WHERE bmp03 = l_bmp[i].bmp03
             IF cl_null(l_item) THEN
                 SELECT bmq011 INTO l_item
                   FROM bmq_file
                  WHERE bmq01 = l_bmp[i].bmp03
             END IF
             IF NOT cl_null(l_item) THEN
                 CALL p101_ins(l_bmp[i].bmp03,l_bmp[i].v2,l_item,' ') #FUN-550079
             END IF
         ELSE
             #此l_bmp[i].bmp03 BOM已拋轉
             SELECT MAX(bmo011) INTO l_bmp[i].v2 
               FROM bmo_file
              WHERE bmo01 = l_bmp[i].bmp03
             
             CALL p101_ins_bom(l_bmp[i].bmp03,l_bmp[i].v2,l_bmp[i].levela,p_acode) #FUN-550079 #INSERT INTO bom_tmp VALUES(g_bmp[l_ac].*)
         END IF
         LET l_levela = l_bmp[i].levela + 1
         CALL p101_bom(l_bmp[i].bmp03,l_bmp[i].v2,l_levela,l_ima910[i]) #FUN-8B0015 
    END FOR
    EXIT WHILE
END WHILE
END FUNCTION
 
FUNCTION p101_create_tmp()
 DROP TABLE firm_tmp
 DROP INDEX firm_inx
 CREATE TEMP TABLE firm_tmp(
     bmp03   LIKE bmp_file.bmp03,
     item    LIKE type_file.chr1000)
create unique index firm_inx on firm_tmp(bmp03);
END FUNCTION
 
FUNCTION p101_create_bom_tmp()
 DROP TABLE bom_tmp
 DROP INDEX bom_inx
 CREATE TEMP TABLE bom_tmp(
     bmp01   LIKE bmp_file.bmp01,
     v1      LIKE fan_file.fan02,
     desc1   LIKE type_file.chr1000,
     desc11  LIKE type_file.chr1000,
     bmp03   LIKE bmp_file.bmp03,
     v2      LIKE fan_file.fan02,
     desc2   LIKE type_file.chr1000,
     desc22  LIKE type_file.chr1000,
     item    LIKE type_file.chr1000,
     levela  LIKE type_file.num5,  
     bmp28   LIKE bmp_file.bmp28)
create unique index bom_inx on bom_tmp(bmp01,bmp03);
END FUNCTION
FUNCTION p101_create_bed_tmp()
 DROP TABLE bed_tmp
 DROP INDEX bed_inx
 CREATE TEMP TABLE bed_tmp(
     bed01   LIKE bed_file.bed01,
     bed03   LIKE bed_file.bed03,
     bed04   LIKE bed_file.bed04,
     sitem   LIKE type_file.chr1000)
create unique index bed_inx on bed_tmp(bed01,bed03,bed04);
END FUNCTION
FUNCTION p101_create_bmn_tmp()
 DROP TABLE bmn_tmp
 DROP INDEX bmn_inx
 CREATE TEMP TABLE bmn_tmp(
     bmn01   LIKE bmn_file.bmn01,
     bmn011  LIKE bmn_file.bmn011,
     bmn03   LIKE bmn_file.bmn03,
     sitem   LIKE type_file.chr1000)
create unique index bmn_inx on bmn_tmp(bmn01,bmn011,bmn03);
END FUNCTION
 
FUNCTION p101_input_p011(p_bmp03)
 DEFINE p_row,p_col   LIKE type_file.num5     #No.FUN-680096 SMALLINT
 DEFINE p_bmp03       LIKE bmp_file.bmp03,
        l_v2          LIKE type_file.chr4,    #No.FUN-680096 VARCHAR(4)
        l_bmq02       LIKE bmq_file.bmq02,
        l_bmo05       LIKE bmo_file.bmo05
 
   LET p_row = 10 LET p_col = 10
 
   OPEN WINDOW p101a_w AT p_row,p_col WITH FORM "abm/42f/abmp101a" 
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("abmp101a")
 
   CALL cl_opmsg('a')
   SELECT bmq02 INTO l_bmq02
     FROM bmq_file
    WHERE bmq01 = p_bmp03
   DISPLAY p_bmp03,l_bmq02 TO FORMONLY.bmp03,FORMONLY.desc2
 
   INPUT l_v2 WITHOUT DEFAULTS FROM FORMONLY.v2
        AFTER FIELD v2 
            IF cl_null(l_v2) THEN NEXT FIELD v2 END IF
            SELECT bmo05 INTO l_bmo05  
              FROM bmo_file 
             WHERE bmo01 = p_bmp03
               AND bmo011= l_v2
               AND bmo06=' ' #FUN-560030
            IF SQLCA.sqlcode THEN 
               CALL cl_err('','mfg2757',0)
               NEXT FIELD v2
            END IF
            IF not cl_null(g_bmo.bmo05) THEN 
               CALL cl_err('','mfg2760',0)
               NEXT FIELD v2
            END IF
        ON ACTION CONTROLP     #查詢條件 
            CASE
               WHEN INFIELD(v2) 

                  CALL cl_init_qry_var()
                 #LET g_qryparam.form = 'q_bmo'      #MOD-C20125 mark
                  LET g_qryparam.form = 'q_bmo4'     #MOD-C20125 add
                  LET g_qryparam.default1 = p_bmp03
                  LET g_qryparam.default1 = l_v2
                  CALL cl_create_qry() RETURNING p_bmp03,l_v2 

                  DISPLAY l_v2 TO FORMONLY.v2 
                  NEXT FIELD v2
               OTHERWISE EXIT CASE
             END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
   END INPUT
   IF INT_FLAG THEN 
       LET g_exit_while = 'N'
       LET g_success = 'N'
       CLOSE WINDOW p101a_w
       RETURN 1,1
   END IF
   CLOSE WINDOW p101a_w
   RETURN 0,l_v2
END FUNCTION
 
FUNCTION p101_out()
DEFINE l_name    LIKE type_file.chr20     #No.FUN-680096 VARCHAR(20)
DEFINE l_sql     LIKE type_file.chr1000   # RDSQL STATEMENT        #No.FUN-680096 VARCHAR(1000)
DEFINE l_za05    LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(40)
DEFINE sr        RECORD 
                   bmp01     LIKE bmp_file.bmp01,   #No.MOD-490217
                  v1        LIKE type_file.chr4,    #No.FUN-680096 VARCHAR(4)
                  desc1     LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(30)
                  desc11    LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(30)
                   bmp03     LIKE bmp_file.bmp03,   #No.MOD-490217
                  v2        LIKE type_file.chr4,    #No.FUN-680096 VARCHAR(4)
                  desc2     LIKE type_file.chr50,   #No.FUN-680096 VARCHAR(30)
                  desc22    LIKE type_file.chr50,   #No.FUN-680096 VARCHAR(30)
                   item      LIKE ima_file.ima01,   #No.MOD-490217
                  levela     LIKE type_file.num5,   #No.FUN-680096 SMALLINT
                  bmp28   LIKE bmp_file.bmp28       #FUN-550079
                 END RECORD
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
     DECLARE p101_curs CURSOR FOR
         SELECT * FROM bom_tmp
 
     CALL cl_outnam('abmp101') RETURNING l_name
 
     START REPORT p101_rep TO l_name
     LET g_pageno = 0
 
     FOREACH p101_curs INTO sr.*
          OUTPUT TO REPORT p101_rep(sr.*)
     END FOREACH
 
     FINISH REPORT p101_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
 
 
REPORT p101_rep(sr)
DEFINE l_last_sw LIKE type_file.chr1    #No.FUN-680096 VARCHAR(1)
DEFINE l_acode   LIKE bmp_file.bmp28 #FUN-550079
DEFINE sr        RECORD 
                   bmp01     LIKE bmp_file.bmp01, #No.MOD-490217
                  v1        LIKE type_file.chr4,  #No.FUN-680096 VARCHAR(4)
                  desc1     LIKE type_file.chr50, #No.FUN-680096 VARCHAR(30) 
                  desc11    LIKE type_file.chr50, #No.FUN-680096 VARCHAR(30)
                   bmp03     LIKE bmp_file.bmp03, #No.MOD-490217
                  v2        LIKE type_file.chr4,  #No.FUN-680096 VARCHAR(4)
                  desc2     LIKE type_file.chr50, #No.FUN-680096 VARCHAR(30)
                  desc22    LIKE type_file.chr50, #No.FUN-680096 VARCHAR(30)
                   item      LIKE ima_file.ima01, #No.MOD-490217
                  levela    LIKE type_file.num5,  #No.FUN-680096 SMALLINT
                  bmp28   LIKE bmp_file.bmp28     #FUN-550079
                 END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER EXTERNAL BY sr.levela,sr.bmp03
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno" 
            PRINT g_head CLIPPED,pageno_total     
            PRINT COLUMN  1,g_x[11] CLIPPED,tm.bmo01,
                  COLUMN 31,g_x[12] CLIPPED,tm.bmo011
            PRINT g_dash
            PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
            PRINTX name=H2 g_x[37],g_x[38],g_x[39],g_x[43],g_x[44] #FUN-550079 加序號 43 & 44
            PRINTX name=H3 g_x[40],g_x[41],g_x[42]
            PRINT g_dash1 
            LET l_last_sw = 'y'
 
        ON EVERY ROW
           IF sr.levela=1 THEN
              LET sr.bmp28 = tm.bmo06
           ELSE
              LET sr.bmp28 = ' '
           END IF
           PRINTX name=D1 COLUMN g_c[31],sr.bmp01,
                          COLUMN g_c[32],sr.v1 USING '####',
                          COLUMN g_c[33],sr.bmp03,
                          COLUMN g_c[34],sr.v2 USING '####',
                          COLUMN g_c[35],sr.item ,
                          COLUMN g_c[36],sr.levela USING '####'
           PRINTX name=D2 COLUMN g_c[37],sr.desc1,
                          COLUMN g_c[38],' ',
                          COLUMN g_c[39],sr.desc2,
                          COLUMN g_c[44],sr.bmp28 #FUN-550079
           PRINTX name=D3 COLUMN g_c[40],sr.desc11,
                          COLUMN g_c[41],' ',
                          COLUMN g_c[42],sr.desc22
 
        ON LAST ROW
            PRINT g_dash
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),
                  g_x[7] CLIPPED
            LET l_last_sw = 'n'
 
        PAGE TRAILER
            IF l_last_sw = 'y' THEN
                PRINT g_dash
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),
                      g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
 
FUNCTION p101s_b_fill(p_bmp,p_bmp02)
  DEFINE   l_sql       LIKE type_file.chr1000,        #No.FUN-680096 VARCHAR(900)
           l_ac        LIKE type_file.num5,           #No.FUN-680096 SMALLINT
           p_bmp02     LIKE bmp_file.bmp02,
           p_bmp       RECORD 
                        bmp01   LIKE bmp_file.bmp01,
                        v1      LIKE bmo_file.bmo011,
                        desc1   LIKE ima_file.ima02,
                        desc11  LIKE ima_file.ima021,
                        bmp03   LIKE bmp_file.bmp03,
                        v2      LIKE bmo_file.bmo011,
                        desc2   LIKE ima_file.ima02,
                        desc22  LIKE ima_file.ima021,
                        item    LIKE ima_file.ima01,  #正式料號
                        levela  LIKE type_file.num5,  #No.FUN-680096 SMALLINT
                        bmp28   LIKE bmp_file.bmp28   #FUN-550079
                       END RECORD,
           g_yn_sitem  LIKE type_file.chr1            #No.FUN-680096 VARCHAR(1)
      LET l_sql =
                 "SELECT bed03,bed02,bed04,ima02,ima021,'Y',bed04 ",
                 "  FROM bed_file,bmp_file,ima_file ",
                 " WHERE bmp01 = bed01 ",
                 "   AND bmp011 = bed011 ",
                 "   AND bmp02 = bed012 ",
                 "   AND bmp01 ='",p_bmp.bmp01,"'",
                 "   AND bmp02 ='",p_bmp02,"'",
                 "   AND (bmp16 = '1' OR bmp16 = '2')",
                 "   AND ima01 = bed04 ",
                 " UNION ",
                 "SELECT bed03,bed02,bed04,bmq02,bmq021,'N',bed04 ",
                 "  FROM bed_file,bmp_file,bmq_file ",
                 " WHERE bmp01 = bed01 ",
                 "   AND bmp011 = bed011 ",
                 "   AND bmp02 = bed012 ",
                 "   AND bmp01 ='",p_bmp.bmp01,"'",
                 "   AND bmp02 ='",p_bmp02,"'",
                 "   AND (bmp16 = '1' OR bmp16 = '2') ",
                 "   AND bmq01 = bed04 ",
                 "   AND (bmq011 IS NULL OR bmq011 = ' ') "
                #" ORDER BY bmq02,bed04 "  #FUN-B70060 mark sql -217 錯誤
 
      PREPARE p101s_pre_bed FROM l_sql
      DECLARE p101s_cur_bed
          CURSOR FOR p101s_pre_bed
      CALL g_bed.clear()
      LET l_ac = 1
      LET g_yn_sitem = 'N'
      FOREACH p101s_cur_bed INTO g_bed[l_ac].*
          IF SQLCA.sqlcode THEN 
              CALL cl_err('p101s_cur_bed',SQLCA.sqlcode,0)
              EXIT FOREACH
          END IF
          IF g_bed[l_ac].a = 'N' THEN #有測試料件
              LET g_yn_sitem = 'Y'    #表示要輸入sitem
          END IF
          LET l_ac = l_ac + 1
      IF l_ac  > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      END FOREACH
      CALL SET_COUNT(l_ac-1)               #告訴I.單身筆數
      LET g_rec_b_bed = l_ac -1
      LET g_ac = g_rec_b_bed
      IF g_yn_sitem = 'Y' THEN
          CALL p101s_array(p_bmp.*)
      END IF
      IF INT_FLAG THEN 
          LET g_exit_while = 'N'
          LET g_success = 'N'
          RETURN
      END IF
END FUNCTION
 
FUNCTION p101s_array(p_bmp)
  DEFINE p_row,p_col	LIKE type_file.num5       #No.FUN-680096 SMALLINT
  DEFINE  l_ac_t        LIKE type_file.num5,      #No.FUN-680096 SMALLINT
          l_exit_sw     LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
          l_cnt         LIKE type_file.num5,      #No.FUN-680096 SMALLINT
          l_allow_insert  LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_allow_delete  LIKE type_file.num5,    #No.FUN-680096 SMALLINT
       l_n             LIKE type_file.num5,       #目前處理的ARRAY CNT   #No.FUN-680096 SMALLINT
       l_ac            LIKE type_file.num5,       #目前處理的ARRAY CNT   #No.FUN-680096 SMALLINT
       l_sl            LIKE type_file.num5,       #目前處理的SCREEN LINE #No.FUN-680096 SMALLINT
          p_bmp         RECORD 
                         bmp01   LIKE bmp_file.bmp01,
                         v1      LIKE bmo_file.bmo011,
                         desc1   LIKE ima_file.ima02,
                         desc11  LIKE ima_file.ima021,
                         bmp03   LIKE bmp_file.bmp03,
                         v2      LIKE bmo_file.bmo011,
                         desc2   LIKE ima_file.ima02,
                         desc22  LIKE ima_file.ima021,
                         item    LIKE ima_file.ima01,  #正式料號
                         levela  LIKE type_file.num5,  #No.FUN-680096 SMALLINT
                         bmp28   LIKE bmp_file.bmp28   #FUN-550079
                        END RECORD
 
   LET p_row = 7  LET p_col = 26
 
   OPEN WINDOW p101s_w AT p_row,p_col WITH FORM "abm/42f/abmp101s" 
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("abmp101s")
 
   DISPLAY p_bmp.bmp01,p_bmp.desc1,p_bmp.desc11,p_bmp.v1,
           p_bmp.bmp03,p_bmp.desc2,p_bmp.desc22,p_bmp.v2
        TO FORMONLY.bmp01,FORMONLY.desc1,FORMONLY.desc11,FORMONLY.v1,
           FORMONLY.bmp03,FORMONLY.desc2,FORMONLY.desc22,FORMONLY.v2
 
   CALL cl_opmsg('s')
   LET l_ac_t = 0
   WHILE TRUE
     LET l_exit_sw = "y"                #正常結束,除非 ^N
     LET l_allow_insert = FALSE
     LET l_allow_delete = FALSE
     INPUT ARRAY g_bed WITHOUT DEFAULTS FROM s_bed.*
              ATTRIBUTE(INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE ROW
          LET l_ac = ARR_CURR()
          LET l_sl = SCR_LINE()
          LET l_n  = ARR_COUNT()
          LET g_bed_t.* = g_bed[l_ac].*
 
      BEFORE FIELD sitem
         IF g_bed[l_ac].a = 'Y'  # 正式料號 #
            THEN

         END IF
 
      AFTER FIELD sitem
         IF NOT cl_null(g_bed[l_ac].bed04) THEN
            IF cl_null(g_bed[l_ac].sitem) THEN NEXT FIELD sitem END IF
            LET g_bmq01 = NULL
            SELECT bmq01 INTO g_bmq01
              FROM bmq_file
             WHERE bmq011 = g_bed[l_ac].sitem
            IF NOT cl_null(g_bmq01) THEN
                #你所輸入的料號已是此料件的正式料號,請重新輸入!
                CALL cl_err(g_bmq01,'abm-115',0)
                NEXT FIELD sitem
            END IF
         END IF
         IF g_bed[l_ac].sitem IS NOT NULL OR g_bed[l_ac].sitem != ' ' THEN
             #FUN-B70060 add
             IF g_bed[l_ac].sitem[1,1] = ' ' THEN
                CALL cl_err(g_bed[l_ac].sitem,"aim-671",0)
                NEXT FIELD sitem
             END IF
             #FUN-B70060 add--end
             IF g_sma.sma100='Y' AND NOT cl_null(g_bed[l_ac].sitem) THEN #E-BOM轉P-BOM時料件編號需存料件主檔中
                 SELECT COUNT(*) INTO l_cnt
                   FROM ima_file
                 WHERE ima01 = g_bed[l_ac].sitem
                 IF SQLCA.sqlcode OR l_cnt <= 0 THEN
                     #E-BOM轉P-BOM時料件編號需存料件主檔中
                     CALL cl_err(g_bed[l_ac].sitem,'abm-110',0)
                     NEXT FIELD sitem
                 END IF
             END IF
         END IF
 
      AFTER ROW
         IF INT_FLAG THEN EXIT INPUT  END IF
         IF g_bed[l_ac].a = 'Y'  # 已是正式料號 #
            THEN 
            LET g_bed[l_ac].* = g_bed_t.*
         END IF
         DISPLAY g_bed[l_ac].* TO s_bed[l_sl].*
         IF g_sma.sma100='Y' AND NOT cl_null(g_bed[l_ac].sitem) THEN #E-BOM轉P-BOM時料件編號需存料件主檔中
             SELECT COUNT(*) INTO l_cnt
               FROM ima_file
             WHERE ima01 = g_bed[l_ac].sitem
             IF SQLCA.sqlcode OR l_cnt <= 0 THEN
                 #E-BOM轉P-BOM時料件編號需存料件主檔中
                 CALL cl_err(g_bed[l_ac].sitem,'abm-110',0)
                 NEXT FIELD sitem
             END IF
         END IF
           
        ON ACTION CONTROLP     #查詢條件 
            CASE
               WHEN INFIELD(sitem)
#FUN-AB0025 ------------Begin---------------
                #  CALL cl_init_qry_var()
                #  LET g_qryparam.form = 'q_ima'
                #  LET g_qryparam.default1 = g_bed[l_ac].sitem
                #  CALL cl_create_qry() RETURNING g_bed[l_ac].sitem
                   CALL q_sel_ima(FALSE, "q_ima", "", g_bed[l_ac].sitem, "", "", "", "" ,"",'' )  RETURNING g_bed[l_ac].sitem
#FUN-AB0025 ------------End-----------------
                   DISPLAY g_bed[l_ac].sitem TO sitem           #No.MOD-490371
                  NEXT FIELD sitem
               OTHERWISE EXIT CASE
             END CASE
 
         AFTER INPUT
             FOR l_ac = 1 TO g_bed.getLength()
                 IF cl_null(g_bed[l_ac].bed04) THEN
                      EXIT FOR
                 END IF
                 IF NOT cl_null(g_bed[l_ac].bed04) AND 
                    g_bed[l_ac].a = 'N' AND 
                    cl_null(g_bed[l_ac].sitem) THEN
                    #正式料號不可白!
                    CALL cl_err(g_bed[l_ac].bed04,'abm-111',0)
                    CONTINUE WHILE
                 END IF
                 IF g_bed[l_ac].a = 'N' THEN
                     SELECT COUNT(*) INTO g_cnt FROM bmo_file
                      WHERE bmo01 = g_bed[l_ac].bed04
                     IF g_cnt >= 1 THEN
                         #請先移轉此替代料件的工程BOM!
                         CALL cl_err(g_bed[l_ac].bed04,'abm-112',1)
                         LET g_exit_while = 'N'
                         LET g_success = 'N'
                         EXIT INPUT
                     END IF
                    
                     SELECT COUNT(*) INTO g_cnt FROM bed_tmp
                      WHERE bed04 = g_bed[l_ac].bed04
                     IF g_cnt = 0 THEN
                         INSERT INTO bed_tmp VALUES (p_bmp.bmp01,g_bed[l_ac].bed03,g_bed[l_ac].bed04,g_bed[l_ac].sitem)
                     ELSE
                         UPDATE bed_tmp
                            SET sitem = g_bed[l_ac].sitem
                          WHERE bed01 = p_bmp.bmp01
                            AND bed03 = g_bed[l_ac].bed03
                            AND bed04 = g_bed[l_ac].bed04
                     END IF
                 END IF
             END FOR
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION controls                                    #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("grid01,grid02","AUTO")   #No.FUN-6B0033
 
   END INPUT
   
      IF l_exit_sw = "y" THEN
          EXIT WHILE                     #ESC 或 DEL 結束 INPUT
      ELSE
          CONTINUE WHILE                 #^N 結束 INPUT
      END IF
  END WHILE
  CLOSE WINDOW p101s_w
END FUNCTION
 
#---->聯產品
FUNCTION p101g_b_fill(p_bmn01,p_bmn011)
  DEFINE   l_sql       LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(900)
           l_ac        LIKE type_file.num5,    #No.FUN-680096 SMALLINT
           p_bmn01     LIKE bmn_file.bmn01,
           p_bmn011    LIKE bmn_file.bmn011,
           g_yn_sitem  LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
      LET l_sql =
                 "SELECT bmn02,bmn03,ima02,'Y',bmn03 ",
                 "  FROM bmn_file,ima_file ",
                 " WHERE bmn01 = '",p_bmn01 ,"'",
                 "   AND bmn011= '",p_bmn011,"'",
                 "   AND bmn03 = ima01 ",
                 " UNION ",
                 "SELECT bmn02,bmn03,bmq02,'N',bmn03 ",
                 "  FROM bmn_file,bmq_file ",
                 " WHERE bmn01 = '",p_bmn01 ,"'",
                 "   AND bmn011= '",p_bmn011,"'",
                 "   AND bmn03 = bmq01 ",
                 "   AND (bmq011 IS NULL OR bmq011 = ' ') "
                #" ORDER BY bmq02,bmn03 "  #FUN-B70060 mark sql -217 錯誤
 
      PREPARE p101g_pre_bmn FROM l_sql
      DECLARE p101g_cur_bmn
          CURSOR FOR p101g_pre_bmn
     
      CALL g_bmn.clear()
      LET l_ac = 1
      LET g_yn_sitem = 'N'
      FOREACH p101g_cur_bmn INTO g_bmn[l_ac].*
          IF SQLCA.sqlcode THEN 
              
              LET g_showmsg=p_bmn01,"/",p_bmn011
              CALL s_errmsg("bmn01,bmn011",g_showmsg,"p101g_cur_bmn",SQLCA.sqlcode,0)
              EXIT FOREACH
          END IF
          IF g_bmn[l_ac].a = 'N' THEN #有測試料件
              LET g_yn_sitem = 'Y'    #表示要輸入sitem
          END IF
          LET l_ac = l_ac + 1
      IF l_ac  > g_max_rec THEN
         CALL s_errmsg("","","",9035,0)
	 EXIT FOREACH
      END IF
      END FOREACH
      CALL SET_COUNT(l_ac-1)               #告訴I.單身筆數
      LET g_rec_b_bmn = l_ac -1
      LET g_ac = g_rec_b_bmn
      IF g_yn_sitem = 'Y' THEN
          CALL p101g_array(p_bmn01,p_bmn011)
      END IF
      IF INT_FLAG THEN 
          LET g_exit_while = 'N'
          LET g_success = 'N'
          RETURN
      END IF
END FUNCTION
 
FUNCTION p101g_array(p_bmn01,p_bmn011)
  DEFINE p_row,p_col	LIKE type_file.num5      #No.FUN-680096 SMALLINT
  DEFINE  l_ac_t        LIKE type_file.num5,     #No.FUN-680096 SMALLINT
          l_exit_sw     LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
          l_cnt         LIKE type_file.num5,     #No.FUN-680096 SMALLINT
          l_allow_insert  LIKE type_file.num5,   #No.FUN-680096 SMALLINT
          l_allow_delete  LIKE type_file.num5,   #No.FUN-680096 SMALLINT
       l_n             LIKE type_file.num5,      #目前處理的ARRAY CNT   #No.FUN-680096 SMALLINT
       l_ac            LIKE type_file.num5,      #目前處理的ARRAY CNT   #No.FUN-680096 SMALLINT
       l_sl            LIKE type_file.chr1,      #目前處理的SCREEN LINE  #No.FUN-680096 VARCHAR(1) 
       p_bmn01         LIKE pmn_file.pmn01,
       p_bmn011        LIKE pmn_file.pmn011,
       l_bmq02         LIKE bmq_file.bmq02
 
   LET p_row = 7  LET p_col = 26
 
   OPEN WINDOW p101g_w AT p_row,p_col WITH FORM "abm/42f/abmp101g" 
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("abmp101g")
 
   SELECT bmq02 INTO l_bmq02 
     FROM bmq_file 
    WHERE bmq01 = p_bmn01
   DISPLAY        p_bmn01,       l_bmq02,         p_bmn011
        TO FORMONLY.bmn01,FORMONLY.desc1,FORMONLY.bmn011
 
   CALL cl_opmsg('s')
   LET l_ac_t = 0
   WHILE TRUE
     LET l_exit_sw = "y"                #正常結束,除非 ^N
     LET l_allow_insert = FALSE
     LET l_allow_delete = FALSE
     INPUT ARRAY g_bmn WITHOUT DEFAULTS FROM s_bmn.*
              ATTRIBUTE(INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE ROW
          LET l_ac = ARR_CURR()
          LET l_sl = SCR_LINE()
          LET l_n  = ARR_COUNT()
          LET g_bmn_t.* = g_bmn[l_ac].*
 
      BEFORE FIELD sitem
         IF g_bmn[l_ac].a = 'Y' THEN

         END IF
 
      AFTER FIELD sitem
         IF NOT cl_null(g_bmn[l_ac].bmn03) THEN
            IF cl_null(g_bmn[l_ac].sitem) THEN 
                NEXT FIELD sitem 
            END IF
            LET g_bmq01 = NULL
            SELECT bmq01 INTO g_bmq01
              FROM bmq_file
             WHERE bmq011 = g_bmn[l_ac].sitem
            IF NOT cl_null(g_bmq01) THEN
                #你所輸入的料號已是此料件的正式料號,請重新輸入!
                CALL cl_err(g_bmq01,'abm-115',0)
                NEXT FIELD sitem
            END IF
         END IF
         IF g_bmn[l_ac].sitem IS NOT NULL OR g_bmn[l_ac].sitem != ' ' THEN
             #FUN-B70060 add
             IF g_bmn[l_ac].sitem[1,1] = ' ' THEN
                CALL cl_err(g_bmn[l_ac].sitem,"aim-671",0)
                NEXT FIELD sitem
             END IF
             #FUN-B70060 add--end
             IF g_sma.sma100='Y' AND NOT cl_null(g_bmn[l_ac].sitem) THEN #E-BOM轉P-BOM時料件編號需存料件主檔中
                 SELECT COUNT(*) INTO l_cnt
                   FROM ima_file
                 WHERE ima01 = g_bmn[l_ac].sitem
                 IF SQLCA.sqlcode OR l_cnt <= 0 THEN
                     #E-BOM轉P-BOM時料件編號需存料件主檔中
                     CALL cl_err(g_bmn[l_ac].sitem,'abm-110',0)
                     NEXT FIELD sitem
                 END IF
             END IF
         END IF
 
      AFTER ROW
         IF INT_FLAG THEN EXIT INPUT  END IF
         IF g_bmn[l_ac].a = 'Y'  # 已是正式料號 #
            THEN 
            LET g_bmn[l_ac].* = g_bmn_t.*
         END IF
         DISPLAY g_bmn[l_ac].* TO s_bmn[l_sl].*
         IF g_sma.sma100='Y' AND NOT cl_null(g_bmn[l_ac].sitem) THEN #E-BOM轉P-BOM時料件編號需存料件主檔中
             SELECT COUNT(*) INTO l_cnt
               FROM ima_file
             WHERE ima01 = g_bmn[l_ac].sitem
             IF SQLCA.sqlcode OR l_cnt <= 0 THEN
                 #E-BOM轉P-BOM時料件編號需存料件主檔中
                 CALL cl_err(g_bmn[l_ac].sitem,'abm-110',0)
                 NEXT FIELD sitem
             END IF
         END IF
           
        ON ACTION CONTROLP     #查詢條件 
            CASE
               WHEN INFIELD(sitem)
#FUN-AB0025 ----Begin----
                #  CALL cl_init_qry_var()
                #  LET g_qryparam.form = 'q_ima'
                #  LET g_qryparam.default1 = g_bmn[l_ac].sitem
                #  CALL cl_create_qry() RETURNING g_bmn[l_ac].sitem
                   CALL q_sel_ima(FALSE, "q_ima", "", g_bmn[l_ac].sitem, "", "", "", "" ,"",'' )  RETURNING g_bmn[l_ac].sitem
#FUN-AB0025 ----End------
                   DISPLAY g_bmn[l_ac].sitem TO sitem          #No.MOD-490371
                  NEXT FIELD sitem
               OTHERWISE EXIT CASE
             END CASE
 
         AFTER INPUT
             FOR l_ac = 1 TO g_bmn.getLength()
                 IF cl_null(g_bmn[l_ac].bmn03) THEN
                      EXIT FOR
                 END IF
                 IF NOT cl_null(g_bmn[l_ac].bmn03) AND 
                    g_bmn[l_ac].a = 'N' AND 
                    cl_null(g_bmn[l_ac].sitem) THEN
                    #正式料號不可白!
                    CALL cl_err(g_bmn[l_ac].bmn03,'abm-111',0)
                    CONTINUE WHILE
                 END IF
                 IF g_bmn[l_ac].a = 'N' THEN
                    
                     SELECT COUNT(*) INTO g_cnt FROM bmn_tmp
                      WHERE bmn03 = g_bmn[l_ac].bmn03
                     IF g_cnt = 0 THEN
                         INSERT INTO bmn_tmp VALUES (p_bmn01,p_bmn011,g_bmn[l_ac].bmn03,g_bmn[l_ac].sitem)
                     ELSE
                         UPDATE bmn_tmp
                            SET sitem = g_bmn[l_ac].sitem
                          WHERE bmn01 = p_bmn01
                            AND bmn011= p_bmn011
                            AND bmn03 = g_bmn[l_ac].bmn03
                     END IF
                 END IF
             END FOR
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION controls                             #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("grid01","AUTO")   #No.FUN-6B0033
 
   END INPUT
   
      IF l_exit_sw = "y" THEN
          EXIT WHILE                     #ESC 或 DEL 結束 INPUT
      ELSE
          CONTINUE WHILE                 #^N 結束 INPUT
      END IF
  END WHILE
  CLOSE WINDOW p101g_w
END FUNCTION
#-->產生產品結構連產品資料檔(bmm_file) -->copy from bmn_file TO bmn_file
FUNCTION p101_ins_bmm(p_bmn01,p_bmn011,p_firm,p_acode) #FUN-550079
DEFINE 
       l_bmn RECORD LIKE bmn_file.*,
       l_bmm RECORD LIKE bmm_file.*,
       p_acode LIKE ima_file.ima910, #FUN-550079
       l_sql LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(400)
       l_cnt LIKE type_file.num5,    #No.FUN-680096 SMALLINT
       p_bmn01  LIKE bmn_file.bmn01, #主件料件編號
       p_bmn011 LIKE bmn_file.bmn011,#版本
       p_firm    LIKE ima_file.ima01,#主件的正式料號
       l_sitem   LIKE ima_file.ima01 #主件的聯產品料件的正式料號
 
       LET l_sql = " SELECT * FROM bmn_file",
                   " WHERE bmn01 = ","'",p_bmn01,"'",  #主件
                   "   AND bmn011= ","'",p_bmn011,"'"  #版本
       PREPARE p101_pbmn FROM l_sql 
       DECLARE p101_bmn_cs CURSOR FOR p101_pbmn
       FOREACH p101_bmn_cs INTO l_bmn.*
           IF g_success = "N" THEN                                                   
              LET g_totsuccess = "N"                                                 
              LET g_success = "Y"                                                    
           END IF
           LET l_bmm.bmm01 = p_firm         #主件
           LET l_bmm.bmm02 = l_bmn.bmn02    #組合項次
           LET l_sitem = NULL
           SELECT sitem INTO l_sitem
             FROM bmn_tmp
            WHERE bmn01 = p_bmn01  #主件
              AND bmn011= p_bmn011 #版本
              AND bmn03 = l_bmn.bmn03
           IF sqlca.sqlcode THEN
               SELECT bmq011 INTO l_sitem
                 FROM bmq_file
                WHERE bmq01 = l_bmn.bmn03
           END IF
           IF NOT cl_null(l_sitem) THEN
               SELECT COUNT(*) INTO g_cnt FROM ima_file
                WHERE ima01 = l_sitem
               IF g_cnt <= 0 THEN
                   CALL p101_ima(l_bmn.bmn03,l_sitem,p_acode)
               END IF
               CALL p101_up_bmq011(l_bmn.bmn03,l_sitem)
               LET l_bmm.bmm03 = l_sitem
           ELSE
               LET l_bmm.bmm03 = l_bmn.bmn03    
           END IF
           LET l_bmm.bmm04 = l_bmn.bmn04
           LET l_bmm.bmm05 = l_bmn.bmn05
           LET l_bmm.bmm06 = l_bmn.bmn06
           LET l_bmm.bmm07 = l_bmn.bmn07
            INSERT INTO bmm_file (bmm01,bmm02,bmm03,bmm04,bmm05,bmm06,bmm07)  #No.MOD-470041
                VALUES(l_bmm.bmm01,l_bmm.bmm02,l_bmm.bmm03,l_bmm.bmm04,
                       l_bmm.bmm05,l_bmm.bmm06,l_bmm.bmm07)
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
              LET g_showmsg=l_bmm.bmm01,"/",l_bmm.bmm02 
              CALL s_errmsg("bmm01,bmm02",g_showmsg,"ins bmm:",SQLCA.sqlcode,1)
              LET g_success = 'N'
              CONTINUE FOREACH
           END IF
       END FOREACH
       IF g_totsuccess = 'N' THEN
          LET g_success = 'N'
       END IF
END FUNCTION
 
FUNCTION p101_ins_bom(p_bmp01,p_bmp011,p_levela,p_acode) #FUN-550079   #INSERT INTO bom_tmp VALUES(g_bmp[l_ac].*)
   DEFINE p_bmp01   LIKE bmp_file.bmp01,
          p_bmp011  LIKE bmp_file.bmp01,
          p_acode   LIKE bmp_file.bmp28, #FUN-550079
          p_levela  LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_sql     LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(2000)
          l_bmp     RECORD 
                       bmp01  LIKE bmp_file.bmp01,
                       v1     LIKE bmo_file.bmo011,
                       desc1  LIKE ima_file.ima02,
                       desc11 LIKE ima_file.ima021,
                       bmp03  LIKE bmp_file.bmp03,
                       v2     LIKE bmo_file.bmo011,
                       desc2  LIKE ima_file.ima02,
                       desc22 LIKE ima_file.ima021,
                       item   LIKE ima_file.ima01, #正式料號
                       levela  LIKE type_file.num5,      #No.FUN-680096 SMALLINT
                       bmp28   LIKE bmp_file.bmp28 #FUN-550079
                    END RECORD
           
   LET l_sql = "SELECT                                  '','',''   ,bmp03,bmq05,bmq02,bmp03,'',bmp28                   ",   #bmq_file測試料件  #FUN-550079
               "  FROM bmp_file,bmq_file ",
               " WHERE bmp03 = bmq01 ",
               "   AND (bmq011 IS NULL OR bmq011= ' ' )",
               "   AND bmp01 = '",p_bmp01,"'",
               "   AND bmp011= '",p_bmp011,"'",
               " UNION ",
               " SELECT                                  '','',''   ,bmp03,ima05,ima02,bmp03,'',bmp28                   ",  #ima_file 正式料件 #FUN-550079
               "   FROM bmp_file,ima_file ",
               "  WHERE bmp03 = ima01 ",
               "    AND bmp01 = '",p_bmp01,"'",
               "    AND bmp011= '",p_bmp011,"'",
               "  UNION ",
               " SELECT                                  '','',''   ,bmp03,bmq05,bmq02,bmq011,'',bmp28                   ", #bmq_file-->ima_file 由測試料轉正式料的料件  #FUN-550079
               "   FROM bmp_file,bmq_file ",
               "  WHERE bmp03 = bmq01 ",
               "    AND bmq011 IS NOT NULL ",
               "    AND bmq011 != ' ' ",
               "    AND bmp01 = '",p_bmp01,"'",
               "    AND bmp011= '",p_bmp011,"'",
               "  ORDER BY bmp03 "     #No.TQC-9A0155
    PREPARE p101_ins_bom_p FROM l_sql 
	DECLARE p101_ins_bom_curs
        CURSOR WITH HOLD FOR p101_ins_bom_p
    INITIALIZE l_bmp.* TO NULL
 
    FOREACH p101_ins_bom_curs INTO l_bmp.*
       IF SQLCA.sqlcode THEN 
          
          LET g_showmsg=p_bmp01,"/",p_bmp011
          CALL s_errmsg("bmp01,bmp011",g_showmsg,"p101_ins_bom",SQLCA.sqlcode,0)
          EXIT FOREACH
       END IF
       LET l_bmp.bmp01 = p_bmp01
       LET l_bmp.v1    = p_bmp011
       LET l_bmp.levela = p_levela
       IF p_levela=1 THEN
         LET l_bmp.bmp28 = tm.bmo06
       END IF
       SELECT ima02,ima021 
         INTO l_bmp.desc1,l_bmp.desc11
         FROM ima_file
        WHERE ima01 = l_bmp.bmp01
       IF SQLCA.sqlcode = 100 THEN
           SELECT bmq02,bmq021 
             INTO l_bmp.desc1,l_bmp.desc11
             FROM bmq_file
            WHERE bmq01 = l_bmp.bmp01
       END IF
 
       INSERT INTO bom_tmp VALUES(l_bmp.*)
 
    END FOREACH
END FUNCTION
FUNCTION p101()
     CALL p101_create_tmp()
     CALL p101_create_bom_tmp()
     CALL p101_create_bed_tmp()
     CALL p101_create_bmn_tmp()
     CALL p101_tm(0,0)			
     IF INT_FLAG THEN 
         LET g_exit_while = 'Y'
         LET g_success = 'N'
         RETURN
     END IF
     IF g_change_lang = TRUE THEN
         RETURN
     END IF
     LET g_levela = 1
     LET g_ac = 0
     CALL s_showmsg_init()   #No.FUN-710014
     IF tm.f = 'Y' THEN
         CALL p101g_b_fill(tm.bmo01,tm.bmo011) #---->本階測試料件的聯產品
     END IF
     IF INT_FLAG THEN 
         LET g_exit_while = 'N'
         LET g_success = 'N'
         RETURN
     END IF
     CALL p101_b_fill(tm.bmo01,tm.bmo011,g_levela,tm.bmo06) #FUN-560030
     IF INT_FLAG THEN 
         LET g_exit_while = 'N'
         LET g_success = 'N'
         RETURN
     END IF
     CALL p101_ins(tm.bmo01,tm.bmo011,tm.firm,tm.bmo06) #FUN-550079
     IF tm.e = 'N' THEN #展單階否
         LET g_levela = g_levela + 1
         CALL p101_bom(tm.bmo01,tm.bmo011,g_levela,tm.bmo06) #FUN-550079
         IF INT_FLAG THEN 
             LET g_exit_while = 'N'
             LET g_success = 'N'
             RETURN
         END IF
     END IF
     CALL s_showmsg()  #No.FUN-710014
END FUNCTION
#No:FUN-9C0077
