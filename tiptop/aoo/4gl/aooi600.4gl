# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: aooi600.4gl
# Descriptions...: 集團中心資料維護
# Date & Author..: 06/03/15 By Joe
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-780056 07/06/29 By mike 報表格式修改為p_query
# Modify.........: No.FUN-7C0010 07/12/04 By Carrier 增加ACTION "資料類型設置","拋轉設置"
# Modify.........: No.TQC-930058 09/03/10 By rainy update資料中心代碼時，沒有一併update資料控管維護檔
# Modify.........: No.FUN-870100 09/06/01 BY lala add geu00-->8 deliver center
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.MOD-B30171 11/03/14 by shenyang 
# Modify.........: No:FUN-B80035 11/08/03 By Lujh 模組程序撰寫規範修正
# Modify.........: No:CHI-B60098 13/04/03 By Alberti 新增 geu00 為 KEY 值
# Modify.........: No:FUN-D40030 13/04/08 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D80066 13/09/16 By fengmy 查詢會出現錯誤訊息(30追单)
# Modify.........: No:MOD-D90075 13/09/16 By fengmy 單身鎖不只鎖geu00='1'的資料

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     g_geu          DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        geu00       LIKE geu_file.geu00,   #集團中心類別
        geu01       LIKE geu_file.geu01,   #集團中心代碼
        geu02       LIKE geu_file.geu02,   #集團中心名稱
        geuacti     LIKE type_file.chr1           #No.FUN-680102CHAR(1)
                    END RECORD,
    g_geu_t         RECORD                 #程式變數 (舊值)
        geu00       LIKE geu_file.geu00,   #集團中心類別
        geu01       LIKE geu_file.geu01,   #集團中心代碼
        geu02       LIKE geu_file.geu02,   #集團中心名稱
        geuacti     LIKE type_file.chr1           #No.FUN-680102CHAR(1)
                    END RECORD,
        g_wc2,g_sql STRING,
        g_rec_b     LIKE type_file.num5,                #單身筆數        #No.FUN-680102 SMALLINT
        l_ac        LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680102 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt      LIKE type_file.num10            #No.FUN-680102 INTEGER
DEFINE g_before_input_done   LIKE type_file.num5        #FUN-570110         #No.FUN-680102 SMALLINT
DEFINE   g_i        LIKE type_file.num5     #count/index for any purpose        #No.FUN-680102 SMALLINT
MAIN
#     DEFINEl_time LIKE type_file.chr8           #No.FUN-6A0081
DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680102 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
       LET p_row = 4 LET p_col = 20
   OPEN WINDOW i600_w AT p_row,p_col WITH FORM "aoo/42f/aooi600"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   LET g_wc2 = '1=1' CALL i600_b_fill(g_wc2)
   CALL i600_menu()
   CLOSE WINDOW i600_w                 #結束畫面
   CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN
 
FUNCTION i600_menu()
  DEFINE l_cmd STRING                                  #No.FUN-780056
   WHILE TRUE
      CALL i600_bp("G")
      CASE g_action_choice
         WHEN "query"       # 查詢
            IF cl_chk_act_auth() THEN
               CALL i600_q()
            END IF
         WHEN "detail"      # 單身
            IF cl_chk_act_auth() THEN
               CALL i600_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"      # 列印
            IF cl_chk_act_auth() THEN
               #CALL i600_out()                                   #No.FUN-780056
               IF cl_null(g_wc2) THEN LET g_wc2='1=1' END IF      #No.FUN-780056
               LET l_cmd='p_query "aooi600" "',g_wc2 CLIPPED,'"'  #No.FUN-780056
               CALL cl_cmdrun(l_cmd)                              #No.FUN-780056
            END IF
         #No.FUN-7C0010  --Begin
         WHEN "data_type_setting"
            IF cl_chk_act_auth() THEN
               IF l_ac > 0 THEN
                  IF g_geu[l_ac].geu00 = '1' THEN
               #     CALL i600_data_type_setting()    #MOD-B30171
                     CALL i6001(g_geu[l_ac].geu01)
                  ELSE
                     CALL cl_err(g_geu[l_ac].geu01,'aoo-046',0)
                  END IF
               END IF
            END IF
         WHEN "carry_setting"
            IF cl_chk_act_auth() THEN
               IF l_ac > 0 THEN
                  IF g_geu[l_ac].geu00 = '1' THEN
                     LET l_cmd='aooi602 "',g_geu[l_ac].geu01,'"'
                     CALL cl_cmdrun(l_cmd)
                  ELSE
                     CALL cl_err(g_geu[l_ac].geu01,'aoo-046',0)
                  END IF
               END IF
            END IF
         #No.FUN-7C0010  --End
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"        # 離開
            EXIT WHILE
         WHEN "controlg"    # 執行
            CALL cl_cmdask()
         WHEN "related_document"  # 相關文件
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_geu[l_ac].geu01 IS NOT NULL THEN
                  LET g_doc.column1 = "geu01"
                  LET g_doc.value1 = g_geu[l_ac].geu01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"     # 轉Excel檔
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_geu),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i600_q()
   CALL i600_b_askkey()
