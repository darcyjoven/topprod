# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: axcr774.4gl
# Descriptions...: 在製品明細表(axcr774)
# Input parameter:
# Return code....:
# Date & Author..: 98/12/10   By Billy
# Modify.........: No.MOD-530122 05/03/16 By Carol QBE欄位順序調整
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.FUN-590110 05/09/23 by vivien 報表轉XML
# Modify.........: No.TQC-5B0110 05/11/12 By CoCo 單據編號位置調整
# Modify.........: No.FUN-620066 06/03/02 By Sarah 抓資料時,多抓重覆性生產料件資料(ima911='Y'),當ima911='Y'時,則ccg04印空白
# Modify.........: No.FUN-630038 06/03/21 By Claire 少計其他,其他金額,本期其他
# Modify.........: No.FUN-670058 06/07/18 By Sarah 增加抓拆件式工單資料(cct_file,ccu_file)
# Modify.........: No.FUN-680007 06/08/03 By Sarah 將之前FUN-670058多抓cct_file,ccu_file的部份remove
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換 
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Hellen 本原幣取位修改
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0078 06/11/13 By ice 修正報表格式錯誤
# Modify.........: No.CHI-690007 06/12/28 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.TQC-710019 07/03/09 By pengu  調整報表格式
# Modify.........: No.TQC-790087 07/09/14 By Sarah 修正Primary Key後,程式判斷錯誤訊息-239時必須改變做法
# Modify.........: No.FUN-7B0043 07/11/30 By Sarah 1.Input增加 起始年月-截止年月
#                                                  2.Input增加 資料內容：1.一般工單 2.委外工單 3.全部
# Mofify.........: No.FUN-7C0101 08/01/25 By lala  成本改善增加成本計算類型(type)
# Modify.........: No.MOD-830199 08/04/19 By Pengu 開工批量資料顯示錯誤.每張工單的批量都相同
# Modify.........: No.MOD-920377 09/03/01 By Pengu 無法列印
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-9B0031 10/11/26 By Summer 重複性生產無法產生工單領用資料
# Modify.........: No:FUN-B80056 11/08/04 By Lujh 模組程序撰寫規範修正
# Modify.........: No.TQC-C20425 12/02/23 By xianghui 修改774_outnam(),在其裏面撈出g_page_line等參數
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26
# Modify.........: No:CHI-D40029 13/04/16 By yangtt 在select之前為清空變量

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                  # Print condition RECORD
           wc      LIKE type_file.chr1000, # Where condition   #No.FUN-680122 VARCHAR(300)
           yy      LIKE type_file.num5,    #起始年             #No.FUN-680122 SMALLINT
           mm      LIKE type_file.num5,    #起始月             #No.FUN-680122 SMALLINT
           yy2     LIKE type_file.num5,    #截止年             #FUN-7B0043 add
           mm2     LIKE type_file.num5,    #截止月             #FUN-7B0043 add
           type1   LIKE type_file.chr1,    #No.FUN-7C0101 VARCHAR(1)
           type    LIKE type_file.chr1,    #資料內容(1.一般工單 2.委外工單 3.全部)    #FUN-7B0043 add
           more    LIKE type_file.chr1     # Input more condition(Y/N)   #No.FUN-680122 VARCHAR(1)
           END RECORD,
       l_flag           LIKE type_file.chr1,     #No.FUN-680122 VARCHAR(1)
       g_bdate,g_edate  LIKE type_file.dat,      #No.FUN-680122DATE
       g_yy,g_mm        LIKE type_file.num5      #No.FUN-680122SMALLINT
DEFINE g_i              LIKE type_file.num5      #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE l_table          STRING                   #FUN-7B0043 add
DEFINE l_table1         STRING                   #FUN-7B0043 add
DEFINE l_sql1           STRING                   #No:CHI-9B0031 add
DEFINE l_sql            STRING                   #No:CHI-9B0031 add
DEFINE g_sql            STRING                   #FUN-7B0043 add
DEFINE g_str            STRING                   #FUN-7B0043 add
DEFINE g_zaa04_value    LIKE zaa_file.zaa04   #TQC-C20425 add
DEFINE g_zaa10_value    LIKE zaa_file.zaa10   #TQC-C20425 add
DEFINE g_zaa11_value    LIKE zaa_file.zaa11   #TQC-C20425 add
DEFINE g_zaa17_value    LIKE zaa_file.zaa17   #TQC-C20425 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
 
  #str FUN-7B0043 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>
   LET g_sql = "ccg01.ccg_file.ccg01,  ccg04.ccg_file.ccg04,",
               "ccg07.ccg_file.ccg07,",                                #No.MOD-920377 add
               "woqty.ccg_file.ccg11,  ccg11.ccg_file.ccg11,",
               "ccg21.ccg_file.ccg21,  ccg31.ccg_file.ccg31,",
               "chg.ccg_file.ccg11,    ccg91.ccg_file.ccg91,",
              #"ccg07.ccg_file.ccg07,",         #No.FUN-7C0101         #No.MOD-920377 mark
               "ccg12a.ccg_file.ccg12a,ccg12b.ccg_file.ccg12b,",
               "ccg12c.ccg_file.ccg12c,ccg12d.ccg_file.ccg12d,",
               "ccg12e.ccg_file.ccg12e,ccg12f.ccg_file.ccg12f,",       #No.FUN-7C0101
               "ccg12g.ccg_file.ccg12g,ccg12h.ccg_file.ccg12h,",       #No.FUN-7C0101
               "ccg22a.ccg_file.ccg22a,ccg22b.ccg_file.ccg22b,",
               "ccg22c.ccg_file.ccg22c,ccg22d.ccg_file.ccg22d,",
               "ccg22e.ccg_file.ccg22e,ccg22f.ccg_file.ccg22f,",       #No.FUN-7C0101
               "ccg22g.ccg_file.ccg22g,ccg22h.ccg_file.ccg22h,",       #No.FUN-7C0101
               "ccg23a.ccg_file.ccg23a,ccg23b.ccg_file.ccg23b,",
               "ccg23c.ccg_file.ccg23c,ccg23d.ccg_file.ccg23d,",
               "ccg23e.ccg_file.ccg23e,ccg23f.ccg_file.ccg23f,",       #No.FUN-7C0101
               "ccg23g.ccg_file.ccg23g,ccg23h.ccg_file.ccg23h,",       #No.FUN-7C0101
               "ccg32a.ccg_file.ccg32a,ccg32b.ccg_file.ccg32b,",
               "ccg32c.ccg_file.ccg32c,ccg32d.ccg_file.ccg32d,",
               "ccg32e.ccg_file.ccg32e,ccg32f.ccg_file.ccg32f,",       #No.FUN-7C0101
               "ccg32g.ccg_file.ccg32g,ccg32h.ccg_file.ccg32h,",       #No.FUN-7C0101
               "ccg92a.ccg_file.ccg92a,ccg92b.ccg_file.ccg92b,",
               "ccg92c.ccg_file.ccg92c,ccg92d.ccg_file.ccg92d,",
               "ccg92e.ccg_file.ccg92e,ccg92f.ccg_file.ccg92f,",       #No.FUN-7C0101
               "ccg92g.ccg_file.ccg92g,ccg92h.ccg_file.ccg92h,",       #No.FUN-7C0101
               "cch22a.cch_file.cch22a,cch22b.cch_file.cch22b,",
               "cch22c.cch_file.cch22c,cch22d.cch_file.cch22d,",
               "cch22e.cch_file.cch22e,cch22f.cch_file.cch22f,",       #No.FUN-7C0101
               "cch22g.cch_file.cch22g,cch22h.cch_file.cch22h,",       #No.FUN-7C0101
               "cch32a.cch_file.cch32a,cch32b.cch_file.cch32b,",
               "cch32c.cch_file.cch32c,cch32d.cch_file.cch32d,",
               "cch32e.cch_file.cch32e,cch32f.cch_file.cch32f,",       #No.FUN-7C0101
               "cch32g.cch_file.cch32g,cch32h.cch_file.cch32h,",       #No.FUN-7C0101
               "cch92a.cch_file.cch92a,cch92b.cch_file.cch92b,",
               "cch92c.cch_file.cch92c,cch92d.cch_file.cch92d,",
               "cch92e.cch_file.cch92e,cch92f.cch_file.cch92f,",       #No.FUN-7C0101
               "cch92g.cch_file.cch92g,cch92h.cch_file.cch92h,",       #No.FUN-7C0101
               "azi03.azi_file.azi03,azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,ccz27.ccz_file.ccz27"
 
   LET l_table = cl_prt_temptable('axcr774',g_sql) CLIPPED   # 產生Temp Table
   IF l_table  = -1 THEN EXIT PROGRAM END IF                 # Temp Table產生
 
   LET g_sql = "k.type_file.num10,        ccg01.ccg_file.ccg01,",
               "cch04.cch_file.cch04,     cch51.cch_file.cch51,",
               "unissue.cch_file.cch51,   cch55.cch_file.cch55,",
               "cch53.cch_file.cch53,     cch91.cch_file.cch91,",
               "cch21.cch_file.cch21,     cch57.cch_file.cch57,",
               "str.type_file.chr1000,    cch52.cch_file.cch52,",
               "unissueamt.cch_file.cch52,cch56.cch_file.cch56,",
               "cch54.cch_file.cch54,     cch92.cch_file.cch92,",
               "cch22.cch_file.cch22,     cch58.cch_file.cch58,",
               "azi03.azi_file.azi03,     azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,     ccz27.ccz_file.ccz27"
   LET l_table1 = cl_prt_temptable('axcr7741',g_sql) CLIPPED   # 產生Temp Table
   IF l_table1  = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
  #end FUN-7B0043 add
 
#NO.CHI-6A0004 --START
#  SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
#    FROM azi_file
#   WHERE azi01=g_aza.aza17
#NO.CHI-6A0004 --END
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate    = ARG_VAL(1)
   LET g_towhom   = ARG_VAL(2)
   LET g_rlang    = ARG_VAL(3)
   LET g_bgjob    = ARG_VAL(4)
   LET g_prtway   = ARG_VAL(5)
   LET g_copies   = ARG_VAL(6)
   LET tm.wc      = ARG_VAL(7)
   LET tm.yy      = ARG_VAL(8)
   LET tm.mm      = ARG_VAL(9)
   LET tm.yy2     = ARG_VAL(10)   #FUN-7B0043 add
   LET tm.mm2     = ARG_VAL(11)   #FUN-7B0043 add
   LET tm.type    = ARG_VAL(12)   #FUN-7B0043 add
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET tm.type1 = ARG_VAL(16)              #No.FUN-7C0101
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) or g_bgjob = 'N' THEN
      CALL axcr774_tm(0,0)
   ELSE 
      CALL axcr774()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr774_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01          #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680122 SMALLINT
   DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 12 END If
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE 
      LET p_row = 5 LET p_col = 12
   END IF
 
   OPEN WINDOW axcr774_w AT p_row,p_col WITH FORM "axc/42f/axcr774"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.yy  = g_ccz.ccz01
   LET tm.mm  = g_ccz.ccz02
   LET tm.yy2 = g_ccz.ccz01   #FUN-7B0043 add
   LET tm.mm2 = g_ccz.ccz02   #FUN-7B0043 add
   LET tm.type= '3'           #FUN-7B0043 add
   LET tm.more= 'N'
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
   LET tm.type1 = g_ccz.ccz28   #No.FUN-7C0101 add
 
   WHILE TRUE
 #MOD-530122
      CONSTRUCT BY NAME tm.wc ON ima12,ima08,ccg01,ima57,ccg04
 ##
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
           #CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION controlp
            CASE
              #str FUN-7B0043 add
               WHEN INFIELD(ima12)   #成本分群
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima13"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima12
                  NEXT FIELD ima12
               WHEN INFIELD(ima08)   #來源碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima7"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima08
                  NEXT FIELD ima08
               WHEN INFIELD(ccg01)   #工單編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_sfb"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ccg01
                  NEXT FIELD ccg01
               WHEN INFIELD(ima57)   #成本階數
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima10"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima57
                  NEXT FIELD ima57
              #end FUN-7B0043 add
