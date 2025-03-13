# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: almq042.4gl
# Descriptions...: 租戶賬款查詢
# Date & Author..: FUN-870015 2008/12/17 By shiwuying
# Modify.........: No.FUN-960134 09/07/23 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No.FUN-9C0067 09/12/15 By lutingting修改抓取資料得sql
# Modify.........: No:FUN-A10060 10/01/13 By shiwuying 權限處理
# Modify.........: No:FUN-A60010 10/07/14 By huangtao  移除lmi, lmj, lmk 相關的欄位
# Modify.........: NO:FUN-A80148 10/09/01 By wangxin 因為lma_file已不使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: No:FUN-AA0057 10/11/24 BY shenyang 招商整合bug 
# Modify.........: No:MOD-B40093 11/04/13 By lilingyu 財務單據action點擊後查不到任何單據,sql條件寫錯

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_rec_b         LIKE type_file.num5
DEFINE g_rec_b1        LIKE type_file.num5  #FUN-AA0057
DEFINE g_rec_b2        LIKE type_file.num5  #FUN-AA0057
DEFINE g_wc            STRING
DEFINE g_lua           DYNAMIC ARRAY OF RECORD
           lua01       LIKE lua_file.lua01,
           lua02       LIKE lua_file.lua02,
           lua09       LIKE lua_file.lua09,
           luaplant_1  LIKE lua_file.luaplant,
           rtz13_1     LIKE rtz_file.rtz13, #FUN-A80148 add
           lualegal    LIKE lua_file.lualegal,
           azt02       LIKE azt_file.azt02,
           lua06_1     LIKE lua_file.lua06,
           lua061_1    LIKE lua_file.lua061,
           lua04_1     LIKE lua_file.lua04,
           lua07_1     LIKE lua_file.lua07,
           lua11       LIKE lua_file.lua11,
           lua12       LIKE lua_file.lua12,
           lua24       LIKE lua_file.lua24,
           lua08t      LIKE lua_file.lua08t,
           oma57       LIKE oma_file.oma57,
           oma571      LIKE oma_file.oma57
                       END RECORD
#FUN-AA0057 ----add---begin--                       
DEFINE g_ogb           DYNAMIC ARRAY OF RECORD 
           ogb01       LIKE ogb_file.ogb01,
           ogb03       LIKE ogb_file.ogb03,
           ogbplant    LIKE ogb_file.ogbplant,
           ogb04       LIKE ogb_file.ogb04,
           ogb12       LIKE ogb_file.ogb12,
           ogb05       LIKE ogb_file.ogb05,
           ogb13       LIKE ogb_file.ogb13,
           ogb14       LIKE ogb_file.ogb14
                       END RECORD
DEFINE g_ohb           DYNAMIC ARRAY OF RECORD 
           ohb01       LIKE ohb_file.ohb01,
           ohb03       LIKE ohb_file.ohb03,
           ohbplant    LIKE ohb_file.ohbplant,
           ohb04       LIKE ohb_file.ohb04,
           ohb12       LIKE ohb_file.ohb12,
           ohb05       LIKE ohb_file.ohb05,
           ohb13       LIKE ohb_file.ohb13,
           ohb14       LIKE ohb_file.ohb14
                       END RECORD                     
