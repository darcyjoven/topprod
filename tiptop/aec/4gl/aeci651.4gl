# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: aeci651.4gl
# Descriptions...: 員工應投入工時維護作業
# Date & Author..: 99/05/20 By Sophia
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.FUN-4B0012 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.MOD-4C0087 04/12/15 By DAY   單身insert出錯
# Modify.........: No.FUN-510032 05/01/17 By pengu 報表轉XML
# Modify.........: No.FUN-660091 05/06/14 By hellen cl_err --> cl_err3
# Modify.........: No.FUN-680073 06/08/21 By hongmei欄位型態轉換
# Modify.........: No.FUN-6A0039 06/10/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790077 07/09/18 By Carrier 去掉bp()中on action modify
# Modify.........: No.FUN-7C0043 07/12/19 By lala   報表轉為使用p_query
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.FUN-890127 08/10/10 By Cockroach 報表轉CR
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_sge01         LIKE sge_file.sge01,   #工作時間表編號 (假單頭)
    g_sge01_t       LIKE sge_file.sge01,   #工作時間表編號 (舊值)
    g_sge           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        sge02       LIKE sge_file.sge02,   #員工代號
        gen02       LIKE gen_file.gen02,   #
        sge03       LIKE sge_file.sge03    #應投入工時
                    END RECORD,
    g_sge_t         RECORD                 #程式變數 (舊值)
        sge02       LIKE sge_file.sge02,   #員工代號
        gen02       LIKE gen_file.gen02,   #
        sge03       LIKE sge_file.sge03    #應投入工時
                    END RECORD,
   #g_wc,g_wc2,g_sql    VARCHAR(300),          #TQC-630166       
    g_wc,g_wc2,g_sql    STRING,             #TQC-630166       
    g_delete        LIKE type_file.chr1,    #No.FUN-680073    VARCHAR(01),
    l_sge02,l_sge03 LIKE type_file.num5,    # No.FUN-680073  SMALLINT
    g_rec_b         LIKE type_file.num5,    #單身筆數    #No.FUN-680073 SMALLINT
    g_ss            LIKE type_file.chr1,     #No.FUN-680073 VARCHAR(01)
    l_ac            LIKE type_file.num5      #目前處理的ARRAY CNT   #No.FUN-680073 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql         STRING   #SELECT ... FOR UPDATE SQL      
DEFINE g_before_input_done  LIKE type_file.num5     #No.FUN-680073 SMALLINT
DEFINE g_cnt                LIKE type_file.num10    #No.FUN-680073 INTEGER
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680073 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000      #No.FUN-680073 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE g_curs_index   LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE g_jump         LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE mi_no_ask      LIKE type_file.num5          #No.FUN-680073 SMALLINT
DEFINE g_head1        STRING
 
MAIN
DEFINE
    p_row,p_col     LIKE type_file.num5           #開窗的位置     #No.FUN-680073 SMALLINT SMALLINT
#       l_time    LIKE type_file.chr8              #No.FUN-6A0100
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
         RETURNING g_time    #No.FUN-6A0100
    LET p_row = ARG_VAL(1)                 #取得螢幕位置
    LET p_col = ARG_VAL(2)
 
    LET g_sge01 = NULL                     #清除鍵值
    LET g_sge01_t = NULL
 
    LET p_row = 3 LET p_col = 34
    OPEN WINDOW i651_w AT p_row,p_col   #顯示畫面
         WITH FORM "aec/42f/aeci651"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    LET g_delete='N'
 
    CALL i651_menu()
 
    CLOSE WINDOW i651_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
         RETURNING g_time    #No.FUN-6A0100
END MAIN
 
#QBE 查詢資料
FUNCTION i651_cs()
    CLEAR FORM                             #清除畫面
    CALL g_sge.clear()
 
CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
   INITIALIZE g_sge01 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON sge01,sge02,sge03    #螢幕上取條件
        FROM sge01,s_sge[1].sge02,s_sge[1].sge03
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
           IF INFIELD(sge02) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.state    = "c"
              LET g_qryparam.form = "q_gen"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO sge02
              NEXT FIELD sge02
           END IF
 
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
 
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND sgeuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND sgegrup MATCHES '",g_grup CLIPPED,"*'"
        #CHI-8A0001 寫ora
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND sgegrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('sgeuser', 'sgegrup')
    #End:FUN-980030
 
    LET g_sql="SELECT UNIQUE sge01 FROM sge_file ", # 組合出 SQL 指令
               " WHERE ", g_wc CLIPPED,
               " ORDER BY 1"
    PREPARE i651_prepare FROM g_sql      #預備一下
    DECLARE i651_b_cs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i651_prepare
    LET g_sql="SELECT COUNT(DISTINCT sge01) ",
                  " FROM sge_file WHERE ",g_wc CLIPPED
    PREPARE i651_precount FROM g_sql
    DECLARE i651_count CURSOR FOR i651_precount
END FUNCTION
 
FUNCTION i651_menu()
DEFINE l_cmd  LIKE type_file.chr1000         #No.FUN-7C0043
   WHILE TRUE
      CALL i651_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i651_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i651_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i651_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i651_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i651_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
         IF cl_chk_act_auth()                                                   
               THEN CALL i651_out()                                            
         END IF                                                                 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#FUN-4B0012
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sge),'','')
            END IF
##
        #No.FUN-6A0039-------add--------str----
        WHEN "related_document"  #相關文件
           IF cl_chk_act_auth() THEN
              IF g_sge01 IS NOT NULL THEN
                LET g_doc.column1 = "sge01"
                LET g_doc.value1 = g_sge01
                CALL cl_doc()
              END IF
          END IF
        #No.FUN-6A0039-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i651_a()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    MESSAGE ""
    CLEAR FORM
   CALL g_sge.clear()
    INITIALIZE g_sge01 LIKE sge_file.sge01
    LET g_sge01_t = NULL
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i651_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        CALL g_sge.clear()
        LET g_rec_b = 0
 
        CALL i651_b()                   #輸入單身
        LET g_sge01_t = g_sge01            #保留舊值
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
 
FUNCTION i651_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_sge01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_sge01_t = g_sge01
    BEGIN WORK
    WHILE TRUE
        CALL i651_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_sge01=g_sge01_t
            DISPLAY g_sge01 TO sge01               #單頭
 
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_sge01 != g_sge01_t THEN             #更改單頭值
            UPDATE sge_file SET sge01 = g_sge01  #更新DB
             WHERE sge01 = g_sge01_t          #COLAUTH?
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_sge01,SQLCA.sqlcode,0) #No.FUN-660091
               CALL cl_err3("upd","sge_file",g_sge01_t,"",SQLCA.sqlcode,"","",1) #FUN-660091
               CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
 
#處理INPUT
FUNCTION i651_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改        #No.FUN-680073 VARCHAR(1)
 
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
    LET g_ss='Y'
    INPUT g_sge01
        WITHOUT DEFAULTS
        FROM sge01
 
        BEFORE FIELD sge01    #判斷是否可更改KEY值
            IF p_cmd='u' AND g_chkey='N' THEN EXIT INPUT END IF
 
        AFTER FIELD sge01                  #工作時間表編號
            IF g_sge01 IS NULL THEN
                NEXT FIELD sge01
            END IF
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_sge01 != g_sge01_t) THEN
                SELECT count(*) INTO g_cnt FROM sge_file
                    WHERE sge01 = g_sge01
                IF g_cnt > 0 THEN   #資料重複
                    CALL cl_err(g_sge01,-239,0)
                    LET g_sge01 = g_sge01_t
                    DISPLAY  g_sge01 TO sge01
                    NEXT FIELD sge01
                END IF
            END IF
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        #-----TQC-860018---------
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controlg 
            CALL cl_cmdask()
        #-----END TQC-860018-----
    END INPUT
END FUNCTION
 
