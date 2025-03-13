# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: amms100.4gl
# Descriptions...: 模具生產系統參數設定作業
# Date & Author..: 00/11/28 By Faith
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.MOD-4B0169 04/11/22 By Mandy check imd_file 的程式段...應加上 imdacti 的判斷
# Modify.........: No.FUN-550054 05/05/28 By wujie 單據編號加大
# Modify.........: No.FUN-660094 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-680100 06/08/28 By huchenghao 類型轉換
# Modify.........: No.FUN-930104 09/03/23 By dxfwo   理由碼的分類改善
# Modify.........: No.TQC-940016 09/05/06 By destiny 將display '!' to 字段這段mark 
 
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   離開MAIN時沒有cl_used(1)和cl_used(2) 
# Modify.........: No.FUN-B50039 11/07/06 By fengrui 增加自定義欄位

DATABASE ds
 
GLOBALS "../../config/top.global"
    DEFINE
        g_t1            LIKE mmd_file.mmd011,    #No.FUN-550054        #No.FUN-680100 VARCHAR(5)
        g_mmd_t         RECORD LIKE mmd_file.*,  # 預留參數檔
        g_mmd_o         RECORD LIKE mmd_file.*   # 預留參數檔
    DEFINE g_forupd_sql STRING        #No.FUN-680100
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8          #No.FUN-6A0076
    DEFINE p_row,p_col LIKE type_file.num5          #No.FUN-680100 SMALLINT
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   LET g_mmd.mmd00 = '0' 
   LET g_mmd.mmdoriu = g_user      #No.FUN-980030 10/01/04
   LET g_mmd.mmdorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO mmd_file VALUES(g_mmd.*)
   IF (NOT cl_setup("AMM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211 
 
   LET p_row = 3 LET p_col = 2 
   OPEN WINDOW s010_w AT p_row,p_col
   WITH FORM "amm/42f/amms100" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
 
   CALL s010_show()
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
   CALL s010_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
   CLOSE WINDOW s010_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211 
END MAIN
 
FUNCTION s010_show()
    LET g_mmd_t.* = g_mmd.*
    LET g_mmd_o.* = g_mmd.*
    DISPLAY BY NAME g_mmd.mmd01,g_mmd.mmd011,
                    g_mmd.mmd02,g_mmd.mmd021,g_mmd.mmd022,
                    g_mmd.mmd03,g_mmd.mmd031,g_mmd.mmd04,g_mmd.mmd041,
                    g_mmd.mmd05,g_mmd.mmd051,g_mmd.mmd06,g_mmd.mmd061,
                    g_mmd.mmd07,g_mmd.mmd071,g_mmd.mmd08,g_mmd.mmd081,
                    g_mmd.mmd09,g_mmd.mmd091,g_mmd.mmd10,g_mmd.mmd101,
                    g_mmd.mmd12,g_mmd.mmd121,
                    g_mmd.mmd13,g_mmd.mmd131,g_mmd.mmd14,g_mmd.mmd141,
                    g_mmd.mmd15,g_mmd.mmd16, g_mmd.mmduser,g_mmd.mmdgrup,
                    g_mmd.mmdmodu,g_mmd.mmddate,
                    #FUN-B50039-add-str--
                    g_mmd.mmdud01,g_mmd.mmdud02,g_mmd.mmdud03,
                    g_mmd.mmdud04,g_mmd.mmdud05,g_mmd.mmdud06,
                    g_mmd.mmdud07,g_mmd.mmdud08,g_mmd.mmdud09,
                    g_mmd.mmdud10,g_mmd.mmdud11,g_mmd.mmdud12,
                    g_mmd.mmdud13,g_mmd.mmdud14,g_mmd.mmdud15
                    #FUN-B50039-add-end--
 
#  IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
     #No.TQC-940016--begin 
     # DISPLAY '!' TO mmd01  
     # DISPLAY '!' TO mmd02  
     # DISPLAY '!' TO mmd03  
     # DISPLAY '!' TO mmd04  
     # DISPLAY '!' TO mmd05  
     # DISPLAY '!' TO mmd06  
     # DISPLAY '!' TO mmd07  
     # DISPLAY '!' TO mmd08  
     # DISPLAY '!' TO mmd09  
     # DISPLAY '!' TO mmd10  
     # DISPLAY '!' TO mmd12  
     # DISPLAY '!' TO mmd13  
     # DISPLAY '!' TO mmd14  
     #No.TQC-940016--end 
#  END IF
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION s010_menu()
    MENU ""
    ON ACTION modify     
       LET g_action_choice = "modify"
       IF cl_chk_act_auth() THEN 
          CALL s010_u()
       END IF 
 
    ON ACTION help
       CALL cl_show_help()
 
    ON ACTION locale
       CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
    ON ACTION exit
       LET g_action_choice = "exit"
       EXIT MENU
 
    ON ACTION CONTROLG  CALL cl_cmdask()
 
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
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
    IF s_ammshut(0) THEN RETURN END IF
    CALL cl_opmsg('u')
    MESSAGE ""
    LET g_forupd_sql = "SELECT * FROM mmd_file WHERE mmd00 = '0' FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE mmd_curl CURSOR FROM g_forupd_sql 
 
    BEGIN WORK
    OPEN mmd_curl
    IF STATUS  THEN CALL cl_err('OPEN mmd_curl',STATUS,1) RETURN END IF
    FETCH mmd_curl INTO g_mmd.*
    IF STATUS  THEN CALL cl_err('',STATUS,0) RETURN END IF
    WHILE TRUE
        LET g_mmd.mmduser = g_user
        LET g_mmd.mmdgrup = g_grup
        LET g_mmd.mmdmodu = g_user
        LET g_mmd.mmddate = g_today
        CALL s010_i()
        IF INT_FLAG THEN
           LET INT_FLAG = 0 CALL cl_err('',9001,0)
           LET g_mmd.* = g_mmd_t.* CALL s010_show()
           EXIT WHILE
        END IF
        UPDATE mmd_file SET * = g_mmd.* WHERE mmd00='0'
        IF STATUS THEN 
#        CALL cl_err('',STATUS,0) #No.FUN-660094
         CALL cl_err3("upd","mmd_file","","",STATUS,"","",0)        #NO.FUN-660094
         CONTINUE WHILE END IF
        CLOSE mmd_curl
        COMMIT WORK
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION s010_i()
   DEFINE   l_mmd   LIKE type_file.chr1             #No.FUN-680100 VARCHAR(1)
#No.FUN-550054--begin
   DEFINE li_result LIKE type_file.num5             #No.FUN-680100 SMALLINT
#No.FUN-550054--end  
 
   INPUT BY NAME g_mmd.mmd01,g_mmd.mmd011,
                 g_mmd.mmd02,g_mmd.mmd021,g_mmd.mmd022,
                 g_mmd.mmd03,g_mmd.mmd031,g_mmd.mmd04,g_mmd.mmd041,
                 g_mmd.mmd05,g_mmd.mmd051,g_mmd.mmd06,g_mmd.mmd061,
                 g_mmd.mmd07,g_mmd.mmd071,g_mmd.mmd08,g_mmd.mmd081,
                 g_mmd.mmd09,g_mmd.mmd091,g_mmd.mmd10,g_mmd.mmd101,
                 g_mmd.mmd12,g_mmd.mmd121,
                 g_mmd.mmd13,g_mmd.mmd131,g_mmd.mmd14,g_mmd.mmd141,
                 #No.FUN-930104--begin
                 #g_mmd.mmd15,g_mmd.mmd16, g_mmd.mmdgrup,g_mmd.mmdgrup, 
                 #No.FUN-930104--end
                 g_mmd.mmd15,g_mmd.mmd16, g_mmd.mmduser,g_mmd.mmdgrup, 
                 g_mmd.mmdmodu,g_mmd.mmddate,
                 #FUN-B50039-add-str--
                 g_mmd.mmdud01,g_mmd.mmdud02,g_mmd.mmdud03,
                 g_mmd.mmdud04,g_mmd.mmdud05,g_mmd.mmdud06,
                 g_mmd.mmdud07,g_mmd.mmdud08,g_mmd.mmdud09,
                 g_mmd.mmdud10,g_mmd.mmdud11,g_mmd.mmdud12,
                 g_mmd.mmdud13,g_mmd.mmdud14,g_mmd.mmdud15
                 #FUN-B50039-add-end--
                 
      WITHOUT DEFAULTS 
 
      AFTER FIELD mmd01
         IF  cl_null(g_mmd.mmd01) THEN
             IF g_mmd.mmd01 NOT MATCHES '[YN]' THEN
                LET g_mmd.mmd01=g_mmd_o.mmd01
                DISPLAY BY NAME g_mmd.mmd01
                NEXT FIELD mmd01
             END IF
             LET g_mmd_o.mmd01=g_mmd.mmd01
         END IF
 
      AFTER FIELD mmd011
         IF NOT cl_null(g_mmd.mmd011) THEN
#No.FUN-550054--begin
#           LET g_t1=g_mmd.mmd011[1,3]
            LET g_t1=g_mmd.mmd011[1,g_doc_len]
            CALL s_check_no("asf",g_t1,"","1","","","")
            RETURNING li_result,g_mmd.mmd011
            LET g_mmd.mmd011 = s_get_doc_no(g_mmd.mmd011)
            DISPLAY BY NAME g_mmd.mmd011
            IF (NOT li_result) THEN
                NEXT FIELD mmd011
            END IF
#           CALL s_mfgslip(g_t1,'asf','1')              #檢查單別
#           IF NOT cl_null(g_errno) THEN                        #抱歉, 有問題
#              CALL cl_err(g_t1,g_errno,0)
#              NEXT FIELD mmd011
#           END IF
#No.FUN-550054--end   
         END IF
 
      AFTER FIELD mmd02
         IF NOT cl_null(g_mmd.mmd02) THEN
            IF g_mmd.mmd02 NOT MATCHES "[YN]" THEN
               LET g_mmd.mmd02=g_mmd_o.mmd02
               DISPLAY BY NAME g_mmd.mmd02
               NEXT FIELD mmd02
	    END IF
            LET g_mmd_o.mmd02=g_mmd.mmd02
         END IF
 
      AFTER FIELD mmd021
         IF NOT cl_null(g_mmd.mmd021) THEN
#No.FUN-550054--begin
#           LET g_t1=g_mmd.mmd021[1,3]
            LET g_t1=g_mmd.mmd021[1,g_doc_len]
            CALL s_check_no("aim",g_t1,"","2","","","")
            RETURNING li_result,g_mmd.mmd021
            LET g_mmd.mmd021 = s_get_doc_no(g_mmd.mmd021)
            DISPLAY BY NAME g_mmd.mmd021
            IF (NOT li_result) THEN
                NEXT FIELD mmd021
            END IF
#           CALL s_mfgslip(g_t1,'aim','2')              #檢查單別
#           IF NOT cl_null(g_errno) THEN                        #抱歉, 有問題
#              CALL cl_err(g_t1,g_errno,0)
#              NEXT FIELD mmd021
#           END IF
#No.FUN-550054--end
         END IF
 
      AFTER FIELD mmd022
         IF NOT cl_null(g_mmd.mmd022) THEN
            CALL s100_mmd022('u')
               IF NOT cl_null(g_errno) THEN 
               CALL cl_err('mmd022:',g_errno,0)
               DISPLAY BY NAME g_mmd.mmd022 
               NEXT FIELD mmd022
            END IF 
         END IF
 
      AFTER FIELD mmd03
	 IF NOT cl_null(g_mmd.mmd03) THEN
            IF g_mmd.mmd03 NOT MATCHES "[YN]" THEN
               LET g_mmd.mmd03=g_mmd_o.mmd03
               DISPLAY BY NAME g_mmd.mmd03
               NEXT FIELD mmd03
            END IF
         END IF
         LET g_mmd_o.mmd03=g_mmd.mmd03
 
      AFTER FIELD mmd031
         IF NOT cl_null(g_mmd.mmd031) THEN
#No.FUN-550054--begin
#           LET g_t1=g_mmd.mmd031[1,3]
            LET g_t1=g_mmd.mmd031[1,g_doc_len]
            CALL s_check_no("asf",g_t1,"","3","","","")
            RETURNING li_result,g_mmd.mmd031
            LET g_mmd.mmd031 = s_get_doc_no(g_mmd.mmd031)
            DISPLAY BY NAME g_mmd.mmd031
            IF (NOT li_result) THEN
               NEXT FIELD mmd031
            END IF
#           CALL s_mfgslip(g_t1,'asf','3')              #檢查單別
#           IF NOT cl_null(g_errno) THEN                        #抱歉, 有問題
#              CALL cl_err(g_t1,g_errno,0)
#              NEXT FIELD mmd031
#           END IF
#No.FUN-550054--end
         END IF
 
      AFTER FIELD mmd04
         IF NOT cl_null(g_mmd.mmd04) THEN
            IF g_mmd.mmd04 NOT MATCHES "[YN]" THEN 
               LET g_mmd.mmd04=g_mmd_o.mmd04
               DISPLAY BY NAME g_mmd.mmd04
               NEXT FIELD mmd04
            END IF
         END IF
         LET g_mmd_o.mmd04=g_mmd.mmd04
 
      AFTER FIELD mmd041
         IF NOT cl_null(g_mmd.mmd041) THEN 
#No.FUN-550054--begin
#           LET g_t1=g_mmd.mmd041[1,3]
            LET g_t1=g_mmd.mmd041[1,g_doc_len]
            CALL s_check_no("asf",g_t1,"","A","","","")
            RETURNING li_result,g_mmd.mmd041
            LET g_mmd.mmd041 = s_get_doc_no(g_mmd.mmd041)
            DISPLAY BY NAME g_mmd.mmd041
            IF (NOT li_result) THEN
               NEXT FIELD mmd041
            END IF
#           CALL s_mfgslip(g_t1,'asf','A')              #檢查單別
#           IF NOT cl_null(g_errno) THEN                        #抱歉, 有問題
#               CALL cl_err(g_t1,g_errno,0)
#               NEXT FIELD mmd041
#            END IF
#No.FUN-550054--end
         END IF
 
      AFTER FIELD mmd05
         IF NOT cl_null(g_mmd.mmd05) THEN
            IF g_mmd.mmd05 NOT MATCHES "[YN]" THEN
               LET g_mmd.mmd05=g_mmd_o.mmd05
               DISPLAY BY NAME g_mmd.mmd05
               NEXT FIELD mmd05
            END IF
         END IF
         LET g_mmd_o.mmd05=g_mmd.mmd05
 
      AFTER FIELD mmd051
         IF NOT cl_null(g_mmd.mmd051) THEN 
#No.FUN-550054--begin
#           LET g_t1=g_mmd.mmd051[1,3]
            LET g_t1=g_mmd.mmd051[1,g_doc_len]
            CALL s_check_no("apm",g_t1,"","1","","","")
            RETURNING li_result,g_mmd.mmd051
            LET g_mmd.mmd051 = s_get_doc_no(g_mmd.mmd051)
            DISPLAY BY NAME g_mmd.mmd051
            IF (NOT li_result) THEN
               NEXT FIELD mmd051
            END IF
#           CALL s_mfgslip(g_t1,'apm','1')              #檢查單別
#           IF NOT cl_null(g_errno) THEN                        #抱歉, 有問題
#              CALL cl_err(g_t1,g_errno,0)
#              NEXT FIELD mmd051
#           END IF
#No.FUN-550054--end
         END IF
 
      AFTER FIELD mmd06
         IF NOT cl_null(g_mmd.mmd06) THEN
            IF g_mmd.mmd06 NOT MATCHES "[YN]" THEN
               LET g_mmd.mmd06=g_mmd_o.mmd06
               DISPLAY BY NAME g_mmd.mmd06
               NEXT FIELD mmd06
            END IF
         END IF
         LET g_mmd_o.mmd06=g_mmd.mmd06
 
      AFTER FIELD mmd061
         IF NOT cl_null(g_mmd.mmd061) THEN
#No.FUN-550054--begin
#           LET g_t1=g_mmd.mmd061[1,3]
            LET g_t1=g_mmd.mmd061[1,g_doc_len]
            CALL s_check_no("apm",g_t1,"","2","","","")
            RETURNING li_result,g_mmd.mmd061
            LET g_mmd.mmd061 = s_get_doc_no(g_mmd.mmd061)
            DISPLAY BY NAME g_mmd.mmd061
            IF (NOT li_result) THEN
                NEXT FIELD mmd061
            END IF
#           CALL s_mfgslip(g_t1,'apm','2')              #檢查單別
#           IF NOT cl_null(g_errno) THEN                        #抱歉, 有問題
#              CALL cl_err(g_t1,g_errno,0)
#              NEXT FIELD mmd061
#           END IF
#No.FUN-550054--end
         END IF
 
      AFTER FIELD mmd07
	 IF NOT cl_null(g_mmd.mmd07) THEN
            IF g_mmd.mmd07 NOT MATCHES "[YN]"  THEN
               LET g_mmd.mmd07=g_mmd_o.mmd07
               DISPLAY BY NAME g_mmd.mmd07
               NEXT FIELD mmd07
            END IF
         END IF
         LET g_mmd_o.mmd07=g_mmd.mmd07
 
      AFTER FIELD mmd071
         IF NOT cl_null(g_mmd.mmd071) THEN
#No.FUN-550054--begin
#           LET g_t1=g_mmd.mmd071[1,3]
            LET g_t1=g_mmd.mmd071[1,g_doc_len]
            CALL s_check_no("apm",g_t1,"","3","","","")
            RETURNING li_result,g_mmd.mmd071
            LET g_mmd.mmd071 = s_get_doc_no(g_mmd.mmd071)
            DISPLAY BY NAME g_mmd.mmd071
            IF (NOT li_result) THEN
                NEXT FIELD mmd071
            END IF
#           CALL s_mfgslip(g_t1,'apm','3')              #檢查單別
#           IF NOT cl_null(g_errno) THEN                        #抱歉, 有問題
#              CALL cl_err(g_t1,g_errno,0)
#              NEXT FIELD mmd071
#           END IF
#No.FUN-550054--end
         END IF
 
      AFTER FIELD mmd08
         IF NOT cl_null(g_mmd.mmd08) THEN 
            IF g_mmd.mmd08 NOT MATCHES "[YN]" THEN
               LET g_mmd.mmd08=g_mmd_o.mmd08
               DISPLAY BY NAME g_mmd.mmd08
               NEXT FIELD mmd08
            END IF
         END IF
         LET g_mmd_o.mmd08=g_mmd.mmd08
 
      AFTER FIELD mmd081
         IF NOT cl_null(g_mmd.mmd081) THEN 
#No.FUN-550054--begin
#           LET g_t1=g_mmd.mmd081[1,3]
            LET g_t1=g_mmd.mmd081[1,g_doc_len]
            CALL s_check_no("apm",g_t1,"","7","","","")
            RETURNING li_result,g_mmd.mmd081
            LET g_mmd.mmd081 = s_get_doc_no(g_mmd.mmd081)
            DISPLAY BY NAME g_mmd.mmd081
            IF (NOT li_result) THEN
                NEXT FIELD mmd081
            END IF
#           CALL s_mfgslip(g_t1,'apm','7')              #檢查單別
#           IF NOT cl_null(g_errno) THEN                        #抱歉, 有問題
#              CALL cl_err(g_t1,g_errno,0)
#              NEXT FIELD mmd081
#           END IF
#No.FUN-550054--end
         END IF
 
      AFTER FIELD mmd09
         IF cl_null(g_mmd.mmd09) THEN
            LET g_mmd.mmd09=g_today
            DISPLAY BY NAME g_mmd.mmd09
            NEXT FIELD mmd09
         END IF
         LET g_mmd_o.mmd09=g_mmd.mmd09
 
      AFTER FIELD mmd091
         IF NOT cl_null(g_mmd.mmd091) THEN
#No.FUN-550054--begin
#           LET g_t1=g_mmd.mmd091[1,3]
            LET g_t1=g_mmd.mmd091[1,g_doc_len]
            CALL s_check_no("asf",g_t1,"","1","","","")
            RETURNING li_result,g_mmd.mmd091
            LET g_mmd.mmd091 = s_get_doc_no(g_mmd.mmd091)
            DISPLAY BY NAME g_mmd.mmd091
            IF (NOT li_result) THEN
                NEXT FIELD mmd091
            END IF
#           CALL s_mfgslip(g_t1,'asf','1')              #檢查單別
#           IF NOT cl_null(g_errno) THEN                        #抱歉, 有問題
#              CALL cl_err(g_t1,g_errno,0)
#              NEXT FIELD mmd091
#           END IF
#No.FUN-550054--end
         END IF
 
      AFTER FIELD mmd10
         IF NOT cl_null(g_mmd.mmd10) THEN
            IF g_mmd.mmd10 NOT MATCHES '[YN]' THEN
               LET g_mmd.mmd10=g_mmd_o.mmd10
               DISPLAY BY NAME g_mmd.mmd10
               NEXT FIELD mmd10
            END IF
         END IF
         LET g_mmd_o.mmd10=g_mmd.mmd10
 
      AFTER FIELD mmd101
         IF NOT cl_null(g_mmd.mmd101) THEN
#No.FUN-550054--begin
#           LET g_t1=g_mmd.mmd101[1,3]
            LET g_t1=g_mmd.mmd101[1,g_doc_len]
            CALL s_check_no("apm",g_t1,"","2","","","")
            RETURNING li_result,g_mmd.mmd101
            LET g_mmd.mmd101 = s_get_doc_no(g_mmd.mmd101)
            DISPLAY BY NAME g_mmd.mmd101
            IF (NOT li_result) THEN
                NEXT FIELD mmd101
            END IF
#           CALL s_mfgslip(g_t1,'apm','2')              #檢查單別
#           IF NOT cl_null(g_errno) THEN                        #抱歉, 有問題
#              CALL cl_err(g_t1,g_errno,0)
#              NEXT FIELD mmd101
#           END IF
#No.FUN-550054--end
         END IF
 
      AFTER FIELD mmd12
         IF NOT cl_null(g_mmd.mmd12) THEN
            IF g_mmd.mmd12 NOT MATCHES '[YN]' THEN
               LET g_mmd.mmd12=g_mmd_o.mmd12
               DISPLAY BY NAME g_mmd.mmd12
               NEXT FIELD mmd12
            END IF
         END IF
         LET g_mmd_o.mmd12=g_mmd.mmd12
 
      AFTER FIELD mmd121
         IF NOT cl_null(g_mmd.mmd121) THEN 
#No.FUN-550054--begin
#           LET g_t1=g_mmd.mmd121[1,3]
            LET g_t1=g_mmd.mmd121[1,g_doc_len]
            CALL s_check_no("asf",g_t1,"","3","","","")
            RETURNING li_result,g_mmd.mmd121
            LET g_mmd.mmd121 = s_get_doc_no(g_mmd.mmd121)
            DISPLAY BY NAME g_mmd.mmd121
            IF (NOT li_result) THEN
                NEXT FIELD mmd121
            END IF
#           CALL s_mfgslip(g_t1,'asf','3')              #檢查單別
#           IF NOT cl_null(g_errno) THEN                        #抱歉, 有問題
#              CALL cl_err(g_t1,g_errno,0)
#              NEXT FIELD mmd121
#           END IF
#No.FUN550054--end
         END IF
 
      AFTER FIELD mmd13
         IF NOT cl_null(g_mmd.mmd13) THEN
            IF g_mmd.mmd13 NOT MATCHES '[YN]' THEN
               LET g_mmd.mmd13=g_mmd_o.mmd13
               DISPLAY BY NAME g_mmd.mmd13
               NEXT FIELD mmd13
            END IF
         END IF
         LET g_mmd_o.mmd13=g_mmd.mmd13
 
      AFTER FIELD mmd131
         IF NOT cl_null(g_mmd.mmd131) THEN
#No.FUN-550054--begin
#           LET g_t1=g_mmd.mmd131[1,3]
            LET g_t1=g_mmd.mmd131[1,g_doc_len]
            CALL s_check_no("apm",g_t1,"","3","","","")
            RETURNING li_result,g_mmd.mmd131
            LET g_mmd.mmd131 = s_get_doc_no(g_mmd.mmd131)
            DISPLAY BY NAME g_mmd.mmd131
            IF (NOT li_result) THEN
                NEXT FIELD mmd131
            END IF
#           CALL s_mfgslip(g_t1,'apm','3')              #檢查單別
#           IF NOT cl_null(g_errno) THEN                        #抱歉, 有問題
#              CALL cl_err(g_t1,g_errno,0)
#              NEXT FIELD mmd131
#           END IF
#No.FUN-550054--end
         END IF
 
      AFTER FIELD mmd14
         IF NOT cl_null(g_mmd.mmd14) THEN
            IF g_mmd.mmd14 NOT MATCHES '[YN]' THEN
               LET g_mmd.mmd14=g_mmd_o.mmd14
               DISPLAY BY NAME g_mmd.mmd14
               NEXT FIELD mmd14
            END IF
         END IF
         LET g_mmd_o.mmd14=g_mmd.mmd14
 
      AFTER FIELD mmd141
         IF NOT cl_null(g_mmd.mmd141) THEN
#No.FUN-550054--begin
#           LET g_t1=g_mmd.mmd141[1,3]
            LET g_t1=g_mmd.mmd141[1,g_doc_len]
            CALL s_check_no("apm",g_t1,"","7","","","")
            RETURNING li_result,g_mmd.mmd141
            LET g_mmd.mmd141 = s_get_doc_no(g_mmd.mmd141)
            DISPLAY BY NAME g_mmd.mmd141
            IF (NOT li_result) THEN
                NEXT FIELD mmd141
            END IF
#           CALL s_mfgslip(g_t1,'apm','7')              #檢查單別
#           IF NOT cl_null(g_errno) THEN                        #抱歉, 有問題
#              CALL cl_err(g_t1,g_errno,0)
#              NEXT FIELD mmd141
#           END IF
#No.FUn-550054--end
         END IF
 
      AFTER FIELD mmd15
         IF g_mmd.mmd15 < 0 THEN
            NEXT FIELD mmd15 
         END IF
 
      AFTER FIELD mmd16
         IF NOT cl_null(g_mmd.mmd16) THEN 
            SELECT * FROM imd_file WHERE imd01=g_mmd.mmd16
                                      AND imdacti = 'Y' #MOD-4B0169
            IF STATUS THEN
#               CALL cl_err(g_mmd.mmd16,'mfg1100',0) #No.FUN-660094
                CALL cl_err3("sel","imd_file",g_mmd.mmd16,"","mfg1100","","",0)        #NO.FUN-660094
               NEXT FIELD mmd16
            END IF
         END IF
      #FUN-B50039-add-str--
      AFTER FIELD mmdud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmdud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmdud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmdud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmdud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmdud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmdud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmdud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmdud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmdud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmdud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmdud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmdud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmdud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmdud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-B50039-add-end--
 
    ON ACTION controlp
          CASE 
             WHEN INFIELD(mmd011) 
                 CALL q_smy( FALSE,TRUE,g_mmd.mmd011,'ASF','1') #TQC-670008
                      RETURNING g_mmd.mmd011
#                 CALL FGL_DIALOG_SETBUFFER(g_mmd.mmd011)
                 DISPLAY BY NAME g_mmd.mmd011 
                 NEXT FIELD mmd011 
             WHEN INFIELD(mmd021) 
                 CALL q_smy( FALSE,TRUE,g_mmd.mmd021,'AIM','2') #TQC-670008
                      RETURNING g_mmd.mmd021
#                 CALL FGL_DIALOG_SETBUFFER(g_mmd.mmd021)
                 DISPLAY BY NAME g_mmd.mmd021 
                 NEXT FIELD mmd021 
             WHEN INFIELD(mmd022) 
                 CALL cl_init_qry_var()
#                 LET g_qryparam.form     = "q_azf"
                 LET g_qryparam.form     = "q_azf01a"      #No.FUN-930104
                 LET g_qryparam.default1 = g_mmd.mmd022    #No.FUN-930104
#                 LET g_qryparam.arg1     = "2"            #No.FUN-930104
                 LET g_qryparam.arg1     = "4"             #No.FUN-930104  
                 CALL cl_create_qry() RETURNING g_mmd.mmd022
#                 CALL FGL_DIALOG_SETBUFFER( g_mmd.mmd022 )
                 DISPLAY BY NAME g_mmd.mmd022 
                 NEXT FIELD mmd022 
             WHEN INFIELD(mmd031) 
                 CALL q_smy( FALSE,TRUE,g_mmd.mmd031,'ASF','3') #TQC-670008
                      RETURNING g_mmd.mmd031
#                 CALL FGL_DIALOG_SETBUFFER(g_mmd.mmd031)
                 DISPLAY BY NAME g_mmd.mmd031 
                 NEXT FIELD mmd031 
             WHEN INFIELD(mmd041) 
                 CALL q_smy( FALSE,TRUE,g_mmd.mmd041,'ASF','A') #TQC-670008
                      RETURNING g_mmd.mmd041
#                 CALL FGL_DIALOG_SETBUFFER(g_mmd.mmd041)
                 DISPLAY BY NAME g_mmd.mmd041 
                 NEXT FIELD mmd041 
             WHEN INFIELD(mmd051) 
                 CALL q_smy( FALSE,TRUE,g_mmd.mmd051,'APM','1') #TQC-670008
                      RETURNING g_mmd.mmd051
#                 CALL FGL_DIALOG_SETBUFFER(g_mmd.mmd051)
                 DISPLAY BY NAME g_mmd.mmd051 
                 NEXT FIELD mmd051 
             WHEN INFIELD(mmd061) 
                 CALL q_smy( FALSE,TRUE,g_mmd.mmd061,'APM','2') #TQC-670008
                      RETURNING g_mmd.mmd061
#                 CALL FGL_DIALOG_SETBUFFER(g_mmd.mmd061)
                 DISPLAY BY NAME g_mmd.mmd061 
                 NEXT FIELD mmd061 
             WHEN INFIELD(mmd071) 
                 CALL q_smy( FALSE,TRUE,g_mmd.mmd071,'APM','3') #TQC-670008
                      RETURNING g_mmd.mmd071
#                 CALL FGL_DIALOG_SETBUFFER(g_mmd.mmd071)
                 DISPLAY BY NAME g_mmd.mmd071 
                 NEXT FIELD mmd071 
             WHEN INFIELD(mmd081) 
                 CALL q_smy( FALSE,TRUE,g_mmd.mmd081,'APM','7') #TQC-670008
                      RETURNING g_mmd.mmd081
#                 CALL FGL_DIALOG_SETBUFFER(g_mmd.mmd081)
                 DISPLAY BY NAME g_mmd.mmd081 
                 NEXT FIELD mmd081 
             WHEN INFIELD(mmd091) 
                 CALL q_smy( FALSE,TRUE,g_mmd.mmd091,'ASF','1') #TQC-670008
                      RETURNING g_mmd.mmd091
#                 CALL FGL_DIALOG_SETBUFFER(g_mmd.mmd091)
                 DISPLAY BY NAME g_mmd.mmd091 
                 NEXT FIELD mmd091 
             WHEN INFIELD(mmd101) 
                 CALL q_smy( FALSE,TRUE,g_mmd.mmd101,'APM','2') #TQC-670008
                      RETURNING g_mmd.mmd101
#                 CALL FGL_DIALOG_SETBUFFER(g_mmd.mmd101)
                 DISPLAY BY NAME g_mmd.mmd101 
                 NEXT FIELD mmd101
             WHEN INFIELD(mmd121) 
                 CALL q_smy( FALSE,TRUE,g_mmd.mmd121,'ASF','3') #TQC-670008
                      RETURNING g_mmd.mmd121
#                 CALL FGL_DIALOG_SETBUFFER(g_mmd.mmd121)
                 DISPLAY BY NAME g_mmd.mmd121 
                 NEXT FIELD mmd061 
             WHEN INFIELD(mmd131) 
                 CALL q_smy( FALSE,TRUE,g_mmd.mmd131,'APM','3') #TQC-670008
                      RETURNING g_mmd.mmd131
#                 CALL FGL_DIALOG_SETBUFFER(g_mmd.mmd131)
                 DISPLAY BY NAME g_mmd.mmd131
                 NEXT FIELD mmd131
             WHEN INFIELD(mmd141) 
                 CALL q_smy( FALSE,TRUE,g_mmd.mmd141,'APM','7') #TQC-670008
                      RETURNING g_mmd.mmd141
#                 CALL FGL_DIALOG_SETBUFFER(g_mmd.mmd141)
                 DISPLAY BY NAME g_mmd.mmd141
                 NEXT FIELD mmd141
	     WHEN INFIELD(mmd16)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_imd"
                LET g_qryparam.default1 = g_mmd.mmd16
                #LET g_qryparam.arg1     = "A"         #MOD-4A0213
                 LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                CALL cl_create_qry() RETURNING g_mmd.mmd16
#                CALL FGL_DIALOG_SETBUFFER( g_mmd.mmd16 )
 		DISPLAY BY NAME g_mmd.mmd16 
		NEXT FIELD mmd16
          END CASE
 
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
 
FUNCTION s100_mmd022(p_cmd)
DEFINE
   p_cmd       LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
   l_azf01     LIKE azf_file.azf01,
   l_azf09     LIKE azf_file.azf09,
   l_azfacti   LIKE azf_file.azfacti
   
   LET g_errno=' '
   SELECT azf01,azf09,azfacti INTO l_azf01,l_azf09,l_azfacti FROM azf_file  #No.FUN-930104
    WHERE azf01 = g_mmd.mmd022 AND azf02='2' #no:6818        
 
   CASE
       WHEN SQLCA.sqlcode = 100 LET g_errno='mfg3088'
                                LET l_azf01=NULL
       WHEN l_azfacti='N'       LET g_errno='9028'
       WHEN l_azf09 != '4'      LET g_errno='aoo-403'   #No.FUN-930104
       OTHERWISE    
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='u' OR cl_null(g_errno) THEN
   DISPLAY l_azf01 TO mmd022 
   END IF
END FUNCTION
