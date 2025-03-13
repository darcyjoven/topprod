# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: artp210.4gl 
# Descriptions...: 盤點計劃整批產生作業
# Date & Author..: FUN-960130 09/08/21 By sunyanchun
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10036 10/01/07 By baofei 手動修改INSERT INTO xxx_file ，增加xxx_file xxxoriu, xxxorig這二個欄位
# Modify.........: No.TQC-A10073 10/01/07 By Cockroach 跨DB修改
# Modify.........: No.FUN-A50102 10/07/13 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A70130 10/08/16 By huangtao  修改單據性質rye02
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管
# Modify.........: No.FUN-AA0062 10/11/08 By yinhy 倉庫權限使用控管修改
# Modify.........: No.TQC-AC0092 10/11/08 By yinhy 拿掉倉庫權限使用控管修改
# Modify.........: No.TQC-AB0323 10/12/08 By huangtao 過到正式區 
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:TQC-BB0097 11/11/10 By suncx 執行效率優化
# Modify.........: No:FUN-C90049 12/10/19 By Lori 預設成本倉與非成本倉改從s_get_defstore取
# Modify.........: No:FUN-C90050 12/10/24 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_rus		RECORD LIKE rus_file.*,
       g_rus_t      RECORD LIKE rus_file.*
DEFINE g_t1       	 LIKE oay_file.oayslip     
DEFINE g_buf             LIKE type_file.chr2
DEFINE p_row,p_col       LIKE type_file.num5
DEFINE g_cnt             LIKE type_file.num10
DEFINE g_i               LIKE type_file.num5
DEFINE g_flag            LIKE type_file.chr1
DEFINE g_msg             LIKE type_file.chr1000
DEFINE l_ac              LIKE type_file.num5
DEFINE g_rec_b           LIKE type_file.num5
DEFINE g_sql             STRING
DEFINE g_change_lang     LIKE type_file.chr1
DEFINE g_type            LIKE type_file.chr1
DEFINE g_rusplant STRING
DEFINE g_rus05  STRING
DEFINE g_rus13  STRING
DEFINE g_rus11  STRING
 
MAIN
   DEFINE l_flag   LIKE type_file.chr1
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time         
 
   LET p_row = 5 LET p_col = 28
 
   OPEN WINDOW p210_w AT p_row,p_col WITH FORM "art/42f/artp210"
     ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
 
   WHILE TRUE
       LET g_rus.rus03 = g_today
       LET g_rus.rus04 = g_today
       LET g_rus.rus06 = 'N'
       LET g_rus.rus08 = 'N'
       LET g_rus.rus10 = 'N'
       LET g_rus.rus12 = 'N'
       LET g_rus.rus15 = 'N'
       LET g_rus.rus16 = 'N'
       LET g_rus.rusconf = 'N'
       LET g_rus.ruscond = NULL
       LET g_rus.rusmksg = 'N'
       LET g_rus.rus900 = '0'
       LET g_rus.ruspos = 'N'
       LET g_rus.ruscont = NULL
       LET g_rus.rususer = g_user
       LET g_rus.rusgrup = g_grup
       LET g_rus.ruscrat = g_today
       LET g_rus.rusmodu = ''
       LET g_rus.rusdate = ''
       LET g_rus.rusacti = 'Y'
       LET g_type = '0'
       LET g_rus_t.* = g_rus.*
       CALL p210_p1()
       IF cl_sure(18,20) THEN
          CALL s_showmsg_init()
          BEGIN WORK
          LET g_success = 'Y'
          CALL p210_p2()
          IF g_success = 'Y' THEN
             COMMIT WORK
             CALL cl_end2(1) RETURNING l_flag
          ELSE
             CALL s_showmsg()
             ROLLBACK WORK
             CALL cl_end2(2) RETURNING l_flag
          END IF
          IF l_flag THEN
             CONTINUE WHILE
          ELSE
             CLOSE WINDOW p210_w
             EXIT WHILE
          END IF
       ELSE
          CONTINUE WHILE
       END IF
   END WHILE
   CLOSE WINDOW p210_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION p210_p1()
DEFINE li_result  LIKE type_file.num5,
       l_n       LIKE type_file.num5
