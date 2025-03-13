# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apsi307.4gl
# Descriptions...: APS 供給法則維護檔
# Date & Author..: NO.FUN-850114 08/01/08 By yiting
# Modify.........: NO.MOD-880179 08/08/21 BY DUKE  倉庫儲位設定開窗選擇
# Modify.........: NO.TQC-940088 09/05/06 BY destiny _u()函數里的where條件里有兩個字段不屬于vmh_file 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-D40103 13/05/08 By lixh1 增加儲位有效性檢查
# Modify.........: No:TQC-D50126 13/06/05 By lixh1 修正FUN-D40103
# Modify.........: No:TQC-D50116 13/05/27 By lixh1 報錯信息修改
# Modify.........: No:TQC-D50126 13/06/05 By lixh1 修正FUN-D40103i
# Modify.........: No:TQC-D50127 13/05/30 By lixh1 調整儲位有效性檢查
# Modify.........: No:TQC-DB0059 13/11/25 By wangrr i307_imechk()缺少返回值
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_vmh           RECORD LIKE vmh_file.*, #FUN-720043 
    g_vmh_t         RECORD LIKE vmh_file.*,   #FUN-850114
    g_vmh01         LIKE vmh_file.vmh01,        #供給法則編號
    g_flag          LIKE type_file.chr1,    
    g_wc,g_sql      string  
 
DEFINE   g_forupd_sql   STRING                   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt          LIKE type_file.num10   
DEFINE   g_msg          LIKE ze_file.ze03  
DEFINE   g_row_count    LIKE type_file.num10   
DEFINE   g_curs_index   LIKE type_file.num10   
DEFINE   g_before_input_done      LIKE type_file.num5            #No.FUN-570110  #No.FUN-690010 SMALLINT


