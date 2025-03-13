# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: p_zm_o1.4gl
# Descriptions...: 有 RECURSIVE 處理的清單 (如 BOM 多階展開清單)
# Date & Author..: 90/05/06 By LYS
# Modify.........: NO.TQC-650016 06/05/08 By Claire 修改轉excel產出檔案為目前最近檔案
# Modify.........: NO.FUN-650084 06/05/15 By Sarah 將列印系統結構表時,內容出現的空白行mark掉
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-860017 08/06/09 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-B10193 11/01/24 By sabrina 顯示頁數
# Modify.........: No:MOD-B20094 11/02/18 By sabrina 取得程式名稱改用"cl_get_progname"
# Modify.........: No:TQC-B30195 11/03/25 By sabrina 修改MOD-B20094的錯
# Modify.........: No:MOD-B90140 11/09/20 By sabrina 應傳sr.zm04而非sr.zm01 
# Modify.........: No:TQC-C70101 12/07/16 By LeoChang 調整列印功能無法使用問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
FUNCTION p_zm_o1()
   DEFINE p_row,p_col	LIKE type_file.num5,          #No.FUN-680135 SMALLINT 
          l_name	    LIKE type_file.chr20,         #No.FUN-680135 VARCHAR(20)
          l_wcshow_sw	LIKE type_file.num5,          #No.FUN-680135 SMALLINT
          l_wc  	    LIKE type_file.chr1000,       #No.FUN-680135 VARCHAR(320)
          l_level  	  LIKE type_file.num5,          # RECURSIVE 展開階數 #No.FUN-680135 SMALLINT
       l_key  	    LIKE zm_file.zm01,	          # RECURSIVE ROOT ITEM NO
          l_sql 	    LIKE type_file.chr1000,       #No.FUN-680135 VARCHAR(320)
          l_chr		    LIKE type_file.chr1,          #No.FUN-680135 VARCHAR(1)
          l_cmd       LIKE type_file.chr1000       #TQC-650016    #No.FUN-680135 VARCHAR(50)
#       l_time          LIKE type_file.chr8	        #No.FUN-6A0096
 
    WHENEVER ERROR CALL cl_err_msg_log   #CONTINUE MOD-510177
 
     LET g_page_line=66         #TQC-C70101 add
#  IF p_row = 0 THEN
#     LET p_row = 4 LET p_col = 20
#  END IF
 
#  IF NOT cl_prichk(g_user,'','p_zm_o1','') THEN
#     RETURN
#  END IF
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
   LET l_name = 'sysu01.05'
   LET l_cmd = 'rm -f ',l_name CLIPPED,'*'  #TQC-650016
   RUN l_cmd                                #TQC-650016
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
     CONSTRUCT BY NAME l_wc ON zm01
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
#TQC-860017 start
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION controlg
           CALL cl_cmdask()
 
        ON ACTION help
           CALL cl_show_help()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
#TQC-860017 end    
 
     END CONSTRUCT
     LET l_wc = l_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
     IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
     CALL cl_wait()
 
     START REPORT p_zm_o1_rep TO l_name
 
     LET l_sql = "SELECT UNIQUE zm01 FROM zm_file",
                 " WHERE ",l_wc
     PREPARE p_zm_o1_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        RETURN
     END IF
 
     DECLARE p_zm_o1_curs1 CURSOR FOR p_zm_o1_prepare1
     FOREACH p_zm_o1_curs1 INTO l_key
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET l_level = 0
       CALL p_zm_o1_bom(l_level,l_key)
     END FOREACH
 
     FINISH REPORT p_zm_o1_rep
 
     ERROR ""
     LET g_page_line=66         #MOD-B10193 add
     CALL cl_prt(l_name,' ','1',80)
     EXIT WHILE
   END WHILE
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
END FUNCTION
 
FUNCTION p_zm_o1_bom(p_level,p_key)
   DEFINE p_level	LIKE type_file.num5,        #No.FUN-680135 SMALLINT
          p_key		LIKE zm_file.zm01,
          l_ac,i	LIKE type_file.num5,        #No.FUN-680135 SMALLINT 
          sr ARRAY[300] OF RECORD zm01 LIKE zm_file.zm01,	# 存每階資料
                                  zm03 LIKE zm_file.zm03,
                                  zm04 LIKE zm_file.zm04
                        END RECORD
 
   LET p_level = p_level + 1
