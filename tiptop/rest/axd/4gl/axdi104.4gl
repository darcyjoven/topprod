# Prog. Version..: '5.10.00-08.01.04(00006)'     #
#
# Pattern name...: axdi104.4gl
# Descriptions...: 單位運費維護作業
# Date & Author..: 03/10/10 by Jack
# Modify.........: No.MOD-4B0067 04/11/08 By Elva 將變數用Like方式定義,報表拉成一行 
# Modify.........: No.FUN-520024 05/02/24 報表轉XML By wujie
# Modify.........: No.MOD-540145 05/05/10 By vivien  刪除HELP FILE   
# Modify.........: No.FUN-680108 06/08/28 By Xufeng  字段類型定義改為LIKE  
# Modify.........: Mo.FUN-6A0078 06/10/24 By xumin g_no_ask改mi_no_ask    
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:FUN-6A0165 06/11/08 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No:FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No:MOD-790127 07/09/26 By Pengu 當操作流程為q()=>u()=>a()時會無法新增

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE 
    g_obp01         LIKE obp_file.obp01, #運輸方式 
    g_obp01_t       LIKE obp_file.obp01,
    g_obp_rowid     LIKE type_file.chr18,         #No.FUN-680108 INT # saki 20070821 rowid chr18 -> num10 
    l_cnt           LIKE type_file.num5,          #No.FUN-680108 SMALLINT
    l_cmd           LIKE type_file.chr1000,       #No.FUN-680108 VARCHAR(100)
    g_obp           DYNAMIC ARRAY OF RECORD      #程式變數(Program Variables)
        obp02       LIKE obp_file.obp02,
        oac02       LIKE oac_file.oac02,
        obp03       LIKE obp_file.obp03,
        oac02a      LIKE oac_file.oac02,
        obp04       LIKE obp_file.obp04,
        obp05       LIKE obp_file.obp05,
        obp06       LIKE obp_file.obp06,
        obp07       LIKE obp_file.obp07
                    END RECORD,
    g_obp_t         RECORD                    #程式變數 (舊值)
        obp02       LIKE obp_file.obp02,                                        
        oac02       LIKE oac_file.oac02,                                        
        obp03       LIKE obp_file.obp03,                                        
        oac02a      LIKE oac_file.oac02,                                       
        obp04       LIKE obp_file.obp04,                                        
        obp05       LIKE obp_file.obp05,                                        
        obp06       LIKE obp_file.obp06,                                        
        obp07       LIKE obp_file.obp07  
                    END RECORD,
    g_obm02         LIKE obm_file.obm02,
     g_wc,g_wc2,g_sql    STRING,  #No:FUN-580092 HCN 
    g_delete        LIKE type_file.chr1,                #若刪除資料,則要重新顯示筆數" #No.FUN-680108 VARCHAR(01) 
    g_rec_b         LIKE type_file.num5,                #單身筆數                     #No.FUN-680108 SMALLINT
     l_za05          LIKE za_file.za05,     #MOD-4B0067
    l_ac            LIKE type_file.num5                #目前處理的ARRAY CNT           #No.FUN-680108 SMALLINT
DEFINE p_row,p_col     LIKE type_file.num5                                            #No.FUN-680108 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5                                        #No.FUN-680108 SMALLINT
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE NOWAIT SQL

DEFINE   g_cnt           LIKE type_file.num10                                         #No.FUN-680108 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose         #No.FUN-680108 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000                                       #No.FUN-680108 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10                                          #No.FUN-680108 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10                                          #No.FUN-680108 INTEGER
DEFINE   g_jump         LIKE type_file.num10                                          #No.FUN-680108 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5     #No.FUN-6A0078                                      #No.FUN-680108 SMALLINT
MAIN
#DEFINE
#       l_time    LIKE type_file.chr8              #No.FUN-6A0091

    OPTIONS                                #改變一些系統預設值
        FORM LINE       FIRST + 2,         #畫面開始的位置
        MESSAGE LINE    LAST,              #訊息顯示的位置
        PROMPT LINE     LAST,              #提示訊息的位置
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("AXD")) THEN
       EXIT PROGRAM
    END IF
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091
    INITIALIZE g_obp_t.* TO NULL                                                
     LET g_forupd_sql = 
     "SELECT * FROM obp_file WHERE obp01 = ? FOR UPDATE NOWAIT"    #g_obp01_t
    DECLARE i104_crl CURSOR FROM g_forupd_sql             # LOCK CURSOR                      

       LET p_row = 4 LET p_col = 3
    OPEN WINDOW i104_w AT p_row,p_col               #顯示畫面
        WITH FORM "axd/42f/axdi104"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
    
    CALL cl_ui_init()
    CALL g_x.clear()
    LET g_delete='N'
    CALL i104_menu()    #中文
    CLOSE WINDOW i104_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091