#FUN-AA0057 ----add---end--                      
DEFINE g_curs_index    LIKE type_file.num10
DEFINE g_row_count     LIKE type_file.num10
DEFINE g_jump          LIKE type_file.num10
DEFINE g_action_flag   STRING
DEFINE g_msg           LIKE type_file.chr1000
DEFINE g_sql           LIKE type_file.chr1000
DEFINE l_ac            LIKE type_file.num5
DEFINE g_cnt           LIKE type_file.num10
DEFINE g_cnt1          LIKE type_file.num10
DEFINE g_cnt2          LIKE type_file.num10 
MAIN
   OPTIONS
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   OPEN WINDOW q042_w WITH FORM "alm/42f/almq042"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL cl_set_comp_visible("lnt08,lnt09,rtz13,lmb03,lmc04",FALSE)       #FUN-A60010   
   CALL q042_q()
   CALL q042_menu()
   CLOSE WINDOW q042_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION q042_cs()
 
   CALL g_lua.clear()
   CALL g_ogb.clear()    #FUN-AA0057
   CALL g_ohb.clear()    #FUN-AA0057
   LET INT_FLAG=0
   WHILE TRUE
      CONSTRUCT BY NAME g_wc ON luaplant,lua06,lua061,lua04,lua07,lua09  #FUN-AA0057
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(luaplant)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_luaplant"
               LET g_qryparam.where = " luaplant IN ",g_auth," "  #No.FUN-A10060
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO luaplant
               NEXT FIELD luaplant
            WHEN INFIELD(lua06)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lua06"
               LET g_qryparam.where = " luaplant IN ",g_auth," "  #No.FUN-A10060
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lua06
               NEXT FIELD lua06
            WHEN INFIELD(lua061)
               CALL cl_init_qry_var() 
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lua061" 
               LET g_qryparam.where = " luaplant IN ",g_auth," "  #No.FUN-A10060
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lua061
               NEXT FIELD lua061
            WHEN INFIELD(lua04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_lua04"
               LET g_qryparam.where = " luaplant IN ",g_auth," "  #No.FUN-A10060
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lua04
               NEXT FIELD lua04
            WHEN INFIELD(lua07)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_lua07"
               LET g_qryparam.where = " luaplant IN ",g_auth," "  #No.FUN-A10060
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lua07
               NEXT FIELD lua07
            OTHERWISE EXIT CASE
         END CASE
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         ON ACTION help
            CALL cl_show_help()
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN
         LET g_wc = ''
         EXIT WHILE
      ELSE
         IF g_wc.getIndexOf("lua06",1) <=0 THEN
            CALL cl_err('','alm-434',0)
            CONTINUE WHILE
         ELSE
            EXIT WHILE
         END IF
      END IF 
   END WHILE  
END FUNCTION
 
FUNCTION q042_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_lua.clear()
   DISPLAY ' ' TO FORMONLY.cn2
   CALL g_ogb.clear()              #FUN-AA0057
   DISPLAY ' ' TO FORMONLY.cn3     #FUN-AA0057
   CALL g_ohb.clear()              #FUN-AA0057
   DISPLAY ' ' TO FORMONLY.cn4     #FUN-AA0057
   CALL q042_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FROM
      CALL g_lua.clear()
      RETURN
   ELSE
      CALL q042_b_fill(g_wc)
      CALL q042_b1_fill(g_wc)  #FUN-AA0057
      CALL q042_b1_fill(g_wc)  #FUN-AA0057
   END IF
   
END FUNCTION
 
FUNCTION q042_menu()
 DEFINE l_msg    LIKE type_file.chr1000
 DEFINE l_oma00  LIKE oma_file.oma00
 DEFINE l_oma01  LIKE oma_file.oma01
   LET g_action_flag = "fixup1"  #FUN-AA0057
   WHILE TRUE
#FUN-AA0057 --add--begin--   
      LET g_action_choice='' 
      CASE
         WHEN (g_action_flag IS NULL) OR (g_action_flag = "fixup1")
              CALL q042_b_fill(g_wc)
              CALL q042_bp("G")
         WHEN (g_action_flag = "fixup2")
              CALL q042_b1_fill(g_wc)
              CALL q042_bp1("G")
         WHEN (g_action_flag = "fixup3")
              CALL q042_b2_fill(g_wc)
              CALL q042_bp2("G")    
      END CASE
#FUN-AA0057 --add--edd--        
      CASE g_action_choice
         
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q042_q()
            END IF
 
         WHEN "financial"    #財務單據
            LET l_ac = ARR_CURR()
            IF g_rec_b > 0 THEN
               SELECT oma00,oma01 INTO l_oma00,l_oma01
                 FROM oma_file
#                WHERE oma70 = g_lua[l_ac].lua01                 #MOD-B40093
                 WHERE oma16 = g_lua[l_ac].lua01                 #MOD-B40093
               LET l_msg = "axrt300 '",l_oma01 CLIPPED,"' 'query'  '",l_oma00,"' "
               CALL cl_cmdrun_wait(l_msg)
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lua),'','')
            END IF
        
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q042_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lua TO s_lua.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
#FUN-AA0057 --add--begin--   
     ON ACTION fixup2 
         LET g_action_flag="fixup2"
         EXIT DISPLAY
     ON ACTION fixup3 
         LET g_action_flag="fixup3"
         EXIT DISPLAY
#FUN-AA0057 --add--end--    
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
     
      ON ACTION financial
         LET g_action_choice="financial"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE         
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION exporttoexcel       
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
     
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                                     
         CALL cl_set_head_visible("","AUTO")      
 
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY
   END DISPLAY  
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#FUN-AA0057 ----add---begin--
FUNCTION q042_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ogb TO s_ogb.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
      ON ACTION fixup1 
         LET g_action_flag="fixup1"
         EXIT DISPLAY
     ON ACTION fixup3 
         LET g_action_flag="fixup3"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION financial
         LET g_action_choice="financial"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE         
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION exporttoexcel       
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
     
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                                     
         CALL cl_set_head_visible("","AUTO")      
 
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY
   END DISPLAY  
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION q042_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ohb TO s_ohb.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
      ON ACTION fixup1
         LET g_action_flag="fixup1"
         EXIT DISPLAY
     ON ACTION fixup2 
         LET g_action_flag="fixup2"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION financial
         LET g_action_choice="financial"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE         
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION exporttoexcel       
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
     
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                                     
         CALL cl_set_head_visible("","AUTO")      
 
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY
   END DISPLAY  
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION  
#FUN-AA0057 ----add---end-- 
 
