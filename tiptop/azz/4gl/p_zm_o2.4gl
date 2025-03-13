# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: p_zm_o2.4gl
# Descriptions...: 系統程式總覽
# Date & Author..: 90/05/20 By LYS
# Modify.........: NO.TQC-650016 06/05/08 By Claire 修改轉excel產出檔案為目前最近檔案
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-860017 08/06/09 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify.........: No.MOD-910233 09/02/06 By Sarah 選擇列印"程式總覽",列印出來的資料沒有排序
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-B10193 11/01/24 By sabrina 顯示頁數
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
FUNCTION p_zm_o2()
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-680135 SMALLINT 
          l_name	    LIKE type_file.chr20, 	#報表外部名稱           #No.FUN-680135 VARCHAR(20)
          l_wcshow_sw	LIKE type_file.num5,    #是否顯示SELECT條件l_wc #No.FUN-680135 SMALLINT
          l_wc  	    LIKE type_file.chr1000,	# WHERE CLAUSE          #No.FUN-680135 VARCHAR(320)
          l_level  	  LIKE type_file.num5,    #No.FUN-680135 SMALLINT
          l_key  	    LIKE zm_file.zm01,
          l_sql 	    LIKE type_file.chr1000,	# RDSQL STATEMENT        #No.FUN-680135 VARCHAR(320)
          l_cmd       LIKE type_file.chr1000, #TQC-650016              #No.FUN-680135 VARCHAR(50)
          l_chr		    LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   WHENEVER ERROR CONTINUE
   IF p_row = 0
   THEN LET p_row = 4 LET p_col = 20
   END IF
#  IF NOT cl_prichk(g_user,'','p_zm_o2','')
#     THEN RETURN
#  END IF
   LET l_name = 'xxx-2.2'
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
 
     START REPORT p_zm_o2_rep TO l_name
 
  LET l_sql = "SELECT UNIQUE zm01 FROM zm_file",
                 " WHERE ",l_wc
     PREPARE p_zm_o2_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) RETURN END IF
     DECLARE p_zm_o2_curs1 CURSOR FOR p_zm_o2_prepare1
     FOREACH p_zm_o2_curs1 INTO l_key
       IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
       LET l_level = 0
       CALL p_zm_o2_bom(l_level,l_key)
     END FOREACH
 
     FINISH REPORT p_zm_o2_rep
 
     ERROR ""
     LET g_page_line=66         #MOD-B10193 add
     CALL cl_prt(l_name,' ','1',80)
     EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p_zm_o2_bom(p_level,p_key)
   DEFINE p_level	LIKE type_file.num5,    #No.FUN-680135 SMALLINT
          p_key		LIKE zm_file.zm01,
          l_ac,i	LIKE type_file.num5,    #No.FUN-680135 SMALLINT
          sr ARRAY[300] OF RECORD zm01 LIKE zm_file.zm01,
                                  zm03 LIKE zm_file.zm03,
                                  zm04 LIKE zm_file.zm04
                        END RECORD
 
   LET p_level = p_level + 1
   DECLARE p_zm_o2_cur CURSOR FOR
           SELECT zm01,zm03,zm04 FROM zm_file
                  WHERE zm01 = p_key
                   AND zm03 > 0
#                  ORDER BY zm03
   LET l_ac = 1
   FOREACH p_zm_o2_cur INTO sr[l_ac].*
      LET l_ac = l_ac + 1
   END FOREACH
   FOR i = 1 TO l_ac-1
         MESSAGE "read:",p_key CLIPPED," ",sr[i].zm03," ",sr[i].zm04
         OUTPUT TO REPORT p_zm_o2_rep(p_level,sr[i].*)
         CALL p_zm_o2_bom(p_level,sr[i].zm04)
   END FOR
END FUNCTION
 
