# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: abxp112.4gl
# Descriptions...: 保稅原物料上階主件保稅碼更新作業
# Date & Author..: 06/11/03 By kim
# Modify.........: No.TQC-740062 07/04/12 By wujie  缺少雙橫線
# Modify.........: No.CHI-710051 07/06/07 By jamie 將ima21欄位放大至11
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/27 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   1、離開MAIN時沒有cl_used(1)和cl_used(2)
#                                                           2、未加離開前得cl_used(2)
#                                                           3、將cl_used()改成標準，使用g_prog
# Modify.........: No:MOD-C10168 12/01/30 By ck2yuan 取消arrno的限制
# Modify.........: No:CHI-C30054 12/03/14 By ck2yuan 改善效能,將定義cursor 搬到迴圈外面,避免多次連接資料庫造成效能降低
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm          RECORD                 # Print condition RECORD
                   wc  STRING             # Where condition
                   END RECORD,
       g_cnt       LIKE type_file.num10,   
       g_flag      LIKE type_file.chr1,
       g_i         LIKE type_file.num5               # count/index for any purpose
 
#CHI-710051
      
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211 
   LET tm.wc = ARG_VAL(1)
   IF cl_null(tm.wc) THEN 
      CALL p112_tm(0,0)
   ELSE 
      CALL p112()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
FUNCTION p112_tm(p_row,p_col)
   DEFINE   p_row,p_col	  LIKE type_file.num5
 
   LET p_row = 4
   LET p_col = 9
 
   OPEN WINDOW p112_w AT p_row,p_col WITH FORM "abx/42f/abxp112" 
        ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init()
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL	
 
   WHILE TRUE
     CONSTRUCT By NAME tm.wc ON bmb03 
 
       ON ACTION controlp
          CASE
            WHEN INFIELD(bmb03) 
#FUN-AA0059 --Begin--
           #    CALL cl_init_qry_var()
           #    LET g_qryparam.state = 'c'
           #    LET g_qryparam.form ="q_ima21"
           #    CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL q_sel_ima( TRUE, "q_ima21","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
               DISPLAY g_qryparam.multiret TO bmb03
               NEXT FIELD bmb03
            OTHERWISE EXIT CASE
          END CASE
    
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION about    
          CALL cl_about()  
 
       ON ACTION help       
          CALL cl_show_help()
 
       ON ACTION controlg     
          CALL cl_cmdask()     
     
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT CONSTRUCT
 
     END CONSTRUCT
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0 
        CLOSE WINDOW p112_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM
     END IF
     IF cl_null(tm.wc) THEN LET tm.wc = " 1=1" END IF
 
     CALL cl_wait()
     CALL p112()
     ERROR ""
 
     IF g_flag THEN
        CONTINUE WHILE
     ELSE
        EXIT WHILE
     END IF
 
   END WHILE
   CLOSE WINDOW p112_w
END FUNCTION
 
#-----------☉ 程式處理邏輯 ☉------------------------------------
# p112()      從單身讀取合乎條件的元件資料
# p112_bom()  處理主件及其相關的展開資料(update ima15='Y')
#-----------------------------------------------------------------
FUNCTION p112()
   DEFINE l_name	LIKE type_file.chr20,		# External(Disk) file name
          #l_time	LIKE type_file.chr8,		# Usima time for running the job
          l_sql 	STRING,	                # RDSQL STATEMENT
          l_bmb03       LIKE bmb_file.bmb03,    # 元件料件
          l_zo10        LIKE zo_file.zo10
 
   #CALL cl_used('abxp112',g_time,1) RETURNING g_time
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
 
   LET g_rlang = g_lang
   # 公司名稱、REMARK
   SELECT zo02,zo10 INTO g_company,l_zo10 FROM zo_file
    WHERE zo01 = g_rlang
 
   LET g_pageno = 0
 
   LET g_success = 'Y'
   LET l_sql = "SELECT UNIQUE bmb03",
               "  FROM bmb_file, ima_file",
               " WHERE ima01 = bmb03 AND ima15='Y'",
               "   AND ima08 !='A'   AND ",tm.wc CLIPPED
   PREPARE p112_prepare1 FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM 
   END IF
   DECLARE p112_c1 CURSOR FOR p112_prepare1
 
   CALL p112_def_cur()     #CHI-C30054 add

   BEGIN WORK
 
   CALL cl_outnam('abxp112') RETURNING l_name
   START REPORT abxp112_rep TO l_name
 
   FOREACH p112_c1 INTO l_bmb03
     IF SQLCA.sqlcode THEN
        CALL cl_err('F1:',SQLCA.sqlcode,1) 
        EXIT FOREACH 
     END IF
     CALL p112_bom(0,l_bmb03)
   END FOREACH
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   FINISH REPORT abxp112_rep
   CALL cl_prt(l_name,g_prtway,g_copies,100)
 
   #CALL cl_used('abxp112',g_time,2) RETURNING g_time
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
   IF g_success = 'Y' THEN
      CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
   ELSE
      CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
   END IF
  
END FUNCTION

