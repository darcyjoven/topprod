# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Program name...: s_for_azwa.4gl
# Descriptions...: 將所有關於異動azwa_file的FUNCTION都放在同一個sub內.
# Date & Author..: 2009/08/05 by Hiko
# Usage..........: CALL s_ins_auth_plant(g_user)                #FOR p_zxy,p_zx
#                : CALL s_del_all_user_plant('DSV1-2')          #FOR aooi931,aooi932
#                : CALL s_move_all_user_plant('DSV2-2', 'DSV1') #FOR aooi932
# Modify.........: No.FUN-980030 09/08/04 By Hiko 新建程式
# Modify.........: No:TQC-9A0163 2009/11/26 By tommas
# Modify.........: No.FUN-A20007 2010/02/02 By tommas 新增azwa_file時，檢查azw01 <> azw07及環狀

DATABASE ds
 
#FUN-980030
 
GLOBALS "../../config/top.global"
 
##################################################
# Descriptions...: 將符合權限的Plant新增到View所讀取的Table內:FOR p_zxy,p_zx
# Date & Author..: 2009/07/24 by Hiko
# Input Parameter: p_user 使用者
# Return code....: void
##################################################
FUNCTION s_ins_auth_plant(p_user)
   DEFINE p_user LIKE zxy_file.zxy01
   DEFINE l_azwa_del_sql STRING
   DEFINE l_zxy_sql STRING,
          l_index   SMALLINT,
          l_zxy_arr DYNAMIC ARRAY OF RECORD
                    zxy03 LIKE zxy_file.zxy03
                    END RECORD,
          l_i       SMALLINT
          
   #先將使用者原本存在p_curr_plant的資料刪除.
   LET l_azwa_del_sql = "DELETE FROM azwa_file WHERE azwa01='",p_user CLIPPED,"'"
   PREPARE del_prep FROM l_azwa_del_sql
   EXECUTE del_prep
   FREE del_prep
 
   #找到使用者所設定Plant
   LET l_zxy_sql = "SELECT zxy03 FROM zxy_file",
                   " WHERE zxy01='",p_user CLIPPED,"'",
                   " ORDER BY zxy03"
   DECLARE zxy03_curs CURSOR FROM l_zxy_sql
 
   LET l_index = 0
   FOREACH zxy03_curs INTO l_zxy_arr[l_index+1].*
      IF STATUS THEN
         CALL cl_err('foreach:', STATUS, 1)
         EXIT PROGRAM
      END IF
   
      LET l_index = l_index + 1
   END FOREACH
 
   FOR l_i=1 TO l_index
      #先將自己新增到azwa_file內.
      INSERT INTO azwa_file VALUES (p_user,l_zxy_arr[l_i].zxy03,l_zxy_arr[l_i].zxy03)
      #再新增p_curr_plant的下階Plant.
      IF chk_plant_tree(l_zxy_arr[l_i].zxy03) THEN
         CALL ins_curr_plant_tree(p_user, l_zxy_arr[l_i].zxy03)
      END IF
   END FOR
END FUNCTION


