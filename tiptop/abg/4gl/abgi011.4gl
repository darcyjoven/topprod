# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abgi011.4gl
# Descriptions...: 預估人工/製費/加工費用維護作業 
# Date & Author..: 02/09/19 By nicola 
# Modify.........: No.FUN-4B0021 04/11/04 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510025 05/01/14 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-530247 05/03/24 By Smapmin 調整報表小數位數
# Modify.........: NO.MOD-580078 05/08/09 BY yiting key 可更改
# Modify.........: NO.MOD-590329 05/09/30 By Yiting 針對zz13設定，假雙檔程式單身不做控管
# Modify.........: NO.MOD-5A0004 05/10/07 By Rosayu _r()後筆數不正確
# Modify.........: No.FUN-660105 06/06/15 By hellen      cl_err --> cl_err3
# Modify.........: No.FUN-680061 06/08/25 By cheunl 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0003 06/10/14 By jamie 1.FUNCTION i011()_q 一開始應清空g_bgl01的值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.FUN-6A0057 06/10/20 By hongmei 將 g_no_ask 改為 mi_no_ask 
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/13 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-720019 07/02/27 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-780047 07/07/16 By destiny 報表由p_query產出
# Modify.........: No.TQC-7A0033 07/10/12 By Mandy informix區r.c2不過
# Modify.........: No.TQC-7A0105 07/10/30 By xufeng 單身切換的時候,單身沒有隨之切換
# Modify.........: No.FUN-980001 09/08/05 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法
 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/13 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-D30032 13/04/08 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
   g_bgl01         LIKE bgl_file.bgl01,   #版本
   g_bgl01_t       LIKE bgl_file.bgl01,   #版本(舊值)
   g_bgl02         LIKE bgl_file.bgl02,   #年度
   g_bgl02_t       LIKE bgl_file.bgl02,   #年度(舊值)
   g_bgl04         LIKE bgl_file.bgl04,   #部門編號
   g_bgl04_t       LIKE bgl_file.bgl04,   #部門編號(舊值)
   g_gem02         LIKE gem_file.gem02,   #部門名稱
   g_bgl           DYNAMIC ARRAY OF RECORD#程式變數(Program Variables)
      bgl03        LIKE bgl_file.bgl03,   #月份
      bgl05        LIKE bgl_file.bgl05,   #總人工
      bgl06        LIKE bgl_file.bgl06,   #總製費
      bgl07        LIKE bgl_file.bgl07    #總加工
                   END RECORD,
   g_bgl_t         RECORD                 #程式變數(舊值)
      bgl03        LIKE bgl_file.bgl03,   #月份
      bgl05        LIKE bgl_file.bgl05,   #總人工
      bgl06        LIKE bgl_file.bgl06,   #總製費
      bgl07        LIKE bgl_file.bgl07    #總加工
                   END RECORD,
   g_wc,g_sql,g_wc2    string,  #No.FUN-580092 HCN
   g_show          LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
   g_rec_b         LIKE type_file.num5,   #單身筆數 #No.FUN-680061 SMALLINT
   g_flag          LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
   g_ver           LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
   l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT  #No.FUN-680061 SMALLINT
DEFINE p_row,p_col    LIKE type_file.num5   #No.FUN-680061 SMALLINT
DEFINE g_forupd_sql   STRING                #SELECT ... FOR UPDATE SQL      
DEFINE g_sql_tmp      STRING                #No.TQC-720019
DEFINE g_cnt          LIKE type_file.num10  #No.FUN-680061 INTEGER
DEFINE g_i            LIKE type_file.num5   #count/index for any purpose #No.FUN-680061 SMALLINT
DEFINE g_msg          LIKE type_file.chr1000#No.FUN-680061 VARCHAR(72)
DEFINE g_before_input_done LIKE type_file.num5   #No.FUN-680061 SMALLINT
DEFINE g_row_count    LIKE type_file.num10  #No.FUN-680061 INTEGER
DEFINE g_curs_index   LIKE type_file.num10  #No.FUN-680061 INTEGER
DEFINE g_jump         LIKE type_file.num10  #No.FUN-680061 INTEGER
DEFINE mi_no_ask      LIKE type_file.num5   #No.FUN-680061 SMALLINT   #No.FUN-6A0057 g_no_ask 
 
 
#主程式開始
MAIN
#  DEFINE     l_time      LIKE type_file.chr8              #No.FUN-6A0056
  
   OPTIONS                                   #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                           #擷取中斷鍵, 由程式處理
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
   WHENEVER ERROR CALL cl_err_msg_log
   
   IF (NOT cl_setup("ABG")) THEN
      EXIT PROGRAM
   END IF
     CALL  cl_used(g_prog,g_time,1)          #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
         RETURNING g_time     #No.FUN-6A0056
   LET p_row = 3 LET p_col = 16
 
 OPEN WINDOW i011_w AT p_row,p_col
       WITH FORM "abg/42f/abgi011" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init() 
 
    CALL i011_menu() 
 
    CLOSE WINDOW i011_w                      #結束畫面
      CALL  cl_used(g_prog,g_time,2)  #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
         RETURNING g_time    #No.FUN-6A0056
