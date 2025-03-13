# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: anmq920.4gl
# Descriptions...: 集團間借還款狀況查詢
# Date & Author..: FUN-620051 06/03/13 By Mandy
# Modify.........: FUN-640090 06/04/12 By Nicola 畫面瀏覽方式變更
# Modify.........: NO.FUN-640186 06/05/25 BY yiting 單頭多一選項-->借出營運中心/還款營運中心.
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-940177 09/05/12 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0196 09/11/24 By Carrier 拨入时,也能查得到还息单
# Modify.........: No.FUN-A50102 10/07/12 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE g_plant_in    LIKE nnv_file.nnv20
DEFINE dbplant       LIKE nnv_file.nnv20   #NO.FUN-640186
DEFINE g_dbs_in      LIKE type_file.chr21  #No.FUN-680107 VARCHAR(21)
DEFINE g_nnv   DYNAMIC ARRAY OF RECORD
                 nnv01      LIKE nnv_file.nnv01,
                 nnv02      LIKE nnv_file.nnv02,
                 nnv05      LIKE nnv_file.nnv05,
                 azp02_out  LIKE azp_file.azp02,
                 nnv06      LIKE nnv_file.nnv06,
                 nma02_1    LIKE nma_file.nma02,
                 nnv21      LIKE nnv_file.nnv21,
                 nma02_2    LIKE nma_file.nma02,
                 nnv28      LIKE nnv_file.nnv28,
                 nnv23      LIKE nnv_file.nnv23,
                 nnv25      LIKE nnv_file.nnv25,
                 nnv26      LIKE nnv_file.nnv26,
                 nnv29      LIKE nnv_file.nnv29,
                 nnv30      LIKE nnv_file.nnv30,
                 nnv31      LIKE nnv_file.nnv31,
                 nnv32      LIKE nnv_file.nnv32,
                 nnv33      LIKE nnv_file.nnv33
               END RECORD,
       g_nnv_t RECORD
                 nnv01      LIKE nnv_file.nnv01,
                 nnv02      LIKE nnv_file.nnv02,
                 nnv05      LIKE nnv_file.nnv05,
                 azp02_out  LIKE azp_file.azp02,
                 nnv06      LIKE nnv_file.nnv06,
                 nma02_1    LIKE nma_file.nma02,
                 nnv21      LIKE nnv_file.nnv21,
                 nma02_2    LIKE nma_file.nma02,
                 nnv28      LIKE nnv_file.nnv28,
                 nnv23      LIKE nnv_file.nnv23,
                 nnv25      LIKE nnv_file.nnv25,
                 nnv26      LIKE nnv_file.nnv26,
                 nnv29      LIKE nnv_file.nnv29,
                 nnv30      LIKE nnv_file.nnv30,
                 nnv31      LIKE nnv_file.nnv31,
                 nnv32      LIKE nnv_file.nnv32,
                 nnv33      LIKE nnv_file.nnv33
               END RECORD,
       g_nnw   DYNAMIC ARRAY OF RECORD
                 nnw00      LIKE nnw_file.nnw00,
                 nnw02      LIKE nnw_file.nnw02,
                 nnw01      LIKE nnw_file.nnw01,
                 nnw06      LIKE nnw_file.nnw06,
                 nma02_3    LIKE nma_file.nma02,
                 nnw21      LIKE nnw_file.nnw21,
                 nma02_4    LIKE nma_file.nma02,
                 nnx05      LIKE nnx_file.nnx05,
                 amt_1      LIKE nnx_file.nnx09,
                 amt_2      LIKE nnx_file.nnx10,
                 nnx16      LIKE nnx_file.nnx16,
                 nnx17      LIKE nnx_file.nnx17
               END RECORD,
       g_nnw_t RECORD
                 nnw00      LIKE nnw_file.nnw00,
                 nnw02      LIKE nnw_file.nnw02,
                 nnw01      LIKE nnw_file.nnw01,
                 nnw06      LIKE nnw_file.nnw06,
                 nma02_3    LIKE nma_file.nma02,
                 nnw21      LIKE nnw_file.nnw21,
                 nma02_4    LIKE nma_file.nma02,
                 nnx05      LIKE nnx_file.nnx05,
                 amt_1      LIKE nnx_file.nnx09,
                 amt_2      LIKE nnx_file.nnx10,
                 nnx16      LIKE nnx_file.nnx16,
                 nnx17      LIKE nnx_file.nnx17
               END RECORD,
       g_wc2,g_sql    STRING,        #No.FUN-680107
       g_rec_b        LIKE type_file.num5,          #No.FUN-680107 SMALLINT
       g_rec_b1       LIKE type_file.num5,          #No.FUN-680107 SMALLINT
       l_ac1          LIKE type_file.num5,          #No.FUN-680107 SMALLINT
       l_ac1_t        LIKE type_file.num5,          #No.FUN-680107 SMALLINT
       l_ac           LIKE type_file.num5           #No.FUN-680107 SMALLINT
