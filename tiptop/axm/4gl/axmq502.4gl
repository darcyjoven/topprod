# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmq502.4gl
# Descriptions...: 訂單分配查詢作業
# Date & Author..: No.FUN-630006 06/03/13 By Nicola
# Modify.........: No.FUN-640025 06/04/08 By Nicola 取消欄位oaz19的判斷
# Modify.........: No.MOD-640057 06/04/08 By Nicola 新增單身切換的功能
# Modify.........: No.FUN-680137 06/09/04 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-710033 07/03/29 By Mandy 多單位畫面標準寫法調整
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_oea   DYNAMIC ARRAY OF RECORD
                  oea03     LIKE oea_file.oea03,
                  occ02     LIKE occ_file.occ02,
                  oea01     LIKE oea_file.oea01,
                  oea02     LIKE oea_file.oea02,
                  oeb03     LIKE oeb_file.oeb03,
                  oeb04     LIKE oeb_file.oeb04,
                  oeb06     LIKE oeb_file.oeb06,
                  oeb913    LIKE oeb_file.oeb913,
                  oeb915    LIKE oeb_file.oeb915,
                  oeb910    LIKE oeb_file.oeb910,
                  oeb912    LIKE oeb_file.oeb912,
                  oeb12     LIKE oeb_file.oeb12,
                  oeb13     LIKE oeb_file.oeb13,
                  oeb15     LIKE oeb_file.oeb15,
                  oeb920    LIKE oeb_file.oeb920
               END RECORD,
       g_oea_t RECORD
                  oea03     LIKE oea_file.oea03,
                  occ02     LIKE occ_file.occ02,
                  oea01     LIKE oea_file.oea01,
                  oea02     LIKE oea_file.oea02,
                  oeb03     LIKE oeb_file.oeb03,
                  oeb04     LIKE oeb_file.oeb04,
                  oeb06     LIKE oeb_file.oeb06,
                  oeb913    LIKE oeb_file.oeb913,
                  oeb915    LIKE oeb_file.oeb915,
                  oeb910    LIKE oeb_file.oeb910,
                  oeb912    LIKE oeb_file.oeb912,
                  oeb12     LIKE oeb_file.oeb12,
                  oeb13     LIKE oeb_file.oeb13,
                  oeb15     LIKE oeb_file.oeb15,
                  oeb920    LIKE oeb_file.oeb920
               END RECORD,
       g_oee   DYNAMIC ARRAY OF RECORD
                  oee03     LIKE oee_file.oee03,
                  oee04     LIKE oee_file.oee04,
                  azp02     LIKE azp_file.azp02,
                  oee05     LIKE oee_file.oee05,
                  oee071    LIKE oee_file.oee071,
                  oee072    LIKE oee_file.oee072,
                  oee073    LIKE oee_file.oee073,
                  oee061    LIKE oee_file.oee061,
                  oee062    LIKE oee_file.oee062,
                  oee063    LIKE oee_file.oee063,
                  oee081    LIKE oee_file.oee081,
                  oee082    LIKE oee_file.oee082,
                  oee083    LIKE oee_file.oee083,
                  oee09     LIKE oee_file.oee09,
                  oee10     LIKE oee_file.oee10,
                  oee11     LIKE oee_file.oee11 
               END RECORD,
       g_oee_t RECORD
                  oee03     LIKE oee_file.oee03,
                  oee04     LIKE oee_file.oee04,
                  azp02     LIKE azp_file.azp02,
                  oee05     LIKE oee_file.oee05,
                  oee071    LIKE oee_file.oee071,
                  oee072    LIKE oee_file.oee072,
                  oee073    LIKE oee_file.oee073,
                  oee061    LIKE oee_file.oee061,
                  oee062    LIKE oee_file.oee062,
                  oee063    LIKE oee_file.oee063,
                  oee081    LIKE oee_file.oee081,
                  oee082    LIKE oee_file.oee082,
                  oee083    LIKE oee_file.oee083,
                  oee09     LIKE oee_file.oee09,
                  oee10     LIKE oee_file.oee10,
                  oee11     LIKE oee_file.oee11 
               END RECORD,
       g_wc2,g_sql    STRING,
       g_rec_b        LIKE type_file.num5,         #No.FUN-680137 SMALLINT
       g_rec_b1       LIKE type_file.num5,         #No.FUN-680137 SMALLINT
       l_ac1          LIKE type_file.num5,         #No.FUN-680137 SMALLINT
       l_ac1_t        LIKE type_file.num5,         #No.FUN-680137 SMALLINT
       l_ac           LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE g_cnt          LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE g_cha          LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
