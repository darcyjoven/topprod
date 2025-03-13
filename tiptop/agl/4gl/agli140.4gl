# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: agli140.4gl
# Descriptions...: 利潤中心內部定價維護作業
# Date & Author..: 06/07/12 By kim
# Modify.........: No.FUN-680021 06/08/07 By Sarah 增加"整批產生"功能
# Modify.........: No.TQC-680030 06/08/11 By pengu 不按查詢,直接按單身,依然可以修改單身
# Modify.........: No.FUN-680098 06/09/14 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0040 06/11/15 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-720019 07/02/28 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-750058 07/05/21 By kim 型態定義錯誤
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-780037 07/08/03 By sherry  報表改由p_query輸出
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840041 08/04/10 By shiwuying  ccc_file增加2個Key,抓取單價時,增加條件 ccc07='1',抓實際成本算出的單價為基准
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-9A0027 09/10/15 By mike 新增时年度期别之初值应调整为 CALL s_yp(g_today) RETURNING g_ahi01,g_ahi02         
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-B60093 11/06/30 By Vampire 在整批產生 加入 成本計算類別 欄位
# Modify.........: No.CHI-C30119 12/04/23 By belle 計算成本時,增加類別編號做為條件
# Modify.........: No:FUN-D30032 13/04/01 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_ahi01           LIKE ahi_file.ahi01,
    g_ahi01_t         LIKE ahi_file.ahi01,
    g_ahi02           LIKE ahi_file.ahi02,
    g_ahi02_t         LIKE ahi_file.ahi02,   
    g_ahi06           LIKE ahi_file.ahi06,       #CHI-C30019
    g_ahi06_t         LIKE ahi_file.ahi06,       #CHI-C30019
    g_ahi             DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        ahi03         LIKE ahi_file.ahi03,
        ima02         LIKE ima_file.ima02,
        ima021        LIKE ima_file.ima021,
        ima25         LIKE ima_file.ima25,
        ahi04         LIKE ahi_file.ahi04,
        ahi05         LIKE ahi_file.ahi05,
        ahi07         LIKE ahi_file.ahi07        #CHI-C30019
                      END RECORD,
    g_ahi_t           RECORD                 #程式變數 (舊值)
        ahi03         LIKE ahi_file.ahi03,
        ima02         LIKE ima_file.ima02,
        ima021        LIKE ima_file.ima021,
        ima25         LIKE ima_file.ima25,
        ahi04         LIKE ahi_file.ahi04,
        ahi05         LIKE ahi_file.ahi05,
        ahi07         LIKE ahi_file.ahi07         #CHI-C30019
                      END RECORD,
    a                 LIKE type_file.chr1,     #FUN-680021 add #No.FUN-680098 VARCHAR(1)
    g_wc,g_sql,g_wc2  STRING,
    g_show            LIKE type_file.chr1,   #No.FUN-680098 VARCHAR(1)
    g_rec_b           LIKE type_file.num5,   #No.FUN-680098 SMALLINT  #單身筆數
    g_flag            LIKE type_file.chr1,   #No.FUN-680098 VARCHAR(1)
    g_ss              LIKE type_file.chr1,   #No.FUN-680098 VARCHAR(1)
    l_ac              LIKE type_file.num5,   #No.FUN-680098 SMALLINT   #目前處理的ARRAY CNT
    g_argv1           LIKE ahi_file.ahi01,
    g_argv2           LIKE ahi_file.ahi02,
    g_argv3           LIKE ahi_file.ahi06    #CHI-C30119
DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-680098  SMALLINT
#主程式開始
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_sql_tmp    STRING   #No.TQC-720019
DEFINE   g_before_input_done   LIKE type_file.num5     #No.FUN-680098 SMALLINT
DEFINE   g_cnt                 LIKE type_file.num10    #No.FUN-680098 INTEGER
DEFINE   g_msg         LIKE ze_file.ze03  #No.FUN-680098    VARCHAR(72)
DEFINE   g_row_count   LIKE type_file.num10    #No.FUN-680098  INTEGER
DEFINE   g_curs_index  LIKE type_file.num10    #No.FUN-680098  INTEGER
DEFINE   l_cmd         LIKE type_file.chr1000  #No.FUN-780037 
MAIN
#       l_time   LIKE type_file.chr8          #No.FUN-6A0073
 
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
 
   LET g_argv1 =ARG_VAL(1)
   LET g_argv2 =ARG_VAL(2)
 
   LET p_row = 3 LET p_col = 16
 
   OPEN WINDOW i140_w AT p_row,p_col
     WITH FORM "agl/42f/agli140"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   IF NOT (cl_null(g_argv1) AND cl_null(g_argv2)) THEN
      CALL i140_q()
   END IF   
   CALL i140_menu()
 
   CLOSE WINDOW i140_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION i140_cs()
DEFINE l_sql STRING
DEFINE l_ahi06 LIKE ahi_file.ahi06
 
    IF NOT (cl_null(g_argv1) AND cl_null(g_argv2) AND cl_null(g_argv3)) THEN #CHI-C30119
       LET g_wc = " ahi01 = '",g_argv1,"'",
                  " AND ahi02 = '",g_argv2,"'"
                 ," AND ahi06 = '",g_argv3,"'"  #CHI-C30119
    ELSE
       CLEAR FORM                            #清除畫面
       CALL g_ahi.clear()
       CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
       INITIALIZE g_ahi01 TO NULL    #FUN-750051
       INITIALIZE g_ahi02 TO NULL    #FUN-750051
       INITIALIZE g_ahi06 TO NULL    #CHI-C30119
       CONSTRUCT g_wc ON ahi01,ahi02,ahi03,ahi04,ahi05
                        ,ahi06,ahi07                    #CHI-C30119
          FROM ahi01,ahi02,s_ahi[1].ahi03,s_ahi[1].ahi04,s_ahi[1].ahi05
              ,ahi06,s_ahi[1].ahi07                     #CHI-C30119
               
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No.FUN-580031 --end--       HCN
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(ahi03)
                CALL cl_init_qry_var()
                LET g_qryparam.form  ="q_ima"
                LET g_qryparam.state ="c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ahi03
                NEXT FIELD ahi03
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
 
       IF INT_FLAG THEN
          RETURN
       END IF
    END IF
 
    IF cl_null(g_wc) THEN
       LET g_wc="1=1"
    END IF
   #CHI-C30119-- 
   #LET l_sql="SELECT DISTINCT ahi01,ahi02 FROM ahi_file ",
   #           " WHERE ", g_wc CLIPPED
    LET l_sql="SELECT DISTINCT ahi01,ahi02,ahi06 FROM ahi_file ",
               " WHERE ", g_wc CLIPPED
   #CHI-C30119-- 
    LET g_sql= l_sql," ORDER BY ahi01"
    PREPARE i140_prepare FROM g_sql      #預備一下
    DECLARE i140_bcs                     #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i140_prepare
 
    DROP TABLE i140_cnttmp
