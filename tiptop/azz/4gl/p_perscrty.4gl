# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: p_perscrty.4gl
# Descriptions...: 畫面設定維護作業
# Date & Author..: 11/12/20 By jrg542
# Modify.........: No.FUN-BC0056 11/12/20 By jrg542 重要資料欄位部分隱藏權限設定
# Modify.........: No:DEV-C50001 12/05/22 By joyce 1.設定完遮罩後自動做r.c2及r.l2
#                                                  2.新增欄位名稱(gae04)欄位
# Modify.........: No:FUN-CA0016 12/12/28 By joyce 1.控卡key值欄位不可設立遮罩，並顯示提示訊息
#                                                  2.取消IMPORT top_chk_dyarr_id的用法，將程式段移到有用到的程式中
# Modify.........: No:FUN-D10008 13/01/09 By joyce 說明若要設定多組以上可視權限，須以"|"區隔
# Modify.........: No:FUN-D30034 13/04/18 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

IMPORT os
#IMPORT FGL top_chk_dyarr_id   # mark by No:FUN-CA0016

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_gdv01         LIKE gdv_file.gdv01,    #目錄代號 (假單頭)
    g_gdv01_t       LIKE gdv_file.gdv01,    #目錄代號 (舊值)
    g_gdv04         LIKE gdv_file.gdv04,    #行業代碼 (假單頭)
    g_gdv04_t       LIKE gdv_file.gdv04,    #行業代碼 (舊值)
    g_gdv03         LIKE gdv_file.gdv03,    #客製欄位 (假單頭)
    g_gdv03_t       LIKE gdv_file.gdv03,    #客製欄位 (舊值)

    g_gaz03          LIKE gaz_file.gaz03,   #畫面名稱
    
    g_gdv           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        gdv02       LIKE gdv_file.gdv02,    #欄位代碼
        gae04       LIKE gae_file.gae04,    #欄位名稱     # No:DEV-C50001
        gdv05       LIKE gdv_file.gdv05,    #使用個資Pattern
        gdv06       LIKE gdv_file.gdv06,    #是否可輸入
        gdv07       LIKE gdv_file.gdv07,    #可閱讀本欄個資的個人
        gdv08       LIKE gdv_file.gdv08     #可閱讀本欄個資的群組
                    END RECORD,
    g_gdv_t         RECORD                  #程式變數 (舊值)
        gdv02       LIKE gdv_file.gdv02,    #欄位代碼
        gae04       LIKE gae_file.gae04,    #欄位名稱     # No:DEV-C50001
        gdv05       LIKE gdv_file.gdv05,    #使用個資Pattern
        gdv06       LIKE gdv_file.gdv06,    #是否可輸入 
        gdv07       LIKE gdv_file.gdv07,    #可閱讀本欄個資的個人
        gdv08       LIKE gdv_file.gdv08     #可閱讀本欄個資的群組
                    END RECORD,

    g_name          LIKE type_file.chr20,   #No.FUN-680102CHAR(10),
    g_wc,g_sql          STRING,  #No.FUN-580092 HCN      
    g_ss            LIKE type_file.chr1,           #No.FUN-680102  VARCHAR(01),            #決定後續步驟
    l_ac            LIKE type_file.num5,           #目前處理的ARRAY CNT        #No.FUN-680102 SMALLINT
    
    g_rec_b         LIKE type_file.num5,           #單身筆數        #No.FUN-680102 SMALLINT
    g_cn2           LIKE type_file.num5            #No.FUN-680102SMALLINT 
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL      
DEFINE g_chr           LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
DEFINE g_before_input_done   LIKE type_file.num5        #FUN-570110        #No.FUN-680102 SMALLINT
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_msg           LIKE ze_file.ze03            #No.FUN-680102CHAR(72)
DEFINE g_row_count     LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_curs_index    LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_gdu01           STRING
DEFINE g_gdu02           STRING
DEFINE g_argv1         LIKE gdv_file.gdv01
DEFINE g_argv2         LIKE gdv_file.gdv03     #MOD-810259


