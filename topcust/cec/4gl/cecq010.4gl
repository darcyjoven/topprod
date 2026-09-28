# Prog. Version..: '5.30.06-13.03.29(00005)'     #
#
# Pattern name...: cecq010.4gl
# Descriptions...: 消耗性料号使用配比表q查询
# Date & Author..: 16/09/06 By guanyao

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE tm    RECORD                                # Print condition RECORD
         tc_shc03   LIKE tc_shc_file.tc_shc03,
         tc_shc08   LIKE tc_shc_file.tc_shc08
       END RECORD
DEFINE g_tc_shb DYNAMIC ARRAY OF RECORD
         tc_shb03   LIKE tc_shb_file.tc_shb03,
         tc_shb06   LIKE tc_shb_file.tc_shb06,
         tc_shb04   LIKE tc_shb_file.tc_shb04,
         tc_shb05   LIKE tc_shb_file.tc_shb05,
         ima02      LIKE ima_file.ima02,
         ima021     LIKE ima_file.ima021,
         tc_shb08   LIKE tc_shb_file.tc_shb08,
         ecd02      LIKE ecd_file.ecd02,
         shm08      LIKE shm_file.shm08,
         shm08_1    LIKE shm_file.shm08,
         ima01      LIKE ima_file.ima01,
         ima02_a    LIKE ima_file.ima02,
         ima021_a   LIKE ima_file.ima021,
         sfa06      LIKE sfa_file.sfa06,
         sfa06_1    LIKE sfa_file.sfa06,
         sfa06_2    LIKE sfa_file.sfa06
       END RECORD
DEFINE g_tc_shb_t     RECORD
         tc_shb03   LIKE tc_shb_file.tc_shb03,
         tc_shb06   LIKE tc_shb_file.tc_shb06,
         tc_shb04   LIKE tc_shb_file.tc_shb04,
         tc_shb05   LIKE tc_shb_file.tc_shb05,
         ima02      LIKE ima_file.ima02,
         ima021     LIKE ima_file.ima021,
         tc_shb08   LIKE tc_shb_file.tc_shb08,
         ecd02      LIKE ecd_file.ecd02,
         shm08      LIKE shm_file.shm08,
         shm08_1    LIKE shm_file.shm08,
         ima01      LIKE ima_file.ima01,
         ima02_a    LIKE ima_file.ima02,
         ima021_a   LIKE ima_file.ima021,
         sfa06      LIKE sfa_file.sfa06,
         sfa06_1    LIKE sfa_file.sfa06,
         sfa06_2    LIKE sfa_file.sfa06
       END RECORD
DEFINE g_tc_shb_1 DYNAMIC ARRAY OF RECORD
         tc_shb03_1   LIKE tc_shb_file.tc_shb03,
         tc_shb06_1   LIKE tc_shb_file.tc_shb06,
         tc_shb04_1   LIKE tc_shb_file.tc_shb04,
         tc_shb05_1   LIKE tc_shb_file.tc_shb05,
         ima02_1      LIKE ima_file.ima02,
         ima021_1     LIKE ima_file.ima021,
         tc_shb08_1   LIKE tc_shb_file.tc_shb08,
         sgm06        LIKE sgm_file.sgm06,
         eca02        LIKE eca_file.eca02,
         ecd02_1      LIKE ecd_file.ecd02,
         shm08_a      LIKE shm_file.shm08,
         shm08_b      LIKE shm_file.shm08,
         ima01_1      LIKE ima_file.ima01,
         ima02_b      LIKE ima_file.ima02,
         ima021_b     LIKE ima_file.ima021,
         img10        LIKE img_file.img10,
         img10_1      LIKE img_file.img10
         ,sfa12       LIKE sfa_file.sfa12   #add by guanyao160920
       END RECORD
