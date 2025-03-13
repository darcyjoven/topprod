# Prog. Version..: '5.30.06-13.03.12(00004)'     #
# Pattern name...: aglp009.4gl
# Descriptions...: 現金流量表直接法资料导入
# Date & Author..: 2010/11/12 By wuxj  
# Modify.........: NO.FUN-B40104 11/05/05 By jll 报表合并作业
# Modify.........: NO.TQC-B60373 11/06/30 By yinhy 錯誤碼'agl034'改為'agl-262'
# Modify.........: No.FUN-B70003 11/07/08 By lutingting 1.根據agli019設置的現金變動碼對應關係產生資料,依據合併后現金變動碼合併
#                                                       2.匯率按照agli019的設置取,aglp009畫面拿掉匯率取值方式
# Modify.........: NO.MOD-BB0262 11/11/23 By xuxz 註釋中版本號修改
# Modify.........: No.CHI-C80041 12/12/24 By bart 排除作廢

DATABASE ds

GLOBALS "../../config/top.global"
DEFINE tm  RECORD
              a       LIKE aep_file.aep01, 
              b       LIKE type_file.chr20,
              c       LIKE aaa_file.aaa01, 
              d       LIKE aep_file.aep02,
              y       LIKE aep_file.aep03, 
              m       LIKE aep_file.aep04
              ,e       LIKE type_file.chr1   #FUN-B70003
          END RECORD
DEFINE tm1 RECORD
              wc      LIKE type_file.chr1000
           END RECORD
DEFINE g_dept         DYNAMIC ARRAY OF RECORD
                      axa01      LIKE axa_file.axa01,  #族群代號
                      axa02      LIKE axa_file.axa02,  #合併個體
                      axa03      LIKE axa_file.axa03,  #合併個體帳別
                      aaw01     LIKE aaw_file.aaw01, #合併帳別
                      axz06      LIKE axz_file.axz06   #記帳幣別
                      END RECORD
