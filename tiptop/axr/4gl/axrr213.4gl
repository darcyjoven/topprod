# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: axrr213.4gl
# Descriptions...: 信用狀餘額表(axrr213)
# Date & Author..: 99/01/25      by plum
# Modify.........: No.FUN-4C0100 04/12/27 By Smapmin 報表轉XML格式
# Modify.........: No.TQC-610059 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.MOD-710209 07/02/01 By Smapmin 總計計算有誤
# Modify.........: No.FUN-7A0036 07/11/02 By baofei  報表輸出至Crystal Reports功能  
# Modify.........: No.CHI-860029 08/07/07 By sherry  在執行信用狀余額報表時，加入「匯入日期」為條件
# Modify.........: No.MOD-920283 09/02/23 By Smapmin 沒有押匯資料也應該要呈現出來
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-C20084 12/02/13 By Dido 排除已結案資料 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                        # Print condition RECORD
              wc      STRING,  # Where condition #No.FUN-680123 VARCHAR(1000) #MOD-C20084 mod 1000 -> STRING
              more    LIKE type_file.chr1,      # Input more condition(Y/N) #No.FUN-680123 VARCHAR(01)
              olc20   LIKE olc_file.olc20      #No.CHI-860029 
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680123 SMALLINT
#No.FUN-7A0036---Begin                                                          
DEFINE l_table        STRING,                                                   
       g_str          STRING,                                                   
       g_sql          STRING, 
       l_sql          STRING                                                    
#No.FUN-7A0036---End      
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
#No.FUN-7A0036---Begin
   LET g_sql = "ola01.ola_file.ola01,",                                         
               "ola04.ola_file.ola04,",                                       
               "ola05.ola_file.ola05,",                                       
               "ola06.ola_file.ola06,",                                         
               "ola09.ola_file.ola09,",                                         
               "ola10.ola_file.ola10,",                                      
               "ola14.ola_file.ola14,",                                      
               "ola21.ola_file.ola21,",                                         
               "occ01.occ_file.occ01,",                                         
               "occ02.occ_file.occ02,",
               "t_azi03.azi_file.azi03,",
               "t_azi04.azi_file.azi04,",
               "t_azi05.azi_file.azi05"                                         
                                                                                
   LET l_table = cl_prt_temptable('axrr213',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?) "       
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM  
   END IF
#No.FUN-7A0036---End
   #-----TQC-610059---------
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #-----END TQC-610059-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#No.FUN-7A0036---Begin 
{  #no.5196
   DROP TABLE curr_tmp
   CREATE TEMP TABLE curr_tmp
    (curr LIKE ade_file.ade04,
     ola05 LIKE cre_file.cre08,
     amt1 LIKE type_file.num20_6,
     amt2 LIKE type_file.num20_6)
      #No.FUN-680123 end
   #no.5196(end)
}
#No.FUN-7A0036---End
   IF cl_null(tm.wc) THEN
      CALL axrr213_tm(0,0)             # Input print condition
   ELSE
      CALL axrr213()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION axrr213_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680123 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680123 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 7 LET p_col = 15
   ELSE LET p_row = 5 LET p_col = 15
   END IF
 
   OPEN WINDOW axrr213_w AT p_row,p_col
        WITH FORM "axr/42f/axrr213"
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
   LET tm.olc20 = g_today  #No.CHI-860029 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ola01, ola04,ola05
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
      LET INT_FLAG = 0 CLOSE WINDOW axrr213_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.olc20
   INPUT BY NAME tm.olc20,tm.more WITHOUT DEFAULTS  #No.CHI-860029 add tm.olc20
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axrr213_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr213'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr213','9031',1)
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
                         " '",tm.wc CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axrr213',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrr213_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrr213()
   ERROR ""
END WHILE
   CLOSE WINDOW axrr213_w
END FUNCTION
 
FUNCTION axrr213()
   DEFINE 
          l_name    LIKE type_file.chr20,          # External(Disk) file name #No.FUN-680123 VARCHAR(20) 
