# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: apmt940.4gl
# Descriptions...: 成本交期品質價分數統計
# Date & Author..: FUN-720041 07/03/13 by Yitng
# Modify.........: No.TQC-750068 07/05/14 By Sarah 程式並沒有copy()段，但是bp()卻有定義reproduce,導致按下複雜後沒反應
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AC0051 10/12/17 By houlia 增加單身筆數顯示/g_rec_b
# Modify.........: No.MOD-BB0207 11/11/21 By Vampire 單頭及單身不可輸入，僅可維護，INPUT ARRAY的地方拿掉新增、刪除權限
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_ppe01         LIKE ppe_file.ppe01,      #流程代碼 (假單頭)  #FUN-720041
    g_ppe02         LIKE ppe_file.ppe02,      #生效日期 (假單頭)
    g_ppe01_t       LIKE ppe_file.ppe01,      #流程代碼   (舊值)
    g_ppe02_t       LIKE ppe_file.ppe02,      #生效日期   (舊值)
    l_cnt           LIKE type_file.num5,      #No.FUN-680136 SMALLINT
    l_cnt1          LIKE type_file.num5,      #No.FUN-680136 SMALLINT
    l_cmd           LIKE type_file.chr1000,   #No.FUN-680136 VARCHAR(100)
    g_ppe           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                    ppe03   LIKE ppe_file.ppe03,
                    ppa03   LIKE ppa_file.ppa03,
                    ppe04   LIKE ppe_file.ppe04,
                    ppe05   LIKE ppe_file.ppe05,
                    ppe06   LIKE ppe_file.ppe06,
                    ppe07   LIKE ppe_file.ppe07
                    END RECORD,
    g_ppe_t         RECORD                    #程式變數 (舊值)
                    ppe03   LIKE ppe_file.ppe03,
                    ppa03   LIKE ppa_file.ppa03,
                    ppe04   LIKE ppe_file.ppe04,
                    ppe05   LIKE ppe_file.ppe05,
                    ppe06   LIKE ppe_file.ppe06,
                    ppe07   LIKE ppe_file.ppe07
                    END RECORD,
    g_wc,g_sql    string,  #No.FUN-580092 HCN
    g_delete        LIKE type_file.chr1,   #若刪除資料,則要重新顯示筆數  #No.FUN-680136
    g_rec_b         LIKE type_file.num5,   #單身筆數        #No.FUN-680136 SMALLINT
    l_za05          LIKE type_file.chr1000,#No.FUN-680136 VARCHAR(40)
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_sl            LIKE type_file.num5    #No.FUN-680136 SMALLINT #目前處理的ARRAY CNT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp    STRING   #No.TQC-720019
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680136 SMALLINT
DEFINE   g_cnt            LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_i              LIKE type_file.num5          #count/index for any purpose    #No.FUN-680136 SMALLINT
DEFINE   g_msg            LIKE ze_file.ze03            #No.FUN-680136 VARCHAR(72)
DEFINE   g_row_count      LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_curs_index     LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_jump           LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_no_ask        LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_ppe01   = NULL                   #清除鍵值
   LET g_ppe02   = NULL                   #清除鍵值
   LET g_ppe01_t = NULL
   LET g_ppe02_t = NULL

   OPEN WINDOW t940_w WITH FORM "apm/42f/apmt940"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
       
   LET g_delete='N'
   CALL t940_menu()
   CLOSE WINDOW t940_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t940_cs()
 
   CLEAR FORM                             #清除畫面
   CALL g_ppe.clear()
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032 
   INITIALIZE g_ppe01 TO NULL    #No.FUN-750051
   INITIALIZE g_ppe02 TO NULL    #No.FUN-750051
   CONSTRUCT g_wc ON ppe01,ppe02,ppe03,ppe04,ppe05,ppe06,ppe07    #螢幕上取條件
           FROM ppe01,ppe02,s_ppe[1].ppe03,
                s_ppe[1].ppe04,
                s_ppe[1].ppe05,s_ppe[1].ppe06,
                s_ppe[1].ppe07
 
       #--No.MOD-4A0248--------
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON ACTION CONTROLP
         CASE WHEN INFIELD(ppe02)  
                   CALL cl_init_qry_var()
                   LET g_qryparam.state= "c"
                   LET g_qryparam.form = "q_pmc"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ppe02
                   NEXT FIELD ppe02
               WHEN INFIELD(ppe03) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.state= "c"
                   LET g_qryparam.form = "q_ppa"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ppe03
                   NEXT FIELD ppe03
         OTHERWISE EXIT CASE
         END CASE
      #--END---------------     
 
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ppeuser', 'ppegrup') #FUN-980030
   IF INT_FLAG THEN RETURN END IF
 
   LET g_sql="SELECT UNIQUE ppe01,ppe02 ",
              " FROM ppe_file ", # 組合出 SQL 指令
              " WHERE ", g_wc CLIPPED,
              " ORDER BY ppe01,ppe02"
   PREPARE t940_prepare FROM g_sql      #預備一下
   DECLARE t940_bcs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR t940_prepare
 
   LET g_sql_tmp="SELECT UNIQUE ppe01,ppe02",  #No.TQC-720019
             "  FROM ppe_file WHERE ", g_wc CLIPPED,
             " GROUP BY ppe01,ppe02 ",
             " INTO TEMP x"
   DROP TABLE x
   PREPARE t940_precount_x FROM g_sql_tmp  #No.TQC-720019
   EXECUTE t940_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x"
   PREPARE t940_precount FROM g_sql
   DECLARE t940_count CURSOR FOR t940_precount
 
