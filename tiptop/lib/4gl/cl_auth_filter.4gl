# Prog. Version..: '5.20'     
#
# Library name...: cl_auth_filter.4gl
# Descriptions...: 取得權限過濾器所設定的過濾條件.
# Memo...........: 取得順序為:1.使用者 2.權限類別 3.部門 4.預設(代表任何人都需要加上過濾條件)                                                                        
# Usage..........: CALL cl_auth_filter(g_prog) RETURNING ls_filter
# Date & Author..: 2009/05/21 by Hiko
# Modify.........: No.FUN-980030 09/08/04 By Hiko 新建程式
 
DATABASE ds
 
GLOBALS "../../config/top.global" 
 
#FUN-980030
 
##########################################################################
# Descriptions...: 取得權限過濾器所設定的過濾條件.
# Input parameter: p_prog_name 程式代碼
# Return code....: ls_filter
# Usage..........: CALL cl_auth_filter(g_prog) RETURNING ls_filter
##########################################################################
FUNCTION cl_auth_filter(p_prog_name)
   DEFINE p_prog_name LIKE type_file.chr20
   DEFINE l_cnt SMALLINT,
          l_gfg_sql STRING,
          rec_gfg RECORD LIKE gfg_file.*
   DEFINE l_filter STRING
   DEFINE i,j,l_idx SMALLINT,
          l_gfj_sql STRING,
          l_gfj_arr DYNAMIC ARRAY OF RECORD
                    gfj04 LIKE gfj_file.gfj04,
                    gfh05 LIKE gfh_file.gfh05
                    END RECORD,
          l_gfj04_tok base.StringTokenizer,
          l_gfj04   STRING,
          l_cond_match BOOLEAN
   DEFINE l_grup STRING #為了要使用字串的getIndexOf所宣告的變數.
 
   #1.判斷此程式是否有設定資料過濾條件.
   SELECT count(*) INTO l_cnt FROM gfg_file WHERE gfg01=p_prog_name
   IF (l_cnt = 0) THEN
      RETURN null #要使用
   END IF
      
   LET l_gfg_sql = "SELECT * FROM gfg_file WHERE gfg01='",p_prog_name CLIPPED,"'"
   DECLARE gfg_cs SCROLL CURSOR FROM l_gfg_sql
   OPEN gfg_cs
   FETCH FIRST gfg_cs INTO rec_gfg.*  
   CLOSE gfg_cs
  
   #取得合併條件
   IF NOT cl_null(rec_gfg.gfg08) THEN
      IF rec_gfg.gfg07='1' THEN
         LET l_filter = " AND ",rec_gfg.gfg08," " #增加空白比較保險
      ELSE #2:OR
         LET l_filter = " OR ",rec_gfg.gfg08," " #增加空白比較保險
      END IF
   END IF
 
   #2.依據使用者/權限類別/部門/預設值的順序來取得過濾條件.
   FOR i=1 TO 4
      SELECT count(*) INTO l_cnt FROM gfj_file WHERE gfj01=p_prog_name AND gfj03=i
      IF (l_cnt = 0) THEN
         CONTINUE FOR
      END IF
     
      LET l_gfj_sql = "SELECT a.gfj04,b.gfh05 FROM gfj_file a",
                       " INNER JOIN gfh_file b ON b.gfh01=a.gfj01 AND b.gfh02=a.gfj05",
                       " WHERE a.gfj01='",p_prog_name CLIPPED,"' AND gfj03=",i,
                       " ORDER BY a.gfj02"
      DECLARE gfj_cs CURSOR FROM l_gfj_sql
      LET l_idx = 0
      FOREACH gfj_cs INTO l_gfj_arr[l_idx+1].*
         LET l_idx = l_idx + 1
      END FOREACH
 
      LET l_cond_match = FALSE
 
      #執行到這裡就一定會往下執行.
      FOR j=1 TO l_idx
         IF i<4 THEN #非預設情況的判斷
            LET l_gfj04_tok = base.StringTokenizer.create(l_gfj_arr[j].gfj04 CLIPPED,"|")
            WHILE l_gfj04_tok.hasMoreTokens()
               LET l_gfj04 = l_gfj04_tok.nextToken()
               LET l_gfj04 = l_gfj04.trim()
               
               CASE i
                  WHEN 1 #依使用者
                     IF l_gfj04 = g_user THEN
                        LET l_filter = l_filter,l_gfj_arr[j].gfh05 CLIPPED
                        LET l_cond_match = TRUE
                        EXIT WHILE
                     END IF
                  WHEN 2 #依權限類別
                     IF l_gfj04 = g_clas THEN
                        LET l_filter = l_filter,l_gfj_arr[j].gfh05 CLIPPED
                        LET l_cond_match = TRUE
                        EXIT WHILE
                     END IF              
                  WHEN 3 #依部門
                     LET l_grup = g_grup CLIPPED
                     IF l_grup.getIndexOf(l_gfj04,1)>0 THEN
                        #舉例說明:
                        #1.g_grup='22',若gfj04='2201,2203,2204,2209',則g_grup的資料不須被限制.
                        #2.g_grup='2201',若gfj04='21,22,25',則g_grup的資料需要被限制.
                        LET l_filter = l_filter,l_gfj_arr[j].gfh05 CLIPPED
                        LET l_cond_match = TRUE
                        EXIT WHILE
                     END IF              
               END CASE
            END WHILE
 
            IF l_cond_match THEN
               EXIT FOR
            END IF
         ELSE #預設,所有人的資料都要被限制.
            LET l_filter = l_filter,l_gfj_arr[j].gfh05 CLIPPED
            LET l_cond_match = TRUE #真的執行到這裡,就表示已經到最後了,所以其實沒有設定l_cond_match也無所謂.
            EXIT FOR
         END IF
      END FOR
      #因為是依據使用者/權限類別/部門/預設值的順序來取得過濾條件,
      #所以在順序取得的過程當中,只要其中一種有設定,就可以不必繼續往下了.
      IF l_cond_match THEN
         EXIT FOR
      END IF
   END FOR
 
   IF NOT cl_null(l_filter) THEN
      #LET l_filter = " AND ",cl_replace_global_var(l_filter)
      LET l_filter = cl_replace_global_var(l_filter)
   END IF
 
   RETURN l_filter #要使用
END FUNCTION
 
##########################################################################
# Descriptions...: 取代過濾條件內的共用變數字串.
# Input parameter: none
# Return code....: ps_src
# Usage..........: CALL cl_replace_global_var(filter_condition)
# Memo...........: p_auth_condition也會呼叫
##########################################################################
FUNCTION cl_replace_global_var(ps_src)
   DEFINE ps_src STRING
   DEFINE l_rep_user STRING,
          l_rep_grup STRING,
          l_rep_clas STRING
 
   LET l_rep_user = "'",g_user,"'"
   LET l_rep_grup = "'",g_grup,"'"
   LET l_rep_clas = "'",g_clas,"'"
   #共用變數只支援:g_user,g_grup,g_clas
   LET ps_src = cl_replace_str(ps_src, "g_user", l_rep_user)
   LET ps_src = cl_replace_str(ps_src, "g_grup", l_rep_grup)
   LET ps_src = cl_replace_str(ps_src, "g_clas", l_rep_clas)
 
   RETURN ps_src
END FUNCTION
 