MAIN
    DEFINE l_gdu01       LIKE gdu_file.gdu01
    DEFINE l_gdu02       LIKE gdu_file.gdu02
    DEFINE l_cnt         LIKE type_file.num5
    
    OPTIONS                                    #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵, 由程式處理

   LET g_argv1 = ARG_VAL(1)             #畫面代碼
   LET g_argv2 = UPSHIFT(ARG_VAL(2))    #客製碼
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)              #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
        RETURNING g_time    #No.FUN-6A0081
   LET g_argv1 = ARG_VAL(1)                   #
   LET g_gdv01 = NULL                         #清除鍵值 #畫面代碼
   LET g_gdv01_t = NULL
   LET g_gdv04_t = NULL
   LET g_gdv03_t = NULL
 
   OPEN WINDOW p_perscrty_w WITH FORM "azz/42f/p_perscrty"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN 
   CALL cl_ui_init()
   
   CALL cl_set_combo_industry("gdv04")    #行業別

   LET l_cnt = 0
   
   DECLARE p_perscrty_gdu01_cur CURSOR FOR 
     SELECT gdu01,gdu02 FROM gdu_file 
             ORDER BY gdu01
   FOREACH p_perscrty_gdu01_cur INTO l_gdu01,l_gdu02

      IF cl_null(g_gdu01) AND  cl_null(g_gdu02) THEN
         LET g_gdu01 = l_gdu01
         LET g_gdu02 = l_gdu02
         
      ELSE
         LET g_gdu01 = g_gdu01 CLIPPED,",",l_gdu01 CLIPPED
         LET g_gdu02 = g_gdu02 CLIPPED,",",l_gdu02 CLIPPED
      END IF
   END FOREACH
                            #ps_field_name, ps_values, ps_items 
    CALL cl_set_combo_items("gdv05",g_gdu01,g_gdu02) #combobox

    IF NOT cl_null(g_argv1) THEN
      CALL p_perscrty_q()
    END IF
    
    CALL p_perscrty_menu()                   
    CLOSE WINDOW p_perscrty_w                 #結束畫面

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION p_perscrty_curs()                          # QBE 查詢資料
   CALL g_gdv.clear()
   
   IF cl_null(g_argv1) THEN
      CLEAR FORM                             # 清除畫面
      
      CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
      INITIALIZE g_gdv01 TO NULL    #No.FUN-750051
      
      CONSTRUCT g_wc ON gdv01,gdv02,gdv03,gdv04    # 螢幕上取條件   #FUN-870102
           FROM gdv01,gdv02,gdv03,gdv04
              
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(gdv01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gaz"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1= g_gdv01     #傳值1進去
                  LET g_qryparam.arg1 = g_lang CLIPPED #傳值2進去 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gdv01
                  NEXT FIELD gdv01
             OTHERWISE
                EXIT CASE
            END CASE

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()

      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN RETURN END IF
   ELSE
      LET g_wc=" gdv01='",g_argv1,"'"
      IF NOT cl_null(g_argv2) THEN     
         LET g_wc = g_wc," AND gdv03 = '",g_argv2 CLIPPED,"' "
      END IF
   END IF
   LET g_sql= "SELECT UNIQUE gdv01,gdv04,gdv03 FROM gdv_file ",
              " WHERE ", g_wc CLIPPED

   
   PREPARE p_perscrty_prepare FROM g_sql      #預備一下
   DECLARE p_perscrty_b_curs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR p_perscrty_prepare
 
   LET g_sql = "SELECT COUNT(DISTINCT gdv01) FROM gdv_file ",
               " WHERE ",g_wc CLIPPED
 
   PREPARE p_perscrty_precount FROM g_sql
   DECLARE p_perscrty_count CURSOR FOR p_perscrty_precount
 
END FUNCTION

#主menu 
FUNCTION p_perscrty_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       #No.FUN-680102 VARCHAR(100)  
 
   WHILE TRUE
      CALL p_perscrty_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL p_perscrty_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p_perscrty_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL p_perscrty_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL p_perscrty_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL p_perscrty_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_perscrty_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_gdv01 IS NOT NULL THEN
                  LET g_doc.column1 = "gdv01"
                  LET g_doc.value1 = g_gdv01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gdv),'','')
            END IF
         WHEN "p_scrtyitem" 
         #  IF g_gdv01 IS NOT NULL THEN   # mark by No:FUN-CA0016
               LET g_msg='p_scrtyitem '
               CALL cl_cmdrun_wait(g_msg)
         #  END IF
      END CASE
   END WHILE
END FUNCTION

#新增
FUNCTION p_perscrty_a()                            # Add  輸入
   MESSAGE ""
   CLEAR FORM
   CALL g_gdv.clear()

   WHILE TRUE
      LET g_gdv01 = NULL
      LET g_gdv03 = "N"
      LET g_gdv04 = "std"                 #行業別代碼 FUN-560038
      LET g_gdv01_t = NULL
      LET g_gdv04_t = NULL
      LET g_gdv03_t = NULL
 
      CALL p_perscrty_i("a")                 # 輸入單頭
 
      IF INT_FLAG THEN                       # 使用者不玩了
         INITIALIZE g_gdv01 TO NULL          #預設值及將數值類變數清成零
         INITIALIZE g_gaz03 TO NULL
         INITIALIZE g_gdv03 TO NULL
         INITIALIZE g_gdv04 TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0
      LET g_rec_b=0
      CALL g_gdv.clear()
      IF g_ss='Y' THEN
         CALL p_perscrty_b_fill('1=1')          #單身
      END IF
        
      CALL p_perscrty_b()                          # 輸入單身
      LET g_gdv01_t=g_gdv01                   #畫面代碼 
      LET g_gdv03_t=g_gdv03                   #客製           
      LET g_gdv04_t=g_gdv04                   #行業別 No.FUN-710055
      EXIT WHILE
   END WHILE
END FUNCTION

#修改
FUNCTION p_perscrty_u()
    IF g_gdv01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    LET g_gdv01_t = g_gdv01
    LET g_gdv04_t = g_gdv04
    LET g_gdv03_t = g_gdv03
    WHILE TRUE
        CALL p_perscrty_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_gdv01=g_gdv01_t
            LET g_gdv04=g_gdv04_t
            LET g_gdv03=g_gdv03_t
            DISPLAY g_gdv01 TO gdv01               #單頭
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_gdv01 != g_gdv01_t THEN             #更改單頭值
            UPDATE gdv_file SET gdv01 = g_gdv01  #更新DB
                WHERE gdv01 = g_gdv01_t          #COLAUTH?
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","gdv_file",g_gdv01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION


