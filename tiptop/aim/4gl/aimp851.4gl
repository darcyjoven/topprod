# Prog. Version..: '5.30.06-13.03.18(00008)'     #
#
# Pattern name...: aimp851.4gl
# Descriptions...: 空白盤點標籤刪除作業
# Date & Author..: 93/05/28 By Apple
# Modify.........: No.FUN-5A0199 06/01/06 By Sarah 標籤別放大至5碼,單號放大至10碼
# Modify.........: No.FUN-570122 06/02/20 By yiting 背景執行
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: No.FUN-660078 06/06/14 By rainy aim系統中，用char定義的變數，改為用LIK
# Modify.........: NO.FUN-660156 06/06/22 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6C0153 06/12/26 By Ray 語言功能無效
# Modify.........: No.MOD-8A0061 08/10/08 By claire tm.b不勾選回頭去挑標籤別會詢問執行似乎不順暢
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-B50052 13/01/18 By Alberti 標籤別改抓asmi300的單別
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#start FUN-5A0199 將標籤別放大成5碼,後面單號放大到10碼(單據號碼組起來最大16碼)
DEFINE tm  RECORD			    	# Print condition RECORD
            a       LIKE type_file.chr1,        #No.FUN-690026 VARCHAR(1)
            #bstk    LIKE pib_file.pib01,        #No.FUN-690026 VARCHAR(05) CHI-B50052 mark
            bstk    LIKE pia_file.pia01,        #CHI-B50052 add
            bstkno  LIKE pib_file.pib03,        #No.FUN-690026 VARCHAR(10)
            estk    LIKE pib_file.pib01,        #No.FUN-690026 VARCHAR(05)
            estkno  LIKE pib_file.pib03,        #No.FUN-690026 VARCHAR(10)
       	    b       LIKE type_file.chr1,        #No.FUN-690026 VARCHAR(1)
            bwip    LIKE pib_file.pib01,        #FUN-660078
            bwipno  LIKE pib_file.pib03,        #No.FUN-690026 VARCHAR(10)
            ewip    LIKE pib_file.pib01,        #FUN-660078
            ewipno  LIKE pib_file.pib03         #No.FUN-690026 VARCHAR(10)
           END RECORD,
#end FUN-5A0199
          p_row,p_col	LIKE type_file.num5    #No.FUN-690026 SMALLINT
#       l_time          LIKE type_file.chr8            #No.FUN-6A0074
DEFINE g_change_lang    LIKE type_file.chr1     #是否有做語言切換 No.FUN-570122  #No.FUN-690026 VARCHAR(1)
DEFINE tm_bstk_o        LIKE pia_file.pia01    #CHI-B50052 add
DEFINE tm_bwip_o        LIKE pia_file.pia01    #CHI-B50052 add
DEFINE g_t1             LIKE smy_file.smyslip  #CHI-B50052 add


MAIN
DEFINE l_flag LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   #FUN-570122 ----Start----
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.a = ARG_VAL(1)
   LET tm.bstk = ARG_VAL(2)
   LET tm.bstkno = ARG_VAL(3)
   LET tm.estk = ARG_VAL(4)
   LET tm.estkno = ARG_VAL(5)
   LET tm.b = ARG_VAL(6)
   LET tm.bwip = ARG_VAL(7)
   LET tm.bwipno = ARG_VAL(8)
   LET tm.ewip = ARG_VAL(9)
   LET tm.ewipno = ARG_VAL(10)
   LET g_bgjob = ARG_VAL(11)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #FUN-570122 ----End----
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
 
   IF s_shut(0) THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM 
   END IF
 
#--NO.FUN-570122 MARK-------
   #LET p_row = 4 LET p_col = 37
 
   #OPEN WINDOW p851_w AT p_row,p_col WITH FORM "aim/42f/aimp851" 
   #    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   # CALL cl_ui_init()
 
   #LET g_action_choice=''
#NO--FUN-570122 MARK---------
 
   WHILE TRUE
   LET g_success = 'Y'
   IF g_bgjob = 'N' THEN
       CALL p851_tm()		
