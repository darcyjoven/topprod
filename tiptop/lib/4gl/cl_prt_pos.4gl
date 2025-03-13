# Prog. Version..: '5.30.06-13.03.28(00008)'     #
#
# Program name...: cl_prt_pos.4gl
# Descriptions...: Report --print the position of data
# Descriptions...: 報表 --列印資料的位置
# Date & Author..: 04/11/29 by CoCo
# Input Parameter: l_prog  程式代號
# Return code....: none
# Usage..........: CALL cl_prt_pos('aapr121')
# Modify.........: No.MOD-530271 05/05/25 By echo 新增報表備註
# Modify.........: No.FUN-560079 05/06/17 by CoCo add Program Class(zaa17)  
# Modify.........: No.FUN-570141 05/07/14 By echo 調整 Declare 寫法!  
# Modify.........: No.MOD-570371 05/07/27 By Echo 報表g_dash1產生錯誤
# Modify.........: No.MOD-570245 05/07/28 By Echo 多報表樣版選項，按「取消」時會有錯誤
# Modify.........: No.FUN-570264 05/07/28 By CoCo background job don't pop q_zaa window
# Modify.........: No.FUN-560048 05/08/01 By echo 錯誤判斷後，直接離開程式
# Modify.........: No.FUN-580019 05/08/08 By Echo 1.HTML的隔線顏色變淡
#                                                 2.兩行以上的單頭可選擇拉成一行呈現
#                                                 3.兩行以上的單頭選擇動態html輸出時,直接把報表拉成一行(若p_zaa沒設定一行時的順序,直接把第二行加在第一行之後) 
#                                                 4.單頭不在page header,而在before group or on every row,須在列印單頭時加上name,如:PRINTX name= H1  
# Modify.........: No.MOD-580124 05/08/18 By echo 程式使用外部呼叫方式的報表,表頭全部無法列印
# Modify.........: No.MOD-580254 05/08/23 By echo 報表選擇多行式列印時會產生錯誤，直接關閉程式(ex: aapr800)
# Modify.........: No.FUN-580131 05/08/24 By Echo 報表備註第二行無顯示
# Modify.........: No.MOD-580063 05/09/13 By Echo 報表轉excel檔後,轉出來的數據類型錯誤,比如人員編號為00003,可是轉到excel後,就成3了
# Modify.........: No.MOD-590446 05/09/28 By Echo p_zab的行序為1空白時，執行報表則直接印p_zaa的欄位內容資料
# Modify.........: No.FUN-5A0044 05/10/11 By Echo 增加報表程式動態更改欄位順序
# Modify.........: No.MOD-5A0397 05/10/27 By Echo 一行式報表動態更改欄位順序或寬度時，應重新計算g_c,g_w
# Modify.........: No.TQC-5B0046 05/11/07 By Echo 由A程式呼叫執行B程式報表時，列印時選擇列印樣板的action為英文, EX:apmt300->apmr920
# Modify.........: No.TQC-5B0170 05/11/21 By Echo 新增cl_prt_pos_dyn()存放g_zaa_dyn陣列
# Modify.........: No.TQC-630166 06/03/16 By Echo 多行式報表拉為單行式時，順序計算錯誤
# Modify.........: No.FUN-650017 06/06/15 By Echo 新增抓取報表左邊界(zaa19)的值
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: NO.FUN-6C0048 07/01/09 by ching-yuan 新增TOP MARGIN g_top_margin& BOTTOM MARGIN g_bottom_margin設定欄位 
# Modify.........: No.FUN-720048 07/02/27 By Echo OPEN USING FOREACH 寫法調整
# Modify.........: NO.FUN-6B0098 07/06/11 by Echo 調整多行式報表樣版選擇視窗
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-7C0058 07/12/19 By jacklai 補充lib的說明資料
# Modify.........: No.FUN-AA0017 10/10/22 By alex 調整ASE段程式
# Modify.........: No:FUN-B70007 11/07/05 By jrg542 在EXIT PROGRAM前加上CALL cl_used(2) 
# Modify.........: No:MOD-CB0286 12/12/17 By Elise 使l_j不會小於0而進入loop

DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa13_value  LIKE zaa_file.zaa13
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17   #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5             #No.FUN-690005  SMALLINT
END GLOBALS
 
DEFINE g_seq            LIKE gaq_file.gaq01           #No.FUN-690005          VARCHAR(10)
 
