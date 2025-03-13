# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Program name...: s_abmi500_carry.4gl
# Descriptions...: BOM資料整批拋轉
# Date & Author..: 11/01/24 By lixh1 FUN-B10013
# # Modify.........: No.FUN-B20101 11/02/28 By shenyang 將abmi500改成三階結構
# Modify.........: No.TQC-C60072 12/06/04 By fengrui 拋轉檢查sql修改
DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../../aim/4gl/aimi100.global" 
GLOBALS "../../sub/4gl/s_data_center.global"   

DEFINE g_bra_1    DYNAMIC ARRAY OF RECORD
                  sel      LIKE type_file.chr1,
                  bra01    LIKE bra_file.bra01,
                  bra011   LIKE bra_file.bra011
                  END RECORD
DEFINE g_azp      DYNAMIC ARRAY OF RECORD
                  sel      LIKE type_file.chr1,
                  azp01    LIKE azp_file.azp01,
                  azp02    LIKE azp_file.azp02,
                  azp03    LIKE azp_file.azp03
                  END RECORD
                  
DEFINE g_gev04    LIKE gev_file.gev04 
DEFINE g_brax     DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                  sel         LIKE type_file.chr1,
                  bra01       LIKE bra_file.bra01,
                  bra011      LIKE bra_file.bra011
                  END RECORD      

DEFINE g_msg1     LIKE type_file.chr1000
DEFINE g_msg2     LIKE type_file.chr1000
DEFINE g_msg3     LIKE type_file.chr1000
DEFINE g_msg4     LIKE type_file.chr1000
DEFINE g_msg_x    LIKE type_file.chr1000
DEFINE g_err      LIKE type_file.chr1000
DEFINE g_bra      RECORD LIKE bra_file.*
DEFINE g_brb      RECORD LIKE brb_file.*
DEFINE g_dbs_sep  LIKE type_file.chr50
DEFINE g_all_cnt  LIKE type_file.num10    #記錄是否有要拋轉的資料
DEFINE g_cur_cnt  LIKE type_file.num10    #當前營運中心滿足拋轉條件的筆數
DEFINE g_plant_sep LIKE azp_file.azp01    

