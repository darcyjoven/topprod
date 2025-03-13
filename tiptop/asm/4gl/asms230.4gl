# Prog. Version..: '5.30.06-13.04.02(00010)'     #
#
# Pattern name...: asms230.4gl
# Descriptions...: 製造管理系統參數設定作業–庫存料件
# Date & Author..: 92/39/21 By David
#                : Rearrange Screen Format & Recoding
# Modify.........: 95/03/21 By Danny (加sma892[1],sma892[2])
# Modify.........: No.FUN-540024 05/04/08 By Carrier 雙單位內容修改
# Modify.........: No: FUN-560220 05/06/27 By pengu 1.sma115/sma116/sma117 的設定拿掉
                                                #   2.新增參數 sma892_3 是否開窗詢問新增庫存明細檔資料  
# Modify.........: NO.FUN-5B0134 05/11/25 BY yiting modify 加上權限判斷 cl_chk_act_auth() 功能
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.CHI-690073 06/11/16 By pengu Disable掉sma12(多倉儲管理)參數畫面的維護，直接default為'Y'
# Modify.........: No.CHI-710041 07/03/13 By jamie 取消sma882欄位及其判斷
# Modify.........: No.TQC-790020 07/09/03 By lumingxing 快速/平速移動料件 周轉率大于100無控管
# Modify.........: No.FUN-890029 08/09/12 By sherry sma43 將2改為‘個別鑒定法’，移除5‘個別鑒定法’
# Modify.........: No.CHI-910041 09/02/03 By jan sma43, sma50 兩欄位移除
# Modify.........: No.FUN-870100 09/07/27 By Cockroach 零售超市移植
# Modify.........: No.CHI-960043 09/08/24 By dxfwo  本作業沒有呼叫cl_used(),當啟動aoos010做記錄時,則無法記錄本支作業的異動情況到p_used中
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0023 10/10/19 BY lixia 加上sam142，sma143，sma144字段
# Modify.........: No.FUN-B30127 11/03/22 By huangtao 不是流通業時，隱藏sma142、sma143、sma144 
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-C80030 12/08/10 By xujing 增加參數字段sma95 批/序號管理
# Modify.........: No:FUN-C80001 12/08/28 By bart 增加sma96 多角拋轉時，批號需一併拋轉
# Modify.........: No:FUN-CC0074 12/12/10 By zhangll 增加sma847第三碼:雜項報廢要輸入部門選項
# Modify.........: No:FUN-D30099 13/03/29 By Elise 將asms230的sma96搬到apms010,欄位改為pod08

DATABASE ds
 
GLOBALS "../../config/top.global"
     DEFINE
        g_sma892_1       LIKE type_file.chr1,   #No.FUN-690010 VARCHAR(1),
        g_sma892_2       LIKE type_file.chr1,   #No.FUN-690010CHAR(1),
        g_sma892_3       LIKE type_file.chr1,   #No.FUN-690010CHAR(1),    #FUN-560220
        g_sma847_1       LIKE type_file.chr1,   #No.FUN-690010CHAR(1),
        g_sma847_2       LIKE type_file.chr1,   #No.FUN-690010CHAR(1),
        g_sma847_3       LIKE type_file.chr1,   #FUN-CC0074 add
        g_sma_o         RECORD LIKE sma_file.*,  # 參數檔
        g_sma_t         RECORD LIKE sma_file.*   # 參數檔
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE  g_before_input_done LIKE type_file.num5    #No.FUN-690010 SMALLINT
MAIN
    OPTIONS
          INPUT NO WRAP
    DEFER INTERRUPT
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
    CALL asms230()
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION asms230()
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
         LET p_row = 4 LET p_col = 10
    ELSE LET p_row = 2 LET p_col = 4
    END IF
    OPEN WINDOW asms230_w AT p_row,p_col
        WITH FORM "asm/42f/asms230"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    IF g_azw.azw04 <> '2' THEN                      #No.FUN-870100
      CALL cl_set_comp_visible('sma139',FALSE)     #No.FUN-870100
    END IF                                         #No.FUN-870100
 
