# Prog. Version..: '5.30.06-13.04.01(00008)'     #
#
# Pattern name...: abmp601.4gl
# Descriptions...: 元件替換巨集作業
# Input parameter: 
# Return code....: 
# Date & Author..: 91/08/08 By  Lin
# Modify.........: 92/11/04 By Apple
# Modify.........:    MOD-490062 04/09/02 ching 改變DISPLAY訊息
# Modify.........: No.FUN-550093 05/06/01 By kim 配方BOM,特性代碼
# Modify.........: No.FUN-5B0013 05/11/02 By Rosayu 將料號/品名/規格 欄位設成[1,,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.FUN-570114 06/02/21 By saki 批次背景執行
# Modify.........: No.TQC-660046 06/06/12 By Jackho cl_err-->cl_err3
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-710028 07/01/23 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-890018 08/10/03 By claire 更新bma_file(bmamodu,bmadate)
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No.FUN-AA0059 10/10/26 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   離開前未加cl_used(2) 
# Modify.........: No.CHI-D10044 13/03/04 By bart s_uima146()參數變更

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
        tm RECORD
          a     LIKE bmb_file.bmb03, #原元件料件編號
          b     LIKE ima_file.ima02, #品名規格
          ima021_1 LIKE ima_file.ima021, #品名規格
          c     LIKE ima_file.ima05, #版本
          d     LIKE ima_file.ima08, #來源碼
          bmx07 LIKE bmx_file.bmx07, #生效日期
          bmx08 LIKE bmx_file.bmx08, #失效日期 
          vdate LIKE type_file.dat,   #No.FUN-680096 DATE
          e     LIKE bmb_file.bmb03,
          f     LIKE ima_file.ima02,
          ima021_2 LIKE ima_file.ima021, #品名規格
          g     LIKE ima_file.ima05,
          h     LIKE ima_file.ima08,
          y     LIKE type_file.chr1   #No.FUN-680096 VARCHAR(1)
          END RECORD,
       sr RECORD
          bmb01	LIKE bmb_file.bmb01, #主件料件編號
          bmb02	LIKE bmb_file.bmb02, #元件項次
          bmb03	LIKE bmb_file.bmb03, #元件料件編號 
          bmb04	LIKE bmb_file.bmb04, #生效日期
          bmb29	LIKE bmb_file.bmb29  #FUN-550093
          END RECORD
DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-680096 SMALLINT
DEFINE g_forupd_sql    STRING,                #SELECT ... FOR UPDATE SQL
       l_flag          LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1    #是否有做語言切換 #No.FUN-680096 VARCHAR(1)
 
DEFINE   g_chr         LIKE type_file.chr1    #No.FUN-680096 VARCHAR(1)
DEFINE   g_cnt         LIKE type_file.num10   #No.FUN-680096 INTEGER
#     DEFINEl_time   LIKE type_file.chr8	           #No.FUN-6A0060
 
MAIN
DEFINE ls_date STRING                          #No.FUN-570114
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   #No.FUN-570114 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.a     = ARG_VAL(1)
   LET ls_date  = ARG_VAL(2)
   LET tm.vdate = cl_batch_bg_date_convert(ls_date)
   LET tm.e    = ARG_VAL(3)
   LET tm.y    = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #No.FUN-570114 ---end---
 
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
   CALL s_decl_bmb()
 
   #No.FUN-570114 --start--
#  LET p_row = 5 LET p_col = 23
 
#  OPEN WINDOW p601_w AT p_row,p_col WITH FORM "abm/42f/abmp601" 
#      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#   
#   CALL cl_ui_init()
 
 
   IF s_shut(0) THEN EXIT PROGRAM END IF                #檢查權限
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
   WHILE TRUE
