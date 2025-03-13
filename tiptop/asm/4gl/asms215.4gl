# Prog. Version..: '5.30.06-13.03.12(00005)'     #
 
#
# Pattern name...: asms215.4gl
# Descriptions...: 系統參數設定作業–料件
# Date & Author..: 92/12/21 By David 
#                : Rearrange Screen Format and recoding
# Modify.........: No.FUN-560026 05/06/08 By kim 新增參數 sma119 料件編號資料長度
# Modify.........: No.MOD-490327 05/06/09 By Mandy 將 sma609 改成不在 asms215 維護
# Modify.........: No.FUN-570205 05/07/27 By saki 更動料件編號長度後，詢問是否更新zaa資料
# Modify.........: No.FUN-590070 05/09/15 By CoCo 料件在zaa的屬性由'J'改成'N'
# Modify.........: Nl:FUN-5A0126 05/10/19 By echo 更動料件號號長度後時，顯示異動提示訊息，再至p_zaa設定調整，而不直接改變p_zaa中對應屬性的隱藏碼或長度
# Modify.........; NO.FUN-5B0134 05/11/25 BY yiting modify 加上權限判斷 cl_chk_act_auth() 功能
# Modify.........: No.FUN-5A0191 05/12/21 By  修改料件編號長度參數時，若有已有料件長度大於
                               #              要修改的長度時show 警告訊息!
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.CHI-960043 09/08/24 By dxfwo  本作業沒有呼叫cl_used(),當啟動aoos010做記錄時,則無法記錄本支作業的異動情況到p_used中
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-A10135 10/01/19 By Carrier 更改退出时,要恢复原状
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
     DEFINE
        g_msg           LIKE ze_file.ze03,  #No.FUN-690010   VARCHAR(200),               #No.FUN-5A0191 add
        g_sma_t         RECORD LIKE sma_file.*,  # 參數檔
        g_sma_o         RECORD LIKE sma_file.*   # 參數檔
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
MAIN
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
    CALL asms215()
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN  
 
FUNCTION asms215()
    DEFINE
        p_row,p_col LIKE type_file.num5     #No.FUN-690010 SMALLINT
#       l_time        LIKE type_file.chr8          #No.FUN-6A0089
 
 
   IF (NOT cl_user()) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASM")) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.CHI-960043
 
    IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
         LET p_row = 7 LET p_col = 30
    ELSE LET p_row = 4 LET p_col = 10
    END IF
    OPEN WINDOW asms215_w AT p_row,p_col       
        WITH FORM "asm/42f/asms215" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL asms215_show()
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL asms215_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW asms215_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.CHI-960043
END FUNCTION
 
FUNCTION asms215_show()
    SELECT *      
        INTO g_sma.*
        FROM sma_file WHERE sma00 = '0'
    IF SQLCA.sqlcode THEN
#      CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660138
       CALL cl_err3("sel","sma_file",g_sma.sma00,"",SQLCA.sqlcode,"","",0) #No.FUN-660138
       RETURN
    END IF
   #DISPLAY BY NAME g_sma.sma09,g_sma.sma38,g_sma.sma64,g_sma.sma609,g_sma.sma119 #FUN-560026 
     DISPLAY BY NAME g_sma.sma09,g_sma.sma38,g_sma.sma64,g_sma.sma119 #FUN-560026  #MOD-490327 移除sma609
                    
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION asms215_menu()
    MENU ""
    ON ACTION modify 
#NO.FUN-5B0134 START---
       LET g_action_choice="modify"
       IF cl_chk_act_auth() THEN
           CALL asms215_u()
       END IF
#NO.FUN-5B0134 END---
    ON ACTION help 
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    #EXIT MENU
    ON ACTION exit
            LET g_action_choice = "exit"
    EXIT MENU
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
            LET g_action_choice = "exit"
          CONTINUE MENU
    
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
END FUNCTION
 
 
FUNCTION asms215_u()
   DEFINE   li_len   LIKE type_file.num5   #No.FUN-690010 SMALLINT                     #No.FUN-570205
   DEFINE   l_gae04  LIKE gae_file.gae04          #No.FUN-5A0126
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_forupd_sql =
      "SELECT *  FROM sma_file ",  
      "  WHERE sma00 = ?        ",
      " FOR UPDATE             "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE sma_curl CURSOR FROM g_forupd_sql
    BEGIN WORK
    OPEN sma_curl USING '0'
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('open cursor',SQLCA.sqlcode,1)
       RETURN
    END IF
    FETCH sma_curl INTO g_sma.*
    IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_sma_o.* = g_sma.*
    LET g_sma_t.* = g_sma.*
    DISPLAY BY NAME g_sma.sma09,g_sma.sma38,g_sma.sma64,g_sma.sma119 #FUN-560026
                    
    WHILE TRUE
        CALL asms215_i()
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_sma.*=g_sma_t.*      #No.TQC-A10135                           
            CALL asms215_show()        #No.TQC-A10135
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE sma_file SET
              sma09=g_sma.sma09,
              sma38=g_sma.sma38,
              sma64=g_sma.sma64,
              #sma609=g_sma.sma609, #MOD-490327 MARK
              sma119=g_sma.sma119 #FUN-560026
            WHERE sma00='0'
        IF SQLCA.sqlcode THEN
