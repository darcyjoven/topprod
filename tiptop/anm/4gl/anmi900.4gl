# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: anmi900.4gl
# Descriptions...: 營運中心週轉金設定
# Date & Author..: 06/02/20 By Nicola
# Modify.........: No.MOD-640134 06/04/11 By Nicola 單頭請加顯示營運中心幣別
# Modify.........: No.FUN-640132 06/04/14 By Nicola 金額欄位依幣別取位
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改.
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6A0011 06/11/12 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0030 06/11/14 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-720019 07/03/01 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-790050 07/07/16 By Carrier _out()轉p_query實現
# Modify.........: No.TQC-940177 09/05/12 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50102 10/07/09 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_nqb01      LIKE nqb_file.nqb01,
       g_nqb01_t    LIKE nqb_file.nqb01,
       g_azp02      LIKE azp_file.azp02,
       g_aza17      LIKE aza_file.aza17,         #No.MOD-640134
       g_nqb        DYNAMIC ARRAY OF RECORD
                       nqb02   LIKE nqb_file.nqb02,
                       nqb03   LIKE nqb_file.nqb03
                    END RECORD,
       g_nqb_t      RECORD
                       nqb02   LIKE nqb_file.nqb02,
                       nqb03   LIKE nqb_file.nqb03
                    END RECORD,
       g_wc,g_sql   STRING,       
       g_rec_b      LIKE type_file.num5,         #No.FUN-680107 SMALLINT
       l_ac         LIKE type_file.num5          #No.FUN-680107 SMALLINT
DEFINE g_forupd_sql STRING                  
DEFINE g_sql_tmp    STRING                  #No.TQC-720019
DEFINE g_before_input_done LIKE type_file.num5   #No.FUN-680107 SMALLINT
DEFINE g_cnt        LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_msg        LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(72)
DEFINE g_row_count  LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_curs_index LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_jump       LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5          #No.FUN-680107 SMALLINT
DEFINE g_azp03      LIKE azp_file.azp03
# DEFINE l_azi04      LIKE azi_file.azi04          #No.FUN-640132  #NO.CHI-6A0004
 
MAIN
#     DEFINEl_time LIKE type_file.chr8           #No.FUN-6A0082
DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680107 SMALLINT
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
 
   LET p_row = 4 LET p_col = 2
 
   OPEN WINDOW i900_w AT p_row,p_col
     WITH FORM "anm/42f/anmi900"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
 
   CALL i900_menu()
 
   CLOSE WINDOW i900_w                 #結束畫面
 
   CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
 
END MAIN
 
