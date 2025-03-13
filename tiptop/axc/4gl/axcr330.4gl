# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: axcr330.4gl
# Descriptions...: 重工前後成本差異表
# Input parameter: 
# Return code....: 
# Date & Author..: 98/08/14 By Star
# Modify.........: No.FUN-4C0099 04/12/30 By kim 報表轉XML功能
# Modify.........: No.MOD-530181 05/03/23 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: NO.FUN-5B0105 05/12/27 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610051 06/02/23 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680122 06/09/01 By zdyllq 類型轉換 
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-7C0101 08/01/30 By douzh 成本改善功能增加成本計算類型(type)
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-A70106 10/07/22 By yinhy DEFINE段LIKE語法sda_file.sda13改為eca_file.eca08
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                    # Print condition RECORD
              wc      STRING,           # Where condition #TQC-630166
              s_y     LIKE type_file.num10,         #No.FUN-680122 INTEGER       # Year
              s_m     LIKE type_file.num5,          #No.FUN-680122 SMALLINT      # Month
              s_amt   LIKE oeb_file.oeb13,          #No.FUN-680122 DECIMAL(20,6)
              s_rat   LIKE oeb_file.oeb13,          #No.FUN-680122 DEC(20,6)
              type    LIKE type_file.chr1,          #No.FUN-7C0101 
              n       LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)       # Print detail ?
              s       LIKE type_file.chr3,          #No.FUN-680122 VARCHAR(3)       # Order by sequence
              t       LIKE type_file.chr3,          #No.FUN-680122 VARCHAR(3)       # Eject sw
              u       LIKE type_file.chr3,          #No.FUN-680122 VARCHAR(3)       # Group total sw
              more    LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)       # Input more condition(Y/N)
              END RECORD,
          last_yy,last_mm   LIKE type_file.num5,           #No.FUN-680122SMALLINT
          g_wc   string,                      #For apa  #No.FUN-580092 HCN
          g_wc1  string,                      #For ale  #No.FUN-580092 HCN
          m_flag LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
DEFINE   g_i     LIKE type_file.num5          #count/index for any purpose        #No.FUN-680122 SMALLINT
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
   LET tm.s_y = ARG_VAL(8)
   LET tm.s_m = ARG_VAL(9)
   #LET tm.n  = ARG_VAL(10)    #TQC-610051 
   LET tm.s_amt = ARG_VAL(10)  #TQC-610051
   LET tm.type = ARG_VAL(17)   #No.FUN-7C0101
   LET tm.s  = ARG_VAL(11)
   LET tm.t  = ARG_VAL(12)
   #LET tm.u  = ARG_VAL(13)    #TQC-610051    
   LET tm.s_rat = ARG_VAL(13)  #TQC-610051
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axcr330_tm(0,0)        # Input print condition
      ELSE CALL axcr330()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr330_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 11 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20 
   ELSE LET p_row = 3 LET p_col = 11
   END IF
   OPEN WINDOW axcr330_w AT p_row,p_col
        WITH FORM "axc/42f/axcr330" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s_y=g_ccz.ccz01
   LET tm.s_m=g_ccz.ccz02
   LET tm.s_amt= 0
   LET tm.s_rat= 0
   LET tm.type=g_ccz.ccz28            #No.FUN-7C0101
   LET tm.n    ='1'
   LET tm.s    = '123'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima01,ima57 
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr330_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
 
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
 
   DISPLAY BY NAME tm.s_y,tm.s_m,tm.s_amt,tm.s_rat,tm.type,    #No.FUN-7C0101
                   tm.s,tm.t,tm.more  
   INPUT BY NAME tm.s_y,tm.s_m,tm.s_amt,tm.s_rat,tm.type,      #No.FUN-7C0101
                 tm2.s1,tm2.s2,
                 tm2.t1,tm2.t2,
                 tm.more WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD s_y
         IF tm.s_y IS NULL THEN
            LET tm.s_y = g_sma.sma51
            DISPLAY tm.s_y TO s_y
         END IF
 
      AFTER FIELD s_m
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.s_m) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.s_y
            IF g_azm.azm02 = 1 THEN
               IF tm.s_m > 12 OR tm.s_m < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD s_m
               END IF
            ELSE
               IF tm.s_m > 13 OR tm.s_m < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD s_m
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
         IF tm.s_m IS NULL THEN
            LET tm.s_m = g_sma.sma52
            DISPLAY tm.s_m TO s_m  
         END IF
