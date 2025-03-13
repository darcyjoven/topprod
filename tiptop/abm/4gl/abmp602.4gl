# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: abmp602.4gl
# Descriptions...: 元件修改巨集作業
# Date & Author..: 91/08/12 By Wu 
# Modify.........: 92/11/04 By Apple
# Modify.........: 93/08/25 By Apple
# Modify.........:    MOD-490062 04/09/02 ching 改變DISPLAY訊息
# Modify.........: No.FUN-550093 05/06/01 By kim 配方BOM,特性代碼
# Modify.........: No.FUN-570102 05/08/08 By Sarah 元件料號開窗
# Modify.........: No.FUN-5B0013 05/11/02 By Rosayu 將料號/品名/規格 欄位設成[1,,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: NO.FUN-590002 05/12/26By Monster radio type 應都要給預設值
# Modify.........: No.FUN-570114 06/02/21 By saki批次背景執行
# Modify.........: No.TQC-660046 06/06/14 By Jackho cl_err-->cl_err3
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-710028 07/01/23 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-890018 08/10/06 By claire 更新bma_file(bmamodu,bmadate)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A40058 10/04/26 By lilingyu 增加規格替代的內容
# Modify.........: No.FUN-AA0059 10/10/26 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting    1、將cl_used()改成標準格式，用g_prog
#                                                            2、離開前未加cl_used(2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
           bmb03 LIKE bmb_file.bmb03,
          vdate LIKE type_file.dat,      #No.FUN-680096 DATE
          a     LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
          b     LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
          d     LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
          y     LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1)
          END RECORD,
       sr RECORD
          bmb01	LIKE bmb_file.bmb01,     #主件編號
          bmb02	LIKE bmb_file.bmb02,     #項次
          bmb03	LIKE bmb_file.bmb03,     #元件編號
          bmb04	LIKE bmb_file.bmb04,     #生效日
          bmb10	LIKE bmb_file.bmb10,     #發料單位
          bmb08	LIKE bmb_file.bmb08,     #損耗率
          bmb16	LIKE bmb_file.bmb16,     #替代特性
          ima25 LIKE ima_file.ima25,     #庫存單位
          ima86 LIKE ima_file.ima86,     #成本單位
          bmb29 LIKE bmb_file.bmb29      #FUN-550093
          END RECORD,
       g_bmb10 LIKE bmb_file.bmb10,
       g_bmb08 LIKE bmb_file.bmb08,
       g_bmb16 LIKE bmb_file.bmb16
 
DEFINE   g_chr          LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
DEFINE   g_cnt          LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_msg          LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(72)
         l_flag         LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
         g_change_lang  LIKE type_file.chr1     #是否有做語言切換 #No.FUN-680096 VARCHAR(1)
#     DEFINEl_time   LIKE type_file.chr8	            #No.FUN-6A0060
MAIN
DEFINE ls_date STRING                           #No.FUN-570114
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   #No.FUN-570114 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.bmb03 = ARG_VAL(1)
   LET ls_date  = ARG_VAL(2)
   LET tm.vdate = cl_batch_bg_date_convert(ls_date)
   LET tm.a     = ARG_VAL(3)
   LET g_bmb10  = ARG_VAL(4)
   LET tm.b     = ARG_VAL(5)
   LET g_bmb08  = ARG_VAL(6)
   LET tm.d     = ARG_VAL(7)
   LET g_bmb16  = ARG_VAL(8)
   LET tm.y     = ARG_VAL(9)
   LET g_bgjob  = ARG_VAL(10)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #No.FUN-570114 --end--
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
   IF g_sma.sma101='N' THEN 
        CALL cl_err('','abm-801',5)
        EXIT PROGRAM 
   END IF #NO:6834
 
   #No.FUN-570114 --start--
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
 
   WHILE TRUE
     IF g_bgjob = 'N' THEN
        CALL p602_tm(0,0)
        IF cl_sure(21,21) THEN
           CALL cl_wait()
           BEGIN WORK
           LET g_success = 'Y'
           CALL abmp602()
           CALL s_showmsg()   #No.FUN-710028
           IF g_success = 'Y' THEN
              COMMIT WORK
              CALL cl_end2(1) RETURNING l_flag          #作業成功是否繼續執行
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag          #作業失敗是否繼續執行
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW p602_w
              EXIT WHILE
           END IF
        ELSE
           CONTINUE WHILE
        END IF
        CLOSE WINDOW p602_w
     ELSE
        BEGIN WORK
        LET g_success = 'Y'
        CALL abmp602()
        CALL s_showmsg()   #No.FUN-710028
        IF g_success = 'Y' THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END IF 
   END WHILE
   #CALL cl_used('abmp602',g_time,2) RETURNING g_time   #No.FUN-6A0060    #FUN-B30211
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-6A0060     #FUN-B30211
#  CALL p602_tm(0,0)
   #No.FUN-570114 ---end---
