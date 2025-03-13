# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: axcr200.4gl
# Descriptions...: 工單投入工時明細表
# Input parameter: 
# Return code....: 
# Date & Author..: 96/02/10 By Roger
# Modify ........: No:8741 03/11/25 By Melody 修改PRINT段
# Modify.........: NO.9804 04/07/27 BY wiky add 生產量' 欄位放大
# Modify.........: No.FUN-4C0099 04/12/29 By kim 報表轉XML功能
# Modify.........: No.MOD-530181 05/03/21 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570240 05/07/28 By elva 月份改為由期別抓資料
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.FUN-580121 05/08/22 by saki 報表背景執行功能
# Modify.........: No.MOD-590295 05/09/13 by Claire sql 要串年度月份
# Modify.........: No.FUN-680122 06/09/01 By zdyllq 類型轉換  
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/26 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-7C0101 08/01/25 By ChenMoyan 成本改善報表部分
# Modify.........: No.FUN-830135 08/03/28 By ChenMoyan 成本改善報表部分修改抓取cck_file的SQL
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.MOD-870121 08/07/17 By Sarah 原先抓ccg_file工時與金額,改抓cch_file DL+OH+SUB的cch21,cch22b,cch22c,cch22e,cch22f,cch22g,cch22h
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-C30012 12/07/27 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,       #No.FUN-680122CHAR(300)      # Where condition
              yy,mm   LIKE type_file.num5,          #No.FUN-680122SMALLINT
              type    LIKE type_file.chr1,          #No.FUN-7C0101
              n       LIKE type_file.chr1,          #No.FUN-680122CHAR(1)
              more    LIKE type_file.chr1           #No.FUN-680122CHAR(1)       # Input more condition(Y/N)
              END RECORD,
          g_tot_bal LIKE type_file.num20_6        #No.FUN-680122DECIMAL(20,6)     # User defined variable
   DEFINE bdate   LIKE type_file.dat            #No.FUN-680122DATE 
   DEFINE edate   LIKE type_file.dat            #No.FUN-680122DATE 
    DEFINE g_sql   string  #No.FUN-580092 HCN
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680122CHAR(72)
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   #No.FUN-580121 --start--
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_lang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.yy = ARG_VAL(8)
   LET tm.mm = ARG_VAL(9)
   LET tm.n = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)           #No.FUN-570264
   LET g_rep_clas = ARG_VAL(12)           #No.FUN-570264
   LET g_template = ARG_VAL(13)           #No.FUN-570264
   #No.FUN-580121 ---end---
   LET tm.type = ARG_VAL(14)              #No.FUN-7C0101
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
 
   #No.FUN-580121 --start--
   IF cl_null(g_bgjob) OR g_bgjob = "N" THEN
      CALL axcr200_tm(0,0)        # Input print condition
   ELSE
      CALL axcr200()
   END IF
   #No.FUN-580121 ---end---
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr200_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW axcr200_w AT p_row,p_col
        WITH FORM "axc/42f/axcr200" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
 
   #No.FUN-580121 --start--
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   CALL s_yp(g_today) RETURNING tm.yy,tm.mm  #FUN-570240
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #No.FUN-580121 ---end---
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON sfb01,sfb05 
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
        IF INFIELD(sfb05) THEN                                              
           CALL cl_init_qry_var()                                           
           LET g_qryparam.form = "q_ima"                                    
           LET g_qryparam.state = "c"                                       
           CALL cl_create_qry() RETURNING g_qryparam.multiret               
           DISPLAY g_qryparam.multiret TO sfb05                             
           NEXT FIELD sfb05                                                 
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axcr200_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   LET tm.n = '3'
   LET tm.type = g_ccz.ccz28
#  INPUT BY NAME tm.yy,tm.mm,tm.n,tm.more WITHOUT DEFAULTS         #No.FUN-7C0101
   INPUT BY NAME tm.yy,tm.mm,tm.type,tm.n,tm.more WITHOUT DEFAULTS #No.FUN-7C0101
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD yy
         IF tm.yy IS NULL THEN NEXT FIELD yy END IF
      AFTER FIELD mm
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.mm > 12 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            ELSE
               IF tm.mm > 13 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            END IF
         END IF