#   LET l_sql=l_sql," INTO TEMP i140_cnttmp"      #No.TQC-720019
    LET g_sql_tmp=l_sql," INTO TEMP i140_cnttmp"  #No.TQC-720019
    
#   PREPARE i140_cnttmp_pre FROM l_sql       #No.TQC-720019
    PREPARE i140_cnttmp_pre FROM g_sql_tmp   #No.TQC-720019
    EXECUTE i140_cnttmp_pre    
    
    LET g_sql="SELECT COUNT(*) FROM i140_cnttmp"      
    
    PREPARE i140_precount FROM g_sql    
    DECLARE i140_count CURSOR FOR i140_precount
 
    IF NOT cl_null(g_argv1) THEN
       LET g_ahi01=g_argv1
    END IF
 
    IF NOT cl_null(g_argv2) THEN
       LET g_ahi02=g_argv2
    END IF
 
    CALL i140_show()
END FUNCTION
 
FUNCTION i140_menu()
 
   WHILE TRUE
      CALL i140_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_argv1) THEN
                  CALL i140_a()
               END IF
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i140_q()
            END IF
           WHEN "delete" 
              IF cl_chk_act_auth() THEN
                 CALL i140_r()
              END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i140_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i140_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "output"
            IF cl_chk_act_auth() THEN
               #No.FUN-780037---Begin      
               #CALL i140_out()
               IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF                   
               LET l_cmd = 'p_query "agli140" "',g_wc CLIPPED,'"'               
               CALL cl_cmdrun(l_cmd) 
               #No.FUN-780037---End
            END IF
        #start FUN-680021 add      
         WHEN "generate"     #整批產生
            IF cl_chk_act_auth() THEN
               CALL i140_g()
            END IF
        #end FUN-680021 add      
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_ahi),'','')
            END IF
         #No.FUN-6B0040-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_ahi01 IS NOT NULL THEN
                LET g_doc.column1 = "ahi01"
                LET g_doc.column2 = "ahi02"
                LET g_doc.value1 = g_ahi01
                LET g_doc.value2 = g_ahi02
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6B0040-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i140_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_ahi.clear()
   LET g_ahi01_t  = NULL
   LET g_ahi02_t  = NULL
   LET g_ahi06_t  = NULL   #CHI-C30119
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i140_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         LET g_ahi01=NULL
         LET g_ahi02=NULL
         LET g_ahi06=NULL                #CHI-C30119
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_ss='N' THEN
         CALL g_ahi.clear()
      ELSE
         CALL i140_b_fill('1=1')            #單身
      END IF
 
      CALL i140_b()                      #輸入單身
 
      LET g_ahi01_t = g_ahi01
      LET g_ahi02_t = g_ahi02
      LET g_ahi06_t = g_ahi06               #CHI-C30119
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i140_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,       #a:輸入 u:更改   #No.FUN-680098 VARCHAR(1)
    l_cnt           LIKE type_file.num10       #No.FUN-680098 INTEGER
DEFINE l_str        LIKE type_file.chr20       #CHI-C30119
 
    LET g_ss='Y'
 
   #LET g_ahi01=YEAR(g_today)                        #CHI-9A0027    
   #LET g_ahi02=MONTH(g_today)                       #CHI-9A0027                                                                                          
    CALL s_yp(g_today) RETURNING g_ahi01,g_ahi02     #CHI-9A0027    
    CALL cl_set_head_visible("","YES")               #FUN-6B0029 
    SELECT ccz28 INTO g_ahi06 FROM ccz_file          #CHI-C30119
 
    INPUT g_ahi01,g_ahi02,g_ahi06 WITHOUT DEFAULTS   #CHI-C30119
        FROM ahi01,ahi02,ahi06                       #CHI-C30119
 
       AFTER INPUT
          IF MDY(g_ahi02,1,g_ahi01) IS NULL THEN
             CALL cl_err('','agl-013',1)
             CONTINUE INPUT
          END IF
       
         #CHI-C30119--
          LET l_str= g_ahi01 USING '&&&&',g_ahi02 USING '&&','0001'
          #-->check 是否存在
          SELECT COUNT(*) INTO l_cnt FROM npp_file
           WHERE npp01 = l_str AND nppsys = 'CC' AND npptype= '0'
             AND npp00 = 1     AND npp011= 1
          IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
          IF l_cnt > 0 THEN
             IF NOT cl_confirm('agl1030') THEN    #是否確定執行 (Y/N) ?
                LET INT_FLAG = 1
             END IF
          END IF
         #CHI-C30119--
       
         ON ACTION CONTROLG
           CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
    END INPUT
 
END FUNCTION
 
