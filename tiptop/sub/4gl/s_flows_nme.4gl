# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: s_flows_nme.4gl
# Descriptions...: 产生/维护现金变动码资料(票据资金)
# Date & Author..: 11/09/07 By wujie #FUN-B90062   
# Usage..........: (p_source,p_bookno,p_no,p_date,p_conf,p_npptype,p_carry)  
# Modify.........: NO.MOD-BA0211 11/10/31 By Polly 計數 l_n 條件增加 tic05 = p_nme.nme21
# Modify.........: NO.MOD-BC0282 11/12/30 By Polly 計數 l_n 條件增加 tic06，tic08 key值條件
# Modify.........: No.MOD-C10025 12/01/14 By Polly 計數 l_n 條件增加 tic00，取消tic03條件
# Modify.........: No.MOD-C20008 12/02/03 By Dido 由於 nme14 為 tic06 條件,因此須在之前判斷是否為 NULL 
# Modify.........: No.TQC-C40142 12/04/17 By lujh 票據參數中設定啟用現金流量表功能，【現金流量表來源】1:票據資金系統，且【現金變動碼輸入控制】=1:必須輸入，
#                                                 查詢出單據，點擊【調整】按鈕，進入設置現金變動碼的界面s_flows界面，
#                                                 性，可以隨便輸入字符串作為現金變動碼。
# Modify.........: No:TQC-C60058 12/06/06 By lujh anms101參數設定，【現金流量來源】=1:票據資金系統；【現金變動碼輸入控制】=1:必須輸入
#                                                 點調整后tic_file不能為空
# Modify.........: No:TQC-C60076 12/06/08 By lujh 點確定時，也要控管原幣和本幣的金額
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_flows_nme(p_nme,p_carry,p_azp01)
   DEFINE p_nme RECORD LIKE nme_file.*  
   DEFINE p_carry   LIKE type_file.num5   #；来源是否为抛转 
   DEFINE p_azp01   LIKE azp_file.azp01
   DEFINE l_tic00   LIKE tic_file.tic00   #帳套
   DEFINE l_tic01   LIKE tic_file.tic01   #年度
   DEFINE l_tic02   LIKE tic_file.tic02   #期別
   DEFINE l_tic03   LIKE tic_file.tic03   #借貸別
   DEFINE g_tic     DYNAMIC ARRAY OF RECORD          
                    tic04     LIKE tic_file.tic04,  #單據編號
                    tic05     LIKE tic_file.tic05,  #項次
                    tic06     LIKE tic_file.tic06,  #現金變動碼
                    tic08     LIKE tic_file.tic08,  #關係人
                    tic07f    LIKE tic_file.tic07f, #原幣金額
                    tic07     LIKE tic_file.tic07   #本幣金額     
                    END RECORD,
          g_tic_t   RECORD          
                    tic04     LIKE tic_file.tic04,  #單據編號
                    tic05     LIKE tic_file.tic05,  #項次
                    tic06     LIKE tic_file.tic06,  #現金變動碼
                    tic08     LIKE tic_file.tic08,  #關係人
                    tic07f    LIKE tic_file.tic07f, #原幣金額
                    tic07     LIKE tic_file.tic07   #本幣金額     
                    END RECORD
   DEFINE g_tic_flows DYNAMIC ARRAY OF RECORD
                    npq02     LIKE npq_file.npq02,  #項次
                    npq25     LIKE npq_file.npq25,  #匯率
                    aag371    LIKE aag_file.aag371,  
                    npq37     LIKE npq_file.npq37,  #關係人
                    npq07f    LIKE npq_file.npq07f, #原幣金額 
                    npq07     LIKE npq_file.npq07   #本幣金額
                    END RECORD                 
   DEFINE l_n,i,k,j           LIKE type_file.num5   #TQC-C60076  add j 
   DEFINE g_success           LIKE type_file.chr1  
   DEFINE l_rec_b             LIKE type_file.num5 
   DEFINE l_allow_insert      LIKE type_file.num5
   DEFINE l_allow_delete      LIKE type_file.num5 
   DEFINE p_cmd               LIKE type_file.chr1 
   DEFINE l_sum1              LIKE nme_file.nme08
   DEFINE l_sum2              LIKE nme_file.nme04 
   DEFINE l_nme21             LIKE nme_file.nme21
   DEFINE l_abb37             LIKE pmc_file.pmc903
   DEFINE l_sum_tic07         LIKE tic_file.tic07
   DEFINE l_sum_tic07f        LIKE tic_file.tic07f 
   DEFINE l_sql               STRING 
   