DEFINE g_msg          LIKE type_file.chr1000       #No.TQC-710033 add
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8       #No.FUN-6A0094
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
  #-----No.FUN-640025 Mark-----
  #IF g_oaz.oaz19 = "N" THEN
  #   EXIT PROGRAM
  #END IF
  #-----No.FUN-640025 Mark END-----
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0094
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW q502_w AT p_row,p_col WITH FORM "axm/42f/axmq502"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
  #TQC-710033 mark 將此段移至q502_def_form()內
  #IF g_sma.sma115 = "N" THEN
  #   CALL cl_set_comp_visible("oeb910,oeb912",FALSE)
  #   CALL cl_set_comp_visible("oeb913,oeb915",FALSE)
  #   CALL cl_set_comp_visible("oee061,oee062,oee063",FALSE)
  #   CALL cl_set_comp_visible("oee071,oee072,oee073",FALSE)
  #   CALL cl_set_comp_visible("oee081,oee082",FALSE)
  #   CALL cl_set_comp_entry("oee063,oee073",FALSE)
  #ELSE
  #   CALL cl_set_comp_entry("oee083",FALSE)
  #END IF
 
   LET g_cha = "1"
   CALL q502_def_form()   #TQC-710033 add
 
   CALL q502_menu()
 
   CLOSE WINDOW q502_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0094
 
END MAIN
 