FUNCTION i140_q()
   LET g_ahi01 = ''
   LET g_ahi02 = ''
   LET g_ahi06 = ''                         #CHI-C30119
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_ahi01,g_ahi02 TO NULL       #FUN-6B0040
   INITIALIZE g_ahi06 TO NULL               #CHI-C30119
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_ahi.clear()
   DISPLAY '' TO FORMONLY.cnt
 
   CALL i140_cs()                      #取得查詢條件
 
   IF INT_FLAG THEN                    #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_ahi01,g_ahi02 TO NULL
      INITIALIZE g_ahi06 TO NULL       #CHI-C30119
      RETURN
   END IF
 
   OPEN i140_bcs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_ahi01,g_ahi02 TO NULL
      INITIALIZE g_ahi06 TO NULL       #CHI-C30119
   ELSE
      OPEN i140_count
      FETCH i140_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i140_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i140_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,   #處理方式   #No.FUN-680098 VARCHAR(1)
   l_abso          LIKE type_file.num10   #絕對的筆數  #No.FUN-680098 integer
 
   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     i140_bcs INTO g_ahi01,g_ahi02,g_ahi06   #CHI-C30119
       WHEN 'P' FETCH PREVIOUS i140_bcs INTO g_ahi01,g_ahi02,g_ahi06   #CHI-C30119
       WHEN 'F' FETCH FIRST    i140_bcs INTO g_ahi01,g_ahi02,g_ahi06   #CHI-C30119
       WHEN 'L' FETCH LAST     i140_bcs INTO g_ahi01,g_ahi02,g_ahi06   #CHI-C30119
       WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
              
               ON ACTION about         #MOD-4C0121
                  CALL cl_about()      #MOD-4C0121
              
               ON ACTION help          #MOD-4C0121
                  CALL cl_show_help()  #MOD-4C0121
              
               ON ACTION controlg      #MOD-4C0121
                  CALL cl_cmdask()     #MOD-4C0121
              
            END PROMPT
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            FETCH ABSOLUTE l_abso i140_bcs INTO g_ahi01,g_ahi02,g_ahi06      #CHI-C30119
   END CASE
 
   IF SQLCA.sqlcode THEN                  #有麻煩
      CALL cl_err(g_ahi01,SQLCA.sqlcode,0)
      INITIALIZE g_ahi01 TO NULL  #TQC-6B0105
      INITIALIZE g_ahi02 TO NULL  #TQC-6B0105
      INITIALIZE g_ahi06 TO NULL  #CHI-C30119
   ELSE
      CALL i140_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = l_abso
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i140_show()
 
   DISPLAY g_ahi01 TO ahi01
   DISPLAY g_ahi02 TO ahi02
   DISPLAY g_ahi06 TO ahi06                  #CHI-C30119
 
   CALL i140_b_fill(g_wc)                      #單身
 
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i140_b()
DEFINE
   l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT #No.FUN-680098 smallint
   l_n             LIKE type_file.num5,          #檢查重複用        #No.FUN-680098   smallint
   l_lock_sw       LIKE type_file.chr1,          #單身鎖住否        #No.FUN-680098    VARCHAR(1)
   p_cmd           LIKE type_file.chr1,          #處理狀態          #No.FUN-680098 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,          #可新增否          #No.FUN-680098 SMALLINT
   l_allow_delete  LIKE type_file.num5,          #可刪除否          #No.FUN-680098 SMALLINT
   l_cnt           LIKE type_file.num10,         #No.FUN-680098  INTEGER
   l_n1            LIKE type_file.num5           #CHI-C30119
 
   LET g_action_choice = ""
 
   IF cl_null(g_ahi01) OR cl_null(g_ahi02) OR (g_ahi01=0) OR (g_ahi01=0) THEN
      CALL cl_err('',-400,1)
      RETURN     #No.TQC-680030 add
   END IF
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT ahi03,'','','',ahi04,ahi05,ahi07 FROM ahi_file",   #CHI-C30119
                      " WHERE ahi01 = ? AND ahi02 = ? AND ahi03= ? "
                     ,"   AND ahi06 = ? FOR UPDATE "                             #CHI-c30119
                      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i140_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   IF g_rec_b=0 THEN CALL g_ahi.clear() END IF
 
   INPUT ARRAY g_ahi WITHOUT DEFAULTS FROM s_ahi.*
 
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
        #CHI-C30119--
         IF g_ahi06 MATCHES'[12]' THEN
            CALL cl_set_comp_entry("ahi07",FALSE)
            LET g_ahi[l_ac].ahi07 = ' '
         ELSE 
            CALL cl_set_comp_entry("ahi07",TRUE)
         END IF
        #CHI-C30119--
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_ahi_t.* = g_ahi[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN i140_bcl USING g_ahi01,g_ahi02,g_ahi[l_ac].ahi03,g_ahi06        #CHI-C30119
            IF STATUS THEN
               CALL cl_err("OPEN i140_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i140_bcl INTO g_ahi[l_ac].*
               IF STATUS THEN
                  CALL cl_err("OPEN i140_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  CALL i140_set_ahi03(g_ahi[l_ac].ahi03) RETURNING g_ahi[l_ac].ima02,
                                                                   g_ahi[l_ac].ima021,
                                                                   g_ahi[l_ac].ima25
                  LET g_ahi_t.*=g_ahi[l_ac].*
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ahi[l_ac].* TO NULL            #900423
         LET g_ahi_t.* = g_ahi[l_ac].*               #新輸入資料
         LET g_ahi[l_ac].ahi04=0
         LET g_ahi[l_ac].ahi05=0
         CALL cl_show_fld_cont()
         NEXT FIELD ahi03
 
      AFTER FIELD ahi03                         # check data 是否重複
         IF NOT cl_null(g_ahi[l_ac].ahi03) THEN
            IF g_ahi[l_ac].ahi03 != g_ahi_t.ahi03 OR g_ahi_t.ahi03 IS NULL THEN
               LET l_cnt=0
               SELECT COUNT(*) INTO l_cnt FROM ima_file 
                     WHERE ima01=g_ahi[l_ac].ahi03
                       AND imaacti='Y'
               IF (SQLCA.sqlcode) OR (l_cnt=0) THEN
#                 CALL cl_err('',100,1)   #No.FUN-660138
                  CALL cl_err3("sel","ima_file",g_ahi[l_ac].ahi03,"",100,"","",1)  #No.FUN-660138
                  LET g_ahi[l_ac].ahi03=g_ahi_t.ahi03
                  LET g_ahi[l_ac].ima02=g_ahi_t.ima02
                  LET g_ahi[l_ac].ima021=g_ahi_t.ima021
                  LET g_ahi[l_ac].ima25=g_ahi_t.ima25
                  DISPLAY BY NAME g_ahi[l_ac].ahi03,g_ahi[l_ac].ima02,
                                  g_ahi[l_ac].ima021,g_ahi[l_ac].ima25
                  NEXT FIELD ahi03
               END IF
 
               LET l_cnt=0
               SELECT COUNT(*) INTO l_cnt FROM ahi_file
                                         WHERE ahi01 = g_ahi01
                                           AND ahi02 = g_ahi02
                                           AND ahi03 = g_ahi[l_ac].ahi03
               IF (l_cnt > 0) OR (SQLCA.sqlcode) THEN
                  CALL cl_err(g_ahi[l_ac].ahi03,-239,0)
                  LET g_ahi[l_ac].ahi03 = g_ahi_t.ahi03
                  LET g_ahi[l_ac].ima02 = g_ahi_t.ima02
                  LET g_ahi[l_ac].ima021= g_ahi_t.ima021
                  LET g_ahi[l_ac].ima25 = g_ahi_t.ima25
                  DISPLAY BY NAME g_ahi[l_ac].ahi03,
                                  g_ahi[l_ac].ima02,
                                  g_ahi[l_ac].ima021,
                                  g_ahi[l_ac].ima25
                  NEXT FIELD ahi03
               END IF
               CALL i140_set_ahi03(g_ahi[l_ac].ahi03) 
                   RETURNING g_ahi[l_ac].ima02,
                             g_ahi[l_ac].ima021,
                             g_ahi[l_ac].ima25
               DISPLAY BY NAME g_ahi[l_ac].ima02,
                               g_ahi[l_ac].ima021,
                               g_ahi[l_ac].ima25
            END IF
         ELSE
            LET g_ahi[l_ac].ima02 = null
            LET g_ahi[l_ac].ima021= null
            LET g_ahi[l_ac].ima25 = null
            DISPLAY BY NAME g_ahi[l_ac].ima02,g_ahi[l_ac].ima021,g_ahi[l_ac].ima25
         END IF
 
      AFTER FIELD ahi04
         IF NOT cl_null(g_ahi[l_ac].ahi04) THEN
            IF g_ahi[l_ac].ahi04<0 THEN
               CALL cl_err('','aim-391',1)
               NEXT FIELD ahi04
            END IF
         END IF
 
      AFTER FIELD ahi05
         IF NOT cl_null(g_ahi[l_ac].ahi05) THEN
            IF g_ahi[l_ac].ahi05<0 THEN
               CALL cl_err('','aim-391',1)
               NEXT FIELD ahi05
            END IF
         END IF
 
     #CHI-C30119--
      AFTER FIELD ahi07
         IF NOT cl_null(g_ahi[l_ac].ahi07) THEN
            IF p_cmd = "a" OR                    
              (p_cmd = "u" AND 
              (g_ahi01 != g_ahi01_t OR g_ahi02 != g_ahi02_t)) THEN
             
               CASE g_ahi[l_ac].ahi07
                  WHEN 4
                     SELECT pja02 FROM pja_file WHERE pja01 = g_ahi[l_ac].ahi07
                                                  AND pjaclose='N'
                     IF SQLCA.sqlcode!=0 THEN
                        CALL cl_err3('sel','pja_file',g_ahi[l_ac].ahi07,'',SQLCA.sqlcode,'','',1)
                       NEXT FIELD ahi07
                     END IF
                  WHEN 5
                     LET l_n1 = 0
                     SELECT count(*) INTO l_n1 FROM imd_file WHERE imd09 = g_ahi[l_ac].ahi07
                                                               AND imdacti = 'Y'
                     IF l_n1 = 0 THEN
                        CALL cl_err3('sel','imd_file',g_ahi[l_ac].ahi07,'',SQLCA.sqlcode,'','',1)
                        NEXT FIELD ahi07            
                     END IF
                  OTHERWISE EXIT CASE
               END CASE 
            END IF
         ELSE 
            LET g_ahi[l_ac].ahi07=' ' 
         END IF
     #CHI-C30119--
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #CKP2
            INITIALIZE g_ahi[l_ac].* TO NULL  #重要欄位空白,無效
            DISPLAY g_ahi[l_ac].* TO s_ahi.*
            CALL g_ahi.deleteElement(g_rec_b+1)
            ROLLBACK WORK
            EXIT INPUT
            #CANCEL INSERT
         END IF
        #CHI-C30119--
         IF g_ahi06 MATCHES'[12]' THEN
            LET g_ahi[l_ac].ahi07 = ' '
         END IF
        #CHI-C30119--
         INSERT INTO ahi_file(ahi01,ahi02,ahi03,ahi04,ahi05,ahi06,ahi07)               #CHI-C30119
              VALUES(g_ahi01,g_ahi02,g_ahi[l_ac].ahi03,g_ahi[l_ac].ahi04,g_ahi[l_ac].ahi05
                    ,g_ahi06,g_ahi[l_ac].ahi07)                                        #CHI-C30119
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ahi[l_ac].ahi02,SQLCA.sqlcode,0)   #No.FUN-660138
            CALL cl_err3("ins","ahi_file",g_ahi[l_ac].ahi03,'',SQLCA.sqlcode,"","",1)  #No.FUN-660138
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_ahi_t.ahi03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM ahi_file WHERE ahi01 = g_ahi01
                                   AND ahi02 = g_ahi02
                                   AND ahi03 = g_ahi_t.ahi03
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_ahi_t.ahi02,SQLCA.sqlcode,0)   #No.FUN-660138
               CALL cl_err3("del","ahi_file",g_ahi[l_ac].ahi03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660138
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
            LET g_ahi[l_ac].* = g_ahi_t.*
            CLOSE i140_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ahi[l_ac].ahi03,-263,1)
            LET g_ahi[l_ac].* = g_ahi_t.*
         ELSE
            UPDATE ahi_file SET ahi03 = g_ahi[l_ac].ahi03,
                                ahi04 = g_ahi[l_ac].ahi04,
                                ahi05 = g_ahi[l_ac].ahi05,
                                ahi07 = g_ahi[l_ac].ahi07       #CHI-C30119
                                 WHERE ahi01 = g_ahi01
                                   AND ahi02 = g_ahi02
                                   AND ahi03 = g_ahi_t.ahi03
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_ahi[l_ac].ahi02,SQLCA.sqlcode,0)   #No.FUN-660138
               CALL cl_err3("upd","ahi_file",g_ahi[l_ac].ahi03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660138
               LET g_ahi[l_ac].* = g_ahi_t.*
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
            IF p_cmd = 'u' THEN
               LET g_ahi[l_ac].* = g_ahi_t.*
            #FUN-D30032--add--begin--
            ELSE
               CALL g_ahi.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end----
            END IF
            CLOSE i140_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30032 add
         CLOSE i140_bcl
         COMMIT WORK
         #CKP2
         CALL g_ahi.deleteElement(g_rec_b+1)
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ahi03)
               CALL cl_init_qry_var()
               LET g_qryparam.form  ="q_ima"
               CALL cl_create_qry() RETURNING g_ahi[l_ac].ahi03
               DISPLAY BY NAME g_ahi[l_ac].ahi03
               NEXT FIELD ahi03	
           #CHI-C30119
            WHEN INFIELD(ahi07)   
               IF g_ahi06 MATCHES '[45]' THEN    
                  CALL cl_init_qry_var()          
               CASE g_ahi06                  
                  WHEN '4'                                         
                    LET g_qryparam.form = "q_pja"                   
                  WHEN '5'
                    LET g_qryparam.form = "q_imd09"
                  OTHERWISE EXIT CASE
               END CASE
               LET g_qryparam.default1 = g_ahi[l_ac].ahi07
               CALL cl_create_qry() RETURNING g_ahi[l_ac].ahi07              
               DISPLAY BY NAME g_ahi[l_ac].ahi07
               NEXT FIELD ahi07 
               END IF
            OTHERWISE EXIT CASE
           #CHI-C30119
         END CASE
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(ahi02) AND l_ac > 1 THEN
            LET g_ahi[l_ac].* = g_ahi[l_ac-1].*
            LET g_ahi[l_ac].ahi03=null
            NEXT FIELD ahi03
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
 
   CLOSE i140_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i140_b_fill(p_wc)                     #BODY FILL UP
