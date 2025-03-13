# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: agli113.4gl
# Descriptions...: 列印族群維護
# Date & Author..: 96/08/26 By Melody
# Modify.........: No.MOD-490344 04/09/20 By Kitty Controlp 未加display
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.MOD-590002 05/09/06 By wujie    系統review報表修改
# Modify.........: No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0040 06/11/15 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-750022 07/05/09 By Lynn 打印時,"FROM:"位置在報表名之上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-780014 07/08/07 By sherry  報表改由Crystal Report輸出 
  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_abe01         LIKE abe_file.abe01,
    g_abe01_t       LIKE abe_file.abe01,
    g_abe01_o       LIKE abe_file.abe01,
    g_abe02         LIKE abe_file.abe02,
    g_abe02_t       LIKE abe_file.abe02,
    g_abe02_o       LIKE abe_file.abe02,
    g_abe           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        abe04       LIKE abe_file.abe04,
        abe03       LIKE abe_file.abe03,
        gem02       LIKE gem_file.gem02
                    END RECORD,
    g_abe_t         RECORD                    #程式變數 (舊值)
        abe04       LIKE abe_file.abe04,
        abe03       LIKE abe_file.abe03,
        gem02       LIKE gem_file.gem02
                    END RECORD,
    m_gem02         LIKE gem_file.gem02,          #No.MOD-590002  #No.FUN-680098   VARCHAR(40)
    i               LIKE type_file.num5,          #No.FUN-680098  SMALLINT
     g_wc,g_sql,g_wc2    STRING,  #No.FUN-580092 HCN   
    g_rec_b         LIKE type_file.num5,          #單身筆數        #No.FUN-680098 SMALLINT
    l_ac            LIKE type_file.num5           #目前處理的ARRAY CNT   #No.FUN-680098 SMALLINT