END MAIN

#QBE 查詢資料
FUNCTION i104_cs()
    CLEAR FORM 
    CALL g_obp.clear()                            #清除畫面
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

   INITIALIZE g_obp01 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON obp01,obp02,obp03,obp04,obp05,obp06,obp07 
                 FROM obp01,s_obp[1].obp02,s_obp[1].obp03,s_obp[1].obp04,
                      s_obp[1].obp05,s_obp[1].obp06,s_obp[1].obp07 
    
   #No:FUN-580031 --start--     HCN
   BEFORE CONSTRUCT
      CALL cl_qbe_init()
   #No:FUN-580031 --end--       HCN

   ON ACTION controlp
     CASE
       WHEN INFIELD(obp01)
          CALL cl_init_qry_var()       
          LET g_qryparam.state ="c"
          LET g_qryparam.form ="q_obm"
          CALL cl_create_qry() RETURNING g_qryparam.multiret
          DISPLAY g_qryparam.multiret TO obp01
          NEXT FIELD obp01        
       WHEN INFIELD (obp02)
          CALL cl_init_qry_var()
          LET g_qryparam.state="c"
          LET g_qryparam.form="q_oac"
          CALL cl_create_qry() RETURNING g_qryparam.multiret
          DISPLAY g_qryparam.multiret TO obp02
          NEXT FIELD obp02
       WHEN INFIELD (obp03)
          CALL cl_init_qry_var()
          LET g_qryparam.state="c"
          LET g_qryparam.form="q_oac"
          CALL cl_create_qry() RETURNING g_qryparam.multiret
          DISPLAY g_qryparam.multiret TO  obp03
          NEXT FIELD obp03
       WHEN INFIELD (obp05)
          CALL cl_init_qry_var()
          LET g_qryparam.state="c"
          LET g_qryparam.form="q_azi"
          CALL cl_create_qry() RETURNING g_qryparam.multiret
          DISPLAY g_qryparam.multiret TO  obp05
          NEXT FIELD obp05
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
     
    IF INT_FLAG THEN RETURN END IF

    LET g_sql="SELECT DISTINCT obp01 ",
              "  FROM obp_file ", # 組合出 SQL 指令
              " WHERE ", g_wc CLIPPED,
              " ORDER BY obp01 "
    PREPARE i104_prepare FROM g_sql      #預備一下
    DECLARE i104_bcs                  #宣告成可卷動的
        SCROLL CURSOR WITH HOLD FOR i104_prepare
    LET g_sql="SELECT COUNT(UNIQUE obp01) ",
              "  FROM obp_file WHERE ", g_wc CLIPPED 
    PREPARE i104_precount FROM g_sql
    DECLARE i104_count CURSOR FOR i104_precount
END FUNCTION

#中文的MENU
FUNCTION i104_menu()
   WHILE TRUE
      CALL i104_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i104_a()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL i104_u()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i104_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i104_r()
            END IF
         WHEN "reproduce"
          IF cl_chk_act_auth() THEN
               CALL i104_copy()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i104_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i104_out()
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
                 IF g_obp01 IS NOT NULL THEN
                 LET g_doc.column1 = "obp01"
                 LET g_doc.value1 = g_obp01
                 CALL cl_doc()
               END IF
         END IF
         #No:FUN-6A0165-------add--------end----
      END CASE
   END WHILE
END FUNCTION

#Add  輸入
FUNCTION i104_a()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    MESSAGE ""
    CLEAR FORM
    CALL g_obp.clear()
    INITIALIZE g_obp01 LIKE obp_file.obp01
    LET g_obp01_t = NULL
    CLOSE i104_bcs
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i104_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
           LET g_obp01 = NULL
           CLEAR FORM
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        LET g_rec_b=0
        CALL i104_b()                      #輸入單身
        LET g_obp01_t = g_obp01            #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION i104_u()
