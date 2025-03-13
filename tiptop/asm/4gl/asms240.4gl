# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asms240.4gl
# Descriptions...: 系統參數設定作業–產品結構     
# Date & Author..: 92/12/21 By David
#                : Rearrange Screen Format & Recoding
# Modify.........: No.FUN-510017 05/01/17 By Mandy 報表轉XML
# Modify.........: No.FUN-550014 05/05/13 By Mandy 增一參數'是否使用特性BOM功能'(sma118 VARCHAR(1))
# Modify.........: No.FUN-560177 05/06/22 By kim 1.是否使用特性BOM功能, 此項設定的輸入請移到 '一般設定' 的最後一項
#                                                2.以上欄位請default出貨值為 'N'
# Modify.........: No: FUN-560220 05/06/27 By pengu  sma118 的設定拿掉
# Modify.........: NO.FUN-5B0134 05/11/25 BY yiting modify 加上權限判斷 cl_chk_act_auth() 功能
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-670041 06/08/10 By Pengu 將sma29 [虛擬產品結構展開與否] 改為 no use
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.MOD-940095 09/04/08 By Dido asms240_show() 增加顯示 sma19
# Modify.........: No.CHI-960043 09/08/24 By dxfwo  本作業沒有呼叫cl_used(),當啟動aoos010做記錄時,則無法記錄本支作業的異動情況到p_used中
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AB0055 10/11/25 By jan 新增欄位sma145
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
     DEFINE
        g_sma_o         RECORD LIKE sma_file.*,  # 參數檔
        g_sma_t         RECORD LIKE sma_file.*   # 參數檔
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
MAIN
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
    CALL asms240()
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN  
 
FUNCTION asms240()
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
         LET p_row = 4 LET p_col = 30
    ELSE LET p_row = 4 LET p_col = 2
    END IF
    OPEN WINDOW asms240_w AT  p_row,p_col      
        WITH FORM "asm/42f/asms240" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL asms240_show()
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL asms240_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW asms240_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.CHI-960043
END FUNCTION
 
FUNCTION asms240_show()
    SELECT * INTO g_sma.*
        FROM sma_file WHERE sma00 = '0'
    IF SQLCA.sqlcode THEN
