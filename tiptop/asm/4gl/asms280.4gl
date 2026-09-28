# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asms280.4gl
# Descriptions...: 製造管理系統參數設定作業–製程管理
# Date & Author..: 99/05/25 by patricia
# Modify.........: No.MOD-480027 04/08/11 By Nicola 每人每天工作時間(分)不可小於零
# Modify.........; NO.FUN-5B0134 05/11/25 BY yiting modify 加上權限判斷 cl_chk_act_auth() 功能
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.MOD-860081 08/06/09 By jamie ON IDLE問題
# Modify.........: NO.FUN-930107 09/03/20 By lutingting增加參數sma131
# Modify.........: No.CHI-960043 09/08/24 By dxfwo  本作業沒有呼叫cl_used(),當啟動aoos010做記錄時,則無法記錄本支作業的異動情況到p_used中
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50081 10/05/20 By lilingyu 平行工藝功能改善
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B80133 11/08/19 By jason 新增'製程序移轉檢查製程報工'選項
 
DATABASE ds
 
GLOBALS "../../config/top.global"
     DEFINE
        g_sma_o         RECORD LIKE sma_file.*,  # 參數檔
        g_sma_t         RECORD LIKE sma_file.*   # 參數檔
 
DEFINE  g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE  g_before_input_done LIKE type_file.num5    #No.FUN-690010 SMALLINT
MAIN
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
    CALL asms280()
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN  
 
FUNCTION asms280()
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
 
    LET p_row = 5 LET p_col = 35
    OPEN WINDOW asms280_w AT p_row,p_col
      WITH FORM "asm/42f/asms280" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL asms280_show()
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL asms280_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW asms280_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.CHI-960043
END FUNCTION
 
FUNCTION asms280_show()
    SELECT * INTO g_sma.*
        FROM sma_file WHERE sma00 = '0'
    IF SQLCA.sqlcode THEN
