# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#Pattern name..:"almt676.4gl"
#Descriptions..: 券核销
#Date & Author..:09/06/04 By Zhangyajun
# Modify.........: No:FUN-960134 09/11/09 By shiwuying 市場移植
# Modify.........: No:FUN-9B0068 09/11/10 BY lilingyu 臨時表字段改成LIKE的形式
# Modify.........: No:FUN-A10060 10/01/14 By shiwuying 權限處理
# Modify.........: No.FUN-A50102 10/07/08 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-A70130 10/08/06 By wangxin 修正取號時及check編號所傳入的模組代碼及單據性質代碼
# Modify.........: No.FUN-A70130 10/08/10 By huangtao 取消lrk_file所有相關資料
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.TQC-B60258 11/06/21 By yangxf 更改WHERE條件
# Modify.........: No.CHI-C30115 12/05/29 By yuhuabao -239的錯誤判斷,應全部改成IF cl_sql_dup_value(SQLCA.sqlcode)
# Modify.........: No.FUN-CA0152 12/11/13 By xumm 券状态4改为已用增加7核销
# Modify.........: No:FUN-D10040 13/01/18 By xumm 券状态改为4:已用 

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_org    LIKE azp_file.azp01,
       g_date   LIKE type_file.dat,
       g_b1   DYNAMIC ARRAY OF RECORD 
                type     LIKE lqb_file.lqb03,
                type_desc   LIKE lpx_file.lpx02,
                count    LIKE type_file.num5,
                count2   LIKE type_file.num5
                        END RECORD,
        g_b2  DYNAMIC ARRAY OF RECORD 
                no   LIKE lqb_file.lqb02,
                msg  LIKE type_file.chr1
                        END RECORD

DEFINE g_sql   STRING
DEFINE p_row,p_col          LIKE type_file.num5
DEFINE g_change_lang     LIKE type_file.chr1000
DEFINE g_cnt LIKE type_file.num5
DEFINE l_ac1,l_ac2 LIKE type_file.num5
DEFINE g_flag STRING 

MAIN
   DEFINE l_flag   LIKE type_file.chr1
   OPTIONS
        INPUT NO WRAP                     
    DEFER INTERRUPT                      

   LET g_org = ARG_VAL(1)
   LET g_date = ARG_VAL(2)
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF


    CALL  cl_used(g_prog,g_time,1) RETURNING g_time   

    LET p_row = 4 LET p_col = 10
    OPEN WINDOW t676_w AT p_row,p_col WITH FORM "alm/42f/almt676"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   
   CALL t676_i()
   CALL t676_menu()
   
   CLOSE WINDOW t676_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
    
END MAIN

FUNCTION t676_i()

  CALL cl_set_act_visible("accept,cancel",TRUE)
  CALL g_b1.clear()
  CALL g_b2.clear()
  CLEAR FORM
  LET g_org = ''
  LET g_date = g_today
  WHILE TRUE
     INPUT g_org,g_date WITHOUT DEFAULTS 
       FROM FORMONLY.org,FORMONLY.date

        AFTER FIELD org
         IF NOT cl_null(g_org) THEN
               CALL t676_org()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_org,g_errno,0)
                  NEXT FIELD org
               END IF
         END IF
          
         ON ACTION controlp
            CASE
               WHEN INFIELD(org)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azp"  
               LET g_qryparam.default1 = g_org
               LET g_qryparam.where = " azp01 IN ",g_auth," " #No.FUN-A10060
               CALL cl_create_qry() RETURNING g_org
               DISPLAY BY NAME g_org
               CALL t676_org()
               NEXT FIELD org
            END CASE
         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
         ON ACTION view1
            LET g_flag="page1"
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT

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

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION qbe_save
            CALL cl_qbe_save()
      END INPUT

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW t676_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF

      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      EXIT WHILE
  END WHILE
  CALL t676_p2()
  CALL t676_b1()
  CALL t676_p3()
  CALL cl_set_act_visible("accept,cancel",FALSE)

END FUNCTION

