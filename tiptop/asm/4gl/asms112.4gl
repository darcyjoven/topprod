# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: asms112.4gl
# Descriptions...: 製造管理系統參數設定作業–整體參數(三)
# Date & Author..: 91/11/08 By Sara 
# Release 4.0....: 92/07/25 By Jones
# Release 4.0....: 99/06/03 By Iceman FOR sma79 
# Modify.........: 99/12/21 By Carol:sma79 值為 Y/N
# Modify.........: N0.FUN-5B0134 05/11/25 BY yiting modify 加上權限判斷 cl_chk_act_auth() 功能
# Modify.........: FUN-5A0184 05/12/27 By Sarah 將sma61拿掉
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-850115 08/04/25 By Duke add APS整合版本
# Modify.........: No.FUN-870156 08/07/29 BY DUKE add 資源型態 sma917
# Modify.........: No.CHI-960043 09/08/24 By dxfwo  本作業沒有呼叫cl_used(),當啟動aoos010做記錄時,則無法記錄本支作業的異動情況到p_used中
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-BC0059 11/12/16 By Mandy 增加欄位:sma918
# Modify.........: No.FUN-B80093 12/01/05 By pauline 增加VIM選項 
# Modify.........: No.FUN-C60046 12/06/18 By bart 增加使用料件特性功能
# Modify.........: No.TQC-CC0130 12/12/27 By bart 修改輸入順序

DATABASE ds
 
GLOBALS "../../config/top.global"
     DEFINE
        g_sma_t         RECORD LIKE sma_file.*,  # 參數檔
        g_sma_o         RECORD LIKE sma_file.*,  # 參數檔
        m_sma RECORD
              sma30       LIKE sma_file.sma30,
              sma51       LIKE sma_file.sma51,
              sma52       LIKE sma_file.sma52,
              sma53       LIKE sma_file.sma53,
              sma54       LIKE sma_file.sma54,
              sma58       LIKE sma_file.sma58,
              sma59       LIKE sma_file.sma59,
             #sma61       LIKE sma_file.sma61,   #FUN-5A0184 mark
              sma79       LIKE sma_file.sma79,
              sma901      LIKE sma_file.sma901,
              sma916      LIKE sma_file.sma916,   #FUN-850115 mark
              sma917      LIKE sma_file.sma917,    #FUN-870156 add
              sma918      LIKE sma_file.sma918,     #FUN-BC0059 add
              sma93       LIKE sma_file.sma93,     #FUN-B80093 add
              sma94       LIKE sma_file.sma94      #FUN-C60046
          END RECORD
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
MAIN
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
    CALL asms112(0,0)
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN  
 
FUNCTION asms112(p_row,p_col)
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
    LET p_row = 4 LET p_col = 31
 
    OPEN WINDOW asms112_w AT p_row,p_col
      WITH FORM "asm/42f/asms112" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL asms112_show()
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL asms112_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW asms112_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.CHI-960043
END FUNCTION
 
FUNCTION asms112_show()
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00 = '0'
 
    IF SQLCA.sqlcode THEN