#Query 查詢
FUNCTION i651_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_sge01 TO NULL             #No.FUN-6A0039
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i651_cs()                         #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i651_b_cs                         #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                  #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_sge01 TO NULL
    ELSE
        CALL i651_fetch('F')               #讀出TEMP第一筆並顯示
        OPEN i651_count
        FETCH i651_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i651_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,       #處理方式     #No.FUN-680073 VARCHAR(1) VARCHAR(1)
    l_abso          LIKE type_file.num10       #絕對的筆數   #No.FUN-680073 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i651_b_cs INTO g_sge01
        WHEN 'P' FETCH PREVIOUS i651_b_cs INTO g_sge01
        WHEN 'F' FETCH FIRST    i651_b_cs INTO g_sge01
        WHEN 'L' FETCH LAST     i651_b_cs INTO g_sge01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
               END PROMPT
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump i651_b_cs INTO g_sge01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_sge01,SQLCA.sqlcode,0)
       INITIALIZE g_sge01 TO NULL  #TQC-6B0105
       RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    CALL i651_show()                       # 重新顯示
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i651_show()
    DISPLAY g_sge01 TO sge01                  #單頭
 
    CALL i651_b_fill(g_wc)                    #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i651_r()
    IF s_shut(0) THEN RETURN END IF           #檢查權限
    IF g_sge01 IS NULL THEN
       CALL cl_err("",-400,0)                 #No.FUN-6A0039
        RETURN
    END IF
    BEGIN WORK
    IF cl_delh(0,0) THEN                      #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "sge01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_sge01       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                   #No.FUN-9B0098 10/02/24
        DELETE FROM sge_file WHERE sge01 = g_sge01
        IF SQLCA.sqlcode THEN
