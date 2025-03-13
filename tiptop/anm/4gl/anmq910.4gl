# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmq910.4gl
# Descriptions...: 資金模擬明細查詢
# Date & Author..: 06/04/03 By Nicola
# Modify.........: MOD-640115 06/04/09 By Melody
# Modify.........: No.MOD-640103 06/04/10 By Nicola 輸入交易幣別再變成其他選項,幣別未清除
# Modify.........: NO.FUN-640089 06/06/08 By Yiting function bar 增加 anmt910
# Modify.........: NO.FUN-650177 06/06/22 BY Yiting 增加203/204類別 
# Modify.........: NO.FUN-650177 06/06/30 BY yiting 可由anmq900串入(版本/營運中心/幣別) 停留在類別明細待輸
# Modify.........: NO.FUN-640132 06/07/04 by Yiting 單身依幣別取位
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改.
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6C0174 06/12/28 By Rayven 匯出EXCEL匯出的值與欄位字段說明未對應
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_nqg01      LIKE nqg_file.nqg01,
       g_nqg02      LIKE nqg_file.nqg02,
       g_cur_type   LIKE type_file.chr1,             #No.FUN-680107 VARCHAR(1)
       g_cur_code   LIKE nqg_file.nqg10, 
       g_detail     LIKE nqg_file.nqg06,             #No.FUN-680107 VARCHAR(3)
       g_nqg        RECORD
                       nqg01   LIKE nqg_file.nqg01,  #No.FUN-680107 VARCHAR(2) 
                       nqg02   LIKE nqg_file.nqg02,  #No.FUN-680107 VARCHAR(10) 
                       nqg03   LIKE nqg_file.nqg03,  #No.FUN-680107 VARCHAR(4) 
                       nqa01   LIKE nqa_file.nqa01,  #No.FUN-680107 VARCHAR(4) 
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
                       nqg_200 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_201 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_202 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_203 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_204 LIKE nqg_file.nqg12,  #NO.FUN-650177 #No.FUN-680107 DEC(30,6)
                       nqg_205 LIKE nqg_file.nqg12,  #NO.FUN-650177 #No.FUN-680107 DEC(30,6)
                       nqg_300 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_301 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_302 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_303 LIKE nqg_file.nqg12,  #No.FUN-680107 DEC(30,6)
                       nqg_304 LIKE nqg_file.nqg12   #No.FUN-680107 DEC(30,6)
                    END RECORD,           
       g_nqgb       DYNAMIC ARRAY OF RECORD
                       nqg04   LIKE nqg_file.nqg04,
                       nqg05   LIKE nqg_file.nqg05,
                       nqg06   LIKE nqg_file.nqg06,
                       nqd02   LIKE nqd_file.nqd02,
                       nqg16   LIKE nqg_file.nqg16,    #NO.FUN-640089 ADD
                       nmt02   LIKE nmt_file.nmt02,    #NO.FUN-640089 ADD
                       nqg07   LIKE nqg_file.nqg07,
                       nqg17   LIKE nqg_file.nqg17,    #NO.FUN-640089 ADD
                       nqg08   LIKE nqg_file.nqg08,
                       nqg09   LIKE nqg_file.nqg09,
                       nqg10   LIKE nqg_file.nqg10,
                       nqg11   LIKE nqg_file.nqg11, 
                       nqg12   LIKE nqg_file.nqg12,
                       nqg13   LIKE nqg_file.nqg13,
                       nqg14   LIKE nqg_file.nqg14,
                       lbal    LIKE nqg_file.nqg12,
                       cbal    LIKE nqg_file.nqg13
                    END RECORD,
       g_sql        STRING,      
       g_rec_b      LIKE type_file.num5          #No.FUN-680107 SMALLINT
DEFINE g_cnt        LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_msg        LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(72)
DEFINE g_row_count  LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_curs_index LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_jump       LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5          #No.FUN-680107 SMALLINT
DEFINE g_argv1      LIKE nqg_file.nqg01          #NO.FUN-650177 
DEFINE g_argv2      LIKE nqg_file.nqg02          #NO.FUN-650177
DEFINE g_argv3      LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1) #NO.FUN-650177
DEFINE t_azi04_1    LIKE azi_file.azi04          #NO.FUN-640132   #交易幣別  #NO.CHI-6A0004
DEFINE t_azi04_2    LIKE azi_file.azi04          #NO.FUN-640132   #營運幣別  #NO.CHI-6A0004
DEFINE t_azi04_3    LIKE azi_file.azi04          #NO.FUN-640132   #集團幣別  #NO.CHI-6A0004
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0082
   DEFINE p_row,p_col   LIKE type_file.num5      #No.FUN-680107 SMALLINT
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   LET g_argv1=ARG_VAL(1)           #NO.FUN-650177
   LET g_argv2=ARG_VAL(2)           #NO.FUN-650177
   LET g_argv3=ARG_VAL(3)           #NO.FUN-650177
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
 
   LET p_row = 4 LET p_col = 2
 
   OPEN WINDOW q910_w AT p_row,p_col
     WITH FORM "anm/42f/anmq910"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
