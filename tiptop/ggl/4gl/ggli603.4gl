# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: ggli603.4gl
# Descriptions...: 股東權益列印報表格式維護作業
# Date & Author..: 01/09/20 By Debbie Hsu
# Modify.........: No.MOD-490344 04/09/20 By Kitty Controlp 未加display
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510007 05/01/20 By Nicola 報表架構修改
# Modify.........: NO.TQC-5B0064 05/11/09 By Niocla 報表修改
# Modify.........: No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.........: No.TQC-630104 06/03/14 By Smapmin DISPLAY ARRAY無控制單身筆數
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型:wq
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0040 06/11/15 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760085 07/07/25 By sherry  報表改由Crystal Report輸出 
# Modify.........: No.FUN-770069 07/10/09 By Sarah 單身刪除的WHERE條件句,atp03的部份應該用g_atp_t.atp03
# Modify.........: No.FUN-980003 09/08/10 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-950114 10/03/09 by huangrh atp02不是KEY，select時去掉
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B60144 11/06/30 By lixiang 單頭增加atp00，單身增加atp09,atp10,atp11,atp12
# Modify.........: NO.FUN-BB0037 11/11/22 By lilingyu 合併報表移植
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_atp00         LIKE atp_file.atp00,      #No.FUN-B60144
    g_atp01         LIKE atp_file.atp01,
    g_atp02         LIKE atp_file.atp02,      #FUN-BB0037
    g_atp00_t       LIKE atp_file.atp00,      #No.FUN-B60144
    g_atp01_t       LIKE atp_file.atp01,
    g_atp02_t       LIKE atp_file.atp02,      #No.FUN-B60144
    g_atp01_o       LIKE atp_file.atp01,
    g_atp           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        atp03       LIKE atp_file.atp03,
        atp09       LIKE atp_file.atp09,      #No.FUN-B60144
        atp10       LIKE atp_file.atp10,      #No.FUN-B60144
        atp04       LIKE atp_file.atp04,
        atp05       LIKE atp_file.atp05,
        atp11       LIKE atp_file.atp11,      #No.FUN-B60144
        atp12       LIKE atp_file.atp12       #No.FUN-B60144
                    END RECORD,
    g_atp_t         RECORD                 #程式變數 (舊值)
        atp03       LIKE atp_file.atp03,
        atp09       LIKE atp_file.atp09,      #No.FUN-B60144
        atp10       LIKE atp_file.atp10,      #No.FUN-B60144
        atp04       LIKE atp_file.atp04,
        atp05       LIKE atp_file.atp05,
        atp11       LIKE atp_file.atp11,      #No.FUN-B60144
        atp12       LIKE atp_file.atp12       #No.FUN-B60144
                    END RECORD,
    i               LIKE type_file.num5,          #No.FUN-680098 SMALLINT
    g_ss            LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
    g_wc,g_sql,g_wc2    STRING,#TQC-630166      
    g_rec_b         LIKE type_file.num5,          #單身筆數        #No.FUN-680098 SMALLINT
    l_ac            LIKE type_file.num5           #目前處理的ARRAY CNT     #No.FUN-680098 SMALLINT
