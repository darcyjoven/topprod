# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: anmt910.4gl
# Descriptions...: 資金調整維護作業
# Date & Author..: 06/03/02 By Nicola
# Modify.........: No.MOD-640117 06/04/10 By Nicola 查詢後再新增,表頭值未清除(殘留值)
#                                                   新增時,未輸入營運中心,卻有營運幣別值??
#                                                   營運中心查詢視窗應只顯示符合版本之工廠
#                                                   提供版本視窗查詢
# Modify.........: No.FUN-640112 06/04/11 By Nicola 營運中心查詢視窗應只顯示符合版本之工廠
#                                                   提供版本視窗查詢
# Modify.........: No.FUN-640132 06/04/14 By Nicola 金額欄位依幣別取位
#
# Modify.........: No.TQC-650131 06/06/01 by rainy  營運幣別不能開窗
# Modify.........: NO.FUN-640089 06/06/08 BY yiting 增加g_argv1,g_argv2,g_argv3
# Modify.........: No.FUN-660148 06/06/27 By Hellen cl_err --> cl_err3
# Modify.........: NO.FUN-640132 06/06/28 BY yiting 金額欄位依本國幣位取位
# Modify.........: NO.FUN-650177 06/06/30 BY yiting 單身只帶出類別999的資料 
# Modify.........: NO.FUN-670015 06/07/11 By yiting anmq910串到anmt910再進去單身會當掉/工廠別ALL的不出現在畫面上
# Modify.........: NO.FUN-670015 06/07/11 BY yiting 交易幣別匯率改抓預設匯率(anmi910)
# Modify.........: No.TQC-680076 06/08/22 By Sarah 單身"類別名稱"欄位沒有顯示
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.MOD-6A0176 06/11/10 By Smapmin 幣別輸入沒有控管資料正確性
# Modify.........: No.FUN-6B0030 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.FUN-6B0079 06/12/04 By jamie 1.FUNCTION _fetch() 清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6C0017 06/12/14 By jamie 程式開頭增加'database ds'
# Modify.........: No.TQC-740024 07/04/06 By Judy 1."運營中心"開窗查詢報錯
#                                                 2.復制時版本開窗選擇不顯示
# Modify.........: No.MOD-740191 07/04/23 By Nicola 單身無法新增
# Modify.........: No.MOD-740259 07/04/23 By Nicola 金額可為正負值
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-830100 08/04/07 By mike 報表輸出方式轉為Crystal Reports  
# Modify.........: No.FUN-870151 08/08/12 By sherry  匯率調整為用azi07取位
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0201 09/11/24 nqg06值不一致的问题
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/08 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds        #FUN-6C0017
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_nqg01      LIKE nqg_file.nqg01,
       g_nqg02      LIKE nqg_file.nqg02,
       g_nqg03      LIKE nqg_file.nqg03,
       g_nqg01_t    LIKE nqg_file.nqg01,
       g_nqg02_t    LIKE nqg_file.nqg02,
       g_nqg03_t    LIKE nqg_file.nqg03,
       g_azp02      LIKE azp_file.azp02,
       g_nqa01      LIKE nqa_file.nqa01,
       g_nqc05      LIKE nqc_file.nqc05,
       g_nqg        DYNAMIC ARRAY OF RECORD
                       nqg04   LIKE nqg_file.nqg04,
                       nqg05   LIKE nqg_file.nqg05,
                       nqg06   LIKE nqg_file.nqg06,
                       nqd02   LIKE nqd_file.nqd02,
                       nqg10   LIKE nqg_file.nqg10,
                       nqg11   LIKE nqg_file.nqg11,
                       nqg12   LIKE nqg_file.nqg12,
                       nqg13   LIKE nqg_file.nqg13,
                       nqg14   LIKE nqg_file.nqg14
                    END RECORD,
       g_nqg_t      RECORD
                       nqg04   LIKE nqg_file.nqg04,
                       nqg05   LIKE nqg_file.nqg05,
                       nqg06   LIKE nqg_file.nqg06,
                       nqd02   LIKE nqd_file.nqd02,
                       nqg10   LIKE nqg_file.nqg10,
                       nqg11   LIKE nqg_file.nqg11,
                       nqg12   LIKE nqg_file.nqg12,
                       nqg13   LIKE nqg_file.nqg13,
                       nqg14   LIKE nqg_file.nqg14
                    END RECORD,
       g_wc,g_sql   STRING,      
       g_rec_b      LIKE type_file.num5,         #No.FUN-680107 SMALLINT
       l_ac         LIKE type_file.num5          #No.FUN-680107 SMALLINT
 
DEFINE g_argv1      LIKE nqg_file.nqg01          #NO.FUN-640089 add
DEFINE g_argv2      LIKE nqg_file.nqg02          #NO.FUN-640089 add
DEFINE g_argv3      LIKE nqg_file.nqg03          #NO.FUN-640089 add
DEFINE g_forupd_sql STRING        
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680107 SMALLINT
DEFINE g_cnt        LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_msg        LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(72)
DEFINE g_row_count  LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_curs_index LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_jump       LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5          #No.FUN-680107 SMALLINT
DEFINE t_azi04_1    LIKE azi_file.azi04   #No.FUN-640132  #NO.CHI-6A0004
DEFINE t_azi04_2    LIKE azi_file.azi04   #No.FUN-640132  #NO.CHI-6A0004
DEFINE t_azi04_3    LIKE azi_file.azi04   #No.FUN-640132  #NO.CHI-6A0004
DEFINE g_str        STRING                #No.FUN-830100                                                                            
DEFINE l_table      STRING                #No.FUN-830100    
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0082
   DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680107 SMALLINT
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)              #NO.FUN-640089 ADD
   LET g_argv2 = ARG_VAL(2)              #NO.FUN-640089 ADD
   LET g_argv3 = ARG_VAL(3)              #NO.FUN-640089 ADD
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
#No.FUN-830100  --BEGIN                                                                                                             
   LET g_sql = "nqg01.nqg_file.nqg01,",                                                                                             
               "azp02.azp_file.azp02,",                                                                                             
               "nqg02.nqg_file.nqg02,",                                                                                             
               "nqg03.nqg_file.nqg03,",                                                                                             
               "nqa01.nqa_file.nqa01,",                                                                                             
               "nqg04.nqg_file.nqg04,",                                                                                             
               "nqg05.nqg_file.nqg05,",                                                                                             
               "nqg06.nqg_file.nqg06,",                                                                                             
               "nqd02.nqd_file.nqd02,",                                                                                             
               "nqg10.nqg_file.nqg10,",                                                                                             
               "nqg11.nqg_file.nqg11,",                                                                                             
               "nqg12.nqg_file.nqg12,",                                                                                             
               "nqg13.nqg_file.nqg13,",                                                                                             
               "nqg14.nqg_file.nqg14,",                                                                                             
               "t_azi04_1.azi_file.azi04,",                                                                                         
               "t_azi04_2.azi_file.azi04,",                                                                                         
               "t_azi04_3.azi_file.azi04,",
               "azi07.azi_file.azi07 "  #No.FUN-870151                                                                                           
   LET l_table = cl_prt_temptable("anmt910",g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"        #FUN-870151 Add ?                                                                     
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                           
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
#No.FUN-830100  --END      
   LET p_row = 4 LET p_col = 2
 
   OPEN WINDOW t910_w AT p_row,p_col
     WITH FORM "anm/42f/anmt910"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
#NO.FUN-640089 start--
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) AND NOT cl_null(g_argv3) THEN
       CALL t910_q()
       CALL t910_b_fill("1=1")
   END IF
