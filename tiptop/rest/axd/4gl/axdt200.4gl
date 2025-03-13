#
# Pattern name...: axdt200.4gl
# Descriptions...: 採購料件詢價維護作業
# Date & Author..: 03/12/12 By Hawk
# Modify.........: No.MOD-4B0067 04/11/18 BY DAY  將變數用Like方式定義
# Modify.........: No:FUN-4C0052 04/12/08 By pengu Data and Group權限控管
# Modify.........: No:MOD-530661 05/03/26 By Elva 單身刪除BUTTON去掉
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     
# Modify.........: Mo.FUN-6A0078 06/10/24 By xumin g_no_ask改mi_no_ask
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:FUN-6A0165 06/11/09 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No:FUN-6A0092 06/11/16 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    g_adf           RECORD LIKE adf_file.*,#簽核等級 (假單頭)
    g_adf_t         RECORD LIKE adf_file.*,#簽核等級 (舊值)
    g_adf01_t       LIKE adf_file.adf01,   #簽核等級 (舊值)
    g_adf_rowid     LIKE type_file.chr18,  #ROWID             #No.FUN-680108 INT
    g_ydate         LIKE type_file.dat,    #單據日期(沿用)    #No.FUN-680108 DATE
    g_adg           DYNAMIC ARRAY of RECORD# 程式變數(Program Variables)
        adg02       LIKE adg_file.adg02,   # 撥出單項次
        adg05       LIKE adg_file.adg05,   # 料件編號
        adg08       LIKE adg_file.adg08,   # 批號
        adg06       LIKE adg_file.adg06,   # 倉庫代號
        adg07       LIKE adg_file.adg07,   # 儲位
        adg09       LIKE adg_file.adg09,   # 撥入工廠代號
        adg10       LIKE adg_file.adg10,   # 撥入工廠倉庫
        adg11       LIKE adg_file.adg11,   # 單位
        adg12       LIKE adg_file.adg12,   # 撥出數量
        adg13       LIKE adg_file.adg13,   # 轉撥計價方式
        adg14       LIKE adg_file.adg14,   # 轉撥百分比
        adg15       LIKE adg_file.adg15,   # 撥出單價
        adg16       LIKE adg_file.adg16    # 撥出金額
                    END RECORD,
    g_adg_t         RECORD                 # 程式變數 (舊值)
        adg02       LIKE adg_file.adg02,   # 撥出單項次
        adg05       LIKE adg_file.adg05,   # 料件編號
        adg08       LIKE adg_file.adg08,   # 批號
        adg06       LIKE adg_file.adg06,   # 倉庫代號
        adg07       LIKE adg_file.adg07,   # 儲位
        adg09       LIKE adg_file.adg09,   # 撥入工廠代號
        adg10       LIKE adg_file.adg10,   # 撥入工廠倉庫
        adg11       LIKE adg_file.adg11,   # 單位
        adg12       LIKE adg_file.adg12,   # 撥出數量
        adg13       LIKE adg_file.adg13,   # 轉撥計價方式
        adg14       LIKE adg_file.adg14,   # 轉撥百分比
        adg15       LIKE adg_file.adg15,   # 撥出單價
        adg16       LIKE adg_file.adg16    # 撥出金額
                    END RECORD,
    g_argv1         LIKE adg_file.adg01,        # 詢價單號
     g_wc,g_wc2,g_sql    string, #No:FUN-580092 HCN       
    g_rec_b         LIKE type_file.num5,        #單身筆數             #No.FUN-680108 SMALLINT
    l_ac            LIKE type_file.num5         #目前處理的ARRAY CNT  #No.FUN-680108 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680108 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5  #No.FUN-680108 SMALLINT

DEFINE   g_forupd_sql   STRING                 #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE   g_cnt          LIKE type_file.num10   #No.FUN-680108 INTEGER
DEFINE   g_chr          LIKE type_file.chr1    #No.FUN-680108 VARCHAR(01)
DEFINE   g_i            LIKE type_file.num5    #count/index for any purpose        #No.FUN-680108 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000 #No.FUN-680108 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-680108 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-680108 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-680108 INTEGER	
DEFINE   mi_no_ask      LIKE type_file.num5    #No.FUN-680108 SMALLINT   #No.FUN-6A0078
#主程式開始
MAIN
#DEFINE                                        #No.FUN-6A0091  
#       l_time    LIKE type_file.chr8          #No.FUN-6A0091
    OPTIONS                                #改變一些系統預設值
        FORM LINE       FIRST + 2,         #畫面開始的位置
        MESSAGE LINE    LAST,              #訊息顯示的位置
        PROMPT LINE     LAST,              #提示訊息的位置
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
# Prog. Version..: '5.10.00-08.01.04(00000)'     #

    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("AXD")) THEN
       EXIT PROGRAM
    END IF

      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091

    LET g_argv1 = ARG_VAL(1)               #參數-1(詢價單號)

    LET g_forupd_sql ="SELECT * FROM adf_file WHERE ROWID = ? FOR UPDATE NOWAIT"
    DECLARE t200_cl CURSOR FROM g_forupd_sql

    LET p_row = 3 LET p_col = 2

    OPEN WINDOW t200_w AT p_row,p_col
        WITH FORM "axd/42f/axdt200"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN

    CALL cl_ui_init()
