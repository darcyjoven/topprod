# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: afat710.4gl
# Descriptions...: 投資抵減附加費用維護作業
# Date & Author..: 96/06/21 By Sophia
# Modify.........: 97/03/25 By Star 自動產生單身 
# Modify.........: 97/04/28 By Star 確認以及取消確認 
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-490235 04/09/13 By Yuna 自動生成改成用confirm的方式
# Modify.........: No.MOD-490344 04/09/20 By Kitty controlp 少display補入,另有l_sl的改掉
# Modify.........: No.MOD-490187 04/10/01 By Kitty confirm改的若不自動產生會跳出,輸入時不會自動帶出資料
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0019 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: NO.FUN-550034 05/05/20 By jackie 單據編號加大
# Modify.........: No.MOD-590288 05/09/14 By Smapmin 申請編號不做單別單號控管
# Modify.........: No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.........: No.TQC-650107 06/05/25 By Smapmin 修正afa-093的錯誤訊息為afa-099
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0001 06/10/11 By jamie FUNCTION t710_q() 一開始應清空g_fcj01的值
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time 
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6C0009 06/12/06 By Rayven 審核后可以刪除資料 
# Modify.........: No.FUN-710028 07/01/25 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-730018 07/03/05 By Smapmin 取消afa-328檢核
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-740100 07/04/23 By Smapmin 把單身自動產生的條件修改跟單身輸入當下的條件一樣
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-980003 09/08/12 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980099 09/08/22 By Sarah t710_cs()段,抓資料的SQL不應抓fcj03,fcj031
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0146 09/11/18 By Carrier AFTER FIELD 附号时判断传叁修改
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.MOD-B30361 11/03/16 by Dido 資產附號增加檢核 afa-126;確認段取消 g_fcb05/g_fcb06 判斷 
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2) 
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-C30107 12/06/14 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_fcj01         LIKE fcj_file.fcj01,   #申請編號 (假單頭)
    g_fcj01_o       LIKE fcj_file.fcj01,   #申請編號 (假單頭)
    g_fcjconf       LIKE fcj_file.fcjconf, #申請編號 (假單頭)
    g_fcb02         LIKE fcb_file.fcb02,   #申請編號 (假單頭)
    g_fcb03         LIKE fcb_file.fcb03,   #申請編號 (假單頭)
    g_fcb04         LIKE fcb_file.fcb04,   #申請編號 (假單頭)
    g_fcb05         LIKE fcb_file.fcb05,   #申請編號 (假單頭)
    g_fcb06         LIKE fcb_file.fcb06,   #申請編號 (假單頭)
    g_fcj01_t       LIKE fcj_file.fcj01,   #申請編號 (舊值)
    g_fcjconf_t     LIKE fcj_file.fcjconf, #申請編號 (舊值)
    g_fcj03 LIKE fcj_file.fcj03, g_fcj031 LIKE fcj_file.fcj031,#No.FUN-680070 INT # saki 20070821 fcj03,fcj031 chr18 -> num10 
    g_fcj           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        fcj02       LIKE fcj_file.fcj02,   #項次
        fcj03       LIKE fcj_file.fcj03,   #財產編號
        fcj031      LIKE fcj_file.fcj031,  #附號
        fcj04       LIKE fcj_file.fcj04,   #中文名稱
        fcj05       LIKE fcj_file.fcj05,   #英文名稱
        faj04       LIKE faj_file.faj04,   #類別
        fcj06       LIKE fcj_file.fcj06,   #數量
        fcj07       LIKE fcj_file.fcj07,   #單位
        fcj08       LIKE fcj_file.fcj08,   #廠商名稱
        faj49       LIKE faj_file.faj49,   #進口編號
        faj51       LIKE faj_file.faj51,   #發票號碼
        faj26       LIKE faj_file.faj26,   #入帳日期 
        fcj09       LIKE fcj_file.fcj09,   #原幣成本
        fcj10       LIKE fcj_file.fcj10,   #原幣幣別
        fcj11       LIKE fcj_file.fcj11    #本幣成本
                    END RECORD,
    g_fcj_t         RECORD                 #程式變數 (舊值)
        fcj02       LIKE fcj_file.fcj02,   #項次
        fcj03       LIKE fcj_file.fcj03,   #財產編號
        fcj031      LIKE fcj_file.fcj031,  #附號
        fcj04       LIKE fcj_file.fcj04,   #中文名稱
        fcj05       LIKE fcj_file.fcj05,   #英文名稱
        faj04       LIKE faj_file.faj04,   #類別
        fcj06       LIKE fcj_file.fcj06,   #數量
        fcj07       LIKE fcj_file.fcj07,   #單位
        fcj08       LIKE fcj_file.fcj08,   #廠商名稱
        faj49       LIKE faj_file.faj49,   #進口編號
        faj51       LIKE faj_file.faj51,   #發票號碼
        faj26       LIKE faj_file.faj26,   #入帳日期 
        fcj09       LIKE fcj_file.fcj09,   #原幣成本
        fcj10       LIKE fcj_file.fcj10,   #原幣幣別
        fcj11       LIKE fcj_file.fcj11    #本幣成本
                    END RECORD,
    g_fcj04_o       LIKE fcj_file.fcj04,
    g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_delete        LIKE type_file.chr1,   #若刪除資料,則要重新顯示筆數       #No.FUN-680070 VARCHAR(01)
    g_rec_b         LIKE type_file.num5,   #單身筆數       #No.FUN-680070 SMALLINT
    g_del           LIKE type_file.chr1,   #No.FUN-680070 VARCHAR(01)
    g_ss            LIKE type_file.chr1,   #No.FUN-680070 VARCHAR(01)
    l_flag          LIKE type_file.chr1,   #No.FUN-680070 VARCHAR(1)
    g_succ          LIKE type_file.chr1,   #No.FUN-680070 VARCHAR(01)
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT       #No.FUN-680070 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql        STRING #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE g_cnt               LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_msg               LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
DEFINE g_row_count         LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_curs_index        LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_jump              LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE mi_no_ask           LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
MAIN
#DEFINE                                                               #NO.FUN-6A0069                                
#    l_time          LIKE type_file.chr8         #計算被使用時間       #No.FUN-680070 VARCHAR(8) #NO.FUN-6A0069
DEFINE p_row,p_col  LIKE type_file.num5         #No.FUN-680070 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818    #NO.FUN-6A0069
   LET g_fcj01   = NULL                  #清除鍵值
   LET g_fcj01_t = NULL
   LET g_fcjconf = NULL  
   LET g_fcjconf_t = NULL
 
   LET g_forupd_sql = " SELECT fcj01 FROM fcj_file WHERE fcj01=? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t710_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 3 LET p_col = 5
   OPEN WINDOW t710_w AT p_row,p_col WITH FORM "afa/42f/afat710"   #顯示畫面
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
 
   CALL t710_menu()
   CLOSE WINDOW t710_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818    #NO.FUN-6A0069
