# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: amri400.4gl
# Descriptions...: MRP 工單模擬資料維護作業
# Date & Author..: 03/05/06 By Nicola
# Modify.........: No:8530 03/11/04 Sophia 'G產生'時, 應可輸入工單模擬編號, 不應該是以目前畫面上QUERY出來的編號
# Modify.........: No.FUN-4B0013 04/11/08 By ching add '轉Excel檔' action
# Modify.........: No.FUN-550055 05/05/25 By Will 單據編號放大
# Modify.........: No.MOD-5A0004 05/10/07 By Rosayu 刪除資料後筆數不正確
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
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770031 07/07/05 By chenl   去除單身中，預設上一筆功能。
# Modify.........: No.TQC-790001 07/09/02 By Mandy PK問題
# Modify.........: No.TQC-790177 07/09/29 By Carrier 去掉全型字符
# Modify.........: No.MOD-810055 08/03/04 By Pengu 按下"產生"後無法將產生的工單資料顯示在單身
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.TQC-970096 09/07/09 By lilingyu 1.錄入資料,刪除后程序會異常當出 2.單身有資料的情況下,點"單身",然后"退出",單身的生產料件清空了
# Modify.........: No.FUN-980004 09/08/12 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50176 11/06/09 By xianghui amri400g里的工單編號改QBE開窗、單身開窗插入可多選插入
# Modify.........: No.TQC-C60163 12/06/20 By fengrui amri400g 添加工單類型、料號、部門、PBI NO開窗,編碼方式改為一般的輸入格式,與批次產生相同
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:MOD-D30174 13/03/18 By ck2yuan l_wc,l_sql改為string
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_msf01         LIKE msf_file.msf01,   #工單模擬編號
    g_msf01_t       LIKE msf_file.msf01,   #工單模擬編號(舊值)
    g_msf           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        msf02       LIKE msf_file.msf02,   #工單編號
        sfb05       LIKE sfb_file.sfb05,   #生產料件
        sfb40       LIKE sfb_file.sfb40,   #優先順序
        sfb13       LIKE sfb_file.sfb13,   #開工日期
        sfb15       LIKE sfb_file.sfb15    #完工日期
                    END RECORD,
    g_msf_t         RECORD                 #程式變數 (舊值)
        msf02       LIKE msf_file.msf02,   #工單編號
        sfb05       LIKE sfb_file.sfb05,   #生產料件
        sfb40       LIKE sfb_file.sfb40,   #優先順序
        sfb13       LIKE sfb_file.sfb13,   #開工日期
        sfb15       LIKE sfb_file.sfb15    #完工日期
                    END RECORD,
     g_wc,g_sql,g_wc2    STRING,           #No.FUN-580092  HCN        
    g_argv1         LIKE msf_file.msf01,   #員工代號
  # g_argv2         VARCHAR(10),              #單號
    g_argv2         LIKE msf_file.msf02,   #No.FUN-680082 VARCHAR(10)
  # g_argv3         SMALLINT,              #項次
    g_argv3         LIKE type_file.num5,   #No.FUN-680082 SMALLINT
  # g_show          VARCHAR(1),
    g_show          LIKE type_file.chr1,   #No.FUN-680082 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,   #單身筆數     #No.FUN-680082 SMALLINT
    g_flag          LIKE type_file.chr1,   #No.FUN-680082 VARCHAR(1)
  # g_ss            VARCHAR(1),
    g_ss            LIKE type_file.chr1,   #No.FUN-680082 VARCHAR(1)
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT  #No.FUN-680082 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql    STRING    #SELECT ... FOR UPDATE SQL   
DEFINE g_sql_tmp       STRING    #No.TQC-720019
DEFINE g_cnt           LIKE type_file.num10     #No.FUN-680082 INTEGER
DEFINE g_msg           LIKE type_file.chr1000   #No.FUN-680082 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10      #No.FUN-680082 INTEGER
DEFINE g_curs_index   LIKE type_file.num10      #No.FUN-680082 INTEGER
DEFINE g_jump         LIKE type_file.num10      #No.FUN-680082 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5      #No.FUN-680082 SMALLINT
 
MAIN
DEFINE
#       l_time    LIKE type_file.chr8            #No.FUN-6A0076
    p_row,p_col   LIKE type_file.num5     #No.FUN-680082 SMALLINT
 
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
    LET p_row = 2 LET p_col = 20
    OPEN WINDOW i400_w AT p_row,p_col
        WITH FORM "amr/42f/amri400"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN
       CALL i400_q()
    END IF
    CALL i400_menu()
    CLOSE WINDOW i400_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)  #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
         RETURNING g_time    #No.FUN-6A0076