--##
    CALL g_x.clear()
--##

    LET g_ydate = NULL
    IF g_argv1 IS NOT NULL AND g_argv1 != ' '
    THEN CALL t200_q()
    END IF
    CALL t200_menu()    #中文
    CLOSE WINDOW t200_w
      CALL  cl_used(g_prog,g_time,2) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091
END MAIN

#QBE 查詢資料
FUNCTION t200_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No:FUN-580031  HCN
    CLEAR FORM                                            #清除畫面
    CALL g_adg.clear()
    IF g_argv1 IS NOT NULL AND g_argv1 != ' '
       THEN LET g_wc = " adf01 = '",g_argv1,"'"
    ELSE
       CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
   INITIALIZE g_adf.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                          # 螢幕上取單頭條件
           adf00,adf01,adf09,adf07,
           adfuser,adfgrup,adfmodu,adfdate,adfpost

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
              CALL cl_qbe_list() RETURNING lc_qbe_sn
              CALL cl_qbe_display_condition(lc_qbe_sn)
           #No:FUN-580031 --end--       HCN
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
    END IF
    #資料權限的檢查
    IF g_priv2='4' THEN                                    #只能使用自己的資料
       LET g_wc = g_wc clipped," AND adfuser = '",g_user,"'"
    END IF
    IF g_priv3='4' THEN                                    #只能使用相同群的資料
       LET g_wc = g_wc clipped," AND adfgrup MATCHES '",g_grup CLIPPED,"*'"
    END IF

    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
       LET g_wc = g_wc clipped," AND adfgrup IN ",cl_chk_tgrup_list()
    END IF

    CONSTRUCT g_wc2 ON adg02,adg05,adg08,adg06,            #螢幕上取單身條件
                       adg07,adg09,adg10,adg11,
                       adg12,adg13,adg14,adg15,adg16
            FROM s_adg[1].adg02,s_adg[1].adg05,s_adg[1].adg08,
                 s_adg[1].adg06,s_adg[1].adg07,s_adg[1].adg09,
                 s_adg[1].adg10,s_adg[1].adg11,s_adg[1].adg12,
                 s_adg[1].adg13,s_adg[1].adg14,s_adg[1].adg15,
                 s_adg[1].adg16

            #No:FUN-580031 --start--     HCN
            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
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
            ON ACTION qbe_save
                CALL cl_qbe_save()
            #No:FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    IF g_wc2 = " 1=1" THEN
       LET g_sql = "SELECT ROWID, adf01 FROM adf_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY adf01"
    ELSE		
       LET g_sql = "SELECT UNIQUE adf_file.ROWID, adf01 ",
                   "  FROM adf_file, adg_file ",
                   " WHERE adf01 = adg01",
                   "   AND ", g_wc CLIPPED,
                   " AND ",g_wc2 CLIPPED,
                   " ORDER BY adf01"
    END IF
    PREPARE t200_prepare FROM g_sql
    DECLARE t200_cs
        SCROLL CURSOR WITH HOLD FOR t200_prepare
    IF g_wc2 = " 1=1" THEN	
        LET g_sql="SELECT COUNT(*) FROM adf_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT adf01)",
                  "  FROM adf_file,adg_file ",
                  " WHERE adg01=adf01 AND ",g_wc CLIPPED,
                  "   AND ",g_wc2 CLIPPED
    END IF
    PREPARE t200_precount FROM g_sql
    DECLARE t200_count CURSOR FOR t200_precount
--## 2004/02/06 by Hiko : 為了上下筆資料所做的設定.
   OPEN t200_count
   FETCH t200_count INTO g_row_count
   CLOSE t200_count
END FUNCTION

#中文的MENU
FUNCTION t200_menu()
   WHILE TRUE
      CALL t200_bp("G")
      CASE g_action_choice
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL t200_q()
           END IF
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL t200_b()
           ELSE
              LET g_action_choice = NULL
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
                IF g_adf.adf01 IS NOT NULL THEN
                LET g_doc.column1 = "adf01"
                LET g_doc.value1 = g_adf.adf01
                CALL cl_doc()
              END IF
        END IF
        #No:FUN-6A0165-------add--------end----
      END CASE
   END WHILE
