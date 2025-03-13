# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Program name...: cl_bef_sel.4gl
# Descriptions...: 跨資料庫查詢時專用:在SELECT SQL執行前增加xxxplant條件
# Date & Author..: 2009/07/15 by Hiko
# Usage..........: CALL cl_bef_sel(l_sql,"DS-4") RETURNING l_sql
# Modify.........: No.FUN-980030 09/08/04 By Hiko 新建程式
# Modify.........: NO.FUN-9B0153 09/11/30 By tommas 剔除與登入plant所對應的實體db無關的plant 
#                                                   新增sql_sever去代理呼叫parse_sel
# Modify.........: No.FUN-A50085 10/05/24 By tommas 1.cl_parse_qry_sql要能夠接多個營運中心清單當作參數.
#                                                   2.因為移除營運中心階層,所以原本程式呼叫cl_bef_sel的動作,要和cl_parse_qry_sql相同.
# Modify.........: No.FUN-A80039 10/08/05 By Hiko 調整UPDATE語法解析錯誤的問題.
# Modify.........: No.FUN-A80093 10/08/17 By Hiko 只能傳遞單一plant,並檢查虛擬db才需要parse
# Modify.........: No.FUN-AB0070 10/11/16 By Hiko 移除WHERE增加xxx_file.xxxplant條件時的xxx_file,以免Sybase出錯.
# Modify.........: No.FUN-AB0108 10/11/26 By Hiko SQL語法有JOIN時,會忽略JOIN後面Table是否要加上xxxplant的判斷,所以LEFT JOIN不會有問題,RIGHT JOIN請改為LEFT JOIN.
# Modify.........: No.FUN-B20063 11/02/23 By Jay  SQL語法遇中文字會變空白
# Modify.........: No.TQC-BA0093 11/10/18 By Hiko 調整cl_is_virtual_db的判斷方式
 
DATABASE ds
 
#FUN-980030
 
GLOBALS "../../config/top.global"
 
DEFINE g_plant_str STRING
DEFINE p_sql_map  DYNAMIC ARRAY OF RECORD  
           p_key   STRING,
           p_value STRING
                  END RECORD 

##################################################
# Descriptions...: 在SELECT SQL執行前增加xxxplant條件
# Date & Author..: 2009/07/15 by Hiko
# Input Parameter: p_src_sql   來源SQL
#                : p_plant_str 要增加的plant字串
# Return code....: l_final_sql 增加xxxplant條件後的SQL
##################################################
FUNCTION cl_bef_sel(p_src_sql, p_plant_str)
   DEFINE p_src_sql          STRING,
          p_plant_str        STRING
   DEFINE l_tok              base.StringTokenizer,
          l_plant            STRING,
          l_final_sql        STRING
   DEFINE l_azwa_rec DYNAMIC ARRAY OF RECORD
                     azwa03 LIKE azwa_file.azwa03
                     END RECORD,
          l_azwa_sql STRING,
          l_i        SMALLINT,
          l_azwa_arr DYNAMIC ARRAY OF STRING,
          l_azwa03   STRING
   DEFINE l_azw05_u  LIKE azw_file.azw05,   #No.FUN-9B0153
          l_azw05_p  LIKE azw_file.azw05,   #No.FUN-9B0153
          l_plant_p  LIKE azw_file.azw01    #No.FUN-9B0153

###  No.FUN-A50085 直接回傳修正後的cl_parse_qry_sql

   RETURN cl_parse_qry_sql(p_src_sql, p_plant_str)

###  No.FUN-A50085  ###

   #LET g_plant_str = NULL
 
   ###若是單一DB單一工廠的方式,則不需要做額外處理.
   ##IF FGL_GETENV("ALLINONE")='0' THEN
   ##   RETURN p_src_sql
   ##END IF
 
   ##where後面也許有select...
   ##select...from table_name...where...
 
   #IF cl_null(p_plant_str) THEN
   #   #CALL cl_err_msg(NULL, 'lib-521', NULL, 5)
   #   RETURN p_src_sql
   #END IF

   ##取得g_plant的階層關係.
   #LET p_plant_str = p_plant_str.trim()
 
   #LET l_tok = base.StringTokenizer.create(p_plant_str, ",")
   #WHILE l_tok.hasMoreTokens()
   #   LET l_plant = l_tok.nextToken()
   #   LET l_plant_p = l_plant
   #   
   #   LET l_azwa_sql = "SELECT azwa03 FROM azwa_file WHERE azwa01='",g_user CLIPPED,"' AND azwa02='",l_plant.trim(),"'"
   #   DECLARE azwa_curs CURSOR FROM l_azwa_sql
   #   LET l_i = 0
   #   FOREACH azwa_curs INTO l_azwa_rec[l_i+1].*
   #      IF STATUS THEN
   #         CALL cl_err('foreach:', STATUS, 1)
   #         EXIT PROGRAM
   #      END IF

   #      #檢查所屬的登入DB(azw06)是否相同
   #      SELECT azw05 INTO l_azw05_u FROM azw_file WHERE azw01 = g_plant    #No.FUN-9B0153
   #      SELECT azw05 INTO l_azw05_p FROM azw_file WHERE azw01 = l_plant_p    #No.FUN-9B0153
   #      IF l_azw05_u != l_azw05_p THEN                                     #No.FUN-9B0153
   #          CONTINUE FOREACH                                               #No.FUN-9B0153
   #      END IF      
   #      
   #      LET l_i = l_i + 1
   #      
   #      LET l_azwa03 = l_azwa_rec[l_i].azwa03 CLIPPED
   #      IF g_plant_str IS NULL THEN
   #         LET g_plant_str = "'",l_azwa03,"'"
   #      ELSE
   #         IF g_plant_str.getIndexOf(l_azwa03, 1)=0 THEN
   #            LET g_plant_str = g_plant_str,",'",l_azwa03,"'"
   #         END IF
   #      END IF
   #   END FOREACH
   #END WHILE
   #
   #LET p_src_sql = p_src_sql.trim()

   #IF cl_null(g_plant_str) THEN  #如果找不到plant，空白字串   #No.FUN-9B0153
   #   LET g_plant_str = "' '"
   #END IF

