# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aeci625.4gl
# Descriptions...: 作業資料描述說明維護作業
# Date & Author..: 91/11/18 By Nora
# Modify.........: No.FUN-4B0012 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-4C0034 04/12/07 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-51003205/01/17 By pengu 報表轉XML
# Modify.........: No.FUN-660091 05/06/15 By hellen cl_err --> cl_err3
# Modify.........: No.FUN-680073 06/08/21 By hongmei 欄位型態轉換
# Modify.........: No.FUN-6A0039 06/10/25 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.CHI-790004 07/09/03 By kim 新增段PK值不可為NULL
# Modify.........: No.TQC-7B0032 07/11/06 By Carrier _q()中清g_ecd前要加入g_flag的判斷
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   離開MAIN時沒有cl_used(1)和cl_used(2)
# Modify.........: No.FUN-C30190 12/03/28 By xumeimei 原報表轉CR報表
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_ecd           RECORD
                    ecd01    LIKE ecd_file.ecd01, #作業編號
                    ecd02    LIKE ecd_file.ecd02,
                    ecduser  LIKE ecd_file.ecduser,    #FUN-4C0034
                    ecdgrup  LIKE ecd_file.ecdgrup     #FUN-4C0034
                    END RECORD,
    g_ecz           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        ecz04       LIKE ecz_file.ecz04,   #行序
        ecz05       LIKE ecz_file.ecz05    #說明
                    END RECORD,
    g_ecz_t         RECORD                 #程式變數 (舊值)
        ecz04       LIKE ecz_file.ecz04,   #行序
        ecz05       LIKE ecz_file.ecz05    #說明
                    END RECORD,
   #g_wc,g_wc2,g_sql    VARCHAR(300)          #TQC-630166    
    g_wc,g_wc2,g_sql    STRING,            #TQC-630166        
    g_flag          LIKE type_file.chr1,   #No.FUN-680073 VARCHAR(1) VARCHAR(1)
    g_rec_b         LIKE type_file.num5,   #單身筆數        #No.FUN-680073 SMALLINT
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT        #No.FUN-680073 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql         STRING                       #SELECT ... FOR UPDATE SQL       
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680073 SMALLINT
 
 
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_i            LIKE type_file.num5          #count/index for any purpose #No.FUN-680073 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000       #No.FUN-680073 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680073 SMALLINT
DEFINE   l_table        STRING                       #No.FUN-C30190
DEFINE   g_str          STRING                       #No.FUN-C30190

MAIN
DEFINE
#       l_time    LIKE type_file.chr8            #No.FUN-6A0100
    p_row,p_col   LIKE type_file.num5          #No.FUN-680073 SMALLINT SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211 
   #FUN-C30190---add---Begin
   LET g_sql = "ecd01.ecd_file.ecd01,",
               "ecdacti.ecd_file.ecdacti,",
               "ecz04.ecz_file.ecz04,",
               "ecz05.ecz_file.ecz05"

   LET l_table = cl_prt_temptable('aeci625',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   #FUN-C30190---add---End
   LET g_ecd.ecd01  = ARG_VAL(1)           #作業編號
 
   LET p_row = 4 LET p_col = 36
   OPEN WINDOW i625_w AT p_row,p_col   #顯示畫面
        WITH FORM "aec/42f/aeci625"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
   IF g_ecd.ecd01 IS NOT NULL AND g_ecd.ecd01 != ' ' THEN
      LET g_flag = 'Y'
      CALL i625_q()
   ELSE
      LET g_flag = 'N'
   END IF
 
   CALL i625_menu()
 
   CLOSE WINDOW i625_w                 #結束畫面
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
         RETURNING g_time    #No.FUN-6A0100
END MAIN
 
#QBE 查詢資料
FUNCTION i625_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_ecz.clear()
 
    IF g_flag = 'N'  THEN  #參數是否有值
       CALL cl_set_head_visible("","YES")        #No.FUN-6B0029
 
   INITIALIZE g_ecd.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON ecd01,ecd02     # 螢幕上取單頭條件
 
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
       END CONSTRUCT
    ELSE
       LET g_wc = " ecd01 ='",g_ecd.ecd01,"'"
    END IF
    IF INT_FLAG THEN RETURN END IF
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND ecduser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND ecdgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND ecdgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ecduser', 'ecdgrup')
    #End:FUN-980030
 
 
    IF g_flag = 'N'  THEN  #參數是否有值
      CONSTRUCT g_wc2 ON ecz04,ecz05                # 螢幕上取單身條件
             FROM s_ecz[1].ecz04,s_ecz[1].ecz05
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
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
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
      IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    ELSE
      LET g_wc2=" 1=1"
    END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT ecd01 FROM ecd_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY ecd01"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE ecd01",
                   " FROM ecd_file, ecz_file ",
                   " WHERE ecd01 = ecz01",
                   " AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY ecd01"
    END IF
 
    PREPARE i625_prepare FROM g_sql
    DECLARE i625_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i625_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM ecd_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT UNIQUE COUNT(*) ",
                  " FROM ecd_file,ecz_file WHERE ",
                  " ecd01=ecz01 ",
                  " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i625_precount FROM g_sql
    DECLARE i625_count CURSOR FOR i625_precount
 
END FUNCTION
 
FUNCTION i625_menu()
 
   WHILE TRUE
      CALL i625_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i625_q()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i625_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i625_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i625_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#FUN-4B0012
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ecz),'','')
            END IF