DEFINE    g_before_input_done  LIKE type_file.num5 
DEFINE    p_cmd                LIKE type_file.chr1 
DEFINE    g_msg                LIKE type_file.chr1000 
DEFINE    g_success            LIKE type_file.chr1 
DEFINE    g_str                STRING
DEFINE    g_sql                STRING
DEFINE    g_aaa03              LIKE aaa_file.aaa03
DEFINE    g_dbs_gl             LIKE azp_file.azp03
DEFINE    g_dbs_axz03          LIKE azp_file.azp03
DEFINE    g_flag               LIKE type_file.chr1 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT          

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time


   IF cl_null(tm.c) THEN LET tm.c=g_aza.aza81 END IF

   CALL p009_tm()           

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION p009_tm()
   DEFINE li_chk_bookno  LIKE type_file.num5  
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_sw           LIKE type_file.chr1, 
          l_cmd          LIKE type_file.chr1000  
   DEFINE l_n            LIKE type_file.num5
   DEFINE l_axa02        LIKE axa_file.axa02
   DEFINE l_axa03        LIKE axa_file.axa03

   CALL s_dsmark(tm.c) 
   LET p_row = 4 LET p_col = 4
   OPEN WINDOW p009_w1 AT p_row,p_col
     WITH FORM "agl/42f/aglp009"  ATTRIBUTE (STYLE = g_win_style CLIPPED)                                     
   CALL cl_ui_init()
   CALL s_shwact(0,0,tm.c)                      
   CALL cl_set_comp_visible('d',FALSE)  
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.c                        
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","aaa_file",tm.c,"",SQLCA.sqlcode,"","sel aaa:",0)                            
   END IF
   INITIALIZE tm.* TO NULL                                                    

   #LET tm.e = '1'    #FUN-B70003
   WHILE TRUE

      #INPUT BY NAME tm.a,tm.b,tm.c,tm.d,tm.y,tm.m,tm.e WITHOUT DEFAULTS   #FUN-B70003
      INPUT BY NAME tm.a,tm.b,tm.c,tm.d,tm.y,tm.m WITHOUT DEFAULTS         #FUN-B70003
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()              
 
         BEFORE INPUT
            CALL cl_set_comp_entry("b,c",FALSE)
            #LET tm.e = '1'    #FUN-B70003
            CALL cl_qbe_init()

         AFTER FIELD y
            IF NOT cl_null(tm.y) THEN
               IF tm.y = 0 THEN
                 NEXT FIELD y
               END IF
            END IF

 
         AFTER FIELD m
            IF NOT cl_null(tm.m) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                WHERE azm01 = tm.y
               IF g_azm.azm02 = '1' THEN
                  IF tm.m > 12 OR tm.m < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD m
                  END IF
               ELSE
                  IF tm.m > 13 OR tm.m < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD m
                  END IF
               END IF
            END IF
 
         AFTER FIELD a
            IF NOT cl_null(tm.a) THEN
               SELECT COUNT(*) INTO l_n FROM axa_file WHERE axa01 = tm.a AND axa04 = 'Y'
               IF l_n = 0 THEN
                  CALL cl_err(tm.a,100,0)
                  NEXT FIELD a
               END IF
               SELECT axa02,axa03 INTO l_axa02,l_axa03 FROM axa_file WHERE axa01 = tm.a AND axa04 = 'Y'
               LET tm.b = l_axa02
               LET tm.c = l_axa03
               DISPLAY l_axa02 TO FORMONLY.b
               DISPLAY l_axa03 TO FORMONLY.c
            ELSE
               NEXT FIELD a
            END IF
 
         AFTER FIELD d
           IF NOT cl_null(tm.d) THEN
              SELECT COUNT(*) INTO l_n FROM axz_file WHERE axz01 = tm.d
              IF l_n = 0 THEN
                 #CALL cl_err(tm.d,'agl034',0)  #No.TQC-B60373
                 CALL cl_err(tm.d,'agl-262',0)  #No.TQC-B60373
                 NEXT FIELD d
              END IF
           END IF

         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
 
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(a)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_axa1"
                  LET g_qryparam.default1 = tm.a
                  CALL cl_create_qry() RETURNING tm.a
                  DISPLAY tm.a TO a
                  NEXT FIELD a
               WHEN INFIELD(d)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_axz1"
                  LET g_qryparam.default1 = tm.d
                  CALL cl_create_qry() RETURNING tm.d
                  DISPLAY tm.d TO d
                  NEXT FIELD d
            END CASE
         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION qbe_save
            CALL cl_qbe_save()

      END INPUT

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p009_w1
         CALL cl_used(g_prog,g_time,2) RETURNING g_time   
         EXIT PROGRAM
      END IF

      CONSTRUCT BY NAME tm1.wc ON axz01 

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
        CASE
            WHEN INFIELD(axz01) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_axz"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO axz01
               NEXT FIELD axz01   
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

      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT CONSTRUCT

      ON ACTION qbe_select
         CALL cl_qbe_select()

     END CONSTRUCT
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p009_w1
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
     END IF
      CALL p009()
      IF g_success = 'Y' THEN
         CALL cl_end2(1) RETURNING g_flag
      ELSE
         CALL cl_end2(2) RETURNING g_flag
      END IF
      IF g_flag THEN
         CONTINUE WHILE
      ELSE
         CLOSE WINDOW p009_w1
         EXIT WHILE
      END IF
   END WHILE
   CLOSE WINDOW p009_w1
END FUNCTION

FUNCTION p009()
DEFINE l_sql     STRING                    
DEFINE l_aep     RECORD LIKE aep_file.*
DEFINE sr        RECORD
       tib08     LIKE tib_file.tib08,
       tib09     LIKE tib_file.tib09,
       abb37     LIKE abb_file.abb37,
       tib05     LIKE tib_file.tib05,
       nml03     LIKE nml_file.nml03 
                 END RECORD
DEFINE l_axz01   LIKE axz_file.axz01
DEFINE l_azj02   LIKE azj_file.azj02
DEFINE l_azk02   LIKE azk_file.azk02
DEFINE l_flag    LIKE type_file.chr1
DEFINE g_no      LIKE type_file.num5  
DEFINE i         LIKE type_file.num5 
DEFINE l_axz03   LIKE axz_file.axz03
DEFINE l_tib05   LIKE tib_file.tib05 
DEFINE l_cnt     LIKE type_file.num5 
DEFINE l_tib08   LIKE tib_file.tib08 
DEFINE l_abb37   LIKE abb_file.abb37
#FUN-B70003--add--str--
DEFINE l_aess    RECORD
       aess06    LIKE aess_file.aess06,   #合併后現金變動碼
       aes02     LIKE aes_file.aes02,     #說明
       aes03     LIKE aes_file.aes03,     #變動分類
       aess07    LIKE aess_file.aess07,   #再衡量匯率類型
       aess08    LIKE aess_file.aess08    #換算匯率類型
                 END RECORD
