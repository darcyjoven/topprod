# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Library name...: cl_chk_act_auth.4gl
# Descriptions...: 檢查ACTION的權限.
# Memo...........:                                                                         
# Usage..........: CALL cl_chk_act_auth()
# Date & Author..: 2003/10/08 by Hiko
# Modify.........: No.MOD-530112 05/03/16 alex 修正比對權限的寫法
# Modify.........: No.FUN-580025 05/08/22 alex add nochking actions in list
# Modify.........: No.FUN-5B0102 05/11/22 alex add function about no show err msg
# Modify.........: No.TQC-5C0125 05/12/28 alex 修正群組部門權限設定
# Modify.........: No.TQC-5C0134 06/02/24 alex 增加同權限部門及管理員可動作設定
# Modify.........: No.TQC-660015 06/06/07 saki cl_chk_tgrup_list組合字串改用逗號，以免SQL錯誤
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-7C0045 07/12/14 By alex 修改說明
# Modify.........: No.MOD-890049 08/09/03 By claire 新增cl_chk_act_auth_showmsg()
# Modify.........: No.TQC-890026 08/09/08 By alex 調整mi_show_nomsg使用後回歸TRUE
# Modify.........: No.FUN-980030 09/08/04 By Hiko For GP5.2
# Modify.........: No.FUN-960173 08/08/14 By alex 調整mi_show_nomsg為mi_show_msg_method
# Modify.........: No.FUN-A10063 10/01/13 By Hiko 補上mi_show_msg_method的判斷
# Modify.........: No.FUN-A20016 10/02/04 By Hiko 營運中心已經失效,則只能查詢.
# Modify.........: No.FUN-BC0055 11/12/20 By jrg542 依照aoos900設定的內容，使cl_chk_act_auth能夠將使用者選用 action 的動作，依需求寫入 gdp_file   
# Modify.........: No:TQC-C60045 13/02/20 By joyce 調整cl_chk_tgrup_list中部門清單的判斷方式

DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0045
 
DEFINE   mi_show_msg_method     LIKE type_file.num5      #FUN-5B0102   #No.FUN-690005 SMALLINT
 
##########################################################################
# Descriptions...: 檢查ACTION的權限.
# Input parameter: none
# Return code....: li_act_allow   (TRUE/FALSE)
# Usage..........: IF cl_chk_act_auth() THEN
# Modify.........: 04/11/29 MOD-4B0130 alex 修改 g_chk_usr_grp_as 賦予初始值
# Modify.........: 05/03/16 MOD-530112 alex 修改比對權限的寫法
# Modify.........: 05/06/10 MOD-560051 alex 修改抓取 gbl_file 機制
# Memo...........: 本函式使用全域變數 g_action_choice 傳入檢查 action_id
##########################################################################
 