#       #FUN-570240  --begin
#       # IF tm.mm IS NULL THEN NEXT FIELD mm END IF
#         IF cl_null(tm.mm) OR tm.mm < 1 OR tm.mm > 13 THEN
#            NEXT FIELD mm
#         END IF
#       #FUN-570240  --end
#No.TQC-720032 -- end --
         CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr200_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file WHERE zz01='axcr200'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr200','9031',1)   
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
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",tm.type CLIPPED,"'",
                         " '",tm.n  CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axcr200',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr200_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr200()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr200_w
END FUNCTION
 
FUNCTION axcr200()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680122CHAR(20)        # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680122CHAR(600)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40)
          l_order    ARRAY[5] OF LIKE cre_file.cre08,           #No.FUN-680122CHAR(10),
          sr            RECORD sfb01   LIKE sfb_file.sfb01,
                               sfb05   LIKE sfb_file.sfb05,
                               ccg07   LIKE ccg_file.ccg07,            #No.FUN-7C0101
                               ccg20   LIKE ccg_file.ccg20,
                               ccj05   LIKE ccj_file.ccj05,
                               ccj06   LIKE ccj_file.ccj06,
                               ccg22b  LIKE ccg_file.ccg22b,           #No.FUN-680122DEC(15,3)
                               ccg22c  LIKE ccg_file.ccg22c            #No.FUN-680122DEC(15,3)
                              ,ccg22e  LIKE ccg_file.ccg22e,           #No.FUN-7C0101
                               ccg22f  LIKE ccg_file.ccg22f,           #No.FUN-7C0101
                               ccg22g  LIKE ccg_file.ccg22g,           #No.FUN-7C0101                           
                               ccg22h  LIKE ccg_file.ccg22h            #No.FUN-7C0101
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     CALL cl_outnam('axcr200') RETURNING l_name
     START REPORT axcr200_rep TO l_name
     LET g_pageno = 0
   #str MOD-870121 mod
   # #-->取 ccg_file
   ##LET l_sql = "SELECT sfb01,sfb05,ccg20,0,0,ccg22b,ccg22c",                                  #No.FUN-7C0101
   # LET l_sql = "SELECT sfb01,sfb05,ccg07,ccg20,0,0,ccg22b,ccg22c,ccg22e,ccg22f,ccg22g,ccg22h",#No.FUN-7C0101
   #             "  FROM sfb_file, ccg_file ",
   #             " WHERE ",tm.wc CLIPPED,
   #             "   AND sfb01=ccg01 ", 
   #             "   AND ccg02=", tm.yy CLIPPED, # MOD-590295
   #             "   AND ccg03=", tm.mm CLIPPED, # MOD-590295 將  mark 取消
   ##            "   AND (ccg20!=0 OR ccg22b!=0 OR ccg22c!=0)"                                  #No.FUN-7C0101
   #             "   AND (ccg20!=0 OR ccg22b!=0 OR ccg22c!=0 OR ccg22e!=0 OR ccg22f!=0 OR ccg22g!=0 OR ccg22h!=0)",#No.FUN-7C0101
   #             "   AND ccg06='",tm.type,"'"                                                   #No.FUN-7C0101
     #-->改取cch_file,抓DL+OH+SUB金額
     LET l_sql = "SELECT sfb01,sfb05,cch07,cch21,0,0,cch22b,cch22c,cch22e,cch22f,cch22g,cch22h",
                 "  FROM sfb_file, cch_file ",
                 " WHERE ",tm.wc CLIPPED,
                 "   AND sfb01=cch01 AND cch04=' DL+OH+SUB' ",
                 "   AND cch02=", tm.yy CLIPPED, # MOD-590295
                 "   AND cch03=", tm.mm CLIPPED, # MOD-590295 將 mark 取消
                 "   AND (cch21!=0 OR cch22b!=0 OR cch22c!=0 OR cch22e!=0 OR cch22f!=0 OR cch22g!=0 OR cch22h!=0)",
                 "   AND cch06='",tm.type,"'"
   #end MOD-870121 mod
     CASE     
       WHEN tm.n = '1'  LET l_sql = l_sql clipped," AND sfb99 !='Y' "
       WHEN tm.n = '2'  LET l_sql = l_sql clipped," AND sfb99  ='Y' "
       OTHERWISE EXIT CASE 
     END CASE
 
     PREPARE axcr200_prepare1 FROM l_sql
     DECLARE axcr200_curs1 CURSOR FOR axcr200_prepare1
     FOREACH axcr200_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach1:',STATUS,1) EXIT FOREACH END IF
       OUTPUT TO REPORT axcr200_rep(sr.*)
     END FOREACH
 
     #-->取 cck_file
     #FUN-570240  --begin
     CALL s_azn01(tm.yy,tm.mm) RETURNING bdate,edate