#      CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660138
       CALL cl_err3("sel","sma_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660138
       RETURN
    END IF
    DISPLAY BY NAME g_sma.sma30,g_sma.sma51,g_sma.sma52,
                    g_sma.sma53,g_sma.sma54,g_sma.sma58,g_sma.sma59,
                   #g_sma.sma61,g_sma.sma79,g_sma.sma901   #FUN-5A0184 mark
                    g_sma.sma79,g_sma.sma901,              #FUN-5A0184
                    g_sma.sma916,                           #FUN-850115 
                    g_sma.sma917,                           #FUN-870156
                    g_sma.sma918,                            #FUN-BC0059 add
                    g_sma.sma93,                            #FUN-B80093 add
                    g_sma.sma94                             #FUN-C60046
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
#FUN-850115 by duke 080425  --begin
#-依勾選是否與 APS 整合, 顯示/隱藏 APS 整合版本欄位
   CALL cl_set_comp_visible("sma916,sma917,sma918", g_sma.sma901 = 'Y') #FUN-BC0059 add
#FUN-850115 --end--
 
 
 
END FUNCTION
 
FUNCTION asms112_menu()
    MENU ""
         ON ACTION modify 
#NO.FUN-5B0134 START---
          LET g_action_choice="modify"
          IF cl_chk_act_auth() THEN
              CALL asms112_u()
          END IF
#NO.FUN-5B0134 END-----
         ON ACTION help   CALL cl_show_help()
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
 
 
FUNCTION asms112_u()
    MESSAGE ""
    CALL cl_opmsg('u')
 
    LET g_forupd_sql = "SELECT *  FROM sma_file WHERE sma00 = ? FOR UPDATE " 
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
    LET g_sma_t.* = g_sma.*
    LET g_sma_o.* = g_sma.*
    DISPLAY BY NAME g_sma.sma30,g_sma.sma51,g_sma.sma52,
                    g_sma.sma53,g_sma.sma54,g_sma.sma58,g_sma.sma59,
                   #g_sma.sma61,g_sma.sma79,g_sma.sma901   #FUN-5A0184 mark
                    g_sma.sma79,g_sma.sma901,              #FUN-5A0184
                    g_sma.sma916,                           #FUN-850115
                    g_sma.sma917,                           #FUN-870156
                    g_sma.sma918,                            #FUN-BC0059 add
                    g_sma.sma93,                            #FUN-B80093 add
                    g_sma.sma94                             #FUN-C60046
 
    WHILE TRUE
        CALL asms112_i()
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           ROLLBACK WORK
           EXIT WHILE
        END IF
        UPDATE sma_file SET
                sma30=g_sma.sma30,
                sma51=g_sma.sma51,
                sma52=g_sma.sma52,
                sma53=g_sma.sma53,
                sma54=g_sma.sma54,
                sma58=g_sma.sma58,
                sma59=g_sma.sma59,
               #sma61=g_sma.sma61,   #FUN-5A0184 mark
                sma79=g_sma.sma79,
                sma901=g_sma.sma901,
                sma916=g_sma.sma916,  #FUN-850115 mark
                sma917=g_sma.sma917,   #FUN-870156
                sma918=g_sma.sma918,    #FUN-BC0059 add
                sma93 = g_sma.sma93,    #FUN-B80093 add
                sma94 = g_sma.sma94     #FUN-C60046
                WHERE sma00='0'
        IF SQLCA.sqlcode THEN
#           CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660138
            CALL cl_err3("upd","sma_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660138
            CONTINUE WHILE
        END IF
        UNLOCK TABLE sma_file
        EXIT WHILE
    END WHILE
    CLOSE sma_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION asms112_i()
   INPUT BY NAME g_sma.sma30,g_sma.sma51,g_sma.sma52,
                #g_sma.sma53,g_sma.sma61,g_sma.sma54,   #FUN-5A0184 mark
                 g_sma.sma53,g_sma.sma54,               #FUN-5A0184
                 g_sma.sma58,g_sma.sma59,g_sma.sma79,
                 g_sma.sma93,                           #FUN-B80093 add #TQC-CC0130
                 g_sma.sma94,                            #FUN-C60046 #TQC-CC0130
                 g_sma.sma901,
                 g_sma.sma916,                          #FUN-850115 
                 g_sma.sma917,                          #FUN-870156  
                 g_sma.sma918                           #FUN-BC0059 add

                 WITHOUT DEFAULTS          
 
      AFTER FIELD sma54
         IF NOT cl_null(g_sma.sma54) THEN
            IF g_sma.sma54 NOT MATCHES "[YN]" THEN
               LET g_sma.sma54=g_sma_o.sma54
               DISPLAY BY NAME g_sma.sma54
               NEXT FIELD sma54
            END IF
         END IF
         LET g_sma_o.sma54=g_sma.sma54
 
      AFTER FIELD sma58
         IF NOT cl_null(g_sma.sma58) THEN
            IF g_sma.sma58 NOT MATCHES "[YN]" THEN
               LET g_sma.sma58=g_sma_o.sma58
               DISPLAY BY NAME g_sma.sma58
               NEXT FIELD sma58
            END IF
         END IF
         LET g_sma_o.sma58=g_sma.sma58
 
      AFTER FIELD sma59
         IF NOT cl_null(g_sma.sma59) THEN
            IF g_sma.sma59 NOT MATCHES "[YN]" THEN
               LET g_sma.sma59=g_sma_o.sma59
               DISPLAY BY NAME g_sma.sma59
               NEXT FIELD sma59
            END IF
         END IF
         LET g_sma_o.sma59=g_sma.sma59
 
     #start FUN-5A0184 mark
     #AFTER FIELD sma61
     #   IF NOT cl_null(g_sma.sma61) THEN
     #      IF g_sma.sma61 NOT MATCHES "[12]"  THEN
     #         LET g_sma.sma61=g_sma_o.sma61
     #         DISPLAY BY NAME g_sma.sma61
     #         NEXT FIELD sma61
     #      END IF
     #   END IF
     #   LET g_sma_o.sma61=g_sma.sma61
     #end FUN-5A0184 mark
 
      AFTER FIELD sma79 
         IF NOT cl_null(g_sma.sma79) THEN 
            IF g_sma.sma79 NOT MATCHES "[YN]" THEN
               LET g_sma.sma79=g_sma_o.sma79 
               DISPLAY BY NAME g_sma.sma79 
               NEXT FIELD sma79 
            END IF
         END IF
         LET g_sma_o.sma79=g_sma.sma79 
 
      AFTER FIELD sma901
         IF NOT cl_null(g_sma.sma901) THEN 
            IF g_sma.sma901 NOT MATCHES "[YN]"  THEN
               LET g_sma.sma901=g_sma_o.sma901
               DISPLAY BY NAME g_sma.sma901
               LET g_sma.sma916=g_sma_o.sma916  #FUN-850115 add
               DISPLAY BY NAME g_sma.sma916     #FUN-850115 add
               LET g_sma.sma917=g_sma_o.sma917  #FUN-870156
               LET g_sma.sma918=g_sma_o.sma918  #FUN-BC0059 add
               DISPLAY BY NAME g_sma.sma917     #FUN-870156
               DISPLAY BY NAME g_sma.sma918     #FUN-BC0059 add
               NEXT FIELD sma901
            END IF
         END IF
         LET g_sma_o.sma901=g_sma.sma901
         LET g_sma_o.sma916=g_sma.sma916       #FUN-850115  add
         LET g_sma_o.sma917=g_sma.sma917       #FUN-870156  add
         LET g_sma_o.sma918=g_sma.sma918       #FUN-BC0059  add
 
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
 
 
 
 
 
