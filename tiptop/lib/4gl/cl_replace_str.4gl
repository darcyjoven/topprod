# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Program name...: cl_replace_str.4gl
# Descriptions...: 取代字串.
#             	   如果找不到所要替換的舊字串,則回傳原來的字串.
# Date & Author..: 03/07/09 by Hiko
# Usage..........: CALL cl_replace_str("abcdefg", "cde", "WXYZ") RETURNING ls_new
# Modify.........: No.TQC-630132 06/03/13 By saki 增加參數預設值function
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-8C0135 08/12/15 By alex 增加multi-str變更函式
# Modify.........: No.FUN-920032 09/02/03 By saki 增加sql變更資料庫字串函式
# Modify.........: No.MOD-960184 09/06/18 By Dido INSERT 語法調整
# Modify.........: No:FUN-A10002 10/01/04 By Hiko 改用StringBuffer處理.
# Modify.........: No:TQC-B60059 11/06/13 By Kevin 指定搜尋的位置
 
DATABASE ds      #No.FUN-690005    #FUN-7C0053
 
DEFINE   mi_once  LIKE type_file.num5             #No.FUN-690005  SMALLINT   #是否只取代第一個找到的替換字串.
 
# Descriptions...: 預設參數值
# Date & Author..: 2006/03/13 by saki
# Input Parameter: none
# Return Code....: void
# Memo...........: No.TQC-630132
 
FUNCTION cl_replace_init()
   LET mi_once = FALSE
END FUNCTION
 
 
# Descriptions...: 設定為只取代第一個找到的替換字串.
# Date & Author..: 2003/08/25 by Hiko
# Input Parameter: none
# Return Code....: void
 
FUNCTION cl_replace_once()
   LET mi_once = TRUE
END FUNCTION
 
 
# Descriptions...: 取代字串.
# Date & Author..: 2003/07/09 by Hiko
# Input Parameter: ps_source STRING 來源字串
#                  ps_old STRING 舊字串
#                  ps_new STRING 新字串
# Return Code....: STRING 取代後的新字串
# Modify.........: No.MOD-590389 05/09/20 alex 將 >1 改 >=1 並加適當處理
# Modify.........: No:FUN-A10002 10/01/04 By Hiko 改用StringBuffer處理. 
FUNCTION cl_replace_str(ps_source, ps_old, ps_new)
  DEFINE ps_source,ps_old,ps_new STRING
  #Begin:FUN-A10002
  DEFINE buf base.StringBuffer

  LET buf = base.StringBuffer.create()
  CALL buf.append(ps_source)
  IF mi_once THEN
     CALL buf.replace(ps_old, ps_new, 1)
  ELSE 
     CALL buf.replace(ps_old, ps_new, 0)
  END IF
  RETURN buf.toString()
  #End:FUN-A10002

  #Begin:FUN-A10002 Mark
  #DEFINE ls_source_left,ls_source_right,ls_result STRING
  #DEFINE li_old_index  LIKE type_file.num5             #No.FUN-690005  SMALLINT
  #
  #LET ps_source = ps_source.trimRight()
  #LET li_old_index = ps_source.getIndexOf(ps_old, 1)
  #
  #IF (li_old_index >= 1) THEN   #MOD-590389
  #   IF li_old_index = 1 THEN
  #      LET ls_source_left = ""
  #   ELSE
  #      LET ls_source_left = ps_source.subString(1, li_old_index-1)
  #   END IF
  #   LET ls_source_right = ps_source.subString(li_old_index+ps_old.getLength(), ps_source.getLength())
  #   LET ls_result = ls_source_left,ps_new,ls_source_right
  #
  #   IF (NOT mi_once) THEN
  #      LET ls_result = cl_replace_str(ls_result, ps_old, ps_new) 
  #   END IF
  #ELSE
  #   LET ls_result = ps_source
  #END IF
  #
  #RETURN ls_result
  #End:FUN-A10002 Mark
END FUNCTION
 
 
# Descriptions...: 取代字串 (適用於multi-byte)
# Date & Author..: 08/12/14 by alex  #MOD-8C0135
# Input Parameter: ps_source STRING 來源字串
#                  ps_old STRING 舊字串
#                  ps_new STRING 新字串
# Return Code....: STRING 取代後的新字串
 