DEFINE p_row,p_col    LIKE type_file.num5           #No.FUN-680107 SMALLINT
DEFINE g_cnt          LIKE type_file.num10          #No.FUN-680107 INTEGER
DEFINE g_forupd_sql   STRING        
DEFINE g_before_input_done   STRING 
DEFINE li_result      LIKE type_file.num5           #No.FUN-680107 SMALLINT
DEFINE g_msg          LIKE type_file.chr1000        #No.FUN-680107 VARCHAR(72)
DEFINE g_into_sw      LIKE type_file.chr1           #No.FUN-680107 VARCHAR(1)
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8          #No.FUN-6A0082
 
   OPTIONS                                          #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                  #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0082
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW q920_w AT p_row,p_col WITH FORM "anm/42f/anmq920"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL g_nnv.clear()
   CALL g_nnw.clear()
   LET g_rec_b1 = 1
   LET g_into_sw = '1'
   CALL q920_menu()
 
   CLOSE WINDOW q920_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0082
 
END MAIN
 
FUNCTION q920_menu()
 
   WHILE TRUE
      IF g_into_sw = '1' THEN
          CALL q920_bp1("G")
      ELSE
          CALL q920_bp2("G")
      END IF
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q920_q()
            END IF
         WHEN "qry_anmt920"
            IF cl_chk_act_auth() THEN
               LET g_msg="anmt920 '",g_nnv_t.nnv01,"'"
               CALL cl_cmdrun_wait(g_msg CLIPPED)
            END IF
         WHEN "qry_anmt930"
            IF cl_chk_act_auth() THEN
               IF g_nnw_t.nnw00 = '1' THEN
                   LET g_msg="anmt930 '",g_nnw_t.nnw01,"'"
               ELSE
                   LET g_msg="anmt940 '",g_nnw_t.nnw01,"'"
               END IF
               CALL cl_cmdrun_wait(g_msg CLIPPED)
            END IF
        ##-----No.FUN-640090 Mark-----
        #WHEN "into_b1"
        #   IF cl_chk_act_auth() THEN
        #       LET g_into_sw = '1'
        #   END IF
        #WHEN "into_b2"
        #   IF cl_chk_act_auth() THEN
        #       LET g_into_sw = '2'
        #   END IF
        ##-----No.FUN-640090 Mark END-----
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q920_q()
 
   CALL q920_b_askkey()
 
END FUNCTION
 
