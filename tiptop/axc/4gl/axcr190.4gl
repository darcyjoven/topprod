# Prog. Version..: '5.30.06-13.03.28(00010)'     #
#
# Pattern name...: axcr190.4gl
# Descriptions...: 成本開帳與倉庫數量比較表
# Input parameter:
# Return code....:
# Date & Author..: 2000/06/20 by connie
# Modify.........: No:9116 04/07/20 Carol 料號欄應為 20碼(照資料庫default欄寬)
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.MOD-530122 05/03/16 By Carol QBE欄位順序調整
# Modify.........: NO.MOD-530789 05/03/28 By pengu  數量中的小數位目前只顯示兩位,應該為三位
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.MOD-580194 05/08/22 By Claire 報表格式調整
# Modify.........: No.TQC-610051 06/02/22 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.MOD-670092 06/07/25 By Pengu 計算出來的差異不正確。
# Modify.........: No.FUN-670067 06/08/08 By Jackho  報表轉template1 
# Modify.........: No.FUN-680122 06/09/01 By zdyllq 類型轉換 
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.MOD-690119 06/10/31 By pengu 庫結存量(imk09)未乘上換算率(img21)
# Modify.........: No.CHI-690007 06/12/26 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.FUN-750101 07/06/22 By mike  報表格式修改為crystal reports
# Mofify.........: No.FUN-7C0101 08/01/25 By lala 成本改善
# Modify.........: No.MOD-840595 08/07/04 By Pengu 當imk_file沒有資料時其報表無法產生資料列印
# Modify.........: No.FUN-7B0030 08/09/25 By jamie 1.若比較結果無差異，應顯示出訊息「成本開帳 與 倉庫數量 比對無差異」，目前是無任何訊息顯示。
#                                                  2.成本開帳檔(cca_file) 與 庫存檔(imk_file) 比對過程，若其中一個數量是空值, 則應顯示出來被check。
# Modify.........: No.CHI-910037 09/01/14 By chenl 報表調整
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-970003 09/12/02 By jan CREATE TEMP TABLE 寫法調整
# Modify.........: No:MOD-A30039 10/03/08 By Sarah 沒有imk資料,成本有開帳,axcr190會勾稽不出來
# Modify.........: No:MOD-B60097 11/06/10 By sabrina 若倉庫為非成本倉時，不應將資料刪掉，而是要將imk09變更為0
# Modify.........: No.FUN-C50128 12/06/04 By suncx 在報表最後增加顯示"開帳金額",及"會計科目"
# Modify.........: No:CHI-C30012 12/07/27 By bart 金額取位改抓ccz26
# Modify.........: No:CHI-C60029 12/08/16 By bart 增加成本庫別(imd09)
# Modify.........: No:MOD-CC0040 12/12/26 By Elise 增加tm.type='5'的狀況

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,       #No.FUN-680122CHAR(300)      # Where condition
              yy,mm   LIKE type_file.num5,          #No.FUN-680122SMALLINT,
              type    LIKE ccg_file.ccg06,          #No.FUN-7C0101 add
              d_sw    LIKE type_file.chr1,          #No.FUN-680122CHAR(1)
              yn      LIKE type_file.chr1,          #No.FUN-680122CHAR(1)
              more    LIKE type_file.chr1           #No.FUN-680122CHAR(1)        # Input more condition(Y/N)
              END RECORD,
          g_tot_bal LIKE ccq_file.ccq03         #No.FUN-680122DECIMAL(13,2)     # User defined variable
   DEFINE bdate   LIKE type_file.dat            #No.FUN-680122DATE
   DEFINE edate   LIKE type_file.dat            #No.FUN-680122DATE
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
# DEFINE   g_dash_1        LIKE type_file.chr1000        #No.FUN-680122  VARCHAR(400)  #Dash line      #No.FUN-670067
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_sql           STRING                  #No.FUN-750101
DEFINE   g_str           STRING                  #No.FUN-750101
DEFINE   l_table         STRING                  #No.FUN-750101
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
 
#No.FUN-750101 --BEGIN--
#TQC-970003--begin--mod----
   LET g_sql="ima01.ima_file.ima01,",
             "ima02.ima_file.ima02,",
             "ima25.ima_file.ima25,",
             "imk02.imk_file.imk02,",
             "imk03.imk_file.imk03,",
             "imk04.imk_file.imk04,",
             "imk09.imk_file.imk09,",
             "cca11.cca_file.cca11,",
             "cca07.cca_file.cca07,",      #No.FUN-7C0101 add
             "dtype.type_file.chr1,",      #No.CHI-910037
             "cca12.cca_file.cca12,",      #FUN-C50128 add 開賬金額
             "ima39.ima_file.ima39,",      #FUN-C50128 add 會計科目
             "imd09.imd_file.imd09"        #CHI-C60029