FUNCTION s_abmi500_carry(p_bra,p_azp,p_gev04,p_bra01,p_bra011,p_plant)  
  DEFINE p_bra                DYNAMIC ARRAY OF RECORD
                              sel      LIKE type_file.chr1,
                              bra01    LIKE bra_file.bra01,
                              bra011   LIKE bra_file.bra011
                              END RECORD
  DEFINE p_azp                DYNAMIC ARRAY OF RECORD
                              sel      LIKE type_file.chr1,
                              azp01    LIKE azp_file.azp01,
                              azp02    LIKE azp_file.azp02,
                              azp03    LIKE azp_file.azp03
                              END RECORD
  DEFINE p_plant              LIKE azp_file.azp01
  DEFINE p_gev04              LIKE gev_file.gev04
  DEFINE p_bra01              LIKE bra_file.bra01
  DEFINE p_bra011             LIKE bra_file.bra011 
  DEFINE l_plant              LIKE azp_file.azp01
  DEFINE l_n                  LIKE type_file.num10
  DEFINE l_n1                 LIKE type_file.num10     
  DEFINE l_i                  LIKE type_file.num10
  DEFINE l_j                  LIKE type_file.num10
  DEFINE l_sql                STRING
  DEFINE l_str1               STRING
  DEFINE l_str2               STRING
  DEFINE l_str3               STRING
  DEFINE l_str4               STRING
  DEFINE l_str1_brb           STRING
  DEFINE l_str2_brb           STRING
  DEFINE l_str3_brb           STRING
  DEFINE l_str4_brb           STRING  
  DEFINE l_bra01              LIKE bra_file.bra01
  DEFINE l_bra01_old          LIKE bra_file.bra01
  DEFINE l_bra06_old          LIKE bra_file.bra06
  DEFINE l_bra011_old         LIKE bra_file.bra011  
  DEFINE l_bra011             LIKE bra_file.bra011
  DEFINE l_bra012_old         LIKE bra_file.bra012
  DEFINE l_bra013_old         LIKE bra_file.bra013
  DEFINE l_dbs_sep            LIKE type_file.chr50
  DEFINE l_gew05              LIKE gew_file.gew05
  DEFINE l_gew07              LIKE gew_file.gew07
  DEFINE l_gez04              LIKE gez_file.gez04
  DEFINE l_gez05              LIKE gez_file.gez05
  DEFINE l_tabname            LIKE type_file.chr50
  DEFINE l_bra                RECORD LIKE bra_file.*
  DEFINE l_gew08              LIKE gew_file.gew08     #for mail
  DEFINE l_hist_tab           LIKE type_file.chr50    #for mail
  DEFINE l_hs_flag            LIKE type_file.chr1     #for mail
  DEFINE l_hs_path            LIKE ze_file.ze03       #for mail
  DEFINE l_bra_upd            LIKE type_file.chr1     #no.FUN-840033 add  
  DEFINE l_count              LIKE type_file.num10
  DEFINE l_sum                LIKE type_file.num10
  DEFINE l_ecb06              LIKE ecb_file.ecb06

  WHENEVER ERROR CALL cl_err_msg_log
  IF p_bra.getLength() = 0 THEN 
     RETURN 
  END IF  
  #檢查是否有拋轉到的資料庫
  IF p_azp.getLength() = 0 THEN 
      RETURN 
  END IF
  CALL g_bra_1.clear()
  #前置准備
  FOR l_i = 1 TO p_bra.getLength()
      LET g_bra_1[l_i].* = p_bra[l_i].*
  END FOR
  FOR l_i = 1 TO p_azp.getLength()
      LET g_azp[l_i].* = p_azp[l_i].*
  END FOR
  LET g_gev04 = p_gev04
  LET g_db_type=cl_db_get_database_type()

  #定義cursor
  CALL s_carry_p_cs()
  #default aooi602中設置的預設值
  LET g_sql = " SELECT gez04,gez05 FROM gez_file ",
              "  WHERE gez01 = '",g_gev04 CLIPPED,"'",
              "    AND gez02 = '2'",
              "    AND gez03 = ?  "
  PREPARE gez_p FROM g_sql
  DECLARE gez_cur CURSOR WITH HOLD FOR gez_p

  #組column
  CALL s_carry_col('bra_file') RETURNING l_str1,l_str2,l_str3  
  CALL s_carry_col('brb_file') RETURNING l_str1_brb,l_str2_brb,l_str3_brb
  
  #組index
  CALL s_carry_idx('bra_file') RETURNING l_str4
  CALL s_carry_idx('brb_file') RETURNING l_str4_brb  
  #建立臨時表,用于存放拋轉的資料
  CALL s_abmi500_carry_p1() RETURNING l_tabname  
  IF g_all_cnt = 0 THEN
     CALL cl_err('','aap-129',1)
     RETURN
  END IF  
  #建立歷史資料拋轉的臨時表
  CALL s_dc_cre_temp_table("gex_file") RETURNING l_hist_tab

  LET g_sql = " SELECT * FROM brb_file WHERE brb01=? AND brb011 = ?"
  PREPARE brb_p FROM g_sql
  DECLARE brb_cur CURSOR WITH HOLD FOR brb_p  

  FOR l_j = 1 TO g_azp.getLength()
     IF cl_null(g_azp[l_j].azp03) THEN CONTINUE FOR END IF
     IF g_azp[l_j].sel = 'N' THEN CONTINUE FOR END IF
 
     SELECT gew05,gew07,gew08 INTO l_gew05,l_gew07,l_gew08 FROM gew_file
      WHERE gew01 = g_gev04
        AND gew02 = '2'
        AND gew04 = g_azp[l_j].azp01
     IF cl_null(l_gew07) THEN LET l_gew07 = 'N' END IF
     IF NOT s_abmi500_carry_chk_ecb(p_bra01,p_bra011,p_plant,g_azp[l_j].azp01,'ecb_file') THEN
        LET g_success = 'N'
        EXIT FOR                     #FUN-B20101 
     END IF
     LET g_sql= "SELECT DISTINCT ecb06 FROM ",cl_get_target_table(p_plant,'ecb_file'), 
                " WHERE ecb01 = '",p_bra01,"'",
                "   AND ecb02 = '",p_bra011,"'"
     PREPARE ecb_p FROM g_sql
     DECLARE ecb_cur CURSOR WITH HOLD FOR ecb_p
     LET l_sum = 0
     FOREACH ecb_cur INTO l_ecb06 
        IF SQLCA.sqlcode THEN
           CALL s_errmsg('bra01',"",'foreach',SQLCA.sqlcode,1)
           LET g_success = 'N'         #FUN-B20101
           EXIT FOREACH  
        END IF
        LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_azp[l_j].azp01,'ecd_file'),
                    " WHERE ecd01 = '",l_ecb06,"'"
        PREPARE ecd_p FROM l_sql
        EXECUTE ecd_p INTO l_count 
        IF cl_null(l_count) THEN 
           LET l_count = 0
        END IF
        IF l_count = 0 THEN 
           CALL s_errmsg('bra01',l_ecb06,g_azp[l_j].azp01,'abm-750',1)
           LET l_sum = l_sum + 1
           CONTINUE FOREACH
        END IF        
     END FOREACH
     IF l_sum > 0 THEN
        LET g_success = 'N'          #FUN-B20101
        EXIT FOR                     #FUN-B20101 
   #    CONTINUE FOR                 #FUN-B20101
     END IF