#  # LET l_final_sql = parse_sel(p_src_sql, 1)   #No.FUN-9B0153 mark by tommas 
   #LET l_final_sql = sql_sever(p_src_sql)    #No.FUN-9B0153 add by tommas 由sql_sever代理呼叫 parse_sel
   #RETURN l_final_sql
   
END FUNCTION 


#####################################################
# Descriptions...: 檢查plant對應的登入db是否為虛擬Schema
# Date & Author..: 2009/12/01 by tommas
# Input Parameter: p_plant  要檢查的plant,若是空值則g=_plant
# Return Code....: BOOLEAN
##################################################### 
FUNCTION cl_is_virtual_db(p_plant)
   DEFINE p_plant   STRING,
          l_azw01   LIKE azw_file.azw01,
          #Begin:TQC-BA0093
          #l_is_virtual INTEGER
          l_azw02   LIKE azw_file.azw02, #法人
          l_cnt1    SMALLINT, #同一法人營運中心的資料筆數
          l_cnt2    SMALLINT  #同一法人不同實體DB的資料筆數
          #End:TQC-BA0093
       
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant 
   END IF
   LET l_azw01 = p_plant.trim()

   #Begin:TQC-BA0093:改為只排除製造業一個Plant對應一個db的狀況即可.
   #SELECT COUNT(azw01) INTO l_is_virtual FROM azw_file #No.FUN-9B0153
   #       WHERE azw05 <> azw06
   #         AND azw01 = l_azw01

   #RETURN l_is_virtual == 1

   SELECT azw02 INTO l_azw02 FROM azw_file WHERE azw01 = l_azw01 #先取得營運中心所對應的法人
   SELECT COUNT(azw01),COUNT(DISTINCT azw05) INTO l_cnt1,l_cnt2  #再由法人取得營運中心的資料筆數(l_cnt1)與不同實體DB的資料筆數(l_cnt2)
     FROM azw_file WHERE azw02=l_azw02

   RETURN l_cnt1 <> l_cnt2 #數量不同就是Single-DB的架構
   #End:TQC-BA0093
END FUNCTION

 
##################################################
# Descriptions...: cl_create_qry,p類程式專用:增加SQL的WHERE條件
# Date & Author..: 2009/07/28 by Hiko
# Input Parameter: p_src_sql    來源SQL
#                : p_curr_plant 要處理的plant
# Return code....: l_final_sql  增加xxxplant條件後的SQL 
##################################################
FUNCTION cl_parse_qry_sql(p_src_sql, p_curr_plant)
   DEFINE p_src_sql    STRING,
          p_curr_plant STRING
   DEFINE l_lower_sql STRING,
          l_final_sql STRING,
          l_next_start_index SMALLINT
   DEFINE l_begin_index SMALLINT,
          l_end_index   SMALLINT,
          l_table_range STRING
   DEFINE l_is_view     INTEGER,
          l_azw01       LIKE azw_file.azw01
   DEFINE l_stk       base.StringTokenizer,
          l_stk_idx   INTEGER
   #Begin:FUN-A80039
   DEFINE l_left_bracket_idx INTEGER, 
          l_bracket_left_str STRING,
          l_where_idx INTEGER,
          l_set_before STRING,
          l_set_after  STRING,
          l_set_scope STRING,
          l_update_where_scope STRING,
          l_temp_update_str STRING,
          l_common_flag BOOLEAN
   #End:FUN-A80039
   
   IF cl_null(p_curr_plant) THEN 
      #CALL cl_err_msg(NULL, 'lib-521', NULL, 5)
      RETURN p_src_sql
   END IF

   IF NOT cl_is_virtual_db(p_curr_plant) THEN      #如果不是虛擬Schema,則RETURN。#No.FUN-9B0153  #No.FUN-A50085 先mark掉 #FUN-A80093:還原
      RETURN p_src_sql                                                                           #No.FUN-A50085 先mark掉 #FUN-A80093:還原
   END IF                                                                                        #No.FUN-A50085 先mark掉 #FUN-A80093:還原
   
   #update table_name set...where...
   #delete from table_name where...
   #select...from table_name...where...
   #Note:很巧,update/delete/select都是6個字元.
  
   LET g_plant_str = "'",p_curr_plant.trim(),"'"  #mark No.FUN-A50085 #FUN-A80093:還原

   #Begin:FUN-A80093:還原