#FUN-B70003--add--end

   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.c
   SELECT azi04 INTO t_azi04
     FROM azi_file WHERE azi01 = g_aaa03

    LET g_no = 1
    FOR g_no = 1 TO 300
        INITIALIZE g_dept[g_no].* TO NULL
    END FOR

    LET l_sql = "SELECT axz01 ",
                "  FROM axz_file",
                " WHERE ",tm1.wc CLIPPED
    PREPARE p009_axz_p FROM l_sql
    DECLARE p009_axz_c CURSOR FOR p009_axz_p
    LET g_no = 1
    FOREACH p009_axz_c INTO l_axz01
        LET l_sql=" SELECT UNIQUE axa01,axa02,axa03",
                  "   FROM axa_file ",
                  "  WHERE axa01='",tm.a,"'",
                  "    AND axa02 = '",l_axz01,"'",  
                  "  UNION ",
                  " SELECT UNIQUE axa01,axb04,axb05",
                  "   FROM axb_file,axa_file ",
                  "  WHERE axa01=axb01 AND axa02=axb02",
                  "    AND axa01='",tm.a,"'",
                  "    AND axb04 = '",l_axz01,"'", 
                  "  ORDER BY 1,2 "
        PREPARE p009_axa_p FROM l_sql
        IF STATUS THEN
           CALL cl_err('prepare:1',STATUS,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time
           EXIT PROGRAM
        END IF
        DECLARE p009_axa_c CURSOR FOR p009_axa_p
        FOREACH p009_axa_c INTO g_dept[g_no].*
           #合併帳別
           CALL s_aaz641_dbs(g_dept[g_no].axa01,g_dept[g_no].axa02)
           RETURNING g_dbs_axz03
           CALL s_get_aaz641(g_dbs_axz03) RETURNING g_dept[g_no].aaw01
           DELETE FROM aep_file WHERE aep01 = g_dept[g_no].axa01 AND aep02 = g_dept[g_no].axa02 
                                  AND aep03 = tm.y AND aep04 = tm.m 
           LET g_no=g_no+1
        END FOREACH
    END FOREACH
    LET g_no=g_no-1
    BEGIN WORK 
    LET g_success = 'Y'
    FOR i = 1 TO g_no

       SELECT axz03 INTO l_axz03 FROM axz_file WHERE axz01=g_dept[i].axa02
       SELECT azp03 INTO g_dbs_new FROM azp_file WHERE azp01 = l_axz03
       IF STATUS THEN LET g_dbs_new = NULL END IF
       IF NOT cl_null(g_dbs_new) THEN
          LET g_dbs_new=g_dbs_new CLIPPED,'.'
       END IF
       LET g_dbs_gl = g_dbs_new CLIPPED
       LET l_aep.aep02 = g_dept[i].axa02  
       #合併帳別
       CALL s_aaz641_dbs(g_dept[i].axa01,g_dept[i].axa02)
       RETURNING g_dbs_axz03
       CALL s_get_aaz641(g_dbs_axz03) RETURNING g_dept[i].aaw01
       LET l_sql = "SELECT SUM(tic07),tic06,tic08,tic03,nml03",
                   "  FROM ",cl_get_target_table(l_axz03,'tic_file,'),
                             cl_get_target_table(l_axz03,'nml_file'),
                   " WHERE tic00 = '",g_dept[i].axa03,"'",
                   "   AND nml01 = tic06 ",
                   "   AND tic01 = '",tm.y,"' AND tic02 = '",tm.m,"'",
                   " GROUP BY tic06,tic08,tic03,nml03"        
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       CALL cl_parse_qry_sql(l_sql,l_axz03) RETURNING l_sql  #FUN-B40104
      PREPARE tia_pre FROM l_sql
      DECLARE tia_cs CURSOR FOR tia_pre
      LET l_aep.aep01 = tm.a
      LET l_aep.aep03 = tm.y
      LET l_aep.aep04 = tm.m
#FUN-B70003--mod--str--
#     IF g_aza.aza04 = 'Y' THEN
#        SELECT axz06,axz07 INTO l_aep.aep07,l_aep.aep14
#          FROM axz_file,axa_file WHERE axz01 = axa02 AND axa01 = tm.a 
#     END IF
      LET l_aep.aep07 = g_aaa03
#FUN-B70003--mod--end
      SELECT axz06,axz07 INTO l_aep.aep10,l_aep.aep14   #FUN-B70003 add aep14
        FROM axz_file WHERE axz01 = l_aep.aep02
      LET l_aep.aep11 = '1'  

      FOREACH tia_cs INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         LET l_aep.aep05 = sr.tib09
         #FUN-B70003--add--str--
         SELECT aess06,aes02,aes03,aess07,aess08 INTO l_aess.*
           FROM aess_file,aes_file
          WHERE aess06 = aes01 AND aess02 = l_aep.aep01 AND aess01 = l_aep.aep02
            AND aess03 = sr.tib09
         IF NOT cl_null(l_aess.aess06) THEN LET l_aep.aep05 = l_aess.aess06 END IF 
         LET l_aep.aep16 = l_aess.aes02
         LET l_aep.aep17 = l_aess.aes03 
         #FUN-B70003--add--end
         LET l_aep.aep09 = sr.tib08
         IF sr.tib05 = '1' THEN
            LET l_tib05 = '2'
         ELSE
            LET l_tib05 = '1'
         END IF 
         IF cl_null(sr.abb37) THEN
            LET l_abb37='XXX'
         ELSE
            LET l_abb37= sr.abb37
         END IF 
         SELECT COUNT(*) INTO l_cnt FROM aep_file
          WHERE aep01 = l_aep.aep01 AND aep02 = l_aep.aep02
            AND aep03 = l_aep.aep03 AND aep04 = l_aep.aep04
            AND aep05 = sr.tib09 AND aep12 = l_abb37 
         IF l_cnt>0 THEN
            CONTINUE FOREACH
         END IF 
         LET l_sql = "SELECT SUM(tib08) ", 
                  "  FROM ",cl_get_target_table(l_axz03,'tia_file,'),   #FUN-B40104
                            cl_get_target_table(l_axz03,'tib_file,'),   #FUN-B40104
                            cl_get_target_table(l_axz03,'aba_file,'),   #FUN-B40104
                            cl_get_target_table(l_axz03,'abb_file'),   #FUN-B40104
                     
                  "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                  "   AND tia01 = tib01 AND tia02 = tib02 ",
                  "   AND tia05 = tib03 AND tia07 = tib05 ",
                  "   AND tia06 = tib04 ",
                  "   AND aba00 = tia05 AND tia05 = '",g_dept[i].axa03,"' ",
                  "   AND abb03 = tia06 ",
                  "   AND abb01 = tib06 ",
                  "   AND abb02 =tib07 ",
                  "   AND aba19 <> 'X' ",  #CHI-C80041
                  "   AND aba03 = '",tm.y,"' AND aba04 = '",tm.m,"'",
                  "   AND tib05 = '",l_tib05,"' AND abb37 = '",sr.abb37,"' and tib09 = '",sr.tib09,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_axz03) RETURNING l_sql  #FUN-B40104
         PREPARE sel_tib08 FROM l_sql
         EXECUTE sel_tib08 INTO l_tib08 
         IF cl_null(l_tib08) THEN LET l_tib08 = 0 END IF 
         IF sr.nml03 = '10' OR sr.nml03 = '20'  OR sr.nml03 = '30' OR sr.nml03 = '40' THEN   #借-贷
            IF l_tib05 = '1' THEN
               LET l_aep.aep09 = l_tib08-sr.tib08
            ELSE
               LET l_aep.aep09 = sr.tib08-l_tib08
            END IF 
         END IF 
         IF sr.nml03 = '11' or sr.nml03 = '21' OR sr.nml03 = '31' THEN   #贷-借
            IF l_tib05 = '1' THEN
               LET l_aep.aep09 = sr.tib08-l_tib08
            ELSE
               LET l_aep.aep09 = l_tib08-sr.tib08
            END IF
         END IF 
        #FUN-B70003--mod--str--
        #IF l_aep.aep07<>g_aaa03 THEN   ###個體公司幣別和合併幣別不相同    #
        #   CASE tm.e  
         IF l_aep.aep10<>g_aaa03 THEN   ###個體公司幣記賬別和合併幣別不相同    #
            CASE l_aess.aess07
        #FUN-B70003--mod--end
              WHEN 1
                 SELECT axp05 INTO l_aep.aep08 FROM axp_file WHERE axp01 = l_aep.aep03
                    AND axp02 = l_aep.aep04 AND axp03 = l_aep.aep10 AND axp04 = l_aep.aep14
              WHEN 2
                 SELECT axp06 INTO l_aep.aep08 FROM axp_file WHERE axp01 = l_aep.aep03
                    AND axp02 = l_aep.aep04 AND axp03 = l_aep.aep10 AND axp04 = l_aep.aep14
              WHEN 3
                 SELECT axp07 INTO l_aep.aep08 FROM axp_file WHERE axp01 = l_aep.aep03
                    AND axp02 = l_aep.aep04 AND axp03 = l_aep.aep10 AND axp04 = l_aep.aep14
              OTHERWISE
            END CASE
         ELSE
            LET l_aep.aep08 = 1
         END IF 
         IF l_aep.aep14<>g_aaa03 THEN   ###個體功能幣別和合併幣別不相同
        #   CASE tm.e               #FUN-B70003
            CASE l_aess.aess08      #FUN-B70003
              WHEN 1
                 SELECT axp05 INTO l_aep.aep15 FROM axp_file WHERE axp01 = l_aep.aep03
                    #AND axp02 = l_aep.aep04 AND axp03 = l_aep.aep07 AND axp04 = l_aep.aep14   #FUN-B70003
                    AND axp02 = l_aep.aep04 AND axp03 = l_aep.aep14 AND axp04 = l_aep.aep07
              WHEN 2
                 SELECT axp06 INTO l_aep.aep15 FROM axp_file WHERE axp01 = l_aep.aep03
                    #AND axp02 = l_aep.aep04 AND axp03 = l_aep.aep07 AND axp04 = l_aep.aep14   #FUN-B70003
                    AND axp02 = l_aep.aep04 AND axp03 = l_aep.aep14 AND axp04 = l_aep.aep07
              WHEN 3
                 SELECT axp07 INTO l_aep.aep15 FROM axp_file WHERE axp01 = l_aep.aep03
                    #AND axp02 = l_aep.aep04 AND axp03 = l_aep.aep07 AND axp04 = l_aep.aep14   #FUN-B70003
                    AND axp02 = l_aep.aep04 AND axp03 = l_aep.aep14 AND axp04 = l_aep.aep07
              OTHERWISE
            END CASE
         ELSE
            LET l_aep.aep15 = 1
         END IF
         IF cl_null(l_aep.aep08) THEN LET l_aep.aep08 = 1 END IF
         IF cl_null(l_aep.aep15) THEN LET l_aep.aep15 = 1 END IF #FUN-B70003
         LET l_aep.aep13 = l_aep.aep09*l_aep.aep08
         LET l_aep.aep06 = l_aep.aep13*l_aep.aep15
         #LET l_aep.aep06 = l_aep.aep09 * l_aep.aep08 
         LET l_aep.aep09 = cl_digcut(l_aep.aep09,t_azi04)
         LET l_aep.aep06 = cl_digcut(l_aep.aep06,t_azi04)
         LET l_aep.aep13 = cl_digcut(l_aep.aep13,t_azi04)
         LET l_aep.aep12 = sr.abb37  
         IF cl_null(l_aep.aep12) THEN LET l_aep.aep12 = 'XXX' END IF 
         IF cl_null(l_aep.aep05) THEN LET l_aep.aep05 = ' ' END IF
         LET l_aep.aeplegal=g_legal        #NO.FUN-B40104  #所属法人

         
         INSERT INTO aep_file VALUES(l_aep.*)
#FUN-B70003--add--str--
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
            UPDATE aep_file SET aep09 = aep09+l_aep.aep09,
                                aep13 = aep13+l_aep.aep13,
                                aep06 = aep06+l_aep.aep06
             WHERE aep01 = l_aep.aep01
               AND aep02 = l_aep.aep02
               AND aep03 = l_aep.aep03
               AND aep04 = l_aep.aep04
               AND aep05 = l_aep.aep05
               AND aep12 = l_aep.aep12
#FUN-B70003--add--end
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('aep01',l_aep.aep01,'upd_aep',STATUS,1)  
               LET g_success = 'N' 
               CONTINUE FOREACH
            END IF
         END IF 
         LET l_flag = 'Y'
      END FOREACH     
   END FOR
   CALL s_showmsg()  
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      IF l_flag = 'Y' THEN 
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF   
   END IF
END FUNCTION
#NO.FUN-B40104
#MOD-BB0262