#NO.FUN-570122 MARK-----
      #IF INT_FLAG THEN 
      #   LET INT_FLAG = 0 EXIT WHILE 
      #END IF
      #IF g_action_choice='exit' THEN CONTINUE WHILE END IF
#NO.FUN-570122 MARK-----
       IF cl_sure(0,0) THEN 
           CALL cl_wait()
           CALL p851()
#          CALL cl_end(19,20)
           ERROR ""
           IF g_success='Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
           ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
           END IF 
           IF l_flag THEN
               CONTINUE WHILE
           ELSE
               EXIT WHILE
           END IF
   #FUN-570122 ----Start----
       ELSE
           CONTINUE WHILE
       END IF
   ELSE
       BEGIN WORK
       CALL p851()
       IF g_success = "Y" THEN
          COMMIT WORK
       ELSE
          ROLLBACK WORK
       END IF
       CALL cl_batch_bg_javamail(g_success)
       EXIT WHILE
   END IF
   #FUN-570122 ----End----
   END WHILE
   #CLOSE WINDOW p851_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION p851_tm()
   DEFINE l_direct  LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_pib03   LIKE pib_file.pib03,
          l_cnt     LIKE type_file.num10,   #No.FUN-690026 INTEGER
          l_cmd     LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(400)
   DEFINE l_sql     STRING    #FUN-5A0199
   DEFINE lc_cmd    LIKE type_file.chr1000  #No.FUN-570122 #No.FUN-690026 VARCHAR(500) 
   DEFINE li_result LIKE type_file.num5     #CHI-B50052 add  
 
   #FUN-570122 ----Start----
   LET p_row = 4 LET p_col = 37
 
   OPEN WINDOW p851_w AT p_row,p_col WITH FORM "aim/42f/aimp851"
      ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
 
   LET g_action_choice=''
   #FUN-570122 ----End----
 
WHILE TRUE    #FUN-570122
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a = 'Y' 
   LET tm.b = 'Y'
   LET g_bgjob = 'N'   #FUN-570122
   INPUT BY NAME tm.a, tm.bstk, tm.bstkno, tm.estk, tm.estkno,
                 tm.b, tm.bwip, tm.bwipno, tm.ewip, tm.ewipno,
                 g_bgjob     #FUN-570122
                 WITHOUT DEFAULTS 
 
      AFTER FIELD a
         IF tm.a IS NULL OR tm.a NOT MATCHES "[YNyn]" 
            THEN NEXT FIELD a
         END IF
         IF tm.a = 'N' THEN 
            LET tm.bstk = ' '   LET tm.bstkno = ' '
            LET tm.estk = ' '   LET tm.estkno = ' '
            DISPLAY BY NAME tm.bstk, tm.bstkno, tm.estk, tm.estkno
            NEXT FIELD b 
         END IF
 
      AFTER FIELD bstk
         IF tm.bstk IS NOT NULL AND tm.bstk != ' ' THEN
         #CHI-B50052---modify---start--
         #   SELECT pib03 INTO l_pib03 FROM pib_file
         #    WHERE pib01 = tm.bstk
         #   IF SQLCA.sqlcode THEN 
         #      CALL cl_err(tm.bstk,'mfg0107',0)
         #      LET tm.bstk = ' ' 
         #      DISPLAY BY NAME tm.bstk 
         #      NEXT FIELD bstk
         #   END IF
            IF NOT cl_null(tm.bstk) THEN
               CALL s_check_no("aim",tm.bstk,tm_bstk_o,"5","pia_file","pia01","")
               RETURNING li_result,tm.bstk
               LET tm.bstk = s_get_doc_no(tm.bstk)
               DISPLAY BY NAME tm.bstk
               IF (NOT li_result) THEN
                  NEXT FIELD bstk
               END IF
               LET tm_bstk_o = tm.bstk
            END IF
           #CHI-B50052---modify---end---
           #start FUN-5A0199
           #SELECT COUNT(*) INTO l_cnt FROM pia_file
           # WHERE pia01[1,3] matches tm.bstk
            LET l_sql = "SELECT COUNT(*) FROM pia_file ",
                        #" WHERE pia01[1,",g_doc_len,"] matches '",tm.bstk,"'"      #CHI-B50052 mark
                        " WHERE substr(pia01,1,",g_doc_len,") LIKE '",tm.bstk,"'"    #CHI-B50052 add
            PREPARE p851_pre FROM l_sql
            DECLARE p851_cur1 CURSOR FOR p851_pre
            OPEN p851_cur1
            FETCH p851_cur1 INTO l_cnt
           #end FUN-5A0199
            IF l_cnt = 0 THEN 
               CALL cl_err(tm.bstk,'mfg0112',0)
               LET tm.bstk = ' ' 
               DISPLAY BY NAME tm.bstk 
               NEXT FIELD bstk
            END IF
         END IF
         LET tm.estk = tm.bstk
         DISPLAY BY NAME tm.estk 
      
      AFTER FIELD b
         IF tm.b IS NULL OR tm.b NOT MATCHES "[YNyn]" 
            THEN NEXT FIELD b
         END IF
         IF tm.b ='N' AND tm.a ='N'
         THEN NEXT FIELD a
         END IF
         #IF tm.b ='N' THEN EXIT INPUT END IF  #MOD-8A0061 mark
 
      AFTER FIELD bwip
         IF tm.bwip IS NOT NULL AND tm.bwip != ' ' THEN 
         #CHI-B50052---modify---start---
         #   SELECT pib03 INTO l_pib03 FROM pib_file 
         #    WHERE pib01 = tm.bwip
         #   IF SQLCA.sqlcode THEN 
