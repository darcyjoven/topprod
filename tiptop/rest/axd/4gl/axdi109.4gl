# Prog. Version..: '5.10.00-08.01.04(00000)'     #
#
# Pattern name...: axdi109.4gl
# Descriptions...: 車輛型號維護作業
# Input parameter: 
# Date & Author..: 2003/12/02 By Leagh
# Modify.........: No.MOD-4B0067 04/11/08 By Elva 將變數用Like方式定義,調整報表
# Modify.........: No.FUN-520024 05/02/24 By Day 報表轉XML
# Modify.........: No.MOD-540145 05/05/10 By vivien  刪除HELP FILE   
# Modify.........: No.TQC-660099 06/06/21 By Mandy TQC-630166的MARK不要用{}改用#
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     
# Modify.........: Mo.FUN-6A0078 06/10/24 By xumin g_no_ask改mi_no_ask    
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:FUN-6A0165 06/11/08 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No:FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
        g_obt01         LIKE obt_file.obt01,    #車輛廠牌
        g_obt01_t       LIKE obt_file.obt01,    #車輛廠牌舊值
        g_obt           DYNAMIC ARRAY OF RECORD #程式變數(Program Variables)
                        obt02       LIKE obt_file.obt02,  #車輛型號
                        obt03       LIKE obt_file.obt03   #說明
                        END RECORD,
        g_obt_t         RECORD                  #程式變數 (舊值)
                        obt02       LIKE obt_file.obt02,  #車輛型號
                        obt03       LIKE obt_file.obt03   #說明
                        END RECORD,
        g_obs02         LIKE obs_file.obs02,
        l_flag          LIKE type_file.chr1,    #No.FUN-680108 VARCHAR(01)
        g_delete        LIKE type_file.chr1,    #No.FUN-680108 VARCHAR(01)
        g_wc,g_sql      STRING,#TQC-630166 
        g_rec_b         LIKE type_file.num5,    #單身筆數                 #No.FUN-680108 SMALLINT
        l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT        #No.FUN-680108 SMALLINT
#       l_time        LIKE type_file.chr8              #No.FUN-6A0091
DEFINE p_row,p_col     LIKE type_file.num5      #No.FUN-680108 SMALLINT
DEFINE g_forupd_sql    STRING   #SELECT ... FOR UPDATE NOWAIT SQL 
DEFINE g_before_input_done  LIKE type_file.num5       #No.FUN-680108 SMALLINT

DEFINE   g_cnt          LIKE type_file.num10    #No.FUN-680108 INTEGER
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose           #No.FUN-680108 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000  #No.FUN-680108 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10                                            #No.FUN-680108 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10    #No.FUN-680108 INTEGER
DEFINE   g_jump         LIKE type_file.num10                                            #No.FUN-680108 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5     #No.FUN-680108 SMALLINT   #No.FUN-6A0078
MAIN
#     DEFINE    l_time LIKE type_file.chr8           #No.FUN-6A0091

    OPTIONS
        FORM LINE     FIRST + 2,
        MESSAGE LINE  LAST,
        PROMPT LINE   LAST,
        INPUT NO WRAP
    DEFER INTERRUPT
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("AXD")) THEN
       EXIT PROGRAM
    END IF
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
    INITIALIZE g_obt_t.* TO NULL
    LET g_forupd_sql = 
        "SELECT * FROM obt_file WHERE obt01 = ? FOR UPDATE NOWAIT"
    DECLARE i109_crl CURSOR FROM g_forupd_sql              # LOCK CURSOR
       LET p_row = 3 LET p_col = 10
 OPEN WINDOW i109_w AT p_row,p_col
        WITH FORM "axd/42f/axdi109"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
    
    CALL cl_ui_init()
    CALL g_x.clear()
    CALL i109_menu()    #中文
    CLOSE WINDOW i109_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
END MAIN


#QBE 查詢資料
FUNCTION i109_cs()
    CLEAR FORM                             #清除畫面
    CALL g_obt.clear()                            #清除畫面
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
   INITIALIZE g_obt01 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON obt01,obt02,obt03  #螢幕上取條件
                 FROM obt01,s_obt[1].obt02,s_obt[1].obt03

    #No:FUN-580031 --start--     HCN
    BEFORE CONSTRUCT
       CALL cl_qbe_init()
    #No:FUN-580031 --end--       HCN

    ON ACTION controlp
       CASE
         WHEN INFIELD(obt01)
          CALL cl_init_qry_var()       
          LET g_qryparam.state ="c"
          LET g_qryparam.form ="q_obs"
          CALL cl_create_qry() RETURNING g_qryparam.multiret
          DISPLAY g_qryparam.multiret TO obt01
          NEXT FIELD obt01
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
 
     #No:FUN-580031 --start--     HCN
     ON ACTION qbe_select
         CALL cl_qbe_select() 
     ON ACTION qbe_save
         CALL cl_qbe_save()
     #No:FUN-580031 --end--       HCN
     END CONSTRUCT        

    IF INT_FLAG THEN  RETURN END IF