#TQC-970003--end--mod------
   LET l_table = cl_prt_temptable('axcr190',g_sql)  CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              #"  VALUES(?,?,?,?,?,?,?,? ,?,?)" #No.FUN-7C0101 add ? #No.CHI-910037 add ?
               "  VALUES(?,?,?,?,?,?,?,? ,?,?,?,?,?)"    #FUN-C50128 add ?,? #CHI-C60029
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM 
   END IF
#No.FUN-750101  --END--
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #TQC-610051-begin
   LET tm.yy = ARG_VAL(8)
   LET tm.mm = ARG_VAL(9)
   LET tm.d_sw = ARG_VAL(10)
   LET tm.yn = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET tm.type = ARG_VAL(15)                #FUN-7C0101
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   ##No.FUN-570264 ---end---
   #TQC-610051-end
   
   #No.CHI-910037--begin--
   CALL r190_temp('c') RETURNING g_errno 
   IF NOT cl_null(g_errno) THEN 
      CALL cl_err('CREATE TEMP TABLE:',g_errno,1)
      EXIT PROGRAM 
   END IF 
   #No.CHI-910037---end---
   
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axcr190_tm(0,0)        # Input print condition
      ELSE CALL axcr190()            # Read data and create out-file
   END IF
   
   #No.CHI-910037--begin--
   CALL r190_temp('d') RETURNING g_errno 
   IF NOT cl_null(g_errno) THEN 
      CALL cl_err('Drop Temp Table:',g_errno,1)
      EXIT PROGRAM 
   END IF 
   #No.CHI-910037---end---
   
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr190_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 15
   END IF
   OPEN WINDOW axcr190_w AT p_row,p_col
        WITH FORM "axc/42f/axcr190"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.type = g_ccz.ccz28          #No.FUN-7C0101 add
   LET tm.yy  = YEAR(g_today)         #No.FUN-7C0101 add
   LET tm.mm  = MONTH(g_today)        #No.FUN-7C0101 add
   LET tm.d_sw = 'Y'
   LET tm.yn   = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
WHILE TRUE
 #MOD-530122
   CONSTRUCT BY NAME tm.wc ON
             ima01,ima57,ima06,ima10,ima12,ima39, ima08,ima09 ,ima11
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
 
#No.FUN-570240 --start
     ON ACTION CONTROLP
        IF INFIELD(ima01) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_ima"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO ima01
           NEXT FIELD ima01
        END IF