FUNCTION t676_org()
 DEFINE l_azp02   LIKE azp_file.azp02
 
   LET g_errno = " "

  #No.FUN-A10060 -BEGIN-----
  #SELECT azp02
  #   INTO l_azp02
  #   FROM azp_file
  #  WHERE azp01 = g_org
  #    AND azp01 IN (SELECT azw01 FROM azw_file
  #                   WHERE azw07=g_plant OR azw01=g_plant)
    LET g_sql = " SELECT azp02 FROM azp_file",
                "  WHERE azp01 = '",g_org,"' ",
                "    AND azp01 IN ",g_auth
    PREPARE sel_azp_pre01 FROM g_sql
    EXECUTE sel_azp_pre01 INTO l_azp02
   #No.FUN-A10060 -END-------
    CASE WHEN SQLCA.sqlcode = 100 LET g_errno = 'art-500'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) THEN
       DISPLAY l_azp02 TO FORMONLY.org_desc
    END IF
END FUNCTION

FUNCTION t676_p2()
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_rxy RECORD LIKE rxy_file.*
DEFINE l_no LIKE lqb_file.lqb02
DEFINE l_status LIKE type_file.chr1
DEFINE l_lqb RECORD LIKE lqb_file.*
DEFINE l_lqe          RECORD LIKE lqe_file.*
DEFINE li_result LIKE type_file.num5
DEFINE l_len1         LIKE type_file.num5
DEFINE l_len2         LIKE type_file.num5
DEFINE l_lpx24        LIKE lpx_file.lpx24
DEFINE l_str          LIKE type_file.chr20
DEFINE l_str1         LIKE type_file.chr20
DEFINE l_str2         LIKE type_file.chr20
DEFINE l_format       LIKE type_file.chr20
DEFINE l_begin_no     LIKE type_file.num20
DEFINE l_end_no       LIKE type_file.num20
DEFINE l_j            LIKE rxy_file.rxy14 
DEFINE l_i            LIKE type_file.num5

   SELECT * FROM lqb_file WHERE 1=0 INTO TEMP lqb_temp
   CREATE TEMP TABLE line(
    lqb03 LIKE pmn_file.pmn01,  #FUN-9B0068
    line  LIKE type_file.num5); #FUN-9B0068
   DELETE FROM lqb_temp
   DELETE FROM line
   BEGIN WORK
   #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=g_org             #FUN-A50102
   #LET g_sql = " SELECT * FROM ",l_dbs CLIPPED,".rxy_file ",
   LET g_sql = " SELECT * FROM ",cl_get_target_table(g_org,'rxy_file'), #FUN-A50102
               " WHERE (rxy00 = '02' OR rxy00 = '01') ",
               "    AND rxy21 = '",g_date,"'",   
               "    AND rxyplant = '",g_org,"'",  
               "    AND (rxy14 IS NOT NULL ",
               "    OR  rxy15 IS NOT NULL) "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql       #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,g_org) RETURNING g_sql #FUN-A50102            
   PREPARE t676_rxy_p1 FROM g_sql
   DECLARE t676_rxy_c1 CURSOR FOR t676_rxy_p1
  # SELECT lrkslip INTO l_lqb.lqb01 FROM lrk_file     #FUN-A70130  mark
  #  WHERE lrkkind='23'                               #FUN-A70130  mark
   SELECT oayslip INTO l_lqb.lqb01 FROM oay_file      #FUN-A70130