END MAIN
 
#QBE 查詢資料
FUNCTION i400_cs()
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = " msf01 = '",g_argv1,"'"
    ELSE
      CLEAR FORM                             #清除畫面
      CALL g_msf.clear()
      CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_msf01 TO NULL    #No.FUN-750051
      CONSTRUCT g_wc ON msf01,msf02
          FROM msf01,s_msf[1].msf02
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
      ON ACTION controlp
            CASE
                WHEN INFIELD(msf02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_sfb8"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO msf02
                  NEXT FIELD msf02
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
    LET g_sql= "SELECT UNIQUE msf01 FROM msf_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY 1"
    PREPARE i400_prepare FROM g_sql      #預備一下
    DECLARE i400_bcs                     #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i400_prepare
 
#   LET g_sql = "SELECT UNIQUE msf01 FROM msf_file ",      #No.TQC-720019
    LET g_sql_tmp = "SELECT UNIQUE msf01 FROM msf_file ",  #No.TQC-720019
                " WHERE ", g_wc CLIPPED,
                " INTO TEMP x "
    DROP TABLE x
#   PREPARE i400_precount_x FROM g_sql      #No.TQC-720019
    PREPARE i400_precount_x FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i400_precount_x
 
        LET g_sql="SELECT COUNT(*) FROM x "
    PREPARE i400_precount FROM g_sql
    DECLARE i400_count CURSOR FOR i400_precount
 
END FUNCTION
 
FUNCTION i400_menu()
 
   WHILE TRUE
      CALL i400_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i400_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i400_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i400_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i400_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i400_b()
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
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_msf),'','')
             END IF
         #--
 
         WHEN "generate"
            IF cl_chk_act_auth() THEN
               CALL i400_g()
            END IF
 
         #No.FUN-6B0041-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_msf01 IS NOT NULL THEN
                 LET g_doc.column1 = "msf01"
                 LET g_doc.value1 = g_msf01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6B0041-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i400_a()
    MESSAGE ""
    CLEAR FORM
    CALL g_msf.clear()
    INITIALIZE g_msf01 LIKE msf_file.msf01
    LET g_msf01_t  = NULL
    LET g_rec_b =0        #NO.FUN-680064
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i400_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET g_msf01=NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_ss='N' THEN
            CALL g_msf.clear()
        ELSE
            CALL i400_bf('1=1')            #單身
        END IF
        CALL i400_b()                      #輸入單身
        LET g_msf01_t = g_msf01
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i400_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,     #a:輸入 u:更改  #No.FUN-680082 VARCHAR(1)
    l_n             LIKE type_file.num5,     #No.FUN-680082 SMALLINT
  # l_str           VARCHAR(40)
    l_str           LIKE type_file.chr1000   #No.FUN-680082 VARCHAR(40)
 
    LET g_ss='Y'
 
    DISPLAY g_msf01 TO msf01
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT g_msf01 WITHOUT DEFAULTS
         FROM msf01
 
        #NO.Fun-550055  --start
        BEFORE INPUT
          #CALL cl_set_docno_format("msf01")  #TQC-C60163 mark
        #NO.Fun-550055  --end
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        #TQC-860019-add
        ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
        #TQC-860019-add
 
    END INPUT
END FUNCTION
 