FUNCTION cl_chk_act_auth()
   DEFINE   lst_act_list   base.StringTokenizer,
            ls_act         STRING,
            li_act_allow   LIKE type_file.num5      #No.FUN-690005 SMALLINT
   DEFINE   lc_gbl02       LIKE gbl_file.gbl02,
            lc_gbl03       LIKE gbl_file.gbl03
   DEFINE   l_flag         BOOLEAN
   DEFINE   l_err_param    STRING #FUN-A10063
   DEFINE   l_azwacti      LIKE azw_file.azwacti #FUN-A20016
   DEFINE   ls_msg         STRING   #No.FUN-BC0055
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   #MOD-4B0130
   LET g_action_choice = g_action_choice.toLowerCase()
 
   #FUN-580025
   IF g_action_choice="controlp" OR g_action_choice="exit"  OR g_action_choice="locale" OR
      g_action_choice="previous" OR g_action_choice="first" OR g_action_choice="jump"   OR
      g_action_choice="next"     OR g_action_choice="last"  OR g_action_choice="exit"   THEN
      RETURN TRUE
   END IF
 
   #Begin:FUN-A20016
   IF g_action_choice<>"query" THEN
      SELECT azwacti INTO l_azwacti FROM azw_file WHERE azw01=g_plant
      IF l_azwacti='N' THEN
         IF mi_show_msg_method<>2 THEN 
            CALL cl_err_msg(NULL,"lib-601",g_plant CLIPPED,10)
            IF mi_show_msg_method IS NOT NULL THEN 
               LET mi_show_msg_method = 1
            END IF
         END IF
         RETURN FALSE
      END IF
   END IF
   #End:FUN-A20016

   #FUN-980030 20090714 by Hiko:資料所屬plant與登入plant不同時,不可以執行任何動作.
   IF g_action_choice<>"query" AND g_action_choice<>"insert" THEN #FUN-A10063:新增,查詢時不控制
      IF NOT cl_null(g_data_plant) AND (g_data_plant != g_plant) THEN
         IF mi_show_msg_method<>2 THEN #FUN-A10063
            LET l_err_param = g_data_plant CLIPPED,"|",g_plant CLIPPED
            CALL cl_err_msg(NULL,"lib-600", l_err_param, 10)
            IF mi_show_msg_method IS NOT NULL THEN #FUN-A10063
               LET mi_show_msg_method = 1
            END IF
         END IF
         RETURN FALSE
      END IF
   END IF
 
    IF cl_null(g_chk_usr_grp_as) THEN #MOD-560051
      LET lc_gbl02 = g_action_choice.trim()
      SELECT gbl03 INTO lc_gbl03 FROM gbl_file
       WHERE gbl01 = g_prog AND gbl02 = lc_gbl02
      IF SQLCA.SQLCODE THEN
         LET lc_gbl03 = ""
      END IF
      CASE lc_gbl03
         WHEN "Q" LET g_chk_usr_grp_as = "query"
         WHEN "M" LET g_chk_usr_grp_as = "modify"
         WHEN "D" LET g_chk_usr_grp_as = "delete"
         OTHERWISE
                  LET g_chk_usr_grp_as = ""
      END CASE
   ELSE
      LET g_chk_usr_grp_as = DOWNSHIFT(g_chk_usr_grp_as)
   END IF
   IF NOT cl_null(g_chk_usr_grp_as) THEN
      DISPLAY 'INFO:Referance Auth->',lc_gbl03,'--',g_chk_usr_grp_as CLIPPED
   END IF
   LET lst_act_list = base.StringTokenizer.create(g_priv1 CLIPPED, ",")
 
   WHILE lst_act_list.hasMoreTokens()
      LET ls_act = lst_act_list.nextToken()
      LET ls_act = ls_act.trim()
 
      # 將 g_priv1 一個個解出來分析 若有一樣的則探討有無權限
      # 找到基本上就是有, 除 modify,invalid,detail 外
      # 0.允許查尋 更改 刪除        1.允許查尋更改 不准刪除
      # 2.允許查詢 刪除 不允許更改  3.允許查詢 不准刪除更改
      # 4.不准查詢刪除更改          分 user and owner
 
#     #MOD-530112
#     IF (ls_act.getIndexOf(g_action_choice, 1) > 0) THEN
      IF (ls_act.equalsIgnoreCase(g_action_choice.trim())) THEN
         LET li_act_allow = TRUE
 
         # 2003/10/08 Hiko 在Action可以執行的情況下,某些Action尚需判斷
         #                 資料擁有者/資料擁有部門是否與使用者/部門相同.
 
         CASE
            #刪除 delete
            WHEN g_action_choice.equals("delete") OR g_chk_usr_grp_as="delete"
               IF (g_data_owner != g_user) AND           # User先看有無註記
                   g_priv2 MATCHES "[134]" THEN
                  LET li_act_allow = FALSE
               END IF
               IF (li_act_allow) AND (g_data_group != g_grup) AND
                  g_priv3 MATCHES "[13457]" THEN          #TQC-5C0125
#                 g_priv3 MATCHES "[134]" THEN  
                  LET li_act_allow = FALSE
               END IF
         
            #更改 modify & detail
            WHEN g_action_choice.equals("modify") OR g_chk_usr_grp_as="modify"
              OR g_action_choice.equals("detail") OR g_chk_usr_grp_as="detail"
               IF (g_data_owner != g_user) AND           # User先看有無註記
                   g_priv2 MATCHES "[234]" THEN
                  LET li_act_allow = FALSE
               END IF
               IF (li_act_allow) AND (g_data_group != g_grup) AND
                  g_priv3 MATCHES "[23467]" THEN         #TQC-5C0125