FUNCTION q920_b_askkey()
   DEFINE l_azp02_in      LIKE azp_file.azp02
 
   CLEAR FORM
   CALL g_nnv.clear()
   CALL g_nnw.clear()
   LET g_plant_in = g_plant
   LET dbplant = '1'       #NO.FUN-640186
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   #INPUT g_plant_in WITHOUT DEFAULTS FROM FORMONLY.plant
   INPUT g_plant_in,dbplant WITHOUT DEFAULTS FROM FORMONLY.plant,FORMONLY.dbplant  #NO.FUN-640186
        AFTER FIELD plant #撥入營運中心
            IF NOT cl_null(g_plant_in) THEN
                CALL q920_plant(g_plant_in) RETURNING l_azp02_in,g_dbs_in
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_plant_in,g_errno,1)
                    NEXT FIELD plant
                END IF
                DISPLAY l_azp02_in TO FORMONLY.azp02_in       
            END IF
#NO.FUN-640186 start---
        ON CHANGE dbplant
           IF dbplant = '1' THEN
               CALL cl_getmsg('sub-109',g_lang) RETURNING g_msg
               CALL cl_set_comp_att_text("nnv05",g_msg CLIPPED)
               CALL cl_getmsg('sub-161',g_lang) RETURNING g_msg
               CALL cl_set_comp_att_text("azp02_out",g_msg CLIPPED)
           ELSE
               CALL cl_getmsg('sub-116',g_lang) RETURNING g_msg
               CALL cl_set_comp_att_text("nnv05",g_msg CLIPPED)
               CALL cl_getmsg('sub-162',g_lang) RETURNING g_msg
               CALL cl_set_comp_att_text("azp02_out",g_msg CLIPPED)
           END IF
#NO.FUN-640186 end---  
        
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(plant) #撥入營運中心
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  LET g_qryparam.default1 = g_plant_in
                  CALL cl_create_qry() RETURNING g_plant_in
                  DISPLAY g_plant_in TO FORMONLY.plant
                  NEXT FIELD plant
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
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   CALL q920_b_fill1()
 
   LET l_ac1 = 1
   LET g_nnv_t.* = g_nnv[l_ac1].*
   CALL q920_b_fill2()
 
END FUNCTION
 
FUNCTION q920_b_fill1()
   DEFINE l_dbs_out  LIKE type_file.chr21         #No.FUN-680107 VARCHAR(21)
 
   LET g_sql = "SELECT nnv01,nnv02,nnv05,'',nnv06,'',nnv21,'',nnv28,nnv23,nnv25,nnv26,nnv29,nnv30,nnv31,nnv32,nnv33",
               "  FROM nnv_file"
#NO.FUN-640186 start--
#               " WHERE nnv20 = '",g_plant_in,"'",
#               " ORDER BY nnv02,nnv01"
   IF dbplant = '1' THEN   #借出營運中心
       LET g_sql = g_sql CLIPPED," WHERE nnv05 = '",g_plant_in,"'",
                                 " ORDER BY nnv02,nnv01"
   ELSE                    #還款營運中心
       LET g_sql = g_sql CLIPPED," WHERE nnv20 = '",g_plant_in,"'",
                                 " ORDER BY nnv02,nnv01"
   END IF    
