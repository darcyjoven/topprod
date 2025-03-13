# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: asfp201.4gl
# Descriptions...: 工單緊急比率重新計算
# Date & Author..: 92/08/18 By Nora
# Modify.........: NO.FUN-510040 05/02/03 By Echo 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-570151 06/03/13 By yiting 批次作業背景執行功能
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-710026 07/01/15 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-8A0086 08/10/21 By baofei 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:TQC-D70065 13/07/22 By lujh 1.“工單類型”，“工單單號”，“生產料件”欄位增加開窗
#                                                 2.無法ctrl+g
#                                                 3.幫助按鈕灰色，無法開啟help

IMPORT os   #No.FUN-9C0009  
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD                # Print condition RECORD
              wc      STRING,           # TQC-630166
              a       LIKE type_file.chr4,          #No.FUN-680121 VARCHAR(3) # 包含尚未發放工單
              edate   LIKE type_file.dat,           #No.FUN-680121 DATE # 完工截止日期
              b       LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1) # 是否列印工單新舊緊急比率
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE   l_flag         LIKE type_file.chr1,                  #No.FUN-570151        #No.FUN-680121 VARCHAR(1)
         g_change_lang  LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1) #是否有做語言切換 No.FUN-570151
         ls_date        STRING                  #->No.FUN-570151
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
#->No.FUN-570151 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.wc    = ARG_VAL(1)
   LET tm.a     = ARG_VAL(2)
   LET ls_date  = ARG_VAL(3)
   LET tm.edate = cl_batch_bg_date_convert(ls_date)   #完工截止日期
   LET tm.b     = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0090

   WHILE TRUE
      LET g_success = 'Y'
      LET g_change_lang = FALSE
      IF g_bgjob = 'N' THEN
         CALL asfp201_tm(0,0)
         IF cl_sure(21,21) THEN
            BEGIN WORK                #NO.FUN-710026 add
            CALL asfp201()
            CALL s_showmsg()          #NO.FUN-710026
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW asfp201_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         BEGIN WORK                #NO.FUN-710026 add
         CALL asfp201()
         CALL s_showmsg()          #NO.FUN-710026
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0090
END MAIN
 
FUNCTION asfp201_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5          #No.FUN-680121 SMALLINT
   DEFINE   l_flag        LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
            l_cmd         LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(400)
   DEFINE   lc_cmd        LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(500) #FUN-570151
 
   OPEN WINDOW asfp201_w WITH FORM "asf/42f/asfp201"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a    = 'Y'
   LET tm.edate= g_lastdat
   LET tm.b    = 'Y'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON sfb02,sfb01,sfb05
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON IDLE g_idle_seconds
      ON ACTION locale
