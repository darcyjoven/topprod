# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: asfp601.4gl
# Descriptions...: 製程追蹤資料刪除作業
# Date & Author..: 92/08/12 By Yen
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-710026 07/01/15 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-770004 07/07/03 By mike 幫助按鈕是灰色的
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.TQC-D70072 13/07/22 By lujh 1.“工單編號”，“生產料件”欄位建議增加開窗
#                                                 2.無法ctrl+g
 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
          wc    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(300)# Where condition
          a     LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
          END RECORD,
       sr RECORD
          sfb01	LIKE sfb_file.sfb01,
          sfb02	LIKE sfb_file.sfb02,
          sfb04	LIKE sfb_file.sfb04,
          sfb05	LIKE sfb_file.sfb05
          END RECORD
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680121 INTEGER
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
 
 
   IF s_shut(0) THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
      EXIT PROGRAM 
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   CALL p601_tm(0,0)				#
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION p601_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5          #No.FUN-680121 SMALLINT
   DEFINE   l_flag        LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
 
   LET p_row = 6
   LET p_col = 20
   OPEN WINDOW p601_w AT p_row,p_col WITH FORM "asf/42f/asfp601"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
 
   CALL cl_opmsg('q')
 
   WHILE TRUE
      CLEAR FORM
      INITIALIZE tm.* TO NULL			# Default condition
      LET tm.a = 'Y'
 
      CONSTRUCT BY NAME tm.wc ON sfb01,sfb05
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT CONSTRUCT
 
         ON ACTION help                                      #No.TQC-770004
            LET g_action_choice="help"                       #No.TQC-770004 
            CALL cl_show_help()                              #No.TQC-770004 
            CONTINUE CONSTRUCT                               #No.TQC-770004 
           
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #TQC-D70072--add--str--
         ON ACTION controlp
           CASE
              WHEN INFIELD(sfb01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form = "q_sfb01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb01
                  NEXT FIELD sfb01
              WHEN INFIELD(sfb05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form = "q_sfb05_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb05
                  NEXT FIELD sfb05
              OTHERWISE
                 EXIT CASE
           END CASE

         ON ACTION controlg
            CALL cl_cmdask()
         #TQC-D70072--add--end--

      END CONSTRUCT
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p601_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
 
      CALL p601_cnt() RETURNING g_cnt
 
      IF g_cnt = 0 THEN
         CALL cl_err('construct:','mfg6159',0)
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME tm.a  # Condition
 
      INPUT BY NAME tm.a WITHOUT DEFAULTS
 
         AFTER FIELD a
            IF tm.a NOT MATCHES "[YN]" THEN
               NEXT FIELD a
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()	# Command execution
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
     
         ON ACTION help                          #No.TQC-770004 
          LET g_action_choice="help"            #No.TQC-770004 
          CALL cl_show_help()                   #No.TQC-770004 
          CONTINUE INPUT                       #No.TQC-770004 
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
 
      IF cl_sure(20,22) THEN
         CALL cl_wait()
         CALL asfp601()    #show 欲刪除之資料
         CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
         IF l_flag THEN
            CONTINUE WHILE
         ELSE
            EXIT WHILE
         END IF
      END IF
      ERROR ""
   END WHILE
 
   CLOSE WINDOW p601_w
 
END FUNCTION
 
FUNCTION asfp601()
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0090
      DEFINE   l_sql  LIKE type_file.chr1000,       # RDSQL STATEMENT  #No.FUN-680121 VARCHAR(601) #No.FUN-6A0090
          l_buf 	LIKE type_file.chr1000 		#                                      #No.FUN-680121 VARCHAR(80)
 
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND sfbuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
     #End:FUN-980030
 
 
     LET l_sql = " SELECT sfb01,sfb02,sfb04,sfb05 ",
                 " FROM sfb_file",
                 " WHERE  sfb04 IN ('1')",
                 "   AND  sfb24  = 'Y'",
                 "   AND  sfbacti = 'Y'",
                 "   AND ",tm.wc
 
     PREPARE p601_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1)
         RETURN
     END IF
     DECLARE p601_cs CURSOR WITH HOLD FOR p601_prepare1
     LET g_chr = ' '
     IF tm.a = 'N' THEN
        LET g_chr = 'Y'
        CALL p601_del()
     ELSE
      #  OPEN WINDOW p601_w2 AT 16,10 WITH 6 ROWS, 60 COLUMNS
      #
      #  CALL cl_getmsg('mfg6158',g_lang) RETURNING l_buf
      #  DISPLAY l_buf AT 1,1
      #  CALL cl_getmsg('mfg2730',g_lang) RETURNING l_buf
      #  DISPLAY l_buf AT 2,1
      #  CALL cl_getmsg('mfg6155',g_lang) RETURNING l_buf
      #  DISPLAY l_buf AT 4,1
      # #CALL cl_getmsg('mfg6156',g_lang) RETURNING l_buf
      # #DISPLAY l_buf AT 5,1
         CALL p601_cnt() RETURNING g_cnt
        #DISPLAY g_cnt USING "###&" AT 2,17   #CHI-A70049 mark
         CALL p601_del()
      #  CLOSE WINDOW p601_w2
     END IF
 
END FUNCTION
 
FUNCTION p601_del()
   DEFINE l_cnt1,l_cnt2	LIKE type_file.num5    	# Already-cnt, N-cnt        #No.FUN-680121 SMALLINT
   DEFINE l_buf,l_buf1  LIKE type_file.chr1000                              #No.FUN-680121 VARCHAR(120)
     LET l_cnt1 = 0
     LET l_cnt2 = 0
     FOREACH p601_cs INTO sr.*
        IF SQLCA.sqlcode THEN
       	   		CALL cl_err('foreach:',SQLCA.sqlcode,1)
	   		EXIT FOREACH
        END IF
        IF tm.a = 'Y' THEN
            LET l_cnt1 = l_cnt1 + 1
           #清除資料總筆數:/明細--工單編號:工單型態: 料件編號:筆數:
            CALL cl_getmsg('mfg6155',g_lang) RETURNING l_buf1
 
            LET l_buf=l_buf1[1,15] CLIPPED,g_cnt USING '##&' CLIPPED
            LET l_buf=l_buf CLIPPED,' ',l_buf1[16,31] CLIPPED,sr.sfb01 CLIPPED
            LET l_buf=l_buf CLIPPED,' ',l_buf1[32,40] CLIPPED,sr.sfb02 CLIPPED
            LET l_buf=l_buf CLIPPED,' ',l_buf1[42,50] CLIPPED,sr.sfb05 CLIPPED
            LET l_buf=l_buf CLIPPED,' ',l_buf1[51,55] CLIPPED,l_cnt1 CLIPPED
            IF NOT cl_confirm(l_buf CLIPPED) THEN
               RETURN
            ELSE
               LET g_chr = 'Y'
            END IF
        ELSE
            MESSAGE sr.sfb01
            CALL ui.Interface.refresh()
        END IF
        LET g_success = 'Y'
        BEGIN WORK
        IF g_chr MATCHES "[Yy]" THEN
           DELETE FROM ecm_file WHERE ecm01 = sr.sfb01
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
               LET g_success = 'N'
#              CALL cl_err('(asfp601:ckp#1)',SQLCA.sqlcode,1)   #No.FUN-660128
#              CALL cl_err3("del","ecm_file",sr.sfb01,"",SQLCA.sqlcode,"","(asfp601:ckp#1)",1)    #No.FUN-660128 #NO.FUN-710026
               CALL s_errmsg('ecm','sr.sfb01','(asfp601:ckp#1)',SQLCA.sqlcode,1)                  #NO.FUN-710026
           END IF
           UPDATE sfb_file SET sfb24 = 'N'
              WHERE sfb01 = sr.sfb01
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
              LET g_success = 'N'
#             CALL cl_err('(asfp601:ckp#2)',SQLCA.sqlcode,1)   #No.FUN-660128
#             CALL cl_err3("upd","sfb_file",sr.sfb01,"",SQLCA.sqlcode,"","(asfp601:ckp#2)",1)    #No.FUN-660128 #NO.FUN-710026
              CALL s_errmsg('sfb01','sr.sfb01','(asfp601:ckp#2)',SQLCA.sqlcode,1)                #NO.FUN-710026  
           END IF
       ELSE
           IF tm.a = 'Y' THEN
              LET l_cnt2 = l_cnt2 + 1
             #DISPLAY l_cnt2 USING "###&" AT 2,53  #CHI-A70049 mark
           END IF
           LET g_success = 'N'
       END IF
       IF g_success = 'Y' THEN
          CALL cl_cmmsg(1) COMMIT WORK
       ELSE
          CALL cl_rbmsg(1) ROLLBACK WORK
       END IF
     END FOREACH
END FUNCTION
 
FUNCTION p601_cnt()
   DEFINE l_sql 	LIKE type_file.chr1000	# RDSQL STATEMENT        #No.FUN-680121 VARCHAR(601)
     LET g_cnt = 0
     LET l_sql = " SELECT COUNT(*) ",
                 " FROM sfb_file",
                 " WHERE  sfb04 IN ('1')",
                 "   AND  sfb24  = 'Y'",
                 "   AND  sfbacti = 'Y'",
                 "   AND ",tm.wc
 
     PREPARE p601_precount FROM l_sql
     DECLARE p601_count CURSOR FOR p601_precount
     OPEN p601_count
     FETCH p601_count INTO g_cnt
     RETURN g_cnt
END FUNCTION
