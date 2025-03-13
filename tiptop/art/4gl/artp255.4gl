# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: artp255.4gl
# Descriptions...: 調撥差異調整批處理
# Date & Author..: NO.FUN-AA0023 10/10/29 By lixia 
# Modify.........: No.TQC-AC0382 10/12/29 By lixia 調撥調整修改
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.TQC-BA0150 11/11/09 By pauline 放大num(申請量與核准量之差)欄位大小
# Modify.........: No.FUN-BA0105 11/10/28 By pauline 修改背景處理寫法
# Modify.........: No.TQC-C20145 12/02/13 By yangxf 調撥單中的撥出營運中心為調撥差異調整單的撥入營運中心,
#                                                   調撥單中的撥入營運中心為調撥差異調整單的撥出營運中心.
# Modify.........: No:FUN-C90050 12/10/24 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ruo             RECORD LIKE ruo_file.*,
       g_ruo_t           RECORD LIKE ruo_file.*
DEFINE g_ruo01       	 STRING
DEFINE g_ruoplant        STRING
DEFINE p_row,p_col       LIKE type_file.num5
DEFINE g_cnt             LIKE type_file.num10
DEFINE g_i               LIKE type_file.num5
DEFINE g_flag            LIKE type_file.chr1
DEFINE g_msg             LIKE type_file.chr1000
DEFINE g_change_lang     LIKE type_file.chr1000
DEFINE l_ac              LIKE type_file.num5
DEFINE g_sql             STRING
DEFINE l_flag            LIKE type_file.chr1
DEFINE g_chk_plant       STRING
DEFINE g_chk_ruo01       STRING

MAIN   
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_ruoplant = ARG_VAL(1) 
   LET g_ruo01 = ARG_VAL(2) 
   LET g_bgjob = ARG_VAL(3)                      
   IF g_bgjob IS NULL THEN
      LET g_bgjob='N'
   END IF
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET p_row = 5 LET p_col = 28
#FUN-BA0105 mark START 
#   OPEN WINDOW p255_w AT p_row,p_col WITH FORM "art/42f/artp255"
#     ATTRIBUTE (STYLE = g_win_style)
 
#   CALL cl_ui_init()
#FUN-BA0105 mark END
   CALL cl_opmsg('z')
 
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p255_p1()
         IF cl_sure(18,20) THEN 
            BEGIN WORK
            LET g_success = 'Y'
            CALL s_showmsg_init()
            CALL p255_p2()
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
               CLOSE WINDOW p255_w
               EXIT WHILE
            END IF 
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p255_w
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL p255_p2()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p255_p1()
DEFINE li_result       LIKE type_file.num5
DEFINE l_n             LIKE type_file.num5
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_sql           STRING
DEFINE l_value         STRING
DEFINE l_azw01         LIKE azw_file.azw01
DEFINE lc_cmd          LIKE type_file.chr1000
#FUN-BA0105 add START
   OPEN WINDOW p255_w AT p_row,p_col WITH FORM "art/42f/artp255"
     ATTRIBUTE (STYLE = g_win_style)

   CALL cl_ui_init()
