# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: anmt900.4gl
# Descriptions...: 預計資金維護作業
# Date & Author..: 06/02/24 By Nicola
# Modify.........: MOD-640149 06/04/09 By Melody
# Modify.........: No.FUN-640132 06/04/14 By Nicola 金額欄位依幣別取位
# Modify.........: NO.FUN-640089 06/06/09 BY yiting 單身增加nqe13,nmt02
# Modify.........: No.FUN-660148 06/06/27 By Hellen cl_err --> cl_err3
# Modify.........: NO.FUN-670015 06/07/11 BY yiting 單身銀行編號需可輸入，實現否預設為N
# Modify.........: No.FUN-680107 06/09/11 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/14 By bnlent  單頭折疊功能修改
# Modify.........: No.FUN-6A0011 06/11/21 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.MOD-6A0174 06/11/28 By Smapmin 單身銀行編號與交易幣別未控管資料正確性
# Modify.........: No.TQC-720019 07/03/01 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-730005 07/03/02 By Smapmin 複製時與新增時一樣帶該營運中心的幣別
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-740081 07/04/22 By rainy 銀行代號不可空白
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-830145 08/04/21 By lutingting報表轉為使用Crystal Report輸出 
# Modify.........: No.FUN-870151 08/08/18 By xiaofeizhu  匯率調整為用azi07取位
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50102 10/07/13 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-B50063 11/05/26 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-C30695 12/03/14 By minpp 修改nqe13的開窗為q_nma 
# Modify.........: No.MOD-C30709 12/03/15 By wangrr nqe08匯率更改後重新計算金額nqe11
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/08 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_nqe01      LIKE nqe_file.nqe01,
       g_nqe02      LIKE nqe_file.nqe02,
       g_nqe01_t    LIKE nqe_file.nqe01,
       g_nqe02_t    LIKE nqe_file.nqe02,
       g_azp02      LIKE azp_file.azp02,
       g_azi02      LIKE azi_file.azi02,
       g_nqe        DYNAMIC ARRAY OF RECORD
                       nqe03   LIKE nqe_file.nqe03,
                       nqe04   LIKE nqe_file.nqe04,
                       nqe05   LIKE nqe_file.nqe05,
                       nqd02   LIKE nqd_file.nqd02, 
                       nqe13   LIKE nqe_file.nqe13,    #NO.FUN-640089
                  #    nmt02   LIKE nmt_file.nmt02,    #NO.FUN-640089  #MOD-C30695  MARK
                       nmt02   LIKE nma_file.nma02,    #MOD-C30695  add
                       nqe06   LIKE nqe_file.nqe06,
                       nqe07   LIKE nqe_file.nqe07,
                       nqe08   LIKE nqe_file.nqe08,
                       nqe09   LIKE nqe_file.nqe09,
                       nqe10   LIKE nqe_file.nqe10,
                       nqe11   LIKE nqe_file.nqe11,
                       nqe12   LIKE nqe_file.nqe12
                    END RECORD,
       g_nqe_t      RECORD
                       nqe03   LIKE nqe_file.nqe03,
                       nqe04   LIKE nqe_file.nqe04,
                       nqe05   LIKE nqe_file.nqe05,
                       nqd02   LIKE nqd_file.nqd02,
                       nqe13   LIKE nqe_file.nqe13,    #NO.FUN-640089
                      #nmt02   LIKE nmt_file.nmt02,    #NO.FUN-640089  #MOD-C30695  MARK
                       nmt02   LIKE nma_file.nma02,    #MOD-C30695  add
                       nqe06   LIKE nqe_file.nqe06,
                       nqe07   LIKE nqe_file.nqe07,
                       nqe08   LIKE nqe_file.nqe08,
                       nqe09   LIKE nqe_file.nqe09,
                       nqe10   LIKE nqe_file.nqe10,
                       nqe11   LIKE nqe_file.nqe11,
                       nqe12   LIKE nqe_file.nqe12
                    END RECORD,
       g_wc,g_sql   STRING,       
       g_rec_b      LIKE type_file.num5,         #No.FUN-680107 SMALLINT
       l_ac         LIKE type_file.num5          #No.FUN-680107 SMALLINT
DEFINE g_forupd_sql STRING        
DEFINE g_sql_tmp    STRING        #No.TQC-720019
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE g_cnt        LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_msg        LIKE ze_file.ze03            #No.FUN-680107 VARCHAR(72)
DEFINE g_row_count  LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_curs_index LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_jump       LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5          #No.FUN-680107 SMALLINT
DEFINE l_azi04      LIKE azi_file.azi04          #No.FUN-640132  #交易幣別 
DEFINE o_azi04      LIKE azi_file.azi04          #No.FUN-640132  #營運幣別 
DEFINE l_sql        STRING                       #No.FUN-830145
DEFINE g_str        STRING                       #No.FUN-830145
DEFINE l_table      STRING                       #No.FUN-830145
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0082
   DEFINE p_row,p_col   LIKE type_file.num5      #No.FUN-680107  SMALLINT
 
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
 
   #No.FUN-830145--START--
   LET l_sql = "nqe03.nqe_file.nqe03,", 
               "nqe04.nqe_file.nqe04,", 
               "nqe05.nqe_file.nqe05,", 
               "nqd02.nqd_file.nqd02,", 
               "nqe06.nqe_file.nqe06,", 
               "nqe07.nqe_file.nqe07,", 
               "nqe08.nqe_file.nqe08,", 
               "nqe09.nqe_file.nqe09,", 
               "nqe10.nqe_file.nqe10,", 
               "nqe11.nqe_file.nqe11,", 
               "nqe13.nqe_file.nqe13,", 
               "nmt02.nmt_file.nmt02,", 
               "nqe12.nqe_file.nqe12,", 
               "o_azi04.azi_file.azi04,",
               "l_azi04.azi_file.azi04,",
               "nqe01.nqe_file.nqe01,", 
               "azp02.azp_file.azp02,", 
               "nqe02.nqe_file.nqe02,", 
               "azi02.azi_file.azi02,",
               "azi07.azi_file.azi07 "     #No.FUN-870151
   LET l_table = cl_prt_temptable('anmr900',l_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?) "        #FUN-870151 ADD ?
   PREPARE insert_prep FROM l_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',STATUS,1)
   END IF 
   #No.FUN-830145--end
 
   LET p_row = 4 LET p_col = 2
 
   OPEN WINDOW t900_w AT p_row,p_col
     WITH FORM "anm/42f/anmt900"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
 
   CALL t900_menu()
 
   CLOSE WINDOW t900_w                 #結束畫面
 
   CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
 