#主程式開始
DEFINE g_forupd_sql         STRING   #SELECT ... FOR UPDATE SQL   
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680098 SMALLINT
DEFINE g_cnt                LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE g_i                  LIKE type_file.num5     #count/index for any purpose  #No.FUN-680098 SMALLLINT
DEFINE g_msg                LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(72)
DEFINE g_row_count          LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE g_curs_index         LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE g_jump               LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE mi_no_ask            LIKE type_file.num5          #No.FUN-680098 SMALLINT
DEFINE g_str                STRING                       #No.FUN-760085
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0073
DEFINE p_row,p_col   LIKE type_file.num5                  #No.FUN-680098       SMALLINT
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   LET i=0
   LET g_atp01_t = NULL
   LET p_row = 3 LET p_col = 8
   OPEN WINDOW i005_w AT p_row,p_col
     WITH FORM "ggl/42f/ggli603"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL i005_menu()
 
   CLOSE FORM i005_w                      #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION i005_cs()
 
   CLEAR FORM                             #清除畫面
   CALL g_atp.clear()
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0029 
 
   INITIALIZE g_atp00 TO NULL    #No.FUN-B60144 
   INITIALIZE g_atp01 TO NULL    #No.FUN-750051
   INITIALIZE g_atp02 TO NULL    #No.FUN-750051
   CONSTRUCT g_wc ON atp01,atp00,atp02,atp03,atp09,atp10,atp04,atp05,atp1,atp12      #No.FUN-B60144 add atp00,atp09,atp10,atp11,atp12
                FROM atp01,atp00,atp02,s_atp[1].atp03,s_atp[1].atp09,s_atp[1].atp10, #No.FUN-B60144 add atp09,atp10 
                     s_atp[1].atp04,s_atp[1].atp05,s_atp[1].atp11,s_atp[1].atp12     #No.FUN-B60144 add atp11,atp12
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(atp00)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form  = "q_aaa"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO atp00
               NEXT FIELD atp00
            WHEN INFIELD(atp04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form  = "q_atn"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_atp[1].atp04
               NEXT FIELD atp04
            OTHERWISE EXIT CASE
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
 
   LET g_sql= "SELECT DISTINCT atp01,atp00,atp02 FROM atp_file ",   #No.FUN-B60144 add atp00
              " WHERE ", g_wc CLIPPED,
              " ORDER BY 1"
   PREPARE i005_prepare FROM g_sql        #預備一下
   DECLARE i005_bcs                       #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR i005_prepare
 
   LET g_sql="SELECT COUNT(DISTINCT atp01)  ",
             " FROM atp_file WHERE ", g_wc CLIPPED
   PREPARE i005_precount FROM g_sql
   DECLARE i005_count CURSOR FOR i005_precount
 
END FUNCTION
 
FUNCTION i005_menu()
 
   WHILE TRUE
      CALL i005_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i005_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i005_q()
            END IF
         #No.FUN-B60144--add--
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i005_u()
            END IF
         #No.FUN-B60144--end--
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i005_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i005_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i005_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i005_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_atp01 IS NOT NULL THEN
                  LET g_doc.column1 = "atp01"
                  LET g_doc.value1 = g_atp01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_atp),'','')
            END IF
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i005_a()
 
   IF s_aglshut(0) THEN RETURN END IF                #判斷目前系統是否可用
   MESSAGE ""
   CLEAR FORM
   CALL g_atp.clear()
   INITIALIZE g_atp01 LIKE atp_file.atp01         #DEFAULT 設定
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i005_i("a")                           #輸入單頭
 
      IF INT_FLAG THEN                           #使用者不玩了
         LET g_atp00=NULL        #No.FUN-B60144 
         LET g_atp01=NULL
         LET g_atp02=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_ss='N' THEN
         CALL g_atp.clear()
         LET g_rec_b = 0
      ELSE
         CALL i005_bf('1=1')         #單身
      END IF
 
      CALL i005_b()                   #輸入單身
 
      LET g_atp01_t = g_atp01                    #保留舊值
      EXIT WHILE
   END WHILE
 
END FUNCTION

