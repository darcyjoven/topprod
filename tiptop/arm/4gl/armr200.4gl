# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: armr200.4gl
# Descriptions...: RMA期間材料成本明細表列印
# Date & Author..: 95/07/16 By Roger
# Modify.........: No.FUN-510044 05/02/02 By Mandy 報表轉XML
# Modify.........: No.FUN-570243 05/07/25 By jackie 料件編號欄位加CONTROLP
# Modify.........: No.FUN-580004 05/08/03 By wujie 雙單位報表格式修改
# Modify.........: No.TQC-610087 06/04/03 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/27 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: NO.FUN-860018 08/06/23 BY TSD.jarlin 舊報表轉CR報表
# Modify.........: No.FUN-870144 08/07/29 By chenmoyan 追單到31區 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-AB0089 11/02/25 By shenyang  修改本月平均單價 
# Modify.........: No.FUN-B80073 11/08/03 By minpp程序撰寫規範修改	
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題

DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580004--begin
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
END GLOBALS
#No.FUN-580004--end
   DEFINE tm  RECORD
              wc      LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(600),
              bdate   LIKE type_file.dat,     #No.FUN-690010 DATE,
              edate   LIKE type_file.dat,     #No.FUN-690010 DATE,
              more    LIKE type_file.chr1     #No.FUN-690010 VARCHAR(01)
              END RECORD,
          last_y,last_m LIKE type_file.num5    #No.FUN-690010 SMALLINT
#FUN-580004--begin
DEFINE g_sma115         LIKE sma_file.sma115
DEFINE l_sql            LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(1000)
DEFINE l_zaa02          LIKE zaa_file.zaa02
DEFINE i                LIKE type_file.num10   #No.FUN-690010 INTEGER
 
