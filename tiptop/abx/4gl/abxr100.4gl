# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abxr100.4gl
# Descriptions...: 放行單列印-套表
# Date & Author..: 96/08/02 By STAR
# Modify.........: No.FUN-550033 05/05/19 By wujie 單據編號加大
# Modify.........: No.MOD-5A0105 05/10/14 By ice 報表寬度錯誤
# Modify.........: No.TQC-610081 06/04/20 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.TQC-660042 06/06/21 By Pengu 列印格式有問題
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0007 06/10/23 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.CHI-6A0004 06/10/26 By Jackho  本（原）幣取位修改
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-6A0083 06/11/09 By xumin 報表寬度不符問題更正 
# Modify.........: No.FUN-710085 07/03/13 By Rayven 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730113 07/03/26 By Nicole 增加CR參數
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A50206 10/05/31 By Sarah 不勾選依保稅群組列印的話,應該不用串bxe_file
# Modify.........: No:MOD-A80001 10/08/02 By Sarah 資料無法寫入ds_report的Temptable
# Modify.........: No.TQC-C10034 12/01/14 By zhuhao 簽核處理
# Modify.........: No.TQC-C20048 12/02/09 By zhuhao 簽核處理還原
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,   # Where condition                     #No.FUN-680062      VARCHAR(1000)
              type    LIKE type_file.chr1,   #FUN-6A0007
              more    LIKE type_file.chr1           # Input more condition(Y/N)       #No.FUN-680062      VARCHAR(1)   
              END RECORD,
          g_mount     LIKE type_file.num10,                                           #No.FUN-680062      integer
          g_chars     LIKE type_file.chr8,                                            #No.FUN-680062      VARCHAR(10)   
          g_dash1_1   LIKE type_file.chr1000		# Dash line                   #No.FUN-680062      VARCHAR(400)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose         #No.FUN-680062      smallint
DEFINE   l_table         STRING                  #No.FUN-710085
DEFINE   g_sql           STRING                  #No.FUN-710085
DEFINE   g_str           STRING                  #No.FUN-710085
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690108
 
   #No.FUN-710085 --start--
   LET g_sql = "bna06.bna_file.bna06,bnb01.bnb_file.bnb01,",
               "bnb02.bnb_file.bnb02,bnb03.bnb_file.bnb03,",
               "bnb04.bnb_file.bnb04,bnb06.bnb_file.bnb06,",
               "bnb07.bnb_file.bnb07,bnb09.bnb_file.bnb09,",
               "bnb11_1.type_file.chr4,bnb11_2.type_file.chr2,",
               "bnb11_3.type_file.chr2,bnb14.bnb_file.bnb14,",
               "bnb15.bnb_file.bnb15,bnb16.bnb_file.bnb16,",
               "bnc03.bnc_file.bnc03,bnc04.bnc_file.bnc04,",
               "bnc05.bnc_file.bnc05,bnc06.bnc_file.bnc06,",
               "bnc07.bnc_file.bnc07,bnc08.bnc_file.bnc08,",
               "bnc09.bnc_file.bnc09,ima1916.ima_file.ima1916"
              #TQC-C20048--mark--begin
              #TQC-C10034--add--begin
              #"sign_type.type_file.chr1,", 
              #"sign_img.type_file.blob,",      
              #"sign_show.type_file.chr1,",
              #"sign_str.type_file.chr1000"
              #TQC-C10034--add--end
              #TQC-C20048--mark--end
   LET l_table = cl_prt_temptable('abxr100',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,   #MOD-A80001 mod
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)" #,?,?,?, ?)"#TQC-C10034 add 4? #TQC-C20048--mark
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-710085 --end--
 
   INITIALIZE tm.* TO NULL            # Default condition