END MAIN
 
#QBE 查詢資料
FUNCTION i011_cs()
    CLEAR FORM                               #清除畫面
    CALL g_bgl.clear() 
    CALL cl_set_head_visible("","YES")       #No.FUN-6B0033
   INITIALIZE g_bgl01 TO NULL    #No.FUN-750051
   INITIALIZE g_bgl02 TO NULL    #No.FUN-750051
   INITIALIZE g_bgl04 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON bgl01,bgl02,bgl04,bgl03,bgl05,bgl06,bgl07
         FROM bgl01,bgl02,bgl04,
              s_bgl[1].bgl03,s_bgl[1].bgl05,s_bgl[1].bgl06,s_bgl[1].bgl07
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON ACTION CONTROLP
         IF INFIELD(bgl04) THEN
         #  CALL q_gem(05,11,g_bgl04) RETURNING g_bgl04
            CALL cl_init_qry_var()            
            LET g_qryparam.state = "c" 
            LET g_qryparam.form = "q_gem"             
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO bgl04
            NEXT FIELD bgl04
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN RETURN END IF
 
    LET g_sql= "SELECT UNIQUE bgl01,bgl02,bgl04 FROM bgl_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY bgl01"
    PREPARE i011_prepare FROM g_sql          #預備一下
    DECLARE i011_bcs                         #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i011_prepare
      
#  LET g_sql = "SELECT UNIQUE bgl01,bgl02,bgl04",      #No.TQC-720019
   LET g_sql_tmp = "SELECT UNIQUE bgl01,bgl02,bgl04",  #No.TQC-720019
               "  FROM bgl_file ",
               " WHERE ", g_wc CLIPPED,
               " INTO TEMP x "
   DROP TABLE x
#  PREPARE i011_pre_x FROM g_sql      #No.TQC-720019
   PREPARE i011_pre_x FROM g_sql_tmp  #No.TQC-720019
   EXECUTE i011_pre_x
 
   LET g_sql = "SELECT COUNT(*) FROM x"
   PREPARE i011_precnt FROM g_sql
   DECLARE i011_count CURSOR FOR i011_precnt
  
END FUNCTION
 
#中文的MENU 
FUNCTION i011_menu()
DEFINE l_cmd LIKE type_file.chr1000                    #No.FUN-780047
   WHILE TRUE
      CALL i011_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i011_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i011_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i011_r()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i011_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
#               CALL i011_out()                                #No.FUN-780047
            #No.FUN-780047 --statt--
            IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF 
            LET l_cmd='p_query "abgi011" "',g_wc CLIPPED,'"'   
            CALL cl_cmdrun(l_cmd)          
            #No.FUN-780047 --end--               
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0021
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bgl),'','')
            END IF
         #No.FUN-6A0003-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_bgl01 IS NOT NULL THEN
                LET g_doc.column1 = "bgl01"
                LET g_doc.column2 = "bgl02"
                LET g_doc.column3 = "bgl04"
                LET g_doc.value1 = g_bgl01
                LET g_doc.value2 = g_bgl02
                LET g_doc.value3 = g_bgl04
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0003-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i011_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_bgl.clear()
   LET g_bgl01_t = NULL
   LET g_bgl02_t = NULL
   LET g_bgl04_t = NULL           
   LET g_bgl01   = NULL
   LET g_bgl02   = NULL
   LET g_bgl04   = NULL           
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i011_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET g_bgl01=NULL
         LET g_bgl02=NULL
         LET g_bgl04=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
     IF cl_null(g_bgl02)  OR
        cl_null(g_bgl04)  THEN
        CONTINUE WHILE
     END IF
      LET g_rec_b = 0                    #No.FUN-680064
      CALL g_bgl.clear()
      CALL i011_b_fill('1=1')            #單身
      CALL i011_b()                      #輸入單身
      LET g_bgl01_t = g_bgl01
      LET g_bgl02_t = g_bgl02
      LET g_bgl04_t = g_bgl04
      EXIT WHILE
   END WHILE