#       l_time          LIKE type_file.chr8        #No.FUN-6A0095
          l_sql     STRING,        #No.FUN-680123 VARCHAR(1000)   #MOD-C20084 mod 1000 -> STRING 
          l_za05    LIKE type_file.chr1000,        #No.FUN-680123 VARCHAR(40)
          l_big5    LIKE type_file.chr1000,        #No.FUN-680123 VARCHAR(100)
          g_str     STRING,                        #No.FUN-7A0036
          l_curr    LIKE azi_file.azi01,           #No.FUN7A0036        
          l_amt1,l_amt2  LIKE type_file.num20_6,   #No.FUN7A0036
          sr        RECORD
                    ola01     LIKE   ola_file.ola01 ,
                   #dept             VARCHAR(06),
                    dept      LIKE   type_file.chr6,     #No.FUN-680123 VARCHAR(06)
                    ola04     LIKE   ola_file.ola04 ,
                    ola05     LIKE   ola_file.ola05 ,
                    ola09     LIKE   ola_file.ola09 ,
                    ola10     LIKE   ola_file.ola10 ,
                    ola14     LIKE   ola_file.ola14 ,
                    ola21     LIKE   ola_file.ola21 ,
                    occ01     LIKE   occ_file.occ01 ,
                    occ02     LIKE   occ_file.occ02 ,
                    ola06     LIKE   ola_file.ola06 ,
                    olc29     LIKE   olc_file.olc29     #No.CHI-860029    
                    END RECORD
     CALL cl_del_data(l_table)           #No.FUN-7A0036
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #No.FUN-7A0036
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN#只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND olauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND olagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND olagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('olauser', 'olagrup')
     #End:FUN-980030
 
     #no.5196
 #    DELETE FROM curr_tmp;              #No.FUN-7A0036
     #no.5196
 
     #No.CHI-860029---Begin
     #LET l_sql = "SELECT ola01,' ',ola04, ola05, ola09, ola10, ola14,", 
     #            "       ola21,occ01,occ02,ola06 ",    
     #            "  FROM ola_file,OUTER occ_file ",         
     #            " WHERE olaconf !='X' " , #010806增
     #            "   AND ", tm.wc CLIPPED   ,
     LET l_sql = "SELECT UNIQUE ola01,' ',ola04, ola05, ola09,' ', ola14,",  
                 "       ola21,occ01,occ02,ola06,'' ",    
                 #"  FROM ola_file, olc_file,OUTER occ_file ",   #MOD-920283
                 "  FROM ola_file LEFT OUTER JOIN olc_file ON ola01=olc29 LEFT OUTER JOIN occ_file ON ola05=occ01 ",   #MOD-920283
                 " WHERE olaconf !='X' " , #010806增
                 "   AND ola40 = 'N' ",    #MOD-C20084
                 "   AND ", tm.wc CLIPPED  
     IF tm.olc20 IS NOT NULL THEN
        LET l_sql = l_sql," AND olc_file.olc20 <= '",tm.olc20,"' " 
     ELSE 
        LET l_sql = l_sql," AND olc_file.olc20 <= '",g_today,"' "
     END IF
     #No.CHI-860029---End
     PREPARE axrr213_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
        EXIT PROGRAM
     END IF
     DECLARE axrr213_curs1 CURSOR FOR axrr213_prepare1
 
     CALL cl_outnam('axrr213') RETURNING l_name
 #    START REPORT axrr213_rep TO l_name                #No.FUN-7A0036
 
     LET g_pageno = 0
     FOREACH axrr213_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #No.CHI-860029---Begin
       IF tm.olc20 IS NULL THEN
          LET tm.olc20 = g_today 
       END IF 
       SELECT SUM(olc11),olc29 INTO sr.ola10,sr.olc29 FROM olc_file,ola_file
        WHERE  olc29=sr.ola01 AND ola01 = olc29 AND olaconf !='X' 
          AND  olc20 <= tm.olc20
        GROUP BY olc29
       #No.CHI-860029---End   
       IF cl_null(sr.ola09) THEN LET sr.ola09=0 END IF
       IF cl_null(sr.ola10) THEN LET sr.ola10=0 END IF
       IF (sr.ola09-sr.ola10) =0 THEN CONTINUE FOREACH END IF #表押匯餘額=0
{---->for 個案
       CASE WHEN sr.ola01[1,1]='M' LET sr.dept='MP'
            WHEN sr.ola01[1,1]='K' LET sr.dept='KB'
            WHEN sr.ola01[1,1]='U' LET sr.dept='UNIKEY'
            OTHERWISE              LET sr.dept=' '
       END CASE
}
#No.FUN-7A0036---Begin  
       SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05                     
         FROM azi_file                                                           
         WHERE azi01=sr.ola06                                                     
     # OUTPUT TO REPORT axrr213_rep(sr.*)    
      EXECUTE insert_prep USING   sr.ola01,sr.ola04,sr.ola05,
                                  sr.ola06,sr.ola09,sr.ola10,sr.ola14,
                                  sr.ola21,sr.occ01,sr.occ02,
                                  t_azi03,t_azi04,t_azi05      