DEFINE g_tc_shb_1_t   RECORD
         tc_shb03_1   LIKE tc_shb_file.tc_shb03,
         tc_shb06_1   LIKE tc_shb_file.tc_shb06,
         tc_shb04_1   LIKE tc_shb_file.tc_shb04,
         tc_shb05_1   LIKE tc_shb_file.tc_shb05,
         ima02_1      LIKE ima_file.ima02,
         ima021_1     LIKE ima_file.ima021,
         tc_shb08_1   LIKE tc_shb_file.tc_shb08,
         sgm06        LIKE sgm_file.sgm06,
         eca02        LIKE eca_file.eca02,
         ecd02_1      LIKE ecd_file.ecd02,
         shm08_a      LIKE shm_file.shm08,
         shm08_b      LIKE shm_file.shm08,
         ima01_1      LIKE ima_file.ima01,
         ima02_b      LIKE ima_file.ima02,
         ima021_b     LIKE ima_file.ima021,
         img10        LIKE img_file.img10,
         img10_1      LIKE img_file.img10
         ,sfa12       LIKE sfa_file.sfa12   #add by guanyao160920
       END RECORD
DEFINE f        ui.Form
DEFINE PAGE     om.DomNode
DEFINE w        ui.Window
DEFINE g_sql    STRING
DEFINE g_cnt    LIKE type_file.num5
DEFINE g_cnt1   LIKE type_file.num5
DEFINE g_cnt2   LIKE type_file.num5
DEFINE l_ac     LIKE type_file.num5
DEFINE g_rec_b  LIKE type_file.num5
DEFINE g_rec_b1 LIKE type_file.num5
DEFINE g_rec_b2 LIKE type_file.num5
DEFINE g_action_flag LIKE type_file.chr5 
DEFINE l_sta    LIKE type_file.chr5
DEFINE l_no     LIKE type_file.chr100
DEFINE g_row_count   LIKE type_file.num5
DEFINE g_curs_index   LIKE type_file.num5