#FUN-BA0105 add END 
  WHILE TRUE
      CLEAR FORM
 
     INPUT g_ruoplant,g_ruo01  WITHOUT DEFAULTS
        FROM ruoplant,ruo01
 
         BEFORE INPUT
            CALL cl_qbe_init()
 
         AFTER FIELD ruoplant
            LET g_chk_plant = ''
            IF NOT cl_null(g_ruoplant) AND g_ruoplant <> "*" THEN
               IF g_ruoplant IS NOT NULL THEN
                  CALL p255_ruoplant() RETURNING l_value
                  IF NOT cl_null(g_errno)  THEN
                     CALL cl_err(l_value,g_errno,0)
                     NEXT FIELD ruoplant                 
                  END IF                  
               END IF
               LET g_chk_plant = cl_replace_str(g_ruoplant,'|',",")            
            ELSE
               DECLARE p255_azw_cs  CURSOR FOR SELECT azw01 FROM azw_file WHERE azw01 = g_plant OR azw07 = g_plant
               FOREACH p255_azw_cs  INTO l_azw01
                 IF g_chk_plant IS NULL THEN
                    LET g_chk_plant = l_azw01
                 ELSE
                    LET g_chk_plant = g_chk_plant,",",l_azw01
                 END IF
               END FOREACH              
            END IF 

        BEFORE FIELD ruo01
           IF cl_null(g_ruoplant) THEN
              CALL cl_err('','atm-520',0)
              NEXT FIELD ruoplant
           END IF      

         AFTER FIELD ruo01
            IF NOT cl_null(g_ruo01) AND g_ruo01 <> "*" THEN
               IF g_ruo01 IS NOT NULL THEN
                  CALL p255_ruo01() RETURNING l_value
                  IF NOT cl_null(g_errno)  THEN
                     CALL cl_err(l_value,g_errno,0)
                     NEXT FIELD ruo01                 
                  END IF                  
               END IF
               LET g_chk_ruo01 = cl_replace_str(g_ruo01,'|',"','")
               LET g_chk_ruo01 = "('",g_chk_ruo01,"')"                             
            END IF              
 
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(ruoplant)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azw01_2"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = g_plant
                  LET g_qryparam.default1 = g_ruoplant
                  CALL cl_create_qry() RETURNING g_ruoplant
                  DISPLAY g_ruoplant TO ruoplant
                  NEXT FIELD ruoplant

               WHEN INFIELD(ruo01)
                  CALL q_ruo(TRUE,TRUE,'',g_chk_plant,'') RETURNING g_ruo01                  
                  DISPLAY g_ruo01 TO ruo01
                  NEXT FIELD ruo01   
            END CASE
 
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
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p255_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

      LET g_bgjob = 'N'
      INPUT BY NAME g_bgjob WITHOUT DEFAULTS
        ON ACTION about
           CALL cl_about()
        ON ACTION help
           CALL cl_show_help()
        ON ACTION controlp
           CALL cl_cmdask()
        ON ACTION exit
           LET INT_FLAG=1
           EXIT INPUT
        ON ACTION qbe_save
           CALL cl_qbe_save()
        ON ACTION locale
           LET g_change_lang=TRUE
           EXIT INPUT
      END INPUT
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p255_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
      END IF
      EXIT WHILE
  END WHILE
  
  IF g_bgjob = "Y" THEN
     SELECT zz08 INTO lc_cmd FROM zz_file
      WHERE zz01 = "artp255"
     IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
        CALL cl_err('artp255','9031',1)
     ELSE
        LET lc_cmd = lc_cmd CLIPPED,
                     " '",g_ruoplant CLIPPED,"'",
                     " '",g_ruo01 CLIPPED,"'",
                     " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('artp255',g_time,lc_cmd CLIPPED)
     END IF
     CLOSE WINDOW p105_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
     EXIT PROGRAM
  END IF
 
END FUNCTION
 
FUNCTION p255_ruoplant()     #管控營運中心
   DEFINE l_ck            LIKE type_file.chr50
   DEFINE tok             base.StringTokenizer
   DEFINE l_cnt           LIKE type_file.num5
   DEFINE l_plant         LIKE azw_file.azw01
   DEFINE l_value         STRING
 
   LET g_errno = ''
   LET l_value = ''
   LET tok = base.StringTokenizer.createExt(g_ruoplant,"|",'',TRUE)
   WHILE tok.hasMoreTokens()
      LET l_plant = tok.nextToken()
      IF l_plant IS NULL THEN CONTINUE WHILE END IF
      IF l_plant <> g_plant THEN 
         SELECT COUNT(*) INTO l_cnt FROM azw_file 
          WHERE azw07 = g_plant AND azw01 = l_plant
         IF l_cnt = 0 THEN
            LET g_errno = 'art-500'
            IF cl_null(l_value) THEN
              LET l_value = l_plant
            ELSE
              LET l_value = l_value||'|'||l_plant
            END IF
         END IF
      END IF   
   END WHILE 
   RETURN l_value
END FUNCTION

FUNCTION p255_ruo01()   #管控調撥單號
   DEFINE l_ruo01         LIKE ruo_file.ruo01
   DEFINE tok             base.StringTokenizer
   DEFINE l_n             LIKE type_file.num5
   DEFINE l_value         STRING
   
   LET g_errno = ''
   LET l_value = ''   
   SELECT ruo01,ruo04,ruo05,ruoplant FROM ruo_file WHERE 1=0 INTO TEMP ruo002_temp
   DELETE FROM ruo002_temp
   CALL p255_getruo01()
   LET tok = base.StringTokenizer.createExt(g_ruo01,"|",'',TRUE)
   WHILE tok.hasMoreTokens()
      LET l_ruo01 = tok.nextToken()
      IF l_ruo01 IS NULL THEN CONTINUE WHILE END IF
      SELECT COUNT(*) INTO l_n  FROM ruo002_temp WHERE ruo01 =  l_ruo01  
      IF l_n IS NULL THEN LET l_n = 0 END IF
      IF l_n = 0 THEN
         LET g_errno = 'art-990'
         IF cl_null(l_value) THEN
            LET l_value = l_ruo01
         ELSE
            LET l_value = l_value||'|'||l_ruo01
         END IF
      END IF
   END WHILE 
   DROP TABLE ruo002_temp  
   RETURN l_value