##################################################
# Descriptions...: 檢查p_curr_plant與其所有下層，是否形成循環等錯誤。
# Date & Author..: 2010/02/03 by tommas
# Input Parameter: p_curr_plant 要檢查的Plant
# Return code....: TRUE 正常。(不會返回FALSE，因有錯誤會彈出警告後離開程式。)
##################################################
FUNCTION chk_plant_tree(p_curr_plant)      #No.FUN-A20007 add by tommas
   DEFINE p_curr_plant,plant LIKE zxy_file.zxy03
   DEFINE l_err,idx     INTEGER
   DEFINE tmp_r  DYNAMIC ARRAY OF RECORD
            azw01 LIKE azw_file.azw01
          END RECORD
   DEFINE l_arr DYNAMIC ARRAY OF RECORD
           azw01  LIKE azw_file.azw01
                 END RECORD

   SELECT COUNT(azw01) INTO l_err FROM azw_file
                       WHERE azw01 = p_curr_plant
                         AND azw07 = p_curr_plant

   PREPARE chk_pre1 FROM "SELECT azw01 FROM azw_file WHERE azw07=?"  #檢查上層不能是自己本身
   DECLARE chk_dec CURSOR FOR chk_pre1
   IF l_err > 0 THEN
      CALL cl_err_msg("ERROR!","sub-530",p_curr_plant,1)
      EXIT PROGRAM
   END IF

   CALL l_arr.appendElement()
   LET l_arr[l_arr.getLength()].azw01 = p_curr_plant

   WHILE l_arr.getLength() > 0       #為了避免資料量大時使用遞迴過度使用效能，才使用stack取代遞迴。
      LET plant = l_arr[1].azw01     #模擬stack的pop
      CALL l_arr.deleteElement(1)    #pop資料後就不存在stack中。
      OPEN chk_dec USING plant
      LET idx = 0
      CALL tmp_r.clear()             #清空暫存的變數
      FOREACH chk_dec INTO tmp_r[idx+1].*
         CALL l_arr.appendElement()                              #模擬stack的push，將找出來的子階層，全部push
         LET l_arr[l_arr.getLength()].azw01 = tmp_r[idx+1].azw01 
         IF p_curr_plant = tmp_r[idx+1].azw01 THEN               #往下找時，如果又遇到自己，表示形成環狀。
             CALL cl_err_msg("ERROR!","sub-531",p_curr_plant,1)
             FREE chk_dec
             EXIT PROGRAM
         END IF
      END FOREACH
   END WHILE
   FREE chk_dec
   RETURN l_err = 0
END FUNCTION
 
##################################################
# Descriptions...: 新增下階Plant. 
# Date & Author..: 2009/07/22 by Hiko
# Input Parameter: p_user       使用者
#                : p_curr_plant 要新增的Plant
# Return code....: void
##################################################
FUNCTION ins_curr_plant_tree(p_user, p_curr_plant)
   DEFINE p_user       LIKE zxy_file.zxy01,
          p_curr_plant LIKE zxy_file.zxy03
   DEFINE l_azw_sql,l_err_sql  STRING,
          l_index    SMALLINT
   DEFINE l_azw_arr DYNAMIC ARRAY OF RECORD
                    azw01 LIKE azw_file.azw01
                    END RECORD,
          l_i        SMALLINT,
          l_plant    LIKE azwa_file.azwa03
   DEFINE l_azwa_sql  STRING,
          l_azwa_cnt  SMALLINT

   #一開始先找出p_curr_plant在azw_file的向下階層關係.
   LET l_azw_sql = "SELECT azw01 FROM azw_file",
                   " WHERE azw07='",p_curr_plant CLIPPED,"'",
                   " ORDER BY azw01"
   DECLARE azw_curs CURSOR FROM l_azw_sql
   
   LET l_index = 0
 
   FOREACH azw_curs INTO l_azw_arr[l_index+1].*
      IF STATUS THEN
         CALL cl_err('foreach:', STATUS, 1)
         EXIT PROGRAM
      END IF
   
      LET l_index = l_index + 1
   END FOREACH
 
   FOR l_i=1 TO l_index
      LET l_plant = l_azw_arr[l_i].azw01
      
      #有權限時,才可以加上plant
      IF cl_user_has_plant_auth(p_user, l_plant) THEN
         #azwa_file沒有資料才可以新增,這可以避免key值重複.
         IF NOT user_has_azwa_data(p_user, p_curr_plant, l_plant) THEN         
            INSERT INTO azwa_file VALUES (p_user,p_curr_plant,l_plant)
         END IF
      END IF
 
      CALL ins_curr_plant_tree(p_user, l_plant)
   END FOR
END FUNCTION