FUNCTION cl_prt_pos(l_prog)
 
 DEFINE   l_prog,l_sql            STRING,
          l_zaa05,l_i,l_cnt,l_j   LIKE type_file.num5,             #No.FUN-690005  SMALLINT
          l_cust                  LIKE type_file.num5,             #No.FUN-690005  SMALLINT
          l_zaa08                 LIKE zaa_file.zaa08,             #No.FUN-690005  VARCHAR(1000)
          l_dash                  LIKE type_file.chr1000,          #No.FUN-690005  VARCHAR(150) 
          l_dash_t                LIKE type_file.chr1000,          #No.FUN-690005  VARCHAR(1000) 
          l_zaa09                 LIKE zaa_file.zaa09,             #No.FUN-690005  VARCHAR(1)
          l_k                     LIKE type_file.num5,             #No.FUN-690005  SMALLINT
          l_zaa14                 LIKE zaa_file.zaa14,           #No.FUN-690005  VARCHAR(1)
          l_zaa16                 LIKE zaa_file.zaa16,           #No.FUN-690005  VARCHAR(1)
          l_zaa07                 LIKE zaa_file.zaa07,
          l_zaa06                 LIKE zaa_file.zaa06,
          l_zaa15                 LIKE zaa_file.zaa15,
          l_zab05                 LIKE zab_file.zab05,
          l_memo                  LIKE zab_file.zab05,
          l_zaa08_trim            STRING,
          l_cnt2                  LIKE type_file.num5,            #No.FUN-690005 SMALLINT
 
          l_len                   LIKE type_file.num5             #No.FUN-690005  SMALLINT   ### FUN-570264 ###
 DEFINE   l_zaa07_null            LIKE type_file.num5,            #No.FUN-690005  SMALLINT
          l_zaa07_max             LIKE type_file.num10            #No.FUN-690005  INTEGER
   CALL g_x.clear()
   CALL g_c.clear()
   CALL g_w.clear()
   LET g_memo = ""
   LET l_zab05 = ""
   LET l_i=0
   LET g_dash1 = ""
   LET g_dash = ""
   LET g_dash2 = ""
   LET l_dash = ""
   LET l_dash_t = ""
   LET l_cnt = 0
   LET g_len = 0
   LET l_len = 0      ### FUN-570264 ##
   ##判斷客製否，使用者名稱優先
 
   LET g_zaa10_value = "Y"
   CASE cl_db_get_database_type() 
      WHEN "MSV"
         LET l_sql = "SELECT count(*) FROM ",
                     "(SELECT DISTINCT zaa04,zaa17,zaa11 FROM zaa_file ",
                     "WHERE zaa01 = '",g_prog CLIPPED,"' AND zaa03 = '",g_rlang,"' AND zaa10 ='",
                     g_zaa10_value,"' AND ((zaa04='default' AND zaa17='default') OR zaa04 ='",g_user CLIPPED, 
                     "' OR zaa17= '",g_clas CLIPPED,"')) AS T"  #FUN-560079
      WHEN "ASE"     #FUN-AA0017
         LET l_sql = "SELECT count(*) FROM ",
                     "(SELECT DISTINCT zaa04,zaa17,zaa11 FROM zaa_file ",
                     "WHERE zaa01 = '",g_prog CLIPPED,"' AND zaa03 = '",g_rlang,"' AND zaa10 ='",
                     g_zaa10_value,"' AND ((zaa04='default' AND zaa17='default') OR zaa04 ='",g_user CLIPPED, 
                     "' OR zaa17= '",g_clas CLIPPED,"')) AS T"  #FUN-560079
      WHEN "ORA"
         LET l_sql = "SELECT count(*) FROM ",
                     "(SELECT DISTINCT zaa04,zaa17,zaa11 FROM zaa_file ",
                     "WHERE zaa01 = '",g_prog CLIPPED,"' AND zaa03 = '",g_rlang,"' AND zaa10 ='",
                     g_zaa10_value,"' AND ((zaa04='default' AND zaa17='default') OR zaa04 ='",g_user CLIPPED, 
                     "' OR zaa17= '",g_clas CLIPPED,"')) "  #FUN-560079
      WHEN "IFX"
         LET l_sql = "SELECT count(*) FROM table(multiset",
                     "(SELECT DISTINCT zaa04,zaa17,zaa11 FROM zaa_file ",
                     "WHERE zaa01 = '",g_prog CLIPPED,"' AND zaa03 = '",g_rlang,"' AND zaa10 ='",
                     g_zaa10_value,"' AND ((zaa04='default' AND zaa17='default') OR zaa04 ='",g_user CLIPPED, 
                     "' OR zaa17= '",g_clas CLIPPED,"')))"  #FUN-560079
   END CASE
 
   PREPARE zaa_pre1 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err("prepare zaa_cur1: ", SQLCA.SQLCODE, 1)   #FUN-560048
      # RETURN FALSE
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B70007
      EXIT PROGRAM                    #FUN-560048
   END IF
   EXECUTE zaa_pre1 INTO l_cust
 
   IF l_cust = 0 THEN
      LET g_zaa10_value = "N"
      CASE cl_db_get_database_type()
         WHEN "MSV"
            LET l_sql = "SELECT count(*) FROM ",
                        "(SELECT DISTINCT zaa04,zaa17,zaa11 FROM zaa_file ",
                        "WHERE zaa01 = '",g_prog CLIPPED,"' AND zaa03 = '",g_rlang,"' AND zaa10 ='",
                        g_zaa10_value,"' AND ((zaa04='default' AND zaa17='default') OR zaa04 ='",g_user CLIPPED, 
                        "' OR zaa17= '",g_clas CLIPPED,"')) AS T"  #FUN-560079
         WHEN "ASE"     #FUN-AA0017
            LET l_sql = "SELECT count(*) FROM ",
                        "(SELECT DISTINCT zaa04,zaa17,zaa11 FROM zaa_file ",
                        "WHERE zaa01 = '",g_prog CLIPPED,"' AND zaa03 = '",g_rlang,"' AND zaa10 ='",
                        g_zaa10_value,"' AND ((zaa04='default' AND zaa17='default') OR zaa04 ='",g_user CLIPPED, 
                        "' OR zaa17= '",g_clas CLIPPED,"')) AS T"  
         WHEN "ORA"
            LET l_sql = "SELECT count(*) FROM ",
                        "(SELECT DISTINCT zaa04,zaa17,zaa11 FROM zaa_file ",
                        "WHERE zaa01 = '",g_prog CLIPPED,"' AND zaa03 = '",g_rlang,"' AND zaa10 ='",
                        g_zaa10_value,"' AND ((zaa04='default' AND zaa17='default') OR zaa04 ='",g_user CLIPPED, 
                        "' OR zaa17= '",g_clas CLIPPED,"')) "  #FUN-560079
         WHEN "IFX"
            LET l_sql = "SELECT count(*) FROM table(multiset",
                        "(SELECT DISTINCT zaa04,zaa17,zaa11 FROM zaa_file ",
                        "WHERE zaa01 = '",g_prog CLIPPED,"' AND zaa03 = '",g_rlang,"' AND zaa10 ='",
                        g_zaa10_value,"' AND ((zaa04='default' AND zaa17='default') OR zaa04 ='",g_user CLIPPED, 
                        "' OR zaa17= '",g_clas CLIPPED,"')))"  #FUN-560079
      END CASE
      PREPARE zaa_pre4 FROM l_sql
      IF SQLCA.SQLCODE THEN
         CALL cl_err("prepare zaa_cur4: ", SQLCA.SQLCODE, 1)   #FUN-560048
       # RETURN FALSE
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B70007
         EXIT PROGRAM                    #FUN-560048
      END IF
 
      EXECUTE zaa_pre4 INTO l_cust
   END IF
 
   #FUN-580019
   LET g_seq = "zaa07"                                     
   SELECT MAX(zaa15) INTO g_line_seq FROM zaa_file   ## 計算行序
   WHERE zaa01 = g_prog AND zaa03 = g_rlang AND zaa10 = g_zaa10_value AND 
         ((zaa04='default' AND zaa17='default') OR zaa04 =g_user
           OR zaa17= g_clas)  
 
   #END FUN-580019
 