#NO.FUN-650177 start--
   IF NOT cl_null(g_argv1) 
      AND NOT cl_null(g_argv2) 
      AND NOT cl_null(g_argv3) THEN
      CALL q910_q()
   END IF
#NO.FUN-650177 end--
   CALL q910_menu()
 
   CLOSE WINDOW q910_w
 
   CALL  cl_used(g_prog,g_time,2)  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
 
END MAIN
 
FUNCTION q910_cs()
  
   CLEAR FORM
   CALL g_nqgb.clear()
   
   CALL cl_set_head_visible("grid01,grid02,grid03,grid04","YES")   #No.FUN-6B0030
#NO.FUN-650177 start--
   IF NOT cl_null(g_argv1) AND
      NOT cl_null(g_argv2) AND
      NOT cl_null(g_argv3) THEN
      LET g_nqg01 = g_argv1
      LET g_nqg02 = g_argv2
      LET g_cur_type = g_argv3
      DISPLAY g_nqg01 TO nqg01
      DISPLAY g_nqg02 TO nqg02
      DISPLAY g_cur_type TO cur_type
      DISPLAY g_cur_code TO cur_code  
 
      INPUT g_detail
            WITHOUT DEFAULTS FROM detail
 
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
   ELSE
      INPUT g_nqg01,g_nqg02,g_cur_type,g_cur_code,g_detail
            WITHOUT DEFAULTS FROM nqg01,nqg02,cur_type,cur_code,detail
#NO.FUN-650177 end----
 
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
         END IF
 
      ON CHANGE cur_type
         IF g_cur_type = "1" THEN
            CALL cl_set_comp_entry("cur_code",TRUE)
            CALL cl_set_comp_required("cur_code",TRUE)
         ELSE
            CALL cl_set_comp_entry("cur_code",FALSE)
            CALL cl_set_comp_required("cur_code",FALSE)
            LET g_cur_code = ""              #No.MOD-640103
            DISPLAY g_cur_code TO cur_code   #No.MOD-640103
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
            WHEN INFIELD(nqg02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_nqg02
               CALL cl_create_qry() RETURNING g_nqg02
               NEXT FIELD nqg02
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
   END IF     #NO.FUN-650177
 
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
 
   PREPARE q910_prepare FROM g_sql
   DECLARE q910_bcs SCROLL CURSOR WITH HOLD FOR q910_prepare
 
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
   PREPARE q910_precount_x FROM g_sql
   EXECUTE q910_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x"
   PREPARE q910_precount FROM g_sql
   DECLARE q910_count CURSOR FOR q910_precount
 
END FUNCTION
 
FUNCTION q910_menu()
DEFINE l_msg  LIKE type_file.chr1000   #No.FUN-680107 VARCHAR(70)
 
   WHILE TRUE
      CALL q910_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q910_q()
            END IF
         WHEN "cate_detail"
            IF cl_chk_act_auth() THEN
               CALL q910_cate_detail()
            END IF
#NO.FUN-640089 start--
         WHEN "maintain_fund_adj"
            IF cl_chk_act_auth() THEN
                LET l_msg="anmt910 '",g_nqg.nqg01,"' '",g_nqg.nqg02,"' '",g_nqg.nqg03,"'"
                CALL cl_cmdrun_wait(l_msg)
            END IF
#NO.FUN-640089 end----
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
#              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nqg),'','')   #No.TQC-6C0174 mark
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nqgb),'','')  #No.TQC-6C0174
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q910_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
 
   MESSAGE ""
   CALL cl_opmsg('q')
 
   CALL q910_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   OPEN q910_bcs
   IF SQLCA.sqlcode THEN
      CALL cl_err("",SQLCA.sqlcode,0)
   ELSE
      CALL q910_fetch('F')
      OPEN q910_count
      FETCH q910_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
   END IF
 