END FUNCTION
 
 
FUNCTION i011_i(p_cmd)
   DEFINE
      p_cmd    LIKE type_file.chr1,    #a:輸入 u:更改 #No.FUN-680061 VARCHAR(01)
      l_n      LIKE type_file.num5,    #No.FUN-680061 SMALLINT
      l_str    LIKE type_file.chr1000  #No.FUN-680061 VARCHAR(40)
 
   CALL cl_set_head_visible("","YES")  #No.FUN-6B0033
   INPUT g_bgl01,g_bgl02,g_bgl04 WITHOUT DEFAULTS
         FROM bgl01,bgl02,bgl04 HELP 1
 
      AFTER FIELD bgl01
         IF cl_null(g_bgl01) THEN LET g_bgl01 = ' ' END IF
 
      AFTER FIELD bgl02                    #年度
         IF NOT cl_null(g_bgl02) THEN
            IF g_bgl02 < 1 THEN NEXT FIELD bgl02 END IF
         END IF 
 
      AFTER FIELD bgl04                    #部門編號
         IF NOT cl_null(g_bgl04) THEN 
            CALL i011_bgl04('a',g_bgl04)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD bgl04
            END IF
         END IF
 
      ON ACTION CONTROLP
         IF INFIELD(bgl04) THEN
         #  CALL q_gem(05,11,g_bgl04) RETURNING g_bgl04
            CALL cl_init_qry_var()            
            LET g_qryparam.form = "q_gem"             
            LET g_qryparam.default1 = g_bgl04         
            CALL cl_create_qry() RETURNING g_bgl04     
            DISPLAY g_bgl04 TO bgl04
            NEXT FIELD bgl04
         END IF
        ON ACTION CONTROLR                                                      
           CALL cl_show_req_fields()     
      ON ACTION CONTROLF                 #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
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
END FUNCTION
 
 
#Query 查詢
FUNCTION i011_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   MESSAGE ""
   CLEAR FORM
   INITIALIZE g_bgl01 TO NULL
   INITIALIZE g_bgl02 TO NULL
   INITIALIZE g_bgl04 TO NULL
   CALL i011_cs()                      #取得查詢條件
   IF INT_FLAG THEN                    #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_bgl01 TO NULL
      INITIALIZE g_bgl02 TO NULL
      INITIALIZE g_bgl04 TO NULL
      RETURN
   END IF
   OPEN i011_bcs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_bgl01 TO NULL
      INITIALIZE g_bgl02 TO NULL
      INITIALIZE g_bgl04 TO NULL
   ELSE
      OPEN i011_count
      FETCH i011_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
      CALL i011_fetch('F')             #讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i011_fetch(p_flag)
   DEFINE
      p_flag   LIKE type_file.chr1   #處理方式 #No.FUN-680061 VARCHAR(01)
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i011_bcs INTO g_bgl01,g_bgl02,g_bgl04
      WHEN 'P' FETCH PREVIOUS i011_bcs INTO g_bgl01,g_bgl02,g_bgl04
      WHEN 'F' FETCH FIRST    i011_bcs INTO g_bgl01,g_bgl02,g_bgl04
      WHEN 'L' FETCH LAST     i011_bcs INTO g_bgl01,g_bgl02,g_bgl04
      WHEN '/' 
       IF (NOT mi_no_ask) THEN          #No.FUN-6A0057 g_no_ask 
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
         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
       END IF
       FETCH ABSOLUTE g_jump i011_bcs INTO g_bgl01,g_bgl02,g_bgl04
       LET mi_no_ask = FALSE    #No.FUN-6A0057 g_no_ask 
   END CASE
   IF SQLCA.sqlcode THEN                  #有麻煩
      CALL cl_err(g_bgl01,SQLCA.sqlcode,0)
      INITIALIZE g_bgl01 TO NULL  #TQC-6B0105
      INITIALIZE g_bgl02 TO NULL  #TQC-6B0105
      INITIALIZE g_bgl04 TO NULL  #TQC-6B0105
   ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
       CALL i011_show()
   END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i011_show()
    
   DISPLAY g_bgl01 TO bgl01                #單頭
   DISPLAY g_bgl02 TO bgl02                #單頭
   DISPLAY g_bgl04 TO bgl04                #單頭
   CALL i011_bgl04('d',g_bgl04)
   CALL i011_b_fill(g_wc)                      #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i011_r()
 
   IF s_shut(0) THEN RETURN END IF
   IF g_bgl01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF   #No.FUN-6A0003
   BEGIN WORK
   IF cl_delh(15,16) THEN
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "bgl01"      #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "bgl02"      #No.FUN-9B0098 10/02/24
       LET g_doc.column3 = "bgl04"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_bgl01       #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_bgl02       #No.FUN-9B0098 10/02/24
       LET g_doc.value3 = g_bgl04       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                        #No.FUN-9B0098 10/02/24
      DELETE FROM bgl_file 
      WHERE bgl01=g_bgl01
        AND bgl02=g_bgl02
        AND bgl04=g_bgl04
      IF SQLCA.sqlcode THEN
