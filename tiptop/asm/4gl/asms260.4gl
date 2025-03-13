# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asms260.4gl
# Descriptions...: 系統參數設定作業 MPS/MRP
# Date & Author..: 92/12/24 By Keith
#                : 重新安排畫面及程式重新Coding 
# Modify.........: NO.FUN-5B0134 05/11/25 BY yiting modify 加上權限判斷 cl_chk_act_auth() 功能
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-920183 09/03/17 BY shiwuying 增加字段sma130
# Modify.........: No.FUN-930164 09/04/15 By jamie update sma22、sma56、sma57成功時，寫入azo_file
# Modify.........: No.FUN-980008 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.CHI-960043 09/08/24 By dxfwo  本作業沒有呼叫cl_used(),當啟動aoos010做記錄時,則無法記錄本支作業的異動情況到p_used中
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0121 09/12/28 By shiwuying sma130增加2選項
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
     DEFINE
        g_sma_o         RECORD LIKE sma_file.*,  # 參數檔
        g_sma_t         RECORD LIKE sma_file.*,  # 參數檔
	g_menu          LIKE type_file.chr1     #No.FUN-690010 VARCHAR(1)
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_msg               LIKE type_file.chr1000 #FUN-930164 add
DEFINE g_flag_22           LIKE type_file.chr1    #FUN-930164 add
DEFINE g_flag_56           LIKE type_file.chr1    #FUN-930164 add
DEFINE g_flag_57           LIKE type_file.chr1    #FUN-930164 add
 
MAIN
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
 #  LET g_menu = '0'
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
    CALL asms260(4,2)
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN  
 
FUNCTION asms260(p_row,p_col)
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
         LET p_row = 5 LET p_col = 18
    ELSE LET p_row = 2 LET p_col = 1
    END IF
    OPEN WINDOW asms260_w AT p_row,p_col
    WITH FORM "asm/42f/asms260" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL asms260_show()
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL asms260_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
             CLOSE WINDOW asms260_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.CHI-960043
END FUNCTION
 
FUNCTION asms260_show()
    SELECT *
        INTO g_sma.*
        FROM sma_file WHERE sma00 = '0'
    IF SQLCA.sqlcode THEN