MAIN
    OPTIONS					#改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT				#擷取中斷鍵,由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("APS")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time 

    INITIALIZE g_vmh.* TO NULL
    INITIALIZE g_vmh_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM vmh_file WHERE vmh01 = ? AND vmh02 = ? AND vmh03 = ? AND vmh04 = ? FOR UPDATE"  #wujie 091021
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i307_cl CURSOR FROM g_forupd_sql                  # LOCK CURSOR
 
    OPEN WINDOW i307_w WITH FORM "aps/42f/apsi307"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    LET g_vmh.vmh01 = ARG_VAL(1)
    LET g_vmh.vmh02 = ARG_VAL(2)
    LET g_vmh.vmh03 = ARG_VAL(3)
    LET g_vmh.vmh04 = ARG_VAL(4)
    IF g_vmh.vmh01 IS NOT NULL AND  g_vmh.vmh01 != ' '
       THEN LET g_flag = 'Y'
            CALL i307_q()
       ELSE LET g_flag = 'N'
    END IF
 
    WHILE TRUE
      LET g_action_choice=""
      CALL i307_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW i307_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i307_cs()
    CLEAR FORM
    IF g_flag = 'Y' THEN
       LET g_wc = " vmh01 ='",g_vmh.vmh01,"'",
                  " AND vmh02 ='",g_vmh.vmh02,"'",
                  " AND vmh03 ='",g_vmh.vmh03,"'",
                  " AND vmh04 ='",g_vmh.vmh04,"'"
    ELSE
   INITIALIZE g_vmh.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                        # 螢幕上取條件
             vmh01,
             vmh02,
             vmh03,
             vmh04,
             vmh05 
 
 
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
          #MOD-880179  ADD
 
 
          ON ACTION controlp
             CASE
                WHEN INFIELD(vmh03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_imd2"
                     CALL cl_create_qry() RETURNING g_vmh.vmh03
                     DISPLAY BY NAME g_vmh.vmh03
                     NEXT FIELD vmh03
                WHEN INFIELD(vmh04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_ime02"
                     LET g_qryparam.arg1 = g_vmh.vmh03
                     CALL cl_create_qry() RETURNING g_vmh.vmh04
                     DISPLAY BY NAME g_vmh.vmh04
                     NEXT FIELD vmh04
             END CASE
 
          
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
          
          ON ACTION about         
             CALL cl_about()      
          
          ON ACTION help          
             CALL cl_show_help()  
          
          ON ACTION controlg      
             CALL cl_cmdask()     
 
          ON ACTION qbe_select
             CALL cl_qbe_select()
          ON ACTION qbe_save
             CALL cl_qbe_save()
 
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    END IF
    IF INT_FLAG THEN RETURN END IF
 
    LET g_sql = "SELECT vmh01,vmh02,vmh03,vmh04 FROM vmh_file ",   # 組合出 SQL 指令
                " WHERE ",g_wc CLIPPED,
                " ORDER BY vmh01,vmh02,vmh03,vmh04"
    PREPARE i307_prepare FROM g_sql                     # RUNTIME 編譯
    DECLARE i307_cs                                     # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i307_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM vmh_file WHERE ",g_wc CLIPPED
    PREPARE i307_precount FROM g_sql
    DECLARE i307_count CURSOR FOR i307_precount
END FUNCTION
 
FUNCTION i307_menu()
    MENU ""
 
        BEFORE MENU
           CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i307_a()
            END IF
 
        ON ACTION query
           LET g_action_choice="query"
           IF cl_chk_act_auth() THEN
                CALL i307_q()
           END IF
        ON ACTION first
           CALL i307_fetch('F')
        ON ACTION next
           CALL i307_fetch('N')
        ON ACTION previous
           CALL i307_fetch('P')
        ON ACTION last
           CALL i307_fetch('L')
        ON ACTION jump
           CALL i307_fetch('/')
        ON ACTION modify
           CALL i307_u()
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION controlg      
           CALL cl_cmdask()     
 
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_vmh.vmh01) AND
                  NOT cl_null(g_vmh.vmh02) AND
                  NOT cl_null(g_vmh.vmh03) AND
                  NOT cl_null(g_vmh.vmh04) THEN
                  LET g_doc.column1 = "vmh01"
                  LET g_doc.column2 = "vmh02"
                  LET g_doc.column3 = "vmh03"
                  LET g_doc.column4 = "vmh04"
                  LET g_doc.value1 = g_vmh.vmh01
                  LET g_doc.value2 = g_vmh.vmh02
                  LET g_doc.value3 = g_vmh.vmh03
                  LET g_doc.value4 = g_vmh.vmh04
                  CALL cl_doc()
               END IF
           END IF
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET INT_FLAG=FALSE 		
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i307_cs
END FUNCTION
 
 
FUNCTION i307_a()
    IF s_shut(0) THEN RETURN END IF              #檢查權限
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_vmh.* LIKE vmh_file.*
 
    LET g_vmh_t.*=g_vmh.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_vmh.vmh01 = ''
        LET g_vmh.vmh02 = 0
        LET g_vmh.vmh03 = ''
        LET g_vmh.vmh04 = ''
        LET g_vmh.vmh05 = 0
        CALL i307_i("a")                         #各欄位輸入
        IF INT_FLAG THEN                         #若按了DEL鍵
            INITIALIZE g_vmh.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF cl_null(g_vmh.vmh01) OR                  # KEY 不可空白
           cl_null(g_vmh.vmh02) OR
           cl_null(g_vmh.vmh03) OR
           g_vmh.vmh04 IS NULL THEN
            CONTINUE WHILE
        END IF
        INSERT INTO vmh_file VALUES(g_vmh.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","vmh_file",g_vmh.vmh01,"",SQLCA.sqlcode,"","",1) # FUN-660095
            CONTINUE WHILE
        ELSE
            LET g_vmh_t.* = g_vmh.*                # 保存上筆資料
            SELECT vmh01 INTO g_vmh.vmh01 FROM vmh_file
             WHERE vmh01 = g_vmh.vmh01
               AND vmh02 = g_vmh.vmh02
               AND vmh03 = g_vmh.vmh03
               AND vmh04 = g_vmh.vmh04
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i307_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
        l_flag          LIKE type_file.chr1,  		 #是否必要欄位有輸入  #No.FUN-690010 VARCHAR(1)
        l_n             LIKE type_file.num5    #No.FUN-690010 SMALLINT
    DEFINE l_cnt        LIKE type_file.num5
 
    DISPLAY BY NAME 
             g_vmh.vmh01      ,
             g_vmh.vmh02 ,
             g_vmh.vmh03    ,
             g_vmh.vmh04  ,
             g_vmh.vmh05
    INPUT BY NAME   
             g_vmh.vmh01      ,
             g_vmh.vmh02 ,
             g_vmh.vmh03    ,
             g_vmh.vmh04  ,
             g_vmh.vmh05
        WITHOUT DEFAULTS
 
 
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i307_set_entry_(p_cmd)
          CALL i307_set_no_entry_(p_cmd)
          LET g_before_input_done = TRUE
 
        #MOD-880179  MODIFY..
        AFTER FIELD vmh03 
           LET l_cnt = 0
           IF NOT cl_null(g_vmh.vmh03) THEN
               SELECT COUNT(*) INTO l_cnt
                 FROM imd_file
                WHERE imd01 = g_vmh.vmh03
                  and imdacti='Y'
                  and imd11='Y'
                  and imd12='Y'
               IF l_cnt = 0 THEN
                   CALL cl_err('','mfg0094',0)
                   NEXT FIELD vmh03
               END IF
           END IF
 #TQC-D50116 -------Begin---------
          #IF NOT cl_null(g_vmh.vmh04) THEN 
          #   LET l_cnt = 0
          #   SELECT COUNT(*) INTO l_cnt
          #     FROM ime_file,imd_file
          #    WHERE ime01 = g_vmh.vmh03
          #      AND ime02 = g_vmh.vmh04
          #      and ime01=imd01
          #      and ime05='Y'
          #      and ime06='Y'
          #   IF l_cnt = 0 THEN
          #       CALL cl_err('','aps-715',0)
          #       NEXT FIELD vmh04
          #   END IF
          #END IF
           IF NOT i307_imechk() THEN  #TQC-D50126
              NEXT FIELD vmh04
           END IF
       #TQC-D50116 -------End----------- 
 
 
        #MOD-880179 MODIFY
        AFTER FIELD vmh04
           IF cl_null(g_vmh.vmh04) THEN 
               LET g_vmh.vmh04 = ' ' 
           END IF
           LET l_cnt = 0
       #TQC-D50116 -------Begin--------
         # IF NOT cl_null(g_vmh.vmh04) THEN
         #     SELECT COUNT(*) INTO l_cnt
         #       FROM ime_file,imd_file
         #      WHERE ime01 = g_vmh.vmh03
         #        AND ime02 = g_vmh.vmh04
         #        and ime01=imd01
         #        and ime05='Y'
         #        and ime06='Y'
         #     IF l_cnt = 0 THEN
         #         CALL cl_err('','mfg0095',0)
         #         NEXT FIELD vmh04
         #     END IF
         # END IF
           IF NOT i307_imechk() THEN
              NEXT FIELD vmh04
           END IF
        #TQC-D50116 -------End---------- 
        AFTER FIELD vmh05
           IF NOT cl_null(g_vmh.vmh05) THEN
               IF g_vmh.vmh05 < 0 THEN
                   CALL cl_err('','aec-020',0)
                   NEXT FIELD vmh05
               END IF
           END IF
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET l_flag='N'
           IF INT_FLAG THEN EXIT INPUT  END IF
           IF l_flag='Y' THEN
              CALL cl_err('','9033',0)
              NEXT FIELD vmh01
           END IF
 
         #MOD-880179  ADD
         ON ACTION controlp
            CASE
               WHEN INFIELD(vmh03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_imd2"
                    CALL cl_create_qry() RETURNING g_vmh.vmh03
                    DISPLAY BY NAME g_vmh.vmh03
                    NEXT FIELD vmh03
               WHEN INFIELD(vmh04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_ime02"
                    LET g_qryparam.arg1 = g_vmh.vmh03
                    CALL cl_create_qry() RETURNING g_vmh.vmh04
                    DISPLAY BY NAME g_vmh.vmh04
                    NEXT FIELD vmh04
            END CASE
 
 
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION help          
           CALL cl_show_help()  
    END INPUT
END FUNCTION

#FUN-D40103 -----Begin-----
FUNCTION i307_imechk()
   DEFINE  l_cnt       LIKE type_file.num5
   DEFINE  l_imeacti   LIKE ime_file.imeacti
   DEFINE  l_ime02     LIKE ime_file.ime02
#  IF NOT cl_null(g_vmh.vmh03) AND g_vmh.vmh04 IS NOT NULL THEN  #TQC-D50127 mark
   IF g_vmh.vmh04 IS NOT NULL AND g_vmh.vmh04 != ' ' THEN        #TQC-D50127
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM ime_file,imd_file
       WHERE ime01 = g_vmh.vmh03
         AND ime02 = g_vmh.vmh04
         and ime01=imd01
         and ime05='Y'
         and ime06='Y'
      IF l_cnt = 0 THEN
          CALL cl_err(g_vmh.vmh03 || ' ' ||g_vmh.vmh04,'aps-715',0)
          RETURN FALSE
      END IF
   END IF     #TQC-D50127
   IF g_vmh.vmh04 IS NOT NULL THEN   #TQC-D50127
      LET l_imeacti = ''
      SELECT imeacti INTO l_imeacti 
        FROM ime_file,imd_file
       WHERE ime01 = g_vmh.vmh03
         AND ime02 = g_vmh.vmh04
         and ime01=imd01
         and ime05='Y'
         and ime06='Y'
      IF l_imeacti = 'N' THEN
         LET l_ime02 = g_vmh.vmh04
         IF cl_null(l_ime02) THEN
            LET l_ime02 = "' '"
         END IF
         CALL cl_err_msg("","aim-507",g_vmh.vmh03 || "|" || l_ime02 ,0)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE  #TQC-DB0059 add
END FUNCTION
#FUN-D40103 -----End-------
 
FUNCTION i307_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i307_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        INITIALIZE g_vmh.* TO NULL
        RETURN
    END IF
    OPEN i307_count
    FETCH i307_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i307_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vmh.vmh01,SQLCA.sqlcode,0)
        INITIALIZE g_vmh.* TO NULL
    ELSE
        CALL i307_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i307_fetch(p_flag)
    DEFINE
        p_flag         LIKE type_file.chr1,   #No.FUN-690010 VARCHAR(1),
        l_abso          LIKE type_file.num10   #No.FUN-690010 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i307_cs INTO g_vmh.vmh01,g_vmh.vmh02,g_vmh.vmh03,g_vmh.vmh04
        WHEN 'P' FETCH PREVIOUS i307_cs INTO g_vmh.vmh01,g_vmh.vmh02,g_vmh.vmh03,g_vmh.vmh04
        WHEN 'F' FETCH FIRST    i307_cs INTO g_vmh.vmh01,g_vmh.vmh02,g_vmh.vmh03,g_vmh.vmh04
        WHEN 'L' FETCH LAST     i307_cs INTO g_vmh.vmh01,g_vmh.vmh02,g_vmh.vmh03,g_vmh.vmh04
        WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION about         
                  CALL cl_about()      
               
               ON ACTION help          
                  CALL cl_show_help()  
               
               ON ACTION controlg      
                  CALL cl_cmdask()     
            END PROMPT
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
            END IF
            FETCH ABSOLUTE l_abso i307_cs INTO g_vmh.vmh01,g_vmh.vmh02,g_vmh.vmh03,g_vmh.vmh04
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg = g_vmh.vmh01 CLIPPED,'+',g_vmh.vmh02 CLIPPED,'+',g_vmh.vmh03 CLIPPED,'+',g_vmh.vmh04 CLIPPED
        CALL cl_err(g_msg,SQLCA.sqlcode,1)
        INITIALIZE g_vmh.* TO NULL          
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
SELECT * INTO g_vmh.* FROM vmh_file            
WHERE vmh01 = g_vmh.vmh01 AND vmh02 = g_vmh.vmh02 AND vmh03 = g_vmh.vmh03 AND vmh04 = g_vmh.vmh04
    IF SQLCA.sqlcode THEN
        LET g_msg = g_vmh.vmh01 CLIPPED
         CALL cl_err3("sel","vmh_file",g_vmh.vmh01,"",SQLCA.sqlcode,"","",1) # FUN-660095
         INITIALIZE g_vmh.* TO NULL       #No.FUN-6A0163
    ELSE
        CALL i307_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i307_show()
    LET g_vmh_t.* = g_vmh.*
    DISPLAY BY NAME 
             g_vmh.vmh01      ,
             g_vmh.vmh02 ,
             g_vmh.vmh03    ,
             g_vmh.vmh04  ,
             g_vmh.vmh05
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION i307_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_vmh.vmh01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_vmh01 = g_vmh.vmh01
    BEGIN WORK
 
    OPEN i307_cl USING g_vmh.vmh01,g_vmh.vmh02,g_vmh.vmh03,g_vmh.vmh04
    IF STATUS THEN
       CALL cl_err("OPEN i307_cl:", STATUS, 1)
       CLOSE i307_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i307_cl INTO g_vmh.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vmh.vmh01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL i307_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i307_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_vmh.* = g_vmh_t.*
            CALL i307_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE vmh_file SET vmh_file.* = g_vmh.*    # 更新DB
            WHERE vmh01 = g_vmh_t.vmh01 AND vmh02 = g_vmh_t.vmh02 AND vmh03 = g_vmh_t.vmh03 AND vmh04 = g_vmh_t.vmh04               # COLAUTH?
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
            LET g_msg = g_vmh.vmh01 CLIPPED
            CALL cl_err3("upd","vmh_file",g_vmh01,"",SQLCA.sqlcode,"","",1) # FUN-660095
            CONTINUE WHILE
        ELSE
            LET g_vmh_t.* = g_vmh.*# 保存上筆資料
            SELECT vmh01 INTO g_vmh.vmh01 FROM vmh_file
             WHERE vmh01      = g_vmh.vmh01
               AND vmh02 = g_vmh.vmh02
              #AND compt    = g_vmh.vmh03                  #No.TQC-940088
               AND vmh03    = g_vmh.vmh03                  #No.TQC-940088
              #AND sply_vmh01 = g_vmh.vmh04                #No.TQC-940088
               AND vmh04    = g_vmh.vmh04                  #No.TQC-940088
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i307_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i307_r()
    DEFINE
        l_chr LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_vmh.vmh01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i307_cl USING g_vmh.vmh01,g_vmh.vmh02,g_vmh.vmh03,g_vmh.vmh04
    IF STATUS THEN
       CALL cl_err("OPEN i307_cl:", STATUS, 1)
       CLOSE i307_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i307_cl INTO g_vmh.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vmh.vmh01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL i307_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "vmh01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "vmh02"         #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "vmh03"         #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "vmh04"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_vmh.vmh01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_vmh.vmh02      #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_vmh.vmh03      #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_vmh.vmh04      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
#           DELETE FROM vmh_file WHERE vmh01 = g_vmh.vmh01 AND vmh02 = g_vmh.vmh02 AND vmh03 = g_vmh.vnm03 AND vmh04 = g_vmh.vmh04
            DELETE FROM vmh_file WHERE vmh01 = g_vmh.vmh01 AND vmh02 = g_vmh.vmh02 AND vmh03 = g_vmh.vmh03 AND vmh04 = g_vmh.vmh04  #wujie 091021
            CLEAR FORM
    END IF
    CLOSE i307_cl
    INITIALIZE g_vmh.* TO NULL
    COMMIT WORK
END FUNCTION
 
FUNCTION i307_set_entry_(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("vmh01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i307_set_no_entry_(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("vmh01",FALSE)
   END IF
END FUNCTION
 