#                 g_priv3 MATCHES "[234]" THEN
                  LET li_act_allow = FALSE
               END IF
         END CASE
         
#         IF (g_action_choice.equals("modify") OR       #查詢
#             g_action_choice.equals("detail") OR  
#             g_action_choice.equals("invalid")) THEN   #更改
#        
#            IF (g_data_owner != g_user) THEN           # User先看有無註記
#               IF (g_priv2 MATCHES "[234]") THEN       # 若有表示 user 最大
#                  LET li_act_allow = FALSE
#               END IF
#            END IF
#        
#            # 2003/10/09 Hiko 如果是FALSE時,就不必再檢查,以免部門檢查段將
#            #                 權限有更改為TRUE. TRUE 則再看部門
#            IF (li_act_allow) THEN
#               IF (g_data_group != g_grup) THEN
#                  IF (g_priv3 MATCHES "[234]") THEN
#                     LET li_act_allow = FALSE
#                  END IF
#               END IF
#            END IF
#        
#         ELSE
#            IF (g_action_choice.equals("delete")) THEN
#               IF (g_data_owner != g_user) THEN
#                  IF (g_priv2 MATCHES "[134]") THEN
#                     LET li_act_allow = FALSE
#                  END IF
#               END IF
#               
#               # 2003/10/09 Hiko 如果是FALSE時,就不必再檢查,
#               #                 以免部門檢查段將權限有更改為TRUE.
#               IF (li_act_allow) THEN
#                  IF (g_data_group != g_grup) THEN
#                     IF (g_priv3 MATCHES "[134]") THEN
#                        LET li_act_allow = FALSE
#                     END IF
#                  END IF
#               END IF
#            END IF
#         END IF
 
          EXIT WHILE
      END IF
   END WHILE
 
   IF (NOT li_act_allow) THEN 
      IF g_action_choice.equals("modify") OR
         g_action_choice.equals("detail") OR
         g_action_choice.equals("delete") THEN
         #您對此筆資料沒有更改或刪除的權限!(請檢查權限設定及資料所有者)
        #IF NOT mi_show_nomsg THEN
         IF mi_show_msg_method IS NOT NULL AND mi_show_msg_method = 2 THEN
         ELSE
            CALL cl_err(g_action_choice,'9007',0)
           #LET mi_show_nomsg = FALSE
           #LET mi_show_nomsg = TRUE   #TQC-890026
            IF mi_show_msg_method IS NOT NULL THEN
               LET mi_show_msg_method = 1   #FUN-960173
            END IF
         END IF
      ELSE
         IF g_chk_usr_grp_as="modify" OR g_chk_usr_grp_as="detail" OR
            g_chk_usr_grp_as="delete" THEN
            #您對此筆資料沒有 act 的權限! (請檢查是否有 as 權限及資料所有者)
           #IF NOT mi_show_nomsg THEN
            IF mi_show_msg_method IS NOT NULL AND mi_show_msg_method = 2 THEN
            ELSE
               CALL cl_err_msg(NULL,"lib-218", g_action_choice CLIPPED ||"|"|| g_chk_usr_grp_as CLIPPED, 10)
              #LET mi_show_nomsg = FALSE
              #LET mi_show_nomsg = TRUE   #TQC-890026
               IF mi_show_msg_method IS NOT NULL THEN
                  LET mi_show_msg_method = 1   #FUN-960173
               END IF
            END IF
         ELSE
            #您在 prog 中沒有執行 act 的權限! (請檢查權限設定)
           #IF NOT mi_show_nomsg THEN
            IF mi_show_msg_method IS NOT NULL AND mi_show_msg_method = 2 THEN
            ELSE
               CALL cl_err_msg(NULL,"lib-219", g_prog CLIPPED ||"|"|| g_action_choice CLIPPED, 10)
              #LET mi_show_nomsg = FALSE
              #LET mi_show_nomsg = TRUE   #TQC-890026
               IF mi_show_msg_method IS NOT NULL THEN
                  LET mi_show_msg_method = 1   #FUN-960173
               END IF
            END IF
         END IF
      END IF
   END IF
 