FUNCTION p_perscrty_i(p_cmd)                   # 處理INPUT
   DEFINE   p_cmd        LIKE type_file.chr1   # a:輸入 u:更改        #No.FUN-680135 VARCHAR(1)
   DEFINE   l_cnt        LIKE type_file.num5
   
   LET g_ss = 'Y'
   DISPLAY g_gdv01,g_gdv04,g_gdv03,g_gaz03 TO gdv01,gdv04,gdv03,gaz03
   CALL cl_set_head_visible("","YES")  
   INPUT g_gdv01,g_gdv04,g_gdv03 WITHOUT DEFAULTS
    FROM gdv01,gdv04,gdv03  #No.FUN-710055
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL p_perscrty_set_entry(p_cmd)
         CALL p_perscrty_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD gdv01 #畫面檔代碼
         IF NOT cl_null(g_gdv01)   THEN
            IF g_gdv01 != g_gdv01_t OR cl_null(g_gdv01_t) THEN
               SELECT COUNT(UNIQUE gav01) INTO g_cnt FROM gav_file
                WHERE gav01 = g_gdv01                
               IF g_cnt > 0 THEN
                  SELECT COUNT(UNIQUE zz01) INTO l_cnt FROM zz_file
                    WHERE zz01 = g_gdv01
                  IF NOT l_cnt > 0 THEN
                      CALL cl_err(g_gdv01,'azz1179',1) #cl_err(訊息(此為子畫面，就不可以使用),代碼,1:開窗 0:右下角)
                      NEXT FIELD gdv01 
                  END IF   
                  LET g_ss = 'Y'
               ELSE    
                  IF p_cmd = 'u' THEN
                     CALL cl_err(g_gdv01,-239,0)
                     LET g_gdv01 = g_gdv01_t
                     NEXT FIELD gdv01
                  ELSE                                             
                     CALL cl_err(g_gdv01,'azz1178',1) #cl_err(訊息(p_per內沒有資料，則不准進行設定作業),代碼,1:開窗 0:右下角)
                     LET g_gdv01 = g_gdv01_t 
                     NEXT FIELD gdv01              
                  END IF
               END IF
               CALL p_perscrty_gaz03()
               DISPLAY g_gaz03 TO gaz03
            END IF

            #暫時不能支援 M-client / B2B
            IF g_gdv01[1,1] = "w" THEN
               CALL cl_err('Error:Cannot Support Web/M-Client/B2B Applications yet.','!',1)
               NEXT FIELD gdv01
            END IF
         END IF
           
      AFTER FIELD gdv04  #行業別
         IF NOT cl_null(g_gdv01) AND NOT cl_null(g_gdv04) THEN
            IF g_gdv04 != g_gdv04_t OR cl_null(g_gdv04_t) THEN
               SELECT COUNT(UNIQUE gav11) INTO g_cnt FROM gav_file
                WHERE gav01=g_gdv01 AND gav11=g_gdv04
                
               IF g_cnt > 0 THEN
                  LET g_ss = 'Y'
               ELSE
                  IF p_cmd = 'u' THEN
                     CALL cl_err(g_gdv04,-239,0)
                     LET g_gdv04 = g_gdv04_t
                     NEXT FIELD gdv04
                  ELSE                                            
                     CALL cl_err(g_gdv01,'azz1178',1) #cl_err(訊息,代碼,1:開窗 0:右下角)
                     LET g_gdv04 = g_gdv04_t
                     NEXT FIELD gdv04               
                  END IF
               END IF
            END IF
         END IF
         
       AFTER FIELD gdv03  #客製欄位
         IF NOT cl_null(g_gdv01) AND NOT cl_null(g_gdv04) 
            AND NOT cl_null(g_gdv03)THEN
            IF g_gdv01 != g_gdv01_t OR cl_null(g_gdv01_t) THEN
                SELECT COUNT(UNIQUE gav08) INTO g_cnt FROM gav_file
                   WHERE gav01=g_gdv01 AND gav08=g_gdv03 AND gav11=g_gdv04                
               IF g_cnt > 0 THEN
                  LET g_ss = 'Y'
               ELSE
                  IF p_cmd = 'u' THEN
                     CALL cl_err(g_gdv03,-239,0)
                     LET g_gdv03 = g_gdv03_t
                     NEXT FIELD gdv03
                  ELSE                                            
                     CALL cl_err(g_gdv01,'azz1178',1) #cl_err(訊息,代碼,1:開窗 0:右下角)
                     LET g_gdv03 = g_gdv03_t
                     NEXT FIELD gdv03                                   
                  END IF
               END IF
            END IF
         END IF
          
      ON ACTION controlp
         CASE
            WHEN INFIELD(gdv01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zz"
               LET g_qryparam.default1= g_gdv01
               LET g_qryparam.arg1 = g_lang CLIPPED   #TQC-6A0010
               CALL cl_create_qry() RETURNING g_gdv01
               NEXT FIELD gdv01
 
            OTHERWISE 
               EXIT CASE
         END CASE
 
      ON ACTION controlf                  #欄位說明
         
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION help
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION about
         CALL cl_about()

   END INPUT
   
END FUNCTION
  
#Query 查詢
FUNCTION p_perscrty_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_gdv01 TO NULL             #No.FUN-6A0015
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL p_perscrty_curs()                 #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN p_perscrty_b_curs                  #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                   #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_gdv01 TO NULL
    ELSE
        CALL p_perscrty_fetch('F')                 #讀出TEMP第一筆並顯示
            OPEN p_perscrty_count
            FETCH p_perscrty_count INTO g_row_count
            
            DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION p_perscrty_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,    #處理方式        #No.FUN-680102 VARCHAR(1)
    l_abso          LIKE type_file.num10    #絕對的筆數      #No.FUN-680102 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     p_perscrty_b_curs INTO g_gdv01,g_gdv04,g_gdv03  
        WHEN 'P' FETCH PREVIOUS p_perscrty_b_curs INTO g_gdv01,g_gdv04,g_gdv03
        WHEN 'F' FETCH FIRST    p_perscrty_b_curs INTO g_gdv01,g_gdv04,g_gdv03
        WHEN 'L' FETCH LAST     p_perscrty_b_curs INTO g_gdv01,g_gdv04,g_gdv03
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
            FETCH ABSOLUTE l_abso p_perscrty_b_curs INTO g_gdv01,g_gdv04,g_gdv03
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_gdv01,SQLCA.sqlcode,0)
#       INITIALIZE g_gdv01 TO NULL
    ELSE
 
        CALL p_perscrty_show()
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

#顯示畫面內容
FUNCTION p_perscrty_show()                         # 將資料顯示在畫面上
   CALL p_perscrty_gaz03()
   DISPLAY g_gdv01,g_gdv04,g_gdv03,g_gaz03 TO gdv01,gdv04,gdv03,gaz03 
   CALL p_perscrty_b_fill(g_wc)                 # 單身   
   CALL cl_show_fld_cont()                    #No.FUN-550037 hmf
