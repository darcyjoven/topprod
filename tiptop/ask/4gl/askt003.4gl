# Prog. Version..: '5.30.06-13.04.22(00008)'     #
#
# Pattern name...: askt003.4gl
# Descriptions...: 基礎碼尺寸表 
# Date & Author..: 08/08/07 By ve007 No.FUN-870117
# Modify.........: No.FUN-8A0145 08/10/31 by hongmei欄位類型修改
# Modify.........: No.TQC-8C0056 08/12/23 By alex 調整setup參數
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-910137 09/02/05 By chenyu 審核之后不可以再點審核
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/12 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No.FUN-AB0025 10/11/11 By huangtao 新增料號管控
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/13 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/20 By bart 複製後停在新資料畫面
# Modify.........: No:CHI-C80041 12/12/28 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:CHI-D20010 13/02/19 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D40030 13/04/08 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_sle           RECORD LIKE sle_file.*,       
    g_sle_t         RECORD LIKE sle_file.*,  
    g_sle_o         RECORD LIKE sle_file.*,
    g_sla          RECORD LIKE sla_file.*, 
    g_sle01_t      LIKE sle_file.sle01,  
    g_k             DYNAMIC ARRAY OF RECORD
        slf09a     LIKE slf_file.slf09a,
        slf11a     LIKE slf_file.slf11a,
        slf12a     LIKE slf_file.slf12a,
        slf13a     LIKE slf_file.slf13a,
        slf14a     LIKE slf_file.slf14a,
        slf15a     LIKE slf_file.slf15a,
        slf16a     LIKE slf_file.slf16a
                        END RECORD,
    g_slf           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        slf04      LIKE slf_file.slf04,  
        slf05      LIKE slf_file.slf05, 
        slf06      LIKE slf_file.slf06,
        bol02      LIKE bol_file.bol02,
        slf07      LIKE slf_file.slf07,
        slb02      LIKE slb_file.slb02,
        slf08      LIKE slf_file.slf08,       
        slf09      LIKE slf_file.slf09,
        slf10      LIKE slf_file.slf10,
        slf11      LIKE slf_file.slf11, 
        slf12      LIKE slf_file.slf12,
        slf13      LIKE slf_file.slf13,
        slf14      LIKE slf_file.slf14,
        slf15      LIKE slf_file.slf15,
        slf16      LIKE slf_file.slf16, 
        slf17      LIKE slf_file.slf17,
        slf18      LIKE slf_file.slf18    #備注
                    END RECORD,
    g_slf_t         RECORD                 #程式變數 (舊值)
        slf04      LIKE slf_file.slf04,
        slf05      LIKE slf_file.slf05,
        slf06      LIKE slf_file.slf06,
        bol02      LIKE bol_file.bol02,
        slf07      LIKE slf_file.slf07,
        slb02      LIKE slb_file.slb02,
        slf08      LIKE slf_file.slf08,
        slf09      LIKE slf_file.slf09,
        slf10      LIKE slf_file.slf10,
        slf11      LIKE slf_file.slf11,
        slf12      LIKE slf_file.slf12,
        slf13      LIKE slf_file.slf13,
        slf14      LIKE slf_file.slf14,
        slf15      LIKE slf_file.slf15,
        slf16      LIKE slf_file.slf16,
        slf17      LIKE slf_file.slf17,
        slf18      LIKE slf_file.slf18    #備注
 
                    END RECORD,
    g_wc,g_wc2,g_sql  STRING,
    l_za05          LIKE za_file.za05,
    g_rec_b         LIKE type_file.num5,              #單身筆數
    l_ac            LIKE type_file.num5              #目前處理的ARRAY CNT
DEFINE   g_before_input_done   LIKE type_file.num5
DEFINE   g_ima02    LIKE ima_file.ima02
DEFINE   g_ima021   LIKE ima_file.ima021
DEFINE   g_forupd_sql  STRING   #SELECT ... FOR UPDATE  SQL
DEFINE   g_chr         LIKE type_file.chr1
DEFINE   g_cnt         LIKE type_file.num5
DEFINE   g_i           LIKE type_file.num5   #count/index for any purpose
DEFINE   g_msg         LIKE type_file.chr100 #FUN-8A0145
DEFINE   g_curs_index  LIKE type_file.num5
DEFINE   g_row_count   LIKE type_file.num5
DEFINE   g_jump        LIKE type_file.num5
DEFINE   g_no_ask      LIKE type_file.num5
DEFINE   g_void        LIKE type_file.chr1      #CHI-C80041

MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASK")) THEN    #TQC-8C0056
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   OPEN WINDOW t003_w WITH FORM "ask/42f/askt003"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
        
   CALL g_x.clear()
    
   LET g_forupd_sql = "SELECT * FROM sle_file WHERE sle01=? AND sle02=? AND sle03=? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t003_cl CURSOR FROM g_forupd_sql
    
   SELECT * INTO g_sla.* FROM sla_file
   CALL t003_menu()
 
   CLOSE WINDOW t003_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
 
 
