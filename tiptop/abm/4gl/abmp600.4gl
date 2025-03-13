# Prog. Version..: '5.30.06-13.04.01(00009)'     #
#
# Pattern name...: abmp600.4gl
# Descriptions...: 元件刪除巨集作業
# Input parameter: 
# Return code....: 
# Date & Author..: 91/08/12 By Wu 
# Modify.......:MOD-490062 04/09/02 ching 改變DISPLAY訊息
# Modify.........: No.FUN-550093 05/05/31 By kim 配方BOM,特性代碼
# Modify.........: No.MOD-550207 05/05/31 By kim Line.22 Define錯誤
# Modify.........: No.FUN-5B0013 05/11/02 By Rosayu 將料號/品名/規格 欄位設成[1,,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.FUN-570114 06/02/16 By saki 批次背景執行
# Modify.........: No.TQC-660046 06/06/12 By xumin cl_err To cl_err3
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-710028 07/01/23 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-980001 09/08/06 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No.FUN-AA0059 10/10/26 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting    1、將cl_used()改成標準格式，用g_prog
#                                                            2、離開前未加cl_used(2)
# Modify.........: No.CHI-D10044 13/03/04 By bart s_uima146()參數變更
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
           bmb03 LIKE bmb_file.bmb03,
          vdate  LIKE type_file.dat,    #No.FUN-680096 DATE
          y     LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
          END RECORD,
       sr RECORD
          bmb01	LIKE bmb_file.bmb01,
          bmb02	LIKE bmb_file.bmb02, #MOD-550207
          bmb03	LIKE bmb_file.bmb03,
          bmb04	LIKE bmb_file.bmb04,
          bmb29	LIKE bmb_file.bmb29  #FUN-550093
          END RECORD
 
DEFINE   g_forupd_sql    STRING                  #SELECT ... FOR UPDATE SQL
DEFINE   g_chr           LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_msg           LIKE ze_file.ze03,      #No.FUN-680096 VARCHAR(72)
         l_flag          LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
         g_change_lang   LIKE type_file.chr1     #是否有做語言切換 #No.FUN-680096 VARCHAR(1)
#     DEFINEl_time   LIKE type_file.chr8	             #No.FUN-6A0060
 
MAIN
DEFINE ls_date STRING                          #No.FUN-570114
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   #No.FUN-570114 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.bmb03 = ARG_VAL(1)
   LET ls_date  = ARG_VAL(2)
   LET tm.vdate = cl_batch_bg_date_convert(ls_date)
   LET tm.y     = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
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
 
   #  CALL cl_used('abmp600',g_time,1) RETURNING g_time  #No.FUN-570114 #No.FUN-6A0060   #FUN-B30211
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-570114 #No.FUN-6A0060   #FUN-B30211
 
 
   IF g_sma.sma101='N' THEN 
      CALL cl_err('','abm-801',5)
      CALL cl_batch_bg_javamail('N')                  #No.FUN-570114
      EXIT PROGRAM 
   END IF    #NO:6834
   IF s_shut(0) THEN EXIT PROGRAM END IF
   #No.FUN-570114 --start--
#  CALL s_decl_bmb()
#  CALL p600_tm(0,0)			
   WHILE TRUE
     IF g_bgjob = 'N' THEN
        CALL s_decl_bmb()
        CALL p600_tm(0,0)
        IF cl_sure(21,21) THEN
           CALL cl_wait()
           LET g_success = 'Y'
           BEGIN WORK
           CALL abmp600()
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
              CLOSE WINDOW p600_w
              EXIT WHILE
           END IF
        ELSE
           CONTINUE WHILE
        END IF
        CLOSE WINDOW p600_w
     ELSE
        LET g_success = 'Y'
        BEGIN WORK
        CALL s_decl_bmb()
        CALL abmp600()
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
   #CALL cl_used('abmp600',g_time,2) RETURNING g_time     #No.FUN-6A0060      #FUN-B30211
   CALL cl_used(g_prog,g_time,2) RETURNING g_time     #No.FUN-6A0060      #FUN-B30211
   #No.FUN-570114 ---end---
END MAIN
 