#    LET g_success = 'Y'
#    CLEAR FORM 
#    LET g_change_lang = FALSE
#    CALL p601_tm(0,0)	  #輸入替換與被替換之資料 
#    IF g_change_lang = TRUE THEN
#        CONTINUE WHILE
#    END IF
#    IF INT_FLAG THEN
#        LET INT_FLAG = 0 
#        EXIT PROGRAM
#    END IF
     IF g_bgjob = "N" THEN
        CALL p601_tm(0,0)
        IF cl_sure(18,20) THEN   #確定執行本作業
           CALL cl_wait()
           BEGIN WORK
           LET g_success = 'Y'
           CALL p601()
           ERROR ""
           CALL s_showmsg()   #No.FUN-710028
           IF g_success = 'Y' THEN
              COMMIT WORK
              CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
           END IF
           IF l_flag THEN
              CLEAR FORM
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW p601_w
              EXIT WHILE
           END IF
        ELSE
           CONTINUE WHILE
        END IF
        CLOSE WINDOW p601_w
#       ERROR ""
     ELSE
        BEGIN WORK
        LET g_success = 'Y'
        CALL p601()
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
  CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
# CLOSE WINDOW p601_w
  #No.FUN-570114 ---end---
END MAIN
 
FUNCTION p601_tm(p_row,p_col)
   DEFINE   p_row,p_col	  LIKE type_file.num5,     #No.FUN-680096 SMALLINT
            l_flag        LIKE type_file.chr1,     #判斷必要欄位是否有輸入    #No.FUN-680096 VARCHAR(1)
            l_flag1       LIKE type_file.num5,     #No.FUN-680096 SMALLINT
            l_bdate       LIKE bmx_file.bmx07,
            l_edate       LIKE bmx_file.bmx08,
            l_cmd         LIKE type_file.chr1000,  #No.FUN-680096  VARCHAR(80)
            lc_cmd        LIKE type_file.chr1000   #No.FUN-570114  #No.FUN-680096 VARCHAR(500)
 
 
   #No.FUN-570114 --start--
   LET p_row = 5 LET p_col = 23
 
   OPEN WINDOW p601_w AT p_row,p_col WITH FORM "abm/42f/abmp601"
     ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
   #No.FUN-570114 ---end---
 
   CLEAR FORM 
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.vdate=g_today
   LET tm.y='Y'
   LET g_bgjob = 'N'                           #No.FUN-570114
 
   WHILE TRUE                                  #No.FUN-570114
      DISPLAY BY NAME tm.vdate,tm.y,g_bgjob    #No.FUN-570114
      INPUT BY NAME tm.a,tm.vdate,tm.e,tm.y,g_bgjob WITHOUT DEFAULTS 
                                                #No.FUN-570114
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         BEFORE FIELD a
            IF g_sma.sma60 = 'Y' THEN		# 若須分段輸入
               CALL s_inp5(9,31,tm.a) RETURNING tm.a
               DISPLAY tm.a TO a  
            END IF
 
         AFTER FIELD a    #將被替換之元件
            IF tm.a IS NULL  THEN 
               NEXT FIELD  a
            ELSE 
               CALL p601_a()  #顯示品名規格...
               IF g_chr='E' THEN  
                  CALL cl_err(' ','mfg0002',0)
                  LET tm.a=NULL
                  DISPLAY BY NAME tm.a
                  NEXT FIELD a
               END IF
            END IF
         
         AFTER FIELD vdate  #有效日期
            CALL p601_cnt()  #顯示處理的筆數
            IF g_cnt=0 THEN
               CALL cl_err(' ','mfg2601',0)
               LET tm.a=NULL
               DISPLAY BY NAME tm.a
               NEXT FIELD a
            END IF
 
         BEFORE FIELD e
            IF g_sma.sma60 = 'Y' THEN		# 若須分段輸入
               CALL s_inp5(14,31,tm.e) RETURNING tm.e
               DISPLAY tm.e TO e  
            END IF
 
         AFTER FIELD e   #替換之元件
            IF tm.e IS NULL  THEN
               NEXT FIELD  e
            ELSE
               IF tm.e=tm.a THEN 
                  CALL cl_err(' ','mfg2715',0)
                  NEXT FIELD e
               END IF  
               CALL p601_e()  #顯示品名規格...
               IF g_chr='E' THEN  
                  CALL cl_err(' ','mfg0002',0)
                  NEXT FIELD e
               END IF
            END IF
 
         AFTER FIELD y    #每項元件前確認
            IF tm.y NOT MATCHES '[YN]' OR tm.y IS NULL THEN
               NEXT FIELD y
            END IF
 
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
 
         AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET l_flag='N'
            IF INT_FLAG THEN
               EXIT INPUT  
            END IF
            IF tm.a IS NULL  THEN    #將被替換之元件
               LET l_flag='Y'
               DISPLAY tm.a TO FORMONLY.a 
            END IF
            IF tm.e IS NULL  THEN    #替換之元件
               LET l_flag='Y'
               DISPLAY tm.e TO FORMONLY.e 
            END IF
            IF l_flag='Y' THEN
               CALL cl_err('','9033',0)
               NEXT FIELD a
            END IF
 
         ON ACTION create_item_master #建立料件基本資料檔
            IF g_sma.sma09='Y' THEN
               LET l_cmd = "aimi109 '",tm.e,"'" CLIPPED 
               CALL cl_cmdrun(l_cmd)
               NEXT FIELD e
            ELSE
               CALL cl_err('','mfg2617',0)
               NEXT FIELD e
            END IF
 
         ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
             
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION CONTROLP     #查詢條件 
            CASE
               WHEN INFIELD(a) #料件主檔
