# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: anmt330.4gl
# Descriptions...: 銀行存款期初開帳維護作業
# Date & Author..: 95/09/12 By Danny
# Modify.........: No.FUN-4C0098 05/01/12 By pengu 報表轉XML
# Modify.........: No.FUN-570247 05/07/26 By elva  月份改為會計期別處理
# Modify.........: No.MOD-630047 06/03/13 By Smapmin 銀行簡稱未印出
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6A0011 06/11/12 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-820002 08/02/25 By lutingting 報表轉為使用p_query
# Modify.........: No.MOD-8C0059 08/12/10 By Sarah 金額欄位增加取位
# Modify.........: No.TQC-8C0021 09/03/04 By Sarah g_azi04無須重新抓取,因為此部分已在cl_setup中處理
# Modify.........: No.TQC-950018 09/05/06 By xiaofeizhu 年度，出納結存合計，總帳結存合計欄位不可錄入負數
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/12 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_npg   RECORD LIKE npg_file.*,
    g_npg_t RECORD LIKE npg_file.*,
    g_npg01_t LIKE npg_file.npg01,
    g_npg02_t LIKE npg_file.npg02,
    g_npg03_t LIKE npg_file.npg03,
    g_wc,g_sql          STRING  #No.FUN-580092 HCN       
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL  
DEFINE g_before_input_done   STRING    
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680107 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680107 SMALLINT
MAIN
#     DEFINE    l_time LIKE type_file.chr8             #No.FUN-6A0082
    DEFINE p_row,p_col    LIKE type_file.num5         #No.FUN-680107 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
    WHENEVER ERROR CALL cl_err_msg_log
    IF (NOT cl_setup("ANM")) THEN
       EXIT PROGRAM
    END IF
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
 
    INITIALIZE g_npg.* TO NULL
    INITIALIZE g_npg_t.* TO NULL
    LET g_forupd_sql = "SELECT * FROM npg_file WHERE npg01 = ? AND npg02 = ? AND npg03 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t330_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
    LET p_row = 4 LET p_col = 8
    OPEN WINDOW t330_w AT p_row,p_col
        WITH FORM "anm/42f/anmt330"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL t330_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW t330_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
 
FUNCTION t330_cs()
    CLEAR FORM
   INITIALIZE g_npg.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        npg01,npg02,npg03,npg06,npg09,npg16,npg19
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(npg01) #料件編號
#                 CALL q_nma(0,0,g_npg.npg01) RETURNING g_npg.npg01
                  CALL cl_init_qry_var() 
                  LET g_qryparam.form = "q_nma" 
                  LET g_qryparam.state= "c"
                  LET g_qryparam.default1 = g_npg.npg01 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO npg01
                  NEXT FIELD npg01
               OTHERWISE EXIT CASE
            END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN RETURN END IF
    LET g_sql="SELECT npg01,npg02,npg03 FROM npg_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED, " ORDER BY npg01,npg02,npg03"
    PREPARE t330_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t330_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t330_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM npg_file WHERE ",g_wc CLIPPED
    PREPARE t330_recount FROM g_sql
    DECLARE t330_count CURSOR FOR t330_recount
END FUNCTION
 
