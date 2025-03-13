# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asms120.4gl
# Descriptions...: 製造管理系統參數設定作業–成本會計
# Date & Author..: 93/10/27 By Wenni 
# Modify ........: 93/12/14 By Wenni
# Modify.........: No.MOD-480026 04/08/26 By Nicola 過期資料保留期間數無法修改
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-680037 06/08/29 By rainy 取消sma881
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-6A0054 06/10/20 By Sarah 將sma87改成開窗,於輸入後檢查存在否
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-830044 08/03/24 By lumx 調整after field sma43的控制邏輯使之與asms230中的控制邏輯一致
# Modify.........: No.FUN-890029 08/09/12 By sherry sma43 將2改為‘個別鑒定法’，移除5‘個別鑒定法’
# Modify.........: No.CHI-910041 09/02/03 By jan mark掉運用到sma50判斷邏輯的部分
# Modify.........: No.CHI-960043 09/08/24 By dxfwo  本作業沒有呼叫cl_used(),當啟動aoos010做記錄時,則無法記錄本支作業的異動情況到p_used中
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
DATABASE ds
 
GLOBALS "../../config/top.global"
     DEFINE
        g_sma_t         RECORD LIKE sma_file.*,  # 參數檔
        g_sma_o         RECORD LIKE sma_file.*   # 參數檔
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
MAIN
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
    CALL asms120(0,0)
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN  
 
FUNCTION asms120(p_row,p_col)
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
 
    LET p_row = 4 LET p_col =20
    OPEN WINDOW asms120_w AT p_row,p_col WITH FORM "asm/42f/asms120" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL asms120_show()
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL asms120_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW asms120_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.CHI-960043 
 
END FUNCTION
 
FUNCTION asms120_show()
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00 = '0'
    IF SQLCA.SQLCODE THEN
