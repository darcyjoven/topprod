# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: apcs010.4gl
# Descriptions...: POS接口參數設定作業
# Date & Author..: 10/03/24 by Cockroach 
# Modify.........: No.FUN-A30087 10/03/25 By Cockroach  
# Modify.........: No.FUN-A50068 10/05/19 By Cockroach   添加POS單據編號和POS上傳系統編碼原則
# Modify.........: No.FUN-B30202 11/03/31 By huangtao 加入 POS會員銷售資料上傳否 
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   1、離開MAIN時沒有cl_used(1)和cl_used(2)
#                                                           2、未加離開前得cl_used(2)
# Modify.........: No.FUN-B80099 11/08/11 By huangtao 加入訂單上傳是否自動轉請購單
# Modify.........: No.FUN-BC0062 12/02/15 By lilingyu 增加控管成本計算方式
# Modify.........: No.FUN-C50090 12/08/03 By baogc 相關欄位隱藏
# Modify.........: No.FUN-C80045 12/08/16 By nanbing 加入ryz10控管 
# Modify.........: No.FUN-C90039 12/09/10 By baogc 分佈上傳營運中心判斷邏輯調整
# Modify.........: No.FUN-CA0091 12/10/26 By baogc 添加欄位"上傳批量提交數量"

DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE g_ryz           RECORD LIKE ryz_file.*,  # 參數檔
       g_ryz_o         RECORD LIKE ryz_file.*   # 參數檔
DEFINE g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5    
 
MAIN
 
   OPTIONS 
      INPUT NO WRAP
   DEFER INTERRUPT 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211 
   CALL apcs010()
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN  
 
FUNCTION apcs010()
DEFINE p_row,p_col LIKE type_file.num5     # SMALLINT
DEFINE cb          ui.ComboBox  #FUN-C50090 Add
 
   IF (NOT cl_user()) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APC")) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  
 
   LET p_row = 5 LET p_col = 35
 
   OPEN WINDOW apcs010_w AT p_row,p_col
     WITH FORM "apc/42f/apcs010" 
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   
   CALL cl_ui_init()

  #FUN-C50090 Add Begin ---
   LET cb = ui.ComboBox.forName("ryz02")
   CALL cb.removeItem('1')
   CALL cl_set_comp_visible('ryz08',FALSE)
  #FUN-C50090 Add End -----
 
   CALL apcs010_show()
 
   LET g_action_choice=""
   CALL apcs010_menu()
 
   CLOSE WINDOW apcs010_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
END FUNCTION
 
FUNCTION apcs010_show()
DEFINE   l_n    LIKE type_file.num5
DEFINE   l_flag LIKE type_file.chr1  #FUN-A50068    
   
   SELECT COUNT(*) INTO l_n FROM ryz_file
   IF l_n=0 THEN 
      RETURN
   END IF  
   SELECT * INTO g_ryz.*
     FROM ryz_file
    WHERE ryz01 = '0'
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","ryz_file","","",SQLCA.sqlcode,"","",0) 
      RETURN
   END IF
 
   DISPLAY BY NAME g_ryz.ryz02,g_ryz.ryz03,g_ryz.ryz04,g_ryz.ryz05,  #FUN-A50068
                   g_ryz.ryz06,g_ryz.ryz07
                   ,g_ryz.ryz08                                  #FUN-B30202 add
                   ,g_ryz.ryz09                                  #FUN-B80099 add
                   ,g_ryz.ryz10                                  #FUN-C80045 add
                   ,g_ryz.ryz11                                  #FUN-CA0091 Add
   CALL s010_chk_result1() RETURNING l_flag     #FUN-A50068 ADD
   CALL cl_show_fld_cont()                  
 
END FUNCTION
 
FUNCTION apcs010_menu()
 
   MENU ""
      ON ACTION modify 
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL apcs010_u()
         END IF
 
      ON ACTION help 
         CALL cl_show_help()
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()            
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
      
      ON ACTION about         
         CALL cl_about()     
     
      ON ACTION controlg    
         CALL cl_cmdask()  
      
      LET g_action_choice = "exit"
      CONTINUE MENU
      
      -- for Windows close event trapped
      ON ACTION close   #COMMAND KEY(INTERRUPT)  
         LET INT_FLAG=FALSE       
         LET g_action_choice = "exit"
         EXIT MENU
 
   END MENU
 