END MAIN
 
FUNCTION p602_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,          #No.FUN-680096 SMALLINT
          l_flag1       LIKE type_file.num10,         #No.FUN-680096 INTEGER
          l_bdate       LIKE bmx_file.bmx07,
          l_edate       LIKE bmx_file.bmx08,
          l_dir1,l_dir2,l_dir3 LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
          lc_cmd        LIKE type_file.chr1000        #No.FUN-570114  #No.FUN-680096 VARCHAR(500)
 
   LET p_row = 4 LET p_col = 23
 
   OPEN WINDOW p602_w AT p_row,p_col WITH FORM "abm/42f/abmp602" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
 WHILE TRUE 
   #NO.FUN-590002 START-------
   LET g_bmb16 = '0'
   LET tm.d = 'Y'
   #NO.FUN-590002 END---------
   CLEAR FORM 
   LET g_cnt = 0
   LET g_success = 'Y'
   LET g_change_lang = FALSE
   INITIALIZE tm.* TO NULL			# Default condition
   LET g_bmb10 = NULL
   LET g_bmb08 = NULL
   #LET g_bmb16 = NULL
   LET tm.y = 'Y'
   LET tm.a = 'N'
   LET tm.b = 'N'
   LET tm.d = 'N'
   LET g_bgjob = 'N'                           #No.FUN-570114
 
   INPUT tm.bmb03,tm.vdate,tm.a,g_bmb10,tm.b,
		 g_bmb08,tm.d,g_bmb16,tm.y,g_bgjob  WITHOUT DEFAULTS 
		 FROM bmb03,vdate,a,bmb10,b,bmb08,d,bmb16,y ,g_bgjob
                                                 #No.FUN-570114
 
      #No.FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_init()
      #No.FUN-580031 ---end---
 
      BEFORE FIELD bmb03  
         IF g_sma.sma60 = 'Y'		# 若須分段輸入
            THEN CALL s_inp5(8,39,tm.bmb03) RETURNING tm.bmb03
                 DISPLAY tm.bmb03 TO bmb03 
         END IF
 
      AFTER FIELD bmb03
         IF tm.bmb03 IS NULL THEN
            NEXT FIELD bmb03
         ELSE
            CALL p602_bmb03()
            IF g_chr = 'E' THEN
               CALL cl_err(tm.bmb03,'mfg0002',0)
               NEXT FIELD bmb03
            END IF
         END IF
 
      AFTER FIELD vdate
         CALL p602_cnt()
         IF g_cnt=0 THEN
            CALL cl_err(tm.vdate,'mfg2601',0)
            NEXT FIELD bmb03 
         END IF
 
      AFTER FIELD a
         IF tm.a IS NULL OR tm.a  = ' ' OR tm.a NOT MATCHES'[YNyn]' THEN
            NEXT FIELD a 
         ELSE
            IF tm.a MATCHES'[Nn]' THEN
               LET g_bmb10 = NULL
               DISPLAY g_bmb10 TO bmb10
            END IF
         END IF 
         LET l_dir1 = 'U'
 
      BEFORE FIELD bmb10
         IF tm.a MATCHES'[Nn]' THEN
            IF l_dir1 = 'U' THEN
               NEXT FIELD b
            ELSE
               NEXT FIELD a
            END IF
         END IF
 
      AFTER FIELD bmb10 
         IF NOT cl_null(g_bmb10) THEN 
            SELECT gfe01 FROM gfe_file WHERE gfe01 = g_bmb10
                                         AND gfeacti = 'Y'
            IF SQLCA.sqlcode != 0 THEN 