##
 
         #No.FUN-6A0039-------add--------str----
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_ecd.ecd01 IS NOT NULL THEN
                 LET g_doc.column1 = "ecd01"
                 LET g_doc.value1 = g_ecd.ecd01
                 CALL cl_doc()
               END IF
           END IF
         #No.FUN-6A0039-------add--------end----
 
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION i625_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    #No.TQC-7B0032  --Begin
    IF g_flag = 'N'  THEN  #參數是否有值
       INITIALIZE g_ecd.* TO NULL             #No.FUN-6A0039
    END IF
    #No.TQC-7B0032  --End  
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_ecz.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i625_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    OPEN i625_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_ecd.* TO NULL
    ELSE
       OPEN i625_count
       FETCH i625_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL i625_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i625_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680073 VARCHAR(1) VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680073 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i625_cs INTO g_ecd.ecd01
        WHEN 'P' FETCH PREVIOUS i625_cs INTO g_ecd.ecd01
        WHEN 'F' FETCH FIRST    i625_cs INTO g_ecd.ecd01
        WHEN 'L' FETCH LAST     i625_cs INTO g_ecd.ecd01
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
            FETCH ABSOLUTE g_jump i625_cs INTO g_ecd.ecd01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       LET g_msg=g_ecd.ecd01 CLIPPED
       CALL cl_err(g_msg,SQLCA.sqlcode,0)
       INITIALIZE g_ecd.* TO NULL  #TQC-6B0105
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
    SELECT ecd01,ecd02,ecduser,ecdgrup INTO g_ecd.*
           FROM ecd_file WHERE ecd01 = g_ecd.ecd01
    IF SQLCA.sqlcode THEN
       LET g_msg=g_ecd.ecd01 CLIPPED
#      CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660091
       CALL cl_err3("sel","ecd_file",g_ecd.ecd01,"",SQLCA.sqlcode,"","",1) #FUN-660091
       INITIALIZE g_ecd.* TO NULL
       RETURN
#FUN-4C0034
    ELSE
       LET g_data_owner = g_ecd.ecduser      #FUN-4C0034
       LET g_data_group = g_ecd.ecdgrup      #FUN-4C0034
       CALL i625_show()                      # 重新顯示
    END IF