### No.FUN-A50085   start add by tommas 10/05/24###
   #LET g_plant_str = ""
   #LET l_stk = base.StringTokenizer.create(p_curr_plant.trim(), ",")
   #LET l_stk_idx = 1
   #WHILE l_stk.hasMoreTokens()
   #    LET g_plant_str = g_plant_str, "'", l_stk.nextToken(), "'"
   #    IF l_stk_idx < l_stk.countTokens() THEN
   #       LET g_plant_str = g_plant_str, ","
   #    END IF
   #    LET l_stk_idx = l_stk_idx + 1
   #END WHILE 
### No.FUN-A50085   end  ###
   #End:FUN-A80093   

   LET l_lower_sql = p_src_sql.toLowerCase()
   LET l_lower_sql = l_lower_sql.trim()
 
   LET l_begin_index = l_lower_sql.getIndexOf("update", 1)
   IF l_begin_index <= 0 THEN
      LET l_begin_index = l_lower_sql.getIndexOf("delete", 1)
      IF l_begin_index <= 0 THEN
         #'select'有可能出現不只一次,因此獨立FUNCTION可以遞迴.
#         LET l_final_sql = parse_sel(p_src_sql, 1)   #No.FUN-9B0153  由sql_sever代理呼叫parse_sel
         LET l_final_sql = sql_sever(p_src_sql)
         #來源SQL是select的話,則處理完畢後就可以直接回傳了.
         #RETURN l_final_sql #FUN-A80039
      ELSE #找到的話,l_begin_index一定是1.
         #delete:第8個字開始找'from',接著再找'where'.
         LET l_begin_index = l_lower_sql.getIndexOf("from", l_begin_index+7)
         LET l_end_index = l_lower_sql.getIndexOf("where", l_begin_index+5)
         #Begin:FUN-A80039
         IF l_end_index=0 THEN #FUN-A80039
            LET l_table_range = l_lower_sql.subString(l_begin_index+5, l_lower_sql.getLength()) 
         ELSE
            #如果沒有找到l_end_index,表示原來的SQL語法就不對了,要讓他直接出錯,所以這邊就不再判斷l_end_index>0
            LET l_table_range = l_lower_sql.subString(l_begin_index+5, l_end_index-1) 
         END IF

         #繼續判斷來源sql內是否有'select'.
         CALL add_plant_in_cond(p_src_sql, l_table_range, l_end_index) RETURNING l_final_sql,l_next_start_index 
         LET l_final_sql = sql_sever(l_final_sql)
         #End:A80039  
      END IF
   ELSE #找到的話,l_begin_index一定是1. 
      #Begin:A80039
      ##update:第8個字開始找'set'.
      #LET l_end_index = l_lower_sql.getIndexOf("set", l_begin_index+7)
      ##如果沒有找到l_end_index,表示原來的SQL語法就不對了,要讓他直接出錯,所以這邊就不再判斷l_end_index>0
      #LET l_table_range = l_lower_sql.subString(l_begin_index+7, l_end_index-1) 
      #UPDATE語法有括號不代表SET設值一定有SELECT語法,有可能只是單純的括號而已.
      #範例1:UPDATE oea_file SET oea05=xxx,oea06=yyy
      #範例2:UPDATE oea_file SET oea05=(xxx),oea06=yyy==>不考慮此狀況,因為一般不會這麼無聊.
      #範例3:UPDATE oea_file SET oea05=(SELECT zx01 FROM zx_file),oea06=yyy
      #範例4:UPDATE oea_file SET oea05=(SELECT zx01 FROM zx_file WHERE zx03=zzz AND (...)), oea06=yyy
      #範例5:UPDATE oea_file SET oea05=xxx,oea06=yyy WHERE oea01=ooo AND (...)
      #範例6:UPDATE oea_file SET oea05=(xxx),oea06=yyy WHERE oea01=ooo AND (...)==>不考慮此狀況,因為一般不會這麼無聊.
      #範例7:UPDATE oea_file SET oea05=(SELECT zx01 FROM zx_file),oea06=yyy WHERE oea01=ooo AND (...)
      #範例8:UPDATE oea_file SET oea05=(SELECT zx01 FROM zx_file WHERE zx03=zzz AND (...)), oea06=yyy WHERE oea01=ooo AND (...)
      #以上範例只有3,4,7,8的狀況需要不同的處理.

      LET l_left_bracket_idx = l_lower_sql.getIndexOf("(", 1)
      LET l_where_idx = l_lower_sql.getIndexOf("where", 1)
      IF l_left_bracket_idx>0 THEN
         IF l_where_idx>0 THEN 
            IF l_where_idx<l_left_bracket_idx THEN #第一個左括號前面有WHERE,表示這是真正的UPDATE WHERE條件內的左括號.
               #範例5:UPDATE oea_file SET oea05=xxx,oea06=yyy WHERE oea01=ooo AND (...)
               LET l_common_flag = TRUE
            ELSE #第一個左括號在WHERE前面,表示SET區塊有SELECT語法.
               #範例4:UPDATE oea_file SET oea05=(SELECT zx01 FROM zx_file WHERE zx03=zzz AND (...)), oea06=yyy
               #範例7:UPDATE oea_file SET oea05=(SELECT zx01 FROM zx_file),oea06=yyy WHERE oea01=ooo AND (...)
               #範例8:UPDATE oea_file SET oea05=(SELECT zx01 FROM zx_file WHERE zx03=zzz AND (...)), oea06=yyy WHERE oea01=ooo AND (...)
               LET l_common_flag = FALSE
            END IF
         ELSE #有左括號但沒有WHERE條件,就表示SET區塊用SELECT設值.
            #範例3:UPDATE oea_file SET oea05=(SELECT zx01 FROM zx_file),oea06=yyy
            LET l_common_flag = FALSE
         END IF
      ELSE #沒有左括號,就延用原本的做法.
         LET l_common_flag = TRUE
      END IF

      IF l_common_flag THEN
         #update:第8個字開始找'set'.
         LET l_end_index = l_lower_sql.getIndexOf("set", l_begin_index+7)
         #如果沒有找到l_end_index,表示原來的SQL語法就不對了,要讓他直接出錯,所以這邊就不再判斷l_end_index>0
         LET l_table_range = l_lower_sql.subString(l_begin_index+7, l_end_index-1)
         #繼續判斷來源sql內是否有'select'.
         CALL add_plant_in_cond(p_src_sql, l_table_range, l_end_index) RETURNING l_final_sql,l_next_start_index
         LET l_final_sql = sql_sever(l_final_sql)  
      ELSE
         #update:第8個字開始找'set'.
         LET l_end_index = l_lower_sql.getIndexOf("set", l_begin_index+7)
         #如果沒有找到l_end_index,表示原來的SQL語法就不對了,要讓他直接出錯,所以這邊就不再判斷l_end_index>0
         #2-1.先將SET之前的字串找出來.
         LET l_set_before = p_src_sql.subString(1, l_end_index-1) #SET之前的字串
         #2-2.再找整個SET設定值的範圍:左右括號一定對稱,所以SET的設值範圍一定是在第一個左括號所對應的最後一個右括號的範圍內.
         LET l_set_after = p_src_sql.subString(l_end_index, p_src_sql.getLength())
         #2-3.取得SET的設值範圍(從SET開始),以及UPDATE語法的WHERE條件範圍
         CALL priv_find_set_scope(l_set_after, 1) RETURNING l_set_scope,l_update_where_scope
         #2-4.先將SET範圍的SQL字段解析.
         LET l_set_scope = sql_sever(l_set_scope)
         #2-5.將l_set_before+l_update_where_scope一起解析.
         LET l_table_range = l_set_before.subString(l_begin_index+7, l_set_before.getLength())
         LET l_table_range = l_table_range.toLowerCase()
         LET l_temp_update_str = l_set_before," ",l_update_where_scope
         #繼續判斷來源sql內是否有'select'.
         CALL add_plant_in_cond(l_temp_update_str, l_table_range, 1) RETURNING l_temp_update_str,l_next_start_index 
         LET l_temp_update_str = sql_sever(l_temp_update_str)
         #2-6.取得解析後的l_update_where_scope.
         LET l_update_where_scope = l_temp_update_str.subString(l_end_index, l_temp_update_str.getLength())  
         #2-7.將l_set_before+l_set_scope+l_update_where_scope合併即可.
         LET l_final_sql = l_set_before," ",l_set_scope," ",l_update_where_scope
      END IF
      #End:A80039
   END IF
 
   #Begin:A80039
   #CALL add_plant_in_cond(p_src_sql, l_table_range, l_end_index) RETURNING l_final_sql,l_next_start_index
   ##繼續判斷來源sql內是否有'select'.
   ##LET l_final_sql = parse_sel(l_final_sql, l_next_start_index) #No.FUN-9B0153 由sql_sever代理呼叫parse_sel
   #LET l_final_sql = sql_sever(l_final_sql)
   #End:A80039

   RETURN l_final_sql