FUNCTION t330_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON ACTION insert  
         LET g_action_choice="insert"
         IF cl_chk_act_auth() THEN
            CALL t330_a() 
         END IF
      ON ACTION query  
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL t330_q() 
         END IF
      ON ACTION next  CALL t330_fetch('N') 
      ON ACTION previous  CALL t330_fetch('P')
       ON ACTION jump CALL t330_fetch('/')     #No.MOD-480071
       ON ACTION first CALL t330_fetch('F')    #No.MOD-480071
       ON ACTION last CALL t330_fetch('L')     #No.MOD-480071
      ON ACTION modify  
         LET g_action_choice="modify"  
         IF cl_chk_act_auth() THEN
            CALL t330_u() 
         END IF
      ON ACTION delete  
         LET g_action_choice="delete"
         IF cl_chk_act_auth() THEN
            CALL t330_r() 
         END IF
      ON ACTION output  
         LET g_action_choice="output"
         IF cl_chk_act_auth() THEN
           CALL t330_out()
         END IF
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
 
      #No.FUN-6A0011--------add----------str----
      ON ACTION related_document             #相關文件"                        
       LET g_action_choice="related_document"           
          IF cl_chk_act_auth() THEN                     
             IF g_npg.npg01 IS NOT NULL THEN            
                LET g_doc.column1 = "npg01"               
                LET g_doc.column2 = "npg02"     
                LET g_doc.column3 = "npg03"          
                LET g_doc.value1 = g_npg.npg01            
                LET g_doc.value2 = g_npg.npg02   
                LET g_doc.value3 = g_npg.npg03         
                CALL cl_doc()                             
             END IF                                        
          END IF                                           
      #No.FUN-6A0011--------add----------end----
    
       ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice = "exit"
           EXIT MENU
 
    END MENU
    CLOSE t330_cs
