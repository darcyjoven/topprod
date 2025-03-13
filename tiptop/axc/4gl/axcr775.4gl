# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: axcr775.4gl
# Descriptions...: 拆件工單匯總表(axcr775)
# Input parameter: 
# Return code....: 
# Date & Author..: 99/03/11 By Apple 
# Modify.........: No.FUN-4C0099 05/01/04 By kim 報表轉XML功能
# Modify.........: No.FUN-570190 05/08/02 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.MOD-560146 05/08/17 by zhangmin 客制轉標准,增加期初余額，差異轉出，期末結存數據。
# Modify.........: No.FUN-670042 06/08/08 By Sarah 增加列印"其他"欄位
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 07/01/03 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.MOD-720042 07/02/06 By TSD.Sora 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/04/02 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.FUN-7C0101 08/01/31 By Cockroach 增加成本計算類型type和打印字段增加
# Modify.........: No.MOD-860158 08/09/27 By liuxqa 修改sql條件
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A40139 10/04/29 By Carrier SQL STANDARDIZE
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE tm  RECORD                  # Print condition RECORD
            wc      LIKE type_file.chr1000,        #No.FUN-680122CHAR(300)      # Where condition
            yy      LIKE type_file.num5,           #No.FUN-680122SMALLINT
            mm      LIKE type_file.num5,           #No.FUN-680122SMALLINT
            type    LIKE type_file.chr1,           #No.FUN-7C0101 ADD 成本計算類型   
            more    LIKE type_file.chr1            #No.FUN-680122CHAR(1)         # Input more condition(Y/N)
           END RECORD,
   #No.MOD-560146 --start--
   l_totccu21,l_sumccu31,l_sumccu11,l_sumccu41,l_sumccu91  LIKE ccu_file.ccu21,
   l_tot2ccu21,l_sum2ccu31,l_sum2ccu11,l_sum2ccu41,l_sum2ccu91  LIKE ccu_file.ccu21, 
   l_totccu22a,l_sumccu32a,l_sumccu12a,l_sumccu42a,l_sumccu92a   LIKE ccu_file.ccu22a,
   l_totccu22b,l_sumccu32b,l_sumccu12b,l_sumccu42b,l_sumccu92b   LIKE ccu_file.ccu22b,
   l_totccu22c,l_sumccu32c,l_sumccu12c,l_sumccu42c,l_sumccu92c   LIKE ccu_file.ccu22c,
   l_totccu22d,l_sumccu32d,l_sumccu12d,l_sumccu42d,l_sumccu92d   LIKE ccu_file.ccu22d,
   l_totccu22e,l_sumccu32e,l_sumccu12e,l_sumccu42e,l_sumccu92e   LIKE ccu_file.ccu22e,       #FUN-670042 add
   l_totccu22f,l_sumccu32f,l_sumccu12f,l_sumccu42f,l_sumccu92f   LIKE ccu_file.ccu22f,   #FUN-7C0101 ADD
   l_totccu22g,l_sumccu32g,l_sumccu12g,l_sumccu42g,l_sumccu92g   LIKE ccu_file.ccu22g,   #FUN-7C0101 ADD
   l_totccu22h,l_sumccu32h,l_sumccu12h,l_sumccu42h,l_sumccu92h   LIKE ccu_file.ccu22h,   #FUN-7C0101 ADD
   l_tot2ccu22a,l_sum2ccu32a,l_sum2ccu12a,l_sum2ccu42a,l_sum2ccu92a  LIKE ccu_file.ccu22a,
   l_tot2ccu22b,l_sum2ccu32b,l_sum2ccu12b,l_sum2ccu42b,l_sum2ccu92b  LIKE ccu_file.ccu22b,
   l_tot2ccu22c,l_sum2ccu32c,l_sum2ccu12c,l_sum2ccu42c,l_sum2ccu92c  LIKE ccu_file.ccu22c,
   l_tot2ccu22d,l_sum2ccu32d,l_sum2ccu12d,l_sum2ccu42d,l_sum2ccu92d  LIKE ccu_file.ccu22d,
   l_tot2ccu22e,l_sum2ccu32e,l_sum2ccu12e,l_sum2ccu42e,l_sum2ccu92e  LIKE ccu_file.ccu22e,   #FUN-670042 add
   l_tot2ccu22f,l_sum2ccu32f,l_sum2ccu12f,l_sum2ccu42f,l_sum2ccu92f  LIKE ccu_file.ccu22f,  #FUN-7C0101ADD
   l_tot2ccu22g,l_sum2ccu32g,l_sum2ccu12g,l_sum2ccu42g,l_sum2ccu92g  LIKE ccu_file.ccu22g,  #FUN-7C0101 ADD
   l_tot2ccu22h,l_sum2ccu32h,l_sum2ccu12h,l_sum2ccu42h,l_sum2ccu92h  LIKE ccu_file.ccu22h,  #FUN-7C0101 ADD
   #No.MOD-560146 --end--
       g_yy,g_mm       LIKE type_file.num5,           #No.FUN-680122SMALLINT
       l_flag          LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
       g_bdate,g_edate LIKE type_file.dat            #No.FUN-680122DATE
DEFINE g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680122 SMALLINT
#MOD-720042 BY TSD.Sora---start---
  DEFINE l_table     STRING
  DEFINE g_sql       STRING
  DEFINE g_str       STRING