#CHI-C30054 str add------
FUNCTION p112_def_cur()
   DEFINE l_cmd         LIKE type_file.chr1000

      LET l_cmd= "SELECT UNIQUE bmb01,ima15,ima02,ima021",
                 " FROM bmb_file,ima_file",
                 " WHERE bmb03= ? ",
                 " AND ima08 != 'A' AND bmb01 = ima01 ",
                 " ORDER BY bmb01"
      PREPARE p112_ppp FROM l_cmd
      IF SQLCA.sqlcode THEN
         CALL cl_err('P1:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      DECLARE p112_cur CURSOR for p112_ppp

END FUNCTION
#CHI-C30054 end add------
 
FUNCTION p112_bom(p_level,p_key)
   DEFINE p_level	LIKE type_file.num5,
          p_key		LIKE bmb_file.bmb03,            #元件料件編號
          l_ac,i	LIKE type_file.num5,
         #arrno		LIKE type_file.num5,	                #BUFFER SIZE (可存筆數) #MOD-C10168 mark
          b_seq		LIKE bmb_file.bmb02,            #滿時,重新讀單身之起始序號
          l_chr		LIKE type_file.chr1,
          l_ima06       LIKE ima_file.ima06,            #分群碼
          sr            DYNAMIC ARRAY OF RECORD         #每階存放資料
                         bmb01  LIKE bmb_file.bmb01,    #主件料號
                         ima15  LIKE ima_file.ima15,    #版本
                         ima02  LIKE ima_file.ima02,    #品名
                         ima021 LIKE ima_file.ima021    #規格
                        END RECORD,
          l_cmd		LIKE type_file.chr1000
 
   IF p_level > 25 THEN 
      CALL cl_err('','mfg2733',1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
   LET p_level = p_level + 1
   IF p_level = 1 THEN
      INITIALIZE sr[1].* TO NULL
   END IF
  #LET arrno = 600  #MOD-C10168 mark
   WHILE TRUE
     #CHI-C30054 mark add---------
     #LET l_cmd= "SELECT UNIQUE bmb01,ima15,ima02,ima021",
     #           " FROM bmb_file,ima_file",
     #           " WHERE bmb03='", p_key,"' ",
     #           " AND ima08 != 'A' AND bmb01 = ima01 ",
     #           " ORDER BY bmb01"
     #PREPARE p112_ppp FROM l_cmd
     #IF SQLCA.sqlcode THEN
     #   CALL cl_err('P1:',SQLCA.sqlcode,1)
     #   LET g_success = 'N' 
     #   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     #   EXIT PROGRAM 
     #END IF
     #DECLARE p112_cur CURSOR for p112_ppp
     #CHI-C30054 mark add---------
      LET l_ac = 1
      # 先撈元件的上層主件
     #FOREACH p112_cur INTO sr[l_ac].*	        # 先將BOM單身存入BUFFER  #CHI-C30054 mark
      FOREACH p112_cur USING p_key INTO sr[l_ac].*                       #CHI-C30054 add 
         IF cl_null(sr[l_ac].ima15) OR sr[l_ac].ima15 != 'Y' THEN
            UPDATE ima_file SET ima15='Y',
                                imadate = g_today   #FUN-C30315 add
             WHERE ima01=sr[l_ac].bmb01
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
               CALL cl_err('up ima15:',SQLCA.sqlcode,0)
               LET g_success='N' EXIT WHILE
            ELSE
               LET sr[l_ac].ima15 = 'Y'
               OUTPUT TO REPORT abxp112_rep(sr[l_ac].*) 
            END IF
         END IF
        #IF l_ac >= arrno THEN             #MOD-C10168 mark
        #   LET g_success='N' EXIT WHILE   #MOD-C10168 mark
        #END IF                            #MOD-C10168 mark
         LET l_ac = l_ac + 1			# 但BUFFER不宜太大
      END FOREACH
      # 再由取的料號，檢查是否有上層元件
      FOR i = 1 TO l_ac-1			# 讀BUFFER傳給p112_bom
         CALL p112_bom(p_level,sr[i].bmb01)
      END FOR
     #IF l_ac < arrno OR l_ac=1 THEN         # BOM單身已讀完  #MOD-C10168 mark
         EXIT WHILE
     #END IF                                                  #MOD-C10168 mark
   END WHILE
END FUNCTION
 
 
REPORT abxp112_rep(sr)
   DEFINE  sr    RECORD                          #每階存放資料
                  bmb01  LIKE bmb_file.bmb01,    #主件料號
                  ima15  LIKE ima_file.ima15,    #版本
                  ima02  LIKE ima_file.ima02,    #品名
                  ima021 LIKE ima_file.ima021    #規格
                 END RECORD,
           l_last_sw    LIKE type_file.chr1 
 
   OUTPUT TOP MARGIN g_top_margin
          LEFT MARGIN g_left_margin
          BOTTOM MARGIN g_bottom_margin
          PAGE LENGTH 66
   ORDER BY sr.bmb01
   FORMAT
     PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1 ,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total 
         PRINT g_dash[1,g_len]               #No.TQC-740062
         PRINT g_x[31] CLIPPED,
               g_x[32] CLIPPED,
               g_x[33] CLIPPED,
               g_x[34] CLIPPED
         PRINT g_dash1
         LET l_last_sw = 'n'
 
     ON EVERY ROW
         PRINT COLUMN g_c[31],sr.bmb01 CLIPPED,
               COLUMN g_c[32],sr.ima02 CLIPPED,
               COLUMN g_c[33],sr.ima021 CLIPPED,
               COLUMN g_c[34],sr.ima15 CLIPPED
 
     ON LAST ROW
         PRINT g_dash1
         LET l_last_sw = 'y'
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
     PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash1
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
END REPORT
 
