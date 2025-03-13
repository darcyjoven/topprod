# Prog. Version..: '5.30.06-13.04.17(00010)'     #
 
#
# Pattern name...: asms210.4gl
# Descriptions...: 製造管理系統參數設定作業–整體參數
# Date & Author..: 92/12/18 By David
#                : Recoding and Reorder Form Screen
# Modify.........: 97/07/22 By Charis(加sma894)
# Modify.........: 99/07/08 By Carol:sma05,sma06改為no use
# Modify.........: 99/08/03 By Kammy:sma11 no use
# Modify.........: 03/08/29 By appleesma08 no use
# Modify.........: NO.FUN-5B0134 05/11/25 by yiting modify 加上權限判斷 cl_chk_act_auth() 功能
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-740074 07/04/13 By wujie  _u()中DISPLAY了不存在的欄位
# Modify.........: No.FUN-850115 08/04/28 By duke add APS整合版本
# Modify.........: No.MOD-860081 08/06/09 By jamie ON IDLE問題
# Modify.........: No.FUN-870156 08/07/29 BY duke  加上資源型態 sma917
# Modify.........: No.CHI-910041 09/02/03 BY jan 拿掉sma50
# Modify.........: No.TQC-920084 09/02/26 By Duke aps整合取消時,sma917需清成空白
# Modify.........: No.FUN-930164 09/04/15 By jamie update sma53成功時，寫入azo_file
# Modify.........: No.FUN-980008 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.CHI-960043 09/08/24 By dxfwo  本作業沒有呼叫cl_used(),當啟動aoos010做記錄時,則無法記錄本支作業的異動情況到p_used中 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/12 By vealxu 精簡程式碼
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-B50039 11/07/08 By fengrui 增加自定義欄位
# Modify.........: No.FUN-BC0059 11/12/16 By Mandy 增加欄位:sma918
# Modify.........: No.FUN-BC0062 12/02/15 By lilingyu 增加控管成本計算方式
# Modify.........: No.FUN-D30024 13/03/12 By qiull sma894改为no use
 
DATABASE ds
 
GLOBALS "../../config/top.global"
     DEFINE
        g_sma_t          RECORD LIKE sma_file.*,  # 預留參數檔
        g_sma_o          RECORD LIKE sma_file.*,  # 預留參數檔
        #FUN-D30024---mark---str---
        #g_sma894_1       LIKE type_file.chr1,   #No.FUN-690010  VARCHAR(1),
        #g_sma894_2	 LIKE type_file.chr1,   #No.FUN-690010  VARCHAR(1),
        #g_sma894_3	 LIKE type_file.chr1,   #No.FUN-690010  VARCHAR(1),
        #g_sma894_4       LIKE type_file.chr1,   #No.FUN-690010  VARCHAR(1),
        #g_sma894_5	 LIKE type_file.chr1,   #No.FUN-690010  VARCHAR(1),
        #g_sma894_6	 LIKE type_file.chr1,   #No.FUN-690010  VARCHAR(1),
        #g_sma894_7	 LIKE type_file.chr1,   #No.FUN-690010  VARCHAR(1),
        #g_sma894_8	 LIKE type_file.chr1,   #No.FUN-690010  VARCHAR(1),
        #FUN-D30024---mark---end---
        l_msg            LIKE ze_file.ze03,   #No.FUN-690010  VARCHAR(16),
        g_menu           LIKE type_file.chr1    #No.FUN-690010  VARCHAR(1)
 
DEFINE g_forupd_sql      STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_cnt             LIKE type_file.num10     #No.FUN-690010 INTEGER
DEFINE g_i               LIKE type_file.num5      #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE g_msg               LIKE type_file.chr1000 #FUN-930164 add
DEFINE g_flag              LIKE type_file.chr1    #FUN-930164 add
 