#              CALL cl_err(g_bmb10,'mfg2605',0) # TQC-660046
               CALL cl_err3("sel","gfe_file",g_bmb10,"","mfg2605","","",0)  # TQC-660046
               NEXT FIELD bmb10
            END IF
         END IF
         LET l_dir1 = 'D'
 
      AFTER FIELD b
         IF tm.b IS NULL OR tm.b  = ' ' OR tm.b NOT MATCHES'[YNyn]' THEN
            NEXT FIELD b 
         ELSE
            IF tm.b MATCHES'[Nn]' THEN
               LET g_bmb08 = NULL
               DISPLAY g_bmb08 TO bmb08
            END IF
         END IF 
         LET l_dir1 = 'D'
         LET l_dir2 = 'U'
 
      BEFORE FIELD bmb08
         IF tm.b MATCHES'[Nn]' THEN
            IF l_dir2 = 'U' THEN
               NEXT FIELD d
            ELSE
               NEXT FIELD b
            END IF
         END IF
 
      AFTER FIELD bmb08 
         IF g_bmb08 IS NULL OR g_bmb08 = ' ' THEN 
            LET g_bmb08 = 0
            DISPLAY g_bmb08 TO bmb08
         END IF
 
      AFTER FIELD d
         IF tm.d IS NULL OR tm.d  = ' ' OR tm.d NOT MATCHES'[YNyn]' THEN
            NEXT FIELD d 
         ELSE
            IF tm.d MATCHES'[Nn]' THEN
               LET g_bmb16 = NULL 
               DISPLAY g_bmb16 TO bmb16
            END IF
         END IF 
         LET l_dir1 = 'D' 
         LET l_dir2 = 'D' 
         LET l_dir3 = 'U'
 
      BEFORE FIELD bmb16
         IF tm.d MATCHES'[Nn]' THEN
            IF l_dir3 = 'U' THEN
               NEXT FIELD y
            ELSE
               NEXT FIELD d
            END IF
         END IF
 
      AFTER FIELD bmb16
         IF g_bmb16 IS NULL OR g_bmb16 NOT MATCHES'[01257]' THEN     #FUN-A40058 add '7'
            NEXT FIELD bmb16
         ELSE
         #  IF g_bmb16 MATCHES'[12]' THEN 
    	 #	CALL p602_prompt()
         #  END IF
         END IF
         LET l_dir1 = 'D' 
         LET l_dir2 = 'D' 
         LET l_dir3 = 'D' 
 
      AFTER FIELD y
         IF tm.y NOT MATCHES "[YN]" THEN NEXT FIELD y END IF
         LET l_dir1 = 'D' 
         LET l_dir2 = 'D' 
         LET l_dir3 = 'D' 
 
      #No.FUN-570114 --start--
      ON CHANGE g_bgjob
         IF g_bgjob = "Y" THEN
            LET tm.y = "N"
            DISPLAY BY NAME tm.y
            CALL cl_set_comp_entry("y",FALSE)
         ELSE
            CALL cl_set_comp_entry("y",TRUE)
         END IF
      #No.FUN-570114 ---end---
 
      ON ACTION CONTROLP
         CASE
#start FUN-570102
            WHEN INFIELD(bmb03) #料件主檔
#FUN-AA0059 --Begin--
              #   CALL cl_init_qry_var()
              #   LET g_qryparam.form = "q_ima"
              #   LET g_qryparam.default1 = tm.bmb03
              #   CALL cl_create_qry() RETURNING tm.bmb03
                 CALL q_sel_ima(FALSE, "q_ima", "", tm.bmb03, "", "", "", "" ,"",'' )  RETURNING tm.bmb03
#FUN-AA0059 --End--
#                CALL FGL_DIALOG_SETBUFFER( tm.bmb03    )
                 DISPLAY BY NAME tm.bmb03
                 NEXT FIELD bmb03
#end FUN-570102
            WHEN INFIELD(bmb10) #單位檔