IF g_obp01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_obp01_t = g_obp01
    WHILE TRUE
        CALL i104_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_obp01=g_obp01_t
            DISPLAY g_obp01 TO obp01          #ATTRIBUTE(YELLOW) #單頭
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_obp01 != g_obp01_t  THEN #更改單頭值
            UPDATE obp_file SET obp01 = g_obp01    #更新DB
                WHERE obp01 = g_obp01_t          #COLAUTH?
            IF SQLCA.sqlcode THEN
                LET g_msg = g_obp01 CLIPPED
                CALL cl_err(g_msg,SQLCA.sqlcode,0)
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION

#處理INPUT
FUNCTION i104_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改        #No.FUN-680108 VARCHAR(1)
    l_n             LIKE type_file.num5,                                       #No.FUN-680108 SMALLINT
    l_obp02         LIKE obp_file.obp02,
    l_obp03         LIKE obp_file.obp03 
    
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
   #----------No:MOD-790127 add
    LET g_before_input_done = FALSE                                     
    CALL i104_set_entry(p_cmd)                                          
   #----------No:MOD-790127 add

    INPUT g_obp01 WITHOUT DEFAULTS FROM obp01
 
        BEFORE INPUT                                                            
            LET g_before_input_done = FALSE                                     
            CALL i104_set_entry(p_cmd)                                          
            CALL i104_set_no_entry(p_cmd)                                       
            LET g_before_input_done = TRUE

        AFTER FIELD obp01                # 流程代號
            IF NOT cl_null(g_obp01) THEN 
               IF g_obp01 != g_obp01_t OR g_obp01_t IS NULL THEN
                  LET g_obm02 = ' '
                  SELECT obm02 INTO g_obm02 FROM obm_file WHERE obm01=g_obp01
                  IF SQLCA.SQLCODE <>0 THEN
                     CALL cl_err(g_obp01,'mfg9169',0)
                     LET g_obp01 = g_obp01_t
                     DISPLAY g_obp01 TO obp01
                     NEXT FIELD obp01
                  END IF
                  DISPLAY g_obm02 TO FORMONLY.obm02
                  SELECT COUNT(*) INTO l_n FROM obp_file WHERE  obp01 = g_obp01
                  IF l_n >0 THEN 
                     CALL cl_err(g_obp01,-239,0) NEXT FIELD obp01
                  END IF
               END IF
            END IF

        ON ACTION CONTROLN
            CALL i104_b_askkey()
            EXIT INPUT

        ON ACTION CONTROLP                 
            CASE
                WHEN INFIELD(obp01)
                  CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_obm"
                   LET g_qryparam.default1 = g_obp01
                   CALL cl_create_qry() RETURNING g_obp01 
                   DISPLAY g_obp01 TO obp01
                   NEXT FIELD obp01        
            END CASE
   
        ON ACTION CONTROLF                  #欄位說明
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
FUNCTION i104_q()
  DEFINE l_obp01  LIKE obp_file.obp01,
         l_cnt    LIKE type_file.num10   #No.FUN-680108 INTEGER

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_obp01 TO NULL        #No.FUN-6A0165

    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_obp.clear()

    CALL i104_cs()                    #取得查詢條件
    IF INT_FLAG THEN                  #使用者不玩了
       LET INT_FLAG = 0
       RETURN
    END IF
    OPEN i104_bcs                     #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN             #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_obp01 TO NULL
    ELSE
        OPEN i104_count                                                     
        FETCH i104_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
        CALL i104_fetch('F')            #讀出TEMP第一筆并顯示
    END IF
END FUNCTION

#處理資料的讀取
FUNCTION i104_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680108 VARCHAR(1)

    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i104_bcs INTO g_obp01
        WHEN 'P' FETCH PREVIOUS i104_bcs INTO g_obp01
        WHEN 'F' FETCH FIRST    i104_bcs INTO g_obp01
        WHEN 'L' FETCH LAST     i104_bcs INTO g_obp01
        WHEN '/' 
         IF (NOT mi_no_ask) THEN      #No.FUN-6A0078
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
         FETCH ABSOLUTE g_jump i104_bcs INTO g_obp01
         LET mi_no_ask = FALSE     #No.FUN-6A0078
    END CASE

    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_obp01,SQLCA.sqlcode,0)
        INITIALIZE g_obp01 TO NULL  #TQC-6B0105
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
    OPEN i104_count
    FETCH i104_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    CALL i104_show()