#Query 查詢
FUNCTION i400_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_msf01 TO NULL          #No.FUN-6B0041
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_msf.clear()
    DISPLAY '    ' TO FORMONLY.cnt
    CALL i400_cs()                      #取得查詢條件
    IF INT_FLAG THEN                    #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_msf01 TO NULL
        RETURN
    END IF
    OPEN i400_bcs                       #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN               #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_msf01 TO NULL
    ELSE
        OPEN i400_count
        FETCH i400_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i400_fetch('F')            #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i400_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式    #No.FUN-680082 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數  #No.FUN-680082 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i400_bcs INTO g_msf01
        WHEN 'P' FETCH PREVIOUS i400_bcs INTO g_msf01
        WHEN 'F' FETCH FIRST    i400_bcs INTO g_msf01
        WHEN 'L' FETCH LAST     i400_bcs INTO g_msf01
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
           FETCH ABSOLUTE g_jump i400_bcs INTO g_msf01
           LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                  #有麻煩
        CALL cl_err(g_msf01,SQLCA.sqlcode,0)
        INITIALIZE g_msf01 TO NULL  #TQC-6B0105
    ELSE
        CALL i400_show()
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
FUNCTION i400_show()
 
    DISPLAY g_msf01 TO msf01                #單頭
    CALL i400_bf(g_wc)                      #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i400_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680082 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用        #No.FUN-680082 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680082 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態          #No.FUN-680082 VARCHAR(1)
    l_imd02         LIKE imd_file.imd02,
    l_smydesc       LIKE smy_file.smydesc,
    l_i             LIKE type_file.num5,    #No.FUN-680082 SMALLINT
  # l_sw            VARCHAR(1),
    l_sw            LIKE type_file.chr1,    #No.FUN-680082 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,    #可新增否    #No.FUN-680082 SMALLINT
    l_allow_delete  LIKE type_file.num5     #可刪除否    #No.FUN-680082 SMALLINT