#        #      CALL cl_err(tm.bwip,'mfg0107',0) #No.FUN-660156 MARK
         #      CALL cl_err3("sel","pib_file",tm.bwip,"","mfg0107","","",0)  #No.FUN-660156
         #      LET tm.bwip = ' ' 
         #      DISPLAY BY NAME tm.bwip 
         #      NEXT FIELD bwip
         #   END IF
            IF NOT cl_null(tm.bwip) THEN
               CALL s_check_no("aim",tm.bwip,tm_bwip_o,"I","pia_file","pia01","")
               RETURNING li_result,tm.bwip
               LET tm.bwip = s_get_doc_no(tm.bwip)
               DISPLAY BY NAME tm.bwip
               IF (NOT li_result) THEN
                  NEXT FIELD bwip
               END IF
               LET tm_bwip_o = tm.bwip
            END IF
           #CHI-B50052---modify---end---
           #start FUN-5A0199
           #SELECT COUNT(*) INTO l_cnt FROM pid_file
           # WHERE pid01[1,3] matches tm.bwip
            LET l_sql = "SELECT COUNT(*) FROM pid_file ",
                        #" WHERE pid01[1,",g_doc_len,"] matches '",tm.bwip,"'"        #CHI-B50052 mark
                         " WHERE substr(pid01,1,",g_doc_len,") LIKE '",tm.bwip,"'"    #CHI-B50052 add
            PREPARE p851_pre1 FROM l_sql
            DECLARE p851_cur2 CURSOR FOR p851_pre1
            OPEN p851_cur2
            FETCH p851_cur2 INTO l_cnt
           #end FUN-5A0199
            IF l_cnt = 0 THEN 
               CALL cl_err(tm.bwip,'mfg0113',0)
               LET tm.bwip = ' ' 
               DISPLAY BY NAME tm.bwip 
               NEXT FIELD bwip
            END IF
         END IF
         LET tm.ewip = tm.bwip
         DISPLAY BY NAME tm.ewip 
 
      #No.FUN-570122 ----Start----
      AFTER FIELD g_bgjob
          IF g_bgjob NOT MATCHES "[YN]"  OR cl_null(g_bgjob) THEN
              NEXT FIELD g_bgjob
          END IF
      #No.FUN-570122 ----End----
 
      AFTER INPUT
          IF INT_FLAG THEN EXIT INPUT END IF
          IF tm.a = 'N' AND tm.b = 'N' 
          THEN NEXT FIELD a
          END IF
