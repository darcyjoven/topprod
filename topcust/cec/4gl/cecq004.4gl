# Prog. Version..: '5.30.06-13.03.29(00005)'     #
#
# Pattern name...: cecq004.4gl
# Descriptions...: 配方成本查询
# Date & Author..: 16/08/02 by jixf 

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE g_shc1 DYNAMIC ARRAY OF RECORD
       tc_sfc02     LIKE tc_sfc_file.tc_sfc02,
       ecd02        LIKE ecd_file.ecd02,
       tc_shc14_1   LIKE tc_shc_file.tc_shc14,
       tc_shc05     LIKE tc_shc_file.tc_shc05,
       ima02        LIKE ima_file.ima02,
       ima021       LIKE ima_file.ima021,
       tc_shc12     LIKE tc_shc_file.tc_shc12,
       tc_shb12     LIKE tc_shb_file.tc_shb12,
       tc_shb12_1   LIKE tc_shb_file.tc_shb12,
       tc_shc12_1   LIKE tc_shc_file.tc_shc12,
       tc_shc13     LIKE tc_shc_file.tc_shc13,
       ecg02        LIKE ecg_file.ecg02,
       tc_shb122    LIKE tc_shb_file.tc_shb122,
       tc_shb121    LIKE tc_shb_file.tc_shb121,
       tc_num       LIKE tc_shb_file.tc_shb121
       END RECORD,
       
       g_shc2  DYNAMIC ARRAY OF RECORD
       tc_sfc01     LIKE tc_sfc_file.tc_sfc01,
       tc_sfcud01   LIKE tc_sfc_file.tc_sfcud01,   #add by guanyao160831
       tc_shc14_2   LIKE tc_shc_file.tc_shc14,
       tc_shc05     LIKE tc_shc_file.tc_shc05,
       ima02        LIKE ima_file.ima02,
       ima021       LIKE ima_file.ima021,
       tc_shc12     LIKE tc_shc_file.tc_shc12,
       tc_shb12     LIKE tc_shb_file.tc_shb12,
       tc_shb12_1   LIKE tc_shb_file.tc_shb12,
       tc_shc12_1   LIKE tc_shc_file.tc_shc12,
       tc_shc13     LIKE tc_shc_file.tc_shc13,
       ecg02        LIKE ecg_file.ecg02,
       tc_shb122    LIKE tc_shb_file.tc_shb122,
       tc_shb121    LIKE tc_shb_file.tc_shb121,
       tc_num       LIKE tc_shb_file.tc_shb121
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
DEFINE g_wc     LIKE type_file.chr1000
DEFINE g_flag   LIKE type_file.chr1

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

   LET g_bgjob = ARG_VAL(1)
   
   LET g_action_flag='page1'
   IF cl_null(g_bgjob) OR g_bgjob='N' THEN
      OPEN WINDOW q004_w AT 2,18 WITH FORM "cec/42f/cecq004"
           ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_init()
      CALL q004_tm()
   END IF 

   CALL q004_menu()
   DROP TABLE q004_shc
   CLOSE WINDOW q004_w              
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q004_menu()
    WHILE TRUE
      IF cl_null(g_action_choice) THEN 
         IF g_action_flag = "page1" THEN  
            CALL q004_bp()
         END IF
         IF g_action_flag = "page2" THEN  
            CALL q004_bp2()
         END IF
      END IF 
      
      CASE g_action_choice
         WHEN "page1"
            CALL q004_bp()
         WHEN "page2"
            CALL q004_bp2()
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q004_tm()
               LET g_action_choice = " "
               LET g_action_flag='page1'
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
             LET w = ui.Window.getCurrent()
             LET f = w.getForm()
             IF g_action_flag = "page1" THEN  
                IF cl_chk_act_auth() THEN
                   LET page = f.FindNode("Page","page1")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_shc1),'','') 
                END IF
             END IF 
             IF g_action_flag = "page2" THEN 
                IF cl_chk_act_auth() THEN
                   LET page = f.FindNode("Page","page2")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_shc2),'','') 
                END IF
             END IF 
             LET g_action_choice = " "  
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q004_tm()
DEFINE lc_qbe_sn       LIKE gbm_file.gbm01  

   CALL cl_opmsg('p')
   CLEAR FORM   
   CALL g_shc1.clear()
   CALL g_shc2.clear()
   LET g_wc=''
 
   CONSTRUCT BY NAME g_wc ON tc_sfc01,tc_shc14 
     
    BEFORE CONSTRUCT
       CALL cl_qbe_init() 
 
    ON ACTION locale 
       CALL cl_show_fld_cont()                    
       LET g_action_choice = "locale"
       EXIT CONSTRUCT
 
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE CONSTRUCT
 
    ON ACTION controlp
       CASE
          WHEN INFIELD(tc_sfc01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="cq_tc_sfc01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_sfc01
                  NEXT FIELD tc_sfc01 
          END CASE 
 
    ON ACTION about         #MOD-4C0121
       CALL cl_about()      #MOD-4C0121
 
    ON ACTION help          #MOD-4C0121
       CALL cl_show_help()  #MOD-4C0121
 
    ON ACTION controlg      #MOD-4C0121
       CALL cl_cmdask()     #MOD-4C0121
 
    ON ACTION EXIT
       LET INT_FLAG = 1
       EXIT CONSTRUCT

    ON ACTION qbe_select
       CALL cl_qbe_select()         
 
  END CONSTRUCT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF

   CALL q004()
   ERROR ""
END FUNCTION
 
FUNCTION q004()
   DEFINE l_sql     STRING 
   DEFINE sr        RECORD 
          tc_sfc01     LIKE tc_sfc_file.tc_sfc01,
          tc_sfcud01   LIKE tc_sfc_file.tc_sfcud01,   #add by guanyao160831
          tc_sfc02     LIKE tc_sfc_file.tc_sfc02,
          ecd02        LIKE ecd_file.ecd02,
          tc_shc14_1   LIKE tc_shc_file.tc_shc14,
          tc_shc05     LIKE tc_shc_file.tc_shc05,
          ima02        LIKE ima_file.ima02,
          ima021       LIKE ima_file.ima021,
          tc_shc12     LIKE tc_shc_file.tc_shc12,
          tc_shb12     LIKE tc_shb_file.tc_shb12,
          tc_shb12_1   LIKE tc_shb_file.tc_shb12,
          tc_shc12_1   LIKE tc_shc_file.tc_shc12,
          tc_shc13     LIKE tc_shc_file.tc_shc13,
          ecg02        LIKE ecg_file.ecg02,
          tc_shb122    LIKE tc_shb_file.tc_shb122,
          tc_shb121    LIKE tc_shb_file.tc_shb121,
          tc_num       LIKE tc_shb_file.tc_shb121
                    END RECORD 
   CALL q004_create_tmp()
   DELETE FROM q004_shc
   LET l_sql=" SELECT tc_sfc01,tc_sfcud01,tc_sfc02,ecd02,tc_shc14,tc_shc05,ima02,   ima021,SUM(tc_shc12),0,0,0,   tc_shc13,ecg02,0,0,0 ",
             " FROM tc_sfc_file LEFT JOIN ecd_file ON tc_sfc02=ecd01 ",
             " ,tc_shc_file LEFT JOIN ima_file ON tc_shc05=ima01 ",
             " LEFT JOIN ecg_file ON tc_shc13=ecg01 ",
             " WHERE tc_sfc02=tc_shc08 AND tc_shc01='1' ",
             " AND ",g_wc,
             " GROUP BY tc_sfc01,tc_sfcud01,tc_sfc02,ecd02,tc_shc14,tc_shc05,ima02,ima021,tc_shc13,ecg02 "  #add tc_sfcud01 by guanyao160831
   PREPARE l_pre22 FROM l_sql
   DECLARE l_cur22 CURSOR FOR l_pre22
   FOREACH l_cur22 INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      SELECT SUM(tc_shb12) INTO sr.tc_shb12 FROM tc_shb_file 
         WHERE tc_shb01='1' AND tc_shb05=sr.tc_shc05 AND tc_shb08=sr.tc_sfc02 AND tc_shb14=sr.tc_shc14_1 AND tc_shb13=sr.tc_shc13   #开工量
         
      SELECT SUM(tc_shb12),SUM(tc_shb122),SUM(tc_shb121) INTO sr.tc_shb12_1,sr.tc_shb122,sr.tc_shb121 FROM tc_shb_file 
         WHERE tc_shb01='2' AND tc_shb05=sr.tc_shc05 AND tc_shb08=sr.tc_sfc02 AND tc_shb14=sr.tc_shc14_1 AND tc_shb13=sr.tc_shc13  #完工量，返工量，报废量
         
      SELECT SUM(tc_shc12) INTO sr.tc_shc12_1 FROM tc_shc_file 
         WHERE tc_shc01='2' AND tc_shc05=sr.tc_shc05 AND tc_shc08=sr.tc_sfc02 AND tc_shc14=sr.tc_shc14_1 AND tc_shc13=sr.tc_shc13    #扫出量

      LET sr.tc_num=sr.tc_shc12-sr.tc_shc12_1-sr.tc_shb121
      INSERT INTO q004_shc VALUES (sr.*)
      
   END FOREACH 
   CALL q004_b_fill_1() 
END FUNCTION

FUNCTION q004_bp2()    #汇总

   DISPLAY g_rec_b TO formonly.cn2

   LET g_flag = ' '
   LET g_action_flag = 'page2'
   CALL q004_b_fill_2()
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_shc2 TO s_shc2.* ATTRIBUTE(COUNT=g_rec_b)    
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()   
   
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY  
         
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY  
         
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont() 
         EXIT DISPLAY  
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
         
      ON ACTION accept
         LET l_ac = ARR_CURR()
         LET g_action_flag = 'page1'
         IF l_ac > 0  THEN
            CALL q004_detail_fill(l_ac)
            LET g_flag = '1' 
         END IF
         EXIT DISPLAY
         
      ON ACTION page1
         LET g_action_flag = 'page1'
         EXIT DISPLAY

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
   END DISPLAY 
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q004_b_fill_2()
DEFINE l_sql   STRING 


   LET l_sql = " SELECT tc_sfc01,tc_sfcud01,tc_shc14_1,tc_shc05,ima02,ima021,",   #add tc_sfcud01 by guanyao160831
               " SUM(tc_shc12),SUM(tc_shb12),SUM(tc_shb12_1),SUM(tc_shc12_1),tc_shc13,",
               " ecg02,SUM(tc_shb122),SUM(tc_shb121),SUM(tc_num) ",
               " FROM q004_shc ",
               " GROUP BY tc_sfc01,tc_sfcud01,tc_shc14_1,tc_shc05,ima02,ima021,tc_shc13,ecg02 "

   PREPARE q004_pre23 FROM l_sql
   DECLARE q004_cur23 CURSOR FOR q004_pre23 
   
   CALL g_shc2.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH q004_cur23 INTO g_shc2[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
      END IF
   END FOREACH

   CALL g_shc2.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
END FUNCTION

FUNCTION q004_b_fill_1()
DEFINE l_sql   STRING 
   
   LET l_sql = " SELECT tc_sfc02,ecd02,tc_shc14_1,tc_shc05,ima02,   ",
               " ima021,tc_shc12,tc_shb12,tc_shb12_1,tc_shc12_1, ",
               " tc_shc13,ecg02,tc_shb122,tc_shb121,tc_num FROM q004_shc "

   PREPARE q004_pre12 FROM l_sql
   DECLARE q004_cur22 CURSOR FOR q004_pre12
   
   CALL g_shc1.clear()
   LET g_cnt1 = 1
   LET g_rec_b1 = 0

   FOREACH q004_cur22 INTO g_shc1[g_cnt1].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
      LET g_cnt1 = g_cnt1 + 1
      IF g_cnt1 > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
      END IF
   END FOREACH

   CALL g_shc1.deleteElement(g_cnt1)
   LET g_rec_b1=g_cnt1-1
   DISPLAY g_rec_b1 TO formonly.cn2
END FUNCTION

FUNCTION q004_bp()

   IF g_action_choice = "page1" AND g_flag != '1' THEN
      CALL q004_b_fill_1()
   END IF 

   LET g_action_choice = " "
   LET g_flag = ' '
  
   CALL cl_set_act_visible("accept,cancel", FALSE) 
   DISPLAY ARRAY g_shc1 TO s_shc1.* ATTRIBUTE(COUNT=g_rec_b1)    
      BEFORE ROW
         CALL cl_show_fld_cont()   
   
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY  
         
      ON ACTION page2
         LET g_action_flag = 'page2'
         EXIT DISPLAY 

         
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY  
         
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont() 
         EXIT DISPLAY  
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
     
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
   END DISPLAY 
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q004_create_tmp()
   DROP TABLE q004_shc
   CREATE TEMP TABLE q004_shc(
       tc_sfc01     VARCHAR(1000),
       tc_sfcud01   VARCHAR(1000),
       tc_sfc02     VARCHAR(1000),
       ecd02        VARCHAR(1000),
       tc_shc14_1   DATE,
       tc_shc05     VARCHAR(1000),
       ima02        VARCHAR(1000),
       ima021       VARCHAR(1000),
       tc_shc12     DECIMAL(15,3),
       tc_shb12     DECIMAL(15,3),
       tc_shb12_1   DECIMAL(15,3),
       tc_shc12_1   DECIMAL(15,3),
       tc_shc13     VARCHAR(80),
       ecg02        VARCHAR(1000),
       tc_shb122    DECIMAL(15,3),
       tc_shb121    DECIMAL(15,3),
       tc_num       DECIMAL(15,3)
   )
END FUNCTION 

FUNCTION q004_detail_fill(l_ac)
DEFINE l_ac   LIKE type_file.num5
DEFINE l_sql  STRING 
LET l_sql = " SELECT tc_sfc02,ecd02,tc_shc14_1,tc_shc05,ima02,   ",
               " ima021,tc_shc12,tc_shb12,tc_shb12_1,tc_shc12_1, ",
               " tc_shc13,ecg02,tc_shb122,tc_shb121,tc_num FROM q004_shc ",
               " WHERE tc_sfc01='",g_shc2[l_ac].tc_sfc01,"'"

   PREPARE q004_pre121 FROM l_sql
   DECLARE q004_cur221 CURSOR FOR q004_pre121
   
   CALL g_shc1.clear()
   LET g_cnt1 = 1
   LET g_rec_b1 = 0

   FOREACH q004_cur221 INTO g_shc1[g_cnt1].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
      LET g_cnt1 = g_cnt1 + 1
      IF g_cnt1 > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
      END IF
   END FOREACH

   CALL g_shc1.deleteElement(g_cnt1)
   LET g_rec_b1=g_cnt1-1
   DISPLAY g_rec_b1 TO formonly.cn2
   
END FUNCTION 