#FUN-B30127 --------------STA
    IF g_azw.azw04 <> '2' THEN 
      CALL cl_set_comp_visible('sma142,sma143,sma144',FALSE)
    END IF
#FUN-B30127 --------------END
    CALL asms230_show()
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL asms230_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW asms230_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.CHI-960043
END FUNCTION
 
FUNCTION asms230_show()
    SELECT * INTO g_sma.*
        FROM sma_file WHERE sma00 = '0'
    IF SQLCA.sqlcode THEN
#      CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660138
       CALL cl_err3("sel","sma_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660138
       RETURN
    END IF
   #-------------No.CHI-690073 modiy
   #DISPLAY BY NAME g_sma.sma12,g_sma.sma42,g_sma.sma882,
   #DISPLAY BY NAME g_sma.sma42,g_sma.sma882,  #CHI-710041 mark
   #-------------No.CHI-690073 end 
    DISPLAY BY NAME g_sma.sma42,               #CHI-710041 mod
                    g_sma.sma88,g_sma.sma884,  #bugno:6810 add
                    g_sma.sma68,g_sma.sma69, #g_sma.sma50,  #CHI-910041
                   #g_sma.sma43,g_sma.sma39     #CHI-910041
                    g_sma.sma39,g_sma.sma139    #CHI-910041 #FUN-870100 ADD 139
                    ,g_sma.sma142,g_sma.sma143,g_sma.sma144 #FUN-AA0023 add 142,143,144
                    #g_sma.sma115,g_sma.sma116,g_sma.sma117  #No.FUN-540024   #FUN-560220
                    ,g_sma.sma95        #FUN-C80030
                   #,g_sma.sma96        #FUN-C80001 #FUN-D30099 mark
 
    LET g_sma892_1=g_sma.sma892[1,1] DISPLAY g_sma892_1 TO g_sma892_1
    LET g_sma892_2=g_sma.sma892[2,2] DISPLAY g_sma892_2 TO g_sma892_2
    LET g_sma892_3=g_sma.sma892[3,3] DISPLAY g_sma892_3 TO g_sma892_3  #FUN-560220
    LET g_sma847_1=g_sma.sma847[1,1] DISPLAY g_sma847_1 TO g_sma847_1
    LET g_sma847_2=g_sma.sma847[2,2] DISPLAY g_sma847_2 TO g_sma847_2
    LET g_sma847_3=g_sma.sma847[3,3] DISPLAY g_sma847_3 TO g_sma847_3  #FUN-CC0074 add
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION asms230_menu()
    MENU ""
    ON ACTION modify
#NO.FUN-5B0134 START---
       LET g_action_choice="modify"
       IF cl_chk_act_auth() THEN
           CALL asms230_u()
       END IF
#NO.FUN-5B0134 END----
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
 
 
FUNCTION asms230_u()
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_forupd_sql =
      "SELECT *  FROM sma_file",
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
   #-------------No.CHI-690073 modify
   #DISPLAY BY NAME g_sma.sma12,g_sma.sma42,g_sma.sma882,
   #DISPLAY BY NAME g_sma.sma42,g_sma.sma882,    #CHI-710041 mark
   #-------------No.CHI-690073 end
    DISPLAY BY NAME g_sma.sma42,                 #CHI-710041 mod
                    g_sma.sma88,g_sma.sma884,    #bugno:6810 add
                    g_sma.sma68,g_sma.sma69, #g_sma.sma50,  #CHI-910041
                    g_sma.sma39                             #CHI-910041 移除g_sma.sma43
                    #g_sma.sma115,g_sma.sma116,g_sma.sma117  #No.FUN-540024  #FUN-560220
                   ,g_sma.sma139                  #FUN-870100 add  
                   ,g_sma.sma142,g_sma.sma143,g_sma.sma144 #FUN-AA0023 add 142,143,144 
                   ,g_sma.sma95        #FUN-C80030
                  #,g_sma.sma96        #FUN-C80001 #FUN-D30099 mark
    LET g_sma892_1=g_sma.sma892[1,1] DISPLAY g_sma892_1 TO g_sma892_1
    LET g_sma892_2=g_sma.sma892[2,2] DISPLAY g_sma892_2 TO g_sma892_2
    LET g_sma892_3=g_sma.sma892[3,3] DISPLAY g_sma892_3 TO g_sma892_3  #-FUN-560220
    LET g_sma847_1=g_sma.sma847[1,1] DISPLAY g_sma847_1 TO g_sma847_1
    LET g_sma847_2=g_sma.sma847[2,2] DISPLAY g_sma847_2 TO g_sma847_2
    LET g_sma847_3=g_sma.sma847[3,3] DISPLAY g_sma847_3 TO g_sma847_3  #FUN-CC0074 add
    WHILE TRUE
        CALL asms230_i()
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_sma.sma12 ='Y'      #No.CHI-690073 add
        UPDATE sma_file SET
            sma12=g_sma.sma12,
            sma42=g_sma.sma42, sma68=g_sma.sma68,
           #sma69=g_sma.sma69, sma50=g_sma.sma50,   #CHI-910041
           #sma43=g_sma.sma43, sma39=g_sma.sma39,   #CHI-910041
            sma69=g_sma.sma69,                      #CHI-910041
            sma39=g_sma.sma39,sma139=g_sma.sma139,  #CHI-910041  #FUN-870100 add 139
            sma142=g_sma.sma142,sma143=g_sma.sma143,sma144=g_sma.sma144, #FUN-AA0023 add 142,143,144
           #sma88=g_sma.sma88, sma882= g_sma.sma882, #CHI-710041 mark
            sma88=g_sma.sma88,                       #CHI-710041 mod  
            sma884=g_sma.sma884,    #bugno:6810 add
            sma892=g_sma.sma892,sma847=g_sma.sma847
            ,sma95 = g_sma.sma95       #FUN-C80030
           #,sma96 = g_sma.sma96       #FUN-C80001 #FUN-D30099 mark
          #--FUN-560220
            #No.FUN-540024
            #sma115=g_sma.sma115,sma116=g_sma.sma116,
            #sma117=g_sma.sma117
            #No.FUN-540024  --end
          #---end
            WHERE sma00='0'
        IF SQLCA.sqlcode THEN
#           CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660138
            CALL cl_err3("upd","sma_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660138
            CONTINUE WHILE
        END IF
        #FUN-C80030---add---str---
        IF g_sma.sma90 = 'Y' AND g_sma.sma95 = 'N' THEN
           CALL cl_err('','asm-231',0)
           UPDATE sma_file SET sma90 = 'N' 
                         WHERE sma00 = '0'
        END IF
        #FUN-C80030---add---end---
        UNLOCK TABLE sma_file
        EXIT WHILE
    END WHILE
    CLOSE sma_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION asms230_i()
   DEFINE   l_dir LIKE type_file.chr1    #No.FUN-690010  VARCHAR(01)
 
 
  #-----------No.CHI-690073 modify
  #INPUT BY NAME g_sma.sma12,g_sma.sma42,g_sma.sma68,
   INPUT BY NAME g_sma.sma42,g_sma.sma68,
  #-----------No.CHI-690073 end
                #g_sma.sma69,g_sma892_1,g_sma.sma882,g_sma.sma88, #CHI-710041 mark
                 g_sma.sma69,g_sma892_1,g_sma.sma88,              #CHI-710041 mod
                 g_sma.sma884,  #bugno:6810 add
                 g_sma892_2,g_sma892_3,g_sma847_1,g_sma847_2,  #-FUN-560220 add g_sma892_3
                 g_sma847_3,   #FUN-CC0074 add
                #g_sma.sma50,g_sma.sma43,g_sma.sma39     #CHI-910041
                 g_sma.sma39,g_sma.sma139                #CHI-910041 #FUN-870100 ADD 139
                 ,g_sma.sma142,g_sma.sma143,g_sma.sma144 #FUN-AA0023 add 142,143,144
                 ,g_sma.sma95       #FUN-C80030 add 
                #,g_sma.sma96       #FUN-C80001 #FUN-D30099 mark       
                 #g_sma.sma115,g_sma.sma116,g_sma.sma117  #NO.FUN-540024  #FUN-560220
                 WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL s230_set_entry()
          CALL s230_set_no_entry()
          LET g_before_input_done = TRUE
          ##FUN-C80030---add---str---
          IF cl_null(g_sma.sma95) OR g_sma.sma95 IS NULL THEN
             IF g_azw.azw04 = '1' THEN
                LET g_sma.sma95 = 'Y'
             ELSE
                LET g_sma.sma95 = 'N'
             END IF
          END IF
          DISPLAY BY NAME g_sma.sma95
          ##FUN-C80030---add---end---
 
     #----------No.CHI-690073 mark
     #BEFORE  FIELD sma12
     #    CALL s230_set_entry()
 
     #AFTER FIELD sma12
     #   IF NOT cl_null(g_sma.sma12) THEN
     #       IF g_sma.sma12 NOT MATCHES '[YN]' THEN
     #          LET g_sma.sma12=g_sma_o.sma12
     #          DISPLAY BY NAME g_sma.sma12
     #          NEXT FIELD sma12
     #       END IF
     #       LET g_sma_o.sma12=g_sma.sma12
     #   END IF
     #   CALL s230_set_no_entry()
     #----------No.CHI-690073 end 
 
      AFTER FIELD sma42
         IF NOT cl_null(g_sma.sma42) THEN
             IF g_sma.sma42 NOT MATCHES '[123]' THEN
                LET g_sma.sma42=g_sma_o.sma42
                DISPLAY BY NAME g_sma.sma42
                NEXT FIELD sma42
             END IF
             LET g_sma_o.sma42=g_sma.sma42
         END IF
     #CHI-710041---mark---str---
     #AFTER FIELD sma882
     #   IF NOT cl_null(g_sma.sma882) THEN
     #       IF g_sma.sma882 NOT MATCHES '[YN]' THEN
     #          LET g_sma.sma882=g_sma_o.sma882
     #          DISPLAY BY NAME g_sma.sma882
     #          NEXT FIELD sma882
     #       END IF
     #   END IF
     #CHI-710041---mark---end---
 
      AFTER FIELD sma88
         IF NOT cl_null(g_sma.sma88) THEN
             IF g_sma.sma88 NOT MATCHES '[YN]' THEN
                LET g_sma.sma88=g_sma_o.sma88
                DISPLAY BY NAME g_sma.sma88
                NEXT FIELD sma88
             END IF
         END IF
 
#bugno:6810 add .........................................................
      BEFORE FIELD sma884
         IF cl_null(g_sma.sma884) THEN
            LET g_sma.sma884='N'
            DISPLAY BY NAME g_sma.sma884
         END IF
 
      AFTER FIELD sma884
         IF NOT cl_null(g_sma.sma884) THEN
             IF g_sma.sma884 NOT MATCHES '[YN]' THEN
                LET g_sma.sma884=g_sma_o.sma884
                DISPLAY BY NAME g_sma.sma884
                NEXT FIELD sma884
             END IF
         END IF
#bugno:6810 end .........................................................
 
      AFTER FIELD sma68
         IF NOT cl_null(g_sma.sma68) THEN
#            IF g_sma.sma68 < 0 OR g_sma.sma68 < g_sma.sma69 THEN   #mark by lumingxing
             IF g_sma.sma68 < 0 OR g_sma.sma68 < g_sma.sma69 OR g_sma.sma68 > 100 THEN   #TQC-790020
                LET g_sma.sma68=g_sma_o.sma68
                DISPLAY BY NAME g_sma.sma68
                NEXT FIELD sma68
             END IF
             LET g_sma_o.sma68=g_sma.sma68
             LET l_dir ='U'
         END IF
 
      AFTER FIELD sma69
         IF NOT cl_null(g_sma.sma69) THEN
#            IF g_sma.sma69 <0 OR g_sma.sma69 > g_sma.sma68 THEN    #mark by lumingxing
             IF g_sma.sma69 <0 OR g_sma.sma69 > g_sma.sma68 OR g_sma.sma69 > 100 THEN   #TQC-790020
                LET g_sma.sma69=g_sma_o.sma69
                DISPLAY BY NAME g_sma.sma69
                NEXT FIELD sma68
             END IF
             LET g_sma_o.sma69=g_sma.sma69
         END IF
 
#     BEFORE FIELD sma50
#        IF cl_null(g_sma.sma24) THEN
#           CALL cl_err(g_sma.sma24,'mfg0077',3)
#           CLOSE WINDOW asms230_w
#           EXIT PROGRAM
#        END IF
 
      #CHI-910041--BEGIN--MARK--
      #AFTER FIELD sma50
      #   IF NOT cl_null(g_sma.sma50) THEN
      #       IF g_sma.sma50 NOT MATCHES '[1234]' THEN
      #            LET g_sma.sma50=g_sma_o.sma50
      #            DISPLAY BY NAME g_sma.sma50
      #            NEXT FIELD sma50
      #      END IF
      #      #採用標準制成本時, 只可使用 3.個別鑑定法
      #      IF g_sma.sma24 = 'Y' AND g_sma.sma50 NOT MATCHES '[34]' THEN
      #         CALL cl_err(g_sma.sma24,'mfg0078',0)
      #         LET g_sma.sma50='3'
      #         DISPLAY BY NAME g_sma.sma50
      #         NEXT FIELD sma50
      #      END IF
      #      LET g_sma_o.sma50=g_sma.sma50
      #  END IF
      #CHI-910041--END--MARK--
 
      AFTER FIELD g_sma892_1
         IF NOT cl_null(g_sma892_1) THEN
             IF g_sma892_1 NOT MATCHES "[12]" THEN
                 NEXT FIELD g_sma892_1
             END IF
         END IF
 
      AFTER FIELD g_sma892_2
         IF NOT cl_null(g_sma892_2) THEN
             IF g_sma892_2 NOT MATCHES "[NnYy]" THEN
                 NEXT FIELD g_sma892_2
             END IF
         END IF
 
    #----------------FUN-560220--------------------------
      AFTER FIELD g_sma892_3
         IF NOT cl_null(g_sma892_3) THEN
             IF g_sma892_3 NOT MATCHES "[NnYy]" THEN
                 NEXT FIELD g_sma892_3
             END IF
         END IF
    #----------------FUN-560220--------------------------
 
#CHI-910041--BEGIN--MARK--
#     AFTER FIELD sma43
#        IF NOT cl_null(g_sma.sma43) THEN
#            #IF g_sma.sma43 NOT MATCHES '[12345]' THEN  #No.FUN-890029
#             IF g_sma.sma43 NOT MATCHES '[1234]' THEN   #No.FUN-890029
#               LET g_sma.sma43=g_sma_o.sma43
#               DISPLAY BY NAME g_sma.sma43
#               NEXT FIELD sma43
#            END IF
#            #庫存發料順序採用先進先出法時, 成本計價方式只可使用 1.先進先出法
#            IF g_sma.sma50 = '1' AND g_sma.sma43 != '1' THEN
#               CALL cl_err(g_sma.sma43,'mfg0079',0)
#               LET g_sma.sma43=g_sma_o.sma43
#               DISPLAY BY NAME g_sma.sma43
#               NEXT FIELD sma43
#            END IF
#            #No.FUN-890029---Begin
#            ##庫存發料順序採用後進先出法時, 成本計價方式只可使用 2.後進先出法
#            #IF g_sma.sma50 = '2' AND g_sma.sma43 != '2' THEN
#            #   CALL cl_err(g_sma.sma43,'mfg0080',0)
#            #   LET g_sma.sma43=g_sma_o.sma43
#            #   DISPLAY BY NAME g_sma.sma43
#            #   NEXT FIELD sma43
#            #END IF
#            #No.FUN-890029---End
#            #庫存發料順序採用個別鑑定法且採用實際成本時,
#            #    成本計價方式只可使用 3.移動加權平均 或 4.月加權平均法
#            #                         2.個別鑑定法
#            IF g_sma.sma50 = '3' AND g_sma.sma24='N'
#                                 #AND g_sma.sma43 NOT MATCHES '[345]' THEN #No.FUN-890029
#                                 AND g_sma.sma43 NOT MATCHES '[234]' THEN #No.FUN-890029
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
#            LET g_sma_o.sma43=g_sma.sma43
#        END IF
#No.CHI-910041--END--MARK--
 
      #AFTER FIELD sma39
      ON CHANGE  sma39    #FUN-AA0023
         IF NOT cl_null(g_sma.sma39) THEN
             IF g_sma.sma39 NOT MATCHES '[YN]' THEN
                LET g_sma.sma39=g_sma_o.sma39
                DISPLAY BY NAME g_sma.sma39
                NEXT FIELD sma39
             END IF
             #No.FUN-870100  --BEGIN
             IF g_azw.azw04='2' AND g_sma.sma39 MATCHES '[Yy]' THEN
                CALL cl_err('','art-341',0)
                LET g_sma.sma39=g_sma_o.sma39  
                DISPLAY BY NAME g_sma.sma39          
                NEXT FIELD sma39         
             END IF        
             #No.FUN-870100  --END
             LET g_sma_o.sma39=g_sma.sma39
         END IF

#FUN-AA0023---add---start----
     ON CHANGE sma142
        CALL s230_set_entry()
        CALL s230_set_no_entry()

#FUN-AA0023---add---end----        
         
#-----------------------FUN-560220-------------------------------
#     #No.FUN-540024
#     BEFORE FIELD sma115
#        CALL s230_set_entry()
 
#     AFTER FIELD sma115
#        IF NOT cl_null(g_sma.sma115) THEN
#            IF g_sma.sma115 NOT MATCHES '[YN]' THEN
#               LET g_sma.sma115=g_sma_o.sma115
#               DISPLAY BY NAME g_sma.sma115
#               NEXT FIELD sma115
#            END IF
#            LET g_sma_o.sma115=g_sma.sma115
#        END IF
#        CALL s230_set_no_entry()
 
#     AFTER FIELD sma116 
#        IF NOT cl_null(g_sma.sma116) THEN
#            IF g_sma.sma116 NOT MATCHES '[YN]' THEN
#               LET g_sma.sma116=g_sma_o.sma116
#               DISPLAY BY NAME g_sma.sma116
#               NEXT FIELD sma116
#            END IF
#            LET g_sma_o.sma116=g_sma.sma116
#        END IF
 
#     AFTER FIELD sma117
#        IF NOT cl_null(g_sma.sma117) THEN
#            IF g_sma.sma117 NOT MATCHES '[YN]' THEN
#               LET g_sma.sma117=g_sma_o.sma117
#               DISPLAY BY NAME g_sma.sma117
#               NEXT FIELD sma117
#            END IF
#            LET g_sma_o.sma117=g_sma.sma117
#        END IF
#     #No.FUN-540024  --end
#-----------------------FUN-560220-------------------------------
 
      AFTER FIELD g_sma847_1
         IF NOT cl_null(g_sma847_1) THEN
             IF g_sma847_1 NOT MATCHES "[NnYy]" THEN
                 NEXT FIELD g_sma847_1
             END IF
         END IF
 
      AFTER FIELD g_sma847_2
         IF NOT cl_null(g_sma847_2) THEN
             IF g_sma847_2 NOT MATCHES "[NnYy]" THEN
                 NEXT FIELD g_sma847_2
             END IF
         END IF

    #FUN-CC0074 add
      AFTER FIELD g_sma847_3
         IF NOT cl_null(g_sma847_3) THEN
             IF g_sma847_3 NOT MATCHES "[NnYy]" THEN
                 NEXT FIELD g_sma847_3
             END IF
         END IF
    #FUN-CC0074 add--end

    #FUN-C80030---add---str---
      AFTER FIELD sma95
         IF g_sma.sma95 NOT MATCHES "[YN]" THEN
            NEXT FIELD sma95
         END IF 
    #FUN-C80030---add---end---

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
 
   LET g_sma.sma892[1,1] = g_sma892_1
   LET g_sma.sma892[2,2] = g_sma892_2
   LET g_sma.sma892[3,3] = g_sma892_3  #FUN-560220
   LET g_sma.sma847[1,1] = g_sma847_1
   LET g_sma.sma847[2,2] = g_sma847_2
   LET g_sma.sma847[3,3] = g_sma847_3  #FUN-CC0074 add
END FUNCTION
 
#genero
FUNCTION s230_set_entry()
 
  #-----------No.CHI-690073 mark
  #IF INFIELD(sma12) OR (NOT g_before_input_done) THEN
  #   CALL cl_set_comp_entry("sma42",TRUE)
  #END IF
  #-----------No.CHI-690073 end
 
   IF (NOT g_before_input_done) THEN
     #CALL cl_set_comp_entry("sma50,sma43,sma39",TRUE) #CHI-910041
      CALL cl_set_comp_entry("sma39",TRUE)             #CHI-910041
   END IF
   #FUN-AA0023---ADD---STR---
      IF g_sma.sma142 MATCHES '[Yy]' THEN
         CALL cl_set_comp_entry("sma143",TRUE)
      END IF
     #FUN-AA0023---ADD---END---
 
 #--FUN-560220
  ##No.FUN-540024  --begin
  #IF INFIELD(sma115) OR (NOT g_before_input_done) THEN
  #   CALL cl_set_comp_entry("sma116",TRUE)
  #END IF
  ##No.FUN-540024  --end   
 #---end
 
END FUNCTION
 
FUNCTION s230_set_no_entry()
 
  #-----------No.CHI-690073 mark
  #IF INFIELD(sma12) OR (NOT g_before_input_done) THEN
  #   IF g_sma.sma12='N' THEN
  #       CALL cl_set_comp_entry("sma42",FALSE)
  #   END IF
  #END IF
  #-----------No.CHI-690073 end
 
   IF (NOT g_before_input_done) THEN
      IF cl_null(g_sma.sma24) THEN
         #CALL cl_set_comp_entry("sma50,sma43,sma39",FALSE)#FUN-910041
         CALL cl_set_comp_entry("sma39",FALSE)    #FUN-910041
      END IF
     #FUN-870100 ADD--
      IF g_azw.azw04<>'2'THEN 
         CALL cl_set_comp_entry("sma139",FALSE)
      END IF
     #FUN-870100 END---
   END IF
   #FUN-AA0023---ADD---STR---
      IF g_sma.sma142 NOT MATCHES '[Yy]' THEN
         CALL cl_set_comp_entry("sma143",FALSE)
      END IF
     #FUN-AA0023---ADD---END---
 #--FUN-560220
  ##No.FUN-540024  --begin
  #IF INFIELD(sma115) OR (NOT g_before_input_done) THEN
  #   IF g_sma.sma115 = 'Y' THEN
  #      LET g_sma.sma116 = 'Y'
  #      DISPLAY BY NAME g_sma.sma116
  #      CALL cl_set_comp_entry("sma116",FALSE)
  #   END IF
  #END IF
  ##No.FUN-540024  --end
 #--end
 
END FUNCTION