#           CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0) #No.FUN-660091
            CALL cl_err3("del","sge_file",g_sge01,"",SQLCA.sqlcode,"","BODY DELETE:",1) #FUN-660091
        ELSE
            CLEAR FORM
            CALL g_sge.clear()
            LET g_delete='Y'
            LET g_sge01 = NULL
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            OPEN i651_count
            #FUN-B50062-add-start--
            IF STATUS THEN
               CLOSE i651_b_cs
               CLOSE i651_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            FETCH i651_count INTO g_row_count
            #FUN-B50062-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i651_b_cs
               CLOSE i651_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i651_b_cs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i651_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i651_fetch('/')
            END IF
        END IF
    END IF
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i651_b()
DEFINE
    l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT #No.FUN-680073 SMALLINT SMALLINT
    l_n             LIKE type_file.num5,      #檢查重複用        #No.FUN-680073 SMALLINT
    l_lock_sw       LIKE type_file.chr1,      #單身鎖住否        #No.FUN-680073 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,      #處理狀態          #No.FUN-680073 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,      #可新增否          #No.FUN-680073 SMALLINT
    l_allow_delete  LIKE type_file.num5       #可刪除否          #No.FUN-680073 SMALLINT
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_sge01 IS NULL THEN
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT sge02,'',sge03 FROM sge_file ",
                       " WHERE sge01= ? AND sge02= ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i651_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_sge WITHOUT DEFAULTS FROM s_sge.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
           #IF g_sge_t.sge02 IS NOT NULL THEN
            IF g_rec_b >= l_ac THEN
 
               LET p_cmd='u'
               LET g_sge_t.* = g_sge[l_ac].*  #BACKUP
 
               BEGIN WORK
 
               OPEN i651_bcl USING g_sge01,g_sge_t.sge02
               IF STATUS THEN
                  CALL cl_err("OPEN i651_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i651_bcl INTO g_sge_t.*
                  IF SQLCA.sqlcode THEN
                      CALL cl_err(g_sge_t.sge02,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_sge[l_ac].* TO NULL      #900423
            LET g_sge_t.* = g_sge[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD sge02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
 
            INSERT INTO sge_file(sge01,sge02,sge03,sgeacti,sgeuser,sgegrup,  #No:BUG-470041 #MOD-4C0087
                                sgemodu,sgedate,sgeoriu,sgeorig)
                VALUES(g_sge01,g_sge[l_ac].sge02,g_sge[l_ac].sge03,'Y',
                       g_user,g_grup,'','', g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_sge[l_ac].sge02,SQLCA.sqlcode,0) #No.FUN-660091
              CALL cl_err3("ins","sge_file",g_sge01,g_sge[l_ac].sge02,SQLCA.sqlcode,"","",1) #FUN-660091
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        AFTER FIELD sge02                       #check 序號是否重複
            IF NOT cl_null(g_sge[l_ac].sge02) THEN
               IF g_sge[l_ac].sge02 != g_sge_t.sge02 OR
                  g_sge_t.sge02 IS NULL THEN
                  SELECT gen02 INTO g_sge[l_ac].gen02 FROM gen_file
                   WHERE gen01 = g_sge[l_ac].sge02
                  IF STATUS THEN
#                    CALL cl_err('sel gen','aec-801',0) #No.FUN-660091
                     CALL cl_err3("sel","gen_file",g_sge[l_ac].sge02,"","aec-801","","sel gen",1) #FUN-660091
                     NEXT FIELD sge02
                  END IF
                  SELECT COUNT(*) INTO l_n FROM sge_file
                   WHERE sge01 = g_sge01
                     AND sge02 = g_sge[l_ac].sge02
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_sge[l_ac].sge02 = g_sge_t.sge02
                     NEXT FIELD sge02
                  END IF
               END IF
            END IF
 
        AFTER FIELD sge03
            IF NOT cl_null(g_sge[l_ac].sge03) THEN
               IF g_sge[l_ac].sge03 < 0 THEN
                  CALL cl_err('','aap-022',0)
                  NEXT FIELD sge03
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_sge_t.sge02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                DELETE FROM sge_file
                 WHERE sge01 = g_sge01
                   AND sge02 = g_sge_t.sge02
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_sge_t.sge02,SQLCA.sqlcode,0) #No.FUN-660091
                   CALL cl_err3("del","sge_file",g_sge01,g_sge_t.sge02,SQLCA.sqlcode,"","",1) #FUN-660091
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_sge[l_ac].* = g_sge_t.*
               CLOSE i651_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_sge[l_ac].sge02,-263,1)
               LET g_sge[l_ac].* = g_sge_t.*
            ELSE
               UPDATE sge_file SET sge02=g_sge[l_ac].sge02,
                                   sge03=g_sge[l_ac].sge03
                WHERE sge01=g_sge01 AND
                      sge02=g_sge_t.sge02
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_sge[l_ac].sge02,SQLCA.sqlcode,0) #No.FUN-660091
                   CALL cl_err3("upd","sge_file",g_sge01,g_sge_t.sge02,SQLCA.sqlcode,"","",1) #FUN-660091
                   LET g_sge[l_ac].* = g_sge_t.*
                   ROLLBACK WORK
                ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_sge[l_ac].* = g_sge_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_sge.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i651_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i651_bcl
            COMMIT WORK
 
#       ON ACTION CONTROLN
#           CALL i651_b_askkey()
#           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(sge02) AND l_ac > 1 THEN
                LET g_sge[l_ac].* = g_sge[l_ac-1].*
                NEXT FIELD sge02
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp
           IF INFIELD(sge02) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.default1 = g_sge[l_ac].sge02
              CALL cl_create_qry() RETURNING g_sge[l_ac].sge02