END FUNCTION

FUNCTION s010_format()
   DEFINE l_n         LIKE type_file.num5
 
   BEGIN WORK
      SELECT COUNT(*) INTO l_n FROM ryz_file
      IF l_n=0 THEN
#FUN-B80099 ------------------STA
#        INSERT INTO ryz_file(ryz01,ryzcrat,ryzuser,ryzgrup,ryzorig,ryzoriu)
#                      VALUES('0'  ,g_today,g_user ,g_grup ,g_grup ,g_user)
         INSERT INTO ryz_file(ryz01,ryz02,ryz04,ryz05,ryz06,ryz07,ryz08,ryz09,ryzcrat,ryzuser,ryzgrup,ryzorig,ryzoriu,ryz10,ryz11) #FUN-C80045 add ryz10 #FUN-CA0091 Add ryz11
                       VALUES('0' ,' ',' ',' ',' ','N','N','N',g_today,g_user ,g_grup ,g_grup ,g_user,'N',0) #FUN-C80045 add ryz10 #FUN-CA0091 Add 0
#FUN-B80099 ------------------END
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ryz_file","","",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN
      #  ELSE
      #     COMMIT WORK
         END IF
      END IF
END FUNCTION
 
FUNCTION apcs010_u()
DEFINE   l_flag LIKE type_file.chr1  #FUN-A50068    

   MESSAGE ""
   CALL cl_opmsg('u')
   
   CALL s010_format()
   LET g_forupd_sql = "SELECT * FROM ryz_file",
                      "  WHERE ryz01 = ?",
                      "   FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE ryz_curl CURSOR FROM  g_forupd_sql
 
   BEGIN WORK
 
   OPEN ryz_curl USING '0'
 
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('open cursor',SQLCA.sqlcode,1)
      RETURN
   END IF
 
   FETCH ryz_curl INTO g_ryz.*
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      RETURN
   END IF
 
   LET g_ryz_o.* = g_ryz.*
 
   DISPLAY BY NAME g_ryz.ryz02,g_ryz.ryz03,g_ryz.ryz04,g_ryz.ryz05,  #FUN-A50068
                   g_ryz.ryz06,g_ryz.ryz07
                   ,g_ryz.ryz08                            #FUN-B30202 add
                   ,g_ryz.ryz09                            #FUN-B80099 add
                   ,g_ryz.ryz10                            #FUN-C80045 add
                   ,g_ryz.ryz11                            #FUN-CA0091 Add
   WHILE TRUE
      CALL apcs010_i()
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_ryz.* = g_ryz_o.* 
         CALL apcs010_show()     
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      CALL s010_chk_result1() RETURNING l_flag     #FUN-A50068 ADD
      IF l_flag = 'N' THEN CONTINUE WHILE END IF   #FUN-A50068 ADD

      UPDATE ryz_file SET ryz02 = g_ryz.ryz02,
                          ryz03 = g_ryz.ryz03,  #FUN-A50068 ADD
                          ryz04 = g_ryz.ryz04,  #FUN-A50068 ADD
                          ryz05 = g_ryz.ryz05,  #FUN-A50068 ADD
                          ryz06 = g_ryz.ryz06,  #FUN-A50068 ADD
                          ryz07 = g_ryz.ryz07,  #FUN-A50068 ADD
                          ryz08 = g_ryz.ryz08,  #FUN-B30202 add
                          ryz09 = g_ryz.ryz09,  #FUN-B80099 add
                          ryz10 = g_ryz.ryz10,  #FUN-C80045 add 
                          ryz11 = g_ryz.ryz11,  #FUN-CA0091 Add
                          ryzmodu=g_user,
                          ryzdate=g_today
       WHERE ryz01 = '0'
 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","ryz_file","","",SQLCA.sqlcode,"","",0) 
         CONTINUE WHILE
      ELSE 
         COMMIT WORK
      END IF
 
      UNLOCK TABLE ryz_file
      EXIT WHILE
   END WHILE
   CLOSE ryz_curl
 
END FUNCTION
 
