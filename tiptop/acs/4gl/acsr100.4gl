# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: acsr100.4gl
# Descriptions...: 無標準成本表
# Input parameter:
# Return code....:
# Date & Author..: 92/01/15 By Nora
# Modify.........: No.FUN-5100339 05/01/20 By pengu 報表轉XML
#
# Modify.........: No.FUN-680071 06/09/08 By chen 類型轉換
# Modify.........: No.FUN-690110 06/10/13 By xiake cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0064 06/10/27 By king l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
                a        LIKE type_file.chr1      #No.FUN-680071 VARCHAR(1)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680071 SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACS")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690110 by xiake
 
 
   CALL r100_tm()			# Read data and create out-file
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690110 by xiake
END MAIN
 
FUNCTION r100_tm()
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-680071 SMALLINT
          l_cmd		LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(400)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 35
   ELSE LET p_row = 4 LET p_col = 15
   END IF
   OPEN WINDOW r100_w AT p_row,p_col
        WITH FORM "acs/42f/acsr100"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a = 'Y'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_copies = '1'
WHILE TRUE
   INPUT BY NAME tm.a WITHOUT DEFAULTS
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT INPUT
 
 
      AFTER FIELD a
         IF tm.a NOT MATCHES'[YN]' THEN
            NEXT FIELD a
         END IF
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
 
 
          ON ACTION exit
          LET INT_FLAG = 1
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
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-690110 by xiake 
      EXIT PROGRAM
         
   END IF
   IF tm.a = 'N' THEN
      CLOSE WINDOW r100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-690110 by xiake
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r100()
   ERROR ""
END WHILE
   CLOSE WINDOW r100_w
END FUNCTION
 