#NO.FUN-640089 end--
   CALL t910_menu()
 
   CLOSE WINDOW t910_w                 #結束畫面
 
   CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
 
END MAIN
 
FUNCTION t910_cs()
 
#NO.FUN-640089 start--
   IF (g_argv1 = " " OR g_argv1 IS NULL) OR
      (g_argv2 = " " OR g_argv2 IS NULL) OR
      (g_argv3 = " " OR g_argv3 IS NULL) THEN
#NO.FUN-640089 end----
       CLEAR FORM                             #清除畫面
       CALL g_nqg.clear()
       CALL cl_set_head_visible("","YES")       #No.FUN-6B0030
   INITIALIZE g_nqg01 TO NULL    #No.FUN-750051
   INITIALIZE g_nqg02 TO NULL    #No.FUN-750051
   INITIALIZE g_nqg03 TO NULL    #No.FUN-750051
       CONSTRUCT g_wc ON nqg01,nqg02,nqg03,nqg04,nqg05,nqg06,nqg10,nqg11,
                         nqg12,nqg13,nqg14
           FROM nqg01,nqg02,nqg03,s_nqg[1].nqg04,s_nqg[1].nqg05,
                s_nqg[1].nqg06,s_nqg[1].nqg10,s_nqg[1].nqg11,
                s_nqg[1].nqg12,s_nqg[1].nqg13,s_nqg[1].nqg14
 
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
          ON ACTION CONTROLP
             CASE
                #-----No.FUN-640112-----
                WHEN INFIELD(nqg01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_nqf"
                   LET g_qryparam.default1 = g_nqg01
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO nqg01
                   NEXT FIELD nqg01
                #-----No.FUN-640112 END-----
                WHEN INFIELD(nqg02)
                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_azp"
                   LET g_qryparam.form = "q_azp1"   #NO.FUN-670015
                   LET g_qryparam.state = "c"
                   LET g_qryparam.default1 = g_nqg02
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO nqg02
                   NEXT FIELD nqg02
                #No.TQC-650131--start--
                WHEN INFIELD(nqg03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azi"
                   LET g_qryparam.default1 = g_nqg03
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO nqg03
                   NEXT FIELD nqg03
                #No.TQC-650131--end--
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
       IF INT_FLAG THEN
         RETURN
       END IF
#NO.FUN-640089 start-- 
   ELSE             
       LET g_wc = " nqg01 = '",g_argv1,"'",
                  "   AND nqg02 = '",g_argv2,"'",
                  "   AND nqg03 = '",g_argv3,"'" 
   END IF                                     
##NO.FUN-640089  end----
 
       LET g_sql = "SELECT UNIQUE nqg01,nqg02,nqg03 FROM nqg_file ",
                   " WHERE ", g_wc CLIPPED,
                   "   AND nqg02 <> 'ALL'",   #NO.FUN-670015
                   " ORDER BY nqg01,nqg02,nqg03"
 
       PREPARE t910_prepare FROM g_sql
       DECLARE t910_bcs SCROLL CURSOR WITH HOLD FOR t910_prepare
 
       LET g_sql = "SELECT UNIQUE nqg01,nqg02,nqg03 FROM nqg_file ",
                   " WHERE ", g_wc CLIPPED,
                   "   AND nqg02 <> 'ALL'",   #NO.FUN-670015
                   " INTO TEMP x "
       DROP TABLE x
       PREPARE t910_precount_x FROM g_sql
       EXECUTE t910_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x"
   PREPARE t910_precount FROM g_sql
   DECLARE t910_count CURSOR FOR t910_precount
 
END FUNCTION
 
FUNCTION t910_menu()
 
   WHILE TRUE
      CALL t910_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t910_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t910_q()
            END IF
#NO.FUN-670015 start--
#         WHEN "delete"
#            IF cl_chk_act_auth() THEN
#               CALL t910_r()
#            END IF
#NO.FUN-670015 end--
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t910_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t910_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t910_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nqg),'','')
            END IF
         #No.FUN-6B0079-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_nqg01 IS NOT NULL THEN
                LET g_doc.column1 = "nqg01"
                LET g_doc.column2 = "nqg02"
                LET g_doc.column3 = "nqg03"
                LET g_doc.value1 = g_nqg01
                LET g_doc.value2 = g_nqg02
                LET g_doc.value3 = g_nqg03
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6B0079-------add--------end----
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION t910_a()
 
   IF s_anmshut(0) THEN
      RETURN
   END IF
 
   MESSAGE ""
   CLEAR FORM
   CALL g_nqg.clear()
   SELECT nqa01 INTO g_nqa01 FROM nqa_file
    WHERE nqa00 = "0"
   DISPLAY g_nqa01 TO nqa01
   LET g_nqg01 = NULL   #No.MOD-640117
   LET g_nqg02 = NULL   #No.MOD-640117
   LET g_nqg03 = NULL   #No.MOD-640117
   LET g_nqg01_t = NULL
   LET g_nqg02_t = NULL
   LET g_nqg03_t = NULL
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL t910_i("a")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      LET g_rec_b = 0
      DISPLAY g_rec_b TO FORMONLY.cn2
 
      CALL t910_b()
 
      LET g_nqg01_t = g_nqg01
      LET g_nqg02_t = g_nqg02
      LET g_nqg03_t = g_nqg03
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t910_u()
 
   IF s_anmshut(0) THEN
      RETURN
   END IF
 
   IF g_nqg01 IS NULL OR g_nqg02 IS NULL OR g_nqg03 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_nqg01_t = g_nqg01
   LET g_nqg02_t = g_nqg02
   LET g_nqg03_t = g_nqg03
 
   WHILE TRUE
      CALL t910_i("u") 
 
      IF INT_FLAG THEN
         LET g_nqg01 = g_nqg01_t
         LET g_nqg02 = g_nqg02_t
         LET g_nqg03 = g_nqg03_t
         DISPLAY g_nqg01,g_nqg02,g_nqg03 TO nqg01,nqg02,nqg03
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_nqg01 != g_nqg01_t OR g_nqg02 != g_nqg02_t OR g_nqg03 != g_nqg03_t THEN
         UPDATE nqg_file SET nqg01 = g_nqg01,
                             nqg02 = g_nqg02,
                             nqg03 = g_nqg03
          WHERE nqg01 = g_nqg01_t
            AND nqg02 = g_nqg02_t
            AND nqg03 = g_nqg03_t
         IF SQLCA.sqlcode THEN
            LET g_msg = g_nqg01 CLIPPED,' + ',g_nqg02 CLIPPED