END FUNCTION

#Query 查詢
FUNCTION t200_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_adf.* TO NULL               #No.FUN-6A0165

    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_adg.clear()
    DISPLAY '   ' TO FORMONLY.cnt            #ATTRIBUTE(YELLOW)
    CALL t200_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_adf.* TO NULL
        RETURN
    END IF
        OPEN t200_count
        FETCH t200_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t200_cs
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_adf.* TO NULL
    ELSE
        CALL t200_fetch('F')
    END IF
END FUNCTION

#處理資料的讀取
FUNCTION t200_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(1)
    l_abso          LIKE type_file.num10         #No.FUN-680108 INTEGER

    CASE p_flag
        WHEN 'N' FETCH NEXT     t200_cs INTO g_adf_rowid,g_adf.adf01
        WHEN 'P' FETCH PREVIOUS t200_cs INTO g_adf_rowid,g_adf.adf01
        WHEN 'F' FETCH FIRST    t200_cs INTO g_adf_rowid,g_adf.adf01
        WHEN 'L' FETCH LAST     t200_cs INTO g_adf_rowid,g_adf.adf01
        WHEN '/'
          IF (NOT mi_no_ask) THEN   #No.FUN-6A0078
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
#             PROMPT g_msg CLIPPED,': ' FOR l_abso
             PROMPT g_msg CLIPPED || ': ' FOR g_jump   --改g_jump
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
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
            END IF
          END IF
            FETCH ABSOLUTE g_jump t200_cs INTO g_adf_rowid,g_adf.adf01
            LET mi_no_ask = FALSE    #No.FUN-6A0078
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adf.adf01,SQLCA.sqlcode,0)
        INITIALIZE g_adf.* TO NULL  #TQC-6B0105
        LET g_adf_rowid = NULL      #TQC-6B0105
        RETURN
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
    SELECT * INTO g_adf.* FROM adf_file WHERE ROWID = g_adf_rowid
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adf.adf01,SQLCA.sqlcode,0)
        INITIALIZE g_adf.* TO NULL
        RETURN
    ELSE                                    #FUN-4C0052權限控管
       LET g_data_owner=g_adf.adfuser
       LET g_data_group=g_adf.adfgrup
    END IF

    CALL t200_show()
END FUNCTION

#將資料顯示在畫面上
FUNCTION t200_show()
    LET g_adf_t.* = g_adf.*
    DISPLAY BY NAME
        g_adf.adf00,g_adf.adf01,
        g_adf.adf09,g_adf.adf07,
        g_adf.adfpost,g_adf.adfuser,
        g_adf.adfgrup,g_adf.adfmodu,
        g_adf.adfdate
    CALL t200_adf00()
    CALL t200_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

FUNCTION t200_b()
DEFINE l_adf        RECORD LIKE adf_file.*
DEFINE l_adg        RECORD LIKE adg_file.*
DEFINE p_cmd        LIKE type_file.chr1   #No.FUN-680108 VARCHAR(01)
DEFINE
    l_ac_t          LIKE type_file.num5,            #No.FUN-680108 SMALLINT
    l_n             LIKE type_file.num5,            #No.FUN-680108 SMALLINT
    l_lock_sw       LIKE type_file.chr1,            #No.FUN-680108 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,  #可新增否 #No.FUN-680108 SMALLINT
    l_allow_delete  LIKE type_file.num5   #可刪除否 #No.FUN-680108 SMALLINT

    LET g_action_choice = ""

    IF s_shut(0) THEN RETURN END IF
    IF g_adf.adf01 IS NULL THEN
       RETURN
    END IF
    SELECT * INTO g_adf.* FROM adf_file WHERE adf01=g_adf.adf01
    IF g_adf.adf00 = "1" THEN RETURN END IF
    CALL cl_opmsg('b')

    LET g_forupd_sql="SELECT adg02,adg05,adg08,adg06,adg07,adg09,adg10,",
                     "       adg11,adg12,adg13,adg14,adg15,adg16",
                     "  FROM adg_file",
                     " WHERE adg02=? AND adg01=?",
                     " FOR UPDATE NOWAIT"
    DECLARE t200_bcl CURSOR FROM g_forupd_sql
 
 #NO.MOD-530661 By Elva--begin