END FUNCTION
 
##################################################
# Descriptions...: 找到SET設值區塊與屬於UPDATE語法的WHERE區塊
# Date & Author..: 2010/08/05 by Hiko
# Input Parameter: p_src          來源字串
#                : p_start_index  開始找字串的起始位置
# Return code....: l_set_scope    SET設值區塊
#                : l_update_where_scope 屬於UPDATE語法的WHERE區塊
##################################################
PRIVATE FUNCTION priv_find_set_scope(p_src, p_start_idx)
   DEFINE p_src STRING,
          p_start_idx INTEGER
   DEFINE l_lower_src STRING
   DEFINE l_set_scope STRING,
          l_update_where_scope STRING
   DEFINE l_idx INTEGER,
          l_char CHAR,
          l_last_right_bracket_idx INTEGER,
          l_left_bracket_cnt SMALLINT,
          l_rigth_bracket_cnt SMALLINT,
          l_left_bracket_idx INTEGER,
          l_where_idx INTEGER

   #要取得真正的SET設值範圍,最後一定是右括號的個數會等於左括號.
   FOR l_idx=p_start_idx TO p_src.getLength()
      LET l_char = p_src.getCharAt(l_idx)
      IF l_char='(' THEN
         LET l_left_bracket_cnt = l_left_bracket_cnt + 1
      ELSE 
         IF l_char=')' THEN
            LET l_rigth_bracket_cnt = l_rigth_bracket_cnt + 1
            IF l_rigth_bracket_cnt=l_left_bracket_cnt THEN #找到右括號之前一定會有左括號:只要兩者的數量相同,就表示已經完成某個SET區塊的設值,要繼續判斷是否還有其他SET的設值區塊.
               LET l_last_right_bracket_idx = l_idx
               EXIT FOR
            END IF
         END IF
      END IF
   END FOR

   LET l_lower_src = p_src.toLowerCase()
   #繼續判斷是否SET設值區塊還有其他的SELECT語法.
   IF l_last_right_bracket_idx<p_src.getLength() THEN
      LET l_left_bracket_idx = p_src.getIndexOf("(", l_last_right_bracket_idx+1)
      LET l_where_idx = l_lower_src.getIndexOf("where", l_last_right_bracket_idx+1)
      IF l_left_bracket_idx>0 THEN #有左括號.
         IF l_where_idx>0 THEN #有WHERE條件.
            IF l_where_idx<l_left_bracket_idx THEN #左括號前面有WHERE,表示這是真正的UPDATE WHERE條件內的左括號.
               #範例7:UPDATE oea_file SET oea05=(SELECT zx01 FROM zx_file),oea06=yyy WHERE oea01=ooo AND (...)
               #範例8:UPDATE oea_file SET oea05=(SELECT zx01 FROM zx_file WHERE zx03=zzz AND (...)), oea06=yyy WHERE oea01=ooo AND (...)
               LET l_set_scope = p_src.subString(1, l_where_idx-1)
               LET l_update_where_scope = p_src.subString(l_where_idx, p_src.getLength())
            ELSE #表示還有其他的SET區塊包含SELECT語法.
               #範例3進階型:UPDATE oea_file SET oea05=(SELECT zx01 FROM zx_file),oea06=(SELECT zx01 FROM zx_file WHERE zx01='tiptop')
               #範例4進階型:UPDATE oea_file SET oea05=(SELECT zx01 FROM zx_file WHERE zx03=zzz AND (...)),oea06=(SELECT zx01 FROM zx_file WHERE zx01='tiptop')
               #還要繼續遞迴判斷.
               CALL priv_find_set_scope(p_src, l_last_right_bracket_idx+1) RETURNING l_set_scope,l_update_where_scope
            END IF
         ELSE #沒有WHERE條件.
            #範例3進階型:UPDATE oea_file SET oea05=(SELECT zx01 FROM zx_file),oea06=(SELECT zx01 FROM zx_file)
            #範例4進階型:UPDATE oea_file SET oea05=(SELECT zx01 FROM zx_file WHERE zx03=zzz AND (...)),oea06=(SELECT zx01 FROM zx_file)
            #還要繼續遞迴判斷.
            CALL priv_find_set_scope(p_src, l_last_right_bracket_idx+1) RETURNING l_set_scope,l_update_where_scope
         END IF
      ELSE #沒有左括號.
         IF l_where_idx>0 THEN #有WHERE條件.
            #範例7簡單型:UPDATE oea_file SET oea05=(SELECT zx01 FROM zx_file),oea06=yyy WHERE oea01=ooo AND ...
            #範例8簡單型:UPDATE oea_file SET oea05=(SELECT zx01 FROM zx_file WHERE zx03=zzz AND (...)), oea06=yyy WHERE oea01=ooo AND ...
            LET l_set_scope = p_src.subString(1, l_where_idx-1)
            LET l_update_where_scope = p_src.subString(l_where_idx, p_src.getLength())
         ELSE #沒有WHERE條件.
            #範例3:UPDATE oea_file SET oea05=(SELECT zx01 FROM zx_file),oea06=yyy
            #範例4:UPDATE oea_file SET oea05=(SELECT zx01 FROM zx_file WHERE zx03=zzz AND (...)), oea06=yyy
            LET l_set_scope = p_src.subString(1, p_src.getLength())
            LET l_update_where_scope = ""
         END IF
      END IF
   ELSE #表示UPDATE是沒有WHERE條件.
      #範例3簡單型:UPDATE oea_file SET oea05=(SELECT zx01 FROM zx_file)
      LET l_set_scope = p_src.subString(1, l_last_right_bracket_idx)
      LET l_update_where_scope = ""
   END IF

   RETURN l_set_scope,l_update_where_scope
