# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Pattern name...: agli141.4gl
# Descriptions...: 外部銷售利潤分攤維護作業
# Date & Author..: 06/07/24 By Sarah
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.FUN-6A0061 23/10/16 By xumin g_no_ask 改為 mi_no_ask
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0040 06/11/15 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-720019 07/02/28 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-730070 07/04/03 By Carrier 會計科目加帳套-財務
# Modify.........: No.TQC-6C0097 07/05/07 By Sarah 執行"分攤整批產生"無法產生資料
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-830095 08/04/21 By lutingting報表轉為使用Crystal Report 輸出 
# Modify.........: No.FUN-980003 09/08/10 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980253 09/08/25 By xiaofeizhu 出貨單號錄入無效值，仍能通過，需管控是否存在于oga_file
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9A0005 09/10/07 By Smapmin 異動碼預設為NULL而非一個空白
# Modify.........: No:CHI-9A0027 09/10/15 By mike 新增时年度期别之初值应调整为 CALL s_yp(g_today) RETURNING g_ahj02,g_ahj03         
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A60056 10/07/08 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No.FUN-A70139 10/07/29 By lutingting 修正FUN-A60056 問題
# Modify.........: No.FUN-9A0036 10/09/14 By chenmoyan 勾選二套帳時,分錄底稿二的匯率,應依帳別二的設定幣別進行換算
# Modify.........: No:FUN-B40056 11/05/11 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料 
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.FUN-D10065 13/01/17 By lujh 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                 判断若npq04 为空.则依原给值方式给值
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No.FUN-D40118 13/05/20 By zhangweib 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空


DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_ahj01            LIKE ahj_file.ahj01,   #銷售成本中心
    g_ahj01_t          LIKE ahj_file.ahj01,   #銷售成本中心
    g_ahj02            LIKE ahj_file.ahj02,   #年度
    g_ahj02_t          LIKE ahj_file.ahj02,   #年度
    g_ahj03            LIKE ahj_file.ahj03,   #期別
    g_ahj03_t          LIKE ahj_file.ahj03,   #期別
    g_gem02            LIKE gem_file.gem02,   #銷售成本中心名稱
    g_ahj              DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        ahj19          LIKE ahj_file.ahj19,   #FUN-A60056
        ahj04          LIKE ahj_file.ahj04,
        ahj05          LIKE ahj_file.ahj05,
        ahj06          LIKE ahj_file.ahj06,
        ahj061         LIKE ahj_file.ahj061,
        ima021         LIKE ima_file.ima021,
        ima25          LIKE ima_file.ima25,
        ahj07          LIKE ahj_file.ahj07,
        ahj08          LIKE ahj_file.ahj08,
        ahj09          LIKE ahj_file.ahj09,
        ahj10          LIKE ahj_file.ahj10,
        ahj11          LIKE ahj_file.ahj11,
        ahj12          LIKE ahj_file.ahj12,
        ahj13          LIKE ahj_file.ahj13,
        ahj14          LIKE ahj_file.ahj14,
        ahj15          LIKE ahj_file.ahj15,
        gem02_b        LIKE gem_file.gem02,
        ahj16          LIKE ahj_file.ahj16,
        ahj17          LIKE ahj_file.ahj17,
        ahj18          LIKE ahj_file.ahj18
                       END RECORD,
    g_ahj_t            RECORD                 #程式變數 (舊值)
        ahj19          LIKE ahj_file.ahj19,   #FUN-A60056
        ahj04          LIKE ahj_file.ahj04,
        ahj05          LIKE ahj_file.ahj05,
        ahj06          LIKE ahj_file.ahj06,
        ahj061         LIKE ahj_file.ahj061,
        ima021         LIKE ima_file.ima021,
        ima25          LIKE ima_file.ima25,
        ahj07          LIKE ahj_file.ahj07,
        ahj08          LIKE ahj_file.ahj08,
        ahj09          LIKE ahj_file.ahj09,
        ahj10          LIKE ahj_file.ahj10,
        ahj11          LIKE ahj_file.ahj11,
        ahj12          LIKE ahj_file.ahj12,
        ahj13          LIKE ahj_file.ahj13,
        ahj14          LIKE ahj_file.ahj14,
        ahj15          LIKE ahj_file.ahj15,
        gem02_b        LIKE gem_file.gem02,
        ahj16          LIKE ahj_file.ahj16,
        ahj17          LIKE ahj_file.ahj17,
        ahj18          LIKE ahj_file.ahj18
                       END RECORD,
    g_wc,g_sql,g_wc2   STRING,
    g_show             LIKE type_file.chr1,          #No.FUN-680098   VARCHAR(1)
    g_rec_b            LIKE type_file.num5,                #單身筆數  #No.FUN-680098 SMALLINT
    g_flag             LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)  
    g_ss               LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)    
    l_ac               LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680098 SMALINT
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680098 SMALLINT
DEFINE g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL  
DEFINE g_sql_tmp       STRING   #No.TQC-720019
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE g_msg           LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10         #No.FUN-680098  INTEGER 
DEFINE g_curs_index    LIKE type_file.num10         #No.FUN-680098  INTEGER 
DEFINE g_jump          LIKE type_file.num10         #No.FUN-680098  INTEGER 
DEFINE mi_no_ask       LIKE type_file.num5          #No.FUN-680098  SMALLINT   #No.FUN-6A0061 
DEFINE g_bookno1       LIKE aza_file.aza81          #No.FUN-730033
DEFINE g_bookno2       LIKE aza_file.aza82          #No.FUN-730033
DEFINE g_bookno        LIKE aza_file.aza82          #No.FUN-D40118   Add
DEFINE l_table         STRING                       #No.FUN-830095
DEFINE g_str           STRING                       #No.FUN-830095
DEFINE l_sql           STRING                       #No.FUN-830095
 
MAIN
#       l_time   LIKE type_file.chr8            #No.FUN-6A0073
 
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
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114 #FUN-BB0047
 
#NO.FUN-830095---------start--
   LET l_sql = "ahj01.ahj_file.ahj01,", 
               "l_gem02.gem_file.gem02,", 
               "ahj02.ahj_file.ahj02,", 
               "ahj03.ahj_file.ahj03,", 
               "ahj04.ahj_file.ahj04,", 
               "ahj05.ahj_file.ahj05,", 
               "ahj06.ahj_file.ahj06,", 
               "ahj061.ahj_file.ahj061,", 
               "l_ima021.ima_file.ima021,",
               "l_ima25.ima_file.ima25,", 
               "ahj07.ahj_file.ahj07,", 
               "ahj08.ahj_file.ahj08,", 
               "ahj09.ahj_file.ahj09,", 
               "ahj10.ahj_file.ahj10,", 
               "ahj11.ahj_file.ahj11,", 
               "ahj12.ahj_file.ahj12,", 
               "ahj13.ahj_file.ahj13,", 
               "ahj14.ahj_file.ahj14,", 
               "ahj15.ahj_file.ahj15,", 
               "l_gem02_b.gem_file.gem02,",
               "ahj16.ahj_file.ahj16,", 
               "ahj17.ahj_file.ahj17,", 
               "ahj18.ahj_file.ahj18,", 
               "azi03.azi_file.azi03,", 
               "azi04.azi_file.azi05" 
   LET l_table = cl_prt_temptable('agli141',l_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?)"
   PREPARE insert_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-830095---------end
 
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047
   LET p_row = 3 LET p_col = 16
   OPEN WINDOW i141_w AT p_row,p_col WITH FORM "agl/42f/agli141"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL i141_menu()
 
   CLOSE WINDOW i141_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION i141_cs()
DEFINE l_sql STRING   
 
    CLEAR FORM                            #清除畫面
    CALL g_ahj.clear()
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
   INITIALIZE g_ahj01 TO NULL    #No.FUN-750051
   INITIALIZE g_ahj02 TO NULL    #No.FUN-750051
   INITIALIZE g_ahj03 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON ahj01,ahj02,ahj03,
                      ahj19,ahj04,ahj05,ahj06,ahj061,ahj07,ahj08,ahj09,ahj10,    #FUN-A60056 add ahj19
                      ahj11,ahj12,ahj13,ahj14,ahj15,ahj16,ahj17,ahj18
         FROM ahj01,ahj02,ahj03,
              s_ahj[1].ahj19,     #FUN-A60056
              s_ahj[1].ahj04,s_ahj[1].ahj05,s_ahj[1].ahj06,s_ahj[1].ahj061,
              s_ahj[1].ahj07,s_ahj[1].ahj08,s_ahj[1].ahj09,s_ahj[1].ahj10,
              s_ahj[1].ahj11,s_ahj[1].ahj12,s_ahj[1].ahj13,s_ahj[1].ahj14,
              s_ahj[1].ahj15,s_ahj[1].ahj16,s_ahj[1].ahj17,s_ahj[1].ahj18
            
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No.FUN-580031 --end--       HCN
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(ahj01)   #銷售成本中心
                CALL cl_init_qry_var()
                LET g_qryparam.form  ="q_gem4"
                LET g_qryparam.state ="c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ahj01
                NEXT FIELD ahj01
             #FUN-A60056--add-str--
             WHEN INFIELD(ahj19)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_azw" 
                LET g_qryparam.state = "c" 
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ahj19 
                NEXT FIELD ahj19 
             #FUN-A60056--add--end
             WHEN INFIELD(ahj04)   #出貨單號
                CALL cl_init_qry_var()
                LET g_qryparam.form  ="q_ogb06"
                LET g_qryparam.state ="c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ahj04
                NEXT FIELD ahj04
             WHEN INFIELD(ahj06)   #料號
                CALL cl_init_qry_var()
                LET g_qryparam.form  ="q_ima"
                LET g_qryparam.state ="c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ahj06
                NEXT FIELD ahj06
             WHEN INFIELD(ahj15)   #分攤成本中心
                CALL cl_init_qry_var()
                LET g_qryparam.form  ="q_gem4"
                LET g_qryparam.state ="c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ahj15
                NEXT FIELD ahj15
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
    
    LET l_sql="SELECT DISTINCT ahj01,ahj02,ahj03 FROM ahj_file",
              " WHERE ", g_wc CLIPPED
    LET g_sql= l_sql," ORDER BY ahj01,ahj02,ahj03"
    PREPARE i141_prepare FROM g_sql      #預備一下
    DECLARE i141_bcs                     #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i141_prepare
 
    DROP TABLE i141_cnttmp
    LET l_sql=l_sql," INTO TEMP i141_cnttmp"
    PREPARE i141_cnttmp_pre FROM l_sql
    EXECUTE i141_cnttmp_pre    
    