FUNCTION p600_tm(p_row,p_col)
   DEFINE   p_row,p_col	  LIKE type_file.num5,     #No.FUN-680096 SMALLINT
            lc_cmd        LIKE type_file.chr1000,  #No.FUN-570114  #No.FUN-680096 VARCHAR(500)
            l_flag        LIKE type_file.num10     #No.FUN-680096 INTEGER
        #   l_bdate       LIKE bmx_file.bmx07,
        #   l_edate       LIKE bmx_file.bmx08
 
   LET p_row = 6 LET p_col = 23
 
   OPEN WINDOW p600_w AT p_row,p_col WITH FORM "abm/42f/abmp600" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('q')
 
#  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-570114  #No.FUN-6A0060
   WHILE TRUE
      CLEAR FORM 
      LET g_success = 'Y'
      LET g_change_lang = FALSE
      INITIALIZE tm.* TO NULL			# Default condition
      LET tm.y = 'Y'
      LET tm.vdate = g_today
      LET g_bgjob = 'N'                                     #No.FUN-570114
      INPUT BY NAME tm.bmb03,tm.vdate,tm.y,g_bgjob WITHOUT DEFAULTS 
                                                  #No.FUN-570114 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         BEFORE FIELD bmb03
           #CHI-A70049---mark---start---
           #IF g_sma.sma60 = 'Y' THEN		# 若須分段輸入
               #CALL s_inp5(9,38,tm.bmb03) RETURNING tm.bmb03
               #DISPLAY tm.bmb03 TO bmb03 
           #END IF
           #CHI-A70049---mark---end---
      
         AFTER FIELD bmb03
            IF tm.bmb03 IS NULL THEN 
               NEXT FIELD bmb03
            ELSE 
               CALL p600_bmb03()
               IF g_chr = 'E' THEN 
                  CALL cl_err(tm.bmb03,'mfg0002',0)
                  NEXT FIELD bmb03
               END IF
            END IF
      
         AFTER FIELD vdate
            IF tm.vdate IS NULL THEN
               LET tm.vdate = ' '
            END IF
            CALL p600_cnt()
            IF g_cnt=0 THEN
               CALL cl_err(' ','mfg2601',0)
               NEXT FIELD bmb03
            END IF
 
         AFTER FIELD y
            IF tm.y NOT MATCHES "[YN]" THEN
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
 
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF tm.bmb03 IS NOT NULL THEN 
               CALL p600_bmb03()
               IF g_chr = 'E' THEN 
                  CALL cl_err(tm.bmb03,'mfg0002',0)
                  NEXT FIELD bmb03
               END IF
            END IF
            IF tm.vdate IS NULL THEN
               LET tm.vdate = ' '
            END IF
            CALL p600_cnt()
            IF g_cnt=0 THEN
               CALL cl_err(' ','mfg2601',0)
               NEXT FIELD bmb03
            END IF
         #No.FUN-570114 ---end---
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
	    CALL cl_cmdask()
        ON ACTION CONTROLP     #查詢條件 
            CASE
               WHEN INFIELD(bmb03) #料件主檔
#FUN-AA0059 --Begin--
                 #   CALL cl_init_qry_var()
                 #   LET g_qryparam.form = "q_ima"
                 #   LET g_qryparam.default1 = tm.bmb03    
                 #   CALL cl_create_qry() RETURNING tm.bmb03    
                    CALL q_sel_ima(FALSE, "q_ima", "",tm.bmb03, "", "", "", "" ,"",'' )  RETURNING tm.bmb03 