END FUNCTION

##################################################
# Descriptions...: 增加xxxplant條件
# Date & Author..: 2009/06/19 by Hiko
# Input Parameter: p_src_sql          來源SQL
#                : p_table_range      包含xxx_file的字串範圍
#                : p_find_index       開始找'where'字串的起始位置
# Return code....: l_final_sql        增加xxxplant條件後的SQL
#                : l_next_start_index 下次開始尋找'_file'的起始位置
##################################################
PRIVATE FUNCTION add_plant_in_cond(p_src_sql, p_table_range, p_find_index)
   DEFINE p_src_sql          STRING,
          p_table_range      STRING,
          p_find_index       SMALLINT
   DEFINE l_lower_sql        STRING,
          l_before_where     STRING,
          l_after_where      STRING,
          l_next_start_index SMALLINT
   DEFINE l_begin_index      SMALLINT,
          l_end_index        SMALLINT,
          l_tmp_char         STRING,
          l_table_prefix     STRING,
          l_table            STRING
   DEFINE l_table_array DYNAMIC ARRAY OF RECORD
                        name  STRING,
                        plant STRING
                        END RECORD
   DEFINE l_arr_length       SMALLINT,
          l_i                SMALLINT,
          l_exist_flag       BOOLEAN
   DEFINE l_where_index      SMALLINT,
          l_plant_condition  STRING
   DEFINE l_join_idx SMALLINT #FUN-AB0108
 
   #Begin:FUN-AB0108
   LET l_join_idx = p_table_range.getIndexOf("join", 1)
   IF l_join_idx>0 THEN
      LET p_table_range = p_table_range.subString(1, l_join_idx-1)
   END IF
   #End:FUN-AB0108

   LET l_begin_index = 1
 
   WHILE TRUE
      LET l_end_index = p_table_range.getIndexOf("_file", l_begin_index)
      IF l_end_index >0 THEN
         LET l_begin_index = l_end_index - 1 #往前找table的區隔符號.
         #因為是由後面往前找,所以目前(IFX,ORA,MSV)至少是不會有問題.
         WHILE TRUE
            LET l_tmp_char = p_table_range.getCharAt(l_begin_index)
            IF l_tmp_char.equals(' ') OR
               l_tmp_char.equals(',') OR
               l_tmp_char.equals('.') OR  #ORA,MSV
               l_tmp_char.equals(':')THEN #IFX
               LET l_begin_index = l_begin_index + 1 #要減1才是真正的table起始位置.
               EXIT WHILE
            ELSE
               IF l_begin_index = 1 THEN #因為一開始已經trim掉空白,因此這表示table是在一開始就有了.
                  EXIT WHILE
               END IF
            END IF
 
            LET l_begin_index = l_begin_index - 1 #繼續往前找table的區隔符號.
         END WHILE
 
         LET l_table_prefix = p_table_range.subString(l_begin_index, l_end_index-1)
         LET l_table = l_table_prefix,"_file"
         IF cl_table_exist_plant(l_table) THEN #此table有xxxplant
            LET l_exist_flag = FALSE
            LET l_arr_length = l_table_array.getLength()
            FOR l_i=1 TO l_arr_length
               #判斷此table是否之前已經找過了.
               IF l_table.equals(l_table_array[l_i].name) THEN
                  LET l_exist_flag = TRUE
                  EXIT FOR
               END IF
            END FOR
 
            IF NOT l_exist_flag THEN
               LET l_table_array[l_arr_length+1].name = l_table
               LET l_table_array[l_arr_length+1].plant = l_table_prefix,"plant"
            END IF
         END IF
      ELSE #找不到'_file'了.
         EXIT WHILE
      END IF
     
      LET l_begin_index = l_end_index + 5 #繼續找下一個table
   END WHILE
 
   LET l_arr_length = l_table_array.getLength()
   IF l_arr_length > 0 THEN
      FOR l_i=1 TO l_arr_length
         IF l_plant_condition.getLength() > 0 THEN
            LET l_plant_condition = l_plant_condition," AND"
         END IF
 
         #LET l_plant_condition = l_plant_condition," ",l_table_array[l_i].name,".",l_table_array[l_i].plant," IN (",g_plant_str,") "
         #LET l_plant_condition = l_plant_condition," ",l_table_array[l_i].name,".",l_table_array[l_i].plant," = ",g_plant_str #FUN-A80093:'IN'改為'='
         LET l_plant_condition = l_plant_condition," ",l_table_array[l_i].plant," = ",g_plant_str #FUN-AB0070:移除Table name #FUN-A80093:'IN'改為'='
      END FOR
 
      LET l_lower_sql = p_src_sql.toLowerCase()
      LET l_where_index = l_lower_sql.getIndexOf('where', p_find_index)

      #沒有Where的情況:
      #1.table後面甚麼都沒有
      #2.table後面加上group by(有可能會搭配having)
      #3.table後面加上order by(一定放最後)
      IF l_where_index = 0 THEN 
         LET l_where_index = l_lower_sql.getIndexOf('group by', p_find_index)
         IF l_where_index = 0 THEN
            LET l_where_index = l_lower_sql.getIndexOf('order by', p_find_index)
            IF l_where_index = 0 THEN
               LET p_src_sql = p_src_sql," WHERE ",l_plant_condition
               LET p_find_index = 0
            ELSE
               #取得'order by'前面的字串.
               LET l_before_where = p_src_sql.subString(1, l_where_index-1)
               #取得'order by'後面的字串.
               LET l_after_where = p_src_sql.subString(l_where_index, p_src_sql.getLength())
               #組合3段字串.
               LET p_src_sql = l_before_where," WHERE ",l_plant_condition,l_after_where
               LET p_find_index = 0
            END IF
         ELSE
            #取得'group by'前面的字串.
            LET l_before_where = p_src_sql.subString(1, l_where_index-1)
            #取得'group by'後面的字串.
            LET l_after_where = p_src_sql.subString(l_where_index, p_src_sql.getLength())
            #組合3段字串.
            LET p_src_sql = l_before_where," WHERE ",l_plant_condition,l_after_where
            LET p_find_index = 0
         END IF
      ELSE
         #取得'where'前面的字串.
         LET l_before_where = p_src_sql.subString(1, l_where_index+5)
         #取得'where'後面的字串.
         LET l_after_where = p_src_sql.subString(l_where_index+5+1, p_src_sql.getLength())
         #組合3段字串.
         LET p_src_sql = l_before_where,l_plant_condition," AND ",l_after_where
         #第一個5是'where'的5個字元;第二個5是' AND '的5個字元.
         LET p_find_index = l_where_index+5+l_plant_condition.getLength()+5
      END IF
   END IF
 
   #第一個5是'where'的5個字元;第二個5是' AND '的5個字元.
   RETURN p_src_sql,p_find_index