MAIN   

   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CEC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127

   
   INITIALIZE tm.* TO NULL

   LET g_bgjob = ARG_VAL(1)
   LET g_action_flag='page1'
   #IF cl_null(g_bgjob) OR g_bgjob='N' THEN
      OPEN WINDOW q010_w AT 2,18 WITH FORM "cec/42f/cecq010"
           ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_init()
      #CALL q010_tm()
      #CALL q010()   
   #END IF 

   CALL q010_menu()
   CLOSE WINDOW q010_w              
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q010_menu()
    WHILE TRUE
      CALL q010_bp()
      
      CASE g_action_choice
         WHEN "page1"
            CALL q010_bp()
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q010_tm()
               LET g_action_choice = " "
            END IF
         WHEN "help"
            CALL cl_show_help()
            LET g_action_choice = " "
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask() 
            LET g_action_choice = " " 
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_shb),'','')
              LET g_action_choice = " " 
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q010_tm()
DEFINE lc_qbe_sn       LIKE gbm_file.gbm01  
DEFINE l_x             LIKE type_file.num5

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   CLEAR FORM   
   CALL g_tc_shb.clear()
   
 
   DIALOG ATTRIBUTE(UNBUFFERED)
      INPUT BY NAME tm.tc_shc03,tm.tc_shc08 ATTRIBUTES (WITHOUT DEFAULTS)
          BEFORE INPUT 
             CALL cl_qbe_display_condition(lc_qbe_sn)

          AFTER FIELD tc_shc03
             IF NOT cl_null(tm.tc_shc03) THEN 
                LET l_x = 0
                SELECT COUNT(*) INTO l_x FROM shm_file WHERE shm01 = tm.tc_shc03
                IF cl_null(l_x) OR l_x = 0 THEN 
                   MESSAGE "没有此LOT单号"
                   NEXT FIELD tc_shc03
                END IF 
             END IF
          AFTER FIELD tc_shc08
             IF NOT cl_null(tm.tc_shc08) THEN 
                LET l_x = 0
                SELECT COUNT(*) INTO l_x FROM ecd_file WHERE ecd01 = tm.tc_shc08
                IF cl_null(l_x) OR l_x = 0 THEN 
                   MESSAGE "没有此作业编号"
                   NEXT FIELD tc_shc08
                END IF 
                IF NOT cl_null(tm.tc_shc03) THEN 
                   LET l_x = 0
                   SELECT COUNT(*) INTO l_x FROM sgm_file WHERE sgm01 = tm.tc_shc03 AND sgm04 = tm.tc_shc08
                   IF cl_null(l_x) OR l_x = 0 THEN 
                      MESSAGE "此LOT单号没有此作业编号"
                      NEXT FIELD tc_shc08
                   END IF 
                END IF 
             END IF
      END INPUT
 
      ON ACTION locale
         CALL cl_show_fld_cont()
         LET g_action_choice = "locale"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP 
         CALL cl_show_help()
 
      ON ACTION controlg 
         CALL cl_cmdask()
 
      ON ACTION EXIT
         LET INT_FLAG = 1
         EXIT DIALOG

      ON ACTION ACCEPT
          LET INT_FLAG = 0
          ACCEPT DIALOG
            
      ON ACTION CANCEL
         LET INT_FLAG = 1
         EXIT DIALOG
 
      ON ACTION CONTROLP
         CASE 
         WHEN INFIELD(tc_shc03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_shm1"
               LET g_qryparam.default1 = tm.tc_shc03
               CALL cl_create_qry() RETURNING tm.tc_shc03
               DISPLAY BY NAME tm.tc_shc03
               NEXT FIELD tc_shc03
         WHEN INFIELD(tc_shc08)
               CALL q_ecd(FALSE,TRUE,'') RETURNING tm.tc_shc08
               DISPLAY BY NAME tm.tc_shc08
               NEXT FIELD tc_shc08
         END CASE 
         
      ON ACTION qbe_select
         CALL cl_qbe_select()
   END DIALOG
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF

   CALL q010()
   ERROR ""
END FUNCTION
 
FUNCTION q010()
   DEFINE l_sql     STRING 
   DEFINE l_oeb01   LIKE oeb_file.oeb01
   DEFINE l_oeb03   LIKE oeb_file.oeb03
   DEFINE l_oeb04   LIKE oeb_file.oeb04
   DEFINE l_oeb916  LIKE oeb_file.oeb916
   DEFINE l_oeb917  LIKE oeb_file.oeb917

   LET g_row_count = 0
   LET g_curs_index = 0
   
   CALL q010_b_fill() 
END FUNCTION


FUNCTION q010_bp()

   DISPLAY g_rec_b TO formonly.cn2

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
   DISPLAY ARRAY g_tc_shb TO s_tc_shb.* 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont() 
            
      AFTER DISPLAY
         CONTINUE DIALOG   #因為外層是DIALOG
   END DISPLAY 
   DISPLAY ARRAY g_tc_shb_1 TO s_tc_shb_1.* 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont() 
            
      AFTER DISPLAY
         CONTINUE DIALOG   #因為外層是DIALOG
   END DISPLAY 
   
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG  
         
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG  
         
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont() 
         EXIT DIALOG  
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about
         CALL cl_about()
         
      ON ACTION accept
         LET l_ac = ARR_CURR()
         LET g_action_flag = 'page2'
         EXIT DIALOG

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
   END DIALOG 
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION q010_b_fill()
DEFINE l_x            LIKE type_file.num20_6 
DEFINE l_sfa          RECORD LIKE sfa_file.*
DEFINE l_ta_ecd04     LIKE ecd_file.ta_ecd04
DEFINE l_sql          STRING 
DEFINE qty            LIKE sfb_file.sfb08
DEFINE l_sfb08        LIKE sfb_file.sfb08
DEFINE l_sgm03        LIKE sgm_file.sgm03
DEFINE l_gfe03        LIKE gfe_file.gfe03
DEFINE l_ima55        LIKE ima_file.ima55
DEFINE l_y            LIKE type_file.num20_6
DEFINE l_sfa06_2      LIKE sfa_file.sfa06
#str----add by guanyao160920
DEFINE l_fac           LIKE img_file.img34 
DEFINE l_i             LIKE type_file.num5
DEFINE l_ima25         LIKE ima_file.ima25
#end----add by guanyao160920

   #
   LET g_sql = "SELECT sgm01,sgm03,sgm02,sgm03_par,ima02,ima021,sgm04,ecd02,'' shm08,'' shm08_1,",
               "       '' ima01,'' ima02_a,'' ima021_a,'' sfa06,'' sfa06_1,'' sfa06_2",
               "       FROM shm_file,sgm_file LEFT JOIN ima_file ON ima01 = sgm03_par",
               "                              LEFT JOIN ecd_file ON ecd01 = sgm04",
               " WHERE shm01 = sgm01",
               "   AND sgm01 = '",tm.tc_shc03,"'"

   IF NOT cl_null(tm.tc_shc08) THEN 
      LET g_sql = g_sql CLIPPED," AND sgm04 = '",tm.tc_shc08,"'"
   END IF 

   LET g_sql = g_sql CLIPPED," ORDER BY sgm03"

   PREPARE q010_pb1 FROM g_sql
   DECLARE oeb_curs1 CURSOR FOR q010_pb1 
   
   CALL g_tc_shb.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH oeb_curs1 INTO g_tc_shb[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #是否包装
      LET l_ta_ecd04 = ''
      SELECT ta_ecd04 INTO l_ta_ecd04 FROM ecd_file WHERE ecd01 = g_tc_shb[g_cnt].tc_shb08
      #求出上一站
      LET l_sgm03 = ''
      SELECT MAX(sgm03) INTO l_sgm03 FROM sgm_file 
       WHERE sgm01 = g_tc_shb[g_cnt].tc_shb03
         AND sgm03 <g_tc_shb[g_cnt].tc_shb06
      IF cl_null(l_sgm03) THEN
         SELECT nvl(shm08,0) INTO g_tc_shb[g_cnt].shm08 FROM shm_file WHERE shm01 = g_tc_shb[g_cnt].tc_shb03
      ELSE 
         LET l_ta_ecd04 = ''
         #start ly180108 mark
         {
         SELECT DISTINCT ta_ecd04 INTO l_ta_ecd04 FROM ecd_file,tc_shb_file 
          WHERE tc_shb03=g_tc_shb[g_cnt].tc_shb03 
            AND tc_shb06=g_tc_shb[g_cnt].tc_shb06
            AND tc_shb08=ecd01
        }
         #end mark 
        SELECT DISTINCT ta_ecd04 INTO l_ta_ecd04 FROM ecd_file ,sgm_file
        WHERE sgm01=g_tc_shb[g_cnt].tc_shb03
            AND sgm03=g_tc_shb[g_cnt].tc_shb06
            AND sgm04=ecd01
    
            
         IF cl_null(l_ta_ecd04) OR l_ta_ecd04='N' THEN 
            SELECT nvl(SUM(tc_shc12),0) INTO g_tc_shb[g_cnt].shm08 FROM tc_shc_file 
             WHERE tc_shc03 = g_tc_shb[g_cnt].tc_shb03
               AND tc_shc06 = l_sgm03
               AND tc_shc01 = '2'
         ELSE
            SELECT nvl(SUM(tc_shb12),0) INTO g_tc_shb[g_cnt].shm08 FROM tc_shb_file 
             WHERE tc_shb03 = g_tc_shb[g_cnt].tc_shb03
               AND tc_shb06 = l_sgm03
               AND tc_shb01 = '2'
         END IF 
      END IF
      #str----add by guanyao160921
      LET l_ta_ecd04 = ''
      SELECT ta_ecd04 INTO l_ta_ecd04 FROM ecd_file WHERE ecd01 = g_tc_shb[g_cnt].tc_shb08
      #end----add by guanyao160921
      LET l_ta_ecd04 = 'Y' #add by guanyao160929
      IF l_ta_ecd04 = 'N' OR cl_null(l_ta_ecd04) THEN 
         SELECT nvl(SUM(tc_shc12),0) INTO g_tc_shb[g_cnt].shm08_1 FROM tc_shc_file 
          WHERE tc_shc03 = g_tc_shb[g_cnt].tc_shb03
            AND tc_shc08 = g_tc_shb[g_cnt].tc_shb08
            AND tc_shc01 = '1'
         SELECT nvl(SUM(tc_shc12),0) INTO g_tc_shb[g_cnt].sfa06_1 FROM tc_shc_file 
          WHERE tc_shc04 = g_tc_shb[g_cnt].tc_shb04
            AND tc_shc03 <> g_tc_shb[g_cnt].tc_shb03
            AND tc_shc08 = g_tc_shb[g_cnt].tc_shb08
            AND tc_shc01 = '1'
      ELSE 
          SELECT nvl(SUM(tc_shb12),0) INTO g_tc_shb[g_cnt].shm08_1 FROM tc_shb_file 
          WHERE tc_shb03 = g_tc_shb[g_cnt].tc_shb03
            AND tc_shb08 = g_tc_shb[g_cnt].tc_shb08
            AND tc_shb01 = '1'
          SELECT nvl(SUM(tc_shb12),0) INTO g_tc_shb[g_cnt].sfa06_1 FROM tc_shb_file 
          WHERE tc_shb03 != g_tc_shb[g_cnt].tc_shb03
            AND tc_shb04 = g_tc_shb[g_cnt].tc_shb04
            AND tc_shb08 = g_tc_shb[g_cnt].tc_shb08
            AND tc_shb01 = '1'
      END IF 
      IF cl_null(g_tc_shb[g_cnt].shm08_1) THEN 
         LET g_tc_shb[g_cnt].shm08_1 = 0
      END IF 
       IF cl_null(g_tc_shb[g_cnt].sfa06_1) THEN 
         LET g_tc_shb[g_cnt].sfa06_1 = 0
      END IF 
      LET g_tc_shb_t.*=g_tc_shb[g_cnt].*
      SELECT sfb08 INTO l_sfb08 FROM sfb_file WHERE sfb01 = g_tc_shb[g_cnt].tc_shb04 
      LET l_sql=					#消耗材料及代買料回收料不計
        "SELECT * FROM sfa_file",
        "  WHERE sfa01='",g_tc_shb[g_cnt].tc_shb04,"' AND sfa26 NOT IN ('S','U','Z')",
        "    AND sfa161>0 AND sfa11 NOT IN ('E','S','X') ",
        "    AND sfa08='",tm.tc_shc08,"'"    
      PREPARE s_minp_p FROM l_sql
      DECLARE s_minp_c CURSOR FOR s_minp_p
      FOREACH s_minp_c INTO l_sfa.*
         LET g_tc_shb[g_cnt].*=g_tc_shb_t.*
         IF l_sfa.sfa100 = 100 THEN
             CONTINUE FOREACH 
         END IF
         IF l_sfa.sfa26 MATCHES '[348]' THEN  
            SELECT SUM(sfa06/sfa28),SUM(sfa05/sfa28),SUM(sfa063/sfa28),SUM(sfa062/sfa28),SUM(sfa065/sfa28)  #FUN-C30166 
              INTO l_sfa.sfa06,l_sfa.sfa05,l_sfa.sfa063,l_sfa.sfa062,l_sfa.sfa065                           #FUN-C30166 
              FROM sfa_file  
              WHERE sfa01=l_sfa.sfa01
                AND sfa27=l_sfa.sfa03
                AND sfa08=l_sfa.sfa08
                AND sfa012=l_sfa.sfa012  #No.FUN-A60027
                AND sfa013=l_sfa.sfa013  #No.FUN-A60027
            IF l_sfa.sfa06 IS NULL THEN LET l_sfa.sfa06 = 0 END IF
         END IF
         LET g_tc_shb[g_cnt].ima01 = l_sfa.sfa03
         SELECT ima02,ima021 INTO g_tc_shb[g_cnt].ima02_a,g_tc_shb[g_cnt].ima021_a  FROM ima_file WHERE ima01 = l_sfa.sfa03
         LET g_tc_shb[g_cnt].sfa06 = l_sfa.sfa06
         LET qty=((l_sfa.sfa06+l_sfa.sfa065-l_sfa.sfa063+l_sfa.sfa062)/l_sfa.sfa05)*l_sfb08  
         IF cl_null(qty) THEN 
            LET qty = 0
         END IF 
         #LET g_tc_shb[g_cnt].sfa06_2 =g_tc_shb[g_cnt].shm08-g_tc_shb[g_cnt].shm08_1-(qty-g_tc_shb[g_cnt].sfa06_1)#mark by guanyao160930
         LET g_tc_shb[g_cnt].sfa06_2 =g_tc_shb[g_cnt].shm08-g_tc_shb[g_cnt].shm08_1-(qty-g_tc_shb[g_cnt].sfa06_1-g_tc_shb[g_cnt].shm08_1)
         #####此lot单上站扫出或者完工数量-本站一开工数量-（工单最小发料套数-非此工单的已发料量-此工单已开工数量）
        # IF  g_tc_shb[g_cnt].sfa06_2 <=0THEN 
        #    CONTINUE FOREACH 
        # END IF 
         LET g_tc_shb[g_cnt].sfa06_2 = g_tc_shb[g_cnt].sfa06_2*l_sfa.sfa161
         LET l_sfa06_2 = g_tc_shb[g_cnt].sfa06_2
         #ly 180108
         # SELECT ima55 INTO l_ima55 FROM sfb_file,ima_file WHERE sfb01=p_wono AND sfb05 = l_sfa.sfa03
         SELECT ima55 INTO l_ima55 FROM sfb_file,ima_file WHERE sfb01=l_sfa.sfa01 AND sfb05 = l_sfa.sfa03
         SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01 = l_ima55
         IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN LET l_gfe03 = 0 END IF
         LET g_tc_shb[g_cnt].sfa06_2 = s_trunc(g_tc_shb[g_cnt].sfa06_2,l_gfe03) 
         IF l_sfa06_2>g_tc_shb[g_cnt].sfa06_2 THEN 
            LET l_y = 0
            SELECT 1/power(10,l_gfe03) INTO l_y FROM dual 
            LET g_tc_shb[g_cnt].sfa06_2 = g_tc_shb[g_cnt].sfa06_2+l_y 
         END IF 
         LET g_cnt = g_cnt + 1
      END FOREACH
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
      END IF
   END FOREACH

   CALL g_tc_shb.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   SELECT COUNT(*) INTO l_x  FROM sfa_file,sgm_file 
    WHERE sfa01 = sgm02 
      AND sfa08= sgm04
      AND sfa11 = 'E' 
      AND sgm01 = tm.tc_shc03
      AND sgm04 = tm.tc_shc08 
   IF l_x >0 THEN 
      LET g_sql = "SELECT sgm01,sgm03,sgm02,sgm03_par,ima02,ima021,sgm04,ecd02,sgm06,eca02,shm08,'' shm08_1,",
                  "       '' ima01_1,'' ima02_b,'' ima021_b,'' img10,'' img10_1,'' sfa12",  #add sfa12 by guanyao160920
                  "       FROM shm_file,sgm_file LEFT JOIN ima_file ON ima01 = sgm03_par",
                  "                              LEFT JOIN ecd_file ON ecd01 = sgm04",
                  "                              LEFT JOIN eca_file ON eca01 = sgm06",
                  " WHERE shm01 = sgm01",
                  "   AND sgm01 = '",tm.tc_shc03,"'", 
                  "   AND sgm04 = '",tm.tc_shc08,"'" 
      PREPARE sel_rvbs_pre FROM g_sql
      DECLARE rvbs_curs CURSOR FOR sel_rvbs_pre
      CALL g_tc_shb_1.clear()
      LET g_cnt = 1
      LET g_rec_b1 = 0
      FOREACH rvbs_curs INTO g_tc_shb_1[g_cnt].*   #單身 ARRAY 填充
         IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
         SELECT COUNT(*) INTO l_x FROM tc_shb_file 
          WHERE tc_shb03 = g_tc_shb_1[g_cnt].tc_shb03_1  
            AND tc_shb06 = g_tc_shb_1[g_cnt].tc_shb06_1
         IF cl_null(l_x) OR l_x = 0 THEN 
            SELECT MAX(sgm03) INTO l_sgm03 FROM sgm_file 
             WHERE sgm01 = g_tc_shb[g_cnt].tc_shb03
               AND sgm03 <g_tc_shb[g_cnt].tc_shb06
            IF cl_null(l_sgm03) OR l_sgm03 = 0 THEN 
               SELECT nvl(shm08,0) INTO g_tc_shb_1[g_cnt].shm08_a FROM shm_file WHERE shm01 = g_tc_shb[g_cnt].tc_shb03
            ELSE 
               LET l_ta_ecd04 = ''
               SELECT DISTINCT ta_ecd04 INTO l_ta_ecd04 FROM ecd_file,tc_shb_file 
                WHERE tc_shb03=g_tc_shb_1[g_cnt].tc_shb03_1
                  AND tc_shb06=g_tc_shb_1[g_cnt].tc_shb06_1
                  AND tc_shb08=ecd01 
               IF cl_null(l_ta_ecd04) OR l_ta_ecd04 = 'N' THEN 
                  SELECT nvl(SUM(tc_shc12),0) INTO g_tc_shb_1[g_cnt].shm08_a FROM tc_shc_file
                   WHERE tc_shc03 = g_tc_shb_1[g_cnt].tc_shb03_1 
                     AND tc_shc06 = g_tc_shb_1[g_cnt].tc_shb06_1
                     AND tc_shb01 = '2'
               ELSE 
                  SELECT nvl(SUM(tc_shb12),0) INTO g_tc_shb_1[g_cnt].shm08_a FROM tc_shb_file
                   WHERE tc_shb03 = g_tc_shb_1[g_cnt].tc_shb03_1 
                     AND tc_shb06 = g_tc_shb_1[g_cnt].tc_shb06_1
                     AND tc_shb01 = '2'
               END IF 
            END IF
            LET  g_tc_shb_1[g_cnt].shm08_b = 0
         ELSE 
            SELECT nvl(SUM(tc_shb12),0) INTO g_tc_shb_1[g_cnt].shm08_a FROM tc_shb_file 
             WHERE tc_shb03 = g_tc_shb_1[g_cnt].tc_shb03_1 
               AND tc_shb06 = g_tc_shb_1[g_cnt].tc_shb06_1
               AND tc_shb01 = '1'
            SELECT nvl(SUM(tc_shb12+tc_shb121+tc_shb122),0) INTO g_tc_shb_1[g_cnt].shm08_b FROM tc_shb_file 
             WHERE tc_shb03 = g_tc_shb_1[g_cnt].tc_shb03_1 
               AND tc_shb06 = g_tc_shb_1[g_cnt].tc_shb06_1
               AND tc_shb01 = '2'
         END IF 
         IF g_tc_shb_1[g_cnt].shm08_a = g_tc_shb_1[g_cnt].shm08_b AND g_tc_shb_1[g_cnt].shm08_a >0 THEN 
            CONTINUE FOREACH 
         END IF 
         LET g_tc_shb_1[g_cnt].shm08_a = g_tc_shb_1[g_cnt].shm08_a-g_tc_shb_1[g_cnt].shm08_b
         LET g_tc_shb_1_t.*=g_tc_shb_1[g_cnt].*
            LET l_sql=					#消耗材料及代買料回收料不計
               "SELECT * FROM sfa_file",
               "  WHERE sfa01='",g_tc_shb_1[g_cnt].tc_shb04_1,"' AND sfa26 NOT IN ('U','Z')",
               "    AND sfa161>0 AND sfa11='E' ",              
               "    AND sfa08='",tm.tc_shc08,"'"    
            PREPARE s_minp_p1 FROM l_sql
            DECLARE s_minp_c1 CURSOR FOR s_minp_p1
            FOREACH s_minp_c1  INTO l_sfa.*
               LET g_tc_shb_1[g_cnt].*=g_tc_shb_1_t.*
               IF l_sfa.sfa100 = 100 THEN
                  CONTINUE FOREACH 
               END IF
               #str---add by guanyao161008
               IF l_sfa.sfa05 = l_sfa.sfa06 THEN 
                  CONTINUE FOREACH 
               END IF 
               #end---add by guanyao161008
               LET g_tc_shb_1[g_cnt].*=g_tc_shb_1[g_cnt].*
               LET g_tc_shb_1[g_cnt].ima01_1 = l_sfa.sfa03
               LET g_tc_shb_1[g_cnt].sfa12 = l_sfa.sfa12   #add by guanyao160920
               SELECT ima02,ima021,ima25 INTO g_tc_shb_1[g_cnt].ima02_b,g_tc_shb_1[g_cnt].ima021_b,l_ima25  FROM ima_file WHERE ima01 = l_sfa.sfa03
               SELECT nvl(SUM(img10),0) INTO g_tc_shb_1[g_cnt].img10 FROM img_file 
                WHERE img01 = l_sfa.sfa03 
                  AND img02 = 'XBC'
                  AND img03 = g_tc_shb_1[g_cnt].eca02#chg by donghy 160911 看着像eca02
                  AND img18 >= g_today   #add by guanyao160920
                  #AND img03 = g_tc_shb_1[g_cnt].sgm06
               #str-----add by guanyao160920
               CALL s_umfchk(l_sfa.sfa03,l_ima25,l_sfa.sfa12) 
                 RETURNING l_i,l_fac
               IF l_i = 1 THEN LET l_fac = 1 END IF
               LET g_tc_shb_1[g_cnt].img10 = g_tc_shb_1[g_cnt].img10*l_fac
               #end-----add by guanyao160920
               LET g_tc_shb_1[g_cnt].shm08_a=g_tc_shb_1[g_cnt].shm08_a*l_sfa.sfa161
               LET l_sfa06_2 = g_tc_shb_1[g_cnt].shm08_a
              # SELECT ima55 INTO l_ima55 FROM sfb_file,ima_file WHERE sfb01=p_wono AND sfb05 = l_sfa.sfa03
               #ly180118  
              SELECT ima55 INTO l_ima55 FROM sfb_file,ima_file WHERE sfb01=l_sfa.sfa01 AND sfb05 = l_sfa.sfa03
              SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01 = l_ima55
               IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN LET l_gfe03 = 0 END IF
               LET g_tc_shb_1[g_cnt].shm08_a = s_trunc(g_tc_shb_1[g_cnt].shm08_a,l_gfe03) 
               IF l_sfa06_2>g_tc_shb_1[g_cnt].shm08_a THEN 
                  LET l_y = 0
                  SELECT 1/power(10,l_gfe03) INTO l_y FROM dual 
                  LET g_tc_shb_1[g_cnt].shm08_a = g_tc_shb_1[g_cnt].shm08_a+l_y 
               END IF 
               LET g_tc_shb_1[g_cnt].img10_1 =g_tc_shb_1[g_cnt].shm08_a -g_tc_shb_1[g_cnt].img10
               IF g_tc_shb_1[g_cnt].img10_1 <=0 THEN
                  #CONTINUE FOREACH  #chg by donghy 库存足也显示出来，让用户看看
               END IF  
               LET g_cnt = g_cnt + 1
               IF g_cnt > g_max_rec THEN
                  CALL cl_err( '', 9035, 0 )
                  EXIT FOREACH
               END IF
            END FOREACH 
        
         END FOREACH
         CALL g_tc_shb_1.deleteElement(g_cnt)
         LET g_rec_b1 = g_cnt - 1
      END IF 
END FUNCTION