#    LET l_sql = "SELECT sfb01,sfb05,0,ccj05,ccj06,0,0",             #No.FUN-830135
     LET l_sql = "SELECT sfb01,sfb05,'',0,ccj05,ccj06,0,0,0,0,0,0",  #No.FUN-830135
                 "  FROM sfb_file, ccj_file ",
                 " WHERE ",tm.wc CLIPPED," AND sfb01=ccj04",
              #  "   AND YEAR(ccj01)=",tm.yy," AND MONTH(ccj01)=",tm.mm,
                 "   AND ccj01 BETWEEN '",bdate,"' AND '",edate,"'",
                 "   AND ccj05!=0"
     #FUN-570240  --end
     CASE     
       WHEN tm.n = '1'  LET l_sql = l_sql clipped," AND sfb99 !='Y' "
       WHEN tm.n = '2'  LET l_sql = l_sql clipped," AND sfb99  ='Y' "
       OTHERWISE EXIT CASE 
     END CASE
 
     PREPARE axcr200_prepare2 FROM l_sql
     DECLARE axcr200_curs2 CURSOR FOR axcr200_prepare2
     FOREACH axcr200_curs2 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach2:',STATUS,1) EXIT FOREACH END IF
       OUTPUT TO REPORT axcr200_rep(sr.*)
     END FOREACH
 
     FINISH REPORT axcr200_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