#      CALL cl_err('',SQLCA.SQLCODE,0)   #No.FUN-660138
       CALL cl_err3("sel","sma_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660138
       RETURN
    END IF
  # default value
    IF cl_null(g_sma.sma80) THEN LET g_sma.sma80='1'  END IF
    IF cl_null(g_sma.sma81) THEN LET g_sma.sma81='1'  END IF
    IF cl_null(g_sma.sma82) THEN LET g_sma.sma82='1'  END IF
    IF cl_null(g_sma.sma23) THEN LET g_sma.sma23='1'  END IF 
    IF cl_null(g_sma.sma43) THEN LET g_sma.sma43='4'  END IF
    IF cl_null(g_sma.sma87) THEN LET g_sma.sma87=g_plant END IF
    #IF cl_null(g_sma.sma881) THEN LET g_sma.sma881='1' END IF   #FUN-680037 remark
    #---> modify by wenni
    IF cl_null(g_sma.sma889) THEN LET g_sma.sma889='1' END IF 
    IF cl_null(g_sma.sma89) THEN LET g_sma.sma89='1' END IF 
    IF cl_null(g_sma.sma891) THEN LET g_sma.sma891='Y' END IF 
    #--->
    DISPLAY BY NAME g_sma.sma80,g_sma.sma81,g_sma.sma82,g_sma.sma23,
                    g_sma.sma43,g_sma.sma86,g_sma.sma87,  #FUN-680037 del sma881
                    g_sma.sma889,g_sma.sma89,g_sma.sma20,g_sma.sma891
                    
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION asms120_menu()
    MENU ""
    ON ACTION modify
        LET g_action_choice="modify"
        IF cl_chk_act_auth() THEN
            CALL asms120_u()
        END IF
    ON ACTION help    CALL cl_show_help()
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
 
 
FUNCTION asms120_u()
    MESSAGE ""
    CALL cl_opmsg('u')
 
    LET g_forupd_sql = "SELECT * FROM sma_file WHERE sma00 = ? FOR UPDATE " 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE sma_curl CURSOR FROM g_forupd_sql
 
    BEGIN WORK
    OPEN sma_curl USING '0'
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('open cursor',SQLCA.sqlcode,1)
       RETURN
    END IF
    FETCH sma_curl INTO g_sma.*
    IF SQLCA.SQLCODE != 0 THEN
       CALL cl_err('',SQLCA.SQLCODE,0)
       RETURN
    END IF
    LET g_sma_t.* = g_sma.*
    LET g_sma_o.* = g_sma.*
    DISPLAY BY NAME g_sma.sma80,g_sma.sma81,g_sma.sma82,g_sma.sma23,
                    g_sma.sma43,g_sma.sma86,g_sma.sma87,             #FUN-680037 del sma881
                    g_sma.sma889,g_sma.sma89,g_sma.sma20,g_sma.sma891
                    
    WHILE TRUE
        CALL asms120_i()
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           ROLLBACK WORK
           EXIT WHILE
        END IF
        UPDATE sma_file SET
               sma80=g_sma.sma80,
               sma81=g_sma.sma81,
               sma82=g_sma.sma82,
               sma23=g_sma.sma23,
               sma43=g_sma.sma43,
               sma86=g_sma.sma86,
               sma87=g_sma.sma87,
              #sma881=g_sma.sma881,  #FUN-680037 remark
               sma889=g_sma.sma889,   #
               sma89=g_sma.sma89,     #
               sma20=g_sma.sma20,      # 
               sma891=g_sma.sma891 
            WHERE sma00='0'
        IF SQLCA.SQLCODE THEN
#           CALL cl_err('',SQLCA.SQLCODE,0)   #No.FUN-660138
            CALL cl_err3("upd","sma_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660138
            CONTINUE WHILE
        END IF
        UNLOCK TABLE sma_file
        EXIT WHILE
    END WHILE
    CLOSE sma_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION asms120_i()
   DEFINE l_cnt   INTEGER   #FUN-6A0054 add
 
   INPUT BY NAME g_sma.sma80,g_sma.sma81,g_sma.sma82,g_sma.sma23,
                 g_sma.sma891,g_sma.sma20,g_sma.sma43,g_sma.sma86,
                #g_sma.sma87,g_sma.sma881,g_sma.sma889,g_sma.sma89  #FUN-680037
                 g_sma.sma87,g_sma.sma889,g_sma.sma89               #FUN-680037
       WITHOUT DEFAULTS 
 
       AFTER FIELD sma80
          IF NOT cl_null(g_sma.sma80) THEN 
             IF g_sma.sma80 NOT MATCHES "[1234]" THEN 
                LET g_sma.sma80=g_sma_o.sma80
                DISPLAY BY NAME g_sma.sma80
                NEXT FIELD sma80
             END IF
             IF g_sma.sma26='1' OR g_sma.sma54='N' THEN
                IF g_sma.sma80 MATCHES "[34]" THEN
                   CALL cl_err('asms120','mfg9270',0)
                   NEXT FIELD sma80
                END IF
             END IF
          END IF
          LET g_sma_o.sma80=g_sma.sma80
 
       AFTER FIELD sma81
          IF NOT cl_null(g_sma.sma81) THEN
             IF g_sma.sma81 NOT MATCHES "[12]"  THEN
                LET g_sma.sma81=g_sma_o.sma81
                DISPLAY BY NAME g_sma.sma81
                NEXT FIELD sma81
             END IF
          LET g_sma_o.sma81=g_sma.sma81
          END IF
 
       AFTER FIELD sma82
          IF NOT cl_null(g_sma.sma82) THEN
             IF g_sma.sma82 NOT MATCHES "[12]"  THEN
                LET g_sma.sma82=g_sma_o.sma82
                DISPLAY BY NAME g_sma.sma82
                NEXT FIELD sma82
             END IF
          END IF
          LET g_sma_o.sma82=g_sma.sma82
 
       AFTER FIELD sma23
          IF NOT cl_null(g_sma.sma23) THEN
             IF g_sma.sma23 NOT MATCHES "[123]" THEN
                LET g_sma.sma23=g_sma_o.sma23
                DISPLAY BY NAME g_sma.sma23
                NEXT FIELD sma23
             END IF
             IF g_sma.sma54='N' THEN
                IF g_sma.sma23='2' THEN
                   CALL cl_err('asms120','mfg9271',0)
                   NEXT FIELD sma23
                END IF
             END IF
          END IF
          LET g_sma_o.sma23=g_sma.sma23
 
       AFTER FIELD sma43
          IF NOT cl_null(g_sma.sma43) THEN
             IF g_sma.sma43 NOT MATCHES "[1234]" THEN
                LET g_sma.sma43=g_sma_o.sma43
                DISPLAY BY NAME g_sma.sma43
                NEXT FIELD sma43
             END IF
#TQC-830044----begin--
#CHI-910041--BEGIN--MARK--
#            #庫存發料順序採用先進先出法時, 成本計價方式只可使用 1.先進先出法
#            IF g_sma.sma50 = '1' AND g_sma.sma43 != '1' THEN
#               CALL cl_err(g_sma.sma43,'mfg0079',0)
#               LET g_sma.sma43=g_sma_o.sma43
#               DISPLAY BY NAME g_sma.sma43
#               NEXT FIELD sma43
#            END IF
#            #No.FUN-890029---Begin
#            #庫存發料順序採用後進先出法時, 成本計價方式只可使用 2.後進先出法
#            #IF g_sma.sma50 = '2' AND g_sma.sma43 != '2' THEN
#            #   CALL cl_err(g_sma.sma43,'mfg0080',0)
#            #   LET g_sma.sma43=g_sma_o.sma43
#            #   DISPLAY BY NAME g_sma.sma43
#            #   NEXT FIELD sma43
#            #END IF
#            #No.FUN-890029---Begin
#            #庫存發料順序採用個別鑑定法且採用實際成本時,
#            #    成本計價方式只可使用 3.移動加權平均 或 4.月加權平均法
#            #                         5.個別鑑定法
#            IF g_sma.sma50 = '3' AND g_sma.sma24='N'
#                                 #AND g_sma.sma43 NOT MATCHES '[345]' THEN  #No.FUN-890029
#                                 AND g_sma.sma43 NOT MATCHES '[234]' THEN   #No.FUN-890029
#               CALL cl_err(g_sma.sma43,'mfg0082',0)
#               LET g_sma.sma43=g_sma_o.sma43
#               DISPLAY BY NAME g_sma.sma43
#               NEXT FIELD sma43
#            END IF
#            #庫存發料順序採用個別鑑定法且採用標準成本時,
#            #            成本計價方式只可使用 5.個別鑑定法
#            IF g_sma.sma50 = '3' AND g_sma.sma24='Y'
#                                 #AND g_sma.sma43 != '5' THEN  #No.FUN-890029
#                                 AND g_sma.sma43 != '2' THEN  #No.FUN-890029
#               CALL cl_err(g_sma.sma43,'mfg0081',0)
#               LET g_sma.sma43=g_sma_o.sma43
#               DISPLAY BY NAME g_sma.sma43
#               NEXT FIELD sma43
#            END IF
#CHI-910041--END--MARK--
             LET g_sma_o.sma43=g_sma.sma43
         END IF
#            IF g_sma.sma24!='Y' THEN
#               IF g_sma.sma43='5' THEN
#                  CALL cl_err('asms120','mfg9272',0)
#                  NEXT FIELD sma43
#               END IF
#            END IF
#         END IF
#         LET g_sma_o.sma43=g_sma.sma43
#TQC-830044----end----
 
    #FUN-680037 remark--start
     # AFTER FIELD sma881
     #    IF NOT cl_null(g_sma.sma881) THEN
     #       IF g_sma.sma881 NOT MATCHES "[12]" THEN
     #          LET g_sma.sma881=g_sma_o.sma881
     #          DISPLAY BY NAME g_sma.sma881
     #          NEXT FIELD sma881
     #       END IF
     #    END IF
     #    LET g_sma_o.sma881=g_sma.sma881
    #FUN-680037 remark--end
       AFTER FIELD sma889
          IF NOT cl_null(g_sma.sma889) THEN
             IF g_sma.sma889 NOT MATCHES "[123]"  THEN
                LET g_sma.sma889=g_sma_o.sma889
                DISPLAY BY NAME g_sma.sma889
                NEXT FIELD sma889
             END IF
          END IF
          LET g_sma_o.sma889=g_sma.sma889
 
       AFTER FIELD sma89
          IF NOT cl_null(g_sma.sma89) THEN
             IF g_sma.sma89 NOT MATCHES "[12]"  THEN
                LET g_sma.sma89=g_sma_o.sma89
                DISPLAY BY NAME g_sma.sma89
                NEXT FIELD sma89
             END IF
             IF g_sma.sma80 = '1' THEN
                IF g_sma.sma89 = '2' THEN
                   CALL cl_err('','mfg9324',0)
                   NEXT FIELD sma89
                END IF 
             END IF
          END IF
          LET g_sma_o.sma89=g_sma.sma89
 
       AFTER FIELD sma20
          IF NOT cl_null(g_sma.sma20) THEN
 #            LET g_sma.sma20=g_sma_o.sma20   #No.MOD-480026 Mark
             DISPLAY BY NAME g_sma.sma20
          #  NEXT FIELD sma20
             IF g_aza.aza02='1' THEN
                IF g_sma.sma20>12 THEN
                   CALL cl_err('','mfg9287',0)
                   NEXT FIELD sma20
                END IF
            ELSE
            #END IF
            #IF g_aza.aza02='2' THEN
                IF g_sma.sma20>13 THEN
                   CALL cl_err('','mfg9288',0)
                   NEXT FIELD sma20
                END IF
             END IF
          END IF
          LET g_sma_o.sma20=g_sma.sma20
 
       AFTER FIELD sma891
          IF NOT cl_null(g_sma.sma891) THEN 
             IF g_sma.sma891 NOT matches '[YN]' THEN 
                NEXT FIELD sma891
             END IF
          END IF
          DISPLAY BY NAME g_sma.sma891
 
      #start FUN-6A0054 add
       AFTER FIELD sma87   #總帳所在營運中心編號
          LET l_cnt = 0
          SELECT COUNT(*) INTO l_cnt FROM azp_file
           WHERE azp01 = g_sma.sma87
          IF l_cnt = 0 THEN
             LET g_sma.sma87=g_sma_o.sma87
             DISPLAY BY NAME g_sma.sma87
             CALL cl_err3("sel","azp_file",g_sma.sma87,"",SQLCA.sqlcode,"","Plant No.",1)
             NEXT FIELD sma87
          END IF
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(sma87)   #總帳所在營運中心編號
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_azp"
                LET g_qryparam.default1 = g_sma.sma87
                CALL cl_create_qry() RETURNING g_sma.sma87
                DISPLAY BY NAME g_sma.sma87
          END CASE
      #end FUN-6A0054 add
 
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