#QBE 查詢資料
FUNCTION t003_cs()
   CLEAR FORM                             #清除畫面
   CALL g_slf.clear()
   CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
      sle01,sle02,ima02,ima021,sle03,sle04,sle05,
      sle06,sle07,sle08,sle09,sleconf,
      sleuser,slegrup,slemodu,sledate
 
      ON ACTION controlp
         CASE
           WHEN INFIELD(sle01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_pbi"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO sle01
           WHEN INFIELD(sle02)
#FUN-AA0059---------mod------------str-----------------
#             CALL cl_init_qry_var()
#          #  LET g_qryparam.form = "q_ima98"
#             LET g_qryparam.form = "q_ima_slk"
#             LET g_qryparam.state = "c"
#             CALL cl_create_qry() RETURNING g_qryparam.multiret
              CALL q_sel_ima(TRUE, "q_ima_slk","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end----------------
              DISPLAY g_qryparam.multiret TO sle02
           WHEN INFIELD(sle03)       #尺寸
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_agd1"     
              LET g_qryparam.state = "c"
              LET g_qryparam.arg1 = g_sla.sla01
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO sle03
           WHEN INFIELD(sle05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_oea98"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO sle05              
          WHEN INFIELD(sle06)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_agd"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO sle06
            OTHERWISE
               EXIT CASE
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
 
   
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('sleuser', 'slegrup') #FUN-980030
 
   IF INT_FLAG THEN RETURN END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET g_wc = g_wc clipped," AND sleuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET g_wc = g_wc clipped," AND slegrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   CONSTRUCT g_wc2 ON slf04,slf05,slf06,bol02,
                      slf07,slf08,slb02,slf09,
                      slf10,slf11,slf12,slf13,
                      slf14,slf15,slf16,slf17,slf18
        FROM s_slf[1].slf04,s_slf[1].slf05,
             s_slf[1].slf06,s_slf[1].bol02,
             s_slf[1].slf07,s_slf[1].slf08,
             s_slf[1].slb02,s_slf[1].slf09,
             s_slf[1].slf10,s_slf[1].slf11,
             s_slf[1].slf12,s_slf[1].slf13,
             s_slf[1].slf14,s_slf[1].slf15,
             s_slf[1].slf16,s_slf[1].slf17,
             s_slf[1].slf18
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(slf06)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_slf06"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO slf06
            WHEN INFIELD(slf07)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_slf07"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO slf07
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
 
   
   END CONSTRUCT
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   IF g_wc2 = " 1=1" THEN			
      LET g_sql = "SELECT UNIQUE sle01,sle02,sle03 FROM sle_file,ima_file ",
                  " WHERE sle02 = ima01 AND ", g_wc CLIPPED,
                  " ORDER BY sle01"
   ELSE					
      LET g_sql = "SELECT UNIQUE sle01,sle02,sle03 ",
                  "  FROM sle_file, slf_file, ima_file, ",
                  "       bol_file, slb_file ",
                  " WHERE sle01 = slf01",
                  "   AND sle02 = slf02",
                  "   AND sle03 = slf03",
                  "   AND sle02 = ima01 ",
                  "   AND slf06 = bol01 ",
                  "   AND slf08 = slb001 ",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY sle01"
   END IF
 
   PREPARE t003_prepare FROM g_sql
   DECLARE t003_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR t003_prepare
 
   IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
       LET g_sql="SELECT COUNT(*) FROM sle_file,ima_file WHERE sle02 = ima01 AND ",g_wc CLIPPED
   ELSE
       LET g_sql="SELECT COUNT(DISTINCT sle01) FROM sle_file,slf_file,ima_file,bol_file,slb_file WHERE sle01 = slf01",
                 " AND sle02 = ima01 ",
                 " AND sle02 = slf02",
                 " AND sle03 = slf03",
                 " AND slf06 = bol01",
                 " AND slf08 = slb01",
                 " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE t003_precount FROM g_sql
   DECLARE t003_count CURSOR FOR t003_precount
  
   OPEN t003_count
   FETCH t003_count INTO g_row_count
   CLOSE t003_count
 
END FUNCTION
 
FUNCTION t003_menu()
 
   WHILE TRUE
      CALL t003_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL t003_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t003_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL t003_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL t003_u()
            END IF
 
         WHEN "reproduce" 
            IF cl_chk_act_auth() THEN
               CALL t003_copy()
            END IF
 
         WHEN "confirm"
            CALL t003_y()
 
         WHEN "undo_confirm"
            CALL t003_z()
 
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL t003_b()
            ELSE
               LET g_action_choice = NULL
            END IF
#         WHEN "output" 
#            IF cl_chk_act_auth()
#               THEN CALL t003_out()
#            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document" 
            IF cl_chk_act_auth() THEN
               IF g_sle.sle01 IS NOT NULL THEN
                  LET g_doc.column1 = "sle01"
                  LET g_doc.value1 = g_sle.sle01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_slf),'','')
            END IF
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               #CALL t003_v()                #CHI-D20010
               CALL t003_v(1)                #CHI-D20010
               IF g_sle.sleconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_sle.sleconf,"","","",g_void,"")
            END IF
         #CHI-C80041---end 
         #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               #CALL t003_v()                #CHI-D20010
               CALL t003_v(2)                #CHI-D20010
               IF g_sle.sleconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_sle.sleconf,"","","",g_void,"")
            END IF
         #CHI-D20010---end
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION t003_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_slf.clear()
    INITIALIZE g_sle.* LIKE sle_file.*             #DEFAULT 設定
    LET g_sle01_t = NULL
    #預設值及將數值類變數清成零
    LET g_sle_o.* = g_sle.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_sle.sleuser=g_user
        LET g_sle.slegrup=g_grup
        LET g_sle.sledate=g_today
        LET g_sle.sle07='Y'            
        LET g_sle.sleconf='N' 
        LET g_sle.sle06 = ' '   
        CALL t003_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_sle.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_sle.sle01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        LET g_sle.sleoriu = g_user      #No.FUN-980030 10/01/04
        LET g_sle.sleorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO sle_file VALUES (g_sle.*)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
            CALL cl_err(g_sle.sle01,SQLCA.sqlcode,1)
            CONTINUE WHILE
        END IF
        SELECT sle01,sle02,sle03 INTO g_sle.sle01,g_sle.sle02,g_sle.sle03 FROM sle_file
            WHERE sle01 = g_sle.sle01 AND sle02 = g_sle.sle02 AND sle03 =g_sle.sle03
        LET g_sle01_t = g_sle.sle01        #保留舊值
        LET g_sle_t.* = g_sle.*
 
        CALL g_slf.clear()
        LET g_rec_b = 0 
        CALL t003_b()                   #輸入單身
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION t003_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_sle.sle01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_sle.* FROM sle_file 
     WHERE sle01=g_sle.sle01
       AND sle02=g_sle.sle02
       AND sle03=g_sle.sle03
    IF g_sle.sleconf ='X' THEN RETURN END IF  #CHI-C80041
    IF g_sle.sleconf ='Y' THEN    #檢查資料是否為無效
       CALL cl_err(g_sle.sle01,9027,0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_sle01_t = g_sle.sle01
    LET g_sle_o.* = g_sle.*
    BEGIN WORK
 
    OPEN t003_cl USING g_sle.sle01,g_sle.sle02,g_sle.sle03
    IF STATUS THEN
       CALL cl_err("OPEN t003_cl:", STATUS, 1)
       CLOSE t003_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t003_cl INTO g_sle.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sle.sle01,SQLCA.sqlcode,1)      # 資料被他人LOCK
        CLOSE t003_cl ROLLBACK WORK RETURN
    END IF
    CALL t003_show()
    WHILE TRUE
        LET g_sle01_t = g_sle.sle01
        LET g_sle.slemodu=g_user
        LET g_sle.sledate=g_today
        CALL t003_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_sle.*=g_sle_t.*
            CALL t003_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_sle.sle01 != g_sle01_t THEN            # 更改單號
           UPDATE slf_file SET slf01 = g_sle.sle01
            WHERE slf01 = g_sle01_t
           IF SQLCA.sqlcode THEN
               CALL cl_err('slf',SQLCA.sqlcode,0) CONTINUE WHILE
           END IF
        END IF
        UPDATE sle_file SET sle_file.* = g_sle.*
         WHERE sle01 = g_sle_o.sle01 AND sle02 = g_sle_o.sle02 AND sle03 = g_sle_o.sle03
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_sle.sle01,SQLCA.sqlcode,0)
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t003_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t003_i(p_cmd)
   DEFINE   l_flag   LIKE type_file.chr1,      #判斷必要欄位是否有輸入
            p_cmd    LIKE type_file.chr1,      #a:輸入 u:更改
            l_cnt    LIKE type_file.num5,    
            l_n,l_n1 LIKE type_file.num5    
   DEFINE   
            l_agd03       LIKE agd_file.agd03,
            l_agb03       LIKE agb_file.agb03
 
   INPUT BY NAME
      g_sle.sle01,g_sle.sle02,g_sle.sle05,
      g_sle.sle04,g_sle.sle08,g_sle.sle09,
      g_sle.sle10,g_sle.sle03,g_sle.sle06,g_sle.sle07
      WITHOUT DEFAULTS  
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t003_set_entry(p_cmd)
         CALL t003_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE 
         
                
      AFTER FIELD sle01                  
         IF NOT cl_null(g_sle.sle01) THEN
            LET g_cnt = 0 
            SELECT COUNT(*) INTO g_cnt FROM sfci_file
             WHERE sfcislk01 = g_sle.sle01
            IF g_cnt <= 0 THEN
               CALL cl_err('','ask-106',0)   
               NEXT FIELD sle01
            END IF
         END IF
 
      AFTER FIELD sle02
         IF NOT cl_null(g_sle.sle02) THEN
#FUN-AB0025 ---------------------start----------------------------
              IF NOT s_chk_item_no(g_sle.sle02,"") THEN
                 CALL cl_err('',g_errno,1)
                 LET g_sle.sle02= g_sle_t.sle02
                 NEXT FIELD sle02
              END IF
#FUN-AB0025 ---------------------end-------------------------------
              LET g_cnt = 0
              SELECT count(*) INTO g_cnt FROM ima_file
               WHERE ima01 = g_sle.sle02
                 #AND imaag1 = ' '
              IF g_cnt <= 0 THEN
                 CALL cl_err('','ask-100',0)
                 DISPLAY BY NAME g_sle.sle02
                 NEXT FIELD sle02
              ELSE
                 SELECT ima02,ima021 INTO g_ima02,g_ima021 FROM ima_file
                  WHERE ima01 = g_sle.sle02
                   #AND imaag1 = ' '
                 DISPLAY g_ima02 TO ima02
                 DISPLAY g_ima021 TO ima021
              END IF
        END IF
      BEFORE FIELD sle04
        LET g_sle.sle04 = g_today
        DISPLAY BY NAME g_sle.sle04
 
      AFTER FIELD sle05
        IF NOT cl_null(g_sle.sle05) THEN
             LET g_cnt = 0
             SELECT count(*) INTO g_cnt FROM oea_file
              WHERE ta_oea005 = g_sle.sle05
                #AND imaag1 = ' '
             IF g_cnt <= 0 THEN
                CALL cl_err('','ask-101',0)
                DISPLAY BY NAME g_sle.sle05
                NEXT FIELD sle05
             END IF
       END IF
  
      AFTER FIELD sle06
       IF NOT cl_null(g_sle.sle06) THEN
           LET g_cnt = 0
    #      SELECT COUNT(*) INTO g_cnt FROM agd_file   #mark by chenyu 
    #        WHERE agd01 = g_tc_sla.tc_sla02
    #          AND agd02 = g_sle.sle06
    #      IF g_cnt <= 0 THEN
    #         CALL cl_err(g_sle.sle06,'agd-001',1)
    #         NEXT FIELD sle06
    #      END IF
        END IF
 
      ### 尺寸編碼必須存在于屬性基本資料檔里面
      AFTER FIELD sle03                                               
        IF NOT cl_null(g_sle.sle03) THEN
             LET g_cnt = 0
 
              SELECT COUNT(*) INTO g_cnt FROM agd_file
               WHERE agd02 = g_sle.sle03
              IF g_cnt <= 0 THEN 
                 CALL cl_err('','ask-102',0)
                 DISPLAY BY NAME g_sle.sle03
                 NEXT FIELD sle03
              ELSE
#                SELECT DISTINCT agd03 INTO l_agd03 FROM agd_file
                 SELECT COUNT(*) INTO l_n1 FROM agd_file 