DEFINE p_wc STRING
DEFINE l_n    LIKE type_file.num5           #CHI-C30119
 
  #CHI-C30119--
   LET l_n = 0
   SELECT count(*) INTO l_n FROM ahi_file
    WHERE ahi01 = g_ahi01 AND ahi02 = g_ahi02 AND ahi06 <> g_ahi06
   IF l_n > 0 THEN
       DELETE FROM ahi_file WHERE ahi01=g_ahi01 AND ahi02=g_ahi02
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
          CALL cl_err3("del","ahi_file",g_ahi01,g_ahi02,SQLCA.sqlcode,"","del ahi",1)
          RETURN
       END IF
   END IF
  #CHI-C30119--
   LET g_sql = "SELECT ahi03,'','','',ahi04,ahi05,ahi07",    #CHI-C30119
               " FROM ahi_file ",
               " WHERE ahi01 = '",g_ahi01,"'",
               "   AND ahi02 = '",g_ahi02,"'",
               "   AND ahi06 = '",g_ahi06,"'",               #CHI-C30119
               "   AND ",p_wc CLIPPED ,
               " ORDER BY ahi03"
   PREPARE i140_prepare2 FROM g_sql       #預備一下
   DECLARE ahi_cs CURSOR FOR i140_prepare2
 
   CALL g_ahi.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH ahi_cs INTO g_ahi[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL i140_set_ahi03(g_ahi[g_cnt].ahi03) RETURNING 
                                          g_ahi[g_cnt].ima02,
                                          g_ahi[g_cnt].ima021,
                                          g_ahi[g_cnt].ima25
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_ahi.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i140_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680098  VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ahi TO s_ahi.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i140_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i140_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i140_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i140_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i140_fetch('L')
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
      
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
     #start FUN-680021 add      
    #@ON ACTION 整批產生
      ON ACTION generate
         LET g_action_choice="generate"
         EXIT DISPLAY
     #end FUN-680021 add      
 
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
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6B0040  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#start FUN-680021 add
FUNCTION i140_g()        #整批產生 
   DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-680098   SMALLINT
   DEFINE tm             RECORD
                          wc    STRING,
                          yy    LIKE ahi_file.ahi01,   #年度
                          mm    LIKE ahi_file.ahi02,   #期別
                          a     LIKE type_file.chr1,   #單價基準 #No.FUN-680098 VARCHAR(1)
                          b     LIKE aao_file.aao05,   #固定比率 #No.FUN-680098 DEC(15,3)
                          type  LIKE type_file.chr1    #CHI-B60093 add 
                         END RECORD
   DEFINE l_sql          STRING
   DEFINE l_cnt          LIKE type_file.num5    #No.FUN-680098   SMALLINT
   DEFINE last_yy        LIKE ahi_file.ahi01           #上期年度
   DEFINE last_mm        LIKE ahi_file.ahi02           #上期期別 
   DEFINE sr             RECORD
                         ahi03 LIKE ahi_file.ahi03,   #料號
                         ahi04 LIKE ahi_file.ahi04,   #成本單價
                         ahi05 LIKE ahi_file.ahi05,   #內部單價
                         ahi07 LIKE ahi_file.ahi07    #CHI-C30119
                         END RECORD
   DEFINE l_ahi          RECORD LIKE ahi_file.*        #利潤中心內部定價檔
   DEFINE l_ccc23,l_ccc232      LIKE ccc_file.ccc23    #CHI-B60093 add
   DEFINE l_n            LIKE type_file.num5           #CHI-C30119
   DEFINE l_str          LIKE type_file.chr20          #CHI-C30119
   LET p_row = 6 LET p_col = 6
 
   OPEN WINDOW i140_w_g AT p_row,p_col WITH FORM "agl/42f/agli140_g"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("agli140_g")
 
   INITIALIZE tm.* TO NULL
   LET tm.yy = YEAR(g_today)
   LET tm.mm = MONTH(g_today)
   LET tm.a  = '1'   #1.依成本價(ccc23)再加固定% 2依上期單價
   LET tm.b  = 0
   SELECT ccz28 INTO g_ccz.ccz28 FROM ccz_file WHERE ccz00='0'     #CHI-B60093 add
   LET tm.type = g_ccz.ccz28                                       #CHI-B60093 add
 
  WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima01,ima08,ima06,ima131
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ima01)   #料號
               CALL cl_init_qry_var()
               LET g_qryparam.form  ="q_ima"
               LET g_qryparam.state ="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO FORMONLY.ima01
               NEXT FIELD ima01
            WHEN INFIELD(ima06)   #分群碼
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_imz"
               LET g_qryparam.state ="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO FORMONLY.ima06
               NEXT FIELD ima06
            WHEN INFIELD(ima131)   #產品分類
               CALL cl_init_qry_var()
               LET g_qryparam.form  ="q_oba"
               LET g_qryparam.state ="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO FORMONLY.ima131
               NEXT FIELD ima131
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
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW i140_w_g
      RETURN
   END IF
 
   INPUT BY NAME tm.yy,tm.mm,tm.a,tm.b,tm.type WITHOUT DEFAULTS         #CHI-B60093 add tm.type
      AFTER FIELD yy
         IF cl_null(tm.yy) THEN
            CALL cl_err(tm.yy,'mfg5103',0)
            NEXT FIELD yy
         END IF
 
      AFTER FIELD mm
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.mm > 12 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            ELSE
               IF tm.mm > 13 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
         IF cl_null(tm.mm) THEN
            CALL cl_err(tm.mm,'mfg5103',0)
            NEXT FIELD mm
         END IF
 
      BEFORE FIELD a
         CALL i140_set_entry('a')
 
      AFTER FIELD a
         LET a = tm.a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[12]' THEN
            CALL cl_err(tm.a,'-1152',0)
            NEXT FIELD a
         END IF
         CALL i140_set_no_entry('a')
 
      AFTER FIELD b
         IF cl_null(tm.b) OR tm.b<0 OR tm.b>100 THEN
            CALL cl_err('','mfg0013',1)
            NEXT FIELD b
         END IF

      #CHI-B60093 --- modify --- start ---
      AFTER FIELD type
         IF cl_null(tm.type) THEN NEXT FIELD type END IF
         IF tm.type NOT MATCHES '[12345]' THEN
            LET tm.type = g_ccz.ccz28
            NEXT FIELD type
         END IF
      #CHI-B60093 --- modify ---  end  ---
 
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
      CLOSE WINDOW i140_w_g
      RETURN
   END IF
 
   IF NOT cl_confirm('abx-080') THEN    #是否確定執行 (Y/N) ?
      CLOSE WINDOW i140_w_g
      RETURN
   END IF
 
     #CHI-C30119--
      LET l_str= tm.yy USING '&&&&',tm.mm USING '&&','0001'
      #-->check 是否存在
      SELECT COUNT(*) INTO l_cnt FROM npp_file
       WHERE npp01 = l_str AND nppsys = 'CC' AND npptype= '0'
         AND npp00 = 1     AND npp011= 1
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
      IF l_cnt > 0 THEN
         IF NOT cl_confirm('agl1030') THEN    #是否確定執行 (Y/N) ?
            CLOSE WINDOW i140_w_g
            RETURN
         END IF
         
      END IF
     #CHI-C30119--
 
   LET l_sql = "SELECT COUNT(ahi03)",
               "  FROM ahi_file,ima_file",
               " WHERE ahi03=ima01",
               "   AND ahi01=",tm.yy,
               "   AND ahi02=",tm.mm,
                  "   AND ahi06=",tm.type,                    #CHI-C30119
               "   AND ",tm.wc CLIPPED
   PREPARE i140_g_p0 FROM l_sql
   IF STATUS THEN CALL cl_err('i140_g_p0:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-690114
      EXIT PROGRAM 
   END IF
   DECLARE i140_g_c0 CURSOR FOR i140_g_p0
   OPEN i140_g_c0
   FETCH i140_g_c0 INTO l_cnt
   #當l_cnt>0表示已存在此料號資料,詢問是否要繼續,否則跳出
   IF l_cnt > 0 THEN 
      #部份料件條件範圍資料已存在,僅產生未存在資料,已存在資料不再異動!是否繼續執行(Y/N)?
      IF NOT cl_confirm('agl-942') THEN    
         CLOSE WINDOW i140_w_g
         RETURN
      END IF
   END IF
 
   MESSAGE " Working ...."
 
   IF tm.a = '1' THEN     #1.依成本價(ccc23)再加固定%

     #LET l_sql = "SELECT ccc01,ccc23,ccc23*(1+",tm.b,"/100)",                        #CHI-B60093 mark
     #LET l_sql = "SELECT ccc01,AVG(ccc23),AVG(ccc23)*(1+",tm.b,"/100)",            #CHI-C30119 mark #CHI-B60093 add
      LET l_sql = "SELECT ccc01,AVG(ccc23),AVG(ccc23)*(1+",tm.b,"/100),ccc08",      #CHI-C30119 add #CHI-B60093 add
                  "  FROM ccc_file,ima_file",
                  " WHERE ccc01=ima01",
                  "   AND ccc02=",tm.yy,
                  "   AND ccc03=",tm.mm,
                 #"   AND ccc07='1' ",      #No.FUN-840041   #CHI-B60093 mark
                  "   AND ccc07= ",tm.type, #CHI-B60093 add
                  "   AND ",tm.wc CLIPPED,  #CHI-B60093 add
                  " GROUP BY ccc01,ccc08"   #CHI-C30119 #CHI-B60093 add 
 
   ELSE                   #2.依上期單價
      CALL s_lsperiod(tm.yy,tm.mm) RETURNING last_yy,last_mm   #上期年月
         LET l_sql = "SELECT ahi03,ahi04,ahi05,ahi07",            #CHI-C30119
                  "  FROM ahi_file,ima_file",
                  " WHERE ahi03=ima01",
                  "   AND ahi01=",last_yy,
                  "   AND ahi02=",last_mm,
                     "   AND ahi06=",tm.type,                     #CHI-C30119
                  "   AND ",tm.wc CLIPPED
   END IF
   PREPARE i140_g_p1 FROM l_sql
   DECLARE i140_g_c1 CURSOR FOR i140_g_p1
     #CHI-C30119--
      SELECT count(*) INTO l_n FROM ahi_file
       WHERE ahi01 = tm.yy AND ahi02 = tm.mm AND ahi06 <> tm.type 
      IF l_n > 0 THEN
          DELETE FROM ahi_file WHERE ahi01=tm.yy AND ahi02=tm.mm
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
             CALL cl_err3("del","ahi_file",g_ahi01,g_ahi02,SQLCA.sqlcode,"","del ahi",1)
             RETURN
          END IF
      END IF
     #CHI-C30119--
   FOREACH i140_g_c1 INTO sr.* 
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) 
         CLOSE WINDOW i140_w_g 
         RETURN
      END IF
 
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM ahi_file 
       WHERE ahi01=tm.yy AND ahi02=tm.mm AND ahi03=sr.ahi03
            AND ahi06 = tm.type AND ahi07 = sr.ahi07                     #CHI-C30119
      IF l_cnt > 0 THEN CONTINUE FOREACH END IF
 
      LET l_ahi.ahi01 =tm.yy                   #年度
      LET l_ahi.ahi02 =tm.mm                   #期別
      LET l_ahi.ahi03 =sr.ahi03                #料號
      LET l_ahi.ahi04 =sr.ahi04                #成本單價
      LET l_ahi.ahi05 =sr.ahi05                #內部單價
         LET l_ahi.ahi06 =tm.type                 #CHI-C30119
         LET l_ahi.ahi07 =sr.ahi07                #CHI-C30119
      INSERT INTO ahi_file VALUES (l_ahi.* )
      IF STATUS THEN
         CALL cl_err3("ins","ahi_file",l_ahi.ahi01,l_ahi.ahi02,STATUS,"","ins_ahi:",1)
         CLOSE WINDOW i140_w_g
         RETURN
      END IF
   END FOREACH
   EXIT WHILE
  END WHILE
  MESSAGE ""
  CLOSE WINDOW i140_w_g