#FUN-AA0059 --End--
#                    CALL FGL_DIALOG_SETBUFFER( tm.bmb03    )
                    DISPLAY BY NAME tm.bmb03    
                    NEXT FIELD bmb03
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
#            CALL cl_dynamic_locale()               #No.FUN-570114
#         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
      IF g_change_lang = TRUE THEN
         LET g_change_lang = FALSE                 #No.FUN-570114
         CALL cl_dynamic_locale()                  #No.FUN-570114
         CALL cl_show_fld_cont()                   #No.FUN-570114   No.FUN-550037 hmf
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN 
         LET INT_FLAG = 0 
         CLOSE WINDOW p600_w                       #No.FUN-570114
         CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B30211
         EXIT PROGRAM 
      END IF
      #No.FUN-570114 --start--
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = 'abmp600'
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('abmp600','9031',1)
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",tm.bmb03 CLIPPED,"'",
                         " '",tm.vdate CLIPPED,"'",
                         " 'N' ",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('abmp600',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p600_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
#     BEGIN WORK
 
#     IF cl_sure(20,22) THEN
#        CALL cl_wait()
#        CALL abmp600()    #show 欲刪除之資料
#       IF g_success = 'Y' THEN
#          COMMIT WORK
#          CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#       ELSE
#          ROLLBACK WORK
#          CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#       END IF
#       IF l_flag THEN
#          CLEAR FORM
#          CONTINUE WHILE
#       ELSE
#          EXIT WHILE
#       END IF
#     END IF
#     ERROR ""
   END WHILE
#    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
#  CLOSE WINDOW p600_w
     #No.FUN-570114 ---end---
END FUNCTION
 
FUNCTION abmp600()
  DEFINE  l_sql 	LIKE type_file.chr1000, # RDSQL STATEMENT   #No.FUN-680096 VARCHAR(600)
          l_buf 	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(80)
          l_buf2	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(80)
          l_message     LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(120)
          l_cnt1,l_cnt2	LIKE type_file.num5     # Already-cnt, N-cnt    #No.FUN-680096 SMALLINT
 
     IF tm.vdate IS NULL OR tm.vdate = ' '
     THEN LET l_sql = " SELECT bmb01,bmb02,bmb03,bmb04,bmb29 ", #FUN-550093
                      " FROM bmb_file",
                      " WHERE bmb03 ='",tm.bmb03,"'" 
                                                
     ELSE LET l_sql = " SELECT DISTINCT bmb01,bmb02,bmb03,bmb04,bmb29 ", #FUN-550093
                      "  FROM bmb_file",
                      " WHERE bmb03 = '",tm.bmb03,"' AND ( ",
                      " bmb04 <= '",tm.vdate,"' OR ", 
                      "  bmb04 IS NULL"," ) AND (",
                      " bmb05 > '",tm.vdate,"' OR ",
                      "  bmb05 IS NULL ", " )"
     END IF 
     PREPARE p600_prepare1 FROM l_sql
     DECLARE p600_cs CURSOR WITH HOLD FOR p600_prepare1
 
     LET g_forupd_sql = " SELECT bmb01,bmb02,bmb03,bmb04,bmb29 ",
                          " FROM bmb_file WHERE bmb01 = ? AND bmb02=? AND bmb03=? AND bmb04=? AND bmb29=? ",
                           " FOR UPDATE "
 
     LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
     DECLARE p600_cl CURSOR FROM g_forupd_sql
 
     IF g_bgjob = 'N' THEN       #FUN-570114
        OPEN WINDOW p600_w2 AT 16,5 WITH 5 ROWS, 70 COLUMNS
     END IF
          
     CALL cl_getmsg('mfg2730',g_lang) RETURNING l_buf
     IF g_bgjob = 'N' THEN       #FUN-570114
        DISPLAY l_buf AT 1,1
     END IF
     CALL cl_getmsg('mfg2704',g_lang) RETURNING l_buf2
     LET l_cnt1 = 0
     LET l_cnt2 = 0
#    LET g_cnt = NULL
     CALL s_showmsg_init()    #No.FUN-710028
     FOREACH p600_cs INTO sr.*
       IF SQLCA.sqlcode THEN 
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)          #No.FUN-710028
          CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)  #No.FUN-710028
          LET g_success= 'N'
          EXIT FOREACH 
       END IF
#No.FUN-710028 --begin                                                                                                              
       IF g_success='N' THEN                                                                                                         
          LET g_totsuccess='N'                                                                                                       
          LET g_success="Y"                                                                                                          
       END IF                                                                                                                        
#No.FUN-710028 -end
       
        #MOD-490062
       LET l_buf[17,20]=g_cnt USING '###&'
       IF g_bgjob = 'N' THEN       #FUN-570114
          DISPLAY l_buf AT 1,1
       END IF
 
       LET l_cnt1 = l_cnt1 + 1
       LET l_buf[34,37]=l_cnt1 USING '###&'
       IF g_bgjob = 'N' THEN       #FUN-570114
          DISPLAY l_buf AT 1,1
       END IF
       #--
 
       OPEN p600_cl USING sr.bmb01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bmb29
 
       IF STATUS THEN
#         CALL cl_err("OPEN p600_cl:", STATUS, 1)          #No.FUN-710028
          CALL s_errmsg('','',"OPEN p600_cl:", STATUS, 1)  #No.FUN-710028
          LET g_success= 'N'
#         EXIT FOREACH      #No.FUN-710028
          CONTINUE FOREACH  #No.FUN-710028
       END IF
 
           IF STATUS THEN 