#No.FUN-B60144--ADD--
FUNCTION i005_u()
    IF s_shut(0) THEN RETURN END IF                 #判斷目前系統是否可用
    #KEY值不能空白
    IF cl_null(g_atp00) OR cl_null(g_atp01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_atp00_t = g_atp00
    LET g_atp01_t = g_atp01
    LET g_atp02_t = g_atp02
    BEGIN WORK
 
   OPEN i005_bcs                            #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                    #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      CLOSE i005_bcs
      ROLLBACK WORK
      RETURN
    END IF
    DISPLAY g_atp01 TO atp01
    DISPLAY g_atp00 TO atp00
    DISPLAY g_atp02 TO atp02
    WHILE TRUE
      CALL i005_i("u")                           #輸入單頭

      IF INT_FLAG THEN                           #使用者不玩了
         LET g_atp02=g_atp02_t
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      UPDATE atp_file SET atp02= g_atp02
            WHERE atp01 = g_atp01 AND atp00 = g_atp00 
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","atp_file",g_atp00_t,g_atp01_t,SQLCA.sqlcode,"","",1) 
            LET g_atp02=g_atp02_t
            CONTINUE WHILE
        END IF
      EXIT WHILE
   END WHILE
   CLOSE i005_bcs
   COMMIT WORK
END FUNCTION
#No.FUN-B60144--END--
 
FUNCTION i005_i(p_cmd)
DEFINE l_flag          LIKE type_file.chr1,              #判斷必要欄位是否有輸入  #No.FUN-680098 VARCHAR(1)
       l_n1,l_n        LIKE type_file.num5,                                       #No.FUN-680098 smallint
       p_cmd           LIKE type_file.chr1               #a:輸入 u:更改           #No.FUN-680098 VARCHAR(1)
 
   LET g_ss = 'Y'
   DISPLAY g_atp01 TO atp01
   CALL cl_set_head_visible("","YES")                    #No.FUN-6B0029 
 
   INPUT g_atp01,g_atp00,g_atp02 WITHOUT DEFAULTS FROM atp01,atp00,atp02   #No.FUN-B60144 add atp00
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i005_set_entry(p_cmd)
         CALL i005_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD atp01
        #IF NOT cl_null(g_atp01) THEN     #No.FUN-B60144 mark
         IF (NOT cl_null(g_atp01)) AND (NOT cl_null(g_atp00)) THEN     #No.FUN-B60144  
            IF g_atp01 != g_atp01_t OR cl_null(g_atp01_t) THEN  #輸入後更改不同時值
               SELECT DISTINCT atp00,atp01,atp02 INTO g_atp00,g_atp01,g_atp02 FROM atp_file  #No.FUN-B60144 add atp00   
                WHERE atp01=g_atp01 AND atp00=g_atp00                                        #No.FUN-B60144 add atp00
               IF SQLCA.sqlcode THEN#不存在, 新來的
                  IF p_cmd='a' THEN
                     LET g_ss='N'
                  END IF
               ELSE
                  IF p_cmd='u' THEN
                     CALL cl_err(g_atp01,-239,0)
                     LET g_atp01=g_atp01_t
                     DISPLAY g_atp02 TO atp02
                     EXIT INPUT
                  END IF
               END IF
            END IF
         END IF
 
      #No.FUN-B60144--add--
      AFTER FIELD atp00
         IF NOT cl_null(g_atp00) THEN
            SELECT COUNT(*) INTO l_n FROM aaa_file WHERE aaa01=g_atp00
            IF l_n=0 THEN
               LET g_atp00=NULL
               CALL cl_err('',100,0)
               NEXT FIELD atp00
            END IF
         END IF  
         IF (NOT cl_null(g_atp01)) AND (NOT cl_null(g_atp00)) THEN  
            IF g_atp00 != g_atp00_t OR cl_null(g_atp00_t) THEN  #輸入後更改不同時值
               SELECT DISTINCT atp00,atp01,atp02 INTO g_atp00,g_atp01,g_atp02 FROM atp_file  
                WHERE atp01=g_atp01 AND atp00=g_atp00                                       
               IF SQLCA.sqlcode THEN#不存在, 新來的
                  IF p_cmd='a' THEN
                     LET g_ss='N'
                  END IF
               ELSE
                  IF p_cmd='u' THEN
                     CALL cl_err(g_atp00,-239,0)
                     LET g_atp00=g_atp00_t
                     DISPLAY g_atp02 TO atp02
                     EXIT INPUT
                  END IF
               END IF
            END IF
         END IF
   #No.FUN-B60144--end--
     
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(atp00)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aaa"
               LET g_qryparam.default1 = g_atp00
               CALL cl_create_qry() RETURNING g_atp00
               DISPLAY g_atp00 TO atp00
               NEXT FIELD atp00
         END CASE
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
      ON ACTION CONTROLZ
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
 
FUNCTION i005_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("atp01,atp00",TRUE)   #No.FUN-B60144 add atp00
   END IF
 
END FUNCTION
 
FUNCTION i005_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("atp01,atp00",FALSE)  #No.FUN-B60144 add atp00
   END IF
 
END FUNCTION
 
FUNCTION i005_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_atp00 TO NULL               #No.FUN-B60144 
   INITIALIZE g_atp01 TO NULL               #NO.FUN-6B0040
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_atp.clear()
 
   CALL i005_cs()                           #取得查詢條件
 
   IF INT_FLAG THEN                         #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
 
   OPEN i005_bcs                            #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                    #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_atp01 TO NULL
   ELSE
      CALL i005_fetch('F')                  #讀出TEMP第一筆並顯示
      OPEN i005_count
      FETCH i005_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
   END IF
 
END FUNCTION
 
FUNCTION i005_fetch(p_flag)
DEFINE p_flag          LIKE type_file.chr1,      #處理方式          #No.FUN-680098 VARCHAR(1)
       l_abso          LIKE type_file.num10      #絕對的筆數        #No.FUN-680098 integer
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i005_bcs INTO g_atp01,g_atp00,g_atp02  #No.FUN-B60144 add g_atp00
      WHEN 'P' FETCH PREVIOUS i005_bcs INTO g_atp01,g_atp00,g_atp02  #No.FUN-B60144 add g_atp00
      WHEN 'F' FETCH FIRST    i005_bcs INTO g_atp01,g_atp00,g_atp02  #No.FUN-B60144 add g_atp00
      WHEN 'L' FETCH LAST     i005_bcs INTO g_atp01,g_atp00,g_atp02  #No.FUN-B60144 add g_atp00
      WHEN '/'
         IF (NOT mi_no_ask) THEN
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
 
             IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
             END IF
          END IF
 
          FETCH ABSOLUTE g_jump i005_bcs INTO g_atp01,g_atp00,g_atp02    #No.FUN-B60144 add g_atp00
          LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_atp01,SQLCA.sqlcode,0)
      INITIALIZE g_atp00 TO NULL  #No.FUN-B60144 
      INITIALIZE g_atp01 TO NULL  #TQC-6B0105
      INITIALIZE g_atp02 TO NULL  #TQC-6B0105
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      SELECT atp01,atp00,atp02 INTO g_atp01,g_atp00,g_atp02 FROM atp_file    #No.FUN-B60144 add atp00
#      WHERE atp01=g_atp01 AND atp02=g_atp02    #No.TQC-950114                                                                      
       WHERE atp01=g_atp01                      #No.TQC-950114  
         AND atp00=g_atp00                      #No.FUN-B60144
      IF STATUS=100 THEN
         LET g_atp01=' ' 
         LET g_atp00=' '                 #No.FUN-B60144
         LET g_atp02=' '
      END IF
 
      CALL i005_show()
 
   END IF
 