#              CALL FGL_DIALOG_SETBUFFER( g_sge[l_ac].sge02 )
               DISPLAY BY NAME g_sge[l_ac].sge02    #No.MOD-490371
              NEXT FIELD sge02
           END IF
 
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
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end                            
 
    END INPUT
 
    CLOSE i651_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i651_b_askkey()
   CLEAR FORM
   CALL g_sge.clear()
    CONSTRUCT g_wc2 ON sge01,sge02,sge03    #螢幕上取條件
        FROM sge01,s_sge[1].sge02,s_sge[1].sge03
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i651_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i651_b_fill(p_wc)              #BODY FILL UP
DEFINE
   #p_wc            VARCHAR(300)                  #TQC-630166 
    p_wc            STRING,                    #TQC-630166       
    l_flag          LIKE type_file.chr1,       #No.FUN-680073 VARCHAR(1) 
   #l_sql           VARCHAR(300)                  #TQC-630166
    l_sql           STRING                     #TQC-630166
 
 
    LET l_sql = "SELECT sge02,gen02,sge03,'' FROM sge_file LEFT OUTER JOIN gen_file ON sge_file.sge02=gen_file.gen01",
                " WHERE sge01 = '",g_sge01,"'",
                "   AND ",p_wc CLIPPED,
                " ORDER BY sge02"
 
    PREPARE sge_pre FROM l_sql
    DECLARE sge_cs CURSOR FOR sge_pre
 
    CALL g_sge.clear()
 
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH sge_cs INTO g_sge[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
 
        LET g_cnt = g_cnt + 1
 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
 
    END FOREACH
    CALL g_sge.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i651_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sge TO s_sge.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      #No.TQC-790077  --Begin
      #ON ACTION modify
      #   LET g_action_choice="modify"
      #   EXIT DISPLAY
      #No.TQC-790077  --End  
      ON ACTION first
         CALL i651_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i651_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i651_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i651_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i651_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
#FUN-4B0012
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##
 
     ON ACTION related_document                #No.FUN-6A0039  相關文件
        LET g_action_choice="related_document"          
        EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end             
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i651_copy()
DEFINE
    l_oldno         LIKE sge_file.sge01,
    l_newno         LIKE sge_file.sge01
 
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_sge01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    INPUT l_newno  FROM sge01
        AFTER FIELD sge01
            IF NOT cl_null(l_newno) THEN
               SELECT count(*) INTO g_cnt FROM sge_file
                WHERE sge01 = l_newno
               IF g_cnt > 0 THEN
                   CALL cl_err(l_newno,-239,0)
                   NEXT FIELD sge01
               END IF
            END IF
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END INPUT
 
    IF INT_FLAG OR l_newno IS NULL THEN
        LET INT_FLAG = 0
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM sge_file
        WHERE sge01=g_sge01
        INTO TEMP x
 
    UPDATE x
        SET sge01=l_newno     #資料鍵值
 
    INSERT INTO sge_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_sge01,SQLCA.sqlcode,0) #No.FUN-660091
        CALL cl_err3("ins","sge_file",l_newno,"",SQLCA.sqlcode,"","",1) #FUN-660091
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_sge01
        LET g_sge01 = l_newno
 
        CALL i651_u()
        CALL i651_b()
 
        #LET g_sge01 = l_oldno #FUN-C30027
 
        #CALL i651_show()      #FUN-C30027
    END IF
END FUNCTION
 
FUNCTION i651_out()
 
 DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680073 SMALLINT
    sr              RECORD
        sge01       LIKE sge_file.sge01,   #
        sge02       LIKE sge_file.sge02,   #
        gen02       LIKE gen_file.gen02,   #
        sge03       LIKE sge_file.sge03,   #
        gen03       LIKE gen_file.gen03,
        gem02       LIKE gem_file.gem02
                    END RECORD,
    l_name          LIKE type_file.chr20,    # No.FUN-680073  VARCHAR(20),  #External(Disk) file name
    l_za05          LIKE type_file.chr1000   # No.FUN-680073  VARCHAR(40)
    DEFINE g_str           STRING                  #No.FUN-890127
    
    IF cl_null(g_wc) THEN
       LET g_wc=" sge01='",g_sge01,"'"
    END IF
 
    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog     #No.FUN-890127
#No.FUN-890127  --add begin--
    LET g_sql="SELECT sge01,sge02,gen02,sge03,gen03,gem02",
              "  FROM sge_file LEFT OUTER JOIN (gen_file LEFT OUTER JOIN gem_file ON gem01=gen03)",
              "    ON sge02 = gen01 ",
              " WHERE ",g_wc CLIPPED