#                 WHERE agd01 = g_sla.sla01  #No.FUN-870117 mark
                  WHERE agd01 = g_sla.sla02  #No.FUN-870117 add
                    AND agd02 = g_sle.sle03
                    IF l_n1 <= 0 THEN 
                       CALL cl_err('','ask-102',0)
                       DISPLAY l_agd03 TO agd03
                       NEXT FIELD sle03 
                     END IF    
             END IF
        END IF
     ###End   
 
 
        AFTER FIELD sle10
           IF NOT cl_null(g_sle.sle10) THEN
              IF g_sle_t.sle10 IS NULL OR g_sle_t.sle10 != g_sle.sle10 THEN
                 SELECT COUNT(*) INTO l_n FROM ocq_file
                  WHERE ocq01 = g_sle.sle10
                 IF l_n = 0 THEN
                    CALL cl_err('','',0)
                    NEXT FIELD sle10
                 END IF
              END IF
           END IF 
 
 
      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,并要求重新輸入
         LET g_sle.sleuser = s_get_data_owner("sle_file") #FUN-C10039
         LET g_sle.slegrup = s_get_data_group("sle_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT  
         END IF
#         CALL cl_show_req_fields()
 
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
      ON ACTION CONTROLO                        # 沿用所有欄位
         IF INFIELD(sle01) THEN
            LET g_sle.* = g_sle_t.*
            #No.FUN-9A0024--begin 
            #DISPLAY BY NAME g_sle.* 
            DISPLAY BY NAME g_sle.sle01,g_sle.sle02,g_sle.sle03,g_sle.sle04,
                            g_sle.sle05,g_sle.sle06,g_sle.sle07,g_sle.sle08,
                            g_sle.sle09,g_sle.sle10,g_sle.sleconf,
                            g_sle.sleuser,g_sle.slegrup,g_sle.slemodu,
                            g_sle.sledate,g_sle.sleoriu,g_sle.sleorig   
            #No.FUN-9A0024--end                         
            NEXT FIELD sle01
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(sle01)
               CALL cl_init_qry_var()
               # LET g_qryparam.form = "q_oea13" 
               LET g_qryparam.form = "q_pbi"
#              LET g_qryparam.default1 = g_sle.sle01    #No.FUN-870117 mark
               LET g_qryparam.default1 = g_sle.sle02    #No.FUN-870117 add
               CALL cl_create_qry() RETURNING g_sle.sle01
               DISPLAY g_sle.sle01 TO sle01
          WHEN INFIELD(sle06)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_agd"
        #     LET g_qryparam.arg1 = g_tc_sla.tc_sla02   
              LET g_qryparam.default1 = g_sle.sle06
              CALL cl_create_qry() RETURNING g_sle.sle06
              DISPLAY g_sle.sle06 TO sle06
 
          WHEN INFIELD(sle02)
#FUN-AA0059---------mod------------str-----------------
#             CALL cl_init_qry_var()
#             #LET g_qryparam.form = "q_ima98" 
#             #LET g_qryparam.default1 = g_sle.sle02              
#             #LET g_qryparam.form = "q_ima20"           
#             LET g_qryparam.form = "q_ima_slk"   
#      #      LET g_qryparam.construct = 'N'            
#      #      LET g_qryparam.arg1 =g_sle.sle01
#      #      #LET g_qryparam.arg1 = "'",g_sle.sle01,"','",g_sle.sle01,"'"  
#      #      message g_qryparam.arg1
#             LET g_qryparam.default1 = g_sle.sle02              
#             CALL cl_create_qry() RETURNING g_sle.sle02
              CALL q_sel_ima(FALSE, "q_ima_slk","",g_sle.sle02,"","","","","",'' ) 
                 RETURNING g_sle.sle02   
#FUN-AA0059---------mod------------end-----------------
              DISPLAY g_sle.sle02 TO sle02
            WHEN INFIELD(sle03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_agd1"    #chenyu  需要修改
               LET g_qryparam.arg1 = g_sla.sla02
               LET g_qryparam.construct = "N"
               CALL cl_create_qry() RETURNING g_sle.sle03
               DISPLAY g_sle.sle03 TO sle03        
           WHEN INFIELD(sle05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_oea98"
              LET g_qryparam.default1 = g_sle.sle05
              CALL cl_create_qry() RETURNING g_sle.sle05
              DISPLAY g_sle.sle05 TO sle05
 
           WHEN INFIELD(sle10)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ocq"
              LET g_qryparam.default1 = g_sle.sle10
              CALL cl_create_qry() RETURNING g_sle.sle10
              DISPLAY g_sle.sle10 TO sle10
 
            OTHERWISE
               EXIT CASE
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about       
         CALL cl_about()     
 
      ON ACTION help         
         CALL cl_show_help()  
 
   
   END INPUT
END FUNCTION
 
FUNCTION t003_set_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1
 
      IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("sle01,sle02,sle03",TRUE)
      END IF
END FUNCTION
 
FUNCTION t003_set_no_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1
 
      IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("sle01,sle02,sle03",FALSE)
      END IF
 
END FUNCTION
 
#Query 查詢     
FUNCTION t003_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_slf.clear()
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL t003_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! " 
    OPEN t003_count
    FETCH t003_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN t003_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_sle.* TO NULL
    ELSE
        CALL t003_fetch('F')                  # 讀出TEMP第一筆并顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t003_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,      #處理方式
    ls_jump         LIKE ze_file.ze03
 
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t003_cs INTO g_sle.sle01,g_sle.sle02,g_sle.sle03
        WHEN 'P' FETCH PREVIOUS t003_cs INTO g_sle.sle01,g_sle.sle02,g_sle.sle03
        WHEN 'F' FETCH FIRST    t003_cs INTO g_sle.sle01,g_sle.sle02,g_sle.sle03
        WHEN 'L' FETCH LAST     t003_cs INTO g_sle.sle01,g_sle.sle02,g_sle.sle03
        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED, ': ' FOR g_jump  
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
            END IF
            FETCH ABSOLUTE g_jump t003_cs INTO g_sle.sle01,g_sle.sle02,g_sle.sle03 
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sle.sle01,SQLCA.sqlcode,0)
        RETURN
    ELSE
       CASE p_flag
            WHEN 'F' LET g_curs_index = 1
            WHEN 'P' LET g_curs_index = g_curs_index - 1
            WHEN 'N' LET g_curs_index = g_curs_index + 1
            WHEN 'L' LET g_curs_index = g_row_count
            WHEN '/' LET g_curs_index = g_jump          #--改g_jump
       END CASE
 
       CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
    SELECT * INTO g_sle.* FROM sle_file WHERE sle01 = g_sle.sle01 AND sle02 = g_sle.sle02 AND sle03 = g_sle.sle03
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sle.sle01,SQLCA.sqlcode,0)
        INITIALIZE g_sle.* TO NULL
        RETURN
    ELSE                                   
       LET g_data_owner=g_sle.sleuser       
       LET g_data_group=g_sle.slegrup
    END IF
 
    CALL t003_show()
END FUNCTION
 
FUNCTION t003_show()
    DEFINE l_cnt      LIKE type_file.num5,
           l_agd03    LIKE agd_file.agd03
    SELECT ima02,ima021 INTO g_ima02,g_ima021 FROM ima_file
     WHERE ima01 = g_sle.sle02 
    LET g_sle_t.* = g_sle.*                      #保存單頭舊值
    DISPLAY BY NAME                              # 顯示單頭值
        g_sle.sle01,g_sle.sle02,
        g_sle.sle03,g_sle.sle04,g_sle.sle05,
        g_sle.sle06,g_sle.sle07,g_sle.sle08,
        g_sle.sle09,g_sle.sle10,g_sle.sleconf,
        g_sle.sleuser,g_sle.slegrup,g_sle.slemodu,
        g_sle.sledate,g_sle.sleoriu,g_sle.sleorig        #No.FUN-9A0024 add sleoriu,sleorig
    DISPLAY g_ima02 TO ima02
    DISPLAY g_ima021 TO ima021
 
   SELECT DISTINCT agd03 INTO l_agd03 FROM agd_file
    WHERE agd01 = g_sla.sla01
      AND agd02 = g_sle.sle03
   DISPLAY l_agd03 TO agd03
 
   CALL t003_b_fill()                 #單身
 
   CALL cl_show_fld_cont()                  
   #CALL cl_set_field_pic(g_sle.sleconf,"","","","","")  #CHI-C80041
   IF g_sle.sleconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
   CALL cl_set_field_pic(g_sle.sleconf,"","","",g_void,"")  #CHI-C80041
END FUNCTION
 
FUNCTION t003_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_sle.sle01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    IF g_sle.sleconf ='X' THEN RETURN END IF  #CHI-C80041
    IF g_sle.sleconf = 'Y' THEN
       CALL cl_err("",9022,0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN t003_cl USING g_sle.sle01,g_sle.sle02,g_sle.sle03
    IF STATUS THEN
       CALL cl_err("OPEN t003_cl:", STATUS, 1)
       CLOSE t003_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t003_cl INTO g_sle.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sle.sle01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE t003_cl ROLLBACK WORK RETURN
    END IF
    CALL t003_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "sle01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_sle.sle01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
         DELETE FROM sle_file WHERE sle01 = g_sle.sle01
                                AND sle02 = g_sle.sle02
                                AND sle03 = g_sle.sle03
                                AND sle06 = g_sle.sle06
         DELETE FROM slf_file WHERE slf01 = g_sle.sle01
                                AND slf02 = g_sle.sle02
                                AND slf03 = g_sle.sle03
                                AND slf19 = g_sle.sle06
         INITIALIZE g_sle.* TO NULL
         CLEAR FORM
         CALL g_slf.clear()
         OPEN t003_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE t003_cs
            CLOSE t003_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end--
         FETCH t003_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t003_cs
            CLOSE t003_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t003_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t003_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL t003_fetch('/')
         END IF
    END IF
    CLOSE t003_cl
    COMMIT WORK
END FUNCTION
 
 
 
#單身
FUNCTION t003_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,   #檢查重復用
    l_lock_sw       LIKE type_file.chr1,      #單身鎖住否
    p_cmd           LIKE type_file.chr1,      #處理狀態
    l_k             LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.chr1,      #可新增否
    l_allow_delete  LIKE type_file.chr1       #可刪除否
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_sle.sle01 IS NULL THEN
       RETURN
    END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    SELECT * INTO g_sle.* FROM sle_file 
     WHERE sle01=g_sle.sle01
       AND sle02=g_sle.sle02
       AND sle03=g_sle.sle03
       
    IF g_sle.sleconf ='X' THEN RETURN END IF  #CHI-C80041
    IF g_sle.sleconf ='Y' THEN    #檢查資料是否為審核
       CALL cl_err('','ask-103',0)
       #CALL cl_err(g_sle.sle1,'aom-000',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT slf04,slf05,slf06,'',",
                       "       slf07,'',slf08,slf09,",
                       "       slf10,slf11,slf12,slf13,",
                       "       slf14,slf15,slf16,slf17,",
                       "       slf18  FROM slf_file ",
                       "  WHERE slf01=? AND slf02=? ",
                       "   AND slf03=? AND slf04=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t003_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_slf WITHOUT DEFAULTS FROM s_slf.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT"
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
        BEFORE ROW
           DISPLAY "BEFORE ROW"
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
 
            BEGIN WORK
            OPEN t003_cl USING g_sle.sle01,g_sle.sle02,g_sle.sle03
            IF STATUS THEN
               CALL cl_err("OPEN t003_cl:", STATUS, 1)
               CLOSE t003_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t003_cl INTO g_sle.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_sle.sle01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE t003_cl 
               ROLLBACK WORK 
               RETURN
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_slf_t.* = g_slf[l_ac].*  #BACKUP
                OPEN t003_bcl USING g_sle.sle01,
                                    g_sle.sle02,
                                    g_sle.sle03,
                                    g_slf_t.slf04
                IF STATUS THEN
                   CALL cl_err("OPEN t003_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH t003_bcl INTO g_slf[l_ac].* 
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_slf_t.slf04,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
                   #CALL t003_slf(' ')           #for referenced field
                   SELECT bol02
                     INTO g_slf[l_ac].bol02
                     FROM bol_file
                    WHERE bol01 = g_slf[l_ac].slf06
                   SELECT slb02
                     INTO g_slf[l_ac].slb02
                     FROM slb_file
                    WHERE slb01 = g_slf[l_ac].slf07
 
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
        DISPLAY "BEFORE INSERT"
            LET p_cmd='a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_slf[l_ac].* TO NULL      #900423
            LET g_slf_t.* = g_slf[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD slf04
 
        AFTER INSERT
        DISPLAY "AFTER INSERT"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
 
           INSERT INTO slf_file 
                VALUES(g_sle.sle01,g_sle.sle02,g_sle.sle03,
                       g_slf[l_ac].slf04,g_slf[l_ac].slf05,
                       g_slf[l_ac].slf06,g_slf[l_ac].slf07,
                       g_slf[l_ac].slf08,g_slf[l_ac].slf09,
                       g_k[l_ac].slf09a,g_slf[l_ac].slf10,
                       g_slf[l_ac].slf11,g_k[l_ac].slf11a,
                       g_slf[l_ac].slf12,g_k[l_ac].slf12a,
                       g_slf[l_ac].slf13,g_k[l_ac].slf13a,
                       g_slf[l_ac].slf14,g_k[l_ac].slf14a,
                       g_slf[l_ac].slf15,g_k[l_ac].slf15a,
                       g_slf[l_ac].slf16,g_k[l_ac].slf16a,
                       g_slf[l_ac].slf17,g_slf[l_ac].slf18,g_sle.sle06)
           IF SQLCA.sqlcode THEN
               CALL cl_err(g_slf[l_ac].slf04,SQLCA.sqlcode,1)
               CANCEL INSERT
           ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
        BEFORE FIELD slf04                        #default 序號
            IF g_slf[l_ac].slf04 IS NULL OR
               g_slf[l_ac].slf04 = 0 THEN
                 SELECT max(slf04)+1               #MOD-540144
                   INTO g_slf[l_ac].slf04
                   FROM slf_file
                  WHERE slf01 = g_sle.sle01
                    AND slf02 = g_sle.sle02
                    AND slf03 = g_sle.sle03
                    AND slf19 = g_sle.sle06
                IF g_slf[l_ac].slf04 IS NULL THEN
                    LET g_slf[l_ac].slf04 = 1
                END IF
            END IF
 
        AFTER FIELD slf04                        #check 序號是否重復
            IF NOT cl_null(g_slf[l_ac].slf04) THEN
               IF g_slf[l_ac].slf04 != g_slf_t.slf04 OR
                  g_slf_t.slf04 IS NULL THEN
                  LET l_n = 0
                   SELECT count(*) INTO l_n FROM slf_file
                    WHERE slf01 = g_sle.sle01 
                      AND slf02 = g_sle.sle02
                      AND slf03 = g_sle.sle03
                      AND slf19 = g_sle.sle06
                      AND slf04 = g_slf[l_ac].slf04
                   IF l_n > 0 THEN
                      CALL cl_err('',-239,0)
                      LET g_slf[l_ac].slf04 = g_slf_t.slf04
                      NEXT FIELD slf04
                   END IF
               END IF
            END IF
 
        AFTER FIELD slf06
            IF NOT cl_null(g_slf[l_ac].slf06) THEN
               LET g_cnt = 0
               SELECT COUNT(*) INTO g_cnt
                 FROM bol_file
                WHERE bol01 = g_slf[l_ac].slf06
               IF g_cnt<=0 THEN
                  CALL cl_err('','ask-104',0)
                  NEXT FIELD slf06
               ELSE
                  SELECT bol02,bol04 
                    INTO g_slf[l_ac].bol02,
                         g_slf[l_ac].slf08 
                    FROM bol_file
                   WHERE bol01 = g_slf[l_ac].slf06
                  DISPLAY g_slf[l_ac].bol02 TO bol02
                  DISPLAY g_slf[l_ac].slf08 TO slf08
               END IF
            END IF
 
        AFTER FIELD slf07
            IF NOT cl_null(g_slf[l_ac].slf07) THEN
               LET g_cnt = 0
               SELECT COUNT(*) INTO g_cnt
                 FROM slb_file
                WHERE slb01 = g_slf[l_ac].slf07
               IF g_cnt<=0 THEN
                  CALL cl_err('','ask-105',0)
                  NEXT FIELD slf07
               ELSE
                  SELECT slb02 INTO g_slf[l_ac].slb02
                    FROM slb_file
                   WHERE slb01 = g_slf[l_ac].slf07
                  DISPLAY g_slf[l_ac].slb02 TO slb02
               END IF
            END IF
 
 
        AFTER FIELD slf09
          IF NOT cl_null(g_slf[l_ac].slf09) THEN
            CALL t003_cl_s_d(g_slf[l_ac].slf09) 
                 RETURNING g_k[l_ac].slf09a,l_k
            IF l_k = 'N' THEN
               NEXT FIELD slf09
            END IF
          END IF
        
        BEFORE FIELD slf10
           IF cl_null(g_slf[l_ac].slf10) THEN
              IF g_slf[l_ac].slf08 = '1' THEN 
                 LET g_slf[l_ac].slf10 = g_sle.sle09
              END IF
 
              IF g_slf[l_ac].slf08 = '2' THEN 
                 LET g_slf[l_ac].slf10 = g_sle.sle08
              END IF
           END IF
   
 
        AFTER FIELD slf11
          IF NOT cl_null(g_slf[l_ac].slf11) THEN
            CALL t003_cl_s_d(g_slf[l_ac].slf11)
                 RETURNING g_k[l_ac].slf11a,l_k
            IF l_k = 'N' THEN
               NEXT FIELD slf11
            END IF
          END IF
 
        AFTER FIELD slf12
          IF NOT cl_null(g_slf[l_ac].slf12) THEN
            CALL t003_cl_s_d(g_slf[l_ac].slf12)
                 RETURNING g_k[l_ac].slf12a,l_k
            IF l_k = 'N' THEN
               NEXT FIELD slf12
            END IF
          END IF
          
        AFTER FIELD slf13
          IF NOT cl_null(g_slf[l_ac].slf13) THEN
            CALL t003_cl_s_d(g_slf[l_ac].slf13)
                 RETURNING g_k[l_ac].slf13a,l_k
            IF l_k = 'N' THEN
               NEXT FIELD slf13
            END IF
          END IF
        AFTER FIELD slf14
          IF NOT cl_null(g_slf[l_ac].slf14) THEN
            CALL t003_cl_s_d(g_slf[l_ac].slf14)
                 RETURNING g_k[l_ac].slf14a,l_k
            IF l_k = 'N' THEN
               NEXT FIELD slf14
            END IF
          END IF
        AFTER FIELD slf15
          IF NOT cl_null(g_slf[l_ac].slf15) THEN
            CALL t003_cl_s_d(g_slf[l_ac].slf15)
                 RETURNING g_k[l_ac].slf15a,l_k
            IF l_k = 'N' THEN
               NEXT FIELD slf15
            END IF
          END IF
        AFTER FIELD slf16
          IF NOT cl_null(g_slf[l_ac].slf16) THEN
            CALL t003_cl_s_d(g_slf[l_ac].slf16)
                 RETURNING g_k[l_ac].slf16a,l_k
            IF l_k = 'N' THEN
               NEXT FIELD slf16
            END IF
          END IF
 
        BEFORE DELETE                           
            IF g_slf_t.slf04 > 0 AND
               g_slf_t.slf04 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
               DELETE FROM slf_file
                WHERE slf01 = g_sle.sle01 
                  AND slf02 = g_sle.sle02
                  AND slf03 = g_sle.sle03
                  AND slf04 = g_slf_t.slf04
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_slf_t.slf04,SQLCA.sqlcode,0)
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  
               MESSAGE "Delete Ok"
               CLOSE t003_bcl
               COMMIT WORK
            END IF
 
     ON ROW CHANGE
            DISPLAY "ON ROW CHANGE"
            IF INT_FLAG THEN                
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_slf[l_ac].* = g_slf_t.*
               CLOSE t003_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
           
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_slf[l_ac].slf04,-263,1)
               LET g_slf[l_ac].* = g_slf_t.*
            ELSE
               UPDATE slf_file SET slf04=g_slf[l_ac].slf04,
                                       slf05=g_slf[l_ac].slf05,
                                       slf06=g_slf[l_ac].slf06,
                                       slf07=g_slf[l_ac].slf07,
                                       slf08=g_slf[l_ac].slf08,
                                       slf09=g_slf[l_ac].slf09,
                                       slf10=g_slf[l_ac].slf10,
                                       slf11=g_slf[l_ac].slf11,
                                       slf12=g_slf[l_ac].slf12,
                                       slf13=g_slf[l_ac].slf13,
                                       slf14=g_slf[l_ac].slf14,
                                       slf15=g_slf[l_ac].slf15,
                                       slf16=g_slf[l_ac].slf16,
                                       slf17=g_slf[l_ac].slf17,
                                       slf18=g_slf[l_ac].slf18,
                                       slf09a = g_k[l_ac].slf09a,
                                       slf11a = g_k[l_ac].slf11a,
                                       slf12a = g_k[l_ac].slf12a,
                                       slf13a = g_k[l_ac].slf13a,
                                       slf14a = g_k[l_ac].slf14a,
                                       slf15a = g_k[l_ac].slf15a,
                                       slf16a = g_k[l_ac].slf16a
                WHERE slf01=g_sle.sle01
                  AND slf02=g_sle.sle02 
                  AND slf03=g_sle.sle03
                  AND slf04=g_slf_t.slf04
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_slf[l_ac].slf04,SQLCA.sqlcode,1)
                  LET g_slf[l_ac].* = g_slf_t.*
                  CLOSE t003_bcl
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE t003_bcl
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW   
           DISPLAY "AFTER  ROW"
           LET l_ac = ARR_CURR()
#          LET l_ac_t = l_ac              #FUN-D40030 mark
 
           IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_slf[l_ac].* = g_slf_t.*
               #FUN-D40030---add---str---
               ELSE
                  CALL g_slf.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030---add---end---
               END IF
               CLOSE t003_bcl
               ROLLBACK WORK
               EXIT INPUT
           END IF
           LET l_ac_t = l_ac              #FUN-D40030 add
           CLOSE t003_bcl
           COMMIT WORK
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(slf06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_bol"
                     LET g_qryparam.default1 = g_slf[l_ac].slf06
                     CALL cl_create_qry() RETURNING g_slf[l_ac].slf06
                     DISPLAY BY NAME g_slf[l_ac].slf06
                     NEXT FIELD slf06
                WHEN INFIELD(slf07)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_slb"
                      LET g_qryparam.default1 = g_slf[l_ac].slf07
                     CALL cl_create_qry() RETURNING g_slf[l_ac].slf07 
                     DISPLAY BY NAME g_slf[l_ac].slf07
                     NEXT FIELD slf07
                OTHERWISE
                    EXIT CASE
            END CASE
 
        ON ACTION CONTROLN
            CALL t003_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            LET g_slf[l_ac].* = g_slf[l_ac-1].*
            IF  l_ac > 1 THEN
               LET g_slf[l_ac].* = g_slf[l_ac-1].*
               SELECT max(slf04)+1
                 INTO g_slf[l_ac].slf04
                 FROM slf_file
                WHERE slf01 = g_sle.sle01
                  AND slf02=g_sle.sle02
                  AND slf03=g_sle.sle03
               NEXT FIELD slf04
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about      
         CALL cl_about()      
 
      ON ACTION help         
         CALL cl_show_help()  
 
    END INPUT
 
    LET g_sle.slemodu = g_user
    LET g_sle.sledate = g_today
    UPDATE sle_file SET slemodu = g_sle.slemodu,sledate = g_sle.sledate
     WHERE sle01 = g_sle.sle01
       AND sle02 = g_sle.sle02
       AND sle03 = g_sle.sle03
    DISPLAY BY NAME g_sle.slemodu,g_sle.sledate
 
    CLOSE t003_bcl
    CLOSE t003_cl
    COMMIT WORK
    #CALL t003_delall()
    CALL t003_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t003_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         #CALL t003_v()        #CHI-D20010
         CALL t003_v(1)        #CHI-D20010
         IF g_sle.sleconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_sle.sleconf,"","","",g_void,"")
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN #CHI-C80041
         DELETE FROM sle_file WHERE sle01 = g_sle.sle01
                              AND sle02 = g_sle.sle02
                              AND sle03 = g_sle.sle03
         INITIALIZE g_sle.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION t003_delall()
    LET g_cnt = 0
    SELECT COUNT(*) INTO g_cnt FROM slf_file
        WHERE slf01 = g_sle.sle01
          AND slf02=g_sle.sle02
          AND slf03=g_sle.sle03
    IF g_cnt <= 0 THEN 			# 未輸入單身資料, 是否取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM sle_file WHERE sle01 = g_sle.sle01
                              AND sle02 = g_sle.sle02
                              AND sle03 = g_sle.sle03
    END IF
END FUNCTION
 
FUNCTION t003_b_askkey()
DEFINE
    #l_wc2           LIKE type_file.chr1000
    l_wc2           STRING       #NO.FUN-910082 
 
    CLEAR bol02,slb02                           #清除FORMONLY欄位
    CONSTRUCT l_wc2 ON slf04,slf05,slf06,bol02,
                       slf07,slf08,slb02,slf09,
                       slf10,slf11,slf12,slf13,
                       slf14,slf15,
                       slf16,slf17,slf18
       FROM s_slf[1].slf04,s_slf[1].slf05,
            s_slf[1].slf06,s_slf[1].bol02,
            s_slf[1].slf07,s_slf[1].slf08,
            s_slf[1].slb02,s_slf[1].slf09,
            s_slf[1].slf10,s_slf[1].slf11,
            s_slf[1].slf12,s_slf[1].slf13,
            s_slf[1].slf14,s_slf[1].slf15,
            s_slf[1].slf16,s_slf[1].slf17,
            s_slf[1].slf18
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about        
         CALL cl_about()    
 
      ON ACTION help         
         CALL cl_show_help() 
 
      ON ACTION controlg     
         CALL cl_cmdask()    
 
    
    END CONSTRUCT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL t003_b_fill()
END FUNCTION
 
FUNCTION t003_b_fill()              #BODY FILL UP
 
    LET g_sql = " SELECT slf04,slf05,slf06,'',slf07,'',slf08,slf09, ",
                       " slf10,slf11,slf12,slf13,slf14,slf15,slf16, ",
                       " slf17,slf18 ",
                  " FROM slf_file ",
                 " WHERE slf01 ='",g_sle.sle01,"' ", 
                   " AND slf02 ='",g_sle.sle02,"' ", 
                   " AND slf03 ='",g_sle.sle03,"' ",
                   " AND slf19 ='",g_sle.sle06,"' ",
                   " AND ",g_wc2 CLIPPED," ORDER BY 1"
    PREPARE t003_pb FROM g_sql
    DECLARE slf_curs                       #SCROLL CURSOR
        CURSOR FOR t003_pb
 
    CALL g_slf.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH slf_curs INTO g_slf[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
 
      SELECT bol02 INTO g_slf[g_cnt].bol02 FROM bol_file
       WHERE bol01 = g_slf[g_cnt].slf06
 
      SELECT slb02 INTO g_slf[g_cnt].slb02 FROM slb_file
       WHERE slb01 = g_slf[g_cnt].slf07
        LET g_rec_b = g_rec_b + 1
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
	   EXIT FOREACH
        END IF
    END FOREACH
    CALL g_slf.deleteElement(g_cnt)
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t003_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_slf TO s_slf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()               
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
     #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
     #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end

      #CHI-D20010--add--str
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010--add---end
      ON ACTION first 
         CALL t003_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                 
                              
      ON ACTION previous
         CALL t003_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY                 
                              
      ON ACTION jump 
         CALL t003_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
                              
      ON ACTION next
         CALL t003_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY                  
                              
      ON ACTION last 
         CALL t003_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DISPLAY                 
#      ON ACTION invalid
#         LET g_action_choice="invalid"
#         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
#      ON ACTION output
#         LET g_action_choice="output"
#         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about       
         CALL cl_about()      
 
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION t003_copy()
DEFINE
    l_sle		RECORD LIKE sle_file.*,
    l_ima02             LIKE ima_file.ima02,
    l_ima021            LIKE ima_file.ima021,
    l_agd03             LIKE agd_file.agd03,
    l_oldno,l_newno	LIKE sle_file.sle01,
    l_oldit,l_newit     LIKE sle_file.sle02,
    l_oldsz,l_newsz     LIKE sle_file.sle03,
    l_oldys,l_newys     LIKE sle_file.sle06
 
    IF s_shut(0) THEN RETURN END IF
    IF g_sle.sle01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL t003_set_entry('a')
    CALL t003_set_no_entry('a')
    LET g_before_input_done = TRUE
 
    DISPLAY l_ima02 TO ima02
    DISPLAY l_ima021 TO ima021
    DISPLAY l_agd03 TO agd03
    INPUT l_newno,l_newit,l_newsz,l_newys FROM sle01,sle02,sle03,sle06
            
        AFTER FIELD sle01 
            IF NOT cl_null(l_newno) THEN
               LET g_cnt = 0
               SELECT COUNT(*) INTO g_cnt FROM sfci_file
                WHERE sfcislk01 = l_newno
               IF g_cnt <= 0 THEN
                  CALL cl_err('','ask-106',0)
                  NEXT FIELD sle01
               END IF
            END IF
 
       AFTER FIELD sle02
         IF NOT cl_null(l_newit) THEN
              LET g_cnt = 0
              SELECT count(*) INTO g_cnt FROM ima_file
               WHERE ima01 = l_newit 
                 #AND imaag1 = ' '
              IF g_cnt <= 0 THEN
                 CALL cl_err('','ask-100',0)
                 NEXT FIELD l_newit 
              ELSE
                 SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
                  WHERE ima01 = l_newit 
                 DISPLAY l_ima02 TO ima02
                 DISPLAY l_ima021 TO ima021
              END IF
        END IF
 
      AFTER FIELD sle03
        IF NOT cl_null(l_newsz) THEN
             LET g_cnt = 0
 
              SELECT COUNT(*) INTO g_cnt FROM agd_file
               WHERE agd02 = l_newsz
              IF g_cnt <= 0 THEN 
                 CALL cl_err('','ask-102',0)
                 DISPLAY BY NAME l_newsz
                 NEXT FIELD sle03
              ELSE
                 SELECT DISTINCT agd03 INTO l_agd03 FROM agd_file
                  WHERE agd01 = g_sla.sla01
                    AND agd02 = l_newsz
                DISPLAY l_agd03 TO agd03
             END IF
 
        END IF
    
 
 
      AFTER INPUT
         SELECT count(*) INTO g_cnt FROM sle_file
           WHERE sle01 = l_newno
             AND sle02 = l_newit
             AND sle03 = l_newsz
 
         IF g_cnt > 0 THEN
            CALL cl_err(l_newno,-239,0)
            NEXT FIELD sle01
         END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help() 
 
      ON ACTION controlg    
         CALL cl_cmdask()    
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(sle01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pbi"
               LET g_qryparam.default1 = l_newno
               CALL cl_create_qry() RETURNING l_newno
               DISPLAY l_newno TO sle01
               NEXT FIELD sle01
              WHEN INFIELD(sle02)
#FUN-AA0059---------mod------------str-----------------
 #            CALL cl_init_qry_var()      
 #            LET g_qryparam.form = "q_ima_slk"   
 #            LET g_qryparam.default1 = l_newit              
 #            CALL cl_create_qry() RETURNING l_newit
              CALL q_sel_ima(FALSE, "q_ima_slk","",l_newit,"","","","","",'' ) 
                   RETURNING l_newit  
#FUN-AA0059---------mod------------end----------------- 
             DISPLAY l_newit TO sle02
              NEXT FIELD sle02
            WHEN INFIELD(sle03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_agd1"    
               LET g_qryparam.arg1 = g_sla.sla01
               LET g_qryparam.construct = "N"
               CALL cl_create_qry() RETURNING l_newsz
               DISPLAY l_newsz TO sle03  
               NEXT FIELD sle03 
            WHEN INFIELD(sle06)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_agd"   
    
              LET g_qryparam.default1 = l_newys 
              CALL cl_create_qry() RETURNING l_newys 
              DISPLAY l_newys TO sle06
         END CASE
    END INPUT
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
         WHERE ima01 = g_sle.sle02
       DISPLAY l_ima02 TO ima02
       DISPLAY l_ima021 TO ima021
       SELECT DISTINCT inbf04 INTO l_agd03 FROM inbf_file   
        WHERE inbf00 = '1'
          AND inbf03 = g_sle.sle03
       DISPLAY l_agd03 TO agd03
       DISPLAY BY NAME g_sle.sle01
       DISPLAY BY NAME g_sle.sle02
       DISPLAY BY NAME g_sle.sle03
#      DISPLAY BY NAME g_sle.sle06 
       RETURN
    END IF
 
    LET l_sle.* = g_sle.*
    LET l_sle.sle01  =l_newno   #新的鍵值
    LET l_sle.sle02  =l_newit
    LET l_sle.sle03  =l_newsz
#   LET l_sle.sle06  =l_newys
    LET l_sle.sle06  =' '
    LET l_sle.sleuser=g_user    #資料所有者
    LET l_sle.slegrup=g_grup    #資料所有者所屬群
    LET l_sle.slemodu=NULL      #資料修改日期
    LET l_sle.sledate=g_today   #資料建立日期
    LET l_sle.sleconf=NULL       #有效資料
    BEGIN WORK
    LET l_sle.sleoriu = g_user      #No.FUN-980030 10/01/04
    LET l_sle.sleorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO sle_file VALUES (l_sle.*)
    IF SQLCA.sqlcode THEN
        CALL cl_err('sle:',SQLCA.sqlcode,0)
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM slf_file         #單身復制
        WHERE slf01=g_sle.sle01
          AND slf02=g_sle.sle02
          AND slf03=g_sle.sle03
#         AND slf19=g_sle.sle06
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sle.sle01,SQLCA.sqlcode,0)
        RETURN
    END IF
    UPDATE x
        SET   slf01=l_newno,
              slf02=l_newit,
              slf03=l_newsz
#             slf19=l_newys
    INSERT INTO slf_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err('slf:',SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    COMMIT WORK
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
        
     LET l_oldno = g_sle.sle01
     LET l_oldit = g_sle.sle02
     LET l_oldsz = g_sle.sle03
 
     SELECT sle_file.* INTO g_sle.* 
       FROM sle_file 
      WHERE sle01 = l_newno AND sle02 = l_newit 
        AND sle03 = l_newsz 
 
     CALL t003_u()
     CALL t003_b()
     #FUN-C80046---begin
     #SELECT sle_file.* INTO g_sle.* 
     #  FROM sle_file 
     # WHERE sle01 = l_oldno AND sle02 = l_oldit 
     #   AND sle03 = l_oldsz 
     #CALL t003_show()
     #FUN-C80046---end
END FUNCTION
 
 
#FUNCTION t003_out()
#DEFINE
#    l_i             LIKE type_file.num5,
#    sr              RECORD
#         sle01      LIKE sle_file.sle01,
#         sle02      LIKE sle_file.sle02,
#         ima02      LIKE ima_file.ima02,
#         ima021     LIKE ima_file.ima021,
#         sle03      LIKE sle_file.sle03,
#         sle04      LIKE sle_file.sle04,
#         sle05      LIKE sle_file.sle05,
#         sle06      LIKE sle_file.sle06,
#         sle07      LIKE sle_file.sle07,
#         sle08      LIKE sle_file.sle08,
#         sle09      LIKE sle_file.sle09,
#         slf04      LIKE slf_file.slf04,
#         slf05      LIKE slf_file.slf05,
#         slf06      LIKE slf_file.slf06, 
#         bol02      LIKE bol_file.bol02,
#         slf07      LIKE slf_file.slf07,
#         slf08      LIKE slf_file.slf08,
#         slb02     LIKE slb_file.slb02,
#         slf09      LIKE slf_file.slf09,
#         slf10      LIKE slf_file.slf10,
#         slf11      LIKE slf_file.slf11,
#         slf12      LIKE slf_file.slf12,
#         slf13      LIKE slf_file.slf13,
#         slf14      LIKE slf_file.slf14,
#         slf15      LIKE slf_file.slf15,
#         slf16      LIKE slf_file.slf16,
#         slf17      LIKE slf_file.slf17,
#         slf18      LIKE slf_file.slf18
#                    END RECORD,
#        l_name      LIKE type_file.chr20     #External(Disk) file name
#    
#    FOR l_i= 1 TO 500 LET g_dash2[l_i,l_i] = '-' END FOR
#
#    IF cl_null(g_wc) THEN 
#       	LET g_wc=" sle01='",g_sle.sle01,"' AND ",
#                 " sle02='",g_sle.sle02,"' AND ",
#                 " sle03='",g_sle.sle03,"' AND ",
#                 " sle06='",g_sle.sle06,"'"
#    END IF	
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    LET g_sql="SELECT sle01,sle02,'','',sle03,sle04,",
#              "       sle05,sle06,sle07,sle08,sle09,",
#              "       slf04,slf05,slf06,'',slf07,",
#              "       slf08,'',slf09,slf10,slf11,",
#              "       slf12,slf13,slf14,slf15,slf16,",
#              "       slf17,slf18 ",
#              " FROM sle_file,slf_file ",
#              " WHERE sle01 = slf01 AND sle02 = slf02",
#              "   AND sle03 = slf03 AND sle06 = slf19",
#              "   AND ",g_wc CLIPPED
#              #"   AND ",g_wc2 CLIPPED
#    PREPARE t003_p1 FROM g_sql                # RUNTIME 編譯
#    DECLARE t003_co                         # SCROLL CURSOR
#         CURSOR FOR t003_p1
#
#    CALL cl_outnam('askt003') RETURNING l_name
#    START REPORT t003_rep TO l_name
#
#    FOREACH t003_co INTO sr.*
#        IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#        END IF
#        SELECT ima02,ima021 INTO sr.ima02,sr.ima021 FROM ima_file 
#         WHERE ima01 = sr.sle02
#        SELECT bol02 INTO sr.bol02 FROM bol_file
#         WHERE bol01 = sr.slf06
#        SELECT slb02 INTO sr.slb02 FROM slb_file
#         WHERE slb01 = sr.slf07      
#        OUTPUT TO REPORT t003_rep(sr.*)
#    END FOREACH
#
#    FINISH REPORT t003_rep
#
#    CLOSE t003_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#END FUNCTION
#
#REPORT t003_rep(sr)
#DEFINE
#    l_trailer_sw    LIKE type_file.chr1,
#    l_sw            LIKE type_file.chr1,
#    l_i             LIKE type_file.num5,
#    l_desc1         LIKE type_file.chr50,
#    l_desc2         LIKE type_file.chr50,
#    l_agd03         LIKE agd_file.agd03,
#    l_msg           LIKE type_file.chr4,
#    sr              RECORD
#         sle01      LIKE sle_file.sle01,
#         sle02      LIKE sle_file.sle02,
#         ima02      LIKE ima_file.ima02,
#         ima021     LIKE ima_file.ima021,
#         sle03      LIKE sle_file.sle03,
#         sle04      LIKE sle_file.sle04,
#         sle05      LIKE sle_file.sle05,
#         sle06      LIKE sle_file.sle06,
#         sle07      LIKE sle_file.sle07,
#         sle08      LIKE sle_file.sle08,
#         sle09      LIKE sle_file.sle09,
#         slf04      LIKE slf_file.slf04,
#         slf05      LIKE slf_file.slf05,
#         slf06      LIKE slf_file.slf06,
#         bol02      LIKE bol_file.bol02,
#         slf07      LIKE slf_file.slf07,
#         slf08      LIKE slf_file.slf08,
#         slb02      LIKE slb_file.slb02,
#         slf09      LIKE slf_file.slf09,
#         slf10      LIKE slf_file.slf10,
#         slf11      LIKE slf_file.slf11,
#         slf12      LIKE slf_file.slf12,
#         slf13      LIKE slf_file.slf13,
#         slf14      LIKE slf_file.slf14,
#         slf15      LIKE slf_file.slf15,
#         slf16      LIKE slf_file.slf16,
#         slf17      LIKE slf_file.slf17,
#         slf18      LIKE slf_file.slf18
#                    END RECORD 
#   OUTPUT
#       TOP MARGIN 0
#       LEFT MARGIN 0
#       BOTTOM MARGIN 6
#       PAGE LENGTH g_page_line  
#
#    ORDER BY sr.sle01
#    FORMAT
#        PAGE HEADER
#            SELECT DISTINCT inbf04 INTO l_agd03 FROM inbf_file
#              WHERE inbf00 = '1'
#                AND inbf03 = sr.sle03
#            PRINT COLUMN ((g_len-length(g_company))/2)+1,g_company
#            PRINT COLUMN ((g_len-length(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#
#            PRINT "  "
#            PRINT "  "
#            PRINT COLUMN 01,g_x[9] CLIPPED,sr.sle01,
#                  COLUMN 60,g_x[10] CLIPPED,sr.sle04
#            PRINT COLUMN 01,g_x[11] CLIPPED,sr.sle02,
#                  COLUMN 60,g_x[18] CLIPPED,l_agd03
#            PRINT COLUMN 01,g_x[12] CLIPPED,sr.ima02,
#                  COLUMN 60,g_x[13] CLIPPED,sr.sle05
#            PRINT COLUMN 01,g_x[19] CLIPPED,sr.ima021
#            PRINT COLUMN 01,g_x[14] CLIPPED,sr.sle08,
#                  COLUMN 60,g_x[15] CLIPPED,sr.sle09
#            PRINT COLUMN 01,g_x[16] CLIPPED,sr.sle06,
#                  COLUMN 60,g_x[17] CLIPPED,sr.sle07
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,
#                  g_x[46] CLIPPED,g_x[34] CLIPPED,g_x[47] CLIPPED,
#                  g_x[36] CLIPPED,g_x[35] CLIPPED,
#                  g_x[37] CLIPPED,g_x[38] CLIPPED,g_x[39] CLIPPED,
#                  g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED,
#                  g_x[43] CLIPPED,g_x[44] CLIPPED,g_x[45] CLIPPED
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#
#        BEFORE GROUP OF sr.sle01
#            SKIP TO TOP OF PAGE
#        BEFORE GROUP OF sr.sle02
#           SKIP TO TOP OF PAGE
#        BEFORE GROUP OF sr.sle03
#           SKIP TO TOP OF PAGE
#        BEFORE GROUP OF sr.sle06
#           SKIP TO TOP OF PAGE
# 
#        ON EVERY ROW
#           IF sr.slf08 = '1' THEN
#              LET l_msg = '橫'
#           ELSE
#              LET l_msg = '直'
#           END IF
#           PRINT COLUMN g_c[31],sr.slf04 USING '###',
#                 COLUMN g_c[32],sr.slf05,
#                 COLUMN g_c[33],sr.slf06,
#                 COLUMN g_c[46],sr.bol02,
#                 COLUMN g_c[34],sr.slf07,
#                 COLUMN g_c[47],sr.slb02,
#                 COLUMN g_c[36],l_msg,
#                 COLUMN g_c[35],sr.slf09,
#                 COLUMN g_c[37],cl_numfor(sr.slf10,12,3),
#                 COLUMN g_c[38],sr.slf11,
#                 COLUMN g_c[39],sr.slf12,
#                 COLUMN g_c[40],sr.slf13,
#                 COLUMN g_c[41],sr.slf14,
#                 COLUMN g_c[42],sr.slf15,
#                 COLUMN g_c[43],sr.slf16,
#                 COLUMN g_c[44],sr.slf17,
#                 COLUMN g_c[45],sr.slf18
#            PRINT g_dash2[1,g_len]
#
#       ON LAST ROW
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),
#                 g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
#
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),
#                     g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
 
FUNCTION t003_y()
   DEFINE g_i   LIKE type_file.num5,
          l_cnt LIKE type_file.num5
 
   IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
#CHI-C30107 ---------------- add ---------------- begin
   IF g_sle.sle01 IS NULL THEN
      CALL cl_err('','arm-019',0) RETURN
   END IF
   IF g_sle.sleconf ='X' THEN RETURN END IF  #CHI-C80041
   IF g_sle.sleconf = 'Y' THEN
      CALL cl_err('',9023,0)
      RETURN
   END IF
   IF NOT cl_confirm('aap-222') THEN RETURN END IF
#CHI-C30107 ---------------- add ---------------- end
   SELECT * INTO g_sle.* FROM sle_file WHERE sle01 = g_sle.sle01 AND sle02 = g_sle.sle02 AND sle03 = g_sle.sle03
   IF g_sle.sle01 IS NULL THEN 
      CALL cl_err('','arm-019',0) RETURN 
   END IF
   #No.MOD-910137 add --begin
   IF g_sle.sleconf ='X' THEN RETURN END IF  #CHI-C80041
   IF g_sle.sleconf = 'Y' THEN
      CALL cl_err('',9023,0)
      RETURN
   END IF
   #No.MOD-910137 add --end
 
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM slf_file
    WHERE slf01=g_sle.sle01
      AND slf02=g_sle.sle02
      AND slf03=g_sle.sle03
   IF l_cnt<=0 THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
 
#  IF NOT cl_confirm('aap-222') THEN RETURN END IF #CHI-C30107 mark
   BEGIN WORK
 
   OPEN t003_cl USING g_sle.sle01,g_sle.sle02,g_sle.sle03
   IF STATUS THEN
      CALL cl_err("OPEN t003_cl:", STATUS, 1)
      CLOSE t003_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t003_cl INTO g_sle.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_sle.sle01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t003_cl ROLLBACK WORK RETURN
   END IF
 
   LET g_success = 'Y'
     UPDATE sle_file SET sleconf = 'Y',
                         slemodu=g_user,
                         sledate=g_today
          WHERE sle01 = g_sle.sle01
            AND sle02 = g_sle.sle02
            AND sle03 = g_sle.sle03
     IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err('confirm',9050,1) LET g_success = 'N' RETURN
     END IF
     IF g_success='Y' THEN
        LET g_sle.sleconf='Y'
        LET g_sle.slemodu=g_user
        LET g_sle.sledate=g_today
        COMMIT WORK
     ELSE
        ROLLBACK WORK
     END IF
     DISPLAY BY NAME g_sle.sleconf,g_sle.slemodu,
                     g_sle.sledate
     MESSAGE ''
     CALL cl_set_field_pic(g_sle.sleconf,"","","","","")
END FUNCTION
 
FUNCTION t003_z()
     DEFINE g_i   LIKE type_file.num5,
            l_cnt LIKE type_file.num5
 
     IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
     SELECT * INTO g_sle.* FROM sle_file WHERE sle01 = g_sle.sle01 AND sle02 = g_sle.sle02 AND sle03 = g_sle.sle03
     IF g_sle.sle01 IS NULL THEN
        CALL cl_err('','arm-019',0)
        RETURN
     END IF
     #No.MOD-910137 add --begin
     IF g_sle.sleconf ='X' THEN RETURN END IF  #CHI-C80041
     IF g_sle.sleconf = 'N' THEN
         CALL cl_err('',9025,0)
         RETURN
     END IF
     #No.MOD-910137 add --end
     LET l_cnt = 0
     SELECT count(*) INTO l_cnt FROM slf_file
      WHERE slf01=g_sle.sle01
        AND slf02=g_sle.sle02
        AND slf03=g_sle.sle03
 
     IF l_cnt <=0 THEN
        CALL cl_err(' ','mfg-009',0)  RETURN 
     END IF
      
     IF cl_confirm('ask-036') THEN   
      
     BEGIN WORK
 
     OPEN t003_cl USING g_sle.sle01,g_sle.sle02,g_sle.sle03
     IF STATUS THEN
        CALL cl_err("OPEN t003_cl:", STATUS, 1)
        CLOSE t003_cl
        ROLLBACK WORK
        RETURN
     END IF
     FETCH t003_cl INTO g_sle.*          # 鎖住將被更改或取消的資料
     IF SQLCA.sqlcode THEN
        CALL cl_err(g_sle.sle01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t003_cl ROLLBACK WORK RETURN
     END IF
 
     LET g_success = 'Y'
     UPDATE sle_file SET sleconf = 'N',
                         slemodu = g_user,
                         sledate = g_today
          WHERE sle01 = g_sle.sle01
            AND sle02 = g_sle.sle02
            AND sle03 = g_sle.sle03
 
     IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err('',9050,1) LET g_success = 'N' RETURN
     END IF
     IF g_success = 'Y' THEN
        LET g_sle.sleconf='N'
        LET g_sle.slemodu=g_user
        LET g_sle.sledate=g_today
        COMMIT WORK
     ELSE
        ROLLBACK WORK
     END IF
     DISPLAY BY NAME g_sle.sleconf,
                     g_sle.slemodu,
                     g_sle.sledate
     MESSAGE ''
     END IF 
     CALL cl_set_field_pic(g_sle.sleconf,"","","","","")
END FUNCTION
 
FUNCTION t003_cl_d_s(p_dec)
DEFINE
     p_dec    LIKE type_file.num20_6, #DECIMAL(17,5), #傳入小數
     l_ele    LIKE type_file.num10,              #分子
     l_den    LIKE type_file.num10,              #分母
     l_ret1,l_ret2,l_ret3    LIKE type_file.num10,
     l_k1     LIKE type_file.num10,
     l_k2     LIKE type_file.num10,
     i,l      LIKE type_file.num5,
     l_kkk    LIKE type_file.chr100 
 
     IF p_dec = 0 THEN
        LET l_kkk = 0
     END IF
     LET l_ele = p_dec * 100000
     LET l_den = 100000
     LET l_ret1 = l_den
     LET l_ret2 = l_ele
     
     IF l_ele > l_den THEN
        LET l_ret3 = l_den
        WHILE (l_ele MOD l_den) <> 0 
           LET l_ret3 = l_den
           LET l_den = l_ele MOD l_den                              
           LET l_ele=l_ret3
           LET l_ret3 = l_den
        END WHILE
     ELSE
        LET l_ret3 = l_ele
        WHILE (l_den MOD l_ele) <> 0
           LET l_ret3 = l_ele
            LET l_ele = l_den MOD l_ele                  
           LET l_den=l_ret3
           LET l_ret3 = l_ele
        END WHILE
     END IF   
 
     LET l_ele = l_ret2/l_ret3
     LET l_den = l_ret1/l_ret3
     LET l_k1 = 0
     IF l_ele > l_den THEN
        LET l_k1 = l_ele/l_den
        LET l_k2 = l_ele MOD l_den
     END IF
     
     
     IF l_k1 = 0 THEN   
        LET l_kkk = l_ele ,'/',l_den
        IF l_ele = '0' THEN LET l_kkk = '0' END IF
     ELSE
        LET l_kkk = l_k1,',',l_k2,'/',l_den
        IF l_k2 = '0' THEN LET l_kkk = l_k1 END IF
     END IF
     FOR i = 1 TO LENGTH(l_kkk)-1
         IF l_kkk[i,i] = ' ' THEN
            FOR l = i TO LENGTH(l_kkk)-1
                LET l_kkk[l,l] = l_kkk[l+1,l+1]
                LET l_kkk[l+1,l+1] = ' '
            END FOR
            LET i = 0
         END IF
     END FOR
     LET l_kkk = l_kkk CLIPPED
     RETURN l_kkk
END FUNCTION 
 
FUNCTION t003_cl_s_d(p_sco)
DEFINE p_sco  LIKE type_file.chr10,   #FUN-8A0145   
       l_d1   LIKE type_file.chr10,   
       l_d2   LIKE type_file.chr10,   
       l_d3   LIKE type_file.chr10,   
       l_s1   LIKE type_file.num10,       
       l_s2   LIKE type_file.num10,
       l_s3   LIKE type_file.num10,
       l_c1   LIKE type_file.num20_6, #DECIMAL(17,5),   
       l_c2   LIKE type_file.num20_6, #DECIMAL(17,5),
       l_c3   LIKE type_file.num20_6, #DECIMAL(17,5),
       l_kkk  LIKE type_file.num20_6, #DECIMAL(17,5),
       i,l,k  LIKE type_file.num5,
       l_i    LIKE type_file.chr1,        
       l_kk   LIKE type_file.num20_6, #DECIMAL(17,5),
       l_str  STRING
DEFINE l_flag LIKE type_file.num5
 
   LET l_flag = 1
   IF p_sco[1,1] = '-' THEN
   	LET p_sco = p_sco[2,length(p_sco)]
   	LET l_flag = -1
   END IF
   IF p_sco[1,1] = '+' THEN
   	LET p_sco = p_sco[2,length(p_sco)]
   END IF
   
   LET l_i = 'Y'
   LET l_kk = p_sco
   
   LET l_str = p_sco
   IF l_str.getIndexOf(",",1) > 0 THEN
		IF l_str.getIndexOf("/",1) <= 0 THEN 
			LET l_i = 'N'
         CALL cl_err(p_sco,'ask-107',1)
         RETURN l_kkk,l_i
		END IF
	ELSE
		IF l_str.getIndexOf("/",1) > 0 THEN 
			LET p_sco = '0,',p_sco
		END IF
	END IF
		
   IF l_kk IS NOT NULL THEN
      RETURN l_kk,l_i
   END IF
	
   LET k = 1
   FOR i = 1 TO LENGTH(p_sco)
       IF p_sco[i,i] != '1' AND p_sco[i,i] !='2' AND p_sco[i,i] !='3'
           AND p_sco[i,i] !='4' AND p_sco[i,i] != '5' AND p_sco[i,i] !='6'
           AND p_sco[i,i] !='7' AND p_sco[i,i] !='8' AND p_sco[i,i] !='9'
           AND p_sco[i,i] !='0' AND p_sco[i,i] !=',' AND p_sco[i,i] !='/'
       THEN 
          LET l_i = 'N'
          CALL cl_err(p_sco,'ask-107',1)
          RETURN l_kkk,l_i
       END IF
       IF p_sco[i,i] = ',' THEN
          LET k = 2
          CONTINUE FOR
       ELSE
          IF p_sco[i,i] = '/' THEN
             LET k = 3
             CONTINUE FOR
          END IF
       END IF 
       CASE
         WHEN k = 1    
              LET l_d1 = l_d1,p_sco[i,i]
         WHEN k = 2
              LET l_d2 = l_d2,p_sco[i,i]
         WHEN k = 3
              LET l_d3 = l_d3,p_sco[i,i]
       END CASE      
   END FOR
   LET l_s1 = l_d1
   LET l_s2 = l_d2 
   LET l_s3 = l_d3
   LET l_c1 = l_d1
   LET l_c2 = l_d2
   LET l_c3 = l_d3
   IF cl_null(l_s1) THEN LET l_s1 = 0 END IF
   IF cl_null(l_s2) THEN LET l_s2 = 0 END IF
   IF cl_null(l_s3) THEN LET l_s3 = 0 END IF
   IF cl_null(l_c1) THEN LET l_c1 = 0 END IF
   IF cl_null(l_c2) THEN LET l_c2 = 0 END IF
   IF cl_null(l_c3) THEN LET l_c3 = 0 END IF
   IF l_s1 <> l_c1 OR l_s2 <> l_c2 OR l_s3 <> l_c3 OR l_s3 = 0 THEN
      LET l_i = 'N'
      CALL cl_err(p_sco,'ask-107',1)
      RETURN l_kkk,l_i
   END IF
   IF l_s2 = 0 THEN
      LET l_kkk = l_s1
   ELSE
      LET l_kkk = l_s1+(l_s2/l_s3)
   END IF
   IF cl_null(l_kkk) THEN
      CALL cl_err(p_sco,'ask-107',1)
      LET l_i = 'N'
   END IF
   LET l_kkk = l_kkk * l_flag
   RETURN l_kkk,l_i
END FUNCTION
 
#No.FUN-870117
#CHI-C80041---begin
#FUNCTION t003_v()               #CHI-D20010
FUNCTION t003_v(p_type)          #CHI-D20010
   DEFINE l_chr LIKE type_file.chr1  
   DEFINE p_type    LIKE type_file.chr1  #CHI-D20010
   DEFINE l_flag    LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_sle.sle01) OR cl_null(g_sle.sle02) OR cl_null(g_sle.sle03) THEN CALL cl_err('',-400,0) RETURN END IF  

   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_sle.sleconf='X' THEN RETURN END IF
   ELSE
      IF g_sle.sleconf<>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t003_cl USING g_sle.sle01,g_sle.sle02,g_sle.sle03
   IF STATUS THEN
      CALL cl_err("OPEN t003_cl:", STATUS, 1)
      CLOSE t003_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t003_cl INTO g_sle.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_sle.sle01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t003_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_sle.sleconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
  #IF cl_void(0,0,g_sle.sleconf)   THEN                                #CHI-D20010
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF    #CHI-D20010
   IF cl_void(0,0,l_flag) THEN                                         #CHI-D20010
        LET l_chr=g_sle.sleconf
       #IF g_sle.sleconf='N' THEN                                      #CHI-D20010
        IF p_type = 1 THEN                                             #CHI-D20010
            LET g_sle.sleconf='X' 
        ELSE
            LET g_sle.sleconf='N'
        END IF
        UPDATE sle_file
            SET sleconf=g_sle.sleconf,  
                slemodu=g_user,
                sledate=g_today
            WHERE sle01=g_sle.sle01
              AND sle02=g_sle.sle02
              AND sle03=g_sle.sle03
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","sle_file",g_sle.sle01,"",SQLCA.sqlcode,"","",1)  
            LET g_sle.sleconf=l_chr 
        END IF
        DISPLAY BY NAME g_sle.sleconf
   END IF
 
   CLOSE t003_cl
   COMMIT WORK
   CALL cl_flow_notify(g_sle.sle01,'V')
 
END FUNCTION
#CHI-C80041---end