#No.FUN-570240 --end
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr190_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   LET tm.wc=tm.wc CLIPPED," AND ima01 NOT LIKE 'MISC%'"
   INPUT BY NAME tm.yy,tm.mm,tm.type,tm.d_sw,tm.yn,tm.more WITHOUT DEFAULTS #No.FUN-7C0101 add tm.type
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD yy
         IF tm.yy IS NULL THEN NEXT FIELD yy END IF
      AFTER FIELD mm
         IF tm.mm IS NULL THEN NEXT FIELD mm END IF
         CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
       AFTER FIELD type                                              #No.FUN-7C0101
         IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF#No.FUN-7C0101
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr190_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr190'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr190','9031',1)   
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
                         #TQC-610051-begin
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",tm.type CLIPPED,"'" ,             #No.FUN-7C0101 add
                         " '",tm.d_sw CLIPPED,"'",
                         " '",tm.yn CLIPPED,"'",
                         #TQC-610051-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078"
         CALL cl_cmdat('axcr190',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr190_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr190()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr190_w
END FUNCTION
 
FUNCTION axcr190()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122  VARCHAR(20)       # External(Disk) file name
          l_cnt     LIKE type_file.num5,        #No.MOD-840595 add
         #l_time    LIKE type_file.chr8         #No.FUN-6A0146
         #l_sql     LIKE type_file.chr1000,     #FUN-7B0030 mark # RDSQL STATEMENT        #No.FUN-680122CHAR(600)
          l_sql     STRING,                     #FUN-7B0030 mod
          l_chr     LIKE type_file.chr1,        #No.FUN-680122 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,     #No.FUN-680122 VARCHAR(40)
          l_img21   LIKE img_file.img21,        #No.MOD-690119 add
          s_imk09   LIKE imk_file.imk09,
          sr	RECORD
            	ima01	LIKE ima_file.ima01,
            	ima02	LIKE ima_file.ima02,
            	ima25	LIKE ima_file.ima25,
            	imk02   LIKE imk_file.imk02,
            	imk03   LIKE imk_file.imk03,
            	imk04   LIKE imk_file.imk04,
            	imk09	LIKE imk_file.imk09,
            	cca11   LIKE cca_file.cca11,
                cca07   LIKE cca_file.cca07, #No.FUN-7C0101 add
            	dtype   LIKE type_file.chr1, #No.CHI-910037
                cca12   LIKE cca_file.cca12, #FUN-C50128 add 
                ima39   LIKE ima_file.ima39,  #FUN-C50128 add
                imd09   LIKE imd_file.imd09  #CHI-C60029
            	END RECORD
 
#No.FUN-750101 --begin--
     LET g_str=''
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
#No.FUN-750101 --end--
 
    #No.CHI-910037--begin--
     CALL r190_temp('r') RETURNING g_errno 
     IF NOT cl_null(g_errno) THEN 
        CALL cl_err('Delete Temp Table:',g_errno,1)
        RETURN  
     END IF 
    #No.CHI-910037---end---
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-670067-begin
#     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axcr190'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 143 END IF  #No:9116,580194
#    IF tm.yn = "Y" THEN LET g_len = 135 END IF                #No:9116
     #CALL cl_outnam('axcr190') RETURNING l_name       #No.MOD-670092 add     #No.FUN-750101 mark
      #MOD-580194-Begin
#     IF tm.yn='N' THEN
#           LET g_len = 114
#       ELSE
#           LET g_len = 152
#     END IF
      #MOD-580194-End
#     FOR g_i = 1 TO g_len LET g_dash_1[g_i,g_i] = '=' END FOR
#No.FUN-670067-end
    # FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '-' END FOR   #No.CHI-910037 mark
    #FUN-7B0030---mod---str---
    #LET l_sql = "SELECT ima01,ima02,ima25,imk02,imk03,imk04,cca11,cca07,SUM(imk09)", #No.FUN-7C0101 add cca07
    #            "  FROM ima_file, cca_file, imk_file",
    #            " WHERE ",tm.wc CLIPPED,
    #            "   AND ima01=cca_file.cca01(+) AND ima01=imk_file.imk01(+) ",
    #            "   AND cca_file.cca02(+)=",tm.yy," AND cca_file.cca03(+)=",tm.mm,
    #            "   AND cca_file.cca06='",tm.type,"'",                       #No.FUN-7C0101 add
    #            "   AND imk_file.imk05(+)=",tm.yy," AND imk_file.imk06(+)=",tm.mm,
    #           #"   AND imk02 NOT IN (SELECT jce02 FROM jce_file) ", #no.5484  #No.MOD-840595 mark
    #            " GROUP BY ima01,ima02,ima25,imk02,imk03,imk04,cca11,cca07"                         #No.FUN-7C0101 add 8
 
  #No.CHI-910037--begin-- mark
  #   LET l_sql = "SELECT ima01,ima02,ima25,imk02,imk03,imk04,cca11,SUM(imk09)",
  #               "  FROM ima_file, cca_file, imk_file",
  #               " WHERE ",tm.wc CLIPPED,
  #               "   AND ima01=cca_file.cca01(+) AND ima01=imk_file.imk01(+) ",
  #               "   AND cca_file.cca02(+)=",tm.yy," AND cca_file.cca03(+)=",tm.mm,
  #               "   AND imk_file.imk05(+)=",tm.yy," AND imk_file.imk06(+)=",tm.mm,
  #               " GROUP BY ima01,ima02,ima25,imk02,imk03,imk04,cca11",
  #               " UNION ",
  #               "SELECT ima01,ima02,ima25,imk02,imk03,imk04,cca11,SUM(imk09)",
  #               "  FROM cca_file, ima_file, imk_file", 
  #               " WHERE ",tm.wc CLIPPED,
  #               "   AND cca01=ima_file.ima01(+) AND cca01=imk_file.imk01(+) ",
  #               "   AND cca02=",tm.yy," AND cca03=",tm.mm ,
  #               "   AND imk_file.imk05(+)=",tm.yy," AND imk_file.imk06(+)=",tm.mm,
  #               " GROUP BY ima01,ima02,ima25,imk02,imk03,imk04,cca11",
  #               " UNION ",
  #               "SELECT ima01,ima02,ima25,imk02,imk03,imk04,cca11,SUM(imk09)",
  #               "  FROM imk_file, cca_file, ima_file", 
  #               " WHERE ",tm.wc CLIPPED,
  #               "   AND imk01=cca_file.cca01(+) AND imk01=ima_file.ima01(+)",
  #               "   AND cca_file.cca02(+)=",tm.yy," AND cca_file.cca03(+)=",tm.mm,
  #               "   AND imk05=",tm.yy," AND imk06=",tm.mm ,
  #               " GROUP BY ima01,ima02,ima25,imk02,imk03,imk04,cca11 "
  #  #FUN-7B0030---mod---end---
  #No.CHI-910037---end-- mark
  
  #No.CHI-910037--begin--
     LET l_sql = " INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " SELECT * FROM imk_temp WHERE dtype='B' "
     PREPARE r190_report FROM l_sql 
     #將明細資料插入臨時表以便處理。
     LET l_sql = "INSERT INTO imk_temp ",
                #"SELECT ima01,ima02,ima25,imk02,imk03,imk04,imk09,0,'','B' ",            #FUN-C50128 mark
                 "SELECT ima01,ima02,ima25,imk02,imk03,imk04,imk09,0,'','B',0,ima39,imd09 ",   #FUN-C50128 add 0,ima39 #CHI-C60029 imd09
                 "  FROM ima_file LEFT OUTER JOIN imk_file ON ima01=imk01 ",
                 "                                        AND imk05=",tm.yy," AND imk06=",tm.mm,
                #"                                        AND imk02 NOT IN (SELECT jce02 FROM jce_file)",  #MOD-A30039 mark
                 "  LEFT OUTER JOIN imd_file ON imd01=imk02 ",
                 " WHERE ",tm.wc CLIPPED,
#                 "   AND ima01=imk_file.imk01(+) ",
#                 "   AND imk_file.imk05(+)=",tm.yy,
#                 "   AND imk_file.imk06(+)=",tm.mm,
#                 "   AND imk02 NOT IN (SELECT jce02 FROM jce_file)",
                 " ORDER BY ima01,imk02,imk03,imk04 "
    PREPARE r190_ins_imk_prep FROM l_sql
    EXECUTE r190_ins_imk_prep 
    IF SQLCA.sqlcode THEN 
       CALL cl_err('Insert Temp Table:',SQLCA.sqlcode,1)
       RETURN 
    END IF
    #將抓取出來的明細資料直接插入到報表數據庫，以備用戶打印明細。
    EXECUTE r190_report 
    IF SQLCA.sqlcode AND SQLCA.sqlcode <> 100 THEN 
       CALL cl_err('',SQLCA.sqlcode,0)
       RETURN 
    END IF 
    
   #str MOD-A30039 add
   #刪除倉庫是不納入計算成本庫的資料
   #LET l_sql = "DELETE FROM imk_temp ",          #MOD-B60097 mark
    LET l_sql = "UPDATE imk_temp SET imk09=0 ",   #MOD-B60097 add
                " WHERE imk02 IN (SELECT jce02 FROM jce_file)"
    PREPARE r190_del_imk_prep FROM l_sql
    EXECUTE r190_del_imk_prep 
   #end MOD-A30039 add
   
   #FUN-C50128 add str--------------------
   #根據ccz07設置，更新會計科目
    CASE  g_ccz.ccz07
       WHEN '2'
          LET l_sql = "UPDATE imk_temp a",
                      "   SET ima39 = (SELECT imz39 FROM imz_file,ima_file b",
                      "                 WHERE imz01=b.ima06 AND b.ima01=a.ima01)"
       WHEN '3'
          LET l_sql = "UPDATE imk_temp a",
                      "   SET ima39 = (SELECT imd08 FROM imd_file,ima_file b",
                      "                 WHERE imd01=b.ima35 AND b.ima01=a.ima01)"
       WHEN '4'
          LET l_sql = "UPDATE imk_temp a",
                      "   SET ima39 = (SELECT ime09 FROM ime_file,ima_file b",
                      "                 WHERE ime01=b.ima35 AND ime02=b.ima36 AND b.ima01=a.ima01)"
    END CASE 
    PREPARE r190_ima39_prep FROM l_sql
    EXECUTE r190_ima39_prep 
   #FUN-C50128 add end--------------------

    IF tm.type = '3' THEN 
      #LET l_sql = " SELECT ima01,ima02,ima25,'','',imk04,SUM(imk09),0,'','D' ",         #FUN-C50128 mark
       LET l_sql = " SELECT ima01,ima02,ima25,'','',imk04,SUM(imk09),0,'','D',0,ima39,'' ",   #FUN-C50128 add 0,ima39 #CHI-C60029 ''
                   "   FROM imk_temp ",
                   "  WHERE dtype = 'B' ", 
                   "  GROUP BY ima01,ima02,ima25,imk04,ima39 "   #FUN-C50128 add ima39
    ELSE 
      #LET l_sql = " SELECT ima01,ima02,ima25,'','','',SUM(imk09),0,'','D'",             #FUN-C50128 mark
#wujie 130627 --begin
       IF tm.type = '5' THEN 
          LET l_sql = " SELECT ima01,ima02,ima25,'','','',SUM(imk09),0,'','D',0,ima39,imd09 ",      #FUN-C50128 add 0,ima39 #CHI-C60029 imd09
                      "   FROM imk_temp ",
                      "  WHERE dtype = 'B' ", 
                      "  GROUP BY ima01,ima02,ima25,ima39,imd09 "   #FUN-C50128 add ima39 #CHI-C60029
       ELSE 
          LET l_sql = " SELECT ima01,ima02,ima25,'','','',SUM(imk09),0,'','D',0,ima39,'' ",      #FUN-C50128 add 0,ima39 #CHI-C60029 imd09
                      "   FROM imk_temp ",
                      "  WHERE dtype = 'B' ", 
                      "  GROUP BY ima01,ima02,ima25,ima39 "  
       END IF 
#wujie 130627 --end
    END IF 
  #No.CHI-910037---end---
     PREPARE axcr190_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE axcr190_curs1 CURSOR FOR axcr190_prepare1
 
     #START REPORT axcr190_rep TO l_name          #No.FUN-750101 
     #LET g_pageno = 0                            #No.FUN-750101 
 
#No.FUN-750101   --begin--
{
#No.FUN-670067-begin                                                                                                                
    IF tm.yn='N' THEN  #                                                                                                            
       LET g_zaa[34].zaa06='Y'                                                                                                      
       LET g_zaa[35].zaa06='Y'                                                                                                      
       LET g_zaa[36].zaa06='Y'                                                                                                      
    ELSE              #                                                                                                             
       LET g_zaa[34].zaa06='N'                                                                                                      
       LET g_zaa[35].zaa06='N'                                                                                                      
       LET g_zaa[36].zaa06='N'                                                                                                      
    END IF        
    CALL cl_prt_pos_len()                                                                                                           
#No.FUN-670067-end
}
     
#No.FUN-7C0101-------------BEGIN-----------------
   #IF tm.yn='N' THEN
   #     LET l_name='axcr190'
   #  ELSE 
   #     LET l_name='axcr190_1'
   #END IF
   
  #No.CHI-910037--begin-- mark
  # IF tm.yn='N' THEN
  #      IF tm.type MATCHES '[12]' THEN
  #         LET l_name='axcr190_2'
  #      END IF
  #      IF tm.type MATCHES '[345]' THEN
  #         LET l_name='axcr190'
  #      END IF
  #   ELSE
  #      IF tm.type MATCHES '[12]' THEN
  #         LET l_name='axcr190_1_2'
  #      END IF
  #      IF tm.type MATCHES '[345]' THEN
  #         LET l_name='axcr190_1'
  #      END IF
  #   END IF
  #No.CHI-910037---end--- mark
#No.FUN-7C0101--------------END------------------
#No.FUN-750101 --end--
 
     FOREACH axcr190_curs1 INTO sr.*
      # IF sr.cca11 IS NULL THEN LET sr.cca11 = 0 END IF   #No.CHI-910037 mark
       IF sr.imk09 IS NULL THEN LET sr.imk09 = 0 END IF
       IF sr.imk02 IS NULL THEN LET sr.imk02 = ' ' END IF
       IF sr.imk03 IS NULL THEN LET sr.imk03 = ' ' END IF
       IF sr.imk04 IS NULL THEN LET sr.imk04 = ' ' END IF
      #-----------No.MOD-840595 add
    
    #No.CHI-910037--begin--
       IF tm.type = '3' THEN 
         #SELECT cca07,SUM(cca11) INTO sr.cca07,sr.cca11 FROM cca_file                       #FUN-C50128 mark
          SELECT cca07,SUM(cca11),SUM(cca12) INTO sr.cca07,sr.cca11,sr.cca12 FROM cca_file   #FUN-C50128 add cca12
           WHERE cca01 = sr.ima01
             AND cca07 = sr.imk04
             AND cca02 = tm.yy
             AND cca03 = tm.mm
           GROUP BY cca07
      #MOD-CC0040---add---S
       ELSE
          IF tm.type = '5' THEN
             SELECT cca07,SUM(cca11),SUM(cca12) INTO sr.cca07,sr.cca11,sr.cca12 FROM cca_file
              WHERE cca01 = sr.ima01
                AND cca07 = sr.imd09
                AND cca02 = tm.yy
                AND cca03 = tm.mm
              GROUP BY cca07
      #MOD-CC0040---add---E
          ELSE 
            #SELECT '',SUM(cca11) INTO sr.cca07,sr.cca11 FROM cca_file                      #FUN-C50128 mark
             SELECT '',SUM(cca11),SUM(cca12) INTO sr.cca07,sr.cca11,sr.cca12 FROM cca_file  #FUN-C50128 add cca12
              WHERE cca01 = sr.ima01
                AND cca02 = tm.yy
                AND cca03 = tm.mm
          END IF   #MOD-CC0040 add
       END IF
       #FUN-C50128 add str--------------------------------
       
       #FUN-C50128 add end--------------------------------
       IF cl_null(sr.cca11) THEN LET sr.cca11 = 0 END IF 
       IF cl_null(sr.cca12) THEN LET sr.cca12 = 0 END IF    #FUN-C50128 add 
       IF tm.d_sw = 'Y' THEN 
          IF sr.cca11 <> sr.imk09 THEN 
             EXECUTE insert_prep USING   sr.*    
          END IF 
       ELSE 
          EXECUTE insert_prep USING   sr.*    
       END IF 
    #No.CHI-910037---end---
   
   #No.CHI-910037--begin-- mark
   #    LET l_cnt = 0 
   #    SELECT COUNT(*) INTO l_cnt FROM jce_file WHERE jce02=sr.imk02
   #    IF l_cnt > 0 THEN CONTINUE FOREACH END IF
   #   #-----------No.MOD-840595 end
   #   #---------No.MOD-690119 add 
   #    SELECT img21 INTO l_img21 FROM img_file 
   #       WHERE img01 = sr.ima01
   #         AND img02 = sr.imk02
   #         AND img03 = sr.imk03
   #         AND img04 = sr.imk04
   #    IF STATUS OR cl_null(l_img21) THEN
   #       LET l_img21 = 1
   #    END IF
   #    LET sr.imk09 = sr.imk09*l_img21
   #   #---------No.MOD-690119 add 
   #    IF tm.yn = "N" THEN
   #       LET sr.imk02 = ' ' LET sr.imk03 = ' ' LET sr.imk04 = ' '
   #    END IF
   #    #IF tm.d_sw='Y' AND sr.cca11=sr.imk09 THEN CONTINUE FOREACH END IF
   #    #No.3236 add
   #      LET s_imk09=0
   #    #-------------No.MOD-690119 modify
   #     #SELECT SUM(imk09) INTO s_imk09
   #     #  FROM imk_file
   #     # WHERE imk01=sr.ima01
   #     #   AND imk05=tm.yy AND imk06=tm.mm
   #     #   AND imk02 NOT IN (SELECT jce02 FROM jce_file)  #no.6913
   #
   #      SELECT SUM(imk09*img21) INTO s_imk09
   #        FROM imk_file,img_file
   #       WHERE imk01=sr.ima01
   #         AND imk05=tm.yy AND imk06=tm.mm
   #         AND imk02 NOT IN (SELECT jce02 FROM jce_file)  #no.6913
   #         AND img01=imk01
   #         AND img02=imk02
   #         AND img03=imk03
   #         AND img04=imk04
   #    #-------------No.MOD-690119 end
   #      IF cl_null(s_imk09) THEN LET s_imk09 = 0 END IF
   #    IF tm.d_sw='Y' AND sr.cca11=s_imk09 THEN CONTINUE FOREACH END IF
   #    #No.3236 end---
   #    #OUTPUT TO REPORT axcr190_rep(sr.*)                         #No.FUN-750101  
   #    EXECUTE insert_prep USING   sr.*                            #No.FUN-750101 
   #No.CHI-910037---end---
     END FOREACH
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
#No.FUN-750101 --BEGIN--
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'ima01,ima57,ima06,ima10,ima12,ima39, ima08,ima09 ,ima11')
        RETURNING tm.wc
     END IF
     LET g_str = tm.wc,';',tm.yy,';',tm.mm,';',tm.yn,';',g_ccz.ccz27