FUNCTION apcs010_i()
   DEFINE   l_flag LIKE type_file.chr1  #FUN-A50068    
   DEFINE   l_sql STRING                #FUN-C80045  
   DEFINE   l_cnt LIKE type_file.num5   #FUN-C80045
 #FUN-A50068 MARK&ADD----------
 # INPUT g_ryz.ryz02
 #       WITHOUT DEFAULTS 
 #  FROM ryz02
        
 #  INPUT BY NAME g_ryz.ryz02,g_ryz.ryz07,g_ryz.ryz03,g_ryz.ryz04,g_ryz.ryz05,g_ryz.ryz06              #FUN-B30202 mark
    INPUT BY NAME g_ryz.ryz02,g_ryz.ryz08,g_ryz.ryz09,g_ryz.ryz11,g_ryz.ryz10,g_ryz.ryz07,g_ryz.ryz03,g_ryz.ryz04,g_ryz.ryz05,g_ryz.ryz06  #FUN-B30202 add   #FUN-B80099 add #FUN-C80045 add ryz10 #FUN-CA0091 Add ryz11
       WITHOUT DEFAULTS
 #FUN-A50068 END---------------

      BEFORE INPUT
         LET g_before_input_done = FALSE
      #  CALL s010_set_entry()
      #  CALL s010_set_no_entry()
         LET g_before_input_done = TRUE
         CALL s010_set_entry_ryz03('d') 
         #FUN-C80045 add
         IF g_ryz.ryz10 = 'Y' THEN 
            CALL cl_set_comp_entry("ryz07",FALSE)
         ELSE 
            CALL cl_set_comp_entry("ryz07",TRUE)
         END IF    
         #FUN-C80045 add
      AFTER FIELD ryz02
         IF NOT cl_null(g_ryz.ryz02) AND g_ryz.ryz02 <> g_ryz_o.ryz02 THEN
            IF g_ryz.ryz02 NOT MATCHES "[12]" THEN
               LET g_ryz.ryz02=g_ryz_o.ryz02
               DISPLAY BY NAME g_ryz.ryz02
               NEXT FIELD ryz02
            END IF
         END IF
     #FUN-CA0091 Add begin ---
      AFTER FIELD ryz11 
         IF NOT cl_null(g_ryz.ryz11) THEN
            IF g_ryz.ryz11 < 0 THEN
               CALL cl_err('','axm-179',0) #不可小于0
               NEXT FIELD ryz11
            END IF 
            IF NOT cl_null(g_ryz.ryz06) AND g_ryz.ryz06 = '5' AND g_ryz.ryz11 > 1 THEN
               CALL cl_err('','apc1050',0) #上传提交笔数大于1时自动编号方式不可设定为5.依年月日时分秒毫秒
               NEXT FIELD ryz11
            END IF
         END IF
     #FUN-CA0091 Add End -----
      #FUN-C80045 add
      ON CHANGE ryz10
         IF g_ryz.ryz10 = 'Y' THEN 
            LET g_ryz.ryz07 = 'Y' 
            CALL cl_set_comp_entry("ryz07",FALSE)
            CALL s010_set_entry_ryz03('a')
            DISPLAY BY NAME g_ryz.ryz07
         ELSE 
            CALL cl_set_comp_entry("ryz07",TRUE)
         END IF    
      #FUN-C80045 add
      #FUN-A50068-------------------------------------
      ON CHANGE ryz07
         CALL s010_set_entry_ryz03('a')
     
      AFTER FIELD ryz06
        IF cl_null(g_ryz.ryz06) THEN
           NEXT FIELD CURRENT
        ELSE
           IF g_ryz.ryz06 NOT MATCHES '[12345]' THEN
              NEXT FIELD CURRENT
           END IF
        END IF
        #FUN-C80045 sta
        CALL s010_chk_result1() RETURNING l_flag
        IF l_flag = 'N' THEN
           NEXT FIELD CURRENT
        END IF
        #FUN-C80045 end
       #FUN-CA0091 Add Begin ---
        IF NOT cl_null(g_ryz.ryz06) AND g_ryz.ryz06 = '5' AND NOT cl_null(g_ryz.ryz11) AND g_ryz.ryz11 > 1 THEN
           CALL cl_err('','apc1050',0) #上传提交笔数大于1时自动编号方式不可设定为5.依年月日时分秒毫秒
           NEXT FIELD ryz06
        END IF
       #FUN-CA0091 Add End -----
      BEFORE FIELD ryz03
        CALL s010_set_entry_ryz03('d')

      AFTER FIELD ryz03
        IF cl_null(g_ryz.ryz03) THEN
           NEXT FIELD CURRENT
        ELSE
           #IF g_ryz_o.ryz03 IS NULL OR (g_ryz.ryz03 <> g_ryz_o.ryz03) THEN #FUN-C80045 mark 
           IF g_ryz_o.ryz03 IS NULL OR g_ryz.ryz03 <> g_ryz_o.ryz03 OR g_ryz_o.ryz03 = 0 THEN #FUN-C80045 add
              IF g_ryz.ryz07 = 'Y' THEN
             #編碼長度 1~8
                  IF g_ryz.ryz03 < 1 OR g_ryz.ryz03 > 8 THEN
                     CALL cl_err('','aoo-500',1) #輸入範圍為 1~8
                     NEXT FIELD CURRENT
                  END IF
               END IF
               #FUN-C80045 add ---
               IF g_ryz.ryz10 = 'Y' THEN
                  LET l_cnt = 0
                 #FUN-C90039 Mark&Add Begin ---
                 ##檢查所有plant在當前碼長下不重複
                 #LET l_sql = "SELECT COUNT(rtz01[1,",g_ryz.ryz03,"]) FROM rtz_file ",
                 #            " WHERE rtz28 = 'Y' ",
                 #            " GROUP BY rtz01[1,",g_ryz.ryz03,"] HAVING COUNT(*) > 1"  
                 #PREPARE rtz01_p1 FROM l_sql
                 #EXECUTE rtz01_p1 INTO l_cnt
                  #檢查POS傳輸營運中心維護作業(apci020)中維護的營運中心在當前碼長下是否重複
                  LET l_sql = "SELECT COUNT(ryg01[1,",g_ryz.ryz03,"]) FROM ryg_file ",
                              " GROUP BY ryg01[1,",g_ryz.ryz03,"] HAVING COUNT(*) > 1"
                  PREPARE sel_ryg01_pre1 FROM l_sql
                  EXECUTE sel_ryg01_pre1 INTO l_cnt
                 #FUN-C90039 Mark&Add End -----
                  IF l_cnt > 0 THEN 
                     CALL cl_err('','apc1029',0)
                     NEXT FIELD CURRENT
                  END IF
               END IF
               #FUN-C80045 add ---          
               CALL s010_chk_result1() RETURNING l_flag
               IF l_flag = 'N' THEN
                  NEXT FIELD CURRENT
               END IF
           END IF
        END IF
        CALL s010_chk_result1() RETURNING l_flag

      AFTER FIELD ryz04
        CALL s010_chk_result1() RETURNING l_flag
        IF l_flag = 'N' THEN
           NEXT FIELD CURRENT
        END IF

      AFTER FIELD ryz05
        CALL s010_chk_result1() RETURNING l_flag
        IF l_flag = 'N' THEN
           NEXT FIELD CURRENT
        END IF
     #FUN-A50068------------------------------------------

      AFTER INPUT
         IF INT_FLAG THEN
            LET g_ryz.*=g_ryz_o.*  #FUN-A50068
            EXIT INPUT