DEFINE   g_cnt      LIKE type_file.num10          #No.FUN-680098 INTEGER
DEFINE   g_i        LIKE type_file.num5           #count/index for any purpose        #No.FUN-680098 SMALLINT
DEFINE   g_msg      LIKE type_file.chr1000        #No.FUN-680098  VARCHAR(72)
#主程式開始
DEFINE   g_forupd_sql   STRING   #SELECT ... FOR UPDATE SQL      
DEFINE   g_before_input_done  LIKE type_file.num5    #No.FUN-680098  SMALLINT
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680098  SMALLINT
#No.FUN-780014---Begin                                                          
DEFINE   g_str           STRING                                                 
DEFINE   l_sql           STRING                                                 
DEFINE   l_table         STRING                                                 
#No.FUN-780014---End   
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0073
DEFINE p_row,p_col   LIKE type_file.num5     #No.FUN-680098         SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
 
   #No.FUN-780014---Begin                                                       
   LET g_sql = "abe01.abe_file.abe01,",     
               "abe02.abe_file.abe02,",                                        
               "abe04.abe_file.abe04,",                                        
               "abe03.abe_file.abe03,",                                        
               "abe03_1.abe_file.abe03,",                                       
               "abe03_2.abe_file.abe03,",                                       
               "abe03_3.abe_file.abe03,",                                     
               "gem02.gem_file.gem02,",                                         
               "gem02_1.gem_file.gem02,",                                       
               "gem02_2.gem_file.gem02,",                                       
               "gem02_3.gem_file.gem02,"                                        
                                                                                
   LET l_table = cl_prt_temptable('agli113',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
               " VALUES(?,?,?,?,?,?,?,?,?,?,?) "                                      
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                                                                       
   #NO.FUN-780014---End  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
 
    LET i=0
    LET g_abe01_t = NULL
    LET g_abe02_t = NULL
 
    LET p_row = 4 LET p_col = 30
 
    OPEN WINDOW i113_w AT p_row,p_col
        WITH FORM "agl/42f/agli113"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL i113_menu()
 
    CLOSE FORM i113_w                      #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION i113_cs()
    CLEAR FORM                                      #清除畫面
    CALL g_abe.clear()
    CALL cl_set_head_visible("","YES")              #No.FUN-6B0029
 
   INITIALIZE g_abe01 TO NULL    #No.FUN-750051
   INITIALIZE g_abe02 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON abe01,abe02 FROM abe01,abe02  #螢幕上取條件
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('abeuser', 'abegrup') #FUN-980030
    IF INT_FLAG THEN RETURN END IF
    LET g_sql= "SELECT DISTINCT abe01,abe02 FROM abe_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY 1"
    PREPARE i113_prepare FROM g_sql        #預備一下
    DECLARE i113_bcs                       #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i113_prepare
 
    LET g_sql="SELECT COUNT(DISTINCT abe01)  ",
              " FROM abe_file WHERE ", g_wc CLIPPED
    PREPARE i113_precount FROM g_sql
    DECLARE i113_count CURSOR FOR i113_precount
 
END FUNCTION
 
#中文的MENU
FUNCTION i113_menu()
 
   WHILE TRUE
      CALL i113_bp("G")
      CASE g_action_choice
           WHEN "insert"
            IF cl_chk_act_auth() THEN
                CALL i113_a()
            END IF
           WHEN "query"
            IF cl_chk_act_auth() THEN
                CALL i113_q()
            END IF
           WHEN "next"
            CALL i113_fetch('N')
           WHEN "previous"
            CALL i113_fetch('P')
           WHEN "modify"
            IF cl_chk_act_auth() THEN
                CALL i113_u()
            END IF
           WHEN "detail"
            IF cl_chk_act_auth() THEN
                CALL i113_b()
            ELSE
               LET g_action_choice = NULL
            END IF
          WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i113_copy()
            END IF
           WHEN "delete"
            IF cl_chk_act_auth() THEN
                 CALL i113_r()
            END IF
           WHEN "output"
            IF cl_chk_act_auth() THEN
                 CALL i113_out()
            END IF
           WHEN "help"
            CALL cl_show_help()
           WHEN "exit"
            EXIT WHILE
           WHEN "jump"
            CALL i113_fetch('/')
           WHEN 'controlg'
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_abe01 IS NOT NULL THEN
                  LET g_doc.column1 = "abe01"
                  LET g_doc.value1 = g_abe01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_abe),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION i113_a()
    IF s_shut(0) THEN RETURN END IF                #判斷目前系統是否可用
    MESSAGE ""
    CLEAR FORM
    CALL g_abe.clear()
    INITIALIZE g_abe01 LIKE abe_file.abe01         #DEFAULT 設定
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i113_i("a")                           #輸入單頭
        IF INT_FLAG THEN                           #使用者不玩了
            LET g_abe01=NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_abe01 IS NULL THEN # KEY 不可空白
            CONTINUE WHILE
        END IF
 
        CALL g_abe.clear()
        LET g_rec_b = 0
 
        CALL i113_b()                              #輸入單身
        SELECT abe01 INTO g_abe01 FROM abe_file
            WHERE abe01 = g_abe01 AND abe02 = g_abe02
        LET g_abe01_t = g_abe01                    #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i113_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,      #判斷必要欄位是否有輸入  #No.FUN-680098 VARCHAR(1)
    l_n1,l_n        LIKE type_file.num5,      #No.FUN-680098   SMALLINT
    p_cmd           LIKE type_file.chr1       #a:輸入 u:更改        #No.FUN-680098 VARCHAR(1)
 
    DISPLAY g_abe01,g_abe02 TO abe01,abe02
    CALL cl_set_head_visible("","YES")        #No.FUN-6B0029
 
    INPUT g_abe01,g_abe02 FROM abe01,abe02
 
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i113_set_entry(p_cmd)
          CALL i113_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
        BEFORE FIELD abe01
          IF p_cmd='u' THEN
             LET g_abe01=g_abe01_t
             LET g_abe02=g_abe02_t
             DISPLAY g_abe01_t TO abe01
             DISPLAY g_abe02_t TO abe02
             NEXT FIELD abe02
          END IF
 
        AFTER FIELD abe01
          IF NOT cl_null(g_abe01) THEN
             SELECT COUNT(*) INTO l_n FROM abe_file
                WHERE abe01=g_abe01
             IF l_n>0 THEN
                CALL cl_err(g_abe01,-239,0)
                NEXT FIELD abe01
             END IF
             LET g_abe01_o = g_abe01
          END IF
 
        AFTER FIELD abe02
          LET g_abe02_o = g_abe02
 
        ON ACTION CONTROLF                  #欄位說明
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
 
FUNCTION i113_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("abe01",TRUE)
    END IF
END FUNCTION
 
FUNCTION i113_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("abe01",FALSE)
    END IF
END FUNCTION
 