DEFINE  l_inb904    STRING              
DEFINE  l_inb907    STRING             
DEFINE  l_str2      LIKE type_file.chr14 
DEFINE  l_ima906    LIKE ima_file.ima906
#FUN-580004--end
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   l_table     STRING   #-----NO.FUN-860018 TSD.jarlin-------#
DEFINE   g_str       STRING   #-----NO.FUN-860018 TSD.jarlin-------#
DEFINE   g_sql       STRING   #-----NO.FUN-860018 TSD.jarlin-------#
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ARM")) THEN
      EXIT PROGRAM
   END IF
 
   #-----NO.FUN-860018 BY TSD.jarlin-----------(S)
    LET g_sql = "inb05.inb_file.inb05,",
                "ima06.ima_file.ima06,",
                "inb04.inb_file.inb04,",
                "inb08.inb_file.inb08,",
                "inb09.inb_file.inb09,",
                "inb13.inb_file.inb13,",
                "inb14.inb_file.inb14,",
                "inb902.inb_file.inb902,",
                "inb904.inb_file.inb904,",
                "inb905.inb_file.inb905,",
                "inb907.inb_file.inb907,",
                "ima02.ima_file.ima02,",
                "ima021.ima_file.ima021,",
                "azi03.azi_file.azi03,",
                "azi04.azi_file.azi04,",
                "azi05.azi_file.azi05,",
                "sma115.sma_file.sma115,",
                "l_str2.type_file.chr14"
    
   LET l_table = cl_prt_temptable('armr200',g_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALl cl_err('insert_prep:',status,1)
       EXIT PROGRAM
    END IF
    #-----NO.FUN-860018 BY TSD.jarlin---------------------(E)
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate  = ARG_VAL(8)
   LET tm.edate  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80073 ADD #FUN-BB0047 從IF中拉出
   IF cl_null(g_bgjob) OR g_bgjob='N'
      THEN CALL r200_tm(0,0)
      ELSE 
         CALL r200()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073 ADD #FUN-BB0047 從IF中拉出
END MAIN
 
FUNCTION r200_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 14
   ELSE LET p_row = 4 LET p_col = 12
   END IF
   OPEN WINDOW r200_w AT p_row,p_col
        WITH FORM "arm/42f/armr200"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON inb04,inb05
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
 
#No.FUN-570243  --start-
      ON ACTION CONTROLP
            IF INFIELD(inb04) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO inb04
               NEXT FIELD inb04
            END IF
#No.FUN-570243 --end--
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
         CLOSE WINDOW r200_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
         EXIT PROGRAM
      END IF
      IF tm.wc = " 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      IF tm.wc != ' 1=1' THEN EXIT WHILE END IF
      CALL cl_err('',9046,0)
   END WHILE
   DISPLAY BY NAME tm.bdate,tm.edate
   INPUT BY NAME tm.bdate,tm.edate,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
 
      AFTER FIELD edate
         IF cl_null(tm.edate) THEN NEXT FIELD edate END IF
         IF tm.edate < tm.bdate THEN
            CALL cl_err('armr200','aap-100',0)
            LET tm.edate=g_today
            DISPLAY tm.edate
            NEXT FIELD bdate
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
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r200_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='armr200'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('armr200','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",          #No.TQC-610087 add
                         " '",tm.edate CLIPPED,"'",          #No.TQC-610087 add       
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('armr200',g_time,l_cmd)
      END IF
      CLOSE WINDOW r200_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r200()
   ERROR ""
END WHILE
   CLOSE WINDOW r200_w
END FUNCTION
 
FUNCTION r200()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
          l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
          l_order   ARRAY[3] OF LIKE type_file.chr20,   #No.FUN-690010 VARCHAR(20),
          sr               RECORD inb05 LIKE inb_file.inb05,
                                  ima06 LIKE ima_file.ima06,
                                  inb04 LIKE inb_file.inb04,
                                  inb08 LIKE inb_file.inb08,
                                  inb09 LIKE inb_file.inb09,
                                  inb13 LIKE inb_file.inb13,
                                  inb14 LIKE inb_file.inb14,
                                  inb902 LIKE inb_file.inb902,     #No.FUN580004
                                  inb904 LIKE inb_file.inb904,     #No.FUN580004
                                  inb905 LIKE inb_file.inb905,     #No.FUN580004
                                  inb907 LIKE inb_file.inb907,     #No.FUN580004
                                  ima02 LIKE ima_file.ima02,
                                  ima021 LIKE ima_file.ima021
                        END RECORD
 
    #-----NO.FUN-860018 BY TSD.jarlin------------------------(S)
    CALL cl_del_data(l_table)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    #-----NO.FUN-860018--------------------------------------(E)
  
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
     #No.FUN-BB0047--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
#No.FUN-580004--begin
     SELECT sma115 INTO g_sma115 FROM sma_file
#No.FUN-580004--end
     LET g_pageno = 0
#--------------------------------------------------------------------
#No.CHI-6A0004-------Begin----------
#    SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
#           FROM azi_file WHERE azi01=g_aza.aza17
#No.CHI-6A0004------End------------
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND inauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND inagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND inagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('inauser', 'inagrup')
     #End:FUN-980030
 
     LET l_sql = " SELECT inb05, ima06, inb04, inb08, inb09, COALESCE(inb13,0)+COALESCE(inb132,0)
                  +COALESCE(inb133,0)+COALESCE(inb134,0)+COALESCE(inb135,0)+COALESCE(inb136,0)+COALESCE(inb137,0)+COALESCE(inb138,0)  , ",  #FUN-AB0089
                 "        inb14,inb902,inb904,inb905,inb907,ima02,ima021 ",    #No.FUN-580004
                 " FROM inb_file,ina_file, OUTER ima_file",
                 " WHERE inb01 = ina01 AND inb_file.inb04 = ima_file.ima01",
                 "   AND ina02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 "   AND inapost !='X' ",#mandy
                 "   AND ", tm.wc CLIPPED,
                 " ORDER BY 1,2,3 "
 
     PREPARE r200_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare1:',STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
        EXIT PROGRAM
      END IF
     DECLARE r200_curs1 CURSOR FOR r200_prepare1
     FOREACH r200_curs1 INTO sr.*
       IF sr.inb09 IS NULL THEN LET sr.inb09=0 END IF
       IF sr.inb13 IS NULL THEN LET sr.inb13=0 END IF      
       IF sr.inb14 IS NULL THEN LET sr.inb14=0 END IF
 
       #-----NO.FUN-860018 BY TSD.jarlin----------------(S)
       SELECT ima906 INTO l_ima906 FROM ima_file
                          WHERE ima01=sr.inb04
       LET l_str2 = ""
       IF g_sma115 = "Y" THEN
          CASE l_ima906
             WHEN "2"
                 CALL cl_remove_zero(sr.inb907) RETURNING l_inb907
                 LET l_str2 = l_inb907 , sr.inb905 CLIPPED
                 IF cl_null(sr.inb907) OR sr.inb907 = 0 THEN
                     CALL cl_remove_zero(sr.inb904) RETURNING l_inb904
                     LET l_str2 = l_inb904, sr.inb902 CLIPPED
                 ELSE
                    IF NOT cl_null(sr.inb904) AND sr.inb904 > 0 THEN
                       CALL cl_remove_zero(sr.inb904) RETURNING l_inb904
                       LET l_str2 = l_str2 CLIPPED,',',l_inb904, sr.inb902 CLIPPED
                 END IF
              END IF
              WHEN "3"
                  IF NOT cl_null(sr.inb907) AND sr.inb907 > 0 THEN
                     CALL cl_remove_zero(sr.inb907) RETURNING l_inb907
                     LET l_str2 = l_inb907 , sr.inb905 CLIPPED        
                   END IF      
          END CASE
       END IF
       EXECUTE insert_prep USING sr.inb05,sr.ima06,sr.inb04,sr.inb08,
                                 sr.inb09,sr.inb13,sr.inb14,sr.inb902,
                                 sr.inb904,sr.inb905,sr.inb907,sr.ima02,
                                 sr.ima021,g_azi03,g_azi04,g_azi05,
                                 g_sma115,l_str2  
       IF SQLCA.sqlcode THEN
          CALL cl_err('execute:',status,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
          EXIT PROGRAM
       END IF                                    
       #-----NO.FUN-860018------------------------------(E)
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
     END FOREACH
 
       #-----NO.FUN-860018 BY TSD.jarlin---------------(S)
       LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,
                    l_table CLIPPED,
                   " ORDER BY inb05,ima06,inb04"
       IF g_zz05 = 'Y' THEN
          CALL cl_wcchp(tm.wc,'inb04,inb05')
          RETURNING g_str
       ELSE
          LET g_str = ''
       END IF
CALL cl_prt_cs3('armr200','armr200',l_sql,g_str)
       #-----NO.FUN-860018------------------------------(E)
       #No.FUN-BB0047--mark--Begin---
       #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
       #No.FUN-BB0047--mark--End-----
END FUNCTION
#No.FUN-870144