#                CALL q_gfe(10,2,g_bmb10) RETURNING g_bmb10
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_gfe'
                 LET g_qryparam.default1 = g_bmb10
                 CALL cl_create_qry() RETURNING g_bmb10
                 DISPLAY g_bmb10  TO bmb10
                 NEXT FIELD bmb10
            OTHERWISE
                 EXIT CASE
         END CASE 
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION locale
#        CALL cl_dynamic_locale()                   #No.FUN-570114
#        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_change_lang = TRUE
         EXIT INPUT
      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT INPUT
 
      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      #No.FUN-580031 ---end---
 
      #No.FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
   END INPUT
   #No.FUN-570114 --start--
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
   #No.FUN-570114 ---end---
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN 
      LET INT_FLAG = 0 
      CLOSE WINDOW p602_w                      #No.FUN-570114
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211 
      EXIT PROGRAM 
   END IF
   IF tm.a matches'[nN]' and tm.b matches'[nN]' and 
      tm.d matches'[nN]'
   THEN CONTINUE WHILE 
   END IF
 
   #No.FUN-570114 --start--
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = 'abmp602'
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('abmp602','9031',1)
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",tm.bmb03 CLIPPED,"'",
                      " '",tm.vdate CLIPPED,"'",
                      " '",tm.a CLIPPED,"'",
                      " '",g_bmb10 CLIPPED,"'",
                      " '",tm.b CLIPPED,"'",
                      " '",g_bmb08 CLIPPED,"'",
                      " '",tm.d CLIPPED,"'",
                      " '",g_bmb16 CLIPPED,"'",
                      " 'N'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('abmp602',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p602_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
#  BEGIN WORK
#  IF cl_sure(20,23) THEN
#      CALL abmp602()
#      IF g_success = 'Y' THEN
#         COMMIT WORK
#         CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#      ELSE
#         ROLLBACK WORK
#         CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#      END IF
#      IF l_flag THEN
#         CLEAR FORM
#         CONTINUE WHILE
#      ELSE
#         EXIT WHILE
#      END IF
#  END IF
#  ERROR ""
   END WHILE 
#    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
#  CLOSE WINDOW p602_w
   #No.FUN-570114 ---end---
END FUNCTION
   
FUNCTION abmp602()
  DEFINE  l_sql 	LIKE type_file.chr1000, # RDSQL STATEMENT   #No.FUN-680096 VARCHAR(600)
          l_buf 	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(80)
          l_buf2	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(100)
          l_message     LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(100)
          l_flag,l_flag2  LIKE type_file.num5,  #No.FUN-680096 SMALLINT 
          l_factor,l_factor2   LIKE bmb_file.bmb10_fac,
          l_cnt1,l_cnt2	LIKE type_file.num5     # Already-cnt, N-cnt   #No.FUN-680096 SMALLINT
 
     LET l_sql = "SELECT bmb01,bmb02,bmb03,bmb04,bmb29 ",
                 " FROM bmb_file ",
                 "  WHERE bmb03 ='",tm.bmb03,"'"
 
     IF tm.vdate IS NOT NULL AND tm.vdate !=' ' 
     THEN LET l_sql = l_sql clipped,
                      " AND (bmb04 <='",tm.vdate,"'"," OR bmb04 IS NULL )",
                      " AND (bmb05 > '",tm.vdate,"'"," OR bmb05 IS NULL )"
     END IF
     LET l_sql = l_sql clipped," FOR UPDATE"
     LET l_sql = cl_forupd_sql(l_sql)

     PREPARE p602_pre1 FROM l_sql 
     IF SQLCA.sqlcode THEN 
        CALL cl_err('prepare p602_pre1',SQLCA.SQLCODE,1) 
        LET g_success = "N" 
        RETURN
     END IF
     DECLARE p602_cs CURSOR FOR p602_pre1
 
     LET l_sql = " SELECT bmb01,bmb02,bmb03,bmb04,bmb10,bmb08, ",
                 " bmb16,ima25,ima86,bmb29 ", #FUN-550093
                 " FROM bmb_file,ima_file ",
                 " WHERE bmb03 = ima01 AND bmb01 = ? AND bmb02=? AND bmb03=? AND bmb04=? AND bmb29=? "
 
    PREPARE p602_prepare FROM l_sql 
	DECLARE p602_cl    
        SCROLL CURSOR WITH HOLD FOR p602_prepare
     IF g_bgjob = 'N' THEN                #FUN-570114
        OPEN WINDOW p602_w2 AT 19,5 WITH 5 ROWS, 70 COLUMNS
     END IF
          
     CALL cl_getmsg('mfg2701',g_lang) RETURNING l_buf
     IF g_bgjob = 'N' THEN                #FUN-570114
        DISPLAY l_buf AT 1,1
     END IF
     CALL cl_getmsg('mfg2709',g_lang) RETURNING l_buf2
     LET l_cnt1 = 0
     LET l_cnt2 = 0
     CALL s_showmsg_init()    #No.FUN-710028
     FOREACH p602_cs INTO sr.bmb01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bmb29
       IF SQLCA.sqlcode THEN 
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)          #No.FUN-710028
          CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)  #No.FUN-710028
          LET g_success = 'N'