END FUNCTION
 
 
FUNCTION t330_a()
    IF s_anmshut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_npg.* LIKE npg_file.*
    LET g_npg_t.* = g_npg.*
    LET g_npg01_t = NULL
    LET g_npg02_t = NULL
    LET g_npg03_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL t330_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_npg.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_npg.npg01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
 
        #FUN-980005 add legal 
        LET g_npg.npglegal = g_legal 
        #FUN-980005 end legal 
 
        INSERT INTO npg_file VALUES(g_npg.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
            LET g_msg=g_npg.npg01 CLIPPED,'+',g_npg.npg02
#           CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("ins","npg_file",g_msg,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CONTINUE WHILE
        ELSE
            LET g_npg_t.* = g_npg.*                # 保存上筆資料
            SELECT npg01,npg02,npg03 INTO g_npg.npg01,g_npg.npg02,g_npg.npg03 FROM npg_file
             WHERE npg01 = g_npg.npg01 AND npg02 = g_npg.npg02
               AND npg03 = g_npg.npg03
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION t330_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,     #No.FUN-680107 VARCHAR(1)
        l_flag          LIKE type_file.chr1,     #判斷必要欄位之值是否有輸入        #No.FUN-680107 VARCHAR(1)
        l_n             LIKE type_file.num5      #No.FUN-680107 SMALLINT
 
    INPUT BY NAME
        g_npg.npg01,g_npg.npg02,g_npg.npg03,g_npg.npg06,g_npg.npg09,
        g_npg.npg16,g_npg.npg19 WITHOUT DEFAULTS 
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t330_set_entry(p_cmd)
            CALL t330_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD npg01
            IF NOT cl_null(g_npg.npg01) THEN
               IF p_cmd = 'a' OR 
                 (p_cmd = 'u' AND g_npg.npg01 != g_npg01_t ) THEN
                  CALL t330_npg01('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_npg.npg01,g_errno,0)
                     LET g_npg.npg01 = g_npg01_t
                     DISPLAY BY NAME g_npg.npg01 
                     NEXT FIELD npg01
                  END IF
               END IF
            END IF
            
        #TQC-950018--Begin--#    
        AFTER FIELD npg02
            IF p_cmd = 'a' OR 
              (p_cmd = 'u' AND g_npg.npg02 != g_npg_t.npg02 ) THEN              
               IF g_npg.npg02 <= 0 THEN
                  CALL cl_err('','afa-949',0)
                  NEXT FIELD npg02
               END IF
            END IF      
        #TQC-950018--End--#            
            
        AFTER FIELD npg03                  #日期
#No.TQC-720032 -- begin --
         IF NOT cl_null(g_npg.npg03) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_npg.npg02
            IF g_azm.azm02 = 1 THEN
               IF g_npg.npg03 > 12 OR g_npg.npg03 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD npg03
               END IF
            ELSE
               IF g_npg.npg03 > 13 OR g_npg.npg03 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD npg03
               END IF
            END IF
         END IF
#            IF g_npg.npg03 <=0 OR g_npg.npg03 >= 14 THEN NEXT FIELD npg03 END IF   #FUN-570247
#No.TQC-720032 -- end --
            IF NOT cl_null(g_npg.npg03) THEN 
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND (g_npg.npg01 != g_npg01_t OR
                                   g_npg.npg02 != g_npg02_t OR 
                                   g_npg.npg03 != g_npg03_t  )) THEN
                 SELECT count(*) INTO l_n FROM npg_file
                  WHERE npg01 = g_npg.npg01 AND npg02 = g_npg.npg02
                    AND npg03 = g_npg.npg03 
                 IF l_n > 0 THEN                  # Duplicated
                    LET g_msg = g_npg.npg01 CLIPPED,'+',g_npg.npg02,'+',
                               g_npg.npg03
                    CALL cl_err(g_msg,-239,0)
                    LET g_npg.npg01 = g_npg01_t
                    LET g_npg.npg02 = g_npg02_t
                    LET g_npg.npg03 = g_npg03_t
                    DISPLAY BY NAME g_npg.npg01 
                    DISPLAY BY NAME g_npg.npg02 
                    DISPLAY BY NAME g_npg.npg03 
                    NEXT FIELD npg03
                 END IF
               END IF
            END IF
        AFTER FIELD npg06
            IF cl_null(g_npg.npg06) THEN LET g_npg.npg06=0 END IF
           #str MOD-8C0059 add
            IF p_cmd = 'a' OR
              (p_cmd = 'u' AND g_npg.npg06 != g_npg_t.npg06 ) THEN
              #TQC-950018--Begin--#
               IF g_npg.npg06 < 0 THEN
                  CALL cl_err('','amm-110',0)
                  NEXT FIELD npg06
               END IF   
              #TQC-950018--End--#              
               SELECT azi04 INTO t_azi04 FROM azi_file,nma_file
                WHERE azi01=nma10
                  AND nma01=g_npg.npg01
               CALL cl_digcut(g_npg.npg06,t_azi04) RETURNING g_npg.npg06
               DISPLAY BY NAME g_npg.npg06
            END IF
           #end MOD-8C0059 add
        AFTER FIELD npg09
            IF cl_null(g_npg.npg09) THEN LET g_npg.npg09=0 END IF
           #str MOD-8C0059 add
            IF p_cmd = 'a' OR
              (p_cmd = 'u' AND g_npg.npg09 != g_npg_t.npg09 ) THEN
              #str TQC-8C0021 mark
              #SELECT azi04 INTO g_azi04 FROM azi_file,nma_file
              # WHERE azi01=nma10
              #   AND nma01=g_aza.aza17
              #end TQC-8C0021 mark
              #TQC-950018--Begin--#
               IF g_npg.npg09 < 0 THEN
                  CALL cl_err('','amm-110',0)
                  NEXT FIELD npg09
               END IF   
              #TQC-950018--End--#              
               CALL cl_digcut(g_npg.npg09,g_azi04) RETURNING g_npg.npg09
               DISPLAY BY NAME g_npg.npg09
            END IF
           #end MOD-8C0059 add
        AFTER FIELD npg16
            IF cl_null(g_npg.npg16) THEN LET g_npg.npg16=0 END IF
           #str MOD-8C0059 add
            IF p_cmd = 'a' OR
              (p_cmd = 'u' AND g_npg.npg16 != g_npg_t.npg16 ) THEN
              #TQC-950018--Begin--#
               IF g_npg.npg16 < 0 THEN
                  CALL cl_err('','amm-110',0)
                  NEXT FIELD npg16
               END IF   
              #TQC-950018--End--#              
               SELECT azi04 INTO t_azi04 FROM azi_file,nma_file
                WHERE azi01=nma10
                  AND nma01=g_npg.npg01
               CALL cl_digcut(g_npg.npg16,t_azi04) RETURNING g_npg.npg16
               DISPLAY BY NAME g_npg.npg16
            END IF
           #end MOD-8C0059 add
        AFTER FIELD npg19
            IF cl_null(g_npg.npg19) THEN LET g_npg.npg19=0 END IF
           #str MOD-8C0059 add
            IF p_cmd = 'a' OR
              (p_cmd = 'u' AND g_npg.npg19 != g_npg_t.npg19 ) THEN
              #str TQC-8C0021 mark
              #SELECT azi04 INTO g_azi04 FROM azi_file,nma_file
              # WHERE azi01=nma10
              #   AND nma01=g_aza.aza17
              #end TQC-8C0021 mark
              #TQC-950018--Begin--#
               IF g_npg.npg19 < 0 THEN
                  CALL cl_err('','amm-110',0)
                  NEXT FIELD npg19
               END IF   
              #TQC-950018--End--#              
               CALL cl_digcut(g_npg.npg19,g_azi04) RETURNING g_npg.npg19
               DISPLAY BY NAME g_npg.npg19
            END IF
           #end MOD-8C0059 add
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET l_flag='N'
            IF INT_FLAG THEN EXIT INPUT  END IF
            IF cl_null(g_npg.npg01) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_npg.npg01 
            END IF
            IF cl_null(g_npg.npg02) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_npg.npg02 
            END IF
            IF cl_null(g_npg.npg03) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_npg.npg03 
            END IF
            IF l_flag='Y' THEN
               CALL cl_err('','9033',0) NEXT FIELD npg01
            END IF
 
        #MOD-650015 --start 
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(npg01) THEN
        #        LET g_npg.* = g_npg_t.*
        #        DISPLAY BY NAME g_npg.* 
        #        NEXT FIELD npg01
        #    END IF
        #MOD-650015 --end
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(npg01) #料件編號
#                 CALL q_nma(0,0,g_npg.npg01) RETURNING g_npg.npg01
#                 CALL FGL_DIALOG_SETBUFFER( g_npg.npg01 )
                  CALL cl_init_qry_var() 
                  LET g_qryparam.form = "q_nma" 
                  LET g_qryparam.default1 = g_npg.npg01 
                  CALL cl_create_qry() RETURNING g_npg.npg01
#                  CALL FGL_DIALOG_SETBUFFER( g_npg.npg01 )
                  DISPLAY BY NAME g_npg.npg01 
                  NEXT FIELD npg01
               OTHERWISE EXIT CASE
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    
    END INPUT
END FUNCTION
 
FUNCTION t330_npg01(p_cmd)
DEFINE
    p_cmd        LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
    l_nma02      LIKE nma_file.nma02,
    l_nma10      LIKE nma_file.nma10,
    l_nmaacti    LIKE nma_file.nmaacti
 
    LET g_errno = ' '
    IF cl_null(g_npg.npg01) THEN 
       LET l_nma02 = NULL
    ELSE
       SELECT nma02,nma10,nmaacti 
         INTO l_nma02,l_nma10,l_nmaacti
         FROM nma_file WHERE nma01 = g_npg.npg01
       CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-013'
                                      LET l_nma02 = NULL
                                      LET l_nma10 = NULL
            WHEN l_nmaacti='N' LET g_errno = '9028'
            OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
    END IF
    IF p_cmd ='d' OR cl_null(g_errno) THEN
       DISPLAY l_nma02 TO FORMONLY.nma02 
       DISPLAY l_nma10 TO FORMONLY.nma10 
    END IF
END FUNCTION
 
FUNCTION t330_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_npg.* TO NULL              #No.FUN-6A0011
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL t330_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    MESSAGE " Searching! " 
    OPEN t330_count
    FETCH t330_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN t330_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        LET g_msg=g_npg.npg01 CLIPPED,'+',g_npg.npg02,'+',g_npg.npg03
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_npg.* TO NULL
    ELSE
        CALL t330_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t330_fetch(p_flnpg)
    DEFINE
        p_flnpg         LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680107 INTEGER
 
    CASE p_flnpg
        WHEN 'N' FETCH NEXT     t330_cs INTO g_npg.npg01,
                                             g_npg.npg02,g_npg.npg03
        WHEN 'P' FETCH PREVIOUS t330_cs INTO g_npg.npg01,
                                             g_npg.npg02,g_npg.npg03
        WHEN 'F' FETCH FIRST    t330_cs INTO g_npg.npg01,
                                             g_npg.npg02,g_npg.npg03
        WHEN 'L' FETCH LAST     t330_cs INTO g_npg.npg01,
                                             g_npg.npg02,g_npg.npg03
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump t330_cs INTO g_npg.npg01,g_npg.npg02,g_npg.npg03
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg=g_npg.npg01 CLIPPED,'+',g_npg.npg02,'+',g_npg.npg03
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_npg.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flnpg
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_npg.* FROM npg_file            # 重讀DB,因TEMP有不被更新特性
       WHERE npg01 = g_npg.npg01 AND npg02 = g_npg.npg02 AND npg03 = g_npg.npg03
    IF SQLCA.sqlcode THEN
        LET g_msg=g_npg.npg01 CLIPPED,'+',g_npg.npg02,'+',g_npg.npg03
#       CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660148
        CALL cl_err3("sel","npg_file",g_msg,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
    ELSE
 
        CALL t330_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t330_show()
    LET g_npg_t.* = g_npg.*
    #No.FUN-9A0024--begin
    #DISPLAY BY NAME g_npg.* 
    DISPLAY BY NAME g_npg.npg01,g_npg.npg02,g_npg.npg03,g_npg.npg06,g_npg.npg09,
                    g_npg.npg16,g_npg.npg19
    #No.FUN-9A0024--end 
    CALL t330_npg01('d')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t330_u()
    IF s_anmshut(0) THEN RETURN END IF
    IF g_npg.npg01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_npg01_t = g_npg.npg01
    LET g_npg02_t = g_npg.npg02
    LET g_npg03_t = g_npg.npg03
    BEGIN WORK
 
    OPEN t330_cl USING g_npg.npg01,g_npg.npg02,g_npg.npg03
    IF STATUS THEN
       CALL cl_err("OPEN t330_cl:", STATUS, 1)
       CLOSE t330_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t330_cl INTO g_npg.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        LET g_msg=g_npg.npg01 CLIPPED,'+',g_npg.npg02,'+',g_npg.npg03
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t330_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t330_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_npg.*=g_npg_t.*
            CALL t330_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE npg_file SET npg_file.* = g_npg.*    # 更新DB
            WHERE npg01 = g_npg.npg01 AND npg02 = g_npg.npg02 AND npg03 = g_npg.npg03             # COLAUTH?
        IF SQLCA.sqlcode THEN
            LET g_msg=g_npg.npg01 CLIPPED,'+',g_npg.npg02,'+',g_npg.npg03
#           CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("upd","npg_file",g_msg,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t330_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t330_r()
    DEFINE l_chr LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
    IF s_anmshut(0) THEN RETURN END IF
    IF g_npg.npg01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
    OPEN t330_cl USING g_npg.npg01,g_npg.npg02,g_npg.npg03
    IF STATUS THEN
       CALL cl_err("OPEN t330_cl:", STATUS, 1)
       CLOSE t330_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t330_cl INTO g_npg.*
    IF SQLCA.sqlcode THEN
        LET g_msg=g_npg.npg01 CLIPPED,'+',g_npg.npg02,'+',g_npg.npg03
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t330_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "npg01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "npg02"         #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "npg03"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_npg.npg01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_npg.npg02      #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_npg.npg03      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
        DELETE FROM npg_file 
            WHERE npg01 = g_npg.npg01 AND npg02 = g_npg.npg02 AND npg03 = g_npg.npg03
        IF SQLCA.SQLERRD[3]=0 THEN
            LET g_msg=g_npg.npg01 CLIPPED,'+',g_npg.npg02,'+',g_npg.npg03
#           CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("del","npg_file",g_msg,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
        ELSE
           CLEAR FORM
           OPEN t330_count
           #FUN-B50063-add-start--
           IF STATUS THEN
              CLOSE t330_cs
              CLOSE t330_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50063-add-end-- 
           FETCH t330_count INTO g_row_count
           #FUN-B50063-add-start--
           IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
              CLOSE t330_cs
              CLOSE t330_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50063-add-end--
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN t330_cs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL t330_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE
              CALL t330_fetch('/')
           END IF
        END IF
    END IF
    CLOSE t330_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t330_out()
   DEFINE
       l_i             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
       l_name          LIKE type_file.chr20,         #External(Disk) file name        #No.FUN-680107 VARCHAR(20)
       l_za05          LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(40)
       l_chr           LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
       sr              RECORD LIKE npg_file.*
 
   #No.FUN-820002--start--
   DEFINE l_cmd           LIKE type_file.chr1000
   IF cl_null(g_wc) AND NOT cl_null(g_npg.npg01) AND NOT cl_null(g_npg.npg02)                                                       
      AND NOT cl_null(g_npg.npg03) AND NOT cl_null(g_npg.npg06)                                                                     
      AND NOT cl_null(g_npg.npg09) AND NOT cl_null(g_npg.npg16)                                                                     
      AND NOT cl_null(g_npg.npg19)   THEN                                                                                           
   LET g_wc=" npg01='",g_npg.npg01,"' AND npg02='",g_npg.npg02,                                                                     
            "' AND npg03='",g_npg.npg03,"' AND npg06 = '",g_npg.npg06,                                                              
            "' AND npg09 = '",g_npg.npg09,"' AND npg16 = '",g_npg.npg16,                                                            
            "' AND npg19 = '",g_npg.npg19,"' "                                                                                      
   END IF 
   IF g_wc IS NULL THEN 
      CALL cl_err('','9057',0) RETURN END IF
#      CALL cl_err('',-400,0) RETURN END IF
 
    LET l_cmd = 'p_query "anmt330" "',g_wc CLIPPED,'"'                                                                              
    CALL cl_cmdrun(l_cmd)                                                                                                           
    RETURN               
#   CALL cl_wait()
#   CALL cl_outnam('anmt330') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT * FROM npg_file WHERE ",g_wc CLIPPED
#   PREPARE t330_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE t330_co CURSOR FOR t330_p1
 
#   START REPORT t330_rep TO l_name
 
#   FOREACH t330_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1) 
#           EXIT FOREACH
#       END IF
#       OUTPUT TO REPORT t330_rep(sr.*)
#   END FOREACH
#   FINISH REPORT t330_rep
#   CLOSE t330_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT t330_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
#       l_chr           LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
#       l_nma02         LIKE nma_file.nma02,          #銀行簡稱
#       l_nma10         LIKE nma_file.nma10,          #幣別
#       sr              RECORD LIKE npg_file.*
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.npg01,sr.npg02,sr.npg03
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno=g_pageno+1
#           LET pageno_total=PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED,pageno_total
#           PRINT g_dash[1,g_len]
#           PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#                 g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
#       ON EVERY ROW
#           SELECT nma02,nma10 INTO l_nma02,l_nma10 FROM nma_file WHERE nma01=sr.npg01
#           SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=l_nma10
#           PRINT COLUMN g_c[31],sr.npg01,
#                 COLUMN g_c[32],l_nma02,   #MOD-630047
#                 COLUMN g_c[33],sr.npg02 USING '####',
#                 COLUMN g_c[34],sr.npg03 USING '##',
#                 COLUMN g_c[35],cl_numfor(sr.npg06,35,g_azi04), 
#                 COLUMN g_c[36],cl_numfor(sr.npg09,36,g_azi04),
#                 COLUMN g_c[37],cl_numfor(sr.npg16,37,g_azi04),
#                 COLUMN g_c[38],cl_numfor(sr.npg19,38,g_azi04)  
#       ON LAST ROW
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-820002--end
 
FUNCTION t330_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("npg01",TRUE)
   END IF
END FUNCTION
 
FUNCTION t330_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("npg01",FALSE)
   END IF
END FUNCTION
 