#        CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0) #FUN-660105
         CALL cl_err3("del","bgl_file",g_bgl01,g_bgl02,SQLCA.sqlcode,"","BODY DELETE:",1) #FUN-660105
      ELSE
         CLEAR FORM
         #MOD-5A0004 add
         DROP TABLE x
#        EXECUTE i011_pre_x                  #No.TQC-720019
         PREPARE i011_pre_x2 FROM g_sql_tmp  #No.TQC-720019
         EXECUTE i011_pre_x2                 #No.TQC-720019
         #MOD-5A0004 end
         CALL g_bgl.clear()
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
         OPEN i011_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE i011_bcs
            CLOSE i011_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         FETCH i011_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i011_bcs
            CLOSE i011_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i011_bcs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i011_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE    #No.FUN-6A0057 g_no_ask 
            CALL i011_fetch('/')
         END IF
      END IF
      LET g_msg=TIME
     #INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06) #FUN-980001 mark
            #VALUES ('abgi011',g_user,g_today,g_msg,g_bgl01,'delete') #FUN-980001 mark
      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980001 add
             VALUES ('abgi011',g_user,g_today,g_msg,g_bgl01,'delete',g_plant,g_legal) #FUN-980001 add
   END IF
   COMMIT WORK 
END FUNCTION
 
 
#單身
FUNCTION i011_b()
   DEFINE
      l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680061 SMALLINT
      l_n             LIKE type_file.num5,    #檢查重複用 #No.FUN-680061 SMALLINT
      l_lock_sw       LIKE type_file.chr1,    #單身鎖住否 #No.FUN-680061 VARCHAR(01)
      p_cmd           LIKE type_file.chr1,    #處理狀態   #No.FUN-680061 VARCHAR(01)
      l_allow_insert  LIKE type_file.num5,    #可新增否   #No.FUN-680061 SMALLINT
      l_allow_delete  LIKE type_file.num5     #可刪除否   #No.FUN-680061 SMALLINT
 
    LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET g_forupd_sql =
           "SELECT bgl03,bgl05,bgl06,bgl07 FROM bgl_file  WHERE bgl01 = ? ",
           "   AND bgl02 = ? AND bgl04 = ? AND bgl03 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i011_b_cl CURSOR FROM g_forupd_sql 
 
#   LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_bgl WITHOUT DEFAULTS FROM s_bgl.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEn
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
            LET g_bgl_t.* = g_bgl[l_ac].*  #BACKUP
#NO.MOD-590329 MARK
 #No.MOD-580078 --start
#            LET g_before_input_done = FALSE
#            CALL i011_set_entry_b(p_cmd)
#            CALL i011_set_no_entry_b(p_cmd)
#            LET g_before_input_done = TRUE
 #No.MOD-580078 --end