#CHI-B50052---modify---start--- 
#     ON ACTION CONTROLP 
#         CASE WHEN INFIELD(bstk) 
#                 CALL q_pib(7,3,tm.bstk) RETURNING tm.bstk
#                 CALL FGL_DIALOG_SETBUFFER( tm.bstk )
################################################################################
# START genero shell script ADD
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = 'q_pib'
#                  LET g_qryparam.default1 = tm.bstk
#                  CALL cl_create_qry() RETURNING tm.bstk
#                  CALL FGL_DIALOG_SETBUFFER( tm.bstk )
# END genero shell script ADD
################################################################################
#                  DISPLAY BY NAME tm.bstk 
#                  NEXT FIELD bstk 
#               WHEN INFIELD(bwip) 
#                 CALL q_pib(7,3,tm.bwip) RETURNING tm.bwip
#                 CALL FGL_DIALOG_SETBUFFER( tm.bwip )
################################################################################
# START genero shell script ADD
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = 'q_pib'
#                  LET g_qryparam.default1 = tm.bwip
#                  CALL cl_create_qry() RETURNING tm.bwip
#                  CALL FGL_DIALOG_SETBUFFER( tm.bwip )
# END genero shell script ADD
################################################################################
#                  DISPLAY BY NAME tm.bwip 
#                  NEXT FIELD bwip 
#               OTHERWISE EXIT CASE
#            END CASE
         ON ACTION CONTROLP
            CASE
              WHEN INFIELD(bstk)
                 LET g_t1 = s_get_doc_no(tm.bstk)
                 CALL q_smy( FALSE,TRUE,g_t1,'AIM','5') RETURNING g_t1
                 LET tm.bstk=g_t1
                 DISPLAY BY NAME tm.bstk
                 NEXT FIELD bstk 
              WHEN INFIELD(bwip)
                 LET g_t1 = s_get_doc_no(tm.bwip)
                 CALL q_smy( FALSE,TRUE,g_t1,'AIM','I') RETURNING g_t1
                 LET tm.bwip=g_t1
                 DISPLAY BY NAME tm.bwip
                 NEXT FIELD bwip 
              OTHERWISE EXIT CASE
            END CASE