##
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i625_show()
    DISPLAY BY NAME g_ecd.ecd01,g_ecd.ecd02  # 顯示單頭值
    CALL i625_b_fill(g_wc2)                  #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i625_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680073 SMALLINT SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680073 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680073 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680073 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680073 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680073 SMALLINT
 
    LET g_action_choice = ""
 
    IF g_ecd.ecd01 IS NULL THEN
       RETURN
    END IF
 
    IF s_shut(0) THEN RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT ecz04,ecz05 FROM ecz_file ",
                       " WHERE ecz01= ? AND ecz04= ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i625_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_ecz WITHOUT DEFAULTS FROM s_ecz.*
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
            LET l_n  = ARR_COUNT()
 
 
            IF g_rec_b >= l_ac THEN
 
               BEGIN WORK
 
               LET p_cmd='u'
               LET g_ecz_t.* = g_ecz[l_ac].*  #BACKUP
 
               OPEN i625_bcl USING g_ecd.ecd01,g_ecz_t.ecz04
               IF STATUS THEN
                  CALL cl_err("OPEN i625_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i625_bcl INTO g_ecz[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ecz_t.ecz04,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ecz[l_ac].* TO NULL      #900423
            LET g_ecz_t.* = g_ecz[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD ecz04
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
 
            INSERT INTO ecz_file(ecz01,ecz02,ecz04,ecz05)
                          VALUES(g_ecd.ecd01,g_today,  #CHI-790004 NULL->g_today
                                 g_ecz[l_ac].ecz04,g_ecz[l_ac].ecz05)
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_ecz[l_ac].ecz04,SQLCA.sqlcode,0) #No.FUN-660091
               CALL cl_err3("ins","ecz_file",g_ecd.ecd01,g_ecz[l_ac].ecz04,SQLCA.sqlcode,"","",1) #FUN-660091
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE FIELD ecz04                        #default 序號
            IF g_ecz[l_ac].ecz04 IS NULL OR
               g_ecz[l_ac].ecz04 = 0 THEN
               SELECT max(ecz04)+1 INTO g_ecz[l_ac].ecz04 FROM ecz_file
                WHERE ecz01 = g_ecd.ecd01
               #若為第一次輸入,則其值為1
               IF g_ecz[l_ac].ecz04 IS NULL THEN
                  LET g_ecz[l_ac].ecz04 = 1
               END IF
            END IF
 
        AFTER FIELD ecz04                        #check 序號是否重複
            IF NOT cl_null(g_ecz[l_ac].ecz04) THEN
               IF g_ecz[l_ac].ecz04 != g_ecz_t.ecz04 OR
                  g_ecz_t.ecz04 IS NULL THEN
                  SELECT count(*) INTO l_n FROM ecz_file
                   WHERE ecz01 = g_ecd.ecd01
                     AND ecz04 = g_ecz[l_ac].ecz04
                  IF l_n > 0 THEN
                     CALL cl_err(g_ecz[l_ac].ecz04,-239,0)
                     LET g_ecz[l_ac].ecz04 = g_ecz_t.ecz04
                     NEXT FIELD ecz04
                  END IF
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_ecz_t.ecz04 > 0 AND
               g_ecz_t.ecz04 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
 
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
 
               DELETE FROM ecz_file
                WHERE ecz01 = g_ecd.ecd01
                  AND ecz04 = g_ecz_t.ecz04
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_ecz_t.ecz04,SQLCA.sqlcode,0) #No.FUN-660091
                  CALL cl_err3("del","ecz_file",g_ecd.ecd01,g_ecz_t.ecz04,SQLCA.sqlcode,"","",1) #FUN-660091
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
 
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
 
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ecz[l_ac].* = g_ecz_t.*
               CLOSE i625_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ecz[l_ac].ecz04,-263,1)
               LET g_ecz[l_ac].* = g_ecz_t.*
            ELSE
               UPDATE ecz_file SET ecz04=g_ecz[l_ac].ecz04,
                                   ecz05=g_ecz[l_ac].ecz05
                WHERE ecz01=g_ecd.ecd01
                  AND ecz04=g_ecz_t.ecz04
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_ecz[l_ac].ecz04,SQLCA.sqlcode,0) #No.FUN-660091
                  CALL cl_err3("upd","ecz_file",g_ecd.ecd01,g_ecz_t.ecz04,SQLCA.sqlcode,"","",1) #FUN-660091
                  LET g_ecz[l_ac].* = g_ecz_t.*
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_ecz[l_ac].* = g_ecz_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_ecz.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i625_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i625_bcl
            COMMIT WORK
 