#              " ORDER BY sge01,sge02"
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(g_wc,'sge01,sge02,sge03')                                                                              
        RETURNING g_wc                                                                                                              
        LET g_str = g_wc                                                                                                            
     END IF                                                                                                                         
     LET g_str =g_str                                                                                                                 
     CALL cl_prt_cs1('aeci651','aeci651',g_sql,g_str) 
#No.FUN-890127  --add end--                   
    
    
 
#No.FUN-890127  --mark begin--
#    LET g_sql="SELECT sge01,sge02,gen02,sge03,gen03",
#              "  FROM sge_file,gen_file ",
#              " WHERE sge02 = gen01 ",
#              "   AND  ",g_wc CLIPPED
#    PREPARE i651_p1 FROM g_sql                # RUNTIME 編譯
#    DECLARE i651_co                         # SCROLL CURSOR
#        CURSOR FOR i651_p1
 
#    CALL cl_outnam('aeci651') RETURNING l_name     
#    START REPORT i651_rep TO l_name                
 
#    FOREACH i651_co INTO sr.*
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)
#            EXIT FOREACH
#            END IF
#        OUTPUT TO REPORT i651_rep(sr.*)             
#    END FOREACH
 
#    FINISH REPORT i651_rep                       
 
#    CLOSE i651_co                                
#    ERROR ""                                      
#    CALL cl_prt(l_name,' ','1',g_len)  
#No.FUN-890127  --mark end--            
 END FUNCTION
 
#No.FUN-890127  --mark begin--
#REPORT i651_rep(sr)
#DEFINE
#   l_trailer_sw    LIKE type_file.chr1,   #No.FUN-680073 VARCHAR(1)
#   sr              RECORD
#       sge01       LIKE sge_file.sge01,   #
#       sge02       LIKE sge_file.sge02,   #
#       gen02       LIKE gen_file.gen02,   #
#       sge03       LIKE sge_file.sge03,   #
#       gen03       LIKE gen_file.gen03,
#       gem02       LIKE gem_file.gem02
#                   END RECORD
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.sge01,sr.sge02
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno=g_pageno+1
#           LET pageno_total=PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED,pageno_total
#           LET g_head1=g_x[9] CLIPPED, sr.sge01 CLIPPED
#           PRINT g_head1
#           PRINT g_dash[1,g_len]
#           LET l_trailer_sw = 'y'
#           PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#                 g_x[35] CLIPPED
#           PRINT g_dash1
 
#       BEFORE GROUP OF sr.sge01
#          SKIP TO TOP OF PAGE
 
#       ON EVERY ROW
#           SELECT gem02 INTO sr.gem02 FROM gem_file WHERE gem01=sr.gen03
#           IF SQLCA.sqlcode THEN LET sr.gem02 = ' ' END IF
#           PRINT COLUMN g_c[31],sr.sge02 CLIPPED,
#                 COLUMN g_c[32],sr.gen02 CLIPPED,
#                 COLUMN g_c[33],sr.gen03 CLIPPED,
#                 COLUMN g_c[34],sr.gem02 CLIPPED,
#                 COLUMN g_c[35],sr.sge03 USING '######&.&&'
 
#       AFTER  GROUP OF sr.sge01  #工作時間表編號
#           PRINT COLUMN g_c[34],g_x[10] CLIPPED,
#                 COLUMN g_c[35],GROUP SUM(sr.sge03) USING '######&.&&'
 
#       ON LAST ROW
#           IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#              THEN PRINT g_dash[1,g_len]
#                   CALL cl_prt_pos_wc(g_wc) #TQC-630166
#                  #IF g_wc[001,080] > ' ' THEN
#       	   #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
#                  #IF g_wc[071,140] > ' ' THEN
#       	   #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
#                  #IF g_wc[141,210] > ' ' THEN
#       	   #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
#           END IF
#           PRINT g_dash[1,g_len]
#           LET l_trailer_sw = 'n'
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#          END IF
#END REPORT
#No.FUN-890127  --mark end--