#No.FUN-750101   --END--
 
    #No.CHI-910037--begin--
    #判斷報表中是否存要打印差異資料。
     LET l_cnt = 0
     LET l_sql = " SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 "  WHERE dtype='D' "
     PREPARE sel_cnt_cr_prep FROM l_sql 
     EXECUTE sel_cnt_cr_prep INTO l_cnt
     IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
     IF l_cnt = 0 THEN 
        LET g_str = g_str,';','Y'
     ELSE 
        LET g_str = g_str,';','N'
     END IF     
    #No.CHI-910037---end---

    LET g_str = g_str,';',g_ccz.ccz26,';',tm.type  #CHI-C30012 #CHI-C60029 tm.type
    
     LET l_sql = " SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED      #No.FUN-750101                                                                    
    # CALL cl_prt_cs3("axcr190",l_name,l_sql,g_str)                       #No.FUN-750101   #No.CHI-910037 mark
     CALL cl_prt_cs3('axcr190','axcr190',l_sql,g_str)   #No.CHI-910037
     #FINISH REPORT axcr190_rep                                    #No.FUN-750101 
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)                  #No.FUN-750101 
END FUNCTION
 
#No.FUN-750101    --begin--
{
REPORT axcr190_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1           #No.FUN-680122CHAR(1)
   DEFINE sr	RECORD
            	ima01	LIKE ima_file.ima01,
            	ima02	LIKE ima_file.ima02,
            	ima25	LIKE ima_file.ima25,
            	imk02   LIKE imk_file.imk02,
            	imk03   LIKE imk_file.imk03,
            	imk04   LIKE imk_file.imk04,
            	cca11   LIKE cca_file.cca11,
            	imk09	LIKE imk_file.imk09
            	END RECORD
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.ima01,sr.imk02,sr.imk03,sr.imk04
  FORMAT
   PAGE HEADER
#No.FUN-670067-begin 
#      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#      IF g_towhom IS NULL OR g_towhom = ' '
#         THEN PRINT '';
#         ELSE PRINT 'TO:',g_towhom;
#      END IF
#      LET g_pageno = g_pageno + 1
#      PRINT ''
#      IF tm.yn = "N" THEN
#         PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1] CLIPPED
#         PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#               COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#         PRINT COLUMN 01,g_x[11] CLIPPED,tm.yy USING '&&&&',g_x[12] CLIPPED,
#                      tm.mm USING '&&',
#               COLUMN g_len-9,g_x[3] CLIPPED,PAGENO USING '<<<'
       PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED ))/2)+1,g_company CLIPPED                                                    
       LET g_pageno = g_pageno + 1                                                                                                   
       LET pageno_total = PAGENO USING '<<<',"/pageno"                                                                               
       PRINT g_head CLIPPED,pageno_total
       PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1] 
       PRINT COLUMN 01,g_x[11] CLIPPED,tm.yy USING '&&&&',g_x[12] CLIPPED,                                                        
                      tm.mm USING '&&'
       PRINT g_dash[1,g_len] CLIPPED