# Save Your Life Function
# Starting
# RETURN TRUE
# Ending
 
  # Reset g_chk_usr_grp_as = ""
  LET g_chk_usr_grp_as = ""

  #No.FUN-BC0055 --- start ---
  IF li_act_allow THEN 
     IF g_azz.azz14 = '1' THEN  #action代碼紀錄 
        LET ls_msg = g_action_choice CLIPPED," entered."
        IF cl_syslog("A","D",ls_msg) THEN END IF
     END IF 
  END IF 
  #No.FUN-BC0055 --- end ---
  call cl_chk_act_auth_record()
  RETURN li_act_allow
 
END FUNCTION
 
##########################################################################
# Descriptions...: 若檢查ACTION不過也不show error msg.
# Input parameter: none
# Return code....: none
# Usage..........: CALL cl_chk_act_auth_nomsg()
# Modify.........: 05/11/22 FUN-5B0102 alex add function about no show err msg
##########################################################################
 
FUNCTION cl_chk_act_auth_nomsg()    #FUN-5B0102
 
                                 #若程式從頭到尾沒call nomsg / showmsg
                                 #則 method =NULL or =0 都有可能, 故取
  #LET mi_show_nomsg = TRUE      #method=2表示不再show error message
   LET mi_show_msg_method = 2    #FUN-960173
   RETURN
 
END FUNCTION
 
##########################################################################
# Descriptions...: 若檢查ACTION不過show error msg.
#                  主要用意為當CALL cl_chk_act_authnomsg() 再CALL本支程式恢復初始值
# Input parameter: none
# Return code....: none
# Usage..........: CALL cl_chk_act_auth_showmsg()
# Modify.........: 08/09/03 MOD-890049 claire add function about show show err msg
##########################################################################
 
FUNCTION cl_chk_act_auth_showmsg()    
 
  #LET mi_show_nomsg = FALSE    #method=1 表示回復要show (離開2就要show)
   LET mi_show_msg_method = 1   #FUN-960173
   RETURN
 
END FUNCTION
 
##########################################################################
# Descriptions...: 查核此 g_user或g_grup是否位列g_data_group的tgrup中
# Input parameter: none
# Return code....: li_ingrup   (TRUE/FALSE)
# Usage..........: IF cl_chk_act_tgrup() THEN
##########################################################################
 
FUNCTION cl_chk_act_tgrup()
 
   DEFINE li_i     LIKE type_file.num5     #No.FUN-690005 SMALLINT  
   DEFINE li_j     LIKE type_file.num5     #No.FUN-690005 SMALLINT
   DEFINE ls_sql   STRING
   DEFINE lc_zyw01 LIKE zyw_file.zyw01
 
   IF cl_null(g_data_group) THEN
      RETURN FALSE
   END IF
 
   SELECT count(*) INTO li_i FROM zyw_file
    WHERE zyw03=g_data_group AND zyw05='0'
   IF SQLCA.SQLCODE OR li_i < 1 THEN
      RETURN FALSE
   END IF
 
   LET ls_sql = " SELECT UNIQUE zyw01 FROM zyw_file ",
                 " WHERE zyw03=",g_data_group CLIPPED, 
                   " AND zyw05='0' "
   PREPARE chk_act_tgrup_pre FROM ls_sql
   DECLARE chk_act_tgrup_cs CURSOR FOR chk_act_tgrup_pre
 
   FOREACH chk_act_tgrup_cs INTO lc_zyw01
      LET li_j=0
      SELECT count(*) INTO li_j FROM zyw_file
       WHERE zyw01=lc_zyw01 AND zyw03=g_grup AND zyw05='0'
      IF li_j >= 1 THEN
         RETURN TRUE
      END IF
      SELECT count(*) INTO li_j FROM zyw_file
       WHERE zyw01=lc_zyw01 AND zyw04=g_user AND zyw05='1'
      IF li_j >= 1 THEN
         RETURN TRUE
      END IF
   END FOREACH
   RETURN FALSE
END FUNCTION
 