#No.8741
REPORT axcr200_rep(sr)
   DEFINE u_p        LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6) #TQC-840066
          amt        LIKE type_file.num20_6         #No.FUN-680122 DECIMAL(20,6)
   DEFINE l_ima02  LIKE ima_file.ima02   #FUN-4C0099
   DEFINE l_ima021  LIKE ima_file.ima021   #FUN-4C0099
   DEFINE l_last_sw    LIKE type_file.chr1,           #No.FUN-680122CHAR(1),
       sr            RECORD sfb01   LIKE sfb_file.sfb01,
                               sfb05   LIKE sfb_file.sfb05,
                               ccg07   LIKE ccg_file.ccg07,           #No.FUN-7C0101
                               ccg20   LIKE ccg_file.ccg20,
                               ccj05   LIKE ccj_file.ccj05,           #No.FUN-680122DEC(15,3)
                               ccj06   LIKE ccj_file.ccj06,           #No.FUN-680122DEC(15,3)
                               ccg22b  LIKE ccg_file.ccg22b,          #No.FUN-680122DEC(15,3)
                               ccg22c  LIKE ccg_file.ccg22c           #No.FUN-680122DEC(15,3)
                              ,ccg22e  LIKE ccg_file.ccg22e,          #No.FUN-7C0101
                               ccg22f  LIKE ccg_file.ccg22f,          #No.FUN-7C0101
                               ccg22g  LIKE ccg_file.ccg22g,          #No.FUN-7C0101
                               ccg22h  LIKE ccg_file.ccg22h          #No.FUN-7C0101
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.sfb01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      LET g_msg=NULL
      IF tm.n='1' THEN LET g_msg=g_x[12] END IF
      IF tm.n='2' THEN LET g_msg=g_x[13] END IF
      PRINT g_x[10] CLIPPED,tm.yy USING '&&&&','  ',
            g_x[11] CLIPPED,tm.mm USING '&&',' ',g_msg CLIPPED
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
           ,g_x[41],g_x[42],g_x[43],g_x[44],g_x[45]                      #No.FUN-7C0101
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   #No.9804
   AFTER GROUP OF sr.sfb01
      SELECT ima02,ima021
        INTO l_ima02,l_ima021
        FROM ima_file
       WHERE ima01=sr.sfb05
      IF SQLCA.sqlcode THEN
          LET l_ima02 = NULL
          LET l_ima021 = NULL
      END IF
      
      PRINT COLUMN g_c[31],sr.sfb01,
            COLUMN g_c[32],sr.sfb05,
            COLUMN g_c[33],l_ima02, 
            COLUMN g_c[34],l_ima021,
           #No.FUN-7C0101
            COLUMN g_c[35],sr.ccg07, 
           #COLUMN g_c[35],cl_numfor(GROUP SUM(sr.ccj06),35,g_ccz.ccz27), #CHI-690007 0->ccz27
            COLUMN g_c[36],cl_numfor(GROUP SUM(sr.ccj06),36,g_ccz.ccz27),
           #COLUMN g_c[36],cl_numfor(GROUP SUM(sr.ccg20),36,2) ,
            COLUMN g_c[37],cl_numfor(GROUP SUM(sr.ccg20),37,2) ,
           #COLUMN g_c[37],cl_numfor(GROUP SUM(sr.ccg22b),37,g_azi03),    #FUN-570190
            COLUMN g_c[38],cl_numfor(GROUP SUM(sr.ccg22b),38,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[38],cl_numfor(GROUP SUM(sr.ccg22c),38,g_azi03),    #FUN-570190
            COLUMN g_c[39],cl_numfor(GROUP SUM(sr.ccg22c),39,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[40],cl_numfor(GROUP SUM(sr.ccg22e),40,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[41],cl_numfor(GROUP SUM(sr.ccg22f),41,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[42],cl_numfor(GROUP SUM(sr.ccg22g),42,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[43],cl_numfor(GROUP SUM(sr.ccg22h),43,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[39],cl_numfor(GROUP SUM(sr.ccj05),39,2),
            COLUMN g_c[44],cl_numfor(GROUP SUM(sr.ccj05),44,2),
           #COLUMN g_c[40],cl_numfor(GROUP SUM(sr.ccg20-sr.ccj05),40,2)
            COLUMN g_c[45],cl_numfor(GROUP SUM(sr.ccg20-sr.ccj05),45,2)
           #No.FUN-7C0101 --End
   ON LAST ROW
      PRINT g_dash2
           #No.FUN-7C0101 --Begin
    # PRINT COLUMN g_c[34],g_x[9] CLIPPED,
      PRINT COLUMN g_c[35],g_x[9] CLIPPED,
           #COLUMN g_c[35],cl_numfor(SUM(sr.ccj06),35,g_ccz.ccz27), #CHI-690007 0->ccz27
            COLUMN g_c[36],cl_numfor(SUM(sr.ccj06),36,g_ccz.ccz27),
           #COLUMN g_c[36],cl_numfor(SUM(sr.ccg20),36,2),
            COLUMN g_c[37],cl_numfor(SUM(sr.ccg20),37,2),
           #COLUMN g_c[37],cl_numfor(SUM(sr.ccg22b),37,g_azi03),    #FUN-570190
            COLUMN g_c[38],cl_numfor(SUM(sr.ccg22b),38,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[38],cl_numfor(SUM(sr.ccg22c),38,g_azi03),    #FUN-570190
            COLUMN g_c[39],cl_numfor(SUM(sr.ccg22c),39,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[40],cl_numfor(SUM(sr.ccg22e),40,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[41],cl_numfor(SUM(sr.ccg22f),41,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[42],cl_numfor(SUM(sr.ccg22g),42,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[43],cl_numfor(SUM(sr.ccg22h),43,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[39],cl_numfor(SUM(sr.ccj05),39,2)  ,
            COLUMN g_c[44],cl_numfor(SUM(sr.ccj05),44,2)  ,
           #COLUMN g_c[40],cl_numfor(SUM(sr.ccg20-sr.ccj05),40,2)
            COLUMN g_c[45],cl_numfor(SUM(sr.ccg20-sr.ccj05),45,2)
           #No.FUN-7C0101 --End
      LET l_last_sw = 'y'
   #No.9804(end)
 
   PAGE TRAILER
      PRINT g_dash
      IF l_last_sw = 'n'
         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      END IF
#No.8741(END)
END REPORT
 