#              CALL cl_err('lock:',SQLCA.sqlcode,1)         #No.FUN-710028
               CALL s_errmsg('','','lock:',SQLCA.sqlcode,1) #No.FUN-710028
               LET g_success= 'N'
#              EXIT FOREACH      #No.FUN-710028
               CONTINUE FOREACH  #No.FUN-710028
           END IF
       FETCH p600_cl INTO sr.bmb01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bmb29
        
          #BugNO:3985
          #LET l_message=l_buf2[07,14],':',sr.bmb01[1,20],' ',#FUN-5B0013 mark
          LET l_message=l_buf2[07,14],':',sr.bmb01 CLIPPED,' ', #FUN-5B0013 add
                        l_buf2[22,25],':',sr.bmb02 USING '####',' ',
                        #l_buf2[33,40],':',sr.bmb03[1,20],' ', #FUN-5B0013 mark
                        l_buf2[33,40],':',sr.bmb03 CLIPPED,' ', #FUN-5B0013 add
                        l_buf2[48,55],':',sr.bmb04,' ',
                        l_buf2[71,78],':',sr.bmb29  #FUN-550093
                       #l_buf2[57,67]
 
       IF tm.y = 'N' OR g_bgjob = "N" THEN  #No.FUN-570114
          LET g_chr = 'Y'
          IF g_bgjob = 'N' THEN          #FUN-570114
             MESSAGE l_message
             DISPLAY l_message AT 4,1
             CALL ui.Interface.refresh()
          END IF
       ELSE
          LET g_chr = ' '
          WHILE g_chr NOT MATCHES "[YyNn]" OR g_chr IS NULL
             LET INT_FLAG = 0  ######add for prompt bug
             IF g_bgjob = 'N' THEN       #FUN-570114
                DISPLAY l_message AT 4,1
                PROMPT l_buf2[57,67] FOR CHAR g_chr
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
             END IF
          END WHILE
       END IF
       IF g_success = 'N' THEN
#          EXIT FOREACH       #No.FUN-710028
           CONTINUE FOREACH   #No.FUN-710028
       END IF
       IF g_chr MATCHES "[Yy]" THEN
          IF g_sma.sma845='Y'   #低階碼可否部份重計
             THEN
             LET g_success='Y'
             #CALL s_uima146(sr.bmb03)  #CHI-D10044
             CALL s_uima146(sr.bmb03,0)  #CHI-D10044
             IF g_bgjob = 'N' THEN       #FUN-570114
                MESSAGE ""
                CALL ui.Interface.refresh()
             END IF
             IF g_success = 'N' THEN
#               EXIT FOREACH       #No.FUN-710028
                CONTINUE FOREACH   #No.FUN-710028
             END IF
          END IF
 
          DELETE FROM bmb_file WHERE bmb01 = sr.bmb01 AND bmb02=sr.bmb02 AND bmb03=sr.bmb03 AND bmb04=sr.bmb04 AND bmb29=sr.bmb29
          IF SQLCA.sqlcode THEN 
         #   CALL cl_err('delete error',SQLCA.sqlcode,0) #No.TQC-660046
         #   CALL cl_err3("del","bmb_file",sr.bmb01,sr.bmb02,SQLCA.sqlcode,"","delete error",0)  #No.TQC-660046 #No.FUN-710028
             CALL s_errmsg(' ',' ','delete error',SQLCA.sqlcode,1) #No.FUN-710028
             LET g_success = 'N'
#            EXIT FOREACH       #No.FUN-710028
             CONTINUE FOREACH   #No.FUN-710028
          END IF
          LET g_msg=TIME
          INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)     #FUN-980001 add plant & legal 
             VALUES ('abmp600',g_user,g_today,g_msg,' ','delete',g_plant,g_legal)#FUN-980001 add plant & legal 
          IF SQLCA.sqlcode THEN 
       #     CALL cl_err('insert error',SQLCA.sqlcode,0)  #No.TQC-660046
       #     CALL cl_err3("ins","azo_file","abmp600",g_user,SQLCA.sqlcode,"","insert error",0)   #No.TQC-660046 #No.FUN-710028
             LET g_showmsg = 'abmp600',"/",g_user    #No.FUN-710028
             CALL s_errmsg('azo01,azo02',g_showmsg,'insert error',SQLCA.sqlcode,1)  #No.FUN-710028
             LET g_success = 'N'