#    WHERE oaytype='23'                               #FUN-A70130  #TQC-B60258  mark
    WHERE oaytype = 'M2'                              #TQC-B60258
   #CALL s_auto_assign_no("alm",l_lqb.lqb01,g_date,'23',"lqa_file","lqa01",g_plant,"","") #FUN-A70130
   CALL s_auto_assign_no("alm",l_lqb.lqb01,g_date,'M2',"lqa_file","lqa01",g_plant,"","") #FUN-A70130
           RETURNING li_result,l_lqb.lqb01
   IF (NOT li_result) THEN
       LET g_success='N'
   END IF
   FOREACH t676_rxy_c1 INTO l_rxy.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','foreach t676_rxy_c1',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      IF NOT cl_null(l_rxy.rxy14) AND cl_null(l_rxy.rxy15) THEN
         LET l_rxy.rxy15 = l_rxy.rxy14 
      END IF
      IF NOT cl_null(l_rxy.rxy15) AND cl_null(l_rxy.rxy14) THEN
         LET l_rxy.rxy14 = l_rxy.rxy15 
      END IF
      #CKP#1   起始券/終止券的長度要一致
      LET l_len1 = LENGTH(l_rxy.rxy14)
      LET l_len2 = LENGTH(l_rxy.rxy15)
      IF l_len1 <> l_len2 THEN
         #券起始編號的總長度和券終止編號的總長度不一致,導致無法中間編號的信息!
         LET g_showmsg = l_rxy.rxy00,'/',l_rxy.rxy01,'/',l_rxy.rxy02,'/',
                         l_rxy.rxyplant,'/',l_len1,'/',l_len2
         CALL s_errmsg('rxy00,rxy01,rxy02,rxyplant,lpx21,lpx21',g_showmsg,'length','alm-481',1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
      
      #CKP#2  起始券的固定編碼和終止券的固定編碼要一致
      LET l_str = l_rxy.rxy14
      FOR l_i = l_len1 TO 1 STEP -1
          IF l_str[l_i,l_i] MATCHES '[0-9]' THEN
             LET l_str[l_i,l_i] = ''
          ELSE
             EXIT FOR
          END IF
      END FOR
      LET l_str1 = l_str CLIPPED
      LET l_str = l_rxy.rxy15
      FOR l_i = l_len1 TO 1 STEP -1
          IF l_str[l_i,l_i] MATCHES '[0-9]' THEN
             LET l_str[l_i,l_i] = ''
          ELSE
             EXIT FOR
          END IF
      END FOR
      LET l_str2 = l_str CLIPPED
    
      IF l_str1 <> l_str2 THEN
         #券起始編號的固定編碼值和券終止編號的固定編碼值不一致,導致無法中間編號的信息!
         LET g_showmsg = l_rxy.rxy00,'/',l_rxy.rxy01,'/',l_rxy.rxy02,'/',
                         l_rxy.rxyplant,'/',l_str1,'/',l_str2
         CALL s_errmsg('rxy00,rxy01,rxy02,rxyplant,lpx23,lpx23',g_showmsg,'fix code','alm-482',1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF

      LET l_len1 = LENGTH(l_str1)   #固定編碼長度
      IF l_len1 + 1 <= l_len2 THEN
         LET l_begin_no = l_rxy.rxy14[l_len1+1,l_len2]  #取流水碼
         LET l_end_no   = l_rxy.rxy15[l_len1+1,l_len2]  #取流水碼
         LET l_lpx24 = l_len2 - l_len1
      ELSE
         LET l_begin_no = ''
         LET l_end_no   = ''
         LET l_lpx24 = 0
      END IF
      LET l_format = ''
      FOR l_i = 1 TO l_lpx24 - 1
          LET l_format = l_format CLIPPED,'&'
      END FOR
      IF l_lpx24 > 0 THEN
         LET l_format = l_format CLIPPED,"<"
      END IF

      LET l_j = l_begin_no
      WHILE TRUE
          LET l_lqb.lqb02 = l_str1 CLIPPED,l_j USING l_format    
          SELECT * INTO l_lqe.* FROM lqe_file WHERE lqe01 = l_lqb.lqb02
          IF SQLCA.sqlcode AND SQLCA.sqlcode <> 100 THEN 
             LET g_success = 'N'
             CALL s_errmsg('lqe01',l_no,'sel lqe',SQLCA.sqlcode,1)
          ELSE
             IF SQLCA.sqlcode = 100 THEN #未登記的券
                LET l_lqb.lqb03 = ''
                LET l_lqb.lqb04 = ''
                LET l_lqb.lqb05 = ''
                LET l_lqb.lqb06 = ''
                LET l_lqb.lqb07 = '2'
             ELSE
                LET l_lqb.lqb03 = l_lqe.lqe02
                LET l_lqb.lqb04 = l_lqe.lqe03
                LET l_lqb.lqb05 = l_lqe.lqe17
                CASE l_lqe.lqe17
                     WHEN '0' LET l_lqb.lqb06 = l_lqe.lqe05
                              LET l_lqb.lqb07 = '1'
                     WHEN '1' LET l_lqb.lqb06 = l_lqe.lqe07
                              #LET l_lqb.lqb07 = '0'          #FUN-CA0152 mark
                              LET l_lqb.lqb07 = '1'           #FUN-CA0152 add
                     WHEN '2' LET l_lqb.lqb06 = l_lqe.lqe10
                              LET l_lqb.lqb07 = '1'
                     WHEN '3' LET l_lqb.lqb06 = l_lqe.lqe12
                              LET l_lqb.lqb07 = '1'
                     #WHEN '4' LET l_lqb.lqb06 = l_lqe.lqe19  #FUN-CA0152 mark
                     #         LET l_lqb.lqb07 = '1'          #FUN-CA0152 mark
                     #FUN-CA0152---------add---------str
                     WHEN '4' LET l_lqb.lqb07 = '0'  
                              LET l_lqb.lqb06 = l_lqe.lqe25   #FUN-D10040 add
                     WHEN '5' LET l_lqb.lqb06 = l_lqe.lqe14
                              LET l_lqb.lqb07 = '0'
                     WHEN '6' LET l_lqb.lqb06 = l_lqe.lqe16
                              LET l_lqb.lqb07 = '0'
                     WHEN '7' LET l_lqb.lqb06 = l_lqe.lqe19
                              LET l_lqb.lqb07 = '0'
                     #FUN-CA0152---------add---------end
                END CASE
             END IF
             SELECT lqc06 INTO l_lqb.lqb08 FROM lqc_file
              WHERE lqc01 = l_lqb.lqb02
             IF cl_null(l_lqb.lqb08) THEN LET l_lqb.lqb08 = 0 END IF
          END IF
          LET l_lqb.lqbplant = g_plant
          LET l_lqb.lqblegal = g_legal
          INSERT INTO lqb_temp VALUES (l_lqb.*)
          LET l_j = l_j + 1
          IF l_j > l_end_no THEN EXIT WHILE END IF
      END WHILE
   END FOREACH
   COMMIT WORK
END FUNCTION

FUNCTION t676_p3()
DEFINE l_lqb RECORD LIKE lqb_file.*
DEFINE l_ac LIKE type_file.num5

       LET g_cnt = 1
       DECLARE coupon_cs CURSOR FOR SELECT * FROM lqb_temp
       FOREACH coupon_cs INTO l_lqb.*
           IF l_lqb.lqb07 = '0' THEN
             #UPDATE lqe_file SET lqe17 = '4',  #FUN-D10040 mark
              UPDATE lqe_file SET lqe17 = '7',  #FUN-D10040 add
                                 lqe18 = g_org,
                                 lqe19 = g_date
                 WHERE lqe01 = l_lqb.lqb02
                IF SQLCA.sqlcode THEN
                   CALL s_errmsg('lqe01',l_lqb.lqb02,'upd lqe',SQLCA.sqlcode,1)
                   LET g_success = 'N'
                END IF
              SELECT line INTO l_ac FROM line WHERE lqb03=l_lqb.lqb03
                 LET g_b1[l_ac].count2 = g_b1[l_ac].count2 + 1
                 DISPLAY ARRAY g_b1 TO s_b1.*
                   BEFORE DISPLAY
                     EXIT DISPLAY
                 END DISPLAY
                 CALL ui.Interface.refresh()
           ELSE
             CALL t676_ins_upd_lqc(l_lqb.*)
              IF l_lqb.lqb05 IS NULL THEN
                 LET g_b2[g_cnt].msg = '5'
              ELSE
                 IF l_lqb.lqb05='1' THEN
                    CONTINUE FOREACH
                 ELSE
                    LET g_b2[g_cnt].msg=l_lqb.lqb05
                 END IF
              END IF
              
              LET g_b2[g_cnt].no=l_lqb.lqb02
              DISPLAY ARRAY g_b2 TO s_b2.*
                BEFORE DISPLAY
                  EXIT DISPLAY
              END DISPLAY
              CALL ui.Interface.refresh()
              LET g_cnt = g_cnt+1
           END IF
           
       END FOREACH
       CALL t676_ins_lqa()
END FUNCTION

FUNCTION t676_menu()
    WHILE TRUE
      CASE g_flag
         WHEN "page1" CALL t676_bp1()
         WHEN "page2" CALL t676_bp2()
         OTHERWISE CALL t676_bp1()
      END CASE
      CASE g_action_choice
         WHEN "insert"
              CALL t676_i()
         WHEN "view1"
              LET g_flag = "page1"
         WHEN "view2"
              LET g_flag="page2"
         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

      END CASE
   END WHILE

END FUNCTION

FUNCTION t676_b1()
DEFINE l_lqb03 LIKE lqb_file.lqb03
DEFINE l_count LIKE type_file.num5
    
    DECLARE b1_cs CURSOR FOR SELECT lqb03,COUNT(lqb02) FROM lqb_temp WHERE lqb05 IS NOT NULL GROUP BY lqb03
    LET g_cnt = 1
    CALL g_b1.clear()
    FOREACH b1_cs INTO l_lqb03,l_count
        LET g_b1[g_cnt].type=l_lqb03
        SELECT lpx02 INTO g_b1[g_cnt].type_desc FROM lpx_file WHERE lpx01=l_lqb03
        LET g_b1[g_cnt].count=l_count
        LET g_b1[g_cnt].count2=0
        INSERT INTO line VALUES(l_lqb03,g_cnt)
        LET g_cnt=g_cnt+1
        
    END FOREACH
    CALL g_b1.deleteElement(g_cnt)

END FUNCTION

FUNCTION t676_bp1()

    CALL cl_set_act_visible("accept,cancel",FALSE)
    DISPLAY ARRAY g_b1 TO s_b1.* ATTRIBUTE(COUNT=g_cnt-1,UNBUFFERED)
      BEFORE DISPLAY
         IF l_ac1 <> 0 THEN
            CALL fgl_set_arr_curr(l_ac1)
         END IF

      BEFORE ROW
         LET l_ac1 = ARR_CURR()
      ON ACTION insert
         LET g_action_choice = "insert"
         EXIT DISPLAY
      ON ACTION view2
         LET g_action_choice = "view2"
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

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()
    END DISPLAY
    
END FUNCTION

FUNCTION t676_bp2()

    CALL cl_set_act_visible("accept,cancel",FALSE)
    DISPLAY ARRAY g_b2 TO s_b2.* ATTRIBUTE(COUNT=g_cnt-1,UNBUFFERED)
      BEFORE DISPLAY
         IF l_ac2 <> 0 THEN
            CALL fgl_set_arr_curr(l_ac2)
         END IF

      BEFORE ROW
         LET l_ac2 = ARR_CURR()
      ON ACTION insert
         LET g_action_choice = "insert"
         EXIT DISPLAY
      ON ACTION view1
         LET g_action_choice = "view1"
         EXIT DISPLAY
      ON ACTION exit
         LET g_action_choice = "exit"
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

FUNCTION t676_ins_upd_lqc(p_lqb)
   DEFINE p_lqb           RECORD LIKE lqb_file.*
   DEFINE l_lqc           RECORD LIKE lqc_file.*

   LET l_lqc.lqcplant = g_plant
   LET l_lqc.lqclegal = g_legal
   LET l_lqc.lqc01 = p_lqb.lqb02
   LET l_lqc.lqc02 = p_lqb.lqb05
   LET l_lqc.lqc03 = p_lqb.lqb06
   LET l_lqc.lqc04 = g_date
   LET l_lqc.lqc05 = p_lqb.lqb07
   LET l_lqc.lqc06 = 1
   INSERT INTO lqc_file VALUES(l_lqc.*)
#  IF SQLCA.sqlcode AND SQLCA.sqlcode <> -239 THEN #CHI-C30115 mark
   IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
      CALL s_errmsg('lqc01',p_lqb.lqb02,'ins lqc',SQLCA.sqlcode,1)
      LET g_success = 'N'
   ELSE
#     IF SQLCA.sqlcode = -239 THEN #CHI-C30115 mark
      IF cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
         UPDATE lqc_file SET lqc06 = lqc06 + 1
          WHERE lqc01 = p_lqb.lqb02
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL s_errmsg('lqc01',p_lqb.lqb02,'upd lqc06',SQLCA.sqlcode,1)
            LET g_success = 'N'
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION t676_ins_lqa()
DEFINE l_lqa RECORD LIKE lqa_file.*
DEFINE l_lqb RECORD LIKE lqb_file.*
DEFINE l_n LIKE type_file.num5

    SELECT COUNT(*) INTO l_n FROM lqb_temp WHERE lqb07='0'
    IF l_n>0 THEN
       SELECT * INTO l_lqb.* FROM lqb_temp
       LET l_lqa.lqa01 = l_lqb.lqb01
       LET l_lqa.lqa02 = '0'
       LET l_lqa.lqa04 = g_date
       LET l_lqa.lqaplant = g_org
       LET l_lqa.lqalegal = l_lqb.lqblegal
       LET l_lqa.lqa05 = 'N'
       LET l_lqa.lqa06 = '0'
       LET l_lqa.lqa07 = 'N'
       LET l_lqa.lqa08 = g_user
       LET l_lqa.lqa09 = g_today
       LET l_lqa.lqauser=g_user
       LET l_lqa.lqagrup=g_grup
       LET l_lqa.lqacrat=g_today
       LET l_lqa.lqaacti='Y'
       LET l_lqa.lqaplant = g_plant
       LET l_lqa.lqalegal = g_legal
       INSERT INTO lqa_file VALUES(l_lqa.*)
       INSERT INTO lqb_file SELECT * FROM lqb_temp WHERE lqb07='0'
    END IF
END FUNCTION
#No.FUN-960134