DEFINE tok         base.StringTokenizer     #FUN-B50176 add
DEFINE l_plant     LIKE msf_file.msf02      #FUN-B50176 add
DEFINE l_flag      LIKE type_file.chr1      #FUN-B50176 add
 
    LET g_action_choice = ""
    IF g_msf01 IS NULL OR g_msf01 = ' ' THEN
        RETURN
    END IF
    IF s_shut(0) THEN RETURN END IF
 
    CALL cl_opmsg('b')
 
 
    LET g_forupd_sql = " SELECT msf02,'','','','' ",
                       " FROM msf_file ",
                       " WHERE msf01 =? ",
                       " AND msf02 = ? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i400_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_msf WITHOUT DEFAULTS FROM s_msf.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            CALL cl_set_docno_format("msf02")   #No.FUN-550055
 
        BEFORE ROW
            LET p_cmd = ''
            BEGIN WORK
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
            #IF g_msf_t.msf02 IS NOT NULL THEN
 
                LET p_cmd='u'
                LET g_msf_t.* = g_msf[l_ac].*  #BACKUP
                OPEN i400_bcl USING g_msf01,g_msf_t.msf02
                IF STATUS THEN
                   CALL cl_err("OPEN i400_bcl:", STATUS, 1)
                   CLOSE i400_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH i400_bcl INTO g_msf[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_msf_t.msf02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   ELSE
                #       LET g_msf_t.*=g_msf[l_ac].*           #TQC-970096
                #   END IF                                    #TQC-970096
                   SELECT sfb05,sfb40,sfb13,sfb15 INTO
                          g_msf[l_ac].sfb05,g_msf[l_ac].sfb40,
                          g_msf[l_ac].sfb13,g_msf[l_ac].sfb15
                     FROM sfb_file WHERE sfb01=g_msf[l_ac].msf02
                        LET g_msf_t.* = g_msf[l_ac].*          #TQC-970096
                   END IF                                      #TQC-970096                      
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
#              CALL g_msf.deleteElement(l_ac)   #取消 Array Element
#              IF g_rec_b != 0 THEN   #單身有資料時取消新增而不離開輸入
#                 LET g_action_choice = "detail"
#                 LET l_ac = l_ac_t
#              END IF
#              EXIT INPUT
            END IF
            INSERT INTO msf_file(msf01,msf02,msfplant,msflegal) #FUN-980004 add msfplant,msflegal
            VALUES(g_msf01,g_msf[l_ac].msf02,g_plant,g_legal) #FUN-980004 add g_plant,g_legal
            IF SQLCA.sqlcode THEN
#                CALL cl_err(g_msf[l_ac].msf02,SQLCA.sqlcode,0) #No.FUN-660107
                 CALL cl_err3("ins","msf_file",g_msf01,g_msf[l_ac].msf02,SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
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
            INITIALIZE g_msf[l_ac].* TO NULL            #900423
            LET g_msf_t.* = g_msf[l_ac].*               #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD msf02
 
        AFTER FIELD msf02
            IF NOT cl_null(g_msf[l_ac].msf02) THEN
                 SELECT COUNT(*) INTO l_n FROM sfb_file
                     WHERE sfb01 = g_msf[l_ac].msf02
                       AND sfb04 < '8' AND sfb87 <> 'X'
                     IF l_n > 0 THEN
                        SELECT sfb05,sfb40,sfb13,sfb15 INTO
                               g_msf[l_ac].sfb05,g_msf[l_ac].sfb40,
                               g_msf[l_ac].sfb13,g_msf[l_ac].sfb15
                          FROM sfb_file WHERE sfb01=g_msf[l_ac].msf02
                     ELSE
                        CALL cl_err(g_msf[l_ac].msf02,'abx-005',0)
                        NEXT FIELD msf02
                     END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_msf_t.msf02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM msf_file
                    WHERE msf01 = g_msf01
                     AND  msf02 = g_msf_t.msf02
                IF SQLCA.sqlcode THEN
#                    CALL cl_err(g_msf_t.msf02,SQLCA.sqlcode,0) #No.FUN-660107
                      CALL cl_err3("del","msf_file",g_msf01,g_msf_t.msf02,SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
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
               LET g_msf[l_ac].* = g_msf_t.*
               CLOSE i400_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_msf[l_ac].msf02,-263,1)
               LET g_msf[l_ac].* = g_msf_t.*
            ELSE
               UPDATE msf_file SET msf02=g_msf[l_ac].msf02
                WHERE msf01 = g_msf01
                  AND msf02 = g_msf_t.msf02
               IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_msf[l_ac].msf02,SQLCA.sqlcode,0) #No.FUN-660107
                     CALL cl_err3("upd","msf_file",g_msf01,g_msf_t.msf02,SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
                   LET g_msf[l_ac].* = g_msf_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_msf[l_ac].* = g_msf_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_msf.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i400_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D40030 Add
            CLOSE i400_bcl
            COMMIT WORK
 
        ON ACTION controlp
            CASE
                WHEN INFIELD(msf02)
#FUN-B50176-mark--begin--
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form     = "q_sfb8"
#                  LET g_qryparam.default1 = g_msf[l_ac].msf02
#                  CALL cl_create_qry() RETURNING g_msf[l_ac].msf02        
##                 CALL FGL_DIALOG_SETBUFFER( g_msf[l_ac].msf02 )
#                  DISPLAY BY NAME g_msf[l_ac].msf02      
#                  NEXT FIELD msf02
#FUN-B50176-mark--end--
                   #FUN-B50176-add-begin--
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_sfb8"
                   IF p_cmd = 'u' THEN
                      LET g_qryparam.default1 = g_msf[l_ac].msf02
                      CALL cl_create_qry() RETURNING g_msf[l_ac].msf02
                      DISPLAY BY NAME g_msf[l_ac].msf02
                   ELSE
                      LET g_qryparam.state = "c"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      LET tok = base.StringTokenizer.createExt(g_qryparam.multiret,"|",'',TRUE)         
                      WHILE tok.hasMoreTokens()
                         LET l_plant = tok.nextToken()
                         IF cl_null(l_plant) THEN
                            CONTINUE WHILE
                         ELSE
                            SELECT COUNT(*) INTO l_n  FROM msf_file
                            WHERE msf01 = g_msf01 AND msf02 = l_plant
                            IF l_n > 0 THEN
                               CONTINUE WHILE
                            END IF
                         END IF
                         INSERT INTO msf_file(msf01,msf02,msfplant,msflegal)
                                      VALUES (g_msf01,l_plant,g_plant,g_legal)
                      END WHILE
                      LET l_flag = 'Y'
                      EXIT INPUT
                   END IF
                   #FUN-B50176-add-end--
            END CASE
       #No.TQC-770031--begin--
       #ON ACTION CONTROLO                        #沿用所有欄位
       #    IF INFIELD(msf02) AND l_ac > 1 THEN
       #        LET g_msf[l_ac].* = g_msf[l_ac-1].*
       #        LET g_msf[l_ac].msf02 = g_msf_t.msf02
       #        DISPLAY g_msf[l_ac].* TO s_msf[l_ac].*
       #        NEXT FIELD msf02
       #    END IF
       #No.TQC-770031--end--
 
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
#FUN-B50176-add-str--
     IF l_flag = 'Y' THEN
         CALL i400_bf('1=1')
         CALL i400_b() 
     END IF
#FUN-B50176-add-end-- 

    CLOSE i400_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i400_b_askkey()
DEFINE
   #l_wc            LIKE type_file.chr1000   #No.FUN-680082 VARCHAR(200)  #MOD-D30174 mark
    l_wc            STRING                   #MOD-D30174 add 
 
    CONSTRUCT l_wc ON msf02 #螢幕上取條件
       FROM s_msf[1].msf02
 
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
    CALL i400_bf(l_wc)
END FUNCTION
 
FUNCTION i400_bf(p_wc)                     #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000     #No.FUN-680082 VARCHAR(200)
 
    LET g_sql =
       "SELECT msf02,sfb05,sfb40,sfb13,sfb15",
       " FROM msf_file LEFT OUTER JOIN sfb_file ON msf_file.msf02=sfb_file.sfb01",
       " WHERE msf01 = '",g_msf01,"'",
       "   AND ",p_wc CLIPPED ,
       " ORDER BY msf02"
    PREPARE i400_prepare2 FROM g_sql       #預備一下
    DECLARE msf_cs CURSOR FOR i400_prepare2
    FOR g_cnt = 1 TO g_msf.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_msf[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH msf_cs INTO g_msf[g_cnt].*     #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        #TQC-630106-begin 
         IF g_cnt > g_max_rec THEN   #MOD-4B0274
            CALL cl_err( '', 9035, 0 )
            EXIT FOREACH
         END IF
        #TQC-630106-end 
    END FOREACH
    CALL g_msf.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i400_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1       #No.FUN-680082 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_msf TO s_msf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i400_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i400_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i400_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i400_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i400_fetch('L')
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
      #@ON ACTION 產生
      ON ACTION generate
         LET g_action_choice="generate"
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
 
 
FUNCTION i400_copy()
DEFINE
    l_n             LIKE type_file.num5,    #No.FUN-680082 smallint
    l_buf           LIKE type_file.chr1000, #No.FUN-680082 VARCHAR(40)
    l_newno1,l_oldno1  LIKE msf_file.msf01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_msf01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    DISPLAY " " TO msf01
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT l_newno1 FROM msf01
 
       AFTER FIELD msf01                   #員工編號
          IF NOT cl_null(l_newno1) THEN
             SELECT COUNT(*) INTO l_n FROM msf_file
              WHERE msf01 = l_newno1
             IF l_n > 0 THEN
                CALL cl_err(g_msf01,-239,0)
                NEXT FIELD msf01
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
        DISPLAY  g_msf01 TO msf01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM msf_file             #單身複製
        WHERE msf01 = g_msf01
        INTO TEMP x
     IF SQLCA.sqlcode THEN
        LET g_msg=g_msf01 CLIPPED
#        CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660107
          CALL cl_err3("ins","x",g_msf01,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
        RETURN
    END IF
    IF cl_null(l_newno1) THEN LET l_newno1 = ' ' END IF #TQC-790001 add
    UPDATE x
        SET msf01=l_newno1             #資料鍵值
  
    INSERT INTO msf_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        LET g_msg=g_msf01 CLIPPED
#        CALL cl_err(l_buf,SQLCA.sqlcode,0) #No.FUN-660107
          CALL cl_err3("ins","msf_file",l_newno1,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
        RETURN
    ELSE
        MESSAGE 'ROW(',l_buf,') O.K'
        LET l_oldno1= g_msf01
        LET g_msf01 = l_newno1
        CALL i400_b()
        #LET g_msf01 = l_oldno1  #FUN-C80046
        CALL i400_show()
    END IF
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i400_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_msf01 IS NULL THEN
       CALL cl_err("",-400,0)                 #No.FUN-6B0041
       RETURN
    END IF
    BEGIN WORK
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "msf01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_msf01       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM msf_file WHERE msf01 = g_msf01
        IF SQLCA.sqlcode THEN
#            CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0) #No.FUN-660107
              CALL cl_err3("del","msf_file",g_msf01,"",SQLCA.SQLCODE,"","BODY DELETE:",1)       #NO.FUN-660107
        ELSE
            CLEAR FORM
            #MOD-5A0004 add
            DROP TABLE x
#           EXECUTE i400_precount_x                  #No.TQC-720019
         IF NOT cl_null(g_sql_tmp) THEN              #NO.TQC-970096
            PREPARE i400_precount_x2 FROM g_sql_tmp  #No.TQC-720019
            EXECUTE i400_precount_x2                 #No.TQC-720019
         END IF                                      #No.TQC-970096            
            #MOD-5A0004 end
            CALL g_msf.clear()
            OPEN i400_count
            #FUN-B50063-add-start--
            IF STATUS THEN
               CLOSE i400_bcs
               CLOSE i400_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50063-add-end-- 
            FETCH i400_count INTO g_row_count
            #FUN-B50063-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i400_bcs
               CLOSE i400_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50063-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i400_bcs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i400_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i400_fetch('/')
            END IF
        END IF
    END IF
    COMMIT WORK
END FUNCTION
 
FUNCTION i400_g()
#DEFINE l_wc          LIKE type_file.chr1000,   #No.FUN-680082 VARCHAR(200)   #MOD-D30174 mark
#       l_sql         LIKE type_file.chr1000,   #No.FUN-680082 VARCHAR(200)   #MOD-D30174 mark
DEFINE l_wc           STRING,                   #MOD-D30174 add  
       l_sql          STRING,                   #MOD-D30174 add
     # l_success     VARCHAR(01),
       l_success     LIKE type_file.chr1,      #No.FUN-680082 VARCHAR(1) 
       l_msf01       LIKE msf_file.msf01,   #NO:8530
       l_sfb01       LIKE sfb_file.sfb01    #工單編號
 
#No:8530
#   IF g_msf01 IS NULL THEN
#      RETURN
#   END IF
 
   OPEN WINDOW i400_g_w AT 12,24 WITH FORM "amr/42f/amri400g"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("amri400g")
 
   IF STATUS THEN
      CALL cl_err('open window i400_g_w:',STATUS,0)
      RETURN
   END IF
 
   #NO:8530
   INPUT l_msf01 FROM FORMONLY.m HELP 1
 
        AFTER FIELD m                    #版別編號
            IF cl_null(l_msf01) THEN
                NEXT FIELD m
            END IF
 
   END INPUT
   IF INT_FLAG THEN CLOSE WINDOW i400_g_w LET INT_FLAG=0 RETURN END IF
 
 
   CONSTRUCT l_wc ON sfb01,sfb02,sfb05,sfb13,sfb82,sfb85
        FROM sfb01,sfb02,sfb05,sfb13,sfb82,sfb85
 
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      #FUN-B50176-add-begin--
      BEFORE FIELD sfb02
         CALL cl_err("","amr-108",0)   #TQC-C60163 add

      ON ACTION controlp
         CASE
            WHEN INFIELD(sfb01)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_sfb8"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sfb01
               NEXT FIELD sfb01
            #TQC-C60163--add--str--
            WHEN INFIELD(sfb05)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_sfb15"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sfb05
               NEXT FIELD sfb05 
            WHEN INFIELD(sfb82)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_sfb16"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sfb82
               NEXT FIELD sfb82 
            WHEN INFIELD(sfb85)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_sfb17"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sfb85
               NEXT FIELD sfb85 
            #TQC-C60163--add--end--
         END CASE
      #FUN-B50176-add-end--

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
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW i400_g_w RETURN END IF
 
   CLOSE WINDOW i400_g_w
   LET l_sql="SELECT sfb01 FROM sfb_file ",
             " WHERE sfb04 < '8' AND sfb87 <> 'X' AND ",l_wc CLIPPED
 
   PREPARE i400_g FROM l_sql
   DECLARE i400_gcur CURSOR FOR i400_g
   IF STATUS THEN
      RETURN
   END IF
 
   BEGIN WORK
   LET l_success='Y'
 
   FOREACH i400_gcur INTO l_sfb01
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         LET l_success='N'
         EXIT FOREACH
      END IF
      IF cl_null(l_msf01) THEN LET l_msf01 = ' ' END IF #TQC-790001 add
      INSERT INTO msf_file(msf01,msf02,msfplant,msflegal) VALUES (l_msf01,l_sfb01,g_plant,g_legal) #No:8530 #FUN-980004 add plant,legal
      IF SQLCA.sqlcode THEN                           #置入資料庫不成功
#         CALL cl_err(l_sfb01,SQLCA.sqlcode,1) #No.FUN-660107
           CALL cl_err3("ins","msf_file",l_msf01,l_sfb01,SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
         LET l_success='N'
         EXIT FOREACH
      END IF
 
   END FOREACH
 
 
   IF l_success='Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
#No:8530
   LET g_msf01 = l_msf01
   LET g_wc = "1 = 1"     #No.MOD-810055 add
   CALL i400_show()       #No.MOD-810055 add
 
   DISPLAY g_msf01 TO msf01                     #單頭
 
   DISPLAY ARRAY g_msf TO s_msf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
       EXIT DISPLAY
   END DISPLAY
##
 
END FUNCTION
 
#Patch....NO.TQC-610035 <001> #
#TQC-790177