#MOD-720042 BY TSD.Sora---end---
 
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                    # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
 
   #MOD-720042 BY TSD.Sora---start---
   LET g_sql = "type.type_file.num5,",
               "ima09.ima_file.ima09,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ccu01.ccu_file.ccu01,",
               "ccu04.ccu_file.ccu04,",
               "ccu07.ccu_file.ccu07,",      #FUN-7C0101 ADD
               "ccu21.ccu_file.ccu21,",
               "ccu22a.ccu_file.ccu22a,",
               "ccu22b.ccu_file.ccu22b,",
               "ccu22c.ccu_file.ccu22c,",
               "ccu22d.ccu_file.ccu22d,",
               "ccu22e.ccu_file.ccu22e,",
               "ccu22f.ccu_file.ccu22f,",   #FUN-7C0101 ADD   
               "ccu22g.ccu_file.ccu22g,",   #FUN-7C0101 ADD   
               "ccu22h.ccu_file.ccu22h,",   #FUN-7C0101 ADD   
               "ccu31.ccu_file.ccu31,",
               "ccu32a.ccu_file.ccu32a,",
               "ccu32b.ccu_file.ccu32b,",
               "ccu32c.ccu_file.ccu32c,",
               "ccu32d.ccu_file.ccu32d,",
               "ccu32e.ccu_file.ccu32e,",
               "ccu32f.ccu_file.ccu32f,",   #FUN-7C0101 ADD                                                                         
               "ccu32g.ccu_file.ccu32g,",   #FUN-7C0101 ADD                                                                         
               "ccu32h.ccu_file.ccu32h,",   #FUN-7C0101 ADD          
               "ccu11.ccu_file.ccu11,",
               "ccu12a.ccu_file.ccu12a,",
               "ccu12b.ccu_file.ccu12b,",
               "ccu12c.ccu_file.ccu12c,",
               "ccu12d.ccu_file.ccu12d,",
               "ccu12e.ccu_file.ccu12e,",
               "ccu12f.ccu_file.ccu12f,",   #FUN-7C0101 ADD                                                                         
               "ccu12g.ccu_file.ccu12g,",   #FUN-7C0101 ADD                                                                         
               "ccu12h.ccu_file.ccu12h,",   #FUN-7C0101 ADD          
               "ccu41.ccu_file.ccu41,",
               "ccu42a.ccu_file.ccu42a,",
               "ccu42b.ccu_file.ccu42b,",
               "ccu42c.ccu_file.ccu42c,",
               "ccu42d.ccu_file.ccu42d,",
               "ccu42e.ccu_file.ccu42e,",
               "ccu42f.ccu_file.ccu42f,",   #FUN-7C0101 ADD                                                                         
               "ccu42g.ccu_file.ccu42g,",   #FUN-7C0101 ADD                                                                         
               "ccu42h.ccu_file.ccu42h,",   #FUN-7C0101 ADD          
               "ccu91.ccu_file.ccu91,",
               "ccu92a.ccu_file.ccu92a,",
               "ccu92b.ccu_file.ccu92b,",
               "ccu92c.ccu_file.ccu92c,",
               "ccu92d.ccu_file.ccu92d,",
               "ccu92e.ccu_file.ccu92e,",
               "ccu92f.ccu_file.ccu92f,",   #FUN-7C0101 ADD                                                                         
               "ccu92g.ccu_file.ccu92g,",   #FUN-7C0101 ADD                                                                         
               "ccu92h.ccu_file.ccu92h,",   #FUN-7C0101 ADD          
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",
               "ccz27.ccz_file.ccz27"
 
   LET l_table = cl_prt_temptable('axcr775',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",   #FUN-7C0101 ADD 16 ?
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ? )"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
                
   #MOD-720042 BY TSD.Sora---end---
 
   INITIALIZE tm.* TO NULL           # Default condition
   LET tm.more = 'N'
   LET g_pdate = ARG_VAL(1)
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.yy = ARG_VAL(8)
   LET tm.mm = ARG_VAL(9)
   LET tm.type= ARG_VAL(13)   #FUN-7C0101 ADD
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL axcr775_tm(0,0)
   ELSE 
      CALL axcr775()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr775_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
       l_cmd          LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 6 LET p_col = 20
   ELSE
      LET p_row = 5 LET p_col = 12
   END IF
   OPEN WINDOW axcr775_w AT p_row,p_col
        WITH FORM "axc/42f/axcr775" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.yy  = g_ccz.ccz01
   LET tm.mm  = g_ccz.ccz02
   LET tm.type= g_ccz.ccz28     #FUN-7C0101 ADD
   LET tm.more= 'N'
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON ima09,ccu01  
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
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
         LET INT_FLAG = 0 
         CLOSE WINDOW axcr775_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM
      END IF
 
      IF tm.wc=' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
      INPUT BY NAME tm.yy,tm.mm,tm.type,tm.more   #FUN-7C0101 ADD tm.type
         WITHOUT DEFAULTS 
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD yy
           IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
 
         AFTER FIELD mm
           IF cl_null(tm.mm) THEN NEXT FIELD mm END IF
#FUN-7C0101 --START--
         AFTER FIELD type
           IF tm.type IS NULL OR tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF
#FUN-7C0101 --END--
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
         LET INT_FLAG = 0 
         CLOSE WINDOW axcr775_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='axcr775'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('axcr775','9031',1)   
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,          #(at time fglgo xxxx p1 p2 p3)
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
                   " '",tm.type CLIPPED,"'",              #No.FUN-7C0101 ADD
                   " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                   " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                   " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
            CALL cl_cmdat('axcr775',g_time,l_cmd)  # Execute cmd at later time
         END IF
         CLOSE WINDOW axcr775_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL axcr775()
      ERROR ""
   END WHILE
   CLOSE WINDOW axcr775_w
END FUNCTION
 