LET g_sql= "SELECT DISTINCT obt01 FROM obt_file ",                          
               " WHERE ", g_wc CLIPPED,                                         
               " ORDER BY obt01"
    PREPARE i109_prepare FROM g_sql      #預備一下
    DECLARE i109_b_cs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i109_prepare

#因主鍵值有兩個故所抓出資料筆數有誤
    LET g_sql="SELECT COUNT(UNIQUE obt01) ",
              " FROM obt_file WHERE ", g_wc CLIPPED
    PREPARE i109_pre_count FROM g_sql
    DECLARE i109_count CURSOR FOR i109_pre_count
    OPEN i109_count                                                            
    FETCH i109_count INTO g_row_count                                          
    CLOSE i109_count

END FUNCTION

#中文的MENU
FUNCTION i109_menu()
   WHILE TRUE
      CALL i109_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i109_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i109_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i109_r()
            END IF
         WHEN "reproduce"
          IF cl_chk_act_auth() THEN
               CALL i109_copy()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i109_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i109_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #No:FUN-6A0165-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_obt01 IS NOT NULL THEN
                 LET g_doc.column1 = "obt01"
                 LET g_doc.value1 = g_obt01
                 CALL cl_doc()
               END IF
         END IF
         #No:FUN-6A0165-------add--------end----

      END CASE
   END WHILE
END FUNCTION

FUNCTION i109_a()
    MESSAGE ""
    CLEAR FORM
    CALL g_obt.clear()
    INITIALIZE g_obt01 LIKE  obt_file.obt01
    LET g_obt01_t  = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i109_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET g_obt01=NULL
            DISPLAY g_obt01 TO obt01
            CLEAR FORM
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_rec_b=0
        CALL i109_b()                   #輸入單身
        LET g_obt01_t = g_obt01
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION i109_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,     #a:輸入 u:更改    #No.FUN-680108 VARCHAR(1)
    l_n             LIKE type_file.num5,     #No.FUN-680108 SMALLINT
    l_str           LIKE type_file.chr1000,  #No.FUN-680108 VARCHAR(40)
    l_obs01         LIKE obs_file.obs01
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

    INPUT g_obt01 WITHOUT DEFAULTS FROM obt01 HELP 1

        AFTER FIELD obt01    
            IF NOT cl_null(g_obt01) THEN 
               SELECT obs01 INTO l_obs01 FROM obs_file WHERE obs01=g_obt01
               IF SQLCA.sqlcode THEN           
                  CALL cl_err('',SQLCA.sqlcode,0)
                  NEXT FIELD obt01
               ELSE 
                   SELECT COUNT(*) INTO l_n FROM obt_file WHERE obt01 = g_obt01
                   IF l_n > 0 THEN
                      CALL cl_err('',-239,0)
                      NEXT FIELD obt01 
                   END IF
               END IF
               SELECT obs02 INTO g_obs02 FROM obs_file WHERE obs01 = g_obt01
               IF SQLCA.sqlcode THEN           
                  CALL cl_err('',SQLCA.sqlcode,0)
                  NEXT FIELD obt01
               ELSE 
                  DISPLAY g_obs02 TO obs02 
               END IF
            END IF

        ON ACTION CONTROLP
            CASE
            WHEN INFIELD(obt01) 
                  CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_obs"
                   LET g_qryparam.default1 = g_obt01
                   CALL cl_create_qry() RETURNING g_obt01 
                   DISPLAY g_obt01 TO obt01
                   NEXT FIELD obt01        
            END CASE

        ON ACTION controlf                  #欄位說明
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
FUNCTION i109_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_obt01 TO NULL             #NO.FUN-6A0165

    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_obt.clear()
    DISPLAY '   ' TO FORMONLY.cnt

    CALL i109_cs()                         #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_obt01 TO NULL
        RETURN
    END IF
    OPEN i109_count
    FETCH i109_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i109_b_cs                        #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                 #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_obt01 TO NULL
    ELSE
        CALL i109_fetch('F')              #讀出TEMP第一筆並顯示
    END IF
