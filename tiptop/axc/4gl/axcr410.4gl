# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: axcr410.4gl
# Descriptions...: 重工後半製成品期報表
# Input parameter: 
# Return code....: 
# Date & Author..: 95/10/20 By Nick
# Modify ........: No:8741 03/11/25 By Melody 修改PRINT段
# Modify.........: No.FUN-4C0099 05/01/25 By kim 報表轉XML功能
# Modify.........: No.MOD-530122 05/03/16 By Carol QBE欄位順序調整
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/05 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.TQC-610051 06/02/22 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0078 06/11/13 By ice 修正報表格式錯誤;修正FUN-680122改錯部分
# Modify.........: No.FUN-660073 06/12/07 By Nicola 訂單樣品修改
# Modify.........: No.CHI-690007 06/12/26 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.CHI-710051 07/06/07 By jamie 將ima21欄位放大至11
# Modify.........: No.FUN-7C0101 08/01/24 By ChenMoyan 成本改善報表部分
# Modify.........: No.FUN-830140 08/04/09 By ChenMoyan 報表部分格式修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#CHI-710051
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(300)      # Where condition
              yy,mm   LIKE type_file.num5,          #No.FUN-680122SMALLINT
              type    LIKE type_file.chr1,          #No.FUN-7C0101
              azh01   LIKE azh_file.azh01,           #No.FUN-680122CHAR(10)
              azh02   LIKE azh_file.azh02,        #No.FUN-680122CHAR(40)
              more    LIKE type_file.chr1           #No.FUN-680122CHAR(1)        # Input more condition(Y/N)
              END RECORD,
          g_tot_bal LIKE ccq_file.ccq03           #No.FUN-680122DECIMAL(13,2)     # User defined variable
   DEFINE bdate   LIKE type_file.dat           #No.FUN-680122DATE
   DEFINE edate   LIKE type_file.dat           #No.FUN-680122DATE
 
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
   LET tm.type = ARG_VAL(15)       # No.FUN-7C0101
   #TQC-610051-begin
   LET tm.yy = ARG_VAL(8)
   LET tm.mm = ARG_VAL(9)
   LET tm.azh01 = ARG_VAL(10)
   LET tm.azh02 = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   ##No.FUN-570264 ---end---
   #TQC-610051-end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axcr410_tm(0,0)        # Input print condition
      ELSE CALL axcr410()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr410_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20 
   ELSE LET p_row = 4 LET p_col = 15
   END IF
   OPEN WINDOW axcr410_w AT p_row,p_col
        WITH FORM "axc/42f/axcr410" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.yy = YEAR(g_today)
   LET tm.mm = MONTH(g_today)
   LET tm.type = g_ccz.ccz28
WHILE TRUE
 #MOD-530122
   CONSTRUCT BY NAME tm.wc ON ima01,ima08,ima09,ima11,
                              ima57,ima06,ima10,ima12
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
     ON ACTION controlp                                                      
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr410_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   LET tm.wc=tm.wc CLIPPED," AND ima01 NOT MATCHES 'MISC*'"
#  INPUT BY NAME tm.yy,tm.mm,tm.azh01,tm.azh02,tm.more WITHOUT DEFAULTS          #No.FUN-7C0101
   INPUT BY NAME tm.yy,tm.mm,tm.type,tm.azh01,tm.azh02,tm.more WITHOUT DEFAULTS  #No.FUN-7C0101
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD yy
         IF tm.yy IS NULL THEN NEXT FIELD yy END IF
      AFTER FIELD mm
         IF tm.mm IS NULL THEN NEXT FIELD mm END IF
         CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
      #No.FUN-7C0101 --Begin
      AFTER FIELD type
         IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF
      #No.FUN-7C0101 --End
      AFTER FIELD azh01
         SELECT azh02 INTO tm.azh02 FROM azh_file WHERE azh01=tm.azh01
         DISPLAY BY NAME tm.azh02
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr410_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr410'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr410','9031',1)   
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
                         " '",tm.yy CLIPPED,"'",                #TQC-610051
                         " '",tm.mm CLIPPED,"'",                #TQC-610051
                         " '",tm.type CLIPPED,"'",              #No.FUN-7C0101
                         " '",tm.azh01 CLIPPED,"'",             #TQC-610051
                         " '",tm.azh02 CLIPPED,"'",             #TQC-610051
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axcr410',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr410_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr410()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr410_w
END FUNCTION
 
