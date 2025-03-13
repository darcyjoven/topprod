# Prog. Version..: '5.30.06-13.03.28(00005)'     #
#
# Pattern name...: arti009_sub_dbs.4gl
# Descriptions...: 流通產品申請资料子料件批量抛转逻辑
#                  Note:本作業Copy與s_aimi100_carry中的FUNCTION i150_dbs（有做部份異動），
#                       用於arti009（流通產品申請作業）中子料件申請單批量拋轉時使用，
#                       若需需該本作業，請參照s_aimi100_carry中FUNCTION i150_dbs的邏輯。
# Date & Author..: FUN-BC0076 12/01/16 By baogc
# Modify.........: No:FUN-C50036 12/05/21 By yangxf 新增ima160字段，给预设值
# Modify.........: No:CHI-C50068 12/11/07 By bart  新增ima72
# Modify.........: No:CHI-CA0073 13/01/30 By pauline 將ima1015用ima1401替代
# Modify.........: No:FUN-D30006 13/03/04 By baogc 添加imaa1030

DATABASE ds
GLOBALS "../../config/top.global"
GLOBALS "../../aim/4gl/aimi100.global"
GLOBALS "../../sub/4gl/s_data_center.global"

DEFINE tm         DYNAMIC ARRAY of RECORD
                  sel    LIKE type_file.chr1,
                  azp01    LIKE azp_file.azp01,
                  azp02    LIKE azp_file.azp02,
                  azp03    LIKE azp_file.azp03,
                  plant    LIKE type_file.chr1000,
                  exist    LIKE type_file.chr1
                  END RECORD 
DEFINE g_imaa     RECORD LIKE imaa_file.*
DEFINE g_gev04    LIKE gev_file.gev04
DEFINE g_err      LIKE type_file.chr1000
DEFINE g_dbase    LIKE type_file.chr21   
DEFINE g_azp01    LIKE azp_file.azp01    
DEFINE g_gew03    LIKE gew_file.gew03    
DEFINE l_hist_tab        LIKE type_file.chr50