END FUNCTION

#處理資料的讀取
FUNCTION i109_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1       #處理方式    #No.FUN-680108 VARCHAR(1)

    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i109_b_cs INTO g_obt01
        WHEN 'P' FETCH PREVIOUS i109_b_cs INTO g_obt01
        WHEN 'F' FETCH FIRST    i109_b_cs INTO g_obt01
        WHEN 'L' FETCH LAST     i109_b_cs INTO g_obt01
        WHEN '/' 
         IF (NOT mi_no_ask) THEN    #No.FUN-6A0078
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
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
         FETCH ABSOLUTE g_jump i109_b_cs INTO g_obt01
         LET mi_no_ask = FALSE    #No.FUN-6A0078
    END CASE

    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_obt01,SQLCA.sqlcode,0)
        INITIALIZE g_obt01 TO NULL  #TQC-6B0105
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
    CALL i109_show()
END FUNCTION

#將資料顯示在畫面上
FUNCTION i109_show()
    DISPLAY g_obt01 TO obt01               #單頭
    SELECT obs02 INTO g_obs02 FROM obs_file WHERE obs01 = g_obt01
    IF SQLCA.sqlcode THEN LET g_obs02 = NULL END IF
    DISPLAY g_obs02 TO obs02
    CALL i109_b_fill(g_wc)              #單身
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

FUNCTION i109_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_obt01 IS NULL THEN 
       CALL cl_err("",-400,0)                 #No.FUN-6A0165  
       RETURN 
    END IF
    BEGIN WORK
    IF cl_delh(0,0) THEN                   #確認一下
        DELETE FROM obt_file WHERE obt01 = g_obt01 
        IF SQLCA.sqlcode THEN
            CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)
        ELSE
            CLEAR FORM
            LET g_obt01 = NULL
            CALL g_obt.clear()
            LET g_cnt=STATUS
            LET g_delete = 'Y'
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            OPEN i109_count                                   
            FETCH i109_count INTO g_row_count                       
            DISPLAY g_row_count TO FORMONLY.cnt                     
            OPEN i109_b_cs                                            
            IF g_curs_index = g_row_count + 1 THEN                  
               LET g_jump = g_row_count                             
               CALL i109_fetch('L')                                 
            ELSE                                                    
               LET g_jump = g_curs_index                            
               LET mi_no_ask = TRUE     #No.FUN-6A0078                             
               CALL i109_fetch('/')                                 
            END IF
        END IF
    END IF
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i109_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680108 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用     #No.FUN-680108 SMALLINT
    l_no            LIKE type_file.num5,    #檢查重複用     #No.FUN-680108 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否     #No.FUN-680108 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態       #No.FUN-680108 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,    #可新增否       #No.FUN-680108 SMALLINT
    l_allow_delete  LIKE type_file.num5,    #可刪除否       #No.FUN-680108 SMALLINT
    l_str           LIKE type_file.chr20    #No.FUN-680108 VARCHAR(20)
    LET g_action_choice = ""
 
    CALL cl_opmsg('b')
    LET g_forupd_sql = "SELECT obt02,obt03 FROM obt_file ",
                       " WHERE obt01 =? AND obt02 =? FOR UPDATE NOWAIT"
    DECLARE i109_b_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
   
        INPUT ARRAY g_obt
            WITHOUT DEFAULTS
            FROM s_obt.* ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
    BEFORE INPUT
        DISPLAY "BEFORE INPUT"
            IF g_rec_b != 0  THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
    BEFORE ROW
        DISPLAY "BEFORE ROW"
            LET p_cmd=' '
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            IF g_rec_b >=l_ac THEN
               BEGIN WORK       
               LET p_cmd='u'
               LET g_obt_t.* = g_obt[l_ac].*  #BACKUP
               OPEN i109_b_cl USING g_obt01,g_obt_t.obt02             #表示更改狀態
               IF STATUS THEN
                  CALL cl_err("OPEN i109_b_cl:",STATUS,1)
                  LET l_lock_sw = "Y"
               ELSE
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_obt_t.obt02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     LET g_obt_t.*=g_obt[l_ac].*
                  END IF
                  FETCH i109_b_cl INTO g_obt[l_ac].* 
               END IF       
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

    BEFORE INSERT
        DISPLAY "BEFORE INSERT"
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_obt[l_ac].* TO NULL      #900423
            LET g_obt_t.* = g_obt[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD obt02

        AFTER FIELD obt02                 
            IF NOT cl_null(g_obt[l_ac].obt02) AND
               (g_obt[l_ac].obt02 != g_obt_t.obt02 OR
                g_obt_t.obt02 IS NULL) THEN
                LET l_no=0
                SELECT count(*) INTO l_no FROM obt_file
                 WHERE obt01 = g_obt01
                   AND obt02 = g_obt[l_ac].obt02
                IF l_no > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_obt[l_ac].obt02 = g_obt_t.obt02
                    NEXT FIELD obt02
                END IF
            END IF
    AFTER INSERT
        DISPLAY "AFTER INSERT"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO obt_file(obt01,obt02,obt03)
                          VALUES(g_obt01,
                                 g_obt[l_ac].obt02,g_obt[l_ac].obt03)
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_obt[l_ac].obt02,SQLCA.sqlcode,0)
               CANCEL INSERT 
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b = g_rec_b + 1
            END IF

  
        BEFORE DELETE                            #是否取消單身
            IF g_obt_t.obt02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM obt_file
                 WHERE obt01 = g_obt01 AND obt02 = g_obt_t.obt02
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_obt_t.obt02,SQLCA.sqlcode,0)
                    ROLLBACK WORK
                    CANCEL DELETE 
                END IF
                LET g_rec_b=g_rec_b-1
                MESSAGE "Delete Ok"
            END IF 
            COMMIT WORK  


    ON ROW CHANGE
        DISPLAY "ON ROW CHANGE"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_obt[l_ac].* = g_obt_t.*
               CLOSE i109_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_obt[l_ac].obt02,-263,1)
               LET g_obt[l_ac].* = g_obt_t.*
            ELSE
               UPDATE obt_file SET obt01=g_obt01,
                                   obt02=g_obt[l_ac].obt02,
                                   obt03=g_obt[l_ac].obt03
                  WHERE obt01 = g_obt01 
                  AND obt02 = g_obt_t.obt02
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_obt[l_ac].obt02,SQLCA.sqlcode,0)
                 LET g_obt[l_ac].* = g_obt_t.*
                 ROLLBACK WORK
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
            END IF

    AFTER ROW
        DISPLAY "AFTER ROW"
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_obt[l_ac].* = g_obt_t.*
               END IF
               CLOSE i109_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i109_b_cl
            COMMIT WORK

        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(obt02) AND l_ac > 1 THEN
               LET g_obt[l_ac].* = g_obt[l_ac-1].*
               NEXT FIELD obp02
            END IF
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

        ON ACTION CONTROLN
            CALL i109_b_askkey()
            EXIT INPUT

        ON ACTION CONTROLZ
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
 
    END INPUT

    CLOSE i109_b_cl
    COMMIT WORK
