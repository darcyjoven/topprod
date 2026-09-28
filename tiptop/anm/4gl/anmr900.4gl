# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: anmr900.4gl
# Descriptions...: 資金模擬彙總表
# Date & Author..: 06/06/22 BY yiting 
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.MOD-740154 07/04/27 By Nicola 營業活動的資金調整金額會被加總至委外採購
# Modify.........: No.FUN-830148 08/04/01 By xiaofeizhu 制作水晶報表
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
# Modify.........: No.FUN-980020 09/09/01 By douzh GP5.2架構重整，修改sub相關傳參
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-950152 10/03/09 By huangrh plan是MSV中的關鍵字
# Modify.........: No.FUN-A50102 10/07/12 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-B80067 11/08/05 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm      RECORD
                  wc         STRING,
                  nqg02      LIKE nqg_file.nqg02,
                  buk_type   LIKE type_file.chr1,       #No.FUN-680107 VARCHAR(1)
                  buk_code   LIKE rpg_file.rpg01,
                  cur_type   LIKE type_file.chr1,       #No.FUN-680107 VARCHAR(1)
                  cur_code   LIKE nqg_file.nqg10,
                  more       LIKE type_file.chr1        #No.FUN-680107 VARCHAR(1)
               END RECORD
DEFINE g_cnt        LIKE type_file.num5,       #No.FUN-680107 SMALLINT
       g_nqg03      LIKE nqg_file.nqg03,
       g_nqa01      LIKE nqa_file.nqa01
DEFINE past_date    LIKE type_file.dat         #No.FUN-680107 DATE
DEFINE l_bdate      LIKE type_file.dat         #No.FUN-680107 DATE
DEFINE g_sql        STRING      
DEFINE g_tmp_ac     LIKE type_file.num5        #No.FUN-680107 SMALLINT
DEFINE g_tmp_cnt    LIKE type_file.num5        #No.FUN-680107 SMALLINT
DEFINE g_nqg_tmp    DYNAMIC ARRAY OF RECORD
                    nqg01     LIKE nqg_file.nqg01,
                    nqg02     LIKE nqg_file.nqg02,
                    ldate     LIKE nqg_file.nqg04,     #No.FUN-680107 DATE
                    nqg_000   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    nqg_100   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    nqg_101   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    nqg_102   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    nqg_103   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    nqg_104   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    nqg_105   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    nqg_106   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    nqg_107   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    nqg_108   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    nqg_109   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    nqg_110   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    nqg_111   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    nqg_112   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    nqg_113   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    nqg_114   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    sum_bus   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    nqg_200   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    nqg_201   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    nqg_202   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    nqg_203   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    nqg_204   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)  
                    nqg_205   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    sum_inv   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    nqg_300   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    nqg_301   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    nqg_302   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    nqg_303   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    nqg_304   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    sum_fin   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    bal       LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    rev       LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                    gap       LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_ldate  DYNAMIC ARRAY OF RECORD
                    ldate     LIKE nqg_file.nqg04      #No.FUN-680107 DATE
                    END RECORD
DEFINE g_nqg_000    DYNAMIC ARRAY OF RECORD
                    amt_000   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_100    DYNAMIC ARRAY OF RECORD
                    amt_100   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_101    DYNAMIC ARRAY OF RECORD
                    amt_101   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_102    DYNAMIC ARRAY OF RECORD
                    amt_102   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_103    DYNAMIC ARRAY OF RECORD
                    amt_103   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_104    DYNAMIC ARRAY OF RECORD
                    amt_104   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_105    DYNAMIC ARRAY OF RECORD
                    amt_105   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_106    DYNAMIC ARRAY OF RECORD
                    amt_106   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_107    DYNAMIC ARRAY OF RECORD
                    amt_107   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_108    DYNAMIC ARRAY OF RECORD
                    amt_108   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_109    DYNAMIC ARRAY OF RECORD
                    amt_109   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_110    DYNAMIC ARRAY OF RECORD
                    amt_110   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_111    DYNAMIC ARRAY OF RECORD
                    amt_111   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_112    DYNAMIC ARRAY OF RECORD
                    amt_112   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_113    DYNAMIC ARRAY OF RECORD
                    amt_113   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_114    DYNAMIC ARRAY OF RECORD
                    amt_114   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_sumbus DYNAMIC ARRAY OF RECORD
                 amt_sumbus   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_200    DYNAMIC ARRAY OF RECORD
                    amt_200   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_201    DYNAMIC ARRAY OF RECORD
                    amt_201   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_202    DYNAMIC ARRAY OF RECORD
                    amt_202   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_203    DYNAMIC ARRAY OF RECORD
                    amt_203   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_204    DYNAMIC ARRAY OF RECORD
                    amt_204   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_205    DYNAMIC ARRAY OF RECORD
                    amt_205   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_suminv DYNAMIC ARRAY OF RECORD
                   amt_suminv LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_300    DYNAMIC ARRAY OF RECORD
                    amt_300   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)  
                    END RECORD
DEFINE g_nqg_301    DYNAMIC ARRAY OF RECORD
                    amt_301   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)  
                    END RECORD
DEFINE g_nqg_302    DYNAMIC ARRAY OF RECORD
                    amt_302   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_303    DYNAMIC ARRAY OF RECORD
                    amt_303   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_304    DYNAMIC ARRAY OF RECORD
                    amt_304   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_sumfin DYNAMIC ARRAY OF RECORD
                 amt_sumfin   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_bal    DYNAMIC ARRAY OF RECORD
                    amt_bal   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_rev    DYNAMIC ARRAY OF RECORD
                    amt_rev   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE g_nqg_gap    DYNAMIC ARRAY OF RECORD
                    amt_gap   LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                    END RECORD
DEFINE   l_table         STRING,             ### FUN-830148 ###                                                                     
         g_str           STRING              ### FUN-830148 ###                                                                     
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
### *** FUN-830148 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                     
    LET g_sql = "plant.nqg_file.nqg02,",
                "page.type_file.num5,",
                "code.type_file.chr8,",
                "amt1.type_file.num20,",
                "amt2.type_file.num20,",
                "amt3.type_file.num20,",
                "amt4.type_file.num20,",
                "amt5.type_file.num20,",
                "amt6.type_file.num20"
    LET l_table = cl_prt_temptable('anmr900',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
                " VALUES(?, ?, ?, ?, ?,                                                                                 
                         ?, ?, ?, ?)"                                                                                   
   PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------#
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.nqg02 = ARG_VAL(8)
   LET tm.more = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
 
   DROP TABLE nqg_tmp
#No.FUN-680107 -- START
#   CREATE TABLE nqg_tmp (
#       nqg01     VARCHAR(2),
#       nqg02     VARCHAR(10),
#       ldate     DATE,
#       nqg_000   DEC(30,6),
#       nqg_100   DEC(30,6),
#       nqg_101   DEC(30,6),
#       nqg_102   DEC(30,6),
#       nqg_103   DEC(30,6),
#       nqg_104   DEC(30,6),
#       nqg_105   DEC(30,6),
#       nqg_106   DEC(30,6),
#       nqg_107   DEC(30,6),
#       nqg_108   DEC(30,6),
#       nqg_109   DEC(30,6),
#       nqg_110   DEC(30,6),
#       nqg_111   DEC(30,6),
#       nqg_112   DEC(30,6),
#       nqg_113   DEC(30,6),
#       nqg_114   DEC(30,6),
#       sum_bus   DEC(30,6),
#       nqg_200   DEC(30,6),
#       nqg_201   DEC(30,6),
#       nqg_202   DEC(30,6),
#       nqg_203   DEC(30,6),
#       nqg_204   DEC(30,6),   
#       nqg_205   DEC(30,6),   
#       sum_inv   DEC(30,6),
#       nqg_300   DEC(30,6),
#       nqg_301   DEC(30,6),
#       nqg_302   DEC(30,6),
#       nqg_303   DEC(30,6),
#       nqg_304   DEC(30,6),
#       sum_fin   DEC(30,6),
#       bal       DEC(30,6),
#       rev       DEC(30,6),
#       gap       DEC(30,6))
 
   CREATE TEMP TABLE nqg_tmp(
       nqg01   LIKE nqg_file.nqg01,
       nqg02   LIKE nqg_file.nqg02,
       ldate   LIKE nqg_file.nqg04,
       nqg_000 LIKE nqg_file.nqg12,
       nqg_100 LIKE nqg_file.nqg12,
       nqg_101 LIKE nqg_file.nqg12,
       nqg_102 LIKE nqg_file.nqg12,
       nqg_103 LIKE nqg_file.nqg12,
       nqg_104 LIKE nqg_file.nqg12,
       nqg_105 LIKE nqg_file.nqg12,
       nqg_106 LIKE nqg_file.nqg12,
       nqg_107 LIKE nqg_file.nqg12,
       nqg_108 LIKE nqg_file.nqg12,
       nqg_109 LIKE nqg_file.nqg12,
       nqg_110 LIKE nqg_file.nqg12,
       nqg_111 LIKE nqg_file.nqg12,
       nqg_112 LIKE nqg_file.nqg12,
       nqg_113 LIKE nqg_file.nqg12,
       nqg_114 LIKE nqg_file.nqg12,
       sum_bus LIKE nqg_file.nqg12,
       nqg_200 LIKE nqg_file.nqg12,
       nqg_201 LIKE nqg_file.nqg12,
       nqg_202 LIKE nqg_file.nqg12,
       nqg_203 LIKE nqg_file.nqg12,
       nqg_204 LIKE nqg_file.nqg12,
       nqg_205 LIKE nqg_file.nqg12,
       sum_inv LIKE nqg_file.nqg12,
       nqg_300 LIKE nqg_file.nqg12,
       nqg_301 LIKE nqg_file.nqg12,
       nqg_302 LIKE nqg_file.nqg12,
       nqg_303 LIKE nqg_file.nqg12,
       nqg_304 LIKE nqg_file.nqg12,
       sum_fin LIKE nqg_file.nqg12,
       bal     LIKE nqg_file.nqg12,
       rev     LIKE nqg_file.nqg12,
       gap     LIKE nqg_file.nqg12)
