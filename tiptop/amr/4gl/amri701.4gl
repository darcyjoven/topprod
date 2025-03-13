# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: amri701.4gl
# Descriptions...: MRP限定版本維護作業
# Date & Author..: 01/08/23 By Mandy
# Modify.........: No.MOD-490371 04/09/22 By Kitty Controlp 未加display,l_sl拿掉
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.FUN-4B0013 04/11/08 By ching add '轉Excel檔' action
# Modify.........: No.FUN-550055 05/05/25 By Will 單據編號放大
# Modify.........: No.MOD-5A0004 05/10/07 By Rosayu 刪除資料後筆數不正確
# Modify.........: No.FUN-5C0047 05/12/14 By Pengu 判斷單別是否存在時位判斷是否存在oay_file中
# Modify.........: No.TQC-630106 06/03/10 By Claire DISPLAY ARRAY無控制單身筆數
# Modify.........: No.FUN-660107 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
# Modify.........: No.FUN-680064 06/10/18 By dxfwo 在新增函數_a()中的單身函數_b()前添加                                             
#                                                           g_rec_b初始化命令                                                       
#                                                          "LET g_rec_b =0"
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/13 By bnlent  單頭折疊功能修改
# Modify.........: No.FUN-6B0041 06/11/16 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-720019 07/03/01 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-750041 07/05/17 By mike 報表格式修改
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-890024 08/09/04 BY DUKE TIPTOP與APS串聯時,增加一欄位條件選擇正反向 msp10
# Modify.........: No.FUN-8A0026 08/10/06 BY DUKE 與APS串聯時,限定版本選擇需可更改
# Modify.........: No.TQC-8C0057 08/12/22 By Mandy amri701 修改限定選擇條件時,並無更新--因為fetch()段漏fetch msp10
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0125 09/12/21 By Mandy 限定條件選擇開放,不需要判斷是否與APS整合
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:CHI-C10017 12/01/12 By bart 單別加入oay_file
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_msp01         LIKE msp_file.msp01,   #單號
    g_msp01_t       LIKE msp_file.msp01,   #員工編號(舊值)
    g_msp10         LIKE msp_file.msp10,   #FUN-890024 add
    g_msp10_t       LIKE msp_file.msp10,   #FUN-890024 add
    g_msp           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        msp02       LIKE msp_file.msp02,   #項次
        msp03       LIKE msp_file.msp03,   #倉庫別
        imd02       LIKE imd_file.imd02,   #倉庫名稱
        msp04       LIKE msp_file.msp04,   #單據別
        smydesc     LIKE smy_file.smydesc, #單據名稱
        msp05       LIKE msp_file.msp05    #指送地址
                    END RECORD,
    g_msp_t         RECORD                 #程式變數 (舊值)
        msp02       LIKE msp_file.msp02,   #項次
        msp03       LIKE msp_file.msp03,   #倉庫別
        imd02       LIKE imd_file.imd02,   #倉庫名稱
        msp04       LIKE msp_file.msp04,   #單據別
        smydesc     LIKE smy_file.smydesc, #單據名稱
        msp05       LIKE msp_file.msp05    #指送地址
                    END RECORD,
    g_wc,g_sql,g_wc2    STRING,  #No.FUN-580092 HCN     
    g_argv1             LIKE msp_file.msp01,    #員工代號
  # g_argv2             VARCHAR(10),               #單號
    g_argv2             LIKE type_file.chr20,   #No.FUN-680082 VARCHAR(10)
  # g_argv3             SMALLINT,               #項次
    g_argv3             LIKE type_file.num5,    #No.FUN-680082 SMALLINT
  # g_show              VARCHAR(1),
    g_show              LIKE type_file.chr1,    #No.FUN-680082 VARCHAR(1)
  # g_t1                VARCHAR(03),
    g_t1                LIKE msp_file.msp04,    #NO.Fun-550055 #No.FUN-680082 VARCHAR(05)
    g_rec_b             LIKE type_file.num5,    #單身筆數      #No.FUN-680082 SMALLINT
    g_flag              LIKE type_file.chr1,    #No.FUN-680082 VARCHAR(1)
  # g_ss                VARCHAR(1),
    g_ss                LIKE type_file.chr1,    #No.FUN-680082 VARCHAR(1)                 
    l_ac                LIKE type_file.num5     #目前處理的ARRAY CNT  #No.FUN-680082  SMALLINT
 