#         EXIT FOREACH      #No.FUN-710028
          CONTINUE FOREACH  #No.FUN-710028
       END IF
 
        #MOD-490062
       LET l_buf[17,20]=g_cnt USING '###&'
       IF g_bgjob = 'N' THEN                #FUN-570114
          DISPLAY l_buf AT 1,1
       END IF
 
       LET l_cnt1 = l_cnt1 + 1
       LET l_buf[34,37]=l_cnt1 USING '###&'
       IF g_bgjob = 'N' THEN                #FUN-570114
          DISPLAY l_buf AT 1,1
       END IF
       #--
 
       OPEN p602_cl  USING sr.bmb01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bmb29
       FETCH p602_cl INTO sr.*
         IF SQLCA.sqlcode THEN
#           CALL cl_err('fetch p602_cl',SQLCA.SQLCODE,0)         #No.FUN-710028
            CALL s_errmsg('','','fetch p602_cl',SQLCA.SQLCODE,1) #No.FUN-710028
            LET g_success = "N"
#           EXIT FOREACH      #No.FUN-710028
            CONTINUE FOREACH  #No.FUN-710028
         END IF
 
       #BugNO:3985
          #LET l_message=l_buf2[01,12],':',sr.bmb01[1,20],' ', #FUN-5B0013 mark
          LET l_message=l_buf2[01,12],':',sr.bmb01 CLIPPED,' ', #FUN-5B0013 add
                        l_buf2[22,29],':',sr.bmb10[1,4],' ',        
                        l_buf2[32,37],':',sr.bmb08 USING '####&.&&&',' ',
                        l_buf2[41,48],':',sr.bmb16 USING '&',' ',
                        l_buf2[64,71],':',sr.bmb29  #FUN-550093
 
       IF tm.y = 'N' OR g_bgjob = 'N' THEN     #FUN-570114
          LET g_chr = 'Y'
          IF g_bgjob = 'N' THEN         #FUN-570114
            MESSAGE l_message
            DISPLAY l_message AT 4,1
            CALL ui.Interface.refresh()
          END IF
       ELSE
          LET g_chr = ' '
          WHILE g_chr NOT MATCHES "[YyNn]" OR g_chr IS NULL
             LET INT_FLAG = 0  ######add for prompt bug
             IF g_bgjob = 'N' THEN                #FUN-570114 --start--
                DISPLAY l_message AT 4,1
                PROMPT l_buf2[50,60] FOR CHAR g_chr
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                     CONTINUE PROMPT
 
                   ON ACTION about         #MOD-4C0121
                      CALL cl_about()      #MOD-4C0121
 
                   ON ACTION help          #MOD-4C0121
                      CALL cl_show_help()  #MOD-4C0121
 
                   ON ACTION controlg      #MOD-4C0121
                      CALL cl_cmdask()     #MOD-4C0121
                END PROMPT
                IF INT_FLAG THEN 
                   LET g_chr = 'N'
                   LET INT_FLAG = 0
                   LET g_success='N'
                   EXIT WHILE
                END IF
             ELSE
                LET g_chr = 'Y'
             END IF                               #FUN-570114 ---end---
          END WHILE
       END IF
       IF g_chr MATCHES "[Yy]" THEN
            #---->發料單位修改
            IF tm.a = 'Y' THEN 
                CALL s_umfchk(sr.bmb03,g_bmb10,sr.ima25)
                     RETURNING l_flag,l_factor 
                IF l_factor IS NULL OR l_factor = ' ' 
                   OR l_factor = 0
                THEN  #Modify:98/11/13 ------單位換算率抓不到show error#  
                      #LET l_factor = 1
                      CALL cl_err('','abm-731',1) 
                      LET g_success ='N'            
                      EXIT FOREACH
                END IF
                CALL s_umfchk(sr.bmb03,g_bmb10,sr.ima86)
                     RETURNING l_flag2,l_factor2
                IF l_factor2 IS NULL OR l_factor2 = ' '
                   OR l_factor2 = 0
                THEN  #LET l_factor = 1