FUNCTION cl_replace_multistr(ps_source, ps_old, ps_new)
 
   DEFINE ps_source        STRING
   DEFINE ps_old           STRING
   DEFINE ps_new           STRING
   DEFINE lb_source        base.StringBuffer
   DEFINE ls_sourcepart    STRING
   DEFINE lb_old           base.StringBuffer
   DEFINE ls_oldpart       STRING
   DEFINE ls_result        STRING
   DEFINE ls_check         STRING
   DEFINE li_source_index  LIKE type_file.num5      
   DEFINE li_old_index     LIKE type_file.num5      
 
   LET ps_source = ps_source.trimRight()
   LET lb_source = base.StringBuffer.create()
   CALL lb_source.append(ps_source)
   LET lb_old = base.StringBuffer.create()
   CALL lb_old.append(ps_old)
   LET ls_oldpart = lb_old.getCharAT(1)
 
   LET li_source_index = 1
   LET ls_result = ""
   WHILE TRUE
      IF li_source_index > lb_source.getLength() THEN EXIT WHILE END IF
      LET ls_sourcepart = lb_source.getCharAT(li_source_index)
 
      IF ls_sourcepart = ls_oldpart THEN 
         LET ls_check = lb_source.subString(li_source_index,li_source_index+lb_old.getLength()-1)
         IF ls_check = ps_old THEN
            LET ls_result = ls_result,ps_new
            LET li_source_index = li_source_index + ps_old.getLength()
            CONTINUE WHILE
         ELSE
            LET ls_result = ls_result,ls_sourcepart
         END IF
      ELSE
         LET ls_result = ls_result,ls_sourcepart
      END IF
      LET li_source_index = li_source_index + ls_sourcepart.getLength()
   END WHILE
   RETURN ls_result
END FUNCTION
 
 
# Descriptions...: 取代SQL字串. FUN-920032
# Date & Author..: 2009/02/03 by saki
# Input Parameter: ps_source STRING 來源SQL字串
# Return Code....: STRING 取代後的新字串
# Modify.........: 
 
FUNCTION cl_replace_sqldb(ps_sql)
   DEFINE   ps_sql         STRING
   DEFINE   ls_temp        STRING
   DEFINE   ls_temp2       STRING
   DEFINE   ls_pres        STRING
   DEFINE   ls_sqldb       STRING
   DEFINE   ls_posts       STRING
   DEFINE   ls_dbname      STRING
   DEFINE   lc_azp03       LIKE azp_file.azp03
   DEFINE   lc_azp04       LIKE azp_file.azp04
   DEFINE   lst_tables     base.StringTokenizer
   DEFINE   ls_table       STRING
   DEFINE   ls_sqldb_tmp   STRING
 
   LET ps_sql = ps_sql.trim()
   LET ls_temp = ps_sql.toLowerCase()
 
   CASE
      WHEN cl_db_get_database_type() = "ORA"
         CASE UPSHIFT(ps_sql.subString(1,6))
            WHEN "SELECT"
               IF ls_temp.getIndexOf(" from ",1) THEN
                  LET ls_pres = ps_sql.subString(1,ls_temp.getIndexOf(" from ",1)+5)
                  LET ls_posts = ps_sql.subString(ls_temp.getIndexOf(" from ",1)+6,ps_sql.getLength())
                  LET ls_temp = ls_posts.toLowerCase()
                  IF ls_temp.getIndexOf(" where ",1) THEN
                     LET ls_sqldb = ls_posts.subString(1,ls_temp.getIndexOf(" where ",1)-1)
                     LET ls_posts = ls_posts.subString(ls_temp.getIndexOf(" where ",1),ls_temp.getLength())
                  ELSE
                     LET ls_sqldb = ls_posts
                     LET ls_posts = ""
                  END IF
               END IF
            WHEN "INSERT"
               LET ls_pres = ps_sql.subString(1,12)
              #-MOD-960184-add-
               IF ls_temp.getIndexOf(") values",1) THEN
                  LET ls_sqldb = ps_sql.subString(13,ls_temp.getIndexOf("(",1)-1)
                  LET ls_posts = ps_sql.subString(ls_temp.getIndexOf("(",1),ls_temp.getLength())
               ELSE
                  LET ls_temp2 = ls_temp
                  IF ls_temp2.getIndexOf("values",1) THEN
                     LET ls_temp2= ps_sql.subString(13,ls_temp2.getIndexOf("values",1)-1) 
                     IF ls_temp2.getIndexOf(")",1) THEN                   
                        LET ls_sqldb = ps_sql.subString(13,ls_temp.getIndexOf("(",1)-1)
                        LET ls_posts = ps_sql.subString(ls_temp.getIndexOf("(",1),ls_temp.getLength())
                     ELSE
                        LET ls_sqldb = ps_sql.subString(13,ls_temp.getIndexOf(" values",1)-1)
                        LET ls_posts = ps_sql.subString(ls_temp.getIndexOf(" values",1),ls_temp.getLength())
                     END IF
                  END IF
               END IF
              #LET ls_temp2 = ls_temp
              #IF ls_temp2.getIndexOf("values",1) THEN
              #   LET ls_temp2= ps_sql.subString(13,ls_temp2.getIndexOf("values",1)-1) 
              #   IF ls_temp2.getIndexOf(")",1) THEN                   
              #      LET ls_sqldb = ps_sql.subString(13,ls_temp.getIndexOf("(",1)-1)
              #      LET ls_posts = ps_sql.subString(ls_temp.getIndexOf("(",1),ls_temp.getLength())
              #   ELSE
              #      LET ls_sqldb = ps_sql.subString(13,ls_temp.getIndexOf(" values",1)-1)
              #      LET ls_posts = ps_sql.subString(ls_temp.getIndexOf(" values",1),ls_temp.getLength())
              #   END IF
              #END IF
              #
              #IF ls_temp.getIndexOf(") values",1) THEN
              #   LET ls_sqldb = ps_sql.subString(13,ls_temp.getIndexOf("(",1)-1)
              #   LET ls_posts = ps_sql.subString(ls_temp.getIndexOf("(",1),ls_temp.getLength())
              #ELSE
              #   LET ls_sqldb = ps_sql.subString(13,ls_temp.getIndexOf(" values",1)-1)
              #   LET ls_posts = ps_sql.subString(ls_temp.getIndexOf(" values",1),ls_temp.getLength())
              #END IF
              #-MOD-960184-add-
            WHEN "UPDATE"
               LET ls_pres = ps_sql.subString(1,7)
               LET ls_sqldb = ps_sql.subString(8,ls_temp.getIndexOf(" set ",1)-1)
               LET ls_posts = ps_sql.subString(ls_temp.getIndexOf(" set ",1),ls_temp.getLength())
            WHEN "DELETE"
               LET ls_pres = ps_sql.subString(1,12)
               LET ls_posts = ps_sql.subString(13,ls_temp.getLength())
               LET ls_temp = ls_posts.toLowerCase()
               IF ls_temp.getIndexOf(" where ",1) THEN
                  LET ls_sqldb = ls_posts.subString(1,ls_temp.getIndexOf(" where ",1)-1)
                  LET ls_posts = ls_posts.subString(ls_temp.getIndexOf(" where ",1),ls_temp.getLength())
               ELSE
                  LET ls_sqldb = ls_posts
                  LET ls_posts = ""
               END IF
         END CASE
   END CASE
 
   LET ls_dbname = ls_sqldb.subString(1,ls_sqldb.getIndexOf(".",1)-1)
   IF ls_dbname IS NOT NULL THEN
      LET lc_azp03 = ls_dbname
      SELECT DISTINCT azp04 INTO lc_azp04 FROM azp_file WHERE azp03 = lc_azp03
      IF NOT cl_null(lc_azp04) THEN
         LET lst_tables = base.StringTokenizer.create(ls_sqldb,",")
         WHILE lst_tables.hasMoreTokens()
            LET ls_table = lst_tables.nextToken()
            LET ls_table = ls_table.trimright()
            LET ls_sqldb_tmp = ls_sqldb_tmp,ls_table,lc_azp04 CLIPPED,","
         END WHILE
         LET ls_sqldb = ls_sqldb_tmp.subString(1,ls_sqldb_tmp.getLength()-1)
         LET ps_sql = ls_pres,ls_sqldb,ls_posts
      END IF
   END IF
 
   RETURN ps_sql