END FUNCTION

#將資料顯示在畫面上
FUNCTION i104_show()
    DISPLAY g_obp01 TO obp01  #ATTRIBUTE(YELLOW)    #單頭
    
    LET g_obm02=null
    SELECT obm02 INTO g_obm02 FROM obm_file WHERE obm01 = g_obp01
    DISPLAY g_obm02 TO obm02  
    CALL i104_b_fill(g_wc)                    #單身
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

#取消整筆 (所有合乎單頭的資料)
FUNCTION i104_r()
    IF s_shut(0) THEN RETURN END IF           #檢查權限
    IF g_obp01 IS NULL THEN 
       CALL cl_err("",-400,0)                 #No.FUN-6A0165 
       RETURN 
    END IF
    IF cl_delh(0,0) THEN                   #確認一下
        DELETE FROM obp_file WHERE obp01 = g_obp01 
        IF SQLCA.sqlcode THEN
            CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)
        ELSE
            CLEAR FORM
            CALL g_obp.clear()
            LET g_delete='Y'
            LET g_obp01 = NULL
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            OPEN i104_count                                                     
            FETCH i104_count INTO g_row_count                 
            DISPLAY g_row_count TO FORMONLY.cnt               
            OPEN i104_bcs                                      
            IF g_curs_index = g_row_count + 1 THEN            
               LET g_jump = g_row_count                       
               CALL i104_fetch('L')                           
            ELSE                                              
               LET g_jump = g_curs_index                      
               LET mi_no_ask = TRUE      #No.FUN-6A0078                      
               CALL i104_fetch('/')                           
            END IF
        END IF
    END IF
END FUNCTION