END FUNCTION
#end FUN-680021 add
 
FUNCTION i140_copy()
DEFINE
   l_n             LIKE type_file.num5,   #No.FUN-680098   smallint
   l_cnt           LIKE type_file.num10,  #No.FUN-680098   INTEGER
   l_newno1,l_oldno1  LIKE ahi_file.ahi01,
   l_newno2,l_oldno2  LIKE ahi_file.ahi02
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_ahi01) OR cl_null(g_ahi02) OR (g_ahi01=0) OR (g_ahi01=0) THEN
      CALL cl_err('',-400,1)
      RETURN     #No.TQC-680030 add
   END IF
 
   DISPLAY " " TO ahi01
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
   INPUT l_newno1,l_newno2 FROM ahi01,ahi02
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         
         IF MDY(g_ahi02,1,g_ahi01) IS NULL THEN
            CALL cl_err('','agl-013',1)
            CONTINUE INPUT
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
      DISPLAY g_ahi01 TO ahi01
      DISPLAY g_ahi02 TO ahi02
      RETURN
   END IF
 
   DROP TABLE i140_x
 
   SELECT * FROM ahi_file             #單身複製
    WHERE ahi01 = g_ahi01
      AND ahi02 = g_ahi02
     INTO TEMP i140_x
   IF SQLCA.sqlcode THEN
      LET g_msg=l_newno1 CLIPPED
