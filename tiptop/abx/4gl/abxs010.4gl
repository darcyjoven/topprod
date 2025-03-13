# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: abxs010.4gl
# Descriptions...: 保稅BOM 核備文號維護作業
# Date & Author..: 96/09/11 By Star 
# Modify ........: No.MOD-490368 By Melody 按更改鍵修改 BOM編號字首後, 未存起來, 重新查詢還是回覆原狀
# Modify.........: No.FUN-660052 05/06/14 By ice cl_err3訊息修改
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.MOD-840155 08/04/20 By Carol 資料異動SQL調整
# Modify.........: No.MOD-940105 09/04/08 By lutingting 若bni_file沒有資料時,會無法修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   離開MAIN時沒有cl_used(1)和cl_used(2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
     DEFINE
        g_bni_t         RECORD LIKE bni_file.*,  # 預留參數檔
        g_bni_o         RECORD LIKE bni_file.*   # 預留參數檔
DEFINE p_row,p_col     LIKE type_file.num5       #No.FUN-680062 smallint
DEFINE g_forupd_sql    STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_bni           RECORD LIKE bni_file.*   #保稅BOM核備文號檔
 
MAIN
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF

    CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211 
    #取得有關語言及日期型態的資料
    SELECT * INTO g_aza.* FROM aza_file
    IF SQLCA.sqlcode THEN 
       CALL cl_err('abxs010',9006,3)
       EXIT PROGRAM
    END IF
 
#   #取得使用者及其所屬部門之資料
#   CALL cl_user()
#
#   #取得權限資料
#   SELECT zy03,zy04,zy05 INTO g_priv1,g_priv2,g_priv3
#          FROM zy_file
#          WHERE zy01 = g_clas AND zy02 = 'abxs010'
#   IF SQLCA.sqlcode THEN EXIT PROGRAM END IF
 
    CALL s010(4,13)
    CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN  
 
FUNCTION s010(p_row,p_col)
    DEFINE
        p_row,p_col LIKE type_file.num5          #No.FUN-680062 smallint
#       l_time      LIKE type_file.chr8          #No.FUN-6A0062
 
    LET p_row = 5 LET p_col = 12
    OPEN WINDOW s010_w AT p_row,p_col WITH FORM "abx/42f/abxs010" 
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL s010_show()
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL s010_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW s010_w
END FUNCTION
 
FUNCTION s010_show()
    DEFINE   l_year LIKE type_file.chr3                #No.FUN-680062   VARCHAR(3)   
    DEFINE   l_cnt  LIKE type_file.num5                #MOD-840155-add
#MOD-840155-modify
#   SELECT * INTO g_bni.* FROM bni_file    
#   IF SQLCA.sqlcode OR g_bni.bni01 IS NULL THEN
    LET l_cnt = 0
    INITIALIZE g_bni_t.*,g_bni.* TO NULL
    SELECT * INTO g_bni.* FROM bni_file    
    SELECT COUNT(*) INTO l_cnt FROM bni_file    
    LET g_bni_t.* = g_bni.*
    IF l_cnt = 0 THEN 
#MOD-840155-modify-end
        LET l_year = YEAR(g_today)-1911 USING '<<<'
        LET g_bni.bni01 = "鴻字第(",l_year CLIPPED , ")"
        LET g_bni.bni02 = "0001"
        LET g_bni.bni03 = "號"
        #IF SQLCA.sqlcode THEN     #MOD-940105
           INSERT INTO bni_file(bni01,bni02,bni03)
                  VALUES (g_bni.bni01,g_bni.bni02,g_bni.bni03) 
           IF SQLCA.sqlcode THEN
#             CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660052
              CALL cl_err3("ins","bni_file",g_bni.bni01,g_bni.bni02,SQLCA.sqlcode,"","",0) 
              RETURN
           END IF
    ELSE
           UPDATE bni_file 
              SET bni01 = g_bni.bni01,
                  bni02 = g_bni.bni02,
                  bni03 = g_bni.bni03
#MOD-840155-add
            WHERE bni01 = g_bni_t.bni01
              AND bni02 = g_bni_t.bni02
              AND bni03 = g_bni_t.bni03
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#MOD-840155-add-end
#             CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660052
              CALL cl_err3("upd","bni_file","","",SQLCA.sqlcode,"","",0) 
              RETURN
           END IF
    END IF
#No.FUN-660052 --Begin
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('',SQLCA.sqlcode,0)
#          RETURN
#       END IF
#No.FUN-660052 --End
    #END IF      #MOD-940105
    DISPLAY BY NAME g_bni.bni01,g_bni.bni02,g_bni.bni03
                    
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION s010_menu()
    MENU ""
    ON ACTION modify 
       LET g_action_choice = "modify"
       IF cl_chk_act_auth() THEN
          CALL s010_u()
       END IF
    ON ACTION locale
       CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#      EXIT MENU
    ON ACTION exit
       LET g_action_choice = "exit"
       EXIT MENU
    ON ACTION CONTROLG
       CALL cl_cmdask()
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
       LET g_action_choice = "exit"
       CONTINUE MENU
    
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
END FUNCTION
 
 
FUNCTION s010_u()
   IF s_shut(0) THEN
      RETURN 
   END IF
   CALL cl_opmsg('u')
   #檢查是否有更改的權限
   MESSAGE ""
 
   LET g_forupd_sql = "SELECT * FROM bni_file FOR UPDATE"    
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE bni_curl CURSOR FROM g_forupd_sql   
 
   BEGIN WORK
   OPEN bni_curl 
   IF STATUS  THEN CALL cl_err('OPEN bni_curl',STATUS,1) RETURN END IF         
   FETCH bni_curl INTO g_bni.*
   IF STATUS  THEN CALL cl_err('',STATUS,0) RETURN END IF            
 
   IF SQLCA.sqlcode  THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      RETURN
   END IF
   LET g_bni_t.* = g_bni.*
   LET g_bni_o.* = g_bni.*
   DISPLAY BY NAME g_bni.bni01,g_bni.bni02,g_bni.bni03
                   
   WHILE TRUE
      CALL s010_i()
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         LET g_bni.* = g_bni_t.*
         CALL s010_show()
         EXIT WHILE
      END IF
      UPDATE bni_file SET
             bni01=g_bni.bni01,
             bni02=g_bni.bni02,
             bni03=g_bni.bni03
#MOD-840155-add
       WHERE bni01 = g_bni_t.bni01
         AND bni02 = g_bni_t.bni02
         AND bni03 = g_bni_t.bni03
#MOD-840155-add-end
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #MOD-840155-modify
#        CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660052
         CALL cl_err3("upd","bni_file","","",SQLCA.sqlcode,"","",0) 
         CONTINUE WHILE
      END IF
      CLOSE bni_curl
      EXIT WHILE
   END WHILE
    COMMIT WORK  #No.MOD-490368
END FUNCTION
 
FUNCTION s010_i()
   DEFINE l_aza LIKE type_file.chr1          #No.FUN-680062      VARCHAR(1)
   INPUT BY NAME g_bni.bni01,g_bni.bni02,g_bni.bni03 WITHOUT DEFAULTS 
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
   END INPUT
END FUNCTION