END FUNCTION
 
##################################################
# Descriptions...: 解析select語法
# Date & Author..: 2009/06/19 by Hiko
# Input Parameter: p_src_sql     來源SQL
#                : p_start_index 起始索引值
# Return code....: l_final_sql 增加xxxplant條件後的SQL
##################################################
PRIVATE FUNCTION parse_sel(p_src_sql, p_start_index)
   DEFINE p_src_sql          STRING,
          p_start_index      SMALLINT
   DEFINE l_lower_sql        STRING,
          l_final_sql        STRING
   DEFINE l_begin_index      SMALLINT,
          l_end_index        SMALLINT,
          l_table_range      STRING,
          l_next_start_index SMALLINT   
 
   IF p_start_index=0 THEN
      RETURN p_src_sql
   END IF

   LET l_lower_sql = p_src_sql.toLowerCase()
 
   LET l_begin_index = l_lower_sql.getIndexOf("select", p_start_index)
   IF l_begin_index > 0 THEN
      #第8個字開始找'from',接著再找'where'.
      LET l_begin_index = l_lower_sql.getIndexOf("from", l_begin_index+7)
      LET l_end_index = l_lower_sql.getIndexOf("where", l_begin_index+5)
      IF l_end_index=0 THEN
         #找不到where的SQL:
         #select * from oea_file
         #select * from oea_file group by xxx
         #select * from oea_file group by xxx having xxx
         #select * from oea_file group by xxx having xxx order by xxx
         #select * from oea_file group by xxx order by xxx
         #select * from oea_file order by xxx
         LET l_end_index = l_lower_sql.getIndexOf("group by", l_begin_index+5) 
         IF l_end_index=0 THEN
            LET l_end_index = l_lower_sql.getIndexOf("order by", l_begin_index+5)
            IF l_end_index=0 THEN
               LET l_end_index = l_lower_sql.getLength()
            END IF
         END IF
      END IF
      #如果沒有找到l_end_index,表示原來的SQL語法就不對了,要讓他直接出錯,所以這邊就不再判斷l_end_index>0
      IF l_end_index = l_lower_sql.getLength() THEN
         LET l_table_range = l_lower_sql.subString(l_begin_index+5, l_end_index) 
      ELSE
         LET l_table_range = l_lower_sql.subString(l_begin_index+5, l_end_index-1) 
      END IF
      CALL add_plant_in_cond(p_src_sql, l_table_range, l_end_index) RETURNING l_final_sql,l_next_start_index
      #繼續判斷來源sql內是否有'select'.
      LET l_final_sql = parse_sel(l_final_sql, l_next_start_index)
   ELSE
      LET l_final_sql = p_src_sql
   END IF
 
   RETURN l_final_sql