#       ON ACTION CONTROLN
#          CALL i625_b_askkey()
#          EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(ecz04) AND l_ac > 1 THEN
              LET g_ecz[l_ac].* = g_ecz[l_ac-1].*
              DISPLAY g_ecz[l_ac].* TO s_ecz[l_ac].*
              NEXT FIELD ecz04
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
 
    CLOSE i625_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i625_b_askkey()
DEFINE
   #l_wc2           VARCHAR(200) #TQC-630166     
    l_wc2           STRING    #TQC-630166     
 
    CONSTRUCT l_wc2 ON ecz04,ecz05
            FROM s_ecz[1].ecz04,s_ecz[1].ecz05
 
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
       LET INT_FLAG = 0
       RETURN
    END IF
    CALL i625_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i625_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   #p_wc2           VARCHAR(200) #TQC-630166    
    p_wc2           STRING    #TQC-630166    
 
    LET g_sql = "SELECT ecz04,ecz05 FROM ecz_file",
                " WHERE ecz01 ='",g_ecd.ecd01,"' AND",  #作業編號
                 p_wc2 CLIPPED,                     #單身
                " ORDER BY 1"
    PREPARE i625_pb FROM g_sql
    DECLARE ecz_cs                       #SCROLL CURSOR
        CURSOR FOR i625_pb
 
    CALL g_ecz.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH ecz_cs INTO g_ecz[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
 
        LET g_cnt = g_cnt + 1
 
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_ecz.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i625_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ecz TO s_ecz.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL i625_fetch('F')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i625_fetch('P')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i625_fetch('/')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i625_fetch('N')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i625_fetch('L')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
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
         EXIT DISPLAY
 
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
 
 
#FUN-4B0012
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##
 
     ON ACTION related_document                #No.FUN-6A0039  相關文件
        LET g_action_choice="related_document"          
        EXIT DISPLAY 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i625_copy()
DEFINE
    l_newno1         LIKE ecd_file.ecd01,
    l_oldno1         LIKE ecd_file.ecd01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ecd.ecd01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
    INPUT l_newno1 FROM ecd01
        AFTER FIELD ecd01
            IF NOT cl_null(l_newno1) THEN
               #檢查欲複製之單頭資料是否存在
               SELECT ecd01 FROM ecd_file
                      WHERE ecd01 = l_newno1
               IF SQLCA.sqlcode THEN
#                 CALL cl_err('','mfg4049',0) #No.FUN-660091
                  CALL cl_err3("sel","ecd_file",l_newno1,"","mfg4049","","",1) #FUN-660091
                  NEXT FIELD ecd01
               END IF
               #檢查單身是否己存在
               SELECT count(*) INTO g_cnt FROM ecz_file
                WHERE ecz01 = l_newno1
               IF g_cnt > 0 THEN
                  LET g_msg = l_newno1 CLIPPED
                  CALL cl_err(g_msg,'mfg0020',0)
                  LET l_newno1 = NULL
                  DISPLAY l_newno1 TO ecd01
                  NEXT FIELD ecd01
               END IF
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
       DISPLAY BY NAME g_ecd.ecd01
       RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM ecz_file         #單身複製
        WHERE ecz01=g_ecd.ecd01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
       LET g_msg=g_ecd.ecd01 CLIPPED
#      CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660091
       CALL cl_err3("ins","x",g_ecd.ecd01,"",SQLCA.sqlcode,"","",1) #FUN-660091
       RETURN
    END IF
 
    UPDATE x
        SET ecz01=l_newno1, ecz02=g_today #CHI-790004 NULL->g_today
    INSERT INTO ecz_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
       LET g_msg=g_ecd.ecd01 CLIPPED
#      CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660091
       CALL cl_err3("ins","ecz_file",g_ecd.ecd01,"",SQLCA.sqlcode,"","",1) #FUN-660091
       RETURN
    END IF
 
    LET g_msg=l_newno1 CLIPPED
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
 
    LET l_oldno1 = g_ecd.ecd01
    SELECT ecd01,ecd02 INTO g_ecd.* FROM ecd_file
           WHERE ecd01 =  l_newno1
    CALL i625_show()
 
    CALL  i625_b()
    #FUN-C30027---begin
    #LET g_ecd.ecd01 = l_oldno1
    #SELECT ecd01 INTO g_ecd.* FROM ecd_file
    #       WHERE ecd01 = g_ecd.ecd01
    #CALL i625_show()
    #FUN-C30027---end
    DISPLAY BY NAME g_ecd.ecd01
END FUNCTION
 
FUNCTION i625_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680073 SMALLINT
    sr              RECORD
        ecd01       LIKE ecd_file.ecd01,   #作業編號
        ecdacti     LIKE ecd_file.ecdacti,
        ecz04       LIKE ecz_file.ecz04,   #行序
        ecz05       LIKE ecz_file.ecz05    #說明
                    END RECORD,
    l_name          LIKE type_file.chr20,    # No.FUN-680073 VARCHAR(20), #External(Disk) file name
    l_za05          LIKE type_file.chr1000   # No.FUN-680073 VARCHAR(40)
DEFINE l_sql    LIKE type_file.chr1000   #FUN-C30190
 
    IF g_wc IS NULL THEN
    #   CALL cl_err('',-400,0)
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
#   LET l_name = 'aeci625.out'
    #FUN-C30190---add---Str
    CALL cl_del_data(l_table)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   
    #FUN-C30190---add---End
    #CALL cl_outnam('aeci625') RETURNING l_name         #FUN-C30190 mark
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT ecd01,ecdacti,ecz04,ecz05 ",
          " FROM ecd_file,ecz_file ",
          " WHERE ecz01=ecd01 ",
          " AND ",g_wc CLIPPED,
          " AND ",g_wc2 CLIPPED
    PREPARE i625_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i625_co                         # SCROLL CURSOR
        CURSOR FOR i625_p1
 
    #START REPORT i625_rep TO l_name                    #FUN-C30190 mark
 
    FOREACH i625_co INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
           END IF
        #OUTPUT TO REPORT i625_rep(sr.*)                #FUN-C30190 mark
        EXECUTE  insert_prep  USING sr.*                #FUN-C30190 add
    END FOREACH
 
    #FINISH REPORT i625_rep                             #FUN-C30190 mark
 
    CLOSE i625_co
    ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)                  #FUN-C30190 mark
    #FUN-C30190-----add---str----
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED," ORDER BY ecd01,ecz04"
    LET g_str = " 1=1"
    CALL cl_prt_cs3("aeci625","aeci625",l_sql,g_str)
    #FUN-C30190-----add---end----