#No.TQC-720032 -- begin --
#         IF tm.s_m > 13  THEN
#            CALL cl_err(tm.s_m,'mfg9071',0)
#         END IF
#No.TQC-720032 -- begin --
 
       AFTER FIELD type                                                            #No.FUN-7C0101
         IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF              #No.FUN-7C0101
 
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
      AFTER INPUT  
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
         LET tm.t = tm2.t1[1,1],tm2.t2[1,1]
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr330_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr330'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr330','9031',1)   
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
                         " '",tm.s_y CLIPPED,"'",
                         " '",tm.s_m CLIPPED,"'",
                         " '",tm.s_amt CLIPPED,"'",
                         #" '",tm.s_rat CLIPPED,"'",            #TQC-610051
                         " '",tm.type CLIPPED,"'",              #No.FUN-7C0101
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.s_rat CLIPPED,"'",             #TQC-610051
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axcr330',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr330_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr330()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr330_w
END FUNCTION
 
FUNCTION axcr330()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(20)      # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680122CHAR(1500)
          l_chr        LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_flag    LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40)
          l_order    ARRAY[5] OF LIKE type_file.chr1000,       #No.FUN-680122CHAR(40) #FUN-5B0105 12->40
          l_ccg   RECORD LIKE ccg_file.*,
          l_ccc   RECORD LIKE ccc_file.*,
          sr               RECORD order1 LIKE type_file.chr1000,       #No.FUN-680122CHAR(40) #FUN-5B0105 12->40
                                  order2 LIKE type_file.chr1000,       #No.FUN-680122CHAR(40) #FUN-5B0105 12->40
                                  ima01  LIKE ima_file.ima01,
                                  ima02  LIKE ima_file.ima02,
                                  ima021 LIKE ima_file.ima021,
                                  ccc08  LIKE ccc_file.ccc08,          #No.FUN-7C0101
                                  ima57  LIKE ima_file.ima57,
                                  ima100 LIKE ima_file.ima100,
                                  A_price  LIKE oeb_file.oeb13,        #No.FUN-680122DEC(20,6)
                                  B_price  LIKE oeb_file.oeb13,        #No.FUN-680122DEC(20,6)
                                  C_price  LIKE oeb_file.oeb13,        #No.FUN-680122DEC(20,6)
                                  D_price  LIKE oeb_file.oeb13,        #No.FUN-680122DEC(20,6)
                                  A_priceX LIKE oeb_file.oeb13,        #No.FUN-680122DEC(20,6)
                                  B_priceX LIKE oeb_file.oeb13,        #No.FUN-680122DEC(20,6)
                                  C_priceX LIKE oeb_file.oeb13,        #No.FUN-680122DEC(20,6)
                                  D_priceX LIKE oeb_file.oeb13,        #No.FUN-680122DEC(20,6)
                                  Diff_price LIKE oeb_file.oeb13,      #No.FUN-680122DEC(20,6)
                                  #Diff_r     LIKE sda_file.sda13,      #No.FUN-680122DEC( 5,2)   #mark by No.TQC-A70106
                                  Diff_r     LIKE eca_file.eca08,      #No.TQC-A70106DEC(8,4)
                                  WoNo     LIKE sfb_file.sfb01
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT '','',ima01,ima02,ima021,ccc08,ima57,ima100,0,0,0,0,0,0,0,0,0,0,' ', ",      #No.FUN-7C0101
                 "       ccg_file.*,ccc_file.* ",
                 "  FROM ccc_file,ima_file,ccg_file,sfb_file ",
                 " WHERE ccc01 = ima01 ",
                 "   AND ccc02 = ",tm.s_y,
                 "   AND ccc03 = ",tm.s_m,
                 "   AND ccc07 = '",tm.type,"'",                                                      #No.FUN-7C0101
                 "   AND ccc01 = ccg04 AND ccc02 = ccg02 AND ccc03 = ccg03 ",
                 "   AND ccc07 = ccg06 AND ccc08 = ccg07 ",                                           #No.FUN-7C0101
                 "   AND ccg01 = sfb01 AND sfb99 = 'Y' ",
                 "   AND ccg31 != 0 AND ccg32 != 0 ",
                 "   AND ",tm.wc clipped
 
     PREPARE axcr330_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
       EXIT PROGRAM    
          
     END IF
     DECLARE axcr330_curs1 CURSOR FOR axcr330_prepare1
 
     CALL cl_outnam('axcr330') RETURNING l_name
 
#No.FUN-7C0101--begin
     IF tm.type MATCHES '[12]' THEN
        LET g_zaa[34].zaa06 = "Y" 
     ELSE
        LET g_zaa[34].zaa06 = "N"
     END IF
     CALL cl_prt_pos_len()