##########################################################################
# Descriptions...: 輸出此 g_grup 所有的相關 grup 清單
# Input parameter: none
# Return code....: ls_tgrup   STRING    Group清單
# Usage..........: CALL cl_chk_tgrup_list()
# Memo...........: 以目前的g_user及g_grup為基準
##########################################################################
 
FUNCTION cl_chk_tgrup_list()
 
   DEFINE li_i       LIKE type_file.num5     #No.FUN-690005 SMALLINT
   DEFINE ls_sql     STRING
   DEFINE lc_zyw01   LIKE zyw_file.zyw01
   DEFINE ls_tgrup   STRING
   DEFINE ls_ret     STRING
   DEFINE lc_zyw03   LIKE zyw_file.zyw03     #No.FUN-A60029
   DEFINE li_tok     base.StringTokenizer    #No:TQC-C60045
   DEFINE li_str     STRING                  #No:TQC-C60045
   DEFINE li_exist   LIKE type_file.num5     #No:TQC-C60045

   IF cl_null(g_grup) OR cl_null(g_user) THEN
      LET ls_ret =  "('",g_grup CLIPPED,"')"   #No.TQC-660015
      RETURN ls_ret.trim()
   END IF
 
   LET ls_tgrup=""
 
   SELECT count(*) INTO li_i FROM zyw_file
    WHERE zyw03=g_grup AND zyw05='0'
   IF li_i >= 1 THEN
      LET ls_sql = " SELECT UNIQUE zyw01 FROM zyw_file ",
                    " WHERE zyw03='",g_grup CLIPPED,"' ", 
                      " AND zyw05='0' "
      PREPARE chk_act_tglst1_pre FROM ls_sql
      DECLARE chk_act_tglst1_cs CURSOR FOR chk_act_tglst1_pre
 
      FOREACH chk_act_tglst1_cs INTO lc_zyw01
 
         LET ls_sql = " SELECT UNIQUE zyw03 FROM zyw_file ",
                       " WHERE zyw01='",lc_zyw01 CLIPPED,"' ", 
                         " AND zyw05='0' "
         PREPARE chk_act_tglst2_pre FROM ls_sql
         DECLARE chk_act_tglst2_cs CURSOR FOR chk_act_tglst2_pre
 
         FOREACH chk_act_tglst2_cs INTO lc_zyw03                        #No:FUN-A60029     lc_zyw01
            # No:TQC-C60045 ---modify start---
            # 原先的判斷方式是為了避免清單(ls_tgrup)中有重複的部門別，因此若有搜尋到一樣的就不加進去，
            # 但是這種作法當部門別為01 , 001 , 0001這類的，就會有問題，
            # 因為若清單中有 0001 這個部門，但是當以 01 或是 001的部門別去搜尋清單時也會視為TRUE，
            # 因此改用Token的方式取出清單中已經存在的部門別再去判斷

         #  IF NOT ls_tgrup.getIndexOf(lc_zyw03 CLIPPED,1) THEN         #No:FUN-A60029
         #     LET ls_tgrup=ls_tgrup.trim(),"'",lc_zyw03 CLIPPED,"',"   #No:FUN-A60029
         #  END IF

            LET li_exist = FALSE
            LET li_tok = base.StringTokenizer.create(ls_tgrup,",")

            WHILE li_tok.hasMoreTokens()
               IF li_str = li_tok.nextToken() THEN
                  IF li_str = lc_zyw03 THEN
                     LET li_exist = TRUE
                  END IF
               END IF
            END WHILE

            IF NOT li_exist THEN
               LET ls_tgrup=ls_tgrup.trim(),"'",lc_zyw03 CLIPPED,"',"   #No:FUN-A60029
            END IF
            # No:TQC-C60045 --- modify end ---
         END FOREACH
      END FOREACH
   END IF
 
   SELECT count(*) INTO li_i FROM zyw_file
    WHERE zyw04=g_user AND zyw05='1'
   IF li_i >= 1 THEN
      LET ls_sql = " SELECT UNIQUE zyw01 FROM zyw_file ",
                    " WHERE zyw04='",g_user CLIPPED,"' ", 
                      " AND zyw05='1' "
 
      PREPARE chk_act_tglst3_pre FROM ls_sql
      DECLARE chk_act_tglst3_cs CURSOR FOR chk_act_tglst3_pre
 
      FOREACH chk_act_tglst3_cs INTO lc_zyw01
 
         LET ls_sql = " SELECT UNIQUE zyw03 FROM zyw_file ",
                       " WHERE zyw01='",lc_zyw01 CLIPPED,"' ", 
                         " AND zyw05='0' "
         PREPARE chk_act_tglst4_pre FROM ls_sql
         DECLARE chk_act_tglst4_cs CURSOR FOR chk_act_tglst4_pre
 
         FOREACH chk_act_tglst4_cs INTO lc_zyw03                        #No:FUN-A60029    lc_zyw01
            # No:TQC-C60045 ---modify start---
            # 原先的判斷方式是為了避免清單(ls_tgrup)中有重複的部門別，因此若有搜尋到一樣的就不加進去，
            # 但是這種作法當部門別為01 , 001 , 0001這類的，就會有問題，
            # 因為若清單中有 0001 這個部門，但是當以 01 或是 001的部門別去搜尋清單時也會視為TRUE，
            # 因此改用Token的方式取出清單中已經存在的部門別再去判斷

         #  IF NOT ls_tgrup.getIndexOf(lc_zyw03 CLIPPED,1) THEN         #No:FUN-A60029
         #     LET ls_tgrup=ls_tgrup.trim(),"'",lc_zyw03 CLIPPED,"',"   #No:FUN-A60029 
         #  END IF

            LET li_exist = FALSE
            LET li_tok = base.StringTokenizer.create(ls_tgrup,",")

            WHILE li_tok.hasMoreTokens()
               IF li_str = li_tok.nextToken() THEN
                  IF li_str = lc_zyw03 THEN
                     LET li_exist = TRUE
                  END IF
               END IF
            END WHILE

            IF NOT li_exist THEN
               LET ls_tgrup=ls_tgrup.trim(),"'",lc_zyw03 CLIPPED,"',"   #No:FUN-A60029
            END IF
            # No:TQC-C60045 --- modify end ---
         END FOREACH
      END FOREACH
   END IF
 
   LET ls_tgrup=ls_tgrup.subString(1,ls_tgrup.getLength()-1)
 
   IF ls_tgrup.getLength() <= 0 THEN
      LET ls_ret = "('",g_grup CLIPPED,"')"     #No.TQC-660015
   ELSE
      LET ls_ret = "(",ls_tgrup.trim(),")"      #No.TQC-660015
   END IF
   RETURN ls_ret.trim()
 