FUNCTION i009_sub_dbs(p_imaa)
DEFINE p_imaa        RECORD LIKE imaa_file.*
DEFINE l_ans         LIKE type_file.chr1
DEFINE l_exit_sw     LIKE type_file.chr1
DEFINE l_c,l_s,i     LIKE type_file.num5
DEFINE l_cnt         LIKE type_file.num5  
DEFINE l_check       LIKE type_file.chr1  
DEFINE l_gew03       LIKE gew_file.gew03 
DEFINE l_gev04       LIKE gev_file.gev04 
DEFINE l_flag        LIKE type_file.chr1  
DEFINE l_count       LIKE type_file.num5  
DEFINE l_child_chk   LIKE type_file.chr1

   LET g_imaa.* = p_imaa.*

   IF s_shut(0) THEN RETURN END IF

   IF NOT cl_confirm("art1042") THEN RETURN END IF

   CALL tm.clear()
   LET g_gev04 = NULL
   #是否為資料中心的拋轉DB
   SELECT gev04 INTO g_gev04 FROM gev_file
    WHERE gev01 = '1' AND gev02 = g_plant
      AND gev03 = 'Y'
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gev04,'aoo-036',0)
      RETURN
   END IF

   BEGIN WORK
   CALL s_showmsg_init()
   LET g_success='Y'
   LET l_child_chk = 'N'

   LET g_sql = "SELECT * ",
               "  FROM imaa_file ",
               " WHERE imaa01 IN (SELECT imx000 ",
               "                    FROM imx_file ",
               "                   WHERE imx00 = '",g_imaa.imaa01,"' )",
               "   AND imaa1010 = '1' ",
               " ORDER BY imaano "
   PREPARE sel_imaa_pre FROM g_sql
   DECLARE sel_imaa_cs CURSOR FOR sel_imaa_pre
   FOREACH sel_imaa_cs INTO g_imaa.*

      IF g_success = 'N' THEN EXIT FOREACH END IF
      IF l_child_chk = 'N' THEN
         CALL i009_carry_data()
      END IF

      IF cl_null(g_gew03) THEN
         CALL cl_err('','aim-201',1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF 
             
      IF INT_FLAG THEN     
         LET INT_FLAG = 0 
         LET g_success = 'N'
         EXIT FOREACH
      END IF 
      LET l_check = 'N'     
      FOR i = 1 TO tm.getLength()
          IF tm[i].sel = 'Y' THEN
             LET l_check = 'Y'
             EXIT FOR
          END IF
      END FOR
      SELECT gev04 INTO l_gev04 FROM gev_file
       WHERE gev01 = '1' and gev02 = g_plant
      SELECT DISTINCT gew03 INTO l_gew03 FROM gew_file
       WHERE gew01 = l_gev04
         AND gew02 = '1'          
      #chech是否所有营运中心皆己存在此料号抛转
      LET l_flag = 'N'               
      FOR i = 1 TO tm.getLength()
          IF tm[i].exist = 'N' THEN
             LET l_flag = 'Y'
             EXIT FOR                
          ELSE
             LET l_flag = 'N'
          END IF        
      END FOR                
      IF l_gew03 = '2' AND l_child_chk = 'N'  THEN
         IF NOT cl_confirm('anm-929') THEN 
            ROLLBACK WORK 
            RETURN 
         END IF   #是否確定拋轉以上資料?
      END IF 
      IF l_gew03 = '3' AND l_check ='N' AND l_flag = 'Y' THEN
         CALL cl_err('','aim-505',1)
         ROLLBACK WORK
         RETURN
      END IF
      IF l_check = 'N' AND l_flag = 'N' THEN
         CALL cl_err('','aim1009',1)
         ROLLBACK WORK
         RETURN
      END IF
      LET l_flag = ' '

      #建立歷史資料拋轉的臨時表
      CALL s_dc_cre_temp_table("gex_file") RETURNING l_hist_tab

      FOR i = 1 TO tm.getLength()
          IF cl_null(tm[i].azp03) OR tm[i].sel = 'N' THEN LET g_success='N' CONTINUE FOR END IF
          EXIT FOR
      END FOR
      IF g_success = 'Y' THEN
         IF g_imaa.imaa00 = 'I' THEN
            CALL i009_dbs_ins() #新增
         ELSE
            CALL i009_dbs_upd() #修改
         END IF
      END IF
      IF g_success = 'Y' THEN
         #更新狀況碼
         UPDATE imaa_file
            SET imaa1010 = '2' #已拋轉
          WHERE imaano = g_imaa.imaano
         IF SQLCA.sqlcode OR sqlca.sqlerrd[3] <= 0 THEN
            #狀況碼更新不成功
            CALL s_errmsg('imaano',g_imaa.imaano,'','lib-30',1)
            LET g_success = 'N'
         END IF
      END IF
      IF g_success='Y' THEN
         IF s_industry('icd') THEN
            LET l_count = 0
            IF NOT cl_null(g_imaa.imaaicd01) THEN
               SELECT COUNT(1) INTO l_count FROM icf_file
                WHERE icf01 = g_imaa.imaaicd01
               IF l_count = 0 THEN
                  INSERT INTO icf_file(icf01,icf02,icf04,icf05)
                  VALUES(g_imaa.imaaicd01,'BIN01','Y','0')
               END IF
               IF SQLCA.sqlcode THEN
                  CALL s_errmsg('imaaicd01',g_imaa.imaaicd01,'',SQLCA.sqlcode,1)
                  LET g_success = 'N'
               END IF
            END IF
            LET l_count = 0
            IF NOT cl_null(g_imaa.imaaicd16) THEN
               SELECT COUNT(1) INTO l_count FROM icf_file
                WHERE icf01 = g_imaa.imaaicd16
               IF l_count = 0 THEN
                  INSERT INTO icf_file(icf01,icf02,icf04,icf05)
                  VALUES(g_imaa.imaaicd16,'BIN01','Y','0')
               END IF
               IF SQLCA.sqlcode THEN
                  CALL s_errmsg('imaaicd16',g_imaa.imaaicd16,'',SQLCA.sqlcode,1)
                  LET g_success = 'N'
               END IF
            END IF 
         END IF
      END IF 
      CALL s_dc_drop_temp_table(l_hist_tab)
      IF g_success = 'Y' THEN LET l_child_chk = 'Y' END IF
   END FOREACH
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_cmmsg(4)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(4)
   END IF
   CALL s_showmsg()
END FUNCTION

#資料拋轉時會用到的副程式
FUNCTION i009_carry_data()
DEFINE l_imaano       LIKE imaa_file.imaano
DEFINE p_row,p_col    LIKE type_file.num5  
DEFINE l_arrno        LIKE type_file.num5  
DEFINE l_ac           LIKE type_file.num5  
DEFINE l_exit_sw      LIKE type_file.chr1  
DEFINE l_wc           LIKE type_file.chr1000
DEFINE l_sql          LIKE type_file.chr1000
DEFINE l_do_ok        LIKE type_file.chr1    
DEFINE l_rec_b        LIKE type_file.num5    
DEFINE l_cnt          LIKE type_file.num5    
DEFINE l_i            LIKE type_file.num5    
DEFINE l_gew03        LIKE gew_file.gew03    
DEFINE l_gev04        LIKE gev_file.gev04    
DEFINE l_geu02        LIKE geu_file.geu02    
DEFINE l_allow_insert LIKE type_file.num5                 #可新增否
DEFINE l_allow_delete LIKE type_file.num5                 #可刪除否
DEFINE l_dbs          STRING                
DEFINE p_sql          LIKE type_file.chr1000
DEFINE l_dbs_sep      LIKE type_file.chr50
DEFINE l_chk          LIKE type_file.num5
DEFINE l_n            LIKE type_file.num5
DEFINE l_azw01        LIKE azw_file.azw01
DEFINE l_azw06        LIKE azw_file.azw06
DEFINE l_str          STRING             

   SELECT UNIQUE gew03 INTO l_gew03 FROM gew_file
    WHERE gew01 = g_gev04
      AND gew02 = '1'
   IF SQLCA.sqlcode THEN
      IF SQLCA.sqlcode = -284 THEN
         LET l_gew03 = '3'
      END IF
   END IF

   IF l_gew03 = '3' THEN
      OPEN WINDOW s_dc_1_w WITH FORM "sub/42f/s_dc_sel_db1"
           ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_locale("s_dc_sel_db1")

      SELECT gev04 INTO l_gev04 FROM gev_file
       WHERE gev01 = '1' and gev02 = g_plant
      SELECT geu02 INTO l_geu02 FROM geu_file
       WHERE geu01 = l_gev04

      DISPLAY l_gev04 TO FORMONLY.gev04
      DISPLAY l_geu02 TO FORMONLY.geu02

      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM azw_file
       WHERE azw05 <> azw06
      IF l_n  = 0  THEN
         CALL cl_set_comp_visible("plant",FALSE)
      END IF
   END IF

   IF g_imaa.imaa00 = 'I' THEN #新增
      IF l_gew03 MATCHES '[123]' THEN
         LET l_sql = " SELECT 'Y',gew04,azp02,azp03,' ','N' FROM gew_file,azp_file ",
                     "  WHERE gew01 = '",g_gev04,"'",
                     "    AND gew02 = '1'",
                     "    AND gew04 = azp01 "
         PREPARE s_carry_data_prepare1 FROM l_sql
         DECLARE azp_curs1 CURSOR FOR s_carry_data_prepare1
         LET g_cnt = 1
         FOREACH azp_curs1 INTO tm[g_cnt].*
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach s_dc_sel_azp:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF

            SELECT COUNT(*) INTO l_chk FROM zxy_file
             WHERE zxy01=g_user
               AND zxy03=tm[g_cnt].azp01
            IF l_chk=0 THEN CONTINUE FOREACH END IF

            CALL s_getdbs_curr(tm[g_cnt].azp01) RETURNING l_dbs
            LET l_cnt = 0
            LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(tm[g_cnt].azp01,'ima_file'),
                        " WHERE ima01 ='",g_imaa.imaa01,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,tm[g_cnt].azp01) RETURNING l_sql
            PREPARE ima_count_pre1 FROM l_sql
            EXECUTE ima_count_pre1 INTO l_cnt
            IF NOT cl_null(l_cnt) THEN
                #新增時,已存在的不能選取
                #修改時,已存在的選取
                IF g_imaa.imaa00 = 'I' THEN #新增
                    IF l_cnt >= 1 THEN
                        LET tm[g_cnt].exist = 'Y'     #存在
                        LET tm[g_cnt].sel = 'N'     #選取
                    END IF
                ELSE
                    IF l_cnt >= 1 THEN
                        LET tm[g_cnt].exist = 'Y'     #存在
                        LET tm[g_cnt].sel    = 'Y'     #選取
                    END IF 
                END IF
            END IF
            LET l_azw06 = NULL                                 
            LET l_azw01 = NULL                                                                           
            LET l_str = ''                                
            SELECT azw06 INTO l_azw06 FROM azw_file WHERE azw01 = tm[g_cnt].azp01
            DECLARE s_dc_db1 CURSOR FOR         
               SELECT azw01 FROM azw_file WHERE azw06 = l_azw06
            FOREACH s_dc_db1  INTO l_azw01                      
              IF STATUS THEN
                 CALL cl_err('foreach:',STATUS,1)
                 EXIT FOREACH          
              END IF                                                     
              IF l_azw01 = tm[g_cnt].azp01 THEN
                 LET l_azw01 = NULL
                 CONTINUE FOREACH
              END IF                                      
              IF cl_null(l_str)  THEN
                 LET l_str = l_azw01          
              ELSE                                       
                 LET l_str = l_str,",",l_azw01
              END IF                                                 
            END FOREACH        
            LET tm[g_cnt].plant = l_str   
            LET g_cnt = g_cnt + 1
                         
         END FOREACH
         CALL tm.deleteElement(g_cnt)
      END IF 
   ELSE       
      LET l_sql = " SELECT 'N',gew04,azp02,azp03,'N' ",
                  "   FROM gew_file,azp_file ",
                  "  WHERE gew01 = '",g_gev04,"'",
                  "    AND azp053 = 'Y' ",
                  "    AND gew02 = '1'",
                  "    AND gew04 = azp01 "
      PREPARE s_carry_data_prepare2 FROM l_sql
      DECLARE azp_curs2 CURSOR FOR s_carry_data_prepare2
      LET g_cnt = 1
      FOREACH azp_curs2 INTO tm[g_cnt].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach s_dc_sel_azp:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
      
         SELECT COUNT(*) INTO l_chk FROM zxy_file
          WHERE zxy01=g_user
            AND zxy03=tm[g_cnt].azp01
         IF l_chk=0 THEN CONTINUE FOREACH END IF
      
         LET l_cnt = NULL
         CALL s_getdbs_curr(tm[g_cnt].azp01) RETURNING l_dbs
         LET g_sql="SELECT COUNT(*) FROM ima_file ",
                   "WHERE ima01='",g_imaa.imaa01,"' ",
                   "AND imaacti='Y'"
         IF NOT s_aimi100_chk_cur(g_sql) THEN
            LET tm[g_cnt].exist = 'Y'
         ELSE
            LET tm[g_cnt].exist = 'N'
         END IF
         DISPLAY BY NAME tm[g_cnt].exist
         LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(tm[g_cnt].azp01,'ima_file'),
                     " WHERE ima01 ='",g_imaa.imaa01,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,tm[g_cnt].azp01) RETURNING l_sql
         PREPARE ima_count_pre2 FROM l_sql
         EXECUTE ima_count_pre2 INTO l_cnt
      
         IF NOT cl_null(l_cnt) THEN
            #新增時,已存在的不能選取
            #修改時,已存在的選取
            IF g_imaa.imaa00 = 'I' THEN #新增
               IF l_cnt >= 1 THEN
                   LET tm[g_cnt].exist = 'Y'     #存在
                   LET tm[g_cnt].sel = 'N'     #選取
               END IF 
            ELSE   
               IF l_cnt >= 1 THEN
                   LET tm[g_cnt].exist = 'Y'     #存在
                   LET tm[g_cnt].sel    = 'Y'     #選取
               END IF
            END IF
         END IF
         LET l_azw06 = NULL         
         LET l_azw01 = NULL                                           
         LET l_str = ''       
         SELECT azw06 INTO l_azw06 FROM azw_file WHERE azw01 = tm[g_cnt].azp01
         DECLARE s_dc_db2  CURSOR  FOR
            SELECT azw01 FROM azw_file WHERE azw06 = l_azw06
         FOREACH s_dc_db2  INTO l_azw01
           IF STATUS THEN                  
              CALL cl_err('foreach:',STATUS,1)        
              EXIT FOREACH
           END IF              
           IF l_azw01 = tm[g_cnt].azp01 THEN                      
              LET l_azw01 = NULL                          
              CONTINUE FOREACH                              
           END IF                         
           IF cl_null(l_str)  THEN                 
              LET l_str = l_azw01          
           ELSE    
              LET l_str = l_str,",",l_azw01
           END IF    
         END FOREACH                          
         LET tm[g_cnt].plant = l_str                                                      
         LET g_cnt = g_cnt + 1
                         
      END FOREACH
      CALL tm.deleteElement(g_cnt)
   END IF       
                
   LET l_rec_b = g_cnt -1
   WHILE TRUE   
      LET l_exit_sw = "n" 
      IF l_gew03 = '3' THEN 
         IF g_imaa.imaa00 = 'U' THEN
             LET l_allow_insert = FALSE
         ELSE
             LET l_allow_insert = TRUE
         END IF
      
         INPUT ARRAY tm WITHOUT DEFAULTS FROM s_azp.*
               ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                         INSERT ROW=l_allow_insert,DELETE ROW=TRUE,APPEND ROW=l_allow_insert)
      
            BEFORE ROW
               LET l_ac = ARR_CURR()
               #新增時,已存在的不能選取
               #修改時,不存在的不能選取
               IF g_imaa.imaa00 = 'I' THEN #新增
                  IF tm[l_ac].exist = 'Y' THEN #存在
                     IF l_ac <> l_rec_b THEN
                        NEXT FIELD exist
                     ELSE
                        LET l_exit_sw = "y"   
                        EXIT INPUT
                     END IF
                  END IF
               ELSE
                  IF tm[l_ac].exist = 'N' THEN #不存在
                     IF l_ac <> l_rec_b THEN
                         NEXT FIELD exist
                     ELSE
                         LET l_exit_sw = "y" 
                         EXIT INPUT
                     END IF
                  END IF
               END IF
               CALL i100_150_set_entry( )
               CALL i100_150_set_no_entry(l_ac)
      
            AFTER FIELD azp01
               IF NOT cl_null(tm[l_ac].azp01) THEN
                  CALL i100_sel_db_azp01(l_ac)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(tm[l_ac].azp01,g_errno,0)
                     NEXT FIELD azp01
                  ELSE
                      CALL s_getdbs_curr(tm[l_ac].azp01) RETURNING l_dbs
                      LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(tm[l_ac].azp01,'ima_file'),
                                  " WHERE ima01 ='",g_imaa.imaa01,"'"
                      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                      CALL cl_parse_qry_sql(l_sql,tm[l_ac].azp01) RETURNING l_sql
                      PREPARE ima_count_pre FROM l_sql
                      EXECUTE ima_count_pre INTO l_cnt
                
                      IF NOT cl_null(l_cnt) THEN
                         IF l_cnt >= 1 THEN
                             LET tm[l_ac].exist = 'Y'
                         ELSE
                             LET tm[l_ac].exist = 'N'
                         END IF 
                      END IF
                      DISPLAY BY NAME tm[l_ac].exist 
                   END IF
               ELSE         
                  LET tm[l_ac].azp02 = NULL
                  LET tm[l_ac].azp03 = NULL 
               END IF       
                      
            ON ACTION controlp
               CASE
                  WHEN INFIELD(azp01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_gew04"
                     LET g_qryparam.arg1     = g_gev04
                     LET g_qryparam.arg2     = '1'
                     LET g_qryparam.default1 = tm[l_ac].azp01
                     CALL cl_create_qry() RETURNING tm[l_ac].azp01
                     CALL i100_sel_db_azp01(l_ac)
                     NEXT FIELD azp01
               END CASE
             
            ON ACTION accept
               LET l_exit_sw = 'y'
               EXIT INPUT     
              
            ON ACTION select_all   #全部選取
               CALL i009_sel_all('Y',l_rec_b)
                 
            ON ACTION select_non   #全部不選
               CALL i009_sel_all('N',l_rec_b)
         END INPUT
      ELSE
         EXIT WHILE
      END IF
      
      IF INT_FLAG THEN
         LET l_exit_sw = 'y'
      END IF
      
      IF l_exit_sw = "y" THEN
         EXIT WHILE
      END IF
   END WHILE
   IF l_gew03 = '3' THEN
     CLOSE WINDOW s_dc_1_w
   END IF

   LET g_gew03 = l_gew03
END FUNCTION

FUNCTION i009_sel_all(p_flag,l_rec_b)
DEFINE  p_flag      LIKE type_file.chr1
DEFINE  l_i         LIKE type_file.num5
DEFINE  l_rec_b     LIKE type_file.num5

   FOR l_i = 1 TO l_rec_b
      IF p_flag = 'Y' THEN
         #新增時,不存在的才能選取
         #修改時,已存在的不能選取
         IF g_imaa.imaa00 = 'I' THEN #新增
            IF tm[l_i].exist = 'N' THEN #不存在
               #LET tm[l_i].a = p_flag
               LET tm[l_i].sel = p_flag
            END IF
         ELSE
            IF tm[l_i].exist = 'Y' THEN #存在
               LET tm[l_i].sel = p_flag
            END IF
         END IF
      ELSE
          LET tm[l_i].sel = p_flag
      END IF
      DISPLAY BY NAME tm[l_i].sel
   END FOR            
END FUNCTION

FUNCTION i009_dbs_ins()
DEFINE l_imaa        RECORD LIKE imaa_file.*  
DEFINE i             LIKE type_file.num5      
DEFINE l_imaicd      RECORD LIKE imaicd_file.*
DEFINE l_cnt         LIKE type_file.num5 
DEFINE l_str         LIKE gca_file.gca01 
DEFINE l_gew08       LIKE gew_file.gew08     #for mail
DEFINE l_hs_flag     LIKE type_file.chr1     #for mail
DEFINE l_hs_path     LIKE ze_file.ze03       #for mail
DEFINE l_j           LIKE type_file.num10
DEFINE l_gew05       LIKE gew_file.gew05
DEFINE l_gew07       LIKE gew_file.gew07
DEFINE l_all_cnt     LIKE type_file.num5
DEFINE l_cur_cnt     LIKE type_file.num5
DEFINE l_ima_ins     LIKE type_file.chr1
DEFINE l_imaa1       RECORD LIKE imaa_file.* 
DEFINE l_ima         RECORD LIKE ima_file.*  
DEFINE l_db          LIKE type_file.chr50    
DEFINE l_sql         STRING
   
   MESSAGE ' COPY FOR INSERT .... '
          
   #讀取相關資料..........................................
   SELECT * INTO l_imaa.* FROM imaa_file 
    WHERE imaano = g_imaa.imaano

   IF STATUS THEN 
      CALL s_errmsg('imaano',g_imaa.imaano,'',SQLCA.sqlcode,1)
      LET g_success = 'N' 
      RETURN 
   END IF     
              
   LET l_imaa1.* = l_imaa.* 
              
   LET l_str = 'imaa01=',l_imaa.imaa01
   DROP TABLE x
   DROP TABLE y
   SELECT * FROM gca_file WHERE gca01=l_str AND gca09='imaa04' INTO TEMP x
   SELECT gcb01,gcb02,gcb03,gcb04,gcb05,gcb06,gcb07,gcb08,gcb09,
          gcb10,gcb11,gcb12,gcb13,gcb14,gcb15,gcb16,gcb17,gcb18
     FROM gcb_file,gca_file WHERE gca01=l_str AND gca09='imaa04'
      AND gca07 = gcb01 AND gcb03='imaa04'
     INTO TEMP y
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM x
   IF l_cnt > 0 THEN
      LET l_str = 'ima01=',l_imaa.imaa01
      UPDATE x SET gca01 = l_str,
                   gca09 = 'ima04'
      UPDATE y SET gcb03 = 'ima04'
      FOR i = 1 TO tm.getLength() 
         IF cl_null(tm[i].azp03) OR tm[i].sel = 'N' THEN  CONTINUE FOR END IF 
         LET g_sql='INSERT INTO ',cl_get_target_table(tm[i].azp01,'gca_file'),' SELECT * FROM x' 
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql  
         CALL cl_parse_qry_sql(g_sql,tm[i].azp01) RETURNING g_sql 
         EXECUTE IMMEDIATE g_sql
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             LET g_msg = 'INSERT ',cl_get_target_table(tm[i].azp01,'ima_file') 
             LET g_showmsg = tm[i].azp03,'/',l_str
             CALL s_errmsg('azp03,gca01',g_showmsg,g_msg,'lib-028',1)
             LET g_success = 'N'
             EXIT FOR
         END IF

         LET g_sql='INSERT INTO ',cl_get_target_table(tm[i].azp01,'gcb_file'),' SELECT * FROM y'
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql 
         CALL cl_parse_qry_sql(g_sql,tm[i].azp01) RETURNING g_sql  
         EXECUTE IMMEDIATE g_sql
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            #LET g_msg = 'INSERT ',l_db CLIPPED,'ima_file'
            LET g_msg = 'INSERT ',cl_get_target_table(tm[i].azp01,'ima_file')
            LET g_showmsg = tm[i].azp03,'/',l_str
            CALL s_errmsg('azp03,gcb01',g_showmsg,g_msg,'lib-028',1)
            LET g_success = 'N'
            EXIT FOR
         END IF
      END FOR
   END IF 
   
   LET g_dbase=NULL
   LET g_azp01 = NULL 
   FOR i = 1 TO tm.getLength()
                                     
       LET l_ima_ins = 'N'
       #建立歷史資料拋轉的臨時表
       IF cl_null(tm[i].azp03) THEN CONTINUE FOR END IF
       IF tm[i].sel = 'N' THEN CONTINUE FOR END IF
                   
       SELECT gew05,gew07,gew08 INTO l_gew05,l_gew07,l_gew08 FROM gew_file
        WHERE gew01 = g_gev04
          AND gew02 = '1'
          AND gew04 = tm[i].azp01
       IF cl_null(l_gew07) THEN LET l_gew07 = 'N' END IF
                           
       CALL s_dc_carry_send_mail_1(tm[i].azp01,i,g_gev04,'1',l_hist_tab)
        RETURNING l_hs_flag,l_hs_path
          
       IF cl_null(tm[i].azp03) OR tm[i].sel = 'N' THEN  CONTINUE FOR END IF
       LET g_dbase=tm[i].azp03 CLIPPED
       LET g_azp01 = tm[i].azp01 CLIPPED
       IF tm[i].azp01 <> g_plant THEN
          CALL i009_default_imz(l_imaa.*) RETURNING l_imaa.*
       ELSE   
          LET l_imaa.* = l_imaa1.*
       END IF
       LET g_sql='INSERT INTO ',cl_get_target_table(tm[i].azp01,'ima_file'),'(', 
 ' ima01      ,', 
 ' ima02      ,', 
 ' ima021     ,', 
 ' ima03      ,',  
 ' ima04      ,', 
 ' ima05      ,', 
 ' ima06      ,',  
 ' ima07      ,', 
 ' ima08      ,',  
 ' ima09      ,',
 ' ima10      ,',
 ' ima11      ,',
 ' ima12      ,',
 ' ima13      ,',
 ' ima14      ,',
 ' ima15      ,',
 ' ima16      ,',
 ' ima17      ,',
 ' ima17_fac  ,',
 ' ima18      ,',
 ' ima19      ,',
 ' ima20      ,',
 ' ima21      ,',
 ' ima22      ,',
 ' ima23      ,',
 ' ima24      ,',
 ' ima25      ,',
 ' ima27      ,',
 ' ima271     ,',
 ' ima28      ,',
 ' ima29      ,',
 ' ima30      ,',
 ' ima31      ,',
 ' ima31_fac  ,',
 ' ima32      ,',
 ' ima33      ,',
 ' ima34      ,',
 ' ima35      ,',
 ' ima36      ,',
 ' ima37      ,',
 ' ima38      ,',
 ' ima39      ,',
 ' ima40      ,',
 ' ima41      ,',
 ' ima42      ,',
 ' ima43      ,',
 ' ima44      ,',
 ' ima44_fac  ,',
 ' ima45      ,',
 ' ima46      ,',
 ' ima47      ,',
 ' ima48      ,',
 ' ima49      ,',
 ' ima491     ,',
 ' ima50      ,',
 ' ima51      ,',
 ' ima52      ,',
 ' ima53      ,',
 ' ima531     ,',
 ' ima532     ,',
 ' ima54      ,',
 ' ima55      ,',
 ' ima55_fac  ,',
 ' ima56      ,',
 ' ima561     ,',
 ' ima562     ,',
 ' ima57      ,',
 ' ima571     ,',
 ' ima58      ,', 
 ' ima59      ,', 
 ' ima60      ,', 
 ' ima61      ,',
 ' ima62      ,',
 ' ima63      ,',
 ' ima63_fac  ,',
 ' ima64      ,',
 ' ima641     ,',
 ' ima65      ,',
 ' ima66      ,',
 ' ima67      ,',
 ' ima68      ,',
 ' ima69      ,',
 ' ima70      ,',
 ' ima71      ,',
 ' ima72      ,',
 ' ima721     ,', #CHI-C50068
 ' ima73      ,',
 ' ima74      ,',
 ' ima86      ,',
 ' ima86_fac  ,',
 ' ima87      ,',
 ' ima871     ,',
 ' ima872     ,',
 ' ima873     ,',
 ' ima874     ,',
 ' ima88      ,',
 ' ima881     ,',
 ' ima89      ,',
 ' ima90      ,',
 ' ima91      ,',
 ' ima92      ,',
 ' ima93      ,',
 ' ima94      ,',
 ' ima95      ,',
 ' ima75      ,',
 ' ima76      ,',
 ' ima77      ,',
 ' ima78      ,',
 ' ima79      ,',
 ' ima80      ,',
 ' ima81      ,',
 ' ima82      ,',
 ' ima83      ,',
 ' ima84      ,',
 ' ima85      ,',
 ' ima851     ,',
 ' ima852     ,',
 ' ima853     ,',
 ' ima96      ,',
 ' ima97      ,',
 ' ima98      ,',
 ' ima99      ,',
 ' ima100     ,',
 ' ima101     ,',
 ' ima102     ,',
 ' ima103     ,',
 ' ima104     ,',
 ' ima105     ,',
 ' ima106     ,',
 ' ima107     ,',
 ' ima108     ,',
 ' ima109     ,',
 ' ima110     ,',
 ' ima111     ,',
 ' ima121     ,',
 ' ima122     ,',
 ' ima123     ,',
 ' ima124     ,',
 ' ima125     ,',
 ' ima126     ,',
 ' ima127     ,',
 ' ima128     ,',    
 ' ima129     ,',
 ' ima130     ,',
 ' ima131     ,',
 ' ima132     ,',
 ' ima133     ,',
 ' ima134     ,',
 ' ima135     ,',
 ' ima136     ,',
 ' ima137     ,',
 ' ima138     ,',
 ' ima139     ,',
 ' ima140     ,',
 ' ima141     ,',
 ' ima142     ,',
 ' ima143     ,',
 ' ima144     ,',
 ' ima145     ,',
 ' ima146     ,',
 ' ima147     ,',
 ' ima148     ,',
 ' ima901     ,',
 ' ima902     ,',
 ' ima903     ,',
 ' ima904     ,',
 ' ima905     ,',
 ' ima906     ,',
 ' ima907     ,',
 ' ima908     ,',
 ' ima909     ,',
 ' ima153     ,',
 ' ima910     ,',
 ' imaacti    ,',
 ' imauser    ,',
 ' imagrup    ,',
 ' imamodu    ,',
 ' imadate    ,',
 ' imaag      ,',
 ' imaag1     ,',
 ' imaud01    ,',
 ' imaud02    ,',
 ' imaud03    ,',
 ' imaud04    ,',
 ' imaud05    ,',
 ' imaud06    ,',
 ' imaud07    ,',
 ' imaud08    ,',
 ' imaud09    ,',
 ' imaud10    ,',
 ' imaud11    ,',
 ' imaud12    ,',
 ' imaud13    ,',
 ' imaud14    ,',
 ' imaud15    ,',
 ' ima1001    ,',
 ' ima1002    ,',
 ' ima1003    ,',
 ' ima1004    ,',
 ' ima1005    ,',
 ' ima1006    ,',
 ' ima1007    ,',
 ' ima1008    ,',
 ' ima1009    ,',
 ' ima1010    ,',
 ' ima1011    ,',
 ' ima1012    ,',
 ' ima1013    ,',
 ' ima1014    ,',
#' ima1015    ,',  #CHI-CA0073 mark 
 ' ima1401    ,',  #CHI-CA0073 add
 ' ima1016    ,',
 ' ima1017    ,',
 ' ima1018    ,',
 ' ima1019    ,',
 ' ima1020    ,',
 ' ima1021    ,',
 ' ima1022    ,',
 ' ima1023    ,',
 ' ima1024    ,',
 ' ima1025    ,',
 ' ima1026    ,',
 ' ima1027    ,',
 ' ima1028    ,',
 ' ima1029    ,',
 ' ima911     ,',
 ' ima912     ,',
 ' ima913     ,',
 ' ima914     ,',
 ' ima391     ,',
 ' ima1321    ,',
 ' ima915     ,',
 ' ima916     ,',
 ' ima918     ,',
 ' ima919     ,',
 ' ima920     ,',
 ' ima921     ,',
 ' ima922     ,',
 ' ima923     ,',
 ' ima924     ,',
 ' ima251     ,',
 ' ima150,ima151,ima152,',
 ' ima154,ima155,',
 ' ima926     ,',
 ' ima120     ,',
 ' ima022,ima156,ima158,ima927, ',
 ' ima928,ima929,',
 ' ima149,ima1491,ima940,ima941,', 
 ' ima925,ima601,imaoriu,imaorig,ima159,ima160,ima1030 )',     #FUN-C50036 add ima160 #FUN-D30006 Add ima1030
 ' VALUES(?, ',
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #10
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #20
 ' ?,?,?,?,?,  ?,?, ',          
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #40
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #50
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #60
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #70 
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #80
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #90
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #100
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #110
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #120
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #130
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #140
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #150
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #160
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #170
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #180
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #190
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #200
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #210
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #220
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #230
 ' ?,?,?,?, ',               
 ' ?,?,?,?, ',           
 ' ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? ,?,?,?)'      #FUN-C50036 add ? #CHI-C50068 #FUN-D30006 Add ima1030
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql,tm[i].azp01) RETURNING g_sql
       PREPARE ins_ima FROM g_sql
       EXECUTE ins_ima USING
 l_imaa.imaa01      ,
 l_imaa.imaa02      ,
 l_imaa.imaa021     ,
 l_imaa.imaa03      ,
 l_imaa.imaa04      ,
 l_imaa.imaa05      ,
 l_imaa.imaa06      ,
 l_imaa.imaa07      ,
 l_imaa.imaa08      ,
 l_imaa.imaa09      ,
 l_imaa.imaa10      ,
 l_imaa.imaa11      ,
 l_imaa.imaa12      ,
 l_imaa.imaa13      ,
 l_imaa.imaa14      ,
 l_imaa.imaa15      ,
 l_imaa.imaa16      ,
 l_imaa.imaa17      ,
 l_imaa.imaa17_fac  ,
 l_imaa.imaa18      ,
 l_imaa.imaa19      ,
 l_imaa.imaa20      ,
 l_imaa.imaa21      ,
 l_imaa.imaa22      ,
 l_imaa.imaa23      ,
 l_imaa.imaa24      ,
 l_imaa.imaa25      ,
 l_imaa.imaa27      ,
 l_imaa.imaa271     ,
 l_imaa.imaa28      ,
 l_imaa.imaa29      ,
 l_imaa.imaa30      ,
 l_imaa.imaa31      ,
 l_imaa.imaa31_fac  ,
 l_imaa.imaa32      ,
 l_imaa.imaa33      ,        
 l_imaa.imaa34      ,
 l_imaa.imaa35      ,
 l_imaa.imaa36      ,
 l_imaa.imaa37      ,
 l_imaa.imaa38      ,
 l_imaa.imaa39      ,
 l_imaa.imaa40      ,
 l_imaa.imaa41      ,
 l_imaa.imaa42      ,
 l_imaa.imaa43      ,
 l_imaa.imaa44      ,
 l_imaa.imaa44_fac  ,
 l_imaa.imaa45      ,
 l_imaa.imaa46      ,
 l_imaa.imaa47      ,
 l_imaa.imaa48      ,
 l_imaa.imaa49      ,
 l_imaa.imaa491     ,
 l_imaa.imaa50      ,
 l_imaa.imaa51      ,
 l_imaa.imaa52      ,
 l_imaa.imaa53      ,
 l_imaa.imaa531     ,
 l_imaa.imaa532     ,
 l_imaa.imaa54      ,
 l_imaa.imaa55      ,
 l_imaa.imaa55_fac  ,
 l_imaa.imaa56      ,
 l_imaa.imaa561     ,
 l_imaa.imaa562     ,
 l_imaa.imaa57      ,
 l_imaa.imaa571     ,
 l_imaa.imaa58      ,    
 l_imaa.imaa59      ,    
 l_imaa.imaa60      ,    
 l_imaa.imaa61      ,
 l_imaa.imaa62      ,
 l_imaa.imaa63      ,
 l_imaa.imaa63_fac  ,
 l_imaa.imaa64      ,
 l_imaa.imaa641     ,
 l_imaa.imaa65      ,
 l_imaa.imaa66      ,
 l_imaa.imaa67      ,
 l_imaa.imaa68      ,
 l_imaa.imaa69      ,
 l_imaa.imaa70      ,
 l_imaa.imaa71      ,
 l_imaa.imaa72      ,
 l_imaa.imaa721     ,  #CHI-C50068
 l_imaa.imaa73      ,
 l_imaa.imaa74      ,
 l_imaa.imaa86      ,
 l_imaa.imaa86_fac  ,
 l_imaa.imaa87      ,
 l_imaa.imaa871     ,
 l_imaa.imaa872     ,
 l_imaa.imaa873     ,
 l_imaa.imaa874     ,
 l_imaa.imaa88      ,
 l_imaa.imaa881     ,
 l_imaa.imaa89      ,
 l_imaa.imaa90      ,
 l_imaa.imaa91      ,
 l_imaa.imaa92      ,
 l_imaa.imaa93      ,
 l_imaa.imaa94      ,
 l_imaa.imaa95      ,
 l_imaa.imaa75      ,
 l_imaa.imaa76      ,
 l_imaa.imaa77      ,
 l_imaa.imaa78      ,
 l_imaa.imaa79      ,
 l_imaa.imaa80      ,
 l_imaa.imaa81      ,
 l_imaa.imaa82      ,
 l_imaa.imaa83      ,
 l_imaa.imaa84      ,
 l_imaa.imaa85      ,
 l_imaa.imaa851     ,
 l_imaa.imaa852     ,
 l_imaa.imaa853     ,
 l_imaa.imaa96      ,
 l_imaa.imaa97      ,
 l_imaa.imaa98      ,
 l_imaa.imaa99      ,
 l_imaa.imaa100     ,
 l_imaa.imaa101     ,
 l_imaa.imaa102     ,
 l_imaa.imaa103     ,
 l_imaa.imaa104     ,
 l_imaa.imaa105     ,
 l_imaa.imaa106     ,
 l_imaa.imaa107     ,
 l_imaa.imaa108     ,
 l_imaa.imaa109     ,
 l_imaa.imaa110     ,
 l_imaa.imaa111     ,
 l_imaa.imaa121     ,
 l_imaa.imaa122     ,
 l_imaa.imaa123     ,
 l_imaa.imaa124     ,
 l_imaa.imaa125     ,
 l_imaa.imaa126     ,
 l_imaa.imaa127     ,
 l_imaa.imaa128     ,
 l_imaa.imaa129     ,
 l_imaa.imaa130     ,
 l_imaa.imaa131     ,
 l_imaa.imaa132     ,
 l_imaa.imaa133     ,
 l_imaa.imaa134     ,
 l_imaa.imaa135     ,
 l_imaa.imaa136     ,
 l_imaa.imaa137     ,
 l_imaa.imaa138     ,
 l_imaa.imaa139     ,
 l_imaa.imaa140     ,
 l_imaa.imaa141     ,
 l_imaa.imaa142     ,
 l_imaa.imaa143     ,
 l_imaa.imaa144     ,
 l_imaa.imaa145     ,
 l_imaa.imaa146     ,
 l_imaa.imaa147     ,
 l_imaa.imaa148     ,
 l_imaa.imaa901     ,
 l_imaa.imaa902     ,
 l_imaa.imaa903     ,
 l_imaa.imaa904     ,
 l_imaa.imaa905     ,
 l_imaa.imaa906     ,
 l_imaa.imaa907     ,
 l_imaa.imaa908     ,
 l_imaa.imaa909     ,
 l_imaa.imaa153     ,
 l_imaa.imaa910     ,
 l_imaa.imaaacti    ,
     g_user,   #資料所有者
     g_grup,   #資料所有部門
     '',       #資料修改者
     g_today,  #最近修改日
 l_imaa.imaaag      ,
 l_imaa.imaaag1     ,
 l_imaa.imaaud01    ,
 l_imaa.imaaud02    ,
 l_imaa.imaaud03    ,
 l_imaa.imaaud04    ,
 l_imaa.imaaud05    ,
 l_imaa.imaaud06    ,
 l_imaa.imaaud07    ,
 l_imaa.imaaud08    ,
 l_imaa.imaaud09    ,
 l_imaa.imaaud10    ,
 l_imaa.imaaud11    ,
 l_imaa.imaaud12    ,
 l_imaa.imaaud13    ,
 l_imaa.imaaud14    ,
 l_imaa.imaaud15    ,
 l_imaa.imaa1001    ,
 l_imaa.imaa1002    ,
 l_imaa.imaa1003    ,
 l_imaa.imaa1004    ,
 l_imaa.imaa1005    ,
 l_imaa.imaa1006    ,
 l_imaa.imaa1007    ,
 l_imaa.imaa1008    ,
 l_imaa.imaa1009    ,
 l_imaa.imaa1010    ,
 l_imaa.imaa1011    ,
 l_imaa.imaa1012    ,
 l_imaa.imaa1013    ,
 l_imaa.imaa1014    ,
 l_imaa.imaa1015    ,
 l_imaa.imaa1016    ,
 l_imaa.imaa1017    ,
 l_imaa.imaa1018    ,
 l_imaa.imaa1019    ,
 l_imaa.imaa1020    ,
 l_imaa.imaa1021    ,        
 l_imaa.imaa1022    ,
 l_imaa.imaa1023    ,
 l_imaa.imaa1024    , 
 l_imaa.imaa1025    , 
 l_imaa.imaa1026    , 
 l_imaa.imaa1027    , 
 l_imaa.imaa1028    ,
 l_imaa.imaa1029    ,
 l_imaa.imaa911     ,
 l_imaa.imaa912     ,
 l_imaa.imaa913     ,
 l_imaa.imaa914     ,
 l_imaa.imaa391     ,
 l_imaa.imaa1321    ,
 l_imaa.imaa915     ,
 g_plant            ,
 l_imaa.imaa918     ,
 l_imaa.imaa919     ,
 l_imaa.imaa920     ,
 l_imaa.imaa921     ,
 l_imaa.imaa922     ,
 l_imaa.imaa923     ,
 l_imaa.imaa924     ,
 l_imaa.imaa251     ,
 '0',l_imaa.imaa151,'0'        ,
 l_imaa.imaa154,'N'            ,
 l_imaa.imaa926     ,
 l_imaa.imaa120     ,
 l_imaa.imaa022,' ',' ','N',
 l_imaa.imaa928,l_imaa.imaa929,
 l_imaa.imaa149,l_imaa.imaa1491,l_imaa.imaa940,l_imaa.imaa941,
 l_imaa.imaa925,'1',l_imaa.imaaoriu,l_imaa.imaaorig,l_imaa.imaa159,'N',l_imaa.imaa1030      #FUN-C50036 add 'N' #FUN-D30006 Add imaa1030
                     
 
