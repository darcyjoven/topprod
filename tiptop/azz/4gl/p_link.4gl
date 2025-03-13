# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: p_link.4gl  
# Descriptions...: 連結程式資料維護作業
# Date & Author..: 03/08/22 Letter
# Modify.........: No.MOD-470041 04/07/19 By Wiky 修改INSERT INTO...
# Modify.........: No.MOD-440219 04/07/27 By Ken 修改link抓取檔名問題...O
# Modify.........: No.MOD-4A0204 04/10/13 By Ken 解決p_zz中多個程式代號對應同一支程式時
# Modify.........: No.FUN-4B0049 04/11/19 By Yuna 加轉excel檔功能
# Modify.........: No.MOD-4B0032 04/11/26 By Smapmin 完整路徑補上模組代號
# Modify.........: No.FUN-4B0055 04/12/01 By Smapmin 加上版本編號
# Modify.........: No.MOD-540140 05/04/20 By alex 刪除 HELP FILE
# Modify.........: No.MOD-540163 05/04/29 By alex 刪除錯誤的 order by 用法
# Modify.........: No.MOD-560097 05/06/17 By alex 客製程式無法抓到板號,按X離開未處理
# Modify.........: No.TQC-5B0051 05/11/07 By alex 加一空白以解除問題
# Modify.........: No.TQC-5B0177 06/02/06 By alex 加入close() 敘述
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.MOD-650113 06/05/30 By Nicola 多一個key值gal02
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.TQC-610012 06/07/03 By rainy 單頭資料筆數有問題
# Modify.........: No.FUN-680135 06/08/31 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0080 06/10/23 By Czl g_no_ask改成g_no_ask
# Modify.........: No.FUN-6A0096 06/10/27 By czl l_time轉g_time
# Modify.........: No.MOD-6B0072 06/11/13 By Smapmin 修改變數定義
# Modify.........: No.FUN-6A0092 06/11/27 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.FUN-720042 07/02/27 By Ken for Genero2.0
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740115 07/04/19 By alexstar 在維護單身資料時,如第一個連結的欄位系統別為"aws",直接移到"axm"系統別中,修改程式代號,
#                                                     背影組出來的檔名會為"aws_axmt410.42m"，會找不到檔案
# Modify.........: No.FUN-740100 07/04/22 By alex os.path.separator()
# Modify.........: No.MOD-7B0008 07/11/01 By alexstar 若作業修改[模組代碼]欄位為客製模組時,[完整路徑]不會顯示已變更後的路徑,須重查才會show正確的路徑
# Modify.........: No.MOD-830195 08/03/25 By chenl 增加開窗傳入條件，以符合q_zz中的條件設置。
# Modify.........: No.TQC-860017 08/06/09 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify.........: No.FUN-870105 08/07/30 By Jerry 若user試圖在單身資料內輸入lib/sub/qry等Function,且單頭資料非lib/sub /qry,則進行輸入控管
# Modify.........: No.FUN-880025 08/08/05 By alex 單身無權限會造成回圈
# Modify.........: No.FUN-880083 08/08/20 By alex 檢核程式名稱是否符合命名原則(不擋)
# Modify.........: No.FUN-890001 08/09/01 By alex MSV調整grep -i及相關目錄搜詢語法
# Modify.........: No.FUN-8B0022 08/11/05 By alex 調整修改單身後會回寫gakdate功能
# Modify.........: No.MOD-8C0178 08/12/17 By alex 調整成程式命名原則 csub/clib/cqry
# Modify.........: No.MOD-920198 09/02/16 By alexstar AIX上,channel.open遇到目錄會hang住
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0151 09/11/27 By alex 調整截取 gao02方式，by AP所在平台UNIX/Windows，與db無關
# Modify.........: No.FUN-B50065 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-C60011 12/07/05 By laura 將執行gen42r,在背景產生的錯誤訊息由p_view呈現
# Modify.........: No:FUN-C30027 12/08/15 By bart 複製後停在新資料畫面
# Modify.........: No:FUN-D30034 13/04/18 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

IMPORT os 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_gak          RECORD                     #(假單頭)
         gak01        LIKE gak_file.gak01,
         gakuser      LIKE gak_file.gakuser,
         gakgrup      LIKE gak_file.gakgrup,
         gakmodu      LIKE gak_file.gakmodu,
         gakdate      LIKE gak_file.gakdate,
         gakoriu      LIKE gak_file.gakoriu,      
         gakorig      LIKE gak_file.gakorig      
                  END RECORD,
       g_gak_t        RECORD                     #(舊值)
         gak01        LIKE gak_file.gak01,
         gakuser      LIKE gak_file.gakuser,
         gakgrup      LIKE gak_file.gakgrup,
         gakmodu      LIKE gak_file.gakmodu,
         gakdate      LIKE gak_file.gakdate,
         gakoriu      LIKE gak_file.gakoriu,    
         gakorig      LIKE gak_file.gakorig
                  END RECORD,
       g_gak_o        RECORD                     #(舊值)
         gak01        LIKE gak_file.gak01,
         gakuser      LIKE gak_file.gakuser,
         gakgrup      LIKE gak_file.gakgrup,
         gakmodu      LIKE gak_file.gakmodu,
         gakdate      LIKE gak_file.gakdate,
         gakoriu      LIKE gak_file.gakoriu, 
         gakorig      LIKE gak_file.gakorig  
                  END RECORD,
       g_gak01_t      LIKE gak_file.gak01,     
       g_gaz03        LIKE gaz_file.gaz03,   
       g_gaz03_t      LIKE gaz_file.gaz03,
       g_gal  DYNAMIC ARRAY of RECORD            #程式變數-單身(Program Variables)
         gal02        LIKE gal_file.gal02,       #模組代號
         gal03        LIKE gal_file.gal03,       #程式名稱
         path         LIKE type_file.chr50,      #FUN-680135 #程式完整路徑
         gal04        LIKE gal_file.gal04,       #鏈結否
         ver          LIKE type_file.chr50       #FUN-680135 #小版號
                  END RECORD,
       g_gal_t        RECORD                     #程式變數 (舊值)
         gal02        LIKE gal_file.gal02,       #模組代號
         gal03        LIKE gal_file.gal03,       #程式名稱
         path         LIKE type_file.chr50,      #FUN-680135 #程式完整路徑
         gal04        LIKE gal_file.gal04,       #鏈結否
         ver          LIKE type_file.chr50       #FUN-680135 #小版號
                  END RECORD 
DEFINE   g_argv1             LIKE zz_file.zz01       # 2004/04/27 nicola 接參數用
DEFINE   g_zz011             LIKE zz_file.zz011
DEFINE   l_run               LIKE type_file.chr20    #FUN-680135 
DEFINE   g_rec_b             LIKE type_file.num5     #單身筆數        #No.FUN-680135 SMALLINT
DEFINE   l_ac                LIKE type_file.num5     #目前處理的ARRAY CNT        #No.FUN-680135 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5     #No.FUN-680135 SMALLINT
DEFINE   l_flag              LIKE type_file.num5     #FUN-680135 
DEFINE   g_no_ask            LIKE type_file.num5     #No.FUN-680135  #No.FUN-6A0080 
DEFINE   l_n                 LIKE type_file.num5     #No.FUN-680135 
DEFINE   g_cnt               LIKE type_file.num10    #No.FUN-680135 
DEFINE   g_curs_index        LIKE type_file.num10    #No.FUN-680135 
DEFINE   g_row_count         LIKE type_file.num10    #No.FUN-580092  #No.FUN-680135 INTEGER
DEFINE   g_jump              LIKE type_file.num10    #No.FUN-680135 
DEFINE   l_gao02             LIKE gao_file.gao02
DEFINE   g_wc,g_wc2,g_sql    STRING                  #No.FUN-580092 
DEFINE   g_msg               STRING                  #No.FUN-680135 
DEFINE   g_forupd_sql        STRING
DEFINE   l_cmdstr            STRING                  #UNIX指令字串
DEFINE   l_path              STRING 
DEFINE   l_top               STRING
DEFINE   l_cust              STRING
DEFINE   l_str               STRING
DEFINE   lc_channel          base.Channel            #No.FUN-C60011
 