FUNCTION axcr775()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122CHAR(20)       # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,    # RDSQL STATEMENT        #No.FUN-680122CHAR(1200)
          sr        RECORD 
                     type      LIKE type_file.num5,           #No.FUN-680122SMALLINT
                     ccu       RECORD   LIKE  ccu_file.*,   #工單在制成本檔  
                     ima09     LIKE     ima_file.ima09,     #分群碼     
                     ima02     LIKE     ima_file.ima02,     #品名規格     
                     ima021    LIKE     ima_file.ima021     #規格     
                    END RECORD
    #MOD-720042 BY TSD.Sora---start---
    CALL cl_del_data(l_table)
    #MOD-720042 BY TSD.Sora---end---
 
 
   CALL s_azm(tm.yy,tm.mm) RETURNING l_flag,g_bdate,g_edate
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   #070306 BY TSD.Sora---start---
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axcr775'
   SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
      FROM azi_file WHERE azi01 = g_aza.aza17
   #070306 BY TSD.Sora---end---
 
    #No.MOD-560146 --start--
   LET l_totccu22a = 0    LET l_sumccu32a  =0
   LET l_totccu22b = 0    LET l_sumccu32b  =0
   LET l_totccu22c = 0    LET l_sumccu32c  =0
   LET l_totccu22d = 0    LET l_sumccu32d  =0
   LET l_totccu22e = 0    LET l_sumccu32e  =0   #FUN-670042 add
   LET l_totccu22f = 0    LET l_sumccu32f  =0   #FUN-7C0101 ADD
   LET l_totccu22g = 0    LET l_sumccu32g  =0   #FUN-7C0101 ADD
   LET l_totccu22h = 0    LET l_sumccu32h  =0   #FUN-7C0101 ADD
   LET l_tot2ccu22a= 0    LET l_sum2ccu32a =0  
   LET l_tot2ccu22b= 0    LET l_sum2ccu32b =0
   LET l_tot2ccu22c= 0    LET l_sum2ccu32c =0
   LET l_tot2ccu22d= 0    LET l_sum2ccu32d =0
   LET l_tot2ccu22e= 0    LET l_sum2ccu32e =0   #FUN-670042 add
   LET l_tot2ccu22f= 0    LET l_sum2ccu32f =0   #FUN-7C0101 ADD
   LET l_tot2ccu22g= 0    LET l_sum2ccu32g =0   #FUN-7C0101 ADD
   LET l_tot2ccu22h= 0    LET l_sum2ccu32h =0   #FUN-7C0101 ADD
   LET l_totccu21  = 0    LET l_sumccu31 = 0
   LET l_tot2ccu21 = 0    LET l_sum2ccu31 = 0
   LET l_sumccu42a = 0    LET l_sumccu92a  =0
   LET l_sumccu42b = 0    LET l_sumccu92b  =0
   LET l_sumccu42c = 0    LET l_sumccu92c  =0
   LET l_sumccu42d = 0    LET l_sumccu92d  =0
   LET l_sumccu42e = 0    LET l_sumccu92e  =0   #FUN-670042 add
   LET l_sumccu42f = 0    LET l_sumccu92f  =0   #FUN-7C0101 ADD    
   LET l_sumccu42g = 0    LET l_sumccu92g  =0   #FUN-7C0101 ADD    
   LET l_sumccu42h = 0    LET l_sumccu92h  =0    #FUN-7C0101 ADD    
   LET l_sum2ccu42a= 0    LET l_sum2ccu92a =0  
   LET l_sum2ccu42b= 0    LET l_sum2ccu92b =0
   LET l_sum2ccu42c= 0    LET l_sum2ccu92c =0
   LET l_sum2ccu42d= 0    LET l_sum2ccu92d =0
   LET l_sum2ccu42e= 0    LET l_sum2ccu92e =0   #FUN-670042 add
   LET l_sum2ccu42f= 0    LET l_sum2ccu92f =0   #FUN-7C0101 ADD    
   LET l_sum2ccu42g= 0    LET l_sum2ccu92g =0   #FUN-7C0101 ADD    
   LET l_sum2ccu42h= 0    LET l_sum2ccu92h =0   #FUN-7C0101 ADD    
   LET l_sumccu41  = 0    LET l_sumccu91 = 0
   LET l_sum2ccu41 = 0    LET l_sum2ccu91 = 0
   LET l_sumccu12a = 0    LET l_sumccu12b = 0
   LET l_sumccu12c = 0    LET l_sumccu12d = 0
   LET l_sumccu12e = 0                          #FUN-670042 add
   LET l_sumccu12f = 0    LET l_sumccu12g = 0   #FUN-7C0101 ADD    
   LET l_sumccu12h = 0                          #FUN-7C0101 ADD    
   LET l_sum2ccu12a= 0    LET l_sum2ccu12b= 0
   LET l_sum2ccu12c= 0    LET l_sum2ccu12d= 0
   LET l_sum2ccu12e= 0                          #FUN-670042 add
   LET l_sum2ccu12f= 0    LET l_sum2ccu12g= 0   #FUN-7C0101 ADD    
   LET l_sum2ccu12h= 0                          #FUN-7C0101 ADD
   LET l_sumccu11  = 0    LET l_sum2ccu11 = 0
    #No.MOD-560146 --end--
 
   LET l_sql = "SELECT '',ccu_file.* ,ima09,ima02,ima021 ",
               #No.TQC-A40139  --Begin
            #  "  FROM ccu_file , ima_file ", #No.MOD-860158 modify by liuxqa
            #  "  FROM ccu_file ,ima_file ",  #No.MOD-860158 mark by liuxqa
            #  " WHERE ccu04 = ima01(+) " ,
               "  FROM ccu_file LEFT OUTER JOIN ima_file ON ccu04 = ima01 " ,
               #No.TQC-A40139  --End  
               "   WHERE ccu02 = ", tm.yy ,
               "   AND ccu03 = ", tm.mm ,
               "   AND ccu06 ='",tm.type,"'", #FUN-7C0101 ADD
               "   AND ", tm.wc CLIPPED  
  
   PREPARE axcr775_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM 
   END IF
   DECLARE axcr775_curs1 CURSOR FOR axcr775_prepare1
 
   #MOD-720042 BY TSD.Sora---start---
   #CALL cl_outnam('axcr775') RETURNING l_name
   #START REPORT axcr775_rep TO l_name
   #MOD-720042 BY TSD.Sora---end---
   LET g_pageno = 0
   FOREACH axcr775_curs1 INTO sr.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      #-->投入 
      IF sr.ccu.ccu22a > 0 THEN 
         LET sr.type = 1 
      ELSE 
         LET sr.type = 2 
      END IF
   #MOD-720042 BY TSD.Sora---start---
      #OUTPUT TO REPORT axcr775_rep(sr.*)
      EXECUTE insert_prep USING
            sr.type,sr.ima09,sr.ima02,sr.ima021,sr.ccu.ccu01,sr.ccu.ccu04,sr.ccu.ccu07,sr.ccu.ccu21,  #FUN-7C0101 ADD ccu07
            sr.ccu.ccu22a,sr.ccu.ccu22b,sr.ccu.ccu22c,sr.ccu.ccu22d,sr.ccu.ccu22e,
            sr.ccu.ccu22f,sr.ccu.ccu22g,sr.ccu.ccu22h,                                              #FUN-7C0101 ADD
            sr.ccu.ccu31,sr.ccu.ccu32a,sr.ccu.ccu32b,
            sr.ccu.ccu32c,sr.ccu.ccu32d,sr.ccu.ccu32e,
            sr.ccu.ccu32f,sr.ccu.ccu32g,sr.ccu.ccu32h,                                              #FUN-7C0101 ADD       
            sr.ccu.ccu11,sr.ccu.ccu12a,
            sr.ccu.ccu12b,sr.ccu.ccu12c,sr.ccu.ccu12d,sr.ccu.ccu12e,
            sr.ccu.ccu12f,sr.ccu.ccu12g,sr.ccu.ccu12h,                                              #FUN-7C0101 ADD 
            sr.ccu.ccu41,sr.ccu.ccu42a,sr.ccu.ccu42b,sr.ccu.ccu42c,sr.ccu.ccu42d,
            sr.ccu.ccu42e,
            sr.ccu.ccu42f,sr.ccu.ccu42g,sr.ccu.ccu42h,                                              #FUN-7C0101 ADD 
            sr.ccu.ccu91,sr.ccu.ccu92a,sr.ccu.ccu92b,sr.ccu.ccu92c,
            sr.ccu.ccu92d,sr.ccu.ccu92e,
            sr.ccu.ccu92f,sr.ccu.ccu92g,sr.ccu.ccu92h,                                              #FUN-7C0101 ADD             
            #g_azi03,g_azi04,g_azi05,g_ccz.ccz27  #CHI-C30012
            g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz27  #CHI-C30012
   #MOD-720042 BY TSD.Sora---end---
   END FOREACH
 
   #MOD-720042 BY TSD.Sora---start---
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'ima09,ccu01')
         RETURNING tm.wc
       LET g_str = tm.wc
    ELSE
       LET g_str = " "
    END IF
    LET g_str = g_str,";",tm.yy,";",tm.mm
#FUN-7C0101 --START-- 根據成本計算類型判定類別編號是否打印
    IF tm.type MATCHES '[12]' THEN
       CALL cl_prt_cs3('axcr775','axcr775',l_sql,g_str)   #FUN-710080 modify
    ELSE 
       CALL cl_prt_cs3('axcr775','axcr775_1',l_sql,g_str)  
    END IF