#FUN-AA0059 ---Begin--
                  #  CALL cl_init_qry_var()
                  #  LET g_qryparam.form = "q_ima"
                  #  LET g_qryparam.default1 = tm.a        
                  #  CALL cl_create_qry() RETURNING tm.a        
                    CALL q_sel_ima(FALSE, "q_ima", "",tm.a, "", "", "", "" ,"",'' )  RETURNING tm.a 
#FUN-AA0059 --End--
#                   CALL FGL_DIALOG_SETBUFFER( tm.a        )
                    DISPLAY BY NAME tm.a        
                    NEXT FIELD a       
               WHEN INFIELD(e) #料件主檔
#FUN-AA0059 --Begin--
                 #   CALL cl_init_qry_var()
                 #   LET g_qryparam.form = "q_ima"
                 #   LET g_qryparam.default1 = tm.e        
                 #   CALL cl_create_qry() RETURNING tm.e        
                    CALL q_sel_ima(FALSE, "q_ima", "",tm.e, "", "", "", "" ,"",'' )  RETURNING tm.e
#FUN-AA0059 --End--
#                   CALL FGL_DIALOG_SETBUFFER( tm.e        )
                    DISPLAY BY NAME tm.e        
                    NEXT FIELD e       
               OTHERWISE EXIT CASE
            END CASE
            
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION locale
#         CALL cl_dynamic_locale()               #No.FUN-570114
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
      IF g_change_lang = TRUE THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale() 
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p601_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = 'abmp601'
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('abmp601','9031',1)           
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",tm.a CLIPPED,"'",
                         " '",tm.vdate CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",
                         " 'N'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('abmp601',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p601_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
   #No.FUN-570114 ---end---
END FUNCTION
 
