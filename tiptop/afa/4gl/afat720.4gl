# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: afat720.4gl
# Descriptions...: 抵年度選定作業
# Date & Author..: 97/05/01 By Star
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-490235 04/09/13 By Yuna 自動生成改成用confirm的方式
# Modify.........: No.MOD-490344 04/09/20 By Kitty controlp 少display補入
# Modify.........: No.MOD-490190 04/09/29 By Kitty 無法自動產生單身
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0019 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0008 04/12/02 By Nicola 單價、金額欄位改為DEC(20,6)
#
# Modify.........: NO.FUN-550034 05/05/20 By jackie 單據編號加大
# Modify.........: No.MOD-5A0004 05/10/07 By Rosayu 刪除資料後筆數不正確
# Modify.........: No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.........: No.TQC-630122 06/03/14 By 不可檢核單據碼數
# Modify.........: No.TQC-650107 06/05/25 By Smapmin 管理局與國稅局必須有其一核准
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0001 06/10/12 By jamie FUNCTION t720_q() 一開始應清空g_fcm01的值
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-710028 07/01/26 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-720019 07/02/28 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-740101 07/04/26 By kim 新增時當fcc04=0時warming
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760182 07/06/27 By chenl   自動產生QBE條件不可為空。
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.TQC-970033 09/07/02 By hongmei UPDATE時,如為數值欄位，資料不能給''(空字串)需給0
# Modify.........: No.FUN-980003 09/08/12 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.MOD-B30603 11/03/17 By lixia 單據確認增加控管
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-C30107 12/06/14 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-D30032 13/04/08 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_fcm01         LIKE fcm_file.fcm01,   #申請編號 (假單頭)
    g_fcm02         LIKE fcm_file.fcm02,   #
    g_fcm05         LIKE fcm_file.fcm05,   #
    g_fcmconf       LIKE fcm_file.fcmconf, #
    g_fcb02         LIKE fcb_file.fcb02,   #申請編號 (假單頭)
    g_fcb03         LIKE fcb_file.fcb03,   #申請編號 (假單頭)
    g_fcb04         LIKE fcb_file.fcb04,   #申請編號 (假單頭)
    g_fcb05         LIKE fcb_file.fcb05,   #申請編號 (假單頭)
    g_fcb06         LIKE fcb_file.fcb06,   #申請編號 (假單頭)
    g_fcm01_t       LIKE fcm_file.fcm01,   #申請編號 (舊值)
    g_fcm05_t       LIKE fcm_file.fcm05,   #申請編號 (舊值)
    g_fcmconf_t     LIKE fcm_file.fcmconf, #申請編號 (舊值)
    g_fcm1          RECORD
        fcm01         LIKE fcm_file.fcm01,  #申請編號 (假單頭)
        fcm05         LIKE fcm_file.fcm05   #
                    END RECORD,
    g_fcm           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        fcm02       LIKE fcm_file.fcm02,   #項次
        fcc03       LIKE fcc_file.fcc03,   #財產編號
        fcc031      LIKE fcc_file.fcc031,  #附號
        cost        LIKE type_file.num20_6,            #成本   #No.FUN-4C0008       #No.FUN-680070 DEC(20,6)
        fcc15       LIKE fcc_file.fcc15,   #扺減率 
        amt1        LIKE type_file.num20_6,            #申請扺減額   #No.FUN-4C0008       #No.FUN-680070 DEC(20,6)
        amt2        LIKE type_file.num20_6,            #申請扺減額   #No.FUN-4C0008       #No.FUN-680070 DEC(20,6)
        fcm04       LIKE fcm_file.fcm04,   #扺減金額
        fcm03       LIKE fcm_file.fcm03    #處分否 
                    END RECORD,
  #Modify:3083查詢時,當國稅局or管理局之核準文號=''or fcc20='4' or fcc20='6',不應出現
    l_fcm          RECORD    #程式變數(Program Variables)
        fcm02       LIKE fcm_file.fcm02,   #項次
        fcc03       LIKE fcc_file.fcc03,   #財產編號
        fcc031      LIKE fcc_file.fcc031,  #附號
        cost        LIKE type_file.num20_6,            #成本   #No.FUN-4C0008        #No.FUN-680070 DEC(20,6)
        fcc15       LIKE fcc_file.fcc15,   #扺減率 
        amt1        LIKE type_file.num20_6,            #申請扺減額   #No.FUN-4C0008       #No.FUN-680070 DEC(20,6)
        amt2        LIKE type_file.num20_6,            #申請扺減額   #No.FUN-4C0008       #No.FUN-680070 DEC(20,6)
        fcm04       LIKE fcm_file.fcm04,   #扺減金額
        fcm03       LIKE fcm_file.fcm03    #處分否 
                    END RECORD,
    g_fcm_t         RECORD                 #程式變數 (舊值)
        fcm02       LIKE fcm_file.fcm02,   #項次
        fcc03       LIKE fcc_file.fcc03,   #財產編號
        fcc031      LIKE fcc_file.fcc031,  #附號
        cost        LIKE type_file.num20_6,            #成本   #No.FUN-4C0008        #No.FUN-680070 DEC(20,6)
        fcc15       LIKE fcc_file.fcc15,   #扺減率 
        amt1        LIKE type_file.num20_6,            #申請扺減額   #No.FUN-4C0008       #No.FUN-680070 DEC(20,6)
        amt2        LIKE type_file.num20_6,            #申請扺減額   #No.FUN-4C0008       #No.FUN-680070 DEC(20,6)
        fcm04       LIKE fcm_file.fcm04,   #扺減金額
        fcm03       LIKE fcm_file.fcm03    #處分否 
                    END RECORD,
    g_fcm04_o       LIKE fcm_file.fcm04,
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_delete        LIKE type_file.chr1,                #若刪除資料,則要重新顯示筆數       #No.FUN-680070 VARCHAR(01)
    g_rec_b         LIKE type_file.num5,                #單身筆數       #No.FUN-680070 SMALLINT
    g_del           LIKE type_file.chr1,          #No.FUN-680070 VARCHAR(01)
    g_ss            LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
    l_flag          LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    g_succ LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
    l_ac            LIKE type_file.num5                #目前處理的ARRAY CNT       #No.FUN-680070 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5         #No.FUN-680070 SMALLINT
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp    STRING   #No.TQC-720019
DEFINE g_before_input_done   LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE g_cnt           LIKE type_file.num10           #No.FUN-680070 INTEGER
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_curs_index   LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_jump         LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
MAIN
#DEFINE
#    l_time          LIKE type_file.chr8                  #計算被使用時間       #No.FUN-680070 VARCHAR(8) #NO.FUN-6A0069
 
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
 
      CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
        RETURNING g_time                  #NO.FUN-6A0069
    LET g_fcm01 = NULL                     #清除鍵值
    LET g_fcm01_t = NULL
    LET g_fcmconf = NULL  
    LET g_fcmconf_t = NULL
 
    LET g_forupd_sql = " SELECT fcm01,fcm05 FROM fcm_file ",
                       " WHERE fcm01= ? ",
                       " AND fcm05= ? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t720_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 3 LET p_col = 13
    OPEN WINDOW t720_w AT p_row,p_col             #顯示畫面
        WITH FORM "afa/42f/afat720"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL t720_menu()
    CLOSE WINDOW t720_w                 #結束畫面
      CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
        RETURNING g_time                  #NO.FUN-6A0069