#     LET l_allow_insert = cl_detail_input_auth("insert")
#     LET l_allow_delete = cl_detail_input_auth("delete")
      LET l_allow_delete = FALSE
      LET l_allow_insert = FALSE
 #NO.MOD-530661 By Elva--end
 
        INPUT ARRAY g_adg WITHOUT DEFAULTS FROM s_adg.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                      APPEND ROW=l_allow_insert)

        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
           LET g_i=g_adg.getLength()

      BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'
            BEGIN WORK
            OPEN t200_cl USING g_adf_rowid
            IF STATUS THEN
               CALL cl_err("OPEN t200_cl:", STATUS, 1)
               CLOSE t200_cl
               ROLLBACK WORK
               RETURN
            END IF
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_adf.adf01,SQLCA.sqlcode,0)
                CLOSE t200_cl ROLLBACK WORK RETURN
            END IF
            FETCH t200_cl INTO g_adf.*
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_adg_t.* = g_adg[l_ac].*
               OPEN t200_bcl USING g_adg_t.adg02,g_adf.adf01
               IF STATUS THEN
                  CALL cl_err("OPEN t200_bcl:", STATUS, 1)
                  LET l_lock_sw='Y'
               ELSE
                  FETCH t200_bcl INTO g_adg[l_ac].*
                  IF SQLCA.sqlcode THEN
                      CALL cl_err(g_adg_t.adg02,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

      BEFORE FIELD adg13
            IF NOT cl_null(g_adg[l_ac].adg02) THEN
                IF cl_null(g_adg[l_ac].adg13) THEN
                    LET g_adg[l_ac].adg13 ='1'
                END IF
                IF cl_null(g_adg[l_ac].adg15) THEN
                    LET g_adg[l_ac].adg15 = 0
                END IF
                LET g_adg[l_ac].adg16 = g_adg[l_ac].adg15 *
                                        g_adg[l_ac].adg12
            END IF
            CALL t200_set_entry_b(p_cmd)

      AFTER FIELD adg13
            CALL t200_set_no_entry_b(p_cmd)

      AFTER FIELD adg14
            IF g_adg[l_ac].adg13 = '4' THEN
               IF cl_null(g_adg[l_ac].adg14) THEN
                   CALL cl_err('','axd-050',0)
                   NEXT FIELD adg14
               END IF
               IF g_adg[l_ac].adg14 >=100 OR
                  g_adg[l_ac].adg14 < 0 THEN
                   CALL cl_err('','axd-050',0)
                   NEXT FIELD adg14
               END IF
            END IF

       AFTER FIELD adg15
            LET g_adg[l_ac].adg16 = g_adg[l_ac].adg15 * g_adg[l_ac].adg12
            #------MOD-5A0095 START----------
            DISPLAY BY NAME g_adg[l_ac].adg16
            #------MOD-5A0095 END------------

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_adg[l_ac].* = g_adg_t.*
               CLOSE t200_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_adg[l_ac].adg02,-263,1)
               LET g_adg[l_ac].* = g_adg_t.*
            ELSE
     UPDATE adg_file
SET adg13=g_adg[l_ac].adg13,adg14=g_adg[l_ac].adg14,
    adg15=g_adg[l_ac].adg15,adg16=g_adg[l_ac].adg16
    WHERE CURRENT OF t200_bcl
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_adg[l_ac].adg02,SQLCA.sqlcode,0)
                  LET g_adg[l_ac].* = g_adg_t.*
               ELSE
                  SELECT * INTO l_adf.* FROM adf_file
                   WHERE adf01=g_adf.adf01
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('select adf',SQLCA.sqlcode,0)
                  END IF
                  SELECT * INTO l_adg.* FROM adg_file
                   WHERE adg01=g_adf.adf01 AND adg02=g_adg[l_ac].adg02
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('select adg',SQLCA.sqlcode,0)
                  END IF
                  CALL t200_adi()
                  CALL p201(l_adf.*,l_adg.*,YEAR(g_adf.adf09),MONTH(g_adf.adf09),'2')
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
             END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_adg[l_ac].* = g_adg_t.*
               END IF
               CLOSE t200_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE t200_bcl
            COMMIT WORK

        ON ACTION CONTROLN
            CALL t200_b_askkey()
            EXIT INPUT
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

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

    CLOSE t200_bcl
    COMMIT WORK
END FUNCTION

FUNCTION t200_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(200)
    CONSTRUCT l_wc2 ON adg02,adg05,adg06,adg07,
                       adg09,adg10,adg11,adg12,
                       adg13,adg14,adg15,adg16
            FROM s_adg[1].adg02,s_adg[1].adg05,s_adg[1].adg08,
                 s_adg[1].adg06,s_adg[1].adg07,s_adg[1].adg09,
                 s_adg[1].adg10,s_adg[1].adg11,s_adg[1].adg12,
                 s_adg[1].adg13,s_adg[1].adg14,s_adg[1].adg15,
                 s_adg[1].adg16

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

    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL t200_b_fill(l_wc2)