#單身
FUNCTION i104_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT #No.FUN-680108 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重復用        #No.FUN-680108 SMALLINT
    l_str           LIKE type_file.chr20,                       #No.FUN-680108 VARCHAR(20)
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否        #No.FUN-680108 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態          #No.FUN-680108 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,     #可新增否          #No.FUN-680108 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否          #No.FUN-680108 SMALLINT

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF cl_null(g_obp01) THEN RETURN END IF


    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT obp02,'',obp03,'',obp04,obp05,obp06,obp07 ",
                       "  FROM obp_file",
                       " WHERE obp01= ?", 
                       "   AND obp02= ?", 
                       "   AND obp03= ?",
                       "   FOR UPDATE NOWAIT"
    DECLARE i104_bcl CURSOR FROM g_forupd_sql 

    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    INPUT ARRAY g_obp WITHOUT DEFAULTS FROM s_obp.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)

    BEFORE INPUT
        DISPLAY "BEFORE INPUT"
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF

    BEFORE ROW
        DISPLAY "BEFORE ROW"
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            IF g_rec_b >=l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_obp_t.* = g_obp[l_ac].*      #BACKUP
                OPEN i104_bcl USING g_obp01,g_obp_t.obp02,g_obp_t.obp03 
                IF STATUS THEN
                   CALL cl_err("OPEN i104_bcl:",STATUS,1)
                   LET l_lock_sw = "Y"
                ELSE
                   IF STATUS THEN
                      CALL cl_err(g_obp_t.obp02,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   ELSE
                      LET g_obp_t.*=g_obp[l_ac].*
                   END IF
                   FETCH i104_bcl INTO g_obp[l_ac].* 
                   SELECT oac02 INTO g_obp[l_ac].oac02 FROM oac_file
                    WHERE oac01 = g_obp[l_ac].obp02
                   SELECT oac02 INTO g_obp[l_ac].oac02a FROM oac_file
                    WHERE oac01 = g_obp[l_ac].obp03
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
        
    BEFORE INSERT
        DISPLAY "BEFORE INSERT"
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_obp[l_ac].* TO NULL      #900423
            LET g_obp[l_ac].obp04 = 0                                       
            LET g_obp[l_ac].obp05 = g_aza.aza17                             
            LET g_obp[l_ac].obp06 = 0                                       
            LET g_obp[l_ac].obp07 = 0
            LET g_obp_t.* = g_obp[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD obp02

    AFTER INSERT
        DISPLAY "AFTER INSERT"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO obp_file(obp01,obp02,obp03,obp04,obp05,obp06,obp07)
                          VALUES(g_obp01,
                                 g_obp[l_ac].obp02,g_obp[l_ac].obp03,
                                 g_obp[l_ac].obp04,g_obp[l_ac].obp05,
                                 g_obp[l_ac].obp06,g_obp[l_ac].obp07)
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_obp[l_ac].obp02,SQLCA.sqlcode,0)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
            END IF

        AFTER FIELD obp02                       
            IF NOT cl_null(g_obp[l_ac].obp02) THEN 
               IF p_cmd = 'a' OR 
                 (p_cmd = 'u' AND g_obp[l_ac].obp02 != g_obp_t.obp02) THEN
                  SELECT oac02 INTO g_obp[l_ac].oac02 FROM oac_file
                   WHERE oac01 = g_obp[l_ac].obp02
                  IF STATUS THEN
                     CALL cl_err(g_obp[l_ac].obp02,'mfg3119',0)
                     NEXT FIELD obp02
                  END IF
               END IF
            END IF

        AFTER FIELD obp03                
            IF NOT cl_null(g_obp[l_ac].obp03) THEN
               IF p_cmd = 'a' OR 
                 (p_cmd = 'u' AND g_obp[l_ac].obp03 != g_obp_t.obp03) THEN
                  SELECT oac02 INTO g_obp[l_ac].oac02a FROM oac_file
                   WHERE oac01 = g_obp[l_ac].obp03 
                  IF STATUS THEN 
                     CALL cl_err(g_obp[l_ac].obp03,'mfg3119',0)   
                     NEXT FIELD obp03 
                  END IF
               END IF
               IF p_cmd = 'a' OR 
                 (p_cmd = 'u' AND (g_obp[l_ac].obp02 != g_obp_t.obp02 OR
                                   g_obp[l_ac].obp03 != g_obp_t.obp03)) THEN
                  SELECT COUNT(*) INTO l_n FROM obp_file
                   WHERE obp01 = g_obp01
                     AND obp02 = g_obp[l_ac].obp02
                     AND obp03 = g_obp[l_ac].obp03
                  IF l_n > 0 THEN
                     CALL cl_err(g_obp[l_ac].obp02,-239,0) NEXT FIELD obp02
                  END IF
               END IF
            END IF

        AFTER FIELD obp04
           IF NOT cl_null(g_obp[l_ac].obp04) THEN
              IF g_obp[l_ac].obp04 < 0 THEN
                 NEXT FIELD obp04
              END IF
           END IF

        AFTER FIELD obp05
           IF NOT cl_null(g_obp[l_ac].obp05) THEN 
              CALL i104_obp05()
              IF NOT cl_null(g_errno) THEN 
                 CALL cl_err(g_obp[l_ac].obp05,g_errno,0) NEXT FIELD obp05
              END IF
           END IF
     
        AFTER FIELD obp06
           IF g_obp[l_ac].obp06 < 0 THEN
              NEXT FIELD obp06
           END IF 
                                                                                
        AFTER FIELD obp07                                                       
           IF NOT cl_null(g_obp[l_ac].obp07) THEN 
              IF g_obp[l_ac].obp07 < 0 THEN          
                 NEXT FIELD obp07
              END IF
           END IF

        BEFORE DELETE                            #是否取消單身
            IF g_obp[l_ac].obp02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
  
                DELETE FROM obp_file
                 WHERE obp01 = g_obp01 
                   AND obp02 = g_obp_t.obp02 AND obp03 = g_obp_t.obp03 
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_obp_t.obp02,SQLCA.sqlcode,0)
                    ROLLBACK WORK
                    CANCEL DELETE 
                    EXIT INPUT
                END IF
            END IF
            COMMIT WORK

    ON ROW CHANGE
        DISPLAY "ON ROW CHANGE"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_obp[l_ac].* = g_obp_t.*
               CLOSE i104_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_obp[l_ac].obp02,-263,1)
               LET g_obp[l_ac].* = g_obp_t.*
            ELSE
               UPDATE obp_file SET obp01=g_obp01,
                                   obp02=g_obp[l_ac].obp02,
                                   obp03=g_obp[l_ac].obp03,
                                   obp04=g_obp[l_ac].obp04,
                                   obp05=g_obp[l_ac].obp05,
                                   obp06=g_obp[l_ac].obp06,
                                   obp07=g_obp[l_ac].obp07
                WHERE obp01 = g_obp01 
                  AND obp02 = g_obp_t.obp02
                  AND obp03 = g_obp_t.obp03
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_obp[l_ac].obp02,SQLCA.sqlcode,0)
                 LET g_obp[l_ac].* = g_obp_t.*
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
                  LET g_obp[l_ac].* = g_obp_t.*
               END IF
               CLOSE i104_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i104_bcl
            COMMIT WORK

 
        ON ACTION controlp
           CASE
              WHEN INFIELD(obp02) #產品名稱
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_oac"
                   LET g_qryparam.default1 = g_obp[l_ac].obp02
                   CALL cl_create_qry() RETURNING g_obp[l_ac].obp02
                  # CALL FGL_DIALOG_SETBUFFER( g_obp[l_ac].obp02 )
                  NEXT FIELD obp02
              WHEN INFIELD(obp03) #幣別
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_oac"
                   LET g_qryparam.default1 = g_obp[l_ac].obp03
                   CALL cl_create_qry() RETURNING g_obp[l_ac].obp03
                   NEXT FIELD obp03
              WHEN INFIELD(obp05) #銷售單位
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_azi"
                   LET g_qryparam.default1 = g_obp[l_ac].obp05
                   CALL cl_create_qry() RETURNING g_obp[l_ac].obp05
                   NEXT FIELD obp05
            END CASE

        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(obp02) AND l_ac > 1 THEN
               LET g_obp[l_ac].* = g_obp[l_ac-1].*
               NEXT FIELD obp02
            END IF

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

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
    CLOSE i104_bcl
    COMMIT WORK

