# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: axcr400.4gl
# Descriptions...: 重工前半製成品期報表
# Input parameter: 
# Return code....: 
# Date & Author..: 95/10/20 By Nick
# Modify ........: No:8741 03/11/25 By Melody 修改PRINT段
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.FUN-4C0099 04/12/31 By kim 報表轉XML功能
# Modify.........: No.MOD-530122 05/03/16 By Carol QBE欄位順序調整
# Modify.........: No.MOD-530508 05/04/4 By pengu 在QBE條件中欄位均可開窗選擇
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.TQC-610051 06/02/23 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680122 06/09/01 By zdyllq 類型轉換  
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0078 06/11/09 By ice 修正報表格式錯誤;修正FUN-680122改錯部分
# Modify.........: No.CHI-690007 06/12/26 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.FUN-7C0101 08/01/22 By Cockroach  增加字段TYPE(成本計算類別)和打印字段增加
        
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(300)      # Where condition
              yy,mm   LIKE type_file.num5,          #No.FUN-680122SMALLINT
              azh01   LIKE azh_file.azh01,           #No.FUN-680122CHAR(10)
              azh02   LIKE azh_file.azh02,        #No.FUN-680122CHAR(40)
              type    LIKE type_file.chr1,         #NO.FUN-7C0101 ADD
              more    LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)        # Input more condition(Y/N)
              END RECORD,
          g_tot_bal LIKE stm_file.stm05         #No.FUN-680122DECIMAL(13,2)     # User defined variable
   DEFINE bdate   LIKE type_file.dat            #No.FUN-680122 DATE
   DEFINE edate   LIKE type_file.dat            #No.FUN-680122 DATE
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
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
   LET tm.azh01 = ARG_VAL(10)
   LET tm.azh02 = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET tm.type    = ARG_VAL(15)   #FUN-7C0101 ADD 
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   ##No.FUN-570264 ---end---
   #TQC-610051-end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axcr400_tm(0,0)        # Input print condition
      ELSE CALL axcr400()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr400_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20 
   ELSE LET p_row = 4 LET p_col = 15
   END IF
   OPEN WINDOW axcr400_w AT p_row,p_col
        WITH FORM "axc/42f/axcr400" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.type = g_ccz.ccz28          #NO.FUN-7C0101 ADD
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   
WHILE TRUE
 ##MOD-530122
   CONSTRUCT BY NAME tm.wc ON ima01,ima08,ima09,ima11,
                              ima57,ima06, ima10,ima12
##
 
   #-------------------------------No.MOD-530508--------------------
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
   ON ACTION CONTROLP
      CASE
         WHEN INFIELD(ima01)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima01
            NEXT FIELD ima01
         WHEN INFIELD(ima08)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima7"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima08
            NEXT FIELD ima08
         WHEN INFIELD(ima09)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima8"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima09
            NEXT FIELD ima09
         WHEN INFIELD(ima11)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima9"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima11
            NEXT FIELD ima11
         WHEN INFIELD(ima57)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima10"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima57
            NEXT FIELD ima57
         WHEN INFIELD(ima06)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima11"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima06
            NEXT FIELD ima06
         WHEN INFIELD(ima10)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima12"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima10
            NEXT FIELD ima10
         WHEN INFIELD(ima12)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima13"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima12
            NEXT FIELD ima12
         OTHERWISE
            EXIT CASE
      END CASE
     #--------------------------No.MOD-530508 END-----------------------
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr400_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   LET tm.wc=tm.wc CLIPPED," AND ima01 NOT MATCHES 'MISC*'"
   INPUT BY NAME tm.yy,tm.mm,tm.azh01,tm.azh02,tm.type,tm.more WITHOUT DEFAULTS #NO.FUN-7C0101 ADD tm.type
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD yy
         IF tm.yy IS NULL THEN NEXT FIELD yy END IF
      AFTER FIELD mm
         IF tm.mm IS NULL THEN NEXT FIELD mm END IF
         CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
      AFTER FIELD azh01
         SELECT azh02 INTO tm.azh02 FROM azh_file WHERE azh01=tm.azh01
         DISPLAY BY NAME tm.azh02
      #NO.FUN-7C0101 --BEGIN--
      AFTER FIELD type
         IF tm.type IS NULL OR tm.type NOT MATCHES '[12345]' THEN
            NEXT FIELD type
         END IF    
         DISPLAY BY NAME tm.type   
       #NO.FUN-7C0101 --END--  
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(azh01)
#              CALL q_azh(4,4,tm.azh01,tm.azh02) RETURNING tm.azh01,tm.azh02
#              CALL FGL_DIALOG_SETBUFFER( tm.azh01 )
#              CALL FGL_DIALOG_SETBUFFER( tm.azh02 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_azh'
               LET g_qryparam.default1 = tm.azh01
               LET g_qryparam.default2 = tm.azh02
               CALL cl_create_qry() RETURNING tm.azh01,tm.azh02