END FUNCTION

 
#取消整筆 (所有合乎單頭的資料)
FUNCTION p_perscrty_r()
    IF g_gdv01 IS NULL THEN
       CALL cl_err("",-400,0)              #No.FUN-6A0015
       RETURN
    END IF
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "gdv01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_gdv01       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM gdv_file WHERE gdv01 = g_gdv01
        IF SQLCA.sqlcode THEN
            CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)   #No.FUN-660131
            CALL cl_err3("del","gdv_file",g_gdv01,"",SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660131
        ELSE
            CLEAR FORM
   CALL g_gdv.clear()
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
        END IF
    END IF
END FUNCTION
 
#單身
FUNCTION p_perscrty_b()
   DEFINE l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680102 SMALLINT
          l_n             LIKE type_file.num5,    #檢查重複用        #No.FUN-680102 SMALLINT
          l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680102 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,    #處理狀態          #No.FUN-680102 VARCHAR(1)
          l_tot           LIKE type_file.num5,                       #No.FUN-680102 SMALLINT
          l_allow_insert  LIKE type_file.num5,    #可新增否          #No.FUN-680102 SMALLINT
          l_allow_delete  LIKE type_file.num5,    #可刪除否          #No.FUN-680102 SMALLINT
          l_gau01         LIKE type_file.num5     # 檢查重複用       #No.FUN-680135 SMALLINT
   DEFINE lc_zz01         LIKE zz_file.zz01       # No:DEV-C50001
   DEFINE lc_zz011        LIKE zz_file.zz011      # No:DEV-C50001
   DEFINE lc_cmd          STRING                  # No:DEV-C50001
   DEFINE lst_act         base.StringTokenizer,
          ls_act          STRING
   DEFINE ls_waitcut      STRING
   DEFINE ls_rtnzx01      STRING 
   DEFINE ls_rtnzw01      STRING 
   DEFINE l_cnt           LIKE type_file.num5
   DEFINE ls_k            LIKE type_file.num5     # No:FUN-CA0016
   DEFINE ls_table_name   LIKE type_file.chr20    # No:FUN-CA0016
   DEFINE ls_unique_index_name  LIKE type_file.chr20   # No:FUN-CA0016


    LET g_action_choice = ""
    IF g_gdv01 IS NULL THEN
        RETURN
    END IF

    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT gdv02,'',gdv05,gdv06,gdv07,gdv08  FROM gdv_file WHERE gdv01=? AND gdv02=? FOR UPDATE"    #FUN-870102
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p_perscrty_b_curl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_gdv WITHOUT DEFAULTS FROM s_gdv.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF 
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            DISPLAY l_ac  TO FORMONLY.cn2
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_gdv_t.* = g_gdv[l_ac].*  #BACKUP
                BEGIN WORK
                OPEN p_perscrty_b_curl USING g_gdv01,g_gdv_t.gdv02
                IF STATUS THEN
                   CALL cl_err("OPEN p_perscrty_b_curl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH p_perscrty_b_curl INTO g_gdv[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_gdv_t.gdv02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   ELSE
                       # No:DEV-C50001 ---start---
                       SELECT gae04 INTO g_gdv[l_ac].gae04 FROM gae_file
                        WHERE gae01 = g_gdv01 AND gae03 = g_lang
                          AND gae11 = g_gdv03 AND gae12 = g_gdv04
                          AND gae02 = g_gdv[l_ac].gdv02
                       # No:DEV-C50001 --- end ---
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
             END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_gdv[l_ac].* TO NULL      #900423
            LET g_gdv_t.* = g_gdv[l_ac].*         #新輸入資料

            # No:DEV-C50001 ---start---
            # 可輸入欄位預設為N
            LET g_gdv[l_ac].gdv06 = "0"
            DISPLAY BY NAME g_gdv[l_ac].gdv06
            # No:DEV-C50001 --- end ---

            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD gdv02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF

            INSERT INTO gdv_file(gdv01,gdv02,gdv03,gdv04,gdv05,gdv06,gdv07,gdv08)
                 VALUES(g_gdv01,g_gdv[l_ac].gdv02,g_gdv03,g_gdv04,g_gdv[l_ac].gdv05,g_gdv[l_ac].gdv06,g_gdv[l_ac].gdv07
                        ,g_gdv[l_ac].gdv08)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","gdv_file",g_gdv[l_ac].gdv02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET g_rec_b=g_rec_b+1
            END IF
 
        AFTER FIELD gdv02                        #check 序號是否重複
            IF NOT cl_null(g_gdv01) AND NOT cl_null(g_gdv03) AND
               NOT cl_null(g_gdv04) AND NOT cl_null(g_gdv[l_ac].gdv02) THEN    
            
               IF g_gdv[l_ac].gdv02 != g_gdv_t.gdv02 OR g_gdv_t.gdv02 IS NULL THEN
                  SELECT count(*) INTO l_n FROM gav_file    #畫面輸出欄位格式設定檔
                   WHERE gav01=g_gdv01 AND gav08=g_gdv03 AND gav11=g_gdv04 AND 
                         gav02=g_gdv[l_ac].gdv02
                  IF l_n > 0 THEN     #判斷是否有此資料
                     SELECT count(*) INTO l_n FROM gdv_file   #個資資訊設定檔
                      WHERE gdv01=g_gdv01 AND gdv02=g_gdv[l_ac].gdv02 AND gdv03=g_gdv03
                        AND gdv04=g_gdv04
                     IF l_n > 0 THEN  #判斷是否有此資料
                        CALL cl_err('',-239,0)
                        LET g_gdv[l_ac].gdv02 = g_gdv_t.gdv02
                        NEXT FIELD gdv02
                     END IF 
                  ELSE 
                     CALL cl_err('',-3120,0)  #欄位的錯誤.
                     LET g_gdv[l_ac].gdv02 = g_gdv_t.gdv02
                     NEXT FIELD gdv02 
                  END IF

                  #判斷一下輸入的是否存在於畫面中,若存在的位置是單身中,則必須是主畫面單身
                  IF NOT p_perscrty_gdv02() THEN
                     NEXT FIELD gdv02
                  END IF

                  # No:DEV-C50001 ---start---
                  SELECT gae04 INTO g_gdv[l_ac].gae04 FROM gae_file
                   WHERE gae01 = g_gdv01 AND gae03 = g_lang
                     AND gae11 = g_gdv03 AND gae12 = g_gdv04
                     AND gae02 = g_gdv[l_ac].gdv02
                  DISPLAY BY NAME g_gdv[l_ac].gae04
                  # No:DEV-C50001 --- end ---
               END IF
            END IF

            # No:FUN-CA0016 ---start---
            # 若使用者輸入的欄位是屬於key值欄位，不可設立遮罩
            # 判斷方式：依使用者輸入的欄位取得table name及unique index
            #           再去判斷使用者輸入的欄位是否是unique index中有定義到的欄位
            LET ls_k = 0
            # 取得table name
            SELECT LOWER(table_name) INTO ls_table_name
              FROM all_tab_columns
             WHERE LOWER(owner) = 'ds'
               AND LOWER(column_name) = g_gdv[l_ac].gdv02
               AND LOWER(table_name) LIKE '%_file'

            IF NOT cl_null(ls_table_name) THEN
               # 取得unique key
               SELECT DISTINCT LOWER(index_name) INTO ls_unique_index_name
                 FROM all_indexes
                WHERE LOWER(table_name) = ls_table_name
                  AND LOWER(owner) = 'ds'
                  AND uniqueness = 'UNIQUE'

               IF NOT cl_null(ls_unique_index_name) THEN
                  # 判斷使用者輸入的欄位是否屬於key值欄位
                  SELECT COUNT(*) INTO ls_k
                    FROM all_indexes a,all_ind_columns b
                   WHERE LOWER(a.table_name) = ls_table_name
                     AND LOWER(a.index_name) = ls_unique_index_name
                     AND LOWER(b.column_name) = g_gdv[l_ac].gdv02
                     AND a.index_name = b.index_name
                     AND LOWER(a.owner) = 'ds'
                     AND LOWER(b.index_owner) = 'ds'
                     AND a.owner = b.index_owner
                   ORDER BY column_position
               END IF
            END IF

            IF ls_k > 0 THEN    # 表示使用者輸入的欄位是屬於key值欄位，不可設立遮罩
               CALL cl_err(g_gdv[l_ac].gdv02,"azz1262",0)
               NEXT FIELD gdv02
            END IF
            # No:FUN-CA0016 --- end ---

       AFTER FIELD gdv07
           IF NOT cl_null(g_gdv[l_ac].gdv07) THEN 
              LET ls_waitcut = g_gdv[l_ac].gdv07
              CALL p_perscrty_chkgdv07(ls_waitcut) RETURNING ls_rtnzx01  
              IF cl_null(ls_rtnzx01) THEN 
              #  CALL cl_err(g_gdv[l_ac].gdv07,'azz-512',0) #不存在此表   # No:FUN-D10008
                 CALL cl_err(g_gdv[l_ac].gdv07,'azz1301',0) # No:FUN-D10008
                 NEXT FIELD gdv07
              END IF 
              LET g_gdv[l_ac].gdv07 =  ls_rtnzx01
           END IF # end if
           
       AFTER FIELD gdv08
           IF NOT cl_null(g_gdv[l_ac].gdv08) THEN 
               LET ls_waitcut = g_gdv[l_ac].gdv08               
               CALL  p_perscrty_chkgdv08(ls_waitcut) RETURNING ls_rtnzw01  
                  IF cl_null(ls_rtnzw01) THEN 
                  #  CALL cl_err(g_gdv[l_ac].gdv08,'azz-512',0) #不存在此表   # No:FUN-D10008
                     CALL cl_err(g_gdv[l_ac].gdv08,'azz1301',0) # No:FUN-D10008
                     NEXT FIELD gdv08
                  END IF 
                  LET g_gdv[l_ac].gdv08 =  ls_rtnzw01
           END IF # end if
           
       BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_gdv_t.gdv02) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            IF l_gau01 > 0 THEN  #當刪除為主鍵的其中一筆資料時
               CALL cl_err("Deleting One of Several Primary Keys!","!",1)
            END IF
            DELETE FROM gdv_file WHERE gdv01 = g_gdv01  #畫面代碼
                                   AND gdv03 = g_gdv03  #客製 
                                   AND gdv04 = g_gdv04  #行業別 
                                   AND gdv02 = g_gdv[l_ac].gdv02 #欄位
            IF SQLCA.sqlcode THEN
               
               CALL cl_err3("del","gdv_file",g_gdv01,g_gdv_t.gdv02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF 
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
         
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_gdv[l_ac].* = g_gdv_t.*
               CLOSE p_perscrty_b_curl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_gau01 > 0 THEN
               CALL cl_err("Primary Key CHANGING!","!",1)
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_gdv[l_ac].gdv02,-263,1)
               LET g_gdv[l_ac].* = g_gdv_t.*
            ELSE
              
               UPDATE gdv_file SET gdv02 = g_gdv[l_ac].gdv02,
                                   gdv07 = g_gdv[l_ac].gdv07,
                                   gdv05 = g_gdv[l_ac].gdv05,
                                   gdv06 = g_gdv[l_ac].gdv06,
                                   gdv08 = g_gdv[l_ac].gdv08
                WHERE gdv01 = g_gdv01           #畫面代碼
                AND gdv03 = g_gdv03             #客製 
                AND gdv04 = g_gdv04             #行業別 
                AND gdv02 = g_gdv[l_ac].gdv02   #欄位
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","gdv_file",g_gdv01,g_gdv_t.gdv02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
                   LET g_gdv[l_ac].* = g_gdv_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   #COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D30034
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_gdv[l_ac].* = g_gdv_t.*
               #FUN-D30034--add--str--
               ELSE
                  CALL g_gdv.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end--
               END IF
               CLOSE p_perscrty_b_curl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30034
            CLOSE p_perscrty_b_curl
            COMMIT WORK

        AFTER INPUT
           CALL cl_err(g_gdv01,'azz1180',1)

           # No:DEV-C50001 ---start---
           # 設定完遮罩後自動執行r.c2及r.l2動作
           SELECT unique(zz011) INTO lc_zz011 FROM zz_file
            WHERE zz01 = g_gdv01
           IF NOT cl_null(lc_zz011) THEN
              LET lc_cmd = "cd ",FGL_GETENV(lc_zz011) CLIPPED,"/4gl; r.c2 ",g_gdv01 CLIPPED
              DISPLAY lc_cmd
              RUN lc_cmd

              LET lc_cmd = "cd ",FGL_GETENV(lc_zz011) CLIPPED,"/4gl; r.l2 ",g_gdv01 CLIPPED
              DISPLAY lc_cmd
              RUN lc_cmd
           ELSE
              CALL cl_err(g_gdv01,'azz1234',1)
           END IF
           # No:DEV-C50001 --- end ---

        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(gdv03) AND l_ac > 1 THEN
                LET g_gdv[l_ac].* = g_gdv[l_ac-1].*
                DISPLAY g_gdv[l_ac].* TO s_gdv[l_ac].*
                NEXT FIELD gdv03
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(gdv07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_zx"  
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_gdv[l_ac].gdv07                  
                  CALL cl_create_qry() RETURNING g_gdv[l_ac].gdv07
                  DISPLAY g_gdv[l_ac].gdv07 TO gdv07
                  NEXT FIELD gdv07
 
               WHEN INFIELD(gdv08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_zw"
                  LET g_qryparam.default1 = g_gdv[l_ac].gdv08
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_gdv[l_ac].gdv08
                  DISPLAY g_gdv[l_ac].gdv08 TO gdv08
                  NEXT FIELD gdv08
            END CASE
 
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
 
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
        END INPUT
 
    CLOSE p_perscrty_b_curl
    #COMMIT WORK
END FUNCTION



#判斷一下輸入的是否存在於畫面中,若存在的位置是單身中,則必須是主畫面單身
FUNCTION p_perscrty_gdv02()

   DEFINE lc_channel    base.Channel
   DEFINE ls_path       STRING
   DEFINE ls_cmd        STRING
   DEFINE ls_result     STRING
   DEFINE lc_zmd01      LIKE gao_file.gao01
   DEFINE li_inTable    LIKE type_file.num5
   DEFINE l_doc         om.DomDocument    #For String to Xml    #No:DEV-C50001
   DEFINE l_root        om.DomNode                              #No:DEV-C50001
   DEFINE l_list        om.NodeList                             #No:DEV-C50001

   LET lc_channel = base.Channel.create()
   CALL lc_channel.setDelimiter("")

   IF cl_null(g_gdv01) THEN RETURN FALSE END IF
   IF cl_null(g_gdv03) THEN RETURN FALSE END IF
   LET lc_zmd01 = g_gdv01[1,3]
   LET li_inTable = FALSE

   #定位待調整的畫面檔
   IF g_gdv01[1,1] = "c" OR g_gdv03 = "Y" THEN
      IF lc_zmd01[1,1] = "a"  THEN LET lc_zmd01 = "c",lc_zmd01[2,3] END IF
      IF lc_zmd01[1,1] = "g"  THEN LET lc_zmd01 = "c",lc_zmd01 END IF
      IF lc_zmd01[1,2] = "cg" THEN LET lc_zmd01 = g_gdv01[1,4] END IF
   END IF
   IF g_gdv01[1,2] = "p_" THEN LET lc_zmd01 = "azz" END IF

   LET ls_path = g_gdv01 CLIPPED,".42f"
   LET ls_path = os.Path.join("42f",ls_path)
   LET ls_path = os.Path.join(FGL_GETENV(UPSHIFT(lc_zmd01 CLIPPED)),ls_path)

   #No:DEV-C50001 -- start --
   #判斷一下輸入欄位是否為 TableColumn
   #IF os.Path.separator() = "/" THEN                     #FUN-A40070
   #   LET ls_cmd = "grep -i 'TableColumn' ",ls_path
   #ELSE
   #   LET ls_cmd = 'findstr "TableColumn" ', ls_path
   #END IF
   #CALL lc_channel.openPipe(ls_cmd,"r")
   #WHILE (lc_channel.read(ls_result))
   #   IF ls_result.getIndexOf(g_gdv[l_ac].gdv02 CLIPPED,1) THEN
   #      LET li_inTable = TRUE
   #      EXIT WHILE
   #   END IF
   #END WHILE

   #CALL lc_channel.close()

   
   #判斷一下輸入欄位是否為 TableColumn
   LET l_doc = om.DomDocument.createFromXmlFile(ls_path)
   INITIALIZE l_root TO NULL
   IF l_doc IS NOT NULL THEN
      LET l_root = l_doc.getDocumentElement()
      LET l_list = l_root.selectByPath("//TableColumn[@colName=\"" || g_gdv[l_ac].gdv02 CLIPPED || "\"]")
      IF l_list.getLength() > 0 THEN
         LET li_inTable = TRUE
      END IF
   END IF

   IF NOT li_inTable THEN RETURN TRUE END IF #只要非單身欄位,就可以部分遮罩
   #No:DEV-C50001 -- end --

   #處理 在單身,但是不在指定dynamic array id內的情況 "禁止設定"
   LET ls_path = g_gdv01 CLIPPED,".4gl"
   LET ls_path = os.Path.join("4gl",ls_path)
   LET ls_path = os.Path.join(FGL_GETENV(UPSHIFT(lc_zmd01 CLIPPED)),ls_path)

#  IF NOT top_chk_dyarr_id.chk_table_component(ls_path,g_gdv[l_ac].gdv02) THEN   # mark by No:FUN-CA0016
   IF NOT p_perscrty_chk_table_component(ls_path,g_gdv[l_ac].gdv02) THEN   # No:FUN-CA0016
      CALL cl_err("Error: Not Describing before Main function, Or, Only Support in First TableColumn!","!",1)
      RETURN FALSE
   END IF

   RETURN TRUE

END FUNCTION

 
FUNCTION p_perscrty_b_y()
   DEFINE r,i,j LIKE type_file.num10          #No.FUN-680102 INTEGER 
   DECLARE p_perscrty_b_y_c CURSOR FOR
       SELECT gdv02 FROM gdv_file WHERE gdv01=g_gdv01 ORDER BY gdv03
   BEGIN WORK LET g_success = 'Y'
   LET i=0
   FOREACH p_perscrty_b_y_c INTO j
       IF STATUS THEN
       CALL cl_err('foreach',STATUS,1)    
        LET g_success = 'N' EXIT FOREACH
     END IF
     LET i=i+1
     UPDATE gdv_file SET gdv02 = i WHERE gdv01=g_gdv01 AND gdv02=j
     IF STATUS THEN
        CALL cl_err('upd gdv02',STATUS,1)    #No.FUN-660131
        CALL cl_err3("upd","gdv_file","","",SQLCA.sqlcode,"","upd gdv_file",1)  #No.FUN-660131
        LET g_success = 'N' EXIT FOREACH
     END IF
   END FOREACH
   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK RETURN END IF
END FUNCTION
  

FUNCTION p_perscrty_b_fill(p_wc)              #BODY FILL UP
   DEFINE p_wc         STRING
   DEFINE p_ac         LIKE type_file.num5    #FUN-680135 SMALLINT
   DEFINE li_cnt       LIKE type_file.num5    #No.FUN-710055
   DEFINE lc_gaq06     LIKE gaq_file.gaq06    #No.FUN-7B0080

   LET g_sql = "SELECT gdv02,'',gdv05,gdv06,gdv07,gdv08 ",     #FUN-870102  # No:DEV-C50001
               " FROM gdv_file  WHERE gdv01= '",g_gdv01 CLIPPED,"'", 
               " AND ",p_wc CLIPPED,
               " ORDER BY gdv01"
    PREPARE p_perscrty_prepare2 FROM g_sql           #預備一下
    DECLARE gdv_curs CURSOR FOR p_perscrty_prepare2
 
    CALL g_gdv.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH gdv_curs INTO g_gdv[g_cnt].*       #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       ELSE
          # No:DEV-C50001 ---start---
          SELECT gae04 INTO g_gdv[g_cnt].gae04 FROM gae_file
           WHERE gae01 = g_gdv01 AND gae03 = g_lang
             AND gae11 = g_gdv03 AND gae12 = g_gdv04
             AND gae02 = g_gdv[g_cnt].gdv02
          # No:DEV-C50001 --- end ---
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_gdv.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
 
FUNCTION p_perscrty_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gdv TO s_gdv.*  ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL p_perscrty_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL p_perscrty_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL p_perscrty_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL p_perscrty_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL p_perscrty_fetch('L')
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
 
      ON ACTION CANCEL
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
         
      ON ACTION p_scrtyitem  #No.MOD-470515
         LET g_action_choice="p_scrtyitem"
         EXIT DISPLAY   
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION p_perscrty_copy()
DEFINE
    l_newno         LIKE gdv_file.gdv01
 
    IF g_gdv01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_getmsg('mfg-065',g_lang) RETURNING g_msg  #No.TQC-B90251 
            LET INT_FLAG = 0  ######add for prompt bug
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    PROMPT g_msg CLIPPED,': ' FOR l_newno
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
#          CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END PROMPT
    IF INT_FLAG OR l_newno IS NULL THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    SELECT count(*) INTO g_cnt FROM gdv_file
        WHERE gdv01 = l_newno
    IF g_cnt > 0 THEN
        CALL cl_err(g_gdv01,-239,0)
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM gdv_file
        WHERE gdv01=g_gdv01
        INTO TEMP x
    UPDATE x
        SET gdv01=l_newno     #資料鍵值
    INSERT INTO gdv_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gdv01,SQLCA.sqlcode,0)   #No.FUN-660131
        CALL cl_err3("ins","gdv_file",g_gdv01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
    END IF
END FUNCTION
 

FUNCTION p_perscrty_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("gav03,gav04",TRUE)  #No.FUN-710055
   END IF
 
END FUNCTION
 

FUNCTION p_perscrty_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("gav01,gav03,gav04",FALSE)  #No.FUN-710055
   END IF
END FUNCTION

#取得程式名稱  #No.FUN-BC0056
FUNCTION p_perscrty_gaz03()
 
   DEFINE l_count  LIKE type_file.num5    #FUN-680135 SMALLINT
 
   LET g_gaz03 = ""
   LET l_count = 0
 
   SELECT count(*) INTO l_count FROM gaz_file WHERE gaz01=g_gdv01

   IF l_count > 0 THEN
      SELECT gaz03 INTO g_gaz03 FROM gaz_file
       WHERE gaz01=g_gdv01 AND gaz02=g_lang AND gaz05="Y"
      IF cl_null(g_gaz03) THEN
        SELECT gaz03 INTO g_gaz03 FROM gaz_file
         WHERE gaz01=g_gdv01 AND gaz02=g_lang AND gaz05="N"
      END IF
   ELSE
      SELECT gae04 INTO g_gaz03 FROM gae_file
       WHERE gae01=g_gdv01 AND gae02='wintitle' AND gae03=g_lang AND gae11="Y" AND gae12=g_ui_setting  #No.FUN-710055
      IF cl_null(g_gaz03) THEN
        SELECT gae04 INTO g_gaz03 FROM gae_file
         WHERE gae01=g_gdv01 AND gae02='wintitle' AND gae03=g_lang AND gae11="N" AND gae12=g_ui_setting  #No.FUN-710055
      END IF
   END IF
   
   IF g_gdv01='TopMenuGroup' THEN
      LET g_gaz03='Common Items For TOP Menu'
   END IF
 
   IF g_gdv01='TopProgGroup' THEN
      LET g_gaz03='Program Items For TOP Menu'
   END IF
 
END FUNCTION

#判斷個資的個人 #No.FUN-BC0056
FUNCTION p_perscrty_chkgdv07(ls_waitcut)

    DEFINE lst_act         base.StringTokenizer,
           ls_act          STRING,
           ls_act_temp      STRING
    DEFINE ls_waitcut      STRING
    DEFINE l_cnt           LIKE type_file.num5
    DEFINE ls_zx01         STRING                #組成 
    DEFINE l_zx01          LIKE zx_file.zx01
    DEFINE l_sql           STRING 
    
    LET lst_act = base.StringTokenizer.create(ls_waitcut CLIPPED,"|")
    LET l_cnt = 0
    LET ls_act = ""
    
    WHILE lst_act.hasMoreTokens()
        IF l_cnt > 0 THEN 
             LET ls_act = ls_act,","
        END IF 
        LET ls_act_temp = lst_act.nextToken()
        LET ls_act = ls_act,"'",ls_act_temp.trim(),"'"
        LET l_cnt = l_cnt + 1
        
    END WHILE  
    LET l_cnt = 0

    LET l_sql = "SELECT zx01 FROM zx_file WHERE zx01 IN (",ls_act,")"
    PREPARE p_perscrty_prepare3 FROM l_sql           #預備一下
    DECLARE zx_curs CURSOR FOR p_perscrty_prepare3

    LET ls_zx01 = ""
    FOREACH zx_curs INTO l_zx01 
       IF l_cnt > 0 THEN 
             LET ls_zx01 = ls_zx01,"|"  #多筆帳號 ex: claire|topdemo
       END IF 
       LET ls_zx01 =  ls_zx01,l_zx01   

       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       
       LET l_cnt = l_cnt + 1
    END FOREACH
    RETURN ls_zx01
END FUNCTION

#判斷個資的群組 #No.FUN-BC0056
FUNCTION p_perscrty_chkgdv08(ls_waitcut)

    DEFINE lst_act         base.StringTokenizer,
           ls_act          STRING,
           ls_act_temp      STRING
    DEFINE ls_waitcut      STRING
    DEFINE l_cnt           LIKE type_file.num5
    DEFINE ls_zw01         STRING                #組成 
    DEFINE l_zw01          LIKE zw_file.zw01
    DEFINE l_sql           STRING    
    
    LET lst_act = base.StringTokenizer.create(ls_waitcut CLIPPED, "|")
    LET l_cnt = 0
    LET ls_act = ""
    WHILE lst_act.hasMoreTokens()
        IF l_cnt > 0 THEN 
             LET ls_act = ls_act,","
        END IF 
        LET ls_act_temp = lst_act.nextToken()
        LET ls_act = ls_act,"'",ls_act_temp.trim(),"'"
        LET l_cnt = l_cnt + 1
    END WHILE  
    LET l_cnt = 0

    LET l_sql = "SELECT zw01 FROM zw_file WHERE zw01 IN (",ls_act,")"
    PREPARE p_perscrty_prepare4 FROM l_sql           #預備一下
    DECLARE zw_curs CURSOR FOR p_perscrty_prepare4

    LET ls_zw01 = ""
    FOREACH zw_curs INTO l_zw01 
       IF l_cnt > 0 THEN 
             LET ls_zw01 = ls_zw01,"|"  #多筆群組 ex: claire|topdemo
       END IF 
       LET ls_zw01 =  ls_zw01,l_zw01   

       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF       
       LET l_cnt = l_cnt + 1
    END FOREACH

    RETURN ls_zw01
END FUNCTION

# No:FUN-CA0016 ---start---
FUNCTION p_perscrty_chk_table_component(ls_fileread,ls_comp)

  DEFINE ch_read      base.channel
  DEFINE ls_fileread  STRING
  DEFINE ls_source    STRING
  DEFINE ls_tmp       STRING
  DEFINE ls_backup    STRING
  DEFINE li_chk1      INTEGER
  DEFINE ls_prog      STRING
  DEFINE li_status    INTEGER
  DEFINE lc_gdv01     LIKE gdv_file.gdv01
  DEFINE ls_comp      STRING

  LET ch_read = base.Channel.create() 

  CALL ch_read.openFile(ls_fileread, "r") 
  CALL ch_read.setDelimiter("")

  LET li_status = FALSE
  WHILE TRUE    #ch_read.read(ls_source)

      LET ls_source = ch_read.readLine()
      IF ch_read.iseof() THEN EXIT WHILE END IF

      LET ls_tmp = ls_source.trim()

      IF ls_tmp.subString(1,1) = "#" OR ls_tmp.subString(1,1) = "{" OR ls_tmp.subString(1,2) = "--" THEN
         LET ls_tmp = ""
      ELSE
         LET ls_tmp = ls_source.tolowercase()
      END IF
      IF ls_tmp.getIndexOf("#",1) THEN
         LET ls_tmp = ls_tmp.subString(1,ls_tmp.getIndexOf("#",1)-1)
      END IF

      #偵測到 MAIN or FUNCTION則停止
      IF ls_tmp.getIndexOf("main",1) OR ls_tmp.getIndexOf("function ",1) THEN
         EXIT WHILE
      END IF

      #抓取 "dynamic array "
      IF ls_tmp.getIndexOf("dynamic array of record",1) THEN
         LET ls_tmp = ls_tmp.trim()
         LET ls_tmp = ls_tmp.subString(ls_tmp.getIndexOf("_",1)+1,
                                       ls_tmp.getIndexOf("dynamic array",1)-1)
         LET li_chk1 = TRUE
      END IF

      IF ls_tmp.getIndexOf("end record",1) THEN
         LET li_chk1 = FALSE
         EXIT WHILE
      END IF

      IF li_chk1 THEN
         IF ls_tmp.getIndexOf(ls_comp,1) THEN
            LET li_status = TRUE               #此處若只符合前幾碼,也會過
            EXIT WHILE
         END IF
      END IF

      LET ls_backup = ls_source
  END WHILE 

  CALL ch_read.close() 

  RETURN li_status
END FUNCTION
# No:FUN-CA0016 --- end ---