DECLARE p_zm_o1_cur CURSOR FOR
           SELECT zm01,zm03,zm04 FROM zm_file
                  WHERE zm01 = p_key
                   AND zm03 > 0
#                  ORDER BY zm03
   LET l_ac = 1
   FOREACH p_zm_o1_cur INTO sr[l_ac].*
      LET l_ac = l_ac + 1
   END FOREACH
   FOR i = 1 TO l_ac-1
         MESSAGE "read:",p_key CLIPPED," ",sr[i].zm03," ",sr[i].zm04
         OUTPUT TO REPORT p_zm_o1_rep(p_level,sr[i].*)
         CALL p_zm_o1_bom(p_level,sr[i].zm04)		# 再 RECURSIVE 展開
   END FOR
END FUNCTION
 
REPORT p_zm_o1_rep(p_level,sr)
   DEFINE l_trailer_sw	    LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
          l_dash	    LIKE type_file.chr1000, #No.FUN-680135 VARCHAR(132)
          t,l_i,l_j,p_level LIKE type_file.num5,    #No.FUN-680135 SMALLINT 
          l_company	    LIKE ama_file.ama07,    #公司名稱      #No.FUN-680135 VARCHAR(36)
          l_title	    LIKE ama_file.ama07,    #報表抬頭      #No.FUN-680135 VARCHAR(36)
          l_len  	    LIKE type_file.num5,    #報表寬度(79/132/136)         #No.FUN-680135 SMALLINT
          sr RECORD                                 # 主要檔案 RECORD
                zm01        LIKE zm_file.zm01,
                zm03        LIKE zm_file.zm03,
                zm04        LIKE zm_file.zm04
             END RECORD,
	  l_gaz03           LIKE gaz_file.gaz03,
          l_chr		    LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
          l_cnt             LIKE type_file.num10    #No.FUN-680135 INTEGER
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
# ORDER BY sr.zm01,sr.zm03
 
  FORMAT
   FIRST PAGE HEADER
     #MOD-B20094---modify---start---
     #SELECT COUNT(gaz03) INTO l_cnt FROM gaz_file
     # WHERE gaz01=sr.zm01 AND gaz02=g_lang
     #IF l_cnt > 1 THEN
     #    SELECT gaz03 INTO l_gaz03 FROM gaz_file
     #        WHERE gaz01=sr.zm01 AND gaz02=g_lang AND gaz05='Y'
     #ELSE
     #    SELECT gaz03 INTO l_gaz03 FROM gaz_file
     #        WHERE gaz01=sr.zm01 AND gaz02=g_lang AND gaz05='N'
     #END IF
      LET l_gaz03 = NULL
     #CALL cl_get_progname(sr.zm01,g_lang) RETURNING l_gaz03     #MOD-B90140 mark
      CALL cl_get_progname(sr.zm04,g_lang) RETURNING l_gaz03     #MOD-B90140 add
     #MOD-B20094---modify---end---
   #   SELECT gaz03 INTO l_gaz03 FROM gaz_file WHERE gaz01 = sr.zm01 AND gaz02 = g_lang order by gaz05
 
      IF SQLCA.sqlcode != 0 THEN
         LET l_gaz03 = '*'
      END IF
 