REPORT p_zm_o2_rep(p_level,sr)
   DEFINE l_trailer_sw	    LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
          l_dash	          LIKE type_file.chr1000, #No.FUN-680135 SMALLINT
          t,l_i,l_j,p_level	LIKE type_file.num5,    #No.FUN-680135 SMALLINT
          l_str             LIKE type_file.chr1000, #No.FUN-680135 VARCHAR(256) #MOD-4C0141
          l_str1   	        LIKE type_file.chr1000, #No.FUN-680135 VARCHAR(256) #
          l_str2   	        LIKE type_file.chr1000, #No.FUN-680135 VARCHAR(256) #
          l_str3   	        LIKE type_file.chr1000, #No.FUN-680135 VARCHAR(256) #
          l_str4   	        LIKE type_file.chr1000, #No.FUN-680135 VARCHAR(256) #
          l_company	        LIKE ama_file.ama07,    #No.FUN-680135 VARCHAR(36)  #公司名稱
          l_title	          LIKE ama_file.ama07,    #No.FUN-680135 VARCHAR(36)  #報表抬頭
          l_len  	          LIKE type_file.num5,    #No.FUN-680135 SMALLINT  #報表寬度(79/132/136)
          l_cnt  	          LIKE type_file.num5,    #No.FUN-680135 SMALLINT  #報表寬度(79/132/136) 
          sr RECORD				                          # 主要檔案 RECORD
		      zm01              LIKE zm_file.zm01,
		      zm03              LIKE zm_file.zm03,
		      zm04              LIKE zm_file.zm04
                            END RECORD,
         #l_zz02            LIKE zz_file.zz02,      #MOD-910233 mark
          l_zz02            LIKE gaz_file.gaz03,    #MOD-910233
          l_sw,l_chr        LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
 #ORDER BY sr.zm04            #MOD-910233 mark
  ORDER EXTERNAL BY sr.zm04   #MOD-910233
 
  FORMAT
   FIRST PAGE HEADER
      PRINT "2.2", COLUMN 75,"2.2"
      PRINT "----------------------------------------------",
            "---------------------------------"
      PRINT ''
 
       LET l_str=cl_getmsg('azz-100',g_lang) #系統程式總覽  #MOD-4C0141
      PRINT "2.2  ",sr.zm01[1,3]," ",l_str CLIPPED 
 
      #│ 程式編號   │     程    式    名    稱           │ R E M A R K  │
       LET l_str=cl_getmsg('azz-101',g_lang) #MOD-4C0141
 
 
      SELECT COUNT(gaz03) INTO l_cnt FROM gaz_file
       WHERE gaz01=sr.zm04 AND gaz02=g_lang
 
      IF l_cnt > 1 THEN
          SELECT gaz03 INTO l_zz02  FROM gaz_file
              WHERE gaz01=sr.zm01 AND gaz02=g_lang AND gaz05='Y'
      ELSE
          SELECT gaz03 INTO l_zz02  FROM gaz_file
              WHERE gaz01=sr.zm01 AND gaz02=g_lang AND gaz05='N'
      END IF
 
      IF SQLCA.sqlcode != 0 THEN LET l_zz02 = NULL END IF
 
      IF g_lang='0' OR g_lang='2' THEN
        LET l_str1=
        "┌──────┬──────────────────┬───────┐"
        LET l_str2=
        "├──────┼──────────────────┼───────┤"
        LET l_str3=
        "└──────┴──────────────────┴───────┘"
 
        LET l_str4=
        "│ "
      ELSE
        LET l_str1=
        "+--------------------------------------------------------------------+"
        LET l_str2=
        "+--------------+-------------------------------------+---------------|"
        LET l_str3=
        "+--------------------------------------------------------------------+"
        LET l_str4=
        "|  "
      END IF
 
      PRINT "    ",l_str1 CLIPPED
      PRINT "    ",l_str CLIPPED
      PRINT "    ",l_str2 CLIPPED
      PRINT COLUMN 5, l_str4 CLIPPED,sr.zm01,
            COLUMN 19,l_str4 CLIPPED,l_zz02, 
            COLUMN 57,l_str4 CLIPPED,COLUMN 73,l_str4 CLIPPED
 
    LET l_trailer_sw = 'y'
 
   PAGE HEADER
      PRINT "2.2", COLUMN 75,"2.2"
      PRINT "----------------------------------------------",
            "---------------------------------"
 
      #│ 程式編號   │     程    式    名    稱           │ R E M A R K  │
       LET l_str=cl_getmsg('azz-101',g_lang) #MOD-4C0141
 
      PRINT "    ",l_str1 CLIPPED
      PRINT "    ",l_str CLIPPED
      PRINT "    ",l_str2 CLIPPED
 
   BEFORE GROUP OF sr.zm04
      LET l_sw = 'y'
      SELECT COUNT(gaz03) INTO l_cnt FROM gaz_file
       WHERE gaz01=sr.zm04 AND gaz02=g_lang
      IF l_cnt > 1 THEN
          SELECT gaz03 INTO l_zz02  FROM gaz_file
              WHERE gaz01=sr.zm04 AND gaz02=g_lang AND gaz05='Y'
      ELSE
          SELECT gaz03 INTO l_zz02  FROM gaz_file
              WHERE gaz01=sr.zm04 AND gaz02=g_lang AND gaz05='N'
      END IF
      IF SQLCA.sqlcode != 0 THEN LET l_zz02 = NULL END IF
 
   ON EVERY ROW
      IF l_sw = 'y' THEN
            PRINT COLUMN 5, l_str4 CLIPPED,sr.zm04[1,10],
                  COLUMN 19,l_str4 CLIPPED,l_zz02, 
                  COLUMN 57,l_str4 CLIPPED, 
                  COLUMN 73,l_str4 CLIPPED
         LET l_sw = 'n'
      END IF
 
   PAGE TRAILER
      IF l_trailer_sw = 'y' THEN
        #(接下頁)
         LET l_str=cl_getmsg('azz-102',g_lang) #MOD-4C0141
           PRINT "    ",l_str3 CLIPPED
           PRINT COLUMN 65, l_str CLIPPED
      ELSE PRINT ''
           PRINT ''
      END IF
 
   ON LAST ROW
      #(結  束)
       LET l_str=cl_getmsg('azz-103',g_lang) #MOD-4C0141
      PRINT "    ",l_str3 CLIPPED
      PRINT COLUMN 65, l_str
      LET l_trailer_sw = 'n'
END REPORT