END FUNCTION

FUNCTION i104_obp05()  #幣別                                                    
    DEFINE l_aziacti LIKE azi_file.aziacti                                
                                                                                
    LET g_errno = " "                                                     
    SELECT aziacti INTO l_aziacti FROM azi_file                           
     WHERE azi01 = g_obp[l_ac].obp05         
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'                
                                   LET l_aziacti = 0                      
         WHEN l_aziacti='N' LET g_errno = '9028'                          
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'   
    END CASE                                                              
END FUNCTION            

FUNCTION i104_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000                 #No.FUN-680108 VARCHAR(200)

 CONSTRUCT l_wc ON obp02,obp03,obp04,obp05,obp06,obp07        #螢幕上取條件
       FROM s_obp[1].obp02,s_obp[1].obp03,s_obp[1].obp04,
            s_obp[1].obp05,s_obp[1].obp06,s_obp[1].obp07

       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No:FUN-580031 --end--       HCN

       ON IDLE g_idle_seconds                                                   
          CALL cl_on_idle()                                                     
          CONTINUE CONSTRUCT                                                    

       #No:FUN-580031 --start--     HCN
       ON ACTION qbe_select
           CALL cl_qbe_select() 
       ON ACTION qbe_save
           CALL cl_qbe_save()
       #No:FUN-580031 --end--       HCN
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
  
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
  
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
     END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = FALSE RETURN END IF
    CALL i104_b_fill(l_wc)
END FUNCTION