#No.FUN-570240 --start
               WHEN INFIELD(ccg04)   #生產料號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima5"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ccg04
                  NEXT FIELD ccg04
#No.FUN-570240 --end
            END CASE
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW axcr774_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM
            
      END IF
      IF tm.wc=' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 
      INPUT BY NAME tm.yy,tm.mm,tm.yy2,tm.mm2,tm.type1,tm.type,tm.more   #FUN-7B0043 add tm.yy2,tm.mm2,tm.type  #No.FUN-7C0101 add 
         WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
         AFTER FIELD yy     #起始年
           IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
         AFTER FIELD mm     #起始月
           IF cl_null(tm.mm) THEN NEXT FIELD mm END IF
        #str FUN-7B0043 add
         AFTER FIELD yy2    #截止年
            IF cl_null(tm.yy2) THEN NEXT FIELD yy2 END IF
            IF tm.yy2 < tm.yy  THEN NEXT FIELD yy2 END IF
         AFTER FIELD mm2    #截止月
            IF cl_null(tm.mm2) THEN NEXT FIELD mm2 END IF
            IF tm.yy2 = tm.yy THEN
               IF tm.mm2 < tm.mm THEN NEXT FIELD mm2 END IF
            END IF
         #No.FUN-7C0101--start--
         AFTER FIELD type1
            IF cl_null(tm.type1) OR tm.type1 NOT MATCHES '[12345]' THEN
               NEXT FIELD type1
            END IF
         #No.FUN-7C0101---end---   
         AFTER FIELD type   #資料內容
            IF tm.type NOT MATCHES'[123]' THEN
                NEXT FIELD type
            END IF
        #end FUN-7B0043 add
         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies)
                         RETURNING g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies
            END IF
################################################################################
# START genero shell script ADD
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
         ON ACTION CONTROLG 
            CALL cl_cmdask()    # Command execution
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW axcr774_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
                WHERE zz01='axcr774'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('axcr774','9031',1)   
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.yy CLIPPED,"'",
                            " '",tm.mm CLIPPED,"'" ,
                            " '",tm.yy2 CLIPPED,"'",         #FUN-7B0043 add
                            " '",tm.mm2 CLIPPED,"'" ,        #FUN-7B0043 add
                            " '",tm.type1 CLIPPED,"'" ,      #No.FUN-7C0101 add
                            " '",tm.type CLIPPED,"'" ,       #FUN-7B0043 add
                            " '",g_rep_user CLIPPED,"'",     #No.FUN-570264
                            " '",g_rep_clas CLIPPED,"'",     #No.FUN-570264
                            " '",g_template CLIPPED,"'",     #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('axcr774',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW axcr774_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL axcr774()
      ERROR ""
   END WHILE
   CLOSE WINDOW axcr774_w
END FUNCTION
 
FUNCTION axcr774()
   DEFINE l_name        LIKE type_file.chr20,          #No.FUN-680122 VARCHAR(20)       # External(Disk) file name