#No:9116
       PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,g_x[35] CLIPPED,                                     
               g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,g_x[39] CLIPPED     
#    PRINT g_x[13] CLIPPED,g_x[14] CLIPPED,g_x[15]
#         PRINT
#            "------------------- ------------------------------ ---- ----------------- ------------------ ---------------------"
##
         PRINT g_dash1
#      ELSE
#         PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1] CLIPPED
#         PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#               COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#         PRINT COLUMN 01,g_x[11] CLIPPED,tm.yy USING '&&&&',g_x[12] CLIPPED,
#               tm.mm USING '&&',
#               COLUMN g_len-9,g_x[3] CLIPPED,PAGENO USING '<<<'
#         PRINT g_dash_1[1,g_len] CLIPPED
##No:9116
#         PRINT g_x[16] CLIPPED,g_x[17] CLIPPED,g_x[18] CLIPPED,g_x[19] CLIPPED
#         PRINT
#            "------------------- ---------------------------------- ---- ---------- ----------  ------------------------ ----------- --------------- ----------------"
##
#      END IF
#No.FUN-670067-end 
 
      LET l_last_sw = 'n'
 
   AFTER GROUP OF sr.imk04
#No.FUN-670067-begin
#      IF tm.yn = "N" THEN
#No:9116
#         PRINT sr.ima01,
#                COLUMN 21,sr.ima02 CLIPPED, #MOD-4A0238
#                COLUMN 53,sr.ima25,
#                COLUMN 58,cl_numfor(GROUP SUM(sr.imk09),15,3),   # NO.MOD-530789
#                COLUMN 77,cl_numfor(sr.cca11,15,3),  # NO.MOD-530789
#                COLUMN 99,cl_numfor(GROUP SUM(sr.imk09)-sr.cca11,15,3)  # NO.MOD-530789
##
#      ELSE
#No:9116
#         PRINT sr.ima01,
#               COLUMN 21,sr.ima02 CLIPPED, #MOD-4A0238
#               COLUMN 57,sr.ima25,
#               COLUMN 61,sr.imk02,
#               COLUMN 72,sr.imk03,
#               COLUMN 84,sr.imk04,
#               COLUMN 104,cl_numfor(GROUP SUM(sr.imk09),15,3),
#               COLUMN 120,cl_numfor(sr.cca11,15,3),
#               COLUMN 132,cl_numfor(GROUP SUM(sr.imk09)-sr.cca11,15,3)
 