#      CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660138
       CALL cl_err3("sel","sma_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660138
       RETURN
    END IF
    DISPLAY BY NAME g_sma.sma54,g_sma.sma541,g_sma.sma542,g_sma.sma28,g_sma.sma26,  #FUN-A50081 add sma541 sma542
                    g_sma.sma55,g_sma.sma551,g_sma.sma59,g_sma.sma897,g_sma.sma131, #FUN-930107 add sma131
                    g_sma.sma126 #FUN-B80133
                    
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION asms280_menu()
    MENU ""
    ON ACTION modify 
#NO.FUN-5B0134 START-
        LET g_action_choice="modify"
        IF cl_chk_act_auth() THEN
            CALL asms280_u()
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
 
 
FUNCTION asms280_u()
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_forupd_sql =
      "SELECT * FROM sma_file   ",
      " WHERE sma00 = ?          ",
      "FOR UPDATE               "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE sma_curl CURSOR FROM  g_forupd_sql
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
    CALL s280_def()
    DISPLAY BY NAME g_sma.sma54,g_sma.sma541,g_sma.sma542,g_sma.sma28,g_sma.sma26,  #FUN-A50081 add sma541,sma542
                    g_sma.sma55,g_sma.sma551,g_sma.sma59,g_sma.sma897,g_sma.sma131, #FUN-930107 add sma131
                    g_sma.sma126   #FUN-B80133 
                    
    WHILE TRUE
        CALL asms280_i()
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE sma_file SET
           sma54=g_sma.sma54, sma28=g_sma.sma28,
           sma541 = g_sma.sma541,sma542=g_sma.sma542,    #FUN-A50081
           sma26=g_sma.sma26,
           sma55=g_sma.sma55, sma551=g_sma.sma551,
           sma59=g_sma.sma59, sma897=g_sma.sma897,
           sma126 = g_sma.sma126, #FUN-B80133
           sma131 = g_sma.sma131  #FUN-930107 add
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
 
FUNCTION asms280_i()
DEFINE
    l_dir  LIKE type_file.chr1,   #No.FUN-690010CHAR(01),
    l_dir1 LIKE type_file.chr1,   #No.FUN-690010CHAR(01),
    l_dir2 LIKE type_file.chr1   #No.FUN-690010CHAR(01)
    
    INPUT g_sma.sma54,g_sma.sma541,g_sma.sma542,g_sma.sma28,g_sma.sma26,   #FUN-A50081 add sma541,sma542
          g_sma.sma55,g_sma.sma551,g_sma.sma59,g_sma.sma897,  
          g_sma.sma131,g_sma.sma126 #FUN-930107 add sma131 #FUN-B80133 add sma126
          WITHOUT DEFAULTS 
    FROM sma54,sma541,sma542,sma28,sma26, sma55,   #FUN-A50081 add sma541,sma542
         sma551,sma59,sma897,sma131,sma126  #FUN-930107 add sma131 #FUN-B80133 add sma126 
       
    BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL s280_set_entry()
        CALL s280_set_no_entry()
        LET g_before_input_done = TRUE
 
    BEFORE FIELD sma54
       CALL s280_set_entry()
 
    AFTER FIELD sma54
       IF g_sma.sma54 NOT MATCHES "[YN]" THEN 
          LET g_sma.sma54 = g_sma_o.sma54
          DISPLAY BY NAME g_sma.sma54
          NEXT FIELD sma54
       END IF
       IF g_sma.sma54 = 'N' THEN
           LET g_sma.sma26 = '1' 
           DISPLAY BY NAME g_sma.sma26 
       END IF
       CALL s280_set_no_entry()
 
#FUN-A50081 --begin--   
   ON CHANGE sma54
       IF g_sma.sma54 = 'N' THEN           
          CALL cl_set_comp_entry("sma541,sma542",FALSE)    
          LET g_sma.sma541 = 'N'
          LET g_sma.sma542 = 'N'           
       ELSE
          CALL cl_set_comp_entry("sma541,sma542",TRUE)   
          LET g_sma.sma541 = 'Y'        	         
       END IF  
       DISPLAY BY NAME g_sma.sma541,g_sma.sma542 
   
   AFTER FIELD sma541
       IF g_sma.sma541 NOT MATCHES "[YN]" THEN
          NEXT FIELD sma541
       END IF 
       
   ON CHANGE sma541 
      IF g_sma.sma541 = 'Y' THEN
         CALL cl_set_comp_entry("sma542",TRUE)
      ELSE
      	 LET g_sma.sma542 = 'N' 
      	 DISPLAY BY NAME g_sma.sma542
         CALL cl_set_comp_entry("sma542",FALSE)         
      END IF 	
    	    
   AFTER FIELD sma542
       IF g_sma.sma542 NOT MATCHES "[YN]" THEN
          NEXT FIELD sma542
       END IF      
#FUN-A50081 --end--

    AFTER FIELD sma28
       IF g_sma.sma28 NOT MATCHES '[12]' THEN
           LET g_sma.sma28=g_sma_o.sma28
           DISPLAY BY NAME g_sma.sma28
           NEXT FIELD sma28
       END IF
       LET g_sma_o.sma28=g_sma.sma28
 
    BEFORE FIELD sma26
       IF g_sma.sma54 = 'N' THEN NEXT FIELD NEXT END IF
 
    AFTER FIELD sma26
       IF g_sma.sma26 NOT MATCHES "[123]" THEN
          LET g_sma.sma26=g_sma_o.sma26
          DISPLAY BY NAME g_sma.sma26
          NEXT FIELD sma26
       END IF
       LET g_sma_o.sma26=g_sma.sma26
 
    AFTER FIELD sma55 
       IF g_sma.sma55 NOT MATCHES "[YN]" THEN 
          CALL cl_err('','aap-099',0)
          NEXT FIELD sma55
          LET g_sma.sma55 = g_sma_o.sma55
          DISPLAY BY NAME g_sma.sma55
       END IF 
 
     #-----No.MOD-480027-----
    AFTER FIELD sma551
       IF g_sma.sma551 < 0 THEN
          CALL cl_err(g_sma.sma551,"aim-391",0)
          NEXT FIELD sma551
       END IF
    #-----END---------------
 
#genero
#   AFTER FIELD sma551
#      IF cl_null(g_sma.sma551) THEN  
#         CALL cl_err('','aap-099',0) 
#         NEXT FIELD sma551
#         LET g_sma.sma551 = g_sma_o.sma551
#         DISPLAY BY NAME g_sma.sma551
#      END IF 
 
    AFTER FIELD sma59
        IF g_sma.sma59 NOT MATCHES "[YN]" THEN
           LET g_sma.sma59=g_sma_o.sma59
           DISPLAY BY NAME g_sma.sma59
           NEXT FIELD sma59
       END IF
       LET g_sma_o.sma59=g_sma.sma59
 
    AFTER FIELD sma897 
       IF g_sma.sma897 NOT MATCHES '[YN]' THEN 
           NEXT FIELD sma897 
       END IF 
 
    #FUN-930107-----begin
    AFTER FIELD sma131                                                                                                               
        IF g_sma.sma131 NOT MATCHES "[YN]" THEN                                                                                      
           LET g_sma.sma131=g_sma_o.sma131                                                                                            
           DISPLAY BY NAME g_sma.sma131                                                                                              
           NEXT FIELD sma131                                                                                                         
       END IF                                                                                                                       
       LET g_sma_o.sma131=g_sma.sma131
    #FUN-930107-----end
 
    ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
    ON ACTION CONTROLR
       CALL cl_show_req_fields()
 
    ON ACTION CONTROLG
       CALL cl_cmdask()
 
   #MOD-860081------add-----str---
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT
    
    ON ACTION about         
       CALL cl_about()      
    
    ON ACTION help          
       CALL cl_show_help()  
   #MOD-860081------add-----end---
   END INPUT
END FUNCTION
 
#處理預設值的部份
FUNCTION s280_def()
   IF cl_null(g_sma.sma54) THEN LET g_sma.sma54 ='N' END IF 
#FUN-A50081 --begin--   
   IF cl_null(g_sma.sma541) THEN LET g_sma.sma541 = 'Y' END IF 
   IF cl_null(g_sma.sma542) THEN LET g_sma.sma542 = 'Y' END IF    
#FUN-A50081 --end--   
   IF cl_null(g_sma.sma28) THEN LET g_sma.sma28 ='2' END IF 
   IF cl_null(g_sma.sma26) THEN LET g_sma.sma26 ='2' END IF 
   IF cl_null(g_sma.sma55) THEN LET g_sma.sma55 ='N' END IF 
   IF cl_null(g_sma.sma59) THEN LET g_sma.sma59 ='N' END IF 
   IF cl_null(g_sma.sma897) THEN LET g_sma.sma897 ='N' END IF
   IF cl_null(g_sma.sma131) THEN LET g_sma.sma131 = 'N' END IF    #FUN-930107  
END FUNCTION
#genero
FUNCTION s280_set_entry()
 
   IF INFIELD(sma54) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("sma26",TRUE)   
   END IF
 
END FUNCTION
 
FUNCTION s280_set_no_entry()
 
   IF INFIELD(sma54) OR (NOT g_before_input_done) THEN
      IF g_sma.sma54='N' THEN
          CALL cl_set_comp_entry("sma26,sma541,sma542",FALSE)  #FUN-A50081 add sma541,sma542
          LET g_sma.sma541 = 'N'                               #FUN-A50081 add 
          LET g_sma.sma542 = 'N'                               #FUN-A50081 add 
          DISPLAY BY NAME g_sma.sma541,g_sma.sma542            #FUN-A50081 add 
      END IF
   END IF

#FUN-A50081 --begin--
   IF INFIELD(sma541) OR (NOT g_before_input_done) THEN
      IF g_sma.sma541='N' THEN
          CALL cl_set_comp_entry("sma542",FALSE)
      END IF
   END IF
#FUN-A50081 --end--
END FUNCTION
 
 