#               CALL FGL_DIALOG_SETBUFFER( tm.azh01 )
#               CALL FGL_DIALOG_SETBUFFER( tm.azh02 )
               DISPLAY BY NAME tm.azh01,tm.azh02
            OTHERWISE
               EXIT CASE
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr400_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr400'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr400','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         #TQC-610051-begin
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",tm.azh01 CLIPPED,"'",
                         " '",tm.azh02 CLIPPED,"'",
                         " '",tm.type CLIPPED,"'",    #NO.FUN-7C0101 ADD
                         #TQC-610051-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axcr400',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr400_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr400()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr400_w
END FUNCTION
 
FUNCTION axcr400()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680122CHAR(20)        # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680122CHAR(600)
          l_chr        LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40)
          ccc   RECORD LIKE ccc_file.*,
          ima   RECORD LIKE ima_file.*
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT ccc_file.*, ima_file.*",
                 "  FROM ccc_file, ima_file",
                 " WHERE ",tm.wc,
                 "   AND ccc02=",tm.yy," AND ccc03=",tm.mm,
                 "   AND ccc07='",tm.type,"'",     #NO.FUN-7C0101 
                 "   AND ccc01=ima01 "
     PREPARE axcr400_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE axcr400_curs1 CURSOR FOR axcr400_prepare1
 
     CALL cl_outnam('axcr400') RETURNING l_name
     #TQC-6A0078...............begin                                                                                                
     IF NOT cl_null(tm.azh02) THEN                                                                                                  
        LET g_x[1]=tm.azh02 CLIPPED                                                                                                 
     END IF                                                                                                                         
     #TQC-6A0078...............end
     START REPORT axcr400_rep TO l_name
     LET g_pageno = 0
     FOREACH axcr400_curs1 INTO ccc.*, ima.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       OUTPUT TO REPORT axcr400_rep(ccc.*, ima.*)
     END FOREACH
 
     FINISH REPORT axcr400_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