END FUNCTION

#############################################
# Descriptions...: 將l_src_sql分段後經由parse_sel處理，並重組
# Date & Author..: 2009/12/16 by tommas
# Input Parameter: l_src_sql STRING 來源字串
# Return Code....: 分段並經過cl_parse_sel後重組的sql
# Modify.........: 
#############################################
FUNCTION sql_sever(l_src_sql)
    DEFINE l_src_sql    STRING
    DEFINE l_sql        STRING
    DEFINE l_idx        INTEGER
    DEFINE l_proc_sql   STRING
    DEFINE l_str        STRING

    CALL p_sql_map.clear()  #清空
    LET l_sql = parse_sever_l(l_src_sql)             #重組SQL並產生分段後的結果(p_sql_map)
    LET l_sql = parse_sel(l_sql, 1)                   #先將重組後的SQL做parse_sel

    FOR l_idx = 1 TO p_sql_map.getLength()            #將分段後的SQL做parse_sel
        LET l_str = p_sql_map[l_idx].p_value
        #開始將每個片斷SQL丟入parse_sel
        #先檢查分段是否有SELECT字串
        LET l_str = parse_sel(l_str, 1)
        LET p_sql_map[l_idx].p_value = l_str
    END FOR

    #開始還原作業

    FOR l_idx = p_sql_map.getLength() TO 1 STEP -1     #將重組後的SQL與分段的SQL還原
        LET l_str = "(",p_sql_map[l_idx].p_value,")"
        CALL cl_replace_str(l_sql, p_sql_map[l_idx].p_key, l_str) RETURNING l_str
        LET l_sql = l_str
    END FOR
    RETURN l_sql
END FUNCTION