MAIN
    OPTIONS
          INPUT NO WRAP
    DEFER INTERRUPT
    LET g_sma.sma00='0'
    SELECT COUNT(*) INTO g_i
      FROM sma_file
     WHERE sma00 = '0'
    IF cl_null(g_i) OR g_i < = 0 THEN
        LET g_sma.smaoriu = g_user      #No.FUN-980030 10/01/04
        LET g_sma.smaorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO sma_file VALUES(g_sma.*)
    END IF
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
    CALL asms210()
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION asms210()
DEFINE p_row,p_col      LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
 
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
         LET p_row = 5 LET p_col = 13
    ELSE LET p_row = 4 LET p_col = 2
    END IF
    OPEN WINDOW asms210_w AT p_row,p_col
    WITH FORM "asm/42f/asms210"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL asms210_show()
 
      LET g_action_choice=""
    CALL asms210_menu()
 
    CLOSE WINDOW asms210_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.CHI-960043
END FUNCTION
 
FUNCTION asms210_show()
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00 = '0'
 
    IF SQLCA.sqlcode THEN
       LET g_sma.sma02 = "N"
       LET g_sma.sma03 = "N"   LET g_sma.sma04 = "N"
       LET g_sma.sma07 = "N"   LET g_sma.sma10 = "N"
       LET g_sma.sma24 = "Y"   LET g_sma.sma30 = g_today
       LET g_sma.sma77 = "1"   LET g_sma.sma901 = 'N'
       LET g_sma.sma916=" "   #FUN-850115 add 
       LET g_sma.sma917=" "   #FUN-870156 add
       LET g_sma.sma918=" "   #FUN-BC0059 add
       LET g_sma.sma79 = "N"
       SELECT azn02,azn04 INTO g_sma.sma51,g_sma.sma52
          FROM azn_file WHERE azn01 = g_sma.sma30
       IF SQLCA.sqlcode THEN
	      CALL cl_getmsg('mfg9101',g_lang) RETURNING l_msg
          LET g_sma.sma51 = 0
          LET g_sma.sma52 = 0
       END IF
       LET g_sma.smauser=g_user
       LET g_sma.smagrup=g_grup
       LET g_sma.smamodu=g_user
       LET g_sma.smadate=TODAY
       LET g_sma.smaacti="Y"
       INSERT INTO sma_file(sma00,sma02,sma03,sma04,
             sma07,sma10,sma24,sma30,sma51,sma52,sma77,sma53,sam79,sma901,    #Genero add
             sma916,    #FUN-850115 add
             sma917,    #FUN-870156 add
             sma918,    #FUN-BC0059 add
             smauser,smagrup,smamodu,smadate,smaacti,smaoriu,smaorig)
        VALUES ('0','N','N','N','N','N','N,','N','N','0',
                'Y',g_today,g_sma.sma51,g_sma.sma52,'0','N',' ','N','N',' ',' ',g_sma.sma918,  #FUN-BC0059 add sma918
                 g_sma.smauser,
                 g_sma.smagrup,g_sma.smamodu,g_sma.smadate,g_sma.smaacti, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
       IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","sma_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660138
          RETURN
       END IF
    ELSE
       CALL cl_getmsg('mfg9100',g_lang) RETURNING l_msg
       UPDATE sma_file SET sma02=g_sma.sma02,
                           sma03=g_sma.sma03,
                           sma04=g_sma.sma04,
                           sma07=g_sma.sma07,
                           sma10=g_sma.sma10,
                           sma24=g_sma.sma24,
                           sma30=g_sma.sma30,
                           sma51=g_sma.sma51,
                           sma52=g_sma.sma52,
                           sma77=g_sma.sma77,
                           #sma894=g_sma.sma894,   #FUN-D30024---mark---
                           sma53=g_sma.sma53,
                           sma79=g_sma.sma79,
                           sma901=g_sma.sma901,      #Genero add
                           sma916=g_sma.sma916,       #FUN-850115 add
                           sma917=g_sma.sma917,       #FUN-870156 add
                           sma918=g_sma.sma918,       #FUN-BC0059 add
                           smauser=g_sma.smauser,
                           smagrup=g_sma.smagrup,
                           smamodu=g_sma.smamodu,
                           smadate=g_sma.smadate,
                           smaacti=g_sma.smaacti,
                           #FUN-B50039-add-str--
                           smaud01=g_sma.smaud01,
                           #smaud02=g_sma.smaud02,   #mark by guanyao160903
                           #smaud03=g_sma.smaud03,   #mark by guanyao160928
                           smaud04=g_sma.smaud04,
                           smaud05=g_sma.smaud05,
                           smaud06=g_sma.smaud06,
                           smaud07=g_sma.smaud07,
                           smaud08=g_sma.smaud08,
                           smaud09=g_sma.smaud09,
                           smaud10=g_sma.smaud10,
                           smaud11=g_sma.smaud11,
                           smaud12=g_sma.smaud12,
                           smaud13=g_sma.smaud13,
                           smaud14=g_sma.smaud14,
                           smaud15=g_sma.smaud15
                           #FUN-B50039-add-end--
        WHERE sma00='0'
        IF g_flag='Y' THEN 
           LET g_errno = TIME
           LET g_msg = 'old:',g_sma_t.sma53,' new:',g_sma.sma53
           INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980008 add
              VALUES ('asms210',g_user,g_today,g_errno,'sma53',g_msg,g_plant,g_legal)   #FUN-980008 add
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","azo_file","asms210","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
              RETURN
           END IF
        END IF 
    END IF
    SELECT COUNT(*) INTO g_cnt FROM sma_file
     WHERE sma00='0'

    DISPLAY l_msg TO FORMONLY.d1
    DISPLAY BY NAME g_sma.sma02,g_sma.sma03,g_sma.sma04,g_sma.sma07,
                    g_sma.sma10,g_sma.sma24,g_sma.sma30,g_sma.sma51,
                    g_sma.sma52,g_sma.sma53,g_sma.sma79,g_sma.sma901,
                    g_sma.sma916,   #FUN-850115
                    g_sma.sma917,   #FUN-870156
                    g_sma.sma918,   #FUN-BC0059 add
                    #FUN-B50039-add-str--
                    #g_sma.smaud01,g_sma.smaud02,g_sma.smaud03,    #mark by guanyao160903
                    #g_sma.smaud01,g_sma.smaud03,                  #add by guanyao160903 #mark by guanyao160928
                    g_sma.smaud01,                                 #add by guanyao160928
                    g_sma.smaud04,g_sma.smaud05,g_sma.smaud06,
                    g_sma.smaud07,g_sma.smaud08,g_sma.smaud09,
                    g_sma.smaud10,g_sma.smaud11,g_sma.smaud12,
                    g_sma.smaud13,g_sma.smaud14,g_sma.smaud15
                    #FUN-B50039-add-end--
    #FUN-D30024---mark---str---
    #LET g_sma894_1=g_sma.sma894[1,1] DISPLAY g_sma894_1 TO g_sma894_1
    #LET g_sma894_2=g_sma.sma894[2,2] DISPLAY g_sma894_2 TO g_sma894_2
    #LET g_sma894_3=g_sma.sma894[3,3] DISPLAY g_sma894_3 TO g_sma894_3
    #LET g_sma894_4=g_sma.sma894[4,4] DISPLAY g_sma894_4 TO g_sma894_4
    #LET g_sma894_5=g_sma.sma894[5,5] DISPLAY g_sma894_5 TO g_sma894_5
    #LET g_sma894_6=g_sma.sma894[6,6] DISPLAY g_sma894_6 TO g_sma894_6
    #LET g_sma894_7=g_sma.sma894[7,7] DISPLAY g_sma894_7 TO g_sma894_7
    #LET g_sma894_8=g_sma.sma894[8,8] DISPLAY g_sma894_8 TO g_sma894_8
    #FUN-D30024---mark---end---
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
 #-依勾選是否與 APS 整合, 顯示/隱藏 APS 整合版本欄位
    CALL cl_set_comp_visible("sma916,sma917,sma918", g_sma.sma901 = 'Y')  #FUN-BC0059 add sma918
    CALL cl_set_comp_required("sma916,sma917,sma918", g_sma.sma901 = 'Y') #FUN-BC0059 add sma918
 
 
END FUNCTION
 
FUNCTION asms210_menu()
    DEFINE
      l_cmd     LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(10)
 
    MENU ""
    ON ACTION modify
        LET g_action_choice="modify"
        IF cl_chk_act_auth() THEN
            CALL asms210_u()
        END IF
 
    ON ACTION close_system
        LET l_cmd = "asms999"
        CALL cl_cmdrun(l_cmd)
    ON ACTION open_system
        LET l_cmd = "asms000"
        CALL cl_cmdrun(l_cmd)
    ON ACTION system_history
        LET l_cmd = "asmq000"
        CALL cl_cmdrun(l_cmd)
    ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
 
 
FUNCTION asms210_u()
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_forupd_sql =
     " SELECT *           ",
     "   FROM sma_file    ",
     "    WHERE sma00 = ?   ",
     "  FOR UPDATE        "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE sma_curl CURSOR FROM g_forupd_sql
    BEGIN WORK
    OPEN sma_curl  USING '0'
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
    SELECT aza06,aza12 INTO g_aza.aza06,g_aza.aza12 FROM aza_file
     WHERE aza01 ='0'
    IF g_aza.aza06="N" THEN
       LET g_sma.sma03 = 'N'
    END IF
    IF g_aza.aza12="N" THEN
        LET g_sma.sma04 = 'N'
    END IF
    IF g_sma.sma12 = 'N' THEN
        LET g_sma.sma24 = 'Y'
    END IF
    LET g_sma.smamodu=g_user
    LET g_sma.smadate=TODAY
    LET g_sma.smaacti='Y'
    DISPLAY BY NAME g_sma.sma02,g_sma.sma03,
                    g_sma.sma04,g_sma.sma07,g_sma.sma10,             #No.TQC-740074
                    #FUN-B50039-add-str--
                    #g_sma.smaud01,g_sma.smaud02,g_sma.smaud03,    #mark by guanyao160903
                    #g_sma.smaud01,g_sma.smaud03,                  #add by guanyao160903  #mark by guanyao160928
                    g_sma.smaud01,                                 #add by guanyao160928
                    g_sma.smaud04,g_sma.smaud05,g_sma.smaud06,
                    g_sma.smaud07,g_sma.smaud08,g_sma.smaud09,
                    g_sma.smaud10,g_sma.smaud11,g_sma.smaud12,
                    g_sma.smaud13,g_sma.smaud14,g_sma.smaud15
                    #FUN-B50039-add-end--
    #FUN-D30024---mark---str---
    #LET g_sma894_1=g_sma.sma894[1,1] DISPLAY g_sma894_1 TO g_sma894_1
    #LET g_sma894_2=g_sma.sma894[2,2] DISPLAY g_sma894_2 TO g_sma894_2
    #LET g_sma894_3=g_sma.sma894[3,3] DISPLAY g_sma894_3 TO g_sma894_3
    #LET g_sma894_4=g_sma.sma894[4,4] DISPLAY g_sma894_4 TO g_sma894_4
    #LET g_sma894_5=g_sma.sma894[5,5] DISPLAY g_sma894_5 TO g_sma894_5
    #LET g_sma894_6=g_sma.sma894[6,6] DISPLAY g_sma894_6 TO g_sma894_6
    #LET g_sma894_7=g_sma.sma894[7,7] DISPLAY g_sma894_7 TO g_sma894_7
    #LET g_sma894_8=g_sma.sma894[8,8] DISPLAY g_sma894_8 TO g_sma894_8
    #FUN-D30024---mark---end---
 
    DISPLAY BY NAME  g_sma.sma901
       #-依勾選是否與 APS 整合, 顯示/隱藏 APS 整合版本欄位
         CALL cl_set_comp_visible("sma916,sma917,sma918", g_sma.sma901 = 'Y') #FUN-BC0059 add sma918
 
    WHILE TRUE
        CALL asms210_i()
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE sma_file SET
                sma02=g_sma.sma02,
                sma03=g_sma.sma03,
                sma04=g_sma.sma04,
                sma07=g_sma.sma07,
                sma10=g_sma.sma10,
                sma24=g_sma.sma24,
                sma77=g_sma.sma77,
                sma30=g_sma.sma30,
                sma51=g_sma.sma51,
                sma52=g_sma.sma52,
                #sma894=g_sma.sma894,   #FUN-D30024---mark---
                sma79=g_sma.sma79,
                sma901=g_sma.sma901,     #Genero add
                sma916=g_sma.sma916,     #FUN-850115 add
                sma917=g_sma.sma917,     #FUN-870156 add
                sma918=g_sma.sma918,     #FUN-BC0059 add 
                sma53 =g_sma.sma53 ,     #Genero add
                smauser=g_sma.smauser,
                smagrup=g_sma.smagrup,
                smamodu=g_sma.smamodu,
                smadate=g_sma.smadate,
                smaacti=g_sma.smaacti,
                #FUN-B50039-add-str--
                smaud01=g_sma.smaud01,
                #smaud02=g_sma.smaud02,    #mark by guanyao160903
                #smaud03=g_sma.smaud03,    #mark by guanyao160928
                smaud04=g_sma.smaud04,
                smaud05=g_sma.smaud05,
                smaud06=g_sma.smaud06,
                smaud07=g_sma.smaud07,
                smaud08=g_sma.smaud08,
                smaud09=g_sma.smaud09,
                smaud10=g_sma.smaud10,
                smaud11=g_sma.smaud11,
                smaud12=g_sma.smaud12,
                smaud13=g_sma.smaud13,
                smaud14=g_sma.smaud14,
                smaud15=g_sma.smaud15
                #FUN-B50039-add-end--
            WHERE sma00='0'
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","sma_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660138
            CONTINUE WHILE
        ELSE 
           IF g_flag='Y' THEN 
              LET g_errno = TIME
              LET g_msg = 'old:',g_sma_t.sma53,' new:',g_sma.sma53
              INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980008 add
                 VALUES ('asms210',g_user,g_today,g_errno,'sma53',g_msg,g_plant,g_legal)   #FUN-980008 add
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("ins","azo_file","asms210","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
                 CONTINUE WHILE
              END IF
           END IF 
        END IF
        UNLOCK TABLE sma_file
        EXIT WHILE
    END WHILE
    CLOSE sma_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION asms210_i()
    DEFINE l_aza   LIKE aza_file.aza01, #No.FUN-690010  VARCHAR(01),
           l_azn02 LIKE azn_file.azn02,
           l_azn04 LIKE azn_file.azn04
 
    INPUT BY NAME g_sma.sma30,g_sma.sma51,g_sma.sma52,g_sma.sma53,
                  g_sma.sma02,g_sma.sma03,g_sma.sma10,g_sma.sma04,
                  g_sma.sma24,g_sma.sma07,g_sma.sma79,g_sma.sma901,
                  g_sma.sma916,         #FUN-850115  add
                  g_sma.sma917,         #FUN-870156  add
                  g_sma.sma918,         #FUN-BC0059  add
                  #g_sma894_1, g_sma894_2, g_sma894_3, g_sma894_4,     #FUN-D30024---mark---
                  #g_sma894_5, g_sma894_6, g_sma894_7, g_sma894_8,     #FUN-D30024---mark---
                  #FUN-B50039-add-str--
                  #g_sma.smaud01,g_sma.smaud02,g_sma.smaud03,   #mark by guanyao160903
                  #g_sma.smaud01,g_sma.smaud03,                 #add by guanyao160903  #mark by guanyao160928
                  g_sma.smaud01,                                #add by guanyao160928
                  g_sma.smaud04,g_sma.smaud05,g_sma.smaud06,
                  g_sma.smaud07,g_sma.smaud08,g_sma.smaud09,
                  g_sma.smaud10,g_sma.smaud11,g_sma.smaud12,
                  g_sma.smaud13,g_sma.smaud14,g_sma.smaud15
                  #FUN-B50039-add-end--
        WITHOUT DEFAULTS

    BEFORE INPUT
        SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00 = '0'   #FUN-BC0062
        LET g_before_input_done = FALSE
        CALL s210_set_entry()
        CALL s210_set_no_entry()
        LET g_before_input_done = TRUE
        LET g_flag='N'     #FUN-930164 add
 
    AFTER FIELD sma02
       IF NOT cl_null(g_sma.sma02) THEN
           IF g_sma.sma02 NOT MATCHES "[YN]" THEN
              LET g_sma.sma02=g_sma_o.sma02
              DISPLAY BY NAME g_sma.sma02
              NEXT FIELD sma02
           END IF
           LET g_sma_o.sma02=g_sma.sma02
       END IF
    BEFORE FIELD sma03
        CALL s210_set_entry()
 
    AFTER FIELD sma03
       IF NOT cl_null(g_sma.sma03) THEN
           IF g_sma.sma03 NOT MATCHES "[YN]" THEN
              LET g_sma.sma03=g_sma_o.sma03
              DISPLAY BY NAME g_sma.sma03
              NEXT FIELD sma03
           ELSE
               IF g_sma.sma03 = 'N' THEN
                   LET g_sma.sma10 = 'N'
                   DISPLAY BY NAME g_sma.sma10
               END IF
           END IF
           LET g_sma_o.sma03=g_sma.sma03
       END IF
       CALL s210_set_no_entry()
 
    AFTER FIELD sma04
       IF NOT cl_null(g_sma.sma04) THEN
          IF g_sma.sma04 NOT MATCHES "[YN]" THEN
             LET g_sma.sma04=g_sma_o.sma04
             DISPLAY BY NAME g_sma.sma04
             NEXT FIELD sma04
          END IF
          LET g_sma_o.sma04=g_sma.sma04
      END IF
 
    AFTER FIELD sma07
       IF NOT cl_null(g_sma.sma07) THEN
           IF g_sma.sma07 NOT MATCHES "[YN]" THEN
               LET g_sma.sma07=g_sma_o.sma07
               DISPLAY BY NAME g_sma.sma07
               NEXT FIELD sma07
           END IF
           LET g_sma_o.sma07=g_sma.sma07
       END IF
 
    AFTER FIELD sma10
       IF NOT cl_null(g_sma.sma10) THEN
           IF g_sma.sma10 NOT MATCHES "[YN]" THEN
               LET g_sma.sma10=g_sma_o.sma10
               DISPLAY BY NAME g_sma.sma10
               NEXT FIELD sma10
           END IF
           LET g_sma_o.sma10=g_sma.sma10
       END IF
 
    AFTER FIELD sma24
       IF NOT cl_null(g_sma.sma24) THEN
           IF g_sma.sma24 NOT MATCHES "[YN]" THEN
                 LET g_sma.sma24=g_sma_o.sma24
                 DISPLAY BY NAME g_sma.sma24
                 NEXT FIELD sma24
           END IF
           LET g_sma_o.sma24=g_sma.sma24
       END IF

#FUN-D30024---mark---str---
#    AFTER FIELD g_sma894_1
#       IF g_sma894_1 NOT MATCHES "[YN]" THEN
#             NEXT FIELD g_sma894_1
##FUN-BC0062 --begin--
#      ELSE
#          IF g_ccz.ccz28 = '6' AND g_sma894_1 = 'Y' THEN
#             CALL cl_err('','apm-908',1)
#             NEXT FIELD CURRENT
#          END IF 
##FUN-BC0062 --end--
#       END IF
#
#    AFTER FIELD g_sma894_2
#       IF g_sma894_2 NOT MATCHES "[YN]" THEN
#             NEXT FIELD g_sma894_2
##FUN-BC0062 --begin--
#      ELSE
#          IF g_ccz.ccz28 = '6' AND g_sma894_2 = 'Y' THEN
#             CALL cl_err('','apm-908',1)
#             NEXT FIELD CURRENT
#          END IF
##FUN-BC0062 --end--
#       END IF
#
#    AFTER FIELD g_sma894_3
#       IF g_sma894_3 NOT MATCHES "[YN]" THEN
#             NEXT FIELD g_sma894_3
#       END IF
#
#    AFTER FIELD g_sma894_4
#       IF g_sma894_4 NOT MATCHES "[YN]" THEN
#             NEXT FIELD g_sma894_4
#       END IF
#
#   AFTER FIELD g_sma894_5
#      IF g_sma894_5 NOT MATCHES "[YN]" THEN
#            NEXT FIELD g_sma894_5
#      END IF

#   AFTER FIELD g_sma894_6
#      IF g_sma894_6 NOT MATCHES "[YN]" THEN
#            NEXT FIELD g_sma894_6
#FUN-BC0062 --begin--
#     ELSE
#         IF g_ccz.ccz28 = '6' AND g_sma894_6 = 'Y' THEN
#            CALL cl_err('','apm-908',1)
#            NEXT FIELD CURRENT
#         END IF
#FUN-BC0062 --end--
#      END IF

#   AFTER FIELD g_sma894_7
#      IF g_sma894_7 NOT MATCHES "[YN]" THEN
#            NEXT FIELD g_sma894_7
#FUN-BC0062 --begin--
#     ELSE
#         IF g_ccz.ccz28 = '6' AND g_sma894_7 = 'Y' THEN
#            CALL cl_err('','apm-908',1)
#            NEXT FIELD CURRENT
#         END IF
#FUN-BC0062 --end--
#      END IF

#   AFTER FIELD g_sma894_8
#      IF g_sma894_8 NOT MATCHES "[YN]" THEN
#            NEXT FIELD g_sma894_8
#FUN-BC0062 --begin--
#     ELSE
#         IF g_ccz.ccz28 = '6' AND g_sma894_8 = 'Y' THEN
#            CALL cl_err('','apm-908',1)
#            NEXT FIELD CURRENT
#         END IF
#FUN-BC0062 --end--
#       END IF
#FUN-D30024---mark---end---
 
    AFTER FIELD sma30
       IF NOT cl_null(g_sma.sma30) THEN
           IF g_sma.sma30 > g_today THEN
              CALL cl_err(g_sma.sma30,'mfg0087',1)
           END IF
           IF g_sma.sma30 != g_sma_o.sma30 THEN
              SELECT azn02,azn04 INTO g_sma.sma51,g_sma.sma52
                 FROM azn_file WHERE azn01 = g_sma.sma30
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("sel","azn_file",g_sma.sma30,"","mfg0088","","",1) #No.FUN-660138
                 NEXT FIELD sma30
              ELSE
                 DISPLAY BY NAME g_sma.sma51,g_sma.sma52
              END IF
           END IF
           LET g_sma_o.sma30=g_sma.sma30
       END IF
    AFTER FIELD sma51
       IF NOT cl_null(g_sma.sma51) THEN
           SELECT azn02 INTO l_azn02 FROM azn_file
              WHERE azn01 = g_sma.sma30
           IF l_azn02 != g_sma.sma51 THEN
              CALL cl_err(g_sma.sma30,'mfg0089',1)
              LET g_sma.sma51=g_sma_o.sma51
              DISPLAY BY NAME g_sma.sma51
              NEXT FIELD sma30
           END IF
       END IF
 
    AFTER FIELD sma52
       IF NOT cl_null(g_sma.sma52) THEN
           SELECT azn04 INTO l_azn04 FROM azn_file
              WHERE azn01 = g_sma.sma30
           IF l_azn04 != g_sma.sma52 THEN
              CALL cl_err(g_sma.sma30,'mfg0090',1)
              LET g_sma.sma52=g_sma_o.sma52
              DISPLAY BY NAME g_sma.sma52
              NEXT FIELD sma30
           END IF
           LET g_sma_o.sma51=g_sma.sma51
       END IF
 
     BEFORE FIELD sma901
       CALL s210_set_entry()
       CALL s210_set_no_entry()
     ON CHANGE sma901
        IF g_sma.sma901 = 'N' THEN
           LET g_sma.sma916 = NULL
           LET g_sma.sma917 = NULL  #TQC-920084 ADD
           LET g_sma.sma918 = 'N'   #FUN-BC0059 add
           DISPLAY BY NAME g_sma.sma916
           DISPLAY BY NAME g_sma.sma917 #FUN-870156 add
           DISPLAY BY NAME g_sma.sma918 #FUN-BC0059 add
        ELSE
           LET g_sma.sma916="2"
           LET g_sma.sma917="1"
           LET g_sma.sma918 = 'N'   #FUN-BC0059 add
           DISPLAY BY NAME g_sma.sma916
           DISPLAY BY NAME g_sma.sma917 #FUN-870156 add
           DISPLAY BY NAME g_sma.sma918 #FUN-BC0059 add
        END IF
        #-依勾選是否與 APS 整合, 顯示/隱藏 APS 整合版本欄位
          CALL cl_set_comp_visible("sma916,sma917,sma918", g_sma.sma901 = 'Y')  #FUN-BC0059 add sma918
          CALL cl_set_comp_required("sma916,sma917,sma918", g_sma.sma901 = 'Y') #FUN-BC0059 add sma918
        CALL s210_set_entry()
        CALL s210_set_no_entry()
 
     AFTER FIELD sma916
       IF NOT cl_null(g_sma.sma916) THEN
          LET g_sma_o.sma916=g_sma.sma916
       END IF
 
     AFTER FIELD sma917
       IF NOT cl_null(g_sma.sma917) THEN
          LET g_sma_o.sma917=g_sma.sma917
       END IF

     #FUN-BC0059 ---add----str---
     AFTER FIELD sma918
       IF NOT cl_null(g_sma.sma918) THEN
          LET g_sma_o.sma918=g_sma.sma918
       END IF
     #FUN-BC0059 ---add----str---
 
     AFTER FIELD sma53
        IF g_sma.sma53 <> g_sma_t.sma53 THEN 
           LET g_flag='Y'
        END IF
      #FUN-B50039-add-str--
      AFTER FIELD smaud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #str----mark by guanyao160903
      #AFTER FIELD smaud02
      #   IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #end----mark by guanyao160903
      #str----add by guanyao160928
      #AFTER FIELD smaud03
      #   IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #end----add by guanyao160928
      AFTER FIELD smaud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD smaud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD smaud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD smaud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD smaud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD smaud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD smaud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD smaud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD smaud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD smaud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD smaud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD smaud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-B50039-add-end--

 
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
  #FUN-D30024---mark---str---
  #LET g_sma.sma894[1,1] = g_sma894_1
  #LET g_sma.sma894[2,2] = g_sma894_2
  #LET g_sma.sma894[3,3] = g_sma894_3
  #LET g_sma.sma894[4,4] = g_sma894_4
  #LET g_sma.sma894[5,5] = g_sma894_5
  #LET g_sma.sma894[6,6] = g_sma894_6
  #LET g_sma.sma894[7,7] = g_sma894_7
  #LET g_sma.sma894[8,8] = g_sma894_8
  #FUN-D30024---mark---end---
END FUNCTION

FUNCTION s210_set_entry()
 
   IF INFIELD(sma03) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("sma10",TRUE)
   END IF
 
   IF (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("sma03,sma04,sma24",TRUE)
   END IF
 
   IF g_sma.sma901 = 'Y' THEN  #FUN-850115 add
      CALL cl_set_comp_entry("sma916",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION s210_set_no_entry()
 
   IF INFIELD(sma03) OR (NOT g_before_input_done) THEN
      IF g_sma.sma03='N' THEN
          CALL cl_set_comp_entry("sma10",FALSE)
      END IF
   END IF
 
   IF (NOT g_before_input_done) THEN
      IF g_aza.aza06 ='N' THEN
          CALL cl_set_comp_entry("sma03",FALSE)
      END IF
      IF g_aza.aza12 ='N' THEN
          CALL cl_set_comp_entry("sma04",FALSE)
      END IF
   END IF
 
   IF g_sma.sma901 = 'N' THEN  #FUN-850115 add
      CALL cl_set_comp_entry("sma916",FALSE)
   END IF
 
END FUNCTION
#NO.FUN-9C0072 精簡程式碼