#            EXIT FOREACH       #No.FUN-710028
             CONTINUE FOREACH   #No.FUN-710028
          END IF
        ELSE
          LET l_cnt2 = l_cnt2 + 1
          #DISPLAY l_cnt2 USING "###&" AT 1,53    #CHI-A70049 mark
          LET l_buf[53,56]=l_cnt2 USING '###&'
          IF g_bgjob = 'N' THEN       #FUN-570114
             DISPLAY l_buf AT 1,1
          END IF
       END IF
#################@ 如刪掉元件後,其主件無其他元件則上主件也刪除#######
       CALL p600_u_head()
       IF g_success = 'N' THEN
#         EXIT FOREACH      #No.FUN-710028
          CONTINUE FOREACH  #No.FUN-710028
       END IF
     END FOREACH
#No.FUN-710028 --begin                                                                                                              
     IF g_totsuccess="N" THEN                                                                                                        
        LET g_success="N"                                                                                                            
     END IF                                                                                                                          
#No.FUN-710028 --end
 
     CLOSE p600_cl
     IF g_bgjob = 'N' THEN       #FUN-570114
        CLOSE WINDOW p600_w2
     END IF
     
END FUNCTION
   
FUNCTION p600_u_head()
   DEFINE l_cnt    LIKE type_file.num5          #No.FUN-680096 SMALLINT
 
  SELECT COUNT(*) INTO l_cnt FROM bmb_file WHERE bmb01 = sr.bmb01 
                                             AND bmb29 = sr.bmb29  #FUN-550093  
  IF l_cnt <= 0 THEN
     DELETE FROM bma_file WHERE bma01 = sr.bmb01 
                            AND bma06 = sr.bmb29  #FUN-550093
     IF SQLCA.sqlcode THEN 
  #     CALL cl_err('delete error',SQLCA.sqlcode,0) #No.TQC-660046
  #     CALL cl_err3("del","bma_file",sr.bmb01,sr.bmb29,SQLCA.sqlcode,"","delete error",0)   #No.TQC-660046 #No.FUN-710028
        LET g_showmsg = sr.bmb01,"/",sr.bmb29    #No.FUN-710028
        CALL s_errmsg('bma01,bma06',g_showmsg,'delete error',SQLCA.sqlcode,1) #No.FUN-710028
        LET g_success = 'N'
     END IF
  END IF
END FUNCTION
   
FUNCTION p600_bmb03()  #元件料件編號
    DEFINE l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima05   LIKE ima_file.ima05,
           l_imaacti LIKE ima_file.imaacti
 
    LET g_chr = ' '
    IF tm.bmb03 IS NULL THEN
        LET l_ima02=NULL
        LET l_ima021=NULL
        LET l_ima05=NULL
        LET g_chr = 'E'
    ELSE
        SELECT  ima02,ima021,ima05,imaacti
           INTO l_ima02,l_ima021,l_ima05,l_imaacti
           FROM ima_file WHERE ima01 = tm.bmb03 
          IF SQLCA.sqlcode THEN
             LET g_chr = 'E'
             LET l_ima02 = NULL
             LET l_ima021= NULL
             LET l_ima05 = NULL
          ELSE
            IF l_imaacti='N' THEN
               LET g_chr = 'E'
            END IF
          END IF
    END IF
    IF g_bgjob = 'N' THEN       #FUN-570114
       DISPLAY l_ima02 TO FORMONLY.ima02 
       DISPLAY l_ima021 TO FORMONLY.ima021 
       DISPLAY l_ima05 TO FORMONLY.ima05 
    END IF
END FUNCTION
 
FUNCTION p600_cnt()
   IF tm.vdate=' ' OR tm.vdate IS NULL THEN
        SELECT COUNT(*) INTO g_cnt FROM bmb_file WHERE bmb03=tm.bmb03
        IF g_bgjob = 'N' THEN       #FUN-570114
           DISPLAY g_cnt TO FORMONLY.cnt      
        END IF
   ELSE
        SELECT COUNT(*) INTO g_cnt FROM bmb_file
               WHERE bmb03=tm.bmb03
                     AND (bmb04 <= tm.vdate OR bmb04 IS NULL) 
                     AND (bmb05 > tm.vdate OR bmb05 IS NULL) 
        IF g_bgjob = 'N' THEN       #FUN-570114
           DISPLAY g_cnt TO FORMONLY.cnt      
        END IF
    END IF
END FUNCTION       