#-------------------- COPY FILE ------------------------------
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           #LET g_msg = 'INSERT ',l_db CLIPPED,'ima_file'
           LET g_msg = 'INSERT ',cl_get_target_table(tm[i].azp01,'ima_file')
           DISPLAY '錯誤碼=>',SQLCA.sqlcode
           LET g_showmsg=tm[i].azp03,'/',l_imaa.imaa01
           CALL s_errmsg('azp03,ima01',g_showmsg,g_msg,'lib-028',1)
           LET g_success = 'N'
           EXIT FOR
       ELSE
          IF s_industry('icd') THEN 
             INITIALIZE l_imaicd.* TO NULL
             LET l_imaicd.imaicd00 = l_imaa.imaa01
             LET l_cnt =0
             LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(tm[i].azp01,'imaicd_file'),
                         " WHERE imaicd00 = '",l_imaicd.imaicd00,"'"
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql
             CALL cl_parse_qry_sql(l_sql,tm[i].azp01) RETURNING l_sql
             PREPARE s_aimi100_pre FROM l_sql
             EXECUTE s_aimi100_pre INTO l_cnt
             IF l_cnt = 0 THEN 
                LET l_imaicd.imaicd01 = l_imaa.imaaicd01
                LET l_imaicd.imaicd02 = l_imaa.imaaicd02
                LET l_imaicd.imaicd03 = l_imaa.imaaicd03
                LET l_imaicd.imaicd04 = l_imaa.imaaicd04
                LET l_imaicd.imaicd05 = l_imaa.imaaicd05
                LET l_imaicd.imaicd06 = l_imaa.imaaicd06
                LET l_imaicd.imaicd07 = l_imaa.imaaicd07
                LET l_imaicd.imaicd08 = l_imaa.imaaicd08
                LET l_imaicd.imaicd09 = l_imaa.imaaicd09
                LET l_imaicd.imaicd10 = l_imaa.imaaicd10
                LET l_imaicd.imaicd12 = l_imaa.imaaicd12
                LET l_imaicd.imaicd13 = l_imaa.imaaicd13
                LET l_imaicd.imaicd14 = l_imaa.imaaicd14
                LET l_imaicd.imaicd15 = l_imaa.imaaicd15
                LET l_imaicd.imaicd16 = l_imaa.imaaicd16
                IF NOT s_ins_imaicd(l_imaicd.*,tm[i].azp01) THEN
                   LET g_success = 'N'
                   EXIT FOR
                END IF
             END IF
             IF NOT i009_chk_smd(i,l_imaa.imaa01) THEN
                LET g_success = 'N'
                EXIT FOR
             END IF
          END IF
           CALL i009_ins_imab(tm[i].azp03) #新增主檔拋轉記錄檔
           CALL s_dc_carry_record(g_gev04,tm[i].azp01,g_prog,g_imaa.imaa01,'1')
           IF g_success = 'N' THEN EXIT FOR END IF
           LET l_ima_ins = 'Y'
       END IF
          
       IF l_ima_ins = 'Y' THEN                                             
           CALL s_dc_carry_send_mail_2(l_hs_flag,l_gew08,l_hs_path,l_hist_tab)
       END IF
   END FOR
           
   IF l_ima_ins = 'Y' THEN
       CALL cl_err('','aim-162',0)
   END IF
   CALL ui.Interface.refresh()