FUNCTION p601_a()    #顯示品名規格...
   DEFINE  l_ima02    LIKE   ima_file.ima02,
           l_ima021   LIKE   ima_file.ima021,
           l_ima05    LIKE   ima_file.ima05,
           l_ima08    LIKE   ima_file.ima08,
           l_imaacti  LIKE   ima_file.imaacti
   LET g_chr=' '
   IF tm.a IS NULL THEN
      LET l_ima02=NULL 
      LET l_ima021=NULL 
      LET l_ima05=NULL 
      LET l_ima08=NULL 
   ELSE 
       SELECT ima02,ima021,ima05,ima08,imaacti
            INTO l_ima02,l_ima021,l_ima05,l_ima08,l_imaacti
            FROM ima_file
            WHERE ima01=tm.a
       IF SQLCA.sqlcode THEN
          LET g_chr='E'
          LET l_ima02=NULL 
          LET l_ima021=NULL 
          LET l_ima05=NULL 
          LET l_ima08=NULL
       ELSE 
          IF l_imaacti='N' THEN
               LET g_chr='E'
          END IF
       END IF 
   END IF
   IF g_bgjob = 'N' THEN                 #FUN-570114
      DISPLAY l_ima02  TO FORMONLY.b  
      DISPLAY l_ima021  TO FORMONLY.ima021_1
      DISPLAY l_ima02   TO FORMONLY.b  
      DISPLAY l_ima05   TO FORMONLY.c    
      DISPLAY l_ima08   TO FORMONLY.d    
   END IF
END FUNCTION       
 
FUNCTION p601_cnt()    #顯示處理的筆數
   IF tm.vdate=' ' OR tm.vdate IS NULL THEN
        SELECT COUNT(*) INTO g_cnt FROM bmb_file WHERE bmb03=tm.a
   ELSE
        SELECT COUNT(*) INTO g_cnt FROM bmb_file
               WHERE bmb03=tm.a
                     AND (bmb04 <= tm.vdate OR bmb04 IS NULL) 
                     AND (bmb05 > tm.vdate OR bmb05 IS NULL) 
    END IF
    IF g_bgjob = 'N' THEN            #FUN-570114
       DISPLAY g_cnt TO FORMONLY.cnt
    END IF
END FUNCTION       
 
FUNCTION p601_e()   #顯示品名規格...
   DEFINE  l_ima02    LIKE   ima_file.ima02,
           l_ima021   LIKE   ima_file.ima021,
           l_ima05    LIKE   ima_file.ima05,
           l_ima08    LIKE   ima_file.ima08,
           l_imaacti  LIKE   ima_file.imaacti
   LET g_chr=' '
   IF tm.a IS NULL THEN
      LET l_ima02=NULL 
      LET l_ima021=NULL 
      LET l_ima05=NULL 
      LET l_ima08=NULL 
   ELSE 
       SELECT ima02,ima021,ima05,ima08,imaacti
            INTO l_ima02,l_ima021,l_ima05,l_ima08,l_imaacti
            FROM ima_file
            WHERE ima01=tm.e
       IF SQLCA.sqlcode THEN
          LET g_chr='E'
          LET l_ima02=NULL 
          LET l_ima021=NULL 
          LET l_ima05=NULL 
          LET l_ima08=NULL 
       ELSE 
          IF l_imaacti='N' THEN
               LET g_chr='E'
          END IF
       END IF
   END IF
   IF g_bgjob = 'N' THEN                  #FUN-570114
      DISPLAY l_ima02   TO FORMONLY.f  
      DISPLAY l_ima021  TO FORMONLY.ima021_2
      DISPLAY l_ima05   TO FORMONLY.g     
      DISPLAY l_ima08   TO FORMONLY.h     
   END IF
END FUNCTION       
 