FUNCTION axcr410()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122 VARCHAR(20)       # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680122CHAR(600)
          l_chr        LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
          ccc   RECORD LIKE ccc_file.*,
          ima   RECORD LIKE ima_file.*
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT ccc_file.*, ima_file.*",
                 "  FROM ccc_file, ima_file",
                 " WHERE ",tm.wc,
                 "   AND ccc02=",tm.yy," AND ccc03=",tm.mm,
                 "   AND ccc01=ima01 "
                ,"   AND ccc07='",tm.type,"'"       #No.FUN-7C0101
     PREPARE axcr410_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE axcr410_curs1 CURSOR FOR axcr410_prepare1
 
     CALL cl_outnam('axcr410') RETURNING l_name
     #No.FUN-7C0101 --Begin
     IF tm.type MATCHES '[12]' THEN                                                                                                 
        LET g_zaa[35].zaa06='Y'                                                                                                     
     END IF                                                                                                                         
     IF tm.type MATCHES '[345]' THEN                                                                                                
        LET g_zaa[35].zaa06='N'                                                                                                     
     END IF          
     #No.FUN-7C0101 --End
     #TQC-6A0078...............begin                                                                                                
     IF NOT cl_null(tm.azh02) THEN                                                                                                  
        LET g_x[1]=tm.azh02 CLIPPED                                                                                                 
     END IF                                                                                                                         
     #TQC-6A0078...............end
     START REPORT axcr410_rep TO l_name
     LET g_pageno = 0
     FOREACH axcr410_curs1 INTO ccc.*, ima.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       OUTPUT TO REPORT axcr410_rep(ccc.*, ima.*)
     END FOREACH
 
     FINISH REPORT axcr410_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