END FUNCTION
 
FUNCTION t940_menu()
   WHILE TRUE
      CALL t940_bp("G")
      CASE g_action_choice
           WHEN "query" 
            IF cl_chk_act_auth() THEN
                CALL t940_q()
            END IF
           WHEN "detail" 
            IF cl_chk_act_auth() THEN 
                CALL t940_b()
            ELSE
               LET g_action_choice = NULL
            END IF
           WHEN "next" 
            CALL t940_fetch('N')
           WHEN "previous" 
            CALL t940_fetch('P')
           WHEN "help" 
            CALL cl_show_help()
           WHEN "exit"
            EXIT WHILE
           WHEN "jump"
            CALL t940_fetch('/')
           WHEN "controlg"     
            CALL cl_cmdask()
            WHEN "related_document"  #No.MOD-470518
            IF cl_chk_act_auth() THEN
               IF g_ppe01 IS NOT NULL THEN
                  LET g_doc.column1 = "ppe01"
                  LET g_doc.column2 = "ppe02"
                  LET g_doc.value1 = g_ppe01
                  LET g_doc.value2 = g_ppe02
                  CALL cl_doc()
               END IF
            END IF
           WHEN "exporttoexcel"   #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ppe),'','') 
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t940_a()
 
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   MESSAGE ""
   CLEAR FORM
   CALL g_ppe.clear()
   INITIALIZE g_ppe01 LIKE ppe_file.ppe01
   INITIALIZE g_ppe02 LIKE ppe_file.ppe02
   LET g_wc=NULL
   LET g_ppe01_t = NULL
   LET g_ppe02_t = NULL
   #預設值及將數值類變數清成零
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL t940_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0
      CALL t940_b()                      #輸入單身
      LET g_ppe01_t = g_ppe01            #保留舊值
      LET g_ppe02_t = g_ppe02            #保留舊值
      EXIT WHILE
   END WHILE
 
END FUNCTION
   
#處理INPUT
FUNCTION t940_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1                 #a:輸入 u:更改        #No.FUN-680136 VARCHAR(1)
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
    INPUT g_ppe01,g_ppe02  WITHOUT DEFAULTS 
           FROM ppe01,ppe02 
 
        ON ACTION CONTROLP                  
           CASE
              WHEN INFIELD(ppe02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pmc" 
                 LET g_qryparam.default1 = g_ppe02
                 CALL cl_create_qry() RETURNING g_ppe02
                 DISPLAY BY NAME g_ppe02
                 NEXT FIELD ppe02
              OTHERWISE         
           END CASE
 
        #TQC-860019-add
        ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
        #TQC-860019-add
   
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
    END INPUT
END FUNCTION
 
FUNCTION t940_q()
 
  DEFINE l_ppe01  LIKE ppe_file.ppe01,
         l_ppe02  LIKE ppe_file.ppe02,
         l_ppe03  LIKE ppe_file.ppe03,
         l_curr   LIKE ppe_file.ppe02,
         l_cnt    LIKE type_file.num10           #No.FUN-680136 INTEGER
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ppe01 TO NULL               #No.FUN-6A0162  
    INITIALIZE g_ppe02 TO NULL               #No.FUN-6A0162
   CALL cl_opmsg('q')
   MESSAGE ""
   CALL t940_cs()                            #取得查詢條件
   IF INT_FLAG THEN                          #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_ppe01 TO NULL
      INITIALIZE g_ppe02 TO NULL
      RETURN
   END IF
   OPEN t940_bcs                    #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                         #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_ppe01 TO NULL
      INITIALIZE g_ppe02 TO NULL
   ELSE
      OPEN t940_count
      FETCH t940_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t940_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
FUNCTION t940_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680136 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     t940_bcs INTO g_ppe01,g_ppe02
        WHEN 'P' FETCH PREVIOUS t940_bcs INTO g_ppe01,g_ppe02
        WHEN 'F' FETCH FIRST    t940_bcs INTO g_ppe01,g_ppe02
        WHEN 'L' FETCH LAST     t940_bcs INTO g_ppe01,g_ppe02
        WHEN '/' 
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
                
                END PROMPT
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump t940_bcs INTO g_ppe01,g_ppe02
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_ppe01,SQLCA.sqlcode,0)
       INITIALIZE g_ppe01 TO NULL 
       INITIALIZE g_ppe02 TO NULL 
    ELSE
       OPEN t940_count
       FETCH t940_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
       CALL t940_show()
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION
 