FUNCTION i104_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000,       #No.FUN-680108 VARCHAR(200)
    l_oac02         LIKE oac_file.oac02,
    l_oac02a        LIKE oac_file.oac02 

    LET g_sql = "SELECT obp02,oac02,obp03,'',obp04,obp05,obp06,obp07 ",
                "  FROM obp_file,OUTER oac_file ",
                " WHERE obp01 = '",g_obp01,"'",
                "   AND oac_file.oac01 = obp02 ",
                "   AND ",p_wc CLIPPED ,
                " ORDER BY 1"
    PREPARE i104_prepare2 FROM g_sql      #預備一下
    DECLARE obp_cs CURSOR FOR i104_prepare2
    CALL g_obp.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH obp_cs INTO g_obp[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT oac02 INTO g_obp[g_cnt].oac02a FROM oac_file  
         WHERE oac01 = g_obp[g_cnt].obp03                                       
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
    END FOREACH
        CALL g_obp.deleteElement(g_cnt)
        LET g_rec_b = g_cnt - 1               #no.6277
        LET g_cnt = 0
END FUNCTION

FUNCTION i104_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_obp TO s_obp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
         CALL i104_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF
           ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION previous
         CALL i104_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION jump 
         CALL i104_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION next
         CALL i104_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION last 
         CALL i104_fetch('L')
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


FUNCTION i104_copy()
DEFINE l_newno1,l_oldno1  LIKE obp_file.obp01,
       l_obm02            LIKE obm_file.obm02,
       p_cmd              LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(1) 
       l_n                LIKE type_file.num5           #No.FUN-680108 SMALLINT

    IF s_shut(0) THEN RETURN END IF
    IF g_obp01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    DISPLAY ' ' TO obm02 ATTRIBUTE(GREEN)

    LET g_before_input_done = FALSE                                             
    CALL i104_set_entry('a')                                                  
    LET g_before_input_done = TRUE  
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

       INPUT l_newno1 FROM obp01
       AFTER FIELD obp01 
            SELECT COUNT(*) INTO l_n FROM obp_file WHERE obp01=l_newno1 
            IF l_n > 0 THEN 
               CALL cl_err(l_newno1,-239,0) NEXT FIELD obp01
            END IF
            SELECT obm02 INTO l_obm02 FROM obm_file WHERE obm01=l_newno1 
            IF STATUS THEN 
               CALL cl_err(l_obm02,STATUS,0) NEXT FIELD obp01
            END IF
            DISPLAY l_obm02 TO obm02 
  
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(obp01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form="q_obm"
                  LET g_qryparam.default1=l_newno1
                  CALL cl_create_qry() RETURNING l_newno1
                  DISPLAY l_newno1 to obp01
                  NEXT FIELD obp01         
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
        LET INT_FLAG = 0 DISPLAY g_obp01 TO obp01 ATTRIBUTE(YELLOW) RETURN
    END IF

    DROP TABLE x
    SELECT * FROM obp_file         #單身複製
        WHERE g_obp01=obp01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
       LET g_msg = g_obp01 CLIPPED
       CALL cl_err(g_msg,SQLCA.sqlcode,0)
       RETURN
    END IF
    UPDATE x SET obp01 = l_newno1 
    INSERT INTO obp_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
       LET g_msg = l_newno1 CLIPPED
       CALL cl_err(g_msg,SQLCA.sqlcode,0)
       RETURN
    END IF
    LET l_oldno1= g_obp01
    LET g_obp01=l_newno1
    CALL i104_b()
    LET g_obp01=l_oldno1
    CALL i104_show()
END FUNCTION

FUNCTION i104_out()
    DEFINE
        l_i             LIKE type_file.num5,     #No.FUN-680108 SMALLINT
        l_obp           RECORD LIKE obp_file.*,
        l_gen           RECORD LIKE gen_file.*,
        l_name          LIKE type_file.chr20,    # External(Disk) file name #No.FUN-680108 VARCHAR(20)
        sr              RECORD 
                        obp01  LIKE obp_file.obp01,
                        obm02  LIKE obm_file.obm02,
                        obp02  LIKE obp_file.obp02,
                        oac02  LIKE oac_file.oac02,
                        obp03  LIKE obp_file.obp03,
                        oac02a LIKE oac_file.oac02,
                        obp04  LIKE obp_file.obp04,
                        obp05  LIKE obp_file.obp05,
                        obp06  LIKE obp_file.obp06,
                        obp07  LIKE obp_file.obp07,
                        azi04  LIKE azi_file.azi04  
                        END RECORD,
         l_za05          LIKE za_file.za05        #MOD-4B0067

    IF cl_null(g_wc) AND NOT cl_null(g_obp01) AND NOT cl_null(g_obp[l_ac].obp02) 
       AND NOT cl_null(g_obp[l_ac].obp03) THEN                          
       LET g_wc = " obp01 = '",g_obp01,"' AND obp02 = '",g_obp[l_ac].obp02,"' AND obp03 = '",g_obp[l_ac].obp03,"'"                                   
    END IF  
    IF g_wc IS NULL OR g_wc =' ' THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('axdi104') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT obp01,obm02,obp02,oac02,obp03,'',obp04,",
              "       obp05,obp06,obp07,azi04",
              "  FROM obp_file,OUTER obm_file,OUTER oac_file,azi_file ",
              " WHERE ",g_wc CLIPPED,
              "   AND obm_file.obm01 = obp01 AND oac_file.oac01 = obp02 ",
              "   AND azi01 = obp05 "
    PREPARE i104_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i104_curo CURSOR FOR i104_p1

    START REPORT i104_rep TO l_name

    FOREACH i104_curo INTO sr.*   
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
        SELECT oac02 INTO sr.oac02a FROM oac_file WHERE  oac01 = sr.obp03
        OUTPUT TO REPORT i104_rep(sr.*)
    END FOREACH

    FINISH REPORT i104_rep

    CLOSE i104_curo
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION

REPORT i104_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,      #No.FUN-680108 VARCHAR(1) 
        l_cnt           LIKE type_file.num10,     #No.FUN-680108 INTEGER 
        sr              RECORD 
                        obp01  LIKE obp_file.obp01,                             
                        obm02  LIKE obm_file.obm02,                             
                        obp02  LIKE obp_file.obp02,                             
                        oac02  LIKE oac_file.oac02,                             
                        obp03  LIKE obp_file.obp03,                             
                        oac02a LIKE oac_file.oac02,                            
                        obp04  LIKE obp_file.obp04,                             
                        obp05  LIKE obp_file.obp05,                             
                        obp06  LIKE obp_file.obp06,                             
                        obp07  LIKE obp_file.obp07,
                        azi04  LIKE azi_file.azi04                              
                        END RECORD

   OUTPUT
       TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line

    ORDER BY sr.obp01,sr.obp02,sr.obp03
    FORMAT
        PAGE HEADER
      PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED                     
            LET g_pageno = g_pageno + 1                                         
            LET pageno_total = PAGENO USING '<<<',"/pageno"                     
            PRINT g_head CLIPPED,pageno_total                                   
      PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]                           
      PRINT ' '                                                                 
      PRINT g_dash[1,g_len]
 #MOD-4B0067(BEGIN)--BY DAY
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
                  g_x[36],g_x[37],g_x[38],g_x[39],g_x[40] 
            PRINT g_dash1
            LET l_trailer_sw = 'y'

        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.obp01 CLIPPED,
                  COLUMN g_c[32],sr.obm02[1,20] CLIPPED,
                  COLUMN g_c[33],sr.obp02 CLIPPED,
                  COLUMN g_c[34],sr.oac02[1,20] CLIPPED,
                  COLUMN g_c[35],sr.obp03 CLIPPED,
                  COLUMN g_c[36],sr.oac02a[1,20] CLIPPED,
                  COLUMN g_c[37],sr.obp04 USING "#####&.&",
                  COLUMN g_c[38],sr.obp05 CLIPPED,
                  COLUMN g_c[39],cl_numfor(sr.obp06,39,sr.azi04),
                  COLUMN g_c[40],cl_numfor(sr.obp07,40,sr.azi04)
 #MOD-4B0067(END)--BY DAY
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'

        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4] CLIPPED,COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
           SKIP 2 LINE
            END IF
END REPORT


FUNCTION i104_set_entry(p_cmd)                                                  
DEFINE   p_cmd     LIKE type_file.chr1            #No.FUN-680108 VARCHAR(1)
                                                                                
   IF (NOT g_before_input_done) THEN                                            
       CALL cl_set_comp_entry("obp01",TRUE)                               
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i104_set_no_entry(p_cmd)                                               
DEFINE   p_cmd     LIKE type_file.chr1            #No.FUN-680108 VARCHAR(1)
                                                                                
   IF (NOT g_before_input_done) THEN                                            
       IF p_cmd = 'u' AND g_chkey = 'N' THEN                                    
           CALL cl_set_comp_entry("obp01",FALSE)                          
       END IF                                                                   
   END IF                                                                       
END FUNCTION