MAIN
    OPTIONS                                   #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                           #擷取中斷鍵, 由程式處理
 
    LET g_argv1 = ARG_VAL(1)       
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log        #忽略一切錯誤
 
    IF (NOT cl_setup("AZZ")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
    LET g_forupd_sql=" SELECT gak01 FROM gak_file WHERE gak01 = ? FOR UPDATE "  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE link_cl CURSOR FROM g_forupd_sql
 
    OPEN WINDOW p_link_w WITH FORM "azz/42f/p_link"
    ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
    CALL cl_ui_init()
 
    # 2004/03/24 新增語言別選項
    CALL cl_set_combo_module("gal02",1)
 
    IF NOT cl_null(g_argv1) THEN 
       CALL p_link_q()
    END IF
 
    LET l_run  = fgl_getenv('FGLRUN')
    LET l_path = fgl_getenv('DS4GL')
    LET l_top  = fgl_getenv('TOP')
    LET l_cust = fgl_getenv('CUST')
 
    IF cl_null(g_argv1) THEN 
       #將lib,sub,qry 的42m目錄下的檔案名稱載到資料庫
       CALL p_link_delb()  #將不存在lib,sub,qry的42m目錄下的單身資料刪除
       CALL p_link_chk() 
    END IF
 
    IF cl_null(g_argv1) THEN
       INITIALIZE g_gak.* TO NULL
    END IF
    CALL p_link_menu() 
 
    LET INT_FLAG=FALSE
 
    IF g_gak.gak01 = 'lib' OR g_gak.gak01 = 'sub' OR g_gak.gak01 = 'qry' THEN
      CALL cl_confirm("azz-035") RETURNING l_flag
      IF l_flag THEN
 
         LET l_cmdstr = os.Path.join(l_top CLIPPED,g_gak.gak01 CLIPPED) #FUN-890001
         LET l_cmdstr = os.Path.join(l_cmdstr CLIPPED,"42m")
         LET l_cmdstr = os.Path.join(l_cmdstr CLIPPED,g_gak.gak01 CLIPPED||'.42x')
         IF NOT os.Path.delete(l_cmdstr.trim()) THEN
       #    DISPLAY "Delete ",l_cmdstr.trim()," File Failed!"
         END IF
     
         LET l_cmdstr = l_run CLIPPED," ",l_path,os.Path.separator(),"bin",os.Path.separator(),"gen42r.42r ",g_gak.gak01 CLIPPED
         RUN l_cmdstr
 
      END IF  
    END IF
 
    CLOSE WINDOW p_link_w                         #結束畫面

    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料
FUNCTION p_link_cs()
 
   IF cl_null(g_argv1) THEN
      CLEAR FORM                             #清除畫面
      CALL g_gal.clear()
      CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
      CONSTRUCT BY NAME g_wc ON gak01,
            gakuser,gakgrup,gakmodu,gakdate               # 螢幕上取單頭條件
      ON ACTION CONTROLP
        CASE 
            WHEN INFIELD(gak01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zz"
               LET g_qryparam.default1 = g_gak.gak01
               LET g_qryparam.arg1 = g_lang             #No.MOD-830195
               CALL cl_create_qry() RETURNING g_gak.gak01
               #CALL FGL_DIALOG_SETBUFFER( g_gak.gak01 )
               DISPLAY BY NAME g_gak.gak01
               NEXT FIELD gak01
            OTHERWISE
               EXIT CASE
        END CASE
    
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      END CONSTRUCT
      
      IF INT_FLAG THEN RETURN END IF
      
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gakuser', 'gakgrup')
      
      CONSTRUCT g_wc2 ON gal02,gal03,gal04
           FROM s_gal[1].gal02,s_gal[1].gal03,s_gal[1].gal04
      
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      END CONSTRUCT
      IF INT_FLAG THEN
         RETURN
      END IF
   ELSE
      LET g_wc=" gak01='",g_argv1,"'"
      LET g_wc2=" 1=1"
   END IF
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT gak01 FROM gak_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY gak01"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE  gak01 ",
                   "  FROM gak_file, gal_file ",
                   " WHERE gak01 = gal01 ",
                   " AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY gak01"
    END IF
    PREPARE gak_prepare FROM g_sql
    DECLARE gak_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR gak_prepare
    
    IF g_wc2 = " 1=1" THEN
       LET g_sql="SELECT COUNT(UNIQUE gak_file.gak01) FROM gak_file WHERE ",g_wc CLIPPED 
    ELSE
       LET g_sql="SELECT COUNT(UNIQUE gak_file.gak01) FROM gak_file,gal_file  ",      
                 " WHERE ",g_wc CLIPPED, 
                 "   AND ",g_wc2 CLIPPED,
                 "   AND gal01=gak01"
    END IF
 
    PREPARE gak_precount FROM g_sql
    DECLARE gak_count CURSOR FOR gak_precount
 
END FUNCTION
 
 
FUNCTION p_link_menu()
 
   WHILE TRUE
      CALL p_link_bp("G")
      CASE g_action_choice
 
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL p_link_a()
            END IF
 
        WHEN "query"
            IF cl_chk_act_auth() THEN
                CALL p_link_q()
            END IF
 
        WHEN "delete"
            IF cl_chk_act_auth() THEN
                CALL p_link_r()
            END IF
 
        WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_link_b()
            ELSE    #FUN-880025
              LET g_action_choice = NULL
            END IF
 
        WHEN "reproduce"
            IF cl_chk_act_auth() THEN
                 CALL p_link_copy()
            END IF
 
        WHEN "help"
            CALL cl_show_help()
 
        WHEN "exit"
            EXIT WHILE
 
        WHEN "controlg"
            CALL cl_cmdask()
 
        WHEN "exporttoexcel"     #FUN-4B0049
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gal),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION p_link_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
 
    #預設值及將數值類變數清成零
    CLEAR FORM
    CALL g_gal.clear()
    INITIALIZE g_gak.* TO NULL                     #DEFAULT 設定
    LET g_gak01_t = NULL
    LET g_gak_o.* = g_gak.*
 
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_gak.gakuser=g_user
        LET g_gak.gakgrup=g_grup
        LET g_gak.gakmodu=g_user
        LET g_gak.gakdate=g_today
        CALL p_link_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_gak.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
 
        IF g_gak.gak01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
 
        INSERT INTO gak_file(gak01,gakuser,gakgrup,gakmodu,gakdate,gakoriu,gakorig)
                     VALUES (g_gak.gak01, g_gak.gakuser,g_gak.gakgrup,
                             g_gak.gakmodu,g_gak.gakdate, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
 
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
            CALL cl_err3("ins","gak_file",g_gak.gak01,"",SQLCA.sqlcode,"","",1)    #No.FUN-660081
            CONTINUE WHILE
        END IF
 
        SELECT gak01 INTO g_gak.gak01 FROM gak_file
         WHERE gak01 = g_gak.gak01
 
        LET g_gak01_t = g_gak.gak01        #保留舊值
        LET g_gak_t.* = g_gak.*
 
        CALL g_gal.clear()
        LET g_rec_b = 0 
        CALL p_link_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
 
FUNCTION p_link_i(p_cmd)
   DEFINE   #l_flag  LIKE type_file.chr1,     #判斷必要欄位是否有輸入 #No.FUN-680135 
            p_cmd    LIKE type_file.chr1,     #a:輸入 u:更改          #No.FUN-680135
            l_cnt    LIKE type_file.num5      #No.FUN-680135 SMALLINT
   CALL cl_set_head_visible("","YES")         #No.FUN-6A0092
 
   INPUT BY NAME g_gak.* WITHOUT DEFAULTS  
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL p_link_set_entry(p_cmd)
         CALL p_link_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD gak01                  #簽核等級
         IF NOT cl_null(g_gak.gak01) THEN
 
            IF g_gak.gak01 != g_gak01_t OR g_gak01_t IS NULL THEN
               SELECT count(*) INTO g_cnt FROM gak_file
                WHERE gak01 = g_gak.gak01
               IF g_cnt > 0 THEN   #資料重複
                  CALL cl_err(g_gak.gak01,-239,0)
                  LET g_gak.gak01 = g_gak01_t
                  DISPLAY BY NAME g_gak.gak01 
                  NEXT FIELD gak01
               END IF
               LET g_cnt = 0 
               SELECT count(*) INTO g_cnt FROM zz_file 
                WHERE zz01 = g_gak.gak01               
               IF g_cnt = 0 AND ( g_gak.gak01 != 'lib' OR 
                   g_gak.gak01 != 'sub' OR g_gak.gak01 ='qry' )
                                                      THEN  #資料不存在
                  CALL cl_err(g_gak.gak01,'azz-052',0)
                  LET g_gak.gak01 = g_gak01_t
                  DISPLAY BY NAME g_gak.gak01 
                  NEXT FIELD gak01
               END IF
 
            END IF
         END IF
 
      AFTER INPUT 
         IF INT_FLAG THEN
            EXIT INPUT  
         END IF
 
     ON ACTION CONTROLP
        CASE 
            WHEN INFIELD(gak01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zz"
               LET g_qryparam.default1 = g_gak.gak01
               LET g_qryparam.arg1 = g_lang             #No.MOD-830195
               CALL cl_create_qry() RETURNING g_gak.gak01
               DISPLAY BY NAME g_gak.gak01
               NEXT FIELD gak01
            OTHERWISE
               EXIT CASE
        END CASE
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
      #MOD-650015 --start
      # ON ACTION CONTROLO                        # 沿用所有欄位
      #    IF INFIELD(gak01) THEN
      #       LET g_gak.* = g_gak_t.*
      #       DISPLAY BY NAME g_gak.* 
      #       NEXT FIELD gak01
      #    END IF
      #MOD-650015 --end
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
 
 
FUNCTION p_link_set_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680135 
 
      IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("gak01",TRUE)
      END IF
END FUNCTION
 
 
FUNCTION p_link_set_no_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680135 
 
      IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("gak01",FALSE)
      END IF
 
END FUNCTION
 
 
FUNCTION p_link_q()
    CALL cl_opmsg('q')
     LET g_row_count = 0 #No.FUN-580092 HCN
    LET g_curs_index = 0
     CALL cl_navigator_setting(g_curs_index,g_row_count) #No.FUN-580092 HCN
 
    MESSAGE ""
    CLEAR FORM
    DISPLAY '   ' TO FORMONLY.cnt
 
    CALL p_link_cs()
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_gak.* TO NULL
        RETURN
    END IF
 
    MESSAGE " SEARCHING ! " 
 
    OPEN gak_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_gak.* TO NULL
    ELSE
       OPEN gak_count
        FETCH gak_count INTO g_row_count #No.FUN-580092 HCN
        DISPLAY g_row_count TO FORMONLY.cnt #No.FUN-580092 HCN
       CALL p_link_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
 
    MESSAGE ""
END FUNCTION
 
 
#處理資料的讀取
FUNCTION p_link_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,    #處理方式     #No.FUN-680135 
    l_abso          LIKE type_file.num10    #絕對的筆數   #No.FUN-680135 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     gak_cs INTO g_gak.gak01               
        WHEN 'P' FETCH PREVIOUS gak_cs INTO g_gak.gak01               
        WHEN 'F' FETCH FIRST    gak_cs INTO g_gak.gak01                   
        WHEN 'L' FETCH LAST     gak_cs INTO g_gak.gak01
        WHEN '/'
           IF (NOT g_no_ask) THEN          #No.FUN-6A0080
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
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
           FETCH ABSOLUTE g_jump gak_cs INTO g_gak.gak01                   
           LET g_no_ask = FALSE        #No.FUN-6A0080
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gak.gak01,SQLCA.sqlcode,0)
        INITIALIZE g_gak.* TO NULL  #TQC-6B0105
        LET g_gak.gak01 = NULL      #TQC-6B0105
        RETURN
    ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count #No.FUN-580092 HCN
         WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE
 
       CALL cl_navigator_setting(g_curs_index, g_row_count) #No.FUN-580092 HCN
 
    END IF
 
    SELECT gak01,gakuser,gakgrup,gakmodu,gakdate
         INTO g_gak.gak01,g_gak.gakuser,g_gak.gakgrup,
              g_gak.gakmodu,g_gak.gakdate
          FROM gak_file WHERE gak01 = g_gak.gak01
    LET g_gaz03 = NULL
    LET g_zz011 = NULL
 
#   #MOD-540163
    # 2004/04/16 改採多語言架構
    CALL cl_get_progname(g_gak.gak01,g_lang) RETURNING g_gaz03
#   SELECT gaz03 INTO g_gaz03 FROM gaz_file
#    WHERE gaz01 = g_gak.gak01
#      AND gaz02 = g_lang order by gaz05
 
       #MOD-4A0204               #FUN-890001  db內維持 "/"
       LET g_sql="SELECT UNIQUE zz011 FROM zz_file",  
                 " WHERE zz08 MATCHES '*/",g_gak.gak01 CLIPPED," *'"   
 
       PREPARE zz011_prepare FROM g_sql
        DECLARE zz011_cs                         #SCROLL CURSOR
            SCROLL CURSOR WITH HOLD FOR zz011_prepare
 
       # 2004/05/10 依據程式代號抓取模組代號
       #SELECT zz011 INTO g_zz011 FROM zz_file
        #WHERE zz01=g_gak.gak01
 
       OPEN zz011_cs
       FETCH zz011_cs INTO g_zz011
      
       CLOSE zz011_cs
        #MOD-4A0204
 
       IF cl_null(g_zz011) THEN 
          SELECT gal02 INTO g_zz011 FROM gal_file
            WHERE gal01=g_gak.gak01 AND gal03 = g_gak.gak01
 
       END IF
 
    CALL p_link_show()
 
END FUNCTION
 
 
#將資料顯示在畫面上
FUNCTION p_link_show()
    LET g_gak_t.* = g_gak.*                #保存單頭舊值
    LET g_gak_o.* = g_gak.*                #保存單頭舊值
 
    DISPLAY BY NAME g_gak.gak01,
                    g_gak.gakuser,g_gak.gakgrup,
                    g_gak.gakmodu,g_gak.gakdate                   
    DISPLAY g_gaz03 TO FORMONLY.zz02
    DISPLAY g_zz011 TO FORMONLY.zz011
 
    CALL p_link_b_fill(g_wc2)                    #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION p_link_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_gak.gak01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    IF g_gak.gak01 = 'p_link' OR g_gak.gak01 = 'lib'
         OR g_gak.gak01 = 'sub'  OR g_gak.gak01 = 'qry' THEN
       CALL cl_err("","azz-033",1)
       RETURN       
    END IF
    BEGIN WORK
    OPEN link_cl USING g_gak.gak01
    IF SQLCA.sqlcode THEN
        CALL cl_err('OPEN link_cl',SQLCA.sqlcode,1)          #資料被他人LOCK
        RETURN
    END IF
 
    FETCH link_cl INTO g_gak.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err('FETCH link_cl',SQLCA.sqlcode,1)          #資料被他人LOCK
        RETURN
    END IF
    CALL p_link_show()
    IF cl_delh(0,0) THEN                   #確認一下
         DELETE FROM gak_file WHERE gak01 = g_gak.gak01 
         DELETE FROM gal_file WHERE gal01 = g_gak.gak01 
         INITIALIZE g_gak.* TO NULL
         CALL g_gal.clear()
         CLEAR FORM
         OPEN gak_count
         #FUN-B50065-add-start--
         IF STATUS THEN
            CLOSE link_cl
            CLOSE gak_count 
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50065-add-end-- 
         FETCH gak_count INTO g_row_count #No.FUN-580092 HCN
         #FUN-B50065-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE link_cl
            CLOSE gak_count 
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50065-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt #No.FUN-580092 HCN
         OPEN gak_cs
         IF g_curs_index = g_row_count + 1 THEN #No.FUN-580092 HCN
            LET g_jump = g_row_count #No.FUN-580092 HCN
            CALL p_link_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE           #No.FUN-6A0080
            CALL p_link_fetch('/')
         END IF
 
    END IF
    CLOSE link_cl 
    COMMIT WORK 
END FUNCTION
 
 
#單身
FUNCTION p_link_b()
DEFINE
    l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT        #No.FUN-680135 SMALLINT 
    #l_n            LIKE type_file.num5,          #檢查重複用      #No.FUN-680135 SMALLINT
    l_lock_sw       LIKE type_file.chr1,          #單身鎖住否      #No.FUN-680135 
    p_cmd           LIKE type_file.chr1,          #處理狀態        #No.FUN-680135 
    l_cnt           LIKE type_file.num5,          #No.FUN-680135 SMALLINT
    l_allow_insert  LIKE type_file.num5,          #可新增否        #No.FUN-680135 SMALLINT
    l_allow_delete  LIKE type_file.num5,          #可刪除否        #No.FUN-680135 SMALLINT
    l_gal02         STRING,
    l_i             LIKE type_file.num5,          #No.FUN-680135 SMALLINT
    l_length        LIKE type_file.num5           #FUN-680135    SMALLINT
DEFINE lr_msg       DYNAMIC ARRAY OF STRING       #No.FUN-C60011 
DEFINE l_list           base.channel,             #No.FUN-C60011
       l_err_list       base.channel,             #No.FUN-C60011
       l_list_path      STRING,                   #No.FUN-C60011
       l_list_path_err  STRING,                   #No.FUN-C60011
       l_listr          STRING,                   #No.FUN-C60011
       l_success_flag LIKE type_file.chr1         #No.FUN-C60011
  
  
    LET g_action_choice = NULL
    IF s_shut(0) THEN RETURN END IF
    IF g_gak.gak01 IS NULL  THEN
        RETURN
    END IF
    IF g_gak.gak01='p_link' THEN
        CALL cl_err('',"azz-034",1)
        RETURN
    END IF
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    SELECT gak01 INTO g_gak.gak01 FROM gak_file WHERE gak01=g_gak.gak01
   
    CALL cl_opmsg('b')
 
    LET g_forupd_sql=" SELECT gal02,gal03,gal04 ",
                       " FROM gal_file ",
                      " WHERE gal01= ? AND gal02=? AND gal03= ? ",  #No.MOD-650113 # g_gak.gak01 
                        " FOR UPDATE "                 # g_gal_t.gal03 
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE link_bcl CURSOR FROM g_forupd_sql  # LOCK CURSOR
 
    INPUT ARRAY g_gal WITHOUT DEFAULTS FROM s_gal.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
   
    BEFORE INPUT
      IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(l_ac)
      END IF
 
    BEFORE ROW
        LET p_cmd = ''
        LET l_ac = ARR_CURR()
        DISPLAY 1 TO FORMONLY.cn3 
        #LET g_gal_t.* = g_gal[l_ac].*  #BACKUP
        LET l_lock_sw = 'N'            #DEFAULT
        #LET l_n  = ARR_COUNT()
        BEGIN WORK
    
        OPEN link_cl USING g_gak.gak01
        IF SQLCA.sqlcode THEN
           CALL cl_err('OPEN link_cl',SQLCA.sqlcode,1)      # 資料被他人LOCK
           CLOSE link_cl
           ROLLBACK WORK
           RETURN
        END IF
 
        FETCH link_cl INTO g_gak.*            # 鎖住將被更改或取消的資料
        IF SQLCA.sqlcode THEN
           CALL cl_err('FETCH link_cl',SQLCA.sqlcode,1)      # 資料被他人LOCK
           CLOSE link_cl
           ROLLBACK WORK
           RETURN
        END IF
    
        #IF g_gal_t.gal03 IS NOT NULL THEN
        IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_gal_t.* = g_gal[l_ac].*
            OPEN link_bcl USING g_gak.gak01,g_gal_t.gal02,g_gal_t.gal03  #No.MOD-650113
            IF SQLCA.sqlcode THEN
                CALL cl_err('OPEN link_bcl',SQLCA.sqlcode,1)
                LET l_lock_sw = "Y"
            END IF
 
           FETCH link_bcl  INTO g_gal[l_ac].gal02,g_gal[l_ac].gal03,
                                g_gal[l_ac].gal04
 
            IF SQLCA.sqlcode THEN
               CALL cl_err('FETCH link_bcl',SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            CALL p_link_gal03('')
            IF NOT cl_null(g_errno)  THEN
               CALL cl_err('',g_errno,1)
               LET g_gal[l_ac].gal03=g_gal_t.gal03
               NEXT FIELD gal03
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF
 
    BEFORE INSERT
        LET l_n = ARR_COUNT()
        LET p_cmd='a'
        INITIALIZE g_gal[l_ac].* TO NULL        #900423
        #IF g_gak.gak01 !='p_link' THEN
           NEXT FIELD gal02 
        #ELSE
           #CALL cl_err('',"azz-034",1)
           #CANCEL INSERT
           #RETURN
          # EXIT INPUT
        #END IF
         CALL cl_show_fld_cont()     #FUN-550037(smin)
 
    AFTER INSERT
       IF INT_FLAG THEN
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          CANCEL INSERT
       END IF
 
           INSERT INTO gal_file(gal01,gal02,gal03,gal04)
           VALUES(g_gak.gak01,g_gal[l_ac].gal02,
                  g_gal[l_ac].gal03,g_gal[l_ac].gal04)
       IF SQLCA.sqlcode THEN
          #CALL cl_err(g_gal[l_ac].gal03,SQLCA.sqlcode,0)  #No.FUN-660081
          CALL cl_err3("ins","gal_file",g_gak.gak01,g_gal[l_ac].gal02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
          CANCEL INSERT
       ELSE
          MESSAGE 'INSERT O.K'
          COMMIT WORK 
          LET g_rec_b=g_rec_b+1
          DISPLAY g_rec_b TO FORMONLY.cn2  
       END IF
 
    AFTER FIELD gal02                          #模組代號
        SELECT gao02 INTO l_gao02
          FROM gao_file
         WHERE gao01 = g_gal[l_ac].gal02
        CALL p_link_gal03('')       #MOD-7B0008
 
        IF cl_null(l_gao02) THEN
           CALL cl_err('','mfg9089',1) 
           NEXT FIELD gal02
        END IF
 
        #FUN-870105 單頭資料非lib/sub/qry,則不可在 gal02輸入LIB/SUB/QRY模組
        IF g_gal[l_ac].gal02 = 'LIB' OR g_gal[l_ac].gal02 = 'SUB' OR
           g_gal[l_ac].gal02 = 'QRY' THEN
           IF (g_gak.gak01="lib" AND g_gal[l_ac].gal02 = "LIB") OR
              (g_gak.gak01="sub" AND g_gal[l_ac].gal02 = "SUB") OR
              (g_gak.gak01="qry" AND g_gal[l_ac].gal02 = "QRY") THEN
           ELSE
              CALL cl_err('','azz-148',1)
              NEXT FIELD gal02
           END IF
        END IF
 
    BEFORE FIELD gal03   #TQC-740115
       SELECT gao02 INTO l_gao02
         FROM gao_file
        WHERE gao01 = g_gal[l_ac].gal02
 
       IF cl_null(l_gao02) THEN
            CALL cl_err('','mfg9089',1)
            NEXT FIELD gal02
       END IF
 
    AFTER FIELD gal03 
       LET l_cnt=0  	
       LET l_gal02 = l_gao02 CLIPPED
       LET l_length = l_gal02.getLength()
 
       #FUN-890001 FUN-9B0151 依AP Server所在平台而定，若UNIX則"/" 若Windows則"\" 
       LET l_i = l_gal02.getIndexOf(os.Path.separator(),1)
 
       LET l_gal02 = l_gal02.subString(l_i+1,l_length)
 
       IF g_gal[l_ac].gal03 != g_gal_t.gal03 OR g_gal_t.gal03 IS NULL THEN
       
          #FUN-880083 在各模組中不可以出現非該模組下的作業,並需符合命名規則
          IF g_gal[l_ac].gal02 <> 'LIB' AND g_gal[l_ac].gal02 <> 'SUB' AND
             g_gal[l_ac].gal02 <> 'QRY' AND g_gal[l_ac].gal02 <> "AZZ" AND
             g_gal[l_ac].gal02 <> "CZZ" THEN
             WHILE TRUE
                LET g_msg = DOWNSHIFT(g_gal[l_ac].gal03)
                IF g_msg.getLength() <= 5 THEN
                   CALL cl_err_msg(NULL,"azz-149",g_gal[l_ac].gal03||"|"||g_gal[l_ac].gal02,10)
                   EXIT WHILE
                END IF
                LET g_msg = DOWNSHIFT(g_gal[l_ac].gal02)
                IF g_msg.getLength() >= (40 - 1) THEN EXIT WHILE END IF
                #允許axmt410.4gl在axm下
                IF g_gal[l_ac].gal03[1,g_msg.getLength()] = g_msg.trim() THEN
                   EXIT WHILE
                END IF
                #允許saxmt400.4gl在axm下
                IF g_gal[l_ac].gal03[1,g_msg.getLength()+1] = "s"||g_msg.trim() THEN
                   EXIT WHILE
                END IF
                IF g_gal[l_ac].gal02[1,2] = "CG" THEN
                   #允許ggli010.4gl在cggl下
                   IF g_gal[l_ac].gal03[1,g_msg.getLength()-1] = g_msg.subString(2,g_msg.getLength()) THEN
                      EXIT WHILE
                   END IF
                   #允許sggli010.4gl在cggl下
                   IF g_gal[l_ac].gal03[1,g_msg.getLength()] = "s"||g_msg.subString(2,g_msg.getLength()) THEN
                      EXIT WHILE
                   END IF
                END IF
                IF g_gal[l_ac].gal02[1,1] = "C" THEN
                   #允許ccl_X or cl_X 在clib下  #MOD-8C0178
                   IF g_msg = "clib" AND ( g_gal[l_ac].gal03[1,3] = "cl_" OR g_gal[l_ac].gal03[1,4] = "ccl_" ) THEN
                      EXIT WHILE
                   END IF
                   #允許cs_X or s_X 在csub下  #MOD-8C0178
                   IF g_msg = "csub" AND ( g_gal[l_ac].gal03[1,2] = "s_" OR g_gal[l_ac].gal03[1,3] = "cs_" ) THEN
                      EXIT WHILE
                   END IF
                   #允許cq_X or q_X 在cqry下  #MOD-8C0178
                   IF g_msg = "cqry" AND ( g_gal[l_ac].gal03[1,2] = "q_" OR g_gal[l_ac].gal03[1,3] = "cq_" ) THEN
                      EXIT WHILE
                   END IF
                   #允許axmt410.4gl在cxm下
                   IF g_gal[l_ac].gal03[1,g_msg.getLength()] = "a"||g_msg.subString(2,g_msg.getLength()) THEN
                      EXIT WHILE
                   END IF
                   #允許saxmt400.4gl在cxm下
                   IF g_gal[l_ac].gal03[1,g_msg.getLength()+1] = "sa"||g_msg.subString(2,g_msg.getLength()) THEN
                      EXIT WHILE
                   END IF
                END IF
                CALL cl_err_msg(NULL,"azz-149",g_gal[l_ac].gal03||"|"||g_gal[l_ac].gal02,10)
                EXIT WHILE
             END WHILE
          END IF
 
         #07/04/22 FUN-740100 by hjwang 
         #LET l_cmdstr = 'ls -l ',l_gao02 CLIPPED,'/42m/',
         #               l_gal02 CLIPPED,'_',
         #               g_gal[l_ac].gal03 CLIPPED,'.42m'
         #RUN l_cmdstr RETURNING l_n  
         #IF l_n != 0 THEN        
         #   CALL cl_err('','azz-031',1)  
         #   LET g_gal[l_ac].gal03 = NULL
         #   NEXT FIELD gal03
         #ELSE
         #   CALL p_link_gal03('a')
         #END IF
      
          LET l_cmdstr = l_gao02 CLIPPED
          IF os.path.separator() = "/" THEN
             LET l_cmdstr = FGL_GETENV(l_cmdstr.subString(l_cmdstr.getIndexOf("$",1)+1,l_cmdstr.getIndexOf("/",1)-1)),
                            os.path.separator(),l_cmdstr.subString(l_cmdstr.getIndexOf("/",1)+1,l_cmdstr.getLength())
          ELSE
             LET l_cmdstr = FGL_GETENV(l_cmdstr.subString(l_cmdstr.getIndexOf("%",1)+1,l_cmdstr.getIndexOf("%",2)-1)),
                            os.path.separator(),l_cmdstr.subString(l_cmdstr.getIndexOf("%",2)+2,l_cmdstr.getLength())
          END IF
          LET l_cmdstr = l_cmdstr.trim(),os.Path.separator(),"42m",os.Path.separator(),
                         l_gal02 CLIPPED,"_",g_gal[l_ac].gal03 CLIPPED,".42m"
 
          IF NOT os.Path.exists(l_cmdstr.trim()) THEN        
             CALL cl_err('','azz-031',1)  
             LET g_gal[l_ac].gal03 = NULL
             NEXT FIELD gal03
          ELSE
             CALL p_link_gal03('a')
          END IF
       END IF
  
    BEFORE DELETE                            #是否取消單身
        IF g_gal_t.gal03 IS NOT NULL THEN
           IF NOT cl_delete() THEN
              CANCEL DELETE
           END IF
           IF l_lock_sw = "Y" THEN
              CALL cl_err("",-263,1)
              CANCEL DELETE
           END IF               
           DELETE FROM gal_file
               WHERE gal01 = g_gak.gak01 
                 AND gal02 = g_gal_t.gal02   #No.MOD-650113
                 AND gal03 = g_gal_t.gal03 
           IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gal_t.gal03,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","gal_file",g_gak.gak01,g_gal_t.gal02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE 
           END IF
           LET g_rec_b=g_rec_b-1
           DISPLAY g_rec_b TO FORMONLY.cn2
           MESSAGE "Delete Ok"
           CLOSE link_bcl 
           COMMIT WORK
        END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_gal[l_ac].* = g_gal_t.*
              CLOSE link_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_gal[l_ac].gal03,-263,1)
              LET g_gal[l_ac].* = g_gal_t.*
           ELSE
              UPDATE gal_file SET gal01 = g_gak.gak01,
                                  gal02 = g_gal[l_ac].gal02,
                                  gal03 = g_gal[l_ac].gal03,  
                                  gal04 = g_gal[l_ac].gal04
               WHERE gal01=g_gak.gak01
                 AND gal02 = g_gal_t.gal02   #No.MOD-650113
                 AND gal03=g_gal_t.gal03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 #CALL cl_err(g_gal[l_ac].gal03,SQLCA.sqlcode,0)  #No.FUN-660081
                 CALL cl_err3("upd","gal_file",g_gak.gak01,g_gal_t.gal02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                LET g_gal_t.* = g_gal[l_ac].*          # 900423
                 CLOSE link_bcl
                 ROLLBACK WORK
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK 
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
#          LET l_ac_t = l_ac           #FUN-D30034 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_gal[l_ac].* = g_gal_t.*
              #FUN-D30034---add---str---
              ELSE
                 CALL g_gal.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034---add---end---
              END IF
              CLOSE link_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac           #FUN-D30034 add
           CLOSE link_bcl
           COMMIT WORK
 
        ON ACTION CONTROLX
           LET g_msg = 'p_zmd "',g_gal[l_ac].gal02,'" '
           CALL cl_cmdrun(g_msg CLIPPED)
 
        ON ACTION CONTROLN
            CALL p_link_b_askkey()
            EXIT INPUT
 
        ON ACTION controls                 
           CALL cl_set_head_visible("","AUTO") 
 
        ON ACTION CONTROLO
           IF INFIELD(gal03) AND 1 > 1 THEN
              LET g_gal[l_ac].* = g_gal[l_ac-1].*
              NEXT FIELD gal03 
           END IF
           
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
 
    #FUN-8B0022
    LET g_gak.gakmodu = g_user
    LET g_gak.gakdate = g_today
    UPDATE gak_file SET gakmodu = g_gak.gakmodu,gakdate = g_gak.gakdate
     WHERE gak01 = g_gak.gak01
    DISPLAY BY NAME g_gak.gakmodu,g_gak.gakdate
    #FUN-8B0022
 
    CLOSE link_bcl
    CLOSE link_cl
    COMMIT WORK 
 
    IF g_gak.gak01 != "lib" AND g_gak.gak01 != "sub" AND  g_gak.gak01 != "qry" THEN
      CALL cl_confirm("azz-036") RETURNING l_flag
    END IF
    IF l_flag THEN
      # 07/04/22 FUN-740100 by hjwang
      # #No.FUN-720042 07/02/27 By Ken for Genero2.0
      ##LET l_cmdstr = l_run CLIPPED," ",l_path,"/bin/gen42r.42m ",g_gak.gak01 CLIPPED
      # LET l_cmdstr = l_run CLIPPED," ",l_path,"/bin/gen42r.42r ",g_gak.gak01 CLIPPED

       #No:FUN-C60011 --start--       
       #LET l_cmdstr = l_run CLIPPED," ",l_path, os.Path.separator(), "bin", os.Path.separator(),"gen42r.42r ",g_gak.gak01 CLIPPED    #No:FUN-C60011--mark--
       LET l_cmdstr = l_run CLIPPED," ",l_path, os.Path.separator(), "bin", os.Path.separator(),"gen42r.42r ",g_gak.gak01 CLIPPED," > $TEMPDIR/link_msg 2>&1"
       RUN l_cmdstr   
       #寫入檔案$TEMPDIR/link_msg
       LET l_success_flag = 'N'
       LET l_list_path = FGL_GETENV("TEMPDIR"),"/","link_msg"
       LET l_list_path_err = FGL_GETENV("TEMPDIR"),"/","link_msg_err"
       LET l_err_list=base.channel.create()
       CALL l_err_list.setdelimiter("")
       CALL l_err_list.openfile(l_list_path_err CLIPPED, "w" ) 
       LET l_list=base.channel.create()
       CALL l_list.setdelimiter("")
       CALL l_list.openfile(l_list_path CLIPPED, "r" )
       WHILE l_list.read(l_listr)
          CALL l_err_list.write(l_listr)
          IF l_listr.getIndexOf("successfully", 1) THEN
             LET l_success_flag = 'Y'
          END IF
          DISPLAY l_listr 
       END WHILE
       CALL l_list.close()
       CALL l_err_list.close()
       IF l_success_flag <> 'Y' THEN 
          LET l_cmdstr=FGL_GETENV("FGLRUN") ," ",FGL_GETENV("TOP"),os.Path.separator(),"azz",os.Path.separator(),          
                       "42r",os.Path.separator(),"p_view.42r ",os.Path.join(FGL_GETENV("TEMPDIR"),"link_msg")," 66"     
          RUN l_cmdstr  
       END IF 
       IF os.Path.exists(os.Path.join(FGL_GETENV("TEMPDIR"),"link_msg")) THEN
          LET l_cmdstr = "rm ",os.Path.join(FGL_GETENV("TEMPDIR"),"link_msg")
          RUN l_cmdstr
       END IF    
       IF os.Path.exists(os.Path.join(FGL_GETENV("TEMPDIR"),"link_msg_err")) THEN
          LET l_cmdstr = "rm ",os.Path.join(FGL_GETENV("TEMPDIR"),"link_msg_err")
          RUN l_cmdstr
       END IF
       #No:FUN-C60011 --end--       
    END IF  
      
    CALL p_link_delall()
 
END FUNCTION
 
FUNCTION p_link_copy()
DEFINE
    l_newno         LIKE gak_file.gak01,
    l_oldno         LIKE gak_file.gak01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_gak.gak01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT l_newno FROM gak01
        AFTER FIELD gak01
            IF l_newno IS NULL THEN
                NEXT FIELD gak01
            END IF
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION controlg
           CALL cl_cmdask()
 
        ON ACTION help
           CALL cl_show_help()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
    END INPUT
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_gak.gak01 
        RETURN
    END IF
    
    SELECT * FROM gak_file         #單頭複製
        WHERE gak01=g_gak.gak01
        INTO TEMP y
    UPDATE y
        SET gak01   = l_newno,  #新的鍵值
            gakuser = g_user,   #新的鍵值
            gakgrup = g_grup,   #資料所有者
            gakmodu = NULL,     #gakmodu=g_user,   #資料所有者所屬群 FUN-8B0022
            gakdate = today     #資料修改日期
    INSERT INTO gak_file
        SELECT * FROM y
    DROP TABLE y
 
    SELECT * FROM gal_file         #單身複製
        WHERE gal01=g_gak.gak01
        INTO TEMP x
 
    IF SQLCA.sqlcode THEN
        #CALL cl_err('REPRODUCE:',SQLCA.sqlcode,0)  #No.FUN-660081
        CALL cl_err3("ins","x",g_gak.gak01,"",SQLCA.sqlcode,"","REPRODUCE",0)    #No.FUN-660081
        RETURN
    END IF
    UPDATE x
         SET gal01=l_newno
     
    INSERT INTO gal_file
        SELECT * FROM x
   
    IF SQLCA.sqlcode THEN
        #CALL cl_err('INSERT:',SQLCA.sqlcode,0)  #No.FUN-660081
        CALL cl_err3("ins","gal_file",l_newno,"",SQLCA.sqlcode,"","INSERT",0)    #No.FUN-660081
        RETURN
    END IF
     
    DROP TABLE x
 
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
    
     LET l_oldno = g_gak.gak01
     SELECT gak_file.* INTO g_gak.* FROM gak_file WHERE gak01 = l_newno
     #CALL p_link_u()
     CALL p_link_b()
     #SELECT gak_file.* INTO g_gak.* FROM gak_file WHERE gak01 = l_oldno  #FUN-C30027
     #CALL p_link_show()  #FUN-C30027
END FUNCTION
 
FUNCTION p_link_gal03(p_cmd)
 
    DEFINE p_cmd       LIKE type_file.chr1     #FUN-680135 
   #DEFINE path        LIKE type_file.chr50    #FUN-680135 #MOD-6B0072
    DEFINE li_cnt      LIKE type_file.num5     #FUN-680135 SMALLINT
    DEFINE ls_path     STRING                  #MOD-6B0072
    DEFINE lc_analy    LIKE type_file.chr1000  #FUN-890001
    DEFINE ls_analy    STRING
    DEFINE ls_cmd      STRING
    DEFINE lc_channel  base.Channel 
 
    LET g_errno = ' '
 
    SELECT gao02 INTO g_gal[l_ac].path FROM gao_file
        WHERE gao01 = g_gal[l_ac].gal02
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'azz-032'
                            LET g_gal[l_ac].path = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF NOT cl_null(g_gal[l_ac].path) THEN 
      #FUN-890001
      #LET g_gal[l_ac].path = g_gal[l_ac].path CLIPPED,'/42m/',DOWNSHIFT(g_gal[l_ac].gal02) CLIPPED,'_',  #MOD-4B0032完整路徑補上模組代號
      #                       g_gal[l_ac].gal03 CLIPPED,'.42m'
       LET ls_path = DOWNSHIFT(g_gal[l_ac].gal02) CLIPPED,'_',g_gal[l_ac].gal03 CLIPPED,'.42m'
       LET g_gal[l_ac].path = os.Path.join(os.Path.join(g_gal[l_ac].path CLIPPED,"42m"),ls_path.trim())
    END IF
 
    #FUN-4B0055 MOD-560097
    IF g_gal[l_ac].gal02[1,1] = "C" OR g_gal[l_ac].gal02[1,1] = "c" THEN
      #FUN-890001
      #LET ls_path = fgl_getenv("CUST") CLIPPED,'/',DOWNSHIFT(g_gal[l_ac].gal02) CLIPPED,'/4gl/',g_gal[l_ac].gal03 CLIPPED,'.4gl'
       LET ls_path = os.Path.join(FGL_GETENV("CUST") CLIPPED,DOWNSHIFT(g_gal[l_ac].gal02) CLIPPED)
    ELSE
      #FUN-890001
      #LET ls_path = fgl_getenv("TOP") CLIPPED,'/',DOWNSHIFT(g_gal[l_ac].gal02) CLIPPED,'/4gl/',g_gal[l_ac].gal03 CLIPPED,'.4gl'
       LET ls_path = os.Path.join(FGL_GETENV("TOP") CLIPPED,DOWNSHIFT(g_gal[l_ac].gal02) CLIPPED)
    END IF
    LET ls_path = os.Path.join(os.Path.join(ls_path,"4gl"),g_gal[l_ac].gal03 CLIPPED||".4gl")
 
    #MOD-920198---start---
    IF os.Path.isdirectory(ls_path) THEN
       RETURN
    END IF
    #MOD-920198---end---
 
   #FUN-890001
   #LET ls_cmd = 'grep -i ','\'prog\\..*version\' ',ls_path
   #DISPLAY "cmd=",ls_cmd
 
    LET lc_channel = base.Channel.create()
   #CALL lc_channel.openPipe(ls_cmd,"r")
    CALL lc_channel.openFile(ls_path,"r")
    WHILE lc_channel.read([lc_analy])
       LET ls_analy = DOWNSHIFT(lc_analy)
       IF ls_analy.getIndexOf("function",1) OR ls_analy.getIndexOf("main",1) THEN
          EXIT WHILE
       END IF
       IF ls_analy.getIndexOf("prog",1) AND ls_analy.getIndexOf("version",1) THEN
          LET li_cnt = ls_analy.getIndexOf("'",1)
          LET ls_analy = ls_analy.subString(li_cnt + 1,ls_analy.getLength())
          LET li_cnt = ls_analy.getIndexOf("'",1)
          LET ls_analy = ls_analy.subString(1,li_cnt - 1)
          LET g_gal[l_ac].ver = ls_analy.trim()
          DISPLAY "VER:",ls_analy.trim()," File =",ls_path.trim()
       END IF
    END WHILE
 
    #FUN-4B0055(END)
    CALL lc_channel.close()    #TQC-5B0177
 
END FUNCTION
 
 
 
FUNCTION p_link_b_askkey()
 
    DEFINE l_wc2           STRING   #TQC-5B0051
 
    CONSTRUCT l_wc2 ON gal02,gal03,gal04
            FROM s_gal[1].gal02,s_gal[1].gal03,s_gal[1].gal04
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    END CONSTRUCT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL p_link_b_fill(l_wc2)
END FUNCTION
 
FUNCTION p_link_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2    STRING                 #TQC-5B0051
    DEFINE l_cnt    LIKE type_file.num5    #FUN-680135 SMALLINT
 
    LET g_sql = " SELECT gal02,gal03,gal04 FROM gal_file",
                 " WHERE gal01 ='",g_gak.gak01 CLIPPED,"' AND ",p_wc2 CLIPPED,
                 " ORDER BY 1"
 
    PREPARE gak_pb FROM g_sql
    DECLARE gal_curs CURSOR FOR gak_pb
 
    CALL g_gal.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
 
    FOREACH gal_curs INTO g_gal[g_cnt].gal02,g_gal[g_cnt].gal03,g_gal[g_cnt].gal04
                 
       #            SELECT gao02 INTO g_gal[g_cnt].path FROM gao_file
       #                WHERE gao01 = g_gal[g_cnt].gal02
       #            LET g_gal[g_cnt].path = g_gal[g_cnt].path CLIPPED,'/42m/',
       #                                     g_gal[g_cnt].gal03 CLIPPED,'.42m'
    
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_rec_b = g_rec_b + 1
 
        LET l_ac = g_cnt             
        CALL p_link_gal03('')
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_gal.deleteElement(g_cnt)
    DISPLAY g_rec_b TO FORMONLY.cn2 
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p_link_bp(p_ud)
   DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud<>'G' OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gal TO s_gal.* ATTRIBUTE(UNBUFFERED, COUNT=g_rec_b)
 
      BEFORE DISPLAY
          CALL cl_navigator_setting(g_curs_index, g_row_count) #No.FUN-580092 HCN
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY                    # A.新增
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY                    # Q.查詢
 
      ON ACTION first
         CALL p_link_fetch('F')
          CALL cl_navigator_setting(g_curs_index, g_row_count) #No.FUN-580092 HCN
         IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL p_link_fetch('P')
          CALL cl_navigator_setting(g_curs_index, g_row_count) #No.FUN-580092 HCN
         IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL p_link_fetch('/')
          CALL cl_navigator_setting(g_curs_index, g_row_count) #No.FUN-580092 HCN
         IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL p_link_fetch('N')
          CALL cl_navigator_setting(g_curs_index, g_row_count) #No.FUN-580092 HCN
         IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL p_link_fetch('L')
          CALL cl_navigator_setting(g_curs_index, g_row_count) #No.FUN-580092 HCN
         IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY                    # B.單身
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY                    # C.複製
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY                    # H.說明
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         # 2004/03/24 新增語言別選項
         CALL cl_set_combo_module("gal02",1)
         CALL ui.Interface.refresh()
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY                    # Esc.結束
 
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
 
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION exporttoexcel       #FUN-4B0049
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION p_link_delall()
    SELECT COUNT(*) INTO g_cnt FROM gal_file
     WHERE gal01 = g_gak.gak01 
    IF g_cnt = 0 THEN                   # 未輸入單身資料, 則取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM gak_file WHERE gak01 = g_gak.gak01 
    END IF
END FUNCTION
 
 
FUNCTION p_link_chk()  #將lib,sub,qry 的42m目錄下的檔案名稱載到資料庫
 
    DEFINE i               LIKE type_file.num5    #No.FUN-680135 SMALLINT
    DEFINE l_dir           LIKE type_file.chr5    #FUN-680135 VARCHAR(5)
    DEFINE scmd            STRING
 
    FOR i = 1 to 3
 
       # 07/04/22 FUN-740100 by hjwang
       CASE
          WHEN i = 1
               LET l_dir = "lib"
              #LET scmd  = "cd ",l_top CLIPPED,"/",l_dir CLIPPED,
              #              "/42m;ls lib_cl_*.42m"
 
          WHEN i = 2
               LET l_dir = "sub"
              #LET scmd  = "cd ",l_top CLIPPED,"/",l_dir CLIPPED,
              #              "/42m;ls sub_s_*.42m"
 
          WHEN i = 3
               LET l_dir = "qry"
              #LET scmd  = "cd ",l_top CLIPPED,"/",l_dir CLIPPED,
              #              "/42m;ls qry_q_*.42m"
 
          OTHERWISE       
              EXIT CASE
       END CASE
 
       LET scmd = l_top CLIPPED,os.Path.separator(),l_dir CLIPPED,os.Path.separator(),"42m"
 
       CALL p_link_ls(l_dir,scmd)
   END FOR
END FUNCTION
 
 
# 07/04/22 FUN-740100 by hjwang
FUNCTION p_link_ls(l_dir,scmd)
 
#   DEFINE ch          base.Channel
    DEFINE l_dir       LIKE type_file.chr5    #FUN-680135 VARCHAR(5)
    DEFINE scmd        STRING
   #DEFINE fn          LIKE gal_file.gal03
    DEFINE fn          STRING
    DEFINE l_gal03     LIKE gal_file.gal03
    DEFINE l_ind1      LIKE type_file.num5    #FUN-680135 SMALLINT
    DEFINE l_ind2      LIKE type_file.num5    #FUN-680135 SMALLINT
    DEFINE ex          LIKE type_file.chr20   #FUN-680135 VARCHAR(10)
    DEFINE l_ind3      LIKE type_file.num5    #FUN-680135 SMALLINT
    
#   LET ch = base.Channel.create()
#   CALL ch.openpipe(scmd,"r") 
#   CALL ch.setDelimiter(".")
#   WHILE ch.read([fn,ex])
 
    CALL os.Path.dirsort("name", 1)
    LET l_ind3 = os.Path.diropen(scmd.trim())
    WHILE l_ind3 > 0
       LET fn = os.Path.dirnext(l_ind3)
       IF fn IS NULL OR fn = "" THEN EXIT WHILE END IF
       IF fn = "." OR fn = ".." THEN CONTINUE WHILE END IF
       IF os.Path.extension(fn.trim()) <> "42m" THEN CONTINUE WHILE END IF
       IF fn.getLength() <= 6 THEN CONTINUE WHILE END IF
       CASE
         WHEN l_dir = "lib"
            IF fn.getIndexOf("lib",1) <=0 OR fn.getIndexOf("cl",1) <= 0 THEN CONTINUE WHILE END IF
         WHEN l_dir = "sub"
            IF fn.getIndexOf("sub",1) <=0 OR fn.getIndexOf("s_",1) <= 0 THEN CONTINUE WHILE END IF
         WHEN l_dir = "qry"
            IF fn.getIndexOf("qry",1) <=0 OR fn.getIndexOf("q_",1) <= 0 THEN CONTINUE WHILE END IF
       END CASE 
       LET fn = os.Path.rootname(fn.trim())
       LET l_ind1 = fn.getIndexOf("_",1) 
       LET l_ind2 = fn.getLength() 
       LET fn =fn.subString(l_ind1+1,l_ind2)
       LET l_gal03 = fn.trim()
       INSERT INTO gal_file(gal01,gal02,gal03,gal04)  #No.MOD-470041
            VALUES (l_dir,upper(l_dir),l_gal03,'Y')
           #VALUES (l_dir,upper(l_dir),fn,'Y')
    END WHILE
    CALL os.Path.dirclose(l_ind3)
 
#   CALL ch.close()
 
END FUNCTION
 
 
FUNCTION p_link_delb()
 
    DECLARE gal_delcurs CURSOR FOR 
     SELECT gal01,gal02,gal03,gal04 FROM gal_file 
      WHERE gal01 = 'lib' OR gal01 = 'sub' OR gal01 = 'qry'
 
    #MOD-4A0204 
    FOREACH gal_delcurs INTO g_gak_t.gak01,g_gal_t.gal02,
                             g_gal_t.gal03,g_gal_t.gal04
 
       IF g_gal_t.gal04 = 'Y' THEN
          SELECT gao02 INTO l_gao02
            FROM gao_file
           WHERE gao01 = g_gal_t.gal02
       
          LET g_gal_t.gal02 = DOWNSHIFT(g_gal_t.gal02) CLIPPED
 
         # 07/04/22 FUN-740100 by hjwang
         #LET l_cmdstr = 'ls -l ',l_gao02 CLIPPED,'/42m/',
         #                g_gal_t.gal02 CLIPPED,'_',
         #                g_gal_t.gal03 CLIPPED,'.42m >/dev/null'
         ##DISPLAY l_cmdstr
         #RUN l_cmdstr RETURNING l_n  
         #DISPLAY l_n
         #IF l_n != 0 THEN       
         #   DELETE FROM gal_file
         #    WHERE gal01 = g_gak_t.gak01
         #      AND gal02 = g_gal_t.gal02   #No.MOD-650113
         #      AND gal03 = g_gal_t.gal03
         #END IF
          LET l_cmdstr = l_gao02 CLIPPED
          IF os.path.separator() = "/" THEN
             LET l_cmdstr = FGL_GETENV(l_cmdstr.subString(l_cmdstr.getIndexOf("$",1)+1,l_cmdstr.getIndexOf("/",1)-1)),
                            os.path.separator(),l_cmdstr.subString(l_cmdstr.getIndexOf("/",1)+1,l_cmdstr.getLength())
          ELSE
             LET l_cmdstr = FGL_GETENV(l_cmdstr.subString(l_cmdstr.getIndexOf("%",1)+1,l_cmdstr.getIndexOf("%",1)-1)),
                            os.path.separator(),l_cmdstr.subString(l_cmdstr.getIndexOf("%",1)+2,l_cmdstr.getLength())
          END IF
          LET l_cmdstr = l_cmdstr.trim(),os.Path.separator(),"42m",os.Path.separator(),
                         g_gal_t.gal02 CLIPPED,"_",
                         g_gal_t.gal03 CLIPPED,".42m"
          IF NOT os.Path.exists(l_cmdstr.trim()) THEN       
             DELETE FROM gal_file
              WHERE gal01 = g_gak_t.gak01
                AND gal02 = g_gal_t.gal02   #No.MOD-650113
                AND gal03 = g_gal_t.gal03
          END IF
 
       END IF
   END FOREACH
 
END FUNCTION
 
