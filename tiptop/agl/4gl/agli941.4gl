# Prog. Version..: '5.30.06-13.04.22(00003)'     #
# Pattern name...: agli941.4gl
# Descriptions...: 現金流量表活動科目設定 
# Date & Author..: 12/03/07 By Lori(FUN-BC0123)
# Modify.........: No:MOD-D10287 13/01/30 By apo 修正l_ac的值為0時造成CALL i941_giw()錯誤之問題
# Modify.........: No:FUN-D30032 13/04/01 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
DATABASE ds
#FUN-BC0123

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    g_giw00         LIKE giw_file.giw00,
    g_giw01         LIKE giw_file.giw01,   #活動類別(假單頭)
    g_giw00_t       LIKE giw_file.giw00,   #活動類別(舊值)
    g_giw01_t       LIKE giw_file.giw01,   #活動類別(舊值)
    g_giw           DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
        giw02       LIKE giw_file.giw02,   #科目編號
        aag02       LIKE aag_file.aag02,   #科目名稱
        giw03       LIKE giw_file.giw03,   #加減項
        giw04       LIKE giw_file.giw04    #異動別
                    END RECORD,
    g_giw_t         RECORD                 #程式變數 (舊值)
        giw02       LIKE giw_file.giw02,   #科目編號
        aag02       LIKE aag_file.aag02,   #科目名稱
        giw03       LIKE giw_file.giw03,   #加減項
        giw04       LIKE giw_file.giw04    #異動別
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,
    g_sql_tmp           STRING,
    g_rec_b         LIKE type_file.num5,    #單身筆數
    g_delete        LIKE type_file.chr1,    #若刪除資料,則要重新顯示筆數
    l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT
DEFINE g_str        STRING
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE g_before_input_done  LIKE type_file.num5
DEFINE   g_cnt           LIKE type_file.num10
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose
DEFINE   g_msg           LIKE ze_file.ze03
DEFINE   g_row_count     LIKE type_file.num10
DEFINE   g_curs_index    LIKE type_file.num10
DEFINE   g_jump          LIKE type_file.num10
DEFINE   mi_no_ask       LIKE type_file.num5

MAIN
DEFINE
   p_row,p_col     LIKE type_file.num5    #開窗的位置
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   LET p_row = ARG_VAL(2)
   LET p_col = ARG_VAL(3)
   LET g_giw01      = NULL                #清除鍵值
   LET g_giw01_t    = NULL
   LET g_giw00      = NULL                #清除鍵值
   LET g_giw00_t    = NULL
   LET p_row = 3 LET p_col = 14
       
   OPEN WINDOW i941_w AT p_row,p_col      #顯示畫面
     WITH FORM "agl/42f/agli941"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
   LET g_forupd_sql = " SELECT * FROM giw_file ",
                      " WHERE giw00 = ? ",
                      "   AND giw01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i941_cl CURSOR FROM g_forupd_sql
   LET g_delete = 'N'
   CALL i941_menu()
   CLOSE WINDOW i941_w                    #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#QBE 查詢資料
FUNCTION i941_cs()
   CLEAR FORM                                   #清除畫面
      CALL g_giw.clear()
   CALL cl_set_head_visible("","YES")

   INITIALIZE g_giw00 TO NULL
   INITIALIZE g_giw01 TO NULL
   CONSTRUCT g_wc ON giw00,giw01,giw02,giw03,giw04    #螢幕上取條件
       FROM giw00,giw01,s_giw[1].giw02,s_giw[1].giw03,s_giw[1].giw04

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION controlp                 # 沿用所有欄位
         CASE
          WHEN INFIELD(giw00)                                                                                                       
             CALL cl_init_qry_var()                                                                                                 
             LET g_qryparam.state = "c"                                                                                             
             LET g_qryparam.form ="q_aaa"                                                                                           
             CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                     
             DISPLAY g_qryparam.multiret TO giw00                                                                                   
             NEXT FIELD giw00                                                                                                       

            WHEN INFIELD(giw01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_giq"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO giw01
               NEXT FIELD giw01 
            WHEN INFIELD(giw02)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_aag"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO giw02
               CALL i941_giw()
               NEXT FIELD giw02
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

      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION qbe_save
         CALL cl_qbe_save()

   END CONSTRUCT

   IF INT_FLAG THEN RETURN END IF
   LET g_sql="SELECT UNIQUE giw00,giw01 FROM giw_file ", # 組合出SQL 指令,看giw01有幾種就run幾次
             " WHERE ", g_wc CLIPPED,
             " ORDER BY 1"
   PREPARE i941_prepare FROM g_sql              #預備一下
   DECLARE i941_b_cs                            #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR i941_prepare
                                                #計算本次查詢單頭的筆數
   LET g_sql_tmp= "SELECT UNIQUE giw00,giw01 FROM giw_file ",                                                          
                  " WHERE ",g_wc CLIPPED,                                                                                           
                  "   INTO TEMP x"                                                                                                  
   DROP TABLE x                                                                                                                     
   PREPARE i941_pre_x FROM g_sql_tmp                                                                                   
   EXECUTE i941_pre_x                                                                                                               
   LET g_sql = "SELECT COUNT(*) FROM x"                                                                                             
   PREPARE i941_precount FROM g_sql
   DECLARE i941_count CURSOR FOR i941_precount
END FUNCTION

FUNCTION i941_menu()

   WHILE TRUE
      CALL i941_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i941_a()
            END IF
         WHEN "modify"                          # u.更新
            IF cl_chk_act_auth() THEN
               CALL i941_u()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i941_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i941_b()
            ELSE
               LET g_action_choice = NULL
            END IF
           WHEN "delete"
            IF cl_chk_act_auth() THEN
                CALL i941_r()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_giw00 IS NULL OR g_giw01 IS NOT NULL THEN
                  LET g_doc.column1 = "giw01"
                  LET g_doc.value1 = g_giw01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_giw),'','')
            END IF

      END CASE
   END WHILE