#NO.FUN-570151 mark
#          CALL cl_dynamic_locale()
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#          CALL cl_on_idle()
#NO.FUN-570151 mark
           LET g_change_lang = TRUE          #FUN-570151
           EXIT CONSTRUCT
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---

         #TQC-D70065--add--str--
         ON ACTION controlp
           CASE
              WHEN INFIELD(sfb02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form = "q_sfb022"
                  LET g_qryparam.arg1 = g_lang
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb02
                  NEXT FIELD sfb02
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

         ON ACTION help
            CALL cl_show_help()
         #TQC-D70065--add--end--

 
      END CONSTRUCT
 
#NO.FUN-570151 start---
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         CLOSE WINDOW asfp201_w
#         EXIT PROGRAM
#      END IF
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW asfp201_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
#NO.FUN-570151 end---
 
      DISPLAY BY NAME tm.a,tm.edate,tm.b
             				        # Condition
      #INPUT BY NAME tm.a,tm.edate,tm.b WITHOUT DEFAULTS
      INPUT BY NAME tm.a,tm.edate,tm.b,g_bgjob WITHOUT DEFAULTS  #NO.FUN-570151
 
         AFTER FIELD a
            IF tm.a NOT MATCHES "[YN]" THEN
               NEXT FIELD a
            END IF
 
         AFTER FIELD edate
            IF tm.edate IS NULL THEN
               NEXT FIELD edate
            END IF
 
         AFTER FIELD b
            IF tm.b NOT MATCHES "[YN]" THEN
               NEXT FIELD b
            END IF
 
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
         ON ACTION locale        #FUN-570151
            LET g_change_lang = TRUE
            EXIT INPUT
 
         #TQC-D70065--add--str--
         ON ACTION help
            CALL cl_show_help()
         #TQC-D70065--add--end--
        
      END INPUT
 
#NO.FUN-570151 start--
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         CLOSE WINDOW asfp201_w
#         EXIT PROGRAM
#      END IF
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW asfp201_w           #FUN-570151
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM                     #FUN-570151
   END IF
 
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'asfp201'
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('asfp201','9031',1)   
        ELSE
           LET tm.wc = cl_replace_str(tm.wc,"'","\"")
           LET lc_cmd = lc_cmd CLIPPED,
                        " '",tm.wc    CLIPPED, "'",
                        " '",tm.a     CLIPPED, "'",
                        " '",tm.edate CLIPPED, "'",
                        " '",tm.b     CLIPPED, "'",
                        " '",g_bgjob CLIPPED, "'"
           CALL cl_cmdat('asfp201',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW asfp201_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
     EXIT WHILE
END WHILE
#FUN-570151 --end--
 
#NO.FUN-570151 mark--
#      CALL cl_wait()
#      CALL asfp201()
#      CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#      IF l_flag THEN
#         CONTINUE WHILE
#      ELSE
#         EXIT WHILE
#      END IF
#      ERROR ""
#   END WHILE
#   CLOSE WINDOW asfp201_w
#NO.FUN-570151 mark
 
END FUNCTION
 
FUNCTION asfp201()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20) # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
#         l_sql     LIKE type_file.chr1000,      # RDSQL STATEMENT TQC-630166        #No.FUN-680121
          l_sql     STRING,          # TQC-630166
          l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          l_cmd     LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(30)
	  l_crate   LIKE sfb_file.sfb34,			#critical rate
	  l_ss	    LIKE type_file.num5,          #No.FUN-680121 SMALLINT #status code 1:ERROR
          sr            RECORD
		sfb01   LIKE sfb_file.sfb01,		#工單編號
   		sfb05	LIKE sfb_file.sfb05,		#料件編號
  		sfb06	LIKE sfb_file.sfb06,		#製程編號
   		sfb071  LIKE sfb_file.sfb071,		#有效日期
		sfb08	LIKE sfb_file.sfb08,		#生產數量
		sfb09	LIKE sfb_file.sfb09,		#完工數量
		sfb10	LIKE sfb_file.sfb10,		#再加工數量
		sfb11	LIKE sfb_file.sfb11,		#F.Q.C數量
		sfb12	LIKE sfb_file.sfb12,		#報廢數量
		sfb15	LIKE sfb_file.sfb15,		#完工日
		sfb17	LIKE sfb_file.sfb17,		#己完工作業序號
		ima56	LIKE ima_file.ima56,
		ima59   LIKE ima_file.ima59,
		ima60	LIKE ima_file.ima60
                        END RECORD,
          sr1           RECORD
		sfb02   LIKE sfb_file.sfb02,		#工單型態
		sfb04   LIKE sfb_file.sfb04,		#工單狀態
		sfb13   LIKE sfb_file.sfb13,		#開工日期
		sfb34   LIKE sfb_file.sfb34,		#緊急比率
		sfb40   LIKE sfb_file.sfb40,		#優先順序
		ima55   LIKE ima_file.ima55
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
 
     LET l_sql = "SELECT sfb01,sfb05,sfb06,sfb071,sfb08,sfb09,sfb10,",
				 " sfb11,sfb12,sfb15,sfb17,ima56,ima59,ima60,",
				 " sfb02,sfb04,sfb13,sfb34,sfb40,ima55",
                 " FROM sfb_file,OUTER ima_file",
                 " WHERE sfb04 != '8' AND (sfb02 = 1 OR sfb02 = 2",
				 " OR sfb02 = 7 OR sfb02 = 12) ",
                       " AND ima_file.ima01=sfb_file.sfb05 AND sfb87!='X' "
	 IF tm.a = 'N' THEN
		LET l_sql = l_sql CLIPPED, " AND sfb04 != '1'"
	 END IF
	 LET l_sql = l_sql CLIPPED," AND sfb15 <= '",tm.edate,
				"' AND ",tm.wc CLIPPED
     PREPARE asfp201_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
           
        	CALL cl_err('prepare:',SQLCA.sqlcode,1)
                CALL s_errmsg('','','prepare:',SQLCA.sqlcode,1)
                CALL cl_batch_bg_javamail('N')                #No.FUN-570114
	 	CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
                EXIT PROGRAM
	 END IF
     DECLARE asfp201_curs1 CURSOR FOR asfp201_prepare1
 
     CALL cl_outnam('asfp201') RETURNING l_name
     START REPORT asfp201_rep TO l_name
 
# genero  script marked      LET g_pageno = 0
     CALL s_showmsg_init()    #NO.FUN-710026
     FOREACH asfp201_curs1 INTO sr.*,sr1.*
#NO.FUN-710026-----begin add
         IF g_success='N' THEN                                                                                                          
            LET g_totsuccess='N'                                                                                                       
            LET g_success="Y"                                                                                                          
         END IF                    
#NO.FUN-710026-----end 
       IF SQLCA.sqlcode != 0 THEN
           LET g_success = 'N' #No.FUN-8A0086
#	   		CALL cl_err('foreach:',SQLCA.sqlcode,1)               #NO.FUN-710026
                        CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)       #NO.FUN-710026
	   		EXIT FOREACH
	   END IF
 
	   CALL s_crate(sr.*) RETURNING l_ss,l_crate
	   IF l_ss THEN CONTINUE FOREACH END IF
 
       OUTPUT TO REPORT asfp201_rep(sr.*,sr1.*,l_crate)
 
     END FOREACH