###   FUN-570264   ###
    IF cl_null(g_bgjob) OR g_bgjob = 'N' OR      #MOD-580124
     (g_bgjob='Y' AND (cl_null(g_rep_user) OR cl_null(g_rep_clas)
      OR cl_null(g_template)))
   THEN
      IF l_cust > 1 OR g_line_seq > 1 THEN
          CALL cl_prt_pos_t()                                  #MOD-570245
      ELSE
         SELECT DISTINCT zaa04,zaa17,zaa11,zaa12,zaa13,zaa19,zaa20,zaa21     #FUN-650017 #No.FUN-6C0048
           INTO g_zaa04_value,g_zaa17_value,g_zaa11_value,g_page_line,
                g_zaa13_value,g_left_margin,g_top_margin,g_bottom_margin   #No.FUN-6C0048
             FROM zaa_file WHERE zaa01 = g_prog AND zaa03 = g_rlang 
             AND zaa10 = g_zaa10_value AND ((zaa04='default' AND zaa17='default')
              OR zaa04 =g_user OR zaa17= g_clas)  #FUN-560079
      END IF
   ELSE
      SELECT DISTINCT zaa04,zaa17,zaa11,zaa12,zaa13,zaa19,zaa20,zaa21        #FUN-650017 #No.FUN-6C0048
        INTO g_zaa04_value,g_zaa17_value,g_zaa11_value,g_page_line,
             g_zaa13_value,g_left_margin,g_top_margin,g_bottom_margin   #No.FUN-6C0048
          FROM zaa_file WHERE zaa01 = g_prog AND zaa03 = g_rlang 
          AND zaa10 = g_zaa10_value AND zaa11 = g_template
          AND zaa04 = g_rep_user AND zaa17 = g_rep_clas
   END IF
 
   LET l_sql = " SELECT zab05 from zab_file ",
        "WHERE zab01= ? AND zab04=",g_rlang," AND zab03 = ?"
   PREPARE zab_prepare FROM l_sql
 
 
   DECLARE zaa_cur1 CURSOR FOR
           SELECT zaa02,zaa08,zaa09,zaa14,zaa16 FROM zaa_file
             WHERE zaa01 = g_prog AND zaa03 = g_rlang AND 
                   zaa04=g_zaa04_value AND  zaa10= g_zaa10_value AND 
                   zaa11 = g_zaa11_value AND zaa17= g_zaa17_value #FUN-560079
 
   FOREACH zaa_cur1 INTO l_i,l_zaa08,l_zaa09,l_zaa14,l_zaa16
   IF l_zaa09 = '1' THEN
         IF l_zaa14 = "H" OR l_zaa14 = "I" THEN              ##報表備註
             IF l_zaa16 = "Y" THEN
                  IF l_zaa14 = "H" THEN
                     LET g_memo_pagetrailer = 1 
                  ELSE
                     LET g_memo_pagetrailer = 0 
                  END IF
                  EXECUTE zab_prepare USING l_zaa08,'1' INTO l_zab05
                  #MOD-590446
                  EXECUTE zab_prepare USING l_zaa08,'2' INTO l_memo  #FUN-580131
                  IF l_zab05 IS NOT NULL OR l_memo IS NOT NULL THEN
                      LET l_zaa08 = l_zab05
                      LET g_memo = l_memo CLIPPED
                  END IF
                  #END MOD-590446
             ELSE
                  LET g_memo_pagetrailer = 0 
                  LET l_zaa08 = ""
                  LET g_memo =  ""
             END IF
         END IF
      LET l_zaa08_trim = l_zaa08
      LET g_x[l_i] = l_zaa08_trim.trimRight()
   ELSE
      LET g_x[l_i] = l_i
   END IF
   END FOREACH
 
   #FUN-650017
   #IF g_page_line = 0 OR g_page_line IS NULL THEN           #FUN-560229
   #    LET g_page_line = 66
   #END IF
   #LET g_line = g_page_line
   #END FUN-650017
 
   #FUN-580019
 
   LET l_zaa07_null = FALSE
   IF g_seq CLIPPED = "zaa18" THEN
      SELECT MAX(zaa18) INTO l_zaa07_max FROM zaa_file   ## 計算行序
      WHERE zaa01 = g_prog AND zaa03 = g_rlang AND zaa10= g_zaa10_value AND 
            zaa11 = g_zaa11_value AND zaa04= g_zaa04_value AND zaa09='2' AND
            zaa06='N' AND zaa17 = g_zaa17_value 
      IF l_zaa07_max > 0 THEN
 
      ELSE
            LET l_zaa07_null = TRUE
            LET g_seq = "zaa07"
      END IF
   END IF 
 
   IF g_seq CLIPPED = "zaa07" THEN
      LET l_sql="SELECT zaa02,zaa05,zaa06,zaa07,zaa08,zaa14,zaa15 FROM zaa_file ", #FUN-580063
                "WHERE zaa01 = '",g_prog CLIPPED,"' AND zaa03 = '",g_rlang,"'",
                " AND zaa04= '",g_zaa04_value,"' AND zaa09='2' AND zaa10='",
                  g_zaa10_value,"' AND zaa11='",g_zaa11_value CLIPPED,"' AND zaa17='",g_zaa17_value CLIPPED,
                "' AND zaa15=? ORDER BY zaa07"
   ELSE
      LET l_sql="SELECT zaa02,zaa05,zaa06,zaa18,zaa08,zaa14,zaa15 FROM zaa_file ", #FUN-580063
                "WHERE zaa01 = '",g_prog CLIPPED,"' AND zaa03 = '",g_rlang,"'",
                " AND zaa04= '",g_zaa04_value,"' AND zaa09='2' AND zaa10='",
                  g_zaa10_value,"' AND zaa11='",g_zaa11_value CLIPPED,"' AND zaa17='",g_zaa17_value CLIPPED,
                "'AND 1= ? ORDER BY zaa18"              #FUN-720048
   END IF
 
   PREPARE zaa_pre2 FROM l_sql
   DECLARE zaa_cur2 CURSOR FOR zaa_pre2
   IF g_seq CLIPPED = "zaa07" THEN
        SELECT MAX(zaa15) INTO g_line_seq FROM zaa_file   ## 計算行序
        WHERE zaa01 = g_prog AND zaa03 = g_rlang AND zaa10= g_zaa10_value AND 
              zaa11 = g_zaa11_value AND zaa04= g_zaa04_value AND zaa09='2' AND
              zaa06='N' AND zaa17 = g_zaa17_value
        IF l_zaa07_null = TRUE THEN
         SELECT MAX(zaa07) INTO l_zaa07_max FROM zaa_file   ## 計算行序
         WHERE zaa01 = g_prog AND zaa03 = g_rlang AND zaa10= g_zaa10_value AND 
               zaa11 = g_zaa11_value AND zaa04= g_zaa04_value AND zaa09='2' AND
               zaa06='N' AND zaa17 = g_zaa17_value and zaa15 = 1
 
        END IF
   ELSE
        LET g_line_seq = 1
   END IF
   
   FOR l_k = 1 TO g_line_seq 
      IF l_zaa07_max = 0 THEN
         LET l_cnt2 = 0
      END IF
 
     #FUN-720048
     #IF g_seq CLIPPED = "zaa07" THEN
     #     OPEN zaa_cur2 USING l_k
     #ELSE
     #     OPEN zaa_cur2
     #END IF
     #FOREACH zaa_cur2 INTO l_i,l_zaa05,l_zaa06,l_zaa07,l_zaa08,l_zaa14,l_zaa15  #FUN-580063
 
      FOREACH zaa_cur2 USING l_k INTO l_i,l_zaa05,l_zaa06,l_zaa07,l_zaa08,l_zaa14,l_zaa15  #FUN-580063
     #END FUN-720048
      
        IF l_zaa07_max > 0 THEN
              IF g_seq CLIPPED = "zaa18" THEN
                  IF cl_null(l_zaa07) OR l_zaa07 CLIPPED = " " THEN 
                    LET l_zaa06 = "Y"
                    LET l_zaa07_max = l_zaa07_max + 1 
                    LET l_zaa07 = l_zaa07_max
                  END IF
              ELSE
                    IF l_k > 1 THEN        
                          LET l_zaa07 = l_zaa07 + l_zaa07_max
                    END IF
              END IF
              LET l_zaa15 = 1
        END IF
        IF l_cnt=0 THEN
           LET g_c[l_i]=1
           LET g_w[l_i]=l_zaa05
           LET l_cnt=1+l_zaa05 + 1
        ELSE
           LET g_c[l_i] = l_cnt
           LET g_w[l_i]=l_zaa05
           LET l_cnt = l_cnt + l_zaa05 + 1  
        END IF
        LET g_zaa[l_i].zaa05 = l_zaa05
        LET g_zaa[l_i].zaa06 = l_zaa06
        LET g_zaa[l_i].zaa07 = l_zaa07
        LET g_zaa[l_i].zaa08 = l_zaa08
        LET g_zaa[l_i].zaa15 = l_zaa15
        LET g_zaa[l_i].zaa14 = l_zaa14
        IF l_zaa06 = 'N' THEN
              LET l_cnt2 = l_cnt2 + l_zaa05 + 1
               FOR l_j = 1 TO l_zaa05                          #MOD-570371
                     LET l_dash[l_j,l_j] = '-' 
              END FOR
               LET l_dash_t = l_dash_t CLIPPED," ", l_dash     #MOD-570371
        END IF
      END FOREACH
      CLOSE zaa_cur2
      IF l_cnt2> g_len THEN
         LET g_len = l_cnt2 - 1
         LET g_seq_item = l_k
         LET g_dash1 = l_dash_t CLIPPED
      END IF
      IF l_zaa07_max > 0 AND l_k > 1 THEN        
            #LET l_zaa07_max = l_zaa07 + l_zaa07_max
            LET l_zaa07_max = l_zaa07  #TQC-630166
      END IF
   END FOR
   IF l_zaa07_max > 0 THEN
      LET g_line_seq = 1
   END IF
   #END FUN-580019
   #FUN-560048
   IF g_len = 0 THEN
      CALL cl_err(g_prog,'lib-278',1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B70007
      EXIT PROGRAM
   END IF
   #END FUN-560048
 
   ##產生g_dash,g_dash2,g_dash1 
   FOR l_i = 1 TO g_len LET g_dash[l_i,l_i] = '=' END FOR 
   FOR l_i = 1 TO g_len LET g_dash2[l_i,l_i] = '-' END FOR 
 
    #MOD-570371
   {
   LET g_dash1 = NULL
   FOR l_i = 1 TO g_zaa.getLength()
       IF g_zaa[l_i].zaa15 = g_seq_item THEN
           IF g_zaa[l_i].zaa06 = 'N' THEN
               IF cl_null(g_dash1)THEN
                   LET g_dash1 = g_dash2[1,g_w[l_i]] CLIPPED
               ELSE
                   LET g_dash1 = g_dash1 CLIPPED," ",
                                   g_dash2[1,g_w[l_i]] CLIPPED
               END IF
           END IF
        END IF
   END FOR
   }
    #END MOD-570371
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
 
   #FUN-580019
   #IF g_towhom IS NULL OR g_towhom = ' '
   #   THEN LET g_head = ''
   #   ELSE LET g_head = 'TO:',g_towhom CLIPPED,'  '
   #END IF
 
   #LET l_len = g_head.getLength()    ### FUN-570264 ###
 
   #IF (g_pdate = 0 ) THEN
   #    LET g_pdate = g_today
   #END IF
 
   #LET g_head = g_head ,g_x[2] CLIPPED,g_pdate ,COLUMN 19+l_len,TIME,COLUMN (g_len-FGL_WIDTH(g_user)-20),'FROM:',
   #             g_user CLIPPED,COLUMN (g_len-13),g_x[3] CLIPPED   ### FUN-570264 ###
   LET g_head = "g_head"  
   #END FUN-580019
   LET g_pageno = 0
 
END FUNCTION
 
##################################################
# Descriptions...: 開啟選擇多樣版視窗
# Date & Author..: 04/11/29, CoCo
# Input Parameter: none
# Return code....: none
# Usage..........: CALL cl_prt_pos_t()
# Memo...........:
# Modify.........: No.FUN-7C0058
##################################################
FUNCTION cl_prt_pos_t()
DEFINE l_choicetemp               LIKE bnb_file.bnb06           #No.FUN-690005  VARCHAR(20)
DEFINE l_zaa11                    LIKE zaa_file.zaa11           #No.FUN-690005  VARCHAR(20)
DEFINE l_i                        LIKE type_file.num5          #No.FUN-690005 SMALLINT
#DEFINE l_names                   STRING   FUN-560079
DEFINE l_items                    STRING
DEFINE l_qry_gae04                LIKE gae_file.gae04,          #No.FUN-690005  VARCHAR(20)     #FUN-580019
       l_gae04                    LIKE gae_file.gae04           #No.FUN-690005  VARCHAR(20) 
 
   #TQC-5B0046
   IF  g_bgjob = "Y" THEN
          CLOSE WINDOW screen
   END IF
   CALL cl_load_act_sys("")  
   #END TQC-5B0046
 
   #FUN-580019
   IF g_line_seq > 1 THEN
      #FUN-6B0098
      #CALL cl_set_act_visible("cancel",FALSE)
      #CALL cl_init_qry_var()
      #LET g_qryparam.form = "q_zaa2"
      #LET g_qryparam.arg1 = g_prog
      #LET g_qryparam.arg2 = g_rlang
      #LET g_qryparam.arg3 = g_zaa10_value
      #LET g_qryparam.arg4 = g_user
      #LET g_qryparam.arg5 = g_clas
      #LET g_qryparam.construct = "N"
      #CALL cl_create_qry() RETURNING g_zaa04_value,g_zaa17_value,g_zaa11_value,
      #                               l_qry_gae04
      #SELECT gae04 INTO l_gae04 FROM gae_file 
      # where gae01='p_zaa' AND gae02='zaa18' AND gae03=g_rlang
      #IF l_gae04 = l_qry_gae04 THEN
      #     LET g_seq="zaa18"
      #END IF
 
      CALL cl_set_act_visible("cancel",FALSE)
      CALL q_zaa2(FALSE,FALSE,g_prog,g_rlang,g_zaa10_value,g_user,g_clas)
           RETURNING g_zaa04_value,g_zaa17_value,g_zaa11_value, l_qry_gae04
 
      SELECT ze03 INTO l_gae04
        FROM ze_file WHERE ze01 = 'lib-363' AND ze02 = g_rlang
      IF l_gae04 = l_qry_gae04 THEN
           LET g_seq="zaa18"
      END IF
 
      #END FUN-6B0098
   ELSE
      CALL cl_set_act_visible("cancel",FALSE)
      CALL cl_init_qry_var()
      LET g_qryparam.form = "q_zaa"
      LET g_qryparam.arg1 = g_prog
      LET g_qryparam.arg2 = g_rlang
      LET g_qryparam.arg3 = g_zaa10_value
      LET g_qryparam.arg4 = g_user
      LET g_qryparam.arg5 = g_clas
      LET g_qryparam.construct = "N"
      CALL cl_create_qry() RETURNING g_zaa04_value,g_zaa17_value,g_zaa11_value
   END IF
   #END FUN-580019
             
   CALL cl_set_act_visible("cancel",TRUE)
    #MOD-570245
   IF cl_null(g_zaa04_value) THEN
        DECLARE zaa_cs CURSOR FOR 
         SELECT DISTINCT zaa04,zaa17,zaa11,zaa12,zaa13,zaa19,zaa20,zaa21 #No.FUN-6C0048
             FROM zaa_file WHERE zaa01 = g_prog AND zaa03 = g_rlang 
             AND zaa10 = g_zaa10_value AND zaa04='default' AND zaa17='default'
        OPEN zaa_cs
        FETCH zaa_cs INTO g_zaa04_value,g_zaa17_value,g_zaa11_value,g_page_line,g_zaa13_value,g_left_margin,g_top_margin,g_bottom_margin   #FUN-650017 #No.FUN-6C0048
        IF SQLCA.SQLCODE OR SQLCA.SQLCODE = NOTFOUND THEN
           CLOSE zaa_cs
           #RETURN
           CALL cl_err("FETCH zaa_cs: ", SQLCA.SQLCODE, 1)     # #FUN-560048
           CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B70007
           EXIT PROGRAM         #END FUN-560048
 
        END IF
        CLOSE zaa_cs
   ELSE
        SELECT DISTINCT zaa12,zaa13,zaa19,zaa20,zaa21 into g_page_line,g_zaa13_value,g_left_margin,g_top_margin,g_bottom_margin FROM zaa_file  #FUN-650017 #No.FUN-6C0048
           WHERE zaa01 = g_prog AND zaa03 = g_rlang AND 
                 zaa04=g_zaa04_value AND zaa10= g_zaa10_value AND
                 zaa11 = g_zaa11_value AND zaa17= g_zaa17_value #FUN-560079
   END IF      
    #END MOD-570245
END FUNCTION
 
#FUN-580019
##################################################
# Descriptions...: 依照設定重新產生報表長度、定位點及 g_dash、g_dash2 資料
# Date & Author..: 05/08/08, Echo
# Input Parameter: none
# Return code....: none
# Usage..........: CALL cl_prt_pos_len()
# Memo...........:
# Modify.........: No.FUN-7C0058
##################################################
FUNCTION cl_prt_pos_len()
DEFINE l_i,k,a,b      LIKE type_file.num10           #No.FUN-690005  INTEGER                      #FUN-5A0044
DEFINE l_zaa02        LIKE zaa_file.zaa02
DEFINE l_cnt          LIKE type_file.num10            #No.FUN-690005  INTEGER
DEFINE l_cnt2         LIKE type_file.num10            #No.FUN-690005  INTEGER
DEFINE l_sql          LIKE type_file.chr1000       #No.FUN-690005 VARCHAR(1000)
DEFINE l_zaa_sort     DYNAMIC ARRAY WITH DIMENSION 2 OF RECORD
                        zaa02  LIKE zaa_file.zaa02,   #序號
                        zaa05  LIKE zaa_file.zaa05,   #寬度
                        zaa06  LIKE zaa_file.zaa06,   #隱藏否
                        zaa08  LIKE zaa_file.zaa08,   #欄位內容
                        zaa14  LIKE zaa_file.zaa14    #欄位屬性
                      END RECORD
   LET g_len = 0   
   #MOD-5A0397
   #IF g_line_seq = 1 THEN              
   #   ##單行列印    
   #   FOR l_i = 1 TO g_zaa.getLength()
   #       IF g_zaa[l_i].zaa06 = 'N' THEN
   #             LET g_len = g_len + g_zaa[l_i].zaa05 + 1
   #       END IF
   #   END FOR
   #ELSE
      CALL g_c.clear()
      CALL g_w.clear()
      LET l_cnt2 = 0
 
      #FUN-5A0044
      CALL l_zaa_sort.clear()
      FOR k = 1 to g_zaa.getLength()
        IF g_zaa[k].zaa05 IS NOT NULL THEN
             LET a = g_zaa[k].zaa15
             LET b = g_zaa[k].zaa07
             LET l_zaa_sort[a,b].zaa02=k
             LET l_zaa_sort[a,b].zaa05=g_zaa[k].zaa05
             LET l_zaa_sort[a,b].zaa06=g_zaa[k].zaa06
             LET l_zaa_sort[a,b].zaa08=g_zaa[k].zaa08 CLIPPED
             LET l_zaa_sort[a,b].zaa14=g_zaa[k].zaa14 
        END IF 
      END FOR
      FOR a = 1 to g_line_seq
        LET l_cnt = 0 
        FOR b = 1 to l_zaa_sort[a].getLength()
         IF l_zaa_sort[a,b].zaa05 IS NOT NULL THEN
             LET l_zaa02 = l_zaa_sort[a,b].zaa02
             IF l_cnt2=0 THEN
                LET g_c[l_zaa02]=1
                LET g_w[l_zaa02]= l_zaa_sort[a,b].zaa05
                LET l_cnt2=1+l_zaa_sort[a,b].zaa05 + 1
             ELSE
                LET g_c[l_zaa02] = l_cnt2
                LET g_w[l_zaa02]= l_zaa_sort[a,b].zaa05
                LET l_cnt2 = l_cnt2 + l_zaa_sort[a,b].zaa05 + 1  
             END IF
             IF l_zaa_sort[a,b].zaa06 = "N" THEN
                 LET l_cnt = l_cnt + l_zaa_sort[a,b].zaa05 + 1
             END IF
         END IF
        END FOR
        IF l_cnt> g_len THEN
           LET g_len = l_cnt - 1
           LET g_seq_item = l_i
        END IF
      END FOR
   #END IF
   #END FUN-5A0044
   #END MOD-5A0397
 
   LET g_dash=NULL
   LET g_dash2=NULL
   FOR l_i = 1 TO g_len LET g_dash[l_i,l_i] = '=' END FOR
   FOR l_i = 1 TO g_len LET g_dash2[l_i,l_i] = '-' END FOR
END FUNCTION
#END FUN-580019
 
#TQC-5B0170
##################################################
# Descriptions...: 存放g_zaa_dyn陣列
# Date & Author..: 05/11/21, Echo
# Input Parameter: none
# Return code....: none
# Usage..........: CALL cl_prt_pos_dyn()
# Memo...........:
# Modify.........: No.FUN-7C0058
##################################################
FUNCTION cl_prt_pos_dyn()
DEFINE i          LIKE type_file.num10            #No.FUN-690005  INTEGER
DEFINE j          LIKE type_file.num10            #No.FUN-690005  INTEGER
 
   LET j = g_zaa_dyn.getLength() + 1
   FOR i = 1 TO g_zaa.getLength()
     IF g_zaa[i].zaa05 IS NOT NULL THEN
         LET g_zaa_dyn[j,i] = g_zaa[i].zaa08
     END IF
   END FOR
END FUNCTION
#END TQC-5B0170
 
##TQC-630166
##################################################
# Descriptions...: 依照報表長度，將"列印條件"進行折行動作
# Date & Author..: 05/08/08, Echo
# Input Parameter: p_wc 列印條件
# Return code....: none
# Usage..........: CALL cl_prt_pos_wc(p_wc)
# Memo...........:
# Modify.........: No.FUN-7C0058
##################################################
FUNCTION cl_prt_pos_wc(p_wc)
DEFINE p_wc         STRING
DEFINE l_i          LIKE type_file.num10            #No.FUN-690005  INTEGER
DEFINE l_j          LIKE type_file.num10            #No.FUN-690005  INTEGER
DEFINE l_tag        LIKE type_file.num10            #No.FUN-690005  INTEGER

 IF g_len = 0 OR g_len IS NULL OR g_len < 10 THEN LET g_len = 80 END IF   #MOD-CB0286 add
 display p_wc
 LET l_j = g_len - 10
 FOR l_i = 1 TO p_wc.getlength()
      IF l_j > p_wc.getLength() THEN 
          LET l_j = p_wc.getLength()
      END IF
      IF l_i = 1 THEN
         PRINT g_x[8] CLIPPED, p_wc.subString(l_i,l_j)
      ELSE
         PRINT COLUMN 10, p_wc.subString(l_i,l_j)
      END IF
      LET l_i = l_j
      LET l_j = l_i + g_len - 10
 END FOR
END FUNCTION
#END TQC-630166