#--------------No.TQC-610081 modify
#  LET tm.more = 'N'
#  LET g_pdate = g_today
#  LET g_rlang = g_lang
#  LET g_bgjob = 'N'
#  LET g_copies = '1'
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#--------------No.TQC-610081 end
   IF cl_null(tm.wc)
      THEN CALL abxr100_tm(4,17)        # Input print condition
      ELSE 
        #LET tm.wc = "bnb01 ='",tm.wc CLIPPED,"'"    #No.TQC-610081 mark
         CALL abxr100()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION abxr100_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680062  SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680062  VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 8 LET p_col = 22
   ELSE LET p_row = 5 LET p_col = 15
   END IF
 
   OPEN WINDOW abxr100_w AT p_row,p_col
        WITH FORM "abx/42f/abxr100"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = '1=1'
   LET tm.more = 'N'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON bnb01,ima1916 #FUN-6A0007
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
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   LET tm.type = 'N'
   INPUT BY NAME tm.type,tm.more #FUN-6A0007
   WITHOUT DEFAULTS
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
      LET INT_FLAG = 0 CLOSE WINDOW abxr100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='abxr100'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abxr100','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('abxr100',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW abxr100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abxr100()
   ERROR ""
END WHILE
   CLOSE WINDOW abxr100_w
END FUNCTION
 
FUNCTION abxr100()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name             #No.FUN-680062      VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0062
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT #No.FUN-680062 VARCHAR(1000)      
          l_chr     LIKE type_file.chr1,          #No.FUN-680062  VARCHAR(1)  
          l_za05    LIKE za_file.za05,            #No.FUN-680062  VARCHAR(40)      
          l_sfs03   LIKE sfs_file.sfs03,
          l_oga16   LIKE oga_file.oga16,
          sr               RECORD
                                  bnb01  LIKE bnb_file.bnb01,
                                  bnb02  LIKE bnb_file.bnb02,
                                  bnb03  LIKE bnb_file.bnb03,
                                  bnb04  LIKE bnb_file.bnb04,
                                  bnb05  LIKE bnb_file.bnb05,
                                  bnb06  LIKE bnb_file.bnb06,
                                  bnb07  LIKE bnb_file.bnb07,
                                  bnb08  LIKE bnb_file.bnb08,
                                  bnb09  LIKE bnb_file.bnb09,
                                  bnb11  LIKE bnb_file.bnb11,
                                  bnb14  LIKE bnb_file.bnb14,
                                  bnb15  LIKE bnb_file.bnb15,
                                  bnc02  LIKE bnc_file.bnc02,
                                  bnc03  LIKE bnc_file.bnc03,
                                  bnc04  LIKE bnc_file.bnc04,
                                  bnc05  LIKE bnc_file.bnc05,
                                  bnc06  LIKE bnc_file.bnc06,
                                  bnc07  LIKE bnc_file.bnc07,
                                  bnc08  LIKE bnc_file.bnc08,
                                  bnc09  LIKE bnc_file.bnc09,
                                  bnc10  LIKE bnc_file.bnc10,
                                  bna06  LIKE bna_file.bna06,
                                  code   LIKE bnb_file.bnb01,        #No.FUN-550033      #No.FUN-680062      VARCHAR(16)   
                                  code1  LIKE bnb_file.bnb01,        #No.FUN-550033      #No.FUN-680062       VARCHAR(16)  
                                  bnb16  LIKE bnb_file.bnb16,
                                  ima1916  LIKE ima_file.ima1916,  #FUN-6A0007
                   bxe02  LIKE bxe_file.bxe02,  #群組品名 
                   bxe03  LIKE bxe_file.bxe03,  #群組規格 
                   bxe04  LIKE bxe_file.bxe04   #群組單位 
                        END RECORD
   #No.FUN-710085 --start--
   DEFINE l_bnb15         LIKE bnb_file.bnb15
   DEFINE l_bnb16         LIKE bnb_file.bnb16
   DEFINE l_bnb11_1       LIKE type_file.chr4
   DEFINE l_bnb11_2       LIKE type_file.chr2
   DEFINE l_bnb11_3       LIKE type_file.chr2
   #No.FUN-710085 --end--
#TQC-C20048--mark--begin
   #TQC-C10034---add--begin
  #DEFINE l_img_blob     LIKE type_file.blob
  #LOCATE l_img_blob IN MEMORY
   #TQC-C10034---add--end
#TQC-C20048--mark--end
   CALL cl_del_data(l_table)  #No.FUN-710085
 
  #----------------No.TQC-660042 modfiy
  #LET g_len = 67
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'abxr100'
  #----------------No.TQC-660042 modfiy
 
   IF tm.type = 'Y' THEN   #依保稅群組列印   #MOD-A50206 add
      LET l_sql = "SELECT bnb01,bnb02,bnb03,bnb04,bnb05,bnb06, ",
                  "       bnb07,bnb08,bnb09,bnb11,bnb14,bnb15,bnc02,bnc03, ",
                  "       bnc04,bnc05,bnc06,bnc07,bnc08,bnc09, ",
                  "       bnc10,bna06,' ',' ',bnb16,           ",
                  " ima1916, bxe02, bxe03, bxe04 ",    #FUN-6A0007
                  "  FROM bnb_file, bnc_file, bna_file,",
                  "       ima_file, bxe_file  ",  #FUN-6A0007
                  " WHERE bnb01 = bnc01 ",
                  "   AND bnc03 = ima01 ",           #FUN-6A0007
                  "   AND ima1916 = bxe01 ",   #FUN-6A0007
                 #"   AND bna01 = bnb01[1,3] ",            #No.FUN-550033
                  "   AND bnb01 like rtrim(bna01)||'-%' ",  #No.FUN-550033
                  "   AND ",tm.wc CLIPPED
  #str MOD-A50206 add
   ELSE
      #不勾選依保稅群組列印的話,應該不用串bxe_file
      LET l_sql = "SELECT bnb01,bnb02,bnb03,bnb04,bnb05,bnb06, ",
                  "       bnb07,bnb08,bnb09,bnb11,bnb14,bnb15,bnc02,bnc03, ",
                  "       bnc04,bnc05,bnc06,bnc07,bnc08,bnc09, ",
                  "       bnc10,bna06,' ',' ',bnb16,           ",
                  "       ima1916, '', '', '' ",  #FUN-6A0007
                  "  FROM bnb_file, bnc_file, bna_file,",
                  "       ima_file  ",  #FUN-6A0007
                  " WHERE bnb01 = bnc01 ",
                  "   AND bnc03 = ima01 ",           #FUN-6A0007
                 #"   AND bna01 = bnb01[1,3] ",            #No.FUN-550033
                  "   AND bnb01 like trim(bna01)||'-%' ",  #No.FUN-550033
                  "   AND ",tm.wc CLIPPED
   END IF
  #end MOD-A50206 add

   PREPARE abxr100_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
   END IF
   DECLARE abxr100_curs1 CURSOR FOR abxr100_prepare1

#No.CHI-6A0004--mark                 
#  SELECT azi03,azi04,azi05
#    INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#    FROM azi_file
#   WHERE azi01=g_aza.aza17
#No.CHI-6A0004--mark                 
 
#No.FUN-710085 --start-- mark
#  CALL cl_outnam('abxr100') RETURNING l_name
#  IF g_len = 0 OR g_len IS NULL THEN LET g_len = 100 END IF
#  FOR g_i = 1 TO g_len LET g_dash1_1[g_i,g_i] = '=' END FOR
# 
#  IF tm.type = 'Y' THEN
#     START REPORT abxr100_rep2 TO l_name
#  ELSE
#     START REPORT abxr100_rep TO l_name
#  END IF
# 
#  LET g_pageno = 0
#  LET g_mount = 0
#No.FUN-710085 --end--
   FOREACH abxr100_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      # 若前面user 按下 control-t 則會顯示目前做到第 n 筆
      IF cl_null(sr.bnb16) THEN LET sr.bnb16 = ' ' END IF
      IF sr.bnb03 = '2' THEN
         SELECT oga16 INTO l_oga16 FROM oga_file
          WHERE oga01 = sr.bnb04
         IF STATUS THEN LET l_oga16 = ' ' END IF
         LET sr.code1 = l_oga16
      END IF
      IF cl_null(sr.bnc06) THEN LET sr.bnc06 = 0 END IF
      IF cl_null(sr.bnc08) THEN LET sr.bnc08 = 0 END IF
      IF cl_null(sr.bnc09) THEN LET sr.bnc09 = 0 END IF
      IF cl_null(sr.bnc10) THEN LET sr.bnc10 = 0 END IF
 
      IF tm.type = 'Y' THEN 
         #No.FUN-710085 --start--
         LET sr.bnc03  = sr.ima1916
         LET sr.bnc05  = sr.bxe04
         LET sr.bnc04 =  sr.bxe02
         LET l_bnb15=sr.bnb15
         LET l_bnb16=sr.bnb16
         IF cl_null(l_bnb15) THEN
         SELECT bnb15 INTO l_bnb15 FROM bnb_file
            WHERE l_bnb16=bnb16 AND bnb15 IS NOT NULL AND bnb15<>' '
         END IF
         LET l_bnb11_1 = YEAR(sr.bnb11)
         LET l_bnb11_2 = MONTH(sr.bnb11)
         LET l_bnb11_3 = DAY(sr.bnb11)
 
         EXECUTE insert_prep USING sr.bna06,sr.bnb01,sr.bnb02,sr.bnb03,
                                   sr.bnb04,sr.bnb06,sr.bnb07,sr.bnb09,
                                   l_bnb11_1,l_bnb11_2,l_bnb11_3,sr.bnb14,
                                   l_bnb15,sr.bnb16,sr.bnc03,sr.bnc04,
                                   sr.bnc05,sr.bnc06,sr.bnc07,sr.bnc08,
                                   sr.bnc09,sr.ima1916
                                  #"",  l_img_blob,   "N",""     #TQC-C10034 add   #TQC-C20048--mark
         #No.FUN-710085 --end--
 
#        OUTPUT TO REPORT abxr100_rep2(sr.*)  #No.FUN-710085 mark
      ELSE 
         #No.FUN-710085 --start--
         LET l_bnb15=sr.bnb15
         LET l_bnb16=sr.bnb16
         IF cl_null(l_bnb15) THEN
         SELECT bnb15 INTO l_bnb15 FROM bnb_file
            WHERE l_bnb16=bnb16 AND bnb15 IS NOT NULL AND bnb15<>' '
         END IF
         LET l_bnb11_1 = YEAR(sr.bnb11)
         LET l_bnb11_2 = MONTH(sr.bnb11)
         LET l_bnb11_3 = DAY(sr.bnb11)
 
         EXECUTE insert_prep USING sr.bna06,sr.bnb01,sr.bnb02,sr.bnb03,
                                   sr.bnb04,sr.bnb06,sr.bnb07,sr.bnb09,
                                   l_bnb11_1,l_bnb11_2,l_bnb11_3,sr.bnb14,
                                   l_bnb15,sr.bnb16,sr.bnc03,sr.bnc04,
                                   sr.bnc05,sr.bnc06,sr.bnc07,sr.bnc08,
                                   sr.bnc09,sr.ima1916
                                  #"",  l_img_blob,   "N",""     #TQC-C10034 add #TQC-C20048--mark
         #No.FUN-710085 --end--
 
#        OUTPUT TO REPORT abxr100_rep(sr.*)   #No.FUN-710085 mark
      END IF
   END FOREACH
#TQC-C20048--mark--begin
   #TQC-C10034--add--begin
#  LET g_cr_table = l_table
#  LET g_cr_apr_key_f = "bnb01"
   #TQC-C10034--add--end
##TQC-C20048--mark--end
   IF tm.type = 'Y' THEN 
      #No.FUN-710085 --start--                                                                                                       
    # LET l_sql = "SELECT * FROM ",l_table CLIPPED   #TQC-730113
    # CALL cl_prt_cs3('abxr1002',l_sql,'')
      LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED 
      CALL cl_prt_cs3('abxr100','abxr1002',l_sql,'')
      #No.FUN-710085 --end--
 
#     FINISH REPORT abxr100_rep2              #No.FUN-710085 mark
   ELSE  
      #No.FUN-710085 --start--                                                                                                       
    # LET l_sql = "SELECT * FROM ",l_table CLIPPED   #TQC-730113
    # CALL cl_prt_cs3('abxr1001',l_sql,'')
      LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   
      CALL cl_prt_cs3('abxr100','abxr1001',l_sql,'')
      #No.FUN-710085 --end--
 
#     FINISH REPORT abxr100_rep               #No.FUN-710085 mark
   END IF
 
#  CALL cl_prt(l_name,g_prtway,g_copies,100) #No.FUN-710085 mark
END FUNCTION
 
REPORT abxr100_rep(sr) 
   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680062     VARCHAR(1)     
          l_len        LIKE type_file.num5,          #No.FUN-680062     smallint 
          i            LIKE type_file.num5,          #No.FUN-680062     smallint
          l_n          LIKE type_file.num5,          #No.FUN-680062     smallint
          l_money      LIKE type_file.num20_6,       #No.FUN-680062     dec(20,6)
          l_moneyoth   LIKE type_file.num20_6,       #No.FUN-680062     dec(20,6)
          l_head       LIKE zaa_file.zaa08,          #No.FUN-680062     VARCHAR(10)
          l_if         LIKE type_file.num5,          #No.FUN-680062     smallint  
          l_bnb01  LIKE bnb_file.bnb01,
          l_bnb15  LIKE bnb_file.bnb15,
          l_bnb16  LIKE bnb_file.bnb16,
          sr               RECORD
                                  bnb01  LIKE bnb_file.bnb01,
                                  bnb02  LIKE bnb_file.bnb02,
                                  bnb03  LIKE bnb_file.bnb03,
                                  bnb04  LIKE bnb_file.bnb04,
                                  bnb05  LIKE bnb_file.bnb05,
                                  bnb06  LIKE bnb_file.bnb06,
                                  bnb07  LIKE bnb_file.bnb07,
                                  bnb08  LIKE bnb_file.bnb08,
                                  bnb09  LIKE bnb_file.bnb09,
                                  bnb11  LIKE bnb_file.bnb11,
                                  bnb14  LIKE bnb_file.bnb14,
                                  bnb15  LIKE bnb_file.bnb15,
                                  bnc02  LIKE bnc_file.bnc02,
                                  bnc03  LIKE bnc_file.bnc03,
                                  bnc04  LIKE bnc_file.bnc04,
                                  bnc05  LIKE bnc_file.bnc05,
                                  bnc06  LIKE bnc_file.bnc06,
                                  bnc07  LIKE bnc_file.bnc07,
                                  bnc08  LIKE bnc_file.bnc08,
                                  bnc09  LIKE bnc_file.bnc09,
                                  bnc10  LIKE bnc_file.bnc10,
                                  bna06  LIKE bna_file.bna06,
                                  code   LIKE bnb_file.bnb01,        #No.FUN-550033   #No.FUN-680062 VARCHAR(16)
                                  code1  LIKE bnb_file.bnb01,        #No.FUN-550033   #No.FUN-680062 VARCHAR(16)
                                  bnb16  LIKE bnb_file.bnb16,
                                  ima1916  LIKE ima_file.ima1916,  #FUN-6A0007
                                  bxe02  LIKE bxe_file.bxe02,  #群組品名  #FUN-6A0007
                                  bxe03  LIKE bxe_file.bxe03,  #群組規格  #FUN-6A0007
                                  bxe04  LIKE bxe_file.bxe04   #群組單位  #FUN-6A0007
                        END RECORD 
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.bnb01,sr.bnb02
  FORMAT
   PAGE HEADER
         SKIP 3 LINE
         PRINT '~l6x5;',COLUMN 85,sr.bnb01   #TQC-6A0083
         SKIP 1 LINE
         PRINT COLUMN 83,sr.bnb02 CLIPPED #TQC-6A0083
         SKIP 3 LINE
 
   BEFORE GROUP OF sr.bnb01
         LET l_n = 0
         LET i   = 0
         LET l_money = 0
         LET l_moneyoth = 0
         CASE
             WHEN sr.bna06 = '1'
                  LET l_head = g_x[11]
             WHEN sr.bna06 = '2'
                  LET l_head = g_x[12]
             WHEN sr.bna06 = '3'
                  LET l_head = g_x[13]
             OTHERWISE
                  LET l_head = ' '
         END CASE
 
   ON EVERY ROW
      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05                #No.CHI-6A0004 g_azi-->t_azi 
        FROM azi_file WHERE azi01=sr.bnc07
 
      IF NOT cl_null(sr.bnc03) THEN
         PRINT COLUMN  5,sr.bnb16 CLIPPED;   #TQC-6A0083
         PRINT COLUMN 23,sr.bnc03 CLIPPED;   #TQC-6A0083
         IF sr.bnb03 = '1' THEN
            PRINT COLUMN 70,sr.bnc06 USING '########&',
                  COLUMN 80,sr.bnc05 CLIPPED  #TQC-6A0083
         ELSE
            PRINT COLUMN 70,sr.bnc06 USING '########&',
                  COLUMN 80,sr.bnc05 CLIPPED, #TQC-6A0083
                  COLUMN 86,sr.bnc06*sr.bnc08 USING '####,###.##'
         END IF
         PRINT COLUMN  5,sr.bnb04 CLIPPED;  #TQC-6A0083
         PRINT COLUMN 24,sr.bnc04 CLIPPED   #TQC-6A0083
      ELSE
         PRINT COLUMN 19,sr.bnc04 CLIPPED,  #TQC-6A0083
               COLUMN 70,sr.bnc06 USING '########&',' ',
               COLUMN 80,sr.bnc05 CLIPPED,  #TQC-6A0083
               COLUMN 86,sr.bnc06 * sr.bnc08 USING '####,###.##'
         PRINT
     END IF
            LET l_moneyoth = l_moneyoth + ( sr.bnc06 * sr.bnc08 )
            LET l_money    = l_money + (sr.bnc06 * sr.bnc08 * sr.bnc09)
         LET l_n = l_n + 1
         IF l_n = 11 THEN
            SKIP TO TOP OF PAGE
         END IF
 
   AFTER GROUP OF sr.bnb01
         FOR i = l_n + 1 TO 10
             SKIP 2 LINES
         END FOR
#        PRINT COLUMN 17,g_dash1[1,g_len] CLIPPED
        #PRINT COLUMN 17,g_dash1 CLIPPED    #No.MOD-5A0105   #No.TQC-660042 mark
         PRINT COLUMN 17,g_dash1_1[1,(g_len - 18)] CLIPPED   #No.TQC-660042 modify
         PRINT COLUMN 20,g_x[14] CLIPPED,sr.bnb14 USING '<<<<&',g_x[15] CLIPPED;
         IF sr.bnb03 != '1' AND l_money<>0 THEN
            PRINT COLUMN 36,g_x[16],sr.bnc07 CLIPPED,l_moneyoth USING '<<<,<<<,<<&.&&';   #TQC-6A0083
            IF l_moneyoth<>l_money THEN
               PRINT ' (NTD ', l_money USING '<<<,<<<,<<&.&&',')'
            END IF
         ELSE
            PRINT ' '
         END IF
 
   ON LAST ROW
      LET l_if = 1
 
   PAGE TRAILER
        SKIP 2 LINE
        PRINT COLUMN 30,l_head CLIPPED  #TQC-6A0083
        SKIP 2 LINES 
        PRINT COLUMN 30,sr.bnb09 CLIPPED  #TQC-6A0083
        PRINT
        LET l_bnb15=sr.bnb15
        LET l_bnb16=sr.bnb16
        IF cl_null(l_bnb15) THEN
        SELECT bnb15 INTO l_bnb15 FROM bnb_file
           WHERE l_bnb16=bnb16 AND bnb15 IS NOT NULL AND bnb15<>' '
        END IF
        PRINT COLUMN 30,l_bnb15 CLIPPED  #TQC-6A0083
        PRINT
        PRINT COLUMN 17,sr.bnb06 CLIPPED,' ',
                        sr.bnb07 CLIPPED   #TQC-6A0083
        PRINT
        PRINT COLUMN 20,YEAR(sr.bnb11),
              COLUMN 35,MONTH(sr.bnb11),
              COLUMN 50,DAY(sr.bnb11)
        LET l_n = 0
END REPORT
 
#FUN-6A0007 依保稅群組列印
REPORT abxr100_rep2(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,
          l_len        LIKE type_file.num5,
          i            LIKE type_file.num5,
          l_n          LIKE type_file.num5,
          l_money      LIKE type_file.num20_6,
          l_moneyoth   LIKE type_file.num20_6,
          l_head       LIKE zaa_file.zaa08,
          l_if         LIKE type_file.num5,
          l_bnb01  LIKE bnb_file.bnb01,
          l_bnb15  LIKE bnb_file.bnb15,
          l_bnb16  LIKE bnb_file.bnb16,
          l_bnc06  LIKE bnc_file.bnc06,
          l_amt_68,l_amt_689 LIKE bnc_file.bnc10,
          sr               RECORD
                                  bnb01  LIKE bnb_file.bnb01,
                                  bnb02  LIKE bnb_file.bnb02,
                                  bnb03  LIKE bnb_file.bnb03,
                                  bnb04  LIKE bnb_file.bnb04,
                                  bnb05  LIKE bnb_file.bnb05,
                                  bnb06  LIKE bnb_file.bnb06,
                                  bnb07  LIKE bnb_file.bnb07,
                                  bnb08  LIKE bnb_file.bnb08,
                                  bnb09  LIKE bnb_file.bnb09,
                                  bnb11  LIKE bnb_file.bnb11,
                                  bnb14  LIKE bnb_file.bnb14,
                                  bnb15  LIKE bnb_file.bnb15,
                                  bnc02  LIKE bnc_file.bnc02,
                                  bnc03  LIKE bnc_file.bnc03,
                                  bnc04  LIKE bnc_file.bnc04,
                                  bnc05  LIKE bnc_file.bnc05,
                                  bnc06  LIKE bnc_file.bnc06,
                                  bnc07  LIKE bnc_file.bnc07,
                                  bnc08  LIKE bnc_file.bnc08,
                                  bnc09  LIKE bnc_file.bnc09,
                                  bnc10  LIKE bnc_file.bnc10,
                                  bna06  LIKE bna_file.bna06,
                                  code   LIKE bnb_file.bnb01,        #No.FUN-550033
                                  code1  LIKE bnb_file.bnb01,        #No.FUN-550033
                                  bnb16  LIKE bnb_file.bnb16,
                                  ima1916  LIKE ima_file.ima1916,
                                  bxe02  LIKE bxe_file.bxe02,  #群組品名 
                                  bxe03  LIKE bxe_file.bxe03,  #群組規格 
                                  bxe04  LIKE bxe_file.bxe04   #群組單位 
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
# ORDER BY sr.bnb01,sr.bnb02
 
  ORDER BY sr.bnb01,sr.ima1916
  FORMAT
   PAGE HEADER
         SKIP 3 LINE
         PRINT '~l6x5;',COLUMN 85,sr.bnb01 CLIPPED #TQC-6A0083
         SKIP 1 LINE
         PRINT COLUMN 83,sr.bnb02 CLIPPED  #TQC-6A0083
         SKIP 3 LINE
 
   BEFORE GROUP OF sr.bnb01
         LET l_n = 0
         LET i   = 0
         LET l_money = 0
         LET l_moneyoth = 0
         CASE
             WHEN sr.bna06 = '1'
                  LET l_head = g_x[11]
             WHEN sr.bna06 = '2'
                  LET l_head = g_x[12]
             WHEN sr.bna06 = '3'
                  LET l_head = g_x[13]
             OTHERWISE
                  LET l_head = ' '
         END CASE
 
   AFTER GROUP OF sr.ima1916  
      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05              #No.CHI-6A0004 g_azi-->t_azi
        FROM azi_file WHERE azi01=sr.bnc07
 
      #-->做替換動作
        LET sr.bnc03  = sr.ima1916            #料號   
        LET l_bnc06   = GROUP SUM(sr.bnc06)     #數量
        LET sr.bnc05  = sr.bxe04            #單位   
        LET l_amt_68  = GROUP SUM(sr.bnc06*sr.bnc08) #數量*單價
        LET sr.bnc04 =  sr.bxe02            #品名
        LET l_amt_689 = GROUP SUM(sr.bnc06 * sr.bnc08 * sr.bnc09)
  
      IF NOT cl_null(sr.bnc03) THEN   #料號
         PRINT COLUMN  5,sr.bnb16 CLIPPED;    #工單  #TQC-6A0083
         PRINT COLUMN 23,sr.bnc03 CLIPPED;    #料號  #TQC-6A0083
         IF sr.bnb03 = '1' THEN
            PRINT COLUMN 70,l_bnc06  USING '########&',    #數量
                  COLUMN 80,sr.bnc05 CLIPPED               #單位  #TQC-6A0083
         ELSE
            PRINT COLUMN 70,sr.bnc06 USING '########&',
                  COLUMN 80,sr.bnc05 CLIPPED,   #TQC-6A0083
                  COLUMN 86,l_amt_68          USING '####,###.##'
         END IF
         PRINT COLUMN 24,sr.bnc04 CLIPPED   #品名規格  #TQC-6A0083
 
      ELSE
         PRINT COLUMN 19,sr.bnc04 CLIPPED,  #TQC-6A0083
               COLUMN 70,sr.bnc06 USING '########&',' ',
               COLUMN 80,sr.bnc05 CLIPPED,   #TQC-6A0083
               COLUMN 86,l_amt_68            USING '####,###.##'
         PRINT
     END IF
            LET l_moneyoth = l_moneyoth + l_amt_68
            LET l_money    = l_money + l_amt_689
         LET l_n = l_n + 1
         IF l_n = 11 THEN
            SKIP TO TOP OF PAGE
         END IF
 
   AFTER GROUP OF sr.bnb01
         FOR i = l_n + 1 TO 10
             SKIP 2 LINES
         END FOR
         PRINT COLUMN 17,g_dash1 CLIPPED
         PRINT COLUMN 20,g_x[14] CLIPPED,sr.bnb14 USING '<<<<&',g_x[15] CLIPPED;
         IF sr.bnb03 != '1' AND l_money<>0 THEN
            PRINT COLUMN 36,g_x[16],sr.bnc07 CLIPPED,l_moneyoth USING '<<<,<<<,<<&.&&';   #TQC-6A0083
            IF l_moneyoth<>l_money THEN
               PRINT ' (NTD ', l_money USING '<<<,<<<,<<&.&&',')'
            END IF
         ELSE
            PRINT ' '
         END IF
 
   ON LAST ROW
      LET l_if = 1
 
   PAGE TRAILER
        SKIP 2 LINE
        PRINT COLUMN 30,l_head CLIPPED   #TQC-6A0083
        SKIP 2 LINES 
        PRINT COLUMN 30,sr.bnb09 CLIPPED  #TQC-6A0083
        PRINT
        LET l_bnb15=sr.bnb15
        LET l_bnb16=sr.bnb16
        IF cl_null(l_bnb15) THEN
        SELECT bnb15 INTO l_bnb15 FROM bnb_file
           WHERE l_bnb16=bnb16 AND bnb15 IS NOT NULL AND bnb15<>' '
        END IF
        PRINT COLUMN 30,l_bnb15 CLIPPED  #TQC-6A0083
        PRINT
        PRINT COLUMN 17,sr.bnb06 CLIPPED,' ',
                        sr.bnb07 CLIPPED    #TQC-6A0083
        PRINT
        PRINT COLUMN 20,YEAR(sr.bnb11),
              COLUMN 35,MONTH(sr.bnb11),
              COLUMN 50,DAY(sr.bnb11)
        LET l_n = 0
END REPORT
#Patch....NO.TQC-610035 <001,002> #