FUNCTION t940_show()
DEFINE    l_pmc03         LIKE pmc_file.pmc03    
 
    DISPLAY g_ppe01 TO ppe01  
    DISPLAY g_ppe02 TO ppe02 
    SELECT pmc03 INTO l_pmc03
      FROM pmc_file
     WHERE pmc01 = g_ppe02
    DISPLAY l_pmc03 TO pmc03
    CALL t940_b_fill(g_wc)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION t940_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680136 SMALLINT
    l_str           LIKE type_file.chr20,               #No.FUN-680136 VARCHAR(20)  
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680136 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680136 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_ppe01 IS NULL OR g_ppe02 IS NULL THEN
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT ppe03,'',ppe04,ppe05,ppe06,ppe07",
                       "  FROM ppe_file",
                       "  WHERE ppe01=? AND ppe02=? AND ppe03=?",
                       "   FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t940_bcl CURSOR FROM g_forupd_sql
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_ppe WITHOUT DEFAULTS FROM s_ppe.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    #INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=FALSE)   #MOD-BB0207 mark
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)                      #MOD-BB0207 add
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           IF g_rec_b >= l_ac THEN
              BEGIN WORK
              LET p_cmd='u'
              LET g_ppe_t.* = g_ppe[l_ac].*      #BACKUP
              OPEN t940_bcl USING g_ppe01,g_ppe02,g_ppe_t.ppe03
              FETCH t940_bcl INTO g_ppe[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_ppe_t.ppe05,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              ELSE
                 SELECT ppa03 INTO g_ppe[l_ac].ppa03
                   FROM ppa_file
                  WHERE ppa02 = g_ppe[l_ac].ppe03
              END IF
              LET g_ppe_t.* = g_ppe[l_ac].*      #BACKUP
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_ppe[l_ac].* TO NULL      #900423
           LET g_ppe_t.* = g_ppe[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD ppe03
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
 
           INSERT INTO ppe_file(ppe01,ppe02,ppe03,ppe04,ppe05,
                                ppe06,ppe07,ppeoriu,ppeorig)
           VALUES(g_ppe01,g_ppe02,g_ppe[l_ac].ppe03,
                  g_ppe[l_ac].ppe04,g_ppe[l_ac].ppe05,
                  g_ppe[l_ac].ppe06,g_ppe[l_ac].ppe07, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","ppe_file",g_ppe[l_ac].ppe03,"",
                            SQLCA.sqlcode,"","",1) 
              LET g_ppe[l_ac].* = g_ppe_t.*
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cnt1      #TQC-AC0051
              COMMIT WORK
           END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ppe[l_ac].* = g_ppe_t.*
              CLOSE t940_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ppe[l_ac].ppe05,-263,1)
              LET g_ppe[l_ac].* = g_ppe_t.*
           ELSE
              UPDATE ppe_file SET ppe07=g_ppe[l_ac].ppe07
               WHERE ppe01=g_ppe01
                 AND ppe02=g_ppe02  
                 AND ppe03=g_ppe_t.ppe03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","ppe_file",g_ppe[l_ac].ppe03,"",
                               SQLCA.sqlcode,"","",1)
                 LET g_ppe[l_ac].* = g_ppe_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN 
                 LET g_ppe[l_ac].* = g_ppe_t.*
              END IF 
              CLOSE t940_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE t940_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(ppe03) AND l_ac > 1 THEN
              LET g_ppe[l_ac].* = g_ppe[l_ac-1].*
              NEXT FIELD ppe03
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
    
    END INPUT
 
    CLOSE t940_bcl
        COMMIT WORK
 
END FUNCTION
 
FUNCTION t940_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
 
    LET g_sql = "SELECT ppe03,'',ppe04,ppe05,ppe06,ppe07 ",
                "  FROM ppe_file ",
                " WHERE ppe01 = '",g_ppe01,"' AND ppe02 = '",g_ppe02,"'",
                "   AND ",p_wc CLIPPED ,
                " ORDER BY 1"
    PREPARE t940_prepare2 FROM g_sql      #預備一下
    DECLARE ppe_cs CURSOR FOR t940_prepare2
 
    CALL g_ppe.clear()   #FUN-5A0157
    LET g_cnt = 1
    LET g_rec_b=0
 
    FOREACH ppe_cs INTO g_ppe[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT ppa03 INTO g_ppe[g_cnt].ppa03
         FROM ppa_file
        WHERE ppa02 = g_ppe[g_cnt].ppe03
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ppe.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1               #no.6277
    DISPLAY g_rec_b TO FORMONLY.cnt1      #TQC-AC0051
    LET g_cnt = 0
   
END FUNCTION
 
FUNCTION t940_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_ppe TO s_ppe.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET l_sl = SCR_LINE()
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first 
         CALL t940_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION previous
         CALL t940_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION jump 
         CALL t940_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION next
         CALL t940_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION last 
         CALL t940_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
     #str TQC-750068 mark
     #ON ACTION reproduce
     #   LET g_action_choice="reproduce"
     #   EXIT DISPLAY
     #end TQC-750068 mark
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
   
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
       ON ACTION related_document  #No.MOD-470518
         LET g_action_choice="related_document"
         EXIT DISPLAY
    
      ON ACTION exporttoexcel    #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY   #TQC-5B0076
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
        #TQC-860019-add
        ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
        #TQC-860019-add
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