END FUNCTION

FUNCTION i009_dbs_upd()
DEFINE l_imaa        RECORD LIKE imaa_file.*
DEFINE l_c,l_s,i     LIKE type_file.num5
DEFINE l_sql         LIKE type_file.chr1000
DEFINE l_cnt         LIKE type_file.num5     
DEFINE l_gew08              LIKE gew_file.gew08 
DEFINE l_hs_flag            LIKE type_file.chr1 
DEFINE l_hs_path            LIKE ze_file.ze03   
DEFINE l_j                  LIKE type_file.num10
DEFINE l_gew05              LIKE gew_file.gew05
DEFINE l_gew07              LIKE gew_file.gew07
DEFINE l_all_cnt            LIKE type_file.num5
DEFINE l_cur_cnt            LIKE type_file.num5
DEFINE l_ima_upd            LIKE type_file.chr1 
DEFINE l_db                 LIKE type_file.chr50
DEFINE l_ima_2       RECORD LIKE ima_file.*

  #讀取相關資料..........................................

   LET g_sql='SELECT * FROM imaa_file WHERE imaano="',g_imaa.imaano CLIPPED,'" '
   PREPARE s_imaa_p FROM g_sql
   DECLARE s_imaa CURSOR FOR s_imaa_p

   FOR i = 1 TO tm.getLength()
       LET l_ima_upd = 'N'
       IF cl_null(tm[i].azp03) THEN CONTINUE FOR END IF
       IF tm[i].sel = 'N' THEN CONTINUE FOR END IF

       SELECT gew05,gew07,gew08 INTO l_gew05,l_gew07,l_gew08 FROM gew_file
        WHERE gew01 = g_gev04
          AND gew02 = '1'
          AND gew04 = tm[i].azp01
       IF cl_null(l_gew07) THEN LET l_gew07 = 'N' END IF

       CALL s_dc_carry_send_mail_1(tm[i].azp01,i,g_gev04,'1',l_hist_tab)
        RETURNING l_hs_flag,l_hs_path

       IF cl_null(tm[i].azp03) OR tm[i].sel = 'N' THEN  CONTINUE FOR END IF
       LET g_sql='SELECT COUNT(*) FROM ',cl_get_target_table(tm[i].azp01,'imaa_file'),
                 'WHERE imaano = ? '
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql,tm[i].azp01) RETURNING g_sql
       PREPARE c_imaa_p FROM g_sql
       DECLARE c_imaa CURSOR FOR c_imaa_p


       #-------------------- UPDATE FILE.dbo.imaa_file ------------------------------
       FOREACH s_imaa INTO l_imaa.*
          IF STATUS THEN
             CALL cl_err('foreach imaa',STATUS,0)
             EXIT FOREACH
          END IF
          OPEN c_imaa USING l_imaa.imaano
          FETCH c_imaa INTO l_cnt
             LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(tm[i].azp01, 'ima_file'),
                                " WHERE ima01=? FOR UPDATE"
             LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
             CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql
             CALL cl_parse_qry_sql(g_forupd_sql,tm[i].azp01) RETURNING g_forupd_sql
             DECLARE i009_cs2_ima_lock CURSOR FROM g_forupd_sql
             OPEN i009_cs2_ima_lock USING l_imaa.imaa01
             IF STATUS THEN
                LET g_msg = tm[i].azp03 CLIPPED,':ima_file:lock'
                LET g_showmsg=tm[i].azp03,'/',l_imaa.imaa01
                CALL s_errmsg('azp03,ima01',g_showmsg,g_msg,STATUS,1)
                CLOSE i009_cs2_ima_lock
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             FETCH i009_cs2_ima_lock INTO l_ima_2.*
             IF SQLCA.SQLCODE THEN
                LET g_msg = tm[i].azp03 CLIPPED,':ima_file:lock'
                LET g_showmsg=tm[i].azp03,'/',l_imaa.imaa01
                CALL s_errmsg('azp03,ima01',g_showmsg,g_msg,SQLCA.SQLCODE,1)
                CLOSE i009_cs2_ima_lock
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             LET l_sql='UPDATE ',cl_get_target_table(tm[i].azp01,'ima_file'),
                       '   SET ima02=?   ,ima021 =? ,',
                       '       ima916=?             ,',
                       '       imamodu=? ,imadate=?  ',
                       ' WHERE ima01 =? '
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql
             CALL cl_parse_qry_sql(l_sql,tm[i].azp01) RETURNING l_sql
             PREPARE u_imaa FROM l_sql
             EXECUTE u_imaa USING l_imaa.imaa02 ,l_imaa.imaa021,
                                  g_plant,
                                  g_user,g_today,
                                  l_imaa.imaa01
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 LET g_msg = 'UPDATE ',cl_get_target_table(tm[i].azp01,'ima_file') 
                 LET g_showmsg=tm[i].azp03,'/',l_imaa.imaa01
                 CALL s_errmsg('azp03,ima01',g_showmsg,g_msg,'lib-028',1)
                 LET g_success = 'N'
                 EXIT FOREACH 
             ELSE
                 IF s_industry('icd') THEN 
                    IF NOT i009_chk_smd(i,l_imaa.imaa01) THEN
                       LET g_success = 'N'
                       EXIT FOREACH            
                    END IF 
                 END IF
                 CALL i009_ins_imab(tm[i].azp03) #新增主檔拋轉記錄檔
                 CALL s_dc_carry_record(g_gev04,tm[i].azp01,g_prog,g_imaa.imaa01,'1')
                 IF g_success = 'N' THEN EXIT FOREACH END IF
                 LET l_ima_upd = 'Y'
             END IF
             CLOSE i009_cs2_ima_lock
       END FOREACH
       IF l_ima_upd = 'Y' THEN      
           CALL s_dc_carry_send_mail_2(l_hs_flag,l_gew08,l_hs_path,l_hist_tab)
       END IF
   END FOR
                
   IF l_ima_upd = 'Y' THEN
       CALL cl_err('','aim-162',0)
   END IF
   CALL ui.Interface.refresh() 