END MAIN
 
FUNCTION t900_cs()
 
   CLEAR FORM                             #清除畫面
   CALL g_nqe.clear()
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
 
   INITIALIZE g_nqe01 TO NULL    #No.FUN-750051
   INITIALIZE g_nqe02 TO NULL    #No.FUN-750051
   CONSTRUCT g_wc ON nqe01,nqe02,nqe03,nqe04,nqe05,nqe06,nqe07,nqe08,
                     nqe09,nqe10,nqe11,nqe12
        FROM nqe01,nqe02,s_nqe[1].nqe03,s_nqe[1].nqe04,s_nqe[1].nqe05,
             s_nqe[1].nqe06,s_nqe[1].nqe07,s_nqe[1].nqe08,
             s_nqe[1].nqe09,s_nqe[1].nqe10,s_nqe[1].nqe11,
             s_nqe[1].nqe12
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(nqe01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_nqe01
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO nqe01
               NEXT FIELD nqe01
            WHEN INFIELD(nqe02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_nqe01
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO nqe02
               NEXT FIELD nqe02
            #-----MOD-6A0174---------
            WHEN INFIELD(nqe05)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nqd"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO nqe05
               NEXT FIELD nqe05
            #-----END MOD-6A0174-----
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nqeuser', 'nqegrup') #FUN-980030
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   LET g_sql = "SELECT UNIQUE nqe01,nqe02 FROM nqe_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY nqe01,nqe02"
 
   PREPARE t900_prepare FROM g_sql
   DECLARE t900_bcs SCROLL CURSOR WITH HOLD FOR t900_prepare
 
#  LET g_sql = "SELECT UNIQUE nqe01,nqe02 FROM nqe_file ",      #No.TQC-720019
   LET g_sql_tmp = "SELECT UNIQUE nqe01,nqe02 FROM nqe_file ",  #No.TQC-720019
               " WHERE ", g_wc CLIPPED,
               " INTO TEMP x "
   DROP TABLE x
#  PREPARE t900_precount_x FROM g_sql      #No.TQC-720019
   PREPARE t900_precount_x FROM g_sql_tmp  #No.TQC-720019
   EXECUTE t900_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x"
   PREPARE t900_precount FROM g_sql
   DECLARE t900_count CURSOR FOR t900_precount
 
END FUNCTION
 
FUNCTION t900_menu()
 
   WHILE TRUE
      CALL t900_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t900_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t900_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t900_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t900_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t900_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t900_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nqe),'','')
            END IF
         #No.FUN-6A0011-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_nqe01 IS NOT NULL THEN
                LET g_doc.column1 = "nqe01"
                LET g_doc.column2 = "nqe02"
                LET g_doc.value1 = g_nqe01
                LET g_doc.value2 = g_nqe02
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0011-------add--------end----
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION t900_a()
 
   IF s_anmshut(0) THEN
      RETURN
   END IF
 
   MESSAGE ""
   CLEAR FORM
   CALL g_nqe.clear()
   LET g_nqe01 = g_plant
   LET g_nqe02 = g_aza.aza17
   LET g_nqe01_t = NULL
   LET g_nqe02_t = NULL
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL t900_i("a")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      LET g_rec_b = 0
      DISPLAY g_rec_b TO FORMONLY.cn2
 
      CALL t900_b()
 
      LET g_nqe01_t = g_nqe01
      LET g_nqe02_t = g_nqe02
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t900_u()
 
   IF s_anmshut(0) THEN
      RETURN
   END IF
 
   IF g_nqe01 IS NULL OR g_nqe02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_nqe01_t = g_nqe01
   LET g_nqe02_t = g_nqe02
 
   WHILE TRUE
      CALL t900_i("u") 
 
      IF INT_FLAG THEN
         LET g_nqe01 = g_nqe01_t
         LET g_nqe02 = g_nqe02_t
         DISPLAY g_nqe01,g_nqe02 TO nqe01,nqe02
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_nqe01 != g_nqe01_t OR g_nqe02 != g_nqe02_t THEN
         UPDATE nqe_file SET nqe01 = g_nqe01,
                             nqe02 = g_nqe02
          WHERE nqe01 = g_nqe01_t
            AND nqe02 = g_nqe02_t
         IF SQLCA.sqlcode THEN
            LET g_msg = g_nqe01 CLIPPED,' + ', g_nqe02 CLIPPED