END FUNCTION

FUNCTION p255_getruo01()  #獲取營運中心下所有的單號
   DEFINE l_ruo04         LIKE ruo_file.ruo04
   DEFINE tok             base.StringTokenizer
   DEFINE l_sql           STRING
   
   LET tok = base.StringTokenizer.createExt(g_chk_plant,",",'',TRUE)   
   WHILE tok.hasMoreTokens()
      LET l_ruo04 = tok.nextToken()
      IF l_ruo04 IS NULL THEN CONTINUE WHILE END IF
      LET l_sql =  " INSERT INTO ruo002_temp SELECT ruo01,ruo04,ruo05,ruoplant ",                         
                   "   FROM ",cl_get_target_table(l_ruo04,'ruo_file'), 
                   "  WHERE  ruoconf = '2'",
                   "    AND  ruo04 = '",l_ruo04,"'",
                   "    AND  ruo02<>'4' " 
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
      CALL cl_parse_qry_sql(l_sql,l_ruo04) RETURNING l_sql       
      PREPARE pre_ruo01 FROM l_sql
      EXECUTE pre_ruo01 
   END WHILE 
END FUNCTION
 
FUNCTION p255_p2()
   DEFINE l_ruo01_t    LIKE ruo_file.ruo01
   DEFINE l_ruo04_t    LIKE ruo_file.ruo04
   DEFINE l_sql        STRING
   DEFINE l_cnt        LIKE type_file.num5
   DEFINE l_no         LIKE oay_file.oayslip
   DEFINE tok          base.StringTokenizer
   DEFINE sr           RECORD
                       ruo01    LIKE ruo_file.ruo01,
                       ruo011   LIKE ruo_file.ruo011,
                       ruo02    LIKE ruo_file.ruo02,
                       ruo03    LIKE ruo_file.ruo03,
                       ruoplant LIKE ruo_file.ruoplant,
                       ruo04    LIKE ruo_file.ruo04,                        
                       ruo05    LIKE ruo_file.ruo05,
                       ruo14    LIKE ruo_file.ruo14,
                       ruo15    LIKE ruo_file.ruo15,
                       ruo99    LIKE ruo_file.ruo99,
                       ruo904   LIKE ruo_file.ruo904,
                       rup02    LIKE rup_file.rup02,
                       rup03    LIKE rup_file.rup03,                      
                       rup06    LIKE rup_file.rup06,
                       rup07    LIKE rup_file.rup07,
                       rup08    LIKE rup_file.rup08,
                   #    num      LIKE type_file.num5          #TQC-BA0150 mark            
                       num      LIKE rvr_file.rvr09           #TQC-BA0150 add
                       END RECORD
   DEFINE l_rvq        RECORD LIKE rvq_file.*
   DEFINE l_rvr        RECORD LIKE rvr_file.*
   DEFINE l_wc         STRING
   DEFINE l_azw01      LIKE azw_file.azw01

   IF cl_null(g_ruo01) OR g_ruo01 = "*" THEN
      LET l_wc = " 1=1 "
   ELSE
      LET l_wc = " ruo01 IN ",g_chk_ruo01
   END IF

   IF cl_null(g_ruoplant) AND g_ruoplant <> "*" THEN
      DECLARE p255_azw_cs1  CURSOR FOR SELECT azw01 FROM azw_file
      FOREACH p255_azw_cs1  INTO l_azw01
         IF g_chk_plant IS NULL THEN
            LET g_chk_plant = l_azw01
         ELSE
            LET g_chk_plant = g_chk_plant,",",l_azw01
         END IF
      END FOREACH       
   END IF
   
   LET g_success = 'Y'
   LET tok = base.StringTokenizer.createExt(g_chk_plant,",",'',TRUE)   
   WHILE tok.hasMoreTokens()
      LET l_ruo04_t = tok.nextToken()
      IF l_ruo04_t IS NULL THEN CONTINUE WHILE END IF
      #LET l_sql =  " SELECT ruo01,ruo02,ruo03,ruoplant,ruo04,ruo05,ruo14,ruo15,ruo99,ruo904,  #TQC-AC0382
      LET l_sql =  " SELECT ruo01,ruo011,ruo02,ruo03,ruoplant,ruo04,ruo05,ruo14,ruo15,ruo99,ruo904,
                            rup02,rup03,rup06,rup07,rup08,rup12-rup16 ",
                   "   FROM ",cl_get_target_table(l_ruo04_t,'ruo_file'),",",
                              cl_get_target_table(l_ruo04_t,'rup_file'),
                   "  WHERE ruo01=rup01 AND ruoplant=rupplant AND ruoplant=ruo04  ",
                   "    AND ruoconf='2' AND rup12-rup16>0 ",
                   "    AND ruoplant = '",l_ruo04_t,"'",
                   "    AND ",l_wc,
                   "    AND  ruo02<>'4' ",
                   "  ORDER BY ruo01,ruoplant"      
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  
      CALL cl_parse_qry_sql(l_sql,l_ruo04_t) RETURNING l_sql          
      PREPARE pre_sel_ruo01 FROM l_sql
      DECLARE p255_ruo_cs2 CURSOR FOR pre_sel_ruo01 
      LET l_ruo01_t = ''
      FOREACH p255_ruo_cs2 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach p255_ruo_cs2:',SQLCA.sqlcode,0)
            LET g_success = 'N'
            EXIT FOREACH
         END IF

         IF cl_null(l_ruo01_t) OR sr.ruo01 <> l_ruo01_t THEN     #插入單頭
            #撥入撥出存在上下級關係
            SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = sr.ruo05 AND azw07 = sr.ruo04  #撥出是撥入的上級
            IF l_cnt>0 THEN
               LET l_rvq.rvqplant = sr.ruo04 
            ELSE
               SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = sr.ruo04 AND azw07 = sr.ruo05 #拨入是拨出的上级
               IF l_cnt>0 THEN 
                  LET l_rvq.rvqplant = sr.ruo05 
               END IF
            END IF
            #撥入撥出無上下級關係
            IF cl_null(l_rvq.rvqplant) THEN 
               SELECT azw07 INTO l_rvq.rvqplant FROM azw_file WHERE azw01 = sr.ruo04  #抓拨出营运中心的上级营运中心
            END IF 
            IF cl_null(l_rvq.rvqplant) THEN 
               LET l_rvq.rvqplant = sr.ruo04　#拨出营运中心为最上层
            END IF
            SELECT azw02 INTO l_rvq.rvqlegal FROM azw_file WHERE azw01 = l_rvq.rvqplant   #法人
         
            LET l_rvq.rvq00 = '2'

            #自动编号 
            #LET l_no = s_get_doc_no(sr.ruo01)  #取出單別
            #FUN-C90050 mark begin---
            #LET l_sql = "SELECT rye03 FROM ",cl_get_target_table(l_rvq.rvqplant,'rye_file'),
            #            " WHERE rye01 = 'art' AND rye02 = 'C5'",
            #CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            #CALL cl_parse_qry_sql(l_sql,l_rvq.rvqplant) RETURNING l_sql
            #PREPARE pre_sel_rye1 FROM l_sql
            #EXECUTE pre_sel_rye1 INTO l_no
            #FUN-C90050 mark end-----

            CALL s_get_defslip('art','C5',l_rvq.rvqplant,'N') RETURNING l_no     #FUN-C90050 add

            CALL s_auto_assign_no("art",l_no,g_today,"C5","rvq_file","rvq01,rvqplant",l_rvq.rvqplant,"","")
            RETURNING l_flag,l_rvq.rvq01 #自動生成新的申請單號 
            IF (NOT l_flag) THEN  
               LET g_success = 'N'
               CALL s_errmsg('rvq01',l_no,'','sub-145',1) 
               EXIT FOREACH
            END IF 
            
            IF sr.ruo02 = 'P' THEN										
               LET l_rvq.rvq02 = 'P'										
            ELSE										
               LET l_rvq.rvq02 = '1'										
            END IF										
            LET l_rvq.rvq03 = g_today										
            LET l_rvq.rvq04 = g_user										
            LET l_rvq.rvq05 = l_rvq.rvqplant										
            LET l_rvq.rvq06 = sr.ruo01	