#############################################
# Private Func...: TRUE
# Descriptions...: 將l_src_sql從第一字元開始過濾
# Date & Author..: 2009/12/16 by tommas
# Input Parameter: l_src_sql STRING 來源字串
# Return Code....: 回傳的SQL片段
# Modify.........: 
#############################################
PRIVATE FUNCTION parse_sever_l(l_src_sql)
   DEFINE l_src_sql    STRING   #來源SQL
   DEFINE l_sql_idx    INTEGER  #目前處理的第N個字元
   DEFINE l_sql_length INTEGER  #來源SQL字串長度
   DEFINE l_reb_sql    STRING   #暫存的變數
   DEFINE l_char       CHAR     #第N個字元
   DEFINE l_clip_sql   STRING   #回傳的SQL片段
   DEFINE l_idx        INTEGER  #FUN-B20063  l_src_sql每次被分段後開始要截取字元的位置(一開始當然=l_sql_idx, 分段後就會=RETURNING l_sql_idx
   DEFINE l_substr     STRING   #FUN-B20063  l_src_sql每次被分段前後所要截取的字串(是組合l_reb_sql的暫存字串)

   LET l_sql_idx = 1
   LET l_idx = l_sql_idx   #FUN-B20063
   LET l_sql_length = l_src_sql.getLength()

   WHILE l_sql_idx <= l_sql_length
      LET l_char = l_src_sql.getCharAt(l_sql_idx)  #從第一個字元開始

      IF l_char = "(" THEN    #遇到左括號，就開始分段
         CALL parse_sever_r(l_src_sql, l_sql_idx) RETURNING l_clip_sql, l_sql_idx
         LET l_reb_sql = l_reb_sql, l_substr   #FUN-B20063
         LET l_substr = ""                     #FUN-B20063
         LET l_reb_sql = l_reb_sql, l_clip_sql
         LET l_idx = l_sql_idx + 1             #FUN-B20063
      ELSE
          #LET l_reb_sql = l_reb_sql, l_char                    #FUN-B20063 mark
          LET l_substr = l_src_sql.subString(l_idx, l_sql_idx)  #FUN-B20063
      END IF
      
      #---FUN-B20063---start------
      IF (l_sql_idx = l_sql_length) THEN
         LET l_reb_sql = l_reb_sql, l_substr
      END IF
      #---FUN-B20063---end--------

      LET l_sql_idx = l_sql_idx + 1
   END WHILE

   RETURN l_reb_sql
END FUNCTION

#############################################
# Private Func...: TRUE
# Descriptions...: 將l_src_sql依照括號分段並放入p_sql_map中
# Date & Author..: 2009/12/16 by tommas
# Input Parameter: l_src_sql STRING 來源字串
# Return Code....: 回傳的SQL片段
# Modify.........: 
#############################################
PRIVATE FUNCTION parse_sever_r(l_src_sql, l_sql_idx)
   DEFINE l_src_sql          STRING
   DEFINE l_sql_idx      INTEGER
   DEFINE l_sql_length   INTEGER
   DEFINE l_clip_sql     STRING
   DEFINE l_reb_sql      STRING
   DEFINE l_char         CHAR
   DEFINE l_map_length   INTEGER
   DEFINE l_str          STRING
   DEFINE l_idx          INTEGER     #FUN-B20063  l_src_sql每次被分段後開始要截取字元的位置(一開始當然=l_sql_idx, 分段後就會=RETURNING l_sql_idx
   DEFINE l_idx_start    INTEGER     #FUN-B20063  p_sql_map從左括號開始要截取字元的位置
   DEFINE l_idx_end      INTEGER     #FUN-B20063  p_sql_map到右括號開始要截取結束字元的位置
   DEFINE l_substr       STRING      #FUN-B20063  l_src_sql每次被分段前後所要截取的字串(是組合l_reb_sql的暫存字串)

   LET l_sql_length = l_src_sql.getLength()
   LET l_idx = l_sql_idx + 1         #FUN-B20063
   LET l_idx_start = l_sql_idx + 1   #FUN-B20063
   LET l_idx_end = 0                 #FUN-B20063
   WHILE l_sql_idx <= l_sql_length
      LET l_sql_idx = l_sql_idx + 1
      LET l_char = l_src_sql.getCharAt(l_sql_idx)
      
      #---FUN-B20063---start------
      IF (l_sql_idx = l_sql_length) THEN
      	 LET l_substr = l_src_sql.subString(l_idx, l_sql_idx)
         LET l_reb_sql = l_reb_sql, l_substr
      END IF
      #---FUN-B20063---end-------
          
      IF l_char = ")" THEN
          LET l_str  = l_sql_idx
          LET l_idx_end = l_sql_idx - 1        #FUN-B20063
          LET l_str = ":{", l_str.trim(),"}"
          CALL p_sql_map.appendElement()
          LET l_map_length = p_sql_map.getLength()
          LET p_sql_map[l_map_length].p_key = l_str
          #LET p_sql_map[l_map_length].p_value = l_reb_sql   #FUN-B20063  mark
          LET p_sql_map[l_map_length].p_value = l_src_sql.subString(l_idx_start, l_idx_end)   #FUN-B20063
          RETURN l_str, l_sql_idx
      END IF
      IF l_char = "(" THEN     
          CALL parse_sever_r(l_src_sql, l_sql_idx) RETURNING l_clip_sql , l_sql_idx
          LET l_reb_sql = l_reb_sql, l_substr     #FUN-B20063
          LET l_substr = ""                       #FUN-B20063
          LET l_reb_sql = l_reb_sql, l_clip_sql
          LET l_idx = l_sql_idx + 1               #FUN-B20063
      ELSE
          #LET l_reb_sql = l_reb_sql, l_char                    #FUN-B20063  mark
          LET l_substr = l_src_sql.subString(l_idx, l_sql_idx)  #FUN-B20063
      END IF
   END WHILE
END FUNCTION