FUNCTION q042_b_fill(p_wc)
 DEFINE p_wc     LIKE type_file.chr1000
 DEFINE l_amt    LIKE oma_file.oma57
 
   LET g_sql = " SELECT lua01,lua02,lua09,luaplant,'',lualegal,'',lua06,lua061,lua04,",
               "        lua07,lua11,lua12,lua24,lua08t,oma57,oma56t-oma57 ",
               "   FROM lua_file,oma_file ",
               "  WHERE ",p_wc CLIPPED,
               "    AND oma01 = lua24 ",
              #FUN-9C0067--mod--str--
              #"    AND oma70 = lua01 ",
              #"    AND oma71 = luaplant ",
               "    AND oma16 = lua01 ",
               "    AND oma66 = luaplant ",
              #FUN-9C0067--mod--end
               "    AND oma03 = lua06 ",
               "    AND oma56t - oma57 > 0 ",
            #  "    AND luaplant IN ",g_auth," "   #No.FUN-A10060   #FUN-AA0057
               "    AND luaplant IN ",g_auth," "   #FUN-AA0057  
   LET g_sql = g_sql CLIPPED," ORDER BY lua01 "
 
   PREPARE q042_bp FROM g_sql
   DECLARE q042_cur CURSOR FOR q042_bp
 
   CALL g_lua.clear()
   LET l_amt = 0
   LET g_cnt = 1
   FOREACH q042_cur INTO g_lua[g_cnt].*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_amt = l_amt + g_lua[g_cnt].oma571
      SELECT rtz13 INTO g_lua[g_cnt].rtz13_1
        FROM rtz_file
       WHERE rtz01 = g_lua[g_cnt].luaplant_1
 
      SELECT azt02 INTO g_lua[g_cnt].azt02
        FROM azt_file
       WHERE azt01 = g_lua[g_cnt].lualegal
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_lua.deleteElement(g_cnt)
   IF g_cnt= 1 THEN CALL cl_err('','mfg3442',0) END IF
   DISPLAY l_amt TO FORMONLY.amt
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
#FUN-AA0057 ----add---begin--
FUNCTION q042_b1_fill(p_wc1)
DEFINE p_wc1     LIKE type_file.chr1000
 
   LET g_sql = " SELECT ogb01,ogb03,ogbplant,ogb04,ogb12,ogb05,ogb13,ogb14 ",
               "   FROM lua_file,ogb_file ",
               "  WHERE ",p_wc1 CLIPPED,
               "    AND ogb49 = lua06",
               "    AND ogbplant = luaplant ",
               "    AND ogb48 = lua07  "
   LET g_sql = g_sql CLIPPED," ORDER BY ogb01 "
   PREPARE q042_bp1 FROM g_sql
   DECLARE q042_cur1 CURSOR FOR q042_bp1
   CALL g_ogb.clear()
   LET g_cnt1 = 1
   FOREACH q042_cur1 INTO g_ogb[g_cnt1].*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt1 = g_cnt1 + 1
      IF g_cnt1 > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_ogb.deleteElement(g_cnt)
   IF g_cnt1= 1 THEN CALL cl_err('','mfg3442',0) END IF
   LET g_rec_b1 = g_cnt1 - 1
   DISPLAY g_rec_b1 TO FORMONLY.cn3
END FUNCTION
FUNCTION q042_b2_fill(p_wc2)
DEFINE p_wc2     LIKE type_file.chr1000
   LET g_sql = " SELECT ohb01,ohb03,ohbplant,ohb04,ohb12,ohb05,ohb13,ohb14 ",
               "   FROM lua_file,ohb_file ",
               "  WHERE ",p_wc2 CLIPPED,
               "    AND ohb70 = lua06 ",
               "    AND ohbplant = luaplant ",
               "    AND ohb69 = lua07  "
   LET g_sql = g_sql CLIPPED," ORDER BY ohb01 "
   PREPARE q042_bp2 FROM g_sql
   DECLARE q042_cur2 CURSOR FOR q042_bp2
   CALL g_ohb.clear()
   LET g_cnt2 = 1
   FOREACH q042_cur2 INTO g_ohb[g_cnt2].*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt2 = g_cnt2 + 1
      IF g_cnt2 > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_ohb.deleteElement(g_cnt)
   IF g_cnt2= 1 THEN CALL cl_err('','mfg3442',0) END IF
   LET g_rec_b2 = g_cnt2 - 1
   DISPLAY g_rec_b2 TO FORMONLY.cn4
END FUNCTION


#FUN-AA0057 ----add---end--
#No.FUN-960134