#NO.MOD-590329
            OPEN i011_b_cl USING g_bgl01,g_bgl02,g_bgl04,g_bgl_t.bgl03  
            IF STATUS THEN
               CALL cl_err("OPEN i011_b_cl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i011_b_cl INTO g_bgl[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_bgl01_t,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  LET g_bgl_t.*=g_bgl[l_ac].*
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
#        NEXT FIELD bgl03
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_bgl[l_ac].* TO NULL
         LET g_bgl_t.* = g_bgl[l_ac].*               #新輸入資料
         LET g_bgl[l_ac].bgl05 = 0
         LET g_bgl[l_ac].bgl06 = 0
         LET g_bgl[l_ac].bgl07 = 0
#NO.MOD-590329 MARK
#No.MOD-580078 --start
#         LET g_before_input_done = FALSE
#         CALL i011_set_entry_b(p_cmd)
#         CALL i011_set_no_entry_b(p_cmd)
#         LET g_before_input_done = TRUE
 #No.MOD-580078 --end
#NO.MOD-590329
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD bgl03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO bgl_file(bgl01,bgl02,bgl03,bgl04,
                              bgl05,bgl06,bgl07)
                VALUES(g_bgl01,g_bgl02,g_bgl[l_ac].bgl03,g_bgl04,
                       g_bgl[l_ac].bgl05,g_bgl[l_ac].bgl06,
                       g_bgl[l_ac].bgl07)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_bgl[l_ac].bgl03,SQLCA.sqlcode,0) #FUN-660105
            CALL cl_err3("ins","bgl_file",g_bgl01,g_bgl02,SQLCA.sqlcode,"","",1) #FUN-660105
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
      AFTER FIELD bgl03                    #月份
         IF NOT cl_null(g_bgl[l_ac].bgl03) THEN
            IF g_bgl[l_ac].bgl03 != g_bgl_t.bgl03 OR g_bgl_t.bgl03 IS NULL THEN
               SELECT COUNT(*) INTO g_cnt
                      FROM bgl_file
                      WHERE bgl01 = g_bgl01
                        AND bgl02 = g_bgl02 
                        AND bgl04 = g_bgl04
                        AND bgl03 = g_bgl[l_ac].bgl03
 
               IF g_cnt > 0 THEN
                  CALL cl_err(g_bgl[l_ac].bgl03,-239,0)
                  NEXT FIELD bgl03
               ELSE
                  IF g_bgl[l_ac].bgl03 <1 OR g_bgl[l_ac].bgl03 > 12 THEN
                      NEXT FIELD bgl03              #判斷是否在1~12月當中
                  END IF
               END IF
            END IF
         END IF
 
      AFTER FIELD bgl05
         IF g_bgl[l_ac].bgl05 < 0 THEN
            NEXT FIELD bgl05
         END IF 
 
      AFTER FIELD bgl06
         IF g_bgl[l_ac].bgl06 < 0 THEN
            NEXT FIELD bgl06
         END IF 
 
      AFTER FIELD bgl07
         IF g_bgl[l_ac].bgl07 < 0 THEN
            NEXT FIELD bgl07
         END IF 
 
      BEFORE DELETE                            #是否取消單身
         IF g_bgl_t.bgl03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM bgl_file
                   WHERE bgl01 = g_bgl01 
                     AND bgl02 = g_bgl02 
                     AND bgl04 = g_bgl04
                     AND bgl03 = g_bgl_t.bgl03
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_bgl_t.bgl03,SQLCA.sqlcode,0) #FUN-660105
               CALL cl_err3("del","bgl_file",g_bgl01,g_bgl_t.bgl03,SQLCA.sqlcode,"","",1) #FUN-660105
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
            LET g_bgl[l_ac].* = g_bgl_t.*
            CLOSE i011_b_cl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_bgl[l_ac].bgl03,-263,1)
            LET g_bgl[l_ac].* = g_bgl_t.*
         ELSE
            UPDATE bgl_file SET bgl03=g_bgl[l_ac].bgl03,
                                bgl05=g_bgl[l_ac].bgl05,
                                bgl06=g_bgl[l_ac].bgl06,
                                bgl07=g_bgl[l_ac].bgl07
             WHERE CURRENT OF i011_b_cl  #要查一下
 
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_bgl[l_ac].bgl03,SQLCA.sqlcode,0) #FUN-660105
               CALL cl_err3("upd","bgl_file",g_bgl01,g_bgl[l_ac].bgl03,SQLCA.sqlcode,"","",1) #FUN-660105
               LET g_bgl[l_ac].* = g_bgl_t.*
               ROLLBACK WORK
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK 
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac #FUN-D30032 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_bgl[l_ac].* = g_bgl_t.*
            #FUN-D30032--add--begin--
            ELSE
               CALL g_bgl.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end----
            END IF
            CLOSE i011_b_cl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac #FUN-D30032 add 
         CLOSE i011_b_cl
         COMMIT WORK
 
      ON ACTION CONTROLN
         CALL i011_b_askkey()
         EXIT INPUT
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(bgl03) AND l_ac > 1 THEN
            LET g_bgl[l_ac].* = g_bgl[l_ac-1].*
            LET g_bgl[l_ac].bgl03=l_ac
            NEXT FIELD bgl03
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
 
      ON ACTION controls                      #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")  #No.FUN-6B0033
    
      END INPUT
 
   CLOSE i011_b_cl
   COMMIT WORK 