#No.FUN-680107 --END
   IF STATUS THEN
      CALL cl_err('create npg_tmp error',STATUS,1)
      EXIT PROGRAM
   END IF
 
   DROP TABLE buk_tmp
#No.FUN-680107 --START
#  CREATE TABLE buk_tmp
#     (
#      real_date   DATE,
#      plan_date   DATE
#     )
   CREATE TEMP TABLE buk_tmp(
       real_date LIKE nqb_file.nqb02,
       plan_date LIKE type_file.dat)
#No.FUN-680107 --END
   IF STATUS THEN
      CALL cl_err('create buk_tmp:',STATUS,1)
      EXIT PROGRAM
   END IF
 
   DROP TABLE amt_tmp
#No.FUN-680107 --START
#  CREATE TABLE amt_tmp
#     (
#      plant       VARCHAR(10),
#      page        SMALLINT,
#      ln          SMALLINT,
#      code        VARCHAR(8),
#      amt1        DEC(30,6),
#      amt2        DEC(30,6),
#      amt3        DEC(30,6),
#      amt4        DEC(30,6),
#      amt5        DEC(30,6),
#      amt6        DEC(30,6))
 
  CREATE TEMP TABLE amt_tmp(
       plant LIKE nqg_file.nqg02,
       page  LIKE type_file.num5,  
       ln    LIKE type_file.num5,  
       code  LIKE type_file.chr8,  
       amt1  LIKE nqg_file.nqg12,
       amt2  LIKE nqg_file.nqg12,
       amt3  LIKE nqg_file.nqg12,
       amt4  LIKE nqg_file.nqg12,
       amt5  LIKE nqg_file.nqg12,
       amt6  LIKE nqg_file.nqg12)
#No.FUN-680107 --END
   IF STATUS THEN
      CALL cl_err('create amt_tmp:',STATUS,1)
      EXIT PROGRAM
   END IF
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
      CALL anmr900_tm()
   ELSE
      CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80067--add-- 
      CALL anmr900()
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
   END IF
END MAIN
 
FUNCTION anmr900_tm()
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01
   DEFINE p_row,p_col   LIKE type_file.num5,         #No.FUN-680107 SMALLINT
          l_cmd         LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(400)
   DEFINE li_result     LIKE type_file.num5          #No.FUN-940102
 
   LET p_row = 4 LET p_col = 15
 
   OPEN WINDOW anmr900_w AT p_row,p_col
     WITH FORM "anm/42f/anmr900"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
 
      CONSTRUCT BY NAME tm.wc ON nqg01
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
        
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
        
         ON ACTION about
            CALL cl_about()
        
         ON ACTION help
            CALL cl_show_help()
        
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW anmr900_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE 
      END IF
 
      INPUT BY NAME tm.nqg02,tm.buk_type,tm.buk_code,tm.cur_type,tm.cur_code,tm.more
             WITHOUT DEFAULTS 
                            
 
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD nqg02
         IF NOT cl_null(tm.nqg02) AND tm.nqg02 <> "ALL" THEN
            SELECT COUNT(*) INTO g_cnt FROM azp_file
             WHERE azp01 = tm.nqg02
            IF g_cnt = 0 THEN
               CALL cl_err(tm.nqg02,"aap-025",0)
               NEXT FIELD nqg02
            END IF
         END IF
         SELECT nqa01 INTO g_nqa01 FROM nqa_file
          WHERE nqa00 = "0"
 #No.FUN-940102 --begin--
               CALL s_chk_demo(g_user,tm.nqg02) RETURNING li_result
                IF not li_result THEN 
                 NEXT FIELD nqg02
                END IF 