END FUNCTION
 
FUNCTION i600_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680102 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,           #No.FUN-680102   VARCHAR(1),         #可新增否
    l_allow_delete  LIKE type_file.chr1            #No.FUN-680102   VARCHAR(1)            #可刪除否
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT geu00,geu01,geu02,geuacti",
                      #"  FROM geu_file WHERE geu01=? FOR UPDATE"               #CHI-B60098 mark
                      #"  FROM geu_file WHERE geu01=? AND gue00=? FOR UPDATE"   #CHI-B60098 add  #MOD-D80066 mark
                       "  FROM geu_file WHERE geu01=? AND geu00=? FOR UPDATE"   #MOD-D80066
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i600_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_geu WITHOUT DEFAULTS FROM s_geu.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()          # 現在游標是在陣列的第幾筆
            LET l_lock_sw = 'N'            # DEFAULT
            LET l_n  = ARR_COUNT()         # 陣列總數有幾筆
            IF g_rec_b >= l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_geu_t.* = g_geu[l_ac].*  #BACKUP
               LET g_before_input_done = FALSE
               CALL i600_set_entry(p_cmd)
               CALL i600_set_no_entry(p_cmd)
               LET g_before_input_done = TRUE
              #OPEN i600_bcl USING g_geu_t.geu01                            #CHI-B60098 mark
              #OPEN i600_bcl USING g_geu_t.geu01,'1'                        #CHI-B60098 add  #MOD-D90075 mark
               OPEN i600_bcl USING g_geu_t.geu01,g_geu_t.geu00              #MOD-D90075 add  
               IF STATUS THEN
                  CALL cl_err("OPEN i600_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i600_bcl INTO g_geu[l_ac].*
                  IF SQLCA.sqlcode THEN
                      CALL cl_err(g_geu_t.geu01,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET g_before_input_done = FALSE
            CALL i600_set_entry(p_cmd)
            CALL i600_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            INITIALIZE g_geu[l_ac].* TO NULL
            LET g_geu[l_ac].geuacti = 'Y'         #Body default
            LET g_geu_t.* = g_geu[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()
            NEXT FIELD geu00
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i600_bcl
              CANCEL INSERT
           END IF
           INSERT INTO geu_file(geu00,geu01,geu02,geuacti,geuuser,geudate,geuoriu,geuorig)
           VALUES(g_geu[l_ac].geu00,g_geu[l_ac].geu01,
                  g_geu[l_ac].geu02,g_geu[l_ac].geuacti,
                  g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_geu[l_ac].geu01,SQLCA.sqlcode,0)   #No.FUN-660131
              CALL cl_err3("ins","geu_file",g_geu[l_ac].geu01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b = g_rec_b + 1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        AFTER FIELD geu01                        #check 集團中心代碼是否重複
            IF NOT cl_null(g_geu[l_ac].geu01) THEN
               IF g_geu[l_ac].geu01 != g_geu_t.geu01 OR g_geu_t.geu01 IS NULL THEN
                  SELECT count(*) INTO g_cnt FROM geu_file
                   WHERE geu01 = g_geu[l_ac].geu01
                  IF g_cnt > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_geu[l_ac].geu01 = g_geu_t.geu01
                     NEXT FIELD geu01
                  END IF
                  DISPLAY 'SELECT COUNT OK'
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_rec_b>=l_ac THEN
               IF g_cnt = 0 THEN
                  IF NOT cl_delete() THEN
                     CANCEL DELETE
                  END IF
                  INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
                  LET g_doc.column1 = "geu01"               #No.FUN-9B0098 10/02/24
                  LET g_doc.value1 = g_geu[l_ac].geu01      #No.FUN-9B0098 10/02/24
                  CALL cl_del_doc()                                                #No.FUN-9B0098 10/02/24
                  IF l_lock_sw = "Y" THEN
                     CALL cl_err("", -263, 1)
                     CANCEL DELETE
                  END IF
                  DELETE FROM geu_file WHERE geu01 = g_geu_t.geu01
                  IF SQLCA.sqlcode THEN
#                    CALL cl_err(g_geu_t.geu01,SQLCA.sqlcode,0)   #No.FUN-660131
                     CALL cl_err3("del","geu_file",g_geu_t.geu01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                     EXIT INPUT
                  END IF
                  #No.FUN-7C0010  --Begin
                  #delete gew/gez_file
                  DISPLAY "delete gev/gew/gez_file"
                  DELETE FROM gev_file WHERE gev04 = g_geu_t.geu01
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","gev_file",g_geu_t.geu01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                     EXIT INPUT
                  END IF
                  DELETE FROM gew_file WHERE gew01 = g_geu_t.geu01
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","gew_file",g_geu_t.geu01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                     EXIT INPUT
                  END IF
                  DELETE FROM gez_file WHERE gez01 = g_geu_t.geu01
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","gez_file",g_geu_t.geu01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                     EXIT INPUT
                  END IF
 
                  #No.FUN-7C0010  --End
                  LET g_rec_b = g_rec_b - 1
                  DISPLAY g_rec_b TO FORMONLY.cn2
                  COMMIT WORK
                ELSE
                  ROLLBACK WORK
                  EXIT INPUT
                END IF
             END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_geu[l_ac].* = g_geu_t.*
              CLOSE i600_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
              CALL cl_err(g_geu[l_ac].geu01,-263,0)
              LET g_geu[l_ac].* = g_geu_t.*
           ELSE
              UPDATE geu_file
                  SET geu00=g_geu[l_ac].geu00,geu01=g_geu[l_ac].geu01,
                      geu02=g_geu[l_ac].geu02,geuacti=g_geu[l_ac].geuacti,
                      geumodu=g_user,geudate=g_today
              #WHERE geu01 = g_geu_t.geu01                            #CHI-B60098 mark
               WHERE geu01 = g_geu_t.geu01 AND geu00 = '1'            #CHI-B60098 add
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_geu[l_ac].geu01,SQLCA.sqlcode,0)   #No.FUN-660131
                 CALL cl_err3("upd","geu_file",g_geu_t.geu01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                 LET g_geu[l_ac].* = g_geu_t.*
              ELSE
                #TQC-930058 有update geu01時，必須udate gev04
                 IF (NOT cl_null(g_geu_t.geu01)) AND (g_geu_t.geu01<>g_geu[l_ac].geu01) THEN
                    UPDATE gev_file
                       SET gev04 = g_geu[l_ac].geu01
                     WHERE gev04 = g_geu_t.geu01
                 END IF
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","gev_file",g_geu_t.geu01,"",SQLCA.sqlcode,"","",1) 
                    LET g_geu[l_ac].* = g_geu_t.*
                 ELSE
                #TQC-930058 end
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
                 END IF  #TQC-930058 add
              END IF
            END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()         # 新增
           #LET l_ac_t = l_ac            # 新增  #FUN-D40030
 
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_geu[l_ac].* = g_geu_t.*
              #FUN-D40030--add--str--
              ELSE
                 CALL g_geu.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D40030--add--end--
              END IF
              CLOSE i600_bcl            # 新增
              ROLLBACK WORK         # 新增
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D40030
           CLOSE i600_bcl            # 新增
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(geu01) AND l_ac > 1 THEN
              LET g_geu[l_ac].* = g_geu[l_ac-1].*
              NEXT FIELD geu01
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION help
           CALL cl_show_help()
 
    END INPUT
 
    CLOSE i600_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i600_b_askkey()
 
    CLEAR FORM
    CALL g_geu.clear()
 
    CONSTRUCT g_wc2 ON geu00,geu01,geu02,geuacti
         FROM s_geu[1].geu00,s_geu[1].geu01,s_geu[1].geu02,s_geu[1].geuacti
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
      ON ACTION qbe_save
	 CALL cl_qbe_save()
 
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('geuuser', 'geugrup') #FUN-980030
 
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL i600_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i600_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680102 VARCHAR(200)
 
    LET g_sql =
        "SELECT geu00,geu01,geu02,geuacti",
        " FROM geu_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
 
    PREPARE i600_pb FROM g_sql
    DECLARE geu_curs CURSOR FOR i600_pb
 
    CALL g_geu.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH geu_curs INTO g_geu[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_geu.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i600_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_geu TO s_geu.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      #No.FUN-7C0010  --Begin
      ON ACTION data_type_setting
         LET g_action_choice="data_type_setting"
         EXIT DISPLAY
 
      ON ACTION carry_setting
         LET g_action_choice="carry_setting"
         EXIT DISPLAY
      #No.FUN-7C0010  --End
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
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
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.FUN-780056 -str
{
FUNCTION i600_out()
    DEFINE
        l_geu           RECORD LIKE geu_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680102 SMALLINT
        l_name          LIKE type_file.chr20,                 # External(Disk) file name        #No.FUN-680102 VARCHAR(20)
        l_za05          LIKE type_file.chr1000                #        #No.FUN-680102 VARCHAR(40)
 
    IF g_wc2 IS NULL THEN
#       CALL cl_err('',-400,0)   #No.TQC-710076
       CALL cl_err('','9057',0)
       RETURN
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM geu_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i600_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i600_co CURSOR FOR i600_p1        # SCROLL CURSOR
    CALL cl_outnam('aooi600') RETURNING l_name
    START REPORT i600_rep TO l_name
 
    FOREACH i600_co INTO l_geu.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        OUTPUT TO REPORT i600_rep(l_geu.*)
    END FOREACH
 
    FINISH REPORT i600_rep
 
    CLOSE i600_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i600_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,           #No.FUN-680102CHAR(1)
        sr RECORD LIKE geu_file.*
 
    OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.geu01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.geu00,
                  COLUMN g_c[32],sr.geu01,
                  COLUMN g_c[33],sr.geu02,
                  COLUMN g_c[34],sr.geuacti
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
#No.FUN-780056 -end
 
FUNCTION i600_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1                                                                 #No.FUN-680102 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("geu01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i600_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1                                                                 #No.FUN-680102 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("geu01",FALSE)
   END IF
 
END FUNCTION
 
#No.FUN-7C0010  --Begin
FUNCTION i600_data_type_setting()
   DEFINE l_gev     DYNAMIC ARRAY OF RECORD
                    gev01     LIKE gev_file.gev01,
                    gev02     LIKE gev_file.gev02
                    END RECORD
   DEFINE l_gev_t   RECORD
                    gev01     LIKE gev_file.gev01,
                    gev02     LIKE gev_file.gev02
                    END RECORD
   DEFINE l_rec_b   LIKE type_file.num5,
          l_cnt     LIKE type_file.num5,
          i         LIKE type_file.num5,
          i_t       LIKE type_file.num5,
          l_n       LIKE type_file.num5,
          l_lock_sw LIKE type_file.chr1,
          p_cmd     LIKE type_file.chr1
DEFINE   g_curs_index   LIKE type_file.num10         #FUN-B30171
DEFINE   g_row_count    LIKE type_file.num10         #FUN-B30171
   IF cl_null(g_geu[l_ac].geu01) THEN
      RETURN
   END IF
   IF cl_null(g_geu[l_ac].geu00) OR g_geu[l_ac].geu00 <> '1' THEN
      RETURN
   END IF
   IF g_geu[l_ac].geuacti <> 'Y' THEN
      RETURN
   END IF
 
   OPEN WINDOW i600_1_w AT 6,26 WITH FORM "aoo/42f/aooi600_1"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("aooi600_1")
 
   LET g_sql = "SELECT gev01,gev02 ",
               "  FROM gev_file ",
               " WHERE gev04 = '",g_geu[l_ac].geu01,"'",
               "   AND gev03 = 'Y'",
               " ORDER BY gev01,gev02 "
 
   PREPARE s_aooi600_1_pre1 FROM g_sql
 
   DECLARE s_aooi600_1_c1 CURSOR FOR s_aooi600_1_pre1
 
   CALL l_gev.clear()
   LET l_cnt = 1
 
   FOREACH s_aooi600_1_c1 INTO l_gev[l_cnt].*
      IF STATUS THEN
         CALL cl_err('foreach gev',STATUS,0)
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
 
   CALL l_gev.deleteElement(l_cnt)
   LET l_rec_b = l_cnt - 1
   LET i = 1
   WHILE TRUE
    CALL cl_set_act_visible("accept,cancel", FALSE)  
   DISPLAY ARRAY l_gev TO s_gev.* ATTRIBUTE(COUNT=l_rec_b,UNBUFFERED)
#      BEFORE ROW
#         EXIT DISPLAY   #FUN-B30171
#FUN-B30171--add--begin
      BEFORE DISPLAY
           CALL cl_navigator_setting(g_curs_index, g_row_count)
      BEFORE ROW
           LET l_ac = ARR_CURR()
           CALL cl_show_fld_cont() 
 
        ON ACTION detail
           LET l_ac = 1
           EXIT DISPLAY
 
        ON ACTION help
           EXIT DISPLAY
 
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont() 
           EXIT DISPLAY
 
        ON ACTION exit
            EXIT WHILE
 
        ON ACTION accept
           EXIT DISPLAY
     
        ON ACTION cancel
           LET INT_FLAG=FALSE 
           EXIT WHILE
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
#FUN-B30171--add--end
   END DISPLAY
   
   CALL cl_set_act_visible("accept,cancel", TRUE)
   LET g_forupd_sql = "SELECT gev01,gev02 ",
                      "  FROM gev_file WHERE gev01=? AND gev02 = ? FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i600_1_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY l_gev WITHOUT DEFAULTS FROM s_gev.*
         ATTRIBUTE (COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW = TRUE,DELETE ROW=TRUE,APPEND ROW=TRUE)
 
       BEFORE INPUT
          IF l_rec_b != 0 THEN
             CALL fgl_set_arr_curr(i)
          END IF
 
       BEFORE ROW
           LET p_cmd=''
           LET i = ARR_CURR()             # 現在游標是在陣列的第幾筆
           LET l_lock_sw = 'N'            # DEFAULT
           LET l_n  = ARR_COUNT()         # 陣列總數有幾筆
           IF l_rec_b >= i THEN
               BEGIN WORK
               LET p_cmd='u'
               LET l_gev_t.* = l_gev[i].*  #BACKUP
               OPEN i600_1_bcl USING l_gev_t.gev01,l_gev_t.gev02
               IF STATUS THEN
                  CALL cl_err("OPEN i600_1_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i600_1_bcl INTO l_gev[i].*
                  IF SQLCA.sqlcode THEN
                      CALL cl_err(l_gev_t.gev01,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE l_gev[i].* TO NULL
            LET l_gev_t.* = l_gev[i].*         #新輸入資料
            CALL cl_show_fld_cont()
            NEXT FIELD gev01
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i600_1_bcl
              CANCEL INSERT
           END IF
           INSERT INTO gev_file(gev01,gev02,gev03,gev04)
           VALUES(l_gev[i].gev01,l_gev[i].gev02,'Y',g_geu[l_ac].geu01)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","gev_file",l_gev[i].gev01,l_gev[i].gev02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET l_rec_b = l_rec_b + 1
           END IF
 
       #AFTER FIELD gev01
       #    IF NOT cl_null(l_gev[i].gev01) THEN
       #       IF l_gev[i].gev01 != l_gev_t.gev01 OR l_gev_t.gev01 IS NULL THEN
       #          SELECT COUNT(*) INTO g_cnt FROM gev_file
       #           WHERE gev01 = l_gev[i].gev01
       #             AND gev03 = 'Y'
       #          IF g_cnt > 0 THEN
       #             CALL cl_err('',-239,0)
       #             LET l_gev[i].gev01 = l_gev_t.gev01
       #             NEXT FIELD gev01
       #          END IF
       #       END IF
       #    END IF
 
        BEFORE FIELD gev02
            IF cl_null(l_gev[i].gev01) THEN NEXT FIELD gev01 END IF
 
        AFTER FIELD gev02
            IF NOT cl_null(l_gev[i].gev02) THEN
               SELECT azp02 FROM azp_file WHERE azp01=l_gev[i].gev02
               IF SQLCA.sqlcode THEN
                  CALL cl_err(l_gev[i].gev02,SQLCA.sqlcode,0)
                  NEXT FIELD gev02
               END IF
               IF l_gev[i].gev02 != l_gev_t.gev02 OR l_gev_t.gev02 IS NULL OR
                  l_gev[i].gev01 != l_gev_t.gev01 OR l_gev_t.gev01 IS NULL THEN
                  SELECT COUNT(*) INTO g_cnt FROM gev_file
                   WHERE gev01 = l_gev[i].gev01
                     AND gev02 = l_gev[i].gev02
                  IF g_cnt > 0 THEN
                     CALL cl_err('',-239,0)
                     LET l_gev[i].gev02 = l_gev_t.gev02
                     NEXT FIELD gev02
                  END IF
                  DISPLAY 'SELECT COUNT OK'
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF l_rec_b>=i THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
               LET g_doc.column1 = "geu01"               #No.FUN-9B0098 10/02/24
               LET g_doc.value1 = g_geu[l_ac].geu01      #No.FUN-9B0098 10/02/24
               CALL cl_del_doc()                                             #No.FUN-9B0098 10/02/24
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM gev_file WHERE gev01 = l_gev_t.gev01
                                      AND gev02 = l_gev_t.gev02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","gev_file",l_gev_t.gev01,l_gev_t.gev02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
                  ROLLBACK WORK
                  EXIT INPUT
               ELSE
                  DELETE FROM gey_file
                   WHERE gey01 = l_gev_t.gev01
                     AND gey02 = l_gev_t.gev02

                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","gey_file",l_gev_t.gev01,l_gev_t.gev02,SQLCA.sqlcode,"","",1)
                     ROLLBACK WORK
                     EXIT INPUT
                  END IF

                  DELETE FROM gew_file
                   WHERE gew02 = l_gev_t.gev01
                     AND gew04 = l_gev_t.gev02
                     AND gew01 = g_geu[l_ac].geu01

                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","gew_file",l_gev_t.gev01,l_gev_t.gev02,SQLCA.sqlcode,"","",1)
                     ROLLBACK WORK
                     EXIT INPUT
                  END IF

                  DELETE FROM gez_file
                   WHERE gez02 = l_gev_t.gev01
                     AND gez03 = l_gev_t.gev02
                     AND gez01 = g_geu[l_ac].geu01
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","gez_file",l_gev_t.gev01,l_gev_t.gev02,SQLCA.sqlcode,"","",1)
                     ROLLBACK WORK
                     EXIT INPUT
                  END IF
                  LET l_rec_b = l_rec_b - 1
                  COMMIT WORK
               END IF
             END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET l_gev[i].* = l_gev_t.*
              CLOSE i600_1_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
              CALL cl_err(l_gev[i].gev01,-263,0)
              LET l_gev[i].* = l_gev_t.*
           ELSE
              UPDATE gev_file SET gev01=l_gev[i].gev01,gev02=l_gev[i].gev02
               WHERE gev01 = l_gev_t.gev01
                 AND gev02 = l_gev_t.gev02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","gev_file",l_gev_t.gev01,l_gev_t.gev02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
                 LET l_gev[i].* = l_gev_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
            END IF
 
        AFTER ROW
           LET i = ARR_CURR()
           LET i_t = i
 
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET l_gev[i].* = l_gev_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL l_gev.deleteElement(i)
               #FUN-D40030--add--end--
              END IF
              CLOSE i600_1_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i600_1_bcl
           COMMIT WORK
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(gev02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azp"
                 LET g_qryparam.default1 = l_gev[i].gev02
                #LET g_qryparam.arg1     = l_gev[i].gev01
                 CALL cl_create_qry() RETURNING l_gev[i].gev02
                 NEXT FIELD gev02
              OTHERWISE
                 EXIT CASE
           END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(gev01) AND i > 1 THEN
              LET l_gev[i].* = l_gev[i-1].*
              NEXT FIELD gev01
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION help
           CALL cl_show_help()
 
    END INPUT
 
    CLOSE i600_1_bcl
    COMMIT WORK
  END WHILE
    CLOSE WINDOW i600_1_w
END FUNCTION
 
#No.FUN-7C0010  --End
#No.FUN-870100 --END
#FUN-B80035