#No.FUN-7C0101--end
 
     START REPORT axcr330_rep TO l_name
 
     LET g_pageno = 0
     FOREACH axcr330_curs1 INTO sr.*,l_ccg.*,l_ccc.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH 
       END IF
       #重工前單價 
       IF l_ccc.ccc11+l_ccc.ccc21 = 0 THEN 
          LET sr.A_price = 0
          LET sr.B_price = 0
          LET sr.C_price = 0
          LET sr.D_price = 0
          #重工前單價 ... 本期無單價時, 改取上期 
          SELECT ccc23a,ccc23b,ccc23c+ccc23d+ccc23e+ccc23f+ccc23g+ccc23h,ccc23        #No.FUN-7C0101
            INTO sr.A_price,sr.B_price,sr.C_price,sr.D_price
            FROM ccc_file 
           WHERE ccc01 = l_ccc.ccc01 AND ccc02 = last_yy AND ccc03 = last_mm
             AND ccc07 = l_ccc.ccc07 AND ccc08 = l_ccc.ccc08                          #No.FUN-7C0101
          IF sr.A_price IS NULL THEN LET sr.A_price = 0 END IF 
          IF sr.B_price IS NULL THEN LET sr.B_price = 0 END IF 
          IF sr.C_price IS NULL THEN LET sr.C_price = 0 END IF 
          IF sr.D_price IS NULL THEN LET sr.D_price = 0 END IF 
          #重工前單價 ... 上期無單價時, 改取上期調整 
          IF SQLCA.sqlcode OR 
          (sr.A_price = 0 AND sr.B_price = 0 AND sr.C_price = 0
           AND sr.D_price = 0 ) THEN
             SELECT cca23a,cca23b,(cca23c+cca23d+cca23e+cca23f+cca23g+cca23h),cca23          #No.FUN-7C0101
               INTO sr.A_price,sr.B_price,sr.C_price,sr.D_price
               FROM cca_file
              WHERE cca01=l_ccc.ccc01 AND cca02=last_yy AND cca03=last_mm
                AND cca06=l_ccc.ccc07 AND cca07=l_ccc.ccc08                                  #No.FUN-7C0101
          END IF 
       ELSE 
          LET sr.A_price =(l_ccc.ccc12a+l_ccc.ccc22a)
                        /(l_ccc.ccc11+l_ccc.ccc21)
          LET sr.B_price =(l_ccc.ccc12b+l_ccc.ccc22b)
                        /(l_ccc.ccc11+l_ccc.ccc21)
          LET sr.C_price =(l_ccc.ccc12c+l_ccc.ccc22c)
                        +(l_ccc.ccc12d+l_ccc.ccc22d)
                        +(l_ccc.ccc12e+l_ccc.ccc22e)
                        +(l_ccc.ccc12f+l_ccc.ccc22f)                                         #No.FUN-7C0101
                        +(l_ccc.ccc12g+l_ccc.ccc22g)                                         #No.FUN-7C0101
                        +(l_ccc.ccc12h+l_ccc.ccc22h)                                         #No.FUN-7C0101
                        /(l_ccc.ccc11+l_ccc.ccc21)
          LET sr.D_price =(l_ccc.ccc12+l_ccc.ccc22)/(l_ccc.ccc11+l_ccc.ccc21)
       END IF 
       IF sr.A_price IS NULL THEN LET sr.A_price = 0 END IF 
       IF sr.B_price IS NULL THEN LET sr.B_price = 0 END IF 
       IF sr.C_price IS NULL THEN LET sr.C_price = 0 END IF 
       IF sr.D_price IS NULL THEN LET sr.D_price = 0 END IF 
 
       # 重工後單價 
         # 不會有分母為零, 前面已擋掉
       LET sr.A_priceX = l_ccg.ccg32a / l_ccg.ccg31
       LET sr.B_priceX = l_ccg.ccg32b / l_ccg.ccg31
       LET sr.C_priceX = (l_ccg.ccg32c+l_ccg.ccg32d+l_ccg.ccg32e+l_ccg.ccg32f+l_ccg.ccg32g+l_ccg.ccg32h)/l_ccg.ccg31  #No.FUN-7C0101
       LET sr.D_priceX = l_ccg.ccg32  / l_ccg.ccg31
       LET sr.Diff_price = sr.D_priceX - sr.D_price
       IF sr.D_price = 0 THEN 
          LET sr.Diff_r = 100
       ELSE 
          LET sr.Diff_r = sr.Diff_price / sr.D_price
       END IF 
       IF ABX(sr.Diff_price) <= tm.s_amt THEN CONTINUE FOREACH END IF 
       IF ABX(sr.Diff_r)     <= tm.s_rat THEN CONTINUE FOREACH END IF 
 
       FOR g_i = 1 TO 2
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ima01
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ima57
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.WoNo = l_ccg.ccg01
       OUTPUT TO REPORT axcr330_rep(sr.*)
     END FOREACH
 
     FINISH REPORT axcr330_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT axcr330_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680122CHAR(1)
          l_flag       LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          sr               RECORD order1 LIKE type_file.chr1000,       #No.FUN-680122CHAR(40) #FUN-5B0105 12->40
                                  order2 LIKE type_file.chr1000,       #No.FUN-680122CHAR(40) #FUN-5B0105 12->40
                                  ima01  LIKE ima_file.ima01,
                                  ima02  LIKE ima_file.ima02,
                                  ima021  LIKE ima_file.ima021,
                                  ccc08  LIKE ccc_file.ccc08,          #No.FUN-7C0101
                                  ima57  LIKE ima_file.ima57,
                                  ima100  LIKE ima_file.ima100,
                                  A_price  LIKE oeb_file.oeb13,        #No.FUN-680122DEC(20,6)
                                  B_price  LIKE oeb_file.oeb13,        #No.FUN-680122DEC(20,6)
                                  C_price  LIKE oeb_file.oeb13,        #No.FUN-680122DEC(20,6)
                                  D_price  LIKE oeb_file.oeb13,        #No.FUN-680122DEC(20,6)
                                  A_priceX LIKE oeb_file.oeb13,        #No.FUN-680122DEC(20,6)
                                  B_priceX LIKE oeb_file.oeb13,        #No.FUN-680122DEC(20,6)
                                  C_priceX LIKE oeb_file.oeb13,        #No.FUN-680122DEC(20,6)
                                  D_priceX LIKE oeb_file.oeb13,        #No.FUN-680122DEC(20,6)
                                  Diff_price LIKE oeb_file.oeb13,      #No.FUN-680122DEC(20,6)
                                  #Diff_r     LIKE sda_file.sda13,      #No.FUN-680122DEC( 5,2)  #mark by No.TQC-A70106
                                  Diff_r     LIKE eca_file.eca08,      #No.TQC-A70106DEC(8,2)
                                  WoNo     LIKE sfb_file.sfb01
                        END RECORD,
      l_chr        LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.ima01,sr.WoNo
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT 
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],                     #No.FUN-7C0101
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],                     #No.FUN-7C0101
            g_x[41],g_x[42],g_x[43],g_x[44],g_x[45]                      #No.FUN-7C0101 
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' 
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' 
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.ima01
      LET l_flag = 'N'
      PRINT COLUMN g_c[31],sr.ima01,
            COLUMN g_c[32],sr.ima02,
            COLUMN g_c[33],sr.ima021, 
            COLUMN g_c[34],sr.ccc08,                                     #No.FUN-7C0101
            COLUMN g_c[35],cl_numfor(sr.A_price,35,g_ccz.ccz26),  #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[36],cl_numfor(sr.B_price,36,g_ccz.ccz26),  #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[37],cl_numfor(sr.C_price,37,g_ccz.ccz26),  #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[38],cl_numfor(sr.D_price,38,g_ccz.ccz26);  #CHI-C30012 g_azi03->g_ccz.ccz26
 
   ON EVERY ROW
      PRINT COLUMN g_c[39],sr.WoNo,
            COLUMN g_c[40],cl_numfor(sr.A_priceX,40,g_ccz.ccz26),  #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[41],cl_numfor(sr.B_priceX,41,g_ccz.ccz26),  #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[42],cl_numfor(sr.C_priceX,42,g_ccz.ccz26),  #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[43],cl_numfor(sr.D_priceX,43,g_ccz.ccz26),  #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[44],cl_numfor(sr.Diff_price,44,g_ccz.ccz26),  #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[45],cl_numfor(sr.Diff_r,45,2),'%'
      IF l_flag = 'N' THEN PRINT COLUMN g_c[31],sr.ima100; LET l_flag = 'Y' END IF 
 
   AFTER GROUP OF sr.ima01
      IF l_flag = 'Y' THEN PRINT ' ' END IF 
 
   ON LAST ROW  
      PRINT g_dash
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'ima01,apa44,rvu04')
              RETURNING tm.wc
         PRINT g_dash2
            #TQC-630166 Start
            #  IF tm.wc[001,80] > ' ' THEN     
         #PRINT g_x[8] CLIPPED,tm.wc[001,80] CLIPPED END IF
 
             CALL cl_prt_pos_wc(tm.wc)
            #TQC-630166 End
 
      END IF
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
 
FUNCTION r330_get_date()
   DEFINE l_correct    LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
   IF tm.s_m = 1
      THEN IF g_aza.aza02 = '1'
              THEN LET last_mm = 12 LET last_yy = tm.s_y - 1
              ELSE LET last_mm = 13 LET last_yy = tm.s_y - 1
           END IF
      ELSE LET last_mm = tm.s_m - 1 LET last_yy = tm.s_y
   END IF
END FUNCTION
 
FUNCTION ABX(l_amt)
DEFINE l_amt LIKE oeb_file.oeb13         #No.FUN-680122 DECIMAL(20,6)
    IF l_amt < 0 THEN LET l_amt = l_amt * -1 END IF 
    RETURN l_amt 
END FUNCTION