END MAIN
 
#QBE 查詢資料
FUNCTION t710_cs()
   CLEAR FORM                             #清除畫面
   CALL g_fcj.clear()
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0029 
 
   #螢幕上取條件
   INITIALIZE g_fcj01 TO NULL    #No.FUN-750051
   INITIALIZE g_fcjconf TO NULL  #No.FUN-750051
   CONSTRUCT g_wc ON fcj01,fcjconf,fcj02,fcj03,fcj031,fcj04,fcj05,fcj06,
                     fcj07,fcj08,fcj09,fcj10,fcj11
        FROM fcj01,fcjconf,s_fcj[1].fcj02,s_fcj[1].fcj03,s_fcj[1].fcj031,
             s_fcj[1].fcj04,s_fcj[1].fcj05,s_fcj[1].fcj06,
             s_fcj[1].fcj07,s_fcj[1].fcj08,s_fcj[1].fcj09,
             s_fcj[1].fcj10,s_fcj[1].fcj11
 
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON ACTION controlp   
         CASE
            WHEN INFIELD(fcj01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_fcb01"
               LET g_qryparam.state = "c" 
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO fcj01
               NEXT FIELD fcj01
            WHEN INFIELD(fcj03)  #財產編號,財產附號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_faj"
               LET g_qryparam.state = "c" 
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO fcj03
               NEXT FIELD fcj03
            OTHERWISE
               EXIT CASE
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
   IF INT_FLAG THEN RETURN END IF
 
  # 組合出 SQL 指令
  #LET g_sql="SELECT UNIQUE fcj01,fcjconf,fcj03,fcj031 FROM fcj_file ",  #TQC-980099 mark
   LET g_sql="SELECT UNIQUE fcj01,fcjconf FROM fcj_file ",        #TQC-980099
             " WHERE ", g_wc CLIPPED,
             " ORDER BY fcj01"  #TQC-980099 mod
   PREPARE t710_prepare FROM g_sql      #預備一下
   DECLARE t710_bcs SCROLL CURSOR WITH HOLD FOR t710_prepare   #宣告成可捲動的
   LET g_sql="SELECT COUNT(UNIQUE fcj01) ",
             "  FROM fcj_file WHERE ", g_wc CLIPPED
   PREPARE t710_count_pre FROM g_sql
   DECLARE t710_count CURSOR FOR t710_count_pre
END FUNCTION
 
FUNCTION t710_menu()
 
   WHILE TRUE
      CALL t710_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL t710_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t710_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL t710_r()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL t710_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "confirm" 
            IF cl_chk_act_auth() THEN
               CALL t710_sure('Y')
            END IF
         WHEN "undo_confirm" 
            IF cl_chk_act_auth() THEN
               CALL t710_sure('N')
            END IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_fcj01 IS NOT NULL THEN
                  LET g_doc.column1 = "fcj01"
                  LET g_doc.value1 = g_fcj01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_fcj),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION t710_a()
    DEFINE      l_ans LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    MESSAGE ""
    CLEAR FORM
    CALL g_fcj.clear()
    INITIALIZE g_fcj01 LIKE fcj_file.fcj01
    INITIALIZE g_fcjconf LIKE fcj_file.fcjconf
    LET g_fcj01_t = NULL
    LET g_fcjconf_t = NULL
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
       CALL t710_i("a")                   #輸入單頭
       IF INT_FLAG THEN                   #使用者不玩了
          LET INT_FLAG = 0
          INITIALIZE g_fcj01 TO NULL
          CALL cl_err('',9001,0)
          EXIT WHILE
       END IF
       LET g_rec_b = 0
       DISPLAY g_rec_b TO FORMONLY.cn2  
       #No.MOD-490187
       IF cl_confirm('afa-103') THEN      #No.MOD-490235
          LET INT_FLAG = 0
 
     #    CALL cl_getmsg('afa-103',g_lang) RETURNING g_msg
     #    LET INT_FLAG = 0  ######add for prompt bug
     #    PROMPT g_msg CLIPPED ,': ' FOR l_ans 
     #       ON IDLE g_idle_seconds
     #          CALL cl_on_idle()
     #          CONTINUE PROMPT
     #       ON ACTION about         #MOD-4C0121
     #          CALL cl_about()      #MOD-4C0121
     #       ON ACTION help          #MOD-4C0121
     #          CALL cl_show_help()  #MOD-4C0121
     #       ON ACTION controlg      #MOD-4C0121
     #          CALL cl_cmdask()     #MOD-4C0121
     #    END PROMPT
     #    IF l_ans MATCHES '[Yy]' THEN 
             CALL t710_g()                       #產生單身
             CALL t710_b_fill("1=1")             #單身
     #    END IF 
       END IF
       CALL t710_b()               #輸入單身
       LET g_fcj01_t = g_fcj01     #保留舊值
       EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t710_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_fcjconf = 'Y' THEN 
       CALL cl_err('','afa-096',0)
       RETURN
    END IF 
 
    IF g_fcj01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fcj01_t = g_fcj01
    BEGIN WORK
    WHILE TRUE
       CALL t710_i("u")                      #欄位更改
       IF INT_FLAG THEN
          LET g_fcj01=g_fcj01_t
          DISPLAY g_fcj01 TO fcj01        #單頭
          LET INT_FLAG = 0
          CALL cl_err('',9001,0)
          EXIT WHILE
       END IF
       IF g_fcj01 != g_fcj01_t  THEN #更改單頭值
          UPDATE fcj_file SET fcj01 = g_fcj01  #更新DB
           WHERE fc101 = g_fcj01_t          #COLAUTH?
          IF SQLCA.sqlcode THEN
             LET g_msg = g_fcj01 CLIPPED