#FUN-BC0062 --begin--
         ELSE
            SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00 = '0'
            IF g_ccz.ccz28 = '6' THEN
               IF cl_null(g_ryz.ryz08) OR g_ryz.ryz08 = 'N' THEN
                  CALL cl_err('','apm-938',1)
                  NEXT FIELD ryz08
               END IF
            END IF
#FUN-BC0062 --end--
         END IF
         #FUN-C80045 add sta
         IF g_ryz.ryz07 = 'Y' AND g_ryz.ryz03 = '0' THEN
            CALL cl_err('','aoo-500',0) #輸入範圍為 1~8
            NEXT FIELD ryz03
         END IF  
         IF g_ryz.ryz10 = 'Y' THEN
            LET l_cnt = 0
           #FUN-C90039 Mark&Add Begin ---
           #LET l_sql = "SELECT COUNT(rtz01[1,",g_ryz.ryz03,"]) FROM rtz_file ",
           #            " WHERE rtz28 = 'Y' ",
           #            " GROUP BY rtz01[1,",g_ryz.ryz03,"] HAVING COUNT(*) > 1"
           #PREPARE rtz01_p2 FROM l_sql
           #EXECUTE rtz01_p2 INTO l_cnt
            #檢查POS傳輸營運中心維護作業(apci020)中維護的營運中心在當前碼長下是否重複
            LET l_sql = "SELECT COUNT(ryg01[1,",g_ryz.ryz03,"]) FROM ryg_file ",
                        " GROUP BY ryg01[1,",g_ryz.ryz03,"] HAVING COUNT(*) > 1"
            PREPARE sel_ryg01_pre2 FROM l_sql
            EXECUTE sel_ryg01_pre2 INTO l_cnt
           #FUN-C90039 Mark&Add End -----
            IF l_cnt > 0 THEN
               CALL cl_err('','apc1029',0)
               NEXT FIELD ryz03 
            END IF
         END IF
         #FUN-C80045 add end
 
 
         IF  cl_null(g_ryz.ryz02) OR g_ryz.ryz02 NOT MATCHES '[12]' THEN
            NEXT FIELD ryz02
         END IF

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
            
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      
      ON ACTION about         
         CALL cl_about()      
      
      ON ACTION help          
         CALL cl_show_help()  
 
   END INPUT
 