#                     CALL cl_err('','abm-731',1)         #No.FUN-710028
                      CALL s_errmsg('','','','abm-731',1) #No.FUN-710028
                      LET g_success ='N' 
#                     EXIT FOREACH      #No.FUN-710028
                      CONTINUE FOREACH  #No.FUN-710028
                END IF
                UPDATE bmb_file SET bmb10      = g_bmb10,   #發料單位
                                    bmb10_fac  = l_factor,  #發料/料件庫存
                                    bmb10_fac2 = l_factor2, #發料/料件成本
                                    bmbmodu    = g_user,
                                    bmbdate    = g_today,
                                    bmbcomm    = 'abmp602'
                       WHERE bmb01 = sr.bmb01 AND bmb02=sr.bmb02 AND bmb03=sr.bmb03 AND bmb04=sr.bmb04 AND bmb29=sr.bmb29
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 
                 THEN 
#                     CALL cl_err(' ','mfg2751',0) # TQC-660046
#                     CALL cl_err3("upd","bmb_file",sr.bmb01,sr.bmb02,"mfg2751","","",1) # TQC-660046 #No.FUN-710028
                      CALL s_errmsg(' ',' ',' ','mfg2751',1)       #No.FUN-710028 
                      LET g_success = 'N'
#                     EXIT FOREACH      #No.FUN-710028
                      CONTINUE FOREACH  #No.FUN-710028
                END IF
            END IF
            #---->損耗率
            IF tm.b = 'Y' THEN 
                 UPDATE bmb_file SET bmb08   = g_bmb08,
                                    bmbmodu  = g_user,
                                    bmbdate  = g_today,
                                    bmbcomm  = 'abmp602'
                      WHERE bmb01 = sr.bmb01 AND bmb02=sr.bmb02 AND bmb03=sr.bmb03 AND bmb04=sr.bmb04 AND bmb29=sr.bmb29
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 
                 THEN 
#                   CALL cl_err(' ','mfg2751',0) # TQC-660046
#                   CALL cl_err3("upd","bmb_file",sr.bmb01,sr.bmb02,"mfg2751","","",1) #TQC-660046 #No.FUN-710028 
                    CALL s_errmsg(' ',' ',' ','mfg2751',1)       #No.FUN-710028 
                    LET g_success = 'N'
#                   EXIT FOREACH      #No.FUN-710028
                    CONTINUE FOREACH  #No.FUN-710028
                 END IF
            END IF
            #---->替代特性
            IF tm.d = 'Y' THEN
                UPDATE bmb_file SET bmb16   = g_bmb16,
                                    bmbmodu = g_user,
                                    bmbdate = g_today,
                                    bmbcomm = 'abmp602'
                     WHERE bmb01 = sr.bmb01 AND bmb02=sr.bmb02 AND bmb03=sr.bmb03 AND bmb04=sr.bmb04 AND bmb29=sr.bmb29
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 
                 THEN 
#                    CALL cl_err(' ','mfg2751',0) # TQC-660046
#                    CALL cl_err3("upd","bmb_file",sr.bmb01,sr.bmb02,"mfg2751","","",1) # TQC-66046 #No.FUN-710028
                     CALL s_errmsg(' ',' ',' ','mfg2751',1)       #No.FUN-710028 
                     LET g_success = 'N'