#           CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660138
            CALL cl_err3("upd","sma_file",g_sma.sma00,"",SQLCA.sqlcode,"","",0) #No.FUN-660138
            CONTINUE WHILE
        #No.FUN-570205 --start--
        ELSE
           IF (g_sma.sma119 != g_sma_t.sma119) OR cl_null(g_sma_t.sma119) THEN
              #FUN-5A0126
              #CASE g_sma.sma119
              #   WHEN "0"
              #      LET li_len = 20
              #   WHEN "1"
              #      LET li_len = 30
              #   WHEN "2"
              #      LET li_len = 40
              #END CASE
              ##CALL cl_prt_type_list("J","",li_len,"Y","","") ### FUN-590070 ###
              #CALL cl_prt_type_list("N","",li_len,"Y","","") ### FUN-590070 ###
 
              SELECT gae04 INTO l_gae04 FROM gae_file where gae01='p_zaa' AND
                 gae02='zaa14_N' AND gae03=g_lang
              CALL cl_err_msg("",'lib-303',l_gae04 CLIPPED || "|" || "N" || "|" || l_gae04 CLIPPED,1) 
              #END FUN-5A0126
           END IF
        #No.FUN-570205 ---end---
        END IF
        UNLOCK TABLE sma_file
        EXIT WHILE
    END WHILE
    CLOSE sma_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION asms215_i()
 
  #INPUT BY NAME g_sma.sma09,g_sma.sma38,g_sma.sma64,g_sma.sma609,g_sma.sma119 WITHOUT DEFAULTS #FUN-560026
    INPUT BY NAME g_sma.sma09,g_sma.sma38,g_sma.sma64,g_sma.sma119 WITHOUT DEFAULTS #FUN-560026 #MOD-490327 移除sma609
 
      AFTER FIELD sma09
         IF NOT cl_null(g_sma.sma09) THEN
             IF g_sma.sma09 NOT MATCHES '[YN]' THEN
                LET g_sma.sma09=g_sma_o.sma09
                DISPLAY BY NAME g_sma.sma09
                NEXT FIELD sma09
             END IF
             LET g_sma_o.sma09=g_sma.sma09
         END IF
 
      AFTER FIELD sma38
         IF NOT cl_null(g_sma.sma38) THEN
             IF g_sma.sma38 NOT MATCHES '[YN]' THEN
                LET g_sma.sma38=g_sma_o.sma38
                DISPLAY BY NAME g_sma.sma38
                NEXT FIELD sma38
             END IF
             LET g_sma_o.sma38=g_sma.sma38
         END IF
 
      AFTER FIELD sma64
         IF NOT cl_null(g_sma.sma64) THEN
             IF g_sma.sma64 NOT MATCHES '[YN]' THEN
                LET g_sma.sma64=g_sma_o.sma64
                DISPLAY BY NAME g_sma.sma64
                NEXT FIELD sma64
             END IF
             LET g_sma_o.sma64=g_sma.sma64
         END IF
      #MOD-490327 MARK
     #AFTER FIELD sma609 
     #   IF NOT cl_null(g_sma.sma609) THEN
     #       IF g_sma.sma609 NOT MATCHES '[YN]' THEN
     #          LET g_sma.sma609=g_sma_o.sma609
     #          DISPLAY BY NAME g_sma.sma609 
     #          NEXT FIELD sma609
     #       END IF
     #       LET g_sma_o.sma64=g_sma.sma64
     #   END IF
 
      #FUN-560026................begin
      #AFTER FIELD sma119    #No.FUN-5A0191 mark
      ON CHANGE sma119       #No.FUN-5A0191 add
         IF NOT cl_null(g_sma.sma119) THEN
             IF g_sma.sma119 NOT MATCHES '[012]' THEN
                LET g_sma.sma119=g_sma_o.sma119
                DISPLAY BY NAME g_sma.sma119 
                NEXT FIELD sma119
             END IF
#-------No.FUN-5A0191 add
              CALL s215_sma119()
              IF NOT cl_null(g_msg) THEN
                 CALL cl_err(g_msg,'!',1)
              END IF
              LET g_sma_o.sma119=g_sma.sma119
#-------No.FUN-5A0191 mark
 
         END IF
      #FUN-560026................end
 
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
 
#-----------No.FUN-5A0191 add
FUNCTION s215_sma119()
DEFINE l_leng   LIKE type_file.num5    #No.FUN-690010    SMALLINT
 
   LET l_leng = 0
   LET g_msg = NULL
   SELECT MAX(LENGTH(ima01)) INTO l_leng FROM ima_file
   CASE g_sma.sma119
        WHEN '0' 
             IF g_sma_o.sma119 MATCHES '[12]' AND l_leng > 20 THEN
                CALL cl_getmsg('asm-410',g_lang) RETURNING g_msg
                LET g_msg = g_msg CLIPPED,"20"
             END IF
        WHEN '1' 
             IF g_sma_o.sma119 MATCHES '[12]' AND l_leng > 30 THEN
                CALL cl_getmsg('asm-410',g_lang) RETURNING g_msg
                LET g_msg = g_msg CLIPPED,"30"
             END IF
   END CASE
END FUNCTION
#-----------No.FUN-5A0191 end