#FUN-B90062     
   IF g_success ='N' THEN RETURN END IF 
   SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
   IF g_nmz.nmz70 <> '1' THEN RETURN END IF  
   CALL g_tic.clear()
   CALL g_tic_flows.clear() 
   IF NOT p_carry THEN  
      OPEN WINDOW s_flows AT 10,20 WITH FORM "sub/42f/s_flows"
      ATTRIBUTE(STYLE = g_win_style CLIPPED)
 
     CALL cl_ui_locale("s_flows") 
     CALL cl_set_comp_entry("tic04,tic05",FALSE) 
   END IF 
   WHENEVER ERROR CONTINUE 
   LET l_tic01 = YEAR(p_nme.nme02)             #年度
   LET l_tic02 = MONTH(p_nme.nme02)            #期別   
   LET l_tic03 = ' '
   IF cl_null(p_nme.nme14) THEN LET p_nme.nme14 = ' ' END IF   #MOD-C20008
   SELECT nmc03 INTO l_tic03
     FROM nmc_file
    WHERE nmc01 = p_nme.nme03
  
   DISPLAY l_tic01,l_tic02,l_tic03 TO tic01,tic02,tic03     
   
   LET i=1
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM tic_file
    WHERE tic01 = l_tic01
      AND tic02 = l_tic02
     #AND tic03 = l_tic03      #MOD-C10025 mark
      AND tic04 = p_nme.nme12
      AND tic05 = p_nme.nme21  #MOD-BA0211 add
      AND tic06 = p_nme.nme14  #MOD-BC0282 add
      AND tic08 = ' '          #MOD-BC0282 add
      AND tic00 = ' '          #MOD-C10025 add
      
   IF l_n <= 0 THEN
      IF cl_null(l_tic00) THEN
         LET l_tic00 = ' '
      END IF
      IF cl_null(l_tic03) THEN
         LET l_tic03 = ' '
      END IF
  
      LET g_tic[i].tic04 = p_nme.nme12
      LET g_tic[i].tic05 = p_nme.nme21
      LET g_tic[i].tic06 = p_nme.nme14 
      IF cl_null(g_tic[i].tic06) THEN  
         LET g_tic[i].tic06 = ' '
      END IF  
      LET g_tic[i].tic07 = p_nme.nme08
      LET g_tic[i].tic07f= p_nme.nme04
      LET g_tic[i].tic08 = ' '     
      SELECT pmc903 INTO l_abb37 FROM pmc_file
       WHERE pmc01 = p_nme.nme25
      IF cl_null(l_abb37) THEN
         SELECT occ37 INTO l_abb37 FROM occ_file
          WHERE occ01 = p_nme.nme25
      END IF
      IF l_abb37 ='Y' THEN
         LET g_tic[i].tic08 = p_nme.nme25  
      END IF       
      LET l_sql = "INSERT INTO ",cl_get_target_table(p_azp01,'tic_file'),
                  "  (tic00,tic01,tic02,tic03,tic04,",
                  "   tic05,tic06,tic07,tic07f,tic08,tic09)",
                  "   VALUES(?,?,?,?,?,?,?,?,?,?,?)" 
 	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,p_azp01) RETURNING l_sql #FUN-A50102
      PREPARE tic_ins_pre FROM l_sql

      EXECUTE tic_ins_pre USING l_tic00,l_tic01,l_tic02,l_tic03,g_tic[i].tic04,
                                g_tic[i].tic05,g_tic[i].tic06,g_tic[i].tic07,
                                g_tic[i].tic07f,g_tic[i].tic08,'1' 

      IF SQLCA.sqlcode THEN
         CALL cl_err('s_flowslow',SQLCA.sqlcode,0) 
         LET g_success ='N'  
         RETURN       
      END IF
   END IF
   IF p_carry THEN RETURN END IF
      
   DECLARE s_flowslows_c CURSOR FOR
    SELECT tic04,tic05,tic06,tic08,tic07f,tic07
      FROM tic_file 
     WHERE tic01 = l_tic01
       AND tic02 = l_tic02
       AND tic03 = l_tic03
       AND tic04 = p_nme.nme12
     ORDER BY tic04

   CALL g_tic.clear()

   
   LET l_rec_b=0
   FOREACH s_flowslows_c INTO g_tic[i].*
      IF STATUS THEN
         CALL cl_err('foreach ogc',STATUS,0)
         EXIT FOREACH
      END IF
      
      LET i = i + 1
   END FOREACH
   CALL g_tic.deleteElement(i)
   LET l_rec_b = i - 1

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   LET i = 1
   INPUT ARRAY g_tic WITHOUT DEFAULTS FROM s_tic.*
         ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
             INSERT ROW = l_allow_insert,DELETE ROW = l_allow_delete,APPEND ROW = l_allow_insert)
             
      BEFORE INPUT
         IF l_rec_b != 0 THEN
             CALL fgl_set_arr_curr(i)
         END IF  
  
      BEFORE ROW
         LET i = ARR_CURR()
         IF l_rec_b >= i THEN
            LET p_cmd='u'
            LET g_tic_t.* = g_tic[i].*                                                                                             
            BEGIN WORK                                                                                                               
            CALL cl_show_fld_cont()
         END IF 
      
      AFTER FIELD tic06
         IF NOT cl_null(g_tic[i].tic06) THEN
            IF cl_null(g_tic[i].tic07) THEN 
               SELECT sum(tic07),sum(tic07f) INTO l_sum_tic07,l_sum_tic07f FROM tic_file
                WHERE tic01 = l_tic01
                  AND tic02 = l_tic02
                  AND tic03 = l_tic03
                  AND tic04 = p_nme.nme12
                  AND tic05 = p_nme.nme21
                  IF cl_null(l_sum_tic07) THEN
                       LET l_sum_tic07 = 0
                  END IF
               IF cl_null(l_sum_tic07f) THEN
                  LET l_sum_tic07f = 0
               END IF
               IF p_nme.nme04 >= l_sum_tic07f THEN
                  LET g_tic[i].tic07f = p_nme.nme04 - l_sum_tic07f
                  IF cl_null(p_nme.nme07) THEN
                     LET g_tic[i].tic07 = g_tic[i].tic07f
                  ELSE
                     LET g_tic[i].tic07 = g_tic[i].tic07f * p_nme.nme07
                  END IF
               ELSE
                  LET g_tic[i].tic07 = 0
                  LET g_tic[i].tic07f = 0
               END IF 
            END IF
            #TQC-C40142--add--str--
            IF g_nmz.nmz71 = 'Y' THEN 
               IF g_nmz.nmz70 = '1' AND g_nmz.nmz72 = '1' THEN 
                  SELECT count(*) INTO l_n FROM nml_file WHERE nml01 = g_tic[i].tic06 AND nmlacti = 'Y'
                  IF l_n = 0 THEN 
                     CALL cl_err('','axr-096',0)
                     NEXT FIELD tic06
                  END IF 
               END IF 
            END IF   
            #TQC-C40142--add--end--
         END IF
         
      AFTER FIELD tic07f
         LET l_sum_tic07f = 0
         SELECT sum(tic07f) INTO l_sum_tic07f FROM tic_file
          WHERE tic01 = l_tic01
            AND tic02 = l_tic02
            AND tic03 = l_tic03
            AND tic04 = p_nme.nme12
            AND tic05 = p_nme.nme21
         IF cl_null(l_sum_tic07f) THEN
            LET l_sum_tic07f = 0
         END IF
         
         IF cl_null(g_tic_t.tic07f) THEN
            LET g_tic_t.tic07f = 0
         END IF
         
         LET l_sum_tic07f = l_sum_tic07f - g_tic_t.tic07f
         
         IF l_sum_tic07f+g_tic[i].tic07f > p_nme.nme04 THEN
            CALL cl_err('','anm-606',0)
            NEXT FIELD tic07f
         END IF
         IF cl_null(p_nme.nme07) THEN
            LET g_tic[i].tic07 = g_tic[i].tic07f
         ELSE
            LET g_tic[i].tic07 = g_tic[i].tic07f * p_nme.nme07
         END IF
      
      AFTER FIELD tic07
         LET l_sum_tic07 = 0
         SELECT sum(tic07) INTO l_sum_tic07 FROM tic_file
          WHERE tic01 = l_tic01
            AND tic02 = l_tic02
            AND tic03 = l_tic03
            AND tic04 = p_nme.nme12
            AND tic05 = p_nme.nme21
         IF cl_null(l_sum_tic07) THEN
            LET l_sum_tic07 = 0
         END IF
         IF cl_null(g_tic_t.tic07) THEN
            LET g_tic_t.tic07 = 0
         END IF
         
         LET l_sum_tic07 = l_sum_tic07 - g_tic_t.tic07
         
         LET l_sum_tic07 = l_sum_tic07
         IF l_sum_tic07+g_tic[i].tic07 > p_nme.nme08 THEN
            CALL cl_err('','anm-607',0)
            NEXT FIELD tic07
         END IF
      AFTER FIELD tic08
         SELECT pmc903 INTO l_abb37 FROM pmc_file
          WHERE pmc01 = p_nme.nme25
         IF cl_null(l_abb37) THEN
            SELECT occ37 INTO l_abb37 FROM occ_file
             WHERE occ01 = p_nme.nme25
         END IF
         IF l_abb37 = 'Y' THEN
            IF cl_null(g_tic[i].tic08) THEN
               CALL cl_err('','anm-608',0)
               NEXT FIELD tic08
            END IF
         ELSE
            IF cl_null(g_tic[i].tic08) THEN
               LET g_tic[i].tic08 = ' '
            END IF
         END IF

      
      BEFORE INSERT 
         LET p_cmd='a'
         INITIALIZE g_tic[i].*  TO NULL 
         LET g_tic[i].tic04 = p_nme.nme12
         LET g_tic[i].tic05 = p_nme.nme21
         LET g_tic_t.* = g_tic[i].*  
         CALL cl_show_fld_cont()
         NEXT FIELD tic06 

      BEFORE DELETE
         IF NOT cl_delb(0,0) THEN
            CANCEL DELETE
         END IF   
         IF cl_null(l_tic00) THEN
            LET l_tic00 = ' '
         END IF
         IF cl_null(l_tic03) THEN
            LET l_tic03 = ' '
         END IF
         DELETE FROM tic_file 
          WHERE tic00 = l_tic00
            AND tic01 = l_tic01
            AND tic02 = l_tic02
            AND tic03 = l_tic03
            AND tic04 = g_tic_t.tic04
            AND tic05 = g_tic_t.tic05
            AND tic06 = g_tic_t.tic06
            AND tic08 = g_tic_t.tic08    
            AND tic07 = g_tic_t.tic07
            AND tic07f = g_tic_t.tic07f                                                                
        IF SQLCA.sqlcode THEN                                                             
           CALL cl_err3("del","tic_file",'',"",SQLCA.sqlcode ,"","",1)                                                       
           ROLLBACK WORK
           CANCEL DELETE
        END IF
        LET l_rec_b = l_rec_b - 1  
  
      ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_tic[i].* = g_tic_t.*
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF cl_null(l_tic00) THEN
             LET l_tic00 = ' '
          END IF
          UPDATE tic_file SET tic06 = g_tic[i].tic06,
                              tic07 = g_tic[i].tic07,
                              tic07f = g_tic[i].tic07f,    
                              tic08 = g_tic[i].tic08      
           WHERE tic00 = l_tic00
             AND tic01 = l_tic01
             AND tic02 = l_tic02
             AND tic04 = g_tic_t.tic04
             AND tic05 = g_tic_t.tic05
             AND tic06 = g_tic_t.tic06
             AND tic08 = g_tic_t.tic08
          IF SQLCA.sqlcode THEN
             CALL cl_err("upd tic_file",SQLCA.sqlcode,1)
             LET g_tic[i].* = g_tic_t.*
             ROLLBACK WORK
          END IF

      AFTER INSERT                                                                                                                   
         IF INT_FLAG THEN                                                                                                            
            CALL cl_err('',9001,0)                                                                                                   
            LET INT_FLAG = 0                                                                                                       
            CANCEL INSERT                                                                                                            
          END IF 
          IF cl_null(l_tic00) THEN
             LET l_tic00 = ' '
          END IF
          IF cl_null(l_tic03) THEN
             LET l_tic03 = ' '
          END IF
          INSERT INTO tic_file VALUES(l_tic00,l_tic01,l_tic02,l_tic03,g_tic[i].tic04,g_tic[i].tic05,
                                      g_tic[i].tic06,g_tic[i].tic07,g_tic[i].tic07f,g_tic[i].tic08,'1')   #No.FUN-B90062 add tic09
          IF SQLCA.sqlcode THEN                                                                                                      
             CALL cl_err3("ins","tic_file",g_tic[i].tic05,"",SQLCA.sqlcode,"","",1)                                                  
             CANCEL INSERT                                                                                                         
          ELSE
             LET l_rec_b = l_rec_b + 1 
          END IF   
     
      AFTER ROW
         LET i = ARR_CURR()
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_tic[i].* = g_tic_t.*
            ROLLBACK WORK
            EXIT INPUT
         END IF         

      AFTER INPUT
         #TQC-C60058--add--str--
         IF cl_null(l_tic00) THEN
            LET l_tic00 = ' '
         END IF
         IF cl_null(l_tic03) THEN
            LET l_tic03 = ' '
         END IF
         IF g_nmz.nmz71 = 'Y' THEN
            IF g_nmz.nmz70 = '1' AND g_nmz.nmz72 = '1' THEN
               SELECT COUNT(*) INTO l_n FROM tic_file
                WHERE tic00 = l_tic00
                  AND tic01 = l_tic01
                  AND tic02 = l_tic02
                  AND tic03 = l_tic03
                  AND tic04 = g_tic_t.tic04
               IF l_n = 0 THEN
                  CALL cl_err('','axr-278',1)
                  NEXT FIELD tic06
               END IF
            END IF
         END IF
         #TQC-C60058--add--end--
         FOR k = 1 TO l_rec_b
           IF cl_null(g_tic[k].tic06) THEN
              LET i = k
              CALL cl_err(k,'agl-354',0)
              CALL fgl_set_arr_curr(k)  
              NEXT FIELD tic06
           END IF
         END FOR

         #TQC-C60076--add--str--   
         FOR j = 1 TO l_rec_b
            LET l_sum_tic07f = 0
            SELECT sum(tic07f) INTO l_sum_tic07f FROM tic_file
             WHERE tic01 = l_tic01
               AND tic02 = l_tic02
               AND tic03 = l_tic03
               AND tic04 = p_nme.nme12
               AND tic05 = p_nme.nme21
            IF cl_null(l_sum_tic07f) THEN
               LET l_sum_tic07f = 0
            END IF

            IF cl_null(g_tic_t.tic07f) THEN
               LET g_tic_t.tic07f = 0
            END IF

            LET l_sum_tic07f = l_sum_tic07f - g_tic_t.tic07f

            IF l_sum_tic07f+g_tic[j].tic07f > p_nme.nme04 THEN
               LET i = j
               CALL cl_err('','anm-606',0)
               NEXT FIELD tic07f
            END IF
            IF cl_null(p_nme.nme07) THEN
               LET g_tic[j].tic07 = g_tic[j].tic07f
            ELSE
               LET g_tic[j].tic07 = g_tic[j].tic07f * p_nme.nme07
            END IF
         END FOR
         #TQC-C60076--add--end--

         SELECT pmc903 INTO l_abb37 FROM pmc_file
          WHERE pmc01 = p_nme.nme25
         IF cl_null(l_abb37) THEN
            SELECT occ37 INTO l_abb37 FROM occ_file
             WHERE occ01 = p_nme.nme25
         END IF
         IF l_abb37 = 'Y' THEN
            FOR k = 1 TO l_rec_b
               IF cl_null(g_tic[k].tic08) THEN
                  LET i = k
                  CALL cl_err('','anm-608',0)
                  CALL fgl_set_arr_curr(k)  
                  NEXT FIELD tic08
               END IF
            END FOR  
         END IF
         COMMIT WORK
         
      ON ACTION controlp
         CASE 
            WHEN INFIELD(tic06)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_nml"
               CALL cl_create_qry() RETURNING g_tic[i].tic06
               DISPLAY BY NAME g_tic[i].tic06
               NEXT FIELD tic06
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
      CALL cl_err('',9001,0)
      LET INT_FLAG = 0
      CLOSE WINDOW s_flows
      RETURN
   END IF
   
   CLOSE WINDOW s_flows
END FUNCTION