#           CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("upd","nqg_file",g_nqg01_t,g_nqg02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CONTINUE WHILE
         END IF
      END IF
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t910_i(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680107 VARCHAR(1)
   CALL cl_set_head_visible("","YES")       #No.FUN-6B0030
 
   INPUT g_nqg01,g_nqg02,g_nqg03 WITHOUT DEFAULTS FROM nqg01,nqg02,nqg03
 
      AFTER FIELD nqg01
         IF NOT cl_null(g_nqg01) THEN
            IF g_nqg01 != g_nqg01_t OR g_nqg01_t IS NULL THEN
               SELECT COUNT(*) INTO g_cnt FROM nqf_file
                WHERE nqf00 = g_nqg01
               IF g_cnt = 0 THEN
                  CALL cl_err(g_nqg01,"anm-027",0)
                  NEXT FIELD nqg01
               END IF
            END IF
         END IF
 
      AFTER FIELD nqg02
         IF NOT cl_null(g_nqg02) THEN
            IF g_nqg02 != g_nqg02_t OR g_nqg02_t IS NULL THEN
               SELECT COUNT(*) INTO g_cnt FROM nqf_file
                WHERE nqf00 = g_nqg01
                  AND nqf01_1 = g_nqg02
               IF g_cnt = 0 THEN
                  SELECT COUNT(*) INTO g_cnt FROM nqf_file
                   WHERE nqf00 = g_nqg01
                     AND nqf01_2 = g_nqg02
                  IF g_cnt = 0 THEN
                     SELECT COUNT(*) INTO g_cnt FROM nqf_file
                      WHERE nqf00 = g_nqg01
                        AND nqf01_3 = g_nqg02
                     IF g_cnt = 0 THEN
                        SELECT COUNT(*) INTO g_cnt FROM nqf_file
                         WHERE nqf00 = g_nqg01
                           AND nqf01_4 = g_nqg02
                        IF g_cnt = 0 THEN
                           SELECT COUNT(*) INTO g_cnt FROM nqf_file
                            WHERE nqf00 = g_nqg01
                              AND nqf01_5 = g_nqg02
                           IF g_cnt = 0 THEN
                              SELECT COUNT(*) INTO g_cnt FROM nqf_file
                               WHERE nqf00 = g_nqg01
                                 AND nqf01_6 = g_nqg02
                              IF g_cnt = 0 THEN
                                 SELECT COUNT(*) INTO g_cnt FROM nqf_file
                                  WHERE nqf00 = g_nqg01
                                    AND nqf01_7 = g_nqg02
                                 IF g_cnt = 0 THEN
                                    SELECT COUNT(*) INTO g_cnt FROM nqf_file
                                     WHERE nqf00 = g_nqg01
                                       AND nqf01_8 = g_nqg02
                                    IF g_cnt = 0 THEN
                                       SELECT COUNT(*) INTO g_cnt FROM nqf_file
                                        WHERE nqf00 = g_nqg01
                                          AND nqf01_9 = g_nqg02
                                       IF g_cnt = 0 THEN
                                          SELECT COUNT(*) INTO g_cnt FROM nqf_file
                                           WHERE nqf00 = g_nqg01
                                             AND nqf01_10 = g_nqg02
                                          IF g_cnt = 0 THEN
                                             SELECT COUNT(*) INTO g_cnt FROM nqf_file
                                              WHERE nqf00 = g_nqg01
                                                AND nqf01_11 = g_nqg02
                                             IF g_cnt = 0 THEN
                                                SELECT COUNT(*) INTO g_cnt FROM nqf_file
                                                 WHERE nqf00 = g_nqg01
                                                   AND nqf01_12 = g_nqg02
                                                IF g_cnt = 0 THEN
                                                   SELECT COUNT(*) INTO g_cnt FROM nqf_file
                                                    WHERE nqf00 = g_nqg01
                                                      AND nqf01_13 = g_nqg02
                                                   IF g_cnt = 0 THEN
                                                      SELECT COUNT(*) INTO g_cnt FROM nqf_file
                                                       WHERE nqf00 = g_nqg01
                                                         AND nqf01_14 = g_nqg02
                                                      IF g_cnt = 0 THEN
                                                         SELECT COUNT(*) INTO g_cnt FROM nqf_file
                                                          WHERE nqf00 = g_nqg01
                                                            AND nqf01_15 = g_nqg02
                                                         IF g_cnt = 0 THEN
                                                            SELECT COUNT(*) INTO g_cnt FROM nqf_file
                                                             WHERE nqf00 = g_nqg01
                                                               AND nqf01_16 = g_nqg02
                                                            IF g_cnt = 0 THEN
                                                               CALL cl_err(g_nqg02,"anm-027",0)
                                                               NEXT FIELD nqg02
                                                            END IF
                                                         END IF
                                                      END IF
                                                   END IF
                                                END IF
                                             END IF
                                          END IF
                                       END IF
                                    END IF
                                 END IF
                              END IF
                           END IF
                        END IF
                     END IF
                  END IF
               END IF
            END IF
            SELECT azp02 INTO g_azp02 FROM azp_file
             WHERE azp01 = g_nqg02
            DISPLAY g_azp02 TO azp02
         END IF
       
         #-----No.FUN-640132 END-----
     AFTER FIELD nqg03
         SELECT azi04 INTO t_azi04_2 FROM azi_file  #NO.CHI-6A0004
          WHERE azi01 = g_nqg03
         SELECT azi04 INTO t_azi04_3 FROM azi_file  #NO.CHI-6A0004
          WHERE azi01 = g_nqa01
         #-----No.FUN-640132 END-----
 
      AFTER INPUT
         IF INT_FLAG THEN
             EXIT INPUT
         END IF
         IF (g_nqg01 != g_nqg01_t OR g_nqg01_t IS NULL)
            AND (g_nqg02 != g_nqg02_t OR g_nqg02_t IS NULL) THEN
            SELECT COUNT(*) INTO g_cnt FROM nqg_file
             WHERE nqg01 = g_nqg01
               AND nqg02 = g_nqg02
            IF g_cnt > 0 THEN
               CALL cl_err("","axm-298",0)
               NEXT FIELD nqg01
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE
            #-----No.FUN-640112-----
            WHEN INFIELD(nqg01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nqf"
               LET g_qryparam.default1 = g_nqg01
               CALL cl_create_qry() RETURNING g_nqg01
               DISPLAY BY NAME g_nqg01
               NEXT FIELD nqg01
            #-----No.FUN-640112 END-----
            WHEN INFIELD(nqg02)
               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_nqg"   #No.FUN-640112
#              LET g_qryparam.form = "q_nqg1"   #No.FUN-670015 #TQC-740024
               LET g_qryparam.form = "q_nqg11"  #TQC-740024  
               LET g_qryparam.default1 = g_nqg02
               LET g_qryparam.arg1 = g_nqg01   #No.FUN-640112
               CALL cl_create_qry() RETURNING g_nqg02
               DISPLAY BY NAME g_nqg02
               NEXT FIELD nqg02
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
 
FUNCTION t910_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
 
   MESSAGE ""
   CALL cl_opmsg('q')
 
   CALL t910_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_nqg01 TO NULL
      INITIALIZE g_nqg02 TO NULL
      INITIALIZE g_nqg03 TO NULL
      RETURN
   END IF
 
   OPEN t910_bcs
   IF SQLCA.sqlcode THEN
      CALL cl_err("",SQLCA.sqlcode,0)
      INITIALIZE g_nqg01 TO NULL
      INITIALIZE g_nqg02 TO NULL
      INITIALIZE g_nqg03 TO NULL
   ELSE
      CALL t910_fetch('F')
      OPEN t910_count
      FETCH t910_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
   END IF
 
END FUNCTION
 
FUNCTION t910_fetch(p_flag)
DEFINE p_flag   LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
       l_abso   LIKE type_file.num10         #No.FUN-680107 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     t910_bcs INTO g_nqg01,g_nqg02,g_nqg03
      WHEN 'P' FETCH PREVIOUS t910_bcs INTO g_nqg01,g_nqg02,g_nqg03
      WHEN 'F' FETCH FIRST    t910_bcs INTO g_nqg01,g_nqg02,g_nqg03
      WHEN 'L' FETCH LAST     t910_bcs INTO g_nqg01,g_nqg02,g_nqg03
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
 
            FETCH ABSOLUTE g_jump t910_bcs INTO g_nqg01,g_nqg02,g_nqg03
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_nqg01,SQLCA.sqlcode,0)
      INITIALIZE g_nqg01 TO NULL                 #NO.FUN-6B0079 add
      INITIALIZE g_nqg02 TO NULL                 #NO.FUN-6B0079 add
      INITIALIZE g_nqg03 TO NULL                 #NO.FUN-6B0079 add
   ELSE
      CALL t910_show()
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
 
FUNCTION t910_show()
 
   SELECT azp02 INTO g_azp02 FROM azp_file
    WHERE azp01 = g_nqg02
 
   SELECT nqa01 INTO g_nqa01 FROM nqa_file
    WHERE nqa00 = "0"
 
   DISPLAY g_nqg01,g_nqg02,g_nqg03,g_azp02,g_nqa01
        TO nqg01,nqg02,nqg03,azp02,nqa01
 
   CALL t910_b_fill(g_wc)
 
   CALL cl_show_fld_cont()
 
END FUNCTION
 
#NO.FUN-670015 start--不能有刪除功能
#FUNCTION t910_r()
#
#   IF s_anmshut(0) THEN RETURN END IF
#
#   IF g_nqg01 IS NULL THEN
#      RETURN
#   END IF
#
#   IF cl_delh(0,0) THEN
#      DELETE FROM nqg_file
#       WHERE nqg01 = g_nqg01
#         AND nqg02 = g_nqg02
#         AND nqg03 = g_nqg03
#      IF SQLCA.sqlcode THEN
##        CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)   #No.FUN-660148
#         CALL cl_err3("del","nqg_file",g_nqg01,g_nqg02,SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660148
#      ELSE
#         CLEAR FORM
#         CALL g_nqg.clear()
#         LET g_nqg01 = NULL
#         LET g_nqg02 = NULL
#         LET g_nqg03 = NULL
#         LET g_cnt=SQLCA.SQLERRD[3]
#         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
#
#         OPEN t910_count
#         FETCH t910_count INTO g_row_count
#         DISPLAY g_row_count TO FORMONLY.cnt
#
#         OPEN t910_bcs
#         IF g_curs_index = g_row_count + 1 THEN
#            LET g_jump = g_row_count
#            CALL t910_fetch('L')
#         ELSE
#            LET g_jump = g_curs_index
#            LET mi_no_ask = TRUE
#            CALL t910_fetch('/')
#         END IF
#      END IF
#   END IF
#
#END FUNCTION
#NO.#NO.FUN-670015 end--不能有刪除功能
 
FUNCTION t910_b()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_allow_delete  LIKE type_file.num5           #No.FUN-680107 SMALLINT
   DEFINE l_cnt           LIKE type_file.num5   #MOD-6A0176 
 
   LET g_action_choice = ""
 
   IF s_anmshut(0) THEN RETURN END IF
 
   IF g_nqg01 IS NULL THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT nqg04,nqg05,nqg06,'',nqg10,nqg11,nqg12,",
                      "       nqg13,nqg14 ",
                      "  FROM nqg_file",
                      "  WHERE nqg01=? AND nqg02=?",
                      "   AND nqg03=? AND nqg04=?",
                     #No.TQC-9B0201  --Begin
                      "   AND nqg05=? AND nqg06=?",
                     #"   AND nqg06 = '999'",   #NO.FUN-670015
                     #No.TQC-9B0201  --End  
                      "   FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t910_bcl CURSOR FROM g_forupd_sql
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_nqg WITHOUT DEFAULTS FROM s_nqg.*
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
            LET g_nqg_t.* = g_nqg[l_ac].*
            BEGIN WORK
           #No.TQC-9B0201  --Begin
           #FUN-890070
           #OPEN t910_bcl USING g_nqg01,g_nqg02,g_nqg03,g_nqg_t.nqg04  #,g_nqg_t.nqg05
            OPEN t910_bcl USING g_nqg01,g_nqg02,g_nqg03,g_nqg_t.nqg04,
                                g_nqg_t.nqg05,g_nqg_t.nqg06
           #No.TQC-9B0201  --End  
            IF STATUS THEN
               CALL cl_err("OPEN t910_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t910_bcl INTO g_nqg[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_nqg_t.nqg04,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  SELECT nqd02 INTO g_nqg[l_ac].nqd02
                    FROM nqd_file
                   WHERE nqd01 = g_nqg[l_ac].nqg06
                  DISPLAY BY NAME g_nqg[l_ac].nqd02
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF
         CALL t910_set_entry()       #NO.FUN-670015
         CALL t910_set_no_entry()    #NO.FUN-670015
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_nqg[l_ac].* TO NULL
         LET g_nqg_t.* = g_nqg[l_ac].*
         LET g_nqg[l_ac].nqg04 = g_today
         LET g_nqg[l_ac].nqg05 = "1"
         #No.TQC-9B0201  --Begin
         #LET g_nqg[l_ac].nqg06 = "114"   #FUN-890070
         LET g_nqg[l_ac].nqg06 = "999"
         #No.TQC-9B0201  --End  
         #-----MOD-6A0176---------
         SELECT nqd02 INTO g_nqg[l_ac].nqd02
           FROM nqd_file
           WHERE nqd01 = g_nqg[l_ac].nqg06
         #-----END MOD-6A0176-----
         LET g_nqg[l_ac].nqg10 = g_aza.aza17
         LET g_nqg[l_ac].nqg11 = 1
         LET g_nqg[l_ac].nqg12 = 0
         LET g_nqg[l_ac].nqg13 = 0
         LET g_nqg[l_ac].nqg14 = 0
         CALL cl_show_fld_cont()
         CALL t910_set_entry()       #NO.FUN-670015
         CALL t910_set_no_entry()    #NO.FUN-670015
         NEXT FIELD nqg04
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
#NO.FUN-670015 start--每次insert都要塞一筆工廠為ALL的資料
         IF g_nqg03 IS NULL THEN LET g_nqg03 = ' ' END IF
         INSERT INTO nqg_file (nqg01,nqg02,nqg03,nqg04,nqg05,nqg06,
                               nqg10,nqg11,nqg12,nqg13,nqg14)
              VALUES(g_nqg01,'ALL',g_nqg03,g_nqg[l_ac].nqg04,
                     g_nqg[l_ac].nqg05,g_nqg[l_ac].nqg06,
                     g_nqg[l_ac].nqg10,g_nqg[l_ac].nqg11,
                     g_nqg[l_ac].nqg12,g_nqg[l_ac].nqg13,
                     g_nqg[l_ac].nqg14)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","nqg_file",g_nqg01,g_nqg02,SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         END IF
#NO.FUN-670015 end----
         INSERT INTO nqg_file (nqg01,nqg02,nqg03,nqg04,nqg05,nqg06,
                               nqg10,nqg11,nqg12,nqg13,nqg14)
              VALUES(g_nqg01,g_nqg02,g_nqg03,g_nqg[l_ac].nqg04,
                     g_nqg[l_ac].nqg05,g_nqg[l_ac].nqg06,
                     g_nqg[l_ac].nqg10,g_nqg[l_ac].nqg11,
                     g_nqg[l_ac].nqg12,g_nqg[l_ac].nqg13,
                     g_nqg[l_ac].nqg14)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_nqg[l_ac].nqg04,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("ins","nqg_file",g_nqg01,g_nqg02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      AFTER FIELD nqg04
         SELECT nqc05 INTO g_nqc05 FROM nqc_file
          WHERE nqc01 = g_nqa01
            #AND nqc02 = g_nqg03
            AND nqc02 = g_nqg[l_ac].nqg10   #NO.FUN-670015
            AND nqc03 = YEAR(g_nqg[l_ac].nqg04)
            AND nqc04 = MONTH(g_nqg[l_ac].nqg04)
         IF STATUS THEN
            LET g_nqc05 = 1
         END IF
         IF g_nqg[l_ac].nqg10 = g_nqg03 THEN LET g_nqc05 = 1 END IF  #NO.FUN-670015 AD
         LET g_nqg[l_ac].nqg11= g_nqc05   #NO.FUN-670015 ADD
         #-----MOD-6A0176---------
         IF cl_null(g_nqg_t.nqg04) OR g_nqg_t.nqg04 <> g_nqg[l_ac].nqg04 THEN  #No.MOD-740191
            SELECT COUNT(*) INTO l_cnt FROM nqg_file
               WHERE nqg01 = g_nqg01
                 AND nqg02 = g_nqg02
                 AND nqg03 = g_nqg03
                 AND nqg04 = g_nqg[l_ac].nqg04
                 AND nqg05 = g_nqg[l_ac].nqg05
                 AND nqg06 = g_nqg[l_ac].nqg06
            IF l_cnt > 0 THEN
               CALL cl_err("","axm-298",0)
               NEXT FIELD nqg04
            END IF
         END IF
         #-----END MOD-6A0176-----
 
      AFTER FIELD nqg05
         #-----MOD-6A0176---------
#        IF NOT cl_null(g_nqg[l_ac].nqg06) THEN
#           IF g_nqg[l_ac].nqg06 != g_nqg_t.nqg06 OR g_nqg_t.nqg06 IS NULL THEN
#              SELECT nqd02 INTO g_nqg[l_ac].nqd02
#                FROM nqd_file
#               WHERE nqd01 = g_nqg[l_ac].nqg06
#              IF STATUS THEN
##                CALL cl_err(g_nqg[l_ac].nqg06,"aoo-109",0)   #No.FUN-660148
#                 CALL cl_err3("sel","nqd_file",g_nqg[l_ac].nqg06,"","aoo-109","","",1)  #No.FUN-660148
#                 NEXT FIELD nqg06
#              END IF
#              DISPLAY BY NAME g_nqg[l_ac].nqd02
#           END IF
#        END IF
         IF cl_null(g_nqg_t.nqg05) OR g_nqg_t.nqg05 <> g_nqg[l_ac].nqg05 THEN  #No.MOD-740191
            SELECT COUNT(*) INTO l_cnt FROM nqg_file
               WHERE nqg01 = g_nqg01
                 AND nqg02 = g_nqg02
                 AND nqg03 = g_nqg03
                 AND nqg04 = g_nqg[l_ac].nqg04
                 AND nqg05 = g_nqg[l_ac].nqg05
                 AND nqg06 = g_nqg[l_ac].nqg06
            IF l_cnt > 0 THEN
               CALL cl_err("","axm-298",0)
               NEXT FIELD nqg05
            END IF
         END IF
         #-----END MOD-6A0176-----
 
      AFTER FIELD nqg10
         IF NOT cl_null(g_nqg[l_ac].nqg10) THEN
            IF g_nqg[l_ac].nqg10 != g_nqg_t.nqg10 OR g_nqg_t.nqg10 IS NULL THEN
               SELECT COUNT(*) INTO g_cnt FROM azi_file
                WHERE azi01 = g_nqg[l_ac].nqg10
               #IF g_cnt < 0 THEN   #MOD-6A0176
               IF g_cnt = 0 THEN   #MOD-6A0176
                  CALL cl_err(g_nqg[l_ac].nqg10,"aap-002",0)
                  NEXT FIELD nqg10
               END IF
#               LET g_nqg[l_ac].nqg11 = s_curr3(g_nqg[l_ac].nqg10,g_today,"S")   #NO.FUN-670015 MARK
               DISPLAY BY NAME g_nqg[l_ac].nqg11                                #NO.FUN-670015 MARK
            END IF
 #NO.FUN-670015 start--
            SELECT nqc05 INTO g_nqc05 FROM nqc_file
             WHERE nqc01 = g_nqa01
               AND nqc02 = g_nqg[l_ac].nqg10   #NO.FUN-670015
               AND nqc03 = YEAR(g_nqg[l_ac].nqg04)
               AND nqc04 = MONTH(g_nqg[l_ac].nqg04)
            IF STATUS THEN
                LET g_nqc05 = 1
            END IF
            IF g_nqg[l_ac].nqg10 = g_nqg03 THEN LET g_nqc05 = 1 END IF  #NO.FUN-670015 AD
            LET g_nqg[l_ac].nqg11= g_nqc05   #NO.FUN-670015 ADD
            DISPLAY BY NAME g_nqg[l_ac].nqg11                                #NO.FUN-670015 MARK
 #NO.FUN-670015 end--
         END IF
         #-----No.FUN-640132-----
         SELECT azi04 INTO t_azi04_1 FROM azi_file  #NO.CHI-6A0004
          WHERE azi01 = g_nqg[l_ac].nqg10
         SELECT azi04 INTO t_azi04_2 FROM azi_file   #NO.CHI-6A0004
          WHERE azi01 = g_nqg03
         SELECT azi04 INTO t_azi04_3 FROM azi_file  #NO.CHI-6A0004
          WHERE azi01 = g_nqa01
         #-----No.FUN-640132 END-----
         CALL t910_set_entry()       #NO.FUN-670015
         CALL t910_set_no_entry()    #NO.FUN-670015
 
      AFTER FIELD nqg11
         IF g_nqg[l_ac].nqg11 < 0 THEN
            CALL cl_err(g_nqg[l_ac].nqg11,"afa-040",0)
            NEXT FIELD nqg11
         END IF
 
      AFTER FIELD nqg12
        ##-----No.MOD-740259 Mark-----
        #IF g_nqg[l_ac].nqg12 < 0 THEN
        #   CALL cl_err(g_nqg[l_ac].nqg12,"afa-040",0)
        #   NEXT FIELD nqg12
        #ELSE
            IF g_nqg[l_ac].nqg12 != g_nqg_t.nqg12 OR g_nqg_t.nqg12 IS NULL THEN
               LET g_nqg[l_ac].nqg13 = g_nqg[l_ac].nqg12 * g_nqg[l_ac].nqg11
               LET g_nqg[l_ac].nqg14 = g_nqg[l_ac].nqg13 * g_nqc05
               CALL cl_digcut(g_nqg[l_ac].nqg12,t_azi04_1) RETURNING g_nqg[l_ac].nqg12    #NO.FUN-640132   #NO.CHI-6A0004
               CALL cl_digcut(g_nqg[l_ac].nqg13,t_azi04_2) RETURNING g_nqg[l_ac].nqg13    #NO.FUN-640132   #NO.CHI-6A0004
               CALL cl_digcut(g_nqg[l_ac].nqg14,t_azi04_3) RETURNING g_nqg[l_ac].nqg14    #NO.FUN-640132   #NO.CHI-6A0004
               DISPLAY BY NAME g_nqg[l_ac].nqg13,g_nqg[l_ac].nqg14
            END IF
        #END IF
         #-----No.MOD-740259 Mark END-----
 
      AFTER FIELD nqg13
         #-----No.MOD-740259 Mark-----
        #IF g_nqg[l_ac].nqg13 < 0 THEN
        #   CALL cl_err(g_nqg[l_ac].nqg13,"afa-040",0)
        #   NEXT FIELD nqg13
        #ELSE
            IF g_nqg[l_ac].nqg13 != g_nqg_t.nqg13 OR g_nqg_t.nqg13 IS NULL THEN
               LET g_nqg[l_ac].nqg14 = g_nqg[l_ac].nqg13 * g_nqc05
               CALL cl_digcut(g_nqg[l_ac].nqg13,t_azi04_2) RETURNING g_nqg[l_ac].nqg13    #NO.FUN-640132  #NO.CHI-6A0004
               CALL cl_digcut(g_nqg[l_ac].nqg14,t_azi04_3) RETURNING g_nqg[l_ac].nqg14    #NO.FUN-640132  #NO.CHI-6A0004
               DISPLAY BY NAME g_nqg[l_ac].nqg14
            END IF
        #END IF
         #-----No.MOD-740259 Mark END-----
 
      AFTER FIELD nqg14
        ##-----No.MOD-740259 Mark-----
        #IF g_nqg[l_ac].nqg14 < 0 THEN
        #   CALL cl_err(g_nqg[l_ac].nqg14,"afa-040",0)
        #   NEXT FIELD nqg14
        #END IF
        ##-----No.MOD-740259 Mark END-----
         CALL cl_digcut(g_nqg[l_ac].nqg14,t_azi04_3) RETURNING g_nqg[l_ac].nqg14    #NO.FUN-640132  #NO.CHI-6A0004
 
      BEFORE DELETE
         IF g_nqg_t.nqg04 > 0 AND g_nqg_t.nqg04 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
#NO.FUN-670015 start--新增時有新增一筆ALL的資料，刪除時也要一併刪掉
            DELETE FROM nqg_file
             WHERE nqg01 = g_nqg01
               AND nqg02 = 'ALL'
               AND nqg03 = g_nqg03
               AND nqg04 = g_nqg_t.nqg04
               AND nqg05 = g_nqg_t.nqg05
               AND nqg06 = g_nqg_t.nqg06
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","nqg_file",g_nqg01,g_nqg_t.nqg04,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               ROLLBACK WORK
               CANCEL DELETE
            END IF
#NO.FUN-670015 end---
            DELETE FROM nqg_file
             WHERE nqg01 = g_nqg01
               AND nqg02 = g_nqg02
               AND nqg03 = g_nqg03
               AND nqg04 = g_nqg_t.nqg04
               AND nqg05 = g_nqg_t.nqg05
               AND nqg06 = g_nqg_t.nqg06
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_nqg_t.nqg04,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("del","nqg_file",g_nqg01,g_nqg_t.nqg04,SQLCA.sqlcode,"","",1)  #No.FUN-660148
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
            LET g_nqg[l_ac].* = g_nqg_t.*
            CLOSE t910_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_nqg[l_ac].nqg04,-263,1)
            LET g_nqg[l_ac].* = g_nqg_t.*
         ELSE
            UPDATE nqg_file SET nqg04 = g_nqg[l_ac].nqg04,
                                nqg05 = g_nqg[l_ac].nqg05,
                                nqg06 = g_nqg[l_ac].nqg06,
                                nqg10 = g_nqg[l_ac].nqg10,
                                nqg11 = g_nqg[l_ac].nqg11,
                                nqg12 = g_nqg[l_ac].nqg12,
                                nqg13 = g_nqg[l_ac].nqg13,
                                nqg14 = g_nqg[l_ac].nqg14
             WHERE nqg01 = g_nqg01
               AND nqg02 = g_nqg02
               AND nqg03 = g_nqg03
               AND nqg04 = g_nqg_t.nqg04
               AND nqg05 = g_nqg_t.nqg05
               AND nqg06 = g_nqg_t.nqg06
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_nqg[l_ac].nqg04,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("upd","nqg_file",g_nqg01,g_nqg_t.nqg04,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               LET g_nqg[l_ac].* = g_nqg_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
      #  LET l_ac_t = l_ac  #FUN-D30032 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_nqg[l_ac].* = g_nqg_t.*
           #FUN-D30032--add--str--
            ELSE
               CALL g_nqg.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
           #FUN-D30032--add--end--
            END IF
            CLOSE t910_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30032 add
         CLOSE t910_bcl
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(nqg10)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = g_nqg[l_ac].nqg10
               CALL cl_create_qry() RETURNING g_nqg[l_ac].nqg10
               DISPLAY BY NAME g_nqg[l_ac].nqg10
               NEXT FIELD nqg10
            OTHERWISE
         END CASE
      ON ACTION controls                       # No.FUN-6B0030
       CALL cl_set_head_visible("","AUTO")      # No.FUN-6B0030
 
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
 
   CLOSE t910_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t910_b_fill(p_wc)
   DEFINE p_wc   LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(200)
 
   LET g_sql = "SELECT nqg04,nqg05,nqg06,'',nqg10,nqg11,",
               "       nqg12,nqg13,nqg14",
               "  FROM nqg_file ",
               " WHERE nqg01 = '",g_nqg01,"'",
               "   AND nqg02 = '",g_nqg02,"'",
               "   AND nqg03 = '",g_nqg03,"'",
               "   AND nqg06 = '999'",         #NO.FUN-650177
               "   AND ",p_wc CLIPPED ,
               " ORDER BY nqg04,nqg05,nqg06"
 
   PREPARE t910_prepare2 FROM g_sql
   DECLARE nqg_cs CURSOR FOR t910_prepare2
 
   LET g_cnt = 1
   LET g_rec_b=0
   CALL g_nqg.clear()
 
   FOREACH nqg_cs INTO g_nqg[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      SELECT nqd02 INTO g_nqg[g_cnt].nqd02
        FROM nqd_file
       WHERE nqd01 = g_nqg[g_cnt].nqg06   #TQC-680076 modify key值寫錯,nqg05->nqg06
#NO.FUN-640132 start
      CALL cl_digcut(g_nqg[g_cnt].nqg12,t_azi04_1) RETURNING g_nqg[g_cnt].nqg12    #NO.FUN-640132  #NO.CHI-6A0004
      CALL cl_digcut(g_nqg[g_cnt].nqg13,t_azi04_2) RETURNING g_nqg[g_cnt].nqg13    #NO.FUN-640132  #NO.CHI-6A0004
      CALL cl_digcut(g_nqg[g_cnt].nqg14,t_azi04_3) RETURNING g_nqg[g_cnt].nqg14    #NO.FUN-640132  #NO.CHI-6A0004
#NO.FUN-640132 end
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_nqg.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t910_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nqg TO s_nqg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
#NO.FUN-670015 MARK-
#      ON ACTION delete
#         LET g_action_choice="delete"
#         EXIT DISPLAY
#NO.FUN-670015 MARK--
      ON ACTION first
         CALL t910_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL t910_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL t910_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL t910_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL t910_fetch('L')
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
      ON ACTION controls                       # No.FUN-6B0030
         CALL cl_set_head_visible("","AUTO")      # No.FUN-6B0030
 
      ON ACTION related_document                #No.FUN-6B0079  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION t910_copy()
   DEFINE l_oldno1   LIKE nqg_file.nqg01,
          l_oldno2   LIKE nqg_file.nqg02,
          l_newno1   LIKE nqg_file.nqg01,
          l_newno2   LIKE nqg_file.nqg02
 
   IF s_anmshut(0) THEN RETURN END IF
 
   IF g_nqg01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")       #No.FUN-6B0030
 
   INPUT l_newno1,l_newno2 FROM nqg01,nqg02
 
      AFTER FIELD nqg01
         IF cl_null(l_newno1) THEN
            NEXT FIELD nqg01
         ELSE
            SELECT COUNT(*) INTO g_cnt FROM nqf_file
             WHERE nqf00 = l_newno1
            IF g_cnt = 0 THEN
               CALL cl_err(l_newno1,"anm-027",0)
               NEXT FIELD nqg01
            END IF
         END IF
 
      AFTER FIELD nqg02
         IF cl_null(l_newno2) THEN
            NEXT FIELD nqg02
         ELSE
            SELECT COUNT(*) INTO g_cnt FROM nqf_file
             WHERE nqf00 = g_nqg01
               AND nqf01_1 = l_newno2
            IF g_cnt = 0 THEN
               SELECT COUNT(*) INTO g_cnt FROM nqf_file
                WHERE nqf00 = g_nqg01
                  AND nqf01_2 = l_newno2
               IF g_cnt = 0 THEN
                  SELECT COUNT(*) INTO g_cnt FROM nqf_file
                   WHERE nqf00 = g_nqg01
                     AND nqf01_3 = l_newno2
                  IF g_cnt = 0 THEN
                     SELECT COUNT(*) INTO g_cnt FROM nqf_file
                      WHERE nqf00 = g_nqg01
                        AND nqf01_4 = l_newno2
                     IF g_cnt = 0 THEN
                        SELECT COUNT(*) INTO g_cnt FROM nqf_file
                         WHERE nqf00 = g_nqg01
                           AND nqf01_5 = l_newno2
                        IF g_cnt = 0 THEN
                           SELECT COUNT(*) INTO g_cnt FROM nqf_file
                            WHERE nqf00 = g_nqg01
                              AND nqf01_6 = l_newno2
                           IF g_cnt = 0 THEN
                              SELECT COUNT(*) INTO g_cnt FROM nqf_file
                               WHERE nqf00 = g_nqg01
                                 AND nqf01_7 = l_newno2
                              IF g_cnt = 0 THEN
                                 SELECT COUNT(*) INTO g_cnt FROM nqf_file
                                  WHERE nqf00 = g_nqg01
                                    AND nqf01_8 = l_newno2
                                 IF g_cnt = 0 THEN
                                    SELECT COUNT(*) INTO g_cnt FROM nqf_file
                                     WHERE nqf00 = g_nqg01
                                       AND nqf01_9 = l_newno2
                                    IF g_cnt = 0 THEN
                                       SELECT COUNT(*) INTO g_cnt FROM nqf_file
                                        WHERE nqf00 = g_nqg01
                                          AND nqf01_10 = l_newno2
                                       IF g_cnt = 0 THEN
                                          SELECT COUNT(*) INTO g_cnt FROM nqf_file
                                           WHERE nqf00 = g_nqg01
                                             AND nqf01_11 = l_newno2
                                          IF g_cnt = 0 THEN
                                             SELECT COUNT(*) INTO g_cnt FROM nqf_file
                                              WHERE nqf00 = g_nqg01
                                                AND nqf01_12 = l_newno2
                                             IF g_cnt = 0 THEN
                                                SELECT COUNT(*) INTO g_cnt FROM nqf_file
                                                 WHERE nqf00 = g_nqg01
                                                   AND nqf01_13 = l_newno2
                                                IF g_cnt = 0 THEN
                                                   SELECT COUNT(*) INTO g_cnt FROM nqf_file
                                                    WHERE nqf00 = g_nqg01
                                                      AND nqf01_14 = l_newno2
                                                   IF g_cnt = 0 THEN
                                                      SELECT COUNT(*) INTO g_cnt FROM nqf_file
                                                       WHERE nqf00 = g_nqg01
                                                         AND nqf01_15 = l_newno2
                                                      IF g_cnt = 0 THEN
                                                         SELECT COUNT(*) INTO g_cnt FROM nqf_file
                                                          WHERE nqf00 = g_nqg01
                                                            AND nqf01_16 = l_newno2
                                                         IF g_cnt = 0 THEN
                                                            CALL cl_err(l_newno2,"anm-027",0)
                                                            NEXT FIELD nqg02
                                                         END IF
                                                      END IF
                                                   END IF
                                                END IF
                                             END IF
                                          END IF
                                       END IF
                                    END IF
                                 END IF
                              END IF
                           END IF
                        END IF
                     END IF
                  END IF
               END IF
            END IF
            SELECT azp02 INTO g_azp02 FROM azp_file
             WHERE azp01 = l_newno2
            DISPLAY g_azp02 TO azp02
         END IF
 
      ON ACTION CONTROLP
         CASE
            #-----No.FUN-640112-----
            WHEN INFIELD(nqg01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nqf"
#TQC-740024.....begin
#              LET g_qryparam.default1 = g_nqg01
#              CALL cl_create_qry() RETURNING g_nqg01
#              DISPLAY BY NAME g_nqg01
               LET g_qryparam.default1 = l_newno1
               CALL cl_create_qry() RETURNING l_newno1
               DISPLAY l_newno1 TO nqg01
#TQC-740024.....end
               NEXT FIELD nqg01
            #-----No.FUN-640112 END-----
            WHEN INFIELD(nqg02)
               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_nqg"   #No.FUN-640112
#              LET g_qryparam.form = "q_nqg1"   #No.FUN-670015 #TQC-740024
               LET g_qryparam.form = "q_nqg11"  #TQC-740024           
               LET g_qryparam.default1 = l_newno2
               LET g_qryparam.arg1 = l_newno1  #No.FUN-640112
               CALL cl_create_qry() RETURNING l_newno2
               DISPLAY l_newno1 TO nqg02
               NEXT FIELD nqg02
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
      CALL t910_show()
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM nqg_file WHERE nqg01=g_nqg01 AND nqg02=g_nqg02 INTO TEMP x
 
   UPDATE x SET nqg01=l_newno1,nqg02=l_newno2
 
   INSERT INTO nqg_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_nqg01,SQLCA.sqlcode,0)   #No.FUN-660148
      CALL cl_err3("ins","nqg_file",g_nqg01,g_nqg02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
   ELSE
      LET g_msg = l_newno1 CLIPPED, ' + ', l_newno2 CLIPPED
      MESSAGE 'ROW(',g_msg,') O.K'
      LET l_oldno1 = g_nqg01
      LET l_oldno2 = g_nqg02
      LET g_nqg01 = l_newno1
      LET g_nqg02 = l_newno2
      CALL t910_b()
      #LET g_nqg01 = l_oldno1  #FUN-C80046
      #LET g_nqg02 = l_oldno2  #FUN-C80046
      #CALL t910_show()        #FUN-C80046
   END IF
 
END FUNCTION
 
FUNCTION t910_out()
   DEFINE l_name   LIKE type_file.chr20,         #No.FUN-680107 VARCHAR(20)
          sr       RECORD     
                      nqg01    LIKE nqg_file.nqg01,
                      azp02    LIKE azp_file.azp02,
                      nqg02    LIKE nqg_file.nqg02,
                      nqg03    LIKE nqg_file.nqg03,
                      nqa01    LIKE nqa_file.nqa01,
                      nqg04    LIKE nqg_file.nqg04,
                      nqg05    LIKE nqg_file.nqg05,
                      nqg06    LIKE nqg_file.nqg06,
                      nqd02    LIKE nqd_file.nqd02,
                      nqg10    LIKE nqg_file.nqg10,
                      nqg11    LIKE nqg_file.nqg11,
                      nqg12    LIKE nqg_file.nqg12,
                      nqg13    LIKE nqg_file.nqg13,
                      nqg14    LIKE nqg_file.nqg14
                   END RECORD 
   CALL cl_del_data(l_table)           #No.FUN-830100 
   #CALL cl_wait()                     #No.FUN-830100
   #CALL cl_outnam('anmt910') RETURNING l_name  #No.FUN-830100
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
   LET g_sql = "SELECT nqg01,'',nqg02,nqg03,'',nqg04,nqg05,nqg06,'',",
               "       nqg10,nqg11,nqg12,nqg13,nqg14",
               "  FROM nqg_file ",
               " WHERE ",g_wc CLIPPED
 
   PREPARE t910_p1 FROM g_sql
   DECLARE t910_curo CURSOR FOR t910_p1
 
   #START REPORT t910_rep TO l_name   #No.FUN-830100
 
   FOREACH t910_curo INTO sr.*   
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)  
         EXIT FOREACH
      END IF
 
      SELECT azp02 INTO sr.azp02 FROM azp_file
       WHERE azp01 = sr.nqg01
 
      SELECT nqa01 INTO sr.nqa01 FROM nqa_file
       WHERE nqa00 = "0"
 
      SELECT nqd02 INTO sr.nqd02 FROM nqd_file
       WHERE nqd01 = sr.nqg06
      #No.FUN-830100  --begin 
      
      SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01 = sr.nqg10  #No.FUN-870151      
      
      #OUTPUT TO REPORT t910_rep(sr.*)
      EXECUTE insert_prep USING sr.nqg01,sr.azp02,sr.nqg02,sr.nqg03,sr.nqa01,                                                       
                                sr.nqg04,sr.nqg05,sr.nqg06,sr.nqd02,sr.nqg10,                                                       
                                sr.nqg11,sr.nqg12,sr.nqg13,sr.nqg14,t_azi04_1,                                                      
                                t_azi04_2,t_azi04_3
                                ,t_azi07  #No.FUN-870151  
      #No.FUN-830100  --end  
 
   END FOREACH
 
   #FINISH REPORT t910_rep  #No.FUN-830100 
 
   CLOSE t910_curo
   ERROR ""
 
   #CALL cl_prt(l_name,' ','1',g_len)  #No.FUN-830100 
   #No.FUN-830100  --begin                                                                                                             
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog                                                                           
   IF g_zz05='Y' THEN                                                                                                               
     CALL cl_wcchp(g_wc,'nqg01,nqg02,nqg03,nqg04,nqg05,nqg06,nqg10,nqg11,                                                           
                         nqg12,nqg13,nqg14')                                                                                        
     RETURNING g_wc                                                                                                                 
     LET g_str = g_wc                                                                                                               
   END IF                                                                                                                           
   LET g_str = g_str CLIPPED                                                                                                        
   LET g_sql="SELECT * FROM ", g_cr_db_str CLIPPED,l_table CLIPPED                                                                  
   CALL cl_prt_cs3('anmt910','anmt910',g_sql,g_str)                                                                                 
#No.FUN-830100  --end                                    
END FUNCTION
 
#No.FUN-830100  --BEGIN                                                                                                             
{                       
REPORT t910_rep(sr)
   DEFINE l_trailer_sw   LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
          sr             RECORD     
                            nqg01    LIKE nqg_file.nqg01,
                            azp02    LIKE azp_file.azp02,
                            nqg02    LIKE nqg_file.nqg02,
                            nqg03    LIKE nqg_file.nqg03,
                            nqa01    LIKE nqa_file.nqa01,
                            nqg04    LIKE nqg_file.nqg04,
                            nqg05    LIKE nqg_file.nqg05,
                            nqg06    LIKE nqg_file.nqg06,
                            nqd02    LIKE nqd_file.nqd02,
                            nqg10    LIKE nqg_file.nqg10,
                            nqg11    LIKE nqg_file.nqg11,
                            nqg12    LIKE nqg_file.nqg12,
                            nqg13    LIKE nqg_file.nqg13,
                            nqg14    LIKE nqg_file.nqg14
                         END RECORD 
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.nqg01,sr.nqg02,sr.nqg03,sr.nqg04
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno" 
         PRINT g_head CLIPPED,pageno_total     
         PRINT 
         PRINT g_x[9],sr.nqg01
         PRINT g_x[10],sr.nqg02,sr.azp02
         PRINT g_x[11],sr.nqg03
         PRINT g_x[12],sr.nqa01
         PRINT g_dash
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
               g_x[38],g_x[39]
         PRINT g_dash1 
         LET l_trailer_sw = "Y"
 
      BEFORE GROUP OF sr.nqg03
         SKIP TO TOP OF PAGE
 
      ON EVERY ROW
         PRINT COLUMN g_c[31],sr.nqg04,
               COLUMN g_c[32],sr.nqg05,
               COLUMN g_c[33],sr.nqg06,
               COLUMN g_c[34],sr.nqd02,
               COLUMN g_c[35],sr.nqg10,
               COLUMN g_c[36],cl_numfor(sr.nqg11,36,0),
               COLUMN g_c[37],cl_numfor(sr.nqg12,37,t_azi04_1),  #NO.CHI-6A0004
               COLUMN g_c[38],cl_numfor(sr.nqg13,38,t_azi04_2),  #NO.CHI-6A0004
               COLUMN g_c[39],cl_numfor(sr.nqg14,39,t_azi04_3)   #NO.CHI-6A0004
 
      ON LAST ROW
         PRINT g_dash
         PRINT g_x[4] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
         LET l_trailer_sw = "N"
 
      PAGE TRAILER
         IF l_trailer_sw = "Y" THEN
            PRINT g_dash
            PRINT g_x[4] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT
}
#No.FUN-830100  --END                                                                                                             
                       
#NO.FUN-670015 start--------------
FUNCTION t910_set_entry()
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
      CALL cl_set_comp_entry("nqg11",TRUE)
END FUNCTION
 
FUNCTION t910_set_no_entry()
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
    IF g_nqg03 = g_nqg[l_ac].nqg10 THEN
        CALL cl_set_comp_entry("nqg11",FALSE)
    END IF
END FUNCTION
#NO.FUN-670015 end---------------
 