END FUNCTION
 
#FUN-A50068 by Cockroach -----------------------------(S)
#POS系統編入 Plant Code (ryz07)如勾選起來，則 一定要輸入碼長 ( ryz03 )，輸入範圍為 1-8；
#如無勾選，則 ryz03 Default 為 0

FUNCTION s010_set_entry_ryz03(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1

  IF g_ryz.ryz07 = 'Y' THEN
     CALL cl_set_comp_entry("ryz03",TRUE)
     CALL cl_set_comp_required("ryz03",TRUE)
  ELSE
     CALL cl_set_comp_entry("ryz03",FALSE)
     CALL cl_set_comp_required("ryz03",FALSE)
     IF p_cmd = 'a' THEN
        LET g_ryz.ryz03 = 0
        DISPLAY BY NAME g_ryz.ryz03
     END IF
  END IF

END FUNCTION

#檢查碼數 + 預覽
#IF (系統單別位數(ryz04) + 1 + POS系統Plant Code碼長(ryz03) + 系統單號位數(ryz05) ) > 20
#則跳出錯誤訊息，POS系統單據編碼超出範圍(20碼)

FUNCTION s010_chk_result1()
DEFINE i               LIKE type_file.num5
DEFINE l_ryz04_length  LIKE type_file.num5
DEFINE l_ryz05_length  LIKE type_file.num5
DEFINE l_result        LIKE type_file.chr100

   CASE g_ryz.ryz04
     WHEN "1" LET l_ryz04_length = 3
     WHEN "2" LET l_ryz04_length = 4
     WHEN "3" LET l_ryz04_length = 5
   END CASE
   CASE g_ryz.ryz05
     WHEN "1" LET l_ryz05_length = 8
     WHEN "2" LET l_ryz05_length = 9
     WHEN "3" LET l_ryz05_length = 10
   END CASE

   IF l_ryz04_length + 1 + l_ryz05_length + g_ryz.ryz03 > 20 THEN
      CALL cl_err('','aoo-501',1) #製造系統單據編碼超出範圍(20碼)
      RETURN 'N'
   END IF
   IF g_ryz.ryz06='5' AND l_ryz04_length + 1 +14+ g_ryz.ryz03 > 20 THEN
      CALL cl_err('','aoo-501',1) #製造系統單據編碼超出範圍(20碼)
      RETURN 'N'
   END IF


   LET l_result = ''
   FOR i = 1 TO l_ryz04_length
       LET l_result = l_result,'X'
   END FOR
   LET l_result = l_result,'-'

   IF g_ryz.ryz03 > 0 THEN
      FOR i = 1 TO g_ryz.ryz03
          LET l_result = l_result,'P'
      END FOR
   END IF

   IF g_ryz.ryz06='5' THEN
      FOR i = 1 TO 14
         LET l_result = l_result,'9'
      END FOR
   ELSE
      FOR i = 1 TO l_ryz05_length
         LET l_result = l_result,'9'
      END FOR
   END IF

   DISPLAY l_result TO result1
   RETURN 'Y'

END FUNCTION
#FUN-A50068-------------------------------------------------
#FUNCTION s010_set_entry()
 
#END FUNCTION
 
#FUNCTION s010_set_no_entry()
 
#END FUNCTION
#FUN-A30087 