END FUNCTION
   
FUNCTION i109_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(200)

    CONSTRUCT l_wc ON obt02,obt03    #螢幕上取條件
                 FROM s_obt[1].obt02,s_obt[1].obt03

       #No:FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No:FUN-580031 --end--       HCN

       ON IDLE g_idle_seconds                                                   
          CALL cl_on_idle()                                                     
          CONTINUE CONSTRUCT                                                    
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
  
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
  
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
       #No:FUN-580031 --start--     HCN
       ON ACTION qbe_select
           CALL cl_qbe_select() 
       ON ACTION qbe_save
           CALL cl_qbe_save()
       #No:FUN-580031 --end--       HCN
     END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    CALL i109_b_fill(l_wc)
END FUNCTION

FUNCTION i109_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(200)
    
LET g_sql = "SELECT obt02,obt03,''",                                        
                "  FROM obt_file ",                                             
                " WHERE obt01 = '",g_obt01,"' AND ", p_wc CLIPPED,              
                " ORDER BY obt02"
    PREPARE i109_prepare2 FROM g_sql      #預備一下
    DECLARE obt_cs CURSOR FOR i109_prepare2
    CALL g_obt.clear()
    LET g_cnt = 1
    LET g_rec_b=0

    FOREACH obt_cs INTO g_obt[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        LET g_cnt=g_cnt+1
    END FOREACH
    CALL g_obt.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    LET g_cnt = 0
END FUNCTION

FUNCTION i109_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_obt TO s_obt.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY                                                            
                                                                                
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

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
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first 
         CALL i109_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF
           ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION previous
         CALL i109_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION jump 
         CALL i109_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION next
         CALL i109_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION last 
         CALL i109_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
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
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

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

      ON ACTION related_document                #No:FUN-6A0165  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY    

      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION i109_copy()
DEFINE l_newno1,l_oldno1  LIKE obt_file.obt01,
       l_obs02            LIKE obs_file.obs02,
       l_n                LIKE type_file.num5          #No.FUN-680108 SMALLINT

    IF s_shut(0) THEN RETURN END IF
    IF g_obt01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    DISPLAY ' ' TO obs02 ATTRIBUTE(GREEN)
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

    INPUT l_newno1 FROM obt01
        AFTER FIELD obt01 
            IF cl_null(l_newno1) THEN NEXT FIELD obt01 END IF
            SELECT COUNT(*) INTO l_n FROM obt_file WHERE obt01=l_newno1 
            IF l_n > 0 THEN 
               CALL cl_err(l_newno1,-239,0) NEXT FIELD obt01
            END IF
            SELECT obs02 INTO l_obs02 FROM obs_file WHERE obs01=l_newno1 
            IF SQLCA.sqlcode THEN 
               CALL cl_err(l_obs02,STATUS,0) NEXT FIELD obt01
            END IF
            DISPLAY l_obs02 TO obs02 
  
        ON ACTION CONTROLP
            CASE
            WHEN INFIELD(obt01) 
                  CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_obs"
              #    LET g_qryparam.default1 = g_obt01
                   CALL cl_create_qry() RETURNING l_newno1 
                   DISPLAY BY NAME l_newno1 
                   NEXT FIELD obt01        
            END CASE
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
        LET INT_FLAG = 0 DISPLAY  g_obt01 TO obt01  ATTRIBUTE(YELLOW) RETURN
    END IF

    DROP TABLE x
    SELECT * FROM obt_file         #單身複製
        WHERE g_obt01=obt01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
       LET g_msg = g_obt01 CLIPPED
       CALL cl_err(g_msg,SQLCA.sqlcode,0)
       RETURN
    END IF
    UPDATE x SET obt01 = l_newno1 
    INSERT INTO obt_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
       LET g_msg = l_newno1 CLIPPED
       CALL cl_err(g_msg,SQLCA.sqlcode,0)
       RETURN
    END IF
    LET l_oldno1= g_obt01
    LET g_obt01=l_newno1
    CALL i109_b()
    LET g_obt01=l_oldno1
    CALL i109_show()
END FUNCTION

FUNCTION i109_out()
DEFINE
    l_i             LIKE type_file.num5,    #No.FUN-680108 SMALLINT
    sr              RECORD LIKE obt_file.*,
    l_name          LIKE type_file.chr20,   #External(Disk) file name  #No.FUN-680108 VARCHAR(20)
     l_za05         LIKE za_file.za05       #MOD-4B0067

   
    IF cl_null(g_wc) AND NOT cl_null(g_obt01)AND NOT cl_null(g_obt[l_ac].obt02) THEN                          
       LET g_wc = " obt01 = '",g_obt01,"' AND obt02 = '",g_obt[l_ac].obt02,"'"                                  
    END IF  
    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('axdi109') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * ",
              "  FROM obt_file ",  # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED,
              " ORDER BY 1 "
    PREPARE i109_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i109_co                         # CURSOR
        CURSOR FOR i109_p1

    START REPORT i109_rep TO l_name

    FOREACH i109_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        OUTPUT TO REPORT i109_rep(sr.*)
    END FOREACH

    FINISH REPORT i109_rep

    CLOSE i109_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION

REPORT i109_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,     #No.FUN-680108 VARCHAR(1)
    sr              RECORD LIKE obt_file.*

    OUTPUT
       TOP MARGIN g_top_margin 
       LEFT MARGIN g_left_margin 
       BOTTOM MARGIN g_bottom_margin 
       PAGE LENGTH g_page_line
    ORDER BY sr.obt01

    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED

            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno" 
            PRINT g_head CLIPPED,pageno_total     

            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            PRINT
            PRINT g_dash[1,g_len]

            PRINT g_x[31],g_x[32],g_x[33]
            PRINT g_dash1 
            LET l_trailer_sw = 'y'

        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.obt01,
                  COLUMN g_c[32],sr.obt02,
                  COLUMN g_c[33],sr.obt03

        ON LAST ROW
            IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
               PRINT g_dash[1,g_len]
           ##TQC-630166
           #{
        #   IF g_sql[001,080] > ' ' THEN
	   #           PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
           #   IF g_sql[071,140] > ' ' THEN
	   #           PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
           #   IF g_sql[141,210] > ' ' THEN
	   #           PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
           #}
              CALL cl_prt_pos_wc(g_sql)
            #END TQC-630166
            END IF
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'n'
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED

        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