END FUNCTION
 

# Descriptions...: 在字串 s 內檢索 t 字串,從第 n 個位置起 找第 m 次出現字串 t的位置 回傳位置值
# Date & Author..: 2011/04/07 by alex
# Input Parameter: s,t 字串 n,m 數值 
# Return Code....: 指定搜尋的位置

FUNCTION cl_str_position(s,t,n,m)      #TQC-B60059

   DEFINE s,t,ls_src,ls_target   STRING
   DEFINE n,m,i,li_times,li_r,li_step   LIKE type_file.num5
   DEFINE buf   base.StringBuffer

   #防呆
   IF cl_null(s) OR cl_null(t) OR n = 0 OR m <= 0 THEN
      RETURN 0
   END IF

   #防惡搞
   IF ( n > 0 AND n > s.getLength() ) OR ( n<0 AND (n * -1) > s.getLength() ) OR
      ( m > 0 AND m > s.getLength() ) THEN
      RETURN 0
   END IF

   IF n < 0 THEN
      LET li_step = n * (-1) 
      LET buf = base.StringBuffer.create()
      CALL buf.append(s)
      FOR i = 1 TO buf.getLength()
         LET ls_src = buf.getCharAt(i),ls_src
      END FOR
      CALL buf.clear()
      CALL buf.append(t)
      FOR i = 1 TO buf.getLength()
         LET ls_target = buf.getCharAt(i),ls_target
      END FOR
   ELSE
      LET li_step = n
      LET ls_src = s
      LET ls_target = t
   END IF
   
   WHILE TRUE
      LET li_r = ls_src.getIndexOf(ls_target, li_step )
      IF li_r > 0 THEN 
         LET li_times = li_times + 1 
      ELSE
         EXIT WHILE
      END IF
      IF li_times = m THEN
         IF n > 0 THEN
            RETURN li_r
         ELSE
            RETURN s.getLength() - li_r - t.getLength() + 2
         END IF
      ELSE
         LET li_step = li_r + 1
         CONTINUE WHILE
      END IF
   END WHILE
   
   RETURN 0
END FUNCTION