#Query 查詢
FUNCTION i113_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_abe01 TO NULL               #No.FUN-6B0040
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_abe.clear()
    CALL i113_cs()
    IF INT_FLAG THEN                         #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i113_bcs                            #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                    #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_abe01 TO NULL
    ELSE
        CALL i113_fetch('F')                 #讀出TEMP第一筆並顯示
        OPEN i113_count
        FETCH i113_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i113_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,   #處理方式        #No.FUN-680098  VARCHAR(1)
    l_abso          LIKE type_file.num10   #絕對的筆數      #No.FUN-680098  INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i113_bcs INTO g_abe01,g_abe02
        WHEN 'P' FETCH PREVIOUS i113_bcs INTO g_abe01,g_abe02
        WHEN 'F' FETCH FIRST    i113_bcs INTO g_abe01,g_abe02
        WHEN 'L' FETCH LAST     i113_bcs INTO g_abe01,g_abe02
        WHEN '/'
            IF (NOT mi_no_ask) THEN
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
            FETCH ABSOLUTE g_jump i113_bcs INTO g_abe01,g_abe02
            LET mi_no_ask = FALSE
    END CASE
    SELECT unique abe01 FROM abe_file WHERE abe01 = g_abe01
    IF SQLCA.sqlcode THEN                         #有麻煩