#           CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("upd","nqe_file",g_nqe01_t,g_nqe02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CONTINUE WHILE
         END IF
      END IF
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t900_i(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680107 VARCHAR(1)
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INPUT g_nqe01,g_nqe02 WITHOUT DEFAULTS FROM nqe01,nqe02
 
      AFTER FIELD nqe01
         IF NOT cl_null(g_nqe01) THEN
            IF g_nqe01 != g_nqe01_t OR g_nqe01_t IS NULL THEN
               SELECT azp02 INTO g_azp02 FROM azp_file
                WHERE azp01 = g_nqe01
               IF STATUS THEN
#                 CALL cl_err(g_nqe01,"aap-025",0)   #No.FUN-660148
                  CALL cl_err3("sel","azp_file",g_nqe01,"","aap-025","","",1)  #No.FUN-660148
                  NEXT FIELD nqe01
               ELSE
                  DISPLAY g_azp02 TO azp02
               END IF
            END IF
            #MOD-640149
               LET g_plant_new=g_nqe01
               #CALL s_getdbs()   #FUN-A50102
               LET g_sql = " SELECT aza17 ",
                           #"   FROM ",g_dbs_new CLIPPED,"aza_file ",
                           "   FROM ",cl_get_target_table(g_plant_new,'aza_file'), #FUN-A50102
                           "  WHERE aza01='0' "
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
               CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
               PREPARE t900_pre FROM g_sql
               DECLARE t900_curs CURSOR FOR t900_pre
               FOREACH t900_curs INTO g_nqe02 END FOREACH
               SELECT azi02 INTO g_azi02 FROM azi_file
                WHERE azi01 = g_nqe02
               DISPLAY g_azi02 TO azi02
            #MOD-640149
            #-----No.FUN-640132-----
            SELECT azi04 INTO l_azi04 FROM azi_file 
             WHERE azi01 = g_nqe02
            #-----No.FUN-640132 END-----
         END IF
 
      AFTER FIELD nqe02
         IF NOT cl_null(g_nqe02) THEN
            IF g_nqe02 != g_nqe02_t OR g_nqe02_t IS NULL THEN
               SELECT azi02 INTO g_azi02 FROM azi_file
                WHERE azi01 = g_nqe02
               IF STATUS THEN
#                 CALL cl_err(g_nqe02,"aap-002",0)   #No.FUN-660148
                  CALL cl_err3("sel","azi_file",g_nqe02,"","aap-002","","",1)  #No.FUN-660148
                  NEXT FIELD nqe02
               ELSE
                  DISPLAY g_azi02 TO azi02
               END IF
            END IF
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
             EXIT INPUT
         END IF
         IF (g_nqe01 != g_nqe01_t OR g_nqe01_t IS NULL)
            AND (g_nqe02 != g_nqe02_t OR g_nqe02_t IS NULL) THEN
            SELECT COUNT(*) INTO g_cnt FROM nqe_file
             WHERE nqe01 = g_nqe01
               AND nqe02 = g_nqe02
            IF g_cnt > 0 THEN
               CALL cl_err("","axm-298",0)
               NEXT FIELD nqe01
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(nqe01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_nqe01
               CALL cl_create_qry() RETURNING g_nqe01
               DISPLAY BY NAME g_nqe01
               NEXT FIELD nqe01
            WHEN INFIELD(nqe02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = g_nqe02
               CALL cl_create_qry() RETURNING g_nqe02
               DISPLAY BY NAME g_nqe02
               NEXT FIELD nqe02
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
 
FUNCTION t900_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   INITIALIZE g_nqe01 TO NULL             #No.FUN-6A0011
   INITIALIZE g_nqe02 TO NULL             #No.FUN-6A0011 
 
   MESSAGE ""
   CALL cl_opmsg('q')
 
   CALL t900_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_nqe01 TO NULL
      INITIALIZE g_nqe02 TO NULL
      RETURN
   END IF
 
   OPEN t900_bcs
   IF SQLCA.sqlcode THEN
      CALL cl_err("",SQLCA.sqlcode,0)
      INITIALIZE g_nqe01 TO NULL
      INITIALIZE g_nqe02 TO NULL
   ELSE
      CALL t900_fetch('F')
      OPEN t900_count
      FETCH t900_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
   END IF
 
END FUNCTION
 
FUNCTION t900_fetch(p_flag)
DEFINE p_flag   LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
       l_abso   LIKE type_file.num10         #No.FUN-680107 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     t900_bcs INTO g_nqe01,g_nqe02
      WHEN 'P' FETCH PREVIOUS t900_bcs INTO g_nqe01,g_nqe02
      WHEN 'F' FETCH FIRST    t900_bcs INTO g_nqe01,g_nqe02
      WHEN 'L' FETCH LAST     t900_bcs INTO g_nqe01,g_nqe02
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
 
            FETCH ABSOLUTE g_jump t900_bcs INTO g_nqe01,g_nqe02
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_nqe01,SQLCA.sqlcode,0)
      INITIALIZE g_nqe01 TO NULL  #TQC-6B0105
      INITIALIZE g_nqe02 TO NULL  #TQC-6B0105
   ELSE
      CALL t900_show()
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
 
FUNCTION t900_show()
 
   SELECT azp02 INTO g_azp02 FROM azp_file
    WHERE azp01 = g_nqe01
 
   SELECT azi02 INTO g_azi02 FROM azi_file
    WHERE azi01 = g_nqe02
 
   #-----No.FUN-640132-----
   SELECT azi04 INTO l_azi04 FROM azi_file  
    WHERE azi01 = g_nqe02
   #-----No.FUN-640132 END-----
 
   DISPLAY g_nqe01,g_nqe02,g_azp02,g_azi02 TO nqe01,nqe02,azp02,azi02
 
   CALL t900_b_fill(g_wc)
 
   CALL cl_show_fld_cont()
 
END FUNCTION
 
FUNCTION t900_r()
 
   IF s_anmshut(0) THEN RETURN END IF
 
   IF g_nqe01 IS NULL THEN
      CALL cl_err("",-400,0)                 #No.FUN-6A0011
      RETURN
   END IF
 
   IF cl_delh(0,0) THEN
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "nqe01"      #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "nqe02"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_nqe01       #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_nqe02       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                      #No.FUN-9B0098 10/02/24
      DELETE FROM nqe_file
       WHERE nqe01 = g_nqe01
         AND nqe02 = g_nqe02
      IF SQLCA.sqlcode THEN
#        CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)   #No.FUN-660148
         CALL cl_err3("del","nqe_file",g_nqe01,g_nqe02,SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660148
      ELSE
         CLEAR FORM
         CALL g_nqe.clear()
         LET g_nqe01 = NULL
         LET g_nqe02 = NULL
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
 
         DROP TABLE x                        #No.TQC-720019
         PREPARE t900_pre_x2 FROM g_sql_tmp  #No.TQC-720019
         EXECUTE t900_pre_x2                 #No.TQC-720019
         OPEN t900_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE t900_bcs
            CLOSE t900_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH t900_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t900_bcs
            CLOSE t900_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
 
         OPEN t900_bcs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t900_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t900_fetch('/')
         END IF
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t900_b()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_allow_delete  LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_cnt           LIKE type_file.num5           #MOD-6A0174
   DEFINE l_nqe11         LIKE nqe_file.nqe11   #MOD-C30709 add--
   LET g_action_choice = ""
 
   IF s_anmshut(0) THEN RETURN END IF
 
   IF g_nqe01 IS NULL THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   #LET g_forupd_sql = "SELECT nqe03,nqe04,nqe05,'',nqe06,nqe07,nqe08,",  #NO.FUN-640089
   LET g_forupd_sql = "SELECT nqe03,nqe04,nqe05,'',nqe13,'',nqe06,nqe07,nqe08,",
                      "       nqe09,nqe10,nqe11,nqe12 ",
                      "  FROM nqe_file",
                      "   WHERE nqe01=? AND nqe02=?",
                      "   AND nqe03=? AND nqe05=? FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t900_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_nqe WITHOUT DEFAULTS FROM s_nqe.*
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
            LET g_nqe_t.* = g_nqe[l_ac].*
            BEGIN WORK
            OPEN t900_bcl USING g_nqe01,g_nqe02,g_nqe_t.nqe03,g_nqe_t.nqe05
            IF STATUS THEN
               CALL cl_err("OPEN t900_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t900_bcl INTO g_nqe[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_nqe_t.nqe03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  SELECT nqd02 INTO g_nqe[l_ac].nqd02
                    FROM nqd_file
                   WHERE nqd01 = g_nqe[l_ac].nqe05
                  DISPLAY BY NAME g_nqe[l_ac].nqd02
                  #-----No.FUN-640132-----
                  SELECT azi04 INTO o_azi04 FROM azi_file 
                   WHERE azi01 = g_nqe[l_ac].nqe07
                  #-----No.FUN-640132 END-----
                  SELECT nmt02 INTO g_nqe[l_ac].nmt02
                    FROM nmt_file 
                   WHERE nmt01 = g_nqe[l_ac].nqe13
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_nqe[l_ac].* TO NULL
         LET g_nqe[l_ac].nqe03 = g_today
         LET g_nqe[l_ac].nqe07 = g_aza.aza17
         LET g_nqe[l_ac].nqe08 = 1
         LET g_nqe[l_ac].nqe09 = 1
         LET g_nqe[l_ac].nqe10 = 0
         LET g_nqe[l_ac].nqe11 = 0
         #LET g_nqe[l_ac].nqe12 = "Y"
         LET g_nqe[l_ac].nqe12 = "N"   #NO.FUN-670015
 
         LET g_nqe_t.* = g_nqe[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD nqe03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO nqe_file (nqe01,nqe02,nqe03,nqe04,nqe05,nqe06,
                               nqe07,nqe08,nqe09,nqe10,nqe11,nqe12,
                               nqe13,nqeoriu,nqeorig)   #NO.FUN-670015
              VALUES(g_nqe01,g_nqe02,g_nqe[l_ac].nqe03,g_nqe[l_ac].nqe04,
                     g_nqe[l_ac].nqe05,g_nqe[l_ac].nqe06,
                     g_nqe[l_ac].nqe07,g_nqe[l_ac].nqe08,
                     g_nqe[l_ac].nqe09,g_nqe[l_ac].nqe10,
                     g_nqe[l_ac].nqe11,g_nqe[l_ac].nqe12,
                     g_nqe[l_ac].nqe13, g_user, g_grup)  #NO.FUN-670015      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_nqe[l_ac].nqe03,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("ins","nqe_file",g_nqe01,g_nqe02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      AFTER FIELD nqe05
         IF NOT cl_null(g_nqe[l_ac].nqe05) THEN
            IF g_nqe[l_ac].nqe05 != g_nqe_t.nqe05 OR g_nqe_t.nqe05 IS NULL THEN
               #-----MOD-6A0174---------
               SELECT COUNT(*) INTO l_cnt FROM nqe_file
                   WHERE nqe01 = g_nqe01
                     AND nqe02 = g_nqe02
                     AND nqe03 = g_nqe[l_ac].nqe03
                     AND nqe05 = g_nqe[l_ac].nqe05
               IF l_cnt > 0 THEN
                  CALL cl_err("","axm-298",0)
                  NEXT FIELD nqe05
               END IF
               #-----END MOD-6A0174-----
               SELECT nqd02,nqd03 INTO g_nqe[l_ac].nqd02,g_nqe[l_ac].nqe04
                 FROM nqd_file
                WHERE nqd01 = g_nqe[l_ac].nqe05
               IF STATUS THEN
#                 CALL cl_err(g_nqe[l_ac].nqe05,"aoo-109",0)   #No.FUN-660148
                  CALL cl_err3("sel","nqd_file",g_nqe[l_ac].nqe05,"","aoo-109","","",1)  #No.FUN-660148
                  NEXT FIELD nqe05
               END IF
               DISPLAY BY NAME g_nqe[l_ac].nqd02,g_nqe[l_ac].nqe04
            END IF
         END IF
 
      AFTER FIELD nqe07
         IF NOT cl_null(g_nqe[l_ac].nqe07) THEN
            IF g_nqe[l_ac].nqe07 != g_nqe_t.nqe07 OR g_nqe_t.nqe07 IS NULL THEN
               #-----MOD-6A0174---------
               SELECT COUNT(*) INTO l_cnt FROM azi_file
                  WHERE azi01 = g_nqe[l_ac].nqe07
               IF l_cnt = 0 THEN
                  CALL cl_err(g_nqe[l_ac].nqe07,"aap-002",0)
                  NEXT FIELD nqe07
               END IF
               #-----END MOD-6A0174-----
               SELECT COUNT(*) INTO g_cnt FROM azi_file
                WHERE azi01 = g_nqe[l_ac].nqe07
               IF g_cnt < 0 THEN
                  CALL cl_err(g_nqe[l_ac].nqe07,"aap-002",0)
                  NEXT FIELD nqe07
               END IF
               LET g_nqe[l_ac].nqe08 = s_exrate(g_nqe[l_ac].nqe07,g_nqe02,"S") 
               DISPLAY BY NAME g_nqe[l_ac].nqe08
            END IF
            #-----No.FUN-640132-----
            SELECT azi04 INTO o_azi04 FROM azi_file 
             WHERE azi01 = g_nqe[l_ac].nqe07
            #-----No.FUN-640132 END-----
         END IF
 
      AFTER FIELD nqe08
         IF g_nqe[l_ac].nqe08 < 0 THEN
            CALL cl_err(g_nqe[l_ac].nqe08,"afa-040",0)
            NEXT FIELD nqe08 
         #MOD-C30709--add--str
         ELSE
            LET l_nqe11=g_nqe[l_ac].nqe10 * g_nqe[l_ac].nqe08
            CALL cl_digcut(l_nqe11,l_azi04) RETURNING l_nqe11
            IF l_nqe11<>g_nqe[l_ac].nqe11 THEN
               LET g_nqe[l_ac].nqe11=l_nqe11
               DISPLAY BY NAME g_nqe[l_ac].nqe11
            END IF
         #MOD-C30709--add--end
         END IF
 
      AFTER FIELD nqe10
         IF g_nqe[l_ac].nqe10 < 0 THEN
            CALL cl_err(g_nqe[l_ac].nqe10,"afa-040",0)
            NEXT FIELD nqe10
         ELSE
            CALL cl_digcut(g_nqe[l_ac].nqe10,o_azi04) RETURNING g_nqe[l_ac].nqe10 
            DISPLAY BY NAME g_nqe[l_ac].nqe10
            IF g_nqe[l_ac].nqe10 != g_nqe_t.nqe10 OR g_nqe_t.nqe10 IS NULL THEN
               LET g_nqe[l_ac].nqe11 = g_nqe[l_ac].nqe10 * g_nqe[l_ac].nqe08
               CALL cl_digcut(g_nqe[l_ac].nqe11,l_azi04) RETURNING g_nqe[l_ac].nqe11
               DISPLAY BY NAME g_nqe[l_ac].nqe11
            END IF
         END IF
 
      AFTER FIELD nqe11
         IF g_nqe[l_ac].nqe11 < 0 THEN
            CALL cl_err(g_nqe[l_ac].nqe11,"afa-040",0)
            NEXT FIELD nqe11
         END IF
         CALL cl_digcut(g_nqe[l_ac].nqe11,l_azi04) RETURNING g_nqe[l_ac].nqe11  
         DISPLAY BY NAME g_nqe[l_ac].nqe11
 
     AFTER FIELD nqe13
        #MOD-740081
         IF cl_null(g_nqe[l_ac].nqe13) THEN
           CALL cl_err('','abm-510',0)
           NEXT FIELD nqe13
         END IF
        #MOD-740081
         #MOD-C30695--MOD--STR
        # SELECT nmt02 INTO g_nqe[l_ac].nmt02
        #   FROM nmt_file 
        #  WHERE nmt01 = g_nqe[l_ac].nqe13
         SELECT nma02 INTO g_nqe[l_ac].nmt02
           FROM nma_file 
          WHERE nma01 = g_nqe[l_ac].nqe13
         ##MOD-C30695--MOD--END
         #-----MOD-6A0174---------
         IF STATUS THEN
            CALL cl_err3("sel","nmt_file",g_nqe[l_ac].nqe13,"","aap-007","","",1)
            NEXT FIELD nqe13
         ELSE
            DISPLAY BY NAME g_nqe[l_ac].nmt02
         END IF
         #DISPLAY BY NAME g_nqe[l_ac].nmt02
         #-----END MOD-6A0174-----
 
 
     #MOD-740081
      AFTER INPUT
        IF cl_null(g_nqe[l_ac].nqe13) THEN
          CALL cl_err('','abm-510',0)
          NEXT FIELD nqe13
        END IF
     #MOD-740081
 
      BEFORE DELETE
         IF g_nqe_t.nqe03 > 0 AND g_nqe_t.nqe03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM nqe_file
             WHERE nqe01 = g_nqe01
               AND nqe02 = g_nqe02
               AND nqe03 = g_nqe_t.nqe03
               AND nqe05 = g_nqe_t.nqe05
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_nqe_t.nqe03,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("del","nqe_file",g_nqe01,g_nqe_t.nqe03,SQLCA.sqlcode,"","",1)  #No.FUN-660148
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
            LET g_nqe[l_ac].* = g_nqe_t.*
            CLOSE t900_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_nqe[l_ac].nqe03,-263,1)
            LET g_nqe[l_ac].* = g_nqe_t.*
         ELSE
            UPDATE nqe_file SET nqe03 = g_nqe[l_ac].nqe03,
                                nqe04 = g_nqe[l_ac].nqe04,
                                nqe05 = g_nqe[l_ac].nqe05,
                                nqe06 = g_nqe[l_ac].nqe06,
                                nqe07 = g_nqe[l_ac].nqe07,
                                nqe08 = g_nqe[l_ac].nqe08,
                                nqe09 = g_nqe[l_ac].nqe09,
                                nqe10 = g_nqe[l_ac].nqe10,
                                nqe11 = g_nqe[l_ac].nqe11,
                                nqe12 = g_nqe[l_ac].nqe12,
                                nqe13 = g_nqe[l_ac].nqe13   #NO.FUN-670015
             WHERE nqe01 = g_nqe01
               AND nqe02 = g_nqe02
               AND nqe03 = g_nqe_t.nqe03
               AND nqe05 = g_nqe_t.nqe05
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_nqe[l_ac].nqe03,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("upd","nqe_file",g_nqe01,g_nqe_t.nqe03,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               LET g_nqe[l_ac].* = g_nqe_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
      #  LET l_ac_t = l_ac    #FUN-D30032 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_nqe[l_ac].* = g_nqe_t.*
          #FUN-D30032--add--str--
            ELSE
               CALL g_nqe.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
          #FUN-D30032--add--end--
            END IF
            CLOSE t900_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac    #FUN-D30032 add
         CLOSE t900_bcl
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(nqe05)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nqd"
               LET g_qryparam.default1 = g_nqe[l_ac].nqe05
               CALL cl_create_qry() RETURNING g_nqe[l_ac].nqe05
               DISPLAY BY NAME g_nqe[l_ac].nqe05
               NEXT FIELD nqe05
            WHEN INFIELD(nqe07)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = g_nqe[l_ac].nqe07
               CALL cl_create_qry() RETURNING g_nqe[l_ac].nqe07
               DISPLAY BY NAME g_nqe[l_ac].nqe07
               NEXT FIELD nqe07
#NO.FUN-670015 start--
            WHEN INFIELD(nqe13)
               CALL cl_init_qry_var()
              #LET g_qryparam.form = "q_nmt"    #MOD-C30695  MARK
               LET g_qryparam.form = "q_nma"    #MOD-C30695  ADD
               LET g_qryparam.default1 = g_nqe[l_ac].nqe13
               CALL cl_create_qry() RETURNING g_nqe[l_ac].nqe13
               DISPLAY BY NAME g_nqe[l_ac].nqe13
               NEXT FIELD nqe13
#NO.FUN-670015 end--
            OTHERWISE
         END CASE
 
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
 
   CLOSE t900_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t900_b_fill(p_wc)
   DEFINE p_wc   LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(200)
 
   #LET g_sql = "SELECT nqe03,nqe04,nqe05,'',nqe06,nqe07,",   #NO.FUN-640089
   LET g_sql = "SELECT nqe03,nqe04,nqe05,'',nqe13,'',nqe06,nqe07,",
               "       nqe08,nqe09,nqe10,nqe11,nqe12",
               "  FROM nqe_file ",
               " WHERE nqe01 = '",g_nqe01,"'",
               "   AND nqe02 = '",g_nqe02,"'",
               "   AND ",p_wc CLIPPED ,
               " ORDER BY nqe03,nqe04"
 
   PREPARE t900_prepare2 FROM g_sql
   DECLARE nqe_cs CURSOR FOR t900_prepare2
 
   LET g_cnt = 1
   LET g_rec_b=0
   CALL g_nqe.clear()
 
   FOREACH nqe_cs INTO g_nqe[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      SELECT nqd02 INTO g_nqe[g_cnt].nqd02
        FROM nqd_file
       WHERE nqd01 = g_nqe[g_cnt].nqe05
 
#NO.FUN-640089 start--
      SELECT nmt02 INTO g_nqe[g_cnt].nmt02
        FROM nmt_file 
       WHERE nmt01 = g_nqe[g_cnt].nqe13
#NO.FUN-640089 end----
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_nqe.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t900_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nqe TO s_nqe.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t900_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL t900_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL t900_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL t900_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL t900_fetch('L')
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------      
 
      ON ACTION related_document                #No.FUN-6A0011  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION t900_copy()
   DEFINE l_oldno1   LIKE nqe_file.nqe01,
          l_oldno2   LIKE nqe_file.nqe02,
          l_newno1   LIKE nqe_file.nqe01,
          l_newno2   LIKE nqe_file.nqe02
 
   IF s_anmshut(0) THEN RETURN END IF
 
   IF g_nqe01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
 
   INPUT l_newno1,l_newno2 FROM nqe01,nqe02
 
      AFTER FIELD nqe01
         IF cl_null(l_newno1) THEN
            NEXT FIELD nqe01
         ELSE
            SELECT azp02 INTO g_azp02 FROM azp_file
             WHERE azp01 = l_newno1
            IF STATUS THEN
#              CALL cl_err(l_newno1,"aap-025",0)   #No.FUN-660148
               CALL cl_err3("sel","azp_file",l_newno1,"","aap-025","","",1)  #No.FUN-660148
               NEXT FIELD nqe01
            ELSE
               DISPLAY g_azp02 TO azp02
            END IF
            #-----TQC-730005---------
            LET g_plant_new=l_newno1
            #CALL s_getdbs()     #FUN-A50102
            LET g_sql = " SELECT aza17 ",
                        #"   FROM ",g_dbs_new CLIPPED,"aza_file ",
                        "   FROM ",cl_get_target_table(g_plant_new,'aza_file'), #FUN-A50102
                        "  WHERE aza01='0' "
 	        CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
            PREPARE t900_pre2 FROM g_sql
            DECLARE t900_curs2 CURSOR FOR t900_pre2
            FOREACH t900_curs2 INTO l_newno2 END FOREACH
            SELECT azi02 INTO g_azi02 FROM azi_file
             WHERE azi01 = l_newno2
            DISPLAY g_azi02 TO azi02
            SELECT azi04 INTO l_azi04 FROM azi_file
             WHERE azi01 = l_newno2
            #-----END TQC-730005-----
         END IF
 
      AFTER FIELD nqe02
         IF cl_null(l_newno2) THEN
            NEXT FIELD nqe02
         ELSE
            SELECT azi02 INTO g_azi02 FROM azi_file
             WHERE azi01 = l_newno2
            IF STATUS THEN
#              CALL cl_err(l_newno2,"aap-002",0)   #No.FUN-660148
               CALL cl_err3("sel","azi_file",l_newno2,"","aap-002","","",1)  #No.FUN-660148
               NEXT FIELD nqe02
            ELSE
               DISPLAY g_azi02 TO azi02
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(nqe01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = l_newno1
               CALL cl_create_qry() RETURNING l_newno1
               DISPLAY l_newno1 TO nqe01
               NEXT FIELD nqe01
            WHEN INFIELD(nqe02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = l_newno2
               CALL cl_create_qry() RETURNING l_newno2
               DISPLAY l_newno2 TO nqe02
               NEXT FIELD nqe02
            #-----MOD-6A0174---------
            WHEN INFIELD(nqe05)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nqd"
               LET g_qryparam.default1 = g_nqe[l_ac].nqe05
               CALL cl_create_qry() RETURNING g_nqe[l_ac].nqe05
               DISPLAY BY NAME g_nqe[l_ac].nqe05
               NEXT FIELD nqe05
            #-----END MOD-6A0174-----
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
      CALL t900_show()
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM nqe_file WHERE nqe01=g_nqe01 AND nqe02=g_nqe02 INTO TEMP x
 
   UPDATE x SET nqe01=l_newno1,nqe02=l_newno2
 
   INSERT INTO nqe_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_nqe01,SQLCA.sqlcode,0)   #No.FUN-660148
      CALL cl_err3("ins","nqe_file",g_nqe01,g_nqe02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
   ELSE
      LET g_msg = l_newno1 CLIPPED, ' + ', l_newno2 CLIPPED
      MESSAGE 'ROW(',g_msg,') O.K'
      LET l_oldno1 = g_nqe01
      LET l_oldno2 = g_nqe02
      LET g_nqe01 = l_newno1
      LET g_nqe02 = l_newno2
      CALL t900_b()
      #LET g_nqe01 = l_oldno1  #FUN-C80046
      #LET g_nqe02 = l_oldno2  #FUN-C80046
      #CALL t900_show()        #FUN-C80046
   END IF
 
END FUNCTION
  
FUNCTION t900_out()
   DEFINE l_name   LIKE type_file.chr20,         #No.FUN-680107 VARCHAR(20)
          sr       RECORD     
                      nqe01    LIKE nqe_file.nqe01,
                      azp02    LIKE azp_file.azp02,
                      nqe02    LIKE nqe_file.nqe02,
                      azi02    LIKE azi_file.azi02,
                      nqe03    LIKE nqe_file.nqe03,
                      nqe04    LIKE nqe_file.nqe04,
                      nqe05    LIKE nqe_file.nqe05,
                      nqd02    LIKE nqd_file.nqd02,
                      nqe13    LIKE nqe_file.nqe13,    #NO.FUN-640089
                      nmt02    LIKE nmt_file.nmt02,    #NO.FUN-640089
                      nqe06    LIKE nqe_file.nqe06,
                      nqe07    LIKE nqe_file.nqe07,
                      nqe08    LIKE nqe_file.nqe08,
                      nqe09    LIKE nqe_file.nqe09,
                      nqe10    LIKE nqe_file.nqe10,
                      nqe11    LIKE nqe_file.nqe11,
                      nqe12    LIKE nqe_file.nqe12
                   END RECORD 
   CALL cl_del_data(l_table)  #No.FUN-830145  
   CALL cl_wait()
   #CALL cl_outnam('anmt900') RETURNING l_name   #No.FUN-830145 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
   #LET g_sql = "SELECT nqe01,'',nqe02,'',nqe03,nqe04,nqe05,'',nqe06,",
   LET g_sql = "SELECT nqe01,'',nqe02,'',nqe03,nqe04,nqe05,'',nqe13,'',nqe06,",
               "       nqe07,nqe08,nqe09,nqe10,nqe11,nqe12",
               "  FROM nqe_file ",
               " WHERE ",g_wc CLIPPED
 
   PREPARE t900_p1 FROM g_sql
   DECLARE t900_curo CURSOR FOR t900_p1
 
   #START REPORT t900_rep TO l_name    #No.FUN-830145 
 
   FOREACH t900_curo INTO sr.*   
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)  
         EXIT FOREACH
      END IF
      
 
      SELECT azp02 INTO sr.azp02 FROM azp_file
       WHERE azp01 = sr.nqe01
 
      SELECT azi02 INTO sr.azi02 FROM azi_file
       WHERE azi01 = sr.nqe02
 
      SELECT nqd02 INTO sr.nqd02 FROM nqd_file
       WHERE nqd01 = sr.nqe05
 
#NO.FUN-640089 start--
      SELECT nmt02 INTO sr.nmt02 FROM nmt_file
       WHERE nmt01 = sr.nqe13
#NO.FUN-640089 end---
 
      #No.FUN-830145--START--
      LET o_azi04 = NULL
      LET l_azi04 = NULL
      SELECT azi04 INTO o_azi04 FROM azi_file WHERE azi01 = sr.nqe07
      SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01 = sr.nqe07  #No.FUN-870151      
      SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = sr.nqe02
      EXECUTE insert_prep USING
         sr.nqe03,sr.nqe04,sr.nqe05,sr.nqd02,sr.nqe06,sr.nqe07,sr.nqe08,
         sr.nqe09,sr.nqe10,sr.nqe11,sr.nqe13,sr.nmt02,sr.nqe12,o_azi04,
         l_azi04,sr.nqe01,sr.azp02,sr.nqe02,sr.azi02
         ,t_azi07   #No.FUN-870151
      #No.FUN-830145--end
      #OUTPUT TO REPORT t900_rep(sr.*)    #No.FUN-830145
 
   END FOREACH
 
   #FINISH REPORT t900_rep   #No.FUN-830145
 
   CLOSE t900_curo
   ERROR ""
   
   #No.FUN-830145--start--
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   
   IF  g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'nqe01,nqe02,nqe03,nqe04,nqe05,nqe06,nqe07,nqe08,
                           nqe09,nqe10,nqe11,nqe12')
       RETURNING g_wc
       LET g_str = g_wc
   END IF
   
   LET g_str = g_str
   
   CALL cl_prt_cs3('anmt900','anmt900',l_sql,g_str)    
   #No.FUN-830145--end
   
   #CALL cl_prt(l_name,' ','1',g_len)   #No.FUN-830145
 
END FUNCTION
 
#No.FUN-830145--start--
#REPORT t900_rep(sr)
#   DEFINE l_trailer_sw   LIKE type_file.chr1,                #No.FUN-680107 VARCHAR(1)
#          sr             RECORD     
#                            nqe01    LIKE nqe_file.nqe01,
#                            azp02    LIKE azp_file.azp02,
#                            nqe02    LIKE nqe_file.nqe02,
#                            azi02    LIKE azi_file.azi02,
#                            nqe03    LIKE nqe_file.nqe03,
#                            nqe04    LIKE nqe_file.nqe04,
#                            nqe05    LIKE nqe_file.nqe05,
#                            nqd02    LIKE nqd_file.nqd02,
#                            nqe13    LIKE nqe_file.nqe13,    #NO.FUN-640089
#                            nmt02    LIKE nmt_file.nmt02,    #NO.FUN-640089
#                            nqe06    LIKE nqe_file.nqe06,
#                            nqe07    LIKE nqe_file.nqe07,
#                            nqe08    LIKE nqe_file.nqe08,
#                            nqe09    LIKE nqe_file.nqe09,
#                            nqe10    LIKE nqe_file.nqe10,
#                            nqe11    LIKE nqe_file.nqe11,
#                            nqe12    LIKE nqe_file.nqe12
#                         END RECORD 
#
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#
#   ORDER BY sr.nqe01,sr.nqe02,sr.nqe03,sr.nqe04
#
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno" 
#         PRINT g_head CLIPPED,pageno_total     
#         PRINT 
#         PRINT g_x[9],sr.nqe01,sr.azp02
#         PRINT g_x[10],sr.nqe02,sr.azi02
#         PRINT g_dash
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#               #g_x[38],g_x[39],g_x[40],g_x[41]
#               g_x[38],g_x[39],g_x[40],g_x[42],g_x[43],g_x[41]   #NO.FUN-640089
#         PRINT g_dash1 
#         LET l_trailer_sw = "Y"
#
#      BEFORE GROUP OF sr.nqe02
#         SKIP TO TOP OF PAGE
#
#      ON EVERY ROW
#         PRINT COLUMN g_c[31],sr.nqe03,
#               COLUMN g_c[32],sr.nqe04,
#               COLUMN g_c[33],sr.nqe05,
#               COLUMN g_c[34],sr.nqd02,
#               COLUMN g_c[35],sr.nqe06,
#               COLUMN g_c[36],sr.nqe07,
#               COLUMN g_c[37],cl_numfor(sr.nqe08,37,0),
#               COLUMN g_c[38],sr.nqe09,
#               COLUMN g_c[39],cl_numfor(sr.nqe10,39,o_azi04),  #No.FUN-640132 
#               COLUMN g_c[40],cl_numfor(sr.nqe11,40,l_azi04),  #No.FUN-640132 
#               COLUMN g_c[42],sr.nqe13,                        #NO.FUN-640089
#               COLUMN g_c[43],sr.nmt02,                        #NO.FUN-640089
#               COLUMN g_c[41],sr.nqe12
#
#      ON LAST ROW
#         PRINT g_dash
#         PRINT g_x[4] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
#         LET l_trailer_sw = "N"
#
#      PAGE TRAILER
#         IF l_trailer_sw = "Y" THEN
#            PRINT g_dash
#            PRINT g_x[4] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#         ELSE
#            SKIP 2 LINE
#         END IF
#
#END REPORT
#No.FUN-830145--end