#No.FUN-940102 --end-- 
 
      AFTER FIELD buk_type
         IF tm.buk_type = "1" THEN
            CALL cl_set_comp_entry("buk_code",TRUE)
            CALL cl_set_comp_required("buk_code",TRUE)
         ELSE
            CALL cl_set_comp_entry("buk_code",FALSE)
            CALL cl_set_comp_required("buk_code",FALSE)
         END IF
 
      AFTER FIELD buk_code
         IF NOT cl_null(tm.buk_code) THEN
           SELECT COUNT(*) INTO g_cnt FROM rpg_file
             WHERE rpg01 = tm.buk_code
            IF g_cnt = 0 THEN
               CALL cl_err(tm.buk_code,"anm-027",0)
               NEXT FIELD buk_code
            END IF
         END IF
 
      ON CHANGE cur_type
         IF tm.cur_type = "1" THEN
            CALL cl_set_comp_entry("cur_code",TRUE)
            CALL cl_set_comp_required("cur_code",TRUE)
         ELSE
            CALL cl_set_comp_entry("cur_code",FALSE)
            CALL cl_set_comp_required("cur_code",FALSE)
            LET tm.cur_code = ""              
            DISPLAY tm.cur_code TO cur_code  
         END IF
 
      AFTER FIELD cur_type
         IF tm.nqg02 = "ALL" AND tm.cur_type = "2" THEN
            CALL cl_err(tm.cur_code,"anm-605",0) 
            NEXT FIELD cur_type
         END IF
 
      AFTER FIELD cur_code
         IF NOT cl_null(tm.cur_code) THEN
            SELECT COUNT(*) INTO g_cnt FROM azi_file
             WHERE azi01 = tm.cur_code
            IF g_cnt = 0 THEN
               CALL cl_err(tm.cur_code,"aap-002",0)
               NEXT FIELD cur_code
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(nqg02)
               CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_azp"    #No.FUN-940102
               LET g_qryparam.form ="q_zxy"    #No.FUN-940102
               LET g_qryparam.arg1 = g_user    #No.FUN-940102
               LET g_qryparam.default1 = tm.nqg02
               CALL cl_create_qry() RETURNING tm.nqg02
               NEXT FIELD nqg02
            WHEN INFIELD(buk_code)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rpg"
               LET g_qryparam.default1 = tm.buk_code
               CALL cl_create_qry() RETURNING tm.buk_code
               NEXT FIELD buk_code
            WHEN INFIELD(cur_code)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = tm.cur_code
               CALL cl_create_qry() RETURNING tm.cur_code
               NEXT FIELD cur_code
            OTHERWISE
         END CASE
 
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR cl_null(tm.more) THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         
         ON ACTION about
            CALL cl_about()
         
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW anmr900_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='anmr900'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('anmr900','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc,"'","\"")
            LET l_cmd = l_cmd CLIPPED,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.nqg02 CLIPPED,"'",
                        " '",tm.more CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",
                        " '",g_rep_clas CLIPPED,"'",
                        " '",g_template CLIPPED,"'"
            CALL cl_cmdat('anmr900',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW anmr900_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL anmr900()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW anmr900_w
 
END FUNCTION
 
FUNCTION anmr900()
   DEFINE l_name      LIKE type_file.chr20,         #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8          #No.FUN-6A0082
          l_sql       STRING,       
          l_lbal      LIKE nqg_file.nqg13,
          l_cbal      LIKE nqg_file.nqg14,
          l_plant     LIKE nqg_file.nqg02,
          l_buk_nqg   RECORD
                      ldate  LIKE nqg_file.nqg04,   #No.FUN-680107 DATE
                      plan   LIKE nqg_file.nqg02,   #No.FUN-680107 VARCHAR(10)
                      class  LIKE nqg_file.nqg05,   #No.FUN-680107 VARCHAR(10)
                      cate   LIKE nqg_file.nqg06,   #No.FUN-680107 VARCHAR(3)  #類別
                      amou   LIKE nqg_file.nqg12    #No.FUN-680107 DEC(20,6)
                      END RECORD,
          l_nqg_tmp  RECORD
                     nqg01     LIKE nqg_file.nqg01,
                     nqg02     LIKE nqg_file.nqg02,
                     ldate     LIKE nqg_file.nqg04,     #No.FUN-680107 DATE
                     nqg_000   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     nqg_100   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     nqg_101   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     nqg_102   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     nqg_103   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     nqg_104   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     nqg_105   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     nqg_106   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     nqg_107   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     nqg_108   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     nqg_109   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     nqg_110   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     nqg_111   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     nqg_112   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     nqg_113   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     nqg_114   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     sum_bus   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     nqg_200   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     nqg_201   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     nqg_202   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     nqg_203   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     nqg_204   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)   
                     nqg_205   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     sum_inv   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     nqg_300   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     nqg_301   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     nqg_302   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     nqg_303   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     nqg_304   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     sum_fin   LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     bal       LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     rev       LIKE nqg_file.nqg12,     #No.FUN-680107 DEC(30,6)
                     gap       LIKE nqg_file.nqg12      #No.FUN-680107 DEC(30,6)
                     END RECORD,
          sr1        RECORD
                     plant       LIKE nqg_file.nqg02,   #No.FUN-680107 VARCHAR(10) #工廠
                     page        LIKE type_file.num5,   #No.FUN-680107 SMALLINT #頁次
                     ln          LIKE type_file.num5,   #No.FUN-680107 SMALLINT #項次
                     code        LIKE type_file.chr8,   #No.FUN-680107 VARCHAR(8) #項目
                     amt1        LIKE type_file.num20,  #No.FUN-680107 DEC(30,0) #金額1
                     amt2        LIKE type_file.num20,  #No.FUN-680107 DEC(30,0) #金額2
                     amt3        LIKE type_file.num20,  #No.FUN-680107 DEC(30,0) #金額3
                     amt4        LIKE type_file.num20,  #No.FUN-680107 DEC(30,0) #金額4
                     amt5        LIKE type_file.num20,  #No.FUN-680107 DEC(30,0) #金額5
                     amt6        LIKE type_file.num20   #No.FUN-680107 DEC(30,0) #金額6
                     END RECORD
   DEFINE l_plandate  LIKE nqg_file.nqg04
   DEFINE l_plan      LIKE nqg_file.nqg02
   DEFINE l_date      LIKE nqg_file.nqg04
   DEFINE l_class     LIKE nqg_file.nqg05
   DEFINE l_cate      LIKE nqg_file.nqg06
   DEFINE l_amou      LIKE nqg_file.nqg12
   DEFINE l_tmp_cnt   LIKE type_file.num5   #No.FUN-680107 SMALLINT
   DEFINE l_i         LIKE type_file.num5   #No.FUN-680107 SMALLINT
   DEFINE l_cn        LIKE type_file.num5   #No.FUN-680107 SMALLINT
   DEFINE k           LIKE type_file.num5   #No.FUN-680107 SMALLINT
   DEFINE i           LIKE type_file.num5   #No.FUN-680107 SMALLINT
   DEFINE n           LIKE type_file.num5   #No.FUN-680107 SMALLINT
   DEFINE l_page      LIKE type_file.num5   #No.FUN-680107 DATE
   DEFINE l_date1     LIKE type_file.dat    #No.FUN-680107 DATE
   DEFINE l_date2     LIKE type_file.dat    #No.FUN-680107 DATE
   DEFINE l_date3     LIKE type_file.dat    #No.FUN-680107 DATE
   DEFINE l_date4     LIKE type_file.dat    #No.FUN-680107 DATE
   DEFINE l_date5     LIKE type_file.dat    #No.FUN-680107 DATE
   DEFINE l_date6     LIKE type_file.dat    #No.FUN-680107 DATE
   DEFINE l_amt1      LIKE type_file.num20  #No.FUN-680107 DEC(30,0) 
   DEFINE l_amt2      LIKE type_file.num20  #No.FUN-680107 DEC(30,0)
   DEFINE l_amt3      LIKE type_file.num20  #No.FUN-680107 DEC(30,0)
   DEFINE l_amt4      LIKE type_file.num20  #No.FUN-680107 DEC(30,0)
   DEFINE l_amt5      LIKE type_file.num20  #No.FUN-680107 DEC(30,0)
   DEFINE l_amt6      LIKE type_file.num20  #No.FUN-680107 DEC(30,0)
   DEFINE l_cnt       LIKE type_file.num5   #No.FUN-680107 SMALLINT
   DEFINE l_amt_000   LIKE type_file.num20  #No.FUN-680107 DEC(30,0)
 
   DELETE FROM nqg_tmp
   IF STATUS THEN
      CALL cl_err("del tmp error",STATUS,0)
      RETURN
   END IF
   DELETE FROM amt_tmp
   IF STATUS THEN
      CALL cl_err("del tmp error",STATUS,0)
      RETURN
   END IF
 
   CALL g_zaa_dyn.clear()

   #No.FUN-B80067--mark--Begin--- 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0082
   #No.FUN-B80067--mark--End-----
   
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-830148 *** ##                                                    
   CALL cl_del_data(l_table)                                                                                                      
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                     #FUN-830148                                       
   #------------------------------ CR (2) ------------------------------# 
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   CALL g_nqg_tmp.clear()
   CALL g_nqg_ldate.clear()
   CALL g_nqg_000.clear()
   CALL g_nqg_100.clear()
   CALL g_nqg_101.clear()
   CALL g_nqg_102.clear()
   CALL g_nqg_103.clear()
   CALL g_nqg_104.clear()
   CALL g_nqg_105.clear()
   CALL g_nqg_106.clear()
   CALL g_nqg_107.clear()
   CALL g_nqg_108.clear()
   CALL g_nqg_109.clear()
   CALL g_nqg_110.clear()
   CALL g_nqg_111.clear()
   CALL g_nqg_112.clear()
   CALL g_nqg_113.clear()
   CALL g_nqg_114.clear()
   CALL g_nqg_sumbus.clear()
   CALL g_nqg_200.clear()
   CALL g_nqg_201.clear()
   CALL g_nqg_202.clear()
   CALL g_nqg_203.clear()
   CALL g_nqg_suminv.clear()
   CALL g_nqg_300.clear()
   CALL g_nqg_301.clear()
   CALL g_nqg_302.clear()
   CALL g_nqg_303.clear()
   CALL g_nqg_304.clear()
   CALL g_nqg_sumfin.clear()
   CALL g_nqg_bal.clear()
   CALL g_nqg_rev.clear()
   CALL g_nqg_gap.clear()
   
   INITIALIZE sr1.* TO NULL
#  CALL cl_outnam('anmr900') RETURNING l_name                           #FUN-830148 MARK
#  START REPORT anmr900_rep TO l_name                                   #FUN-830148 MARK
   LET g_pageno = 0
   CALL r900_c_buk_tmp()       # 產生時距檔
   CALL r900_nqg_buk()
 
#   LET g_sql = "SELECT UNIQUE plan FROM buk_nqg "      #TQC-950152
   LET g_sql = "SELECT UNIQUE plan_1 FROM buk_nqg "     #TQC-950152
 
   PREPARE r900_pnqgtmp FROM g_sql
   DECLARE r900_bnqgtmp CURSOR FOR r900_pnqgtmp
 
   FOREACH r900_bnqgtmp INTO l_plan
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach nqgtmp1:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET l_nqg_tmp.bal = 0
      LET l_cn  = 0
      LET g_sql = "SELECT UNIQUE plan_date FROM buk_tmp "
 
      PREPARE r900_pnqgtmp2 FROM g_sql
      DECLARE r900_bnqgtmp2 CURSOR FOR r900_pnqgtmp2
      
      FOREACH r900_bnqgtmp2 INTO l_date
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach nqgtmp2:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
      
         LET l_nqg_tmp.nqg01 = ''
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
         LET l_nqg_tmp.nqg_204 = 0   
         LET l_nqg_tmp.nqg_205 = 0  
         LET l_nqg_tmp.nqg_300 = 0
         LET l_nqg_tmp.nqg_301 = 0
         LET l_nqg_tmp.nqg_302 = 0
         LET l_nqg_tmp.nqg_303 = 0
         LET l_nqg_tmp.nqg_304 = 0
         LET l_nqg_tmp.rev = 0
 
         LET g_sql = "SELECT class,cate,amou FROM buk_nqg ",
                     " WHERE ldate = '",l_date,"'",