#       CALL cl_err(g_abe01,SQLCA.sqlcode,0)   #No.FUN-660123
        CALL cl_err3("sel","abe_file",g_abe01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
        INITIALIZE g_abe01 TO NULL  #TQC-6B0105
        INITIALIZE g_abe02 TO NULL  #TQC-6B0105
    ELSE
        CALL i113_show()
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
 
FUNCTION i113_show()
 
    DISPLAY g_abe01,g_abe02 TO abe01,abe02
 
    CALL i113_b_fill(g_wc)
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i113_r()
    DEFINE l_chr LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_abe01 IS NULL
	THEN CALL cl_err('',-400,0) RETURN
    END IF
    BEGIN WORK
    IF cl_delh(15,16) THEN
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "abe01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_abe01       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
        DELETE FROM abe_file WHERE abe01=g_abe01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err(g_abe01,SQLCA.sqlcode,0)   #No.FUN-660123
           CALL cl_err3("del","abe_file",g_abe01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
        ELSE
           CLEAR FORM
           CALL g_abe.clear()
           CALL g_abe.clear()
           OPEN i113_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i113_bcs
             CLOSE i113_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
           FETCH i113_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i113_bcs
             CLOSE i113_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN i113_bcs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL i113_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE
              CALL i113_fetch('/')
           END IF
        END IF
    END IF
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i113_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT        #No.FUN-680098 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用        #No.FUN-680098 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否        #No.FUN-680098 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態          #No.FUN-680098 VARCHAR(1)
    l_jump          LIKE type_file.num5,     #判斷是否跳過AFTER ROW的處理   #No.FUN-680098  SMALLINT 
    l_allow_insert  LIKE type_file.num5,     #可新增否        #No.FUN-680098 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否        #No.FUN-680098 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT abe04,abe03,'' FROM abe_file ",
                       " WHERE abe01= ? AND abe04= ?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i113_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_abe WITHOUT DEFAULTS FROM s_abe.*
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
 
            IF g_rec_b >= l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_abe_t.* = g_abe[l_ac].*  #BACKUP
               OPEN i113_bcl USING g_abe01,g_abe_t.abe04
               IF STATUS THEN
                  CALL cl_err("OPEN i113_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i113_bcl INTO g_abe[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_abe_t.abe04,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            IF l_ac <= l_n THEN                    #DISPLAY NEWEST
                CALL i113_abe03('d')
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_abe[l_ac].* TO NULL      #900423
            LET g_abe_t.* = g_abe[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD abe04
 
        AFTER INSERT
 
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO abe_file(abe01,abe02,abe03,abe04,abeacti,
                                 abeuser,abegrup,abemodu,abedate,abeoriu,abeorig)
                          VALUES(g_abe01,g_abe02,g_abe[l_ac].abe03,
                                 g_abe[l_ac].abe04,'Y',
                                 g_user,g_grup,g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_abe[l_ac].abe03,SQLCA.sqlcode,0)   #No.FUN-660123
                CALL cl_err3("ins","abe_file",g_abe01,g_abe[l_ac].abe04,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b = g_rec_b + 1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE FIELD abe04                        #default 項次
            IF g_abe[l_ac].abe04 IS NULL OR
               g_abe[l_ac].abe04 = 0 THEN
                SELECT max(abe04)+1
                   INTO g_abe[l_ac].abe04
                   FROM abe_file
                   WHERE abe01 = g_abe01
                IF g_abe[l_ac].abe04 IS NULL
                   THEN LET g_abe[l_ac].abe04 = 1
                END IF
            END IF
 
        AFTER FIELD abe04
            IF NOT cl_null(g_abe[l_ac].abe04) THEN
               IF g_abe[l_ac].abe04 != g_abe_t.abe04 OR g_abe_t.abe04 IS NULL THEN
                   SELECT count(*) INTO l_n FROM abe_file
                    WHERE abe01 = g_abe01 AND abe04 = g_abe[l_ac].abe04
                   IF l_n > 0 THEN
                       CALL cl_err(g_abe[l_ac].abe04,-239,0)
                       LET g_abe[l_ac].abe04 = g_abe_t.abe04
                       NEXT FIELD abe04
                   END IF
               END IF
            END IF
 
        AFTER FIELD abe03
            IF NOT cl_null(g_abe[l_ac].abe03) THEN
               IF g_abe[l_ac].abe03 != g_abe_t.abe03 OR g_abe_t.abe03 IS NULL THEN
                  SELECT count(*) INTO l_n FROM abe_file
                      WHERE abe01 = g_abe01 AND abe03 = g_abe[l_ac].abe03
                  IF l_n > 0 THEN
                      CALL cl_err(g_abe[l_ac].abe03,-239,0)
                      LET g_abe[l_ac].abe03 = g_abe_t.abe03
                      #------MOD-5A0095 START----------
                      DISPLAY BY NAME g_abe[l_ac].abe03
                      #------MOD-5A0095 END------------
                      NEXT FIELD abe03
                  END IF
                  CALL i113_abe03(p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_abe[l_ac].abe03,g_errno,0)
                     LET g_abe[l_ac].abe03=g_abe_t.abe03
                     NEXT FIELD abe03
                  END IF
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_abe_t.abe04 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM abe_file
                 WHERE abe01 = g_abe01 AND abe04 = g_abe[l_ac].abe04
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_abe_t.abe04,SQLCA.sqlcode,0)   #No.FUN-660123
                   CALL cl_err3("del","abe_file",g_abe01,g_abe_t.abe04,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b = g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
 
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_abe[l_ac].* = g_abe_t.*
               CLOSE i113_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_abe[l_ac].abe04,-263,1)
               LET g_abe[l_ac].* = g_abe_t.*
            ELSE
               UPDATE abe_file SET abe03 = g_abe[l_ac].abe03,
                                   abe04 = g_abe[l_ac].abe04,
                                   abemodu = g_user,
                                   abedate = g_today
                WHERE abe01=g_abe01 AND abe04=g_abe_t.abe04
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_abe[l_ac].abe04,SQLCA.sqlcode,0)   #No.FUN-660123
                    CALL cl_err3("upd","abe_file",g_abe01,g_abe_t.abe04,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                    LET g_abe[l_ac].* = g_abe_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac   #FUN-D30032 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              #LET g_abe[l_ac].* = g_abe_t.*  #FUN-D30032 mark
              #FUN-D30032--add--begin--
               IF p_cmd = 'u' THEN
                  LET g_abe[l_ac].* = g_abe_t.*
               ELSE
                  CALL g_abe.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               END IF   
              #FUN-D30032--add--end----
               CLOSE i113_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30032 add
            #LET g_abe_t.* = g_abe[l_ac].*   #TQC-620018
            CLOSE i113_bcl
            COMMIT WORK
 
#       ON ACTION CONTROLN
#           CALL i113_b_askkey()
#           EXIT INPUT
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(abe03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem"
                 LET g_qryparam.default1 = g_abe[l_ac].abe03
                 CALL cl_create_qry() RETURNING g_abe[l_ac].abe03
#                 CALL FGL_DIALOG_SETBUFFER( g_abe[l_ac].abe03 )
                  DISPLAY BY NAME g_abe[l_ac].abe03   #No.MOD-490344
                 NEXT FIELD abe03
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(abe04) AND l_ac > 1 THEN
                LET g_abe[l_ac].* = g_abe[l_ac-1].*
                LET g_abe[l_ac].abe04 = NULL   #TQC-620018
                DISPLAY g_abe[l_ac].* TO s_abe[l_ac].*
                NEXT FIELD abe04
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
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
    END INPUT
 
    CLOSE i113_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i113_abe03(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
       l_gem02         LIKE gem_file.gem02,            
       l_gem05         LIKE gem_file.gem05,
       l_gemacti       LIKE gem_file.gemacti
 
   LET g_errno = ' '
   SELECT gem02,gem05,gemacti
     INTO g_abe[l_ac].gem02,l_gem05,l_gemacti FROM gem_file
      WHERE gem01 = g_abe[l_ac].abe03
    CASE WHEN STATUS = 100        LET g_errno = 'agl-003'
         WHEN l_gemacti = 'N'     LET g_errno = '9028'
         OTHERWISE           LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
END FUNCTION
 
FUNCTION i113_b_askkey()
DEFINE
    l_wc       LIKE type_file.chr1000   #No.FUN-680098 VARCHAR(200)
 
    CONSTRUCT l_wc ON abe03
       FROM s_abe[1].abe03
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
    IF INT_FLAG THEN RETURN END IF
    CALL i113_b_fill(l_wc)
 
END FUNCTION
 
FUNCTION i113_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc      LIKE type_file.chr1000     #No.FUN-680098 VARCHAR(200)
 
    LET g_sql =
       "SELECT abe04,abe03,'' FROM abe_file ",
       " WHERE abe01 = '",g_abe01,"' AND ", p_wc CLIPPED , " ORDER BY abe04"
 
    PREPARE i113_prepare2 FROM g_sql      #預備一下
    DECLARE abe_cs CURSOR FOR i113_prepare2
 
    CALL g_abe.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH abe_cs INTO g_abe[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      SELECT gem02 INTO g_abe[g_cnt].gem02 FROM gem_file
                  WHERE gem01   = g_abe[g_cnt].abe03
                    AND gemacti = 'Y'
      IF SQLCA.sqlcode THEN LET g_abe[g_cnt].gem02 = ' ' END IF
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
    END FOREACH
 
    CALL g_abe.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i113_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_abe TO s_abe.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i113_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i113_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i113_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i113_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i113_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
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
 
 
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
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
 
 
FUNCTION i113_copy()
DEFINE
    l_abe		RECORD LIKE abe_file.*,
    l_oldno,l_newno	LIKE abe_file.abe01
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_abe01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i113_set_entry('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
    INPUT l_newno FROM abe01
        AFTER FIELD abe01
            IF NOT cl_null(l_newno) THEN
               SELECT count(*) INTO g_cnt FROM abe_file
                   WHERE abe01 = l_newno
               IF g_cnt > 0 THEN
                   CALL cl_err(l_newno,-239,0)
                   NEXT FIELD abe01
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY g_abe01 TO abe01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM abe_file         #單身複製
        WHERE abe01=g_abe01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_abe01,SQLCA.sqlcode,0)   #No.FUN-660123
        CALL cl_err3("ins","x",g_abe01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
        RETURN
    END IF
    UPDATE x
        SET abe01=l_newno
    INSERT INTO abe_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err('abe:',SQLCA.sqlcode,0)   #No.FUN-660123
        CALL cl_err3("sel","abe_file",l_newno,"",SQLCA.sqlcode,"","abe:",1)  #No.FUN-660123
        RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
     LET l_oldno = g_abe01
     SELECT unique abe01 INTO g_abe01 FROM abe_file WHERE abe01 = l_newno
     CALL i113_u()
     CALL i113_b()
     #FUN-C30027---begin
     #SELECT unique abe01 INTO g_abe01 FROM abe_file WHERE abe01 = l_oldno
     #SELECT unique abe02 INTO g_abe02 FROM abe_file WHERE abe01 = l_oldno
     #CALL i113_show()
     #FUN-C30027---end
END FUNCTION
 
FUNCTION i113_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680098 SMALLINT
        l_name          LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680098 VARCHAR(20)
        l_za05          LIKE za_file.za05,            #No.FUN-680098 VARCHAR(40)
        l_chr           LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
        l_abe           RECORD LIKE abe_file.*
    #No.FUN-780014---Begin    在FUNCTION內使用"l_"定義局部變量,通常計數變量不在>
    DEFINE  i,j         LIKE type_file.num5                                     
    DEFINE  l_gem02     LIKE gem_file.gem02                                     
    DEFINE  l_gem02_1   LIKE gem_file.gem02                                     
    DEFINE  l_gem02_2   LIKE gem_file.gem02                                     
    DEFINE  l_gem02_3   LIKE gem_file.gem02                                     
    DEFINE  l_abe03_1   LIKE abe_file.abe03                                     
    DEFINE  l_abe03_2   LIKE abe_file.abe03                                     
    DEFINE  l_abe03_3   LIKE abe_file.abe03                                     
    DEFINE  l_abe01_t   LIKE abe_file.abe01                                     
    DEFINE  l_abe02_t   LIKE abe_file.abe02
    DEFINE  l_abe03_t   LIKE abe_file.abe03
    DEFINE  l_abe04_t   LIKE abe_file.abe04                     
    #No.FUN-780014---End                
    IF g_wc IS NULL THEN
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
    #CALL cl_outnam('agli113') RETURNING l_name                    #No.FUN-780014
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'agli113'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT * FROM abe_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED,
              " ORDER BY abe01,abe04,abe03"
    PREPARE i113_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i113_co  CURSOR FOR i113_p1
  
    #No.FUN-780014---Begin
    #START REPORT i113_rep TO l_name                    
    CALL cl_del_data(l_table)                                                   
                                                                                
    LET i=1                         #循環計數,實現每行3筆排列                   
    LET j=0                         #累加計數,判斷當前FOREACH到的筆數           
    INITIALIZE l_abe01_t TO NULL    #初始化分組key舊值                          
    INITIALIZE l_abe02_t TO NULL    #初始化分組key舊值
    INITIALIZE l_abe03_t TO NULL
    INITIALIZE l_abe04_t TO NULL                      
    #No.FUN-780014---End     
    FOREACH i113_co INTO l_abe.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        #No.FUN-780014---Begin
        #OUTPUT TO REPORT i113_rep(l_abe.*)
        IF (cl_null(l_abe01_t) OR l_abe.abe01<>l_abe01_t) THEN   #分組重新排列處>
                                                                                
           IF j>0 AND i<>1 THEN                                 #若上一組最后一>
                                                                #則插入上一分組>
               EXECUTE insert_prep USING l_abe01_t,l_abe02_t,l_abe04_t,
                                         l_abe03_t,l_abe03_1,l_abe03_2,         
                                         l_abe03_3,l_gem02,l_gem02_1,l_gem02_2, 
                                         l_gem02_3                              
               INITIALIZE l_abe03_1,l_abe03_2,l_abe03_3,        #每次插入后清空>
                          l_gem02_1,l_gem02_2,l_gem02_3 TO NULL #以防當前筆值為>
           END IF                                                               
           LET i=1                                              #切換分組時,    
           LET j=0                                              #重新計數       
       END IF                                                                   
       #SELECT gem02 INTO l_gem02 FROM gem_file                                  
       #    WHERE gem01 = l_abe.abe01 AND gemacti='Y'              
       #IF STATUS=100 THEN LET l_gem02='' END IF                                 
       LET j = j+1                                              #組內計數累加   
       IF i =1 AND NOT cl_null(l_abe.abe03) THEN                                                             
          LET l_abe03_1 = l_abe.abe03                           #存儲排列值1    
          SELECT gem02 INTO l_gem02_1 FROM gem_file                             
             WHERE gem01=l_abe.abe03 AND gemacti='Y'              
          LET i = i+1                                           #組內循環計數   
       ELSE                                                                     
          IF i=2 AND NOT cl_null(l_abe.abe03) THEN                                                           
             LET l_abe03_2 = l_abe.abe03                        #存儲排列值2    
             SELECT gem02 INTO l_gem02_2 FROM gem_file                          
                WHERE gem01=l_abe.abe03 AND gemacti='Y'           
             LET i = i+1                                                        
          ELSE                                                                  
             IF i=3 AND NOT cl_null(l_abe.abe03) THEN           #排滿3筆,插入當>
                LET l_abe03_3 = l_abe.abe03                     #存儲排列值3    
                LET i = 1                                                       
                SELECT gem02 INTO l_gem02_3 FROM gem_file                       
                   WHERE gem01=l_abe.abe03 AND gemacti='Y'        
                IF STATUS=100 THEN LET l_gem02_3=' ' END IF                     
                EXECUTE insert_prep USING l_abe.abe01,l_abe.abe02,l_abe.abe04,
                                          l_abe.abe03,l_abe03_1,l_abe03_2,      
                                          l_abe03_3,l_gem02,l_gem02_1,l_gem02_2,
                                          l_gem02_3                             
                INITIALIZE l_abe03_1,l_abe03_2,l_abe03_3,        #每次插入后清空
                           l_gem02_1,l_gem02_2,l_gem02_3 TO NULL #以防當前筆值為
             END IF                                                             
          END IF                                                                
       END IF                                                                   
       #No.FUN-780014---End       
           LET l_abe01_t = l_abe.abe01                                          
           LET l_abe02_t = l_abe.abe02                                          
           LET l_abe03_t = l_abe.abe03                                          
           LET l_abe04_t = l_abe.abe04
    END FOREACH
 
    #No.FUN-780014---Begin                                                      
    IF i <> 1 THEN                                               #若查詢的最后一
                                                                 #則插入最后一行
       EXECUTE insert_prep USING l_abe.abe01,l_abe.abe02,l_abe.abe04,
                                 l_abe.abe03,l_abe03_1,l_abe03_2,               
                                 l_abe03_3,l_gem02,l_gem02_1,l_gem02_2,         
                                 l_gem02_3                                      
       INITIALIZE l_abe03_1,l_abe03_2,l_abe03_3,                                
                  l_gem02_1,l_gem02_2,l_gem02_3 TO NULL                         
    END IF                  
    #FINISH REPORT i113_rep
    #No.FUN-780014---End
 
    CLOSE i113_co
    ERROR ""
  
    #No.FUN-780014---Begin
    #CALL cl_prt(l_name,' ','1',g_len)
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc,'abe01,abe02')                                        
            RETURNING g_wc                                                      
       LET g_str = g_wc                                                         
    END IF                                                                      
    LET g_str = g_wc                                                            
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED          
    CALL cl_prt_cs3('agli113','agli113',l_sql,g_str)                            
   #No.FUN-780014---End                           
END FUNCTION
 
#No.FUN-780014---Begin
{
REPORT i113_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680098   VARCHAR(1)
        sr RECORD LIKE abe_file.*,
        l_chr           LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.abe01,sr.abe04,sr.abe03
 
    FORMAT
        PAGE HEADER
            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#           PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED     # No.TQC-750022
            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
            PRINT ' '
            PRINT g_x[2] CLIPPED,g_today,' ',TIME,
                COLUMN (g_len-FGL_WIDTH(g_user)-18),'FROM:',g_user CLIPPED, COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<'    # No.TQC-750022 
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
           LET i=i+1
           SELECT gem02 INTO m_gem02 FROM gem_file
             WHERE gem01=sr.abe03 AND gemacti='Y'
           IF STATUS=100 THEN LET m_gem02=' ' END IF
           IF i<=3 THEN
              PRINT COLUMN 22*i,sr.abe03 CLIPPED,' ',m_gem02 CLIPPED;
              IF i=3 THEN
                 PRINT ''
              ELSE
                PRINT '';
              END IF
           ELSE
              LET i=1
              PRINT COLUMN 22*i,sr.abe03 CLIPPED,' ',m_gem02 CLIPPED;
           END IF
 
        BEFORE GROUP OF sr.abe01
           PRINT g_x[11] CLIPPED,' ',sr.abe01,COLUMN 18,sr.abe02
           PRINT ''
           PRINT COLUMN 22,g_x[12] CLIPPED, COLUMN 44,g_x[12] CLIPPED,
                 COLUMN 66,g_x[12] CLIPPED
           PRINT COLUMN 22,'---------------       ---------------       ---------------'
 
        AFTER GROUP OF sr.abe01
           LET i=0
           PRINT ''
           PRINT ''
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
#No.FUN-780014---End
 
FUNCTION i113_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_abe01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_abe01_t = g_abe01
    LET g_abe02_t = g_abe02
    BEGIN WORK
    WHILE TRUE
        CALL i113_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_abe02 = g_abe02_t
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE abe_file SET abe02 = g_abe02
            WHERE abe01 = g_abe01
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_abe01,SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("upd","abe_file",g_abe01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
#Patch....NO.MOD-5A0095 <001> #
#Patch....NO.TQC-610035 <001> #
