# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: p_qry_test.4gl
# Descriptions...: 動態查詢函式測試檢查 
# Date & Author..: 04/12/31 alex
# Modify.........: No.FUN-4C0107 04/12/31 自 p_qry 中分離出來
# Modify.........: No.MOD-510126 05/01/18 測試時按下放棄可以回來不會再往下做
# Modify.........: No.MOD-620018 06/02/10 測試CONSTRUCT時會抓取錯誤的回傳量
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: FOR GP5.2     09/08/03 By Hiko 移除gab10,gac04
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
DEFINE
    g_gab           RECORD                        # (單頭)
        gab01       LIKE gab_file.gab01,
        gae04       LIKE gae_file.gae04,
        gab07       LIKE gab_file.gab07,
        #gab10       LIKE gab_file.gab10, #FUN-980030
        gab08       LIKE gab_file.gab08,
        gab11       LIKE gab_file.gab11,
        gab06       LIKE gab_file.gab06,
        gab02       LIKE gab_file.gab02,
        gab05       LIKE gab_file.gab05,
        gab03       LIKE gab_file.gab03,
        gab04       LIKE gab_file.gab04
                    END RECORD
END GLOBALS
 
DEFINE g_msg STRING
 
FUNCTION p_qry_test()
 
   DEFINE   l_returnCount   LIKE type_file.num10   #NO.FUN-680135 INTEGER
   DEFINE   l_tmp           LIKE type_file.chr2    #NO.FUN-680135 VARCHAR(2)
   DEFINE   l_values        STRING
   DEFINE   l_i             LIKE type_file.num5    #No.FUN-680135 SMALLINT
 
   IF cl_null(g_gab.gab01) THEN
      RETURN
   END IF
 
   IF g_gab.gab07='Y' THEN
      CALL cl_err('Hard-Code Function Cannot Test!','!',1)
      RETURN
   END IF
 
   CALL cl_init_qry_var()
   LET g_errno = " "
 
   OPEN WINDOW p_qry_test_w WITH FORM "azz/42f/p_qry_test"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("p_qry_test")
 
   SELECT COUNT(*) INTO l_returnCount FROM gac_file
    WHERE gac01 = g_gab.gab01 AND gac12 = g_gab.gab11
      AND gac10 = "Y"
 
   IF SQLCA.SQLCODE THEN
      IF SQLCA.SQLCODE = 100 THEN
         LET g_errno  = "azz-013"
      ELSE
         LET g_errno  = SQLCA.sqlcode USING '-------'
      END IF
      RETURN
   ELSE
      LET l_values=""
      FOR l_i = 1 TO l_returnCount
        LET l_values=l_values.trim(),",",l_i 
      END FOR
      LET l_values=l_values.trim()
      LET l_values=l_values.subString(2,l_values.getLength())
      CALL cl_set_combo_items("multiret_index",l_values,l_values)
   END IF
 
   INPUT g_qryparam.state,    g_qryparam.construct, g_qryparam.where,
         g_qryparam.pagecount,g_qryparam.default1,  g_qryparam.default2,
         g_qryparam.default3, g_qryparam.default4,  g_qryparam.default5,
         g_qryparam.arg1,     g_qryparam.arg2,      g_qryparam.arg3,
         g_qryparam.arg4,     g_qryparam.arg5,      g_qryparam.arg6, 
         g_qryparam.arg7,     g_qryparam.arg8,      g_qryparam.arg9,
         g_qryparam.multiret_index
    FROM FORMONLY.state,      FORMONLY.construct,   FORMONLY.where,
         FORMONLY.pagecount,  FORMONLY.default1,    FORMONLY.default2,
         FORMONLY.default3,   FORMONLY.default4,    FORMONLY.default5,
         FORMONLY.arg1,       FORMONLY.arg2,        FORMONLY.arg3,
         FORMONLY.arg4,       FORMONLY.arg5,        FORMONLY.arg6,
         FORMONLY.arg7,       FORMONLY.arg8,        FORMONLY.arg9,
         FORMONLY.multiret_index
 
   BEFORE INPUT
      LET g_qryparam.form           = g_gab.gab01 # 執行查詢程式代碼
      LET g_qryparam.state          = "i"         # 現在狀態 "i"nput,"c"onstruct
      LET g_qryparam.construct      = "N"         # 是否做 construct (Y/N) Def:Y
      LET g_qryparam.where          = "1=1"       # 該程式中特別的where條件
#         g_qryparam.pagecount                    # 一次回傳幾筆可選
      LET g_qryparam.multiret_index = 1           