#      CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660138
       CALL cl_err3("sel","sma_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660138
       RETURN
    END IF
    LET g_sma.sma888 = g_sma.sma888[1,1]
    DISPLAY BY NAME g_sma.sma09,g_sma.sma18,g_sma.sma65,g_sma.sma66, #FUN-550014 add sma118    #FUN-560220 delete sma118
                    g_sma.sma67,g_sma.sma888,                  #No.FUN-670041 delete sma29
                    g_sma.sma845,g_sma.sma846,g_sma.sma895,
                    g_sma.sma100,g_sma.sma101,g_sma.sma19,g_sma.sma145      #bugno:8610 add  #MOD-940095 add sma19 #FUN-AB0055
                    
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION asms240_menu()
    MENU ""
    ON ACTION modify 
#NO.FUN-5B0134 START---
       LET g_action_choice="modify"
       IF cl_chk_act_auth() THEN
           CALL asms240_u()
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
 
 
FUNCTION asms240_u()
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_forupd_sql =
     " SELECT *               ",   #sma09,sma65,sma66,sma67
     "      FROM sma_file     ",
     "       WHERE sma00 = ?   ",
     "      FOR UPDATE        "
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
 
  #--FUN-560220
   ##FUN-560177................begin
   #IF cl_null(g_sma.sma118) THEN
   #   LET g_sma.sma118='N'
   #END IF
   ##FUN-560177................end
  #--end
 
    LET g_sma_o.* = g_sma.*
    LET g_sma_t.* = g_sma.*
    IF cl_null(g_sma.sma145) THEN LET g_sma.sma145='N' END IF   #FUN-AB0055
    DISPLAY BY NAME g_sma.sma09,g_sma.sma18,g_sma.sma65,g_sma.sma66, #FUN-550014 add sma118   #FUN-560220 delete sma118
                    g_sma.sma67,                  #No.FUN-670041 delete sma29
                    g_sma.sma845,g_sma.sma846,g_sma.sma895,
                    g_sma.sma100,g_sma.sma101,g_sma.sma145  #bugno:6810 add #FUN-AB0055
                    
    WHILE TRUE
        CALL asms240_i()
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE sma_file SET
           #sma118=g_sma.sma118, #FUN-550014 #FUN-560220
           sma09=g_sma.sma09,sma18=g_sma.sma18,
           sma65=g_sma.sma65,sma66=g_sma.sma66,
          #--------#No.FUN-670041 modify
          #sma67=g_sma.sma67,sma29=g_sma.sma29,
           sma67=g_sma.sma67,sma29='Y',
          #--------#No.FUN-670041 modify
           sma845=g_sma.sma845,sma846=g_sma.sma846,
           sma895=g_sma.sma895,
           sma100=g_sma.sma100,   #bugno:6810 add
           sma101=g_sma.sma101,   #bugno:6810 add
           sma888 = g_sma.sma888,sma19=g_sma.sma19,
           sma145 = g_sma.sma145    #FUN-AB0055 
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
 
FUNCTION asms240_i()
 
   INPUT BY NAME g_sma.sma09,g_sma.sma100,g_sma.sma101,g_sma.sma888, #FUN-550014  #FUN-560220  delete sma118
                 g_sma.sma65,g_sma.sma19,g_sma.sma845,g_sma.sma846,g_sma.sma18,
                 g_sma.sma66,g_sma.sma67,g_sma.sma895,g_sma.sma145   #No.FUN-670041 delete sma29 #FUN-AB0055
                 WITHOUT DEFAULTS 
 
      AFTER FIELD sma09
         IF NOT cl_null(g_sma.sma09) THEN
             IF g_sma.sma09 NOT MATCHES "[YN]" THEN
                LET g_sma.sma09=g_sma_o.sma09
                DISPLAY BY NAME g_sma.sma09
                NEXT FIELD sma09
             END IF
             LET g_sma_o.sma09=g_sma.sma09
         END IF
 
      AFTER FIELD sma18
         IF NOT cl_null(g_sma.sma18) THEN
             IF g_sma.sma18 NOT MATCHES "[YN]" THEN
                LET g_sma.sma18=g_sma_o.sma18
                DISPLAY BY NAME g_sma.sma18
                NEXT FIELD sma18
             END IF
             LET g_sma_o.sma18=g_sma.sma18
         END IF
 
      AFTER FIELD sma65
         IF NOT cl_null(g_sma.sma65) THEN
             IF g_sma.sma65 NOT MATCHES "[123]" THEN
                LET g_sma.sma65=g_sma_o.sma65
                DISPLAY BY NAME g_sma.sma65
                NEXT FIELD sma65
             END IF
             LET g_sma_o.sma65=g_sma.sma65
         END IF
 
      AFTER FIELD sma66
         IF NOT cl_null(g_sma.sma66) THEN
             IF g_sma.sma66 NOT MATCHES "[YN]" THEN
                LET g_sma.sma66=g_sma_o.sma66
                DISPLAY BY NAME g_sma.sma66
                NEXT FIELD sma66
             END IF
             LET g_sma_o.sma66=g_sma.sma66
         END IF
 
      AFTER FIELD sma67
         IF NOT cl_null(g_sma.sma67) THEN
             IF g_sma.sma67 NOT MATCHES "[YN]" THEN
                LET g_sma.sma67=g_sma_o.sma67
                DISPLAY BY NAME g_sma.sma67
                NEXT FIELD sma67
             END IF
             LET g_sma_o.sma67=g_sma.sma67
         END IF
 
 
#---------No.FUN-670041 mark
#     AFTER FIELD sma29
#        IF NOT cl_null(g_sma.sma29) THEN
#            IF g_sma.sma29 NOT MATCHES "[YN]" THEN
#               LET g_sma.sma29=g_sma_o.sma29
#               DISPLAY BY NAME g_sma.sma29
#               NEXT FIELD sma29
#            END IF
#            LET g_sma_o.sma29=g_sma.sma29
#        END IF
#---------No.FUN-670041 mark
 
      AFTER FIELD sma888
         IF NOT cl_null(g_sma.sma888) THEN
             IF g_sma.sma888 NOT MATCHES "[YN]" THEN
                LET g_sma.sma888=g_sma_o.sma888
                DISPLAY BY NAME g_sma.sma888
                NEXT FIELD sma888
             END IF
             LET g_sma_o.sma888=g_sma.sma888
         END IF
 
#     AFTER FIELD sma19
#        IF cl_null(g_sma.sma19) THEN
#           LET g_sma.sma19=g_sma_o.sma19
#           DISPLAY BY NAME g_sma.sma19
#           NEXT FIELD sma19
#        END IF
#        LET g_sma_o.sma19=g_sma.sma19
 
      AFTER FIELD sma845
         IF NOT cl_null(g_sma.sma845) THEN
             IF g_sma.sma845 NOT MATCHES "[YN]" THEN
                LET g_sma.sma845=g_sma_o.sma845
                DISPLAY BY NAME g_sma.sma845
                NEXT FIELD sma845
             END IF
             LET g_sma_o.sma845=g_sma.sma845
         END IF
 
      AFTER FIELD sma846
         IF NOT cl_null(g_sma.sma846) THEN
             IF g_sma.sma846 NOT MATCHES "[YN]" THEN
                LET g_sma.sma846=g_sma_o.sma846
                DISPLAY BY NAME g_sma.sma846
                NEXT FIELD sma846
             END IF
             LET g_sma_o.sma846=g_sma.sma846
         END IF
 
      AFTER FIELD sma895
         IF NOT cl_null(g_sma.sma895) THEN
             IF g_sma.sma895 NOT MATCHES "[12]" THEN
                LET g_sma.sma895=g_sma_o.sma895
                DISPLAY BY NAME g_sma.sma895
                NEXT FIELD sma895
             END IF
             LET g_sma_o.sma895=g_sma.sma895
         END IF
 
#bugno:6810 add................................................
      BEFORE FIELD sma100
         IF cl_null(g_sma.sma100) THEN  
            LET g_sma.sma100 = 'Y'
            DISPLAY BY NAME g_sma.sma100 
         END IF 
         
      AFTER FIELD sma100
         IF NOT cl_null(g_sma.sma100) THEN
             IF g_sma.sma100 NOT MATCHES "[YN]" THEN
                LET g_sma.sma100=g_sma_o.sma100
                DISPLAY BY NAME g_sma.sma100
                NEXT FIELD sma100
             END IF
             LET g_sma_o.sma100=g_sma.sma100
         END IF
 
      BEFORE FIELD sma101
         IF cl_null(g_sma.sma101) THEN  
            LET g_sma.sma101 = 'Y'
            DISPLAY BY NAME g_sma.sma101 
         END IF 
 
      AFTER FIELD sma101
         IF NOT cl_null(g_sma.sma101) THEN
             IF g_sma.sma101 NOT MATCHES "[YN]" THEN
                LET g_sma.sma101=g_sma_o.sma101
                DISPLAY BY NAME g_sma.sma101
                NEXT FIELD sma101
             END IF
             LET g_sma_o.sma101=g_sma.sma101
         END IF
#bugno:6810 end................................................
 
#FUN-AB0055--begin--add--------------------------
      AFTER FIELD sma145
         IF NOT cl_null(g_sma.sma145) THEN
             IF g_sma.sma145 NOT MATCHES "[YN]" THEN
                LET g_sma.sma145=g_sma_o.sma145
                DISPLAY BY NAME g_sma.sma145
                NEXT FIELD sma145
             END IF
             LET g_sma_o.sma145=g_sma.sma145
         END IF
#FUN-AB0055--end--add-----------------------------
 
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