FUNCTION  p601()
  DEFINE  l_sql 	LIKE type_file.chr1000,# RDSQL STATEMENT   #No.FUN-680096 VARCHAR(500)
          l_buf 	LIKE type_file.chr1000,#No.FUN-680096 VARCHAR(80)
          l_buf2	LIKE type_file.chr1000,#No.FUN-680096 VARCHAR(100)
          l_message     LIKE type_file.chr1000,#No.FUN-680096 VARCHAR(100)
          l_cmd         LIKE type_file.chr1000,#No.FUN-680096 VARCHAR(200)
          l_cnt1,l_cnt2	LIKE type_file.num5    # Already-cnt, N-cnt   #No.FUN-680096 SMALLINT
 
     LET l_cmd=" SELECT bmb01,bmb02,",
               " bmb03,bmb04,bmb29", #FUN-550093
               " FROM bmb_file ",
               " WHERE bmb03 ='",tm.a,"'" 
     IF  tm.vdate IS NOT NULL THEN
        LET l_cmd=l_cmd CLIPPED, 
           "  AND (bmb04 <='", tm.vdate,"' OR bmb04 IS NULL )",
                 "  AND (bmb05>'",tm.vdate,"' OR bmb05 IS NULL )" 
     END IF
     PREPARE p601_ppp FROM l_cmd
     IF SQLCA.sqlcode THEN 
        CALL cl_err('P1:',SQLCA.sqlcode,1) 
        CALL cl_batch_bg_javamail('N')                 #No.FUN-570114
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211
        EXIT PROGRAM 
     END IF
     DECLARE p601_cur CURSOR WITH HOLD FOR p601_ppp
 
     LET g_forupd_sql = " SELECT bmb01,bmb02,bmb03,bmb04,bmb29 ", #FUN-550093
                          " FROM bmb_file ",
                         " WHERE bmb01 = ? AND bmb02=? AND bmb03=? AND bmb04=? AND bmb29=? ",
                           " FOR UPDATE "
 
     LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
     DECLARE p601_cl CURSOR FROM g_forupd_sql
 
     IF g_bgjob = 'N' THEN         #FUN-570114
        OPEN WINDOW p601_w2 AT 16,5 WITH 5 ROWS, 70 COLUMNS
     END IF
          
     CALL cl_getmsg('mfg2701',g_lang) RETURNING l_buf
     IF g_bgjob = 'N' THEN         #FUN-570114
        DISPLAY l_buf AT 1,1
     END IF
     CALL cl_getmsg('mfg2724',g_lang) RETURNING l_buf2
     LET l_cnt1 = 0
     LET l_cnt2 = 0
     CALL s_showmsg_init()    #No.FUN-710028
     FOREACH p601_cur INTO sr.*
       IF SQLCA.sqlcode THEN 
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)          #No.FUN-710028
          CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)  #No.FUN-710028
          LET g_success= 'N'
#         EXIT FOREACH      #No.FUN-710028
          CONTINUE FOREACH  #No.FUN-710028
       END IF
 
        #MOD-490062
       LET l_buf[17,20]=g_cnt USING '###&'
       IF g_bgjob = 'N' THEN         #FUN-570114
          DISPLAY l_buf AT 1,1
       END IF
 
       LET l_cnt1 = l_cnt1 + 1
       LET l_buf[34,37]=l_cnt1 USING '###&'
       IF g_bgjob = 'N' THEN         #FUN-570114
          DISPLAY l_buf AT 1,1
       END IF
       #--
 
       OPEN p601_cl USING sr.bmb01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bmb29
 
       IF STATUS THEN
          CALL cl_err("OPEN p601_cl:", STATUS, 1)
          LET g_success= 'N'
          EXIT FOREACH 
       END IF
 
       IF SQLCA.sqlcode THEN 
#         CALL cl_err('lock:',SQLCA.sqlcode,1)         #No.FUN-710028
          CALL s_errmsg('','','lock:',SQLCA.sqlcode,1) #No.FUN-710028
          LET g_success= 'N'