#      END IF
         PRINT  COLUMN g_c[31],sr.ima01,                                                                                            
                COLUMN g_c[32],sr.ima02 CLIPPED, #MOD-4A0238                                                                        
                COLUMN g_c[33],sr.ima25,                                                                                            
                COLUMN g_c[34],sr.imk02,                                                                                            
                COLUMN g_c[35],sr.imk03,                                                                                            
                COLUMN g_c[36],sr.imk04,                                                                                            
                COLUMN g_c[37],cl_numfor(GROUP SUM(sr.imk09),37,g_ccz.ccz27), #CHI-690007 3->ccz27                                                                 
                COLUMN g_c[38],cl_numfor(sr.cca11,38,g_ccz.ccz27), #CHI-690007 3->ccz27
                COLUMN g_c[39],cl_numfor(GROUP SUM(sr.imk09)-sr.cca11,39,g_ccz.ccz27) #CHI-690007 3->ccz27
#No.FUN-670067-end
 
   AFTER GROUP OF sr.ima01
      IF tm.yn = "Y" THEN
         PRINT COLUMN 93,'小計: ',         #No:9116
#No.FUN-670067-begin
#                COLUMN 108,cl_numfor(GROUP SUM(sr.imk09),11,3),  # NO.MOD-530789
#                COLUMN 124,cl_numfor(sr.cca11,11,3), # NO.MOD-530789
#                COLUMN 140,cl_numfor(GROUP SUM(sr.imk09)-sr.cca11,11,3)  # NO.MOD-530789
                COLUMN g_c[37],cl_numfor(GROUP SUM(sr.imk09),37,g_ccz.ccz27),  # NO.MOD-530789  #No.FUN-670067 #CHI-690007 3->ccz27                               
                COLUMN g_c[38],cl_numfor(sr.cca11,38,g_ccz.ccz27), # NO.MOD-530789       #No.FUN-670067  #CHI-690007 3->ccz27                                     
                COLUMN g_c[39],cl_numfor(GROUP SUM(sr.imk09)-sr.cca11,39,g_ccz.ccz27)  # NO.MOD-530789   #No.FUN-670067  #CHI-690007 3->ccz27                     