END FUNCTION

FUNCTION i009_default_imz(p_imaa)
DEFINE p_imaa RECORD LIKE imaa_file.*
   
   LET g_sql = "SELECT imz03,imz04,",
               "       imz07,imz08,imz09,imz10,",
               "       imz11,imz12,imz14,imz15,",
               "       imz17,imz19,imz21,",
               "       imz23,imz24,imz27,",
               "       imz28,imz34,",
               "       imz35,imz36,imz37,imz38,",
               "       imz39,imz42,imz43,",
               "       imz45,imz46 ,imz47,",
               "       imz48,imz49,imz491,imz50,",
               "       imz51,imz52,imz54,",
               "       imz56,imz561,imz562,",
               "       imz571,",
               "       imz59 ,imz60,imz61,imz62,",
               "       imz64,imz641,",
               "       imz65,imz66,imz67,imz68,",
               "       imz69,imz70,imz71,",
               "       imz87,imz871,imz872,",
               "       imz873,imz874,imz88,imz89,",
               "       imz90,imz94,imz99,imz100 ,",
               "       imz101,imz102 ,imz103,imz105,",
               "       imz106,imz107,imz108,imz109,",
               "       imz110,imz130,imz131,imz132,",
               "       imz133,imz134,",
               "       imz147,imz148,imz903,",
               "       imz909,imz153,",      
               "       imz911,",
               "       imz136,imz137,imz391,imz1321,",
               "       imz72",
               "      ,imzicd01,imzicd02,imzicd03,imzicd04,imzicd05,",
               "       imzicd06,imzicd07,imzicd08,imzicd09,imzicd10,",
               "       imzicd12,imzicd13,imzicd14,imzicd15,imzicd16",
               "  FROM ",cl_get_target_table(g_azp01,'imz_file'),
               " WHERE imz01 ='",p_imaa.imaa06 CLIPPED,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
   CALL cl_parse_qry_sql(g_sql,g_azp01) RETURNING g_sql   
   PREPARE ima06_p11 FROM g_sql

   EXECUTE ima06_p11 INTO p_imaa.imaa03,p_imaa.imaa04,
                         p_imaa.imaa07,p_imaa.imaa08,p_imaa.imaa09,p_imaa.imaa10,
                         p_imaa.imaa11,p_imaa.imaa12,p_imaa.imaa14,p_imaa.imaa15,
                         p_imaa.imaa17,p_imaa.imaa19,p_imaa.imaa21,
                         p_imaa.imaa23,p_imaa.imaa24,p_imaa.imaa27,
                         p_imaa.imaa28,p_imaa.imaa34,
                         p_imaa.imaa35,p_imaa.imaa36,p_imaa.imaa37,p_imaa.imaa38,
                         p_imaa.imaa39,p_imaa.imaa42,p_imaa.imaa43,
                         p_imaa.imaa45,p_imaa.imaa46,p_imaa.imaa47,
                         p_imaa.imaa48,p_imaa.imaa49,p_imaa.imaa491,p_imaa.imaa50,
                         p_imaa.imaa51,p_imaa.imaa52,p_imaa.imaa54,
                         p_imaa.imaa56,p_imaa.imaa561,p_imaa.imaa562,
                         p_imaa.imaa571,
                         p_imaa.imaa59,p_imaa.imaa60,p_imaa.imaa61,p_imaa.imaa62,
                         p_imaa.imaa64,p_imaa.imaa641,
                         p_imaa.imaa65,p_imaa.imaa66,p_imaa.imaa67,p_imaa.imaa68,
                         p_imaa.imaa69,p_imaa.imaa70,p_imaa.imaa71,
                         p_imaa.imaa87,p_imaa.imaa871,p_imaa.imaa872,
                         p_imaa.imaa873,p_imaa.imaa874,p_imaa.imaa88,p_imaa.imaa89,
                         p_imaa.imaa90,p_imaa.imaa94,p_imaa.imaa99,p_imaa.imaa100,
                         p_imaa.imaa101,p_imaa.imaa102,p_imaa.imaa103,p_imaa.imaa105,
                         p_imaa.imaa106,p_imaa.imaa107,p_imaa.imaa108,p_imaa.imaa109,
                         p_imaa.imaa110,p_imaa.imaa130,p_imaa.imaa131,p_imaa.imaa132,
                         p_imaa.imaa133,p_imaa.imaa134,
                         p_imaa.imaa147,p_imaa.imaa148,p_imaa.imaa903,
                         p_imaa.imaa909,p_imaa.imaa153,         
                         p_imaa.imaa911,
                         p_imaa.imaa136,p_imaa.imaa137,p_imaa.imaa391,p_imaa.imaa1321,
                         p_imaa.imaa915
                        ,p_imaa.imaaicd01,p_imaa.imaaicd02,p_imaa.imaaicd03,
                         p_imaa.imaaicd04,p_imaa.imaaicd05,p_imaa.imaaicd06,
                         p_imaa.imaaicd07,p_imaa.imaaicd08,p_imaa.imaaicd09,
                         p_imaa.imaaicd10,p_imaa.imaaicd12,p_imaa.imaaicd13,
                         p_imaa.imaaicd14,p_imaa.imaaicd15,p_imaa.imaaicd16
      IF STATUS THEN
         CALL cl_err('sel imz',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN p_imaa.*     
      END IF
   IF p_imaa.imaa99  IS NULL THEN LET p_imaa.imaa99 = 0 END IF
   IF p_imaa.imaa133 IS NULL THEN LET p_imaa.imaa133 = p_imaa.imaa01 END IF
   RETURN p_imaa.*

END FUNCTION

FUNCTION i009_chk_smd(i,l_ima01) 
DEFINE i        LIKE type_file.num5
DEFINE l_ima01  LIKE ima_file.ima01 
DEFINE l_sql    LIKE type_file.chr1000
DEFINE l_ima    RECORD LIKE ima_file.*
DEFINE l_imaicd RECORD LIKE imaicd_file.* 
DEFINE l_smd    RECORD LIKE smd_file.*
                         
    LET g_showmsg=tm[i].azp03,'/',l_ima01
                         
    #sel ima_file        
    LET l_sql = "SELECT * FROM ima_file WHERE ima01 = ? "
    PREPARE icd_ima_c1 FROM l_sql
    EXECUTE icd_ima_c1 INTO l_ima.* USING l_ima01
    IF SQLCA.sqlcode THEN
       LET g_msg = 'select ',cl_get_target_table(tm[i].azp01,'ima_file')    
       CALL s_errmsg('azp03,ima01',g_showmsg,g_msg,SQLCA.SQLCODE,1)
    END IF               
    IF cl_null(l_ima.ima01) THEN
       RETURN FALSE      
    END IF               
                         
    #sel imaicd_file     
    LET l_sql = "SELECT * FROM imaicd_file WHERE imaicd00 = ? "
    PREPARE icd_imaicd_c1 FROM l_sql
    EXECUTE icd_imaicd_c1 INTO l_imaicd.* USING l_ima01
    IF SQLCA.sqlcode THEN
       LET g_msg = 'select ',cl_get_target_table(tm[i].azp01,'imaicd_file') 
       CALL s_errmsg('azp03,imaicd00',g_showmsg,g_msg,SQLCA.SQLCODE,1)
    END IF               
    IF cl_null(l_imaicd.imaicd00) THEN 
       RETURN FALSE      
    END IF
    
    LET l_smd.smd01 =  l_ima.ima01
    LET l_smd.smdacti = 'Y'
    LET l_smd.smdpos =  '1'
    LET l_smd.smddate =  NULL

    CASE l_ima.ima906
       WHEN '1'   #單一單位
          LET l_smd.smd02 = l_ima.ima25
          LET l_smd.smd03 = l_ima.ima25
          LET l_smd.smd04 = 1
          LET l_smd.smd06 = 1
          IF NOT i009_ins_smd(i,l_smd.*) THEN
             RETURN FALSE
          END IF
       WHEN '3'   #參考單位
          IF l_imaicd.imaicd14 = 0 OR cl_null(l_imaicd.imaicd14) THEN
             RETURN FALSE
          END IF
          #第一筆
          LET l_smd.smd02 = l_ima.ima25
          LET l_smd.smd03 = l_ima.ima907
          LET l_smd.smd04 = 1
          LET l_smd.smd06 = l_imaicd.imaicd14
          LET l_smd.smd06 = s_digqty(l_smd.smd06,l_smd.smd03)
          IF NOT i009_ins_smd(i,l_smd.*) THEN
             RETURN FALSE
          END IF
          #第二筆
          LET l_smd.smd02 = l_ima.ima907
          LET l_smd.smd03 = l_ima.ima25
          LET l_smd.smd04 = l_imaicd.imaicd14
          LET l_smd.smd04 = s_digqty(l_smd.smd04,l_smd.smd02)
          LET l_smd.smd06 = 1
          IF NOT i009_ins_smd(i,l_smd.*) THEN
             RETURN FALSE
          END IF
    END CASE
    RETURN TRUE
END FUNCTION

FUNCTION i009_ins_smd(i,l_smd)
DEFINE i     LIKE type_file.num5
DEFINE l_sql LIKE type_file.chr1000
DEFINE l_cnt LIKE type_file.num10
DEFINE l_smd RECORD LIKE smd_file.*
DEFINE l_str1_smd           STRING
DEFINE l_str2_smd           STRING
DEFINE l_str3_smd           STRING

    LET g_showmsg=tm[i].azp03,'/',l_smd.smd01
    #sel smd_file count
    LET l_sql = "SELECT COUNT(smd01) FROM ",cl_get_target_table(tm[i].azp01,'smd_file'),
                " WHERE smd01 = ? AND smd02 = ? AND smd03 = ? "
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
    CALL cl_parse_qry_sql(l_sql,tm[i].azp01) RETURNING l_sql
    PREPARE icd_smd_c1 FROM l_sql
    EXECUTE icd_smd_c1 INTO l_cnt USING l_smd.smd01,l_smd.smd02,l_smd.smd03
    IF SQLCA.sqlcode THEN
       LET g_msg = 'select ',cl_get_target_table(tm[i].azp01,'smd_file')
       CALL s_errmsg('azp03,smd01',g_showmsg,g_msg,SQLCA.SQLCODE,1)
       RETURN FALSE
    END IF

    IF l_cnt > 0 THEN   #已存在更新新GROSS換算率
       LET l_sql = "UPDATE ",cl_get_target_table(tm[i].azp01,'smd_file'),
                    " SET smd04 = ?, smd06 = ?",
                    " WHERE smd01 = ? AND smd02 = ? AND smd03 = ?"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       CALL cl_parse_qry_sql(l_sql,tm[i].azp01) RETURNING l_sql
       PREPARE icd_smd_c2 FROM l_sql
       EXECUTE icd_smd_c2 USING l_smd.smd04,l_smd.smd06,
                                l_smd.smd01,l_smd.smd02,l_smd.smd03
       IF SQLCA.sqlcode THEN
          LET g_msg = 'update ',cl_get_target_table(tm[i].azp01,'smd_file')
          CALL s_errmsg('azp03,smd01',g_showmsg,g_msg,SQLCA.SQLCODE,1)
          RETURN FALSE
       END IF
    ELSE
       #定義cursor
       CALL s_carry_p_cs()
       CALL s_carry_col('smd_file') RETURNING l_str1_smd,l_str2_smd,l_str3_smd
       LET l_sql = "INSERT INTO ",cl_get_target_table(tm[i].azp01,'smd_file'),
                  " VALUES(",l_str2_smd,")"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       CALL cl_parse_qry_sql(l_sql,tm[i].azp01) RETURNING l_sql
       PREPARE icd_smd_c3 FROM l_sql
       EXECUTE icd_smd_c3 USING l_smd.*
       IF SQLCA.sqlcode THEN
          LET g_msg = 'insert ',cl_get_target_table(tm[i].azp01,'smd_file')
          CALL s_errmsg('azp03,smd01',g_showmsg,g_msg,SQLCA.SQLCODE,1)
          RETURN FALSE
       END IF
    END IF
    RETURN TRUE
END FUNCTION

FUNCTION i009_ins_imab(l_dbs) #新增主檔拋轉記錄檔
  DEFINE l_dbs        LIKE azp_file.azp03

    INSERT INTO imab_file(imab00,imabno,imab01,imabtype,imabdate,imabdb)
       VALUES (g_imaa.imaa00,g_imaa.imaano,g_imaa.imaa01,'1',g_today,l_dbs)
    IF SQLCA.sqlcode THEN
        LET g_showmsg=g_imaa.imaa00,'/',g_imaa.imaano,'/',g_imaa.imaa01
        CALL s_errmsg('imaa00,imaano,imaa01',g_showmsg,'',SQLCA.sqlcode,1)
        LET g_success='N'
    END IF
    IF SQLCA.sqlerrd[3]=0 THEN
        LET g_showmsg=g_imaa.imaa00,'/',g_imaa.imaano,'/',g_imaa.imaa01
        CALL s_errmsg('imaa00,imaano,imaa01',g_showmsg,'',SQLCA.sqlcode,1)
        LET g_success='N'
    END IF
END FUNCTION
#FUN-BC0076