FUNCTION i900_cs()
 
   CLEAR FORM                             #清除畫面
   CALL g_nqb.clear()
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_nqb01 TO NULL    #No.FUN-750051
   CONSTRUCT g_wc ON nqb01,nqb02,nqb03
        FROM nqb01,s_nqb[1].nqb02,s_nqb[1].nqb03
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(nqb01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_nqb01
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO nqb01
               NEXT FIELD nqb01
            OTHERWISE
         END CASE
 
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nqbuser', 'nqbgrup') #FUN-980030
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   LET g_sql = "SELECT UNIQUE nqb01 FROM nqb_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY nqb01"
 
   PREPARE i900_prepare FROM g_sql
   DECLARE i900_bcs SCROLL CURSOR WITH HOLD FOR i900_prepare
 
#  LET g_sql = "SELECT UNIQUE nqb01 FROM nqb_file ",      #No.TQC-720019
   LET g_sql_tmp = "SELECT UNIQUE nqb01 FROM nqb_file ",  #No.TQC-720019
               " WHERE ", g_wc CLIPPED,
               " INTO TEMP x "
   DROP TABLE x
#  PREPARE i900_precount_x FROM g_sql      #No.TQC-720019
   PREPARE i900_precount_x FROM g_sql_tmp  #No.TQC-720019
   EXECUTE i900_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x"
   PREPARE i900_precount FROM g_sql
   DECLARE i900_count CURSOR FOR i900_precount
 
END FUNCTION
 
FUNCTION i900_menu()
 
   WHILE TRUE
      CALL i900_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i900_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i900_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i900_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i900_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i900_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               #No.FUN-790050  --Begin
               #CALL i900_out()
               IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF
               LET g_msg = 'p_query "anmi900" "',g_wc CLIPPED,'"'
               CALL cl_cmdrun(g_msg)
               #No.FUN-790050  --End  
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nqb),'','')
            END IF
         #No.FUN-6A0011---------add---------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_nqb01 IS NOT NULL THEN
                 LET g_doc.column1 = "nqb01"
                 LET g_doc.value1 = g_nqb01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0011---------add---------end----
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i900_a()
 
   IF s_anmshut(0) THEN
      RETURN
   END IF
 
   MESSAGE ""
   CLEAR FORM
   CALL g_nqb.clear()
   LET g_nqb01 = g_plant
   LET g_nqb01_t = NULL
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i900_i("a")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      LET g_rec_b = 0
      DISPLAY g_rec_b TO FORMONLY.cn2
 
      CALL i900_b()
      LET g_nqb01_t = g_nqb01
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i900_u()
 
   IF s_anmshut(0) THEN
      RETURN
   END IF
 
   IF g_nqb01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_nqb01_t = g_nqb01
 
   WHILE TRUE
      CALL i900_i("u") 
 
      IF INT_FLAG THEN
         LET g_nqb01 = g_nqb01_t
         DISPLAY g_nqb01 TO nqb01
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_nqb01 != g_nqb01_t THEN
         UPDATE nqb_file SET nqb01 = g_nqb01
          WHERE nqb01 = g_nqb01_t
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_nqb01,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("upd","nqb_file",g_nqb01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CONTINUE WHILE
         END IF
      END IF
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i900_i(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INPUT g_nqb01 WITHOUT DEFAULTS FROM nqb01
 
      AFTER FIELD nqb01
         IF NOT cl_null(g_nqb01) THEN
            IF g_nqb01 != g_nqb01_t OR g_nqb01_t IS NULL THEN
               SELECT azp02,azp03 INTO g_azp02,g_azp03 FROM azp_file
                WHERE azp01 = g_nqb01
               IF STATUS THEN
#                 CALL cl_err(g_nqb01,"aap-025",0)   #No.FUN-660148
                  CALL cl_err3("sel","azp_file",g_nqb01,"","aap-025","","",1)  #No.FUN-660148
                  NEXT FIELD nqb01
               END IF
               #-----No.MOD-640134-----
               LET g_sql = "SELECT aza17 ",
                          #"  FROM ",g_azp03,".dbo.aza_file" #TQC-940177 
                           #"  FROM ",s_dbstring(g_azp03 CLIPPED),"aza_file" #TQC-940177 
                           "  FROM ",cl_get_target_table(g_nqb01,'aza_file') #FUN-A50102 
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
		       CALL cl_parse_qry_sql(g_sql,g_nqb01) RETURNING g_sql #FUN-A50102            
               PREPARE i900_paza FROM g_sql
               DECLARE i900_baza CURSOR FOR i900_paza
               
               OPEN i900_baza
               FETCH i900_baza INTO g_aza17
 
               DISPLAY g_azp02,g_aza17 TO azp02,aza17
               #-----No.MOD-640134 END-----
               #-----No.FUN-640132-----
               SELECT azi04 INTO t_azi04 FROM azi_file   #NO.CHI-6A0004
                WHERE azi01 = g_aza17
               #-----No.FUN-640132 END-----
            END IF
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
             EXIT INPUT
         END IF
         IF g_nqb01 != g_nqb01_t OR g_nqb01_t IS NULL THEN
            SELECT COUNT(*) INTO g_cnt FROM nqb_file
             WHERE nqb01 = g_nqb01
            IF g_cnt > 0 THEN
               CALL cl_err("","axm-298",0)
               NEXT FIELD nqb01
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(nqb01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_nqb01
               CALL cl_create_qry() RETURNING g_nqb01
               DISPLAY BY NAME g_nqb01
               NEXT FIELD nqb01
            OTHERWISE
         END CASE
 
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
 
      ON ACTION controlg
         CALL cl_cmdask()
 
   END INPUT
 
END FUNCTION
 
FUNCTION i900_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   INITIALIZE g_nqb01 TO NULL             #NO.FUN-6A0011
 
   MESSAGE ""
   CALL cl_opmsg('q')
 
   CALL i900_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_nqb01 TO NULL
      RETURN
   END IF
 
   OPEN i900_bcs
   IF SQLCA.sqlcode THEN
      CALL cl_err("",SQLCA.sqlcode,0)
      INITIALIZE g_nqb01 TO NULL
   ELSE
      CALL i900_fetch('F')
      OPEN i900_count
      FETCH i900_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
   END IF
 
END FUNCTION
 
FUNCTION i900_fetch(p_flag)
DEFINE p_flag   LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
       l_abso   LIKE type_file.num10         #No.FUN-680107 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i900_bcs INTO g_nqb01
      WHEN 'P' FETCH PREVIOUS i900_bcs INTO g_nqb01
      WHEN 'F' FETCH FIRST    i900_bcs INTO g_nqb01
      WHEN 'L' FETCH LAST     i900_bcs INTO g_nqb01
      WHEN '/'
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
 
            PROMPT g_msg CLIPPED,': ' FOR g_jump
 
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION about
                  CALL cl_about()
              
               ON ACTION help
                  CALL cl_show_help()
              
               ON ACTION controlg
                  CALL cl_cmdask()
 
               END PROMPT
 
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
 
            FETCH ABSOLUTE g_jump i900_bcs INTO g_nqb01
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_nqb01,SQLCA.sqlcode,0)
      INITIALIZE g_nqb01 TO NULL  #TQC-6B0105
   ELSE
      CALL i900_show()
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
 
FUNCTION i900_show()
 
   #-----No.MOD-640134-----
   SELECT azp02,azp03 INTO g_azp02,g_azp03 FROM azp_file
    WHERE azp01 = g_nqb01
 
   LET g_sql = "SELECT aza17 ",
              #"  FROM ",g_azp03,".dbo.aza_file" #TQC-940177 
               #"  FROM ",s_dbstring(g_azp03 CLIPPED),"aza_file"  #TQC-940177
             "  FROM ",cl_get_target_table(g_nqb01,'aza_file') #FUN-A50102
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,g_nqb01) RETURNING g_sql #FUN-A50102           
   PREPARE i900_paza1 FROM g_sql
   DECLARE i900_baza1 CURSOR FOR i900_paza1
   
   OPEN i900_baza1
   FETCH i900_baza1 INTO g_aza17
 
   DISPLAY g_nqb01,g_azp02,g_aza17 TO nqb01,azp02,aza17
   #-----No.MOD-640134 END-----
 
   #-----No.FUN-640132-----
   SELECT azi04 INTO t_azi04 FROM azi_file   #NO.CHI-6A0004
    WHERE azi01 = g_aza17
   #-----No.FUN-640132 END-----
 
   CALL i900_b_fill(g_wc)
 
   CALL cl_show_fld_cont()
 
END FUNCTION
 
FUNCTION i900_r()
 
   IF s_anmshut(0) THEN RETURN END IF
 
   IF g_nqb01 IS NULL THEN
      CALL cl_err("",-400,0)                 #No.FUN-6A0011
      RETURN
   END IF
 
   IF cl_delh(0,0) THEN
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "nqb01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_nqb01       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                      #No.FUN-9B0098 10/02/24
      DELETE FROM nqb_file
       WHERE nqb01 = g_nqb01
      IF SQLCA.sqlcode THEN
#        CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)   #No.FUN-660148
         CALL cl_err3("del","nqb_file",g_nqb01,"",SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660148
      ELSE
         CLEAR FORM
         CALL g_nqb.clear()
         LET g_nqb01 = NULL
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
 
         DROP TABLE x                        #No.TQC-720019
         PREPARE i900_pre_x2 FROM g_sql_tmp  #No.TQC-720019
         EXECUTE i900_pre_x2                 #No.TQC-720019
         OPEN i900_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE i900_bcs
            CLOSE i900_count
           COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH i900_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i900_bcs
            CLOSE i900_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
 
         OPEN i900_bcs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i900_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i900_fetch('/')
         END IF
      END IF
   END IF
 
END FUNCTION
 
FUNCTION i900_b()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_allow_delete  LIKE type_file.num5           #No.FUN-680107 SMALLINT
 
   LET g_action_choice = ""
 
   IF s_anmshut(0) THEN RETURN END IF
 
   IF g_nqb01 IS NULL THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT nqb02,nqb03 FROM nqb_file",
                      "  WHERE nqb01=?",
                      "   AND nqb02=? FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i900_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_nqb WITHOUT DEFAULTS FROM s_nqb.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_nqb_t.* = g_nqb[l_ac].*
            BEGIN WORK
            OPEN i900_bcl USING g_nqb01,g_nqb_t.nqb02
            IF STATUS THEN
               CALL cl_err("OPEN i900_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i900_bcl INTO g_nqb[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_nqb_t.nqb02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_nqb[l_ac].* TO NULL
         LET g_nqb[l_ac].nqb02 = g_today
         LET g_nqb[l_ac].nqb03 = 0
         LET g_nqb_t.* = g_nqb[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD nqb02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO nqb_file (nqb01,nqb02,nqb03,nqboriu,nqborig)
              VALUES(g_nqb01,g_nqb[l_ac].nqb02,
                     g_nqb[l_ac].nqb03, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_nqb[l_ac].nqb02,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("ins","nqb_file",g_nqb01,g_nqb[l_ac].nqb02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      
      AFTER FIELD nqb03
         #-----No.FUN-640132-----
         IF NOT cl_null(g_nqb[l_ac].nqb03) THEN
            CALL cl_digcut(g_nqb[l_ac].nqb03,t_azi04) RETURNING g_nqb[l_ac].nqb03  #NO.CHI-6A0004
            DISPLAY BY NAME g_nqb[l_ac].nqb03
         END IF
         #-----No.FUN-640132 END-----
         IF g_nqb[l_ac].nqb03 < 0 THEN
            CALL cl_err(g_nqb[l_ac].nqb03,"afa-040",0)
            NEXT FIELD nqb03
         END IF
 
      BEFORE DELETE
         IF g_nqb_t.nqb02 > 0 AND g_nqb_t.nqb02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM nqb_file
             WHERE nqb01 = g_nqb01
               AND nqb02 = g_nqb_t.nqb02
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_nqb_t.nqb02,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("del","nqb_file",g_nqb01,g_nqb_t.nqb02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
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
            LET g_nqb[l_ac].* = g_nqb_t.*
            CLOSE i900_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_nqb[l_ac].nqb02,-263,1)
            LET g_nqb[l_ac].* = g_nqb_t.*
         ELSE
            UPDATE nqb_file SET nqb02 = g_nqb[l_ac].nqb02,
                                nqb03 = g_nqb[l_ac].nqb03
             WHERE nqb01 = g_nqb01
               AND nqb02 = g_nqb_t.nqb02
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_nqb[l_ac].nqb02,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("upd","nqb_file",g_nqb01,g_nqb_t.nqb02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               LET g_nqb[l_ac].* = g_nqb_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac      #FUN-D30032 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_nqb[l_ac].* = g_nqb_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_nqb.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end-- 
            END IF
            CLOSE i900_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac      #FUN-D30032 Add
         CLOSE i900_bcl
         COMMIT WORK
 
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
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------       
 
   END INPUT
 
   CLOSE i900_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i900_b_fill(p_wc)
   DEFINE p_wc   LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(200)
 
   LET g_sql = "SELECT nqb02,nqb03 FROM nqb_file ",
               " WHERE nqb01 = '",g_nqb01,"'",
               "   AND ",p_wc CLIPPED ,
               " ORDER BY nqb02"
 
   PREPARE i900_prepare2 FROM g_sql
   DECLARE nqb_cs CURSOR FOR i900_prepare2
 
   CALL g_nqb.clear()
   LET g_cnt = 1
   LET g_rec_b=0
 
   FOREACH nqb_cs INTO g_nqb[g_cnt].*   #單身 ARRAY 填充
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
 
   CALL g_nqb.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i900_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nqb TO s_nqb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
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
         CALL i900_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL i900_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL i900_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL i900_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL i900_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
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
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0011  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------       
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i900_copy()
   DEFINE l_oldno1   LIKE nqb_file.nqb01,
          l_newno1   LIKE nqb_file.nqb01
 
   IF s_anmshut(0) THEN RETURN END IF
 
   IF g_nqb01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INPUT l_newno1 FROM nqb01
 
      AFTER FIELD nqb01
         IF cl_null(l_newno1) THEN
            NEXT FIELD nqb01
         ELSE
            IF g_nqb01 != g_nqb01_t OR g_nqb01_t IS NULL THEN
               SELECT azp02 INTO g_azp02 FROM azp_file
                WHERE azp01 = g_nqb01
               IF STATUS THEN
#                 CALL cl_err(g_nqb01,"aap-025",0)   #No.FUN-660148
                  CALL cl_err3("sel","azp_file",g_nqb01,"","aap-025","","",1)  #No.FUN-660148
                  NEXT FIELD nqb01
               ELSE
                  DISPLAY g_azp02 TO azp02
               END IF
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(nqb01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = l_newno1
               CALL cl_create_qry() RETURNING l_newno1
               DISPLAY l_newno1 TO nqb01
               NEXT FIELD nqb01
            OTHERWISE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
     
      ON ACTION help
         CALL cl_show_help()
     
      ON ACTION controlg
         CALL cl_cmdask()
 
   END INPUT
 
   IF INT_FLAG OR l_newno1 IS NULL THEN
      LET INT_FLAG = 0
      CALL i900_show()
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM nqb_file WHERE nqb01=g_nqb01 INTO TEMP x
 
   UPDATE x SET nqb01=l_newno1
 
   INSERT INTO nqb_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_nqb01,SQLCA.sqlcode,0)   #No.FUN-660148
      CALL cl_err3("ins","nqb_file",g_nqb01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
   ELSE
      MESSAGE 'ROW(',l_newno1,') O.K'
      LET l_oldno1 = g_nqb01
      LET g_nqb01 = l_newno1
      CALL i900_b()
      #LET g_nqb01 = l_oldno1  #FUN-C80046
      #CALL i900_show()        #FUN-C80046
   END IF
 
END FUNCTION
 
#No.FUN-790050  --Begin
#FUNCTION i900_out()
#   DEFINE l_name   LIKE type_file.chr20,         #No.FUN-680107 VARCHAR(20)
#          sr       RECORD     
#                      nqb01  LIKE nqb_file.nqb01,
#                      azp02  LIKE azp_file.azp02,
#                      nqb02  LIKE nqb_file.nqb02,
#                      nqb03  LIKE nqb_file.nqb03
#                   END RECORD 
#
#   CALL cl_wait()
#   CALL cl_outnam('anmi900') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#
#   LET g_sql = "SELECT nqb01,'',nqb02,nqb03",
#               "  FROM nqb_file ",
#               " WHERE ",g_wc CLIPPED
#
#   PREPARE i900_p1 FROM g_sql
#   DECLARE i900_curo CURSOR FOR i900_p1
#
#   START REPORT i900_rep TO l_name
#
#   FOREACH i900_curo INTO sr.*   
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)   
#         EXIT FOREACH
#      END IF
#
#      SELECT azp02 INTO sr.azp02 FROM azp_file
#       WHERE azp01 = sr.nqb01
#
#      OUTPUT TO REPORT i900_rep(sr.*)
#
#   END FOREACH
#
#   FINISH REPORT i900_rep
#
#   CLOSE i900_curo
#   ERROR ""
#
#   CALL cl_prt(l_name,' ','1',g_len)
#
#END FUNCTION
#
#REPORT i900_rep(sr)
#   DEFINE l_trailer_sw   LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
#          sr             RECORD     
#                            nqb01  LIKE nqb_file.nqb01,
#                            azp02  LIKE azp_file.azp02,
#                            nqb02  LIKE nqb_file.nqb02,
#                            nqb03  LIKE nqb_file.nqb03
#                         END RECORD 
#
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#
#   ORDER BY sr.nqb01,sr.nqb02
#
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno" 
#         PRINT g_head CLIPPED,pageno_total     
#         PRINT 
#         PRINT g_dash
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34]
#         PRINT g_dash1 
#         LET l_trailer_sw = "Y"
#
#      BEFORE GROUP OF sr.nqb01
#         PRINT COLUMN g_c[31],sr.nqb01 CLIPPED,
#               COLUMN g_c[32],sr.azp02 CLIPPED;
#
#      ON EVERY ROW
#         PRINT COLUMN g_c[33],sr.nqb02,
#               COLUMN g_c[34],cl_numfor(sr.nqb03,34,0)
#
#      ON LAST ROW
#         PRINT g_dash
#         PRINT g_x[4] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
#         LET l_trailer_sw = "N"
#
#      PAGE TRAILER
#         IF l_trailer_sw = "Y" THEN
#             PRINT g_dash
#             PRINT g_x[4] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#         ELSE
#             SKIP 2 LINE
#         END IF
#
#END REPORT
#No.FUN-790050  --End  
