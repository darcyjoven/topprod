# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: anmq900.4gl
# Descriptions...: 資金模擬彙總查詢
# Date & Author..: 06/03/30 By Nicola
# Modify.........: MOD-640115 06/04/09 By Melody
# Modify.........: No.MOD-640099 06/04/10 By Nicola 輸入交易幣別再變成其他選項,幣別未清除
# Modify.........: No.FUN-640164 06/04/11 By Nicola 提供版本視窗查詢
# Modify.........: NO.FUN-640089 06/06/08 BY yiting 增加anmq910 ACTION
# Modify.........: NO.FUN-650177 06/06/22 BY yiting 增加203/204類別
# Modify.........: No.FUN-660148 06/06/27 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6C0174 06/12/28 By Rayven 此程序無法使用excel功能，移除此功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-740155 07/04/27 By Nicola 營業活動的資金調整金額會被加總至委外採購
# Modify.........: No.MOD-8C0232 08/12/24 By chenl  調整sql語句。
# Modify.........: No.TQC-940177 09/05/12 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法 
# Modify.........: No.TQC-950127 09/06/09 By baofei DISPLAY BY NAME g_nqg01有誤                                                     
# Modify.........: No.TQC-950127 09/06/09 By chenmoyan plan是msv中的關鍵字
# Modify.........: No.FUN-980020 09/09/01 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0177 09/11/20 By Carrier SQL STANDARDIZE
# Modify.........: No.FUN-A50102 10/07/12 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-B30211 11/04/06 By yangtingting   未加離開前得cl_used(2) 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_nqg01      LIKE nqg_file.nqg01,
       g_nqg02      LIKE nqg_file.nqg02,
       g_nqg03      LIKE nqg_file.nqg03,
       g_nqa01      LIKE nqa_file.nqa01,
       g_buk_type   LIKE type_file.chr1,             #No.FUN-680107 VARCHAR(1)
       g_buk_code   LIKE rpg_file.rpg01,
       g_cur_type   LIKE type_file.chr1,             #No.FUN-680107 VARCHAR(1)
       g_cur_code   LIKE nqg_file.nqg10,
       g_nqg        DYNAMIC ARRAY OF RECORD
                       date    LIKE type_file.dat,   #No.FUN-680107 DATE
                       nqg_000 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_100 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_101 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_102 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_103 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_104 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_105 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_106 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_107 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_108 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_109 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_110 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_111 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_112 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_113 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_114 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       sum_bus LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_200 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_201 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_202 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_203 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_204 LIKE nqg_file.nqg12,  #NO.FUN-650177 #No.FUN-680107 DEC(30,6)
                       nqg_205 LIKE nqg_file.nqg12,  #NO.FUN-650177 #No.FUN-680107 DEC(30,6)
                       sum_inv LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_300 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_301 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_302 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_303 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_304 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       sum_fin LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       bal     LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       rev     LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       gap     LIKE nqg_file.nqg12   #No.FUN-680107 DEC(30,6)
                    END RECORD,
       g_wc,g_sql   STRING,                         
       g_rec_b      LIKE type_file.num5          #No.FUN-680107 SMALLINT
DEFINE g_cnt        LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_msg        LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(72)
DEFINE g_row_count  LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_curs_index LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_jump       LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5          #No.FUN-680107 SMALLINT
DEFINE past_date    LIKE type_file.dat           #No.FUN-680107 DATE
DEFINE l_bdate      LIKE type_file.dat           #No.FUN-680107 DATE
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0082
   DEFINE p_row,p_col   LIKE type_file.num5      #No.FUN-680107 SMALLINT
 
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
 
   CALL  cl_used(g_prog,g_time,1)  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
 
   DROP TABLE nqg_tmp
# No.FUN-680107 --START
#  CREATE TABLE nqg_tmp ( 
#       nqg01     VARCHAR(2), 
#       nqg02     VARCHAR(10), 
#       ldate     DATE, 
#       nqg_000   DEC(30,0), 
#       nqg_100   DEC(30,0), 
#       nqg_101   DEC(30,0), 
#       nqg_102   DEC(30,0), 
#       nqg_103   DEC(30,0), 
#       nqg_104   DEC(30,0), 
#       nqg_105   DEC(30,0), 
#       nqg_106   DEC(30,0), 
#       nqg_107   DEC(30,0), 
#       nqg_108   DEC(30,0), 
#       nqg_109   DEC(30,0), 
#       nqg_110   DEC(30,0), 
#       nqg_111   DEC(30,0), 
#       nqg_112   DEC(30,0), 
#       nqg_113   DEC(30,0), 
#       nqg_114   DEC(30,0), 
#       sum_bus   DEC(30,0), 
#       nqg_200   DEC(30,0), 
#       nqg_201   DEC(30,0), 
#       nqg_202   DEC(30,0), 
#       nqg_203   DEC(30,0), 
#       nqg_204   DEC(30,0),   #NO.FUN-650177
#       nqg_205   DEC(30,0),   #NO.FUN-650177
#       sum_inv   DEC(30,0), 
#       nqg_300   DEC(30,0), 
#       nqg_301   DEC(30,0), 
#       nqg_302   DEC(30,0), 
#       nqg_303   DEC(30,0), 
#       nqg_304   DEC(30,0), 
#       sum_fin   DEC(30,0), 
#       bal       DEC(30,0), 
#       rev       DEC(30,0), 
#       gap       DEC(30,0))  
   CREATE TEMP TABLE nqg_tmp(
       nqg01     LIKE nqg_file.nqg01,
       nqg02     LIKE nqg_file.nqg02,
       ldate     LIKE type_file.dat,   
       nqg_000   LIKE nqg_file.nqg12,
       nqg_100   LIKE nqg_file.nqg12,
       nqg_101   LIKE nqg_file.nqg12,
       nqg_102   LIKE nqg_file.nqg12,
       nqg_103   LIKE nqg_file.nqg12,
       nqg_104   LIKE nqg_file.nqg12,
       nqg_105   LIKE nqg_file.nqg12,
       nqg_106   LIKE nqg_file.nqg12,
       nqg_107   LIKE nqg_file.nqg12,
       nqg_108   LIKE nqg_file.nqg12,
       nqg_109   LIKE nqg_file.nqg12,
       nqg_110   LIKE nqg_file.nqg12,
       nqg_111   LIKE nqg_file.nqg12,
       nqg_112   LIKE nqg_file.nqg12,
       nqg_113   LIKE nqg_file.nqg12,
       nqg_114   LIKE nqg_file.nqg12,
       sum_bus   LIKE nqg_file.nqg12,
       nqg_200   LIKE nqg_file.nqg12,
       nqg_201   LIKE nqg_file.nqg12,
       nqg_202   LIKE nqg_file.nqg12,
       nqg_203   LIKE nqg_file.nqg12,
       nqg_204   LIKE nqg_file.nqg12,
       nqg_205   LIKE nqg_file.nqg12,
       sum_inv   LIKE nqg_file.nqg12,
       nqg_300   LIKE nqg_file.nqg12,
       nqg_301   LIKE nqg_file.nqg12,
       nqg_302   LIKE nqg_file.nqg12,
       nqg_303   LIKE nqg_file.nqg12,
       nqg_304   LIKE nqg_file.nqg12,
       sum_fin   LIKE nqg_file.nqg12,
       bal       LIKE nqg_file.nqg12,
       rev       LIKE nqg_file.nqg12,
       gap       LIKE nqg_file.nqg12)