#         EXIT FOREACH      #No.FUN-710028
          CONTINUE FOREACH  #No.FUN-710028
       END IF
       FETCH p601_cl INTO sr.bmb01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bmb29 #FUN-550093
       IF sr.bmb04 IS NULL THEN LET sr.bmb04='        '  END IF
      
       #BugNO:3985
          #LET l_message=l_buf2[01,13],':',sr.bmb01[1,20],' ',#FUN-5B0013 mark
          LET l_message=l_buf2[01,13],':',sr.bmb01 CLIPPED,' ', #FUN-5B0013 add
                        l_buf2[22,25],':',sr.bmb02 USING '####',' ',
                        #l_buf2[27,38],':',sr.bmb03[1,20],' ',#FUN-5B0013 mark
                        l_buf2[27,38],':',sr.bmb03 CLIPPED,' ', #FUN-5B0013 add
                        l_buf2[48,55],':',sr.bmb04,' ',
                        l_buf2[73,80],':',sr.bmb29 #FUN-550093
                       
 
       IF tm.y = 'N' OR g_bgjob = 'N' THEN     #FUN-570114
          LET g_chr = 'Y'
          IF g_bgjob = 'N' THEN      #FUN-570114
             MESSAGE l_message
             DISPLAY l_message AT 4,1
             CALL ui.Interface.refresh()
          END IF
       ELSE
          LET g_chr = ' '
          WHILE g_chr NOT MATCHES "[YyNn]" OR g_chr IS NULL
             LET INT_FLAG = 0  ######add for prompt bug
             IF g_bgjob = 'N' THEN             #FUN-570114--start--
                DISPLAY l_message AT 4,1
                PROMPT  l_buf2[57,69] FOR CHAR g_chr
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
                LET g_chr = "Y"
             END IF                        #FUN-570114---end---
          END WHILE
       END IF
       IF g_success = 'N' THEN
#          EXIT FOREACH       #No.FUN-710028
           CONTINUE FOREACH   #No.FUN-710028
       END IF
       IF g_chr MATCHES "[Yy]" THEN         #確定被替換
          UPDATE bmb_file SET bmb03  =tm.e,
                              bmbmodu=g_user,
                              bmbdate=g_today,
                              bmbcomm='aimp601'
                 WHERE  bmb01 = sr.bmb01 AND bmb02=sr.bmb02 AND bmb03=sr.bmb03 AND bmb04=sr.bmb04 AND bmb29=sr.bmb29 
          IF SQLCA.sqlcode THEN  
#            CALL cl_err('update error',SQLCA.sqlcode,0)  # TQC-660046
#            CALL cl_err3("upd","bmb_file",sr.bmb01,sr.bmb02,SQLCA.sqlcode,"","update error",0)  # TQC-660046 #No.FUN-710028
             CALL s_errmsg(' ',' ','update error',SQLCA.sqlcode,1)  #No.FUN-710028 
             LET g_success = 'N'
#            EXIT FOREACH       #No.FUN-710028
             CONTINUE FOREACH   #No.FUN-710028
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
          IF g_sma.sma845='Y'   #低階碼可否部份重計
             THEN
             LET g_success='Y'
             #CALL s_uima146(sr.bmb03)  #CHI-D10044
             CALL s_uima146(sr.bmb03,0)  #CHI-D10044
             IF g_success = 'N' THEN
#               EXIT FOREACH       #No.FUN-710028
                CONTINUE FOREACH   #No.FUN-710028
             END IF
             #CALL s_uima146(tm.e) #CHI-D10044
             CALL s_uima146(tm.e,0) #CHI-D10044
             IF g_success = 'N' THEN
#               EXIT FOREACH       #No.FUN-710028
                CONTINUE FOREACH   #No.FUN-710028
             END IF
             IF g_bgjob = 'N' THEN                #FUN-570114
                MESSAGE ""
                CALL ui.Interface.refresh()
             END IF
          END IF
        ELSE
          LET l_cnt2 = l_cnt2 + 1
          #DISPLAY l_cnt2 USING "###&" AT 1,53       #CHI-A70049 mark
          LET l_buf[53,56]=l_cnt2 USING '###&'
          IF g_bgjob = 'N' THEN                     #FUN-570114
             DISPLAY l_buf AT 1,1
          END IF
       END IF
     END FOREACH
#No.FUN-710028 --begin                                                                                                              
     IF g_totsuccess="N" THEN                                                                                                        
        LET g_success="N"                                                                                                            
     END IF                                                                                                                          
#No.FUN-710028 --end
 
     CLOSE p601_cl
     CLOSE WINDOW p601_w2
     
END FUNCTION