#No.8741
REPORT axcr410_rep(ccc, ima)
   DEFINE l_last_sw     LIKE type_file.chr1           #No.FUN-680122CHAR(1)
   DEFINE ccc           RECORD LIKE ccc_file.*
   DEFINE ima           RECORD LIKE ima_file.*
   DEFINE pos1          LIKE type_file.num5,
          pos2          LIKE type_file.num5,
          pos3          LIKE type_file.num5,
          pos4          LIKE type_file.num5,
          pos5          LIKE type_file.num5,
          pos6          LIKE type_file.num5
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY ccc.ccc01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED     #No.TQC-6A0078
      PRINT g_x[9] CLIPPED,tm.yy USING '&&&&',
            g_x[10] CLIPPED,tm.mm USING '&&'
      PRINT g_dash[1,g_len]   #No.TQC-6A0078
      IF tm.type  MATCHES '[12]' THEN                                                                                                 
            LET pos1 = 35                                                                                                      
            LET pos2 = 41                                                                                            
            LET pos3 = 47                                                                                            
            LET pos4 = 53                                                                                            
            LET pos5 = 59                                                                                            
            LET pos6 = 64                                                                                            
    ELSE                                                                                                                            
            LET pos1 = 36                                                                                                      
            LET pos2 = 42                                                                                                      
            LET pos3 = 48                                                                                                      
            LET pos4 = 54                                                                                                      
            LET pos5 = 60                                                                                                      
            LET pos6 = 65                                                                                                      
    END IF  
    # No.FUN-7C0101 --Begin
    # PRINT COLUMN r410_getStartPos(35,38,g_x[11]),g_x[11],
    #       COLUMN r410_getStartPos(39,42,g_x[12]),g_x[12],
    #       COLUMN r410_getStartPos(43,46,g_x[13]),g_x[13],
    #       COLUMN r410_getStartPos(47,50,g_x[14]),g_x[14],
    #       COLUMN r410_getStartPos(51,54,g_x[15]),g_x[15]
      PRINT COLUMN r410_getStartPos(pos1,pos2-1,g_x[11]),g_x[11],                                                                         
            COLUMN r410_getStartPos(pos2,pos3-1,g_x[12]),g_x[12],                                                                         
            COLUMN r410_getStartPos(pos3,pos4-1,g_x[13]),g_x[13],                                                                         
            COLUMN r410_getStartPos(pos4,pos5-1,g_x[14]),g_x[14],                                                                         
            COLUMN r410_getStartPos(pos5,pos6,g_x[15]),g_x[15] 
    # PRINT COLUMN g_c[35],g_dash2[1,g_w[35]+g_w[36]+g_w[37]+g_w[38]+3],
    #       COLUMN g_c[39],g_dash2[1,g_w[39]+g_w[40]+g_w[41]+g_w[42]+3],
    #       COLUMN g_c[43],g_dash2[1,g_w[43]+g_w[44]+g_w[45]+g_w[46]+3],
    #       COLUMN g_c[47],g_dash2[1,g_w[47]+g_w[48]+g_w[49]+g_w[50]+3],
    #       COLUMN g_c[51],g_dash2[1,g_w[51]+g_w[52]+g_w[53]+g_w[54]+3]
    #FUN-830140 --Begin
    IF tm.type  MATCHES '[12]' THEN
            LET pos1 = g_c[35]
            LET pos2 = g_c[42] - 26 
            LET pos3 = g_c[48] - 26
            LET pos4 = g_c[54] - 26
            LET pos5 = g_c[60] - 26                                                                                            
            LET pos6 = g_c[65] - 26
    ELSE 
            LET pos1 = g_c[36]                                                                                                      
            LET pos2 = g_c[42]                                                                                        
            LET pos3 = g_c[48]                                                                                          
            LET pos4 = g_c[54]                                                                                          
            LET pos5 = g_c[60]                                                                                         
            LET pos6 = g_c[65] 
    END IF
            PRINT COLUMN pos1,g_dash2[1,g_w[36]+g_w[37]+g_w[38]+g_w[39]+g_w[40]+g_w[41]+4],                                            
                  COLUMN pos2,g_dash2[1,g_w[42]+g_w[43]+g_w[44]+g_w[45]+g_w[46]+g_w[47]+4],                                            
                  COLUMN pos3,g_dash2[1,g_w[48]+g_w[49]+g_w[50]+g_w[51]+g_w[52]+g_w[53]+4],                                            
                  COLUMN pos4,g_dash2[1,g_w[54]+g_w[55]+g_w[56]+g_w[57]+g_w[58]+g_w[59]+4],                                            
                  COLUMN pos5,g_dash2[1,g_w[60]+g_w[61]+g_w[62]+g_w[63]+g_w[64]+g_w[65]+5] 
    {ELSE
    #FUN-830140 --End
        IF tm.type  MATCHES '[345]' THEN
            PRINT COLUMN g_c[36],g_dash2[1,g_w[36]+g_w[37]+g_w[38]+g_w[39]+g_w[40]+g_w[41]+3]                                                            
            PRINT COLUMN g_c[42],g_dash2[1,g_w[42]+g_w[43]+g_w[44]+g_w[45]+g_w[46]+g_w[47]+3]                                                            
            PRINT COLUMN g_c[48],g_dash2[1,g_w[48]+g_w[49]+g_w[50]+g_w[51]+g_w[52]+g_w[53]+3]                                                            
            PRINT COLUMN g_c[54],g_dash2[1,g_w[54]+g_w[55]+g_w[56]+g_w[57]+g_w[58]+g_w[59]+3]                                                            
            PRINT COLUMN g_c[60],g_dash2[1,g_w[60]+g_w[61]+g_w[62]+g_w[63]+g_w[64]+g_w[65]+5]
         END IF}
    # No.FUN-7C0101 --End  
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],
            g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],
            g_x[51],g_x[52],g_x[53],g_x[54]
    # No.FUN-7C0101 --Begin
           ,g_x[55],g_x[56],g_x[57],g_x[58],g_x[59],
            g_x[60],g_x[61],g_x[62],g_x[63],g_x[64],
            g_x[65]
    # No.FUN-7C0101 --End
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      PRINT COLUMN g_c[31],ccc.ccc01,
            COLUMN g_c[32],ima.ima02,
            COLUMN g_c[33],ima.ima21,
            COLUMN g_c[34],ima.ima25,
          # No.FUN-7C0101 --Begin
            COLUMN g_c[35],ccc.ccc08,
          # COLUMN g_c[35],cl_numfor((ccc.ccc11 +ccc.ccc21 +ccc.ccc25),35,g_ccz.ccz27), #CHI-690007 0->ccz27
            COLUMN g_c[36],cl_numfor((ccc.ccc11 +ccc.ccc21 +ccc.ccc25),36,g_ccz.ccz27), 
          # COLUMN g_c[36],cl_numfor((ccc.ccc12a+ccc.ccc22a+ccc.ccc26a),36,g_azi03),    #FUN-570190
            COLUMN g_c[37],cl_numfor((ccc.ccc12a+ccc.ccc22a+ccc.ccc26a),37,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[37],cl_numfor((ccc.ccc12b+ccc.ccc22b+ccc.ccc26b),37,g_azi03),    #FUN-570190
            COLUMN g_c[38],cl_numfor((ccc.ccc12b+ccc.ccc22b+ccc.ccc26b),38,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[39],cl_numfor((ccc.ccc12e+ccc.ccc22e+ccc.ccc26e),39,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[40],cl_numfor((ccc.ccc12g+ccc.ccc22g+ccc.ccc26g),40,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[38],cl_numfor((ccc.ccc12 +ccc.ccc22 +ccc.ccc26 ),38,g_azi03),    #FUN-570190
            COLUMN g_c[41],cl_numfor((ccc.ccc12 +ccc.ccc22 +ccc.ccc26 ),41,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[39],cl_numfor(ccc.ccc27,39,g_ccz.ccz27), #CHI-690007 0->ccz27
            COLUMN g_c[42],cl_numfor(ccc.ccc27,42,g_ccz.ccz27),
          # COLUMN g_c[40],cl_numfor(ccc.ccc28a,40,g_azi03),    #FUN-570190 
            COLUMN g_c[43],cl_numfor(ccc.ccc28a,43,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[41],cl_numfor(ccc.ccc28b,41,g_azi03),    #FUN-570190
            COLUMN g_c[44],cl_numfor(ccc.ccc28b,44,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[45],cl_numfor(ccc.ccc28e,45,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[46],cl_numfor(ccc.ccc28g,46,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[42],cl_numfor(ccc.ccc28,42,g_azi03),    #FUN-570190
            COLUMN g_c[47],cl_numfor(ccc.ccc28,47,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[43],cl_numfor(ccc.ccc31,43,g_ccz.ccz27), #CHI-690007 0->ccz27
            COLUMN g_c[48],cl_numfor(ccc.ccc31,48,g_ccz.ccz27),
          # COLUMN g_c[44],cl_numfor(ccc.ccc31*ccc.ccc23a,44,g_azi03),    #FUN-570190
            COLUMN g_c[49],cl_numfor(ccc.ccc31*ccc.ccc23a,49,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[45],cl_numfor(ccc.ccc31*ccc.ccc23b,45,g_azi03),    #FUN-570190
            COLUMN g_c[50],cl_numfor(ccc.ccc31*ccc.ccc23b,50,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[51],cl_numfor(ccc.ccc31*ccc.ccc23e,51,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[52],cl_numfor(ccc.ccc31*ccc.ccc23g,52,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[46],cl_numfor(ccc.ccc32,46,g_azi03),    #FUN-570190
            COLUMN g_c[53],cl_numfor(ccc.ccc32,53,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[47],cl_numfor((ccc.ccc41 +ccc.ccc51 +ccc.ccc61 +ccc.ccc71 +ccc.ccc81),47,g_ccz.ccz27),  #No.FUN-660073  #CHI-690007 0->ccz27
            COLUMN g_c[54],cl_numfor((ccc.ccc41 +ccc.ccc51 +ccc.ccc61 +ccc.ccc71 +ccc.ccc81),54,g_ccz.ccz27),         
          # COLUMN g_c[48],cl_numfor((ccc.ccc41 +ccc.ccc51 +ccc.ccc61 +ccc.ccc71 +ccc.ccc81)*ccc.ccc23a,48,g_azi03),    #FUN-570190  #No.FUN-660073
            COLUMN g_c[55],cl_numfor((ccc.ccc41 +ccc.ccc51 +ccc.ccc61 +ccc.ccc71 +ccc.ccc81)*ccc.ccc23a,55,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26  
          # COLUMN g_c[49],cl_numfor((ccc.ccc41 +ccc.ccc51 +ccc.ccc61 +ccc.ccc71 +ccc.ccc81)*ccc.ccc23b,49,g_azi03),    #FUN-570190  #No.FUN-660073
            COLUMN g_c[56],cl_numfor((ccc.ccc41 +ccc.ccc51 +ccc.ccc61 +ccc.ccc71 +ccc.ccc81)*ccc.ccc23b,56,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[57],cl_numfor((ccc.ccc41 +ccc.ccc51 +ccc.ccc61 +ccc.ccc71 +ccc.ccc81)*ccc.ccc23e,57,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[58],cl_numfor((ccc.ccc41 +ccc.ccc51 +ccc.ccc61 +ccc.ccc71 +ccc.ccc81)*ccc.ccc23g,58,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[50],cl_numfor((ccc.ccc42 +ccc.ccc52 +ccc.ccc62 +ccc.ccc72 +ccc.ccc82),50,g_azi03),    #FUN-570190  #No.FUN-660073
            COLUMN g_c[59],cl_numfor((ccc.ccc42 +ccc.ccc52 +ccc.ccc62 +ccc.ccc72 +ccc.ccc82),59,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[51],cl_numfor(ccc.ccc91,51,g_ccz.ccz27),  #CHI-690007 0->ccz27
            COLUMN g_c[60],cl_numfor(ccc.ccc91,60,g_ccz.ccz27),
          # COLUMN g_c[52],cl_numfor(ccc.ccc92a,52,g_azi03),    #FUN-570190
            COLUMN g_c[61],cl_numfor(ccc.ccc92a,61,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[53],cl_numfor(ccc.ccc92b,53,g_azi03),    #FUN-570190
            COLUMN g_c[62],cl_numfor(ccc.ccc92b,62,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[63],cl_numfor(ccc.ccc92e,63,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[64],cl_numfor(ccc.ccc92g,64,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[54],cl_numfor(ccc.ccc92,54,g_azi03)    #FUN-570190
            COLUMN g_c[65],cl_numfor(ccc.ccc92,65,g_ccz.ccz26) #CHI-C30012 g_azi03->g_ccz.ccz26
   #  PRINT COLUMN g_c[36],cl_numfor((ccc.ccc12d+ccc.ccc22d+ccc.ccc26d),36,g_azi03),    #FUN-570190
      PRINT COLUMN g_c[37],cl_numfor((ccc.ccc12d+ccc.ccc22d+ccc.ccc26d),37,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[37],cl_numfor((ccc.ccc12c+ccc.ccc22c+ccc.ccc26c),37,g_azi03),    #FUN-570190
            COLUMN g_c[38],cl_numfor((ccc.ccc12c+ccc.ccc22c+ccc.ccc26c),38,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[39],cl_numfor((ccc.ccc12f+ccc.ccc22f+ccc.ccc26f),39,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[40],cl_numfor((ccc.ccc12h+ccc.ccc22h+ccc.ccc26h),40,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[40],cl_numfor(ccc.ccc28d,40,g_azi03),    #FUN-570190
            COLUMN g_c[43],cl_numfor(ccc.ccc28d,43,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[41],cl_numfor(ccc.ccc28c,41,g_azi03),    #FUN-570190
            COLUMN g_c[44],cl_numfor(ccc.ccc28c,44,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[45],cl_numfor(ccc.ccc28f,45,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[46],cl_numfor(ccc.ccc28h,46,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[44],cl_numfor(ccc.ccc31*ccc.ccc23d,44,g_azi03),    #FUN-570190
            COLUMN g_c[49],cl_numfor(ccc.ccc31*ccc.ccc23d,49,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[45],cl_numfor(ccc.ccc31*ccc.ccc23c,45,g_azi03),    #FUN-570190
            COLUMN g_c[50],cl_numfor(ccc.ccc31*ccc.ccc23c,50,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[48],cl_numfor((ccc.ccc41 +ccc.ccc51 +ccc.ccc61 +ccc.ccc71 +ccc.ccc81)*ccc.ccc23d,48,g_azi03),    #FUN-570190  #No.FUN-660073
            COLUMN g_c[55],cl_numfor((ccc.ccc41 +ccc.ccc51 +ccc.ccc61 +ccc.ccc71 +ccc.ccc81)*ccc.ccc23d,55,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[49],cl_numfor((ccc.ccc41 +ccc.ccc51 +ccc.ccc61 +ccc.ccc71 +ccc.ccc81)*ccc.ccc23c,49,g_azi03),    #FUN-570190  #No.FUN-660073
            COLUMN g_c[56],cl_numfor((ccc.ccc41 +ccc.ccc51 +ccc.ccc61 +ccc.ccc71 +ccc.ccc81)*ccc.ccc23c,56,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[57],cl_numfor((ccc.ccc41 +ccc.ccc51 +ccc.ccc61 +ccc.ccc71 +ccc.ccc81)*ccc.ccc23e,57,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[58],cl_numfor((ccc.ccc41 +ccc.ccc51 +ccc.ccc61 +ccc.ccc71 +ccc.ccc81)*ccc.ccc23h,58,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[52],cl_numfor(ccc.ccc92d,52,g_azi03),    #FUN-570190
            COLUMN g_c[61],cl_numfor(ccc.ccc92d,61,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[53],cl_numfor(ccc.ccc92c,53,g_azi03)    #FUN-570190
            COLUMN g_c[62],cl_numfor(ccc.ccc92c,62,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[63],cl_numfor(ccc.ccc92f,63,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[64],cl_numfor(ccc.ccc92h,64,g_ccz.ccz26) #CHI-C30012 g_azi03->g_ccz.ccz26
          # No.FUN-7C0101 --End
   ON LAST ROW
      PRINT
      PRINT COLUMN g_c[33],g_x[16] CLIPPED,
          # No.FUN-7C0101 --Begin
          # COLUMN g_c[35],cl_numfor(SUM(ccc.ccc11 +ccc.ccc21 +ccc.ccc25),35,g_ccz.ccz27),  #CHI-690007 0->ccz27
            COLUMN g_c[36],cl_numfor(SUM(ccc.ccc11 +ccc.ccc21 +ccc.ccc25),36,g_ccz.ccz27),
          # COLUMN g_c[36],cl_numfor(SUM(ccc.ccc12a+ccc.ccc22a+ccc.ccc26a),36,g_azi03),    #FUN-570190
            COLUMN g_c[37],cl_numfor(SUM(ccc.ccc12a+ccc.ccc22a+ccc.ccc26a),37,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[37],cl_numfor(SUM(ccc.ccc12b+ccc.ccc22b+ccc.ccc26b),37,g_azi03),    #FUN-570190
            COLUMN g_c[38],cl_numfor(SUM(ccc.ccc12b+ccc.ccc22b+ccc.ccc26b),38,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[39],cl_numfor(SUM(ccc.ccc12e+ccc.ccc22b+ccc.ccc26e),39,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[40],cl_numfor(SUM(ccc.ccc12g+ccc.ccc22b+ccc.ccc26g),40,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[38],cl_numfor(SUM(ccc.ccc12 +ccc.ccc22 +ccc.ccc26 ),38,g_azi03),    #FUN-570190
            COLUMN g_c[41],cl_numfor(SUM(ccc.ccc12 +ccc.ccc22 +ccc.ccc26 ),41,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[39],cl_numfor(SUM(ccc.ccc27),39,g_ccz.ccz27), #CHI-690007 0->ccz27
            COLUMN g_c[42],cl_numfor(SUM(ccc.ccc27),42,g_ccz.ccz27),
          # COLUMN g_c[40],cl_numfor(SUM(ccc.ccc28a),40,g_azi03),    #FUN-570190
            COLUMN g_c[43],cl_numfor(SUM(ccc.ccc27),43,g_ccz.ccz27),
          # COLUMN g_c[41],cl_numfor(SUM(ccc.ccc28b),41,g_azi03),    #FUN-570190
            COLUMN g_c[44],cl_numfor(SUM(ccc.ccc28b),44,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[45],cl_numfor(SUM(ccc.ccc28e),45,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[46],cl_numfor(SUM(ccc.ccc28g),46,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[42],cl_numfor(SUM(ccc.ccc28 ),42,g_azi03),    #FUN-570190
            COLUMN g_c[47],cl_numfor(SUM(ccc.ccc28 ),47,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[43],cl_numfor(SUM(ccc.ccc31),43,g_ccz.ccz27), #CHI-690007 0->ccz27
            COLUMN g_c[48],cl_numfor(SUM(ccc.ccc31),48,g_ccz.ccz27),
          # COLUMN g_c[44],cl_numfor(SUM(ccc.ccc31*ccc.ccc23a),44,g_azi03),    #FUN-570190
            COLUMN g_c[49],cl_numfor(SUM(ccc.ccc31*ccc.ccc23a),49,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[45],cl_numfor(SUM(ccc.ccc31*ccc.ccc23b),45,g_azi03),    #FUN-570190
            COLUMN g_c[50],cl_numfor(SUM(ccc.ccc31*ccc.ccc23b),50,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[51],cl_numfor(SUM(ccc.ccc31*ccc.ccc23e),51,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[52],cl_numfor(SUM(ccc.ccc31*ccc.ccc23g),52,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[46],cl_numfor(SUM(ccc.ccc32),46,g_azi03),    #FUN-570190
            COLUMN g_c[53],cl_numfor(SUM(ccc.ccc32),53,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[47],cl_numfor(SUM((ccc.ccc41 +ccc.ccc51 +ccc.ccc61 +ccc.ccc71 +ccc.ccc81)),47,g_ccz.ccz27),  #No.FUN-660073 #CHI-690007 0->ccz27
            COLUMN g_c[54],cl_numfor(SUM((ccc.ccc41 +ccc.ccc51 +ccc.ccc61 +ccc.ccc71 +ccc.ccc81)),54,g_ccz.ccz27),
          # COLUMN g_c[48],cl_numfor(SUM((ccc.ccc41 +ccc.ccc51 +ccc.ccc61 +ccc.ccc71 +ccc.ccc81)*ccc.ccc23a),48,g_azi03),    #FUN-570190  #No.FUN-660073
            COLUMN g_c[55],cl_numfor(SUM((ccc.ccc41 +ccc.ccc51 +ccc.ccc61 +ccc.ccc71 +ccc.ccc81)*ccc.ccc23a),55,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[49],cl_numfor(SUM((ccc.ccc41 +ccc.ccc51 +ccc.ccc61 +ccc.ccc71 +ccc.ccc81)*ccc.ccc23b),49,g_azi03),    #FUN-570190  #No.FUN-660073
            COLUMN g_c[56],cl_numfor(SUM((ccc.ccc41 +ccc.ccc51 +ccc.ccc61 +ccc.ccc71 +ccc.ccc81)*ccc.ccc23b),56,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[57],cl_numfor(SUM((ccc.ccc41 +ccc.ccc51 +ccc.ccc61 +ccc.ccc71 +ccc.ccc81)*ccc.ccc23e),57,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[58],cl_numfor(SUM((ccc.ccc41 +ccc.ccc51 +ccc.ccc61 +ccc.ccc71 +ccc.ccc81)*ccc.ccc23g),58,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[50],cl_numfor(SUM((ccc.ccc42 +ccc.ccc52 +ccc.ccc62 +ccc.ccc72 +ccc.ccc82)),50,g_azi03),    #FUN-570190  #No.FUN-660073
            COLUMN g_c[59],cl_numfor(SUM((ccc.ccc42 +ccc.ccc52 +ccc.ccc62 +ccc.ccc72 +ccc.ccc82)),59,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[51],cl_numfor(SUM(ccc.ccc91),51,g_ccz.ccz27),  #CHI-690007 0->ccz27
            COLUMN g_c[60],cl_numfor(SUM(ccc.ccc91),60,g_ccz.ccz27),
          # COLUMN g_c[52],cl_numfor(SUM(ccc.ccc92a),52,g_azi03),    #FUN-570190
            COLUMN g_c[61],cl_numfor(SUM(ccc.ccc92a),61,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[53],cl_numfor(SUM(ccc.ccc92b),53,g_azi03),    #FUN-570190
            COLUMN g_c[63],cl_numfor(SUM(ccc.ccc92b),62,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[63],cl_numfor(SUM(ccc.ccc92e),63,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[64],cl_numfor(SUM(ccc.ccc92g),64,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[54],cl_numfor(SUM(ccc.ccc92 ),54,g_azi03)    #FUN-570190
            COLUMN g_c[54],cl_numfor(SUM(ccc.ccc92 ),65,g_ccz.ccz26) #CHI-C30012 g_azi03->g_ccz.ccz26
    # PRINT COLUMN g_c[36],cl_numfor(SUM(ccc.ccc12d+ccc.ccc22d+ccc.ccc26d),36,g_azi03),    #FUN-570190
      PRINT COLUMN g_c[37],cl_numfor(SUM(ccc.ccc12d+ccc.ccc22d+ccc.ccc26d),37,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[37],cl_numfor(SUM(ccc.ccc12c+ccc.ccc22c+ccc.ccc26c),37,g_azi03),    #FUN-570190
            COLUMN g_c[38],cl_numfor(SUM(ccc.ccc12c+ccc.ccc22c+ccc.ccc26c),38,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[39],cl_numfor(SUM(ccc.ccc12f+ccc.ccc22f+ccc.ccc26f),39,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26                                         
            COLUMN g_c[40],cl_numfor(SUM(ccc.ccc12h+ccc.ccc22g+ccc.ccc26h),40,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26         
          # COLUMN g_c[40],cl_numfor(SUM(ccc.ccc28d),40,g_azi03),    #FUN-570190
            COLUMN g_c[43],cl_numfor(SUM(ccc.ccc28d),43,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[41],cl_numfor(SUM(ccc.ccc28c),41,g_azi03),    #FUN-570190
            COLUMN g_c[44],cl_numfor(SUM(ccc.ccc28c),44,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[45],cl_numfor(SUM(ccc.ccc28f),45,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[46],cl_numfor(SUM(ccc.ccc28h),46,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[44],cl_numfor(SUM(ccc.ccc31*ccc.ccc23d),44,g_azi03),    #FUN-570190
            COLUMN g_c[49],cl_numfor(SUM(ccc.ccc31*ccc.ccc23d),49,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[45],cl_numfor(SUM(ccc.ccc31*ccc.ccc23c),45,g_azi03),    #FUN-570190
            COLUMN g_c[50],cl_numfor(SUM(ccc.ccc31*ccc.ccc23c),50,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[51],cl_numfor(SUM(ccc.ccc31*ccc.ccc23f),51,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[52],cl_numfor(SUM(ccc.ccc31*ccc.ccc23h),52,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[48],cl_numfor(SUM((ccc.ccc41 +ccc.ccc51 +ccc.ccc61 +ccc.ccc71 +ccc.ccc81)*ccc.ccc23d),48,g_azi03),    #FUN-570190  #No.FUN-660073
            COLUMN g_c[55],cl_numfor(SUM((ccc.ccc41 +ccc.ccc51 +ccc.ccc61 +ccc.ccc71 +ccc.ccc81)*ccc.ccc23d),55,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[49],cl_numfor(SUM((ccc.ccc41 +ccc.ccc51 +ccc.ccc61 +ccc.ccc71 +ccc.ccc81)*ccc.ccc23c),49,g_azi03),    #FUN-570190  #No.FUN-660073
            COLUMN g_c[49],cl_numfor(SUM((ccc.ccc41 +ccc.ccc51 +ccc.ccc61 +ccc.ccc71 +ccc.ccc81)*ccc.ccc23c),56,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[57],cl_numfor(SUM((ccc.ccc41 +ccc.ccc51 +ccc.ccc61 +ccc.ccc71 +ccc.ccc81)*ccc.ccc23f),57,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[58],cl_numfor(SUM((ccc.ccc41 +ccc.ccc51 +ccc.ccc61 +ccc.ccc71 +ccc.ccc81)*ccc.ccc23h),58,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[52],cl_numfor(SUM(ccc.ccc92d),52,g_azi03),    #FUN-570190
            COLUMN g_c[61],cl_numfor(SUM(ccc.ccc92d),61,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
          # COLUMN g_c[53],cl_numfor(SUM(ccc.ccc92c),53,g_azi03)    #FUN-570190
            COLUMN g_c[62],cl_numfor(SUM(ccc.ccc92c),62,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[63],cl_numfor(SUM(ccc.ccc92f),63,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[64],cl_numfor(SUM(ccc.ccc92h),64,g_ccz.ccz26) #CHI-C30012 g_azi03->g_ccz.ccz26
          # No.FUN-7C0101 --End
      PRINT g_dash[1,g_len]   #No.TQC-6A0078
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]   #No.TQC-6A0078
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
#No.8741(END)
END REPORT
 
#by kim 05/1/26
#函式說明:算出一字串,位於數個連續表頭的中央位置
#l_sta -  zaa起始序號   l_end - zaa結束序號  l_sta -字串長度
#傳回值 - 字串起始位置
FUNCTION r410_getStartPos(l_sta,l_end,l_str)
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