FUNCTION q502_menu()
 
   WHILE TRUE
      #-----No.MOD-640057-----
      IF g_cha = "1" THEN
         CALL q502_bp("G")
      ELSE
         CALL q502_bp1("G")
      END IF
      #-----No.MOD-640057 END-----
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q502_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q502_q()
 
   CLEAR FORM
   CALL g_oea.clear()
 
   CONSTRUCT g_wc2 ON oea03,oea01,oea02,oeb03,oeb04,oeb06,oeb15
                 FROM s_oea[1].oea03,s_oea[1].oea01,s_oea[1].oea02,
                      s_oea[1].oeb03,s_oea[1].oeb04,s_oea[1].oeb06,
                      s_oea[1].oeb15
 
      #No.FUN-580031 --start--
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(oea03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_occ"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea03
                 NEXT FIELD oea03
            WHEN INFIELD(oea01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_oea11"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea01
                 NEXT FIELD oea01
            WHEN INFIELD(oeb04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_ima"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oeb04
                 NEXT FIELD oeb04
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
 
      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      #No.FUN-580031 ---end---
 
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   CALL q502_b1_fill(g_wc2)
 
   LET l_ac1 = 1
   LET g_oea_t.* = g_oea[l_ac1].*
 
   CALL q502_b_fill()
 
END FUNCTION
 
FUNCTION q502_b1_fill(p_wc2)
   DEFINE p_wc2    STRING
 
   LET g_sql = "SELECT oea03,'',oea01,oea02,oeb03,oeb04,oeb06,",
               "       oeb913,oeb915,oeb910,oeb912,oeb12,oeb13,oeb15,oeb920", 
               "  FROM oea_file,oeb_file",
               " WHERE ",p_wc2 CLIPPED,
               "   AND oea01 = oeb01",
               "   AND oea00 = '1'",
               "   AND oea37 = 'Y'",
               "   AND oeaconf = 'Y'",
               " ORDER BY oea03,oea01"
 
   PREPARE q502_pb1 FROM g_sql
   DECLARE oea_curs CURSOR FOR q502_pb1
  
   CALL g_oea.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH oea_curs INTO g_oea[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)
         EXIT FOREACH
      END IF
 
      SELECT occ02 INTO g_oea[g_cnt].occ02
        FROM occ_file
       WHERE occ01 = g_oea[g_cnt].oea03
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
 
   END FOREACH
 
   CALL g_oea.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b1 = g_cnt - 1
   DISPLAY g_rec_b1 TO FORMONLY.cn3
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION q502_b_fill()
 
   LET g_sql = "SELECT oee03,oee04,'',oee05,oee071,oee072,oee073,",
               "       oee061,oee062,oee063,oee081,oee082,oee083,",
               "       oee09,oee10,oee11",
               "  FROM oee_file",
               " WHERE oee01 = '",g_oea_t.oea01 CLIPPED,"'",
               "   AND oee02 = ",g_oea_t.oeb03, 
               " ORDER BY oee03"
   DISPLAY g_sql
 
   PREPARE q502_pb FROM g_sql
   DECLARE oee_curs CURSOR FOR q502_pb
  
   CALL g_oee.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH oee_curs INTO g_oee[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)
         EXIT FOREACH
      END IF
 
      SELECT azp02 INTO g_oee[g_cnt].azp02 FROM azp_file
       WHERE azp01 = g_oee[g_cnt].oee04
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
 
   END FOREACH
 
   CALL g_oee.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION q502_bp2()
 
   DISPLAY ARRAY g_oee TO s_oee.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
FUNCTION q502_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "distributed_detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_oea TO s_oea.* ATTRIBUTE(COUNT=g_rec_b1,KEEP CURRENT ROW)
 
      BEFORE DISPLAY
         IF l_ac1 <> 0 THEN
            CALL fgl_set_arr_curr(l_ac1)
         END IF
 
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         IF l_ac1 = 0 THEN
            LET l_ac1 = 1
         END IF
         CALL cl_show_fld_cont()
         LET l_ac1_t = l_ac1
         LET g_oea_t.* = g_oea[l_ac1].*
         CALL q502_b_fill()
         CALL q502_bp2()
 
      ON ACTION query
         LET g_cha = "1"     #No.MOD-640057
         LET g_action_choice="query"
         EXIT DISPLAY
 
      #-----No.MOD-640057-----
      ON ACTION view
         LET g_cha = "2"
         LET g_action_choice="veiw"
         EXIT DISPLAY
      #-----No.MOD-640057 END-----
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CALL q502_def_form()   #TQC-710033 add
 
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
 
#-----No.MOD-640057-----
FUNCTION q502_bp1(p_ud)
   DEFINE p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "distributed_detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_oee TO s_oee.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION query
         LET g_cha = "1"     #No.MOD-640057
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION head
         LEt g_cha = "1"
         LET g_action_choice="head"
         EXIT DISPLAY
 
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
#-----No.MOD-640057 END-----
 
#-----TQC-710033---------add----str---
FUNCTION q502_def_form()   
    IF g_sma.sma115 = "N" THEN
       CALL cl_set_comp_visible("oeb910,oeb912",FALSE)
       CALL cl_set_comp_visible("oeb913,oeb915",FALSE)
       CALL cl_set_comp_visible("oee061,oee062,oee063",FALSE)
       CALL cl_set_comp_visible("oee071,oee072,oee073",FALSE)
       CALL cl_set_comp_visible("oee081,oee082",FALSE)
       CALL cl_set_comp_entry("oee063,oee073",FALSE)
    ELSE
       CALL cl_set_comp_entry("oee083",FALSE)
       CALL cl_set_comp_visible("oee062,oee072,oee082",FALSE) #TQC-710033 add 換算率不需顯示
    END IF
    #使用多單位的單位管制方式-母子單位
    IF g_sma.sma122 ='1' THEN 
       #--單頭
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg #母單位
       CALL cl_set_comp_att_text("oeb913",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg #母單位數量
       CALL cl_set_comp_att_text("oeb915",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg #子單位
       CALL cl_set_comp_att_text("oeb910",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg #子單位數量
       CALL cl_set_comp_att_text("oeb912",g_msg CLIPPED)
       #--end
 
       #--單身
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg #母單位
       CALL cl_set_comp_att_text("oee071",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg #母單位數量
       CALL cl_set_comp_att_text("oee073",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg #子單位
       CALL cl_set_comp_att_text("oee061",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg #子單位數量
       CALL cl_set_comp_att_text("oee063",g_msg CLIPPED)
       #--end
 
    END IF
 
    #使用多單位的單位管制方式-參考單位
    IF g_sma.sma122 ='2' THEN 
       #--單頭
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg #參考單位
       CALL cl_set_comp_att_text("oeb913",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg #參考單位數量
       CALL cl_set_comp_att_text("oeb915",g_msg CLIPPED)
       CALL cl_getmsg('asm-324',g_lang) RETURNING g_msg #銷售單位
       CALL cl_set_comp_att_text("oeb910",g_msg CLIPPED)
       CALL cl_getmsg('asm-325',g_lang) RETURNING g_msg #銷售數量
       CALL cl_set_comp_att_text("oeb912",g_msg CLIPPED)
       #--end
 
       #--單身
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg #參考單位
       CALL cl_set_comp_att_text("oee071",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg #參考單位數量
       CALL cl_set_comp_att_text("oee073",g_msg CLIPPED)
       CALL cl_getmsg('asm-328',g_lang) RETURNING g_msg #異動單位
       CALL cl_set_comp_att_text("oee061",g_msg CLIPPED)
       CALL cl_getmsg('asm-329',g_lang) RETURNING g_msg #異動數量
       CALL cl_set_comp_att_text("oee063",g_msg CLIPPED)
       #--end
    END IF
END FUNCTION
#-----TQC-710033---------add----end---
 
 
 