#       l_time          LIKE type_file.chr8            #No.FUN-6A0146
         #l_sql         STRING,   #CHAR(1200),         # RDSQL STATEMENT   #FUN-670058 modify  #No:CHI-9B0031 mark
         #l_sql1        STRING,                        #FUN-7B0043 add    #No:CHI-9B0031 mark
          l_za05        LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
          l_sfm03       LIKE sfm_file.sfm03,
          l_sfm04       LIKE sfm_file.sfm04,
          l_sfm05       LIKE sfm_file.sfm05,
          l_sfm06       LIKE sfm_file.sfm06,
          l_sfb08       LIKE sfb_file.sfb08,
          l_dif,l_chg   LIKE ccg_file.ccg11,
          l_woqty       LIKE ccg_file.ccg11,
          l_cnt         LIKE type_file.num5,           #No.FUN-680122 SMALLINT
          l_cch         RECORD LIKE cch_file.*,
          bdate,edate   LIKE type_file.dat,            #FUN-7B0043 add
          sr     RECORD
                 ccg    RECORD   LIKE ccg_file.* ,   #工單在製成本檔
                 ima12  LIKE     ima_file.ima12 ,    #分群碼
                 ima911 LIKE     ima_file.ima911 ,   #是否為重覆性生產料件  #FUN-620066
                 sfb99  LIKE     sfb_file.sfb99      #重工否
                 END RECORD
 
  #str FUN-7B0043 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>>
   CALL cl_del_data(l_table)   
   CALL cl_del_data(l_table1)   
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",     #No.MOD-920377 add
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"            #No.MOD-920377 modify
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
      EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
      EXIT PROGRAM
   END IF
  #end FUN-7B0043 add
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #FUN-7B0043 add
 
   #str FUN-7B0043 mod
   #起始年月(tm.yy,tm.mm)與截止年月(tm.yy2,tm.mm2)抓取起迄日期(g_bdate,g_edate)
   CALL s_azm(tm.yy,tm.mm) RETURNING l_flag,bdate,edate
   LET g_bdate = bdate
   CALL s_azm(tm.yy2,tm.mm2) RETURNING l_flag,bdate,edate
   LET g_edate = edate
 
   CASE tm.type
      WHEN '1'   #一般工單
           LET l_sql1 = " AND sfb02 != '7' AND sfb02 != '8'"
      WHEN '2'   #委外工單
           LET l_sql1 = " AND (sfb02 = '7' OR sfb02 = '8')"
      WHEN '3'   #全部
           LET l_sql1 = " AND 1=1"
   END CASE
   #end FUN-7B0043 mod
 
   DROP TABLE r774_file
   CREATE TEMP TABLE r774_file(
       wo         LIKE type_file.chr20, 
       part       LIKE type_file.chr20, 
       amt1       LIKE ade_file.ade05,
       amt2       LIKE ade_file.ade05,
       amt3       LIKE ade_file.ade05,
       amt4       LIKE ade_file.ade05);
   create unique index r774_01 on r774_file(wo,part)
 
   LET l_sql = " SELECT sfm03,sfm04,sfm05,sfm06 FROM sfm_file  ",
               " WHERE  sfm01 =  ?  AND sfm10 = '1'",
               "  ORDER BY sfm03,sfm04"
   PREPARE r774_presfm FROM l_sql
   IF STATUS THEN CALL cl_err('r774_presfm:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM 
   END IF
   DECLARE r774_sfmcur CURSOR FOR r774_presfm
 
   LET l_sql = " SELECT cch_file.*",
               " FROM cch_file,sfb_file ",   #FUN-7B0043 add sfb_file
               " WHERE cch01 =  ? ",
               "   AND cch01 = sfb01 ",      #FUN-7B0043 add
              #str FUN-7B0043 mod
              #"   AND cch02 = ", tm.yy ,
              #"   AND cch03 = ", tm.mm ,
               "   AND (cch02*12+cch03 BETWEEN ",tm.yy*12+tm.mm,
               "                           AND ",tm.yy2*12+tm.mm2,")",
              #end FUN-7B0043 mod
               "   AND cch06 ='",tm.type1,"'",      #No.FUN-7C0101
               "   AND cch04 = ' DL+OH+SUB'"
   LET l_sql = l_sql CLIPPED,l_sql1 CLIPPED   #FUN-7B0043 add
   PREPARE r774_precch FROM l_sql
   IF STATUS THEN CALL cl_err('r774_precch:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM 
   END IF
   DECLARE r774_cchcur CURSOR FOR r774_precch

  #------------------No:CHI-9B0031 add
   LET l_sql = " SELECT cch_file.*",
               " FROM cch_file ",  
               " WHERE cch01 =  ? ",
               "   AND (cch02*12+cch03 BETWEEN ",tm.yy*12+tm.mm,
               "                           AND ",tm.yy2*12+tm.mm2,")",
               "   AND cch06 ='",tm.type1,"'",    
               "   AND cch04 = ' DL+OH+SUB'"
   PREPARE r774_precch3 FROM l_sql
   IF STATUS THEN CALL cl_err('r774_precch3:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM 
   END IF
   DECLARE r774_cchcur3 CURSOR FOR r774_precch3
  #------------------No:CHI-9B0031 end
 
   #--->在製品下階
  #------------------No:CHI-9B0031 mark --start-- 
  #LET l_sql = " SELECT cch_file.*",
  #            " FROM cch_file,sfb_file ",   #FUN-7B0043 add sfb_file
  #            " WHERE cch01 = ?   " ,
  #            "   AND cch01 = sfb01 ",      #FUN-7B0043 add
  #           #str FUN-7B0043 mod
  #           #"   AND cch02 = ", tm.yy ,
  #           #"   AND cch03 = ", tm.mm ,
  #            "   AND (cch02*12+cch03 BETWEEN ",tm.yy*12+tm.mm,
  #            "                           AND ",tm.yy2*12+tm.mm2,")",
  #           #end FUN-7B0043 mod
  #             "   AND cch06 ='",tm.type1,"'",      #No.FUN-7C0101
  #            "   AND cch04 != ' DL+OH+SUB'"
  #LET l_sql = l_sql CLIPPED,l_sql1 CLIPPED   #FUN-7B0043 add 
  #PREPARE r774_precch2 FROM l_sql
  #IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
  #   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
  #   EXIT PROGRAM 
  #END IF
  #DECLARE r774_cchcur2  CURSOR FOR r774_precch2
  #------------------No:CHI-9B0031 mark --end-- 
 
   #--->在製品上階
  #LET l_sql = " SELECT ccg_file.*,ima12,sfb99",          #FUN-620066 mark
   LET l_sql = " SELECT ccg_file.*,ima12,ima911,sfb99",   #FUN-620066
               " FROM ccg_file ,ima_file, sfb_file ",
               " WHERE ccg04=ima01 " ,
               "   AND ccg01=sfb01 " ,
              #str FUN-7B0043 mod
              #"   AND ccg02 = ", tm.yy ,
              #"   AND ccg03 = ", tm.mm ,
               "   AND (ccg02*12+ccg03 BETWEEN ",tm.yy*12+tm.mm,
               "                           AND ",tm.yy2*12+tm.mm2,")",
               "   AND ccg06 ='",tm.type1,"'",     #No.FUN-7C0101
              #end FUN-7B0043 mod
               "   AND ", tm.wc CLIPPED
   LET l_sql = l_sql CLIPPED,l_sql1 CLIPPED   #FUN-7B0043 add
   #start FUN-620066
   LET l_sql = l_sql CLIPPED,
               " UNION ",
               " SELECT ccg_file.*,",
               "        ima12,ima911,''",
               " FROM ccg_file ,ima_file  ",   #FUN-7B0043 add sfb_file  #No:CHI-9B0031 modify
               " WHERE ccg01=ima01 " ,
              #"   AND ccg01=sfb01 " ,   #FUN-7B0043 add   #No:CHI-9B0031 mark
               "   AND ima911='Y' ",
              #str FUN-7B0043 mod
              #"   AND ccg02 = ", tm.yy ,
              #"   AND ccg03 = ", tm.mm ,
               "   AND (ccg02*12+ccg03 BETWEEN ",tm.yy*12+tm.mm,
               "                           AND ",tm.yy2*12+tm.mm2,")",
              #end FUN-7B0043 mod
               "   AND ccg06 ='",tm.type1,"'",       #No.FUN-7C0101
               "   AND ", tm.wc CLIPPED
              #end FUN-620066
  #LET l_sql = l_sql CLIPPED,l_sql1 CLIPPED   #FUN-7B0043 add   #No:CHI-9B0031 mark
   PREPARE axcr774_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM 
   END IF
   DECLARE axcr774_curs1 CURSOR FOR axcr774_prepare1
 
  #str FUN-7B0043 mod
  #CALL cl_outnam('axcr774') RETURNING l_name
  #START REPORT axcr774_rep TO l_name
   CALL r774_outnam() RETURNING l_name
   START REPORT axcr774_rep1 TO l_name
  #end FUN-7B0043 mod
   LET g_pageno = 0
   FOREACH axcr774_curs1 INTO sr.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      #-->取本月之報廢量
      LET l_chg = 0    LET l_cnt = 0
      LET l_woqty = NULL   #No.MOD-830199 add
      FOREACH r774_sfmcur USING sr.ccg.ccg01
                           INTO l_sfm03,l_sfm04,l_sfm05,l_sfm06
         LET l_dif = l_sfm06 - l_sfm05
         LET l_chg = l_chg + l_dif
         IF l_cnt = 0 THEN LET l_woqty = l_sfm05 END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      IF cl_null(l_woqty) THEN
         SELECT sfb08 INTO l_sfb08 FROM sfb_file WHERE sfb01 = sr.ccg.ccg01
         IF cl_null(l_sfb08) THEN LET l_sfb08 = 0 END IF
         LET l_woqty = l_sfb08
      END IF
 
      #-->取本月之' DL+OH+SUB'
     #---------------No:CHI-9B0031 add
      IF sr.ima911 = 'Y' THEN
         OPEN r774_cchcur3 USING sr.ccg.ccg01
         FETCH r774_cchcur3 INTO l_cch.*
         CLOSE r774_cchcur3
      ELSE
     #---------------No:CHI-9B0031 end
         OPEN r774_cchcur USING sr.ccg.ccg01
         FETCH r774_cchcur INTO l_cch.*
         CLOSE r774_cchcur
      END IF      # No:CHI-9B0031 add
 
     #OUTPUT TO REPORT axcr774_rep(sr.*,l_cch.*,l_chg,l_woqty)    #FUN-7B0043 mark
      OUTPUT TO REPORT axcr774_rep1(sr.*,l_cch.*,l_chg,l_woqty)   #FUN-7B0043
   END FOREACH
 
  #FINISH REPORT axcr774_rep    #FUN-7B0043 mark
   FINISH REPORT axcr774_rep1   #FUN-7B0043
  #CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #FUN-7B0043 mark
 
  #str FUN-7B0043 add
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>>
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'ima12,ima08,ccg01,ima57,ccg04')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   #p1~p6
   LET g_str = g_str,";",tm.yy,";",tm.mm,
                     ";",tm.yy2,";",tm.mm2,";",tm.type
   #No.FUN-7C0101--start--
   IF tm.type MATCHES '[12]' THEN
   CALL cl_prt_cs3('axcr774','axcr774_1',l_sql,g_str)
   END IF
   IF tm.type MATCHES '[345]' THEN
   CALL cl_prt_cs3('axcr774','axcr774',l_sql,g_str)
   END IF
   #No.FUN-7C0101---end---
  #end FUN-7B0043 add
END FUNCTION
 
#str FUN-7B0043 mark
#REPORT axcr774_rep(sr,l_cch,l_chg,l_woqty)
#  DEFINE l_last_sw     LIKE type_file.chr1,           #No.FUN-680122CHAR(01)
#         l_chg         LIKE ccg_file.ccg11,
#         l_woqty       LIKE ccg_file.ccg11,
#         l_unissue     LIKE sfa_file.sfa05,
#         l_unissuea,l_unissueb,l_unissuec,l_unissued,l_unissuee      LIKE ccc_file.ccc23a,   #FUN-630038 add l_unissuee 
#         l_sumcch52a,l_sumcch52b,l_sumcch52c,l_sumcch52d,l_sumcch52e LIKE cch_file.cch22a,   #FUN-630038 add l_sumcch52e
#         l_sumunissuea,l_sumunissueb,l_sumunissuec LIKE sfa_file.sfa05,
#         l_sumunissued,l_sumunissuee               LIKE sfa_file.sfa05,                      #FUN-630038 add l_sumunissuee 
#         l_sumcch56a,l_sumcch56b,l_sumcch56c,l_sumcch56d,l_sumcch56e LIKE ccc_file.ccc23a,   #FUN-630038 add l_sumcch56e
#         l_sumcch54a,l_sumcch54b,l_sumcch54c,l_sumcch54d,l_sumcch54e LIKE cch_file.cch32a,   #FUN-630038 add l_sumcch54e
#         l_totcch92a,l_totcch92b,l_totcch92c,l_totcch92d,l_totcch92e LIKE cch_file.cch92a,   #FUN-630038 add l_totcch92e
#         l_totcch22a,l_totcch22b,l_totcch22c,l_totcch22d,l_totcch22e LIKE cch_file.cch22a,   #FUN-630038 add l_totcch22e
#         l_totcch58a,l_totcch58b,l_totcch58c,l_totcch58d,l_totcch58e LIKE ccc_file.ccc23a,   #FUN-630038 add l_totcch58e
#         l_sumcch51    LIKE cch_file.cch21,
#         l_sumunissue  LIKE cch_file.cch21,
#         l_sumcch55    LIKE cch_file.cch21,
#         l_sumcch31    LIKE cch_file.cch21,
#         l_totcch91    LIKE cch_file.cch21,
#         l_totcch21    LIKE cch_file.cch21,
#         l_totcch57    LIKE cch_file.cch21,
#         l_cch         RECORD LIKE cch_file.*,
#         l_ccc         RECORD LIKE ccc_file.*,
#         l_cch2        RECORD LIKE cch_file.*,
#         l_cnt         LIKE type_file.num5,          #No.FUN-680122 SMALLINT
#         sr            RECORD
#                 ccg     RECORD   LIKE ccg_file.* ,   #工單在製成本檔
#                 ima12   LIKE     ima_file.ima12,     #分群碼
#                 ima911  LIKE     ima_file.ima911 ,   #是否為重覆性生產料件  #FUN-620066
#                 sfb99   LIKE     sfb_file.sfb99      #重工否
#                 END RECORD
#
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
# ORDER BY sr.ima12 ,sr.sfb99, sr.ccg.ccg01
# 
# FORMAT
#   PAGE HEADER
##No.FUN-590110 --start
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1 ,g_x[1] CLIPPED   #No.TQC-6A0078
#
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,
#           g_x[11] CLIPPED,' ',tm.yy CLIPPED,
#           "-",tm.mm USING'&&' CLIPPED
#     PRINT g_dash[1,g_len]
#    #start FUN-620066
#    #PRINT COLUMN  1,g_x[12] CLIPPED,sr.ccg.ccg01,
#    #      COLUMN 28,g_x[32] CLIPPED,sr.ccg.ccg04  ##TQC-5B0110&051112 23->28 ##
#     IF cl_null(sr.ima911) OR sr.ima911 != 'Y' THEN
#        PRINT COLUMN  1,g_x[12] CLIPPED,sr.ccg.ccg01,
#              COLUMN 51,g_x[32] CLIPPED,sr.ccg.ccg04
#     ELSE
#        PRINT COLUMN  1,g_x[32] CLIPPED,sr.ccg.ccg04 
#     END IF
#    #end FUN-620066
# 
#     PRINT COLUMN   1,g_x[33] CLIPPED, cl_numfor(l_woqty     ,14,g_ccz.ccz27), #CHI-690007 0->ccz27
#           COLUMN  25,g_x[34] CLIPPED, cl_numfor(sr.ccg.ccg11,14,g_ccz.ccz27), #CHI-690007 0->ccz27
#           COLUMN  49,g_x[35] CLIPPED, cl_numfor(sr.ccg.ccg21,14,g_ccz.ccz27), #CHI-690007 0->ccz27
#           COLUMN  73,g_x[36] CLIPPED, cl_numfor(sr.ccg.ccg31,14,g_ccz.ccz27), #CHI-690007 0->ccz27
#           COLUMN  97,g_x[37] CLIPPED, cl_numfor(l_chg       ,14,g_ccz.ccz27), #CHI-690007 0->ccz27
#           COLUMN 120,g_x[38] CLIPPED, cl_numfor(sr.ccg.ccg91,14,g_ccz.ccz27)  #CHI-690007 0->ccz27
#
#     PRINT ' '
#    #-----------------No.TQC-710019 modify
#    #PRINT COLUMN 1,g_x[15] clipped,g_x[16] clipped,g_x[25] clipped    #No.TQC-6A0078
#     PRINT COLUMN 10,g_x[15] clipped,g_x[16] clipped,g_x[25] clipped    #No.TQC-6A0078
#    #-----------------No.TQC-710019 end
#                    ,g_x[41] clipped   #FUN-630038
#     #--->初存金額
#     PRINT COLUMN 1  , g_x[14] CLIPPED ,
#           COLUMN 11 , cl_numfor(sr.ccg.ccg12a,18,g_azi03),    #FUN-570190
#           COLUMN 30 , cl_numfor(sr.ccg.ccg12b,18,g_azi03),    #FUN-570190
#           COLUMN 49 , cl_numfor(sr.ccg.ccg12c,18,g_azi03),    #FUN-570190
#           COLUMN 68 , cl_numfor(sr.ccg.ccg12d,18,g_azi03)     #FUN-570190  #FUN-630038 ccg12c->ccg12d
#          ,COLUMN 77 , cl_numfor(sr.ccg.ccg12e,18,g_azi03)     #FUN-630038
#
#     #--->本期投入
#     IF cl_null(l_cch.cch22b) THEN LET l_cch.cch22b = 0 END IF
#     IF cl_null(l_cch.cch22c) THEN LET l_cch.cch22c = 0 END IF
#     IF cl_null(l_cch.cch22d) THEN LET l_cch.cch22d = 0 END IF
#     IF cl_null(l_cch.cch22e) THEN LET l_cch.cch22e = 0 END IF  #FUN-630038
#     PRINT COLUMN  1 , g_x[17] CLIPPED ,
#           COLUMN 11 , cl_numfor((sr.ccg.ccg22a+sr.ccg.ccg23a),18,g_azi03),    #FUN-570190
#           COLUMN 30 , cl_numfor((sr.ccg.ccg22b+sr.ccg.ccg23b),18,g_azi03),    #FUN-570190
#           COLUMN 49 , cl_numfor((sr.ccg.ccg22c+sr.ccg.ccg23c),18,g_azi03),    #FUN-570190
#           COLUMN 68 , cl_numfor((sr.ccg.ccg22d+sr.ccg.ccg23d),18,g_azi03),    #FUN-570190
#           COLUMN 77 , cl_numfor((sr.ccg.ccg22e+sr.ccg.ccg23e),18,g_azi03),    #FUN-630038
#           COLUMN 105, cl_numfor(l_cch.cch22b,18,g_azi03),    #FUN-570190   #FUN-630038  87->105
#           COLUMN 125, cl_numfor(l_cch.cch22c,18,g_azi03),    #FUN-570190    #FUN-630038 106->125
#           COLUMN 143, cl_numfor(l_cch.cch22d,18,g_azi03)     #FUN-570190    #FUN-630038 125->143
#          ,COLUMN 163, cl_numfor(l_cch.cch22e,18,g_azi03)     #FUN-630038  
#
#     #--->本期產出
#     IF cl_null(l_cch.cch32b) THEN LET l_cch.cch32b = 0 END IF
#     IF cl_null(l_cch.cch32c) THEN LET l_cch.cch32c = 0 END IF
#     IF cl_null(l_cch.cch32d) THEN LET l_cch.cch32d = 0 END IF
#     IF cl_null(l_cch.cch32e) THEN LET l_cch.cch32e = 0 END IF #FUN-630038
#     PRINT COLUMN  1 , g_x[18] CLIPPED ,
#           COLUMN 11 , cl_numfor(sr.ccg.ccg32a,18,g_azi03),    #FUN-570190
#           COLUMN 30 , cl_numfor(sr.ccg.ccg32b,18,g_azi03),    #FUN-570190
#           COLUMN 49 , cl_numfor(sr.ccg.ccg32c,18,g_azi03),    #FUN-570190
#           COLUMN 68 , cl_numfor(sr.ccg.ccg32d,18,g_azi03),    #FUN-570190
#           COLUMN 77 , cl_numfor(sr.ccg.ccg32e,18,g_azi03),    #FUN-630038  
#           COLUMN 105, cl_numfor(l_cch.cch32b, 18,g_azi03),   #FUN-570190  #FUN-630038  87->105
#           COLUMN 125, cl_numfor(l_cch.cch32c, 18,g_azi03),    #FUN-570190  #FUN-630038 106->125
#           COLUMN 143, cl_numfor(l_cch.cch32d, 18,g_azi03)     #FUN-570190  #FUN-630038 125->143   cch32c->cch32d
#          ,COLUMN 163, cl_numfor(l_cch.cch32e, 18,g_azi03)     #FUN-630038
#
#     #--->末存金額
#     IF cl_null(l_cch.cch92b) THEN LET l_cch.cch92b = 0 END IF
#     IF cl_null(l_cch.cch92c) THEN LET l_cch.cch92c = 0 END IF
#     IF cl_null(l_cch.cch92d) THEN LET l_cch.cch92d = 0 END IF
#     IF cl_null(l_cch.cch92e) THEN LET l_cch.cch92e = 0 END IF #FUN-630038 
#     PRINT COLUMN  1 , g_x[39] CLIPPED ,
#           COLUMN 11 , cl_numfor(sr.ccg.ccg92a,18,g_azi03),    #FUN-570190
#           COLUMN 30 , cl_numfor(sr.ccg.ccg92b,18,g_azi03),    #FUN-570190
#           COLUMN 49 , cl_numfor(sr.ccg.ccg92c,18,g_azi03),    #FUN-570190
#           COLUMN 68 , cl_numfor(sr.ccg.ccg92d,18,g_azi03),    #FUN-570190
#           COLUMN 77 , cl_numfor(sr.ccg.ccg92e,18,g_azi03),    #FUN-630038
#           COLUMN 105, cl_numfor(l_cch.cch92b, 18,g_azi03),    #FUN-570190  #FUN-630038  87->105
#           COLUMN 125, cl_numfor(l_cch.cch92c, 18,g_azi03),    #FUN-570190  #FUN-630038 106->125
#           COLUMN 143, cl_numfor(l_cch.cch92d, 18,g_azi03)     #FUN-570190  #FUN-630038 125->143
#          ,COLUMN 163, cl_numfor(l_cch.cch92e, 18,g_azi03)     #FUN-630038
##No.FUN-590110 --end
#
#     #--->Title
#     PRINT ' '
##No.FUN-590110 --start
#     PRINT g_x[51],g_x[52],g_x[53],g_x[54],g_x[55],g_x[56],g_x[57],g_x[58]
#     PRINT g_dash1
##    PRINT COLUMN   4,g_x[13] CLIPPED, COLUMN  24,g_x[40] CLIPPED,
##          COLUMN  41,g_x[41] CLIPPED, COLUMN  57,g_x[42] CLIPPED,
##          COLUMN  74,g_x[43] CLIPPED, COLUMN  90,g_x[44] CLIPPED,
##          COLUMN 106,g_x[45] CLIPPED, COLUMN 122,g_x[46] CLIPPED
##    PRINT '-------------------- --------------- --------------- ',
##          '--------------- --------------- --------------- ',
##          '--------------- ---------------'
##No.FUN-590110 --end
#     LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.ccg.ccg01
#     LET l_sumcch51     = 0 LET l_sumunissue   = 0
#     LET l_sumcch55     = 0 LET l_sumcch31     = 0
#     LET l_totcch91     = 0 LET l_totcch21     = 0
#     LET l_totcch57     = 0
#
#     LET l_sumcch52a    = 0 LET l_sumunissuea  = 0
#     LET l_sumcch56a    = 0 LET l_sumcch54a    = 0
#     LET l_totcch92a    = 0 LET l_totcch22a    = 0
#     LET l_totcch58a    = 0
#
#     LET l_sumcch52b    = 0 LET l_sumunissueb  = 0
#     LET l_sumcch56b    = 0 LET l_sumcch54b    = 0
#     LET l_totcch92b    = 0 LET l_totcch22b    = 0
#     LET l_totcch58b  = 0
#
#     LET l_sumcch52c    = 0 LET l_sumunissuec  = 0
#     LET l_sumcch56c    = 0 LET l_sumcch54c    = 0
#     LET l_totcch92c    = 0 LET l_totcch22c    = 0
#     LET l_totcch58c    = 0
#
#     LET l_sumcch52d    = 0 LET l_sumunissued  = 0
#     LET l_sumcch56d    = 0 LET l_sumcch54d    = 0
#     LET l_totcch92d    = 0 LET l_totcch22d    = 0
#     LET l_totcch58d    = 0
#
#    #FUN-630038-begin
#     LET l_sumcch52e    = 0 LET l_sumunissuee  = 0
#     LET l_sumcch56e    = 0 LET l_sumcch54e    = 0
#     LET l_totcch92e    = 0 LET l_totcch22e    = 0
#     LET l_totcch58e    = 0
#    #FUN-630038-end
#     SKIP TO TOP OF PAGE
#
#   ON EVERY ROW
#     #-->列印明細
#     FOREACH r774_cchcur2 USING sr.ccg.ccg01 INTO l_cch2.*
#       #-->單位成本
#       SELECT * INTO l_ccc.* FROM ccc_file WHERE ccc01 = l_cch2.cch04
#                                             AND ccc02 = tm.yy
#                                             AND ccc03 = tm.mm
#       IF cl_null(l_ccc.ccc23a) THEN LET l_ccc.ccc23a = 0 END IF
#       IF cl_null(l_ccc.ccc23b) THEN LET l_ccc.ccc23b = 0 END IF
#       IF cl_null(l_ccc.ccc23c) THEN LET l_ccc.ccc23c = 0 END IF
#
#       #-->未發需求
#       SELECT (sfa05-sfa06) INTO l_unissue FROM sfa_file
#                                          WHERE sfa01 = sr.ccg.ccg01
#                                            AND sfa03 = l_cch2.cch04
#       IF cl_null(l_unissue) THEN LET l_unissue = 0 END IF
#
#       #-->列印數量
##No.FUN-590110 --start
#       PRINT COLUMN  g_c[51],l_cch2.cch04 CLIPPED,
#            #CHI-690007................begin
#            #COLUMN  g_c[52],l_cch2.cch51   USING '--------------&',  #累計發料
#            #COLUMN  g_c[53],l_unissue      USING '--------------&',  #未發需求
#            #COLUMN  g_c[54],l_cch2.cch55   USING '--------------&',  #累計超領退
#            #COLUMN  g_c[55],l_cch2.cch53   USING '--------------&',  #累計完成
#            #COLUMN  g_c[56],l_cch2.cch91   USING '--------------&',  #期末在製
#            #COLUMN  g_c[57],l_cch2.cch21   USING '--------------&',  #本期發料
#            #COLUMN  g_c[58],l_cch2.cch57   USING '--------------&'   #本期超領退
#             COLUMN  g_c[52],cl_numfor(l_cch2.cch51,52,g_ccz.ccz27)  ,  #累計發料
#             COLUMN  g_c[53],cl_numfor(l_unissue   ,53,g_ccz.ccz27)  ,  #未發需求
#             COLUMN  g_c[54],cl_numfor(l_cch2.cch55,54,g_ccz.ccz27)  ,  #累計超領退
#             COLUMN  g_c[55],cl_numfor(l_cch2.cch53,55,g_ccz.ccz27)  ,  #累計完成
#             COLUMN  g_c[56],cl_numfor(l_cch2.cch91,56,g_ccz.ccz27)  ,  #期末在製
#             COLUMN  g_c[57],cl_numfor(l_cch2.cch21,57,g_ccz.ccz27)  ,  #本期發料
#             COLUMN  g_c[58],cl_numfor(l_cch2.cch57,58,g_ccz.ccz27)     #本期超領退
#            #CHI-690007................end
#       LET l_sumcch51     = l_sumcch51   + l_cch2.cch51
#       LET l_sumunissue   = l_sumunissue + l_unissue
#       LET l_sumcch55     = l_sumcch55   + l_cch2.cch55
#       LET l_sumcch31     = l_sumcch31   + l_cch2.cch53
#       LET l_totcch91     = l_totcch91   + l_cch2.cch91
#       LET l_totcch21     = l_totcch21   + l_cch2.cch21
#       LET l_totcch57     = l_totcch57   + l_cch2.cch57
#
#       #-->列印材料
#       LET l_unissuea = l_unissue * l_ccc.ccc23a
#       PRINT COLUMN  g_c[51],g_x[19] CLIPPED,
#             COLUMN  g_c[52],cl_numfor(l_cch2.cch52a,52,g_azi03),  #累計發料    #FUN-570190
#             COLUMN  g_c[53],cl_numfor(l_unissuea   ,53,g_azi03),  #未發需求    #FUN-570190
#             COLUMN  g_c[54],cl_numfor(l_cch2.cch56a,54,g_azi03),  #累計超領退    #FUN-570190
#             COLUMN  g_c[55],cl_numfor(l_cch2.cch54a,55,g_azi03),  #累計完成      #FUN-570190
#             COLUMN  g_c[56],cl_numfor(l_cch2.cch92a,56,g_azi03),  #期末在製    #FUN-570190
#             COLUMN  g_c[57],cl_numfor(l_cch2.cch22a,57,g_azi03),  #本期發料    #FUN-570190
#             COLUMN  g_c[58],cl_numfor(l_cch2.cch58a,58,g_azi03)   #本期超領退    #FUN-570190
#
#       LET l_sumcch52a    = l_sumcch52a   + l_cch2.cch52a
#       LET l_sumunissuea  = l_sumunissuea + l_unissuea
#       LET l_sumcch56a    = l_sumcch56a   + l_cch2.cch56a
#       LET l_sumcch54a    = l_sumcch54a   + l_cch2.cch54a
#       LET l_totcch92a    = l_totcch92a   + l_cch2.cch92a
#       LET l_totcch22a    = l_totcch22a   + l_cch2.cch22a
#       LET l_totcch58a    = l_totcch58a   + l_cch2.cch58a
#
#       #-->列印人工
#       LET l_unissueb = l_unissue * l_ccc.ccc23b
#       PRINT COLUMN  g_c[51],g_x[20] CLIPPED,
#             COLUMN  g_c[52],cl_numfor(l_cch2.cch52b,52,g_azi03),  #累計發料    #FUN-570190
#             COLUMN  g_c[53],cl_numfor(l_unissueb,53,g_azi03),     #未發需求    #FUN-570190
#             COLUMN  g_c[54],cl_numfor(l_cch2.cch56b,54,g_azi03),  #累計超領退    #FUN-570190
#             COLUMN  g_c[55],cl_numfor(l_cch2.cch54b,55,g_azi03),  #累計完成      #FUN-570190
#             COLUMN  g_c[56],cl_numfor(l_cch2.cch92b,56,g_azi03),  #期末在製    #FUN-570190
#             COLUMN  g_c[57],cl_numfor(l_cch2.cch22b,57,g_azi03),  #本期發料    #FUN-570190
#             COLUMN  g_c[58],cl_numfor(l_cch2.cch58b,58,g_azi03)   #本期超領退    #FUN-570190
#
#       LET l_sumcch52b    = l_sumcch52b   + l_cch2.cch52b
#       LET l_sumunissueb  = l_sumunissueb + l_unissueb
#       LET l_sumcch56b    = l_sumcch56b   + l_cch2.cch56b
#       LET l_sumcch54b    = l_sumcch54b   + l_cch2.cch54b
#       LET l_totcch92b    = l_totcch92b   + l_cch2.cch92b
#       LET l_totcch22b    = l_totcch22b   + l_cch2.cch22b
#       LET l_totcch58b    = l_totcch58b   + l_cch2.cch58b
#
#       #-->列印製造
#       LET l_unissuec = l_unissue * l_ccc.ccc23c
#       PRINT COLUMN  g_c[51],g_x[21] CLIPPED,
#             COLUMN  g_c[52],cl_numfor(l_cch2.cch52c,52,g_azi03),  #累計發料    #FUN-570190
#             COLUMN  g_c[53],cl_numfor(l_unissuec   ,53,g_azi03),  #未發需求    #FUN-570190
#             COLUMN  g_c[54],cl_numfor(l_cch2.cch56c,54,g_azi03),  #累計超領退    #FUN-570190
#             COLUMN  g_c[55],cl_numfor(l_cch2.cch54c,55,g_azi03),  #累計完成      #FUN-570190
#             COLUMN  g_c[56],cl_numfor(l_cch2.cch92c,56,g_azi03),  #期末圭製    #FUN-570190
#             COLUMN  g_c[57],cl_numfor(l_cch2.cch22c,57,g_azi03),  #本期發料    #FUN-570190
#             COLUMN  g_c[58],cl_numfor(l_cch2.cch58c,58,g_azi03)   #本期超領退    #FUN-570190
#
#       LET l_sumcch52c    = l_sumcch52c   + l_cch2.cch52c
#       LET l_sumunissuec  = l_sumunissuec + l_unissuec
#       LET l_sumcch56c    = l_sumcch56c   + l_cch2.cch56c
#       LET l_sumcch54c    = l_sumcch54c   + l_cch2.cch54c
#       LET l_totcch92c    = l_totcch92c   + l_cch2.cch92c
#       LET l_totcch22c    = l_totcch22c   + l_cch2.cch22c
#       LET l_totcch58c    = l_totcch58c   + l_cch2.cch58c
#
#       #-->列印加工
#       LET l_unissued = l_unissue * l_ccc.ccc23d
#       PRINT COLUMN  g_c[51],g_x[24] CLIPPED,
#             COLUMN  g_c[52],cl_numfor(l_cch2.cch52d,52,g_azi03),  #累計發料    #FUN-570190
#             COLUMN  g_c[53],cl_numfor(l_unissued   ,53,g_azi03),  #未發需求    #FUN-570190
#             COLUMN  g_c[54],cl_numfor(l_cch2.cch56d,54,g_azi03),  #累計超領退    #FUN-570190
#             COLUMN  g_c[55],cl_numfor(l_cch2.cch54d,55,g_azi03),  #累計完成      #FUN-570190
#             COLUMN  g_c[56],cl_numfor(l_cch2.cch92d,56,g_azi03),  #期末圭製    #FUN-570190
#             COLUMN  g_c[57],cl_numfor(l_cch2.cch22d,57,g_azi03),  #本期發料    #FUN-570190
#             COLUMN  g_c[58],cl_numfor(l_cch2.cch58d,58,g_azi03)   #本期超領退    #FUN-570190
##No.FUN-590110 --end
#
#       LET l_sumcch52d    = l_sumcch52d   + l_cch2.cch52d
#       LET l_sumunissued  = l_sumunissued + l_unissued
#       LET l_sumcch56d    = l_sumcch56d   + l_cch2.cch56d
#       LET l_sumcch54d    = l_sumcch54d   + l_cch2.cch54d
#       LET l_totcch92d    = l_totcch92d   + l_cch2.cch92d
#       LET l_totcch22d    = l_totcch22d   + l_cch2.cch22d
#       LET l_totcch58d    = l_totcch58d   + l_cch2.cch58d
#
#       #FUN-630038-begin
#       #-->列印其他
#       LET l_unissuee = l_unissue * l_ccc.ccc23e
#       PRINT COLUMN g_c[51],g_x[40] CLIPPED,
#             COLUMN  g_c[52],cl_numfor(l_cch2.cch52e,52,g_azi03),  #累計發料    #FUN-570190
#             COLUMN  g_c[53],cl_numfor(l_unissuee   ,53,g_azi03),  #未發需求    #FUN-570190
#             COLUMN  g_c[54],cl_numfor(l_cch2.cch56e,54,g_azi03),  #累計超領退    #FUN-570190
#             COLUMN  g_c[55],cl_numfor(l_cch2.cch54e,55,g_azi03),  #累計完成    #FUN-570190
#             COLUMN  g_c[56],cl_numfor(l_cch2.cch92e,56,g_azi03),  #期末圭製    #FUN-570190
#             COLUMN  g_c[57],cl_numfor(l_cch2.cch22e,57,g_azi03),  #本期發料    #FUN-570190
#             COLUMN  g_c[58],cl_numfor(l_cch2.cch58e,58,g_azi03)   #本期超領退    #FUN-570190
#
#       LET l_sumcch52e    = l_sumcch52e   + l_cch2.cch52e
#       LET l_sumunissuee  = l_sumunissuee + l_unissuee
#       LET l_sumcch56e    = l_sumcch56e   + l_cch2.cch56e
#       LET l_sumcch54e    = l_sumcch54e   + l_cch2.cch54e
#       LET l_totcch92e    = l_totcch92e   + l_cch2.cch92e
#       LET l_totcch22e    = l_totcch22e   + l_cch2.cch22e
#       LET l_totcch58e    = l_totcch58e   + l_cch2.cch58e
#       #FUN-630038-end
#
#       INSERT INTO r774_file VALUES(l_cch2.cch01,l_cch2.cch04,
#                                    l_cch2.cch22a,
#                                    l_cch2.cch22b,
#                                    l_cch2.cch22c,
#                                    l_cch2.cch22d,l_cch2.cch22e)  #FUN-630038 add l_cch.cch22e
#      #IF SQLCA.sqlcode = -239  THEN             #TQC-790087 mark
#       IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #TQC-790087
#          UPDATE r774_file SET amt1 = amt1 + l_cch2.cch22a,
#                               amt2 = amt2 + l_cch2.cch22b,
#                               amt3 = amt3 + l_cch2.cch22c,
#                               amt4 = amt4 + l_cch2.cch22d
#                              ,amt5 = amt5 + l_cch2.cch22e       #FUN-630038
#           WHERE wo = l_cch2.cch01 AND part = l_cch2.cch04
#       END IF
#
#     END FOREACH
#
#   AFTER GROUP OF sr.ccg.ccg01
#     PRINT g_x[26] CLIPPED,g_dash[21,g_len]
##No.FUN-590110 --start
#     #-->列印數量
#     PRINT COLUMN g_c[51],g_x[31] clipped,
#          #CHI-690007..............begin
#          #COLUMN  g_c[52],l_sumcch51        USING '--------------&',  #累計發料
#          #COLUMN  g_c[53],l_sumunissue      USING '--------------&',  #未發需求
#          #COLUMN  g_c[54],l_sumcch55        USING '--------------&',  #累計超領退
#          #COLUMN  g_c[55],l_sumcch31        USING '--------------&',  #累計完成
#          #COLUMN  g_c[56],l_totcch91        USING '--------------&',  #期末在製
#          #COLUMN  g_c[57],l_totcch21        USING '--------------&',  #本期發料
#          #COLUMN  g_c[58],l_totcch57        USING '--------------&'   #本期超領退
#           COLUMN  g_c[52],cl_numfor(l_sumcch51  ,52,g_ccz.ccz27)    ,  #累計發料
#           COLUMN  g_c[53],cl_numfor(l_sumunissue,53,g_ccz.ccz27)    ,  #未發需求
#           COLUMN  g_c[54],cl_numfor(l_sumcch55  ,54,g_ccz.ccz27)    ,  #累計超領退
#           COLUMN  g_c[55],cl_numfor(l_sumcch31  ,55,g_ccz.ccz27)    ,  #累計完成
#           COLUMN  g_c[56],cl_numfor(l_totcch91  ,56,g_ccz.ccz27)    ,  #期末在製
#           COLUMN  g_c[57],cl_numfor(l_totcch21  ,57,g_ccz.ccz27)    ,  #本期發料
#           COLUMN  g_c[58],cl_numfor(l_totcch57  ,58,g_ccz.ccz27)       #本期超領退
#          #CHI-690007..............end
#     #-->列印材料
#     PRINT COLUMN  g_c[51],g_x[19] CLIPPED,
#           COLUMN  g_c[52],cl_numfor(l_sumcch52a  ,52,g_azi03),       #累計發料    #FUN-570190
#           COLUMN  g_c[53],cl_numfor(l_sumunissuea,53,g_azi03),       #未發需求    #FUN-570190
#           COLUMN  g_c[54],cl_numfor(l_sumcch56a  ,54,g_azi03),       #累計超領退    #FUN-570190
#           COLUMN  g_c[55],cl_numfor(l_sumcch54a  ,55,g_azi03),       #累計完成      #FUN-570190
#           COLUMN  g_c[56],cl_numfor(l_totcch92a  ,56,g_azi03),       #期末在製    #FUN-570190
#           COLUMN  g_c[57],cl_numfor(l_totcch22a  ,57,g_azi03),       #本期發料    #FUN-570190
#           COLUMN  g_c[58],cl_numfor(l_totcch58a  ,58,g_azi03)        #本期超領退    #FUN-570190
#
#     #-->列印人工
#     PRINT COLUMN  g_c[51],g_x[20] CLIPPED,
#           COLUMN  g_c[52],cl_numfor(l_sumcch52b  ,52,g_azi03),        #累計發料    #FUN-570190
#           COLUMN  g_c[53],cl_numfor(l_sumunissueb,53,g_azi03),        #未發需求    #FUN-570190
#           COLUMN  g_c[54],cl_numfor(l_sumcch56b  ,54,g_azi03),        #累計超領退    #FUN-570190
#           COLUMN  g_c[55],cl_numfor(l_sumcch54b  ,55,g_azi03),        #累計完成      #FUN-570190
#           COLUMN  g_c[56],cl_numfor(l_totcch92b  ,56,g_azi03),        #期末在製    #FUN-570190
#           COLUMN  g_c[57],cl_numfor(l_totcch22b  ,57,g_azi03),        #本期發料    #FUN-570190
#           COLUMN  g_c[58],cl_numfor(l_totcch58b  ,58,g_azi03)         #本期超領退    #FUN-570190
#
#     #-->列印製造
#     PRINT COLUMN  g_c[51],g_x[21] CLIPPED,
#           COLUMN  g_c[52],cl_numfor(l_sumcch52c  ,52,g_azi03),        #累計發料    #FUN-570190
#           COLUMN  g_c[53],cl_numfor(l_sumunissuec,53,g_azi03),        #未發需求    #FUN-570190
#           COLUMN  g_c[54],cl_numfor(l_sumcch56c  ,54,g_azi03),        #累計超領退    #FUN-570190
#           COLUMN  g_c[55],cl_numfor(l_sumcch54c  ,55,g_azi03),        #累計完成      #FUN-570190
#           COLUMN  g_c[56],cl_numfor(l_totcch92c  ,56,g_azi03),        #期末在製    #FUN-570190
#           COLUMN  g_c[57],cl_numfor(l_totcch22c  ,57,g_azi03),        #本期發料    #FUN-570190
#           COLUMN  g_c[58],cl_numfor(l_totcch58c  ,58,g_azi03)         #本期超領退    #FUN-570190
#
#     #-->列印加工
#     PRINT COLUMN  g_c[51],g_x[24] CLIPPED,
#           COLUMN  g_c[52],cl_numfor(l_sumcch52d  ,52,g_azi03),        #累計發料    #FUN-570190
#           COLUMN  g_c[53],cl_numfor(l_sumunissued,53,g_azi03),        #未發需求    #FUN-570190
#           COLUMN  g_c[54],cl_numfor(l_sumcch56d  ,54,g_azi03),        #累計超領退    #FUN-570190
#           COLUMN  g_c[55],cl_numfor(l_sumcch54d  ,55,g_azi03),        #累計完成      #FUN-570190
#           COLUMN  g_c[56],cl_numfor(l_totcch92d  ,56,g_azi03),        #期末在製    #FUN-570190
#           COLUMN  g_c[57],cl_numfor(l_totcch22d  ,57,g_azi03),        #本期發料    #FUN-570190
#           COLUMN  g_c[58],cl_numfor(l_totcch58d  ,58,g_azi03)         #本期超領退    #FUN-570190
##No.FUN-590110 --end
#
#     #FUN-630038-begin
#     #-->列印其他
#     PRINT COLUMN g_c[51],g_x[40] CLIPPED,
#          COLUMN  g_c[52],cl_numfor(l_sumcch52e  ,52,g_azi03),        #累計發料    #FUN-570190
#          COLUMN  g_c[53],cl_numfor(l_sumunissuee,53,g_azi03),        #未發需求    #FUN-570190
#          COLUMN  g_c[54],cl_numfor(l_sumcch56e  ,54,g_azi03),        #累計超領退    #FUN-570190
#          COLUMN  g_c[55],cl_numfor(l_sumcch54e  ,55,g_azi03),        #累計完成    #FUN-570190
#          COLUMN  g_c[56],cl_numfor(l_totcch92e  ,56,g_azi03),        #期末在製    #FUN-570190
#          COLUMN  g_c[57],cl_numfor(l_totcch22e  ,57,g_azi03),        #本期發料    #FUN-570190
#          COLUMN  g_c[58],cl_numfor(l_totcch58e  ,58,g_azi03)         #本期超領退    #FUN-570190
#     #FUN-630038-end
#  
#   ON LAST ROW
#     PRINT g_dash[1,g_len]
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#  
#   PAGE TRAILER
#     IF l_last_sw = 'n' THEN
#        PRINT g_dash[1,g_len] CLIPPED
#        PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#     ELSE 
#        SKIP 2 LINE
#     END IF
#END REPORT
##Patch....NO.TQC-610037 <> #
#end FUN07B0043 mark
 
#str FUN-7B0043 add
REPORT axcr774_rep1(sr,l_cch,l_chg,l_woqty)
   DEFINE l_last_sw    LIKE type_file.chr1,      #No.FUN-680122 VARCHAR(01)
          sr           RECORD
                        ccg    RECORD LIKE ccg_file.*,   #工單在製成本檔
                        ima12  LIKE ima_file.ima12,      #分群碼
                        ima911 LIKE ima_file.ima911,     #是否為重覆性生產料件  #FUN-620066
                        sfb99  LIKE sfb_file.sfb99       #重工否
                       END RECORD,
          l_cch        RECORD LIKE cch_file.*,
          l_chg        LIKE ccg_file.ccg11,
          l_woqty      LIKE ccg_file.ccg11,
          l_ccc        RECORD LIKE ccc_file.*,
          l_cch2       RECORD LIKE cch_file.*,
          l_k          LIKE type_file.num10,
          l_str        LIKE type_file.chr1000,
          l_zero       LIKE type_file.num5,
          l_unissue    LIKE sfa_file.sfa05,
          l_unissuea,l_unissueb,l_unissuec,l_unissued,l_unissuee LIKE ccc_file.ccc23a    #FUN-630038 add l_unissuee 
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.ccg.ccg01
 
  FORMAT
   #PAGE HEADER
    BEFORE GROUP OF sr.ccg.ccg01
      #--->本期投入
      IF cl_null(l_cch.cch22a) THEN LET l_cch.cch22a = 0 END IF    #No.MOD-920377 add
      IF cl_null(l_cch.cch22b) THEN LET l_cch.cch22b = 0 END IF
      IF cl_null(l_cch.cch22c) THEN LET l_cch.cch22c = 0 END IF
      IF cl_null(l_cch.cch22d) THEN LET l_cch.cch22d = 0 END IF
      IF cl_null(l_cch.cch22e) THEN LET l_cch.cch22e = 0 END IF
      IF cl_null(l_cch.cch22f) THEN LET l_cch.cch22f = 0 END IF    #No.MOD-920377 add
      IF cl_null(l_cch.cch22g) THEN LET l_cch.cch22g = 0 END IF    #No.MOD-920377 add
      IF cl_null(l_cch.cch22h) THEN LET l_cch.cch22h = 0 END IF    #No.MOD-920377 add
      #--->本期產出
      IF cl_null(l_cch.cch32a) THEN LET l_cch.cch32a = 0 END IF    #No.MOD-920377 add
      IF cl_null(l_cch.cch32b) THEN LET l_cch.cch32b = 0 END IF
      IF cl_null(l_cch.cch32c) THEN LET l_cch.cch32c = 0 END IF
      IF cl_null(l_cch.cch32d) THEN LET l_cch.cch32d = 0 END IF
      IF cl_null(l_cch.cch32e) THEN LET l_cch.cch32e = 0 END IF
      IF cl_null(l_cch.cch32f) THEN LET l_cch.cch32f = 0 END IF    #No.MOD-920377 add
      IF cl_null(l_cch.cch32g) THEN LET l_cch.cch32g = 0 END IF    #No.MOD-920377 add
      IF cl_null(l_cch.cch32h) THEN LET l_cch.cch32h = 0 END IF    #No.MOD-920377 add
      #--->末存金額
      IF cl_null(l_cch.cch92a) THEN LET l_cch.cch92a = 0 END IF    #No.MOD-920377 add
      IF cl_null(l_cch.cch92b) THEN LET l_cch.cch92b = 0 END IF
      IF cl_null(l_cch.cch92c) THEN LET l_cch.cch92c = 0 END IF
      IF cl_null(l_cch.cch92d) THEN LET l_cch.cch92d = 0 END IF
      IF cl_null(l_cch.cch92e) THEN LET l_cch.cch92e = 0 END IF
      IF cl_null(l_cch.cch92f) THEN LET l_cch.cch92f = 0 END IF    #No.MOD-920377 add
      IF cl_null(l_cch.cch92g) THEN LET l_cch.cch92g = 0 END IF    #No.MOD-920377 add
      IF cl_null(l_cch.cch92h) THEN LET l_cch.cch92h = 0 END IF    #No.MOD-920377 add
 
      EXECUTE insert_prep USING
         sr.ccg.ccg01,sr.ccg.ccg04,sr.ccg.ccg07,                     #No.FUN-7C0101
         l_woqty,sr.ccg.ccg11,sr.ccg.ccg21,sr.ccg.ccg31,l_chg,sr.ccg.ccg91,
         sr.ccg.ccg12a,sr.ccg.ccg12b,sr.ccg.ccg12c,sr.ccg.ccg12d,
         sr.ccg.ccg12e,sr.ccg.ccg12f,sr.ccg.ccg12g,sr.ccg.ccg12h,    #No.FUN-7C0101
         sr.ccg.ccg22a,sr.ccg.ccg22b,sr.ccg.ccg22c,sr.ccg.ccg22d,
         sr.ccg.ccg22e,sr.ccg.ccg22f,sr.ccg.ccg22g,sr.ccg.ccg22h,    #No.FUN-7C0101
         sr.ccg.ccg23a,sr.ccg.ccg23b,sr.ccg.ccg23c,sr.ccg.ccg23d,
         sr.ccg.ccg23e,sr.ccg.ccg23f,sr.ccg.ccg23g,sr.ccg.ccg23h,    #No.FUN-7C0101
         sr.ccg.ccg32a,sr.ccg.ccg32b,sr.ccg.ccg32c,sr.ccg.ccg32d,
         sr.ccg.ccg32e,sr.ccg.ccg32f,sr.ccg.ccg32g,sr.ccg.ccg32h,    #No.FUN-7C0101
         sr.ccg.ccg92a,sr.ccg.ccg92b,sr.ccg.ccg92c,sr.ccg.ccg92d,
         sr.ccg.ccg92e,sr.ccg.ccg92f,sr.ccg.ccg92g,sr.ccg.ccg92h,    #No.FUN-7C0101
         l_cch.cch22a,                                               #No.MOD-920377 add
         l_cch.cch22b,l_cch.cch22c,l_cch.cch22d,l_cch.cch22e,
         l_cch.cch22f,l_cch.cch22g,l_cch.cch22h,                         #No.FUN-7C0101
         l_cch.cch32a,                                               #No.MOD-920377 add
         l_cch.cch32b,l_cch.cch32c,l_cch.cch32d,l_cch.cch32e,
         l_cch.cch32f,l_cch.cch32g,l_cch.cch32h,                         #No.FUN-7C0101
         l_cch.cch92a,                                               #No.MOD-920377 add
         l_cch.cch92b,l_cch.cch92c,l_cch.cch92d,l_cch.cch92e,
         l_cch.cch92f,l_cch.cch92g,l_cch.cch92h,                         #No.FUN-7C0101
         #g_azi03,g_azi04,g_azi05,g_ccz.ccz27
         g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27  #CHI-C30012
 
      LET l_k    = 0
      LET l_zero = 0
 
      #-->列印明細
      #----------------No:CHI-9B0031 add
       IF sr.ima911 = 'Y' THEN
          LET l_sql = " SELECT cch_file.*",
                      " FROM cch_file ",  
                      " WHERE cch01 = ?   " ,
                      "   AND (cch02*12+cch03 BETWEEN ",tm.yy*12+tm.mm,
                      "                           AND ",tm.yy2*12+tm.mm2,")",
                       "   AND cch06 ='",tm.type1,"'",    
                      "   AND cch04 != ' DL+OH+SUB'"
       ELSE
          LET l_sql = " SELECT cch_file.*",
                      " FROM cch_file,sfb_file ",   
                      " WHERE cch01 = ?   " ,
                      "   AND cch01 = sfb01 ",     
                      "   AND (cch02*12+cch03 BETWEEN ",tm.yy*12+tm.mm,
                      "                           AND ",tm.yy2*12+tm.mm2,")",
                       "   AND cch06 ='",tm.type1,"'",    
                      "   AND cch04 != ' DL+OH+SUB'"
          LET l_sql = l_sql CLIPPED,l_sql1 CLIPPED  
       END IF
       PREPARE r774_precch2 FROM l_sql
       IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
          EXIT PROGRAM 
       END IF
       DECLARE r774_cchcur2  CURSOR FOR r774_precch2
      #------------------No:CHI-9B0031 end
      FOREACH r774_cchcur2 USING sr.ccg.ccg01 INTO l_cch2.*
        INITIALIZE l_ccc.* TO NULL    #CHI-D40029
        #-->單位成本
        SELECT * INTO l_ccc.* FROM ccc_file WHERE ccc01 = l_cch2.cch04
                                              AND ccc02 = tm.yy
                                              AND ccc03 = tm.mm
        IF cl_null(l_ccc.ccc23a) THEN LET l_ccc.ccc23a = 0 END IF
        IF cl_null(l_ccc.ccc23b) THEN LET l_ccc.ccc23b = 0 END IF
        IF cl_null(l_ccc.ccc23c) THEN LET l_ccc.ccc23c = 0 END IF
        IF cl_null(l_ccc.ccc23d) THEN LET l_ccc.ccc23d = 0 END IF
        IF cl_null(l_ccc.ccc23e) THEN LET l_ccc.ccc23e = 0 END IF
 
        #-->未發需求
        SELECT (sfa05-sfa06) INTO l_unissue FROM sfa_file
                                           WHERE sfa01 = sr.ccg.ccg01
                                             AND sfa03 = l_cch2.cch04
        IF cl_null(l_unissue) THEN LET l_unissue = 0 END IF
 
        #-->列印數量
        LET l_k = l_k + 1    #序號,CR樣版排序用
        LET l_str = '0' CLIPPED       #數量:
        IF cl_null(l_cch2.cch51) THEN LET l_cch2.cch51 = 0 END IF
        IF cl_null(l_unissue)    THEN LET l_unissue = 0    END IF
        IF cl_null(l_cch2.cch55) THEN LET l_cch2.cch55 = 0 END IF
        IF cl_null(l_cch2.cch53) THEN LET l_cch2.cch53 = 0 END IF
        IF cl_null(l_cch2.cch91) THEN LET l_cch2.cch91 = 0 END IF
        IF cl_null(l_cch2.cch21) THEN LET l_cch2.cch21 = 0 END IF
        IF cl_null(l_cch2.cch57) THEN LET l_cch2.cch57 = 0 END IF
        EXECUTE insert_prep1 USING
           l_k,sr.ccg.ccg01,l_cch2.cch04,
           l_cch2.cch51,l_unissue,l_cch2.cch55,l_cch2.cch53,l_cch2.cch91,
           l_cch2.cch21,l_cch2.cch57,
           l_str,
           l_zero,l_zero,l_zero,l_zero,l_zero,l_zero,l_zero,
           #g_azi03,g_azi04,g_azi05,g_ccz.ccz27  #CHI-C30012
           g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27  #CHI-C30012
 
        #-->列印材料
        LET l_unissuea = l_unissue * l_ccc.ccc23a
        LET l_k = l_k + 1    #序號,CR樣版排序用
        LET l_str = '1' CLIPPED       #材料:
        IF cl_null(l_cch2.cch52a) THEN LET l_cch2.cch52a = 0 END IF
        IF cl_null(l_unissuea)    THEN LET l_unissuea = 0    END IF
        IF cl_null(l_cch2.cch56a) THEN LET l_cch2.cch56a = 0 END IF
        IF cl_null(l_cch2.cch54a) THEN LET l_cch2.cch54a = 0 END IF
        IF cl_null(l_cch2.cch92a) THEN LET l_cch2.cch92a = 0 END IF
        IF cl_null(l_cch2.cch22a) THEN LET l_cch2.cch22a = 0 END IF
        IF cl_null(l_cch2.cch58a) THEN LET l_cch2.cch58a = 0 END IF
        EXECUTE insert_prep1 USING
           l_k,sr.ccg.ccg01,l_cch2.cch04,
           l_zero,l_zero,l_zero,l_zero,l_zero,l_zero,l_zero,
           l_str,
           l_cch2.cch52a,l_unissuea,l_cch2.cch56a,l_cch2.cch54a,l_cch2.cch92a,
           l_cch2.cch22a,l_cch2.cch58a,
           #g_azi03,g_azi04,g_azi05,g_ccz.ccz27  #CHI-C30012
           g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27  #CHI-C30012
 
        #-->列印人工
        LET l_unissueb = l_unissue * l_ccc.ccc23b
        LET l_k = l_k + 1    #序號,CR樣版排序用
        LET l_str = '2' CLIPPED       #人工:
        IF cl_null(l_cch2.cch52b) THEN LET l_cch2.cch52b = 0 END IF
        IF cl_null(l_unissueb)    THEN LET l_unissueb = 0    END IF
        IF cl_null(l_cch2.cch56b) THEN LET l_cch2.cch56b = 0 END IF
        IF cl_null(l_cch2.cch54b) THEN LET l_cch2.cch54b = 0 END IF
        IF cl_null(l_cch2.cch92b) THEN LET l_cch2.cch92b = 0 END IF
        IF cl_null(l_cch2.cch22b) THEN LET l_cch2.cch22b = 0 END IF
        IF cl_null(l_cch2.cch58b) THEN LET l_cch2.cch58b = 0 END IF
        EXECUTE insert_prep1 USING
           l_k,sr.ccg.ccg01,l_cch2.cch04,
           l_zero,l_zero,l_zero,l_zero,l_zero,l_zero,l_zero,
           l_str,
           l_cch2.cch52b,l_unissueb,l_cch2.cch56b,l_cch2.cch54b,l_cch2.cch92b,
           l_cch2.cch22b,l_cch2.cch58b,
           #g_azi03,g_azi04,g_azi05,g_ccz.ccz27  #CHI-C30012
           g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27  #CHI-C30012
 
        #-->列印製造
        LET l_unissuec = l_unissue * l_ccc.ccc23c
        LET l_k = l_k + 1    #序號,CR樣版排序用
        LET l_str = '3' CLIPPED       #製造:
        IF cl_null(l_cch2.cch52c) THEN LET l_cch2.cch52c = 0 END IF
        IF cl_null(l_unissuec)    THEN LET l_unissuec = 0    END IF
        IF cl_null(l_cch2.cch56c) THEN LET l_cch2.cch56c = 0 END IF
        IF cl_null(l_cch2.cch54c) THEN LET l_cch2.cch54c = 0 END IF
        IF cl_null(l_cch2.cch92c) THEN LET l_cch2.cch92c = 0 END IF
        IF cl_null(l_cch2.cch22c) THEN LET l_cch2.cch22c = 0 END IF
        IF cl_null(l_cch2.cch58c) THEN LET l_cch2.cch58c = 0 END IF
        EXECUTE insert_prep1 USING
           l_k,sr.ccg.ccg01,l_cch2.cch04,
           l_zero,l_zero,l_zero,l_zero,l_zero,l_zero,l_zero,
           l_str,
           l_cch2.cch52c,l_unissuec,l_cch2.cch56c,l_cch2.cch54c,l_cch2.cch92c,
           l_cch2.cch22c,l_cch2.cch58c,
           #g_azi03,g_azi04,g_azi05,g_ccz.ccz27  #CHI-C30012
           g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27  #CHI-C30012
 
        #-->列印加工
        LET l_unissued = l_unissue * l_ccc.ccc23d
        LET l_k = l_k + 1    #序號,CR樣版排序用
        LET l_str = '4' CLIPPED       #加工:
        IF cl_null(l_cch2.cch52d) THEN LET l_cch2.cch52d = 0 END IF
        IF cl_null(l_unissued)    THEN LET l_unissued = 0    END IF
        IF cl_null(l_cch2.cch56d) THEN LET l_cch2.cch56d = 0 END IF
        IF cl_null(l_cch2.cch54d) THEN LET l_cch2.cch54d = 0 END IF
        IF cl_null(l_cch2.cch92d) THEN LET l_cch2.cch92d = 0 END IF
        IF cl_null(l_cch2.cch22d) THEN LET l_cch2.cch22d = 0 END IF
        IF cl_null(l_cch2.cch58d) THEN LET l_cch2.cch58d = 0 END IF
        EXECUTE insert_prep1 USING
           l_k,sr.ccg.ccg01,l_cch2.cch04,
           l_zero,l_zero,l_zero,l_zero,l_zero,l_zero,l_zero,
           l_str,
           l_cch2.cch52d,l_unissued,l_cch2.cch56d,l_cch2.cch54d,l_cch2.cch92d,
           l_cch2.cch22d,l_cch2.cch58d,
           #g_azi03,g_azi04,g_azi05,g_ccz.ccz27 #CHI-C30012
           g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27  #CHI-C30012
 
        #-->列印其他
        LET l_unissuee = l_unissue * l_ccc.ccc23e
        LET l_k = l_k + 1    #序號,CR樣版排序用
        LET l_str = '5' CLIPPED       #其他:
        IF cl_null(l_cch2.cch52e) THEN LET l_cch2.cch52e = 0 END IF
        IF cl_null(l_unissuee)    THEN LET l_unissuee = 0    END IF
        IF cl_null(l_cch2.cch56e) THEN LET l_cch2.cch56e = 0 END IF
        IF cl_null(l_cch2.cch54e) THEN LET l_cch2.cch54e = 0 END IF
        IF cl_null(l_cch2.cch92e) THEN LET l_cch2.cch92e = 0 END IF
        IF cl_null(l_cch2.cch22e) THEN LET l_cch2.cch22e = 0 END IF
        IF cl_null(l_cch2.cch58e) THEN LET l_cch2.cch58e = 0 END IF
        EXECUTE insert_prep1 USING
           l_k,sr.ccg.ccg01,l_cch2.cch04,
           l_zero,l_zero,l_zero,l_zero,l_zero,l_zero,l_zero,
           l_str,
           l_cch2.cch52e,l_unissued,l_cch2.cch56e,l_cch2.cch54e,l_cch2.cch92e,
           l_cch2.cch22e,l_cch2.cch58e,
           #g_azi03,g_azi04,g_azi05,g_ccz.ccz27 #CHI-C30012
           g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27  #CHI-C30012
 
      END FOREACH
 
END REPORT
 
FUNCTION r774_outnam()
   DEFINE l_name            LIKE type_file.chr20,
          l_sw              LIKE type_file.chr1,
          l_n               LIKE type_file.num5,
          l_waitsec         LIKE type_file.num5,
          l_buf             LIKE type_file.chr6,
          l_n2              LIKE type_file.num5
#TQC-C20425-----------------Begin----------------------
   DEFINE p_code                LIKE zz_file.zz01,
          l_chr                 LIKE type_file.chr1,
          l_cnt                 LIKE type_file.num5,
          l_zaa02               LIKE type_file.num5,
          l_zaa08               LIKE type_file.chr1000,
          l_cmd                 LIKE type_file.chr1000,
          l_zaa08_s             STRING,
          l_zaa14               LIKE zaa_file.zaa14,
          l_zaa16               LIKE zaa_file.zaa16,
          l_cust                LIKE type_file.num5,
          l_sql                 STRING
   DEFINE l_gay03               LIKE gay_file.gay03
   DEFINE l_str                 STRING
   DEFINE l_azp02               LIKE azp_file.azp02
#TQC-C20425------------------End-----------------------
 
   SELECT zz06 INTO l_sw FROM zz_FILE WHERE zz01 = g_prog
   IF l_sw = '1' THEN
      LET l_name = g_prog CLIPPED,'.out'
   ELSE
      SELECT zz16,zz24  INTO l_n,l_waitsec FROM zz_FILE WHERE zz01 = g_prog
      IF (l_n IS NULL OR l_n <0) THEN LET l_n=0 END IF
      LET l_n = l_n + 1
      IF l_n > 30000 THEN  LET l_n = 0  END IF
      LET l_buf = l_n USING "&&&&&&"
      IF g_aza.aza49 = '1' THEN   #01r-09r
         LET l_name = g_prog CLIPPED,".0",l_buf[6,6],"r"
      ELSE
         CASE g_aza.aza49
            WHEN '2'   #01r-19r
                 LET l_n2 = l_n MOD 20
            WHEN '3'   #01r-29r
                 LET l_n2 = l_n MOD 30
            WHEN '4'   #01r-39r
                 LET l_n2 = l_n MOD 40
            WHEN '5'   #01r-49r
                 LET l_n2 = l_n MOD 50
         END CASE
         LET l_buf = l_n2 USING "&&&&&&"
         LET l_name = g_prog CLIPPED,".",l_buf[5,6],"r"
      END IF
   END IF
   UPDATE zz_file SET zz16 = l_n WHERE zz01 = g_prog
#TQC-C20425-----------------Begin----------------------
   LET g_memo = ""
   SELECT count(*) INTO l_cnt FROM zaa_file WHERE zaa01 = p_code AND zaa03 = g_rlang
   IF not SQLCA.sqlcode AND l_cnt>0 THEN   ## get data from zaa_file
      SELECT count(*) INTO l_cnt FROM zaa_file WHERE zaa01 = p_code AND zaa03 = g_rlang AND zaa11 = 'voucher'
      IF l_cnt > 0 THEN   ## voucher
         SELECT count(*) INTO l_cnt FROM zaa_file
              WHERE zaa01 = p_code AND zaa03 = g_rlang AND zaa04='default' AND
                    zaa11 = 'voucher' AND zaa10='Y'
         IF l_cnt > 0 THEN  ## customerize
            LET g_zaa10_value = 'Y'
         ELSE
            LET g_zaa10_value = 'N'
         END IF
         CASE cl_db_get_database_type()
            WHEN "ORA"
               LET l_sql = "SELECT count(*) FROM ",
                           "(SELECT unique zaa04,zaa17 FROM zaa_file ",
                           "WHERE zaa01 = '",g_prog CLIPPED,"' AND zaa03 = '",g_rlang,"' AND zaa10 ='",
                           g_zaa10_value,"' AND ((zaa04='default' AND zaa17='default') OR zaa04 ='",g_user CLIPPED,
                           "' OR zaa17= '",g_clas CLIPPED,"'))"
            WHEN "IFX"
               LET l_sql = "SELECT count(*) FROM table(multiset",
                           "(SELECT unique zaa04,zaa17 FROM zaa_file ",
                           "WHERE zaa01 = '",g_prog CLIPPED,"' AND zaa03 = '",g_rlang,"' AND zaa10 ='",
                           g_zaa10_value,"' AND ((zaa04='default' AND zaa17='default') OR zaa04 ='",g_user CLIPPED,
                           "' OR zaa17= '",g_clas CLIPPED,"')))"
            WHEN "MSV"
               LET l_sql = "( SELECT count(distinct zaa04+zaa17) FROM zaa_file ",
                               " WHERE zaa01 = '",g_prog CLIPPED,"' AND zaa03 = '",g_rlang,"' ",
                                 " AND zaa10 ='",g_zaa10_value,"' ",
                                 " AND ((zaa04='default' AND zaa17='default') ",
                                 " OR zaa04 ='",g_user CLIPPED,"' OR zaa17= '",g_clas CLIPPED,"') "
            WHEN "ASE"
               LET l_sql = " SELECT count(distinct zaa04+zaa17) FROM zaa_file ",
                               " WHERE zaa01 = '",g_prog CLIPPED,"' AND zaa03 = '",g_rlang,"' ",
                                 " AND zaa10 ='",g_zaa10_value,"' ",
                                 " AND ((zaa04='default' AND zaa17='default') ",
                                 " OR zaa04 ='",g_user CLIPPED,"' OR zaa17= '",g_clas CLIPPED,"') "
         END CASE
         PREPARE zaa_pre1 FROM l_sql
         IF SQLCA.SQLCODE THEN
            CALL cl_err("prepare zaa_cur4: ", SQLCA.SQLCODE, 0)
            #RETURN FALSE
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM

         END IF
         EXECUTE zaa_pre1 INTO l_cust
          IF cl_null(g_bgjob) OR g_bgjob = 'N' OR
            (g_bgjob='Y' AND (cl_null(g_rep_user) OR cl_null(g_rep_clas)
             OR cl_null(g_template)))
         THEN

            IF l_cust > 1 THEN
               CALL cl_prt_pos_t()
            ELSE
               SELECT unique zaa04,zaa17 INTO g_zaa04_value,g_zaa17_value
               FROM zaa_file WHERE zaa01 = g_prog AND zaa03 = g_rlang AND zaa10 =
                   g_zaa10_value AND ((zaa04='default' AND zaa17='default')
                   OR zaa04 =g_user OR zaa17= g_clas )
            END IF
         ELSE
            SELECT unique zaa04,zaa17 INTO g_zaa04_value,g_zaa17_value
            FROM zaa_file WHERE zaa01 = g_prog AND zaa03 = g_rlang
             AND zaa10 = g_zaa10_value AND zaa11 = g_template
             AND zaa04 = g_rep_user AND zaa17 = g_rep_clas
         END IF

         DECLARE zaa_cur CURSOR FOR
          SELECT zaa02,zaa08,zaa14,zaa16 FROM zaa_file
           WHERE zaa01 = p_code AND zaa03 = g_rlang AND zaa04=g_zaa04_value AND
                 zaa11 = 'voucher' AND zaa10=g_zaa10_value AND zaa17 = g_zaa17_value
           ORDER BY zaa02
         FOREACH zaa_cur INTO l_zaa02,l_zaa08,l_zaa14,l_zaa16
            IF SQLCA.SQLCODE THEN
               CALL cl_err("FOREACH zaa_cur: ", SQLCA.SQLCODE, 0)
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B70007
               EXIT PROGRAM
            END IF
            LET l_zaa08 = cl_outnam_zab(l_zaa08,l_zaa14,l_zaa16)
            LET l_zaa08_s = l_zaa08 CLIPPED
            LET g_x[l_zaa02] = l_zaa08_s
         END FOREACH
         ### for g_page_line ###
          SELECT unique zaa12,zaa19,zaa20,zaa21 into g_page_line,g_left_margin,g_top_margin,g_bottom_margin
          FROM zaa_file   #MOD-560029
          WHERE zaa01 = p_code AND zaa03 = g_rlang AND zaa04=g_zaa04_value AND
                zaa11 = 'voucher' AND zaa10=g_zaa10_value AND zaa17 = g_zaa17_value

         SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = g_prog
      ELSE
        LET g_xml_rep = l_name CLIPPED,".xml"
        CALL fgl_report_set_document_handler(om.XmlWriter.createFileWriter(g_xml_rep CLIPPED))
        CALL cl_prt_pos(p_code)
      END IF
   END IF
   LET l_str = p_code
   IF l_str.subString(4,4) != 'p' AND g_x.getLength() = 0 THEN
      SELECT gay03 INTO l_gay03 FROM gay_file
        WHERE gay01 = g_rlang AND gayacti = "Y"
      LET l_str = g_rlang CLIPPED, ":",l_gay03 CLIPPED
      CALL cl_err_msg(g_prog,'lib-358',l_str,10)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   IF g_page_line = 0 or g_page_line is null THEN
      LET g_page_line = 66
   END IF
   LET g_line = g_page_line
   IF g_left_margin IS NULL THEN
      LET g_left_margin = 0
   END IF

   IF g_top_margin IS NULL THEN
      LET g_top_margin = 1 #預設報表上邊界為1
   END IF
   IF g_bottom_margin IS NULL THEN
      LET g_bottom_margin = 5 #預設報表下邊界為5
   END IF

   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_plant
   LET g_company = g_company CLIPPED,"[",g_plant CLIPPED,":",l_azp02 CLIPPED,"]"
#TQC-C20425------------------End-----------------------
   RETURN l_name
END FUNCTION
#end FUN-7B0043 add
