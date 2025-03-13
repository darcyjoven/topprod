# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: admr150.4gl
# Descriptions...: 收貨數量異常警訊表
# Date & Author..: 02/04/02 By Wiky
# Modify.........: No.FUN-4C0099 05/01/18 By kim 報表轉XML功能
# Modify.........: No.TQC-610083 06/04/03 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680097 06/08/28 By chen 類型轉換
# Modify.........: No.FUN-690111 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-750139 08/01/23 By jamie 報表產出結果 1.請於--"採購數量"欄位後，增加 "採購單位" 欄位。
#                                                               2.    --"百分比"欄位，增加顯示"%"。
# Modify.........: No.FUN-860005 08/06/02 By mike 報表輸出方式轉為Crystal Reports
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.MOD-8A0038 08/11/15 By Pengu 收貨數量應考慮退貨量
# Modify.........: No.MOD-940396 09/04/29 By lutingting增大l_munt寬度 
# Modify.........: No.MOD-960243 09/07/16 By Smapmin 收貨數量需排除作廢的單據數量
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      LIKE type_file.chr1000,          # Where condition   #No.FUN-680097 VARCHAR(300)
              bdate   LIKE type_file.dat,              #No.FUN-680097 DATE
              edate   LIKE type_file.dat,              #No.FUN-680097 DATE
              d       LIKE type_file.num5,             #No.FUN-680097 SMALLINT
              more    LIKE type_file.chr1              # Input more condition(Y/N)  #No.FUN-680097 VARCHAR(01)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680097 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680097 VARCHAR(72)
DEFINE   l_table         STRING                       #No.FUN-860005
DEFINE   g_sql           STRING                       #No.FUN-860005
DEFINE   g_str           STRING                       #No.FUN-860005
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ADM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690111
 