END MAIN
 
 
#QBE 查詢資料
FUNCTION t720_cs()
   CLEAR FORM                             #清除畫面
   CALL g_fcm.clear()
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0029
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0029
 
      #螢幕上取條件
   INITIALIZE g_fcm01 TO NULL    #No.FUN-750051
   INITIALIZE g_fcm05 TO NULL    #No.FUN-750051
   CONSTRUCT g_wc ON fcm01,fcm05,fcmconf,fcm02,fcm04,fcm03
        FROM fcm01,fcm05,fcmconf,s_fcm[1].fcm02,s_fcm[1].fcm04,s_fcm[1].fcm03
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
              WHEN INFIELD(fcm01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_fcb01"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fcm01
                 NEXT FIELD fcm01
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
    LET g_sql="SELECT UNIQUE fcm01,fcm05 FROM fcm_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY 1,2"
    PREPARE t720_prepare FROM g_sql      #預備一下
    DECLARE t720_bcs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR t720_prepare
 {  LET g_sql="SELECT unique fcm01,fcm02,fcm05,fcmconf ",
              "  FROM fcm_file WHERE ", g_wc CLIPPED ,
              " ORDER BY 1,2,3,4 "
    PREPARE t720_pre   FROM g_sql
    DECLARE t720_count CURSOR FOR t720_pre }
 
 
#   LET g_sql = "SELECT UNIQUE fcm01,fcm05 FROM fcm_file ",      #No.TQC-720019
    LET g_sql_tmp = "SELECT UNIQUE fcm01,fcm05 FROM fcm_file ",  #No.TQC-720019
                " WHERE ", g_wc CLIPPED,
               #"  ORDER BY 1,2 ",
                "  INTO TEMP x "
    
    DROP TABLE x
#   PREPARE t720_precount_x FROM g_sql      #No.TQC-720019
    PREPARE t720_precount_x FROM g_sql_tmp  #No.TQC-720019
    EXECUTE t720_precount_x
 
        LET g_sql="SELECT COUNT(*) FROM x "
 
    PREPARE t720_precount FROM g_sql
    DECLARE t720_count CURSOR FOR t720_precount
END FUNCTION
 
FUNCTION t720_menu()
 
   WHILE TRUE
      CALL t720_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL t720_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t720_q()
            END IF
            #NEXT OPTION "next"
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL t720_r()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL t720_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "auto_generate"
            IF cl_chk_act_auth() THEN 
               CALL t720_g()                       #產生單身
               CALL t720_b_fill("1=1")             #單身
            END IF
         WHEN "confirm" 
            IF cl_chk_act_auth() THEN
               CALL t720_sure('Y')
            END IF
         WHEN "undo_confirm" 
            IF cl_chk_act_auth() THEN
               CALL t720_sure('N')
            END IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_fcm01 IS NOT NULL THEN
                  LET g_doc.column1 = "fbc01"
                  LET g_doc.value1 = g_fcm01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_fcm),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION t720_a()
    DEFINE l_ans   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
    DEFINE l_fcc04 LIKE fcc_file.fcc04         #MOD-740101 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    MESSAGE ""
    CLEAR FORM
    CALL g_fcm.clear()
    INITIALIZE g_fcm01 LIKE fcm_file.fcm01
    LET g_fcmconf = 'N' 
    LET g_fcm01_t = NULL
    LET g_fcm05_t = NULL
    LET g_fcmconf_t = NULL
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
       LET g_fcm05 = YEAR(g_today)
       CALL t720_i("a")                   #輸入單頭
       IF INT_FLAG THEN                   #使用者不玩了
          LET INT_FLAG = 0
          INITIALIZE g_fcm01 TO  NULL
          CALL cl_err('',9001,0)
          EXIT WHILE
       END IF
       LET g_rec_b = 0
       DISPLAY g_rec_b TO FORMONLY.cn2  
       CALL SET_COUNT(0)
       #MOD-740101...........begin
       SELECT fcc04 INTO l_fcc04 FROM fcc_file
                                WHERE fcc01=g_fcm01
       IF l_fcc04=0 THEN
          CALL cl_err('','afa-139',1) 
       ELSE
       #MOD-740101...........end
          IF NOT cl_confirm('afa-103') THEN RETURN END IF     #No.MOD-490235
          LET INT_FLAG = 0
          CALL t720_g()                       #產生單身
          CALL t720_b_fill("1=1")             #單身
       END IF
       CALL t720_b()                   #輸入單身
       LET g_fcm01_t = g_fcm01            #保留舊值
       EXIT WHILE
    END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION t720_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改       #No.FUN-680070 VARCHAR(1)
    l_fcm04         LIKE fcm_file.fcm04
 
    LET g_ss='Y'
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
    INPUT g_fcm01,g_fcm05 WITHOUT DEFAULTS FROM fcm01,fcm05 
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t720_set_entry(p_cmd)
            CALL t720_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