#TQC-C20145 MARK begin ----
#            LET l_sql = "SELECT imd20 FROM ",cl_get_target_table(sr.ruo04,'imd_file'),
#                        " WHERE imd01 = '",sr.ruo14,"'"
#            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
#            CALL cl_parse_qry_sql(l_sql,sr.ruo04) RETURNING l_sql
#            PREPARE pre_sel_imd FROM l_sql
#            EXECUTE pre_sel_imd INTO l_rvq.rvq07
#            IF SQLCA.sqlcode THEN
#               LET g_success = 'N'
#               CALL s_errmsg('imd20',sr.ruo14,'','art-438',1)
#               EXIT FOREACH
#            END IF
#TQC-C20145 MARK end -----
            LET l_rvq.rvq07 = sr.ruo04   #TQC-C20145 add 
#           LET l_rvq.rvq08 = sr.ruo04   #TQC-C20145 mark
            LET l_rvq.rvq08 = sr.ruo05   #TQC-C20145
            LET l_rvq.rvq10 = g_today										
            LET l_rvq.rvq10t = TIME										
            LET l_rvq.rvq11 = g_user										
            LET l_rvq.rvq12 = NULL
            LET l_rvq.rvq14 = sr.ruo01										
            LET l_rvq.rvq15 = sr.ruo14										
            LET l_rvq.rvq99 = sr.ruo99										
            LET l_rvq.rvq904 = sr.ruo904										
            LET l_rvq.rvqpos = 'Y'										
            LET l_rvq.rvqconf = '1'
            LET l_rvq.rvqplant = l_rvq.rvqplant 
            LET l_rvq.rvquser = g_user   
            LET l_rvq.rvqgrup = g_grup   
            LET l_rvq.rvqoriu = g_user   
            LET l_rvq.rvqorig = g_grup  
            LET l_rvq.rvqcrat = g_today  
            LET l_rvq.rvqacti = 'Y'       
            LET l_rvq.rvqdate = NULL
            LET l_sql = "INSERT INTO ", cl_get_target_table(l_rvq.rvqplant,'rvq_file'),
                        "(rvq00,rvq01,rvq02,rvq03,rvq04,rvq05,rvq06,rvq07,rvq08,rvq09,rvq10,
                          rvq10t,rvq11,rvq12,rvq12t,rvq13,rvq14,rvq15,rvq904,rvq99,
                          rvqacti,rvqconf,rvqcrat,rvqdate,rvqgrup,rvqlegal,rvqmodu,
                          rvqorig,rvqoriu,rvqplant,rvqpos,rvquser) ",
                        " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                                 ?,?,?,?,?, ?,?)  "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  
            CALL cl_parse_qry_sql(l_sql,l_rvq.rvqplant) RETURNING l_sql          
            PREPARE pre_sel_rvq01 FROM l_sql
            EXECUTE pre_sel_rvq01 USING l_rvq.rvq00,l_rvq.rvq01,l_rvq.rvq02,l_rvq.rvq03,l_rvq.rvq04,
                          l_rvq.rvq05,l_rvq.rvq06,l_rvq.rvq07,l_rvq.rvq08,l_rvq.rvq09,
                          l_rvq.rvq10,l_rvq.rvq10t,l_rvq.rvq11,l_rvq.rvq12,l_rvq.rvq12t,
                          l_rvq.rvq13,l_rvq.rvq14,l_rvq.rvq15,l_rvq.rvq904,
                          l_rvq.rvq99,l_rvq.rvqacti,l_rvq.rvqconf,l_rvq.rvqcrat,l_rvq.rvqdate,
                          l_rvq.rvqgrup,l_rvq.rvqlegal,l_rvq.rvqmodu,
                          l_rvq.rvqorig,l_rvq.rvqoriu,l_rvq.rvqplant,l_rvq.rvqpos,l_rvq.rvquser
            IF SQLCA.sqlerrd[3]=0 OR SQLCA.SQLCODE THEN
               LET g_success = 'N'
               CALL s_errmsg('rvqplant',l_rvq.rvqplant,'INSERT rvq_file',SQLCA.sqlcode,1)
               EXIT FOREACH            
            END IF
         END IF 
         
         #插入單身
         LET l_rvr.rvr00 = '2'
         LET l_rvr.rvr01 = l_rvq.rvq01
         IF cl_null(l_rvr.rvr02) THEN  #自動增1編號       
            LET l_rvr.rvr02 = '1'
         ELSE
            LET l_rvr.rvr02 = l_rvr.rvr02 + 1
         END IF
         LET l_rvr.rvr03 = sr.rup02										
         LET l_rvr.rvr04 = sr.rup03										
         LET l_rvr.rvr05 = sr.rup06										
         LET l_rvr.rvr06 = sr.rup07	
         LET l_rvr.rvr07 = sr.rup08         
         LET l_rvr.rvr08 = sr.num										
         LET l_rvr.rvr09 = sr.num										
         LET l_rvr.rvrplant = l_rvq.rvqplant										
         LET l_rvr.rvrlegal = l_rvq.rvqlegal										
         LET l_sql = " INSERT INTO ", cl_get_target_table(l_rvq.rvqplant,'rvr_file'),
                     "(rvr00,rvr01,rvr02,rvr03,rvr04,rvr05,rvr06,rvr07,rvr08,rvr09,
                       rvr10,rvr11,rvrlegal,rvrplant) ",
                     " VALUES (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  
         CALL cl_parse_qry_sql(l_sql,l_rvq.rvqplant) RETURNING l_sql          
         PREPARE pre_sel_rvr FROM l_sql
         EXECUTE pre_sel_rvr USING l_rvr.rvr00,l_rvr.rvr01,l_rvr.rvr02,l_rvr.rvr03,l_rvr.rvr04,
                                   l_rvr.rvr05,l_rvr.rvr06,l_rvr.rvr07,l_rvr.rvr08,l_rvr.rvr09,
                                   l_rvr.rvr10,l_rvr.rvr11,l_rvr.rvrlegal,l_rvr.rvrplant         
         IF SQLCA.sqlerrd[3]=0 OR SQLCA.SQLCODE THEN 
            LET g_success = 'N'
            CALL s_errmsg('rvrplant',l_rvq.rvqplant,'INSERT rvr_file',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF         
         IF g_success = 'Y' AND (cl_null(l_ruo01_t) OR sr.ruo01 <> l_ruo01_t) THEN#已产生差异调整申请单的拨出与拨入营运中心中的调拨单的状态由拨入审核变更为结案
            LET l_sql ="UPDATE ",cl_get_target_table(sr.ruo04,'ruo_file'),
                       "   SET ruoconf='3' ",
                       " WHERE ruo01 = '",sr.ruo01,"'",
                       "   AND ruoplant = '",sr.ruo04,"'"  
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  
            CALL cl_parse_qry_sql(l_sql,sr.ruo04) RETURNING l_sql          
            PREPARE pre_sel_ruo1 FROM l_sql
            EXECUTE pre_sel_ruo1          
            IF SQLCA.sqlerrd[3]=0 OR SQLCA.SQLCODE THEN 
               LET g_success = 'N'
               CALL s_errmsg('ruoplant',sr.ruo04,'UPDATE ruo_file',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF            
            IF sr.ruo02='1' THEN										
               LET l_sql ="UPDATE ",cl_get_target_table(sr.ruo05,'ruo_file'),
                          "   SET ruoconf='3' ",
                          #" WHERE ruo01 = '",sr.ruo01,"'",
                          " WHERE ruo01 = '",sr.ruo011,"'",   #TQC-AC0382
                          "   AND ruoplant = '",sr.ruo05,"'"   
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  
               CALL cl_parse_qry_sql(l_sql,sr.ruo05) RETURNING l_sql          
               PREPARE pre_sel_ruo2 FROM l_sql
               EXECUTE pre_sel_ruo2          
               IF SQLCA.sqlerrd[3]=0 OR SQLCA.SQLCODE THEN 
                  LET g_success = 'N'
                  CALL s_errmsg('ruoplant',sr.ruo05,'UPDATE ruo_file',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF           
            ELSE	
               LET l_sql ="UPDATE ",cl_get_target_table(sr.ruo05,'ruo_file'),
                          "   SET ruoconf='3' ",
                          " WHERE ruo03 = '",sr.ruo03,"'",
                          "   AND ruoplant = '",sr.ruo05,"'"  
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  
               CALL cl_parse_qry_sql(l_sql,sr.ruo05) RETURNING l_sql          
               PREPARE pre_sel_ruo3 FROM l_sql
               EXECUTE pre_sel_ruo3          
               IF SQLCA.sqlerrd[3]=0 OR SQLCA.SQLCODE THEN 
                  LET g_success = 'N'
                  CALL s_errmsg('ruoplant',sr.ruo05,'UPDATE ruo_file',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF                      
            END IF 
         END IF
         LET l_ruo01_t = sr.ruo01   
      END FOREACH
   END WHILE   
END FUNCTION
#FUN-AA0023---end---