END FUNCTION
 
FUNCTION i005_show()
 
   DISPLAY g_atp01,g_atp00,g_atp02 TO atp01,atp00,atp02  #單頭      #No.FUN-B60144 add atp00
 
   CALL i005_bf(g_wc)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i005_r()
   DEFINE l_chr    LIKE type_file.chr1    #No.FUN-680098 VARCHAR(1)
 
   IF s_aglshut(0) THEN RETURN END IF

   #No.FUN-B60144--add--
   IF cl_null(g_atp00) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   #No.FUN-B60144--end--
 
   IF cl_null(g_atp01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   IF cl_delh(15,16) THEN
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "atp01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_atp01       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                        #No.FUN-9B0098 10/02/24
      DELETE FROM atp_file WHERE atp01=g_atp01 AND atp00=g_atp00  #No.FUN-B60144 add atp00
      IF SQLCA.sqlcode THEN
#        CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)   #No.FUN-660123
         CALL cl_err3("del","atp_file",g_atp01,"",SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660123
      ELSE
         CLEAR FORM
         CALL g_atp.clear()
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
 
         OPEN i005_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i005_bcs
             CLOSE i005_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         FETCH i005_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i005_bcs
             CLOSE i005_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
 
         OPEN i005_bcs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i005_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i005_fetch('/')
         END IF
      END IF
 
      LET g_msg=TIME
      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980003 add plant,legal
                   VALUES ('ggli603',g_user,g_today,g_msg,g_atp01,'delete',g_plant,g_legal) #FUN-980003 add plant,legal
   END IF
 
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i005_b()
DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680098 smallint
       l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680098 smallint
       l_lock_sw       LIKE type_file.chr1,                #單身鎖住否       #No.FUN-680098 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,                #處理狀態         #No.FUN-680098 VARCHAR(1)
       l_sql           STRING,
       l_atn02         LIKE atn_file.atn02,
       l_atp03_o       LIKE atp_file.atp03,
       l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680098 SMALLINT
       l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680098 SMALLINT
 
 
   LET g_action_choice = ""
   IF s_aglshut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = " SELECT atp03,atp09,atp10,atp04,atp05,atp11,atp12 FROM atp_file ",   #No.FUN-B60144 add atp09,atp10,atp11,atp12
                      "  WHERE atp01= ? AND atp00= ? AND atp03= ? FOR UPDATE "              #No.FUN-B60144 add atp00
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i005_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_atp WITHOUT DEFAULTS FROM s_atp.*
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
         LET l_n = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_atp_t.* = g_atp[l_ac].*  #BACKUP
            OPEN i005_bcl USING g_atp01, g_atp00,g_atp_t.atp03   #No.FUN-B60144 add atp00
            IF STATUS THEN
               CALL cl_err("OPEN i005_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i005_bcl INTO g_atp[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_atp_t.atp03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
       # INSERT INTO atp_file(atp01,atp02,atp03,atp04,atp05)         #No.FUN-B60144 mark
       #                VALUES(g_atp01,g_atp02,g_atp[l_ac].atp03,    #No.FUN-B60144 mark
       #                      g_atp[l_ac].atp04,g_atp[l_ac].atp05)   #No.FUN-B60144 mark
         INSERT INTO atp_file(atp00,atp01,atp02,atp03,atp04,atp05,atp09,atp10,atp11,atp12)      #No.FUN-B60144
                        VALUES(g_atp00,g_atp01,g_atp02,g_atp[l_ac].atp03,                       #No.FUN-B60144 
                              g_atp[l_ac].atp04,g_atp[l_ac].atp05,                              #No.FUN-B60144
                              g_atp[l_ac].atp09,g_atp[l_ac].atp10,                              #No.FUN-B60144
                              g_atp[l_ac].atp11,g_atp[l_ac].atp12)                              #No.FUN-B60144  
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_atp[l_ac].atp03,SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("ins","atp_file",g_atp01,g_atp[l_ac].atp03,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_atp[l_ac].* TO NULL      #900423
         LET g_atp[l_ac].atp11=0
         LET g_atp_t.* = g_atp[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD atp03
 
      BEFORE FIELD atp03
         IF cl_null(g_atp[l_ac].atp03) THEN
            SELECT MAX(atp03)+1 INTO g_atp[l_ac].atp03 FROM atp_file
             WHERE atp01=g_atp01
            IF cl_null(g_atp[l_ac].atp03) THEN
               LET g_atp[l_ac].atp03 = 1
            END IF
         END IF
 
      AFTER FIELD atp03
         IF NOT cl_null(g_atp[l_ac].atp03) THEN
            IF g_atp[l_ac].atp03 != g_atp_t.atp03 OR
               g_atp_t.atp03 IS NULL THEN
               SELECT count(*) INTO l_n FROM atp_file
                WHERE atp01 = g_atp01
                  AND atp02 = g_atp02
                  AND atp03 = g_atp[l_ac].atp03
               IF l_n > 0 THEN
                  CALL cl_err(g_atp[l_ac].atp03,-239,0)
                  LET g_atp[l_ac].atp03 = g_atp_t.atp03
                  NEXT FIELD atp03
               END IF
            END IF
         END IF
 
      AFTER FIELD atp04
         IF NOT cl_null(g_atp[l_ac].atp04) THEN
            #FUN-B60144--ADD
            IF NOT cl_null(g_atp[l_ac].atp04) THEN
               SELECT COUNT(*) INTO l_n FROM atn_file WHERE atn01=g_atp[l_ac].atp04
               IF l_n=0 THEN
                  CALL cl_err('',100,0)
                  NEXT FIELD atp04
               END IF
            END IF
           #FUN-B60144--END 
            IF g_atp[l_ac].atp04 != g_atp_t.atp04 OR g_atp_t.atp04 IS NULL THEN
               SELECT atn02 INTO l_atn02 FROM atn_file
                WHERE atn01=g_atp[l_ac].atp04
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_atp[l_ac].atp04,'agl-117',0)   #No.FUN-660123
                  CALL cl_err3("sel","atn_file",g_atp[l_ac].atp04,"","agl-117","","",1)  #No.FUN-660123
                  LET l_atn02 = ' '
                  NEXT FIELD atp04
               END IF
               LET g_atp[l_ac].atp05 = l_atn02
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_atp[l_ac].atp05
               #------MOD-5A0095 END------------
            END IF
         END IF
     
      #FUN-B60144--ADD
       AFTER FIELD atp09
         IF g_atp[l_ac].atp09 MATCHES "[456]" THEN
            CALL cl_set_comp_entry("atp04,atp10,atp12",FALSE)
            LET g_atp[l_ac].atp10='0'
            LET g_atp[l_ac].atp12='0'
            LET g_atp[l_ac].atp04=NULL
         ELSE
            CALL cl_set_comp_entry("atp04,atp10,atp12",TRUE)
         END IF
         IF g_atp[l_ac].atp09 NOT MATCHES "[01234567]" THEN
            NEXT FIELD atp09
         END IF

      #FUN-B60144--END

      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_atp_t.atp03) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
 
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
 
            DELETE FROM atp_file
             WHERE atp01 = g_atp01
               AND atp02 = g_atp02
               AND atp03 = g_atp_t.atp03   #FUN-770069 mod
               AND atp00 = g_atp00         #No.FUN-B60144
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_atp_t.atp03,SQLCA.sqlcode,0)   #No.FUN-660123
               CALL cl_err3("del","atp_file",g_atp01,g_atp_t.atp03,SQLCA.sqlcode,"","",1)  #No.FUN-660123
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_atp[l_ac].* = g_atp_t.*
            CLOSE i005_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_atp[l_ac].atp03,-263,1)
            LET g_atp[l_ac].* = g_atp_t.*
         ELSE
            UPDATE atp_file SET atp03=g_atp[l_ac].atp03,
                                atp04=g_atp[l_ac].atp04,
                                atp05=g_atp[l_ac].atp05,
                                atp09=g_atp[l_ac].atp09,      #No.FUN-B60144
                                atp10=g_atp[l_ac].atp10,      #No.FUN-B60144
                                atp11=g_atp[l_ac].atp11,      #No.FUN-B60144
                                atp12=g_atp[l_ac].atp12       #No.FUN-B60144
             WHERE atp01=g_atp01 AND atp03=g_atp_t.atp03 AND atp00=g_atp00    #No.FUN-B60144
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#              CALL cl_err(g_atp[l_ac].atp03,SQLCA.sqlcode,0)   #No.FUN-660123
               CALL cl_err3("upd","atp_file",g_atp01,g_atp_t.atp03,SQLCA.sqlcode,"","",1)  #No.FUN-660123
               LET g_atp[l_ac].* = g_atp_t.*
               ROLLBACK WORK
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac     #FUN-D30032 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_atp[l_ac].* = g_atp_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_atp.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end-- 
            END IF
            CLOSE i005_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac     #FUN-D30032 Add
         CLOSE i005_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(atp03) AND l_ac > 1 THEN
            LET g_atp[l_ac].* = g_atp[l_ac-1].*
            LET g_atp[l_ac].atp03 = NULL   #TQC-620018
            DISPLAY g_atp[l_ac].* TO s_atp[l_ac].*
            NEXT FIELD atp03
         END IF
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(atp04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_atn01"
               LET g_qryparam.default1 = g_atp[l_ac].atp04
               LET g_qryparam.default2 = g_atp[l_ac].atp05
               CALL cl_create_qry() RETURNING g_atp[l_ac].atp04, g_atp[l_ac].atp05
               DISPLAY BY NAME g_atp[l_ac].atp04               #No.MOD-490344
               DISPLAY BY NAME g_atp[l_ac].atp05               #No.MOD-490344
               NEXT FIELD atp04
            OTHERWISE EXIT CASE
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
#No.FUN-6B0029--beatk                                             
       ON ACTION controls                                        
          CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
   END INPUT
 
   CLOSE i005_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i005_b_askkey()
DEFINE l_wc   LIKE type_file.chr1000 #No.FUN-680098 VARCHAR(200)
 
   CLEAR FORM
   CALL g_atp.clear()
 
   CONSTRUCT l_wc ON atp03,atp09,atp10,atp04,atp05,atp11,atp12  #螢幕上取條件     #No.FUN-B60144 add atp09,atp10,atp11,atp12
        FROM s_atp[1].atp03,s_atp[1].atp09,s_atp[1].atp10,s_atp[1].atp04,s_atp[1].atp05,   #No.FUN-B60144 add atp09,atp10
             s_atp[1].atp11,s_atp[1].atp12                                        #No.FUN-B60144 add atp11,atp12
 
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
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   CALL i005_bf(l_wc)
 
END FUNCTION
 
FUNCTION i005_bf(p_wc)              #BODY FILL UP
DEFINE p_wc     LIKE type_file.chr1000  #No.FUN-680098 VARCHAR(200)
 
   LET g_sql = "SELECT atp03,atp09,atp10,atp04,atp05,atp11,atp12 ",   #No.FUN-B60144 add atp09,atp10,atp11,atp12
               " FROM atp_file ",
               " WHERE atp01 = '",g_atp01,"' ",
               "   AND atp00 = '",g_atp00,"' ",              #No.FUN-B60144 
               "   AND ", p_wc CLIPPED,
               " ORDER BY atp03,atp04 "
 
   PREPARE i005_prepare2 FROM g_sql      #預備一下
   DECLARE atp_cs CURSOR FOR i005_prepare2
 
   CALL g_atp.clear()
 
   LET g_cnt = 1
   LET g_rec_b = 0
   FOREACH atp_cs INTO g_atp[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      #-----TQC-630104---------
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
      #-----END TQC-630104-----
   END FOREACH
   CALL g_atp.deleteElement(g_cnt)
   LET g_rec_b=g_cnt -1
 
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i005_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      #No.FUN-680098  VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_atp TO s_atp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      #No.FUN-B60144--add--
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      #No.FUN-B60144--end--
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first
         CALL i005_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i005_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i005_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i005_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i005_fetch('L')
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
#No.FUN-6B0029--beatk                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i005_copy()
DEFINE l_atp		RECORD LIKE atp_file.*,
       l_sql            LIKE type_file.chr1000,       #No.FUN-680098 VARCHAR(100)
       l_oldno1         LIKE atp_file.atp01,
       l_oldno2         LIKE atp_file.atp02,
       l_oldno3         LIKE atp_file.atp00,          #No.FUN-B60144 
       l_newno1         LIKE atp_file.atp01,
       l_newno2         LIKE atp_file.atp02,
       l_newno3         LIKE atp_file.atp00           #No.FUN-B60144 
 
   IF s_aglshut(0) THEN RETURN END IF

   #No.FUN-B60144--add--
   IF cl_null(g_atp00) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   #No.FUN-B60144--end--
 
   IF cl_null(g_atp01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL i005_set_entry('a')
   LET g_before_input_done = TRUE
   CALL cl_set_head_visible("","YES")                 #No.FUN-6B0029 
 
   INPUT l_newno1,l_newno2,l_newno3 FROM atp01,atp02,atp00   #No.FUN-B60144 add atp00
 
      AFTER FIELD atp01
        #IF NOT cl_null(l_newno1) THEN       #No.FUN-B60144 mark
         IF (NOT cl_null(l_newno1)) AND (NOT cl_null(l_newno3)) THEN       #No.FUN-B60144  
            SELECT count(*) INTO g_cnt FROM atp_file
             WHERE atp01 = l_newno1 AND atp00=l_newno3                   #No.FUN-B60144 add atp00 
            IF g_cnt > 0 THEN
               CALL cl_err(l_newno1,-239,0)
               NEXT FIELD atp01
            END IF
         END IF
      #No.FUN-B60144--add
      AFTER FIELD atp00
         IF (NOT cl_null(l_newno1)) AND (NOT cl_null(l_newno3)) THEN     
            SELECT count(*) INTO g_cnt FROM atp_file
             WHERE atp01 = l_newno1 AND atp00=l_newno3                
            IF g_cnt > 0 THEN
               CALL cl_err(l_newno3,-239,0)
               NEXT FIELD atp00
            END IF
         END IF
      #No.FUN-B60144--end

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
      DISPLAY g_atp00 TO atp00   #No.FUN-B60144
      DISPLAY g_atp01 TO atp01
      DISPLAY g_atp02 TO atp02
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM atp_file         #單身複製
    WHERE atp01=g_atp01 AND atp02=g_atp02 AND atp00=g_atp00   #No.FUN-B60144 add atp00
     INTO TEMP x
 
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_atp01,SQLCA.sqlcode,0)   #No.FUN-660123
      CALL cl_err3("ins","x",g_atp00,g_atp01,SQLCA.sqlcode,"","",1)  #No.FUN-660123
      RETURN
   END IF
 
   UPDATE x SET atp01=l_newno1,atp02=l_newno2,atp00=l_newno3   #No.FUN-B60144 add atp00
 
   INSERT INTO atp_file SELECT * FROM x
 
   IF SQLCA.sqlcode THEN
#     CALL cl_err('atp:',SQLCA.sqlcode,0)   #No.FUN-660123
      CALL cl_err3("ins","atp_file",l_newno1,l_newno2,SQLCA.sqlcode,"","atp:",1)  #No.FUN-660123
      RETURN
   ELSE
      LET g_cnt=SQLCA.SQLERRD[3]
      MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno1,') O.K'

      LET l_oldno3 = g_atp00     #No.FUN-B60144
      LET l_oldno1 = g_atp01
      LET l_oldno2 = g_atp02
 
      SELECT unique atp00,atp01,atp02 INTO g_atp00,g_atp01,g_atp02     #No.FUN-B60144 add atp00
        FROM atp_file
       WHERE atp01 = l_newno1 AND atp02=l_newno2 AND atp00=l_newno3    #No.FUN-B60144 add atp00
      #FUN-C80046---begin
      #SELECT unique atp00,atp01,atp02 INTO g_atp00,g_atp01,g_atp02     #No.FUN-B60144 add atp00
      #  FROM atp_file
      # WHERE atp01 = l_oldno1 AND atp02=l_oldno2 AND atp00=l_oldno3    #No.FUN-B60144 add atp00
      #FUN-C80046---end
      CALL i005_show()
 
   END IF
 
END FUNCTION
 
FUNCTION i005_out()
   DEFINE l_i             LIKE type_file.num5,          #No.FUN-680098 smallint
          l_name          LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680098 VARCHAR(20)
          l_chr           LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
          l_atp           RECORD LIKE atp_file.*
 
   IF g_wc IS NULL THEN
      CALL cl_err('','9057',0)
      RETURN
   END IF
 
   CALL cl_wait()
#  CALL cl_outnam('ggli603') RETURNING l_name     #No.fun-76085   
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog #No.FUN-760085 
  #No.FUN-760085---Beatk
  #LET g_sql="SELECT * FROM atp_file ",          # 組合出 SQL 指令
  #          " WHERE ",g_wc CLIPPED ,
  #          " ORDER BY 1,2,3 "
  #PREPARE i005_p1 FROM g_sql                # RUNTIME 編譯
  #DECLARE i005_co CURSOR FOR i005_p1
 
  #START REPORT i005_rep TO l_name
 
  #FOREACH i005_co INTO l_atp.*
  #   IF SQLCA.sqlcode THEN
  #      CALL cl_err('Foreach:',SQLCA.sqlcode,1)   
  #      EXIT FOREACH
  #   END IF
 
  #   OUTPUT TO REPORT i005_rep(l_atp.*)
 
  #END FOREACH
 
  #FINISH REPORT i005_rep
 
  #CLOSE i005_co
  #ERROR ""
 
  #CALL cl_prt(l_name,' ','1',g_len)
   LET g_sql="SELECT atp01,atp00,atp02,atp03,atp09,atp10,atp04,atp05,atp11,atp12 FROM atp_file ",          # 組合出 SQL 指令     #No.FUN-B60144 add atp00,atp09,atp10,atp11,atp12         
             " WHERE ",g_wc CLIPPED ,                                           
             " ORDER BY 1,2,3 "  
   IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc,'atp01,atp00,atp02,atp03,atp09,atp10,atp04,atp05,atp11,atp12')    #No.FUN-B60144 add atp00,atp09,atp10,atp11,atp12        
            RETURNING g_str                                                     
   END IF
   CALL cl_prt_cs1('ggli603','ggli603',g_sql,g_str)
  #No.FUN-760085---End 
END FUNCTION
 
#No.FUN-760085---End
{
REPORT i005_rep(sr)
   DEFINE l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680098 VARCHAR(1)
          sr              RECORD LIKE atp_file.*,
          l_chr           LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
   DEFINE g_head1         STRING
 
   OUTPUT
      TOP MARGIN g_top_maratk
      LEFT MARGIN g_left_maratk
      BOTTOM MARGIN g_bottom_maratk
      PAGE LENGTH g_page_line
 
   ORDER BY sr.atp01,sr.atp03
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         PRINT
         PRINT g_dash[1,g_len]
         LET g_head1 = g_x[9] CLIPPED,sr.atp01,'     ',g_x[10] CLIPPED,sr.atp02
         PRINT g_head1
         PRINT ' '
         PRINT g_x[31],g_x[32],g_x[33]
         PRINT g_dash1
         LET l_trailer_sw = 'y'
 
      BEFORE GROUP OF sr.atp01
         SKIP TO TOP OF PAGE
 
      ON EVERY ROW
         PRINT COLUMN g_c[31],sr.atp03 USING '###&',
               COLUMN g_c[32],sr.atp04,
               COLUMN g_c[33],sr.atp05
 
      ON LAST ROW
         IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
            CALL cl_wcchp(g_wc,'atp01,atp02,atp03,atp04,atp05') RETURNING g_sql
            PRINT g_dash[1,g_len]
          #TQC-630166
#           IF g_sql[001,080] > ' ' THEN
#    	       PRINT COLUMN g_c[31],g_x[8] CLIPPED,
#                    COLUMN g_c[32],g_sql[001,070] CLIPPED
#           END IF
#           IF g_sql[071,140] > ' ' THEN
#     	       PRINT COLUMN g_c[32],g_sql[071,140] CLIPPED
#           END IF
#           IF g_sql[141,210] > ' ' THEN
#     	       PRINT COLUMN g_c[32],g_sql[141,210] CLIPPED
#           END IF
#          CALL cl_prt_pos_wc(g_sql)
           #END TQC-630166
         END IF
         PRINT g_dash[1,g_len]
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED  #No.TQC-5B0029
         LET l_trailer_sw = 'n'
 
      PAGE TRAILER
         IF l_trailer_sw = 'y' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED   #No.TQC-5B0064
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT
}
#No.FUN-760085---End
#Patch....NO.MOD-5A0095 <001> #