#主程式開始
DEFINE g_forupd_sql         STRING                 #SELECT ... FOR UPDATE SQL 
DEFINE g_sql_tmp            STRING                 #No.TQC-720019
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-680082 SMALLINT
DEFINE g_cnt                LIKE type_file.num10   #No.FUN-680082 INTEGER
DEFINE g_msg                LIKE type_file.chr1000 #No.FUN-680082 VARCHAR(72)
DEFINE g_row_count          LIKE type_file.num10   #No.FUN-680082 INTEGER
DEFINE g_curs_index         LIKE type_file.num10   #No.FUN-680082 INTEGER
DEFINE g_jump               LIKE type_file.num10   #No.FUN-680082 INTEGER
DEFINE mi_no_ask            LIKE type_file.num5    #No.FUN-680082 SMALLINT
 
MAIN
DEFINE
#       l_time    LIKE type_file.chr8            #No.FUN-6A0076
    p_row,p_col   LIKE type_file.num5      #No.FUN-680082 SMALLINT 
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMR")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
         RETURNING g_time    #No.FUN-6A0076
    LET g_argv1 = ARG_VAL(1)
    LET p_row = 2 LET p_col = 20
    OPEN WINDOW i701_w AT p_row,p_col
        WITH FORM "amr/42f/amri701"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    IF NOT cl_null(g_argv1) THEN
       CALL i701_q()
    END IF
    CALL i701_menu()
 
    CLOSE WINDOW i701_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)  #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
         RETURNING g_time    #No.FUN-6A0076
END MAIN
 
#QBE 查詢資料
FUNCTION i701_cs()
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = " msp01 = '",g_argv1,"'"
    ELSE
      CLEAR FORM                             #清除畫面
   CALL g_msp.clear()
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_msp01 TO NULL    #No.FUN-750051
   LET g_msp10 = 0               #NO.FUN-890024
      CONSTRUCT g_wc ON msp01,msp10,msp02,msp03,msp04,msp05
          FROM msp01,msp10,s_msp[1].msp02,s_msp[1].msp03,s_msp[1].msp04,s_msp[1].msp05
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
            CASE
                WHEN INFIELD(msp03)        # 倉庫別
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     ="q_imd"
                   LET g_qryparam.state    = "c"
                  #LET g_qryparam.arg1     = "A"
                    LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO msp03
                   NEXT FIELD msp03
 
                WHEN INFIELD(msp04)
#                     LET g_t1=g_msp[1].msp04[1,3]
                     LET g_t1=s_get_doc_no(g_msp[1].msp04[1,3])   #NO.Fun-550055
                     LET g_qryparam.state = "c"
                     CALL q_smy3(TRUE,TRUE,g_t1,'*','*') RETURNING g_qryparam.multiret  #No:CHI-C10017
                     DISPLAY g_qryparam.multiret TO msp04
                     NEXT FIELD msp04
 
{
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_smy"
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.arg1     = "*"
                   LET g_qryparam.arg2     = "*"
                   IF g_qryparam.arg1 != '*' THEN
                      LET g_qryparam.where =g_qryparam.where CLIPPED,
                                           " AND smysys='",g_qryparam.arg1,"'"
                   END IF
                   IF g_qryparam.arg2 != '*' THEN
                      LET g_qryparam.where =g_qryparam.where CLIPPED,
                                           " AND smykind='",g_qryparam.arg2,"'"
                   END IF
                   LET g_qryparam.where = g_qryparam.where CLIPPED,
                                          " ORDER BY 2 "
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO msp04
                   NEXT FIELD msp04
}
                WHEN INFIELD(msp05) #Addr
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_pme"
                   LET g_qryparam.state    = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO msp05
                   NEXT FIELD msp05
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
    END IF
    #FUN-890024 add msp10
    LET g_sql= "SELECT UNIQUE msp01,msp10 FROM msp_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY 1"
    PREPARE i701_prepare FROM g_sql      #預備一下
    DECLARE i701_bcs                     #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i701_prepare
 
#   LET g_sql = "SELECT UNIQUE msp01 FROM msp_file ",      #No.TQC-720019
    #FUN-890024 add msp10
    LET g_sql_tmp = "SELECT UNIQUE msp01,msp10 FROM msp_file ",  #No.TQC-720019
                " WHERE ", g_wc CLIPPED,
                " INTO TEMP x "
    DROP TABLE x
#   PREPARE i701_precount_x FROM g_sql      #No.TQC-720019
    PREPARE i701_precount_x FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i701_precount_x
 
        LET g_sql="SELECT COUNT(*) FROM x "
    PREPARE i701_precount FROM g_sql
    DECLARE i701_count CURSOR FOR i701_precount
 
END FUNCTION
 