#      CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660138
       CALL cl_err3("sel","sma_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660138
       RETURN
    END IF
  # DISPLAY BY NAME g_sma.sma21,g_sma.sma22,g_sma.sma56,g_sma.sma57 #No.FUN-920183
    DISPLAY BY NAME g_sma.sma21,g_sma.sma22,g_sma.sma56,            #No.FUN-920183
  #No.FUN-9C0121 -BEGIN-----
  #                 g_sma.sma57,g_sma.sma130                        #No.FUN-920183
                    g_sma.sma57
    IF g_sma.sma130 = '0' THEN
       DISPLAY g_sma.sma130 TO sma1301
       DISPLAY '' TO sma1302
    ELSE
       IF g_sma.sma130 = '1' OR g_sma.sma130 = '2' THEN
          DISPLAY g_sma.sma130 TO sma1302
          DISPLAY '1' TO sma1301
       ELSE
          DISPLAY '' TO sma1301
          DISPLAY '' TO sma1302
       END IF
    END IF
  #No.FUN-9C0121 -END-------
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION asms260_menu()
    MENU ""
    ON ACTION modify 
#NO.FUN-5B0134 START---
          LET g_action_choice="modify"
          IF cl_chk_act_auth() THEN
             CALL asms260_u()
          END IF
#NO.FUN-5B0134 ENF-----
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
 
 
FUNCTION asms260_u()
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_forupd_sql =
      "SELECT *               ",
      "     FROM sma_file     ",
      "      WHERE sma00 = ?   ",
      "     FOR UPDATE        "
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
    IF cl_null(g_sma.sma130) THEN LET g_sma.sma130 = '0' END IF      #No.FUN-920183
  # DISPLAY BY NAME g_sma.sma21,g_sma.sma22,g_sma.sma56,g_sma.sma57  #No.FUN-920183
    DISPLAY BY NAME g_sma.sma21,g_sma.sma22,g_sma.sma56,             #No.FUN-920183
  #No.FUN-9C0121 -BEGIN-----
  #                 g_sma.sma57,g_sma.sma130                         #No.FUN-920183
                    g_sma.sma57
    IF g_sma.sma130 = '0' THEN
       DISPLAY g_sma.sma130 TO sma1301
       DISPLAY '' TO sma1302
    ELSE
       IF g_sma.sma130 = '1' OR g_sma.sma130 = '2' THEN
          DISPLAY g_sma.sma130 TO sma1302
          DISPLAY '1' TO sma1301
       ELSE
          DISPLAY '' TO sma1301
          DISPLAY '' TO sma1302
       END IF
    END IF
  #No.FUN-9C0121 -END-------
                
    WHILE TRUE
        CALL asms260_i()
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE sma_file SET
                sma21=g_sma.sma21,
                sma22=g_sma.sma22,
                sma56=g_sma.sma56,
                sma57=g_sma.sma57,   #No.FUN-920183
                sma130=g_sma.sma130  #No.FUN-920183
            WHERE sma00='0'
        IF SQLCA.sqlcode THEN
#           CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660138
            CALL cl_err3("upd","sma_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660138
            CONTINUE WHILE
       #FUN-930164---add---str--- 
        ELSE 
           IF g_flag_22='Y' THEN 
              LET g_errno = TIME
              LET g_msg = 'old:',g_sma_t.sma22,' new:',g_sma.sma22
              INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980008 add
                 VALUES ('asms260',g_user,g_today,g_errno,'sma22',g_msg,g_plant,g_legal)   #FUN-980008 add
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("ins","azo_file","asms260","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
                 CONTINUE WHILE
              END IF
           END IF 
           IF g_flag_56='Y' THEN 
              LET g_errno = TIME
              LET g_msg = 'old:',g_sma_t.sma56,' new:',g_sma.sma56
              INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980008 add
                 VALUES ('asms260',g_user,g_today,g_errno,'sma56',g_msg,g_plant,g_legal)   #FUN-980008 add
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("ins","azo_file","asms260","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
                 CONTINUE WHILE
              END IF
           END IF 
           IF g_flag_57='Y' THEN 
              LET g_errno = TIME
              LET g_msg = 'old:',g_sma_t.sma57,' new:',g_sma.sma57
              INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980008 add
                 VALUES ('asms260',g_user,g_today,g_errno,'sma57',g_msg,g_plant,g_legal)   #FUN-980008 add
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("ins","azo_file","asms260","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
                 CONTINUE WHILE
              END IF
           END IF 
       #FUN-930164---add---end--- 
        END IF
        EXIT WHILE
    END WHILE
    CLOSE sma_curl
    COMMIT WORK 
END FUNCTION
 
FUNCTION asms260_i()
 
  #No.FUN-9C0121 -BEGIN-----
   DEFINE l_sma1301   LIKE sma_file.sma130
   DEFINE l_sma1302   LIKE sma_file.sma130

   IF g_sma.sma130 = '0' OR cl_null(g_sma.sma130) THEN
      LET l_sma1301 = '0'
      LET l_sma1302 = ''
   END IF
   IF g_sma.sma130 = '1' THEN
      LET l_sma1302 = '1'
      LET l_sma1301 = '1'
   END IF
   IF g_sma.sma130 = '2' THEN
      LET l_sma1302 = '2'
      LET l_sma1301 = '1'
   END IF
   DISPLAY l_sma1301 TO l_sma1301
   DISPLAY l_sma1302 TO l_sma1302

  #INPUT BY NAME g_sma.sma21, g_sma.sma22,g_sma.sma56,g_sma.sma57,g_sma.sma130 #No.FUN-920183 
  #         WITHOUT DEFAULTS
   INPUT g_sma.sma21, g_sma.sma22,g_sma.sma56,g_sma.sma57,l_sma1301,l_sma1302
         WITHOUT DEFAULTS
    FROM sma21,sma22,sma56,sma57,sma1301,sma1302
  #No.FUN-9C0121 -END-------
 
      BEFORE INPUT              #FUN-930164 add  
          LET g_flag_22='N'     #FUN-930164 add
          LET g_flag_56='N'     #FUN-930164 add
          LET g_flag_57='N'     #FUN-930164 add
 
      AFTER FIELD sma22
         IF NOT cl_null(g_sma.sma22) THEN
             IF g_sma.sma22 NOT MATCHES '[12345]' THEN
                 LET g_sma.sma22=g_sma_o.sma22
                 DISPLAY BY NAME g_sma.sma22
                 NEXT FIELD sma22
             END IF
             LET g_sma_o.sma22=g_sma.sma22
            #FUN-930164---add---str---
             IF g_sma.sma22 <> g_sma_t.sma22 THEN 
                LET g_flag_22='Y'
             END IF
            #FUN-930164---add---end---
         END IF
 
      AFTER FIELD sma56
         IF NOT cl_null(g_sma.sma56) THEN
             IF g_sma.sma56 NOT MATCHES "[123]" THEN
                 LET g_sma.sma56=g_sma_o.sma56
                 DISPLAY BY NAME g_sma.sma56
                 NEXT FIELD sma56
             END IF
             LET g_sma_o.sma56=g_sma.sma56
            #FUN-930164---add---str---
             IF g_sma.sma56 <> g_sma_t.sma56 THEN 
                LET g_flag_56='Y'
             END IF
            #FUN-930164---add---end---
         END IF
  
      AFTER FIELD sma57
         IF NOT cl_null(g_sma.sma57) THEN
             IF g_sma.sma57 NOT MATCHES "[12]" THEN
                   LET g_sma.sma57=g_sma_o.sma57
                   DISPLAY BY NAME g_sma.sma57
                   NEXT FIELD sma57
             END IF
             LET g_sma_o.sma57=g_sma.sma57
            #FUN-930164---add---str---
             IF g_sma.sma57 <> g_sma_t.sma57 THEN 
                LET g_flag_57='Y'
             END IF
            #FUN-930164---add---end---
         END IF
 
  #No.FUN-9C0121 BEGIN -----
  ##No.FUN-920183 start ------ 
  #   AFTER FIELD sma130
  #      IF NOT cl_null(g_sma.sma130) THEN
  #         IF g_sma.sma130 NOT MATCHES "[012]" THEN #No.FUN-9C0121 Add 2
  #            LET g_sma.sma130 = g_sma_o.sma130
  #            DISPLAY BY NAME g_sma.sma130
  #            NEXT FIELD sma130
  #         END IF
  #         LET g_sma_o.sma130 = g_sma.sma130
  #      END IF
  ##No.FUN-920183 end -------

      ON CHANGE sma1301
         IF l_sma1301 = '1' THEN
            LET l_sma1301 = '1'
            LET l_sma1302 = '2'
            CALL cl_set_comp_entry("sma1302",TRUE)
         END IF
         IF l_sma1301 = '0' THEN
            LET l_sma1301 = '0'
            LET l_sma1302 = ''
            CALL cl_set_comp_entry("sma1302",FALSE)
         END IF
         DISPLAY l_sma1301 TO sma1301
         DISPLAY l_sma1302 TO sma1302

     # ON CHANGE sma1302
     #    IF NOT cl_null(l_sma1302) THEN
     #       LET l_sma1301 = ''
     #       DISPLAY l_sma1301 TO sma1301
     #    END IF
  #No.FUN-9C0121 END -------
 
      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         IF INT_FLAG THEN
            EXIT INPUT  
         END IF
      #No.FUN-9C0121 BEGIN -----
         IF cl_null(l_sma1301) AND cl_null(l_sma1302) THEN
            NEXT FIELD sma1301
         END IF
         IF l_sma1301 = '0' THEN
            LET g_sma.sma130 = '0'
         ELSE
            IF l_sma1302 = '1' THEN
               LET g_sma.sma130 = '1'
            ELSE
               LET g_sma.sma130 = '2'
            END IF
         END IF
      #No.FUN-9C0121 END -------
 
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