END FUNCTION

#Add  輸入
FUNCTION i941_a()
DEFINE   l_n    LIKE type_file.num5
   
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   MESSAGE ""
   CLEAR FORM
      CALL g_giw.clear()
   INITIALIZE g_giw01 LIKE giw_file.giw01
   LET g_giw01_t = NULL
   INITIALIZE g_giw00 LIKE giw_file.giw00
   LET g_giw00_t = NULL
   #預設值及將數值類變數清成零
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i941_i("a")                           #輸入單頭
      IF INT_FLAG THEN                           #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      CALL g_giw.clear()
      SELECT COUNT(*) INTO l_n FROM giw_file WHERE giw01=g_giw01
                                               AND giw00=g_giw00
      LET g_rec_b = 0
      IF l_n > 0 THEN
         CALL i941_b_fill('1=1')
      END IF
      CALL i941_b()                             #輸入單身
      LET g_giw00_t = g_giw00                   #保留舊值
      LET g_giw01_t = g_giw01                   #保留舊值
      EXIT WHILE
   END WHILE
END FUNCTION

#處理INPUT
FUNCTION i941_i(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,         #a:輸入 u:更改
   l_cnt           LIKE type_file.num5

   CALL cl_set_head_visible("","YES")

   INPUT g_giw00,g_giw01 WITHOUT DEFAULTS FROM giw00,giw01
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i941_set_entry(p_cmd)
         CALL i941_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE

      AFTER FIELD giw00 
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM aaa_file 
           WHERE aaa01 = g_giw00 AND 
                 aaaacti = 'Y'
         IF l_cnt = 0 THEN
            CALL cl_err('','agl-095',0)   
            NEXT FIELD giw00
         END IF

      AFTER FIELD giw01                  #設定活動類別
         IF NOT cl_null(g_giw01) THEN
            CALL i941_giw01('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD giw01
            END IF
         END IF

      ON ACTION controlp                 # 沿用所有欄位
         CASE
            WHEN INFIELD(giw00)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa"
               LET g_qryparam.default1 = g_giw00
               CALL cl_create_qry() RETURNING g_giw00
               DISPLAY BY NAME g_giw00
               NEXT FIELD giw00 
            WHEN INFIELD(giw01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_giq"
               LET g_qryparam.default1 = g_giw01
               CALL cl_create_qry() RETURNING g_giw01
               DISPLAY BY NAME g_giw01
               NEXT FIELD giw01 
            OTHERWISE
               EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
   END INPUT
END FUNCTION

FUNCTION i941_giw01(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,
   l_giq02    LIKE giq_file.giq02

   LET g_errno=''
   SELECT giq02 INTO l_giq02
     FROM giq_file
    WHERE giq01=g_giw01
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='agl-917'
                                LET l_giq02=NULL
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN

     DISPLAY l_giq02 TO FORMONLY.giq02 
   END IF
END FUNCTION
#Query 查詢
FUNCTION i941_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_giw00,g_giw01 TO NULL
   MESSAGE ""
   CALL cl_opmsg('q')
   CALL i941_cs()                         #取得查詢條件
   IF INT_FLAG THEN                       #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i941_b_cs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                  #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_giw00,g_giw01 TO NULL
   ELSE
      CALL i941_fetch('F')               #讀出TEMP第一筆並顯示
      OPEN i941_count
      FETCH i941_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
   END IF
END FUNCTION

#處理資料的讀取
FUNCTION i941_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,                 #處理方式
   l_abso          LIKE type_file.num10                 #絕對的筆數

    MESSAGE ""
    CASE p_flag
       WHEN 'N' FETCH NEXT     i941_b_cs INTO g_giw00,g_giw01
       WHEN 'P' FETCH PREVIOUS i941_b_cs INTO g_giw00,g_giw01
       WHEN 'F' FETCH FIRST    i941_b_cs INTO g_giw00,g_giw01
       WHEN 'L' FETCH LAST     i941_b_cs INTO g_giw00,g_giw01
       WHEN '/' 
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0
               PROMPT g_msg CLIPPED,': ' FOR g_jump
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
            FETCH ABSOLUTE g_jump i941_b_cs INTO g_giw00,g_giw01
            LET mi_no_ask = FALSE
   END CASE
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_giw01,SQLCA.sqlcode,0)
      INITIALIZE g_giw01 TO NULL
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

   CALL i941_show()
END FUNCTION

#將資料顯示在畫面上
FUNCTION i941_show()
   DISPLAY g_giw00 TO giw00               #單頭 #No.FUN-740020
   DISPLAY g_giw01 TO giw01               #單頭
   CALL i941_giw01('d')
   CALL i941_b_fill(g_wc)                 #單身
   CALL cl_show_fld_cont()
END FUNCTION

#取消整筆 (所有合乎單頭的資料)
FUNCTION i941_r()
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   IF g_giw01 IS NULL THEN
      RETURN
   END IF
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
      INITIALIZE g_doc.* TO NULL
      LET g_doc.column1 = "giw00"
      LET g_doc.value1 = g_giw00
      LET g_doc.column1 = "giw01"
      LET g_doc.value1 = g_giw01
      CALL cl_del_doc()
      DELETE FROM giw_file WHERE giw00 = g_giw00
                             AND giw01 = g_giw01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","giw_file",g_giw01,"",SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660123 #No.FUN-740020
      ELSE
         CLEAR FORM
         CALL g_giw.clear()
         LET g_giw00 = NULL   #No.FUN-740020
         LET g_giw01 = NULL
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
         OPEN i941_count
         FETCH i941_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i941_b_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i941_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i941_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION

#單身
FUNCTION i941_b()
DEFINE
   l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT        #No.FUN-680098 SMALLINT
   l_n             LIKE type_file.num5,     #檢查重複用
   l_lock_sw       LIKE type_file.chr1,     #單身鎖住否
   p_cmd           LIKE type_file.chr1,     #處理狀態
   l_giw_delyn     LIKE type_file.chr1,     #判斷是否可以刪除單身資料ROW
   l_chr           LIKE type_file.chr1,
   l_allow_insert  LIKE type_file.num5,     #可新增否
   l_allow_delete  LIKE type_file.num5      #可刪除否

   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF          #檢查權限
   IF g_giw00 IS NULL OR g_giw01 IS NULL THEN
       RETURN
   END IF

   CALL cl_opmsg('b')                       #單身處理的操作提示

   LET g_forupd_sql = "SELECT giw02,'',giw03,giw04 FROM giw_file",
                      " WHERE giw00 = ? AND giw01=? AND giw02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i941_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_giw WITHOUT DEFAULTS FROM s_giw.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)

      BEFORE INPUT
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
   
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'                   #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'                   
            LET g_giw_t.* = g_giw[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN i941_bcl USING g_giw00,g_giw01,g_giw_t.giw02 
            IF STATUS THEN
               CALL cl_err("OPEN i941_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            END IF
            FETCH i941_bcl INTO g_giw_t.* 
            IF SQLCA.sqlcode THEN
               CALL cl_err('lock giw',SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
   
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_giw[l_ac].* TO NULL         #900423
         INITIALIZE g_giw_t.* TO NULL  
         IF l_ac > 1 THEN
            LET g_giw[l_ac].giw03 = g_giw[l_ac-1].giw03
            LET g_giw[l_ac].giw04 = g_giw[l_ac-1].giw04
         END IF
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD giw02
   
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
          INSERT INTO giw_file (giw00,giw01,giw02,giw03,giw04)
              VALUES(g_giw00,g_giw01,g_giw[l_ac].giw02,g_giw[l_ac].giw03,
                     g_giw[l_ac].giw04)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","giw_file",g_giw01,g_giw[l_ac].giw02,SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
   
      AFTER FIELD giw02
         IF NOT cl_null(g_giw[l_ac].giw02) THEN
            CALL i941_giw()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD giw02
            END IF
         END IF
         IF g_giw[l_ac].giw02 != g_giw_t.giw02 OR
            cl_null(g_giw_t.giw02) THEN
            SELECT COUNT(*) INTO l_n FROM giw_file
             WHERE giw00 =  g_giw00
               AND giw01 <> g_giw01 
               AND giw02 =  g_giw[l_ac].giw02 

            IF l_n > 0 THEN    #科目已存在其他群組中
               IF NOT cl_confirm('agl-919') THEN
                  NEXT FIELD giw02
               END IF
            END IF
            SELECT count(*) INTO l_n FROM giw_file 
             WHERE giw01 = g_giw01 AND giw02 = g_giw[l_ac].giw02
               AND giw00 = g_giw00
            IF l_n <> 0 THEN
               LET g_giw[l_ac].giw02 = g_giw_t.giw02
               CALL cl_err('','-239',0) 
               NEXT FIELD giw02
            END IF
         END IF
   
      AFTER FIELD giw03
         IF NOT cl_null(g_giw[l_ac].giw03) THEN
            IF g_giw[l_ac].giw03 NOT MATCHES '[-+]' THEN 
               NEXT FIELD giw03 
            END IF
         END IF
   
      AFTER FIELD giw04
         IF NOT cl_null(g_giw[l_ac].giw04) THEN
            IF g_giw[l_ac].giw04 NOT MATCHES '[123456]' THEN
               NEXT FIELD giw04
            END IF 
         END IF
   
      BEFORE DELETE
         #判斷是否可以刪除此ROW,因為此ROW可能和其它file有key值的關聯性,
         #所以不能隨便亂刪掉
         CALL i941_giw_delyn() RETURNING l_giw_delyn 
         IF g_giw_t.giw02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN   #詢問是否確定
               CANCEL DELETE
            END IF
            IF l_giw_delyn = 'N ' THEN   #為不可刪除此ROW的狀態下
                                         #人工輸入金額設定作業中此ROW已被使用,不可刪除!!
               CALL cl_err(g_giw_t.giw02,'agl-918',0) 
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM giw_file WHERE giw00 = g_giw00
                                   AND giw01 = g_giw01 AND giw02 = g_giw_t.giw02 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","giw_file",g_giw01,g_giw_t.giw02,SQLCA.sqlcode,"","",1)
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
   
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_giw[l_ac].* = g_giw_t.*
            CLOSE i941_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_giw[l_ac].giw02,-263,1)
            LET g_giw[l_ac].* = g_giw_t.*
         ELSE
            UPDATE giw_file SET giw02 = g_giw[l_ac].giw02,
                                giw03 = g_giw[l_ac].giw03,
                                giw04 = g_giw[l_ac].giw04 
             WHERE giw00=g_giw00
               AND giw01=g_giw01 AND giw02=g_giw_t.giw02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","giw_file",g_giw01,g_giw_t.giw02,SQLCA.sqlcode,"","",1)
               LET g_giw[l_ac].* = g_giw_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
   
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30032 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_giw[l_ac].* = g_giw_t.*
            #FUN-D30032--add--begin---
            ELSE
               CALL g_giw.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end----
            END IF
            CLOSE i941_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30032 add
         CLOSE i941_bcl
         COMMIT WORK
   
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(giw02) AND l_ac > 1 THEN
            LET g_giw[l_ac].* = g_giw[l_ac-1].*
            NEXT FIELD giw02
         END IF
   
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
   
      ON ACTION CONTROLG
         CALL cl_cmdask()
   
      ON ACTION controlp
         CASE
            WHEN INFIELD(giw02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.default1 = g_giw[l_ac].giw02
               LET g_qryparam.arg1 = g_giw00
               CALL cl_create_qry() RETURNING g_giw[l_ac].giw02
               DISPLAY BY NAME g_giw[l_ac].giw02
               CALL i941_giw()
               NEXT FIELD giw02
            OTHERWISE
               EXIT CASE
          END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
   
   END INPUT

   CLOSE i941_bcl
   COMMIT WORK

END FUNCTION

FUNCTION i941_giw()
DEFINE l_giwacti    LIKE aag_file.aagacti

   LET g_errno = ' '
   IF l_ac > 0 THEN   #MOD-D10287
      SELECT aag02,aagacti INTO g_giw[l_ac].aag02,l_giwacti FROM aag_file
       WHERE aag01 = g_giw[l_ac].giw02 
       AND aag00 = g_giw00
      CASE WHEN SQLCA.sqlcode = 100 LET g_errno = 'agl-001'
           WHEN l_giwacti = 'N'     LEt g_errno = '9028'
           OTHERWISE
      END CASE
   END IF   #MOD-D10287
END FUNCTION

FUNCTION i941_giw_delyn()
DEFINE 
   l_delyn       LIKE type_file.chr1,         #存放可否刪除的變數
   l_n           LIKE type_file.num5
   
   LET l_delyn = 'Y'

   SELECT COUNT(*)  INTO l_n FROM gix_file 
    WHERE gix01 = g_giw01
      AND gix02 = g_giw[l_ac].giw02 
      AND giw00 = g_giw00
   IF l_n > 0 THEN 
      LET l_delyn = 'N'
   END IF
   RETURN l_delyn
END FUNCTION

FUNCTION i941_b_askkey()
   CLEAR FORM
   CALL g_giw.clear()
   CONSTRUCT g_wc2 ON giw00,giw01,giw02,giw03,giw04
        FROM giw00,giw01,s_giw[1].giw02,s_giw[1].giw03,s_giw[1].giw04

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

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

   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   CALL i941_b_fill(g_wc2)
END FUNCTION
   
FUNCTION i941_b_fill(p_wc)              #BODY FILL UP
DEFINE
   p_wc            STRING,
   l_flag          LIKE type_file.chr1,              #有無單身筆數
   l_sql           STRING
 
   LET l_sql = "SELECT giw02,aag02,giw03,giw04 ",
               "  FROM giw_file,OUTER aag_file",
               " WHERE giw01 = '",g_giw01,"'",
               "   AND giw00 = '",g_giw00,"'",
               "   AND giw00 = aag00 ",
               "   AND giw02 = aag01 AND ",p_wc CLIPPED,
               " ORDER BY giw02"

   PREPARE giw_pre FROM l_sql
   DECLARE giw_cs CURSOR FOR giw_pre

   CALL g_giw.clear()
   LET g_cnt = 1
   LET l_flag='N'
   LET g_rec_b=0
   FOREACH giw_cs INTO g_giw[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_flag='Y'
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_giw.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF l_flag='N' THEN LET g_rec_b=0 END IF     #無單身時將筆數清為零
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
END FUNCTION

FUNCTION i941_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_giw TO s_giw.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first 
         CALL i941_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION previous
         CALL i941_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY

      ON ACTION jump
         CALL i941_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY

      ON ACTION next
         CALL i941_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY

      ON ACTION last
         CALL i941_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY

     ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

     ON ACTION accept
        LET g_action_choice="detail"
        LET l_ac = ARR_CURR()
        EXIT DISPLAY

     ON ACTION cancel
        LET INT_FLAG=FALSE
        LET g_action_choice="exit"
        EXIT DISPLAY

     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
     ON ACTION about
        CALL cl_about()

     AFTER DISPLAY
        CONTINUE DISPLAY

     ON ACTION controls
        CALL cl_set_head_visible("","AUTO")

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i941_set_entry(p_cmd) 
DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("giw00,giw01,giw02",TRUE)
   END IF 
END FUNCTION

FUNCTION i941_set_no_entry(p_cmd) 
DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("giw00,giw01,giw02",FALSE)
   END IF 
END FUNCTION

FUNCTION i941_u()
   DEFINE l_giw_lock    RECORD LIKE giw_file.*
   IF s_shut(0) THEN
      RETURN
   END IF
   IF g_chkey = 'N' THEN
      CALL cl_err('','agl-266',1)
      RETURN
   END IF
   MESSAGE ""
   LET g_giw00_t = g_giw00
   LET g_giw01_t = g_giw01

   BEGIN WORK
   OPEN i941_cl USING g_giw00,g_giw01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE i941_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i941_cl INTO l_giw_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("giw00 LOCK:",SQLCA.sqlcode,1)
      CLOSE i941_cl
      ROLLBACK WORK
      RETURN
   END IF

   WHILE TRUE
      CALL i941_i("u")
      IF INT_FLAG THEN
         LET g_giw00 = g_giw00_t
         LET g_giw01 = g_giw01_t
         DISPLAY g_giw00,g_giw01 TO giw00,giw01
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE giw_file SET giw00 = g_giw00, giw01 = g_giw01
       WHERE giw00 = g_giw00_t
         AND giw01 = g_giw01_t
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","giw_file",g_giw00_t,g_giw01_t,SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