#CHI-B50052---modify---end--- 
################################################################################
# START genero shell script ADD
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
   
      ON ACTION locale
        #->No.FUN-570122--end---
          LET g_action_choice='locale'     #No.TQC-6C0153
       #  CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          LET g_change_lang = TRUE
          #->No.FUN-570122--end---
         EXIT INPUT
      
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
      
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE     #No.TQC-6C0153
   END IF
 
   #FUN-570122  ----Start----
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p850_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "aimp851"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('aimp851','9031',1)
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",tm.a CLIPPED,"'",
                      " '",tm.bstk CLIPPED,"'",
                      " '",tm.bstkno CLIPPED,"'",
                      " '",tm.estk CLIPPED,"'",
                      " '",tm.estkno CLIPPED,"'",
                      " '",tm.b CLIPPED,"'",
                      " '",tm.bwip CLIPPED,"'",
                      " '",tm.bwipno CLIPPED,"'",
                      " '",tm.ewip CLIPPED,"'",
                      " '",tm.ewipno CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('aimp851',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p851_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE
   #FUN-570122  ----End----
 
END FUNCTION
 
FUNCTION p851()
   DEFINE l_name         LIKE type_file.chr20,    #External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8             #No.FUN-6A0074
          l_tag1,l_tag2  LIKE pia_file.pia01,     #FUN-5A0199 10碼變16碼 #No.FUN-690026 VARCHAR(16)   
          l_sql1,l_sql2  LIKE type_file.chr1000   #No.FUN-690026 VARCHAR(400)
 
   LET g_success = 'Y'
   BEGIN WORK      
   IF tm.a = 'Y' THEN 
      LET l_sql1 = "DELETE FROM pia_file ",
                   "WHERE pia16 ='Y' ",
                   "  AND (pia02 IS NULL OR pia02 = ' ') "
      IF tm.bstk IS NOT NULL AND tm.bstk != ' '
         AND tm.bstkno IS NOT NULL  AND tm.bstkno != ' ' THEN
        #LET l_tag1 = tm.bstk,'-',tm.bstkno           #FUN-5A0199 mark
         LET l_tag1 = tm.bstk CLIPPED,'-',tm.bstkno   #FUN-5A0199
         LET l_sql1 = l_sql1 clipped ," AND pia01 >= '",l_tag1,"'"
      END IF
 
      IF tm.bstk IS NOT NULL AND tm.bstk != ' '
         AND (tm.bstkno IS NULL OR tm.bstkno = ' ') THEN
         LET l_sql1 = l_sql1 clipped ,
                     #" AND pia01[1,3] matches '",tm.bstk,"'"               #FUN-5A0199 mark
                     # " AND pia01[1,",g_doc_len,"] matches '",tm.bstk,"'"   #FUN-5A0199   #CHI-B50052 mark
                      " AND substr(pia01,1,",g_doc_len,") LIKE '",tm.bstk,"'"    #CHI-B50052 add
      END IF
 
      IF tm.estk IS NOT NULL AND tm.estk != ' '
         AND tm.estkno IS NOT NULL  AND tm.estkno != ' ' THEN
        #LET l_tag1 = tm.estk,'-',tm.estkno           #FUN-5A0199 mark
         LET l_tag1 = tm.estk CLIPPED,'-',tm.estkno   #FUN-5A0199
         LET l_sql1 = l_sql1 clipped ,
                      " AND pia01 <='",l_tag1,"'"
      END IF
 
      PREPARE p851_pia FROM l_sql1
      EXECUTE p851_pia
      IF SQLCA.sqlcode THEN 
         CALL cl_err('delete pia_file error',SQLCA.sqlcode,0) 
         LET g_success = 'N'
      END IF
   END IF 
   IF tm.b = 'Y' THEN 
      LET l_sql2 = "DELETE FROM pid_file ",
                   " WHERE pid06='Y' ",
                   "   AND (pid03 IS NULL OR pid03 = ' ' ) "
 
      IF tm.bwip IS NOT NULL AND tm.bwip != ' '
         AND (tm.bwipno IS NULL OR tm.bwipno = ' ')
      THEN LET l_sql2 = l_sql2 clipped ,
                       #" AND pid01[1,3] matches '",tm.bwip,"'"               #FUN-5A0199 mark
                       # " AND pid01[1,",g_doc_len,"] matches '",tm.bstk,"'"   #FUN-5A0199  #CHI-B50052 mark
                        " AND substr(pid01,1,",g_doc_len,") LIKE '",tm.bwip,"'"    #CHI-B50052 add
      END IF
 
      IF tm.bwip IS NOT NULL AND tm.bwip != ' '
         AND tm.bwipno IS NOT NULL  AND tm.bwipno != ' ' THEN
        #LET l_tag2 = tm.bwip,'-',tm.bwipno           #FUN-5A0199 mark
         LET l_tag2 = tm.bwip CLIPPED,'-',tm.bwipno   #FUN-5A0199
         LET l_sql2 = l_sql2 clipped ," AND pid01 >='",l_tag2,"'"
      END IF
 
      IF tm.ewip IS NOT NULL AND tm.ewip != ' '
         AND tm.ewipno IS NOT NULL  AND tm.ewipno != ' ' THEN
        #LET l_tag2 = tm.ewip,'-',tm.ewipno           #FUN-5A0199 mark
         LET l_tag2 = tm.ewip CLIPPED,'-',tm.ewipno   #FUN-5A0199
         LET l_sql2 = l_sql2 clipped ," AND pid01 <='",l_tag2,"'"
      END IF
 
      PREPARE p851_pid FROM l_sql2
      EXECUTE p851_pid
   END IF
#  IF g_success = 'Y' THEN
#     CALL cl_cmmsg(1)
#     COMMIT WORK
#  ELSE
#     CALL cl_rbmsg(1)
#     ROLLBACK WORK
#  END IF
END FUNCTION