##########################################################################
# Descriptions...: 判斷使用者在azwa_file內是否有Plant資料
# Input parameter: p_user        使用者 
#                : p_login_plant 登入Plant
#                : p_plant       Plant資料
# Return code....: l_result TRUE/FALSE
# Date & Author..: 2009/08/05 by Hiko
##########################################################################
FUNCTION user_has_azwa_data(p_user, p_login_plant, p_plant)
   DEFINE p_user        LIKE azwa_file.azwa01,
          p_login_plant LIKE azwa_file.azwa02,
          p_plant       LIKE azwa_file.azwa03
   DEFINE l_azwa_sql STRING,
          l_azwa_cnt SMALLINT,
          l_result  BOOLEAN
   
   LET l_result = FALSE

   LET l_azwa_sql = "SELECT COUNT(*) FROM azwa_file",
                    " WHERE azwa01='",p_user CLIPPED,"' AND azwa02='",p_login_plant CLIPPED,"' AND azwa03='",p_plant CLIPPED,"'"
   DECLARE azwa_curs SCROLL CURSOR FROM l_azwa_sql
   OPEN azwa_curs
   FETCH FIRST azwa_curs INTO l_azwa_cnt
   CLOSE azwa_curs
   
   IF l_azwa_cnt > 0 THEN #判斷是否存在資料.
      LET l_result = TRUE
   END IF
      
   RETURN l_result
END FUNCTION

##################################################
# Descriptions...: 移除Plant時,要同步移除節點與上層的關聯
# Date & Author..: 2009/11/19 by hsien  #No:TQC-9A0163
# Input Parameter: p_curr_plant 要移除的Plant
# Return code....: void
##################################################
FUNCTION s_del_all_user_plant(p_curr_plant)
   DEFINE p_curr_plant LIKE zxy_file.zxy03
   DEFINE l_plant_str  STRING
   DEFINE l_azwa_del_sql STRING

   LET l_plant_str = get_plant_cond(p_curr_plant, NULL)
   LET l_azwa_del_sql = "DELETE FROM azwa_file WHERE azwa03 IN (" ,l_plant_str, ") AND azwa02 NOT IN (",l_plant_str,")"  #要移除的節點底下節點關係不變
   PREPARE del_prep1 FROM l_azwa_del_sql 
   EXECUTE del_prep1
   FREE del_prep1
END FUNCTION