#------------No.TQC-630122 mark
#No.FUN-550034 --start--
#        CALL cl_set_docno_format("fcm01")
#No.FUN-550034 ---end---
#------------No.TQC-630122 end
 
        AFTER FIELD fcm01            #申請編號      
            IF g_fcm01 IS NOT NULL AND
               (g_fcm01!=g_fcm01_t OR g_fcm01_t IS NULL) THEN
                CALL t720_fcm01('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_fcm01,g_errno,0)
                   LET g_fcm01 = g_fcm01_t
                   DISPLAY g_fcm01 TO fcm01
                   NEXT FIELD fcm01
                END IF
            END IF 
 
        AFTER FIELD fcm05            #扺減 年度 
            IF NOT cl_null(g_fcm05) THEN  
               SELECT count(*) INTO g_cnt FROM fcm_file
                WHERE fcm01 = g_fcm01 AND fcm05 = g_fcm05 
               IF g_cnt > 0 THEN   #資料重複
                  CALL cl_err(g_fcm01,-239,0)
                  LET g_fcm01 = g_fcm01_t
                  LET g_fcm05 = g_fcm05_t
                  DISPLAY  g_fcm01 TO fcm01
                  DISPLAY  g_fcm05 TO fcm05 
                  NEXT FIELD fcm01
               END IF
            END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(fcm01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_fcb01"
                 LET g_qryparam.default1 = g_fcm01
                 CALL cl_create_qry() RETURNING g_fcm01,g_fcb03,g_fcb04
#                 CALL FGL_DIALOG_SETBUFFER( g_fcm01 )
#                 CALL FGL_DIALOG_SETBUFFER( g_fcb03 )
#                 CALL FGL_DIALOG_SETBUFFER( g_fcb04 )
                  DISPLAY BY NAME g_fcm01                    #No.MOD-490344
                 SELECT fcb02 INTO g_fcb02 FROM fcb_file
                  WHERE fcbconf = 'Y' AND fcb01 = g_fcm01 AND fcb03 = g_fcb03
                    AND fcb04 = g_fcb04
                 CALL t720_fcm01('d')
                 NEXT FIELD fcm01
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
FUNCTION t720_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("fcm01",TRUE)
    END IF
 
END FUNCTION
FUNCTION t720_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("fcm01",FALSE)
    END IF
 
END FUNCTION
 
 
FUNCTION t720_fcm01(p_cmd)      #申請編號    
    DEFINE p_cmd     LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT fcb02,fcb03,fcb04,fcb05,fcb06 
           INTO g_fcb02,g_fcb03,g_fcb04,g_fcb05,g_fcb06 
           FROM fcb_file WHERE fcb01 = g_fcm01
            AND fcbconf !='X'  #010808增
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'afa-125'
         LET g_fcb02 = NULL  LET g_fcb04 = NULL
         LET g_fcb03 = NULL  
         #WHEN cl_null(g_fcb03) OR cl_null(g_fcb05)   #TQC-650107
         WHEN cl_null(g_fcb03) AND cl_null(g_fcb05)   #TQC-650107
              LET g_errno='afa-335' 
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd'
      THEN DISPLAY g_fcb02 TO FORMONLY.fcb02 # 
           DISPLAY g_fcb03 TO FORMONLY.fcb03 # 
           DISPLAY g_fcb04 TO FORMONLY.fcb04 # 
           DISPLAY g_fcb05 TO FORMONLY.fcb05 # 
           DISPLAY g_fcb06 TO FORMONLY.fcb06 # 
    END IF
END FUNCTION
   
#Query 查詢
FUNCTION t720_q()
  DEFINE l_fcm01  LIKE fcm_file.fcm01,
         l_cnt    LIKE type_file.num10        #No.FUN-680070 INTEGER
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fcm01 TO NULL             #No.FUN-6A0001
    INITIALIZE g_fcm05 TO NULL             #No.FUN-6A0001
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL t720_cs()                         #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_fcm01 TO NULL
        RETURN
    END IF
    OPEN t720_bcs                          #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                  #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_fcm01 TO NULL
    ELSE
        OPEN t720_count
        FETCH t720_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
        CALL t720_fetch('F')               #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t720_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680070 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數       #No.FUN-680070 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     t720_bcs INTO g_fcm01,g_fcm05
        WHEN 'P' FETCH PREVIOUS t720_bcs INTO g_fcm01,g_fcm05
        WHEN 'F' FETCH FIRST    t720_bcs INTO g_fcm01,g_fcm05
        WHEN 'L' FETCH LAST     t720_bcs INTO g_fcm01,g_fcm05
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
            FETCH ABSOLUTE g_jump t720_bcs INTO g_fcm01,g_fcm05
            LET mi_no_ask = FALSE
    END CASE     
                 
    LET g_succ='Y'
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_fcm01,SQLCA.sqlcode,0)
        INITIALIZE g_fcm01 TO NULL  #TQC-6B0105
        INITIALIZE g_fcm05 TO NULL  #TQC-6B0105
        LET g_succ='N'
    ELSE         
        SELECT UNIQUE fcmconf INTO g_fcmconf FROM fcm_file 
         WHERE fcm01 = g_fcm01 AND fcm05 = g_fcm05 
        CALL t720_show()
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
FUNCTION t720_show()
  DEFINE p_flag LIKE type_file.chr1          #No.FUN-680070 VARCHAR(1)
    #Modify:3083  
    LET p_flag ='' 
   #CALL t720_chkfcb() RETURNING p_flag 
   #IF p_flag ='N' THEN CALL t720_fetch('N') END IF 
    DISPLAY g_fcm01,g_fcm05,g_fcmconf TO fcm01,fcm05,fcmconf  
    CALL cl_set_field_pic(g_fcmconf,"","","","","")
    CALL t720_fcm01('d')
    CALL t720_b_fill(g_wc)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t720_chkfcb()
  DEFINE l_flag LIKE type_file.chr1          #No.FUN-680070 VARCHAR(1)
    SELECT fcb02,fcb03,fcb04,fcb05,fcb06
           INTO g_fcb02,g_fcb03,g_fcb04,g_fcb05,g_fcb06
           FROM fcb_file WHERE fcb01 = g_fcm01
            AND fcbconf !='X'  #010808增
    IF cl_null(g_fcb04) OR cl_null(g_fcb06) THEN 
       LET l_flag ='N'  #管理/國稅局文號為空白--資料不顯示
    ELSE 
       LET l_flag ='Y' 
    END IF 
    RETURN l_flag 
END FUNCTION
 
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t720_r()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_fcm01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_fcmconf MATCHES '[Yy]' THEN 
       CALL cl_err('','afa-096',0)
       RETURN
    END IF 
    LET g_fcm01_t=g_fcm01
    LET g_fcm05_t=g_fcm05
    BEGIN WORK
 
    OPEN t720_cl USING g_fcm01_t,g_fcm05_t
    IF STATUS THEN
       CALL cl_err("OPEN t720_cl:", STATUS, 1)
       CLOSE t720_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t720_cl INTO g_fcm1.*              # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fcm01,SQLCA.sqlcode,0)
        RETURN
    END IF
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fbc01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fcm01       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM fcm_file WHERE fcm01 = g_fcm01 AND fcm05 = g_fcm05 
        IF SQLCA.sqlcode THEN
#           CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)   #No.FUN-660136
            CALL cl_err3("del","fcm_file",g_fcm01,g_fcm05,SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660136
        ELSE
            CLEAR FORM
            #MOD-5A0004 add
            DROP TABLE x
#           EXECUTE t720_precount_x                  #No.TQC-720019
            PREPARE t720_precount_x2 FROM g_sql_tmp  #No.TQC-720019
            EXECUTE t720_precount_x2                 #No.TQC-720019
            #MOD-5A0004 end
            CALL g_fcm.clear()
            LET g_delete='Y'
            LET g_fcm01 = NULL
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            OPEN t720_count
            #FUN-B50062-add-start--
            IF STATUS THEN
               CLOSE t720_bcs
               CLOSE t720_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            FETCH t720_count INTO g_row_count
            #FUN-B50062-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE t720_bcs
               CLOSE t720_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN t720_bcs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL t720_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL t720_fetch('/')
            END IF
 
        END IF
    END IF
    CLOSE t720_cl
    COMMIT WORK
 
END FUNCTION
 
 
#單身
FUNCTION t720_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否       #No.FUN-680070 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否       #No.FUN-680070 SMALLINT
 
    LET g_action_choice = ""
    IF g_fcmconf = 'Y' THEN 
       CALL cl_err('','afa-096',0)
       RETURN
    END IF 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_fcm01 IS NULL THEN
        RETURN
    END IF
    CALL cl_opmsg('b')
    LET g_forupd_sql = " SELECT fcm02,'','','','','','',fcm04,fcm03 ",
                       " FROM fcm_file  ",
                       " WHERE fcm01=? ",
                       " AND fcm02=? ",
                       " AND fcm05=? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t720_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
   #CKP2
   IF g_rec_b=0 THEN CALL g_fcm.clear() END IF
 
 
        INPUT ARRAY g_fcm WITHOUT DEFAULTS FROM s_fcm.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
          IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
          END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
           #LET g_fcm_t.* = g_fcm[l_ac].*      #BACKUP
            LET l_lock_sw = 'N'            #DEFAULT
            LET g_del = 'Y'
            LET l_n  = ARR_COUNT()
            LET g_fcm01_t=g_fcm01
            LET g_fcm05_t=g_fcm05
            BEGIN WORK 
           #IF g_fcm_t.fcm02 IS NOT NULL THEN
            IF g_rec_b>=l_ac THEN  
                OPEN t720_cl USING g_fcm01_t,g_fcm05_t
                IF STATUS THEN
                   CALL cl_err("OPEN t720_cl:", STATUS, 1)
                   CLOSE t720_cl
                   ROLLBACK WORK
                   RETURN
                END IF
                FETCH t720_cl INTO g_fcm1.*              # 對DB鎖定
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_fcm01,SQLCA.sqlcode,0)
                    RETURN
                END IF
                LET p_cmd='u'
                LET g_fcm_t.* = g_fcm[l_ac].*      #BACKUP
                LET l_flag = 'Y'
 
                OPEN t720_bcl USING g_fcm01, g_fcm_t.fcm02,g_fcm05
                IF STATUS THEN
                   CALL cl_err("OPEN t720_bcl:", STATUS, 1)
                   CLOSE t720_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t720_bcl INTO g_fcm_t.*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_fcm_t.fcm02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
             END IF
            #IF l_ac <= l_n then                   #DISPLAY NEWEST
              #  LET g_fcm_t.* = g_fcm[l_ac].*      #BACKUP
            #    CALL t720_fcm02('a')
            #END IF
          #  NEXT FIELD fcm02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              #CKP2
              INITIALIZE g_fcm[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_fcm[l_ac].* TO s_fcm.*
              CALL g_fcm.deleteElement(l_ac)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF
             INSERT INTO fcm_file (fcm01,fcm02,fcm03,fcm04,fcm05,fcmconf,fcmlegal)  #No.MOD-470041 #FUN-980003 add
                 VALUES(g_fcm01,g_fcm[l_ac].fcm02,g_fcm[l_ac].fcm03, 
                        g_fcm[l_ac].fcm04,g_fcm05,'N',g_legal)      #FUN-980003 add
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_fcm[l_ac].fcm02,SQLCA.sqlcode,0)   #No.FUN-660136
                CALL cl_err3("ins","fcm_file",g_fcm01,g_fcm[l_ac].fcm02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
               #LET g_fcm[l_ac].* = g_fcm_t.*
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
            INITIALIZE g_fcm[l_ac].* TO NULL      #900423
            LET g_fcm[l_ac].fcm04 = 0
            LET g_fcm[l_ac].fcm03 = 'N' 
            CALL t720_fcm02('a')
            LET g_fcm_t.* = g_fcm[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fcm02
            
        AFTER FIELD fcm02                        #check 序號是否重複
            IF NOT cl_null(g_fcm[l_ac].fcm02) THEN 
                  SELECT count(*) INTO l_n FROM fcc_file
                   WHERE fcc01 = g_fcm01
                     AND fcc02 = g_fcm[l_ac].fcm02
                     AND fcc04 IN ('1','2')
                 IF l_n = 0 THEN
                    CALL cl_err(g_fcm[l_ac].fcm02,'afa-126',0)
                    LET g_fcm[l_ac].fcm02 = g_fcm_t.fcm02
                    DISPLAY g_fcm[l_ac].fcm02 TO fcm02
                    NEXT FIELD fcm02
                 ELSE 
                    CALL t720_fcm02('a')
                 END IF
            END IF 
  
        AFTER FIELD fcm04 
            IF NOT cl_null(g_fcm[l_ac].fcm04) THEN 
               IF g_fcm[l_ac].fcm04 > g_fcm[l_ac].amt2 THEN 
                  CALL cl_err(g_fcm[l_ac].fcm04,'afa-330',0)
                  NEXT FIELD fcm04 
               END IF 
            END IF 
 
        BEFORE DELETE                            #是否取消單身
            IF g_fcm_t.fcm02 > 0 AND
               g_fcm_t.fcm02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     ROLLBACK WORK
                     CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                # genero shell add end
                DELETE FROM fcm_file
                    WHERE fcm01 = g_fcm01     
                      AND fcm02 = g_fcm_t.fcm02
                      AND fcm05 = g_fcm05
                IF SQLCA.sqlcode THEN
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
               LET g_fcm[l_ac].* = g_fcm_t.*
               CLOSE t720_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fcm[l_ac].fcm02,-263,1)
               LET g_fcm[l_ac].* = g_fcm_t.*
            ELSE
               UPDATE fcm_file SET
                  fcm02=g_fcm[l_ac].fcm02,fcm03=g_fcm[l_ac].fcm03,
                  fcm04=g_fcm[l_ac].fcm04
                WHERE fcm01 = g_fcm01 AND fcm02 = g_fcm_t.fcm02
                  AND fcm05 = g_fcm05 
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_fcm[l_ac].fcm02,SQLCA.sqlcode,0)   #No.FUN-660136
                   CALL cl_err3("upd","fcm_file",g_fcm01,g_fcm_t.fcm02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                   LET g_fcm[l_ac].* = g_fcm_t.*
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
               IF p_cmd='u' THEN
                  LET g_fcm[l_ac].* = g_fcm_t.*
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_fcm.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
               END IF
               CLOSE t720_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30032 add
            LET g_fcm_t.* = g_fcm[l_ac].*
            CLOSE t720_bcl
            COMMIT WORK
            #CKP2
           #CALL g_fcm.deleteElement(g_rec_b+1) #FUN-D30032 mark
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(fcm02) AND l_ac > 1 THEN
                LET g_fcm[l_ac].* = g_fcm[l_ac-1].*
                LET g_fcm[l_ac].fcm02 = NULL   #TQC-620018
                NEXT FIELD fcm02
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
 
    CLOSE t720_bcl
        COMMIT WORK
END FUNCTION
   
FUNCTION t720_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000                #No.FUN-680070 VARCHAR(200)
 
    CONSTRUCT l_wc ON fcm02,fcm04,fcm03               #螢幕上取條件
       FROM s_fcm[1].fcm02,s_fcm[1].fcm04,s_fcm[1].fcm03 
 
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
    CALL t720_b_fill(l_wc)
END FUNCTION
 
FUNCTION t720_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(200)
    l_total1,l_total2 LIKE type_file.num20_6,   #No.FUN-4C0008       #No.FUN-680070 DEC(20,6)
    l_fcm04         LIKE fcm_file.fcm04,
    l_fcc20         LIKE fcc_file.fcc20,
    l_fcc24         LIKE fcc_file.fcc24,
    l_fcj11         LIKE fcj_file.fcj11 
    
 
    LET g_sql ="SELECT fcm02,fcc03,fcc031,fcc16,fcc15,0,0,fcm04,fcm03 ", 
               "  FROM fcm_file,fcc_file",
               " WHERE fcm01  = '",g_fcm01,"'",
               "   AND fcm01  = fcc01",
               "   AND fcm02  = fcc02",
               "   AND fcm05  = ",g_fcm05,
               "   AND fcc04 IN ('1','2') ",
               "   AND ",p_wc CLIPPED,
               " ORDER BY 1"
    PREPARE t720_prepare2 FROM g_sql      #預備一下
    DECLARE fcm_cs CURSOR FOR t720_prepare2
 
    LET g_cnt = 1
    CALL g_fcm.clear()
    LET g_rec_b=0
    FOREACH fcm_cs INTO l_fcm.*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        # 申請扺減
        #主件成本 
           IF cl_null(l_fcm.cost) THEN LET l_fcm.cost=0 END IF 
           #-->計算主件部份的扺減額  .. 為避免小數位四捨五入問題 
           #-->扺減額獨立推算 
           DECLARE afat720_curs3 CURSOR FOR
            SELECT fcc24 FROM fcc_file 
             WHERE fcc01=g_fcm01 AND fcc02=l_fcm.fcm02 
           LET l_fcc24 = 0 LET l_total1 = 0 
           FOREACH afat720_curs3 INTO l_fcc24
               LET l_total1 = l_total1 + (l_fcc24*(l_fcm.fcc15/100))
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
           END FOREACH 
           IF cl_null(l_total1) THEN # 主件申報可扺減稅額 
              LET l_total1 =(l_fcm.cost * (l_fcm.fcc15/100)) 
           END IF 
 
           #附屬成本  
           DECLARE t720_g_cur3 CURSOR FOR SELECT fcj11  FROM fcj_file,faj_file 
             WHERE fcj01 = g_fcm01 AND fcj02 = l_fcm.fcm02 
               AND fcj03 = faj02 AND fcj031= faj022 
           LET l_total2 = 0 LET l_fcj11 = 0 
           FOREACH t720_g_cur3 INTO l_fcj11 
                 # 附件申報可扺減稅額 
                 LET l_total2 = l_total2 + (l_fcj11 * (l_fcm.fcc15/100)) 
                 # 總成本 
                 LET l_fcm.cost = l_fcm.cost + l_fcj11 
           END FOREACH 
           IF cl_null(l_total2) THEN LET l_total2 = 0 END IF 
           LET l_fcm.amt1 = l_total1 + l_total2 
 
 
        # 未扺減額
          # 已扺減額
          LET l_fcm04 = 0 
          SELECT SUM(fcm04) INTO l_fcm04 FROM fcm_file 
           WHERE fcm01 = g_fcm01 AND fcm02 = l_fcm.fcm02
            AND fcm05 <= g_fcm05 AND fcmconf = 'Y' 
          IF STATUS OR cl_null(l_fcm04) THEN LET l_fcm04 = 0 END IF 
   
        LET l_fcm.amt2 = l_fcm.amt1 - l_fcm04 
        IF l_fcm.amt2 < 0 THEN LET l_fcm.amt2=0 END IF
        #Modify:3083 
         SELECT fcc20 INTO l_fcc20 FROM fcc_file  #
         WHERE fcc01 = g_fcm01 AND fcc03 = l_fcm.fcc03  
           AND fcc031= l_fcm.fcc031 
         IF NOT cl_null(l_fcc20) AND l_fcc20 !='4' AND l_fcc20 !='6' THEN
              LET g_fcm[g_cnt].fcm02 = l_fcm.fcm02 
              LET g_fcm[g_cnt].fcm03 = l_fcm.fcm03 
              LET g_fcm[g_cnt].fcc03 = l_fcm.fcc03 
              LET g_fcm[g_cnt].fcc031= l_fcm.fcc031 
              LET g_fcm[g_cnt].cost  = l_fcm.cost  
              LET g_fcm[g_cnt].fcc15 = l_fcm.fcc15 
              LET g_fcm[g_cnt].amt1  = l_fcm.amt1 
              LET g_fcm[g_cnt].amt2  = l_fcm.amt2 
              LET g_fcm[g_cnt].fcm04 = l_fcm.fcm04
              LET g_fcm[g_cnt].fcm03 = l_fcm.fcm03 
              LET g_cnt = g_cnt + 1
              LET g_rec_b = g_rec_b + 1
          END IF 
        #-------------------------------------      
    END FOREACH
    CALL g_fcm.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t720_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fcm TO s_fcm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t720_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL t720_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump
         CALL t720_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL t720_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL t720_fetch('L')
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
         CALL cl_set_field_pic(g_fcmconf,"","","","","")
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 自動產生
      ON ACTION auto_generate
         LET g_action_choice="auto_generate"
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
 
 
FUNCTION t720_g()
    DEFINE l_fcm      RECORD LIKE fcm_file.*
    DEFINE l_fcc      RECORD LIKE fcc_file.*
    DEFINE l_n        LIKE type_file.num5         #No.FUN-680070 SMALLINT
    DEFINE l_ans      LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
    DEFINE l_wc       LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(300)
    DEFINE l_msg      LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(300)
    DEFINE l_yy2      LIKE type_file.num5          #No.FUN-680070 SMALLINT
    DEFINE l_fcj11    LIKE   fcj_file.fcj11
    DEFINE l_fcc16    LIKE   fcc_file.fcc16
    DEFINE l_fcc24    LIKE   fcc_file.fcc24
    DEFINE l_fcm04    LIKE   fcm_file.fcm04
    DEFINE l_faj43    LIKE   faj_file.faj43
    DEFINE l_total1   LIKE type_file.num20_6   #No.FUN-4C0008       #No.FUN-680070 DEC(20,6)
    DEFINE l_total2   LIKE type_file.num20_6   #No.FUN-4C0008       #No.FUN-680070 DEC(20,6)
    DEFINE ls_tmp STRING
 
    IF cl_null(g_fcm01) THEN RETURN END IF 
    IF g_fcmconf MATCHES '[Yy]' THEN 
       CALL cl_err('afa-337',STATUS,0)
       RETURN
    END IF 
    LET g_fcm01_t=g_fcm01
    LET g_fcm05_t=g_fcm05
    LET p_row = 8 LET p_col =  25
    OPEN WINDOW t720_g AT p_row,p_col
        WITH FORM "afa/42f/afat7202" 
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("afat7202")
 
    IF INT_FLAG THEN CLOSE WINDOW t720_g RETURN END IF
 
    LET l_yy2 = g_fcm05 
    DISPLAY l_yy2 TO FORMONLY.l_yy2
 
    CONSTRUCT BY NAME l_wc ON fcc02               # 螢幕上取自動產生條件
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
   #No.TQC-760182--begin--
    IF l_wc = " 1=1" THEN
       CALL cl_err('','abm-997',1)
       LET INT_FLAG = 1
    END IF
   #No.TQC-760182--end--
    IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW t720_g RETURN END IF
   
    SELECT COUNT(*) INTO l_n FROM fcm_file 
     WHERE fcm01 = g_fcm01 AND fcm05 = l_yy2 
    IF l_n != 0 THEN 
       CALL cl_getmsg('afa-329',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
       PROMPT g_msg CLIPPED ,': ' FOR l_ans 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
#             CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
       
       END PROMPT
       IF l_ans NOT MATCHES '[Yy]' THEN 
          CLOSE WINDOW t720_g RETURN 
       ELSE 
          DELETE FROM fcm_file WHERE fcm01=g_fcm01 AND fcm05 = l_yy2 
       END IF
    END IF 
 
    CLOSE WINDOW t720_g
    MESSAGE 'Wait ...........'
    # 合併碼 非合併 
    LET g_sql = "SELECT fcc_file.* FROM fcc_file",
                " WHERE fcc01 = '",g_fcm01,"' ", 
                "  AND fcc04 IN ('1','2') ",
                "  AND ",l_wc CLIPPED 
    display 'g_sql:',g_sql
    PREPARE t720_preparex FROM g_sql      #預備一下
    DECLARE t720_g_cur1 CURSOR FOR t720_preparex
 
    LET l_fcm.fcm01   = g_fcm01      # 申請編號 
    LET l_fcm.fcmconf = g_fcmconf    # 確認碼 
    LET l_fcm.fcm05   = l_yy2        # 申請編號 
    LET l_fcm.fcmlegal = g_legal      #FUN-980003 add
 
    BEGIN WORK 
 { #No.MOD-490190
    OPEN t720_cl USING g_fcm01_t,g_fcm05_t
    IF STATUS THEN
       CALL cl_err("OPEN t720_cl:", STATUS, 1)
       CLOSE t720_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t720_cl INTO g_fcm1.*              # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fcm01,SQLCA.sqlcode,0)
        RETURN
    END IF
--}
    LET g_success = 'Y' 
    CALL s_showmsg_init()    #No.FUN-710028
    FOREACH t720_g_cur1 INTO l_fcc.*
#No.FUN-710028 --begin                                                                                                              
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
#No.FUN-710028 --end
 
        IF STATUS THEN 
#          CALL cl_err('err t720_g_cur1',STATUS,0)         #No.FUN-710028
           CALL s_errmsg('','','err t720_g_cur1',STATUS,1) #No.FUN-710028
           LET g_success = 'N' EXIT FOREACH            
        END IF 
        #扺減率 
        IF cl_null(l_fcc.fcc15) THEN LET l_fcc.fcc15 = 0 END IF 
 
        LET l_fcm.fcm02 = l_fcc.fcc02     #項次
 
        #是否已處分 
        LET l_faj43 = ''
        SELECT faj43 INTO l_faj43 FROM faj_file 
         WHERE faj02 = l_fcc.fcc03 AND faj022 = l_fcc.fcc031
        IF l_faj43 MATCHES '[56]' THEN LET l_fcm.fcm03 = 'Y' 
                                  ELSE LET l_fcm.fcm03 = 'N' END IF 
 
        IF l_fcm.fcm03 = 'N' THEN  # 未處分時, 計算其扺減額 
           #主件成本 
           IF cl_null(l_fcc.fcc16) THEN LET l_fcc.fcc16 = 0 END IF 
           #-->計算主件部份的扺減額  .. 為避免小數位四捨五入問題 
           #-->扺減額獨立推算 
           DECLARE afat720_cost3 CURSOR FOR
            SELECT fcc24 FROM fcc_file 
             WHERE fcc01=l_fcc.fcc01 AND fcc02=l_fcc.fcc02
           LET l_fcc24 = 0 LET l_total1 = 0 
           FOREACH afat720_cost3 INTO l_fcc24
               LET l_total1 = l_total1 + (l_fcc24*(l_fcc.fcc15/100))
           END FOREACH 
           IF cl_null(l_total1) THEN # 主件申報可扺減稅額 
              LET l_total1 =(l_fcc.fcc16 * (l_fcc.fcc15/100)) 
           END IF 
 
           #附屬成本  
           DECLARE t720_g_cur2 CURSOR FOR SELECT fcj11  FROM fcj_file,faj_file 
             WHERE fcj01 = l_fcc.fcc01  AND fcj02 = l_fcc.fcc02 
               AND fcj03 = faj02 AND fcj031= faj022 
           LET l_total2 = 0 LET l_fcj11 = 0 
           FOREACH t720_g_cur2 INTO l_fcj11 
                 # 附件申報可扺減稅額 
                 LET l_total2 = l_total2 + (l_fcj11 * (l_fcc.fcc15/100)) 
           END FOREACH 
           IF cl_null(l_total2) THEN LET l_total2 = 0 END IF 
 
           #扺減金額 
           LET l_fcm.fcm04 = l_total1 + l_total2 
 
           #取出已享用的扺減金額 
           # 已扺減額
           LET l_fcm04 = 0 
           SELECT SUM(fcm04) INTO l_fcm04 FROM fcm_file 
            WHERE fcm01 = g_fcm01 AND fcm02 = l_fcm.fcm02
              AND fcm05 <= g_fcm05 AND fcmconf = 'Y' 
           IF STATUS OR cl_null(l_fcm04) THEN LET l_fcm04 = 0 END IF 
   
           #減去已扺減的金額 
           LET l_fcm.fcm04 = l_fcm.fcm04 - l_fcm04 
           IF l_fcm.fcm04 < 0 THEN LET l_fcm.fcm04 = 0 END IF 
        ELSE  # 若已處分時, 扺減額為0  
           LET l_fcm.fcm04 = 0 
        END IF 
 
        INSERT INTO fcm_file VALUES(l_fcm.*)
        IF SQLCA.sqlcode THEN
#          CALL cl_err('err ins fcm',STATUS,0)   #No.FUN-660136
#          CALL cl_err3("ins","fcm_file",l_fcm.fcm01,l_fcm.fcm02,SQLCA.sqlcode,"","err ins fcm",1)  #No.FUN-660136 #No.FUN-710028
           LET g_showmsg = l_fcm.fcm01,"/",l_fcm.fcm02,"/",l_fcm.fcm05           #No.FUN-710028
           CALL s_errmsg('fcm01,fcm02,fcm05',g_showmsg,'err ins fcm',STATUS,1)   #No.FUN-710028
#          LET g_success = 'N' EXIT FOREACH      #No.FUN-710028
           LET g_success = 'N' CONTINUE FOREACH  #No.FUN-710028
        END IF 
    END FOREACH 
#No.FUN-710028 --begin                                                                                                              
    IF g_totsuccess="N" THEN                                                                                                        
       LET g_success="N"                                                                                                            
    END IF                                                                                                                          
#No.FUN-710028 --end
    CALL s_showmsg()   #No.FUN-710028
    IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK  END IF 
    MESSAGE ' '
END FUNCTION
 
FUNCTION t720_sure(l_chr)
DEFINE s_cnt     LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       l_cnt     LIKE type_file.num5,          #No.FUN-680070 SMALLINT
       l_chr     LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 LET g_fcm01_t=g_fcm01
 LET g_fcm05_t=g_fcm05
 #bugno:7341 add......................................................
 IF l_chr='Y' THEN
     SELECT COUNT(*) INTO l_cnt FROM fcc_file
      WHERE fcc01= g_fcm01
     IF l_cnt = 0 THEN
         CALL cl_err('','mfg-009',0)
         RETURN
     END IF
 END IF
 #bugno:7341 end......................................................
 
IF cl_null(g_fcm01) THEN RETURN END IF 
IF l_chr='Y' THEN  #---確認 ---#    
    IF g_fcmconf='Y' THEN RETURN END IF
    #MOD-B30603 add--str--
    IF cl_null(g_fcb05) OR cl_null(g_fcb06) THEN
       CALL cl_err('','afa1003',1)
       RETURN
    END IF
    #MOD-B30603 add--end--
    #確認一下
    IF cl_sure(0,0) AND (NOT cl_null(g_fcb05) AND NOT cl_null(g_fcb06)) THEN 
#CHI-C30107 ------------ add -------------- begin
       SELECT fcmconf INTO g_fcmconf FROM fcm_file WHERE fcm01 = g_fcm01
                                                     AND fcm05 = g_fcm05
       IF g_fcmconf='Y' THEN RETURN END IF

#CHI-C30107 ------------ add -------------- end
       BEGIN WORK 
 
       OPEN t720_cl USING g_fcm01_t,g_fcm05_t
       IF STATUS THEN
          CALL cl_err("OPEN t720_cl:", STATUS, 1)
          CLOSE t720_cl
          ROLLBACK WORK
          RETURN
       END IF
       FETCH t720_cl INTO g_fcm1.*              # 對DB鎖定
       IF SQLCA.sqlcode THEN
          CALL cl_err(g_fcm01,SQLCA.sqlcode,0)
          RETURN
       END IF
       LET g_success = 'Y'
       CALL s_showmsg_init()               #No.FUN-710028
       CALL t720_surey()                   #更新資產基本資料檔 
       CALL s_showmsg()                    #No.FUN-710028
       IF g_success = 'Y' THEN LET g_fcmconf='Y' COMMIT WORK
          DISPLAY g_fcmconf TO fcmconf
       ELSE LET g_fcmconf='N' ROLLBACK WORK
       END IF   
    END IF 
ELSE               # 取消確認
    IF g_fcmconf='N' THEN RETURN END IF
    IF cl_sure(0,0) THEN                   #確認一下
       BEGIN WORK 
 
       OPEN t720_cl USING g_fcm01_t,g_fcm05_t
       IF STATUS THEN
          CALL cl_err("OPEN t720_cl:", STATUS, 1)
          CLOSE t720_cl
          ROLLBACK WORK
          RETURN
       END IF
       FETCH t720_cl INTO g_fcm1.*              # 對DB鎖定
       IF SQLCA.sqlcode THEN
           CALL cl_err(g_fcm01,SQLCA.sqlcode,0)
           RETURN
       END IF
       LET g_success = 'Y'
       CALL s_showmsg_init()               #No.FUN-710028
       CALL t720_suren()                   #更新資產基本資料檔 
       CALL s_showmsg()                    #No.FUN-710028
       IF g_success = 'Y' THEN LET g_fcmconf='N' COMMIT WORK
            DISPLAY g_fcmconf TO fcmconf  
       ELSE LET g_fcmconf='Y' ROLLBACK WORK
       END IF   
    END IF 
END IF 
    CALL cl_set_field_pic(g_fcmconf,"","","","","")
END FUNCTION
   
FUNCTION t720_surey()
DEFINE l_n       LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       l_fcc15   LIKE fcc_file.fcc15,
       l_sql     LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(300)
       l_faj     RECORD LIKE faj_file.*
 
     IF cl_null(g_fcb06) THEN 
        CALL cl_err(g_fcm01,'afa-328',0)
        RETURN 
     END IF
     LET l_sql = 'SELECT * FROM faj_file ',
                 'WHERE faj02 = ? AND faj022 = ?  '
 
     PREPARE afat720_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM 
     END IF
     DECLARE t720_surey SCROLL CURSOR FOR afat720_prepare2
 
    FOR l_n = 1 TO 300 
#No.FUN-710028 --begin                                                                                                              
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
#No.FUN-710028 --end
 
        IF cl_null(g_fcm[l_n].fcc03) THEN EXIT FOR END IF 
        OPEN t720_surey USING g_fcm[l_n].fcc03,g_fcm[l_n].fcc031 
        FETCH t720_surey INTO l_faj.*
        IF cl_null(l_faj.faj81) THEN LET l_faj.faj81 = 0 END IF 
        IF cl_null(l_faj.faj811) THEN LET l_faj.faj811 = 0 END IF 
        IF l_faj.faj811 + g_fcm[l_n].fcm04 > g_fcm[l_n].amt1 THEN 
      #    MESSAGE g_fcm[l_n].fcc03,' ',g_fcm[l_n].fcc031,' ', 
      #              l_faj.faj811,' ', g_fcm[l_n].fcm04,' ',g_fcm[l_n].amt1 
#          CALL cl_err('afa-336',STATUS,0)          #No.FUN-710028
           CALL s_errmsg('','','afa-336',STATUS,1)  #No.FUN-710028
#          LET g_success = 'N' EXIT FOR      #No.FUN-710028
           LET g_success = 'N' CONTINUE FOR  #No.FUN-710028
        END IF 
        UPDATE faj_file SET faj811 = l_faj.faj811+g_fcm[l_n].fcm04,#已扺減金額 
                            faj812 = g_fcm05                       #年度 
         WHERE faj02 = g_fcm[l_n].fcc03 AND faj022 = g_fcm[l_n].fcc031 
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
           LET g_showmsg = g_fcm[l_n].fcc03,"/",g_fcm[l_n].fcc031  #No.FUN-710028
           CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj_file',SQLCA.sqlcode,1) #No.FUN-710028
#          LET g_success = 'N' CLOSE t720_surey RETURN #No.FUN-710028
           LET g_success = 'N' CONTINUE FOR            #No.FUN-710028
        END IF
        CLOSE t720_surey 
    END FOR
#No.FUN-710028 --begin                                                                                                              
    IF g_totsuccess="N" THEN                                                                                                        
       LET g_success="N"                                                                                                            
    END IF                                                                                                                          
#No.FUN-710028 --end
 
    LET g_i = g_i      
    UPDATE fcm_file SET fcmconf='Y' WHERE fcm01=g_fcm01 AND fcm05 = g_fcm05 
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       LET g_showmsg = g_fcm01,"/",g_fcm05   #No.FUN-710028
       CALL s_errmsg('fcm01,fcm05',g_showmsg,'upd fcm_file',SQLCA.sqlcode,1)  #No.FUN-710028
       LET g_success = 'N' 
    END IF
END FUNCTION 
   
FUNCTION t720_suren()
DEFINE l_n       LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       l_fcc15   LIKE fcc_file.fcc15,
       l_sql     LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(300)
       l_faj     RECORD LIKE faj_file.*
 
     IF cl_null(g_fcb06) THEN 
        CALL cl_err(g_fcm01,'afa-328',0)
        RETURN 
     END IF
     LET l_sql = " SELECT * FROM faj_file " ,
                 " WHERE faj02 = ? AND faj022 = ? " 
 
     PREPARE afat720_prepare3 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM 
     END IF
     DECLARE t720_suren CURSOR FOR afat720_prepare3
 
    FOR l_n = 1 TO 300 
#No.FUN-710028 --begin                                                                                                              
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
#No.FUN-710028 --end
 
        IF cl_null(g_fcm[l_n].fcc03) THEN EXIT FOR END IF 
        OPEN t720_suren USING g_fcm[l_n].fcc03,g_fcm[l_n].fcc031 
        FETCH t720_suren INTO l_faj.*
        IF cl_null(l_faj.faj811) THEN LET l_faj.faj811 = 0 END IF 
        UPDATE faj_file SET faj811 = l_faj.faj811-g_fcm[l_n].fcm04,#已扺減金額 
                          # faj812 = ''  #年度 #TQC-970033 mark
                            faj812 = 0   #年度 #TQC-970033 add
         WHERE faj02 = g_fcm[l_n].fcc03 AND faj022 = g_fcm[l_n].fcc031 
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
           LET g_showmsg = g_fcm[l_n].fcc03,"/",g_fcm[l_n].fcc031  #No.FUN-710028
           CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj_file',SQLCA.sqlcode,1) #No.FUN-710028
#          LET g_success = 'N' CLOSE t720_suren RETURN #No.FUN-710028
           LET g_success = 'N' CONTINUE FOR            #No.FUN-710028
        END IF
        CLOSE t720_suren 
    END FOR     
#No.FUN-710028 --begin                                                                                                              
    IF g_totsuccess="N" THEN                                                                                                        
       LET g_success="N"                                                                                                            
    END IF                                                                                                                          
#No.FUN-710028 --end
 
    LET g_i = g_i 
    UPDATE fcm_file SET fcmconf='N' WHERE fcm01=g_fcm01 AND fcm05 = g_fcm05 
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       LET g_showmsg = g_fcm01,"/",g_fcm05   #No.FUN-710028
       CALL s_errmsg('fcm01,fcm05',g_showmsg,'upd fcm_file',SQLCA.sqlcode,1)  #No.FUN-710028
       LET g_success = 'N' 
    END IF
END FUNCTION 
   
FUNCTION t720_fcm02(p_cmd)
DEFINE   p_cmd       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
         l_cnt       LIKE type_file.num5,         #No.FUN-680070 SMALLINT
         l_total1    LIKE type_file.num20_6,  #No.FUN-4C0008       #No.FUN-680070 DEC(20,6)
         l_total2    LIKE type_file.num20_6,  #No.FUN-4C0008       #No.FUN-680070 DEC(20,6)
         l_fcj11     LIKE  fcj_file.fcj11,
         l_fcc03     LIKE  fcc_file.fcc03,
         l_fcc031    LIKE  fcc_file.fcc031,
         l_fcc16     LIKE  fcc_file.fcc16,
         l_fcc24     LIKE  fcc_file.fcc24,
         l_fcm04     LIKE  fcm_file.fcm04,
         l_fcc15     LIKE  fcc_file.fcc15
 
    LET g_errno = ' '
    SELECT fcc03,fcc031,fcc16,fcc15
      INTO l_fcc03,l_fcc031,l_fcc16,l_fcc15
      FROM fcc_file 
     WHERE fcc01 = g_fcm01 AND fcc02 = g_fcm[l_ac].fcm02 
       AND fcc04 IN ('1','2') 
 
    IF STATUS THEN LET g_errno = STATUS USING '----' END IF 
 
    IF cl_null(g_errno) AND (p_cmd = 'a' OR p_cmd = 'u') THEN
        LET g_fcm[l_ac].fcc03 = l_fcc03 
        LET g_fcm[l_ac].fcc031= l_fcc031 
        LET g_fcm[l_ac].fcc15 = l_fcc15
          
           IF cl_null(l_fcc16) THEN LET l_fcc16 = 0 END IF 
           LET g_fcm[l_ac].cost = l_fcc16 
           #-->計算主件部份的扺減額  .. 為避免小數位四捨五入問題 
           #-->扺減額獨立推算 
           DECLARE afat720_curs4 CURSOR FOR
            SELECT fcc24 FROM fcc_file 
             WHERE fcc01=g_fcm01 AND fcc02=g_fcm[l_ac].fcm02 
           LET l_fcc24 = 0 LET l_total1 = 0 
           FOREACH afat720_curs4 INTO l_fcc24
               LET l_total1 = l_total1 + (l_fcc24*(l_fcc15/100))
           END FOREACH 
           IF cl_null(l_total1) THEN # 主件申報可扺減稅額 
              LET l_total1 =(g_fcm[l_ac].cost * (g_fcm[l_ac].fcc15/100)) 
           END IF 
 
           #附屬成本  
           DECLARE t720_g_cur4 CURSOR FOR SELECT fcj11  FROM fcj_file,faj_file 
             WHERE fcj01 = g_fcm01 AND fcj02 = g_fcm[l_ac].fcm02 
               AND fcj03 = faj02 AND fcj031= faj022 
           LET l_total2 = 0 LET l_fcj11 = 0 
           FOREACH t720_g_cur4 INTO l_fcj11 
                 # 附件申報可扺減稅額 
                 LET l_total2 = l_total2 + (l_fcj11 * (g_fcm[l_ac].fcc15/100)) 
                 # 總成本 
                 LET g_fcm[l_ac].cost = g_fcm[l_ac].cost + l_fcj11 
           END FOREACH 
           IF cl_null(l_total2) THEN LET l_total2 = 0 END IF 
           LET g_fcm[l_ac].amt1 = l_total1 + l_total2 
 
        # 未扺減額
          # 已扺減額
          LET l_fcm04 = 0 
          SELECT SUM(fcm04) INTO l_fcm04 FROM fcm_file 
           WHERE fcm01 = g_fcm01 AND fcm02 = g_fcm[l_ac].fcm02
             AND fcm05 <= g_fcm05 AND fcmconf = 'Y' 
          IF STATUS OR cl_null(l_fcm04) THEN LET l_fcm04 = 0 END IF 
   
        LET g_fcm[l_ac].amt2 = g_fcm[l_ac].amt1 - l_fcm04 
        IF g_fcm[l_ac].amt2 < 0 THEN LET g_fcm[l_ac].amt2=0 END IF
 
        DISPLAY g_fcm[l_ac].fcc03 TO fcc03
        DISPLAY g_fcm[l_ac].fcc031 TO fcc031
        DISPLAY g_fcm[l_ac].cost TO cost
        DISPLAY g_fcm[l_ac].fcc15 TO fcc15
        DISPLAY g_fcm[l_ac].amt1 TO amt1
        DISPLAY g_fcm[l_ac].amt2 TO amt2
    END IF
 
END FUNCTION
 