#     CASE 
#       WHEN g_lang = '0' 
#            SELECT zz02 INTO l_zz02 FROM zz_file WHERE zz01 = sr.zm01
#            IF SQLCA.sqlcode != 0 THEN LET l_zz02 = '*' END IF
#       WHEN g_lang = '2'  
#            SELECT zz02c INTO l_zz02 FROM zz_file WHERE zz01 = sr.zm01
#            IF SQLCA.sqlcode != 0 THEN LET l_zz02 = '*' END IF
#       OTHERWISE          
#            SELECT zz02e INTO l_zz02 FROM zz_file WHERE zz01 = sr.zm01
#            IF SQLCA.sqlcode != 0 THEN LET l_zz02 = '*' END IF
#     END CASE
#     IF g_lang = '1'
#     THEN PRINT "1.5  MENU STRUCTURE"
#     ELSE PRINT "1.5  系統結構表"
#     END IF
 
      PRINT " "
      PRINT "    ",l_gaz03 CLIPPED, "(",sr.zm01 CLIPPED,")"
      LET t = 0
      LET l_trailer_sw = 'y'
 
   PAGE HEADER
      LET l_trailer_sw = 'y'
 
   ON EVERY ROW
     # SELECT gaz03 INTO l_gaz03 FROM gaz_file WHERE gaz01 = sr.zm04 AND gaz02 = g_lang
     #MOD-B20094---modify---start---
     #SELECT COUNT(gaz03) INTO l_cnt FROM gaz_file
     # WHERE gaz01=sr.zm04 AND gaz02=g_lang
     #IF l_cnt > 1 THEN
     #    SELECT gaz03 INTO l_gaz03 FROM gaz_file
     #        WHERE gaz01=sr.zm04 AND gaz02=g_lang AND gaz05='Y'
     #ELSE
     #    SELECT gaz03 INTO l_gaz03 FROM gaz_file
     #        WHERE gaz01=sr.zm04 AND gaz02=g_lang AND gaz05='N'
     #END IF
      LET l_gaz03 = NULL
     #CALL cl_get_progname(sr.zm01,g_lang) RETURNING l_gaz03     #TQC-B30195 mark
      CALL cl_get_progname(sr.zm04,g_lang) RETURNING l_gaz03     #TQC-B30195 add
     #MOD-B20094---modify---end---
#     CASE
#      WHEN g_lang = '0'
#           SELECT zz02 INTO l_zz02 FROM zz_file WHERE zz01 = sr.zm04
#      WHEN g_lang = '2'
#           SELECT zz02e INTO l_zz02 FROM zz_file WHERE zz01 = sr.zm04
#      OTHERWISE 
#           SELECT zz02e INTO l_zz02 FROM zz_file WHERE zz01 = sr.zm04
#     END CASE
      IF SQLCA.sqlcode != 0 THEN LET l_gaz03 = '*' END IF
 
      IF p_level > t
      THEN 
           CASE 
            WHEN g_lang = '0'
                 FOR l_i = 1 TO p_level PRINT "          │"; END FOR
            WHEN g_lang = '2'
                 FOR l_i = 1 TO p_level PRINT "          │"; END FOR
            OTHERWISE 
                 FOR l_i = 1 TO p_level PRINT "          | "; END FOR
           END CASE
           PRINT " "
      END IF
      IF p_level < t
      THEN 
           CASE 
            WHEN g_lang = '0' 
                 FOR l_i = 1 TO p_level PRINT "          │"; END FOR
                 PRINT "          └"
            WHEN g_lang = '2' 
                 FOR l_i = 1 TO p_level PRINT "          │"; END FOR
                 PRINT "          └"
            OTHERWISE  
                 FOR l_i = 1 TO p_level PRINT "          | "; END FOR
                 PRINT "          +-"
           END CASE
      END IF
      CASE 
        WHEN g_lang = '0'
             FOR l_i = 1 TO p_level-1 PRINT "          │"; END FOR
             PRINT "          ├";
        WHEN g_lang = '2'
             FOR l_i = 1 TO p_level-1 PRINT "          │"; END FOR
             PRINT "          ├";
        OTHERWISE 
             FOR l_i = 1 TO p_level-1 PRINT "          | "; END FOR
             PRINT "          |-";
      END CASE
#     IF sr.zm03 < 71
#     THEN PRINT sr.zm03 USING '<<';
#     ELSE PRINT '^';
#     END IF
      PRINT '─',l_gaz03 CLIPPED,"(",sr.zm04 CLIPPED,")"
      LET t = p_level
 
   PAGE TRAILER
      print ''
 
   ON LAST ROW
      CASE 
       WHEN g_lang = '0'
            FOR l_i = 1 TO p_level PRINT "          └"; END FOR #print ''
       WHEN g_lang = '2'
            FOR l_i = 1 TO p_level PRINT "          └"; END FOR #print ''
       OTHERWISE 
            FOR l_i = 1 TO p_level PRINT "          +-"; END FOR #print ''
      END CASE
END REPORT