#     CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660138
      CALL cl_err3("ins","i140_x",g_ahi01,g_ahi02,SQLCA.sqlcode,"","",1)  #No.FUN-660138
      RETURN
   END IF
 
   UPDATE i140_x SET ahi01=l_newno1,
                     ahi02=l_newno2
 
   INSERT INTO ahi_file SELECT * FROM i140_x
   IF SQLCA.sqlcode THEN
      LET g_msg=l_newno1 CLIPPED
#     CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660138
      CALL cl_err3("ins","ahi_file",l_newno1,l_newno2,SQLCA.sqlcode,"",g_msg,1)  #No.FUN-660138
      RETURN
   ELSE
      MESSAGE 'COPY O.K'
      LET g_ahi01=l_newno1
      LET g_ahi02=l_newno2
      CALL i140_show()
   END IF
 
END FUNCTION
 
FUNCTION i140_set_ahi03(p_ahi03)
DEFINE p_ahi03 LIKE ahi_file.ahi03,
       l_ima02 LIKE ima_file.ima02,
       l_ima021 LIKE ima_file.ima021,
       l_ima25 LIKE ima_file.ima25
 
   SELECT ima02,ima021,ima25 INTO l_ima02,l_ima021,l_ima25 FROM ima_file
       WHERE ima01=p_ahi03
   IF SQLCA.sqlcode THEN
      LET l_ima02=null
      LET l_ima021=null
      LET l_ima25=null
   END IF
   RETURN l_ima02,l_ima021,l_ima25