END FUNCTION
 
FUNCTION i011_bgl04(p_cmd,p_key)  #部門編號
    DEFINE p_cmd     LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
           p_key     LIKE bgl_file.bgl04,
           l_gem02   LIKE gem_file.gem02,
           l_gemacti LIKE gem_file.gemacti
 
    LET g_errno = " "
    SELECT gem02,gemacti INTO l_gem02,l_gemacti
      FROM gem_file WHERE gem01 = p_key
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                   LET l_gem02 = ' '
         WHEN l_gemacti='N'        LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
        DISPLAY l_gem02 TO FORMONLY.gem02
    END IF
END FUNCTION
 
FUNCTION i011_b_askkey()
   DEFINE
      l_wc   LIKE type_file.chr1000 #No.FUN-680061 VARCHAR(200) 
 
   CONSTRUCT l_wc ON bgl03,bgl05,bgl06,bgl07          #螢幕上取條件
             FROM s_bgl[1].bgl03,s_bgl[1].bgl05,s_bgl[1].bgl06,s_bgl[1].bgl07
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
   CALL i011_b_fill(l_wc)
END FUNCTION
 
FUNCTION i011_b_fill(p_wc)                #BODY FILL UP
   DEFINE
      p_wc   LIKE type_file.chr1000       #No.FUN-680061 VARCHAR(200)
 
   LET g_sql =
       "SELECT bgl03,bgl05,bgl06,bgl07 ",
       "  FROM bgl_file ",
       " WHERE bgl01 = '",g_bgl01,"'",
       "   AND bgl02 = '",g_bgl02,"'",
       "   AND bgl04 = '",g_bgl04,"'",
       "   AND ",p_wc CLIPPED ,
       " ORDER BY bgl03"
   PREPARE i011_prepare2 FROM g_sql       #預備一下
   DECLARE bgl_cs CURSOR FOR i011_prepare2
 
   CALL g_bgl.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH bgl_cs INTO g_bgl[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1  #No.8563
   END FOREACH
   CALL g_bgl.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   IF g_rec_b > g_max_rec THEN
      LET g_msg = g_bgl01 CLIPPED
      CALL cl_err(g_msg,9036,0)
   END IF
     
   DISPLAY g_rec_b TO FORMONLY.cn2 
   LET g_cnt = 0
END FUNCTION
 
FUNCTION i011_bp(p_ud)
   DEFINE
      p_ud   LIKE type_file.chr1    #No.FUN-680061 VARCHAR(01)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bgl TO s_bgl.* ATTRIBUTE(COUNT=g_rec_b)
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
      ON ACTION first 
         CALL i011_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i011_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump 
         CALL i011_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i011_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last 
         CALL i011_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
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
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel   #No.FUN-4B0021
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0003  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
     #No.TQC-7A0105    ---mark--begin--
     ## No.FUN-530067 --start--
     #AFTER DISPLAY
     #   CONTINUE DISPLAY
     ## No.FUN-530067 ---end---
     #No.TQC-7A0105    ---mark---end---
     
      ON ACTION controls                       #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.FUN-780047--start--
{FUNCTION i011_out()
   DEFINE
      l_i    LIKE type_file.num5,    #No.FUN-680061 SMALLINT
      l_name LIKE type_file.chr20,   # External(Disk) file name #NO.FUN-680061 VARCHAR(20)
      l_za05 LIKE type_file.chr1000, #NO.FUN-680061 VARCHAR(40)  
      sr RECORD
         bgl01      LIKE bgl_file.bgl01,
         bgl02      LIKE bgl_file.bgl02,
         bgl03      LIKE bgl_file.bgl03,
         bgl04      LIKE bgl_file.bgl04,
         bgl05      LIKE bgl_file.bgl05,
         bgl06      LIKE bgl_file.bgl06,
         bgl07      LIKE bgl_file.bgl07,
         gem02      LIKE gem_file.gem02
      END RECORD
 
   CALL cl_wait()
   CALL cl_outnam('abgi011') RETURNING l_name
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
   LET g_sql="SELECT bgl01,bgl02,bgl03,bgl04,bgl05,bgl06,bgl07,'' FROM bgl_file ",   # 組合出 SQL 指令 #TQC-7A0033
             " WHERE ",g_wc CLIPPED ,
             " ORDER BY bgl01,bgl02,bgl04 "
   PREPARE i011_p1 FROM g_sql                # RUNTIME 編譯
   DECLARE i011_co CURSOR FOR i011_p1
 
   START REPORT i011_rep TO l_name
 
   FOREACH i011_co INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      SELECT gem02 into sr.gem02 FROM gem_file    #取科目名稱
             WHERE gem01=sr.bgl04
 
      OUTPUT TO REPORT i011_rep(sr.*)
   END FOREACH
 
   FINISH REPORT i011_rep
 
   CLOSE i011_co
   ERROR ""
   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i011_rep(sr)
   DEFINE
      l_trailer_sw  LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
      sr RECORD
         bgl01      LIKE bgl_file.bgl01,
         bgl02      LIKE bgl_file.bgl02,
         bgl03      LIKE bgl_file.bgl03,
         bgl04      LIKE bgl_file.bgl04,
         bgl05      LIKE bgl_file.bgl05,
         bgl06      LIKE bgl_file.bgl06,
         bgl07      LIKE bgl_file.bgl07,
         gem02      LIKE gem_file.gem02
      END RECORD
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.bgl01,sr.bgl04,sr.bgl02,sr.bgl03
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED, pageno_total
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
         PRINT g_dash1
         LET l_trailer_sw = 'y'
   
      BEFORE GROUP OF sr.bgl01
         PRINT COLUMN g_c[31],sr.bgl01 CLIPPED;
 
      BEFORE GROUP OF sr.bgl04
         PRINT COLUMN g_c[32],sr.bgl04 CLIPPED,
               COLUMN g_c[33],sr.gem02 CLIPPED;
 
      BEFORE GROUP OF sr.bgl02
         PRINT COLUMN g_c[34],sr.bgl02;
 
      ON EVERY ROW
 
         PRINT COLUMN g_c[35],sr.bgl03 ,
                COLUMN g_c[36],cl_numfor(sr.bgl05,36,g_azi05), #MOD-530247
                COLUMN g_c[37],cl_numfor(sr.bgl06,37,g_azi05), #MOD-530247
                COLUMN g_c[38],cl_numfor(sr.bgl07,38,g_azi05)  #MOD-530247 
 
      ON LAST ROW
         IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
            PRINT g_dash[1,g_len]
         END IF
         PRINT g_dash[1,g_len]
         LET l_trailer_sw = 'n'
         PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
      PAGE TRAILER
         IF l_trailer_sw = 'y' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
END REPORT}
#No.FUN-780047--end--
 
#NO.MOD-590329 MARK
 #NO.MOD-580078
#FUNCTION i011_set_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680061 VARCHAR(01)
 
#   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
#     CALL cl_set_comp_entry("bgl03",TRUE)
#   END IF
 
#END FUNCTION
 
#FUNCTION i011_set_no_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680061 VARCHAR(01)
 
#   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
#     CALL cl_set_comp_entry("bgl03",FALSE)
#   END IF
 
#END FUNCTION
 #No.MOD-580078 --end
#NO.MOD-590329