FUNCTION r100()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name  #No.FUN-680071 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0064
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT  #No.FUN-680071 VARCHAR(600)
          l_chr		LIKE type_file.chr1,    #No.FUN-680071 VARCHAR(1)
          l_za05	LIKE type_file.chr1000, #No.FUN-680071 VARCHAR(40)
          sr            RECORD
           imb01     LIKE imb_file.imb01,#料件編號
           imb111    LIKE imb_file.imb111,#標準本階材料成本
           imb112    LIKE imb_file.imb112,#標準本階材料製造費用(間接材料)
           imb1131   LIKE imb_file.imb1131,#標準本階人工成本
           imb1132   LIKE imb_file.imb1132,#標準本階人工製造費用(間接人工)
           imb114    LIKE imb_file.imb114,#標準本階固定製造費用成本
           imb115    LIKE imb_file.imb115,#標準本階變動製造費用成本
           imb116    LIKE imb_file.imb116,#標準本階廠外加工成本
           imb1171   LIKE imb_file.imb1171,#標準本階廠外加工固定製造費用成本
           imb1172   LIKE imb_file.imb1172,#標準本階廠外加工變動製造費用成本
           imb119    LIKE imb_file.imb119,#標準本階機器成本
           imb118    LIKE imb_file.imb118,#標準採購成本
           imb120    LIKE imb_file.imb120,#標準本階附加成本
           imb121    LIKE imb_file.imb121,#標準下階材料成本
           imb122    LIKE imb_file.imb122,#標準下階材料製造費用成本(間接材料)
           imb1231   LIKE imb_file.imb1231,#標準下階人工成本
           imb1232   LIKE imb_file.imb1232,#標準下階人工製造費用成本(間接人工)
           imb124    LIKE imb_file.imb124,#標準下階固定製造成本
           imb125    LIKE imb_file.imb125,#標準下階變動製造成本
           imb126    LIKE imb_file.imb126,#標準下階廠外加工成本
           imb1271   LIKE imb_file.imb1271,#標準下階廠外加工固定製造費用成本
           imb1272   LIKE imb_file.imb1272,#標準下階廠外加工變動製造費用成本
           imb129    LIKE imb_file.imb129,#標準下階機器成本
           imb130    LIKE imb_file.imb130,#標準下階附加成本
           imbacti   LIKE imb_file.imbacti,
           ima01     LIKE ima_file.ima01,#料件編號
           ima02     LIKE ima_file.ima02, #品名規格
           ima05     LIKE ima_file.ima05, #版本
           ima08     LIKE ima_file.ima08  #來源碼
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET l_sql = "SELECT ",
                 "imb01,imb111,imb112,imb1131,imb1132,imb114,",
                 "imb115,imb116,imb1171,imb1172,imb119,imb118,",
                 "imb120,imb121,imb122,imb1231,imb1232,imb124,",
                 "imb125,imb126,imb1271,imb1272,imb129,imb130,",
                 "imbacti,ima01,ima02,ima05,ima08",
                 "  FROM ima_file, OUTER imb_file",
                 " WHERE imb_file.imb01 = ima_file.ima01 ",
                 " AND imaacti = 'Y' ",
                 " AND ima01 NOT IN (",
                 " SELECT imb01 FROM imb_file)"
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET l_sql = l_sql clipped," AND imbuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET l_sql = l_sql clipped," AND imbgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET l_sql = l_sql clipped," AND imbgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET l_sql = l_sql CLIPPED,cl_get_extra_cond('imbuser', 'imbgrup')
     #End:FUN-980030
 
     PREPARE r100_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-690110  by  xiake
        EXIT PROGRAM 
     END IF
     DECLARE r100_cs1 CURSOR FOR r100_prepare1
 
     CALL cl_outnam('acsr100') RETURNING l_name
     START REPORT r100_rep TO l_name
 
     LET g_pageno = 0
     FOREACH r100_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
 
       IF (sr.imb111 IS NULL OR sr.imb111 = 0) AND
          (sr.imb112 IS NULL OR sr.imb112 = 0) AND
          (sr.imb1131 IS NULL OR sr.imb1131 = 0) AND
          (sr.imb1132 IS NULL OR sr.imb1132 = 0) AND
          (sr.imb114 IS NULL OR sr.imb114 = 0) AND
          (sr.imb115 IS NULL OR sr.imb115 = 0) AND
          (sr.imb116 IS NULL OR sr.imb116 = 0) AND
          (sr.imb1171 IS NULL OR sr.imb1171 = 0) AND
          (sr.imb1172 IS NULL OR sr.imb1172 = 0) AND
          (sr.imb119 IS NULL OR sr.imb119 = 0) AND
          (sr.imb118 IS NULL OR sr.imb118 = 0) AND
          (sr.imb120 IS NULL OR sr.imb120 = 0) AND
          (sr.imb121 IS NULL OR sr.imb121 = 0) AND
          (sr.imb122 IS NULL OR sr.imb122 = 0) AND
          (sr.imb1231 IS NULL OR sr.imb1231 = 0) AND
          (sr.imb1232 IS NULL OR sr.imb1232 = 0) AND
          (sr.imb124 IS NULL OR sr.imb124 = 0) AND
          (sr.imb125 IS NULL OR sr.imb125 = 0) AND
          (sr.imb126 IS NULL OR sr.imb126 = 0) AND
          (sr.imb1271 IS NULL OR sr.imb1271 = 0) AND
          (sr.imb1272 IS NULL OR sr.imb1272 = 0) AND
          (sr.imb129 IS NULL OR sr.imb129 = 0) AND
          (sr.imb130 IS NULL OR sr.imb130 = 0) AND
          (sr.imbacti IS NULL OR sr.imbacti = 'Y') THEN
           OUTPUT TO REPORT r100_rep(sr.*)
        END IF
 
     END FOREACH
 
     FINISH REPORT r100_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r100_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,      #No.FUN-680071 VARCHAR(1)
          sr            RECORD
           imb01     LIKE imb_file.imb01,#料件編號
           imb111    LIKE imb_file.imb111,#標準本階材料成本
           imb112    LIKE imb_file.imb112,#標準本階材料製造費用(間接材料)
           imb1131   LIKE imb_file.imb1131,#標準本階人工成本
           imb1132   LIKE imb_file.imb1132,#標準本階人工製造費用(間接人工)
           imb114    LIKE imb_file.imb114,#標準本階固定製造費用成本
           imb115    LIKE imb_file.imb115,#標準本階變動製造費用成本
           imb116    LIKE imb_file.imb116,#標準本階廠外加工成本
           imb1171   LIKE imb_file.imb1171,#標準本階廠外加工固定製造費用成本
           imb1172   LIKE imb_file.imb1172,#標準本階廠外加工變動製造費用成本
           imb119    LIKE imb_file.imb119,#標準本階機器成本
           imb118    LIKE imb_file.imb118,#標準採購成本
           imb120    LIKE imb_file.imb120,#標準本階附加成本
           imb121    LIKE imb_file.imb121,#標準下階材料成本
           imb122    LIKE imb_file.imb122,#標準下階材料製造費用成本(間接材料)
           imb1231   LIKE imb_file.imb1231,#標準下階人工成本
           imb1232   LIKE imb_file.imb1232,#標準下階人工製造費用成本(間接人工)
           imb124    LIKE imb_file.imb124,#標準下階固定製造成本
           imb125    LIKE imb_file.imb125,#標準下階變動製造成本
           imb126    LIKE imb_file.imb126,#標準下階廠外加工成本
           imb1271   LIKE imb_file.imb1271,#標準下階廠外加工固定製造費用成本
           imb1272   LIKE imb_file.imb1272,#標準下階廠外加工變動製造費用成本
           imb129    LIKE imb_file.imb129,#標準下階機器成本
           imb130    LIKE imb_file.imb130,#標準下階附加成本
           imbacti   LIKE imb_file.imbacti,
           ima01     LIKE ima_file.ima01,#料件編號
           ima02     LIKE ima_file.ima02, #品名規格
           ima05     LIKE ima_file.ima05, #版本
           ima08     LIKE ima_file.ima08  #來源碼
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.ima01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
 
      PRINT g_dash[1,g_len]
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      PRINT COLUMN g_c[31],sr.ima01,
            COLUMN g_c[32],sr.ima02,
            COLUMN g_c[33],sr.ima05,
            COLUMN g_c[34],sr.ima08;
      CASE sr.ima08
           WHEN 'C' PRINT COLUMN g_c[35],g_x[13] CLIPPED
           WHEN 'T' PRINT COLUMN g_c[35],g_x[14] CLIPPED
           WHEN 'D' PRINT COLUMN g_c[35],g_x[15] CLIPPED
           WHEN 'A' PRINT COLUMN g_c[35],g_x[16] CLIPPED
           WHEN 'M' PRINT COLUMN g_c[35],g_x[17] CLIPPED
           WHEN 'P' PRINT COLUMN g_c[35],g_x[18] CLIPPED
           WHEN 'X' PRINT COLUMN g_c[35],g_x[19] CLIPPED
           WHEN 'K' PRINT COLUMN g_c[35],g_x[20] CLIPPED
           WHEN 'U' PRINT COLUMN g_c[35],g_x[21] CLIPPED
           WHEN 'V' PRINT COLUMN g_c[35],g_x[22] CLIPPED
           WHEN 'W' PRINT COLUMN g_c[35],g_x[23] CLIPPED
           WHEN 'R' PRINT COLUMN g_c[35],g_x[24] CLIPPED
           WHEN 'Z' PRINT COLUMN g_c[35],g_x[25] CLIPPED
           WHEN 'S' PRINT COLUMN g_c[35],g_x[26] CLIPPED
           OTHERWISE PRINT
      END CASE
 
   ON LAST ROW
      LET l_last_sw = 'y'
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