END FUNCTION

FUNCTION t200_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(200)

    LET g_sql =
        "SELECT adg02,adg05,adg08,adg06,adg07,adg09,",
        "       adg10,adg11,adg12,adg13,adg14,adg15,adg16",
        "  FROM adg_file",
        " WHERE adg01 ='",g_adf.adf01,"'",
        "   AND ",p_wc2 CLIPPED,
        " ORDER BY adg02,adg05,adg10"
    PREPARE t200_pb FROM g_sql
    DECLARE adg_cs
        CURSOR FOR t200_pb

    #單身 ARRAY 乾洗
    CALL g_adg.clear()
    LET g_cnt = 1
    FOREACH adg_cs INTO g_adg[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_adg.deleteElement(g_cnt)

    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
    LET g_cnt = 0
END FUNCTION

FUNCTION t200_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_adg TO s_adg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL t200_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION previous
         CALL t200_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION jump
         CALL t200_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION next
         CALL t200_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION last
         CALL t200_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---

 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION

FUNCTION t200_adi()
DEFINE l_adi10 LIKE adi_file.adi10,
       l_adi11 LIKE adi_file.adi11,
       l_adi12 LIKE adi_file.adi12,
       l_azp03 LIKE azp_file.azp03

    SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01= g_adg[l_ac].adg09

    LET l_adi11 = g_adg[l_ac].adg13
    LET l_adi12 = g_adg[l_ac].adg14
    IF cl_null(l_adi11) THEN LET l_adi11=' ' END IF
    LET g_sql = " UPDATE ",l_azp03 CLIPPED,
                ".adi_file SET adi11 = '",l_adi11,"',"
    IF cl_null(l_adi12) THEN
       LET g_sql=g_sql CLIPPED," adi12=NULL"
    ELSE
       LET g_sql=g_sql CLIPPED," adi12=",l_adi12
    END IF
    LET g_sql=g_sql CLIPPED,"  WHERE adi03 = '",g_adf.adf01,
                "'   AND adi04 = ",g_adg[l_ac].adg02
    PREPARE t200_prepare6 FROM g_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('update adi',SQLCA.sqlcode,0)
    END IF
    EXECUTE t200_prepare6
    IF SQLCA.sqlcode THEN
       CALL cl_err('update adi',SQLCA.sqlcode,0)
    END IF
END FUNCTION

FUNCTION t200_adf00()
 DEFINE gmsg  LIKE type_file.chr8              #No.FUN-680108 VARCHAR(8) 

 CASE g_adf.adf00
     WHEN '1' LET  gmsg = cl_getmsg('axd-082',g_lang)
     WHEN '2' LET  gmsg = cl_getmsg('axd-083',g_lang)
     WHEN '3' LET  gmsg = cl_getmsg('axd-084',g_lang)
 END CASE
DISPLAY gmsg TO FORMONLY.e
END FUNCTION

FUNCTION t200_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)
 
      CALL cl_set_comp_entry("adg14,adg15",TRUE)
 
END FUNCTION
 
FUNCTION t200_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)
 
      CASE g_adg[l_ac].adg13
           WHEN '1' INITIALIZE g_adg[l_ac].adg14 TO NULL
                    LET g_adg[l_ac].adg15 = 0
                    LET g_adg[l_ac].adg16 = g_adg[l_ac].adg15 * g_adg[l_ac].adg12
                    CALL cl_set_comp_entry("adg14,adg15",FALSE)
           WHEN '2' INITIALIZE g_adg[l_ac].adg14 TO NULL
                    LET g_adg[l_ac].adg15 = 0
                    LET g_adg[l_ac].adg16 = g_adg[l_ac].adg15 * g_adg[l_ac].adg12
                    CALL cl_set_comp_entry("adg14,adg15",FALSE)
           WHEN '3' INITIALIZE g_adg[l_ac].adg14 TO NULL
                    CALL cl_set_comp_entry("adg14",FALSE)
           WHEN '4' LET g_adg[l_ac].adg15 = 0
                    LET g_adg[l_ac].adg16 = g_adg[l_ac].adg15 * g_adg[l_ac].adg12
                    CALL cl_set_comp_entry("adg15",FALSE)
      END CASE
 
END FUNCTION
#Patch....NO:MOD-5A0095 <001> #
#Patch....NO:TQC-610037 <001,002> #