#         g_qryparam.default1                     # 預設傳入值,當查不到時需回
#         g_qryparam.default2                     # 傳的原欄位值,因Return最多
#         g_qryparam.default3                     # 只有 3個
      DISPLAY g_qryparam.state, g_qryparam.construct, g_qryparam.multiret_index,
              g_qryparam.where, g_gab.gab01,          l_returnCount
           TO FORMONLY.state,   FORMONLY.construct,   FORMONLY.multiret_index,
              FORMONLY.where,   FORMONLY.q_form,  FORMONLY.q_retno
 
    BEFORE FIELD state
       CALL cl_set_comp_entry("multiret_index",TRUE)
 
    AFTER FIELD state
       IF g_qryparam.state IS NOT NULL AND g_qryparam.state="i" THEN
          CALL cl_set_comp_entry("multiret_index",FALSE)
       END IF
 
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT
 
     ON ACTION about         #MOD-4C0121
        CALL cl_about()      #MOD-4C0121
    
     ON ACTION help          #MOD-4C0121
        CALL cl_show_help()  #MOD-4C0121
    
     ON ACTION controlg      #MOD-4C0121
        CALL cl_cmdask()     #MOD-4C0121
 
    END INPUT
 
    CLOSE WINDOW p_qry_test_w
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    IF g_qryparam.state = "i" THEN    #MOD-620018
       CASE
          WHEN l_returnCount = 1
             CALL cl_create_qry() RETURNING g_qryparam.default1
          WHEN l_returnCount = 2
             CALL cl_create_qry() RETURNING g_qryparam.default1,
                                            g_qryparam.default2
          WHEN l_returnCount = 3
             CALL cl_create_qry() RETURNING g_qryparam.default1,
                                            g_qryparam.default2,
                                            g_qryparam.default3
          WHEN l_returnCount = 4
             CALL cl_create_qry() RETURNING g_qryparam.default1,
                                            g_qryparam.default2,
                                            g_qryparam.default3,
                                            g_qryparam.default4
          WHEN l_returnCount = 5
             CALL cl_create_qry() RETURNING g_qryparam.default1,
                                            g_qryparam.default2,
                                            g_qryparam.default3,
                                            g_qryparam.default4,
                                            g_qryparam.default5
          OTHERWISE
             LET g_errno = "azz-014"
       END CASE
   ELSE
       CALL cl_create_qry() RETURNING g_qryparam.default1
       LET l_returnCount = 1
   END IF
 
   CALL p_qry_result(l_returnCount)
 
   RETURN
END FUNCTION
 
   # Show Result FUN-4C0107
 
FUNCTION p_qry_result(l_count)
 
   DEFINE l_qry_relt   DYNAMIC ARRAY of RECORD
      no               LIKE type_file.num5,   #No.FUN-680135 SMALLINT
      rtn              STRING
                   END RECORD
   DEFINE l_count      LIKE type_file.num5    #No.FUN-680135 SMALLINT
 
   CALL l_qry_relt.clear()
 
   OPEN WINDOW p_qry_result_w WITH FORM "azz/42f/p_qry_result"
   ATTRIBUTE (STYLE = "viewer")
 
   CALL cl_ui_locale("p_qry_result")
 
   CASE
      WHEN l_count=1
         LET l_qry_relt[1].no=1    LET l_qry_relt[1].rtn=g_qryparam.default1
      WHEN l_count=2
         LET l_qry_relt[1].no=1    LET l_qry_relt[1].rtn=g_qryparam.default1
         LET l_qry_relt[2].no=2    LET l_qry_relt[2].rtn=g_qryparam.default2
      WHEN l_count=3
         LET l_qry_relt[1].no=1    LET l_qry_relt[1].rtn=g_qryparam.default1
         LET l_qry_relt[2].no=2    LET l_qry_relt[2].rtn=g_qryparam.default2
         LET l_qry_relt[3].no=3    LET l_qry_relt[3].rtn=g_qryparam.default3
      WHEN l_count=4
         LET l_qry_relt[1].no=1    LET l_qry_relt[1].rtn=g_qryparam.default1
         LET l_qry_relt[2].no=2    LET l_qry_relt[2].rtn=g_qryparam.default2
         LET l_qry_relt[3].no=3    LET l_qry_relt[3].rtn=g_qryparam.default3
         LET l_qry_relt[4].no=4    LET l_qry_relt[4].rtn=g_qryparam.default4
      WHEN l_count=4
         LET l_qry_relt[1].no=1    LET l_qry_relt[1].rtn=g_qryparam.default1
         LET l_qry_relt[2].no=2    LET l_qry_relt[2].rtn=g_qryparam.default2
         LET l_qry_relt[3].no=3    LET l_qry_relt[3].rtn=g_qryparam.default3
         LET l_qry_relt[4].no=4    LET l_qry_relt[4].rtn=g_qryparam.default4
         LET l_qry_relt[5].no=5    LET l_qry_relt[5].rtn=g_qryparam.default5
      OTHERWISE
         LET l_qry_relt[1].no=1    LET l_qry_relt[1].rtn="Returning Value Error"  
         LET l_qry_relt[2].no=2    LET l_qry_relt[2].rtn="Returning Value Error"  
         LET l_qry_relt[3].no=3    LET l_qry_relt[3].rtn="Returning Value Error"  
         LET l_qry_relt[4].no=4    LET l_qry_relt[4].rtn="Returning Value Error"  
         LET l_qry_relt[5].no=5    LET l_qry_relt[5].rtn="Returning Value Error"  
    END CASE
 
   DISPLAY g_qryparam.form,   g_qryparam.state,      g_qryparam.construct,
           g_qryparam.where,  g_qryparam.pagecount
        TO FORMONLY.q_form,   FORMONLY.q_stat,       FORMONLY.q_cons,
           FORMONLY.q_where,  FORMONLY.q_page
 
   IF g_qryparam.construct="c" THEN 
      DISPLAY g_gab.gab05 TO FORMONLY.q_swhere
   ELSE
      DISPLAY g_gab.gab02 TO FORMONLY.q_swhere
   END IF
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY l_qry_relt TO s_qry_result.* ATTRIBUTE(COUNT=l_count,UNBUFFERED)
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION yes_i_see
         EXIT DISPLAY
 
      END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
   CLOSE WINDOW p_qry_result_w
   RETURN
END FUNCTION
 
