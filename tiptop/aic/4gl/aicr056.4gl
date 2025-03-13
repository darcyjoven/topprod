# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aicr056.4gl
# Descriptions...: 庫存數量表列印-icd
# Date & Author..: 2002/07/22 By bart (aicr056.4gl) #NO.FUN-BC0133

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc      STRING,                 
              #edate   LIKE type_file.dat,     
              #a       LIKE type_file.chr1,    #VARCHAR(1)
              more    LIKE type_file.chr1     #VARCHAR(1)
              END RECORD,
          i           LIKE type_file.num5,    #SMALLINT
          g_yy        LIKE type_file.num5,    #SMALLINT
          g_mm        LIKE type_file.num5,    #SMALLINT
          last_y      LIKE type_file.num5,    #SMALLINT
          last_m      LIKE type_file.num5,    #SMALLINT
          l_cnt       LIKE type_file.num5,    #SMALLINT
          #m_bdate     LIKE type_file.dat,     #DATE
          #m_edate     LIKE type_file.dat,     #DATE
          #l_imk09     LIKE imk_file.imk09,    
          l_flag      LIKE type_file.chr1     #VARCHAR(1)
 
DEFINE   g_chr        LIKE type_file.chr1     #VARCHAR(1)
DEFINE   g_i          LIKE type_file.num5     #count/index for any purpose  #SMALLINT
DEFINE   g_sql        STRING                  
DEFINE   g_str        STRING                  
DEFINE   l_table      STRING                  
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("aic")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET g_sql="img01.img_file.img01,ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,img02.img_file.img02,",
             "img03.img_file.img03,img04.img_file.img04,",
             "img10.img_file.img10,ima25.ima_file.ima25,",
             "idc05.idc_file.idc05,idc06.idc_file.idc06,",  #NO.FUN-BC0133
             "idc08.idc_file.idc08,idc11.idc_file.idc11,",  #NO.FUN-BC0133
             "idc07.idc_file.idc07"                         #NO.FUN-BC0133
 
   LET l_table = cl_prt_temptable('aicr056',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED, 
               " VALUES(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?)"     #NO.FUN-BC0133
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #LET tm.edate = ARG_VAL(8)   
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
       CALL r056_tm(0,0)
   ELSE
       CALL r056()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION r056_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,   #No.FUN-690026 SMALLINT
       l_cmd          LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 4 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 12
   END IF
   OPEN WINDOW r056_w AT p_row,p_col
        WITH FORM "aic/42f/aicr056"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   #LET tm.edate = g_today
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON img01,img02,img03,img04,idc11
 
#No.FUN-570240 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION controlp
            IF INFIELD(img01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO img01
               NEXT FIELD img01
            END IF
#No.FUN-570240 --end
 
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
 
 
         ON ACTION EXIT
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
         LET INT_FLAG = 0
         CLOSE WINDOW r056_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
         EXIT PROGRAM
      END IF
      IF tm.wc = " 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      IF tm.wc != ' 1=1' THEN EXIT WHILE END IF
      CALL cl_err('',9046,0)
   END WHILE
   DISPLAY BY NAME tm.more # Condition
   INPUT BY NAME tm.more WITHOUT DEFAULTS
      #No.FUN-580031 --start--
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      AFTER INPUT
         IF  INT_FLAG THEN EXIT INPUT END IF
         LET l_flag = 'N'

         IF  cl_null(tm.more) OR tm.more NOT MATCHES '[YN]' THEN
             LET l_flag = 'Y'
             DISPLAY BY NAME tm.more
         END IF
         IF  l_flag = 'Y' THEN
             CALL cl_err('','9033',0)
             NEXT FIELD more
         END IF
################################################################################
# START genero shell script ADD
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()
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
   IF  INT_FLAG THEN
       LET INT_FLAG = 0
       CLOSE WINDOW r056_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
       EXIT PROGRAM
   END IF
 
   LET last_y = g_yy LET last_m = g_mm - 1
   IF last_m = 0 THEN LET last_y = last_y - 1 LET last_m = 12 END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='aicr056'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aicr056','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         #" '",tm.edate CLIPPED,"'",             #TQC-610072
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aicr056',g_time,l_cmd)
      END IF
      CLOSE WINDOW r056_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r056()
   ERROR ""
END WHILE
   CLOSE WINDOW r056_w
END FUNCTION
 
FUNCTION r056()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0074
          #l_sql     LIKE type_file.chr1000, # RDSQL STATEMENT  #No.FUN-690026 VARCHAR(1000)
          l_sql     STRING,                 #MOD-8C0015
          l_chr     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_za05    LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
          sr        RECORD
                    img01 LIKE img_file.img01,   #--料號
                    img02 LIKE img_file.img02,   #--倉
                    img03 LIKE img_file.img03,   #--儲
                    img04 LIKE img_file.img04,   #--批
                    img10 LIKE img_file.img10,   #--出入庫量
                    ima25 LIKE ima_file.ima25,   #--料件主檔單位
                    #imk09 LIKE imk_file.imk09,   #--上期期末庫存
                    #tmp01 LIKE imk_file.imk05,   #--上期期末年度  # SMALLINT
                    #tmp02 LIKE imk_file.imk06,   #--上期期末期別  # SMALLINT
                    idc05 LIKE idc_file.idc05,   #刻號
                    idc06 LIKE idc_file.idc06,   #BIN
                    idc08 LIKE idc_file.idc08,   #數量
                    idc11 LIKE idc_file.idc11,   #datecode
                    idc07 LIKE idc_file.idc07    #單位
                    END RECORD,
          l_img09       LIKE img_file.img09,     #--來源單位
          l_img2ima_fac LIKE ima_file.ima31_fac  #--轉換率 
   DEFINE l_ima02   LIKE ima_file.ima02,        
          l_ima021  LIKE ima_file.ima021        
 
   CALL cl_del_data(l_table)                   
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
 
   IF cl_null(tm.wc) THEN LET tm.wc=" 1=1" END IF

   LET l_sql = " SELECT img01,img02,img03,img04,img10,'',idc05,idc06,idc08,idc11,idc07 ",
                "   FROM img_file, idc_file",
               "  WHERE img01=idc01 AND img02=idc02 ",
               "    AND img03=idc03 AND img04=idc04 ",
               "    AND ",tm.wc CLIPPED

   PREPARE r056_prepare1 FROM l_sql 
   
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      RETURN
   END IF 
   
   DECLARE r056_curs1 CURSOR FOR r056_prepare1
   
   FOREACH r056_curs1 INTO sr.*
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
     END IF

     
        SELECT ima02,ima021,ima25 INTO l_ima02,l_ima021,sr.ima25 FROM ima_file                   
              WHERE ima01 = sr.img01                                                
        IF SQLCA.sqlcode THEN                                                     
           LET l_ima02 = ' '                                                     
           LET l_ima021 = ' '
           LET sr.ima25 = NULL
        END IF 
        
   EXECUTE insert_prep USING sr.img01,l_ima02,l_ima021,sr.img02,sr.img03,
                             sr.img04,sr.img10,sr.ima25,
                             sr.idc05,sr.idc06,sr.idc08,sr.idc11,sr.idc07  #NO.FUN-BC0133

   END FOREACH

     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'img01,img02,img03,img04,idc11')   #NO.FUN-BC0133
             RETURNING tm.wc
     END IF
      
     LET g_str = tm.wc
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
     CALL cl_prt_cs3('aicr056','aicr056',l_sql,g_str)

END FUNCTION
#NO.FUN-BC0133