#                     "   AND plan = '",l_plan,"'"    #TQC-950152 
                     "   AND plan_1 = '",l_plan,"'"   #TQC-950152 
         
         PREPARE r900_pnqgtmp1 FROM g_sql
         DECLARE r900_bnqgtmp1 CURSOR FOR r900_pnqgtmp1
         
         FOREACH r900_bnqgtmp1 INTO l_class,l_cate,l_amou
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
               WHEN "204"
                  LET l_nqg_tmp.nqg_204 = l_nqg_tmp.nqg_204 + l_amou
               WHEN "205"
                  LET l_nqg_tmp.nqg_204 = l_nqg_tmp.nqg_205 + l_amou
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
                        LET l_nqg_tmp.nqg_114 = l_nqg_tmp.nqg_114 + l_amou   #No.MOD-740154
                     WHEN "2"
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
                                 + l_nqg_tmp.nqg_202 + l_nqg_tmp.nqg_203     
                                 + l_nqg_tmp.nqg_204 - l_nqg_tmp.nqg_205    
      
         LET l_nqg_tmp.sum_fin = l_nqg_tmp.nqg_300 - l_nqg_tmp.nqg_301
                               - l_nqg_tmp.nqg_302 - l_nqg_tmp.nqg_303
                               - l_nqg_tmp.nqg_304
      
         LET l_nqg_tmp.bal = l_nqg_tmp.nqg_000 + l_nqg_tmp.sum_bus
                           + l_nqg_tmp.sum_inv + l_nqg_tmp.sum_fin
      
         LET l_nqg_tmp.gap = l_nqg_tmp.bal - l_nqg_tmp.rev
         INSERT INTO nqg_tmp VALUES(l_nqg_tmp.*)
         IF STATUS THEN
            CALL cl_err("ins nqg_tmp error",STATUS,0)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
            EXIT PROGRAM
         END IF 
         LET l_cn = l_cn + 1
         END FOREACH
      END FOREACH
      LET l_i = 1
      LET g_sql = "SELECT * FROM nqg_tmp ",
                  " WHERE nqg02 = '",tm.nqg02,"'",
                  " ORDER BY nqg02,ldate" 
      PREPARE r900_ptmp1 FROM g_sql
      DECLARE r900_ctmp1 CURSOR FOR r900_ptmp1
      FOREACH r900_ctmp1 INTO g_nqg_tmp[l_i].*
          IF STATUS THEN
             CALL cl_err("foreach nqg_tmp error",STATUS,0)
             CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
             EXIT PROGRAM
          END IF 
          LET g_nqg_ldate[l_i].ldate = g_nqg_tmp[l_i].ldate
          LET g_nqg_000[l_i].amt_000 = g_nqg_tmp[l_i].nqg_000
          LET g_nqg_100[l_i].amt_100 = g_nqg_tmp[l_i].nqg_100
          LET g_nqg_101[l_i].amt_101 = g_nqg_tmp[l_i].nqg_101
          LET g_nqg_102[l_i].amt_102 = g_nqg_tmp[l_i].nqg_102
          LET g_nqg_103[l_i].amt_103 = g_nqg_tmp[l_i].nqg_103
          LET g_nqg_104[l_i].amt_104 = g_nqg_tmp[l_i].nqg_104
          LET g_nqg_105[l_i].amt_105 = g_nqg_tmp[l_i].nqg_105
          LET g_nqg_106[l_i].amt_106 = g_nqg_tmp[l_i].nqg_106
          LET g_nqg_107[l_i].amt_107 = g_nqg_tmp[l_i].nqg_107
          LET g_nqg_108[l_i].amt_108 = g_nqg_tmp[l_i].nqg_108
          LET g_nqg_109[l_i].amt_109 = g_nqg_tmp[l_i].nqg_109
          LET g_nqg_110[l_i].amt_110 = g_nqg_tmp[l_i].nqg_110
          LET g_nqg_111[l_i].amt_111 = g_nqg_tmp[l_i].nqg_111
          LET g_nqg_112[l_i].amt_112 = g_nqg_tmp[l_i].nqg_112
          LET g_nqg_113[l_i].amt_113 = g_nqg_tmp[l_i].nqg_113
          LET g_nqg_114[l_i].amt_114 = g_nqg_tmp[l_i].nqg_114
          LET g_nqg_sumbus[l_i].amt_sumbus = g_nqg_tmp[l_i].sum_bus
          LET g_nqg_200[l_i].amt_200 = g_nqg_tmp[l_i].nqg_200
          LET g_nqg_201[l_i].amt_201 = g_nqg_tmp[l_i].nqg_201
          LET g_nqg_202[l_i].amt_202 = g_nqg_tmp[l_i].nqg_202
          LET g_nqg_203[l_i].amt_203 = g_nqg_tmp[l_i].nqg_203
          LET g_nqg_204[l_i].amt_204 = g_nqg_tmp[l_i].nqg_204
          LET g_nqg_205[l_i].amt_205 = g_nqg_tmp[l_i].nqg_205
          LET g_nqg_suminv[l_i].amt_suminv = g_nqg_tmp[l_i].sum_inv
          LET g_nqg_300[l_i].amt_300 = g_nqg_tmp[l_i].nqg_300
          LET g_nqg_301[l_i].amt_301 = g_nqg_tmp[l_i].nqg_301
          LET g_nqg_302[l_i].amt_302 = g_nqg_tmp[l_i].nqg_302
          LET g_nqg_303[l_i].amt_303 = g_nqg_tmp[l_i].nqg_303
          LET g_nqg_304[l_i].amt_304 = g_nqg_tmp[l_i].nqg_304
          LET g_nqg_sumfin[l_i].amt_sumfin = g_nqg_tmp[l_i].sum_fin
          LET g_nqg_bal[l_i].amt_bal = g_nqg_tmp[l_i].bal 
          LET g_nqg_rev[l_i].amt_rev = g_nqg_tmp[l_i].rev
          LET g_nqg_gap[l_i].amt_gap = g_nqg_tmp[l_i].gap
          LET l_i = l_i + 1
      END FOREACH
      LET l_amt1 = 0 
      LET l_amt2 = 0
      LET l_amt3 = 0
      LET l_amt4 = 0
      LET l_amt5 = 0
      LET l_amt6 = 0
      LET n = 0
      LET g_tmp_cnt = l_i - 1 
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
        #營運活動資金  
          LET l_amt1 = 0
          LET n = n + 1
          LET l_amt2 = 0
          LET n = n + 1
          LET l_amt3 = 0
          LET n = n + 1
          LET l_amt4 = 0
          LET n = n + 1
          LET l_amt5 = 0
          LET n = n + 1
          LET l_amt6 = 0
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,2,'02',
                                   l_amt1,l_amt2,l_amt3,
                                   l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF 
        #期初訂金 
        LET l_amt1 = g_nqg_000[i+n].amt_000
        LET n = n + 1
        LET l_amt2 = g_nqg_000[i+n].amt_000
        LET n = n + 1
        LET l_amt3 = g_nqg_000[i+n].amt_000
        LET n = n + 1
        LET l_amt4 = g_nqg_000[i+n].amt_000
        LET n = n + 1
        LET l_amt5 = g_nqg_000[i+n].amt_000
        LET n = n + 1
        LET l_amt6 = g_nqg_000[i+n].amt_000
        INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,3,'03',
                                   l_amt1,l_amt2,l_amt3,
                                   l_amt4,l_amt5,l_amt6)
        IF STATUS THEN
            CALL cl_err("ins amt_tmp error",STATUS,0)
            EXIT FOR
        END IF 
        IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          ##訂單
          LET l_amt1 = g_nqg_100[i+n].amt_100
          LET n = n + 1
          LET l_amt2 = g_nqg_100[i+n].amt_100
	  LET n = n + 1
          LET l_amt3 = g_nqg_100[i+n].amt_100
          LET n = n + 1
          LET l_amt4 = g_nqg_100[i+n].amt_100
          LET n = n + 1
          LET l_amt5 = g_nqg_100[i+n].amt_100
          LET n = n + 1
          LET l_amt6 = g_nqg_100[i+n].amt_100
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,4,'04',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #101銷貨單
          LET l_amt1 = g_nqg_101[i+n].amt_101
          LET n = n + 1
          LET l_amt2 = g_nqg_101[i+n].amt_101
	  LET n = n + 1
          LET l_amt3 = g_nqg_101[i+n].amt_101
          LET n = n + 1
          LET l_amt4 = g_nqg_101[i+n].amt_101
          LET n = n + 1
          LET l_amt5 = g_nqg_101[i+n].amt_101
          LET n = n + 1
          LET l_amt6 = g_nqg_101[i+n].amt_101
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,5,'05',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0 
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #102應收帳款
          LET l_amt1 = g_nqg_102[i+n].amt_102
          LET n = n + 1
          LET l_amt2 = g_nqg_102[i+n].amt_102
	  LET n = n + 1
          LET l_amt3 = g_nqg_102[i+n].amt_102
          LET n = n + 1
          LET l_amt4 = g_nqg_102[i+n].amt_102
          LET n = n + 1
          LET l_amt5 = g_nqg_102[i+n].amt_102
          LET n = n + 1
          LET l_amt6 = g_nqg_102[i+n].amt_102
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,6,'06',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0 
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #103應收票據
          LET l_amt1 = g_nqg_103[i+n].amt_103
          LET n = n + 1
          LET l_amt2 = g_nqg_103[i+n].amt_103
	  LET n = n + 1
          LET l_amt3 = g_nqg_103[i+n].amt_103
          LET n = n + 1
          LET l_amt4 = g_nqg_103[i+n].amt_103
          LET n = n + 1
          LET l_amt5 = g_nqg_103[i+n].amt_103
          LET n = n + 1
          LET l_amt6 = g_nqg_103[i+n].amt_103
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,7,'07',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0 
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #104採購(委外採購)單
          LET l_amt1 = g_nqg_104[i+n].amt_104
          LET n = n + 1
          LET l_amt2 = g_nqg_104[i+n].amt_104
	  LET n = n + 1
          LET l_amt3 = g_nqg_104[i+n].amt_104
          LET n = n + 1
          LET l_amt4 = g_nqg_104[i+n].amt_104
          LET n = n + 1
          LET l_amt5 = g_nqg_104[i+n].amt_104
          LET n = n + 1
          LET l_amt6 = g_nqg_104[i+n].amt_104
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,8,'08',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0 
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #105入庫單
          LET l_amt1 = g_nqg_105[i+n].amt_105
          LET n = n + 1
          LET l_amt2 = g_nqg_105[i+n].amt_105
	  LET n = n + 1
          LET l_amt3 = g_nqg_105[i+n].amt_105
          LET n = n + 1
          LET l_amt4 = g_nqg_105[i+n].amt_105
          LET n = n + 1
          LET l_amt5 = g_nqg_105[i+n].amt_105
          LET n = n + 1
          LET l_amt6 = g_nqg_105[i+n].amt_105
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,9,'09',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0 
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #106應付帳款
          LET l_amt1 = g_nqg_106[i+n].amt_106
          LET n = n + 1
          LET l_amt2 = g_nqg_106[i+n].amt_106
	  LET n = n + 1
          LET l_amt3 = g_nqg_106[i+n].amt_106
          LET n = n + 1
          LET l_amt4 = g_nqg_106[i+n].amt_106
          LET n = n + 1
          LET l_amt5 = g_nqg_106[i+n].amt_106
          LET n = n + 1
          LET l_amt6 = g_nqg_106[i+n].amt_106
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,10,'10',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          ##107應付票據
          LET l_amt1 = g_nqg_107[i+n].amt_107
          LET n = n + 1
          LET l_amt2 = g_nqg_107[i+n].amt_107
	  LET n = n + 1
          LET l_amt3 = g_nqg_107[i+n].amt_107
          LET n = n + 1
          LET l_amt4 = g_nqg_107[i+n].amt_107
          LET n = n + 1
          LET l_amt5 = g_nqg_107[i+n].amt_107
          LET n = n + 1
          LET l_amt6 = g_nqg_107[i+n].amt_107
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,11,'11',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #108 LC開狀保證金
          LET l_amt1 = g_nqg_108[i+n].amt_108
          LET n = n + 1
          LET l_amt2 = g_nqg_108[i+n].amt_108
	  LET n = n + 1
          LET l_amt3 = g_nqg_108[i+n].amt_108
          LET n = n + 1
          LET l_amt4 = g_nqg_108[i+n].amt_108
          LET n = n + 1
          LET l_amt5 = g_nqg_108[i+n].amt_108
          LET n = n + 1
          LET l_amt6 = g_nqg_108[i+n].amt_108
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,12,'12',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #109 直接人工
          LET l_amt1 = g_nqg_109[i+n].amt_109
          LET n = n + 1
          LET l_amt2 = g_nqg_109[i+n].amt_109
	  LET n = n + 1
          LET l_amt3 = g_nqg_109[i+n].amt_109
          LET n = n + 1
          LET l_amt4 = g_nqg_109[i+n].amt_109
          LET n = n + 1
          LET l_amt5 = g_nqg_109[i+n].amt_109
          LET n = n + 1
          LET l_amt6 = g_nqg_109[i+n].amt_109
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,13,'13',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #110 製造費用
          LET l_amt1 = g_nqg_110[i+n].amt_110
          LET n = n + 1
          LET l_amt2 = g_nqg_110[i+n].amt_110
	  LET n = n + 1
          LET l_amt3 = g_nqg_110[i+n].amt_110
          LET n = n + 1
          LET l_amt4 = g_nqg_110[i+n].amt_110
          LET n = n + 1
          LET l_amt5 = g_nqg_110[i+n].amt_110
          LET n = n + 1
          LET l_amt6 = g_nqg_110[i+n].amt_110
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,14,'14',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #111 管理費用
          LET l_amt1 = g_nqg_111[i+n].amt_111
          LET n = n + 1
          LET l_amt2 = g_nqg_111[i+n].amt_111
	  LET n = n + 1
          LET l_amt3 = g_nqg_111[i+n].amt_111
          LET n = n + 1
          LET l_amt4 = g_nqg_111[i+n].amt_111
          LET n = n + 1
          LET l_amt5 = g_nqg_111[i+n].amt_111
          LET n = n + 1
          LET l_amt6 = g_nqg_111[i+n].amt_111
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,15,'15',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #112 銷售費用 
          LET l_amt1 = g_nqg_112[i+n].amt_112
          LET n = n + 1
          LET l_amt2 = g_nqg_112[i+n].amt_112
	  LET n = n + 1
          LET l_amt3 = g_nqg_112[i+n].amt_112
          LET n = n + 1
          LET l_amt4 = g_nqg_112[i+n].amt_112
          LET n = n + 1
          LET l_amt5 = g_nqg_112[i+n].amt_112
          LET n = n + 1
          LET l_amt6 = g_nqg_112[i+n].amt_112
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,16,'16',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #113 研發費用 
          LET l_amt1 = g_nqg_113[i+n].amt_113
          LET n = n + 1
          LET l_amt2 = g_nqg_113[i+n].amt_113
	  LET n = n + 1
          LET l_amt3 = g_nqg_113[i+n].amt_113
          LET n = n + 1
          LET l_amt4 = g_nqg_113[i+n].amt_113
          LET n = n + 1
          LET l_amt5 = g_nqg_113[i+n].amt_113
          LET n = n + 1
          LET l_amt6 = g_nqg_113[i+n].amt_113
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,17,'17',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n  < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #114 其它 
          LET l_amt1 = g_nqg_114[i+n].amt_114
          LET n = n + 1
          LET l_amt2 = g_nqg_114[i+n].amt_114
	  LET n = n + 1
          LET l_amt3 = g_nqg_114[i+n].amt_114
          LET n = n + 1
          LET l_amt4 = g_nqg_114[i+n].amt_114
          LET n = n + 1
          LET l_amt5 = g_nqg_114[i+n].amt_114
          LET n = n + 1
          LET l_amt6 = g_nqg_114[i+n].amt_114
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,18,'18',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #營運活動資金餘額小計
          LET l_amt1 = g_nqg_sumbus[i+n].amt_sumbus
          LET n = n + 1
          LET l_amt2 = g_nqg_sumbus[i+n].amt_sumbus
	  LET n = n + 1
          LET l_amt3 = g_nqg_sumbus[i+n].amt_sumbus
          LET n = n + 1
          LET l_amt4 = g_nqg_sumbus[i+n].amt_sumbus
          LET n = n + 1
          LET l_amt5 = g_nqg_sumbus[i+n].amt_sumbus
          LET n = n + 1
          LET l_amt6 = g_nqg_sumbus[i+n].amt_sumbus
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,19,'19',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #投資活動資金
          LET l_amt1 = 0
          LET n = n + 1
          LET l_amt2 = 0
          LET n = n + 1
          LET l_amt3 = 0
          LET n = n + 1
          LET l_amt4 = 0
          LET n = n + 1
          LET l_amt5 = 0
          LET n = n + 1
          LET l_amt6 = 0
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,20,'20',
                                   l_amt1,l_amt2,l_amt3,
                                   l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #資本支出預算數
          LET l_amt1 = g_nqg_200[i+n].amt_200
          LET n = n + 1
          LET l_amt2 = g_nqg_200[i+n].amt_200
	  LET n = n + 1
          LET l_amt3 = g_nqg_200[i+n].amt_200
          LET n = n + 1
          LET l_amt4 = g_nqg_200[i+n].amt_200
          LET n = n + 1
          LET l_amt5 = g_nqg_200[i+n].amt_200
          LET n = n + 1
          LET l_amt6 = g_nqg_200[i+n].amt_200
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,21,'21',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #長短期投資
          LET l_amt1 = g_nqg_201[i+n].amt_201
          LET n = n + 1
          LET l_amt2 = g_nqg_201[i+n].amt_201
	  LET n = n + 1
          LET l_amt3 = g_nqg_201[i+n].amt_201
          LET n = n + 1
          LET l_amt4 = g_nqg_201[i+n].amt_201
          LET n = n + 1
          LET l_amt5 = g_nqg_201[i+n].amt_201
          LET n = n + 1
          LET l_amt6 = g_nqg_201[i+n].amt_201
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,22,'22',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #現金增資
          LET l_amt1 = g_nqg_202[i+n].amt_202
          LET n = n + 1
          LET l_amt2 = g_nqg_202[i+n].amt_202
	  LET n = n + 1
          LET l_amt3 = g_nqg_202[i+n].amt_202
          LET n = n + 1
          LET l_amt4 = g_nqg_202[i+n].amt_202
          LET n = n + 1
          LET l_amt5 = g_nqg_202[i+n].amt_202
          LET n = n + 1
          LET l_amt6 = g_nqg_202[i+n].amt_202
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,23,'23',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #外匯
          LET l_amt1 = g_nqg_203[i+n].amt_203
          LET n = n + 1
          LET l_amt2 = g_nqg_203[i+n].amt_203
	  LET n = n + 1
          LET l_amt3 = g_nqg_203[i+n].amt_203
          LET n = n + 1
          LET l_amt4 = g_nqg_203[i+n].amt_203
          LET n = n + 1
          LET l_amt5 = g_nqg_203[i+n].amt_203
          LET n = n + 1
          LET l_amt6 = g_nqg_203[i+n].amt_203
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,24,'24',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #204 投資
          LET l_amt1 = g_nqg_204[i+n].amt_204
          LET n = n + 1
          LET l_amt2 = g_nqg_204[i+n].amt_204
	  LET n = n + 1
          LET l_amt3 = g_nqg_204[i+n].amt_204
          LET n = n + 1
          LET l_amt4 = g_nqg_204[i+n].amt_204
          LET n = n + 1
          LET l_amt5 = g_nqg_204[i+n].amt_204
          LET n = n + 1
          LET l_amt6 = g_nqg_204[i+n].amt_204
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,25,'25',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #205 其它
          LET l_amt1 = g_nqg_205[i+n].amt_205
          LET n = n + 1
          LET l_amt2 = g_nqg_205[i+n].amt_205
	  LET n = n + 1
          LET l_amt3 = g_nqg_205[i+n].amt_205
          LET n = n + 1
          LET l_amt4 = g_nqg_205[i+n].amt_205
          LET n = n + 1
          LET l_amt5 = g_nqg_205[i+n].amt_205
          LET n = n + 1
          LET l_amt6 = g_nqg_205[i+n].amt_205
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,26,'26',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #投資活動資金餘額小計
          LET l_amt1 = g_nqg_suminv[i+n].amt_suminv
          LET n = n + 1
          LET l_amt2 = g_nqg_suminv[i+n].amt_suminv
	  LET n = n + 1
          LET l_amt3 = g_nqg_suminv[i+n].amt_suminv
          LET n = n + 1
          LET l_amt4 = g_nqg_suminv[i+n].amt_suminv
          LET n = n + 1
          LET l_amt5 = g_nqg_suminv[i+n].amt_suminv
          LET n = n + 1
          LET l_amt6 = g_nqg_suminv[i+n].amt_suminv
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,27,'27',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #理財活動資金
          LET l_amt1 = 0
          LET n = n + 1
          LET l_amt2 = 0
          LET n = n + 1
          LET l_amt3 = 0
          LET n = n + 1
          LET l_amt4 = 0
          LET n = n + 1
          LET l_amt5 = 0
          LET n = n + 1
          LET l_amt6 = 0
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,28,'28',
                                   l_amt1,l_amt2,l_amt3,
                                   l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n  < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #應收利息
          LET l_amt1 = g_nqg_300[i+n].amt_300
          LET n = n + 1
          LET l_amt2 = g_nqg_300[i+n].amt_300
	  LET n = n + 1
          LET l_amt3 = g_nqg_300[i+n].amt_300
          LET n = n + 1
          LET l_amt4 = g_nqg_300[i+n].amt_300
          LET n = n + 1
          LET l_amt5 = g_nqg_300[i+n].amt_300
          LET n = n + 1
          LET l_amt6 = g_nqg_300[i+n].amt_300
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,29,'29',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          ##短期融資到期
          LET l_amt1 = g_nqg_301[i+n].amt_301
          LET n = n + 1
          LET l_amt2 = g_nqg_301[i+n].amt_301
	  LET n = n + 1
          LET l_amt3 = g_nqg_301[i+n].amt_301
          LET n = n + 1
          LET l_amt4 = g_nqg_301[i+n].amt_301
          LET n = n + 1
          LET l_amt5 = g_nqg_301[i+n].amt_301
          LET n = n + 1
          LET l_amt6 = g_nqg_301[i+n].amt_301
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,30,'30',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #長期融資到期
          LET l_amt1 = g_nqg_302[i+n].amt_302
          LET n = n + 1
          LET l_amt2 = g_nqg_302[i+n].amt_302
	  LET n = n + 1
          LET l_amt3 = g_nqg_302[i+n].amt_302
          LET n = n + 1
          LET l_amt4 = g_nqg_302[i+n].amt_302
          LET n = n + 1
          LET l_amt5 = g_nqg_302[i+n].amt_302
          LET n = n + 1
          LET l_amt6 = g_nqg_302[i+n].amt_302
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,31,'31',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #應付利息
          LET l_amt1 = g_nqg_303[i+n].amt_303
          LET n = n + 1
          LET l_amt2 = g_nqg_303[i+n].amt_303
	  LET n = n + 1
          LET l_amt3 = g_nqg_303[i+n].amt_303
          LET n = n + 1
          LET l_amt4 = g_nqg_303[i+n].amt_303
          LET n = n + 1
          LET l_amt5 = g_nqg_303[i+n].amt_303
          LET n = n + 1
          LET l_amt6 = g_nqg_303[i+n].amt_303
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,32,'32',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n > =g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #其它
          LET l_amt1 = g_nqg_304[i+n].amt_304
          LET n = n + 1
          LET l_amt2 = g_nqg_304[i+n].amt_304
	  LET n = n + 1
          LET l_amt3 = g_nqg_304[i+n].amt_304
          LET n = n + 1
          LET l_amt4 = g_nqg_304[i+n].amt_304
          LET n = n + 1
          LET l_amt5 = g_nqg_304[i+n].amt_304
          LET n = n + 1
          LET l_amt6 = g_nqg_304[i+n].amt_304
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,33,'33',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #理財活動資金餘額小計
          LET l_amt1 = g_nqg_sumfin[i+n].amt_sumfin
          LET n = n + 1
          LET l_amt2 = g_nqg_sumfin[i+n].amt_sumfin
	  LET n = n + 1
          LET l_amt3 = g_nqg_sumfin[i+n].amt_sumfin
          LET n = n + 1
          LET l_amt4 = g_nqg_sumfin[i+n].amt_sumfin
          LET n = n + 1
          LET l_amt5 = g_nqg_sumfin[i+n].amt_sumfin
          LET n = n + 1
          LET l_amt6 = g_nqg_sumfin[i+n].amt_sumfin
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,34,'34',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #期末現金餘額
          LET l_amt1 = g_nqg_bal[i+n].amt_bal
          LET n = n + 1
          LET l_amt2 = g_nqg_bal[i+n].amt_bal
	  LET n = n + 1
          LET l_amt3 = g_nqg_bal[i+n].amt_bal
          LET n = n + 1
          LET l_amt4 = g_nqg_bal[i+n].amt_bal
          LET n = n + 1
          LET l_amt5 = g_nqg_bal[i+n].amt_bal
          LET n = n + 1
          LET l_amt6 = g_nqg_bal[i+n].amt_bal
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,35,'35',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n > =g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #營運週轉金
          LET l_amt1 = g_nqg_rev[i+n].amt_rev
          LET n = n + 1
          LET l_amt2 = g_nqg_rev[i+n].amt_rev
	  LET n = n + 1
          LET l_amt3 = g_nqg_rev[i+n].amt_rev
          LET n = n + 1
          LET l_amt4 = g_nqg_rev[i+n].amt_rev
          LET n = n + 1
          LET l_amt5 = g_nqg_rev[i+n].amt_rev
          LET n = n + 1
          LET l_amt6 = g_nqg_rev[i+n].amt_rev
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,36,'36',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET n = 0
      FOR i = 1 TO g_tmp_cnt          #塞入工廠/頁次/項次/項目/金額 
        IF i+n < = 6 THEN  LET l_page = 1  ELSE LET l_page = l_page + 1 END IF
          #資金缺口
          LET l_amt1 = g_nqg_gap[i+n].amt_gap
          LET n = n + 1
          LET l_amt2 = g_nqg_gap[i+n].amt_gap
	  LET n = n + 1
          LET l_amt3 = g_nqg_gap[i+n].amt_gap
          LET n = n + 1
          LET l_amt4 = g_nqg_gap[i+n].amt_gap
          LET n = n + 1
          LET l_amt5 = g_nqg_gap[i+n].amt_gap
          LET n = n + 1
          LET l_amt6 = g_nqg_gap[i+n].amt_gap
          INSERT INTO amt_tmp VALUES(tm.nqg02,l_page,37,'37',
                                     l_amt1,l_amt2,l_amt3,
                                     l_amt4,l_amt5,l_amt6)
          IF STATUS THEN
              CALL cl_err("ins nqg_tmp error",STATUS,0)
              EXIT FOR
          END IF 
          IF i+n >= g_tmp_cnt THEN EXIT FOR END IF
      END FOR
      LET l_cnt = 1
      LET g_sql = "SELECT * FROM amt_tmp "
      PREPARE r900_ptmp FROM g_sql
      DECLARE r900_btmp CURSOR FOR r900_ptmp
      FOREACH r900_btmp  INTO sr1.*