#FUN-7C0101 --END--
   #FINISH REPORT axcr775_rep
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   #MOD-720042 BY TSD.Sora---end---
END FUNCTION
 
{REPORT axcr775_rep(sr)
    #No.MOD-560146 --start-- 報表列印欄位增加
   DEFINE l_last_sw    LIKE type_file.chr1,           #No.FUN-680122CHAR(01)
          l_inccu21    LIKE ccu_file.ccu21,  
          l_ouccu31    LIKE ccu_file.ccu31,  
          l_endccu11   LIKE ccu_file.ccu11,  
          l_endccu41   LIKE ccu_file.ccu41,
          l_endccu91   LIKE ccu_file.ccu91,
          l_inccu22a   LIKE ccu_file.ccu22a,
          l_inccu22b   LIKE ccu_file.ccu22b,
          l_inccu22c   LIKE ccu_file.ccu22c,
          l_inccu22d   LIKE ccu_file.ccu22d,
          l_inccu22e   LIKE ccu_file.ccu22e,   #FUN-670042 add
          l_ouccu32a   LIKE ccu_file.ccu32a,
          l_ouccu32b   LIKE ccu_file.ccu32b,
          l_ouccu32c   LIKE ccu_file.ccu32c,
          l_ouccu32d   LIKE ccu_file.ccu32d,
          l_ouccu32e   LIKE ccu_file.ccu32e,   #FUN-670042 add
          l_endccu12a  LIKE ccu_file.ccu12a,
          l_endccu12b  LIKE ccu_file.ccu12b,
          l_endccu12c  LIKE ccu_file.ccu12c,
          l_endccu12d  LIKE ccu_file.ccu12d,
          l_endccu12e  LIKE ccu_file.ccu12e,   #FUN-670042 add
          l_endccu42a  LIKE ccu_file.ccu42a,
          l_endccu42b  LIKE ccu_file.ccu42b,
          l_endccu42c  LIKE ccu_file.ccu42c,
          l_endccu42d  LIKE ccu_file.ccu42d,
          l_endccu42e  LIKE ccu_file.ccu42e,   #FUN-670042 add
          l_endccu92a  LIKE ccu_file.ccu92a,
          l_endccu92b  LIKE ccu_file.ccu92b,
          l_endccu92c  LIKE ccu_file.ccu92c,
          l_endccu92d  LIKE ccu_file.ccu92d,
          l_endccu92e  LIKE ccu_file.ccu92e,   #FUN-670042 add
          sr           RECORD
                        type   LIKE type_file.num5,           #No.FUN-680122SMALLINT
                        ccu    RECORD   LIKE  ccu_file.*,  #工單在制成本檔
                        ima09  LIKE ima_file.ima09,        #分群碼
                        ima02  LIKE ima_file.ima02,        #品名規格     
                        ima021 LIKE ima_file.ima021        #規格     
                       END RECORD
          
   OUTPUT TOP MARGIN g_top_margin 
          LEFT MARGIN g_left_margin 
          BOTTOM MARGIN g_bottom_margin 
          PAGE LENGTH g_page_line
   ORDER BY sr.ccu.ccu01,sr.type
   FORMAT                                          
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
         LET g_pageno=g_pageno+1
         LET pageno_total=PAGENO USING '<<<','/pageno'
         PRINT g_head CLIPPED,pageno_total
         PRINT g_x[9],tm.yy CLIPPED,'-',tm.mm USING'&&' CLIPPED
         PRINT g_dash[1,g_len]
         PRINT COLUMN r775_getStartPos(36,40,g_x[12]),g_x[12],
               COLUMN r775_getStartPos(42,46,g_x[10]),g_x[10],
               COLUMN r775_getStartPos(48,52,g_x[11]),g_x[11],
               COLUMN r775_getStartPos(54,58,g_x[17]),g_x[17],
               COLUMN r775_getStartPos(60,64,g_x[18]),g_x[18]
            
         PRINT COLUMN g_c[36],g_dash2[1,g_w[36]+g_w[37]+g_w[38]+g_w[39]+g_w[40]+4],
               COLUMN g_c[42],g_dash2[1,g_w[42]+g_w[43]+g_w[44]+g_w[45]+g_w[46]+4],
               COLUMN g_c[48],g_dash2[1,g_w[48]+g_w[49]+g_w[50]+g_w[51]+g_w[52]+4],
               COLUMN g_c[54],g_dash2[1,g_w[54]+g_w[55]+g_w[56]+g_w[57]+g_w[58]+4],
               COLUMN g_c[60],g_dash2[1,g_w[60]+g_w[61]+g_w[62]+g_w[63]+g_w[64]+4]
  
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],
               g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
               g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],
               g_x[47],g_x[48],g_x[49],g_x[50],g_x[51],g_x[52],
               g_x[53],g_x[54],g_x[55],g_x[56],g_x[57],g_x[58],
               g_x[59],g_x[60],g_x[61],g_x[62],g_x[63],g_x[64]
        
         PRINT g_dash1
         LET l_last_sw='n'
 
      BEFORE GROUP OF sr.ccu.ccu01
         LET l_inccu21  = 0
         LET l_inccu22a = 0
         LET l_inccu22b = 0
         LET l_inccu22c = 0
         LET l_inccu22d = 0
         LET l_inccu22e = 0   #FUN-670042 add
         LET l_ouccu31  = 0
         LET l_ouccu32a = 0
         LET l_ouccu32b = 0
         LET l_ouccu32c = 0
         LET l_ouccu32d = 0
         LET l_ouccu32e = 0   #FUN-670042 add
         LET l_endccu11 = 0
         LET l_endccu12a= 0
         LET l_endccu12b= 0
         LET l_endccu12c= 0
         LET l_endccu12d= 0
         LET l_endccu12e= 0   #FUN-670042 add
         LET l_endccu41 = 0
         LET l_endccu42a= 0
         LET l_endccu42b= 0
         LET l_endccu42c= 0
         LET l_endccu42d= 0
         LET l_endccu42e= 0   #FUN-670042 add
         LET l_endccu91 = 0
         LET l_endccu92a= 0
         LET l_endccu92b= 0
         LET l_endccu92c= 0
         LET l_endccu92d= 0
         LET l_endccu92e= 0   #FUN-670042 add
         PRINT COLUMN g_c[31],sr.ccu.ccu01;  
 
   ON EVERY ROW  
      PRINT COLUMN g_c[32],sr.ccu.ccu04,
            COLUMN g_c[33],sr.ima02,
            COLUMN g_c[34],sr.ima021,
            COLUMN g_c[35],cl_numfor(sr.ccu.ccu21 ,35,g_ccz.ccz27), #CHI-690007 0->ccz27
            COLUMN g_c[36],cl_numfor(sr.ccu.ccu22a,36,g_azi03),    #FUN-570190
            COLUMN g_c[37],cl_numfor(sr.ccu.ccu22b,37,g_azi03),    #FUN-570190
            COLUMN g_c[38],cl_numfor(sr.ccu.ccu22c,38,g_azi03),    #FUN-570190
            COLUMN g_c[39],cl_numfor(sr.ccu.ccu22d,39,g_azi03),    #FUN-570190
            COLUMN g_c[40],cl_numfor(sr.ccu.ccu22e,40,g_azi03),    #FUN-670042 add
            COLUMN g_c[41],cl_numfor(sr.ccu.ccu31 ,41,g_ccz.ccz27), #CHI-690007 0->ccz27
            COLUMN g_c[42],cl_numfor(sr.ccu.ccu32a,42,g_azi03),    #FUN-570190
            COLUMN g_c[43],cl_numfor(sr.ccu.ccu32b,43,g_azi03),    #FUN-570190
            COLUMN g_c[44],cl_numfor(sr.ccu.ccu32c,44,g_azi03),    #FUN-570190
            COLUMN g_c[45],cl_numfor(sr.ccu.ccu32d,45,g_azi03),    #FUN-570190
            COLUMN g_c[46],cl_numfor(sr.ccu.ccu32e,46,g_azi03),    #FUN-670042 add
            COLUMN g_c[47],cl_numfor(sr.ccu.ccu11 ,47,g_ccz.ccz27), #CHI-690007 0->ccz27
            COLUMN g_c[48],cl_numfor(sr.ccu.ccu12a,48,g_azi03),    #FUN-570190
            COLUMN g_c[49],cl_numfor(sr.ccu.ccu12b,49,g_azi03),    #FUN-570190
            COLUMN g_c[50],cl_numfor(sr.ccu.ccu12c,50,g_azi03),    #FUN-570190
            COLUMN g_c[51],cl_numfor(sr.ccu.ccu12d,51,g_azi03),    #FUN-570190
            COLUMN g_c[52],cl_numfor(sr.ccu.ccu12e,52,g_azi03),    #FUN-670042 add
            COLUMN g_c[53],cl_numfor(sr.ccu.ccu41 ,53,g_ccz.ccz27), #CHI-690007 0->ccz27
            COLUMN g_c[54],cl_numfor(sr.ccu.ccu42a,54,g_azi03),    #FUN-570190
            COLUMN g_c[55],cl_numfor(sr.ccu.ccu42b,55,g_azi03),    #FUN-570190
            COLUMN g_c[56],cl_numfor(sr.ccu.ccu42c,56,g_azi03),    #FUN-570190
            COLUMN g_c[57],cl_numfor(sr.ccu.ccu42d,57,g_azi03),    #FUN-570190
            COLUMN g_c[58],cl_numfor(sr.ccu.ccu42e,58,g_azi03),    #FUN-670042 add
            COLUMN g_c[59],cl_numfor(sr.ccu.ccu91 ,59,g_ccz.ccz27), #CHI-690007 0->ccz27
            COLUMN g_c[60],cl_numfor(sr.ccu.ccu92a,60,g_azi03),    #FUN-570190
            COLUMN g_c[61],cl_numfor(sr.ccu.ccu92b,61,g_azi03),    #FUN-570190
            COLUMN g_c[62],cl_numfor(sr.ccu.ccu92c,62,g_azi03),    #FUN-570190
            COLUMN g_c[63],cl_numfor(sr.ccu.ccu92d,63,g_azi03),    #FUN-570190
            COLUMN g_c[64],cl_numfor(sr.ccu.ccu92e,64,g_azi03)     #FUN-670042 add
      IF sr.ima09 = '0' THEN 
         #--->原料
         LET l_totccu21  = l_totccu21  + sr.ccu.ccu21  
         LET l_totccu22a = l_totccu22a + sr.ccu.ccu22a 
         LET l_totccu22b = l_totccu22b + sr.ccu.ccu22b
         LET l_totccu22c = l_totccu22c + sr.ccu.ccu22c
         LET l_totccu22d = l_totccu22d + sr.ccu.ccu22d
         LET l_totccu22e = l_totccu22e + sr.ccu.ccu22e   #FUN-670042 add
         LET l_sumccu31  = l_sumccu31  + sr.ccu.ccu31  
         LET l_sumccu32a = l_sumccu32a + sr.ccu.ccu32a 
         LET l_sumccu32b = l_sumccu32b + sr.ccu.ccu32b
         LET l_sumccu32c = l_sumccu32c + sr.ccu.ccu32c
         LET l_sumccu32d = l_sumccu32d + sr.ccu.ccu32d
         LET l_sumccu32e = l_sumccu32e + sr.ccu.ccu32e   #FUN-670042 add
         LET l_sumccu11  = l_sumccu11  + sr.ccu.ccu11  
         LET l_sumccu12a = l_sumccu12a + sr.ccu.ccu12a 
         LET l_sumccu12b = l_sumccu12b + sr.ccu.ccu12b
         LET l_sumccu12c = l_sumccu12c + sr.ccu.ccu12c
         LET l_sumccu12d = l_sumccu12d + sr.ccu.ccu12d
         LET l_sumccu12e = l_sumccu12e + sr.ccu.ccu12e   #FUN-670042 add
         LET l_sumccu41  = l_sumccu41  + sr.ccu.ccu41  
         LET l_sumccu42a = l_sumccu42a + sr.ccu.ccu42a 
         LET l_sumccu42b = l_sumccu42b + sr.ccu.ccu42b
         LET l_sumccu42c = l_sumccu42c + sr.ccu.ccu42c
         LET l_sumccu42d = l_sumccu42d + sr.ccu.ccu42d
         LET l_sumccu42e = l_sumccu42e + sr.ccu.ccu42e   #FUN-670042 add
         LET l_sumccu91  = l_sumccu91  + sr.ccu.ccu91  
         LET l_sumccu92a = l_sumccu92a + sr.ccu.ccu92a 
         LET l_sumccu92b = l_sumccu92b + sr.ccu.ccu92b
         LET l_sumccu92c = l_sumccu92c + sr.ccu.ccu92c
         LET l_sumccu92d = l_sumccu92d + sr.ccu.ccu92d
         LET l_sumccu92e = l_sumccu92e + sr.ccu.ccu92e   #FUN-670042 add
      ELSE 
         #--->成品
         LET l_tot2ccu21  = l_tot2ccu21  + sr.ccu.ccu21  
         LET l_tot2ccu22a = l_tot2ccu22a + sr.ccu.ccu22a 
         LET l_tot2ccu22b = l_tot2ccu22b + sr.ccu.ccu22b
         LET l_tot2ccu22c = l_tot2ccu22c + sr.ccu.ccu22c
         LET l_tot2ccu22d = l_tot2ccu22d + sr.ccu.ccu22d
         LET l_tot2ccu22e = l_tot2ccu22e + sr.ccu.ccu22e   #FUN-670042 add
         LET l_sum2ccu31  = l_sum2ccu31  + sr.ccu.ccu31  
         LET l_sum2ccu32a = l_sum2ccu32a + sr.ccu.ccu32a 
         LET l_sum2ccu32b = l_sum2ccu32b + sr.ccu.ccu32b
         LET l_sum2ccu32c = l_sum2ccu32c + sr.ccu.ccu32c
         LET l_sum2ccu32d = l_sum2ccu32d + sr.ccu.ccu32d
         LET l_sum2ccu32e = l_sum2ccu32e + sr.ccu.ccu32e   #FUN-670042 add
         LET l_sum2ccu11  = l_sum2ccu11  + sr.ccu.ccu11  
         LET l_sum2ccu12a = l_sum2ccu12a + sr.ccu.ccu12a 
         LET l_sum2ccu12b = l_sum2ccu12b + sr.ccu.ccu12b
         LET l_sum2ccu12c = l_sum2ccu12c + sr.ccu.ccu12c
         LET l_sum2ccu12d = l_sum2ccu12d + sr.ccu.ccu12d
         LET l_sum2ccu12e = l_sum2ccu12e + sr.ccu.ccu12e   #FUN-670042 add
         LET l_sum2ccu41  = l_sum2ccu41  + sr.ccu.ccu41  
         LET l_sum2ccu42a = l_sum2ccu42a + sr.ccu.ccu42a 
         LET l_sum2ccu42b = l_sum2ccu42b + sr.ccu.ccu42b
         LET l_sum2ccu42c = l_sum2ccu42c + sr.ccu.ccu42c
         LET l_sum2ccu42d = l_sum2ccu42d + sr.ccu.ccu42d
         LET l_sum2ccu42e = l_sum2ccu42e + sr.ccu.ccu42e   #FUN-670042 add
         LET l_sum2ccu91  = l_sum2ccu91  + sr.ccu.ccu91  
         LET l_sum2ccu92a = l_sum2ccu92a + sr.ccu.ccu92a 
         LET l_sum2ccu92b = l_sum2ccu92b + sr.ccu.ccu92b
         LET l_sum2ccu92c = l_sum2ccu92c + sr.ccu.ccu92c
         LET l_sum2ccu92d = l_sum2ccu92d + sr.ccu.ccu92d
         LET l_sum2ccu92e = l_sum2ccu92e + sr.ccu.ccu92e   #FUN-670042 add
      END IF 
      LET l_inccu21  = l_inccu21  + sr.ccu.ccu21
      LET l_inccu22a = l_inccu22a + sr.ccu.ccu22a 
      LET l_inccu22b = l_inccu22b + sr.ccu.ccu22b
      LET l_inccu22c = l_inccu22c + sr.ccu.ccu22c
      LET l_inccu22d = l_inccu22d + sr.ccu.ccu22d
      LET l_inccu22e = l_inccu22e + sr.ccu.ccu22e   #FUN-670042 add
      LET l_ouccu31  = l_ouccu31  + sr.ccu.ccu31  
      LET l_ouccu32a = l_ouccu32a + sr.ccu.ccu32a 
      LET l_ouccu32b = l_ouccu32b + sr.ccu.ccu32b
      LET l_ouccu32c = l_ouccu32c + sr.ccu.ccu32c
      LET l_ouccu32d = l_ouccu32d + sr.ccu.ccu32d
      LET l_ouccu32e = l_ouccu32e + sr.ccu.ccu32e   #FUN-670042 add
      LET l_endccu11  = l_endccu11  + sr.ccu.ccu11  
      LET l_endccu12a = l_endccu12a + sr.ccu.ccu12a 
      LET l_endccu12b = l_endccu12b + sr.ccu.ccu12b
      LET l_endccu12c = l_endccu12c + sr.ccu.ccu12c
      LET l_endccu12d = l_endccu12d + sr.ccu.ccu12d
      LET l_endccu12e = l_endccu12e + sr.ccu.ccu12e   #FUN-670042 add
      LET l_endccu41  = l_endccu41  + sr.ccu.ccu41  
      LET l_endccu42a = l_endccu42a + sr.ccu.ccu42a 
      LET l_endccu42b = l_endccu42b + sr.ccu.ccu42b
      LET l_endccu42c = l_endccu42c + sr.ccu.ccu42c
      LET l_endccu42d = l_endccu42d + sr.ccu.ccu42d
      LET l_endccu42e = l_endccu42e + sr.ccu.ccu42e   #FUN-670042 add
      LET l_endccu91  = l_endccu91  + sr.ccu.ccu91  
      LET l_endccu92a = l_endccu92a + sr.ccu.ccu92a 
      LET l_endccu92b = l_endccu92b + sr.ccu.ccu92b
      LET l_endccu92c = l_endccu92c + sr.ccu.ccu92c
      LET l_endccu92d = l_endccu92d + sr.ccu.ccu92d
      LET l_endccu92e = l_endccu92e + sr.ccu.ccu92e   #FUN-670042 add
 
   AFTER GROUP OF sr.ccu.ccu01
      PRINT COLUMN g_c[34], g_x[16] CLIPPED,
            COLUMN g_c[35], cl_numfor(l_inccu21 ,35,g_ccz.ccz27), #CHI-690007 0->ccz27 
            COLUMN g_c[36], cl_numfor(l_inccu22a,36,g_azi03),    #FUN-570190
            COLUMN g_c[37], cl_numfor(l_inccu22b,37,g_azi03),    #FUN-570190
            COLUMN g_c[38], cl_numfor(l_inccu22c,38,g_azi03),    #FUN-570190
            COLUMN g_c[39], cl_numfor(l_inccu22d,39,g_azi03),    #FUN-570190
            COLUMN g_c[40], cl_numfor(l_inccu22e,40,g_azi03),    #FUN-670042 add
            COLUMN g_c[41], cl_numfor(l_ouccu31 ,41,g_ccz.ccz27), #CHI-690007 0->ccz27 
            COLUMN g_c[42], cl_numfor(l_ouccu32a,42,g_azi03),    #FUN-570190 
            COLUMN g_c[43], cl_numfor(l_ouccu32b,43,g_azi03),    #FUN-570190
            COLUMN g_c[44], cl_numfor(l_ouccu32c,44,g_azi03),    #FUN-570190
            COLUMN g_c[45], cl_numfor(l_ouccu32d,45,g_azi03),    #FUN-570190
            COLUMN g_c[46], cl_numfor(l_ouccu32e,46,g_azi03),    #FUN-670042 add
            COLUMN g_c[47], cl_numfor(l_endccu11,47,g_ccz.ccz27), #CHI-690007 0->ccz27 
            COLUMN g_c[48], cl_numfor(l_endccu12a,48,g_azi03),    #FUN-570190 
            COLUMN g_c[49], cl_numfor(l_endccu12b,49,g_azi03),    #FUN-570190
            COLUMN g_c[50], cl_numfor(l_endccu12c,50,g_azi03),    #FUN-570190
            COLUMN g_c[51], cl_numfor(l_endccu12d,51,g_azi03),    #FUN-570190
            COLUMN g_c[52], cl_numfor(l_endccu12e,52,g_azi03),    #FUN-670042 add
            COLUMN g_c[53], cl_numfor(l_endccu41 ,53,g_ccz.ccz27), #CHI-690007 0->ccz27 
            COLUMN g_c[54], cl_numfor(l_endccu42a,54,g_azi03),    #FUN-570190 
            COLUMN g_c[55], cl_numfor(l_endccu42b,55,g_azi03),    #FUN-570190
            COLUMN g_c[56], cl_numfor(l_endccu42c,56,g_azi03),    #FUN-570190
            COLUMN g_c[57], cl_numfor(l_endccu42d,57,g_azi03),    #FUN-570190
            COLUMN g_c[58], cl_numfor(l_endccu42e,58,g_azi03),    #FUN-670042 add
            COLUMN g_c[59], cl_numfor(l_endccu91 ,59,g_ccz.ccz27), #CHI-690007 0->ccz27 
            COLUMN g_c[60], cl_numfor(l_endccu92a,60,g_azi03),    #FUN-570190 
            COLUMN g_c[61], cl_numfor(l_endccu92b,61,g_azi03),    #FUN-570190
            COLUMN g_c[62], cl_numfor(l_endccu92c,62,g_azi03),    #FUN-570190
            COLUMN g_c[63], cl_numfor(l_endccu92d,63,g_azi03),    #FUN-570190
            COLUMN g_c[64], cl_numfor(l_endccu92e,64,g_azi03)     #FUN-670042 add
      PRINT 
 
   ON LAST ROW
      PRINT COLUMN g_c[34],g_dash2[1,g_w[34]],
            COLUMN g_c[35],g_dash2[1,g_w[35]],
            COLUMN g_c[36],g_dash2[1,g_w[36]],
            COLUMN g_c[37],g_dash2[1,g_w[37]],
            COLUMN g_c[38],g_dash2[1,g_w[38]],
            COLUMN g_c[39],g_dash2[1,g_w[39]],
            COLUMN g_c[40],g_dash2[1,g_w[40]],
            COLUMN g_c[41],g_dash2[1,g_w[41]],
            COLUMN g_c[42],g_dash2[1,g_w[42]],
            COLUMN g_c[43],g_dash2[1,g_w[43]],
            COLUMN g_c[44],g_dash2[1,g_w[44]],
            COLUMN g_c[45],g_dash2[1,g_w[45]],
            COLUMN g_c[46],g_dash2[1,g_w[46]],
            COLUMN g_c[47],g_dash2[1,g_w[47]],
            COLUMN g_c[48],g_dash2[1,g_w[48]],
            COLUMN g_c[49],g_dash2[1,g_w[49]],
            COLUMN g_c[50],g_dash2[1,g_w[50]],
            COLUMN g_c[51],g_dash2[1,g_w[51]],
            COLUMN g_c[52],g_dash2[1,g_w[52]],
            COLUMN g_c[53],g_dash2[1,g_w[53]],
            COLUMN g_c[54],g_dash2[1,g_w[54]],
            COLUMN g_c[55],g_dash2[1,g_w[55]],
            COLUMN g_c[56],g_dash2[1,g_w[56]],
            COLUMN g_c[57],g_dash2[1,g_w[57]],
            COLUMN g_c[58],g_dash2[1,g_w[58]],
            COLUMN g_c[59],g_dash2[1,g_w[59]],
            COLUMN g_c[60],g_dash2[1,g_w[60]],
            COLUMN g_c[61],g_dash2[1,g_w[61]],
            COLUMN g_c[62],g_dash2[1,g_w[62]],
            COLUMN g_c[63],g_dash2[1,g_w[63]],
            COLUMN g_c[64],g_dash2[1,g_w[64]]
      PRINT COLUMN g_c[34], g_x[13] CLIPPED,
            COLUMN g_c[35], cl_numfor(l_totccu21,35,g_ccz.ccz27), #CHI-690007 0->ccz27
            COLUMN g_c[36], cl_numfor(l_totccu22a,36,g_azi03),    #FUN-570190
            COLUMN g_c[37], cl_numfor(l_totccu22b,37,g_azi03),    #FUN-570190
            COLUMN g_c[38], cl_numfor(l_totccu22c,38,g_azi03),    #FUN-570190
            COLUMN g_c[39], cl_numfor(l_totccu22d,39,g_azi03),    #FUN-570190
            COLUMN g_c[40], cl_numfor(l_totccu22e,40,g_azi03),    #FUN-670042 add
            COLUMN g_c[41], cl_numfor(l_sumccu31,41,g_ccz.ccz27), #CHI-690007 0->ccz27 
            COLUMN g_c[42], cl_numfor(l_sumccu32a,42,g_azi03),    #FUN-570190
            COLUMN g_c[43], cl_numfor(l_sumccu32b,43,g_azi03),    #FUN-570190
            COLUMN g_c[44], cl_numfor(l_sumccu32c,44,g_azi03),    #FUN-570190
            COLUMN g_c[45], cl_numfor(l_sumccu32d,45,g_azi03),    #FUN-570190
            COLUMN g_c[46], cl_numfor(l_sumccu32e,46,g_azi03),    #FUN-670042 add
            COLUMN g_c[47], cl_numfor(l_sumccu11,47,g_ccz.ccz27), #CHI-690007 0->ccz27 
            COLUMN g_c[48], cl_numfor(l_sumccu12a,48,g_azi03),    #FUN-570190
            COLUMN g_c[49], cl_numfor(l_sumccu12b,49,g_azi03),    #FUN-570190
            COLUMN g_c[50], cl_numfor(l_sumccu12c,50,g_azi03),    #FUN-570190
            COLUMN g_c[51], cl_numfor(l_sumccu12d,51,g_azi03),    #FUN-570190
            COLUMN g_c[52], cl_numfor(l_sumccu12e,52,g_azi03),    #FUN-670042 add
            COLUMN g_c[53], cl_numfor(l_sumccu41,53,g_ccz.ccz27), #CHI-690007 0->ccz27 
            COLUMN g_c[54], cl_numfor(l_sumccu42a,54,g_azi03),    #FUN-570190
            COLUMN g_c[55], cl_numfor(l_sumccu42b,55,g_azi03),
            COLUMN g_c[56], cl_numfor(l_sumccu42c,56,g_azi03),    #FUN-570190
            COLUMN g_c[57], cl_numfor(l_sumccu42d,57,g_azi03),    #FUN-570190
            COLUMN g_c[58], cl_numfor(l_sumccu42e,58,g_azi03),    #FUN-670042 add
            COLUMN g_c[59], cl_numfor(l_sumccu91,59,g_ccz.ccz27), #CHI-690007 0->ccz27 
            COLUMN g_c[60], cl_numfor(l_sumccu92a,60,g_azi03),    #FUN-570190
            COLUMN g_c[61], cl_numfor(l_sumccu92b,61,g_azi03),    #FUN-570190
            COLUMN g_c[62], cl_numfor(l_sumccu92c,62,g_azi03),    #FUN-570190
            COLUMN g_c[63], cl_numfor(l_sumccu92d,63,g_azi03),    #FUN-570190
            COLUMN g_c[64], cl_numfor(l_sumccu92e,64,g_azi03)     #FUN-670042 add
      PRINT COLUMN g_c[34],g_dash2[1,g_w[34]],
            COLUMN g_c[35],g_dash2[1,g_w[35]],
            COLUMN g_c[36],g_dash2[1,g_w[36]],
            COLUMN g_c[37],g_dash2[1,g_w[37]],
            COLUMN g_c[38],g_dash2[1,g_w[38]],
            COLUMN g_c[39],g_dash2[1,g_w[39]],
            COLUMN g_c[40],g_dash2[1,g_w[40]],
            COLUMN g_c[41],g_dash2[1,g_w[41]],
            COLUMN g_c[42],g_dash2[1,g_w[42]],
            COLUMN g_c[43],g_dash2[1,g_w[43]],
            COLUMN g_c[44],g_dash2[1,g_w[44]],
            COLUMN g_c[45],g_dash2[1,g_w[45]],
            COLUMN g_c[46],g_dash2[1,g_w[46]],
            COLUMN g_c[47],g_dash2[1,g_w[47]],
            COLUMN g_c[48],g_dash2[1,g_w[48]],
            COLUMN g_c[49],g_dash2[1,g_w[49]],
            COLUMN g_c[50],g_dash2[1,g_w[50]],
            COLUMN g_c[51],g_dash2[1,g_w[51]],
            COLUMN g_c[52],g_dash2[1,g_w[52]],
            COLUMN g_c[53],g_dash2[1,g_w[53]],
            COLUMN g_c[54],g_dash2[1,g_w[54]],
            COLUMN g_c[55],g_dash2[1,g_w[55]],
            COLUMN g_c[56],g_dash2[1,g_w[56]],
            COLUMN g_c[57],g_dash2[1,g_w[57]],
            COLUMN g_c[58],g_dash2[1,g_w[58]],
            COLUMN g_c[59],g_dash2[1,g_w[59]],
            COLUMN g_c[60],g_dash2[1,g_w[60]],
            COLUMN g_c[61],g_dash2[1,g_w[61]],
            COLUMN g_c[62],g_dash2[1,g_w[62]],
            COLUMN g_c[63],g_dash2[1,g_w[63]],
            COLUMN g_c[64],g_dash2[1,g_w[64]]
      PRINT COLUMN g_c[34],g_x[14] CLIPPED,
            COLUMN g_c[35], cl_numfor(l_tot2ccu21,35,g_ccz.ccz27), #CHI-690007 0->ccz27
            COLUMN g_c[36], cl_numfor(l_tot2ccu22a,36,g_azi03),    #FUN-570190
            COLUMN g_c[37], cl_numfor(l_tot2ccu22b,37,g_azi03),    #FUN-570190
            COLUMN g_c[38], cl_numfor(l_tot2ccu22c,38,g_azi03),    #FUN-570190
            COLUMN g_c[39], cl_numfor(l_tot2ccu22d,39,g_azi03),    #FUN-570190
            COLUMN g_c[40], cl_numfor(l_tot2ccu22e,40,g_azi03),    #FUN-670042 add
            COLUMN g_c[41], cl_numfor(l_sum2ccu31,41,g_ccz.ccz27), #CHI-690007 0->ccz27 
            COLUMN g_c[42], cl_numfor(l_sum2ccu32a,42,g_azi03),    #FUN-570190
            COLUMN g_c[43], cl_numfor(l_sum2ccu32b,43,g_azi03),    #FUN-570190
            COLUMN g_c[44], cl_numfor(l_sum2ccu32c,44,g_azi03),    #FUN-570190
            COLUMN g_c[45], cl_numfor(l_sum2ccu32d,45,g_azi03),    #FUN-570190
            COLUMN g_c[46], cl_numfor(l_sum2ccu32e,46,g_azi03),    #FUN-670042 add
            COLUMN g_c[47], cl_numfor(l_sum2ccu11,47,g_ccz.ccz27), #CHI-690007 0->ccz27 
            COLUMN g_c[48], cl_numfor(l_sum2ccu12a,48,g_azi03),    #FUN-570190
            COLUMN g_c[49], cl_numfor(l_sum2ccu12b,49,g_azi03),    #FUN-570190
            COLUMN g_c[50], cl_numfor(l_sum2ccu12c,50,g_azi03),    #FUN-570190
            COLUMN g_c[51], cl_numfor(l_sum2ccu12d,51,g_azi03),    #FUN-570190
            COLUMN g_c[52], cl_numfor(l_sum2ccu12e,52,g_azi03),    #FUN-670042 add
            COLUMN g_c[53], cl_numfor(l_sum2ccu41,53,g_ccz.ccz27), #CHI-690007 0->ccz27 
            COLUMN g_c[54], cl_numfor(l_sum2ccu42a,54,g_azi03),    #FUN-570190
            COLUMN g_c[55], cl_numfor(l_sum2ccu42b,55,g_azi03),    #FUN-570190
            COLUMN g_c[56], cl_numfor(l_sum2ccu42c,56,g_azi03),    #FUN-570190
            COLUMN g_c[57], cl_numfor(l_sum2ccu42d,57,g_azi03),    #FUN-570190
            COLUMN g_c[58], cl_numfor(l_sum2ccu42e,58,g_azi03),    #FUN-670042 add
            COLUMN g_c[59], cl_numfor(l_sum2ccu91,59,g_ccz.ccz27), #CHI-690007 0->ccz27 
            COLUMN g_c[60], cl_numfor(l_sum2ccu92a,60,g_azi03),    #FUN-570190
            COLUMN g_c[61], cl_numfor(l_sum2ccu92b,61,g_azi03),    #FUN-570190
            COLUMN g_c[62], cl_numfor(l_sum2ccu92c,62,g_azi03),    #FUN-570190
            COLUMN g_c[63], cl_numfor(l_sum2ccu92d,63,g_azi03),    #FUN-570190
            COLUMN g_c[64], cl_numfor(l_sum2ccu92e,64,g_azi03)     #FUN-670042 add
      PRINT g_dash[1,g_len]
      LET l_last_sw='y'
          
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[44], (g_len-9) CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
 
#by kim 05/1/26
#函式說明:算出一字串,位于數個連續表頭的中央位置
#l_sta -  zaa起始序號   l_end - zaa結束序號  l_sta -字串長度
#傳回值 - 字串起始位置
FUNCTION r775_getStartPos(l_sta,l_end,l_str)
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
}