END FUNCTION
 
FUNCTION q910_fetch(p_flag)
   DEFINE p_flag   LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
          l_abso   LIKE type_file.num10         #No.FUN-680107 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     q910_bcs INTO g_nqg.nqg01,g_nqg.nqg02,g_nqg.nqg03
      WHEN 'P' FETCH PREVIOUS q910_bcs INTO g_nqg.nqg01,g_nqg.nqg02,g_nqg.nqg03
      WHEN 'F' FETCH FIRST    q910_bcs INTO g_nqg.nqg01,g_nqg.nqg02,g_nqg.nqg03
      WHEN 'L' FETCH LAST     q910_bcs INTO g_nqg.nqg01,g_nqg.nqg02,g_nqg.nqg03
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
 
         FETCH ABSOLUTE g_jump q910_bcs INTO g_nqg.nqg01,g_nqg.nqg02,g_nqg.nqg03
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nqg.nqg01,SQLCA.sqlcode,0)
      INITIALIZE g_nqg.* TO NULL  #TQC-6B0105
   ELSE
      CALL q910_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index,g_row_count)
   END IF
 
END FUNCTION
 
FUNCTION q910_show()
 
   CALL q910_sum()
 
   SELECT nqa01 INTO g_nqg.nqa01 FROM nqa_file
    WHERE nqa00 = "0"
 
   DISPLAY BY NAME g_nqg.*
 
   CALL q910_b_fill()
 
   CALL cl_show_fld_cont()
 
END FUNCTION
 
FUNCTION q910_b_fill()
 
   IF g_cur_type = "1" THEN
#NO.FUN-640089 start-
#      LET g_sql = "SELECT nqg04,nqg05,nqg06,'',nqg07,nqg08,nqg09,",
      LET g_sql = "SELECT nqg04,nqg05,nqg06,'',nqg16,'',nqg07,nqg17,nqg08,nqg09,",
#NO.FUN-640089 end--
                  "       nqg10,nqg11,nqg12,nqg13,nqg14,0,0",
                  "  FROM nqg_file",
                  " WHERE nqg01 = '",g_nqg.nqg01,"'",
                  "   AND nqg02 = '",g_nqg.nqg02,"'",
                  "   AND nqg06 = '",g_detail,"'",
                  "   AND nqg10 = '",g_cur_code,"'",
                  " ORDER BY nqg04,nqg07,nqg08,nqg09"
   ELSE
#NO.FUN-640089 start--
#      LET g_sql = "SELECT nqg04,nqg05,nqg06,'',nqg07,nqg08,nqg09,",
      LET g_sql = "SELECT nqg04,nqg05,nqg06,'',nqg16,'',nqg07,nqg17,nqg08,nqg09,",