#         OUTPUT TO REPORT anmr900_rep(sr1.*)                                     #FUN-830148 MARK
     ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-830148 *** ##                                                      
         EXECUTE insert_prep USING                                                                                                  
                 sr1.plant,sr1.page,sr1.code,sr1.amt1,sr1.amt2,sr1.amt3,
                 sr1.amt4,sr1.amt5,sr1.amt6 
     #------------------------------ CR (3) ------------------------------#    
          LET l_cnt = l_cnt + 1 
      END FOREACH
      DISPLAY BY NAME l_cnt
#    FINISH REPORT anmr900_rep                                                     #FUN-830148 MARK
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)                                     #FUN-830148 MARK
#No.FUN-830148--begin                                                                                                               
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'nqg01')                                                     
              RETURNING tm.wc                                                                                                       
      END IF                                                                                                                        
#No.FUN-830148--end
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-830148 **** ##                                                        
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = tm.wc,";",g_nqg_tmp[1].ldate,";",g_nqg_tmp[2].ldate,";",g_nqg_tmp[3].ldate,";",
                g_nqg_tmp[4].ldate,";",g_nqg_tmp[5].ldate,";",g_nqg_tmp[6].ldate                                                       
    CALL cl_prt_cs3('anmr900','anmr900',g_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#
   #No.FUN-B80067--mark--Begin---
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0082
   #No.FUN-B80067--mark--End-----
END FUNCTION
 
#FUN-830148--Mark--Begin--#
#REPORT anmr900_rep(sr1)
#  DEFINE l_last_sw  LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
#         sr1        RECORD
#                    plant       LIKE nqg_file.nqg02,   #No.FUN-680107 VARCHAR(10)  #工廠
#                    page        LIKE type_file.num5,   #No.FUN-680107 SMALLINT #頁次
#                    ln          LIKE type_file.num5,   #No.FUN-680107 SMALLINT #項次
#                    code        LIKE type_file.chr8,   #No.FUN-680107 VARCHAR(8) #項目
#                    amt1        LIKE type_file.num20,  #No.FUN-680107 DEC(30,0) #金額1
#                    amt2        LIKE type_file.num20,  #No.FUN-680107 DEC(30,0) #金額2
#                    amt3        LIKE type_file.num20,  #No.FUN-680107 DEC(30,0) #金額3
#                    amt4        LIKE type_file.num20,  #No.FUN-680107 DEC(30,0) #金額4
#                    amt5        LIKE type_file.num20,  #No.FUN-680107 DEC(30,0) #金額5
#                    amt6        LIKE type_file.num20   #No.FUN-680107 DEC(30,0) #金額6
#                    END RECORD
#  DEFINE     l_p    LIKE type_file.num5          #No.FUN-680107 SMALLINT
#  DEFINE     l_ac   LIKE type_file.num5          #No.FUN-680107 SMALLINT
#  DEFINE     l_i    LIKE type_file.num5          #No.FUN-680107 SMALLINT
#  DEFINE     l_j    LIKE type_file.num5          #No.FUN-680107 SMALLINT
#  DEFINE     i      LIKE type_file.num10         #No.FUN-680107 INTEGER
#
 
#  OUTPUT 
#    TOP MARGIN g_top_margin
#    LEFT MARGIN g_left_margin
#    BOTTOM MARGIN g_bottom_margin
#    PAGE LENGTH g_page_line
 
#  ORDER BY sr1.plant,sr1.page,sr1.code
 
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#        LET g_pageno=g_pageno+1
#        LET pageno_total=PAGENO USING '<<<',"/pageno"
#        PRINT g_head CLIPPED,pageno_total
#        PRINT g_dash[1,g_len]
#        FOR l_p = 1 to 6
#            LET g_zaa[67+l_p].zaa08 = g_nqg_tmp[(sr1.page-1)*6+l_p].ldate
#        END FOR
#        CALL cl_prt_pos_dyn()
#        PRINTX name=H1 g_x[31],g_x[68],g_x[69],g_x[70],g_x[71],g_x[72],
#                       g_x[73]
#        PRINT g_dash1
#        LET l_last_sw = 'n'
#        LET l_ac = (g_tmp_cnt/6) + 1
#        LET l_j = 1
 
#        BEFORE GROUP OF sr1.plant
#          SKIP TO TOP OF PAGE 
 
#        BEFORE GROUP OF sr1.page
#          IF sr1.page <> 1 THEN
#             SKIP TO TOP OF PAGE
#          END IF
#
#        BEFORE GROUP OF sr1.code
#          CASE sr1.code
#             WHEN '02' PRINT g_x[32] CLIPPED
#             WHEN '03' PRINT g_x[33] CLIPPED;
#             WHEN '04' PRINT g_x[34] CLIPPED;
#             WHEN '05' PRINT g_x[35] CLIPPED;
#             WHEN '06' PRINT g_x[36] CLIPPED;
#             WHEN '07' PRINT g_x[37] CLIPPED;
#             WHEN '08' PRINT g_x[38] CLIPPED;
#             WHEN '09' PRINT g_x[39] CLIPPED;
#             WHEN '10' PRINT g_x[40] CLIPPED;
#             WHEN '11' PRINT g_x[41] CLIPPED;
#             WHEN '12' PRINT g_x[42] CLIPPED;
#             WHEN '13' PRINT g_x[43] CLIPPED;
#             WHEN '14' PRINT g_x[44] CLIPPED;
#             WHEN '15' PRINT g_x[45] CLIPPED;
#             WHEN '16' PRINT g_x[46] CLIPPED;
#             WHEN '17' PRINT g_x[47] CLIPPED;
#             WHEN '18' PRINT g_x[48] CLIPPED;
#             WHEN '19' PRINT g_x[49] CLIPPED;
#             WHEN '20' PRINT g_x[50] CLIPPED
#             WHEN '21' PRINT g_x[51] CLIPPED;
#             WHEN '22' PRINT g_x[52] CLIPPED;
#             WHEN '23' PRINT g_x[53] CLIPPED;
#             WHEN '24' PRINT g_x[54] CLIPPED;
#             WHEN '25' PRINT g_x[55] CLIPPED;
#             WHEN '26' PRINT g_x[56] CLIPPED;
#             WHEN '27' PRINT g_x[57] CLIPPED;
#             WHEN '28' PRINT g_x[58] CLIPPED
#             WHEN '29' PRINT g_x[59] CLIPPED;
#             WHEN '30' PRINT g_x[60] CLIPPED;
#             WHEN '31' PRINT g_x[61] CLIPPED;
#             WHEN '32' PRINT g_x[62] CLIPPED;
#             WHEN '33' PRINT g_x[63] CLIPPED;
#             WHEN '34' PRINT g_x[64] CLIPPED;
#             WHEN '35' PRINT g_x[65] CLIPPED;
#             WHEN '36' PRINT g_x[66] CLIPPED;
#             WHEN '37' PRINT g_x[67] CLIPPED;
#          END CASE    
#         
#        ON EVERY ROW
#             IF sr1.code <> '02' AND sr1.code <> '20' AND sr1.code <>'28' THEN
#                  PRINT COLUMN g_c[68],sr1.amt1 USING '---,---,---,---,---,---,---,--&',
#                        COLUMN g_c[69],sr1.amt2 USING '---,---,---,---,---,---,---,--&', 
#                        COLUMN g_c[70],sr1.amt3 USING '---,---,---,---,---,---,---,--&', 
#                        COLUMN g_c[71],sr1.amt4 USING '---,---,---,---,---,---,---,--&', 
#                        COLUMN g_c[72],sr1.amt5 USING '---,---,---,---,---,---,---,--&', 
#                        COLUMN g_c[73],sr1.amt6 USING '---,---,---,---,---,---,---,--&'       
#             END IF
#     ON LAST ROW
#        PRINT
#        PRINT g_dash[1,g_len]
#        LET l_last_sw = 'y'
#        PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
#    
#     PAGE TRAILER
#        IF l_last_sw = 'n' THEN 
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#        ELSE
#           SKIP 2 LINE
#        END IF
 
#END REPORT
#FUN-830148--Mark--End--#
 
FUNCTION rpg_buk()
   DEFINE l_bucket ARRAY[36] OF LIKE type_file.num5    #No.FUN-680107 SMALLINT
   DEFINE l_rpg    RECORD LIKE rpg_file.*
   DEFINE dd1,dd2  LIKE type_file.dat                  #No.FUN-680107 DATE
   DEFINE i,j      LIKE type_file.num10                #No.FUN-680107 INTEGER
 
   SELECT * INTO l_rpg.* FROM rpg_file
    WHERE rpg01 = tm.buk_code
   IF STATUS THEN
      CALL cl_err('sel rpg:',STATUS,1)
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
   INSERT INTO buk_tmp VALUES (l_bdate-1,past_date)
 
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
 
FUNCTION r900_c_buk_tmp()                #產生時距檔
   DEFINE d,d2     LIKE type_file.dat    #No.FUN-680107 DATE
   DEFINE l_nqf02  LIKE type_file.dat    #No.FUN-680107 DATE
   DEFINE j        LIKE type_file.num10  #No.FUN-680107 INTEGER
   DEFINE l_bdate1 LIKE type_file.dat    #No.TQC-950152 
 
   DROP TABLE buk_tmp
#No.FUN-680107 --START 
#  CREATE TABLE buk_tmp
#     (
#      real_date   DATE,
#      plan_date   DATE
#     )
 
   CREATE TEMP TABLE buk_tmp(
       real_date LIKE nqg_file.nqg04,
       plan_date LIKE type_file.dat)
#No.FUN-680107 --END
   IF STATUS THEN
      CALL cl_err('create buk_tmp:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
      EXIT PROGRAM
   END IF
   LET g_sql = "SELECT nqf02 FROM nqf_file,nqg_file", 
               " WHERE nqf00 = nqg01 ",
               "   AND ",tm.wc CLIPPED
 
   PREPARE p910_pnqf FROM g_sql
   DECLARE p910_bnqf CURSOR FOR p910_pnqf
 
   OPEN p910_bnqf
   FETCH p910_bnqf INTO l_nqf02
 
   LET l_bdate = g_today 
  
   CASE
      WHEN tm.buk_type = '1'
         CALL rpg_buk()
         RETURN
      WHEN tm.buk_type = '2'
         LET past_date = l_bdate-1
      WHEN tm.buk_type = '3'
         LET past_date = l_bdate-7
      WHEN tm.buk_type = '4'
         LET past_date = l_bdate-10
      WHEN tm.buk_type = '5'
         LET past_date = l_bdate-30
      OTHERWISE
         LET past_date = l_bdate-1
   END CASE
 
   CALL r900_buk_date(past_date) RETURNING past_date
#No.TQC-950152 --Begin                                                                                                              
#  INSERT INTO buk_tmp VALUES(l_bdate-1,past_date)                                                                                  
   LET l_bdate1=l_bdate-1                                                                                                           
   INSERT INTO buk_tmp VALUES(l_bdate1,past_date)                                                                                   
#No.TQC-950152  
   IF STATUS THEN
      CALL cl_err('ins buk_tmp:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
      EXIT PROGRAM
   END IF
 
   FOR j = l_bdate TO l_nqf02
      LET d=j
 
      CALL r900_buk_date(d) RETURNING d2
 
      INSERT INTO buk_tmp VALUES(d,d2)
      IF STATUS THEN
         CALL cl_err('ins buk_tmp:',STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
         EXIT PROGRAM
      END IF
   END FOR
 
END FUNCTION
 
FUNCTION r900_nqg_buk()
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
   DEFINE l_azp03 LIKE azp_file.azp03
   DEFINE l_rate  LIKE nqg_file.nqg11
 
   DROP TABLE buk_nqg
#No.FUN-680107 --START 
#  CREATE TABLE buk_nqg
#     (
#      ldate   DATE,
#      plan   VARCHAR(10),
#      class  VARCHAR(10),
#      cate   VARCHAR(3),
#      amou   DEC(20,6)
#     )
 
   CREATE TEMP TABLE buk_nqg(
       ldate LIKE nqg_file.nqg04,
#      plan  LIKE nqg_file.nqg02,                   #TQC-950152                                                                     
       plan_1  LIKE nqg_file.nqg02,                 #TQC-950152  
       class LIKE nqg_file.nqg05,
       cate  LIKE nqg_file.nqg06,
       amou  LIKE nqg_file.nqg12)
#No.FUN-680107 --END
   IF STATUS THEN
      CALL cl_err('create buk_nqg:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
      EXIT PROGRAM
   END IF
 
   CASE tm.cur_type
      WHEN "1"
         LET g_sql = "SELECT '',nqg02,nqg05,nqg06,nqg12,nqg04 FROM nqg_file",
                     " WHERE ",tm.wc CLIPPED,
                     "   AND nqg10 ='",tm.cur_code,"'"
      WHEN "2"
         LET g_sql = "SELECT '',nqg02,nqg05,nqg06,nqg13,nqg04 FROM nqg_file",
                     " WHERE ",tm.wc CLIPPED
      WHEN "3"
         LET g_sql = "SELECT '',nqg02,nqg05,nqg06,nqg14,nqg04 FROM nqg_file",
                     " WHERE ",tm.wc CLIPPED
   END CASE
 
   IF tm.nqg02 <> "ALL" THEN
      LET g_sql = g_sql CLIPPED, "   AND nqg02 = '",tm.nqg02,"'"
   END IF
 
   PREPARE r900_pbuknqg FROM g_sql
   DECLARE r900_bbuknqg CURSOR FOR r900_pbuknqg
 
   FOREACH r900_bbuknqg INTO tmp.*
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
         CALL cl_err("ins buk_nqg error",STATUS,0)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
         EXIT PROGRAM
      END IF
 
   END FOREACH
 
   #週轉金
   IF tm.nqg02 = "ALL" THEN
      LET g_sql = "SELECT * FROM nqb_file"
   ELSE
      LET g_sql = "SELECT * FROM nqb_file",
                  " WHERE nqb01 = '",tm.nqg02,"'"
   END IF
 
   PREPARE r900_pbuknqb FROM g_sql
   DECLARE r900_bbuknqb CURSOR FOR r900_pbuknqb
 
   FOREACH r900_bbuknqb INTO l_nqb.*
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
                  #"  FROM ",l_azp03,".aza_file"
                  "  FROM ",cl_get_target_table(l_nqb.nqb01,'aza_file') #FUN-A50102
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql                      #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,l_nqb.nqb01) RETURNING g_sql          #FUN-A50102            
      PREPARE p910_paza FROM g_sql
      DECLARE p910_baza CURSOR FOR p910_paza
 
      OPEN p910_baza
      FETCH p910_baza INTO l_aza17
 
      IF tm.cur_type = "1" THEN
         IF tm.cur_code <> l_aza17 THEN
#           CALL s_currm(tm.cur_code,l_nqb.nqb02,"S",l_azp03)        #FUN-980020 mark
            CALL s_currm(tm.cur_code,l_nqb.nqb02,"S",l_nqb.nqb01)    #FUN-980020
                 RETURNING l_rate
            LET l_nqb.nqb03 = l_nqb.nqb03 * l_rate
         END IF
      END IF
 
      IF tm.cur_type = "3" THEN
         IF g_nqa01 <> l_aza17 THEN
#           CALL s_currm(g_nqa01,l_nqb.nqb02,"S",l_azp03)           #FUN-980020 mark 
            CALL s_currm(g_nqa01,l_nqb.nqb02,"S",l_nqb.nqb01)       #FUN-980020 
                 RETURNING l_rate
            LET l_nqb.nqb03 = l_nqb.nqb03 * l_rate
         END IF
      END IF
 
      INSERT INTO buk_nqg VALUES(tmp.ldate,l_nqb.nqb01,"A","AAA",l_nqb.nqb03)
      IF STATUS THEN
         CALL cl_err("ins buk_nqg error",STATUS,0)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
         EXIT PROGRAM
      END IF
 
      IF tm.nqg02 = "ALL" THEN
         INSERT INTO buk_nqg VALUES(tmp.ldate,"ALL","A","AAA",l_nqb.nqb03)
         IF STATUS THEN
            CALL cl_err("ins all_buk_nqg error",STATUS,0)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
            EXIT PROGRAM
         END IF
      END IF
   END FOREACH
 
END FUNCTION
 
FUNCTION r900_buk_date(d)
   DEFINE d,d2   LIKE type_file.dat    #No.FUN-680107 DATE
   DEFINE x      LIKE type_file.chr8   #No.FUN-680107 VARCHAR(8)
   DEFINE i      LIKE type_file.num10  #No.FUN-680107 INTEGER
 
   CASE
      WHEN tm.buk_type = '3'
         LET i = weekday(d)
         IF i = 0 THEN
            LET i = 7
         END IF
         LET d2 = d - i + 1
      WHEN tm.buk_type = '4'
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
      WHEN tm.buk_type = '5'
         LET x = d USING 'yyyymmdd'
         LET x[7,8]='01'
         LET d2= MDY(x[5,6],x[7,8],x[1,4])
      OTHERWISE
         LET d2=d
   END CASE
 
   RETURN d2
 
END FUNCTION
#FUN-870144