#            CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660136
             CALL cl_err3("upd","fcj_file",g_fcj01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
             CONTINUE WHILE
          END IF
       END IF
       EXIT WHILE
    END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION t710_i(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改       #No.FUN-680070 VARCHAR(1)
       l_fcj04         LIKE fcj_file.fcj04
 
   LET g_ss='Y'
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
   INPUT g_fcj01 WITHOUT DEFAULTS FROM fcj01
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t710_set_entry(p_cmd)
         CALL t710_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
#MOD-590288
##No.FUN-550034 --start--
#        CALL cl_set_docno_format("fcj01")
##No.FUN-550034 ---end---
#END MOD-590288
 
      AFTER FIELD fcj01            #申請編號      
         IF g_fcj01 IS NOT NULL AND
            (g_fcj01!=g_fcj01_t OR g_fcj01_t IS NULL) THEN
            CALL t710_fcj01('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_fcj01,g_errno,0)
               LET g_fcj01 = g_fcj01_t
               DISPLAY g_fcj01 TO fcj01
               NEXT FIELD fcj01
            END IF
            SELECT count(*) INTO g_cnt FROM fcj_file
             WHERE fcj01 = g_fcj01
            IF g_cnt > 0 THEN   #資料重複
               CALL cl_err(g_fcj01,-239,0)
               LET g_fcj01 = g_fcj01_t
               DISPLAY  g_fcj01 TO fcj01 # 
               NEXT FIELD fcj01
            END IF
         END IF
 
      AFTER INPUT  #97/05/22 modify
         IF INT_FLAG THEN EXIT INPUT END IF
 
      ON ACTION controlp   
         CASE
            WHEN INFIELD(fcj01)
#              CALL q_fcb(7,3,'1','2')
#              RETURNING g_fcj01,g_fcb02,g_fcb03,g_fcb04
#              CALL FGL_DIALOG_SETBUFFER( g_fcj01 )
#              CALL FGL_DIALOG_SETBUFFER( g_fcb02 )
#              CALL FGL_DIALOG_SETBUFFER( g_fcb03 )
#              CALL FGL_DIALOG_SETBUFFER( g_fcb04 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_fcb01"
               LET g_qryparam.default1 = g_fcj01 
               CALL cl_create_qry() RETURNING g_fcj01,g_fcb03,g_fcb04
#              CALL FGL_DIALOG_SETBUFFER( g_fcj01 )
#              CALL FGL_DIALOG_SETBUFFER( g_fcb03 )
#              CALL FGL_DIALOG_SETBUFFER( g_fcb04 )
               DISPLAY g_fcj01,g_fcb02,g_fcb03,g_fcb04             #No.MOD-490344
               SELECT fcb02 INTO g_fcb02 FROM fcb_file
                WHERE fcbconf = 'Y' AND fcb01 = g_fcj01 AND fcb03 = g_fcb03
                  AND fcb04 = g_fcb04
               CALL t710_fcj01('d')
               NEXT FIELD fcj01
            OTHERWISE
               EXIT CASE
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
 
FUNCTION t710_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("fcj01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t710_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("fcj01",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION t710_fcj01(p_cmd)      #申請編號    
   DEFINE p_cmd     LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
   LET g_errno = ' '
   SELECT fcb02,fcb03,fcb04,fcb05,fcb06 
     INTO g_fcb02,g_fcb03,g_fcb04,g_fcb05,g_fcb06 
     FROM fcb_file 
    WHERE fcb01 = g_fcj01
      AND fcbconf !='X' #010808增 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'afa-125'
                                  LET g_fcb02 = NULL  LET g_fcb04 = NULL
                                  LET g_fcb03 = NULL  
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY g_fcb02 TO FORMONLY.fcb02  
      DISPLAY g_fcb03 TO FORMONLY.fcb03  
      DISPLAY g_fcb04 TO FORMONLY.fcb04  
      DISPLAY g_fcb05 TO FORMONLY.fcb05  
      DISPLAY g_fcb06 TO FORMONLY.fcb06  
   END IF
END FUNCTION
   
#Query 查詢
FUNCTION t710_q()
   DEFINE l_fcj01  LIKE fcj_file.fcj01,
          l_cnt    LIKE type_file.num10        #No.FUN-680070 INTEGER
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_fcj01 TO NULL             #No.FUN-6A0001
   MESSAGE ""
   CALL cl_opmsg('q')
   CALL t710_cs()                    #取得查詢條件
   IF INT_FLAG THEN                       #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_fcj01 TO NULL
      RETURN
   END IF
   OPEN t710_bcs                    #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                         #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_fcj01 TO NULL
   ELSE
      OPEN t710_count
      FETCH t710_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t710_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t710_fetch(p_flag)
DEFINE p_flag       LIKE type_file.chr1,     #處理方式    #No.FUN-680070 VARCHAR(1)
       l_abso       LIKE type_file.num10     #絕對的筆數  #No.FUN-680070 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     t710_bcs INTO g_fcj01,g_fcjconf  #TQC-980099 mod #,g_fcj03,g_fcj031
      WHEN 'P' FETCH PREVIOUS t710_bcs INTO g_fcj01,g_fcjconf  #TQC-980099 mod #,g_fcj03,g_fcj031
      WHEN 'F' FETCH FIRST    t710_bcs INTO g_fcj01,g_fcjconf  #TQC-980099 mod #,g_fcj03,g_fcj031
      WHEN 'L' FETCH LAST     t710_bcs INTO g_fcj01,g_fcjconf  #TQC-980099 mod #,g_fcj03,g_fcj031
      WHEN '/' 
          IF (NOT mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
#                   CONTINUE PROMPT
 
                ON ACTION about         #MOD-4C0121
                   CALL cl_about()      #MOD-4C0121
 
                ON ACTION help          #MOD-4C0121
                   CALL cl_show_help()  #MOD-4C0121
 
                ON ACTION controlg      #MOD-4C0121
                   CALL cl_cmdask()     #MOD-4C0121
             END PROMPT
             IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
          END IF
          FETCH ABSOLUTE g_jump t710_bcs INTO g_fcj01,g_fcjconf  #TQC-980099 mod #,g_fcj03,g_fcj031
          LET mi_no_ask = FALSE 
   END CASE
 
   LET g_succ='Y'
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_fcj01,SQLCA.sqlcode,0)
      INITIALIZE g_fcj01 TO NULL  #TQC-6B0105
      LET g_succ='N'
   ELSE
      OPEN t710_count
      FETCH t710_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
      CALL t710_show()
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
 
#將資料顯示在畫面上
FUNCTION t710_show()
   DISPLAY g_fcj01,g_fcjconf TO fcj01,fcjconf        #單頭
   CALL cl_set_field_pic(g_fcjconf,"","","","","")
   CALL t710_fcj01('d')
   CALL t710_b_fill(g_wc)                 #單身
   CALL cl_show_fld_cont()                #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t710_r()
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   #No.TQC-6C0009 --start--
   IF g_fcjconf = 'Y' THEN
      CALL cl_err('','afa-096',0)
      RETURN
   END IF
   #No.TQC-6C0009 --end--
   IF g_fcj01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   LET g_fcj01_t=g_fcj01
   BEGIN WORK
 
   OPEN t710_cl USING g_fcj01_t
   IF STATUS THEN
      CALL cl_err("OPEN t710_cl:", STATUS, 1)
      CLOSE t710_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t710_cl INTO g_fcj01_o             # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fcj01,SQLCA.sqlcode,0)
      RETURN
   END IF
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "fcj01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_fcj01       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM fcj_file WHERE fcj01 = g_fcj01 
      IF SQLCA.sqlcode THEN
#        CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)   #No.FUN-660136
         CALL cl_err3("del","fcj_file",g_fcj01,"",SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660136
      ELSE
         CLEAR FORM
         CALL g_fcj.clear()
         LET g_delete='Y'
         LET g_fcj01 = NULL
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
         OPEN t710_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE t710_bcs
             CLOSE t710_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         FETCH t710_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE t710_bcs
             CLOSE t710_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t710_bcs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t710_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t710_fetch('/')
         END IF
      END IF
   END IF
   CLOSE t710_cl
   COMMIT WORK
 
END FUNCTION
 
#單身
FUNCTION t710_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否       #No.FUN-680070 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否       #No.FUN-680070 SMALLINT
 
    LET g_action_choice = ""
    IF g_fcjconf = 'Y' THEN 
       CALL cl_err('','afa-096',0)
       RETURN
    END IF 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_fcj01 IS NULL THEN
        RETURN
    END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT fcj02,fcj03,fcj031,fcj04,fcj05,'',",
                       "       fcj06,fcj07,fcj08,'','','',fcj09,fcj10,fcj11 ",
                       "  FROM fcj_file ",
                       " WHERE fcj01 = ? ",
                       "   AND fcj03 = ? ",
                       "   AND fcj031= ? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t710_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    #CKP2
    IF g_rec_b=0 THEN CALL g_fcj.clear() END IF
 
    INPUT ARRAY g_fcj WITHOUT DEFAULTS FROM s_fcj.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b!=0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd=''
           LET l_ac = ARR_CURR()
           DISPLAY l_ac  TO FORMONLY.cn3  
           LET l_lock_sw = 'N'            #DEFAULT
           LET g_del = 'Y'
           LET l_n  = ARR_COUNT()
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_fcj[l_ac].* = g_fcj_t.*
              EXIT INPUT
           END IF
           LET g_fcj01_t=g_fcj01
           BEGIN WORK 
           IF g_rec_b>=l_ac THEN
              LET p_cmd='u'
              LET g_fcj_t.* = g_fcj[l_ac].*      #BACKUP
              LET l_flag = 'Y'
 
              OPEN t710_cl USING g_fcj01_t
              IF STATUS THEN
                 CALL cl_err("OPEN t710_cl:", STATUS, 1)
                 CLOSE t710_cl
                 ROLLBACK WORK
                 RETURN
              END IF
              FETCH t710_cl INTO g_fcj01_o# 對DB鎖定
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_fcj01,SQLCA.sqlcode,0)
                 RETURN
              END IF
 
              OPEN t710_bcl USING g_fcj01,g_fcj_t.fcj03,g_fcj_t.fcj031
              IF STATUS THEN
                 CALL cl_err("OPEN t710_bcl:", STATUS, 1)
                 CLOSE t710_bcl
                 ROLLBACK WORK
                 RETURN
              ELSE
                 FETCH t710_bcl INTO g_fcj[l_ac].* 
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_fcj_t.fcj03,SQLCA.sqlcode,1)
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
           IF g_fcj[l_ac].fcj03 IS NOT NULL THEN
              CALL t710_fcj031('d')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_fcj[l_ac].fcj031,g_errno,1)
                 NEXT FIELD fcj02                                         
              END IF
           END IF
           INSERT INTO fcj_file (fcj01,fcj02,fcj03,fcj031,fcj04,fcj05,  #No.MOD-470041
                                 fcj06,fcj07,fcj08,fcj09,fcj10,fcj11,
                                 fcjconf,fcjlegal)         #FUN-980003 add
           VALUES(g_fcj01,g_fcj[l_ac].fcj02,g_fcj[l_ac].fcj03,
                  g_fcj[l_ac].fcj031,g_fcj[l_ac].fcj04,g_fcj[l_ac].fcj05,
                  g_fcj[l_ac].fcj06,g_fcj[l_ac].fcj07,g_fcj[l_ac].fcj08,
                  g_fcj[l_ac].fcj09,g_fcj[l_ac].fcj10,g_fcj[l_ac].fcj11,
                  'N',g_legal)      #FUN-980003 add 
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_fcj[l_ac].fcj02,SQLCA.sqlcode,0)   #No.FUN-660136
              CALL cl_err3("ins","fcj_file",g_fcj01,g_fcj[l_ac].fcj02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
              #LET g_fcj[l_ac].* = g_fcj_t.*
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
              COMMIT WORK
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_fcj[l_ac].* TO NULL      #900423
           LET g_fcj_t.* = g_fcj[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD fcj02
 
        BEFORE FIELD fcj02                        #default 序號
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_fcj[l_ac].* = g_fcj_t.*
              DISPLAY BY NAME g_fcj[l_ac].* #No.MOD-490344    
              EXIT INPUT
           END IF
 
        AFTER FIELD fcj02                        #check 序號是否重複
           IF NOT cl_null(g_fcj[l_ac].fcj02) THEN
              SELECT count(*) INTO l_n FROM fcc_file
               WHERE fcc01 = g_fcj01
                 AND fcc02 = g_fcj[l_ac].fcj02
              IF l_n = 0 THEN
                 CALL cl_err(g_fcj[l_ac].fcj02,'afa-126',0)
                 LET g_fcj[l_ac].fcj02 = g_fcj_t.fcj02
                 DISPLAY g_fcj[l_ac].fcj02 TO fcj02     #No.MOD-490344
                 NEXT FIELD fcj02
              END IF
           END IF 
 
        AFTER FIELD fcj031
           IF g_fcj[l_ac].fcj031 IS NULL THEN 
              LET g_fcj[l_ac].fcj031 = ' '
          #-MOD-B30361-add-
           ELSE
              LET l_n = 0
              SELECT COUNT(*) INTO l_n 
                FROM fcc_file
               WHERE fcc01 = g_fcj01
                 AND fcc03 = g_fcj[l_ac].fcj03
                 AND fcc031 = g_fcj[l_ac].fcj031
              IF l_n = 0 THEN
                 CALL cl_err(g_fcj[l_ac].fcj02,'afa-126',0)
                 LET g_fcj[l_ac].fcj031 = g_fcj_t.fcj031
                 DISPLAY g_fcj[l_ac].fcj031 TO fcj031
                 NEXT FIELD fcj02
              END IF
          #-MOD-B30361-end-
           END IF
         # CALL t710_fcj031('a')    #No.TQC-9B0146                              
           CALL t710_fcj031(p_cmd)  #No.TQC-9B0146
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_fcj[l_ac].fcj031,g_errno,1)
              LET g_fcj[l_ac].fcj03  = g_fcj_t.fcj03    #No.TQC-9B0146
              LET g_fcj[l_ac].fcj031 = g_fcj_t.fcj031
              DISPLAY g_fcj[l_ac].fcj031 TO fcj031     #No.MOD-490344
              NEXT FIELD fcj03
           END IF                  
#          LET g_fcj_t.fcj03  = g_fcj[l_ac].fcj03      #No.TQC-9B0146
#          LET g_fcj_t.fcj031 = g_fcj[l_ac].fcj031     #No.TQC-9B0146     
 
        BEFORE DELETE                            #是否取消單身
           IF g_fcj_t.fcj02 > 0 AND
              g_fcj_t.fcj02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
                 ROLLBACK WORK
              END IF
              # genero shell add start
              IF l_lock_sw = "Y" THEN 
                 CALL cl_err("", -263, 1) 
                 CANCEL DELETE 
              END IF 
              # genero shell add end
              DELETE FROM fcj_file
               WHERE fcj01 = g_fcj01     
                 AND fcj02 = g_fcj_t.fcj02
                 AND fcj03 = g_fcj_t.fcj03
                 AND fcj031= g_fcj_t.fcj031
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_fcj_t.fcj02,SQLCA.sqlcode,0)   #No.FUN-660136
                 CALL cl_err3("del","fcj_file",g_fcj01,g_fcj_t.fcj02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              COMMIT WORK
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_fcj[l_ac].* = g_fcj_t.*
              CLOSE t710_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_fcj[l_ac].fcj02,-263,1)
              LET g_fcj[l_ac].* = g_fcj_t.*
           ELSE
              IF g_fcj[l_ac].fcj03 IS NOT NULL THEN
                 CALL t710_fcj031('d')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fcj[l_ac].fcj031,g_errno,1)
                    NEXT FIELD fcj02                                         
                 END IF
              END IF
              UPDATE fcj_file SET
                     fcj01 =g_fcj01,
                     fcj02 =g_fcj[l_ac].fcj02,
                     fcj03 =g_fcj[l_ac].fcj03,
                     fcj031=g_fcj[l_ac].fcj031,
                     fcj04 =g_fcj[l_ac].fcj04,
                     fcj05 =g_fcj[l_ac].fcj05,
                     fcj06 =g_fcj[l_ac].fcj06,
                     fcj07 =g_fcj[l_ac].fcj07,
                     fcj08 =g_fcj[l_ac].fcj08,
                     fcj09 =g_fcj[l_ac].fcj09,
                     fcj10 =g_fcj[l_ac].fcj10,
                     fcj11 =g_fcj[l_ac].fcj11
               WHERE fcj01 =g_fcj01
                 AND fcj03 =g_fcj_t.fcj03
                 AND fcj031=g_fcj_t.fcj031
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_fcj[l_ac].fcj02,SQLCA.sqlcode,0)   #No.FUN-660136
                 CALL cl_err3("upd","fcj_file",g_fcj01,g_fcj_t.fcj03,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                 LET g_fcj[l_ac].* = g_fcj_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
       
        AFTER ROW
           LET l_ac = ARR_CURR()
        #  LET l_ac_t = l_ac     #FUN-D30032 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_fcj[l_ac].* = g_fcj_t.*
            #FUN-D30032--add--str--
              ELSE
                 CALL g_fcj.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
            #FUN-D30032--add--end--
              END IF
              LET l_ac_t = l_ac  #FUN-D30032 add
              CLOSE t710_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE t710_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(fcj02) AND l_ac > 1 THEN
              LET g_fcj[l_ac].* = g_fcj[l_ac-1].*
              LET g_fcj[l_ac].fcj02 = NULL   #TQC-620018
              DISPLAY g_fcj[l_ac].* TO s_fcj[l_ac].*
              NEXT FIELD fcj02
           END IF
 
        ON ACTION controlp  #ok
           CASE
              WHEN INFIELD(fcj03)  #財產編號,財產附號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faj"
                 LET g_qryparam.default1 = g_fcj[l_ac].fcj03
                 LET g_qryparam.default2 = g_fcj[l_ac].fcj031
                 CALL cl_create_qry() RETURNING g_fcj[l_ac].fcj03,g_fcj[l_ac].fcj031
#                CALL FGL_DIALOG_SETBUFFER( g_fcj[l_ac].fcj03 )
#                CALL FGL_DIALOG_SETBUFFER( g_fcj[l_ac].fcj031 )
#                CALL fgl_dialog_setbuffer(g_fcj[l_ac].fcj03)
                 DISPLAY g_fcj[l_ac].fcj03,g_fcj[l_ac].fcj031 TO fcj03,fcj031      #No.MOD-490344
               # CALL t710_fcj031('a')    #No.TQC-9B0146                        
                 CALL t710_fcj031(p_cmd)  #No.TQC-9B0146
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(' ',g_errno,0)
                    NEXT FIELD fcj03
                 END IF
                 NEXT FIELD fcj03
              OTHERWISE
                 EXIT CASE
           END CASE
 
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
 
    CLOSE t710_bcl
    COMMIT WORK
END FUNCTION
   
FUNCTION t710_fcj031(p_cmd)
DEFINE   p_cmd       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
         l_cnt       LIKE type_file.num5,         #No.FUN-680070 SMALLINT
         l_faj04     LIKE faj_file.faj04,
         l_faj26     LIKE faj_file.faj26,
         l_faj06     LIKE faj_file.faj06,
         l_faj07     LIKE faj_file.faj07,
         l_faj11     LIKE faj_file.faj11,
         l_faj17     LIKE faj_file.faj17,
         l_faj18     LIKE faj_file.faj18,
         l_faj49     LIKE faj_file.faj49,
         l_faj51     LIKE faj_file.faj51,
         l_faj16     LIKE faj_file.faj16,
         l_faj15     LIKE faj_file.faj15,
         l_faj14     LIKE faj_file.faj14
 
   LET g_errno = ' '
     IF p_cmd='a'  OR ((l_flag='Y' AND g_del != 'Y' OR p_cmd = 'u') AND                    #No.MOD-490187  #No.TQC-9B0146
                            (g_fcj[l_ac].fcj03!=g_fcj_t.fcj03 OR
                             g_fcj[l_ac].fcj031!=g_fcj_t.fcj031)) THEN
       SELECT COUNT(*) INTO l_cnt  FROM fcj_file 
        WHERE fcj01=g_fcj01 AND fcj03=g_fcj[l_ac].fcj03 
          AND fcj031=g_fcj[l_ac].fcj031
       IF l_cnt>0 THEN
          LET g_errno='afa-105'
          RETURN 
       END IF
       SELECT faj04,faj26,faj06,faj07,faj11,faj17,faj18,
              faj49,faj51,faj16,faj15,faj14
        INTO l_faj04,l_faj26,l_faj06,l_faj07,l_faj11,l_faj17,l_faj18,
             l_faj49,l_faj51,l_faj16,l_faj15,l_faj14
        FROM faj_file
       WHERE faj02  = g_fcj[l_ac].fcj03
         AND faj021 <> '1'   #非主件
         AND faj022 = g_fcj[l_ac].fcj031
         AND faj42 IN ('1','2','3','5')              #No.MOD-490187
         AND (faj14 + faj141 - faj59) > 0
         AND fajconf = 'Y'
     CASE
          #WHEN STATUS  = 100 LET g_errno = 'afa-093'        #No.MOD-490187   #TQC-650107
          WHEN STATUS  = 100 LET g_errno = 'afa-999'         #TQC-650107
         OTHERWISE LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
     IF cl_null(g_errno) AND (p_cmd = 'a' OR p_cmd = 'u') THEN
        LET g_fcj[l_ac].fcj04 = l_faj06
        LET g_fcj[l_ac].fcj05 = l_faj07
        LET g_fcj[l_ac].fcj06 = l_faj17
        LET g_fcj[l_ac].fcj07 = l_faj18
        LET g_fcj[l_ac].fcj08 = l_faj11
        LET g_fcj[l_ac].fcj09 = l_faj16
        LET g_fcj[l_ac].fcj10 = l_faj15
        LET g_fcj[l_ac].fcj11 = l_faj14
        LET g_fcj[l_ac].faj04 = l_faj04
        LET g_fcj[l_ac].faj26 = l_faj26
        LET g_fcj[l_ac].faj49 = l_faj49
        LET g_fcj[l_ac].faj51 = l_faj51
        DISPLAY l_faj04 TO FORMONLY.faj04  
        DISPLAY l_faj26 TO FORMONLY.faj26  
        DISPLAY l_faj49 TO FORMONLY.faj49  
        DISPLAY l_faj51 TO FORMONLY.faj51  
        DISPLAY  g_fcj[l_ac].fcj04 TO fcj04
        DISPLAY  g_fcj[l_ac].fcj05 TO fcj05
        DISPLAY  g_fcj[l_ac].fcj06 TO fcj06
        DISPLAY  g_fcj[l_ac].fcj07 TO fcj07
        DISPLAY  g_fcj[l_ac].fcj08 TO fcj08
        DISPLAY  g_fcj[l_ac].fcj09 TO fcj09
        DISPLAY  g_fcj[l_ac].fcj10 TO fcj10
        DISPLAY  g_fcj[l_ac].fcj11 TO fcj11
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
        DISPLAY l_faj04 TO FORMONLY.faj04  
        DISPLAY l_faj26 TO FORMONLY.faj26  
        DISPLAY l_faj49 TO FORMONLY.faj49  
        DISPLAY l_faj51 TO FORMONLY.faj51  
        DISPLAY  g_fcj[l_ac].fcj04 TO fcj04
        DISPLAY  g_fcj[l_ac].fcj05 TO fcj05
        DISPLAY  g_fcj[l_ac].fcj06 TO fcj06
        DISPLAY  g_fcj[l_ac].fcj07 TO fcj07
        DISPLAY  g_fcj[l_ac].fcj08 TO fcj08
        DISPLAY  g_fcj[l_ac].fcj09 TO fcj09
        DISPLAY  g_fcj[l_ac].fcj10 TO fcj10
        DISPLAY  g_fcj[l_ac].fcj11 TO fcj11
    END IF
  END IF
END FUNCTION
 
FUNCTION t710_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000                #No.FUN-680070 VARCHAR(200)
 
    CONSTRUCT l_wc ON fcj02,fcj03,fcj031,fcj04,fcj05,fcj06,fcj07,  #螢幕上取條件
                      fcj08,fcj09,fcj10,fcj11,faj04,faj26,faj49,faj51
       FROM s_fcj[1].fcj02,s_fcj[1].fcj03,s_fcj[1].fcj031,s_fcj[1].fcj04,
            s_fcj[1].fcj05,
            s_fcj[1].fcj06,s_fcj[1].fcj07,s_fcj[1].fcj08,s_fcj[1].fcj09,
            s_fcj[1].fcj10,s_fcj[1].fcj11,s_fcj[1].faj04,s_fcj[1].faj26,
            s_fcj[1].faj49,s_fcj[1].faj51
 
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
    IF INT_FLAG THEN LET INT_FLAG = FALSE RETURN END IF
    CALL t710_b_fill(l_wc)
END FUNCTION
 
FUNCTION t710_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    LET g_sql ="SELECT fcj02,fcj03,fcj031,fcj04,fcj05,faj04,fcj06,fcj07,fcj08, ",
               " faj49,faj51,faj26,fcj09,fcj10,fcj11 ",
               "  FROM fcj_file,OUTER faj_file",
               " WHERE fcj01  = '",g_fcj01,"'",
               "   AND fcj_file.fcj03  = faj_file.faj02",
               "   AND fcj_file.fcj031 = faj_file.faj022",
               "   AND ",p_wc CLIPPED,
               " ORDER BY fcj02 "
    PREPARE t710_prepare2 FROM g_sql      #預備一下
    DECLARE fcj_cs CURSOR FOR t710_prepare2
    LET g_cnt = 1
    CALL g_fcj.clear()
    LET g_rec_b=0
    FOREACH fcj_cs INTO g_fcj[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_fcj.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t710_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fcj TO s_fcj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t710_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL t710_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL t710_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL t710_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL t710_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
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
         CALL cl_set_field_pic(g_fcjconf,"","","","","")
 
      ON ACTION exit 
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
#@    ON ACTION 相關文件  
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
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
 
   
      ON ACTION exporttoexcel   #No.FUN-4B0019
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
 
      #FUN-810046
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t710_g()
    DEFINE l_fcj      RECORD LIKE fcj_file.*
    DEFINE l_fcc      RECORD LIKE fcc_file.*
    DEFINE l_faj      RECORD LIKE faj_file.*
    DEFINE l_n        LIKE type_file.num5         #No.FUN-680070 SMALLINT
    DEFINE l_faj26    LIKE   faj_file.faj26
 
    DELETE FROM fcj_file WHERE fcj01=g_fcj01 
    DECLARE t710_g_cur1 CURSOR FOR 
     SELECT fcc_file.*,faj26 FROM fcc_file,faj_file 
      WHERE fcc01 = g_fcj01 
        AND fcc03 = faj02 AND fcc031 = faj022 
 
    FOREACH t710_g_cur1 INTO l_fcc.*,l_faj26 
        IF STATUS THEN 
           CALL cl_err('err t710_g_cur1',STATUS,0) EXIT FOREACH  
        END IF 
        # 依此申請編號的投資抵減單身資料到資產主檔取其
        # 2.附屬配件 及 3.附加費用
        # 並且此筆資料不存在投資抵減申請作業中, 
        #   且此筆資料的入帳年度和其在投資抵減的資產的入帳年度相同 
        #   且此筆資料不得為已抵減 
        DECLARE t710_g_cur2 CURSOR FOR                    #型態是附加的
         SELECT * FROM faj_file 
          WHERE faj02 = l_fcc.fcc03 
            AND faj021 IN ('2','3') AND fajconf = 'Y' 
            #-----MOD-740100---------
            #AND YEAR(faj26) = YEAR(l_faj26) 
            #AND faj42 = '1'  
            AND faj42 IN ('1','2','3','5')
            #AND faj43 not IN ('5','6')
            AND (faj14+faj141-faj59) >0
            #-----END MOD-740100-----
 
        FOREACH t710_g_cur2 INTO l_faj.*
            IF STATUS THEN 
               CALL cl_err('err t710_g_cur2',STATUS,0)   
               EXIT FOREACH
            END IF 
            message l_faj.faj02,' ',l_faj.faj022
            IF cl_null(l_faj.faj022) THEN LET l_faj.faj022 = ' ' END IF 
        #   SELECT COUNT(*) INTO l_n FROM fcc_file 
        #    WHERE fcc01=g_fcj01 AND fcc03=l_faj.faj02 AND fcc031=l_faj.faj022
        #   IF cl_null(l_n) THEN LET l_n = 0 END IF
            # 在投資抵減申請作業已有這一筆 ,則不做 
        #   IF l_n > 0 THEN CONTINUE FOREACH END IF 
            LET l_fcj.fcj01 = g_fcj01       #申請編號
            LET l_fcj.fcj02 = l_fcc.fcc02   #項次
            LET l_fcj.fcj03 = l_faj.faj02   #財編
            LET l_fcj.fcj031= l_faj.faj022  #附號
            LET l_fcj.fcj04 = l_faj.faj06   #中文名稱
            LET l_fcj.fcj05 = l_faj.faj07   #英文名稱
            LET l_fcj.fcj06 = l_faj.faj17   #數量
            LET l_fcj.fcj07 = l_faj.faj18   #單位
            LET l_fcj.fcj08 = l_faj.faj10   #廠商名稱
            LET l_fcj.fcj09 = l_faj.faj16   #原幣成本 
            LET l_fcj.fcj10 = l_faj.faj15   #原幣幣別
            LET l_fcj.fcj11 = l_faj.faj14   #本幣成本 
            LET l_fcj.fcjconf = 'N'         #確認否 
            LET l_fcj.fcjlegal = g_legal    #FUN-980003 add
            INSERT INTO fcj_file VALUES(l_fcj.*)
           #IF SQLCA.sqlcode AND STATUS != -239 THEN #TQC-790102
            IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.SQLCODE)  THEN #TQC-790102
#              CALL cl_err('err ins fcj',STATUS,0)   #No.FUN-660136
               CALL cl_err3("ins","fcj_file",l_fcj.fcj01,l_fcj.fcj02,SQLCA.sqlcode,"","err ins fcj",1)  #No.FUN-660136
            END IF 
        END FOREACH 
    END FOREACH 
END FUNCTION
 
FUNCTION t710_sure(l_chr)
DEFINE s_cnt     LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       l_chr     LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
       LET g_fcj01_t=g_fcj01
IF l_chr='Y' THEN  #---確認 ---#    
    IF g_fcjconf='Y' THEN RETURN END IF
    #確認一下
   #IF cl_sure(0,0) AND (NOT cl_null(g_fcb05) AND NOT cl_null(g_fcb06)) THEN #MOD-B30361 mark 
    IF cl_sure(0,0) THEN                             
#CHI-C30107 -------------- add ------------------ begin                        #MOD-B30361
       SELECT fcjconf INTO g_fcjconf FROM fcj_file WHERE fcj01 = g_fcj01
       IF g_fcjconf='Y' THEN RETURN END IF
#CHI-C30107 -------------- add ------------------ end
       BEGIN WORK 
 
       OPEN t710_cl USING g_fcj01_t
       IF STATUS THEN
          CALL cl_err("OPEN t710_cl:", STATUS, 1)
          CLOSE t710_cl
          ROLLBACK WORK
          RETURN
       END IF
       FETCH t710_cl INTO g_fcj01_o# 對DB鎖定
       IF SQLCA.sqlcode THEN
           CALL cl_err(g_fcj01,SQLCA.sqlcode,0)
           RETURN
       END IF
       LET g_success = 'Y'
       CALL s_showmsg_init()   #No.FUN-710028
       CALL t710_surey()       #更新資產基本資料檔 
       CALL s_showmsg()        #No.FUN-710028
       IF g_success = 'Y' THEN LET g_fcjconf='Y' COMMIT WORK
          DISPLAY g_fcjconf TO fcjconf
       ELSE LET g_fcjconf='N' ROLLBACK WORK
       END IF   
    END IF 
ELSE               # 取消確認
    IF g_fcjconf='N' THEN RETURN END IF
    IF cl_sure(0,0) THEN                   #確認一下
       BEGIN WORK 
 
       OPEN t710_cl USING g_fcj01_t
       IF STATUS THEN
          CALL cl_err("OPEN t710_cl:", STATUS, 1)
          CLOSE t710_cl
          ROLLBACK WORK
          RETURN
       END IF
       FETCH t710_cl INTO g_fcj01_o# 對DB鎖定
       IF SQLCA.sqlcode THEN
           CALL cl_err(g_fcj01,SQLCA.sqlcode,0)
           RETURN
       END IF
       LET g_success = 'Y'
       CALL s_showmsg_init()   #No.FUN-710028
       CALL t710_suren()       #更新資產基本資料檔 
       CALL s_showmsg()        #No.FUN-710028
       IF g_success = 'Y' THEN LET g_fcjconf='N' COMMIT WORK
            DISPLAY g_fcjconf TO fcjconf # 
       ELSE LET g_fcjconf='Y' ROLLBACK WORK
       END IF   
    END IF 
END IF 
    CALL cl_set_field_pic(g_fcjconf,"","","","","")
END FUNCTION
   
FUNCTION t710_surey()
DEFINE s_cnt     LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       l_fcj03,fcj031   LIKE type_file.chr18,         #No.FUN-680070 INT # saki 20070821 fcj03,fcj031 chr18 -> num10 
       l_fcc15   LIKE fcc_file.fcc15,
       l_sql     LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(300)
       l_fcj     RECORD LIKE fcj_file.*
 
     #-----TQC-730018---------
     #IF cl_null(g_fcb06) THEN 
     #   CALL cl_err(g_fcj01,'afa-328',0)
     #   RETURN 
     #END IF
     #-----END TQC-730018-----
 
     DECLARE t710_surey CURSOR FOR SELECT * FROM fcj_file
       WHERE fcj01=g_fcj01
 
     # 取扺減率
     LET l_sql = " SELECT fcc15,fcc03,fcc031  FROM fcc_file ",
                 "  WHERE fcc01 = ? ",
                 "    AND fcc03 = ? ",
                 "    AND fcc031= ? "
 
     PREPARE afat710_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM 
     END IF
     DECLARE t710_surey_1 CURSOR FOR afat710_prepare2
 
    FOREACH t710_surey INTO l_fcj.* 
#No.FUN-710028 --begin                                                                                                              
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
#No.FUN-710028 --end
 
        IF SQLCA.sqlcode THEN
#          CALL cl_err('t710_surey',SQLCA.sqlcode,0)                   #No.FUN-710028
           CALL s_errmsg('fcj01',g_fcj01,'t710_surey',SQLCA.sqlcode,1) #No.FUN-710028
           LET g_success = 'N'
           EXIT FOREACH 
        END IF
        # 取扺減率
        LET l_fcc15 = 0 
 
        OPEN t710_surey_1 USING l_fcj.fcj01,l_fcj.fcj03,l_fcj.fcj031
        IF STATUS THEN
#          CALL cl_err("OPEN t710_surey:", STATUS, 1)                   #No.FUN-710028
           LET g_showmsg = l_fcj.fcj01,"/",l_fcj.fcj03,"/",l_fcj.fcj031 #No.FUN-710028
           CALL s_errmsg('fcc01,fcc03,fcc031',g_showmsg,"OPEN t710_surey:", STATUS, 1) #No.FUN-710028
#No.FUN-710028 --begin
#          CLOSE t710_surey
#          ROLLBACK WORK
#          RETURN
           LET g_success = 'N' 
           CONTINUE FOREACH
#No.FUN-710028 --end
        END IF
        FETCH t710_surey_1 INTO l_fcc15,l_fcj03,fcj031
        CLOSE t710_surey_1 
 
        # 更新資產主檔 
        UPDATE faj_file SET faj42 = '5',                   #國稅局已核准
                            faj80 = l_fcc15,               #扺減率
                            faj81 = l_fcj.fcj11 * (l_fcc15/100), #扺減金額
                            faj82 = g_fcb03,               #管理局核准日期 
                            faj83 = g_fcb04,               #管理局核准文號 
                            faj84 = g_fcb05,               #國稅局核准日期
                            faj85 = g_fcb06,               #國稅局核准文號
                            faj851= '2'                    #2.附加費用 
                      WHERE faj02 = l_fcj.fcj03 AND faj022= l_fcj.fcj031 
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           LET g_showmsg = l_fcj.fcj03,"/",l_fcj.fcj031
           CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj_file:',SQLCA.sqlcode,1) #No.FUN-710028
           LET g_success = 'N' 
#          RETURN           #No.FUN-710028
           CONTINUE FOREACH #No.FUN-710028
        END IF
    END FOREACH 
#No.FUN-710028 --begin                                                                                                              
    IF g_totsuccess="N" THEN                                                                                                        
       LET g_success="N"                                                                                                            
    END IF                                                                                                                          
#No.FUN-710028 --end
 
    UPDATE fcj_file SET fcjconf='Y' WHERE fcj01=g_fcj01
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       CALL s_errmsg('fcj01',g_fcj01,'upd fcj_file',SQLCA.sqlcode,1)  #No.FUN-710028
       LET g_success = 'N' 
    END IF
END FUNCTION 
   
FUNCTION t710_suren()
DEFINE s_cnt     LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       l_fcj     RECORD LIKE fcj_file.*
 
 
     DECLARE t710_suren CURSOR FOR SELECT * FROM fcj_file 
       WHERE fcj01=g_fcj01 
 
    FOREACH t710_suren INTO l_fcj.* 
#No.FUN-710028 --begin                                                                                                              
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
#No.FUN-710028 --end
 
        IF SQLCA.sqlcode THEN
#          CALL cl_err('t710_suren',SQLCA.sqlcode,0)                   #No.FUN-710028
           CALL s_errmsg('fcj01',g_fcj01,'t710_suren',SQLCA.sqlcode,1) #No.FUN-710028
           LET g_success = 'N'
           EXIT FOREACH 
        END IF
        # 更新資產主檔 
        UPDATE faj_file SET faj42 = '1',      #投資扺減否
                            faj80 = 0,        #扺減率
                            faj81 = 0,        #扺減金額
                            faj82 = '',       #管理局核准日期 
                            faj83 = ' ',       #管理局核准文號 
                            faj84 = '',       #國稅局核准日期
                            faj85 = ' ',       #國稅局核准文號
                            faj851= ' '        #2.附加費用 
                      WHERE faj02 = l_fcj.fcj03 AND faj022= l_fcj.fcj031 
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           LET g_showmsg = l_fcj.fcj03,"/",l_fcj.fcj031
           CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj_file:',SQLCA.sqlcode,1) #No.FUN-710028
           LET g_success = 'N' 
#          RETURN           #No.FUN-710028
           CONTINUE FOREACH #No.FUN-710028
        END IF
    END FOREACH 
#No.FUN-710028 --begin                                                                                                              
    IF g_totsuccess="N" THEN                                                                                                        
       LET g_success="N"                                                                                                            
    END IF                                                                                                                          
#No.FUN-710028 --end
 
    UPDATE fcj_file SET fcjconf='N' WHERE fcj01=g_fcj01
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       CALL s_errmsg('fcj01',g_fcj01,'upd fcj_file',SQLCA.sqlcode,1)  #No.FUN-710028
       LET g_success = 'N' 
    END IF
END FUNCTION 
 