#   LET g_sql="SELECT COUNT(*) FROM i141_cnttmp"      #No.TQC-720019
    LET g_sql_tmp="SELECT COUNT(*) FROM i141_cnttmp"  #No.TQC-720019
#   PREPARE i141_precount FROM g_sql      #No.TQC-720019
    PREPARE i141_precount FROM g_sql_tmp  #No.TQC-720019
    DECLARE i141_count CURSOR FOR i141_precount
 
END FUNCTION
 
FUNCTION i141_menu()
 
   WHILE TRUE
      CALL i141_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i141_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i141_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i141_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i141_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i141_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i141_out()
            END IF
         WHEN "gen_apportion"     #分攤整批產生
            IF cl_chk_act_auth() THEN
               CALL i141_g()
            END IF
         WHEN "gen_entry_sheet"   #內部分錄產生
            IF cl_chk_act_auth() THEN
               CALL i141_v()
            END IF
         WHEN "entry_sheet"
            IF cl_chk_act_auth() THEN
               CALL i141_e()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_ahj),'','')
            END IF
         #No.FUN-6B0040-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_ahj01 IS NOT NULL THEN
                LET g_doc.column1 = "ahj01"
                LET g_doc.column2 = "ahj02"
                LET g_doc.column3 = "ahj03"
                LET g_doc.value1 = g_ahj01
                LET g_doc.value2 = g_ahj02
                LET g_doc.value3 = g_ahj03
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6B0040-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i141_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_ahj.clear()
   LET g_ahj01_t  = NULL
   LET g_ahj02_t  = NULL
   LET g_ahj03_t  = NULL
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i141_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_ahj01,g_ahj02,g_ahj03 TO NULL
         LET g_ss='N'
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      LET g_rec_b = 0                    #No.FUN-680064
      IF g_ss='N' THEN
         CALL g_ahj.clear()
      ELSE
         CALL i141_b_fill('1=1')         #單身
      END IF
 
      CALL i141_b()                      #輸入單身
 
      LET g_ahj01_t = g_ahj01
      LET g_ahj02_t = g_ahj02
      LET g_ahj03_t = g_ahj03
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i141_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #a:輸入 u:更改        #No.FUN-680098 VARCHAR(1)
    l_cnt           LIKE type_file.num10    #No.FUN-680098    INTEGER 
 
    LET g_ss='Y'
 
   #LET g_ahj02=YEAR(g_today)   #CHI-9A0027     
   #LET g_ahj03=MONTH(g_today)  #CHI-9A0027                                                                                          
    CALL s_yp(g_today) RETURNING g_ahj02,g_ahj03 #CHI-9A0027    
    CALL cl_set_head_visible("","YES")      #No.FUN-6B0029
 
    INPUT g_ahj01,g_ahj02,g_ahj03 WITHOUT DEFAULTS FROM ahj01,ahj02,ahj03
 
       AFTER FIELD ahj01
          IF NOT cl_null(g_ahj01) THEN
             IF NOT s_costcenter_chk(g_ahj01) THEN
                LET g_ahj01=''
                LET g_gem02=''
                DISPLAY BY NAME g_ahj01
                DISPLAY '' TO FORMONLY.gem02
                NEXT FIELD ahj01
             ELSE
                LET g_gem02=s_costcenter_desc(g_ahj01)
                DISPLAY g_gem02 TO FORMONLY.gem02
             END IF
          END IF
 
       AFTER FIELD ahj02
          IF NOT cl_null(g_ahj02) THEN
             IF g_ahj02 < 0 THEN 
                CALL cl_err('','mfg3291',1)
                NEXT FIELD ahj02
             END IF
          END IF
 
       AFTER FIELD ahj03
#No.TQC-720032 -- begin --
         IF NOT cl_null(g_ahj03) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_ahj03
            IF g_azm.azm02 = 1 THEN
               IF g_ahj03 > 12 OR g_ahj03 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD ahj03
               END IF
            ELSE
               IF g_ahj03 > 13 OR g_ahj03 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD ahj03
               END IF
            END IF
         END IF
#          IF NOT cl_null(g_ahj03) THEN
#             IF g_ahj03 < 1 OR g_ahj03 > 12 THEN 
#                CALL cl_err('','agl-013',1)
#                NEXT FIELD ahj03
#             END IF
#          END IF
#No.TQC-720032 -- end --
 
       AFTER INPUT
          IF INT_FLAG THEN
             EXIT INPUT
          END IF
       
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(ahj01)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gem4"
                LET g_qryparam.default1 =g_ahj01
                CALL cl_create_qry() RETURNING g_ahj01 
                DISPLAY BY NAME g_ahj01
                NEXT FIELD ahj01
          END CASE
          
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
 