#FUN-B20101--add--bdgin 
  END FOR 
  IF g_success = 'N' THEN
      CALL s_dc_drop_temp_table(l_tabname)
      CALL s_dc_drop_temp_table(l_hist_tab)
      RETURN
  END IF  
  FOR l_j = 1 TO g_azp.getLength()
     IF cl_null(g_azp[l_j].azp03) THEN CONTINUE FOR END IF
     IF g_azp[l_j].sel = 'N' THEN CONTINUE FOR END IF
     SELECT gew05,gew07,gew08 INTO l_gew05,l_gew07,l_gew08 FROM gew_file
      WHERE gew01 = g_gev04
        AND gew02 = '2'
        AND gew04 = g_azp[l_j].azp01
     IF cl_null(l_gew07) THEN LET l_gew07 = 'N' END IF
#FUN-B20101--add-end
     #mail_1                                                              
     CALL s_dc_carry_send_mail_1(g_azp[l_j].azp01,l_j,g_gev04,'2',l_hist_tab)
          RETURNING l_hs_flag,l_hs_path
 
     CALL s_dbstring(g_azp[l_j].azp03) RETURNING l_dbs_sep
     LET g_dbs_sep = l_dbs_sep
     LET g_plant_sep = g_azp[l_j].azp01   

     LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'bra_file'),   
                 " VALUES(",l_str2,")"
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
     CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  
     PREPARE db_cs1 FROM g_sql
   
     LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'bra_file'),  
                 "   SET ",l_str3,
                 " WHERE ",l_str4
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
     CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  
     PREPARE db_cs2 FROM g_sql
 
     LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01,'brb_file'),  
                 " VALUES(",l_str2_brb,")"
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
     CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  
     PREPARE db_cs1_brb FROM g_sql

     LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01,'brb_file'),   
                 "   SET ",l_str3_brb,
                 " WHERE ",l_str4_brb
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
     CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  
     PREPARE db_cs2_brb FROM g_sql
 

     #default aooi602中設置的預設值
     LET l_bra01 = NULL

     FOREACH gez_cur USING g_azp[l_j].azp01 INTO l_gez04,l_gez05
        IF SQLCA.sqlcode THEN
           CALL s_errmsg('gez03',g_azp[l_j].azp01,'foreach',SQLCA.sqlcode,1)
           CONTINUE FOREACH
        END IF
        IF l_gez04 = 'bra01'  THEN LET l_bra01  = l_gez05 END IF
     END FOREACH
 
     #定義拋轉的SQL
     LET g_sql = " SELECT * FROM ",l_tabname CLIPPED,
                 "  WHERE ",l_gew05 CLIPPED
     PREPARE carry_p1 FROM g_sql
     DECLARE carry_cur1 CURSOR WITH HOLD FOR carry_p1
 
     #當前營運中心,滿足aooi602拋轉條件的筆數
     LET g_cur_cnt = 0
     LET g_sql = " SELECT COUNT(*) FROM ",l_tabname CLIPPED,                         
                 "  WHERE ",l_gew05 CLIPPED                                   
     PREPARE cnt_p1 FROM g_sql                                              
     EXECUTE cnt_p1 INTO g_cur_cnt
     IF cl_null(g_cur_cnt) THEN LET g_cur_cnt = 0 END IF

     LET l_bra_upd = 'N'     
     LET g_success = 'Y'
     BEGIN WORK
     FOREACH carry_cur1 INTO g_bra.*
       IF SQLCA.sqlcode THEN
          CALL s_errmsg('bra01',g_bra.bra01,'foreach',SQLCA.sqlcode,1)
       #  CONTINUE FOREACH       #FUN-B20101
          LET g_success = 'N'
          EXIT FOREACH           #FUN-B20101
       END IF
 
       LET g_msg1 = 'ins ',g_azp[l_j].azp03 CLIPPED,':',g_bra.bra01 CLIPPED,'+',g_bra.bra011 CLIPPED,':'
       LET g_msg2 = 'upd ',g_azp[l_j].azp03 CLIPPED,':',g_bra.bra01 CLIPPED,'+',g_bra.bra011 CLIPPED,':'
 
       LET l_bra01_old = g_bra.bra01
       LET l_bra011_old = g_bra.bra011
       LET l_bra06_old = g_bra.bra06
       LET l_bra012_old = g_bra.bra012
       LET l_bra013_old = g_bra.bra013

       IF NOT cl_null(l_bra01)  THEN LET g_bra.bra01  = l_bra01  END IF
 
        #check item exist or not ?
        IF NOT s_abmi500_carry_chk_ima(g_bra.bra01,'bra_file') THEN
           LET g_success = 'N'
        END IF
 
        LET g_bra.bra08 = g_plant
        LET g_bra.bra09 = 1
        #把數據插入到要拋轉的目標資料庫中
        EXECUTE db_cs1 USING g_bra.*
        IF SQLCA.sqlcode = 0 THEN
           MESSAGE g_msg1 CLIPPED,':OK'
           CALL ui.Interface.refresh()
        ELSE
           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #若此筆數據在目標資料庫中已經存在

              IF l_gew07 = 'N' THEN
                 MESSAGE g_msg1 CLIPPED,':exist'
                 CALL ui.Interface.refresh()
                 LET g_success = 'N'         
              ELSE
                 LET g_sql = "SELECT bra09 FROM ",cl_get_target_table(g_azp[l_j].azp01,'bra_file'),    
                             " WHERE bra01='",l_bra01_old ,"'",
                             "   AND bra011='",l_bra011_old ,"'"
                 CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
                 CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  
                 PREPARE bra_p1 FROM g_sql
                 EXECUTE bra_p1 INTO g_bra.bra09
                 IF cl_null(g_bra.bra09) THEN LET g_bra.bra09 = 0 END IF
                 LET g_bra.bra09 = g_bra.bra09 + 1    #拋轉次數
 
                 EXECUTE db_cs2 USING g_bra.*,l_bra01_old,l_bra06_old,l_bra011_old,l_bra012_old,l_bra013_old   #更新
                 IF SQLCA.sqlcode = 0 THEN
                    MESSAGE g_msg2 CLIPPED,':ok'
                    CALL ui.Interface.refresh()
                 ELSE
                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                    LET g_showmsg = g_bra.bra01 ,"/", g_bra.bra011
                    CALL s_errmsg('bra01,bra011',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                    MESSAGE g_msg2 CLIPPED,':fail'
                    CALL ui.Interface.refresh()
                    LET g_success = 'N'
                 END IF
              END IF
           ELSE
              LET g_msg_x = g_azp[l_j].azp01,':ins'
              LET g_showmsg = g_bra.bra01 ,"/", g_bra.bra06,"/", g_bra.bra011,"/", g_bra.bra012,"/", g_bra.bra013
              CALL s_errmsg('bra01,bra06,bra011,bra012,bra013',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
              MESSAGE g_msg1 CLIPPED,':fail'
              CALL ui.Interface.refresh()
              LET g_success = 'N'
           END IF
        END IF
        IF g_success = 'Y' THEN
            CALL s_dc_carry_record(g_gev04,g_azp[l_j].azp01,g_prog,g_bra.bra01||'+'||g_bra.bra06||'+'||g_bra.bra011||'+'||g_bra.bra012||'+'||g_bra.bra013,'2')
            CALL s_abmi500_brb1(l_bra01_old,l_bra01,l_bra011_old,l_bra011,g_azp[l_j].azp01,l_gew07)
        END IF
     END FOREACH
     IF g_success = 'N' THEN
        ROLLBACK WORK
     ELSE
        LET l_bra_upd = 'Y'  
        COMMIT WORK
     END IF
     #mail 2          
     IF g_success = 'Y' THEN 
        LET l_bra_upd = 'Y'
     END IF
     IF l_bra_upd = 'Y' THEN                                                   
         CALL s_dc_carry_send_mail_2(l_hs_flag,l_gew08,l_hs_path,l_hist_tab)
     END IF                   
  END FOR
 
  CALL s_dc_drop_temp_table(l_tabname)
  CALL s_dc_drop_temp_table(l_hist_tab)
 

 #MESSAGE 'Data Carry Finish!'
  IF l_bra_upd = 'Y' THEN
     CALL cl_err('','aim-162',0)
  END IF 
 
  CALL ui.Interface.refresh()

END FUNCTION  



FUNCTION s_abmi500_brb1(p_bra01_old,p_bra01_new,p_bra011_old,p_bra011_new,p_azp01,p_gew07)
   DEFINE p_bra01_old     LIKE bra_file.bra01
   DEFINE p_bra01_new     LIKE bra_file.bra01
   DEFINE p_bra011_old     LIKE bra_file.bra06
   DEFINE p_bra011_new     LIKE bra_file.bra06
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
 
   FOREACH brb_cur USING p_bra01_old,p_bra011_old INTO g_brb.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('brb01',g_brb.brb01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_bra01_new) THEN LET g_brb.brb01 = p_bra01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_brb.brb01 CLIPPED,'+',g_brb.brb02 CLIPPED,'+',g_brb.brb03 CLIPPED,'+',g_brb.brb04 CLIPPED,'+',g_brb.brb011 CLIPPED,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_brb.brb01 CLIPPED,'+',g_brb.brb02 CLIPPED,'+',g_brb.brb03 CLIPPED,'+',g_brb.brb04 CLIPPED,'+',g_brb.brb011 CLIPPED,':'
      #check item exist or not ?
      IF NOT s_abmi500_carry_chk_ima(g_brb.brb03,'brb_file') THEN
         LET g_success = 'N'
      END IF
      EXECUTE db_cs1_brb USING g_brb.*
      IF SQLCA.sqlcode = 0 THEN
         IF g_success = 'Y' THEN
            MESSAGE g_msg3 CLIPPED,':ok'
            CALL ui.Interface.refresh()
         END IF
      ELSE
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #若此筆數據在目標資料庫中已經存在
            IF p_gew07 = 'N' THEN
               MESSAGE g_msg3 CLIPPED,':exist'
               CALL ui.Interface.refresh()
               LET g_success = 'N'   
            ELSE
               EXECUTE db_cs2_brb USING g_brb.*,p_bra01_old,g_brb.brb02,g_brb.brb03,g_brb.brb04,
                                        g_brb.brb29,g_brb.brb011,g_brb.brb012,g_brb.brb013
               IF SQLCA.sqlcode = 0 THEN
                  IF g_success = 'Y' THEN
                     MESSAGE g_msg4 CLIPPED,':ok'
                     CALL ui.Interface.refresh()
                  END IF
               ELSE
                  LET g_msg_x = p_azp01,':upd'
                  LET g_showmsg = g_brb.brb01,'/',g_brb.brb02,'/',g_brb.brb03,'/',g_brb.brb04,'/',g_brb.brb29
                  CALL s_errmsg('brb01,brb02,brb03,brb04,brb29',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                  MESSAGE g_msg4 CLIPPED,':fail'
                  CALL ui.Interface.refresh()
                  LET g_success = 'N'
               END IF
            END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_brb.brb01,'/',g_brb.brb02,'/',g_brb.brb03,'/',g_brb.brb04,'/',g_brb.brb29,'/',g_brb.brb011,'/',g_brb.brb012,'/',g_brb.brb013
            CALL s_errmsg('brb01,brb02,brb03,brb04,brb29,brb011,brb012,brb013',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3 CLIPPED,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      IF g_success = 'Y' THEN
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_brb.brb01||'+'||g_brb.brb02||'+'||g_brb.brb03||'+'||g_brb.brb04||'+'||g_brb.brb29||'+'||g_brb.brb011||'+'||g_brb.brb012||'+'||g_brb.brb013,'2')
      END IF
   END FOREACH
END FUNCTION

FUNCTION s_abmi500_carry_p1()
   DEFINE l_i                  LIKE type_file.num10
   DEFINE l_tabname            STRING                            
   DEFINE l_str                STRING                    
 
   CALL s_dc_cre_temp_table("bra_file") RETURNING l_tabname

   LET g_sql = " CREATE UNIQUE INDEX ",l_tabname CLIPPED,"_01 ON ",l_tabname CLIPPED,"(bra01,bra06,bra011,bra012,bra013)"
 
   PREPARE unique_p1 FROM g_sql
   EXECUTE unique_p1
 
   LET g_sql = " INSERT INTO ",l_tabname CLIPPED," SELECT * FROM bra_file",
                                                 "  WHERE bra01 = ? AND bra011 = ?",
                                                 "    AND bra10 = '2'"
   PREPARE ins_pp FROM g_sql
 
   LET g_all_cnt = 0


   FOR l_i = 1 TO g_bra_1.getLength()
      IF cl_null(g_bra_1[l_i].bra01) THEN
         CONTINUE FOR
      END IF
      IF g_bra_1[l_i].sel = 'N' THEN
         CONTINUE FOR
      END IF
      EXECUTE ins_pp USING g_bra_1[l_i].bra01,g_bra_1[l_i].bra011

      IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.SQLCODE) THEN

         LET l_str = "ins ",l_tabname                      
         IF g_bgerr THEN                                                    
            CALL s_errmsg('','',l_str,SQLCA.sqlcode,1)   
         ELSE                                                               
            CALL cl_err(l_str,SQLCA.sqlcode,1)           
         END IF
         CONTINUE FOR
      END IF
      LET g_all_cnt = g_all_cnt + 1
   END FOR
   RETURN l_tabname
END FUNCTION

FUNCTION s_abmi500_carry_chk_ima(p_ima01,p_tabname)
   DEFINE p_ima01        LIKE ima_file.ima01
   DEFINE p_tabname      LIKE type_file.chr50
   DEFINE l_cnt          LIKE type_file.num5
 
   IF cl_null(p_ima01) THEN
      RETURN TRUE
   END IF
 
   LET l_cnt = 0
   LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_sep,'ima_file'),   
             " WHERE ima01='",p_ima01,"'" 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
   CALL cl_parse_qry_sql(g_sql,g_plant_sep) RETURNING g_sql  
   PREPARE chk_ima_p1 FROM g_sql
   EXECUTE chk_ima_p1 INTO l_cnt
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
 
   IF l_cnt = 0 THEN
      LET g_showmsg = g_dbs_sep,"/",p_tabname,"/",p_ima01
      CALL s_errmsg('azp01,gat01,ima01',g_showmsg,'sel ima01','abm-805',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
FUNCTION s_abmi500_carry_chk_ecb(p_bra01,p_bra011,p_plant,l_plant,p_tabname)
   DEFINE p_bra01        LIKE bra_file.bra01
   DEFINE p_bra011       LIKE bra_file.bra011 
   DEFINE p_plant        LIKE azp_file.azp01    
   DEFINE l_plant        LIKE azp_file.azp01
   DEFINE p_tabname      LIKE type_file.chr50 
   DEFINE l_cnt          LIKE type_file.num10
   DEFINE l_n            LIKE type_file.num10 
   DEFINE l_sql1         STRING
   DEFINE l_sql2         STRING
   DEFINE l_bra01_1      LIKE bra_file.bra01
   DEFINE l_bra011_1     LIKE bra_file.bra011
   DEFINE l_bra012_1     LIKE bra_file.bra012
   DEFINE l_bra013_1     LIKE bra_file.bra013

   LET l_sql1 = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'ecb_file'),
                "  WHERE ecb01 = '",p_bra01 CLIPPED,"'",  
                "    AND ecb02 = '",p_bra011 CLIPPED,"'"
   CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1  
   CALL cl_parse_qry_sql(l_sql1,l_plant) RETURNING l_sql1 
   PREPARE chk_ecb_p1 FROM l_sql1 
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('bra01,bra011','ecb_file','i500_pre:',SQLCA.sqlcode,1)
      RETURN FALSE
   END IF
   EXECUTE chk_ecb_p1 INTO l_cnt
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF

   IF l_cnt = 0 THEN
      LET g_showmsg = g_dbs_sep,"/",p_tabname,"/",p_bra01,"/",p_bra011
      CALL s_errmsg('azp01,gat01,bra01',g_showmsg,'sel ecb01','abm-749',1)
      RETURN FALSE
   END IF

   LET l_sql1 = " SELECT DISTINCT bra01,bra011,bra012,bra013 ",
                "  FROM ",cl_get_target_table(p_plant,'bra_file'),
                " WHERE bra01 = '",p_bra01 CLIPPED,"'",
                "   AND bra011 = '",p_bra011 CLIPPED,"'",
                "   AND bra10 = '2' " CLIPPED             #TQC-C60072
                #"   AND bra10 = '2'CLIPPED "             #TQC-C60072
   CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
   CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1
   PREPARE i500_pre1 FROM l_sql1
   IF SQLCA.sqlcode THEN
      CALL s_errmsg("","",'i500_pre1:',SQLCA.sqlcode,1)
      RETURN FALSE
   END IF
   DECLARE i500_ecb CURSOR FOR i500_pre1
   LET l_sql2 = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'ecb_file'),
                "  WHERE ecb01 ='",p_bra01 CLIPPED,"'",
                "    AND ecb02 = '",p_bra011 CLIPPED,"'",
                "    AND ecb03 = ? ",
                "    AND ecb012 = ? "
   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
   CALL cl_parse_qry_sql(l_sql2,l_plant) RETURNING l_sql2
   PREPARE i500_pre2 FROM l_sql2
   IF SQLCA.sqlcode THEN
      CALL s_errmsg("","",'i500_pre2:',SQLCA.sqlcode,0)
      RETURN FALSE
   END IF
   DECLARE i500_count2 CURSOR FOR i500_pre2
   IF l_cnt > 0 THEN
      FOREACH i500_ecb INTO l_bra01_1,l_bra011_1,l_bra012_1,l_bra013_1
         IF STATUS THEN
            CALL s_errmsg("","",'foreach:',STATUS,1)
            RETURN FALSE 
         END IF 
         OPEN i500_count2 USING l_bra013_1,l_bra012_1
         IF SQLCA.sqlcode THEN
            CALL s_errmsg("","",'OPEN i500_count2:',SQLCA.sqlcode,1)
            CLOSE i500_count2 
            RETURN FALSE
         END IF
         FETCH i500_count2 INTO l_n
         IF SQLCA.sqlcode THEN
             CALL s_errmsg("","",'i500_count2:',SQLCA.sqlcode,1)
             CLOSE i500_count2
             RETURN FALSE
         END IF
         IF cl_null(l_n) THEN LET l_n = 0 END IF       
         IF l_n > = 1 THEN
            CONTINUE FOREACH
         ELSE
            CALL s_errmsg("",l_plant,p_bra01,'abm-749',1)
            RETURN FALSE 
         END IF 
         CLOSE i500_count2
      END FOREACH
      RETURN TRUE
   ELSE
      CALL s_errmsg("",l_plant,p_bra01,'abm-749',1)
      RETURN FALSE
   END IF 

END FUNCTION
#FUN-B10013


  