#No.FUN-680107 --END
   IF STATUS THEN 
      CALL cl_err('create npg_tmp error',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
   LET p_row = 4 LET p_col = 2
 
   OPEN WINDOW q900_w AT p_row,p_col
     WITH FORM "anm/42f/anmq900"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL q900_menu()
 
   DROP TABLE nqg_tmp
   CLOSE WINDOW q900_w
 
   CALL  cl_used(g_prog,g_time,2)  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
 
END MAIN
 
FUNCTION q900_cs()
 
   CLEAR FORM
   CALL g_nqg.clear()
 
   LET g_buk_type = "5"
 
   CALL cl_set_head_visible("grid01,grid02,grid03","YES")   #No.FUN-6B0030
   INPUT g_nqg01,g_nqg02,g_buk_type,g_buk_code,g_cur_type,g_cur_code
         WITHOUT DEFAULTS FROM nqg01,nqg02,buk_type,buk_code,
                               cur_type,cur_code
 
      BEFORE INPUT
         CALL cl_qbe_init()
 
      AFTER FIELD nqg02
         IF NOT cl_null(g_nqg02) AND g_nqg02 <> "ALL" THEN
            SELECT COUNT(*) INTO g_cnt FROM azp_file
             WHERE azp01 = g_nqg02
            IF g_cnt = 0 THEN
               CALL cl_err(g_nqg02,"aap-025",0)
               NEXT FIELD nqg02
            END IF
            SELECT nqg03 INTO g_nqg03 FROM nqg_file
             WHERE nqg01 = g_nqg01 
               AND nqg02 = g_nqg02 
            DISPLAY g_nqg03 to nqg03
         END IF
         SELECT nqa01 INTO g_nqa01 FROM nqa_file
          WHERE nqa00 = "0"
         DISPLAY g_nqa01 to nqa01
 
      AFTER FIELD buk_type
         IF g_buk_type = "1" THEN
            CALL cl_set_comp_entry("buk_code",TRUE)
            CALL cl_set_comp_required("buk_code",TRUE)
         ELSE
            CALL cl_set_comp_entry("buk_code",FALSE)
            CALL cl_set_comp_required("buk_code",FALSE)
         END IF
 
      AFTER FIELD buk_code
         IF NOT cl_null(g_buk_code) THEN
            SELECT COUNT(*) INTO g_cnt FROM rpg_file
             WHERE rpg01 = g_buk_code
            IF g_cnt = 0 THEN
               CALL cl_err(g_buk_code,"anm-027",0)
               NEXT FIELD buk_code
            END IF
         END IF
 
      ON CHANGE cur_type
         IF g_cur_type = "1" THEN
            CALL cl_set_comp_entry("cur_code",TRUE)
            CALL cl_set_comp_required("cur_code",TRUE)
         ELSE
            CALL cl_set_comp_entry("cur_code",FALSE)
            CALL cl_set_comp_required("cur_code",FALSE)
            LET g_cur_code = ""              #No.MOD-640099
            DISPLAY g_cur_code TO cur_code   #No.MOD-640099
         END IF
 
      AFTER FIELD cur_type
         IF g_nqg02 = "ALL" AND g_cur_type = "2" THEN
            CALL cl_err(g_cur_code,"anm-605",0)  #MOD-640115
            NEXT FIELD cur_type
         END IF
 
      AFTER FIELD cur_code
         IF NOT cl_null(g_cur_code) THEN
            SELECT COUNT(*) INTO g_cnt FROM azi_file
             WHERE azi01 = g_cur_code
            IF g_cnt = 0 THEN
               CALL cl_err(g_cur_code,"aap-002",0)
               NEXT FIELD cur_code
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE
            #-----No.FUN-640164-----
            WHEN INFIELD(nqg01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nqf"
               LET g_qryparam.default1 = g_nqg01
               CALL cl_create_qry() RETURNING g_nqg01
#               DISPLAY BY NAME g_nqg01   #No.TQC-950127 
               DISPLAY  g_nqg01 TO nqg01   #TQC-950127  
               NEXT FIELD nqg01
            #-----No.FUN-640164 END-----
            WHEN INFIELD(nqg02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_nqg02
               CALL cl_create_qry() RETURNING g_nqg02
               NEXT FIELD nqg02
            WHEN INFIELD(buk_code)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rpg"
               LET g_qryparam.default1 = g_buk_code
               CALL cl_create_qry() RETURNING g_buk_code
               NEXT FIELD buk_code
            WHEN INFIELD(cur_code)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = g_cur_code
               CALL cl_create_qry() RETURNING g_cur_code
               NEXT FIELD cur_code
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
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
  
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END INPUT
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   IF g_nqg02 = "ALL" THEN
      LET g_sql = "SELECT UNIQUE nqg01,nqg02,nqg03 FROM nqg_file ",
                  " WHERE nqg01 = '",g_nqg01,"'",
                  " ORDER BY nqg01,nqg02,nqg03"
   ELSE
      LET g_sql = "SELECT UNIQUE nqg01,nqg02,nqg03 FROM nqg_file ",
                  " WHERE nqg01 = '",g_nqg01,"'",
                  "   AND nqg02 = '",g_nqg02,"'",
                  " ORDER BY nqg01,nqg02,nqg03"
   END IF
 
   PREPARE q900_prepare FROM g_sql
   DECLARE q900_bcs SCROLL CURSOR WITH HOLD FOR q900_prepare
 
   IF g_nqg02 = "ALL" THEN
      LET g_sql = "SELECT UNIQUE nqg01,nqg02 FROM nqg_file ",
                  " WHERE nqg01 = '",g_nqg01,"'",
                  " INTO TEMP x "
   ELSE
      LET g_sql = "SELECT UNIQUE nqg01,nqg02 FROM nqg_file ",
                  " WHERE nqg01 = '",g_nqg01,"'",
                  "   AND nqg02 = '",g_nqg02,"'",
                  " INTO TEMP x "
   END IF
   DROP TABLE x
   PREPARE q900_precount_x FROM g_sql
   EXECUTE q900_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x"
   PREPARE q900_precount FROM g_sql
   DECLARE q900_count CURSOR FOR q900_precount
 
END FUNCTION
 
FUNCTION q900_menu()
DEFINE l_msg  LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(70)  #NO.FUN-640089
 
   WHILE TRUE
      CALL q900_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q900_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#No.TQC-6C0174 --start-- mark
#        WHEN "exporttoexcel"
#           IF cl_chk_act_auth() THEN
#              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nqg),'','')
#           END IF
#No.TQC-6C0174 --end--
#NO.FUN-640089 start--
         WHEN "Fund_simulation_detail"
            IF cl_chk_act_auth() THEN
                LET l_msg="anmq910 '",g_nqg01,"' '",g_nqg02,"' '",g_cur_type,"'"
                CALL cl_cmdrun_wait(l_msg)
            END IF
#NO.FUN-640089 end----
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q900_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
 
   MESSAGE ""
   CALL cl_opmsg('q')
 
   CALL q900_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   CALL cl_wait()
 
   CALL q900_sum()
 
   OPEN q900_bcs
   IF SQLCA.sqlcode THEN
      CALL cl_err("",SQLCA.sqlcode,0)
   ELSE
      CALL q900_fetch('F')
      OPEN q900_count
      FETCH q900_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
   END IF
 
END FUNCTION
 
FUNCTION q900_fetch(p_flag)
   DEFINE p_flag   LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
          l_abso   LIKE type_file.num10         #No.FUN-680107 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     q900_bcs INTO g_nqg01,g_nqg02,g_nqg03
      WHEN 'P' FETCH PREVIOUS q900_bcs INTO g_nqg01,g_nqg02,g_nqg03
      WHEN 'F' FETCH FIRST    q900_bcs INTO g_nqg01,g_nqg02,g_nqg03
      WHEN 'L' FETCH LAST     q900_bcs INTO g_nqg01,g_nqg02,g_nqg03
      WHEN '/'
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
 
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
 
         FETCH ABSOLUTE g_jump q900_bcs INTO g_nqg01,g_nqg02,g_nqg03
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nqg01,SQLCA.sqlcode,0)
      INITIALIZE g_nqg01 TO NULL  #TQC-6B0105
      INITIALIZE g_nqg02 TO NULL  #TQC-6B0105
      INITIALIZE g_nqg03 TO NULL  #TQC-6B0105
   ELSE
      CALL q900_show()
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
 
FUNCTION q900_show()
 
   SELECT nqa01 INTO g_nqa01 FROM nqa_file
    WHERE nqa00 = "0"
 
   DISPLAY g_nqg01,g_nqg02,g_nqg03,g_nqa01
        TO nqg01,nqg02,nqg03,nqa01
 
   CALL q900_b_fill(g_wc)
 
   CALL cl_show_fld_cont()
 
END FUNCTION
 
FUNCTION q900_b_fill(p_wc)
   DEFINE p_wc   LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(200)
 
   LET g_sql = "SELECT ldate,nqg_000,nqg_100,nqg_101,nqg_102,nqg_103,",
               "       nqg_104,nqg_105,nqg_106,nqg_107,nqg_108,nqg_109,",
               "       nqg_110,nqg_111,nqg_112,nqg_113,nqg_114,sum_bus,",
               #"       nqg_200,nqg_201,nqg_202,nqg_203,sum_inv,nqg_300,",
               "       nqg_200,nqg_201,nqg_202,nqg_203,nqg_204,nqg_205,sum_inv,nqg_300,",  #NO.FUN-650177
               "       nqg_301,nqg_302,nqg_303,nqg_304,sum_fin,bal,rev,gap", 
               "  FROM nqg_tmp ",
               " WHERE nqg01 = '",g_nqg01,"'",
               "   AND nqg02 = '",g_nqg02,"'",
               " ORDER BY ldate"
 
   PREPARE q900_prepare2 FROM g_sql
   DECLARE nqg_cs CURSOR FOR q900_prepare2
 
   LET g_cnt = 1
   LET g_rec_b=0
   CALL g_nqg.clear()
 
   FOREACH nqg_cs INTO g_nqg[g_cnt].*
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
 
   CALL g_nqg.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION q900_bp(p_ud)
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
         CALL cl_show_fld_cont()
 
#No.FUN-6B0030------Begin--------------                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("grid01,grid02,grid03","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL q900_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL q900_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL q900_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL q900_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL q900_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
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
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
#No.TQC-6C0174 --start-- mark
#     ON ACTION exporttoexcel 
#        LET g_action_choice = 'exporttoexcel'
#        EXIT DISPLAY
#No.TQC-6C0174 --end--
 
#NO.FUN-640089 start--
      ON ACTION Fund_simulation_detail
         LET g_action_choice="Fund_simulation_detail"
         EXIT DISPLAY
#NO.FUN-640089 end--
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION q900_sum() 
   DEFINE l_nqg_tmp   RECORD
                         nqg01     LIKE nqg_file.nqg01,        #No.FUN-680107 VARCHAR(2)
                         nqg02     LIKE nqg_file.nqg02,        #No.FUN-680107 VARCHAR(10)
                         ldate     LIKE type_file.dat,         #No.FUN-680107 DATE
                         nqg_000 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         nqg_100 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         nqg_101 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         nqg_102 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         nqg_103 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         nqg_104 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         nqg_105 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         nqg_106 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         nqg_107 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         nqg_108 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         nqg_109 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         nqg_110 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         nqg_111 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         nqg_112 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         nqg_113 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         nqg_114 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         sum_bus LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         nqg_200 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         nqg_201 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         nqg_202 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         nqg_203 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         nqg_204 LIKE nqg_file.nqg12,  #NO.FUN-650177 #No.FUN-680107 DEC(30,0)
                         nqg_205 LIKE nqg_file.nqg12,  #NO.FUN-650177 #No.FUN-680107 DEC(30,0)
                         sum_inv LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         nqg_300 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         nqg_301 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         nqg_302 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         nqg_303 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         nqg_304 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         sum_fin LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         bal     LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         rev     LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,0)
                         gap     LIKE nqg_file.nqg12   #No.FUN-680107  DEC(30,0)
                      END RECORD
   DEFINE l_buk_nqg   RECORD
                         ldate  LIKE type_file.dat,    #No.FUN-680107 DATE
                         plan   LIKE nqg_file.nqg02,   #No.FUN-680107 VARCHAR(10)
                         class  LIKE nqg_file.nqg05,   #No.FUN-680107 VARCHAR(10)
                         cate   LIKE nqg_file.nqg06,   #No.FUN-680107 VARCHAR(3)
                         amou   LIKE nqg_file.nqg12    #No.FUN-680107 DEC(20,6)
                      END RECORD
   DEFINE l_plandate  LIKE nqg_file.nqg04
   DEFINE l_plan      LIKE nqg_file.nqg02
   DEFINE l_date      LIKE nqg_file.nqg04
   DEFINE l_class     LIKE nqg_file.nqg05
   DEFINE l_cate      LIKE nqg_file.nqg06
   DEFINE l_amou      LIKE nqg_file.nqg12
   DEFINE l_cnt       LIKE type_file.num5     #No.FUN-680107 SMALLINT
 
   DELETE FROM nqg_tmp
   IF STATUS THEN
#     CALL cl_err("del tmp error",STATUS,0)   #No.FUN-660148
      CALL cl_err3("del","nqg_tmp","","",STATUS,"","del tmp error",0)  #No.FUN-660148
      RETURN
   END IF
 
   CALL q900_c_buk_tmp()       # 產生時距檔
 
   CALL q900_nqg_buk()
   LET l_cnt = 0
#   LET g_sql = "SELECT UNIQUE plan1 FROM buk_nqg "   #No.TQC-950127                                                                 
   LET g_sql = "SELECT UNIQUE plan_1 FROM buk_nqg "  #No.TQC-950127 
 
   PREPARE q900_pnqgtmp FROM g_sql
   DECLARE q900_bnqgtmp CURSOR FOR q900_pnqgtmp
 
   FOREACH q900_bnqgtmp INTO l_plan
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach nqgtmp1:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET l_nqg_tmp.bal = 0
 
     #LET g_sql = "SELECT UNIQUE plan_date FROM buk_tmp "                     #No.MOD-8C0232 mark
      LET g_sql = "SELECT UNIQUE plan_date FROM buk_tmp ORDER BY plan_date "  #No.MOD-8C0232
 
      PREPARE q900_pnqgtmp2 FROM g_sql
      DECLARE q900_bnqgtmp2 CURSOR FOR q900_pnqgtmp2
      
      FOREACH q900_bnqgtmp2 INTO l_date
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach nqgtmp2:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
      
         LET l_nqg_tmp.nqg01 = g_nqg01
         LET l_nqg_tmp.nqg02 = l_plan
         LET l_nqg_tmp.ldate = l_date
         LET l_nqg_tmp.nqg_000 = l_nqg_tmp.bal
         LET l_nqg_tmp.nqg_100 = 0
         LET l_nqg_tmp.nqg_101 = 0
         LET l_nqg_tmp.nqg_102 = 0
         LET l_nqg_tmp.nqg_103 = 0
         LET l_nqg_tmp.nqg_104 = 0
         LET l_nqg_tmp.nqg_105 = 0
         LET l_nqg_tmp.nqg_106 = 0
         LET l_nqg_tmp.nqg_107 = 0
         LET l_nqg_tmp.nqg_108 = 0
         LET l_nqg_tmp.nqg_109 = 0
         LET l_nqg_tmp.nqg_110 = 0
         LET l_nqg_tmp.nqg_111 = 0
         LET l_nqg_tmp.nqg_112 = 0
         LET l_nqg_tmp.nqg_113 = 0
         LET l_nqg_tmp.nqg_114 = 0
         LET l_nqg_tmp.nqg_200 = 0
         LET l_nqg_tmp.nqg_201 = 0
         LET l_nqg_tmp.nqg_202 = 0
         LET l_nqg_tmp.nqg_203 = 0
         LET l_nqg_tmp.nqg_204 = 0   #NO.FUN-650177
         LET l_nqg_tmp.nqg_205 = 0   #NO.FUN-650177
         LET l_nqg_tmp.nqg_300 = 0
         LET l_nqg_tmp.nqg_301 = 0
         LET l_nqg_tmp.nqg_302 = 0
         LET l_nqg_tmp.nqg_303 = 0
         LET l_nqg_tmp.nqg_304 = 0
         LET l_nqg_tmp.rev = 0
      
         LET g_sql = "SELECT class,cate,amou FROM buk_nqg ",
                     " WHERE ldate = '",l_date,"'",
#                     "   AND plan1 = '",l_plan,"'"    #No.TQC-950127                                                                
                     "   AND plan_1 = '",l_plan,"'"     #No.TQC-950127 
         
         PREPARE q900_pnqgtmp1 FROM g_sql
         DECLARE q900_bnqgtmp1 CURSOR FOR q900_pnqgtmp1
      
         FOREACH q900_bnqgtmp1 INTO l_class,l_cate,l_amou
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach nqgtmp3:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
      
            CASE l_cate
               WHEN "000"
                  LET l_nqg_tmp.nqg_000 = l_nqg_tmp.nqg_000 + l_amou
               WHEN "100"
                  LET l_nqg_tmp.nqg_100 = l_nqg_tmp.nqg_100 + l_amou
               WHEN "101"
                  LET l_nqg_tmp.nqg_101 = l_nqg_tmp.nqg_101 + l_amou
               WHEN "102"
                  LET l_nqg_tmp.nqg_102 = l_nqg_tmp.nqg_102 + l_amou
               WHEN "103"
                  LET l_nqg_tmp.nqg_103 = l_nqg_tmp.nqg_103 + l_amou
               WHEN "104"
                  LET l_nqg_tmp.nqg_104 = l_nqg_tmp.nqg_104 + l_amou
               WHEN "105"
                  LET l_nqg_tmp.nqg_105 = l_nqg_tmp.nqg_105 + l_amou
               WHEN "106"
                  LET l_nqg_tmp.nqg_106 = l_nqg_tmp.nqg_106 + l_amou
               WHEN "107"
                  LET l_nqg_tmp.nqg_107 = l_nqg_tmp.nqg_107 + l_amou
               WHEN "108"
                  LET l_nqg_tmp.nqg_108 = l_nqg_tmp.nqg_108 + l_amou
               WHEN "109"
                  LET l_nqg_tmp.nqg_109 = l_nqg_tmp.nqg_109 + l_amou
               WHEN "110"
                  LET l_nqg_tmp.nqg_110 = l_nqg_tmp.nqg_110 + l_amou
               WHEN "111"
                  LET l_nqg_tmp.nqg_111 = l_nqg_tmp.nqg_111 + l_amou
               WHEN "112"
                  LET l_nqg_tmp.nqg_112 = l_nqg_tmp.nqg_112 + l_amou
               WHEN "113"
                  LET l_nqg_tmp.nqg_113 = l_nqg_tmp.nqg_113 + l_amou
               WHEN "114"
                  LET l_nqg_tmp.nqg_114 = l_nqg_tmp.nqg_114 + l_amou
               WHEN "200"
                  LET l_nqg_tmp.nqg_200 = l_nqg_tmp.nqg_200 + l_amou
               WHEN "201"
                  LET l_nqg_tmp.nqg_201 = l_nqg_tmp.nqg_201 + l_amou
               WHEN "202"
                  LET l_nqg_tmp.nqg_202 = l_nqg_tmp.nqg_202 + l_amou
               WHEN "203"
                  LET l_nqg_tmp.nqg_203 = l_nqg_tmp.nqg_203 + l_amou
#NO.FUN-650177 start--
               WHEN "204"
                  LET l_nqg_tmp.nqg_204 = l_nqg_tmp.nqg_204 + l_amou
               WHEN "205"
                  LET l_nqg_tmp.nqg_204 = l_nqg_tmp.nqg_205 + l_amou
#NO.FUN-650177 end----
               WHEN "300"
                  LET l_nqg_tmp.nqg_300 = l_nqg_tmp.nqg_300 + l_amou
               WHEN "301"
                  LET l_nqg_tmp.nqg_301 = l_nqg_tmp.nqg_301 + l_amou
               WHEN "302"
                  LET l_nqg_tmp.nqg_302 = l_nqg_tmp.nqg_302 + l_amou
               WHEN "303"
                  LET l_nqg_tmp.nqg_303 = l_nqg_tmp.nqg_303 + l_amou
               WHEN "304"
                  LET l_nqg_tmp.nqg_304 = l_nqg_tmp.nqg_304 + l_amou
               WHEN "AAA"
                  LET l_nqg_tmp.rev = l_nqg_tmp.rev + l_amou
               OTHERWISE
                  CASE l_class
                     WHEN "1"
                        LET l_nqg_tmp.nqg_114 = l_nqg_tmp.nqg_114 + l_amou   #No.MOD-740155
                     WHEN "2"
                        #LET l_nqg_tmp.nqg_203 = l_nqg_tmp.nqg_203 + l_amou
                        LET l_nqg_tmp.nqg_205 = l_nqg_tmp.nqg_205 + l_amou   #NO.FUN-650177
                     WHEN "3"
                        LET l_nqg_tmp.nqg_304 = l_nqg_tmp.nqg_304 + l_amou
                  END CASE
            END CASE
      
         END FOREACH
      
         LET l_nqg_tmp.sum_bus = l_nqg_tmp.nqg_100 + l_nqg_tmp.nqg_101
                               + l_nqg_tmp.nqg_102 + l_nqg_tmp.nqg_103
                               - l_nqg_tmp.nqg_104 - l_nqg_tmp.nqg_105
                               - l_nqg_tmp.nqg_106 - l_nqg_tmp.nqg_107
                               - l_nqg_tmp.nqg_108 - l_nqg_tmp.nqg_109
                               - l_nqg_tmp.nqg_110 - l_nqg_tmp.nqg_111
                               - l_nqg_tmp.nqg_112 - l_nqg_tmp.nqg_113
                               - l_nqg_tmp.nqg_114
      
         LET l_nqg_tmp.sum_inv = - l_nqg_tmp.nqg_200 - l_nqg_tmp.nqg_201
                                 #+ l_nqg_tmp.nqg_202 - l_nqg_tmp.nqg_203
                                 + l_nqg_tmp.nqg_202 + l_nqg_tmp.nqg_203     #NO.FUN-650177
                                 + l_nqg_tmp.nqg_204 - l_nqg_tmp.nqg_205     #NO.FUN-650177
      
         LET l_nqg_tmp.sum_fin = l_nqg_tmp.nqg_300 - l_nqg_tmp.nqg_301
                               - l_nqg_tmp.nqg_302 - l_nqg_tmp.nqg_303
                               - l_nqg_tmp.nqg_304
      
         LET l_nqg_tmp.bal = l_nqg_tmp.nqg_000 + l_nqg_tmp.sum_bus
                           + l_nqg_tmp.sum_inv + l_nqg_tmp.sum_fin
      
         LET l_nqg_tmp.gap = l_nqg_tmp.bal - l_nqg_tmp.rev
         
         INSERT INTO nqg_tmp VALUES(l_nqg_tmp.*)
         IF STATUS THEN
#           CALL cl_err("ins nqg_tmp error",STATUS,0)   #No.FUN-660148
            CALL cl_err3("ins","nqg_tmp",l_nqg_tmp.nqg01,l_nqg_tmp.nqg02,STATUS,"","ins nqg_tmp error",0)  #No.FUN-660148
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
         END IF 
         LET l_cnt =l_cnt + 1 
      END FOREACH
   END FOREACH
 
END FUNCTION
 
FUNCTION q900_c_buk_tmp()       # 產生時距檔
   DEFINE d,d2     LIKE type_file.dat           #No.FUN-680107 DATE
   DEFINE l_nqf02  LIKE nqf_file.nqf02          #No.FUN-680107 DATE
   DEFINE j        LIKE type_file.num10         #No.FUN-680107 INTEGER
   DEFINE l_date   LIKE type_file.dat           #No.TQC-9B0177
 
   DROP TABLE buk_tmp
 #No.FUN-680107 --START
#   CREATE TABLE buk_tmp
#      (
#       real_date   DATE,
#       plan_date   DATE
#      )
   CREATE TEMP TABLE buk_tmp(
       real_date   LIKE type_file.dat,   
       plan_date   LIKE type_file.dat)
#No.FUN-680107 --END
   IF STATUS THEN
      CALL cl_err('create buk_tmp:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
   SELECT nqf02 INTO l_nqf02 FROM nqf_file
    WHERE nqf00 = g_nqg01
 
   LET l_bdate = g_today 
  
   CASE
      WHEN g_buk_type = '1'
         CALL rpg_buk()
         RETURN
      WHEN g_buk_type = '2'
         LET past_date = l_bdate-1
      WHEN g_buk_type = '3'
         LET past_date = l_bdate-7
      WHEN g_buk_type = '4'
         LET past_date = l_bdate-10
      WHEN g_buk_type = '5'
         LET past_date = l_bdate-30
      OTHERWISE
         LET past_date = l_bdate-1
   END CASE
 
   CALL q900_buk_date(past_date) RETURNING past_date
   #No.TQC-9B0177  --Begin
   #LET g_sql = "INSERT INTO buk_tmp VALUES (DATEADD(day,-1,'",l_bdate,"'),'",past_date,"') "
   #DECLARE q900_tmp_date1 CURSOR FROM g_sql
   #EXECUTE q900_tmp_date1
   LET l_date = l_bdate - 1
   INSERT INTO buk_tmp VALUES (l_date,past_date)
   #No.TQC-9B0177  --End
   IF STATUS THEN
#     CALL cl_err('ins buk_tmp:',STATUS,1)   #No.FUN-660148
      CALL cl_err3("ins","buk_tmp","","",STATUS,"","ins buk_tmp",1)  #No.FUN-660148
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
   FOR j = l_bdate TO l_nqf02
      LET d=j
 
      CALL q900_buk_date(d) RETURNING d2
 
      INSERT INTO buk_tmp VALUES(d,d2)
      IF STATUS THEN
#        CALL cl_err('ins buk_tmp:',STATUS,1)   #No.FUN-660148
         CALL cl_err3("ins","buk_tmp","","",STATUS,"","ins buk_tmp",1)  #No.FUN-660148
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
   END FOR
 
END FUNCTION
 
FUNCTION q900_buk_date(d)
   DEFINE d,d2   LIKE type_file.dat           #No.FUN-680107 DATE
   DEFINE x      LIKE type_file.chr8          #No.FUN-680107 VARCHAR(8)
   DEFINE i      LIKE type_file.num10         #No.FUN-680107 INTEGER
 
   CASE
      WHEN g_buk_type = '3'
         LET i = weekday(d)
         IF i = 0 THEN
            LET i = 7
         END IF
         LET d2 = d - i + 1
      WHEN g_buk_type = '4'
         LET x = d USING 'yyyymmdd'
 
         CASE
            WHEN x[7,8]<='10'
               LET x[7,8]='01'
            WHEN x[7,8]<='20'
               LET x[7,8]='11'
            OTHERWISE
               LET x[7,8]='21'
         END CASE
 
         LET d2= MDY(x[5,6],x[7,8],x[1,4])
      WHEN g_buk_type = '5'
         LET x = d USING 'yyyymmdd'
         LET x[7,8]='01'
         LET d2= MDY(x[5,6],x[7,8],x[1,4])
      OTHERWISE
         LET d2=d
   END CASE
 
   RETURN d2
 
END FUNCTION
 
FUNCTION rpg_buk()
   DEFINE l_bucket ARRAY[36] OF LIKE type_file.num5    #No.FUN-680107 ARRAY[36] OF SMALLINT
   DEFINE l_rpg    RECORD LIKE rpg_file.*
   DEFINE dd1,dd2  LIKE type_file.dat                  #No.FUN-680107 DATE
   DEFINE i,j      LIKE type_file.num10                #No.FUN-680107 INTEGER
   DEFINE l_date   LIKE type_file.dat           #No.TQC-9B0177
 
   SELECT * INTO l_rpg.* FROM rpg_file
    WHERE rpg01 = g_buk_code
   IF STATUS THEN
#     CALL cl_err('sel rpg:',STATUS,1)   #No.FUN-660148
      CALL cl_err3("sel","rpg_file",g_buk_code,"",STATUS,"","sel rpg:",1)  #No.FUN-660148
      RETURN
   END IF
  
   LET l_bucket[01] = l_rpg.rpg101
   LET l_bucket[02] = l_rpg.rpg102
   LET l_bucket[03] = l_rpg.rpg103
   LET l_bucket[04] = l_rpg.rpg104
   LET l_bucket[05] = l_rpg.rpg105
   LET l_bucket[06] = l_rpg.rpg106
   LET l_bucket[07] = l_rpg.rpg107
   LET l_bucket[08] = l_rpg.rpg108
   LET l_bucket[09] = l_rpg.rpg109
   LET l_bucket[10] = l_rpg.rpg110
   LET l_bucket[11] = l_rpg.rpg111
   LET l_bucket[12] = l_rpg.rpg112
   LET l_bucket[13] = l_rpg.rpg113
   LET l_bucket[14] = l_rpg.rpg114
   LET l_bucket[15] = l_rpg.rpg115
   LET l_bucket[16] = l_rpg.rpg116
   LET l_bucket[17] = l_rpg.rpg117
   LET l_bucket[18] = l_rpg.rpg118
   LET l_bucket[19] = l_rpg.rpg119
   LET l_bucket[20] = l_rpg.rpg120
   LET l_bucket[21] = l_rpg.rpg121
   LET l_bucket[22] = l_rpg.rpg122
   LET l_bucket[23] = l_rpg.rpg123
   LET l_bucket[24] = l_rpg.rpg124
   LET l_bucket[25] = l_rpg.rpg125
   LET l_bucket[26] = l_rpg.rpg126
   LET l_bucket[27] = l_rpg.rpg127
   LET l_bucket[28] = l_rpg.rpg128
   LET l_bucket[29] = l_rpg.rpg129
   LET l_bucket[30] = l_rpg.rpg130
   LET l_bucket[31] = l_rpg.rpg131
   LET l_bucket[32] = l_rpg.rpg132
   LET l_bucket[33] = l_rpg.rpg133
   LET l_bucket[34] = l_rpg.rpg134
   LET l_bucket[35] = l_rpg.rpg135
   LET l_bucket[36] = l_rpg.rpg136
 
   LET past_date = l_bdate - l_rpg.rpg101
   #No.TQC-9B0177  --Begin
   #LET g_sql = "INSERT INTO buk_tmp VALUES (DATEADD(day,-1,'",l_bdate,"'),'",past_date,"') "
   #DECLARE q900_tmp_date2 CURSOR FROM g_sql
   #EXECUTE q900_tmp_date2
   LET l_date = l_bdate - 1
   INSERT INTO buk_tmp VALUES (l_date,past_date)
   #No.TQC-9B0177  --End  
 
   LET dd1 = l_bdate
   LET dd2 = l_bdate
 
   FOR i = 1 TO 36
      FOR j=1 TO l_bucket[i]
         INSERT INTO buk_tmp VALUES (dd1,dd2)
         LET dd1 = dd1 + 1
      END FOR
 
      LET dd2 = dd2 + l_bucket[i]
   END FOR
 
END FUNCTION
 
FUNCTION q900_nqg_buk()
   DEFINE tmp RECORD
                 ldate  LIKE nqg_file.nqg04,
                 plan   LIKE nqg_file.nqg02,
                 class  LIKE nqg_file.nqg05,
                 cate   LIKE nqg_file.nqg06,
                 amou   LIKE nqg_file.nqg12,
                 sdate  LIKE nqg_file.nqg04
              END RECORD
   DEFINE l_nqb  RECORD LIKE nqb_file.*
   DEFINE l_aza17 LIKE aza_file.aza17
   #DEFINE l_azp03 LIKE azp_file.azp03  #FUN-A50102
   DEFINE l_rate  LIKE nqg_file.nqg11
 
   DROP TABLE buk_nqg
#No.FUN-680107 --START 
#   CREATE TABLE buk_nqg
#      (
#       ldate   DATE,
#       plan   VARCHAR(10),
#       class  VARCHAR(10),
#       cate   VARCHAR(3),
#       amou   DEC(20,6)
#      )
   CREATE TEMP TABLE buk_nqg(
       ldate  LIKE nqg_file.nqg04,
#       plan   LIKE nqg_file.nqg02,     #No.TQC-950127                                                                      
       plan_1   LIKE nqg_file.nqg02,            #No.TQC-950127
       class  LIKE nqg_file.nqg05,
       cate   LIKE nqg_file.nqg06,
       amou   LIKE nqg_file.nqg12)
#No.FUN-680107 --END
   IF STATUS THEN
      CALL cl_err('create buk_nqg:',STATUS,1)   
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
   CASE g_cur_type
      WHEN "1"
         LET g_sql = "SELECT '',nqg02,nqg05,nqg06,nqg12,nqg04 FROM nqg_file",
                     " WHERE nqg01 ='",g_nqg01,"'",
                     "   AND nqg10 ='",g_cur_code,"'"
      WHEN "2"
         LET g_sql = "SELECT '',nqg02,nqg05,nqg06,nqg13,nqg04 FROM nqg_file",
                     " WHERE nqg01 ='",g_nqg01,"'"
      WHEN "3"
         LET g_sql = "SELECT '',nqg02,nqg05,nqg06,nqg14,nqg04 FROM nqg_file",
                     " WHERE nqg01 ='",g_nqg01,"'"
   END CASE
 
   IF g_nqg02 <> "ALL" THEN
      LET g_sql = g_sql CLIPPED, "   AND nqg02 = '",g_nqg02,"'"
   END IF
 
   PREPARE q900_pbuknqg FROM g_sql
   DECLARE q900_bbuknqg CURSOR FOR q900_pbuknqg
 
   FOREACH q900_bbuknqg INTO tmp.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      SELECT plan_date INTO tmp.ldate FROM buk_tmp
       WHERE real_date = tmp.sdate
      IF STATUS THEN
         SELECT MIN(plan_date) INTO tmp.ldate
           FROM buk_tmp
      END IF
 
      INSERT INTO buk_nqg VALUES(tmp.ldate,tmp.plan,tmp.class,tmp.cate,tmp.amou)
      IF STATUS THEN
#        CALL cl_err("ins buk_nqg error",STATUS,0)   #No.FUN-660148
         CALL cl_err3("ins","buk_nqg","","",STATUS,"","ins buk_nqg error",0)  #No.FUN-660148
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
 
   END FOREACH
 
   #週轉金
   IF g_nqg02 = "ALL" THEN
      LET g_sql = "SELECT * FROM nqb_file"
   ELSE
      LET g_sql = "SELECT * FROM nqb_file",
                  " WHERE nqb01 = '",g_nqg02,"'"
   END IF
 
   PREPARE q900_pbuknqb FROM g_sql
   DECLARE q900_bbuknqb CURSOR FOR q900_pbuknqb
 
   FOREACH q900_bbuknqb INTO l_nqb.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
 
      SELECT plan_date INTO tmp.ldate FROM buk_tmp
       WHERE real_date = l_nqb.nqb02
      IF STATUS THEN
         SELECT MIN(plan_date) INTO tmp.ldate
           FROM buk_tmp
      END IF
 
      #SELECT azp03 INTO l_azp03 FROM azp_file #FUN-A50102
      # WHERE azp01 = l_nqb.nqb01              #FUN-A50102
 
      LET g_sql = "SELECT aza17 ",
                 #"  FROM ",l_azp03,".dbo.aza_file" #TQC-940177 
                 # "  FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file" #TQC-940177
                  "  FROM ",cl_get_target_table(l_nqb.nqb01,'aza_file') #FUN-A50102 
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,l_nqb.nqb01) RETURNING g_sql #FUN-A50102	            
      PREPARE p910_paza FROM g_sql
      DECLARE p910_baza CURSOR FOR p910_paza
 
      OPEN p910_baza
      FETCH p910_baza INTO l_aza17
 
      IF g_cur_type = "1" THEN
         IF g_cur_code <> l_aza17 THEN
#           CALL s_currm(g_cur_code,l_nqb.nqb02,"S",l_azp03)      #FUN-980020 mark
            CALL s_currm(g_cur_code,l_nqb.nqb02,"S",l_nqb.nqb01)  #FUN-980020 
                 RETURNING l_rate
            LET l_nqb.nqb03 = l_nqb.nqb03 * l_rate
         END IF
      END IF
 
      IF g_cur_type = "3" THEN
         IF g_nqa01 <> l_aza17 THEN
#           CALL s_currm(g_nqa01,l_nqb.nqb02,"S",l_azp03)     #FUN-980020 mark
            CALL s_currm(g_nqa01,l_nqb.nqb02,"S",l_nqb.nqb01) #FUN-980020
                 RETURNING l_rate
            LET l_nqb.nqb03 = l_nqb.nqb03 * l_rate
         END IF
      END IF
 
      INSERT INTO buk_nqg VALUES(tmp.ldate,l_nqb.nqb01,"A","AAA",l_nqb.nqb03)
      IF STATUS THEN
#        CALL cl_err("ins buk_nqg error",STATUS,0)   #No.FUN-660148
         CALL cl_err3("ins","buk_nqg","","",STATUS,"","ins buk_nqg error",0)  #No.FUN-660148
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF g_nqg02 = "ALL" THEN
         INSERT INTO buk_nqg VALUES(tmp.ldate,"ALL","A","AAA",l_nqb.nqb03)
         IF STATUS THEN
#           CALL cl_err("ins all_buk_nqg error",STATUS,0)   #No.FUN-660148
            CALL cl_err3("ins","buk_nqg","","",STATUS,"","ins all_buk_nqg error",0)  #No.FUN-660148
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
             EXIT PROGRAM
         END IF
      END IF
   END FOREACH
 
END FUNCTION
 