END FUNCTION
 
FUNCTION i140_GETLASTDAY(p_date)
DEFINE p_date   LIKE type_file.dat      #No.FUN-680098 DATE
   IF p_date IS NULL OR p_date=0 THEN
      RETURN 0
   END IF
   IF MONTH(p_date)=12 THEN
      RETURN MDY(1,1,YEAR(p_date)+1)-1
   ELSE
      RETURN MDY(MONTH(p_date)+1,1,YEAR(p_date))-1
   END IF
END FUNCTION
 
FUNCTION i140_r()
   IF cl_null(g_ahi01) OR cl_null(g_ahi02) OR (g_ahi01=0) OR (g_ahi01=0) THEN
      CALL cl_err('',-400,1)
      RETURN     #No.TQC-680030 add
   END IF
   IF NOT cl_delh(20,16) THEN RETURN END IF
   INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
   LET g_doc.column1 = "ahi01"      #No.FUN-9B0098 10/02/24
   LET g_doc.column2 = "ahi02"      #No.FUN-9B0098 10/02/24
   LET g_doc.column3 = "ahi06"      #No.CHI-C30119
   LET g_doc.value1 = g_ahi01       #No.FUN-9B0098 10/02/24
   LET g_doc.value2 = g_ahi02       #No.FUN-9B0098 10/02/24
   LET g_doc.value3 = g_ahi06       #No.CHI-C30119
   CALL cl_del_doc()                                                          #No.FUN-9B0098 10/02/24
   DELETE FROM ahi_file WHERE ahi01=g_ahi01
                          AND ahi02=g_ahi02
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#     CALL cl_err('del ahi',SQLCA.sqlcode,1)   #No.FUN-660138
      CALL cl_err3("del","ahi_file",g_ahi01,g_ahi02,SQLCA.sqlcode,"","del ahi",1)  #No.FUN-660138
      RETURN      
   END IF   
 
   INITIALIZE g_ahi01,g_ahi02 TO NULL
   INITIALIZE g_ahi06 TO NULL               #CHI-C30119
   MESSAGE ""
   DROP TABLE i140_cnttmp                   #No.TQC-720019
   PREPARE i140_precount_x2 FROM g_sql_tmp  #No.TQC-720019
   EXECUTE i140_precount_x2                 #No.TQC-720019
   OPEN i140_count
   #FUN-B50062-add-start--
   IF STATUS THEN
      CLOSE i140_bcs
      CLOSE i140_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50062-add-end--
   FETCH i140_count INTO g_row_count
   #FUN-B50062-add-start--
   IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
      CLOSE i140_bcs
      CLOSE i140_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50062-add-end--
   DISPLAY g_row_count TO FORMONLY.cnt
   IF g_row_count>0 THEN
      OPEN i140_bcs
      CALL i140_fetch('F') 
   ELSE
      DISPLAY g_ahi01 TO ahi01
      DISPLAY g_ahi02 TO ahi02
      DISPLAY 0 TO FORMONLY.cn2
      CALL g_ahi.clear()
      CALL i140_menu()
   END IF                      