#No.FUN-7A0036---End
     END FOREACH
#No.FUN-7A0036---Begin
#     FINISH REPORT axrr213_rep   
                                       
   IF g_zz05 = 'Y' THEN                                                         
      CALL cl_wcchp(tm.wc,'ola01,ola04,ola05')                                   
        RETURNING tm.wc
        LET g_str=tm.wc                                                         
   END IF                                                                       
 
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED           
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)   
   CALL cl_prt_cs3('axrr213','axrr213',l_sql,g_str)
#No.FUN-7A0036---End
END FUNCTION
 
#No.FUN-7A0036---Begin
{
REPORT axrr213_rep(sr)
   DEFINE 
          l_last_sw    LIKE type_file.chr1,     #No.FUN-680123 VARCHAR(1) 
          l_occ     LIKE occ_file.occ02,
         #l_curr               VARCHAR(4),
          l_curr    LIKE azi_file.azi01,        #No.FUN-680123 VARCHAR(4)
          l_amt1,l_amt2,amt3   LIKE type_file.num20_6,       #No.FUN-680123 DECIMAL(20,6)
          sr        RECORD
                    ola01     LIKE   ola_file.ola01 ,
                    dept      LIKE   type_file.chr6,        #No.FUN-680123 VARCHAR(06)
                    ola04     LIKE   ola_file.ola04 ,
                    ola05     LIKE   ola_file.ola05 ,
                    ola09     LIKE   ola_file.ola09 ,
                    ola10     LIKE   ola_file.ola10 ,
                    ola14     LIKE   ola_file.ola14 ,
                    ola21     LIKE   ola_file.ola21 ,
                    occ01     LIKE   occ_file.occ01 ,
                    occ02     LIKE   occ_file.occ02 ,
                    ola06     LIKE   ola_file.ola06
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
  ORDER BY sr.ola01,sr.ola06,sr.ola05
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
      PRINT g_dash1
      LET l_last_sw='n'
  BEFORE GROUP OF sr.ola01
     PRINT COLUMN g_c[31], sr.ola01;
     #SKIP TO TOP OF  PAGE
 
  ON EVERY ROW
      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05
        FROM azi_file
       WHERE azi01=sr.ola06
      PRINT COLUMN g_c[32], sr.occ01,
            COLUMN g_c[33], sr.occ02[1,8],
            COLUMN g_c[34], sr.ola21[1,15],
            COLUMN g_c[35], sr.ola04,
            COLUMN g_c[36], sr.ola14,
            COLUMN g_c[37], sr.ola06,
            COLUMN g_c[38], cl_numfor((sr.ola09-sr.ola10),38,t_azi04)
     #no.5196
      INSERT INTO curr_tmp VALUES(sr.ola06,sr.ola05,sr.ola09,sr.ola10)
     #no.5196(end)
 
  ON LAST ROW
     LET l_last_sw='y'
         #no.5196
     PRINT g_dash[1,g_len]
         DECLARE curr_temp1 CURSOR FOR
          SELECT curr,SUM(amt1),SUM(amt2) FROM curr_tmp
           #WHERE ola05=sr.ola05   #MOD-710209
           GROUP BY curr
         PRINT COLUMN g_c[34],g_x[9] CLIPPED;
         FOREACH curr_temp1 INTO l_curr,l_amt1,l_amt2
             SELECT azi05 into t_azi05
               FROM azi_file
               WHERE azi01=l_curr
         PRINT COLUMN g_c[37],l_curr CLIPPED,
               COLUMN g_c[38],cl_numfor(l_amt1-l_amt2,38,t_azi05)
         END FOREACH
         #no.5196(end)
 
  PAGE TRAILER
      PRINT g_dash[1,g_len]
      IF l_last_sw = 'n' THEN
         PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE
         PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      END IF
 
END REPORT
}
#No.FUN-7A0036---End