#No.FUN-670067-end
      END IF
   ON LAST ROW
      PRINT g_dash[1,g_len] CLIPPED
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len] CLIPPED
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
#Patch....NO.TQC-610037 <> #
}
#No.FUN-750101    --end--
 
 
#No.CHI-910037--begin--
FUNCTION r190_temp(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1  
    
    LET g_errno = ''
    IF p_cmd = 'd' THEN 
       DROP TABLE imk_temp;
       IF SQLCA.sqlcode THEN 
          LET g_errno = SQLCA.sqlcode
       END IF 
    END IF 
   
    IF p_cmd = 'r' THEN 
       DELETE FROM imk_temp; 
       IF SQLCA.sqlcode THEN 
          LET g_errno = SQLCA.sqlcode
       END IF 
    END IF 
    
    IF p_cmd = 'c' THEN 
       DROP TABLE imk_temp
       CREATE TEMP TABLE imk_temp( 
         ima01    LIKE ima_file.ima01,     #MOD-A30039 mod
         ima02    LIKE ima_file.ima02,
         ima25    LIKE ima_file.ima25,
         imk02    LIKE imk_file.imk02,
         imk03    LIKE imk_file.imk03,
         imk04    LIKE imk_file.imk04,
         imk09    LIKE imk_file.imk09,
         cca11    LIKE cca_file.cca11,
         cca07    LIKE cca_file.cca07,
         dtype    LIKE type_file.chr1,     #'B'-明細資料,'D'-差異資料
         cca12    LIKE cca_file.cca12,     #FUN-C50128 add
         ima39    LIKE ima_file.ima39,     #FUN-C50128 add
         imd09    LIKE imd_file.imd09);    #CHI-C60029
       IF SQLCA.sqlcode THEN 
          LET g_errno = SQLCA.sqlcode
       END IF 
    END IF 
    RETURN g_errno
END FUNCTION 
#No.CHI-910037---end---
 