#NO.FUN-640186 end----
     
   PREPARE q920_pb1 FROM g_sql
   DECLARE nnv_curs CURSOR FOR q920_pb1
   CALL g_nnv.clear()
   CALL g_nnw.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH nnv_curs INTO g_nnv[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)
         EXIT FOREACH
      END IF
      CALL q920_plant(g_nnv[g_cnt].nnv05) 
           RETURNING g_nnv[g_cnt].azp02_out,l_dbs_out
      #CALL q920_nma01(l_dbs_out,g_nnv[g_cnt].nnv06)
      CALL q920_nma01(g_nnv[g_cnt].nnv05,g_nnv[g_cnt].nnv06)   #FUN-A50102
           RETURNING g_nnv[g_cnt].nma02_1
      #CALL q920_nma01(g_dbs_in ,g_nnv[g_cnt].nnv21) 
      CALL q920_nma01(g_plant_in ,g_nnv[g_cnt].nnv21)   #FUN-A50102
           RETURNING g_nnv[g_cnt].nma02_2
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
 
   END FOREACH
 
   CALL g_nnv.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b1 = g_cnt - 1
   DISPLAY g_rec_b1 TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION q920_b_fill2()
   DEFINE l_nnw20      LIKE nnw_file.nnw05
   DEFINE l_dbs_out    LIKE type_file.chr21         #No.FUN-680107 VARCHAR(21)
   DEFINE l_azp02_out  LIKE azp_file.azp02
 
   #No.TQC-9B0196  --Begin
   #LET g_sql = "SELECT nnw00,nnw02,nnw01,nnw06,'',nnw21,'',nnx05,nnw10,nnw11,nnx16,nnx17,nnw20 ",
   #            "  FROM nnw_file,nnx_file",
   #            " WHERE nnw01 = nnx01 ",
   #            "   AND nnw05 = '",g_plant_in,"'",
   #            "   AND nnx03 = '",g_nnv_t.nnv01,"'",
   #            " ORDER BY nnw02"
   LET g_sql = "SELECT nnw00,nnw02,nnw01,nnw06,'',nnw21,'',nnx05,nnw10,nnw11,nnx16,nnx17,nnw20 ",
               "  FROM nnw_file,nnx_file",
               " WHERE nnw01 = nnx01 ",
               "   AND nnx03 = '",g_nnv_t.nnv01,"'"

   IF dbplant = '1' THEN
      LET g_sql = g_sql CLIPPED,
               "   AND nnw20 = '",g_plant_in,"'"
   ELSE
      LET g_sql = g_sql CLIPPED,
               "   AND nnw05 = '",g_plant_in,"'"
   END IF
   LET g_sql = g_sql CLIPPED,
               " ORDER BY nnw02"
   #No.TQC-9B0196  --End  
   DISPLAY g_sql
 
   PREPARE q920_pb FROM g_sql
   DECLARE nnw_curs CURSOR FOR q920_pb
  
   CALL g_nnw.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH nnw_curs INTO g_nnw[g_cnt].*,l_nnw20
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)
         EXIT FOREACH
      END IF
 
      #CALL q920_nma01(g_dbs_in,g_nnw[g_cnt].nnw06)
      CALL q920_nma01(g_plant_in,g_nnw[g_cnt].nnw06)   #FUN-A50102
           RETURNING g_nnw[g_cnt].nma02_3
      CALL q920_plant(l_nnw20) 
           RETURNING l_azp02_out,l_dbs_out
      #CALL q920_nma01(l_dbs_out ,g_nnw[g_cnt].nnw21)
      CALL q920_nma01(l_nnw20 ,g_nnw[g_cnt].nnw21)   #FUN-A50102
           RETURNING g_nnw[g_cnt].nma02_4
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
 
   END FOREACH
 
   CALL g_nnw.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn3
   LET g_cnt = 0
 
END FUNCTION
 
#-----No.FUN-640090-----
FUNCTION q920_bp2(p_ud)
   DEFINE p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "distributed_detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
 
   DISPLAY ARRAY g_nnw TO s_nnw.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
     #BEFORE DISPLAY
     #   IF g_into_sw='1' THEN
     #       EXIT DISPLAY
     #   END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF l_ac = 0 THEN
            LET l_ac = 1
         END IF
         CALL cl_show_fld_cont()
         LET g_nnw_t.* = g_nnw[l_ac].*
 
#No.FUN-6B0030------Begin--------------                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
      ON ACTION query
         LET g_into_sw = "1"     #No.MOD-640057
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION head
         LEt g_into_sw = "1"
         LET g_action_choice="head"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
     #ON ACTION into_b1
     #   LET g_action_choice="into_b1"
     #   LET g_into_sw = '1'
     #   EXIT DISPLAY
 
      ON ACTION qry_anmt930
         LET g_action_choice="qry_anmt930"
         EXIT DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help    
         CALL cl_show_help()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION q920_bp3()
 
   DISPLAY ARRAY g_nnw TO s_nnw.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
   END DISPLAY
 
END FUNCTION
#-----No.FUN-640090 END-----
 