DEFINE l_rusplant  LIKE rus_file.rusplant
DEFINE tok       base.StringTokenizer
DEFINE l_rus01   LIKE rus_file.rus01
DEFINE l_azp01   LIKE azp_file.azp01
DEFINE l_rtz04   LIKE rtz_file.rtz04
DEFINE l_sql     STRING
 
   WHILE TRUE
     CLEAR FORM
     INPUT g_rus.rus02,g_rus.rus03,g_rus.rus04,g_rusplant,
           g_type,g_rus05,g_rus.rus14,g_rus.rus06,
           g_rus.rus07,g_rus.rus08,g_rus.rus09,g_rus.rus10,
           g_rus11,g_rus.rus12,g_rus13
        WITHOUT DEFAULTS
        FROM rus02,rus03,rus04,rusplant,
             type,rus05,rus14,rus06,
             rus07,rus08,rus09,rus10,
             rus11,rus12,rus13
 
         BEFORE INPUT
            CALL cl_qbe_init()
            
         AFTER FIELD rus04
          IF g_rus.rus04 IS NOT NULL THEN
            IF g_rus.rus04 != g_rus_t.rus04 THEN              
               IF g_rus.rus04 < g_today THEN
                  CALL cl_err('','art-346',0)
                  NEXT FIELD rus04
               ELSE
                  LET g_rus_t.rus04 = g_rus.rus04
               END IF
            END IF
          END IF
         
         AFTER FIELD rusplant
            IF NOT cl_null(g_rusplant) THEN
               IF g_rusplant IS NOT NULL THEN
                  CALL p210_rusplant()
                  IF NOT cl_null(g_errno)  THEN
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD rusplant                 
                  END IF
                  LET l_sql = cl_replace_str(g_rusplant,'|',"','")
                  LET l_sql = "('",l_sql,"')"
               END IF              
            END IF
            
         AFTER FIELD rus05
          IF g_rus05 IS NOT NULL THEN
             CALL p210_rus05()
             IF NOT cl_null(g_errno)  THEN
                CALL cl_err('',g_errno,0)
                NEXT FIELD rus05
             END IF
             #No.TQC-AC0092 mark  --Begin
             #No.FUN-AA0062  --Begin
             #IF NOT s_chk_ware(g_rus05) THEN
             #   NEXT FIELD rus05
             #END IF 
             #No.FUN-AA0062  --End
             #No.TQC-AC0092 mark  --End
          END IF
         
         ON CHANGE type
            IF NOT cl_null(g_type) THEN
               LET g_rus05 = ''
               DISPLAY g_rus05 TO rus05
            END IF
            
         ON CHANGE rus06,rus08,rus10,rus12
            CASE 
              WHEN INFIELD(rus06)
                   IF g_rus.rus06 = 'Y' THEN
                      CALL cl_set_comp_entry('rus07',TRUE)
                   ELSE
                      CALL cl_set_comp_entry('rus07',FALSE)
                      LET g_rus.rus07 = ''
                      DISPLAY g_rus.rus07 TO rus07
                   END IF                
              WHEN INFIELD(rus08)
                   IF g_rus.rus08 = 'Y' THEN
                      CALL cl_set_comp_entry('rus09',TRUE)
                   ELSE
                      CALL cl_set_comp_entry('rus09',FALSE)
                      LET g_rus.rus09 = ''
                      DISPLAY g_rus.rus09 TO rus07
                   END IF
              WHEN INFIELD(rus10)
                   IF g_rus.rus10 = 'Y' THEN
                      CALL cl_set_comp_entry('rus11',TRUE)
                   ELSE
                      CALL cl_set_comp_entry('rus11',FALSE)
                      LET g_rus11 = ''
                      DISPLAY g_rus11 TO rus07
                   END IF
              WHEN INFIELD(rus12)
                   IF g_rus.rus12 = 'Y' THEN
                      CALL cl_set_comp_entry('rus13',TRUE)
                   ELSE
                      CALL cl_set_comp_entry('rus13',FALSE)
                      LET g_rus13 = ''
                      DISPLAY g_rus13 TO rus07
                   END IF
            END CASE 
     AFTER FIELD rus07
         IF g_rus.rus07 IS NOT NULL THEN
            CALL p210_rus07()
            IF NOT cl_null(g_errno)  THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD rus07
            END IF
         END IF
         
      AFTER FIELD rus09
         IF g_rus.rus09 IS NOT NULL THEN
            CALL p210_rus09()
            IF NOT cl_null(g_errno)  THEN
               CALL cl_err('',g_errno,0) NEXT FIELD rus09
            END IF
         END IF
 
      AFTER FIELD rus11
         IF g_rus.rus11 IS NOT NULL THEN
            CALL p210_rus11()
            IF NOT cl_null(g_errno)  THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD rus11
            END IF
         END IF
         
      AFTER FIELD rus13
         IF g_rus.rus13 IS NOT NULL THEN
               CALL p210_rus13()
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD rus13
               END IF
         END IF
               
         AFTER INPUT 
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
 
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
 
         ON ACTION CONTROLP                  
            CASE
              WHEN INFIELD(rusplant)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form="q_tqb1"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1=g_rusplant
                 CALL cl_create_qry() RETURNING g_rusplant
                 DISPLAY g_rusplant TO rusplant
                 NEXT FIELD rusplant
                 
              WHEN INFIELD(rus05)
                 CALL cl_init_qry_var()
                 CASE g_type
                   WHEN '0' LET g_qryparam.form = "q_imd01_3"
                            LET g_qryparam.where = "imd20 IN ",l_sql
                   WHEN '1' LET g_qryparam.form = "q_tqb10"
                            LET g_qryparam.where = "rtz01 IN ",l_sql
                   WHEN '2' LET g_qryparam.form = "q_tqb18"
                            LET g_qryparam.where = "rtz01 IN ",l_sql
                 END CASE
                 LET g_qryparam.state = "c"           
                 LET g_qryparam.default1 = g_rus05
                 CALL cl_create_qry() RETURNING g_rus05
                 DISPLAY g_rus05 TO rus05
                 NEXT FIELD rus05
                 
              WHEN INFIELD(rus07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima131_1"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_rus.rus07
                 CALL cl_create_qry() RETURNING g_rus.rus07
                 DISPLAY BY NAME g_rus.rus07
                 NEXT FIELD rus07
 
              WHEN INFIELD(rus09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima1005"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_rus.rus09
                 CALL cl_create_qry() RETURNING g_rus.rus09
                 DISPLAY BY NAME g_rus.rus09
                 NEXT FIELD rus09
 
              WHEN INFIELD(rus11)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_rty05_3"
                LET g_qryparam.state = "c"
                LET g_qryparam.default1 = g_rus11
                LET g_qryparam.where = "rtyacti = 'Y' AND rty01 IN ",l_sql
                CALL cl_create_qry() RETURNING g_rus11
                DISPLAY g_rus11 TO rus11
                NEXT FIELD rus11
                
              WHEN INFIELD(rus13)
#FUN-AA0059----mark--------str-------------
#                CALL cl_init_qry_var()
#               SELECT azp01 INTO l_azp01 FROM rtz_file,azp_file
#                WHERE azp01 = rtz01 AND rtz04 IS NULL
#               IF g_rusplant.getIndexOf(l_azp01,1)>0 THEN
#                  LET g_qryparam.form = "q_ima"
#               ELSE
#                  LET g_qryparam.form = "q_rte03_5"
#                  LET tok = base.StringTokenizer.createExt(g_rusplant,"|",'',TRUE)
#                  LET l_sql = ''
#                  WHILE tok.hasMoreTokens()
#                      LET l_rusplant = tok.nexttoken()
#                      IF l_rusplant IS NOT NULL THEN
#                         SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01 = l_rusplant
#                         IF l_sql IS NOT NULL THEN
#                             LET l_sql = l_sql,",'",l_rtz04,"'"
#                         ELSE
#                             LET l_sql = "'",l_rtz04,"'"
#                         END IF
#                      END IF
#                  END WHILE
#                  LET l_sql = "(",l_sql,")"
#                  LET g_qryparam.where = "rte01 IN ",l_sql
#                  CALL cl_create_qry() RETURNING g_rus13
#               END IF            
#                LET g_qryparam.state = "c"
#                LET g_qryparam.default1 = g_rus13
#                CALL cl_create_qry() RETURNING g_rus13
                CALL q_sel_ima(TRUE, "q_ima","",g_rus13,"","","","","",'')  #FUN-AA0059 add
                    RETURNING g_rus13                                       #FUN-AA0059 add
#FUN-AA0059----mark------end---------------
                DISPLAY g_rus13 TO rus13
                NEXT FIELD rus13
           END CASE
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p210_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      EXIT WHILE
  END WHILE
 
END FUNCTION
 
FUNCTION p210_p2()
DEFINE tok,tok2,tok3,tok4    base.StringTokenizer
DEFINE l_rye03               LIKE rye_file.rye03
DEFINE li_result             LIKE type_file.num5
#DEFINE l_dbs                 LIKE azp_file.azp03   #FUN-A50102
DEFINE l_sql                 STRING
DEFINE l_rte03               LIKE rte_file.rte03
DEFINE l_n,l_cnt             LIKE type_file.num5
DEFINE l_rtz04               LIKE rtz_file.rtz04
DEFINE l_rus05               LIKE rus_file.rus05
DEFINE l_rty05               LIKE rty_file.rty05
DEFINE l_rus05_s             STRING                 #TQC-BB0097
DEFINE l_rty05_s             STRING                 #TQC-BB0097
DEFINE l_rte03_s             STRING                 #TQC-BB0097


    LET l_rus05_s = cl_replace_str(g_rus05,"|","','") #TQC-BB0097
    LET l_rus05_s = "('",l_rus05_s,"')"               #TQC-BB0097
    LET l_rty05_s = cl_replace_str(g_rus11,"|","','") #TQC-BB0097
    LET l_rty05_s = "('",l_rty05_s,"')"               #TQC-BB0097
    LET l_rte03_s = cl_replace_str(g_rus13,"|","','") #TQC-BB0097
    LET l_rte03_s = "('",l_rte03_s,"')"               #TQC-BB0097
     
    LET tok = base.StringTokenizer.createExt(g_rusplant,"|",'',TRUE)
    WHILE tok.hasMoreTokens()
      LET g_rus.rusplant = tok.nextToken()
      IF g_rus.rusplant IS NULL THEN
         CONTINUE WHILE
      END IF
     
     #TQC-A10073 MARK&ADD--------------------------------------- 
     #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_rus.rusplant
#FUN-A50102 -------------------mark start----------------------
#     LET g_plant_new = g_rus.rusplant
#     CALL s_gettrandbs()
#     LET l_dbs = g_dbs_tra
#    #TQC-A10073 MARK&ADD---------------------------------------
#     LET l_dbs = s_dbstring(l_dbs CLIPPED)
#FUN-A50102-------------------mark end-------------------------
#     LET g_sql = "SELECT rye03 FROM ",l_dbs CLIPPED,"rye_file ",                        #FUN-A50102  mark
      #FUN-C90050 mark betgin---
      #LET g_sql = "SELECT rye03 FROM ",cl_get_target_table(g_rus.rusplant,'rye_file'),   #FUN-A50102
      #            " WHERE rye01 = 'art' AND rye02 = 'D5' AND ryeacti = 'Y'"              #FUN-A70130
      #CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102 
      #CALL cl_parse_qry_sql(g_sql,g_rus.rusplant) RETURNING g_sql   #FUN-A50102               
      #PREPARE rye03_cs FROM g_sql
      #EXECUTE rye03_cs INTO l_rye03
      #FUN-C90050 mark end-----
      CALL s_get_defslip('art','D5',g_rus.rusplant,'N') RETURNING l_rye03    #FUN-C90050 add

      IF l_rye03 IS NULL THEN 
         CALL s_errmsg('','','art D ','art-330',1)
         LET g_success = 'N'
      END IF
 
     #CALL s_auto_assign_no("art",l_rye03,g_today,"","rus_file","rus01",g_rus.rusplant,"","") #No.FUN-A70130
      CALL s_auto_assign_no("art",l_rye03,g_today,"D5","rus_file","rus01",g_rus.rusplant,"","") #No.FUN-A70130
          RETURNING li_result,g_rus.rus01
      IF (NOT li_result) THEN
          CALL s_errmsg('rye03',l_rye03,'','sub-145',1)  
          LET g_success = 'N'
      END IF
      
      LET g_rus.rus05 = ''
      CASE g_type
       #TQC-BB0097 mod begin ---------------------------------
       #WHEN '0' LET tok2 = base.StringTokenizer.createExt(g_rus05,"|",'',TRUE)                
       #         WHILE tok2.hasmoretokens()
       #             LET l_rus05 = tok2.nexttoken()
       #             SELECT COUNT(*) INTO l_n FROM imd_file WHERE imd01=l_rus05 AND imd20=g_rus.rusplant
       #             IF l_n = 0 THEN
       #                CONTINUE WHILE
       #             ELSE
       #                IF g_rus.rus05 IS NULL THEN
       #                   LET g_rus.rus05 = l_rus05
       #                ELSE
       #                   LET g_rus.rus05 = g_rus.rus05,'|',l_rus05
       #                END IF
       #             END IF
       #         END WHILE
        WHEN '0'
                 LET g_sql = "SELECT imd01 FROM imd_file WHERE imd20='",g_rus.rusplant,"' AND imd01 IN ",l_rus05_s
                 CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                 PREPARE rus05_pre FROM g_sql
                 DECLARE rus05_cs CURSOR FOR rus05_pre
                 FOREACH rus05_cs INTO l_rus05
                    IF g_rus.rus05 IS NULL THEN
                       LET g_rus.rus05 = l_rus05
                    ELSE
                       LET g_rus.rus05 = g_rus.rus05,'|',l_rus05
                    END IF       
                 END FOREACH
       #TQC-BB0097 mod end-------------------------------------
        WHEN '1' #SELECT rtz07 INTO g_rus.rus05 FROM rtz_file WHERE rtz01 = g_rus.rusplant    #FUN-C90049 mark
            CALL s_get_coststore(g_rus.rusplant,g_rus.rus13) RETURNING g_rus.rus05                     #FUN-C90049 add
        WHEN '2' #SELECT rtz08 INTO g_rus.rus05 FROM rtz_file WHERE rtz01 = g_rus.rusplant    #FUN-c90049 mark
            CALL s_get_noncoststore(g_rus.rusplant,g_rus.rus13) RETURNING g_rus.rus05                  #FUN-C90049 add 
      END CASE
 
      LET g_rus.rus11 = ''
      IF g_rus.rus10 = 'Y' THEN
        #TQC-BB0097 mod begin ---------------------------------
        #LET tok3 = base.StringTokenizer.createExt(g_rus11,"|",'',TRUE)
        #WHILE tok3.hasMoreTokens()
        #   LET l_rty05 = tok3.nexttoken()
        #   SELECT COUNT(*) INTO l_n FROM rty_file WHERE rty01=g_rus.rusplant AND rty05=l_rty05
        #   IF l_n=0 THEN
        #      CONTINUE WHILE
        #   ELSE
        #      IF g_rus.rus11 IS NULL THEN
        #         LET g_rus.rus11 = l_rty05
        #      ELSE
        #         LET g_rus.rus11 = g_rus.rus11,'|',l_rty05
        #      END IF
        #   END IF
        #END WHILE   
         LET g_sql = "SELECT rty05 FROM rty_file WHERE rty01='",g_rus.rusplant,"' AND rty05 IN ",l_rty05_s
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         PREPARE rty05_pre FROM g_sql
         DECLARE rty05_cs CURSOR FOR rty05_pre
         FOREACH rty05_cs INTO l_rty05
            IF g_rus.rus11 IS NULL THEN
               LET g_rus.rus11 = l_rty05
            ELSE
               LET g_rus.rus11 = g_rus.rus05,'|',l_rty05
            END IF                 
         END FOREACH
        #TQC-BB0097 mod end-------------------------------------
      END IF
 
      LET g_rus.rus13 = ''
      IF g_rus.rus12 = 'Y' THEN
         SELECT COUNT(*) INTO l_n FROM rtz_file
          WHERE rtz01 = g_rus.rusplant AND rtz04 IS NULL
         IF l_n = 0 THEN
             SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01 = g_rus.rusplant
            #TQC-BB0097 mod begin ---------------------------------
            #LET tok4 = base.StringTokenizer.createExt(g_rus13,"|",'',TRUE)
            #WHILE tok4.hasMoreTokens()
            #  LET l_rte03 = tok4.nexttoken()
            #  SELECT COUNT(*) INTO l_n FROM rte_file
            #   WHERE rte01 = l_rtz04 AND rte03 = l_rte03
            #  IF l_n >0 THEN
            #     IF g_rus.rus13 IS NOT NULL THEN
            #        LET g_rus.rus13 = g_rus.rus13,"|",l_rte03
            #     ELSE
            #        LET g_rus.rus13 = l_rte03
            #     END IF
            #  END IF
            #END WHILE
             LET g_sql = "SELECT rte03 FROM rte_file WHERE rte01='",l_rtz04,"' AND rte03 IN ",l_rte03_s
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql
             PREPARE rte03_pre FROM g_sql
             DECLARE rte03_cs CURSOR FOR rte03_pre
             FOREACH rte03_cs INTO l_rte03
                IF g_rus.rus11 IS NULL THEN
                   LET g_rus.rus13 = l_rte03
                ELSE
                   LET g_rus.rus13 = g_rus.rus05,'|',l_rte03
                END IF
             END FOREACH
            #TQC-BB0097 mod end-------------------------------------
         ELSE
            LET g_rus.rus13 = g_rus13
         END IF
      END IF
      SELECT azw02 INTO g_rus.ruslegal FROM azw_file WHERE azw01 = g_rus.rusplant
     #LET g_sql = "INSERT INTO ",l_dbs CLIPPED,"rus_file(",                           #FUN-A50102 mark
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_rus.rusplant,'rus_file'),"(",  #FUN-A50102 
                  "  rus01,rus02,rus03,rus04,rus05,rus06,rus07,rus08,rus09,rus10,",
                  "  rus11,rus12,rus13,rus14,rus15,rus16,rusconf,ruscond,rusconu,rusmksg,",
                  "  russign,rusdays,rusprit,russseq,russmax,rus900,rusplant,rususer,rusgrup,ruscrat,",
                  "  rusmodu,rusdate,rusacti,ruspos,ruscont,ruslegal,rusoriu,rusorig ", #FUN-A10036
                  " )VALUES(?,?,?,?,?, ?,?,?,?,?,",
                  "         ?,?,?,?,?, ?,?,?,?,?,",
                  "         ?,?,?,?,?, ?,?,?,?,?,",
                  "         ?,?,?,?,?, ?,?,?",      #FUN-A10036
                  ")"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql                         #FUN-A50102 
      CAll cl_parse_qry_sql(g_sql,g_rus.rusplant) RETURNING g_sql          #FUN-A50102
      PREPARE rus_ins FROM g_sql
      EXECUTE rus_ins USING g_rus.rus01,g_rus.rus02,g_rus.rus03,g_rus.rus04,g_rus.rus05,
                            g_rus.rus06,g_rus.rus07,g_rus.rus08,g_rus.rus09,g_rus.rus10,
                            g_rus.rus11,g_rus.rus12,g_rus.rus13,g_rus.rus14,g_rus.rus15,
                            g_rus.rus16,g_rus.rusconf,g_rus.ruscond,g_rus.rusconu,g_rus.rusmksg,
                            g_rus.russign,g_rus.rusdays,g_rus.rusprit,g_rus.russseq,g_rus.russmax,
                            g_rus.rus900,g_rus.rusplant,g_rus.rususer,g_rus.rusgrup,g_rus.ruscrat,
                            g_rus.rusmodu,g_rus.rusdate,g_rus.rusacti,g_rus.ruspos,g_rus.ruscont,
                            g_rus.ruslegal,g_user,g_grup  #FUN-A10036
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('rusplant',g_rus.rusplant,'ins rus_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
    END WHILE
END FUNCTION
 
FUNCTION p210_rus05()
DEFINE l_imd11         LIKE imd_file.imd11
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_imdacti       LIKE imd_file.imdacti
DEFINE l_sql,l_buf     STRING
 
   LET g_errno = ''
   LET l_buf = cl_replace_str(g_rusplant,"|","','")
   LET l_buf = "('",l_buf,"')"
   LET tok = base.StringTokenizer.createExt(g_rus05,"|",'',TRUE)
   WHILE tok.hasMoreTokens()
      LET l_ck = tok.nextToken()
      IF l_ck IS NULL THEN
         LET g_errno = 'art-358'
         RETURN
      END IF
      LET l_sql ="SELECT imd11,imdacti FROM imd_file ",
                 " WHERE imd01 = '",l_ck,"' AND imd20 IN ",l_buf
      PREPARE imd_cs FROM l_sql
      EXECUTE imd_cs  INTO l_imd11,l_imdacti 
      IF SQLCA.sqlcode = 100  THEN
         LET g_errno = 'art-359'
         RETURN
      END IF
      IF l_imdacti IS NULL OR l_imdacti = 'N' THEN
         LET g_errno = 'art-360'
         RETURN
      END IF
      IF l_imd11 IS NULL OR l_imd11 = 'N' THEN
         LET g_errno = 'art-361'
         RETURN
      END IF
   END WHILE
END FUNCTION
 
FUNCTION p210_rus07()
DEFINE l_obaacti       LIKE oba_file.obaacti
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
 
   LET g_errno = ''
   LET tok = base.StringTokenizer.createExt(g_rus.rus07,"|",'',TRUE)
   WHILE tok.hasMoreTokens()
      LET l_ck = tok.nextToken()
      IF l_ck IS NULL THEN
         LET g_errno = 'art-358'
         RETURN
      END IF
      SELECT obaacti INTO l_obaacti FROM oba_file
          WHERE oba01 = l_ck
      IF SQLCA.sqlcode = 100  THEN
         LET g_errno = 'art-349'
         RETURN
      END IF
      IF l_obaacti IS NULL OR l_obaacti = 'N' THEN
         LET g_errno = 'art-350'
         RETURN
      END IF
   END WHILE
END FUNCTION
 
FUNCTION p210_rus09()
DEFINE l_tqaacti       LIKE tqa_file.tqaacti
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
 
   LET g_errno = ''
   LET tok = base.StringTokenizer.createExt(g_rus.rus09,"|",'',TRUE)
   WHILE tok.hasMoreTokens()
      LET l_ck = tok.nextToken()
      IF l_ck IS NULL THEN
         LET g_errno = 'art-358'
         RETURN
      END IF
      SELECT tqaacti INTO l_tqaacti FROM tqa_file
          WHERE tqa01 = l_ck AND tqa03 = '2'
      IF SQLCA.sqlcode = 100  THEN
         LET g_errno = 'art-352'
         RETURN
      END IF
      IF l_tqaacti IS NULL OR l_tqaacti = 'N' THEN
         LET g_errno = 'art-353'
         RETURN
      END IF
   END WHILE
END FUNCTION
 
FUNCTION p210_rus11()
DEFINE l_pmcacti       LIKE pmc_file.pmcacti
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
 
   LET g_errno = ''
   LET tok = base.StringTokenizer.createExt(g_rus11,"|",'',TRUE)
   WHILE tok.hasMoreTokens()
      LET l_ck = tok.nextToken()
      IF l_ck IS NULL THEN
         LET g_errno = 'art-358'
         RETURN
      END IF
      SELECT pmcacti INTO l_pmcacti FROM pmc_file
          WHERE pmc01 = l_ck
      IF SQLCA.sqlcode = 100  THEN
         LET g_errno = 'art-354'
         RETURN
      END IF
      IF l_pmcacti IS NULL OR l_pmcacti = 'N' THEN
         LET g_errno = 'art-355'
         RETURN
      END IF
   END WHILE
END FUNCTION
 
FUNCTION p210_rus13()
DEFINE l_imaacti     LIKE ima_file.imaacti
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
 
   LET g_errno = ''
   LET tok = base.StringTokenizer.createExt(g_rus13,"|",'',TRUE)
   WHILE tok.hasMoreTokens()
      LET l_ck = tok.nextToken()
      IF l_ck IS NULL THEN
         LET g_errno = 'art-358'
         RETURN
      END IF
      SELECT imaacti INTO l_imaacti FROM ima_file WHERE ima01 = l_ck
      IF SQLCA.sqlcode = 100  THEN
         LET g_errno = 'art-374'
         RETURN
      END IF
      IF l_imaacti = 'N' THEN
         LET g_errno = 'art-375'
         RETURN
      END IF
   END WHILE
END FUNCTION
 
FUNCTION p210_rusplant()
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_azp01         LIKE azp_file.azp01
 
        LET g_errno = ''
        LET tok = base.StringTokenizer.createExt(g_rusplant,"|",'',TRUE)
        WHILE tok.hasMoreTokens()
           LET l_ck = tok.nextToken()
           IF l_ck IS NULL THEN CONTINUE WHILE END IF
           SELECT azp01 INTO l_azp01
             FROM azp_file WHERE azp01 = l_ck
           IF SQLCA.sqlcode = 100 THEN
              LET g_errno = 'art-044'
              RETURN
           END IF
       END WHILE
 
END FUNCTION
#NO.FUN-960130-----------end---------------------- 

#TQC-AB0323