FUNCTION i141_q()
   LET g_ahj01 = ''
   LET g_ahj02 = ''
   LET g_ahj03 = ''
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_ahj01,g_ahj02,g_ahj03 TO NULL     #No.FUN-6B0040
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_ahj.clear()
   DISPLAY '' TO FORMONLY.cnt
 
   CALL i141_cs()                      #取得查詢條件
 
   IF INT_FLAG THEN                    #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_ahj01,g_ahj02,g_ahj03 TO NULL
      RETURN
   END IF
 
   OPEN i141_bcs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_ahj01,g_ahj02,g_ahj03 TO NULL
   ELSE
      OPEN i141_count
      FETCH i141_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i141_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i141_fetch(p_flag)
   DEFINE p_flag          LIKE type_file.chr1       #處理方式        #No.FUN-680098 VARCHAR(1)
 
   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     i141_bcs INTO g_ahj01,g_ahj02,g_ahj03
       WHEN 'P' FETCH PREVIOUS i141_bcs INTO g_ahj01,g_ahj02,g_ahj03
       WHEN 'F' FETCH FIRST    i141_bcs INTO g_ahj01,g_ahj02,g_ahj03
       WHEN 'L' FETCH LAST     i141_bcs INTO g_ahj01,g_ahj02,g_ahj03
       WHEN '/'
            IF (NOT mi_no_ask) THEN        #No.FUN-6A0061
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
            FETCH ABSOLUTE g_jump i141_bcs INTO g_ahj01,g_ahj02,g_ahj03
            LET mi_no_ask = FALSE    #No.FUN-6A0061
   END CASE
 
   IF SQLCA.sqlcode THEN                  #有麻煩
      CALL cl_err(g_ahj01,SQLCA.sqlcode,0)
      INITIALIZE g_ahj01 TO NULL  #TQC-6B0105
      INITIALIZE g_ahj02 TO NULL  #TQC-6B0105
      INITIALIZE g_ahj03 TO NULL  #TQC-6B0105
   ELSE
      CALL i141_show()
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
FUNCTION i141_show()
 
   DISPLAY g_ahj01 TO ahj01
   DISPLAY g_ahj02 TO ahj02
   DISPLAY g_ahj03 TO ahj03
   CALL i141_set_ahj15(g_ahj01) RETURNING g_gem02
   DISPLAY g_gem02 TO FORMONLY.gem02
 
   CALL i141_b_fill(g_wc)                      #單身
 
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i141_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680098 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用         #No.FUN-680098 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680098 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                 #處理狀態          #No.FUN-680098 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680098  SMALLINT
   l_allow_delete  LIKE type_file.num5,                #可刪除否        #No.FUN-680098  SMALLINT 
   l_cnt           LIKE type_file.num10,                                #No.FUN-680098  INTEGER 
   l_ogb           RECORD LIKE ogb_file.*,
   l_oga24         LIKE oga_file.oga24
 
   LET g_action_choice = ""
 
   IF cl_null(g_ahj01) OR cl_null(g_ahj02) OR cl_null(g_ahj03) OR
      g_ahj02=0 OR g_ahj03=0 THEN
      CALL cl_err('',-400,1)
   END IF
 
   IF s_shut(0) THEN RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT ahj19,ahj04,ahj05,ahj06,ahj061,'','',ahj07,ahj08,",   #FUN-A60056 add ahj19
                      "       ahj09,ahj10,ahj11,ahj12,ahj13,ahj14,ahj15,'',",
                      "       ahj16,ahj17,ahj18",
                      "  FROM ahj_file",
                      "  WHERE ahj01 = ? AND ahj02 = ? AND ahj03 = ? ",
                      "   AND ahj04 = ? AND ahj05 = ? FOR UPDATE"
                      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i141_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   IF g_rec_b=0 THEN CALL g_ahj.clear() END IF
 
   INPUT ARRAY g_ahj WITHOUT DEFAULTS FROM s_ahj.*
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
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_ahj_t.* = g_ahj[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN i141_bcl USING g_ahj01,g_ahj02,g_ahj03,g_ahj[l_ac].ahj04,g_ahj[l_ac].ahj05
            IF STATUS THEN
               CALL cl_err("OPEN i141_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i141_bcl INTO g_ahj[l_ac].*
               IF STATUS THEN
                  CALL cl_err("OPEN i141_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  CALL i141_set_ahj06(g_ahj[l_ac].ahj06) 
                       RETURNING g_ahj[l_ac].ima021,g_ahj[l_ac].ima25
                  CALL i141_set_ahj15(g_ahj[l_ac].ahj15) 
                       RETURNING g_ahj[l_ac].gem02_b
                  LET g_ahj_t.*=g_ahj[l_ac].*
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ahj[l_ac].* TO NULL            #900423
         LET g_ahj_t.* = g_ahj[l_ac].*               #新輸入資料
         LET g_ahj[l_ac].ahj16=0
         LET g_ahj[l_ac].ahj17=0
         CALL cl_show_fld_cont()
        #NEXT FIELD ahj04   #FUN-A70139
         NEXT FIELD ahj19   #FUN-A70139
 
      #FUN-A60056--add--str--
      AFTER FIELD ahj19
         IF NOT cl_null(g_ahj[l_ac].ahj19) THEN
            CALL i141_ahj19()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ahj[l_ac].ahj19,g_errno,1)
               NEXT FIELD ahj19
            END IF 
         ELSE
            CALL cl_err('','alm-809',0)
            NEXT FIELD ahj19 
         END IF
      #FUN-A60056--add--end

      AFTER FIELD ahj04                         # check data 是否重複
         IF NOT cl_null(g_ahj[l_ac].ahj04) THEN
            IF (g_ahj[l_ac].ahj04 != g_ahj_t.ahj04 OR g_ahj_t.ahj04 IS NULL) OR 
               (g_ahj[l_ac].ahj05 != g_ahj_t.ahj05 OR g_ahj_t.ahj05 IS NULL) THEN
               #TQC-980253--Add--Begin--#                                                                                           
               LET l_cnt=0                                                                                                          
              #FUN-A60056--mod--str--
              #SELECT COUNT(*) INTO l_cnt FROM oga_file                                                                             
              # WHERE oga01=g_ahj[l_ac].ahj04                                                                                       
              #   AND oga00 IN ('1','4','5','6')                                                                                        
              #   AND oga09 IN ('2','3','4','6','8')                                                                                       
              #   AND ogaconf='Y'                                                                                                   
              #   AND ogapost='Y'                                                                                                   
               LET g_sql = "SELECT COUNT(*) ",
                           "  FROM ",cl_get_target_table(g_ahj[l_ac].ahj19,'oga_file'),
                           " WHERE oga01='",g_ahj[l_ac].ahj04,"'",
                           "   AND oga00 IN ('1','4','5','6')",
                           "   AND oga09 IN ('2','3','4','6','8')",
                           "   AND ogaconf='Y' AND ogapost='Y' " 
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,g_ahj[l_ac].ahj19) RETURNING g_sql
               PREPARE sel_cou_ahj19 FROM g_sql
               EXECUTE sel_cou_ahj19 INTO l_cnt
              #FUN-A60056--mod--end
               IF (l_cnt <= 0) OR (SQLCA.sqlcode) THEN                                                                              
                  CALL cl_err(g_ahj[l_ac].ahj04,'anm-027',0)                                                                        
                  LET g_ahj[l_ac].ahj04 = g_ahj_t.ahj04                                                                             
                  DISPLAY BY NAME g_ahj[l_ac].ahj04                                                                                 
                  NEXT FIELD ahj04                                                                                                  
               END IF                                                                                                               
               #TQC-980253--Add--End--#
               LET l_cnt=0
               SELECT COUNT(*) INTO l_cnt FROM ahj_file
                WHERE ahj01=g_ahj01 
                  AND ahj02=g_ahj02 
                  AND ahj03=g_ahj03
                  AND ahj04=g_ahj[l_ac].ahj04 
                  AND ahj05=g_ahj[l_ac].ahj05
               IF (l_cnt > 0) OR (SQLCA.sqlcode) THEN
                  CALL cl_err(g_ahj[l_ac].ahj04,-239,0)
                  LET g_ahj[l_ac].ahj04 = g_ahj_t.ahj04
                  LET g_ahj[l_ac].ahj05 = g_ahj_t.ahj05
                  DISPLAY BY NAME g_ahj[l_ac].ahj04,g_ahj[l_ac].ahj05
                  NEXT FIELD ahj04
               ELSE
                  CALL i141_set_ahj05(g_ahj[l_ac].ahj04,g_ahj[l_ac].ahj05,g_ahj[l_ac].ahj19)   #FUN-A60056 add ahj19
                       RETURNING l_ogb.*,l_oga24
                  LET g_ahj[l_ac].ahj06 = l_ogb.ogb04                           #料號
                  LET g_ahj[l_ac].ahj061= l_ogb.ogb06                           #品名
                  CALL i141_set_ahj06(g_ahj[l_ac].ahj06) 
                       RETURNING g_ahj[l_ac].ima021,g_ahj[l_ac].ima25
                  LET g_ahj[l_ac].ahj07 = l_ogb.ogb12*l_ogb.ogb05_fac           #數量
                  CALL i141_set_ahj08(g_ahj02,g_ahj03,g_ahj[l_ac].ahj06) 
                       RETURNING g_ahj[l_ac].ahj08,g_ahj[l_ac].ahj10
                  LET g_ahj[l_ac].ahj09 = g_ahj[l_ac].ahj07*g_ahj[l_ac].ahj08   #成本金額
                  LET g_ahj[l_ac].ahj11 = g_ahj[l_ac].ahj07*g_ahj[l_ac].ahj10   #內部金額
                  LET g_ahj[l_ac].ahj12 = l_ogb.ogb13*l_oga24/l_ogb.ogb05_fac   #銷售單價
                  LET g_ahj[l_ac].ahj13 = g_ahj[l_ac].ahj07*g_ahj[l_ac].ahj12   #銷售金額
                  LET g_ahj[l_ac].ahj14 = g_ahj[l_ac].ahj13-g_ahj[l_ac].ahj11   #內部利潤
                  DISPLAY BY NAME g_ahj[l_ac].ahj06 ,g_ahj[l_ac].ahj061,
                                  g_ahj[l_ac].ima021,g_ahj[l_ac].ima25,
                                  g_ahj[l_ac].ahj07 ,g_ahj[l_ac].ahj08,
                                  g_ahj[l_ac].ahj09 ,g_ahj[l_ac].ahj10,
                                  g_ahj[l_ac].ahj11 ,g_ahj[l_ac].ahj12,
                                  g_ahj[l_ac].ahj13 ,g_ahj[l_ac].ahj14
                  LET g_ahj_t.* = g_ahj[l_ac].*               #新輸入資料
               END IF
            END IF
         END IF
 
      AFTER FIELD ahj05                         # check data 是否重複
         IF NOT cl_null(g_ahj[l_ac].ahj05) THEN
            IF (g_ahj[l_ac].ahj04 != g_ahj_t.ahj04 OR g_ahj_t.ahj04 IS NULL) OR 
               (g_ahj[l_ac].ahj05 != g_ahj_t.ahj05 OR g_ahj_t.ahj05 IS NULL) THEN
               LET l_cnt=0
               SELECT COUNT(*) INTO l_cnt FROM ahj_file
                WHERE ahj01=g_ahj01 
                  AND ahj02=g_ahj02 
                  AND ahj03=g_ahj03
                  AND ahj04=g_ahj[l_ac].ahj04 
                  AND ahj05=g_ahj[l_ac].ahj05
               IF (l_cnt > 0) OR (SQLCA.sqlcode) THEN
                  CALL cl_err(g_ahj[l_ac].ahj04,-239,0)
                  LET g_ahj[l_ac].ahj04 = g_ahj_t.ahj04
                  LET g_ahj[l_ac].ahj05 = g_ahj_t.ahj05
                  DISPLAY BY NAME g_ahj[l_ac].ahj04,g_ahj[l_ac].ahj05
                  NEXT FIELD ahj05
               ELSE
                  CALL i141_set_ahj05(g_ahj[l_ac].ahj04,g_ahj[l_ac].ahj05,g_ahj[l_ac].ahj19)   #FUN-A60056 add ahj19
                       RETURNING l_ogb.*,l_oga24
                  LET g_ahj[l_ac].ahj06 = l_ogb.ogb04                           #料號
                  LET g_ahj[l_ac].ahj061= l_ogb.ogb06                           #品名
                  CALL i141_set_ahj06(g_ahj[l_ac].ahj06) 
                       RETURNING g_ahj[l_ac].ima021,g_ahj[l_ac].ima25
                  LET g_ahj[l_ac].ahj07 = l_ogb.ogb12*l_ogb.ogb05_fac           #數量
                  CALL i141_set_ahj08(g_ahj02,g_ahj03,g_ahj[l_ac].ahj06) 
                       RETURNING g_ahj[l_ac].ahj08,g_ahj[l_ac].ahj10
                  LET g_ahj[l_ac].ahj09 = g_ahj[l_ac].ahj07*g_ahj[l_ac].ahj08   #成本金額
                  LET g_ahj[l_ac].ahj11 = g_ahj[l_ac].ahj07*g_ahj[l_ac].ahj10   #內部金額
                  LET g_ahj[l_ac].ahj12 = l_ogb.ogb13*l_oga24/l_ogb.ogb05_fac   #銷售單價
                  LET g_ahj[l_ac].ahj13 = g_ahj[l_ac].ahj07*g_ahj[l_ac].ahj12   #銷售金額
                  LET g_ahj[l_ac].ahj14 = g_ahj[l_ac].ahj13-g_ahj[l_ac].ahj11   #內部利潤
                  DISPLAY BY NAME g_ahj[l_ac].ahj06 ,g_ahj[l_ac].ahj061,
                                  g_ahj[l_ac].ima021,g_ahj[l_ac].ima25,
                                  g_ahj[l_ac].ahj07 ,g_ahj[l_ac].ahj08,
                                  g_ahj[l_ac].ahj09 ,g_ahj[l_ac].ahj10,
                                  g_ahj[l_ac].ahj11 ,g_ahj[l_ac].ahj12,
                                  g_ahj[l_ac].ahj13 ,g_ahj[l_ac].ahj14
               END IF
            END IF
         END IF
 
      AFTER FIELD ahj06   #料號
         IF NOT cl_null(g_ahj[l_ac].ahj06) THEN
            IF g_ahj[l_ac].ahj06 != g_ahj_t.ahj06 OR g_ahj_t.ahj06 IS NULL THEN
               LET l_cnt=0
               SELECT COUNT(*) INTO l_cnt FROM ima_file 
                WHERE ima01=g_ahj[l_ac].ahj06
                  AND imaacti='Y'
               IF (SQLCA.sqlcode) OR (l_cnt=0) THEN
                  CALL cl_err3("sel","ima_file",g_ahj[l_ac].ahj06,"",100,"","",1)
                  LET g_ahj[l_ac].ahj06 =g_ahj_t.ahj06
                  LET g_ahj[l_ac].ahj061=g_ahj_t.ahj061
                  LET g_ahj[l_ac].ima021=g_ahj_t.ima021
                  LET g_ahj[l_ac].ima25 =g_ahj_t.ima25
                  DISPLAY BY NAME g_ahj[l_ac].ahj06 ,g_ahj[l_ac].ahj061,
                                  g_ahj[l_ac].ima021,g_ahj[l_ac].ima25
                  NEXT FIELD ahj06
               END IF
               CALL i141_set_ahj06(g_ahj[l_ac].ahj06) 
                    RETURNING g_ahj[l_ac].ima021,g_ahj[l_ac].ima25
               DISPLAY BY NAME g_ahj[l_ac].ima021,g_ahj[l_ac].ima25
            END IF
         ELSE
            LET g_ahj[l_ac].ahj061= NULL
            LET g_ahj[l_ac].ima021= NULL
            LET g_ahj[l_ac].ima25 = NULL
            DISPLAY BY NAME g_ahj[l_ac].ahj061,
                            g_ahj[l_ac].ima021,g_ahj[l_ac].ima25
         END IF
 
      AFTER FIELD ahj07   #數量
         IF cl_null(g_ahj[l_ac].ahj07) OR g_ahj[l_ac].ahj07<0 THEN
            CALL cl_err('','mfg3291',1)
            NEXT FIELD ahj07
         ELSE
            IF g_ahj[l_ac].ahj07 != g_ahj_t.ahj07 THEN
               LET g_ahj[l_ac].ahj09 = g_ahj[l_ac].ahj07*g_ahj[l_ac].ahj08   #成本金額
               LET g_ahj[l_ac].ahj11 = g_ahj[l_ac].ahj07*g_ahj[l_ac].ahj10   #內部金額
               LET g_ahj[l_ac].ahj13 = g_ahj[l_ac].ahj07*g_ahj[l_ac].ahj12   #銷售金額
               LET g_ahj[l_ac].ahj14 = g_ahj[l_ac].ahj13-g_ahj[l_ac].ahj11   #內部利潤
               DISPLAY BY NAME g_ahj[l_ac].ahj07,g_ahj[l_ac].ahj09,
                               g_ahj[l_ac].ahj11,g_ahj[l_ac].ahj13,
                               g_ahj[l_ac].ahj14
            END IF
         END IF
 
      AFTER FIELD ahj08   #成本單價
         IF cl_null(g_ahj[l_ac].ahj08) OR g_ahj[l_ac].ahj08<0 THEN
            CALL cl_err('','mfg3291',1)
            NEXT FIELD ahj08
         ELSE
            IF g_ahj[l_ac].ahj08 != g_ahj_t.ahj08 THEN
               LET g_ahj[l_ac].ahj09 = g_ahj[l_ac].ahj07*g_ahj[l_ac].ahj08   #成本金額
               DISPLAY BY NAME g_ahj[l_ac].ahj08,g_ahj[l_ac].ahj09
            END IF
         END IF
 
      AFTER FIELD ahj09   #成本金額
         IF cl_null(g_ahj[l_ac].ahj09) OR g_ahj[l_ac].ahj09<0 THEN
            CALL cl_err('','mfg3291',1)
            NEXT FIELD ahj09
         END IF
 
      AFTER FIELD ahj10   #內部單價
         IF cl_null(g_ahj[l_ac].ahj10) OR g_ahj[l_ac].ahj10<0 THEN
            CALL cl_err('','mfg3291',1)
            NEXT FIELD ahj10
         ELSE
            IF g_ahj[l_ac].ahj10 != g_ahj_t.ahj10 THEN
               LET g_ahj[l_ac].ahj11 = g_ahj[l_ac].ahj07*g_ahj[l_ac].ahj10   #內部金額
               LET g_ahj[l_ac].ahj14 = g_ahj[l_ac].ahj13-g_ahj[l_ac].ahj11   #內部利潤
               DISPLAY BY NAME g_ahj[l_ac].ahj10,g_ahj[l_ac].ahj11,
                               g_ahj[l_ac].ahj14
            END IF
         END IF
 
      AFTER FIELD ahj11   #內部金額
         IF cl_null(g_ahj[l_ac].ahj11) OR g_ahj[l_ac].ahj11<0 THEN
            CALL cl_err('','mfg3291',1)
            NEXT FIELD ahj11
         END IF
 
      AFTER FIELD ahj12   #銷售單價
         IF cl_null(g_ahj[l_ac].ahj12) OR g_ahj[l_ac].ahj12<0 THEN
            CALL cl_err('','mfg3291',1)
            NEXT FIELD ahj12
         ELSE
            IF g_ahj[l_ac].ahj12 != g_ahj_t.ahj12 THEN
               LET g_ahj[l_ac].ahj13 = g_ahj[l_ac].ahj07*g_ahj[l_ac].ahj12   #銷售金額
               LET g_ahj[l_ac].ahj14 = g_ahj[l_ac].ahj13-g_ahj[l_ac].ahj11   #內部利潤
               DISPLAY BY NAME g_ahj[l_ac].ahj12,g_ahj[l_ac].ahj13,
                               g_ahj[l_ac].ahj14
            END IF
         END IF
 
      AFTER FIELD ahj13   #銷售金額
         IF cl_null(g_ahj[l_ac].ahj13) OR g_ahj[l_ac].ahj13<0 THEN
            CALL cl_err('','mfg3291',1)
            NEXT FIELD ahj13
         END IF
 
      AFTER FIELD ahj14   #內部利潤
         IF cl_null(g_ahj[l_ac].ahj14) THEN
            CALL cl_err('','mfg5103',1)
            NEXT FIELD ahj14
         END IF
 
      AFTER FIELD ahj15   #分攤成本中心
         IF NOT cl_null(g_ahj[l_ac].ahj15) THEN
            IF NOT s_costcenter_chk(g_ahj[l_ac].ahj15) THEN
               LET g_ahj[l_ac].ahj15=''
               LET g_ahj[l_ac].gem02_b=''
               DISPLAY BY NAME g_ahj[l_ac].ahj15
               DISPLAY '' TO FORMONLY.gem02_b
               NEXT FIELD ahj15
            ELSE
               LET g_ahj[l_ac].gem02_b=s_costcenter_desc(g_ahj[l_ac].ahj15)
               DISPLAY g_ahj[l_ac].gem02_b TO FORMONLY.gem02_b
            END IF
         END IF
 
      AFTER FIELD ahj16   #分攤比例%
         IF cl_null(g_ahj[l_ac].ahj16) OR 
            g_ahj[l_ac].ahj16<0 OR g_ahj[l_ac].ahj16>100 THEN
            CALL cl_err('','mfg0013',1)
            NEXT FIELD ahj16
         ELSE
            LET g_ahj[l_ac].ahj17=g_ahj[l_ac].ahj14*g_ahj[l_ac].ahj16/100
            DISPLAY BY NAME g_ahj[l_ac].ahj17
         END IF
 
      AFTER FIELD ahj17   #分攤金額
         IF cl_null(g_ahj[l_ac].ahj17) OR g_ahj[l_ac].ahj17<0 THEN
            CALL cl_err('','mfg0013',1)
            NEXT FIELD ahj17
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #CKP2
            INITIALIZE g_ahj[l_ac].* TO NULL  #重要欄位空白,無效
            DISPLAY g_ahj[l_ac].* TO s_ahj.*
            CALL g_ahj.deleteElement(g_rec_b+1)
            ROLLBACK WORK
            EXIT INPUT
            #CANCEL INSERT
         END IF
         INSERT INTO ahj_file(ahj01,ahj02,ahj03,ahj19,ahj04,ahj05,ahj06,ahj061,   #FUN-A60056 add ahj19
                              ahj07,ahj08,ahj09,ahj10,ahj11,ahj12,ahj13,
                              ahj14,ahj15,ahj16,ahj17)
              VALUES(g_ahj01,g_ahj02,g_ahj03,
                     g_ahj[l_ac].ahj19,              #FUN-A60056
                     g_ahj[l_ac].ahj04 ,g_ahj[l_ac].ahj05,g_ahj[l_ac].ahj06,
                     g_ahj[l_ac].ahj061,g_ahj[l_ac].ahj07,g_ahj[l_ac].ahj08,
                     g_ahj[l_ac].ahj09 ,g_ahj[l_ac].ahj10,g_ahj[l_ac].ahj11,
                     g_ahj[l_ac].ahj12 ,g_ahj[l_ac].ahj13,g_ahj[l_ac].ahj14,
                     g_ahj[l_ac].ahj15 ,g_ahj[l_ac].ahj16,g_ahj[l_ac].ahj17)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ahj_file",g_ahj01,g_ahj02,SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_ahj_t.ahj04 IS NOT NULL OR g_ahj_t.ahj05 IS NOT NULL THEN
            IF NOT cl_null(g_ahj_t.ahj18) THEN
               CALL cl_err("", 'agl-941', 1)
               CANCEL DELETE
            END IF
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM ahj_file WHERE ahj01 = g_ahj01
                                   AND ahj02 = g_ahj02
                                   AND ahj03 = g_ahj03
                                   AND ahj04 = g_ahj_t.ahj04
                                   AND ahj05 = g_ahj_t.ahj05
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","ahj_file",g_ahj_t.ahj04,g_ahj_t.ahj05,SQLCA.sqlcode,"","",1)
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
            LET g_ahj[l_ac].* = g_ahj_t.*
            CLOSE i141_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF NOT cl_null(g_ahj[l_ac].ahj18) THEN
            CALL cl_err('','agl-941',1)   #已產生內部分錄的資料,不可修改或刪除!
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ahj[l_ac].ahj04,-263,1)
            LET g_ahj[l_ac].* = g_ahj_t.*
         ELSE
            UPDATE ahj_file SET ahj04 = g_ahj[l_ac].ahj04,
                                ahj05 = g_ahj[l_ac].ahj05,
                                ahj06 = g_ahj[l_ac].ahj06,
                                ahj061= g_ahj[l_ac].ahj061,
                                ahj07 = g_ahj[l_ac].ahj07,
                                ahj08 = g_ahj[l_ac].ahj08,
                                ahj09 = g_ahj[l_ac].ahj09,
                                ahj10 = g_ahj[l_ac].ahj10,
                                ahj11 = g_ahj[l_ac].ahj11,
                                ahj12 = g_ahj[l_ac].ahj12,
                                ahj13 = g_ahj[l_ac].ahj13,
                                ahj14 = g_ahj[l_ac].ahj14,
                                ahj15 = g_ahj[l_ac].ahj15,
                                ahj16 = g_ahj[l_ac].ahj16,
                                ahj17 = g_ahj[l_ac].ahj17,
                                ahj19 = g_ahj[l_ac].ahj19     #FUN-A60056
                          WHERE ahj01 = g_ahj01
                            AND ahj02 = g_ahj02
                            AND ahj03 = g_ahj03
                            AND ahj04 = g_ahj_t.ahj04
                            AND ahj05 = g_ahj_t.ahj05
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","ahj_file",g_ahj_t.ahj04,g_ahj_t.ahj05,SQLCA.sqlcode,"","",1)
               LET g_ahj[l_ac].* = g_ahj_t.*
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
               LET g_ahj[l_ac].* = g_ahj_t.*
            #FUN-D30032--add--begin--
            ELSE
               CALL g_ahj.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end----
            END IF
            CLOSE i141_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30032 add
         CLOSE i141_bcl
         COMMIT WORK
         #CKP2
         CALL g_ahj.deleteElement(g_rec_b+1)
 
      ON ACTION CONTROLP
         CASE
            #FUN-A60056--add--str--
            WHEN INFIELD(ahj19)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azw"
               LET g_qryparam.default1 = g_ahj[l_ac].ahj19
               LET g_qryparam.where = "azw02 = '",g_legal,"' "
               CALL cl_create_qry() RETURNING g_ahj[l_ac].ahj19
               DISPLAY g_ahj[l_ac].ahj19 TO ahj19
               NEXT FIELD ahj19
            #FUN-A60056--add--end
            WHEN INFIELD(ahj04)   #出貨單號
               CALL cl_init_qry_var()
               LET g_qryparam.form  ="q_ogb06"
               LET g_qryparam.default1 =g_ahj[l_ac].ahj04
               LET g_qryparam.default2 =g_ahj[l_ac].ahj05
               CALL cl_create_qry() RETURNING g_ahj[l_ac].ahj04,g_ahj[l_ac].ahj05
               DISPLAY BY NAME g_ahj[l_ac].ahj04,g_ahj[l_ac].ahj05
               NEXT FIELD ahj04
            WHEN INFIELD(ahj06)   #料號
               CALL cl_init_qry_var()
               LET g_qryparam.form  ="q_ima"
               LET g_qryparam.default1 =g_ahj[l_ac].ahj06
               CALL cl_create_qry() RETURNING g_ahj[l_ac].ahj06
               DISPLAY BY NAME g_ahj[l_ac].ahj06
               NEXT FIELD ahj06
            WHEN INFIELD(ahj15)   #分攤成本中心
               CALL cl_init_qry_var()
               LET g_qryparam.form  ="q_gem4" 
               LET g_qryparam.default1 =g_ahj[l_ac].ahj15
               CALL cl_create_qry() RETURNING g_ahj[l_ac].ahj15
               DISPLAY BY NAME g_ahj[l_ac].ahj15
               NEXT FIELD ahj15
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
 
   CLOSE i141_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i141_b_fill(p_wc)                     #BODY FILL UP
   DEFINE p_wc STRING  
 
   LET g_sql = "SELECT ahj19,ahj04,ahj05,ahj06,ahj061,'','',ahj07,ahj08,",   #FUN-A60056 add ahj19
               "       ahj09,ahj10,ahj11,ahj12,ahj13,ahj14,ahj15,'',",
               "       ahj16,ahj17,ahj18",
               "  FROM ahj_file ",
               " WHERE ahj01='",g_ahj01,"'",
               "   AND ahj02='",g_ahj02,"'",
               "   AND ahj03='",g_ahj03,"'",
               "   AND ",p_wc CLIPPED ,
               " ORDER BY ahj04,ahj05"
   PREPARE i141_p FROM g_sql       #預備一下
   DECLARE ahj_cs CURSOR FOR i141_p
 
   CALL g_ahj.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH ahj_cs INTO g_ahj[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL i141_set_ahj06(g_ahj[g_cnt].ahj06) 
           RETURNING g_ahj[g_cnt].ima021,g_ahj[g_cnt].ima25
      CALL i141_set_ahj15(g_ahj[g_cnt].ahj15) 
           RETURNING g_ahj[g_cnt].gem02_b
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_ahj.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i141_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ahj TO s_ahj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i141_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i141_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i141_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i141_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i141_fetch('L')
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
 
      #@ON ACTION 分攤整批產生
      ON ACTION gen_apportion
         LET g_action_choice="gen_apportion"
         EXIT DISPLAY
 
      #@ON ACTION 內部分錄產生
      ON ACTION gen_entry_sheet
         LET g_action_choice="gen_entry_sheet"
         EXIT DISPLAY
 
      #@ON ACTION 分錄底稿
      ON ACTION entry_sheet
         LET g_action_choice="entry_sheet"
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
      ON ACTION related_document                #No.FUN-6B0040  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i141_g()        #分攤整批產生 
   DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680098  SMALLLINT
   DEFINE l_sql          STRING       
   DEFINE tm             RECORD
                          wc    STRING,                #TQC-6C0097 modify   #LIKE type_file.num10
                          yy    LIKE ahj_file.ahj02,   #年度
                          mm    LIKE ahj_file.ahj03,   #期別
                          a     LIKE ahj_file.ahj15,   #分攤成本中心
                          b     LIKE type_file.chr1,   #分攤基準    #No.FUN-680098 VARCHAR(1)   
                          c     LIKE ahj_file.ahj16    #分攤比率
                         END RECORD
   DEFINE l_ogb          RECORD LIKE ogb_file.*        #出貨單單身檔
   DEFINE l_ahj          RECORD LIKE ahj_file.*        #外部銷售利潤分攤檔
   DEFINE l_oga24        LIKE oga_file.oga24           #出貨單單頭匯率
 
   LET p_row = 6 LET p_col = 6
 
   OPEN WINDOW i141_w_g AT p_row,p_col WITH FORM "agl/42f/agli141_g"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("agli141_g")
 
   INITIALIZE tm.* TO NULL
   LET tm.yy = YEAR(g_today)
   LET tm.mm = MONTH(g_today)
   LET tm.b  = '1'   #1.依成本 2.依銷售價格
   LET tm.c  = 0
 
  WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ogb930,ima131,oga14
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ogb930)   #銷售成本中心
               CALL cl_init_qry_var()
               LET g_qryparam.form  ="q_gem4"
               LET g_qryparam.state ="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO FORMONLY.ogb930
               NEXT FIELD ogb930
            WHEN INFIELD(ima131)   #產品分類
               CALL cl_init_qry_var()
               LET g_qryparam.form  ="q_oba"
               LET g_qryparam.state ="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO FORMONLY.ima131
               NEXT FIELD ima131
            WHEN INFIELD(oga14)   #業務人員
               CALL cl_init_qry_var()
               LET g_qryparam.form  ="q_gen3"
               LET g_qryparam.state ="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO FORMONLY.oga14
               NEXT FIELD oga14
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
      CLOSE WINDOW i141_w_g
      RETURN
   END IF
 
   INPUT BY NAME tm.yy,tm.mm,tm.a,tm.b,tm.c WITHOUT DEFAULTS
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
 
      AFTER FIELD a
         IF NOT cl_null(tm.a) THEN
            IF NOT s_costcenter_chk(tm.a) THEN
               CALL cl_err(tm.a,'mfg1318',0)
               NEXT FIELD a
            END IF
         END IF
 
      AFTER FIELD b
         IF cl_null(tm.b) OR tm.b NOT MATCHES '[12]' THEN
            CALL cl_err(tm.b,'-1152',0)
            NEXT FIELD b
         END IF
 
      AFTER FIELD c
         IF cl_null(tm.c) OR tm.c<0 OR tm.c>100 THEN
            CALL cl_err('','mfg0013',1)
            NEXT FIELD c
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(a)   #分攤成本中心
               CALL cl_init_qry_var()
               LET g_qryparam.form  ="q_gem4" 
               CALL cl_create_qry() RETURNING tm.a
               DISPLAY tm.a TO FORMONLY.a
               NEXT FIELD a
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
      LET INT_FLAG = 0
      CLOSE WINDOW i141_w_g
      RETURN
   END IF
 
   IF NOT cl_confirm('abx-080') THEN    #是否確定執行 (Y/N) ?
      CLOSE WINDOW i141_w_g
      RETURN
   END IF
 
   DELETE FROM ahj_file WHERE ahj02=tm.yy AND ahj03=tm.mm
   MESSAGE " Working ...."
 
   #抓取出貨單資料
   LET l_sql = "SELECT ogb_file.*",
              #"  FROM ogb_file,oga_file,ima_file",   #FUN-A60056
               "  FROM ",cl_get_target_table(g_plant,'ogb_file'),",",
               "       ",cl_get_target_table(g_plant,'oga_file'),",ima_file",   #FUN-A60056
               " WHERE oga01=ogb01",
               "   AND ogb04=ima01",
               "   AND YEAR(oga02)=",tm.yy,
               "   AND MONTH(oga02)=",tm.mm,
               "   AND ",tm.wc CLIPPED
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A60056
   PREPARE i141_g_p1 FROM l_sql
   DECLARE i141_g_curs CURSOR FOR i141_g_p1
   FOREACH i141_g_curs INTO l_ogb.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) 
         CLOSE WINDOW i141_w_g 
         RETURN
      END IF
 
      LET l_ahj.ahj01 =l_ogb.ogb930                               #銷售成本中心
      LET l_ahj.ahj02 =tm.yy                                      #年度
      LET l_ahj.ahj03 =tm.mm                                      #期別
      LET l_ahj.ahj04 =l_ogb.ogb01                                #出貨單號
      LET l_ahj.ahj05 =l_ogb.ogb03                                #項次
      LET l_ahj.ahj06 =l_ogb.ogb04                                #料號
      LET l_ahj.ahj061=l_ogb.ogb06                                #品名
      LET l_ahj.ahj07 =l_ogb.ogb12*l_ogb.ogb05_fac                #數量
      LET l_ahj.ahj19 =l_ogb.ogbplant   #FUN-A60056
      CALL i141_set_ahj08(l_ahj.ahj02,l_ahj.ahj03,l_ahj.ahj06)    #成本單價 
           RETURNING l_ahj.ahj08,l_ahj.ahj10                      #內部單價
      LET l_ahj.ahj09 = l_ahj.ahj07*l_ahj.ahj08                   #成本金額
      LET l_ahj.ahj11 = l_ahj.ahj07*l_ahj.ahj10                   #內部金額
     #FUN-A60056--mod--str--
     #SELECT oga24 INTO l_oga24 FROM oga_file WHERE oga01=l_ahj.ahj04
      LET g_sql = "SELECT oga24 FROM ",cl_get_target_table(l_ahj.ahj19,'oga_file'),
                  " WHERE oga01='",l_ahj.ahj04,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,l_ahj.ahj19) RETURNING g_sql
      PREPARE sel_oga24_pre1 FROM g_sql
      EXECUTE sel_oga24_pre1 INTO l_oga24
     #FUN-A60056--mod--end
      IF SQLCA.sqlcode THEN LET l_oga24=1 END IF                  #匯率
      LET l_ahj.ahj12 = l_ogb.ogb13*l_oga24/l_ogb.ogb05_fac       #銷售單價
      LET l_ahj.ahj13 = l_ahj.ahj07*l_ahj.ahj12                   #銷售金額
      LET l_ahj.ahj14 = l_ahj.ahj13-l_ahj.ahj11                   #內部利潤
      IF NOT cl_null(tm.a) THEN                                   #分攤成本中心
         LET l_ahj.ahj15 = tm.a
      ELSE
         #tm.a空白表示依產品分類設定
         SELECT oba10 INTO l_ahj.ahj15 FROM oba_file,ima_file
          WHERE oba01=ima131 AND ima01=l_ahj.ahj06
         IF SQLCA.sqlcode THEN LET l_ahj.ahj15 = '' END IF       
      END IF
      LET l_ahj.ahj16 = tm.c                                       #分攤比率
      LET l_ahj.ahj17 = l_ahj.ahj14*l_ahj.ahj16/100                #分攤金額 
 
      INSERT INTO ahj_file VALUES (l_ahj.* )
      IF STATUS THEN
         CALL cl_err3("ins","ahj_file",l_ahj.ahj01,l_ahj.ahj02,STATUS,"","ins_ahj:",1)
         CLOSE WINDOW i141_w_g
         RETURN
      END IF
   END FOREACH
   EXIT WHILE
  END WHILE
  MESSAGE ""
  CALL cl_end(0,0)
  CLOSE WINDOW i141_w_g