FUNCTION i701_menu()
 
   WHILE TRUE
     #FUN-9C0125-mark---str---
     #限定條件選擇開放,不需要判斷是否與APS整合
     ##FUN-890024
     #IF cl_null(g_sma.sma901) OR g_sma.sma901='N' THEN
     #   CALL cl_set_comp_visible("msp10",FALSE)
     #ELSE
     #   CALL cl_set_comp_visible("msp10",TRUE)
     #END IF
     #FUN-9C0125-mark---end---
      CALL i701_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i701_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i701_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i701_r()
            END IF
         #FUN-8A0026  add
         WHEN "modify"
           #IF cl_chk_act_auth() AND                                   #FUN-9C0125 mark
           #   (NOT cl_null(g_sma.sma901) and g_sma.sma901 = 'Y') THEN #FUN-9C0125 mark
            IF cl_chk_act_auth() THEN                                  #FUN-9C0125 add
               CALL i701_u()
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i701_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i701_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0013
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_msp),'','')
             END IF
         #--
         #No.FUN-6B0041-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_msp01 IS NOT NULL THEN
                 LET g_doc.column1 = "msp01"
                 LET g_doc.value1 = g_msp01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6B0041-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#FUN-8A0026 add
FUNCTION i701_u()
  IF s_shut(0) THEN RETURN END IF
  #若非由MENU進入本程式,則無更新之功能
  IF g_msp01 IS NULL THEN
     CALL cl_err('',-400,0)
     RETURN
  END IF
  MESSAGE ""
  CALL cl_opmsg('u')
  LET g_msp01_t = g_msp01
  LET g_msp10_t = g_msp10
  BEGIN WORK
    CALL i701_show()
    WHILE TRUE
       CALL i701_i("u")                      # 欄位更改
       IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_msp01 = g_msp01_t
           LET g_msp10 = g_msp10_t
           CALL i701_show()
           CALL cl_err('',9001,0)
           EXIT WHILE
       END IF
       UPDATE msp_file SET msp10 = g_msp10    # 更新DB
           WHERE msp01 = g_msp01             # COLAUTH?
       IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","msp_file",g_msp01,"",SQLCA.sqlcode,"","",1)
           CONTINUE WHILE
       END IF
 
       EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
 
FUNCTION i701_a()
    MESSAGE ""
    CLEAR FORM
    CALL g_msp.clear()
    INITIALIZE g_msp01 LIKE msp_file.msp01
    LET g_msp01_t  = NULL
    LET g_msp10 = 0   #FUN-890024 add
    LET g_msp10_t =0  #FUN-890024 add
    LET g_rec_b =0                         #NO.FUN-680064
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i701_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET g_msp01=NULL
            LET g_msp10 = 0  #FUN-890024 add
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_ss='N' THEN
            CALL g_msp.clear()
        ELSE
            CALL i701_bf('1=1')            #單身
        END IF
        CALL i701_b()                      #輸入單身
        LET g_msp01_t = g_msp01
        LET g_msp10_t = g_msp10            #FUN-890024
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i701_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #a:輸入 u:更改 #No.FUN-680082 VARCHAR(1)
    l_n             LIKE type_file.num5,    #No.FUN-680082 SMALLINT
  # l_str           VARCHAR(40)
    l_str           LIKE type_file.chr1000,  #No.FUN-680082 VARCHAR(40)
    l_rec           LIKE type_file.num5
 
    LET g_ss='Y'
    #FUN-8A0026---str
    IF p_cmd='u' THEN
       CALL cl_set_comp_entry("msp01",FALSE)
    END IF
    IF p_cmd='a' THEN
       CALL cl_set_comp_entry("msp01",TRUE)
    END IF
    #FUN-8A0026 ---END
    DISPLAY g_msp01 TO msp01
    DISPLAY g_msp10 TO msp10   #FUN-890024
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT g_msp01,g_msp10 WITHOUT DEFAULTS FROM msp01,msp10   #FUN-890024 add msp10

        #FUN-8A0026
        AFTER FIELD msp01
          IF p_cmd='a' THEN
             LET l_rec = 0
             SELECT COUNT(*) INTO l_rec FROM msp_file WHERE  msp01 = g_msp01
             IF NOT cl_null(l_rec) AND l_rec > 0   THEN
                CALL cl_err('','aec-010',0)
                NEXT FIELD msp01
             END IF
          END IF
 
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
    CALL cl_set_comp_entry("msp01",TRUE) #FUN-9C0125 add
END FUNCTION
 