##################################################
# Descriptions...: 移動Plant時,要同步移動所有使用者的azwa_file資料:FOR aooi932
# Date & Author..: 2009/07/23 by Hiko
# Input Parameter: p_curr_plant  要移動的Plant
#                : p_upper_plant 要移動到那個Plant底下
# Return code....: void
##################################################
FUNCTION s_move_all_user_plant(p_curr_plant, p_upper_plant)
   DEFINE p_curr_plant  LIKE zxy_file.zxy03,
          p_upper_plant LIKE zxy_file.zxy03
   DEFINE l_plant_str  STRING
   DEFINE l_azwa_del_sql STRING
   DEFINE l_plant_tok base.StringTokenizer,
          l_tmp_plant STRING,
          l_plant     STRING,
          l_plant_arr DYNAMIC ARRAY OF RECORD
                      plant LIKE azwa_file.azwa03
                      END RECORD,
          l_j         SMALLINT
   DEFINE l_azwa_sql STRING,
          l_azwa_arr DYNAMIC ARRAY OF RECORD LIKE azwa_file.*,
          l_index    SMALLINT,
          l_i        SMALLINT
   DEFINE l_zxy_sql  STRING,
          l_zxy_cnt  SMALLINT
   DEFINE l_cnt SMALLINT
 
   #azwa02屬於p_curr_plant的整顆Tree的資料不能刪除,其他azwa03有p_curr_plant的整顆Tree的資料都得刪除.
   LET l_plant_str = get_plant_cond(p_curr_plant, NULL)
   #此段刪除程式和s_del_plant_tree的條件有些微不同,所以這裡自己處理.
   LET l_azwa_del_sql = "DELETE FROM azwa_file WHERE azwa02 NOT IN (",l_plant_str,") AND azwa03 IN (",l_plant_str,")"
   PREPARE del_prep3 FROM l_azwa_del_sql 
   EXECUTE del_prep3
   FREE del_prep3
 
   #取得真正的Plant Tree陣列.
   LET l_plant_tok = base.StringTokenizer.create(l_plant_str, ",")
   WHILE l_plant_tok.hasMoreTokens()
      LET l_tmp_plant = l_plant_tok.nextToken() #'P1'
      LET l_plant = l_tmp_plant.subString(2, l_tmp_plant.getLength()-1) #P1
      LET l_j = l_j + 1
      LET l_plant_arr[l_j].plant = l_plant
   END WHILE
 
   LET l_azwa_sql = "SELECT * FROM azwa_file",
                    " WHERE azwa03='",p_upper_plant,"'",
                    " ORDER BY azwa01,azwa02"
   DECLARE azwa_curs3 CURSOR FROM l_azwa_sql
   
   LET l_index = 0
 
   FOREACH azwa_curs3 INTO l_azwa_arr[l_index+1].*
      IF STATUS THEN
         CALL cl_err('foreach:', STATUS, 1)
         EXIT PROGRAM
      END IF
   
      LET l_index = l_index + 1
   END FOREACH
 
   FOR l_i=1 TO l_index
      FOR l_j=1 TO l_plant_arr.getLength() 
         #有權限才要加上Plant資料.
         IF cl_user_has_plant_auth(l_azwa_arr[l_i].azwa01, l_plant_arr[l_j].plant) THEN
            IF NOT user_has_azwa_data(l_azwa_arr[l_i].azwa01, l_azwa_arr[l_i].azwa02, l_plant_arr[l_j].plant) THEN         
               INSERT INTO azwa_file VALUES(l_azwa_arr[l_i].azwa01,l_azwa_arr[l_i].azwa02,l_plant_arr[l_j].plant)
            END IF
         END IF
      END FOR
   END FOR
END FUNCTION 

##################################################
# Descriptions...: 取得Plant的IN條件
# Date & Author..: 2009/07/23 by Hiko
# Input Parameter: p_curr_plant 目標Plant
#                : p_in_cond    Plant的IN條件 
# Return code....: p_in_cond
##################################################
FUNCTION get_plant_cond(p_plant, p_in_cond)
   DEFINE p_plant STRING,
          p_in_cond STRING
   DEFINE l_azw_sql   STRING,
          l_index     SMALLINT,
          l_i         SMALLINT
   DEFINE l_azw_arr DYNAMIC ARRAY OF RECORD
                    plant LIKE azw_file.azw01
                    END RECORD
   DEFINE l_curr_plant STRING

   LET p_plant = p_plant.trim()

   IF cl_null(p_in_cond) THEN
      LET p_in_cond = "'",p_plant,"'"
   ELSE
      IF p_in_cond.getIndexOf(p_plant, 1)=0 THEN
         LET p_in_cond = p_in_cond,",'",p_plant,"'"
      END IF
   END IF

   LET l_azw_sql = "SELECT azw01 FROM azw_file",
                   " WHERE azw07='",p_plant,"'",
                   " ORDER BY azw01"
   DECLARE azw_curs2 CURSOR FROM l_azw_sql
   
   LET l_index = 0
   FOREACH azw_curs2 INTO l_azw_arr[l_index+1].*
      IF STATUS THEN
         CALL cl_err('foreach:', STATUS, 1)
         EXIT PROGRAM
      END IF
   
      LET l_index = l_index + 1
   END FOREACH
 
   FOR l_i=1 TO l_index
      LET l_curr_plant = l_azw_arr[l_i].plant CLIPPED
      #這個判斷是為了避免azw_file的從屬關係設定錯誤而做.例如azw01='DS-4',azw07='DS-4'==>這資料就不合理.
      IF l_curr_plant = p_plant THEN
         CONTINUE FOR
      END IF
 
      LET p_in_cond = get_plant_cond(l_curr_plant, p_in_cond)
   END FOR
 
   RETURN p_in_cond
END FUNCTION