END FUNCTION
 
FUNCTION i141_v()
   DEFINE l_cnt     LIKE type_file.num5          #No.FUN-680098  SMALLINT
   DEFINE l_nppglno LIKE npp_file.nppglno
   DEFINE l_ahj     RECORD LIKE ahj_file.*
   DEFINE l_npp     RECORD LIKE npp_file.*
   DEFINE l_npq     RECORD LIKE npq_file.*
   DEFINE l_aag05   LIKE aag_file.aag05
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add
 
   LET l_npp.npp01=g_ahj02 USING '&&&&',g_ahj03 USING '&&','0001'
 
   #判斷已拋轉傳票不可再產生分錄底稿
   SELECT nppglno INTO l_nppglno FROM npp_file 
    WHERE nppsys = 'CC'        AND npp00 = 2 
      AND npp01  = l_npp.npp01 AND npp011= 1 AND npptype = '0'
   IF NOT cl_null(l_nppglno) THEN
      CALL cl_err('sel npp','axm-275',0) RETURN
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM npq_file 
    WHERE npqsys = 'CC'        AND npq00 = 2 
      AND npq01  = l_npp.npp01 AND npq011= 1 AND npqtype = '0'
   IF l_cnt > 0 THEN
      #此單據分錄底稿已存在，是否重新產生分錄底稿 ?
      IF NOT s_ask_entry(l_npp.npp01) THEN RETURN END IF
   END IF

   #FUN-B40056--add--str--
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM tic_file
    WHERE tic04 = l_npp.npp01
   IF l_cnt > 0 THEN
      IF NOT cl_confirm('sub-533') THEN
         RETURN
      END IF
   END IF
   DELETE FROM tic_file WHERE tic04 = l_npp.npp01
   #FUN-B40056--add--end-- 

   DELETE FROM npp_file 
    WHERE nppsys = 'CC'        AND npp00 = 2 
      AND npp01  = l_npp.npp01 AND npp011= 1 AND npptype = '0'
   DELETE FROM npq_file 
    WHERE npqsys = 'CC'        AND npq00 = 2 
      AND npq01  = l_npp.npp01 AND npq011= 1 AND npqtype = '0'
 
   #產生內部分錄
   LET l_npp.nppsys = 'CC'
   LET l_npp.npp00  = 2
   LET l_npp.npp011 = 1
   LET l_npp.npp02  = g_today
   LET l_npp.npp03  = NULL
   LET l_npp.npp06  = g_plant
   LET l_npp.nppglno= NULL
   LET l_npp.npptype= '0'
   LET l_npp.npplegal= g_legal #FUN-980003 add
   INSERT INTO npp_file VALUES(l_npp.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("ins","npp_file",l_npp.npp01,"",SQLCA.SQLCODE,"","ins_npp",1)
   END IF

  #No.FUN-D40118 ---Add--- Start
   IF l_npp.npptype = '1' THEN
      LET g_bookno = g_bookno2
   ELSE
      LET g_bookno = g_bookno1
   END IF
  #No.FUN-D40118 ---Add--- End
 
   #No.FUN-730070  --Begin
   CALL s_get_bookno(YEAR(l_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag =  '1' THEN  #抓不到帳別
      CALL cl_err(l_npp.npp02,'aoo-081',1)
   END IF
   #No.FUN-730070  --End  
   INITIALIZE l_ahj.* TO NULL
   LET l_npq.npq02 = 0
 
   DECLARE ahj_cs1 CURSOR FOR
      SELECT * FROM ahj_file
       WHERE ahj01=g_ahj01 AND ahj02=g_ahj02 AND ahj03=g_ahj03
   FOREACH ahj_cs1 INTO l_ahj.*
      IF STATUS THEN
         CALL cl_err('FOREACH',STATUS,1)
         EXIT FOREACH
      END IF
 
      #借方科目:利潤中心內部成本科目
      LET l_npq.npqsys = 'CC'
      LET l_npq.npq00  = 2
      LET l_npq.npq01  = l_npp.npp01
      LET l_npq.npq011 = 1
      LET l_npq.npq02  = l_npq.npq02 + 1
      LET l_npq.npq03  = g_aaz.aaz91      #利潤中心內部成本科目
      LET l_npq.npq04  = NULL #FUN-D10065 add
      #CALL cl_getmsg('agl-933',g_lang) RETURNING l_npq.npq04   #利潤分攤    #FUN-D10065  mark
      #部門 
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01 = l_npq.npq03
                                                AND aag00 = g_bookno1  #No.FUN-730070
      IF cl_null(l_aag05) THEN LET l_aag05 = NULL END IF
      IF l_aag05 = 'N' THEN
         LET l_npq.npq05=NULL
      ELSE
         LET l_npq.npq05=l_ahj.ahj01
      END IF
      LET l_npq.npq06  = '1'              #借
      CALL cl_digcut(l_ahj.ahj17,g_azi04) RETURNING l_npq.npq07f
      IF cl_null(l_npq.npq07f) THEN LET l_npq.npq07f=0 END IF
      CALL cl_digcut(l_ahj.ahj17,g_azi04) RETURNING l_npq.npq07
      IF cl_null(l_npq.npq07)  THEN LET l_npq.npq07 =0 END IF
      LET l_npq.npq08  = ' '
      LET l_npq.npq11  = ''   #MOD-9A0005
      LET l_npq.npq12  = ''   #MOD-9A0005
      LET l_npq.npq13  = ''   #MOD-9A0005
      LET l_npq.npq14  = ''   #MOD-9A0005
      LET l_npq.npq15  = ' '
      LET l_npq.npq21  = ' '
      LET l_npq.npq22  = ' '
      LET l_npq.npq23  = NULL
      LET l_npq.npq24  = g_aza.aza17    #本幣幣別
      LET l_npq.npq25  = 1
      LET l_npq.npq30  = g_plant
      LET l_npq.npqtype= '0'
      LET l_npq.npqlegal= g_legal  #FUN-980003 add
#No.FUN-9A0036 --Begin
      IF l_npp.npptype = '1' THEN
         CALL s_newrate(g_bookno1,g_bookno2,
                        l_npq.npq24,l_npq.npq25,l_npp.npp02)
         RETURNING l_npq.npq25
         LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
      END IF
#No.FUN-9A0036 --End
      #FUN-D10065--add--str--
      CALL s_def_npq3(g_bookno1,l_npq.npq03,g_prog,l_npq.npq01,'','')
      RETURNING l_npq.npq04
      IF cl_null(l_npq.npq04) THEN
         CALL cl_getmsg('agl-933',g_lang) RETURNING l_npq.npq04
      END IF
      #FUN-D10065--add--end--
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES(l_npq.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("ins","npq_file",l_npq.npq01,"",SQLCA.SQLCODE,"","ins_npq",1)
      END IF
 
      #貸方科目:利潤中心內部收入科目
      LET l_npq.npqsys = 'CC'
      LET l_npq.npq00  = 2
      LET l_npq.npq01  = l_npp.npp01
      LET l_npq.npq011 = 1
      LET l_npq.npq02  = l_npq.npq02 + 1
      LET l_npq.npq03  = g_aaz.aaz92      #利潤中心內部收入科目
      LET l_npq.npq04  = NULL #FUN-D10065 add
      #CALL cl_getmsg('agl-933',g_lang) RETURNING l_npq.npq04   #利潤分攤   #FUN-D10065  mark
      #部門 
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01 = l_npq.npq03
                                                AND aag00 = g_bookno1  #No.FUN-730070
      IF cl_null(l_aag05) THEN LET l_aag05 = NULL END IF
      IF l_aag05 = 'N' THEN
         LET l_npq.npq05=NULL
      ELSE
         LET l_npq.npq05=l_ahj.ahj15
      END IF
      LET l_npq.npq06  = '2'              #貸
      CALL cl_digcut(l_ahj.ahj17,g_azi04) RETURNING l_npq.npq07f
      IF cl_null(l_npq.npq07f) THEN LET l_npq.npq07f=0 END IF
      CALL cl_digcut(l_ahj.ahj17,g_azi04) RETURNING l_npq.npq07
      IF cl_null(l_npq.npq07)  THEN LET l_npq.npq07 =0 END IF
      LET l_npq.npq08  = ' '
      LET l_npq.npq11  = ''   #MOD-9A0005
      LET l_npq.npq12  = ''   #MOD-9A0005
      LET l_npq.npq13  = ''   #MOD-9A0005
      LET l_npq.npq14  = ''   #MOD-9A0005
      LET l_npq.npq15  = ' '
      LET l_npq.npq21  = ' '
      LET l_npq.npq22  = ' '
      LET l_npq.npq23  = NULL
      LET l_npq.npq24  = g_aza.aza17    #本幣幣別
      LET l_npq.npq25  = 1
      LET l_npq.npq30  = g_plant
      LET l_npq.npqtype= '0'
      LET l_npq.npqlegal= g_legal  #FUN-980003 add
#No.FUN-9A0036 --Begin
      IF l_npp.npptype = '1' THEN
         CALL s_newrate(g_bookno1,g_bookno2,
                        l_npq.npq24,l_npq.npq25,l_npp.npp02)
         RETURNING l_npq.npq25
         LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
      END IF
#No.FUN-9A0036 --End
      #FUN-D10065--add--str--
      CALL s_def_npq3(g_bookno1,l_npq.npq03,g_prog,l_npq.npq01,'','')
      RETURNING l_npq.npq04
      IF cl_null(l_npq.npq04) THEN
         CALL cl_getmsg('agl-933',g_lang) RETURNING l_npq.npq04
      END IF
      #FUN-D10065--add--end--
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES(l_npq.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("ins","npq_file",l_npq.npq01,"",SQLCA.SQLCODE,"","ins_npq",1)
      END IF
   END FOREACH
 
   #回寫內部分錄編號
   UPDATE ahj_file SET ahj18 = l_npp.npp01
                 WHERE ahj01 = g_ahj01
                   AND ahj02 = g_ahj02
                   AND ahj03 = g_ahj03
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","ahj_file",g_ahj01,g_ahj02,SQLCA.SQLCODE,"","upd_ahj",1)
   END IF
 
   CALL cl_getmsg('axm-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED   #分錄底稿產生完畢 !
   CALL s_flows('3','',l_npq.npq01,g_today,'N',l_npq.npqtype,TRUE)   #No.TQC-B70021   
END FUNCTION
 
FUNCTION i141_e()
 
   CALL s_fsgl('CC',2,g_ahj[l_ac].ahj18,0,'',1,'','0',g_plant)  #No.FUN-680098 
 
END FUNCTION
 
FUNCTION i141_copy()
DEFINE
   l_n                LIKE type_file.num5,          #No.FUN-680098 SMALLINT
   l_cnt              LIKE type_file.num10,         #No.FUN-680098 INTEGER  
   l_newno1,l_oldno1  LIKE ahj_file.ahj01,
   l_newno2,l_oldno2  LIKE ahj_file.ahj02,
   l_newno3,l_oldno3  LIKE ahj_file.ahj03
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_ahj01) OR cl_null(g_ahj02) OR cl_null(g_ahj03) OR 
      g_ahj02=0 OR g_ahj03=0 THEN
      CALL cl_err('',-400,1)
   END IF
 
   DISPLAY " " TO ahj01
   DISPLAY " " TO ahj02
   DISPLAY " " TO ahj03
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
   INPUT l_newno1,l_newno2,l_newno3 FROM ahj01,ahj02,ahj03
 
      AFTER FIELD ahj01
         IF NOT cl_null(l_newno1) THEN
            IF NOT s_costcenter_chk(l_newno1) THEN
               LET l_newno1=''
               DISPLAY '' TO ahj01
               NEXT FIELD ahj01
            END IF
         END IF
 
      AFTER FIELD ahj02
         IF NOT cl_null(l_newno2) THEN
            IF l_newno2 < 0 THEN 
               CALL cl_err('','mfg3291',1)
               NEXT FIELD ahj02
            END IF
         END IF
 
      AFTER FIELD ahj03
         IF NOT cl_null(l_newno3) THEN
            IF l_newno3 < 1 OR l_newno3 > 12 THEN 
               CALL cl_err('','agl-013',1)
               NEXT FIELD ahj03
            END IF
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ahj01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gem4"
               LET g_qryparam.default1 =l_newno1
               CALL cl_create_qry() RETURNING l_newno1
               DISPLAY l_newno1 TO ahj01
               NEXT FIELD ahj01
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
      LET INT_FLAG = 0
      DISPLAY g_ahj01 TO ahj01
      DISPLAY g_ahj02 TO ahj02
      DISPLAY g_ahj03 TO ahj03
      RETURN
   END IF
 
   DROP TABLE i141_x
 
   SELECT * FROM ahj_file             #單身複製
    WHERE ahj01 = g_ahj01
      AND ahj02 = g_ahj02
      AND ahj03 = g_ahj03
     INTO TEMP i141_x
   IF SQLCA.sqlcode THEN
      LET g_msg=l_newno1 CLIPPED
      CALL cl_err3("ins","i141_x",g_ahj01,g_ahj02,SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   UPDATE i141_x SET ahj01=l_newno1,
                     ahj02=l_newno2,
                     ahj03=l_newno3
 
   INSERT INTO ahj_file SELECT * FROM i141_x
   IF SQLCA.sqlcode THEN
      LET g_msg=l_newno1 CLIPPED
      CALL cl_err3("ins","ahj_file",l_newno1,l_newno2,SQLCA.sqlcode,"",g_msg,1)
      RETURN
   END IF
   LET g_msg=l_newno1 CLIPPED,'+',l_newno2 CLIPPED,'+',l_newno3 CLIPPED
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
 
   LET l_oldno1 = g_ahj01
   LET l_oldno2 = g_ahj02
   LET l_oldno3 = g_ahj03
   CALL i141_b()
   #FUN-C30027---begin
   #LET g_ahj01 = l_oldno1
   #LET g_ahj02 = l_oldno2
   #LET g_ahj03 = l_oldno3
   #CALL i141_show()
   #DISPLAY BY NAME g_ahj01,g_ahj02,g_ahj03
   #FUN-C30027---end
 
END FUNCTION
 
FUNCTION i141_set_ahj05(p_ahj04,p_ahj05,p_ahj19)   #FUN-A60056 add ahj19
   DEFINE p_ahj04  LIKE ahj_file.ahj04,
          p_ahj05  LIKE ahj_file.ahj05,
          p_ahj19  LIKE ahj_file.ahj19,     #FUN-A60056
          l_ogb    RECORD LIKE ogb_file.*,
          l_oga24  LIKE oga_file.oga24
 
  #FUN-A60056--mod-str--
  #SELECT * INTO l_ogb.*
  #  FROM ogb_file
  # WHERE ogb01=p_ahj04 AND ogb03=p_ahj05
   LET g_sql = "SELECT * FROM ",cl_get_target_table(p_ahj19,'ogb_file'),
               " WHERE ogb01='",p_ahj04,"' AND ogb03='",p_ahj05,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql 
   CALL cl_parse_qry_sql(g_sql,p_ahj19) RETURNING g_sql
   PREPARE sel_ogb_pre1 FROM g_sql
   EXECUTE sel_ogb_pre1 INTO l_ogb.*
  #FUN-A60056--mod--end
   IF SQLCA.sqlcode THEN
      INITIALIZE l_ogb.* TO NULL
   END IF
  #FUN-A60056--mod--str--
  #SELECT oga24 INTO l_oga24
  #  FROM oga_file
  # WHERE oga01=p_ahj04
   LET g_sql = "SELECT oga24 FROM ",cl_get_target_table(p_ahj19,'oga_file'),
               " WHERE oga01='",p_ahj04,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,p_ahj19) RETURNING g_sql
   PREPARE sel_oga24 FROM g_sql
   EXECUTE sel_oga24 INTO l_oga24
  #FUN-A60056--mod--end
   IF SQLCA.sqlcode THEN
      LET l_oga24=1
   END IF
   RETURN l_ogb.*,l_oga24
END FUNCTION
 
FUNCTION i141_set_ahj06(p_ahj06)
   DEFINE p_ahj06  LIKE ahj_file.ahj06,
          l_ima021 LIKE ima_file.ima021,
          l_ima25  LIKE ima_file.ima25
 
   SELECT ima021,ima25 INTO l_ima021,l_ima25 
     FROM ima_file
    WHERE ima01=p_ahj06
   IF SQLCA.sqlcode THEN
      LET l_ima021=null
      LET l_ima25=null
   END IF
   RETURN l_ima021,l_ima25
END FUNCTION
 
FUNCTION i141_set_ahj08(p_ahj02,p_ahj03,p_ahj06)
   DEFINE p_ahj02  LIKE ahj_file.ahj02,
          p_ahj03  LIKE ahj_file.ahj03, 
          p_ahj06  LIKE ahj_file.ahj06, 
          l_ahi04  LIKE ahi_file.ahi04,
          l_ahi05  LIKE ahi_file.ahi05
 
   SELECT ahi04,ahi05 INTO l_ahi04,l_ahi05
     FROM ahi_file
    WHERE ahi01=p_ahj02 AND ahi02=p_ahj03 AND ahi03=p_ahj06
   IF SQLCA.sqlcode THEN
      LET l_ahi04=0
      LET l_ahi05=0
   END IF
   RETURN l_ahi04,l_ahi05
END FUNCTION
 
FUNCTION i141_set_ahj15(p_ahj15)
   DEFINE p_ahj15  LIKE ahj_file.ahj15,
          l_gem02  LIKE gem_file.gem02
 
   SELECT gem02 INTO l_gem02
     FROM gem_file
    WHERE gem01=p_ahj15
   IF SQLCA.sqlcode THEN
      LET l_gem02=null
   END IF
   RETURN l_gem02
END FUNCTION
 
FUNCTION i141_r()
   DEFINE l_sql   STRING
   DEFINE l_cnt   LIKE type_file.num5          #No.FUN-680098 SMALLINT
 
   IF cl_null(g_ahj01) OR cl_null(g_ahj02) OR cl_null(g_ahj03) THEN #OR  #NO.FUN-6B0040
     #g_ahj02=0 OR g_ahj03=0 THEN             #No.FUN-6B0040
      CALL cl_err('',-400,1)
      RETURN                                  #No.FUN-6B0040        
   END IF
 
   LET l_sql = "SELECT COUNT(npp01)",
               "  FROM ahj_file,npp_file",
               " WHERE nppsys ='CC'",
               "   AND npp00  =2",
               "   AND npp01  =ahj18",
               "   AND npp011 =1",
               "   AND npptype='0'",
               "   AND ahj01=",g_ahj01,
               "   AND ahj02=",g_ahj02,
               "   AND ahj03=",g_ahj03 
   PREPARE i141_r_p1 FROM l_sql
   IF STATUS THEN CALL cl_err('i141_r_p1:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM 
   END IF
   DECLARE i141_r_c1 CURSOR FOR i141_r_p1
   OPEN i141_r_c1
   FETCH i141_r_c1 INTO l_cnt
   #當l_cnt>0表示已有內部分錄底稿資料,不可刪除
   IF l_cnt > 0 THEN
      CALL cl_err("", 'agl-941', 1)
      RETURN
   END IF
 
   IF NOT cl_delh(20,16) THEN RETURN END IF
   INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
   LET g_doc.column1 = "ahj01"      #No.FUN-9B0098 10/02/24
   LET g_doc.column2 = "ahj02"      #No.FUN-9B0098 10/02/24
   LET g_doc.column3 = "ahj03"      #No.FUN-9B0098 10/02/24
   LET g_doc.value1 = g_ahj01       #No.FUN-9B0098 10/02/24
   LET g_doc.value2 = g_ahj02       #No.FUN-9B0098 10/02/24
   LET g_doc.value3 = g_ahj03       #No.FUN-9B0098 10/02/24
   CALL cl_del_doc()                                                          #No.FUN-9B0098 10/02/24
   DELETE FROM ahj_file WHERE ahj01=g_ahj01
                          AND ahj02=g_ahj02
                          AND ahj03=g_ahj03
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("del","ahj_file",g_ahj01,g_ahj02,SQLCA.sqlcode,"","del ahj",1)
      RETURN      
   END IF   
 
   INITIALIZE g_ahj01,g_ahj02,g_ahj03 TO NULL
   MESSAGE ""
 
   DROP TABLE i141_cnttmp
   LET l_sql="SELECT DISTINCT ahj01,ahj02,ahj03 FROM ahj_file",
             " WHERE ", g_wc CLIPPED,
             " INTO TEMP i141_cnttmp"
   PREPARE i141_cnttmp_p1 FROM l_sql
#  EXECUTE i141_cnttmp_p1                  #No.TQC-720019
   PREPARE i141_cnttmp_p12 FROM g_sql_tmp  #No.TQC-720019
   EXECUTE i141_cnttmp_p12                 #No.TQC-720019
    
   OPEN i141_count
   #FUN-B50062-add-start--
   IF STATUS THEN
      CLOSE i141_bcs
      CLOSE i141_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50062-add-end-- 
   FETCH i141_count INTO g_row_count
   #FUN-B50062-add-start--
   IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
      CLOSE i141_bcs
      CLOSE i141_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50062-add-end-- 
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN i141_bcs
   IF g_curs_index = g_row_count + 1 THEN
      LET g_jump = g_row_count
      CALL i141_fetch('L')
   ELSE
      LET g_jump = g_curs_index
      LET mi_no_ask = TRUE    #No.FUN-6A0061
      CALL i141_fetch('/')
   END IF
END FUNCTION
 
FUNCTION i141_out()
   DEFINE sr           RECORD LIKE ahj_file.*,
          l_i          LIKE type_file.num5,                  #No.FUN-680098 SMALLINT
          l_name       LIKE type_file.chr20,                 # External(Disk) file name  #No.FUN-680098 VARCHAR(20)
          l_za05       LIKE za_file.za05                     # #No.FUN-680098 VARCHAR(40)
   #No.FUN-830095-----start--
   DEFINE l_gem02       LIKE gem_file.gem02
   DEFINE l_ima021      LIKE ima_file.ima021
   DEFINE l_ima25       LIKE ima_file.ima25
   DEFINE l_gem02_b     LIKE gem_file.gem02
   DEFINE l_str         STRING
   #No.FUN-830095--end  
   
   IF g_wc IS NULL THEN 
      IF NOT cl_null(g_ahj01) AND (g_ahj02>0) AND (g_ahj03>0) THEN
         LET g_wc=" AND ahj01=",g_ahj01,
                  " AND ahj02=",g_ahj02,
                  " AND ahj03=",g_ahj03
      ELSE
         CALL cl_err('',-400,0)
         RETURN 
      END IF
   END IF
   CALL cl_wait()
   
   CALL cl_del_data(l_table)         #No.FUN-830095
   
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='agli141'     #No.FUN-830095   
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   LET g_sql="SELECT * FROM ahj_file ",          # 組合出 SQL 指令
             " WHERE 1=1 AND ",g_wc CLIPPED,
             " ORDER BY ahj01,ahj02,ahj03,ahj04,ahj05"
   PREPARE i141_p1 FROM g_sql                # RUNTIME 編譯
   DECLARE i141_c1 CURSOR FOR i141_p1        # SCROLL CURSOR
 
#   CALL cl_outnam('agli141') RETURNING l_name   #No.FUN-830095
#   START REPORT i141_rep TO l_name              #No.FUN-830095
 
   FOREACH i141_c1 INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)    
         EXIT FOREACH
      END IF
   #No.FUN-830095----------------start--
      CALL s_costcenter_desc(sr.ahj01) RETURNING l_gem02
      CALL i141_set_ahj06(sr.ahj06) RETURNING l_ima021,l_ima25
      CALL i141_set_ahj15(sr.ahj15) RETURNING l_gem02_b      
      EXECUTE insert_prep USING 
           sr.ahj01,l_gem02,sr.ahj02,sr.ahj03,sr.ahj04,sr.ahj05,sr.ahj06,
           sr.ahj061,l_ima021,l_ima25,sr.ahj07,sr.ahj08,sr.ahj09,sr.ahj10,
           sr.ahj11,sr.ahj12,sr.ahj13,sr.ahj14,sr.ahj15,l_gem02_b,sr.ahj16,
           sr.ahj17,sr.ahj18,g_azi03,g_azi04        
   #No.FUN-830095----------------end       
      #OUTPUT TO REPORT i141_rep(sr.*)      #No.FUN-830095
   END FOREACH
   
   #No.FUN-830095---------------start----
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   
   IF g_zz05='Y'  THEN 
      CALL cl_wcchp(g_wc,'ogb930,ima131,oga14,ahj01,ahj02,ahj03,                                                                                            
                          ahj04,ahj05,ahj06,ahj061,ahj07,ahj08,ahj09,ahj10,                                                             
                          ahj11,ahj12,ahj13,ahj14,ahj15,ahj16,ahj17,ahj18 ')
           RETURNING l_str
   ELSE
      LET l_str = "" 	  
   END IF
  
   LET g_str = l_str,";",g_azi03,";",g_azi04
   	  
   CALL cl_prt_cs3('agli141','agli141',l_sql,g_str)
   #No.FUN-830095---------------end
   #FINISH REPORT i141_rep  #No.FUN-830095
 
   CLOSE i141_c1
   ERROR ""
   #CALL cl_prt(l_name,' ','1',g_len)  #No.FUN-830095
END FUNCTION
 
##No.FUN-830095---------start--
#REPORT i141_rep(sr)
#   DEFINE l_trailer_sw  LIKE type_file.chr1,       #No.FUN-680098   VARCHAR(1)
#          sr            RECORD LIKE ahj_file.*,
#          l_gem02       LIKE gem_file.gem02,
#          l_ima021      LIKE ima_file.ima021,
#          l_ima25       LIKE ima_file.ima25,
#          l_gem02_b     LIKE gem_file.gem02
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#   ORDER EXTERNAL BY sr.ahj01,sr.ahj02,sr.ahj03,sr.ahj04,sr.ahj05
#
#   FORMAT
#     PAGE HEADER
#       PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#       PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#       LET g_pageno=g_pageno+1
#       LET pageno_total=PAGENO USING '<<<',"/pageno"
#       PRINT g_head CLIPPED,pageno_total
#       PRINT g_dash[1,g_len]
#       PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#             g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#             g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],
#             g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],
#             g_x[51],g_x[52],g_x[53]
#       PRINT g_dash1
#       LET l_trailer_sw = 'y'
#
#     BEFORE GROUP OF sr.ahj03
#       CALL s_costcenter_desc(sr.ahj01) RETURNING l_gem02
#       PRINT COLUMN g_c[31],sr.ahj01 CLIPPED,                #銷售成本中心
#             COLUMN g_c[32],l_gem02 CLIPPED,                 #名稱
#             COLUMN g_c[33],sr.ahj02 USING "####",           #年度
#             COLUMN g_c[34],sr.ahj03 USING "####";           #期別
#
#     ON EVERY ROW
#       CALL i141_set_ahj06(sr.ahj06) RETURNING l_ima021,l_ima25
#       CALL i141_set_ahj15(sr.ahj15) RETURNING l_gem02_b
#       PRINT COLUMN g_c[35],sr.ahj04 CLIPPED,                #出貨單號
#             COLUMN g_c[36],sr.ahj05 CLIPPED,                #項次
#             COLUMN g_c[37],sr.ahj06 CLIPPED,                #料號
#             COLUMN g_c[38],sr.ahj061 CLIPPED,               #品名
#             COLUMN g_c[39],l_ima021 CLIPPED,                #規格
#             COLUMN g_c[40],l_ima25 CLIPPED,                 #單位
#             COLUMN g_c[41],cl_numfor(sr.ahj07,41,0),        #數量
#             COLUMN g_c[42],cl_numfor(sr.ahj08,42,g_azi03),  #成本單價
#             COLUMN g_c[43],cl_numfor(sr.ahj09,43,g_azi04),  #成本金額
#             COLUMN g_c[44],cl_numfor(sr.ahj10,44,g_azi03),  #內部單價
#             COLUMN g_c[45],cl_numfor(sr.ahj11,45,g_azi04),  #內部金額
#             COLUMN g_c[46],cl_numfor(sr.ahj12,46,g_azi03),  #銷售單價
#             COLUMN g_c[47],cl_numfor(sr.ahj13,47,g_azi04),  #銷售金額
#             COLUMN g_c[48],cl_numfor(sr.ahj14,48,g_azi04),  #內部利潤
#             COLUMN g_c[49],sr.ahj15 CLIPPED,                #分攤成本中心
#             COLUMN g_c[50],l_gem02_b CLIPPED,               #部門名稱
#             COLUMN g_c[51],cl_numfor(sr.ahj16,51,3),        #分攤比率
#             COLUMN g_c[52],cl_numfor(sr.ahj17,52,g_azi04),  #分攤金額
#             COLUMN g_c[53],sr.ahj18 CLIPPED                 #分錄單號
#
#     ON LAST ROW
#       PRINT g_dash[1,g_len]
#       PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#       LET l_trailer_sw = 'n'
#
#     PAGE TRAILER
#       IF l_trailer_sw = 'y' THEN
#          PRINT g_dash[1,g_len]
#          PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#       ELSE
#          SKIP 2 LINE
#       END IF
#END REPORT
#No.FUN-830095--end 
#FUN-A60056--add--str--
FUNCTION i141_ahj19()
   LET g_errno = ''
              
   SELECT * FROM azp_file,azw_file
    WHERE azp01 = azw01
      AND azp01 = g_ahj[l_ac].ahj19
      AND azw02 = g_legal
           
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'agl-171'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
                
END FUNCTION 
#FUN-A60056--add--end