END FUNCTION
 
#No.FUN-780037---Begin
{
FUNCTION i140_out()
    DEFINE
        sr              RECORD LIKE ahi_file.*,
        l_i             LIKE type_file.num5,    #No.FUN-680098 SMALLINT
        l_name          LIKE type_file.chr20,   # External(Disk) file name #No.FUN-680098 VARCHAR(20)
        l_za05          LIKE za_file.za05       # #No.FUN-680098 VARCHAR(40)
   
    IF g_wc IS NULL THEN 
       IF (g_ahi01>0) AND (g_ahi02>0) THEN
          LET g_wc=" ahi01=",g_ahi01,
                   " AND ahi02=",g_ahi02
       ELSE
          CALL cl_err('',-400,0)
          RETURN 
       END IF
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM ahi_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED,
              " ORDER BY ahi01,ahi02,ahi03"
    PREPARE i140_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i140_co                         # SCROLL CURSOR
         CURSOR FOR i140_p1
 
    CALL cl_outnam('agli140') RETURNING l_name
    START REPORT i140_rep TO l_name
 
    FOREACH i140_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)    
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i140_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i140_rep
 
    CLOSE i140_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i140_rep(sr)
    DEFINE
        l_trailer_sw   LIKE type_file.chr1,      #No.FUN-680098  VARCHAR(1),
        sr RECORD LIKE ahi_file.*,
        l_ima02   LIKE ima_file.ima02,
        l_ima021  LIKE ima_file.ima021,
        l_ima25   LIKE ima_file.ima25
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.ahi01,sr.ahi02,sr.ahi03
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
                  g_x[36],g_x[37],g_x[38]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            SELECT ima02,ima021,ima25 INTO 
                 l_ima02,l_ima021,l_ima25 
                FROM ima_file WHERE ima01=sr.ahi03
            IF SQLCA.sqlcode THEN
               LET l_ima02 =NULL
               LET l_ima021=NULL
            END IF
            PRINT COLUMN g_c[31],sr.ahi01 USING "####",
                  COLUMN g_c[32],sr.ahi02 USING "####",
                  COLUMN g_c[33],sr.ahi03,
                  COLUMN g_c[34],l_ima02,
                  COLUMN g_c[35],l_ima021,
                  COLUMN g_c[36],l_ima25,
                  COLUMN g_c[37],cl_numfor(sr.ahi04,37,6),
                  COLUMN g_c[38],cl_numfor(sr.ahi05,38,6),
                  COLUMN g_c[39],cl_numfor(sr.ahi07,39,6)       #CHI-C30119 
 
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
END REPORT
}
#No.FUN-780037---End
#start FUN-680021 add
FUNCTION i140_set_entry(p_cmd)
   DEFINE p_cmd  LIKE type_file.chr1    #No.FUN-680098  VARCHAR(01)
 
   IF INFIELD(a) OR ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("b",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i140_set_no_entry(p_cmd)
   DEFINE p_cmd  LIKE type_file.chr1     #No.FUN-680098  VARCHAR(01)
 
   IF INFIELD(a) OR ( NOT g_before_input_done ) THEN
      IF a != '1' THEN
         CALL cl_set_comp_entry("b",FALSE)
      END IF
   END IF
END FUNCTION
#end FUN-680021 add