#                    EXIT FOREACH      #No.FUN-710028
                     CONTINUE FOREACH  #No.FUN-710028
                END IF
            END IF
         #TQC-890018-begin-add
          UPDATE bma_file SET bmamodu=g_user,
                              bmadate=g_today
                 WHERE bma01=sr.bmb01  
                   AND bma06=sr.bmb29
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN  
             CALL cl_err3("upd","bma_file",sr.bmb01,"",SQLCA.sqlcode,"","update error",0)  
             LET g_success = 'N'
             EXIT FOREACH
          END IF
         #TQC-890018-end-add
       ELSE
          LET l_cnt2 = l_cnt2 + 1
          LET l_buf[53,56]=l_cnt2 USING '###&'
          IF g_bgjob = 'N' THEN                #FUN-570114
             DISPLAY l_buf AT 1,1
          END IF
       END IF
     END FOREACH
#No.FUN-710028 --begin                                                                                                              
     IF g_totsuccess="N" THEN                                                                                                        
        LET g_success="N"                                                                                                            
     END IF                                                                                                                          
#No.FUN-710028 --end
 
     CLOSE p602_cl
     IF g_bgjob = 'N' THEN        #FUN-570114
        CLOSE WINDOW p602_w2
     END IF
END FUNCTION
   
FUNCTION p602_bmb03()  #元件料件編號
    DEFINE l_ima02   LIKE ima_file.ima02,
           l_ima05   LIKE ima_file.ima05,
           l_imaacti LIKE ima_file.imaacti
 
    LET g_chr = ' '
    IF tm.bmb03 IS NULL THEN
        LET l_ima02=NULL
        LET l_ima05=NULL
        LET g_chr = 'E'
    ELSE SELECT  ima02,ima05,imaacti
            INTO l_ima02,l_ima05,l_imaacti
            FROM ima_file WHERE ima01 = tm.bmb03 
            IF SQLCA.sqlcode THEN
               LET g_chr = 'E'
               LET l_ima02 = NULL
               LET l_ima05 = NULL
               ELSE IF l_imaacti='N' THEN
                       LET g_chr = 'E'
                    END IF
            END IF
     END IF
     IF g_bgjob = 'N' THEN                #FUN-570114
        DISPLAY l_ima02 TO FORMONLY.ima02
        DISPLAY l_ima05 TO FORMONLY.ima05 
     END IF
END FUNCTION
   
FUNCTION p602_cnt()
   IF tm.vdate=' ' OR tm.vdate IS NULL THEN
        SELECT COUNT(*) INTO g_cnt FROM bmb_file WHERE bmb03=tm.bmb03
        IF g_bgjob = 'N' THEN                #FUN-570114
           DISPLAY g_cnt TO FORMONLY.cnt      
        END IF
   ELSE
        SELECT COUNT(*) INTO g_cnt FROM bmb_file
               WHERE bmb03=tm.bmb03
                     AND (bmb04 <= tm.vdate OR bmb04 IS NULL) 
                     AND (bmb05 > tm.vdate OR bmb05 IS NULL) 
        IF g_bgjob = 'N' THEN                #FUN-570114
           DISPLAY g_cnt TO FORMONLY.cnt      
        END IF
    END IF
END FUNCTION       
           
FUNCTION p602_prompt()
    DEFINE l_cmd   LIKE type_file.chr50   #No.FUN-680096 VARCHAR(40)
 
  CALL cl_getmsg('mfg2629',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
  PROMPT g_msg CLIPPED FOR g_chr 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
#        CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
  
  END PROMPT
  IF INT_FLAG THEN LET INT_FLAG = 0 END IF
  IF g_chr MATCHES '[Yy]' THEN 
     IF g_bmb16 = '1' THEN 
        LET l_cmd = "abmi601 " 
     ELSE 
        IF g_bmb16 = '2' THEN 
           LET l_cmd = "abmi602 "
        END IF
     END IF
     CALL cl_cmdrun(l_cmd)
  END IF
END FUNCTION