END FUNCTION
 
#FUN-C30190-----mark-----str----- 
#REPORT i625_rep(sr)
#DEFINE
#    l_trailer_sw    LIKE type_file.chr1,   #No.FUN-680073 VARCHAR(1)
#    l_i             LIKE type_file.num5,   #No.FUN-680073 SMALLINT
#    sr              RECORD
#        ecd01       LIKE ecd_file.ecd01,   #作業編號
#        ecdacti     LIKE ecd_file.ecdacti, #
#        ecz04       LIKE ecz_file.ecz04,   #行序
#        ecz05       LIKE ecz_file.ecz05    #說明
#                    END RECORD
# 
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
# 
#    ORDER BY sr.ecd01
# 
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
# 
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
# 
#        BEFORE GROUP OF sr.ecd01
#            IF sr.ecdacti = 'N' THEN PRINT COLUMN g_c[31],'*'; END IF
#            PRINT COLUMN g_c[32],sr.ecd01;
# 
#        ON EVERY ROW
#            PRINT COLUMN g_c[33],sr.ecz04 using '###&',
#                  COLUMN g_c[34],sr.ecz05
# 
#        AFTER GROUP OF sr.ecd01
#            SKIP 1 LINE
# 
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#               THEN#IF g_wc[001,080] > ' ' THEN
#		   #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
#                   #IF g_wc[071,140] > ' ' THEN
#		   #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
#                   #IF g_wc[141,210] > ' ' THEN
#		   #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
#                    CALL cl_prt_pos_wc(g_wc) #TQC-630166
#                    PRINT g_dash[1,g_len]
#            END IF
#            LET l_trailer_sw = 'n'
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#FUN-C30190-----mark-----end-----