#NO.FUN-710026----begin 
     IF g_totsuccess="N" THEN                                                                                                         
        LET g_success="N"                                                                                                             
     END IF 
#NO.FUN-710026----end  
 
     FINISH REPORT asfp201_rep
 
     IF tm.b = 'Y' THEN
     	CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     ELSE
#      LET l_cmd = "chmod 777 ", l_name                   #No.FUN-9C0009  
#      RUN l_cmd                                          #No.FUN-9C0009
       IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009
     END IF
END FUNCTION
 
REPORT asfp201_rep(sr,sr1,l_crate)
   DEFINE l_last_sw     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          sr            RECORD
				sfb01   LIKE sfb_file.sfb01,		#工單編號
		   		sfb05	LIKE sfb_file.sfb05,		#料件編號
		   		sfb06	LIKE sfb_file.sfb06,		#製程編號
		   		sfb071  LIKE sfb_file.sfb071,		#有效日期
				sfb08	LIKE sfb_file.sfb08,		#生產數量
				sfb09	LIKE sfb_file.sfb09,		#完工數量
				sfb10	LIKE sfb_file.sfb10,		#再加工數量
				sfb11	LIKE sfb_file.sfb11,		#F.Q.C數量
				sfb12	LIKE sfb_file.sfb12,		#報廢數量
				sfb15	LIKE sfb_file.sfb15,		#完工日
				sfb17	LIKE sfb_file.sfb17,		#己完工作業序號
				ima56	LIKE ima_file.ima56,
				ima59   LIKE ima_file.ima59,
				ima60	LIKE ima_file.ima60
                        END RECORD,
          sr1           RECORD
				sfb02   LIKE sfb_file.sfb02,		#工單型態
				sfb04   LIKE sfb_file.sfb04,		#工單狀態
				sfb13   LIKE sfb_file.sfb13,		#開工日期
				sfb34   LIKE sfb_file.sfb34,		#緊急比率
				sfb40   LIKE sfb_file.sfb40,		#優先順序
				ima55   LIKE ima_file.ima55
                        END RECORD,
		  l_crate   LIKE sfb_file.sfb34 			#critical rate
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   #No.MOD-580242
 
  ORDER BY sr.sfb01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT ' '
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
            g_x[37],g_x[38],g_x[39],g_x[40],g_x[41]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      IF tm.b = 'Y' THEN
      	 PRINT COLUMN g_c[31],sr.sfb01,
               COLUMN g_c[32],sr.sfb05,
               COLUMN g_c[33],s_wotype(sr1.sfb02) CLIPPED,
	       COLUMN g_c[34],s_wostatu(sr1.sfb04) CLIPPED,
               COLUMN g_c[35],sr.sfb08 USING '--------&.&&',
               COLUMN g_c[36],sr1.ima55,
               COLUMN g_c[37],sr1.sfb13,
               COLUMN g_c[38],sr.sfb15,
               COLUMN g_c[39],sr1.sfb40 USING'####',
               COLUMN g_c[40],sr1.sfb34 USING'##&.###',
               COLUMN g_c[41],l_crate USING '##&.###'
      END IF
	  UPDATE sfb_file SET sfb34 = l_crate
			WHERE sfb01 = sr.sfb01
	  IF STATUS THEN 
#	      CALL cl_err('update:',STATUS,1)    #No.FUN-660128
	      CALL cl_err3("upd","sfb_file",sr.sfb01,"",STATUS,"","update:",1)    #No.FUN-660128
              CALL cl_batch_bg_javamail('N')                #No.FUN-570114
              CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
              EXIT PROGRAM 
          END IF
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'sfb01,sfb02,sfb03,sfb04,sfb05')
              RETURNING tm.wc
         PRINT g_dash[1,g_len]
#TQC-630166-start
         CALL cl_prt_pos_wc(tm.wc) 
#             IF tm.wc[1,120] > ' ' THEN
#		 PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#             IF tm.wc[121,240] > ' ' THEN
#		 PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#             IF tm.wc[241,300] > ' ' THEN
#		 PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#TQC-630166-end
      END IF
      PRINT g_dash[1,g_len]
      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