FUNCTION q920_bp1(p_ud)
   DEFINE p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "distributed_detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_nnv TO s_nnv.* ATTRIBUTE(COUNT=g_rec_b1,KEEP CURRENT ROW)   #No.FUN-640090
 
      #-----No.FUN-640090-----
      BEFORE DISPLAY
         IF l_ac1 <> 0 THEN
            CALL fgl_set_arr_curr(l_ac1)
         END IF
      #-----No.FUN-640090 END-----
 
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         IF l_ac1 = 0 THEN
            LET l_ac1 = 1
         END IF
         CALL cl_show_fld_cont()
         LET l_ac1_t = l_ac1
         LET g_nnv_t.* = g_nnv[l_ac1].*
         CALL q920_b_fill2()
         CALL q920_bp3()     #No.FUN-640090
 
#No.FUN-6B0030------Begin--------------                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
      ON ACTION query
         LET g_into_sw = "1"     #No.FUN-640090
         LET g_action_choice="query"
         EXIT DISPLAY
 
      #-----No.FUN-640090-----
      ON ACTION view
         LET g_into_sw = "2"
         LET g_action_choice="veiw"
         EXIT DISPLAY
      #-----No.FUN-640090 END-----
 
      ON ACTION qry_anmt920
         LET g_action_choice="qry_anmt920"
        #LET l_ac = 1
         EXIT DISPLAY
 
     #ON ACTION into_b2   #No.FUN-640090 Mark
     #   LET g_action_choice="into_b2"
     #   LET g_into_sw = '2'
     #  #LET l_ac = 1
     #   EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION q920_plant(p_plant)
    DEFINE p_plant LIKE nnv_file.nnv05,
           l_azp01 LIKE azp_file.azp01,
           l_azp02 LIKE azp_file.azp02,
           l_azp03 LIKE azp_file.azp03,
           l_dbs   LIKE type_file.chr21         #No.FUN-680107 VARCHAR(21)
 
    LET g_errno = ' '
 	SELECT azp01,azp02,azp03 INTO l_azp01,l_azp02,l_azp03  FROM azp_file
         WHERE azp01 = p_plant
 
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg9142'
                            LET l_azp02 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
   #LET l_dbs = s_dbstring(l_azp03 CLIPPED) #TQC-940177  
    LET l_dbs = s_dbstring(l_azp03 CLIPPED) #TQC-940177 
    RETURN l_azp02,l_dbs
END FUNCTION
 
#FUNCTION q920_nma01(p_dbs,p_nma01)  #銀行代號
FUNCTION q920_nma01(l_plant,p_nma01)   #FUN-A50102
   DEFINE  p_nma01 LIKE nma_file.nma01,
           #p_dbs   LIKE type_file.chr21,      #No.FUN-680107 VARCHAR(21)
           l_plant LIKE type_file.chr21,       #FUN-A50102
           l_sql   LIKE type_file.chr1000,    #No.FUN-680107 VARCHAR(500)
           l_nma02 LIKE nma_file.nma02,
           l_nma05 LIKE nma_file.nma05,
           l_nma10 LIKE nma_file.nma10,
           l_nma28 LIKE nma_file.nma28,
           l_nmaacti LIKE nma_file.nmaacti
 
    LET g_errno = ' '
    LET l_sql=
              #"SELECT nma02 FROM ",p_dbs CLIPPED,"nma_file",
              "SELECT nma02 FROM ",cl_get_target_table(l_plant,'nma_file'), #FUN-A50102
              " WHERE nma01 = '",p_nma01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
    PREPARE nma_pre FROM l_sql
    DECLARE nma_cur CURSOR FOR nma_pre
    OPEN nma_cur
    FETCH nma_cur INTO l_nma02
    CASE WHEN SQLCA.SQLCODE = 100
                            LET g_errno = 'anm-013'
                            LET l_nma02 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    RETURN l_nma02
END FUNCTION