#No.FUN-860005  --BEGIN
   LET g_sql = "pmm09.pmm_file.pmm09,",                                                                                   
               "pmm12.pmm_file.pmm12,",                                                                                   
               "pmn04.pmn_file.pmn04,",                                                                                   
               "pmn041.pmn_file.pmn041,",                                                                                  
               "pmc03.pmc_file.pmc03,",                                                                                   
               "pmn20.pmn_file.pmn20,",                                                                                  
               "pmn07.pmn_file.pmn07,",                                                       
               #"l_munt.type_file.num5,",         #MOD-940396 mark 
               "l_munt.rvb_file.rvb07,",          #MOD-940396                                     
               "pmm01.pmm_file.pmm01,",                                                                                   
               "pmn02.pmn_file.pmn02,",
               "l_ima021.ima_file.ima021,",
               "l_rate.oea_file.oea09,",
               "l_sum.rvb_file.rvb07"
   LET l_table = cl_prt_temptable("admr150",g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
   PREPARE insert_prep FROM g_sql 
   IF STATUS THEN 
      CALL cl_err("insert_prep:",status,1) 
      EXIT PROGRAM 
   END IF
#No.FUN-860005  --END
 
#-------------No.TQC-610083 modify
#  LET tm.more = 'N'
#  LET tm.edate =g_today 
#  LET tm.bdate =g_today
#  LET tm.d = 0
#  LET g_pdate = g_today
#  LET g_rlang = g_lang
#  LET g_bgjob = 'N'
#  LET g_copies = '1'
#  LET tm.wc    = ARG_VAL(1)
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.d     = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
#-------------No.TQC-610083 end
   IF cl_null(tm.wc) THEN
       CALL admr150_tm(0,0)             # Input print condition
   ELSE
       CALL admr150()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
END MAIN
 
FUNCTION admr150_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01           #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680097 SMALLINT
       l_cmd          LIKE type_file.chr1000        #No.FUN-680097 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   OPEN WINDOW admr150_w AT p_row,p_col
        WITH FORM "adm/42f/admr150"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
#-------------------No.TQC-610083 add
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET tm.edate =g_today 
   LET tm.bdate =g_today
   LET tm.d = 0
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
#-------------------No.TQC-610083 end
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmm09,pmm12
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
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW admr150_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.bdate,tm.edate,tm.d,tm.more
   INPUT BY NAME tm.bdate,tm.edate,tm.d,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN
             NEXT FIELD bdate
         END IF
 
      AFTER FIELD edate
        IF cl_null(tm.edate) OR tm.edate < tm.bdate THEN
            NEXT FIELD edate
        END IF
 
      AFTER FIELD d
        IF cl_null(tm.d) THEN
            NEXT FIELD d
        END IF
 
 
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
      LET INT_FLAG = 0 CLOSE WINDOW admr150_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='admr150'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('admr150','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.bdate CLIPPED,"'" ,
                         " '",tm.edate CLIPPED,"'" ,
                         " '",tm.d CLIPPED,"'" ,
                        #" '",tm.more CLIPPED,"'"  ,            #No.TQC-610083 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('admr150',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW admr150_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL admr150()
   ERROR ""
END WHILE
   CLOSE WINDOW admr150_w
END FUNCTION
 
FUNCTION admr150()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680097 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0100
          l_sql     LIKE type_file.chr1000,       #No.FUN-680097 VARCHAR(3000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680097 VARCHAR(40)
          sr        RECORD
                    pmm09    LIKE pmm_file.pmm09,
                    pmm12    LIKE pmm_file.pmm12,
                    pmn04    LIKE pmn_file.pmn04,
                    pmn041   LIKE pmn_file.pmn041,
                    pmc03    LIKE pmc_file.pmc03,
                    pmn20    LIKE pmn_file.pmn20,
                    pmn07    LIKE pmn_file.pmn07,             #FUN-750139 add
                    #l_munt   LIKE type_file.num5,             #No.FUN-680097 SMALLINT  #MOD-940396 mark 
                    l_munt   LIKE rvb_file.rvb07,     #MOD-940396 
                    pmm01    LIKE pmm_file.pmm01,
                    pmn02    LIKE pmn_file.pmn02
                    END RECORD
 
#No.FUN-860005  --BEGIN
     DEFINE  l_ima021   LIKE ima_file.ima021
     DEFINE  l_rate     LIKE oea_file.oea09
     DEFINE  l_sum      LIKE rvb_file.rvb07
 
     CALL cl_del_data(l_table) 
#No.FUN-860005  --END
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmmuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
     #End:FUN-980030
 
     LET l_sql="SELECT pmm09,pmm12,pmn04,pmn041,pmc03,pmn20,pmn07,'',pmm01,pmn02 ",   #FUN-750139 add pmna07
               "  FROM pmm_file, OUTER pmn_file,OUTER pmc_file",
               " WHERE pmm_file.pmm01=pmn_file.pmn01 ",
               "   AND pmm_file.pmm09=pmc_file.pmc01 ",
               "   AND pmm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
               "   AND ",tm.wc CLIPPED,
               "   AND pmm18 = 'Y' ",  #採購單已確認的資料
               " ORDER BY pmm01 "
     PREPARE admr150_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
        EXIT PROGRAM 
     END IF
     DECLARE admr150_curs1 CURSOR FOR admr150_prepare1
 
     #CALL cl_outnam('admr150') RETURNING l_name    #No.FUN-860005
     #START REPORT admr150_rep TO l_name            #No.FUN-860005
 
     LET g_pageno = 0
     FOREACH admr150_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       #No.FUN-860005  --BEGIN
       #OUTPUT TO REPORT admr150_rep(sr.*)
      #---------No.MOD-8A0038 modify
      #SELECT SUM(rvb07) INTO l_sum FROM rvb_file  #收貨數量                                                                         
       #SELECT SUM(rvb07-rvb29) INTO l_sum FROM rvb_file  #收貨數量    #MOD-960243                                                                        
       SELECT SUM(rvb07-rvb29) INTO l_sum FROM rvb_file,rva_file  #收貨數量    #MOD-960243                                                                        
      #---------No.MOD-8A0038 end
        WHERE rvb04=sr.pmm01                                                                                                         
         AND rvb03=sr.pmn02                                                                                                         
         AND rva01=rvb01   #MOD-960243
         AND rvaconf != 'X'   #MOD-960243
       IF cl_null(l_sum) THEN LET l_sum=0 END IF                                                                                     
       LET sr.l_munt=l_sum-sr.pmn20          #超交數量                                                                               
       LET l_rate=(sr.l_munt/sr.pmn20)*100   #超交比率=(超交數量/pmn20)* 100                                                         
       IF  l_rate >tm.d THEN                                                                                                         
          SELECT ima021 INTO l_ima021 FROM ima_file                                                                                 
              WHERE ima01=sr.pmn04                                                                                                  
          IF SQLCA.sqlcode THEN                                                                                                     
              LET l_ima021 = NULL                                                                                                   
          END IF 
          EXECUTE insert_prep USING sr.pmm09,sr.pmm12,sr.pmn04,sr.pmn041,sr.pmc03,
                                    sr.pmn20,sr.pmn07,sr.l_munt,sr.pmm01,sr.pmn02,
                                    l_ima021,l_rate,l_sum
       END IF    
       #No.FUN-860005  --END                                     
     END FOREACH
 
     #No.FUN-860005  --BEGIN  
     #FINISH REPORT admr150_rep
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
     IF g_zz05 = 'Y ' THEN 
        CALL cl_wcchp(tm.wc,'pmm09,pmm12')
        RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str CLIPPED
     LET g_sql="SELECT * FROM ", g_cr_db_str CLIPPED,l_table CLIPPED                                                                
     CALL cl_prt_cs3('admr150','admr150',g_sql,g_str)  
     #No.FUN-860005  --END 
END FUNCTION
 
#No.FUN-860005  --BEGIN
{
REPORT admr150_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,             #No.FUN-680097 VARCHAR(1)
          l_ima021 LIKE ima_file.ima021,
          sr        RECORD
                    pmm09    LIKE pmm_file.pmm09,
                    pmm12    LIKE pmm_file.pmm12,
                    pmn04    LIKE pmn_file.pmn04,
                    pmn041    LIKE pmn_file.pmn041,
                    pmc03    LIKE pmc_file.pmc03,
                    pmn20    LIKE pmn_file.pmn20,
                    pmn07    LIKE pmn_file.pmn07,             #FUN-750139 add
                    l_munt   LIKE type_file.num5,       #No.FUN-680097 SMALLINT
                    pmm01    LIKE pmm_file.pmm01,
                    pmn02    LIKE pmn_file.pmn02
                    END RECORD,
          l_rate    LIKE oea_file.oea09,                #No.FUN-680097 DEC(3,0) 
          l_sum     LIKE rvb_file.rvb07                 #No.FUN-680097 DEC(20,6)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.pmm01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41]  #FUN-750139 add g_x[41]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      SELECT SUM(rvb07) INTO l_sum FROM rvb_file  #收貨數量
       WHERE rvb04=sr.pmm01
         AND rvb03=sr.pmn02
      IF cl_null(l_sum) THEN LET l_sum=0 END IF
      LET sr.l_munt=l_sum-sr.pmn20          #超交數量
      LET l_rate=(sr.l_munt/sr.pmn20)*100   #超交比率=(超交數量/pmn20)* 100
      IF  l_rate >tm.d THEN
          SELECT ima021 INTO l_ima021 FROM ima_file
              WHERE ima01=sr.pmn04
          IF SQLCA.sqlcode THEN
              LET l_ima021 = NULL
          END IF
 
          PRINT COLUMN g_c[31],sr.pmn04  CLIPPED,
                COLUMN g_c[32],sr.pmn041 CLIPPED,
                COLUMN g_c[33],l_ima021  CLIPPED,
                COLUMN g_c[34],sr.pmm09  CLIPPED,
                COLUMN g_c[35],sr.pmc03  CLIPPED,
                COLUMN g_c[36],cl_numfor(sr.pmn20,36,2),
                COLUMN g_c[41],sr.pmn07  CLIPPED,      #FUN-750139  add
                COLUMN g_c[37],cl_numfor(l_sum,37,2),
                COLUMN g_c[38],cl_numfor(sr.l_munt,38,2),
               #COLUMN g_c[39],l_rate    CLIPPED,       #FUN-750139 mark
                COLUMN g_c[39],l_rate    CLIPPED,'%',   #FUN-750139 mod
                COLUMN g_c[40],sr.pmm01  CLIPPED
      END IF
   ON LAST ROW
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      PRINT g_dash
      IF l_last_sw = 'n'
         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[40], g_x[6] CLIPPED
         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[40], g_x[7] CLIPPED
      END IF
END REPORT
}
#No.FUN-860005  --END
#FUN-870144