#Query 查詢
FUNCTION i701_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_msp01 TO NULL          #No.FUN-6B0041
    LET g_msp10 = 0                     #NO.FUN-890024
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_msp.clear()
    DISPLAY '    ' TO FORMONLY.cnt
    CALL i701_cs()                      #取得查詢條件
    IF INT_FLAG THEN                    #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_msp01 TO NULL
        LET g_msp10 = 0                 #FUN-890024 add
        RETURN
    END IF
    OPEN i701_bcs                       #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN               #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_msp01 TO NULL
        LET g_msp10 = 0  #FUN-890024
    ELSE
        OPEN i701_count
        FETCH i701_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i701_fetch('F')            #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i701_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式    #No.FUN-680082 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數  #No.FUN-680082 INTEGER 
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i701_bcs INTO g_msp01,g_msp10 #TQC-8C0057 add msp10
        WHEN 'P' FETCH PREVIOUS i701_bcs INTO g_msp01,g_msp10 #TQC-8C0057 add msp10
        WHEN 'F' FETCH FIRST    i701_bcs INTO g_msp01,g_msp10 #TQC-8C0057 add msp10
        WHEN 'L' FETCH LAST     i701_bcs INTO g_msp01,g_msp10 #TQC-8C0057 add msp10
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
               END PROMPT
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
           END IF
           FETCH ABSOLUTE g_jump i701_bcs INTO g_msp01,g_msp10 #TQC-8C0057 add msp10
           LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                  #有麻煩
        CALL cl_err(g_msp01,SQLCA.sqlcode,0)
        INITIALIZE g_msp01 TO NULL  #TQC-6B0105
        INITIALIZE g_msp10 TO NULL  #TQC-8C0057 add
    ELSE
       #CALL i701_show() #TQC-8C0057 mark
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    #TQC-8C0057--add----str---
    SELECT UNIQUE msp01,msp10 INTO g_msp01,g_msp10 FROM msp_file    # 重讀DB,因TEMP有不被更新特性
       WHERE msp01 = g_msp01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","msp_file",g_msp01,g_msp10,SQLCA.sqlcode,"","",0)  
    ELSE
        CALL i701_show()                   # 重新顯示
    END IF
    #TQC-8C0057--add----end---
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i701_show()
 
    DISPLAY g_msp01 TO msp01
    DISPLAY g_msp10 TO msp10                #FUN-890024 add
    CALL i701_bf(g_wc)                      #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i701_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  #No.FUN-680082 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用         #No.FUN-680082 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否         #No.FUN-680082 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態           #No.FUN-680082 VARCHAR(1)
    l_cnt           LIKE type_file.num5,    #No.FUN-680082 SMALLINT
    l_cnt1          LIKE type_file.num5,    #No.TQC-750041 SMALLINT
    l_imd02         LIKE imd_file.imd02,
    l_smydesc       LIKE smy_file.smydesc,
    l_i             LIKE type_file.num5,    #No.FUN-680082 SMALLINT
  # l_sw            VARCHAR(1),
    l_sw            LIKE type_file.chr1,    #No.FUN-680082 VARCHAR(1) 
    l_allow_insert  LIKE type_file.num5,    #可新增否           #No.FUN-680082 SMALLINT
    l_allow_delete  LIKE type_file.num5     #可刪除否           #No.FUN-680082 SMALLINT
 
    LET g_action_choice = ""
    IF g_msp01 IS NULL OR g_msp01 = ' ' THEN
        RETURN
    END IF
    IF s_shut(0) THEN RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT msp02,msp03,'',msp04,'',msp05 ",
                       "   FROM msp_file ",
                       "  WHERE msp01 = ? ",
                       "    AND msp02 = ? ",
                       "    FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i701_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_msp WITHOUT DEFAULTS FROM s_msp.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            BEGIN WORK
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
            #IF g_msp_t.msp02 IS NOT NULL THEN
                LET p_cmd='u'
                LET g_msp_t.* = g_msp[l_ac].*  #BACKUP
                OPEN i701_bcl USING g_msp01,g_msp_t.msp02
                IF STATUS THEN
                   CALL cl_err("OPEN i701_bcl:", STATUS, 1)
                   CLOSE i701_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH i701_bcl INTO g_msp[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_msp_t.msp02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   ELSE
                       LET g_msp_t.*=g_msp[l_ac].*
                   END IF
                   SELECT smydesc INTO l_smydesc FROM smy_file
                    WHERE smyslip=g_msp[l_ac].msp04
                   IF STATUS THEN
                   #-------No.FUN-5C0047 add
                      SELECT oaydesc INTO l_smydesc FROM oay_file
                          WHERE oayslip=g_msp[l_ac].msp04
                       IF STATUS THEN
                          LET g_msp[l_ac].smydesc=g_msp_t.smydesc
                       ELSE
                          LET g_msp[l_ac].smydesc=l_smydesc
                       END IF
                   #    LET g_msp[l_ac].smydesc=g_msp_t.smydesc
                   #------No.FUN-5C0047 end
                   ELSE
                       LET g_msp[l_ac].smydesc=l_smydesc
                   END IF
 
                   SELECT imd02 INTO l_imd02 FROM imd_file
                    WHERE imd01=g_msp[l_ac].msp03
                   IF STATUS THEN
                       LET g_msp[l_ac].imd02=g_msp_t.imd02
                   ELSE
                       LET g_msp[l_ac].imd02=l_imd02
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
#              CALL g_msp.deleteElement(l_ac)   #取消 Array Element
#              IF g_rec_b != 0 THEN   #單身有資料時取消新增而不離開輸入
#                 LET g_action_choice = "detail"
#                 LET l_ac = l_ac_t
#              END IF
#              EXIT INPUT
            END IF
           {
            IF g_msp_t.msp02 IS NULL OR
               g_msp[l_ac].msp02 != g_msp_t.msp02  OR
               g_msp[l_ac].msp03 != g_msp_t.msp03  OR
               g_msp[l_ac].msp04 != g_msp_t.msp04  OR
               g_msp[l_ac].msp05 != g_msp_t.msp05 THEN
               SELECT COUNT(*) INTO l_cnt FROM msp_file
                WHERE msp01=g_msp01 AND msp03=g_msp[l_ac].msp03
                  AND msp04=g_msp[l_ac].msp04 AND msp05=g_msp[l_ac].msp05
               IF l_cnt >0 THEN
                  CALL cl_err('','-239',0)
                  INITIALIZE g_msp[l_ac].* TO NULL
               END IF
            END IF
            }
            #FUN-890024  add msp10  
            INSERT INTO msp_file(msp01,msp02,msp03,msp04,msp05,msp10)
                          VALUES(g_msp01,g_msp[l_ac].msp02,g_msp[l_ac].msp03,
                                 g_msp[l_ac].msp04,g_msp[l_ac].msp05,g_msp10)
            IF SQLCA.sqlcode THEN
#                CALL cl_err(g_msp[l_ac].msp02,SQLCA.sqlcode,0) #No.FUN-660107
                 CALL cl_err3("ins","msp_file",g_msp01,g_msp[l_ac].msp02,SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_msp[l_ac].* TO NULL            #900423
            LET g_msp_t.* = g_msp[l_ac].*               #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD msp02
 
        BEFORE FIELD msp02                        # dgeeault 序號
             IF g_msp[l_ac].msp02 IS  NULL OR g_msp[l_ac].msp02 = 0 THEN
                SELECT max(msp02)+1 INTO g_msp[l_ac].msp02 FROM msp_file
                    WHERE msp01 = g_msp01
                IF g_msp[l_ac].msp02 IS NULL THEN
                    LET g_msp[l_ac].msp02 = 1
                END IF
            END IF
        AFTER FIELD msp02                          # check 序號是否重複
            IF g_msp[l_ac].msp02 IS NOT NULL AND
                (g_msp[l_ac].msp02 != g_msp_t.msp02 OR
                 g_msp_t.msp02 IS NULL) THEN
                 SELECT COUNT(*) INTO l_n FROM msp_file
                  WHERE msp01 = g_msp01
                    AND msp02 = g_msp[l_ac].msp02
                 IF l_n > 0 THEN
                     CALL cl_err(g_msp[l_ac].msp02,-239,0)
                     LET g_msp[l_ac].msp02 = g_msp_t.msp02 #BugNo:6468
                     NEXT FIELD msp02
                 END IF
            END IF
 
        AFTER FIELD msp03
            IF NOT cl_null(g_msp[l_ac].msp03) THEN
                LET l_sw='N'
                FOR l_i = 1 TO LENGTH(g_msp[l_ac].msp03)
                   IF g_msp[l_ac].msp03[l_i,l_i]='*' THEN
                     LET l_sw='Y'
                   END IF
                END FOR
                IF l_sw='N' THEN
                  CALL i701_msp03('a',g_msp[l_ac].msp03)
                       RETURNING g_msp[l_ac].imd02
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_msp[l_ac].msp03,g_errno,0)
                     NEXT FIELD msp03    #No.TQC-750041  
                  END IF
                  DISPLAY g_msp[l_ac].imd02 TO imd02
                END IF
            END IF
 
        AFTER FIELD msp04
            IF NOT cl_null(g_msp[l_ac].msp04) THEN
               IF g_msp_t.msp04 IS NULL OR
                  (g_msp_t.msp04 != g_msp[l_ac].msp04) THEN
                  CALL i701_msp04('a',g_msp[l_ac].msp04)
                       RETURNING g_msp[l_ac].smydesc
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_msp[l_ac].msp04,g_errno,0)
                     NEXT FIELD msp04    #No.TQC-750041 
                  END IF
                  DISPLAY g_msp[l_ac].smydesc TO smydesc
               END IF
            END IF
 
        #No.TQC-750041  --BEGIN--
        AFTER FIELD msp05                                                                                                           
            IF NOT cl_null(g_msp[l_ac].msp05) THEN                                                                                  
               IF g_msp_t.msp05 IS NULL OR                                                                                          
                  (g_msp_t.msp05 != g_msp[l_ac].msp05) THEN                                                                         
                #  CALL i701_msp04('a',g_msp[l_ac].msp04)                                                                            
                 #      RETURNING g_msp[l_ac].smydesc
                  SELECT count(*)  INTO l_cnt1 FROM pme_file
                   WHERE pme01=g_msp[l_ac].msp05
                  IF l_cnt1=0 THEN
                     CALL cl_err(g_msp[l_ac].msp05,g_errno,0)
                     LET g_msp[l_ac].msp05=g_msp_t.msp05                                                                       
                     NEXT FIELD msp05                                                                                 
                  END IF                                                                                                            
                #  DISPLAY g_msp[l_ac].smydesc TO smydesc                                                                            
               END IF                                                                                                               
            END IF 
        #No.TQC-750041  --END--           
        BEFORE DELETE                            #是否取消單身
            IF g_msp_t.msp02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM msp_file
                    WHERE msp01 = g_msp01
                     AND  msp02 = g_msp_t.msp02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_msp_t.msp02,SQLCA.sqlcode,0) #No.FUN-660107
                    CALL cl_err3("del","msp_file",g_msp01,g_msp_t.msp02,SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
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
               LET g_msp[l_ac].* = g_msp_t.*
               CLOSE i701_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_msp[l_ac].msp02,-263,1)
               LET g_msp[l_ac].* = g_msp_t.*
            ELSE
              {
               IF g_msp_t.msp02 IS NULL OR
                  g_msp[l_ac].msp02 != g_msp_t.msp02  OR
                  g_msp[l_ac].msp03 != g_msp_t.msp03  OR
                  g_msp[l_ac].msp04 != g_msp_t.msp04  OR
                  g_msp[l_ac].msp05 != g_msp_t.msp05 THEN
                   SELECT COUNT(*) INTO l_cnt FROM msp_file
                    WHERE msp01=g_msp01 AND msp03=g_msp[l_ac].msp03
                      AND msp04=g_msp[l_ac].msp04 AND msp05=g_msp[l_ac].msp05
                  IF l_cnt >0 THEN
                     CALL cl_err('','-239',0)
                     INITIALIZE g_msp[l_ac].* TO NULL
                  END IF
               END IF
              }
               UPDATE msp_file SET
                      msp02=g_msp[l_ac].msp02,
                      msp03=g_msp[l_ac].msp03,
                      msp04=g_msp[l_ac].msp04,
                      msp05=g_msp[l_ac].msp05
                WHERE msp01 = g_msp01
                  AND msp02 = g_msp_t.msp02
               IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_msp[l_ac].msp02,SQLCA.sqlcode,0) #No.FUN-660107
                    CALL cl_err3("upd","msp_file",g_msp01,g_msp_t.msp02,SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
                   LET g_msp[l_ac].* = g_msp_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_msp[l_ac].* = g_msp_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_msp.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i701_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D40030 Add
            CLOSE i701_bcl
            COMMIT WORK
 
        ON ACTION controlp
            CASE
                WHEN INFIELD(msp03)        # 倉庫別
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_imd"
                   LET g_qryparam.default1 = g_msp[l_ac].msp03
                   #LET g_qryparam.arg1     = "A"  #MOD-4A0213
                    LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                   CALL cl_create_qry() RETURNING g_msp[l_ac].msp03
                  # CALL FGL_DIALOG_SETBUFFER( g_msp[l_ac].msp03 )
                   DISPLAY g_msp[l_ac].msp03 TO msp03
                   NEXT FIELD msp03
 
                WHEN INFIELD(msp04)
#                   LET g_t1=g_msp[l_ac].msp04[1,3]
                   LET g_t1=s_get_doc_no(g_msp[l_ac].msp04[1,3])   #NO.Fun-550055
                   CALL q_smy3(FALSE,FALSE,g_t1,'*','*') RETURNING g_t1   #No:CHI-C10017
                   LET g_msp[l_ac].msp04=g_t1
                   DISPLAY g_msp[l_ac].msp04 TO msp04
                   NEXT FIELD msp04
{
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_smy"
                   LET g_qryparam.default1 = g_msp[l_ac].msp04
                   LET g_qryparam.arg1     = "*"
                   LET g_qryparam.arg2     = "*"
                   IF g_qryparam.arg1 != '*' THEN
                      LET g_qryparam.where =g_qryparam.where CLIPPED,
                                           " AND smysys='",g_qryparam.arg1,"'"
                   END IF
                   IF g_qryparam.arg2 != '*' THEN
                      LET g_qryparam.where =g_qryparam.where CLIPPED,
                                           " AND smykind='",g_qryparam.arg2,"'"
                   END IF
                   LET g_qryparam.where = g_qryparam.where CLIPPED,
                                          " ORDER BY 2 "
                   CALL cl_create_qry() RETURNING g_msp[l_ac].msp04
#                   CALL FGL_DIALOG_SETBUFFER( g_msp[l_ac].msp04 )
                    DISPLAY g_msp[l_ac].msp04 TO msp04          #No.MOD-490371
                   NEXT FIELD msp04
}
                WHEN INFIELD(msp05) #Addr
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_pme"
                   LET g_qryparam.default1 = g_msp[l_ac].msp05
                   CALL cl_create_qry() RETURNING g_msp[l_ac].msp05
                  # CALL FGL_DIALOG_SETBUFFER( g_msp[l_ac].msp05 )
                   DISPLAY g_msp[l_ac].msp05 TO msp05
                   NEXT FIELD msp05
            END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
            #BugNo:6468
            IF INFIELD(msp02) AND l_ac > 1 THEN
                LET g_msp[l_ac].* = g_msp[l_ac-1].*
                LET g_msp[l_ac].msp02 = g_msp_t.msp02
                DISPLAY g_msp[l_ac].* TO s_msp[l_ac].*
                NEXT FIELD msp02
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
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
        END INPUT
 
        CLOSE i701_bcl
        COMMIT WORK
END FUNCTION
 
FUNCTION i701_msp03(p_cmd,l_msp03)          #學歷代號
    DEFINE l_imd02   LIKE imd_file.imd02,
           l_imdacti LIKE imd_file.imdacti,
           l_msp03   LIKE msp_file.msp03,
           p_cmd     LIKE type_file.chr1    #No.FUN-680082 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT imd02,imdacti INTO l_imd02,l_imdacti
      FROM imd_file WHERE imd01 = l_msp03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0094'
                                   LET l_imd02 = NULL
         WHEN l_imdacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd='d' THEN
     DISPLAY l_imd02 TO imd02            #No.MOD-490371
  END IF
    RETURN l_imd02
END FUNCTION
 
FUNCTION i701_msp04(p_cmd,l_msp04)         #學歷代號
    DEFINE l_smydesc LIKE smy_file.smydesc,
           l_smyacti LIKE smy_file.smyacti,
           l_msp04   LIKE msp_file.msp04,
           p_cmd     LIKE type_file.chr1       #No.FUN-680082 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT smydesc,smyacti INTO l_smydesc,l_smyacti
      FROM smy_file WHERE smyslip = l_msp04
 
 #---- No.FUN-5C0047 add 判斷訂單單據別
    IF SQLCA.sqlcode THEN
       SELECT oaydesc INTO l_smydesc
          FROM oay_file WHERE oayslip = l_msp04
       LET l_smyacti = 'Y'
    END IF
 #-----No.FUN-5C0047 end
 
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3046'
                                   LET l_smydesc = NULL
         WHEN l_smyacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd='d' THEN
     DISPLAY l_smydesc TO smydesc         #No.MOD-490371
  END IF
    RETURN l_smydesc
END FUNCTION
 
FUNCTION i701_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000  #No.FUN-680082 VARCHAR(200)
 
    CONSTRUCT l_wc ON msp02,msp03,msp04,msp05 #螢幕上取條件
       FROM s_msp[1].msp02,s_msp[1].msp03,s_msp[1].msp04,s_msp[1].msp05
 
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
    IF INT_FLAG THEN RETURN END IF
    CALL i701_bf(l_wc)
END FUNCTION
 
FUNCTION i701_bf(p_wc)                     #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000  #No.FUN-680082 VARCHAR(200)
 
    #FUN-890024  add msp10
    LET g_sql =
       "SELECT msp02,msp03,imd02,msp04,smydesc,msp05,msp10 ",
       " FROM msp_file LEFT OUTER JOIN imd_file ON msp_file.msp03=imd_file.imd01 LEFT OUTER JOIN smy_file ON msp_file.msp04=smy_file.smyslip ",
       " WHERE msp01 = '",g_msp01,"'",
       "   AND ",p_wc CLIPPED ,
       " ORDER BY msp02 "
    PREPARE i701_prepare2 FROM g_sql       #預備一下
    DECLARE msp_cs CURSOR FOR i701_prepare2
    CALL g_msp.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH msp_cs INTO g_msp[g_cnt].*     #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        #FUN-890024
      #----No.FUN-5C0047 add
        IF cl_null(g_msp[g_cnt].smydesc) THEN
           SELECT oaydesc INTO g_msp[g_cnt].smydesc
             FROM oay_file WHERE oayslip=g_msp[g_cnt].msp04
        END IF
      #-----No.FUN-5C0047 end
 
        LET g_cnt = g_cnt + 1
        #TQC-630106-begin 
         IF g_cnt > g_max_rec THEN   #MOD-4B0274
            CALL cl_err( '', 9035, 0 )
            EXIT FOREACH
         END IF
        #TQC-630106-end 
    END FOREACH
    CALL g_msp.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i701_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680082 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_msp TO s_msp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      #FUN-8A0026 add
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i701_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i701_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i701_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i701_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i701_fetch('L')
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
 
 
      #FUN-4B0013
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
      ON ACTION related_document                #No.FUN-6B0041  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i701_copy()
DEFINE
    l_n             LIKE type_file.num5,    #No.FUN-680082 smallint 
    l_buf           LIKE type_file.chr1000, #No.FUN-680082 VARCHAR(1)
    l_newno1,l_oldno1  LIKE msp_file.msp01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_msp01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    DISPLAY " " TO msp01
    #FUN-8A0026
    CALL cl_set_comp_entry("msp01",TRUE)

    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT l_newno1 FROM msp01
 
        AFTER FIELD msp01                   #員工編號
            IF NOT cl_null(l_newno1) THEN
               SELECT COUNT(*) INTO l_n FROM msp_file
                WHERE msp01 = l_newno1
               IF l_n > 0 THEN
                 CALL cl_err(g_msp01,-239,0)
                 NEXT FIELD msp01
               END IF
            END IF
 
        AFTER INPUT
            IF INT_FLAG THEN
                EXIT INPUT
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
        DISPLAY  g_msp01 TO msp01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM msp_file             #單身複製
        WHERE msp01 = g_msp01
        INTO TEMP x
     IF SQLCA.sqlcode THEN
        LET g_msg=g_msp01 CLIPPED
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        RETURN
    END IF
    UPDATE x
        SET msp01=l_newno1             #資料鍵值
    INSERT INTO msp_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        LET g_msg=g_msp01 CLIPPED
        CALL cl_err(l_buf,SQLCA.sqlcode,0)
        RETURN
    ELSE
        MESSAGE 'ROW(',l_buf,') O.K'
        LET l_oldno1= g_msp01
        LET g_msp01 = l_newno1
        CALL i701_b()
        #LET g_msp01 = l_oldno1  #FUN-C80046
        #CALL i701_show()        #FUN-C80046
    END IF
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i701_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_msp01 IS NULL THEN
       CALL cl_err("",-400,0)                 #No.FUN-6B0041
       RETURN
    END IF
    BEGIN WORK
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "msp01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_msp01       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM msp_file WHERE msp01 = g_msp01
        IF SQLCA.sqlcode THEN
#            CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0) #No.FUN-660107
             CALL cl_err3("del","msp_file",g_msp01,"",SQLCA.SQLCODE,"","BODY DELETE:",1)       #NO.FUN-660107
        ELSE
            CLEAR FORM
            #MOD-5A0004 add
            DROP TABLE x
#           EXECUTE i701_precount_x                  #No.TQC-720019
            PREPARE i701_precount_x2 FROM g_sql_tmp  #No.TQC-720019
            EXECUTE i701_precount_x2                 #No.TQC-720019
            #MOD-5A0004 end
            CALL g_msp.clear()
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            OPEN i701_count
            #FUN-B50063-add-start--
            IF STATUS THEN
               CLOSE i701_bcs
               CLOSE i701_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50063-add-end-- 
            FETCH i701_count INTO g_row_count
            #FUN-B50063-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i701_bcs
               CLOSE i701_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50063-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i701_bcs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i701_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i701_fetch('/')
            END IF
        END IF
    END IF
    COMMIT WORK
END FUNCTION

 
#Patch....NO.TQC-610035 <001> #