END FUNCTION
 
 
#darcy:2024/10/23 add s---
function cl_chk_act_auth_record()
   define l_zxa   record like zxa_file.*
   define l_sql   string
   define l_zxa01 varchar(40)
   define l_zxd01 varchar(40)
   define l_cnt   integer

   let l_zxd01 = g_action_choice
   select count(1) into l_cnt from zxd_file where zxd01 = l_zxd01
   if l_cnt = 0 then
      return
   end if

   initialize l_zxa.* to null
 
   let l_zxa.zxa03 = g_prog
   let l_zxa.zxa04 = g_action_choice
   let l_zxa.zxa07 = g_today
   let l_zxa.zxa08 = current hour to second

   let l_zxa.zxa01 = g_user
   let l_zxa.zxa02 = '1'
   #  人员 + 作业权限 记录
   insert into zxa_file values (l_zxa.*)

   let l_sql = "select zy01 from zy_file ",
               " where zy01 in ( ",
               " select zx04 from zx_file where zx01 = '",g_user,"'",
               " union select zxw04 from zxw_file where zxw01 = '",g_user,"' and zxw03 ='1'",
               " ) and zy02 = '",g_prog,"' and zy03 like '%",g_action_choice,"%'"

   declare zxa_ins1 cursor from l_sql
   foreach zxa_ins1 into l_zxa01
      if sqlca.sqlcode then
         # call cl_err("zxa_ins1",sqlca.sqlcode,1)
         exit foreach
      end if
      let l_zxa.zxa01 = l_zxa01
      let l_zxa.zxa02 = '2'
      # 权限类型 + 作业权限 记录
      insert into zxa_file values (l_zxa.*)
   end foreach

end function
#darcy:2024/10/23 add e---