#No.8741
REPORT axcr400_rep(ccc, ima)
   DEFINE l_last_sw    LIKE type_file.chr1          #No.FUN-680122CHAR(1)
   DEFINE ccc           RECORD LIKE ccc_file.*
   DEFINE ima           RECORD LIKE ima_file.*
   DEFINE l_dash       LIKE type_file.chr1000       #No.FUN-680122CHAR(400)   #FUN-4C0099 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY ccc.ccc01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED   #No.TQC-6A0078
      PRINT g_x[9] CLIPPED,tm.yy USING '&&&&',
            g_x[10] CLIPPED,tm.mm USING '&&'
      PRINT g_dash[1,g_len]   #No.TQC-6A0078
      
      PRINT COLUMN r400_getStartPos(36,41,g_x[14]),g_x[11],
            COLUMN r400_getStartPos(42,47,g_x[15]),g_x[12],
            COLUMN r400_getStartPos(48,53,g_x[16]),g_x[13],
            COLUMN r400_getStartPos(54,59,g_x[17]),g_x[14]
 
      PRINT COLUMN g_c[36],g_dash2[1,g_w[36]+g_w[37]+g_w[38]+g_w[39]+g_w[40]+g_w[41]+5],
            COLUMN g_c[42],g_dash2[1,g_w[42]+g_w[43]+g_w[44]+g_w[45]+g_w[46]+g_w[47]+5],
            COLUMN g_c[48],g_dash2[1,g_w[48]+g_w[49]+g_w[50]+g_w[51]+g_w[52]+g_w[53]+5],
            COLUMN g_c[54],g_dash2[1,g_w[54]+g_w[55]+g_w[56]+g_w[57]+g_w[58]+g_w[59]+5]
 
     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
           g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
           g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],
           g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],
           g_x[51],g_x[52],g_x[53],g_x[54],g_x[55],   #FUN-7C0101 ADD******
           g_x[56],g_x[57],g_x[58],g_x[59]    #FUN-7C0101 ADD******
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      PRINT COLUMN g_c[31],ccc.ccc01,
            COLUMN g_c[32],ima.ima02 CLIPPED, #MOD-4A0238
            COLUMN g_c[33],ima.ima021 CLIPPED,
            COLUMN g_c[34],ima.ima25
  #NO.FUN-7C0101 --BEGIN--
   IF tm.type MATCHES '[345]' THEN
      PRINT COLUMN g_c[35],ccc.ccc08
   END IF     
  #NO.FUN-7C0101 --END--            
      PRINT COLUMN g_c[36],cl_numfor(ccc.ccc11, 36,g_ccz.ccz27), #CHI-690007 0->ccz27
            COLUMN g_c[37],cl_numfor(ccc.ccc12a,37,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[38],cl_numfor(ccc.ccc12b,38,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[39],cl_numfor(ccc.ccc12e,39,g_ccz.ccz26),    #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[40],cl_numfor(ccc.ccc12g,40,g_ccz.ccz26),    #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[41],cl_numfor(ccc.ccc12, 41,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[42],cl_numfor(ccc.ccc21, 42,g_ccz.ccz27), #CHI-690007 0->ccz27
            COLUMN g_c[43],cl_numfor(ccc.ccc22a,43,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[44],cl_numfor(ccc.ccc22b,44,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[45],cl_numfor(ccc.ccc22e,45,g_ccz.ccz26),    #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[46],cl_numfor(ccc.ccc22g,46,g_ccz.ccz26),    #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[47],cl_numfor(ccc.ccc22, 47,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[48],cl_numfor(ccc.ccc25, 48,g_ccz.ccz27), #CHI-690007 0->ccz27
            COLUMN g_c[49],cl_numfor(ccc.ccc26a,49,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[50],cl_numfor(ccc.ccc26b,50,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[51],cl_numfor(ccc.ccc26e,51,g_ccz.ccz26),    #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[52],cl_numfor(ccc.ccc26g,52,g_ccz.ccz26),    #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[53],cl_numfor(ccc.ccc26, 53,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[54],cl_numfor((ccc.ccc11+ccc.ccc21+ccc.ccc25), 54,g_ccz.ccz27), #CHI-690007 0->ccz27
            COLUMN g_c[55],cl_numfor(ccc.ccc12a+ccc.ccc22a+ccc.ccc26a,55,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[56],cl_numfor(ccc.ccc12b+ccc.ccc22b+ccc.ccc26b,56,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[57],cl_numfor(ccc.ccc12e+ccc.ccc22e+ccc.ccc26e,57,g_ccz.ccz26),    #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[58],cl_numfor(ccc.ccc12g+ccc.ccc22g+ccc.ccc26g,58,g_ccz.ccz26),    #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[59],cl_numfor(ccc.ccc12 +ccc.ccc22 +ccc.ccc26, 59,g_ccz.ccz26)    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
      PRINT COLUMN g_c[37],cl_numfor(ccc.ccc12d,37,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[38],cl_numfor(ccc.ccc12c,38,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[39],cl_numfor(ccc.ccc12f,39,g_ccz.ccz26),    #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[40],cl_numfor(ccc.ccc12h,40,g_ccz.ccz26),    #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[43],cl_numfor(ccc.ccc22d,43,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[44],cl_numfor(ccc.ccc22c,44,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[45],cl_numfor(ccc.ccc22f,45,g_ccz.ccz26),    #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[46],cl_numfor(ccc.ccc22h,46,g_ccz.ccz26),    #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[49],cl_numfor(ccc.ccc26d,49,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[50],cl_numfor(ccc.ccc26c,50,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[51],cl_numfor(ccc.ccc26f,51,g_ccz.ccz26),    #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[52],cl_numfor(ccc.ccc26h,52,g_ccz.ccz26),    #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[55],cl_numfor((ccc.ccc12d+ccc.ccc22d+ccc.ccc26d),55,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[56],cl_numfor((ccc.ccc12c+ccc.ccc22c+ccc.ccc26c),56,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[57],cl_numfor( ccc.ccc12f+ccc.ccc22f+ccc.ccc26f, 57,g_ccz.ccz26),    #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[58],cl_numfor( ccc.ccc12h+ccc.ccc22h+ccc.ccc26h, 58,g_ccz.ccz26)     #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
 
   ON LAST ROW
      PRINT
      PRINT COLUMN g_c[34], g_x[15] CLIPPED,
            COLUMN g_c[36],cl_numfor(SUM(ccc.ccc11 ),36,g_ccz.ccz27), #CHI-690007 0->ccz27
            COLUMN g_c[37],cl_numfor(SUM(ccc.ccc12a),37,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[38],cl_numfor(SUM(ccc.ccc12b),38,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[39],cl_numfor(SUM(ccc.ccc12e),39,g_ccz.ccz26),    #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[40],cl_numfor(SUM(ccc.ccc12g),40,g_ccz.ccz26),    #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[41],cl_numfor(SUM(ccc.ccc12 ),41,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[42],cl_numfor(SUM(ccc.ccc21 ),42,g_ccz.ccz27), #CHI-690007 0->ccz27
            COLUMN g_c[43],cl_numfor(SUM(ccc.ccc22a),43,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[44],cl_numfor(SUM(ccc.ccc22b),44,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[45],cl_numfor(SUM(ccc.ccc22e),45,g_ccz.ccz26),    #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[46],cl_numfor(SUM(ccc.ccc22g),46,g_ccz.ccz26),    #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[47],cl_numfor(SUM(ccc.ccc22 ),47,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[48],cl_numfor(SUM(ccc.ccc25 ),48,g_ccz.ccz27), #CHI-690007 0->ccz27
            COLUMN g_c[49],cl_numfor(SUM(ccc.ccc26a),49,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[50],cl_numfor(SUM(ccc.ccc26b),50,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[51],cl_numfor(SUM(ccc.ccc26e),51,g_ccz.ccz26),    #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[52],cl_numfor(SUM(ccc.ccc26g),52,g_ccz.ccz26),    #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[53],cl_numfor(SUM(ccc.ccc26 ),53,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[54],cl_numfor(SUM( ccc.ccc11 +ccc.ccc21 +ccc.ccc25  ),54,g_ccz.ccz27), #CHI-690007 0->ccz27
            COLUMN g_c[55],cl_numfor(SUM((ccc.ccc12a+ccc.ccc22a+ccc.ccc26a)),55,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[56],cl_numfor(SUM((ccc.ccc12b+ccc.ccc22b+ccc.ccc26b)),56,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[57],cl_numfor(SUM((ccc.ccc12e+ccc.ccc22e+ccc.ccc26e)),57,g_ccz.ccz26),    #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[58],cl_numfor(SUM((ccc.ccc12g+ccc.ccc22g+ccc.ccc26g)),58,g_ccz.ccz26),    #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[59],cl_numfor(SUM((ccc.ccc12 +ccc.ccc22 +ccc.ccc26 )),59,g_ccz.ccz26)    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
      PRINT COLUMN g_c[37],cl_numfor(SUM(ccc.ccc12d),37,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[38],cl_numfor(SUM(ccc.ccc12c),38,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[39],cl_numfor(SUM(ccc.ccc12f),39,g_ccz.ccz26),    #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[40],cl_numfor(SUM(ccc.ccc12h),40,g_ccz.ccz26),    #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[43],cl_numfor(SUM(ccc.ccc22d),43,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[44],cl_numfor(SUM(ccc.ccc22c),44,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[45],cl_numfor(SUM(ccc.ccc22f),45,g_ccz.ccz26),    #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[46],cl_numfor(SUM(ccc.ccc22h),46,g_ccz.ccz26),    #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[49],cl_numfor(SUM(ccc.ccc26d),49,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[50],cl_numfor(SUM(ccc.ccc26c),50,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[51],cl_numfor(SUM(ccc.ccc26f),51,g_ccz.ccz26),    #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[52],cl_numfor(SUM(ccc.ccc26h),52,g_ccz.ccz26),    #FUN-7C0101 ADD ****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[55],cl_numfor(SUM((ccc.ccc12d+ccc.ccc22d+ccc.ccc26d)),55,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[56],cl_numfor(SUM((ccc.ccc12c+ccc.ccc22c+ccc.ccc26c)),56,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[57],cl_numfor(SUM((ccc.ccc12f+ccc.ccc22f+ccc.ccc26f)),57,g_ccz.ccz26),    #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[58],cl_numfor(SUM((ccc.ccc12h+ccc.ccc22h+ccc.ccc26h)),58,g_ccz.ccz26)     #FUN-7C0101 ADD****** #CHI-C30012 g_azi03->g_ccz.ccz26
      PRINT g_dash[1,g_len]   #No.TQC-6A0078
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED   #no.TQC-6A0078
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len] CLIPPED
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED   #No.TQC-6A0078
         ELSE SKIP 2 LINE
      END IF
#No.8741(END)
END REPORT
 
#by kim 05/1/26
#函式說明:算出一字串,位於數個連續表頭的中央位置
#l_sta -  zaa起始序號   l_end - zaa結束序號  l_sta -字串長度
#傳回值 - 字串起始位置
FUNCTION r400_getStartPos(l_sta,l_end,l_str)
DEFINE l_sta,l_end,l_length,l_pos,l_w_tot,l_i LIKE type_file.num5          #No.FUN-680122 SMALLINT
DEFINE l_str STRING
   LET l_str=l_str.trim()
   LET l_length=l_str.getLength()
   LET l_w_tot=0
   FOR l_i=l_sta to l_end
      LET l_w_tot=l_w_tot+g_w[l_i]
   END FOR
   LET l_pos=(l_w_tot/2)-(l_length/2)
   IF l_pos<0 THEN LET l_pos=0 END IF
   LET l_pos=l_pos+g_c[l_sta]+(l_end-l_sta)
   RETURN l_pos
END FUNCTION