#NO.FUN-640089 end--
                  "       nqg10,nqg11,nqg12,nqg13,nqg14,0,0",
                  "  FROM nqg_file",
                  " WHERE nqg01 = '",g_nqg.nqg01,"'",
                  "   AND nqg02 = '",g_nqg.nqg02,"'",
                  "   AND nqg06 = '",g_detail,"'",
                  " ORDER BY nqg04,nqg07,nqg08,nqg09"
   END IF
 
   PREPARE q910_prepare2 FROM g_sql
   DECLARE nqg_cs CURSOR FOR q910_prepare2
 
   LET g_cnt = 1
   LET g_rec_b=0
   CALL g_nqgb.clear()
 
   FOREACH nqg_cs INTO g_nqgb[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
#NO.FUN-640132 start--
      SELECT azi04 INTO t_azi04_1 FROM azi_file  #NO.CHI-6A0004
       WHERE azi01 = g_nqgb[g_cnt].nqg10
      SELECT azi04 INTO t_azi04_2 FROM azi_file  #NO.CHI-6A0004
       WHERE azi01 = g_nqg.nqg03
      SELECT azi04 INTO t_azi04_3 FROM azi_file  #NO.CHI-6A0004
       WHERE azi01 = g_nqg.nqa01
#NO.FUN-640132 end--
      
      SELECT nqd02 INTO g_nqgb[g_cnt].nqd02
        FROM nqd_file
       WHERE nqd01 = g_nqgb[g_cnt].nqg06
#NO.FUN-640089 start--
      SELECT nmt02 INTO g_nqgb[g_cnt].nmt02
        FROM nmt_file
       WHERE nmt01 = g_nqgb[g_cnt].nqg16
#NO.FUN-640089 end---
 
      IF g_cnt = 1 THEN
         LET g_nqgb[g_cnt].lbal = g_nqgb[g_cnt].lbal + g_nqgb[g_cnt].nqg13
         LET g_nqgb[g_cnt].cbal = g_nqgb[g_cnt].cbal + g_nqgb[g_cnt].nqg14
      ELSE
         LET g_nqgb[g_cnt].lbal = g_nqgb[g_cnt-1].lbal + g_nqgb[g_cnt].nqg13
         LET g_nqgb[g_cnt].cbal = g_nqgb[g_cnt-1].cbal + g_nqgb[g_cnt].nqg14
      END IF
#NO.FUN-640132 start--
      CALL cl_digcut(g_nqgb[g_cnt].nqg12,t_azi04_1) RETURNING g_nqgb[g_cnt].nqg12  #NO.CHI-6A0004
      CALL cl_digcut(g_nqgb[g_cnt].nqg13,t_azi04_2) RETURNING g_nqgb[g_cnt].nqg13  #NO.CHI-6A0004
      CALL cl_digcut(g_nqgb[g_cnt].nqg14,t_azi04_3) RETURNING g_nqgb[g_cnt].nqg14  #NO.CHI-6A0004
      CALL cl_digcut(g_nqgb[g_cnt].lbal,t_azi04_2) RETURNING g_nqgb[g_cnt].lbal  #NO.CHI-6A0004
      CALL cl_digcut(g_nqgb[g_cnt].cbal,t_azi04_3) RETURNING g_nqgb[g_cnt].cbal  #NO.CHI-6A0004
#NO.FUN-640132 end--
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_nqgb.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION q910_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel",FALSE)
   DISPLAY ARRAY g_nqgb TO s_nqg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         CALL cl_show_fld_cont()
 
#No.FUN-6B0030------Begin--------------                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("grid01,grid02,grid03,grid04","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION cate_detail
         LET g_action_choice="cate_detail"
         EXIT DISPLAY
 
#NO.FUN-640089 start--
      ON ACTION maintain_fund_adj
         LET g_action_choice="maintain_fund_adj"
         EXIT DISPLAY
#NO.FUN-640089 end--
 
      ON ACTION first
         CALL q910_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL q910_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL q910_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL q910_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL q910_fetch('L')
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
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION q910_sum() 
   DEFINE l_class     LIKE nqg_file.nqg05
   DEFINE l_cate      LIKE nqg_file.nqg06
   DEFINE l_amou      LIKE nqg_file.nqg12
 
   CASE g_cur_type
      WHEN "1"
         LET g_sql = "SELECT nqg05,nqg06,nqg12 FROM nqg_file",
                     " WHERE nqg01 ='",g_nqg.nqg01,"'",
                     "   AND nqg02 ='",g_nqg.nqg02,"'",
                     "   AND nqg10 ='",g_cur_code,"'"
      WHEN "2"
         LET g_sql = "SELECT nqg05,nqg06,nqg13 FROM nqg_file",
                     " WHERE nqg01 ='",g_nqg.nqg01,"'",
                     "   AND nqg02 ='",g_nqg.nqg02,"'"
      WHEN "3"
         LET g_sql = "SELECT nqg05,nqg06,nqg14 FROM nqg_file",
                     " WHERE nqg01 ='",g_nqg.nqg01,"'",
                     "   AND nqg02 ='",g_nqg.nqg02,"'"
   END CASE
 
   PREPARE q910_pnqg FROM g_sql
   DECLARE q910_bnqg CURSOR FOR q910_pnqg
 
   LET g_nqg.nqg_000 = 0
   LET g_nqg.nqg_100 = 0
   LET g_nqg.nqg_101 = 0
   LET g_nqg.nqg_102 = 0
   LET g_nqg.nqg_103 = 0
   LET g_nqg.nqg_104 = 0
   LET g_nqg.nqg_105 = 0
   LET g_nqg.nqg_106 = 0
   LET g_nqg.nqg_107 = 0
   LET g_nqg.nqg_108 = 0
   LET g_nqg.nqg_109 = 0
   LET g_nqg.nqg_110 = 0
   LET g_nqg.nqg_111 = 0
   LET g_nqg.nqg_112 = 0
   LET g_nqg.nqg_113 = 0
   LET g_nqg.nqg_114 = 0
   LET g_nqg.nqg_200 = 0
   LET g_nqg.nqg_201 = 0
   LET g_nqg.nqg_202 = 0
   LET g_nqg.nqg_203 = 0
   LET g_nqg.nqg_204 = 0   #NO.FUN-650177
   LET g_nqg.nqg_205 = 0   #NO.FUN-650177
   LET g_nqg.nqg_300 = 0
   LET g_nqg.nqg_301 = 0
   LET g_nqg.nqg_302 = 0
   LET g_nqg.nqg_303 = 0
   LET g_nqg.nqg_304 = 0
      
   FOREACH q910_bnqg INTO l_class,l_cate,l_amou
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach nqg:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
   
      CASE l_cate
         WHEN "000"
            LET g_nqg.nqg_000 = g_nqg.nqg_000 + l_amou
         WHEN "100"
            LET g_nqg.nqg_100 = g_nqg.nqg_100 + l_amou
         WHEN "101"
            LET g_nqg.nqg_101 = g_nqg.nqg_101 + l_amou
         WHEN "102"
            LET g_nqg.nqg_102 = g_nqg.nqg_102 + l_amou
         WHEN "103"
            LET g_nqg.nqg_103 = g_nqg.nqg_103 + l_amou
         WHEN "104"
            LET g_nqg.nqg_104 = g_nqg.nqg_104 + l_amou
         WHEN "105"
            LET g_nqg.nqg_105 = g_nqg.nqg_105 + l_amou
         WHEN "106"
            LET g_nqg.nqg_106 = g_nqg.nqg_106 + l_amou
         WHEN "107"
            LET g_nqg.nqg_107 = g_nqg.nqg_107 + l_amou
         WHEN "108"
            LET g_nqg.nqg_108 = g_nqg.nqg_108 + l_amou
         WHEN "109"
            LET g_nqg.nqg_109 = g_nqg.nqg_109 + l_amou
         WHEN "110"
            LET g_nqg.nqg_110 = g_nqg.nqg_110 + l_amou
         WHEN "111"
            LET g_nqg.nqg_111 = g_nqg.nqg_111 + l_amou
         WHEN "112"
            LET g_nqg.nqg_112 = g_nqg.nqg_112 + l_amou
         WHEN "113"
            LET g_nqg.nqg_113 = g_nqg.nqg_113 + l_amou
         WHEN "114"
            LET g_nqg.nqg_114 = g_nqg.nqg_114 + l_amou
         WHEN "200"
            LET g_nqg.nqg_200 = g_nqg.nqg_200 + l_amou
         WHEN "201"
            LET g_nqg.nqg_201 = g_nqg.nqg_201 + l_amou
         WHEN "202"
            LET g_nqg.nqg_202 = g_nqg.nqg_202 + l_amou
         WHEN "203"
            LET g_nqg.nqg_203 = g_nqg.nqg_203 + l_amou
#NO.FUN-650177 start--
         WHEN "204"
            LET g_nqg.nqg_204 = g_nqg.nqg_204 + l_amou
         WHEN "205"
            LET g_nqg.nqg_205 = g_nqg.nqg_205 + l_amou
#NO.FUN-650177 end----
         WHEN "300"
            LET g_nqg.nqg_300 = g_nqg.nqg_300 + l_amou
         WHEN "301"
            LET g_nqg.nqg_301 = g_nqg.nqg_301 + l_amou
         WHEN "302"
            LET g_nqg.nqg_302 = g_nqg.nqg_302 + l_amou
         WHEN "303"
            LET g_nqg.nqg_303 = g_nqg.nqg_303 + l_amou
         WHEN "304"
            LET g_nqg.nqg_304 = g_nqg.nqg_304 + l_amou
         OTHERWISE
            CASE l_class
               WHEN "1"
                  LET g_nqg.nqg_104 = g_nqg.nqg_104 + l_amou
               WHEN "2"
                  #LET g_nqg.nqg_203 = g_nqg.nqg_203 + l_amou
                  LET g_nqg.nqg_205 = g_nqg.nqg_205 + l_amou    #NO.FUN-650177
               WHEN "3"
                  LET g_nqg.nqg_304 = g_nqg.nqg_304 + l_amou
            END CASE
      END CASE
   
   END FOREACH
 
END FUNCTION
 
FUNCTION q910_cate_detail()
 
   CALL cl_set_head_visible("grid01,grid02,grid03,grid04","YES")   #No.FUN-6B0030
   INPUT g_detail WITHOUT DEFAULTS FROM detail
 
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
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   CALL q910_b_fill()
 
END FUNCTION
 
