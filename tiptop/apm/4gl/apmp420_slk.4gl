# Prog. Version..: '5.30.06-13.04.03(00003)'     #
#
# Pattern name...: apmp420_slk.4gl
# Descriptions...: 訂單轉請購單維護作業
# Date & Author..: FUN-C60098 12/06/29 By xjll
# Modify.........: No:FUN-C90050 12/10/24 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No:TQC-D40015 13/04/03 By Elise 調整s_sizechk傳入參數

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../axm/4gl/s_slk.global" 

DEFINE  li_a           LIKE type_file.chr10
DEFINE  g_oebslk      DYNAMIC ARRAY OF RECORD
                      oebslk01     LIKE oebslk_file.oebslk01,
                      oebslk03     LIKE oebslk_file.oebslk03,
                      oebslk04     LIKE oebslk_file.oebslk04,
                      oebslk05     LIKE oebslk_file.oebslk05,
                      oebslk05_fac LIKE oebslk_file.oebslk05_fac,
                      oebslk06     LIKE oebslk_file.oebslk06,
                      oebslk09     LIKE oebslk_file.oebslk09,
                      oebslk091    LIKE oebslk_file.oebslk091,
                      oebslk092    LIKE oebslk_file.oebslk092,
                      oebslk15     LIKE oebslk_file.oebslk15,   
                      oebslk12     LIKE oebslk_file.oebslk12,
                      oebslk13     LIKE oebslk_file.oebslk13,
                      oebslk131    LIKE oebslk_file.oebslk131,
                      oebslk1006   LIKE oebslk_file.oebslk1006,
                      oebslk14     LIKE oebslk_file.oebslk14,
                      oebslk14t    LIKE oebslk_file.oebslk14t,
                      oebslk23     LIKE oebslk_file.oebslk23,
                      oebslk24     LIKE oebslk_file.oebslk24,
                      oebslk25     LIKE oebslk_file.oebslk25,
                      oebslk26     LIKE oebslk_file.oebslk26,
                      oebslk28     LIKE oebslk_file.oebslk28,
                      oebslk07     LIKE oebslk_file.oebslk07,
                      oebslk11     LIKE oebslk_file.oebslk11
                      END RECORD,
        g_oebslk_t    RECORD
                      oebslk01     LIKE oebslk_file.oebslk01,
                      oebslk03     LIKE oebslk_file.oebslk03,
                      oebslk04     LIKE oebslk_file.oebslk04,
                      oebslk05     LIKE oebslk_file.oebslk05,
                      oebslk05_fac LIKE oebslk_file.oebslk05_fac,
                      oebslk06     LIKE oebslk_file.oebslk06,
                      oebslk09     LIKE oebslk_file.oebslk09,
                      oebslk091    LIKE oebslk_file.oebslk091,
                      oebslk092    LIKE oebslk_file.oebslk092,
                      oebslk15     LIKE oebslk_file.oebslk15,  
                      oebslk12     LIKE oebslk_file.oebslk12,
                      oebslk13     LIKE oebslk_file.oebslk13,
                      oebslk131    LIKE oebslk_file.oebslk131,
                      oebslk1006   LIKE oebslk_file.oebslk1006,
                      oebslk14     LIKE oebslk_file.oebslk14,
                      oebslk14t    LIKE oebslk_file.oebslk14t,
                      oebslk23     LIKE oebslk_file.oebslk23,
                      oebslk24     LIKE oebslk_file.oebslk24,
                      oebslk25     LIKE oebslk_file.oebslk25,
                      oebslk26     LIKE oebslk_file.oebslk26,
                      oebslk28     LIKE oebslk_file.oebslk28,
                      oebslk07     LIKE oebslk_file.oebslk07,
                      oebslk11     LIKE oebslk_file.oebslk11
                      END RECORD
DEFINE g_wc         STRING                                           
DEFINE g_flag       LIKE type_file.chr1
DEFINE g_cnt        LIKE type_file.num5
DEFINE g_sql        STRING
DEFINE b_oebslk     RECORD LIKE oebslk_file.*
DEFINE g_oea        RECORD LIKE oea_file.*
DEFINE g_pml        RECORD LIKE pml_file.*
DEFINE g_pmlslk     RECORD LIKE pmlslk_file.*
DEFINE g_pmk01      LIKE pmk_file.pmk01
DEFINE g_forupd_sql STRING,
       g_rec_b      LIKE type_file.num5,
       g_rec_b2     LIKE type_file.num5,  
       l_ac         LIKE type_file.num5, 
       l_ac2        LIKE type_file.num5
DEFINE g_msg        STRING
DEFINE g_argv1      LIKE pmk_file.pmk01    #請購單單號

MAIN

 DEFINE l_flag        LIKE type_file.chr1

    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   LET g_argv1=ARG_VAL(1)
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   WHILE TRUE 
      LET g_success='Y' 
      LET g_flag = '1'
      OPEN WINDOW p420_w WITH FORM "apm/42f/apmp420_r_slk"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      CALL cl_ui_init()  
      CALL p420_q()
      IF g_flag = '1' THEN
         CALL p420_dialog()
         IF g_success='Y' THEN
            CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
         ELSE
            CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
         END IF
         IF l_flag THEN
            CONTINUE WHILE
         ELSE
            CLOSE WINDOW p420_w
            EXIT WHILE
         END IF
      END IF 
      IF g_flag = '0' THEN 
         EXIT WHILE
      END IF
#     IF g_success='Y' THEN
#           CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#        ELSE
#           CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#     END IF
#     IF l_flag THEN
#        CONTINUE WHILE
#     ELSE
#        CLOSE WINDOW p420_w
#        EXIT WHILE
#     END IF
   END WHILE 
   CLOSE WINDOW p420_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
FUNCTION p420_q()
DEFINE l_cnt LIKE type_file.num5

  CLEAR FORM 
  LET g_wc = NULL
  CONSTRUCT BY NAME g_wc ON oea01
  
  BEFORE CONSTRUCT
   CALL cl_qbe_init()

  #AFTER FIELD oea01 
  #  IF cl_null(g_wc) THEN
  #     NEXT FIELD oea01
  #  END IF   
  # #SELECT COUNT(*) INTO l_cnt FROM oea_file WHERE g_wc  CLIPPED
    #IF cl_null(l_cnt) OR l_cnt = 0 THEN
    #   CALL cl_err('','mfg-234',0)
    #   NEXT FIELD oea01  
    #END IF 
     
     ON ACTION controlp
                CASE
                   WHEN INFIELD(oea01) #查詢單据
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_oea11" 
                        LET g_qryparam.where = " oea00 <> '4' AND oeaslk02 <> '2' AND oeaconf = 'Y' "
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO oea01
                        NEXT FIELD oea01
                 END CASE   
     
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT

        ON ACTION about
           CALL cl_about()

        ON ACTION HELP
           CALL cl_show_help()

        ON ACTION controlg
           CALL cl_cmdask()

        ON ACTION qbe_save
           CALL cl_qbe_save()            
  END CONSTRUCT  
  IF INT_FLAG THEN
     LET g_flag = '0'
     RETURN
  END IF 
# CLOSE WINDOW p420_w
END FUNCTION 

FUNCTION p420_dialog()

 DEFINE p_cmd     LIKE type_file.chr1,
        p_cmd2    LIKE type_file.chr1
 DEFINE l_n       LIKE type_file.num5
 DEFINE l_ima151  LIKE ima_file.ima151
 DEFINE l_lock_sw LIKE type_file.chr1
 DEFINE l_flag    LIKE type_file.chr1 

   OPEN WINDOW apmp420_slk_w WITH FORM "apm/42f/apmp420_slk"
    ATTRIBUTE (STYLE = g_win_style CLIPPED)

   LET l_flag = 'Y'
   CALL cl_ui_locale("apmp420_slk")
   CALL cl_set_act_visible("controlb",FALSE)
   CALL  p420_ins_tmpa()
   CALL  p420_fill() 

   LET g_forupd_sql = "SELECT * FROM oebslk_file ",
                      " WHERE oebslk01= ? AND oebslk03= ?  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p420_bcl_slk CURSOR FROM g_forupd_sql
   
   DIALOG ATTRIBUTES(UNBUFFERED)
     INPUT ARRAY g_oebslk FROM s_oebslk.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
      BEFORE INPUT
            LET li_a=FALSE                
            IF g_rec_b !=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            CALL cl_set_comp_entry("oebslk12",TRUE)  
            CALL cl_set_act_visible("controlb",FALSE) 
      BEFORE ROW
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_n = ARR_COUNT()   
           SELECT * INTO g_oea.* FROM oea_file WHERE oea01 = g_oebslk[l_ac].oebslk04
           
           SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01=g_oebslk[l_ac].oebslk04
               CALL p420_settext_slk(g_oebslk[l_ac].oebslk04)
               CALL p420_fillimx_slk(g_oebslk[l_ac].oebslk04,g_oebslk[l_ac].oebslk01,g_oebslk[l_ac].oebslk03)
             IF l_ima151 <>'Y'  THEN
                CALL cl_set_comp_entry("oebslk12",TRUE)  #非子母料件數量可以錄入
             ELSE
                CALL cl_set_comp_entry("oebslk12",FALSE)  
             END IF   
             IF g_rec_b >= l_ac THEN
              LET p_cmd = 'u'
              LET g_oebslk_t.* = g_oebslk[l_ac].*
              BEGIN WORK
              OPEN p420_bcl_slk USING g_oebslk[l_ac].oebslk01,g_oebslk[l_ac].oebslk03
               IF STATUS THEN
                  CALL cl_err("OPEN p420_bcl_slk:", STATUS, 1)
                  LET l_lock_sw = "Y"
                  CONTINUE DIALOG
               ELSE
                  FETCH p420_bcl_slk INTO b_oebslk.*
                  LET g_oebslk[l_ac].* = g_oebslk_t.*
                     SELECT SUM(tmpa05) INTO g_oebslk[l_ac].oebslk12 FROM tmpa_file
                      WHERE tmpa01=g_oebslk[l_ac].oebslk01 AND tmpa02=g_oebslk[l_ac].oebslk03
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_oebslk_t.oebslk03,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                     CONTINUE DIALOG
                  END IF
               END IF 
               CALL cl_show_fld_cont()
            END IF 

        BEFORE FIELD oebslk12
         IF l_ima151 <> 'Y' THEN
            CALL cl_set_comp_entry("oebslk12",TRUE)
         END IF
         
        AFTER FIELD oebslk12
         IF l_ima151 <> 'Y' THEN
            IF g_oebslk[l_ac].oebslk12 < 0 THEN
               CALL cl_err('','art-040',0)
               LET g_oebslk[l_ac].oebslk12=g_oebslk_t.oebslk12
               NEXT FIELD oebslk12
            END IF
            IF NOT p420_check_imx(1,g_oebslk[l_ac].oebslk12,g_oebslk_t.oebslk12) THEN
               LET g_oebslk[l_ac].oebslk12=g_oebslk_t.oebslk12
               NEXT FIELD oebslk12
            END IF 
            IF g_oea.oea213 = 'N' THEN
               LET g_oebslk[l_ac].oebslk14 = g_oebslk[l_ac].oebslk131*g_oebslk[l_ac].oebslk12
               CALL cl_digcut(g_oebslk[l_ac].oebslk14,t_azi04)  RETURNING g_oebslk[l_ac].oebslk14
               LET g_oebslk[l_ac].oebslk14t= g_oebslk[l_ac].oebslk14*(1+ g_oea.oea211/100)
               CALL cl_digcut(g_oebslk[l_ac].oebslk14t,t_azi04) RETURNING g_oebslk[l_ac].oebslk14t
            ELSE
               LET g_oebslk[l_ac].oebslk14t= g_oebslk[l_ac].oebslk131*g_oebslk[l_ac].oebslk12
               CALL cl_digcut(g_oebslk[l_ac].oebslk14t,t_azi04) RETURNING g_oebslk[l_ac].oebslk14t
               LET g_oebslk[l_ac].oebslk14 = g_oebslk[l_ac].oebslk14t/(1+ g_oea.oea211/100)
               CALL cl_digcut(g_oebslk[l_ac].oebslk14,t_azi04)  RETURNING g_oebslk[l_ac].oebslk14
            END IF
            DISPLAY g_oebslk[l_ac].oebslk14 TO s_oebslk[l_ac].oebslk14
            DISPLAY g_oebslk[l_ac].oebslk14t TO s_oebslk[l_ac].oebslk14t
          END IF
      
      # BEFORE DELETE
      #     IF INT_FLAG THEN
      #        CALL cl_err('',9001,0)
      #        LET INT_FLAG = 0
      #        LET g_oebslk[l_ac].* = g_oebslk_t.*
      #        CLOSE p420_bcl_slk
      #        ROLLBACK WORK
      #        CONTINUE DIALOG
      #     END IF 
      #     CALL g_oebslk.deleteElement(l_ac)
      #     CALL ui.Interface.refresh()
      #     DELETE FROM tmpa_file WHERE tmpa01 = g_oebslk[l_ac].oebslk01 AND tmpa02 = g_oebslk[l_ac].oebslk03 
      #     IF SQLCA.sqlcode THEN
      #        CALL cl_err3("del","tmpa_file",g_oebslk[l_ac].oebslk01,g_oebslk[l_ac].oebslk03,SQLCA.sqlcode,"","",1)
      #        ROLLBACK WORK
      #        CANCEL DELETE
      #     ELSE
      #        LET g_rec_b=g_rec_b-1
      #        DISPLAY g_rec_b TO FORMONLY.cn5
      #     END IF     
      #     COMMIT WORK
            
         
        ON ROW CHANGE
             IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_oebslk[l_ac].* = g_oebslk_t.*
               CLOSE p420_bcl_slk
               ROLLBACK WORK
               EXIT DIALOG
             END IF

            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_oebslk[l_ac].oebslk03,-263,1)
               LET g_oebslk[l_ac].* = g_oebslk_t.*
            ELSE
               IF l_ima151 <> 'Y' THEN 
                  UPDATE tmpa_file SET tmpa05 = g_oebslk[l_ac].oebslk12 WHERE tmpa01 = g_oebslk[l_ac].oebslk01
                                                                          AND tmpa02 = g_oebslk[l_ac].oebslk03
                                                                          AND tmpa04 = g_oebslk[l_ac].oebslk04
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                     CALL cl_err3("upd","tmpa_file",g_oea.oea01,g_oebslk_t.oebslk03,SQLCA.sqlcode,"","upd tmpa",1)
                     LET g_oebslk[l_ac].* = g_oebslk_t.*
                  END IF                     
               END IF 
            END IF 

        AFTER ROW    
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CLOSE p420_bcl_slk           
               ROLLBACK WORK                
               EXIT DIALOG    
            END IF                          
            CLOSE p420_bcl_slk
            COMMIT WORK
       END INPUT  
       
     INPUT ARRAY g_imx FROM s_imx.*
             ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,
             INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
             
          BEFORE INPUT
              LET li_a=TRUE                 #FUN-C60100 add
              IF g_rec_b2 != 0 THEN
                 CALL fgl_set_arr_curr(l_ac2)
              END IF
              CALL cl_set_comp_entry("color",FALSE)  #顏色不開啟錄入
          BEFORE ROW
             LET p_cmd2 = ''
             LET l_ac2 = ARR_CURR()
             INITIALIZE g_imx_t.* TO NULL

             BEGIN WORK

             OPEN p420_bcl_slk USING g_oebslk[l_ac].oebslk01,g_oebslk[l_ac].oebslk03
             IF STATUS THEN
                CALL cl_err("OPEN p420_bcl_slk:", STATUS, 1)
                CLOSE p420_bcl_slk
                ROLLBACK WORK
                RETURN
             END IF
             FETCH p420_bcl_slk INTO b_oebslk.*
             
             SELECT SUM(tmpa05) INTO g_oebslk[l_ac].oebslk12 FROM tmpa_file
                      WHERE tmpa01=g_oebslk[l_ac].oebslk01 AND tmpa02=g_oebslk[l_ac].oebslk03
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_oebslk[l_ac].oebslk01,SQLCA.sqlcode,0)
                CLOSE p420_bcl_slk
                ROLLBACK WORK
                RETURN
             END IF

             IF g_rec_b2 >= l_ac2 THEN
                LET p_cmd2='u'
                LET g_imx_t.* = g_imx[l_ac2].*
                LET l_lock_sw = 'N'
             END IF
             
            AFTER FIELD imx01
              IF NOT cl_null(g_imx[l_ac2].imx01) THEN
                 IF p_cmd2='a' OR (g_imx[l_ac2].imx01 !=g_imx_t.imx01 AND g_imx_t.imx01 IS NOT NULL) THEN
                    IF NOT p420_check_imx(1,g_imx[l_ac2].imx01,g_imx_t.imx01) THEN
                       LET g_imx[l_ac2].imx01 = g_imx_t.imx01
                       NEXT FIELD imx01
                    END IF
                 END IF
              END IF
           AFTER FIELD imx02
              IF NOT cl_null(g_imx[l_ac2].imx02) THEN
                 IF p_cmd2='a' OR (g_imx[l_ac2].imx02 !=g_imx_t.imx02 AND g_imx_t.imx02 IS NOT NULL) THEN
                    IF NOT p420_check_imx(2,g_imx[l_ac2].imx02,g_imx_t.imx02) THEN
                       LET g_imx[l_ac2].imx02 = g_imx_t.imx02
                       NEXT FIELD imx02
                    END IF
                 END IF
             END IF
           AFTER FIELD imx03
              IF NOT cl_null(g_imx[l_ac2].imx03) THEN
                 IF p_cmd2='a' OR (g_imx[l_ac2].imx03 !=g_imx_t.imx03 AND g_imx_t.imx03 IS NOT NULL) THEN
                    IF NOT p420_check_imx(3,g_imx[l_ac2].imx03,g_imx_t.imx03) THEN
                       LET g_imx[l_ac2].imx03 = g_imx_t.imx03
                       NEXT FIELD imx03
                    END IF
                 END IF
              END IF
           AFTER FIELD imx04
              IF NOT cl_null(g_imx[l_ac2].imx04) THEN
                 IF p_cmd2='a' OR (g_imx[l_ac2].imx04 !=g_imx_t.imx04 AND g_imx_t.imx04 IS NOT NULL) THEN
                     IF NOT p420_check_imx(4,g_imx[l_ac2].imx04,g_imx_t.imx04) THEN
                        LET g_imx[l_ac2].imx04 = g_imx_t.imx04
                        NEXT FIELD imx04
                     END IF
                 END IF
              END IF
           AFTER FIELD imx05
              IF NOT cl_null(g_imx[l_ac2].imx05) THEN
                 IF p_cmd2='a' OR (g_imx[l_ac2].imx05 !=g_imx_t.imx05 AND g_imx_t.imx05 IS NOT NULL) THEN
                    IF NOT p420_check_imx(5,g_imx[l_ac2].imx05,g_imx_t.imx05) THEN
                       LET g_imx[l_ac2].imx05 = g_imx_t.imx05
                       NEXT FIELD imx05
                    END IF
                 END IF
              END IF
           AFTER FIELD imx06
              IF NOT cl_null(g_imx[l_ac2].imx06) THEN
                 IF p_cmd2='a' OR (g_imx[l_ac2].imx06 !=g_imx_t.imx06 AND g_imx_t.imx06 IS NOT NULL) THEN
                    IF NOT p420_check_imx(6,g_imx[l_ac2].imx06,g_imx_t.imx06) THEN
                       LET g_imx[l_ac2].imx06 = g_imx_t.imx06
                       NEXT FIELD imx06
                    END IF
                 END IF
              END IF
           AFTER FIELD imx07
              IF NOT cl_null(g_imx[l_ac2].imx07) THEN
                 IF p_cmd2='a' OR (g_imx[l_ac2].imx07 !=g_imx_t.imx07 AND g_imx_t.imx07 IS NOT NULL) THEN
                    IF NOT p420_check_imx(7,g_imx[l_ac2].imx07,g_imx_t.imx07) THEN
                       LET g_imx[l_ac2].imx07 = g_imx_t.imx07
                       NEXT FIELD imx07
                    END IF
                 END IF
              END IF
           AFTER FIELD imx08
              IF NOT cl_null(g_imx[l_ac2].imx08) THEN
                 IF p_cmd2='a' OR (g_imx[l_ac2].imx08 !=g_imx_t.imx08 AND g_imx_t.imx08 IS NOT NULL) THEN
                    IF NOT p420_check_imx(8,g_imx[l_ac2].imx08,g_imx_t.imx08) THEN
                       LET g_imx[l_ac2].imx08 = g_imx_t.imx08
                       NEXT FIELD imx08
                    END IF
                 END IF
              END IF
           AFTER FIELD imx09
              IF NOT cl_null(g_imx[l_ac2].imx09) THEN
                 IF p_cmd2='a' OR (g_imx[l_ac2].imx09 !=g_imx_t.imx09 AND g_imx_t.imx09 IS NOT NULL) THEN
                    IF NOT p420_check_imx(9,g_imx[l_ac2].imx09,g_imx_t.imx09) THEN
                       LET g_imx[l_ac2].imx09 = g_imx_t.imx09
                       NEXT FIELD imx09
                    END IF
                 END IF
              END IF
           AFTER FIELD imx10
              IF NOT cl_null(g_imx[l_ac2].imx10) THEN
                 IF p_cmd2='a' OR (g_imx[l_ac2].imx10 !=g_imx_t.imx10 AND g_imx_t.imx10 IS NOT NULL) THEN
                    IF NOT p420_check_imx(10,g_imx[l_ac2].imx10,g_imx_t.imx10) THEN
                       LET g_imx[l_ac2].imx10 = g_imx_t.imx10
                       NEXT FIELD imx10
                    END IF
                 END IF
              END IF
           AFTER FIELD imx11
              IF NOT cl_null(g_imx[l_ac2].imx11) THEN
                 IF p_cmd2='a' OR (g_imx[l_ac2].imx11 !=g_imx_t.imx11 AND g_imx_t.imx11 IS NOT NULL) THEN
                    IF NOT p420_check_imx(11,g_imx[l_ac2].imx11,g_imx_t.imx11) THEN
                       LET g_imx[l_ac2].imx11 = g_imx_t.imx11
                       NEXT FIELD imx11
                    END IF
                 END IF
              END IF
           AFTER FIELD imx12
              IF NOT cl_null(g_imx[l_ac2].imx12) THEN
                 IF p_cmd2='a' OR (g_imx[l_ac2].imx12 !=g_imx_t.imx12 AND g_imx_t.imx12 IS NOT NULL) THEN
                    IF NOT p420_check_imx(12,g_imx[l_ac2].imx12,g_imx_t.imx12) THEN
                       LET g_imx[l_ac2].imx12 = g_imx_t.imx12
                       NEXT FIELD imx12
                    END IF
                 END IF
              END IF
           AFTER FIELD imx13
              IF NOT cl_null(g_imx[l_ac2].imx13) THEN
                 IF p_cmd2='a' OR (g_imx[l_ac2].imx13 !=g_imx_t.imx13 AND g_imx_t.imx13 IS NOT NULL) THEN
                    IF NOT p420_check_imx(13,g_imx[l_ac2].imx13,g_imx_t.imx13) THEN
                       LET g_imx[l_ac2].imx13 = g_imx_t.imx13
                       NEXT FIELD imx13
                    END IF
                 END IF
              END IF
           AFTER FIELD imx14
              IF NOT cl_null(g_imx[l_ac2].imx14) THEN
                 IF p_cmd2='a' OR (g_imx[l_ac2].imx14 !=g_imx_t.imx14 AND g_imx_t.imx14 IS NOT NULL) THEN
                    IF NOT p420_check_imx(14,g_imx[l_ac2].imx14,g_imx_t.imx14) THEN
                       LET g_imx[l_ac2].imx14 = g_imx_t.imx14
                       NEXT FIELD imx14
                    END IF
                 END IF
              END IF
           AFTER FIELD imx15
              IF NOT cl_null(g_imx[l_ac2].imx15) THEN
                 IF p_cmd2='a' OR (g_imx[l_ac2].imx15 !=g_imx_t.imx15 AND g_imx_t.imx15 IS NOT NULL) THEN
                    IF NOT p420_check_imx(15,g_imx[l_ac2].imx15,g_imx_t.imx15) THEN
                       LET g_imx[l_ac2].imx15 = g_imx_t.imx15
                       NEXT FIELD imx15
                    END IF
                 END IF
              END IF
              
           ON ROW CHANGE
              CALL p420_ins_slk('u',l_ac2,g_oebslk[l_ac].oebslk04,
                            g_oebslk[l_ac].oebslk01,g_oebslk[l_ac].oebslk03)
              CALL p420_update_oebslk()   #将數量匯總
              IF g_success = 'Y' THEN
                 COMMIT WORK
              ELSE
                 ROLLBACK WORK
              END IF
              DISPLAY ARRAY g_oebslk TO s_oebslk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
                 BEFORE DISPLAY
                    EXIT DISPLAY
              END DISPLAY
           AFTER ROW
              CLOSE p420_bcl_slk

           AFTER INPUT
              IF INT_FLAG THEN                         # 若按了DEL鍵
                 LET INT_FLAG = 0
                 EXIT DIALOG
              END IF
        END INPUT
        
        ON ACTION accept
           LET l_flag = 'Y'
           ACCEPT DIALOG 
        
        ON ACTION cancel
           LET l_flag = 'N'
           EXIT DIALOG
           
       ON ACTION controlb    
        SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01=g_oebslk[l_ac].oebslk04
         IF l_ima151 = 'Y' THEN
            IF li_a THEN
               NEXT FIELD oebslk04
            ELSE
               NEXT FIELD color
            END IF
         END IF

       END DIALOG 
       
       IF INT_FLAG THEN
           LET INT_FLAG = 0
          #EXIT WHILE 
           RETURN   
       END IF
       IF l_flag = 'Y' THEN
          IF cl_null(g_argv1)  THEN
             CALL p420_ins_pmk() RETURNING g_pmk01
             CALL p420_ins_pml()
             CALL p420_ins_pmlslk()
             IF g_success = 'Y ' THEN
                CALL cl_err(g_pmk01,'axm-559',1)
                #IF cl_confirm('mfg-237') THEN
                #    LET g_msg="apmt420_slk ","'",g_pmk01,"'"
                #    CALL cl_cmdrun_wait(g_msg) 
                #END IF
             END IF
          ELSE
            LET g_pmk01 = g_argv1
                CALL p420_ins_pml()
                CALL p420_ins_pmlslk()
                IF g_success = 'Y ' THEN
                   CALL cl_err(g_pmk01,'axm-559',1)
                END IF
          END IF 
       END IF
      CLOSE WINDOW apmp420_slk_w 
      
END FUNCTION 

FUNCTION p420_fill()
   IF cl_null(g_wc) THEN
      LET g_wc = " 1=1"
   END IF

   LET g_sql="SELECT DISTINCT oebslk01,oebslk03,oebslk04,oebslk05,oebslk05_fac,oebslk06,oebslk09,",
                "       oebslk091,oebslk092,oebslk15,oebslk12,oebslk13,oebslk131,oebslk1006,oebslk14,",
                "       oebslk14t,oebslk23,oebslk24,oebslk25,oebslk26,",
                "       oebslk28,oebslk07,oebslk11,oebslkplant,oebslklegal",
                "  FROM oebslk_file,oeb_file,oebi_file,oea_file ",
                " WHERE oebslk01=oea01 ",
                "   AND oeaconf = 'Y' " ,
                "   AND oea01 = oeb01 " ,
                "   AND oebi01 = oeb01 AND oebi03 = oeb03 ",
                "   AND oebi01 = oebslk01 AND oebislk03 = oebslk03 ",
                "   AND ",g_wc CLIPPED,
                " ORDER BY oebslk01"

   PREPARE p420_pp FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   DECLARE p420_cs_slk CURSOR FOR p420_pp
   CALL g_oebslk.clear()
   LET g_cnt=1
   FOREACH p420_cs_slk INTO g_oebslk[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare2:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt=g_cnt+1
      IF g_cnt > g_max_rec THEN    
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_oebslk.deleteElement(g_cnt)
   LET g_rec_b=g_cnt - 1
   IF g_rec_b = 0 THEN
      CALL cl_err('','mfg-239',0)
   END IF   
   DISPLAY g_rec_b TO FORMONLY.cn5
END FUNCTION 

FUNCTION p420_ins_tmpa()

DEFINE l_oeb  RECORD LIKE oeb_file.*
DEFINE l_oebslk03 LIKE oebslk_file.oebslk03

 DROP TABLE tmpa_file
       CREATE TEMP TABLE tmpa_file(
          tmpa01  LIKE oebslk_file.oebslk01,  #单据号码
          tmpa02  LIKE oebslk_file.oebslk03,  #订单母料件項次
          tmpa03  LIKE oeb_file.oeb03,        #訂單子料件項次
          tmpa04  LIKE oebslk_file.oebslk04,  #料件編號
          tmpa05  LIKE oebslk_file.oebslk12)  #訂單數量

   
   LET g_sql = " SELECT * FROM oeb_file,oea_file WHERE oeb01 = oea01 ",
               " AND ",g_wc CLIPPED,
                " ORDER BY oea01"
                
   PREPARE p420_p FROM g_sql 
   DECLARE p420_cs CURSOR FOR p420_p
   INITIALIZE l_oeb.* TO NULL
   FOREACH p420_cs INTO l_oeb.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(l_oeb.oeb01) THEN
          EXIT FOREACH
      END IF
      
      SELECT DISTINCT oebislk03 INTO l_oebslk03 FROM oebi_file         #增加母料件項次
        WHERE oebi01=l_oeb.oeb01
         AND oebi03=l_oeb.oeb03
         
      IF NOT cl_null(l_oeb.oeb01) AND NOT cl_null(l_oeb.oeb03) THEN
         INSERT INTO tmpa_file VALUES(l_oeb.oeb01,l_oebslk03,l_oeb.oeb03,l_oeb.oeb04,l_oeb.oeb12)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tmpa_file",l_ac,"",STATUS,"","ins tmpa",1)
            EXIT FOREACH
         END IF
      END IF
   END FOREACH  
END FUNCTION 

FUNCTION p420_check_imx(p_index,p_qty,p_qty_t)
   DEFINE p_index     LIKE type_file.num5,
          p_qty       LIKE oeb_file.oeb12,
          p_qty_t     LIKE oeb_file.oeb12
   DEFINE l_ima01     LIKE ima_file.ima01
   DEFINE l_img10     LIKE img_file.img10
   DEFINE l_n         LIKE type_file.num5 
   DEFINE l_oeb12     LIKE oeb_file.oeb12
   DEFINE l_ima151    LIKE ima_file.ima151 

    LET g_errno = ''
    LET l_oeb12 = 0
    IF cl_null(g_oebslk[l_ac].oebslk04)  THEN
       RETURN FALSE
    END IF

    IF p_qty < 0 THEN
       CALL cl_err('','art-040',0)
       RETURN FALSE
    END IF
    SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = g_oebslk[l_ac].oebslk04
    IF l_ima151 = 'Y' THEN
       CALL p420_get_ima_slk(l_ac2,p_index,g_oebslk[l_ac].oebslk04) RETURNING l_ima01
    ELSE
       LET l_ima01 = g_oebslk[l_ac].oebslk04
    END IF

    SELECT COUNT(*) INTO l_n FROM oeb_file WHERE oeb01=g_oebslk[l_ac].oebslk01
         AND oeb03 IN (SELECT oeb03 FROM  oeb_file,oebi_file
                        WHERE oeb01=oebi01
                          AND oeb03=oebi03
                          AND oeb01=g_oebslk[l_ac].oebslk01
                          AND oebislk02=g_oebslk[l_ac].oebslk04
                          AND oebislk03=g_oebslk[l_ac].oebslk03)
         AND oeb04=l_ima01
   IF l_n=0  OR cl_null(l_n) THEN
      CALL cl_err('','mfg-235',0) 
      RETURN FALSE
   END IF
   SELECT oeb12 INTO l_oeb12 FROM oeb_file,tmpa_file WHERE oeb01 = g_oebslk[l_ac].oebslk01
                                             AND oeb03 = (SELECT oeb03 FROM oeb_file,oebi_file
                                                            WHERE oebi01 = oeb01
                                                              AND oebi03 = oeb03
                                                              AND oebi01 = g_oebslk[l_ac].oebslk01
                                                              AND oeb04 = l_ima01
                                                              AND oebislk02 = g_oebslk[l_ac].oebslk04   #母料件編號
                                                              AND oebislk03 = g_oebslk[l_ac].oebslk03)  #款號項次  
  IF p_qty > l_oeb12 THEN
     CALL cl_err('','mfg-238',0)
     RETURN FALSE
  END IF

  RETURN TRUE
END FUNCTION

FUNCTION p420_get_ima_slk(p_i,p_index,p_ima01)
   DEFINE p_i         LIKE type_file.num5
   DEFINE p_index     LIKE type_file.num5
   DEFINE l_ima01     LIKE ima_file.ima01
   DEFINE p_ima01     LIKE ima_file.ima01
   DEFINE l_ps        LIKE sma_file.sma46

   SELECT sma46 INTO l_ps FROM sma_file
   IF cl_null(l_ps) THEN LET l_ps = ' ' END IF

   LET l_ima01 = p_ima01,l_ps,
                 g_imx[p_i].color,l_ps,
                 g_imxtext[p_i].detail[p_index].size

   RETURN l_ima01
END FUNCTION

# Usage..........:服飾版本母料件的二維屬性加載（顏色、尺寸） CALL s_set_text_slk(p_ima01)
# Input Parameter: p_ima01 母料件編號
FUNCTION p420_settext_slk(p_ima01)
   DEFINE p_ima01     LIKE ima_file.ima01
   DEFINE l_ima151    LIKE ima_file.ima151
   DEFINE l_index     STRING
   DEFINE l_sql       STRING
   DEFINE l_i,l_j     LIKE type_file.num5
   DEFINE lc_agd02    LIKE agd_file.agd02
   DEFINE lc_agd02_2  LIKE agd_file.agd02
   DEFINE lc_agd03    LIKE agd_file.agd03
   DEFINE lc_agd03_2  LIKE agd_file.agd03
   DEFINE l_imx01     LIKE imx_file.imx01
   DEFINE l_imx02     LIKE imx_file.imx02
   DEFINE ls_value    STRING
   DEFINE ls_desc     STRING
   DEFINE l_repeat1   LIKE type_file.chr1,
          l_repeat2   LIKE type_file.chr1
   DEFINE l_colarray  DYNAMIC ARRAY OF RECORD
          color       LIKE type_file.chr50
                      END RECORD
   DEFINE l_agd04     LIKE agd_file.agd04

   SELECT ima151 INTO l_ima151 FROM ima_file
    WHERE ima01 = p_ima01 AND imaacti='Y' AND ima1010='1' #檢查料件
   IF l_ima151 = 'N' OR cl_null(l_ima151) THEN
      CALL cl_set_comp_visible("color,number,count",FALSE)
      FOR l_i = 1 TO 20
         LET l_index = l_i USING '&&'
         CALL cl_set_comp_visible("imx" || l_index,FALSE)
      END FOR
      RETURN
   ELSE
        CALL cl_set_comp_visible("color,number,count",TRUE)
   END IF

#抓取母料件多屬性資料
   LET l_sql = "SELECT DISTINCT(imx02),agd04 FROM imx_file,agd_file",
               " WHERE imx00 = '",p_ima01,"'",
               "   AND imx02=agd02",
               "   AND agd01 IN ",
               " (SELECT ima941 FROM ima_file WHERE ima01='",p_ima01,"')",
               " ORDER BY agd04"
   PREPARE s_f3_pre FROM l_sql
   DECLARE s_f2_cs CURSOR FOR s_f3_pre

   CALL g_imxtext.clear()
   FOREACH s_f2_cs INTO l_imx02,l_agd04
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare2:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      LET g_imxtext[1].detail[g_imxtext[1].detail.getLength()+1].size=l_imx02 CLIPPED
   END FOREACH

   LET l_sql = "SELECT DISTINCT(imx01),agd04 FROM imx_file,agd_file",
               " WHERE imx00 = '",p_ima01,"'",
               "   AND imx01=agd02",
               "   AND agd01 IN ",
               " (SELECT ima940 FROM ima_file WHERE ima01='",p_ima01,"')",
               " ORDER BY agd04"
   PREPARE s_colslk_pre FROM l_sql
   DECLARE s_colslk_cs CURSOR FOR s_colslk_pre

   CALL l_colarray.clear()
   FOREACH s_colslk_cs INTO l_imx01,l_agd04
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare2:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      LET l_colarray[l_colarray.getLength()+1].color=l_imx01 CLIPPED
   END FOREACH

   FOR l_i = 1 TO l_colarray.getLength()
      LET g_imxtext[l_i].* = g_imxtext[1].*
      LET g_imxtext[l_i].color = l_colarray[l_i].color
   END FOR

   FOR l_i = 1 TO g_imxtext.getLength()
      LET lc_agd02 = g_imxtext[l_i].color CLIPPED
      LET ls_value = ls_value,lc_agd02,","
      SELECT agd03 INTO lc_agd03 FROM agd_file,ima_file
       WHERE agd01 = ima940 AND agd02 = lc_agd02
         AND ima01 = p_ima01
      LET ls_desc = ls_desc,lc_agd02,":",lc_agd03 CLIPPED,","
   END FOR
   CALL cl_set_combo_items("color",ls_value.subString(1,ls_value.getLength()-1),ls_desc.subString(1,ls_desc.getLength()-1))
   FOR l_i = 1 TO g_imxtext[1].detail.getLength()
      LET l_index = l_i USING '&&'
      LET lc_agd02_2 = g_imxtext[1].detail[l_i].size CLIPPED
      SELECT agd03 INTO lc_agd03_2 FROM agd_file,ima_file
       WHERE agd01 = ima941 AND agd02 = lc_agd02_2
         AND ima01 = p_ima01
      CALL cl_set_comp_visible("imx" || l_index,TRUE)
      CALL cl_set_comp_att_text("imx" || l_index,lc_agd03_2)
   END FOR
   FOR l_i = g_imxtext[1].detail.getLength()+1 TO 20
      LET l_index = l_i USING '&&'
      CALL cl_set_comp_visible("imx" || l_index,FALSE)
   END FOR
END FUNCTION

#
#Usage..........: 函數功能說明：此函數為母料件單身調用，用於帶出各個二維屬性對應的子料件的數量值，并儲存在g_imx中
#                               傳入參數：母料件編號，儲存子料件的表的表名,key列名以及key相應的值
#                 如訂單使用此函數：CALL s_fillimx_slk(p_ima01,g_oea.oea01,g_oeaslk[l_ac2].oeaslk03)
#
# Input Parameter: p_ima01            母料件編號
#                  p_keyvalue1        key值1--primary key value1，單據編號
#                  p_keyvalue2        key值2--primary key value2，母料件項次
#
FUNCTION p420_fillimx_slk(p_ima01,p_keyvalue1,p_keyvalue2)
  DEFINE p_ima01             LIKE ima_file.ima01
  DEFINE p_keyvalue1         LIKE type_file.chr20
  DEFINE p_keyvalue2         LIKE type_file.chr20
  DEFINE l_ima151            LIKE ima_file.ima151
  DEFINE l_i,l_j,l_k         LIKE type_file.num5
  DEFINE l_sql               STRING

   SELECT ima151 INTO l_ima151 FROM ima_file
    WHERE ima01 = p_ima01 AND imaacti='Y'
   IF l_ima151 = 'N' OR cl_null(l_ima151) THEN
      RETURN
   END IF

   LET g_keyvalue1=p_keyvalue1
   LET g_keyvalue2=p_keyvalue2
   LET l_sql = "SELECT tmpa05 FROM tmpa_file,oebi_file ",   #採購數量
                        " WHERE tmpa04= ?",                 #子料件编号
                        "   AND tmpa01=oebi01 ",            #單據號碼
                        "   AND tmpa03=oebi03 ",            #子料件項次
                        "   AND oebi01='",p_keyvalue1,"'",
                        "   AND oebislk03='",p_keyvalue2,"'"

   PREPARE p420_getamount_slk_pre FROM l_sql

   CALL g_imx.clear()

   FOR l_k = 1 TO g_imxtext.getLength() #遍歷母料件二維屬性數組
      LET l_i=g_imx.getLength()+1
      LET g_imx[l_i].color = g_imxtext[l_k].color CLIPPED  #得到顏色屬性值
      FOR l_j = 1 TO g_imxtext[1].detail.getLength()
         CASE l_j
          WHEN 1
             CALL p420_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx01
          WHEN 2
             CALL p420_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx02
          WHEN 3
             CALL p420_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx03
          WHEN 4
             CALL p420_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx04
          WHEN 5
             CALL p420_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx05
          WHEN 6
             CALL p420_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx06
          WHEN 7
             CALL p420_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx07
          WHEN 8
             CALL p420_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx08
          WHEN 9
             CALL p420_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx09
          WHEN 10
             CALL p420_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx10
          WHEN 11
             CALL p420_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx11
          WHEN 12
             CALL p420_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx12
          WHEN 13
             CALL p420_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx13
          WHEN 14
             CALL p420_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx14
          WHEN 15
             CALL p420_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx15
         END CASE

      END FOR
   END FOR
   FOR l_i =  g_imx.getLength() TO 1 STEP -1    #如果二維屬性單身的數量全部為零，刪除數據

      IF (g_imx[l_i].imx01 IS NULL OR g_imx[l_i].imx01 = 0) AND
         (g_imx[l_i].imx02 IS NULL OR g_imx[l_i].imx02 = 0) AND
         (g_imx[l_i].imx03 IS NULL OR g_imx[l_i].imx03 = 0) AND
         (g_imx[l_i].imx04 IS NULL OR g_imx[l_i].imx04 = 0) AND
         (g_imx[l_i].imx05 IS NULL OR g_imx[l_i].imx05 = 0) AND
         (g_imx[l_i].imx06 IS NULL OR g_imx[l_i].imx06 = 0) AND
         (g_imx[l_i].imx07 IS NULL OR g_imx[l_i].imx07 = 0) AND
         (g_imx[l_i].imx08 IS NULL OR g_imx[l_i].imx08 = 0) AND
         (g_imx[l_i].imx09 IS NULL OR g_imx[l_i].imx09 = 0) AND
         (g_imx[l_i].imx10 IS NULL OR g_imx[l_i].imx10 = 0) AND
         (g_imx[l_i].imx11 IS NULL OR g_imx[l_i].imx11 = 0) AND
         (g_imx[l_i].imx12 IS NULL OR g_imx[l_i].imx12 = 0) AND
         (g_imx[l_i].imx13 IS NULL OR g_imx[l_i].imx13 = 0) AND
         (g_imx[l_i].imx14 IS NULL OR g_imx[l_i].imx14 = 0) AND
         (g_imx[l_i].imx15 IS NULL OR g_imx[l_i].imx15 = 0)
         THEN
          CALL g_imx.deleteElement(l_i)
      END IF
   END FOR
   LET g_rec_b2 = g_imx.getLength()

END FUNCTION

#得到對應的子料件的數量
FUNCTION p420_get_amount_slk(p_j,p_k,p_ima01)
    DEFINE l_sql     STRING
    DEFINE p_j       LIKE type_file.num5
    DEFINE p_k       LIKE type_file.num5
    DEFINE p_ima01   LIKE ima_file.ima01
    DEFINE l_ps      LIKE sma_file.sma46
    DEFINE l_qty     LIKE rvb_file.rvb07
    DEFINE l_ima01   LIKE ima_file.ima01
    DEFINE l_azw05   LIKE azw_file.azw05
    DEFINE l_dbs     LIKE type_file.chr21

    SELECT sma46 INTO l_ps FROM sma_file
    IF cl_null(l_ps) THEN
       LET l_ps=' '
    END IF
    LET l_ima01 = p_ima01,l_ps,g_imxtext[p_k].color,l_ps,g_imxtext[p_k].detail[p_j].size  #得到子料件編號

    EXECUTE p420_getamount_slk_pre USING l_ima01 INTO l_qty

    IF cl_null(l_qty) THEN
       LET l_qty = 0
    END IF

    RETURN l_qty

END FUNCTION

# Usage..........:更新、刪除、新增子料件數據
#
# Input Parameter: p_cmd  r:刪除
#                         a:新增
#                         u:修改
#                  p_ac 當前所在的行--g_imx二維屬性單身，光標所在的行
#                  p_ima01            母料件編號
#                  p_keyvalue1        單據編號
#                  p_keyvalue2        母料件項次

FUNCTION p420_ins_slk(p_cmd,p_ac,p_ima01,p_keyvalue1,p_keyvalue2)
   DEFINE p_ac                LIKE type_file.num5
   DEFINE p_ima01             LIKE ima_file.ima01
   DEFINE p_cmd               LIKE type_file.chr1
   DEFINE p_keyvalue1         LIKE type_file.chr20
   DEFINE p_keyvalue2         LIKE type_file.chr20
   DEFINE l_sql1              STRING
   DEFINE l_sql2              STRING
   DEFINE l_sql3              STRING
   DEFINE l_sql4              STRING
   DEFINE l_sql5              STRING

      LET g_keyvalue1=p_keyvalue1
      LET g_keyvalue2=p_keyvalue2
      LET l_sql1 = "SELECT count(*) FROM tmpa_file,oebi_file ",
                        "  WHERE tmpa04= ? ",
                        "   AND oebi01=tmpa01",
                        "   AND oebi03=tmpa03",
                        "   AND oebi01='",g_keyvalue1,"'",
                        "   AND oebislk03='",g_keyvalue2,"'"

      LET l_sql3 = "SELECT oebi03 FROM tmpa_file,oebi_file ",
                        " WHERE tmpa04= ? ",
                        "   AND tmpa01=oebi01 ",
                        "   AND tmpa03=oebi03 ",
                        "   AND oebi01='",g_keyvalue1,"'",
                        "   AND oebislk03='",g_keyvalue2,"'"

     LET l_sql4 = " DELETE FROM tmpa_file ",
                        "  WHERE tmpa01='",g_keyvalue1,"'",
                        "    AND tmpa03=? "
   PREPARE p420_getcount_slk_pre FROM l_sql1  #檢查是否存在
   PREPARE p420_selkey_slk_pre   FROM l_sql3  #得到對應子料件的項次
   PREPARE p420_delslk_slk_pre   FROM l_sql4  #刪除子料件

   IF g_imx[p_ac].imx01 >= 0 THEN
      CALL p420_imx_ins_slk(p_ac,1,g_imx[p_ac].imx01,p_cmd,p_ima01)
   END IF
   IF g_imx[p_ac].imx02 >=0 THEN
      CALL p420_imx_ins_slk(p_ac,2,g_imx[p_ac].imx02,p_cmd,p_ima01)
   END IF
   IF g_imx[p_ac].imx03 >=0 THEN
      CALL p420_imx_ins_slk(p_ac,3,g_imx[p_ac].imx03,p_cmd,p_ima01)
   END IF
   IF g_imx[p_ac].imx04 >=0 THEN
      CALL p420_imx_ins_slk(p_ac,4,g_imx[p_ac].imx04,p_cmd,p_ima01)
   END IF
   IF g_imx[p_ac].imx05 >=0 THEN
      CALL p420_imx_ins_slk(p_ac,5,g_imx[p_ac].imx05,p_cmd,p_ima01)
   END IF
   IF g_imx[p_ac].imx06 >=0 THEN
      CALL p420_imx_ins_slk(p_ac,6,g_imx[p_ac].imx06,p_cmd,p_ima01)
   END IF
   IF g_imx[p_ac].imx07 >=0 THEN
      CALL p420_imx_ins_slk(p_ac,7,g_imx[p_ac].imx07,p_cmd,p_ima01)
   END IF
   IF g_imx[p_ac].imx08 >=0 THEN
      CALL p420_imx_ins_slk(p_ac,8,g_imx[p_ac].imx08,p_cmd,p_ima01)
   END IF
   IF g_imx[p_ac].imx09 >=0 THEN
      CALL p420_imx_ins_slk(p_ac,9,g_imx[p_ac].imx09,p_cmd,p_ima01)
   END IF
   IF g_imx[p_ac].imx10 >=0 THEN
      CALL p420_imx_ins_slk(p_ac,10,g_imx[p_ac].imx10,p_cmd,p_ima01)
   END IF
   IF g_imx[p_ac].imx11 >=0 THEN
      CALL p420_imx_ins_slk(p_ac,11,g_imx[p_ac].imx11,p_cmd,p_ima01)
   END IF
   IF g_imx[p_ac].imx12 >=0 THEN
      CALL p420_imx_ins_slk(p_ac,12,g_imx[p_ac].imx12,p_cmd,p_ima01)
   END IF
   IF g_imx[p_ac].imx13 >=0 THEN
      CALL p420_imx_ins_slk(p_ac,13,g_imx[p_ac].imx13,p_cmd,p_ima01)
   END IF
   IF g_imx[p_ac].imx14 >=0 THEN
      CALL p420_imx_ins_slk(p_ac,14,g_imx[p_ac].imx14,p_cmd,p_ima01)
   END IF
   IF g_imx[p_ac].imx15 >=0 THEN
      CALL p420_imx_ins_slk(p_ac,15,g_imx[p_ac].imx15,p_cmd,p_ima01)
   END IF
END FUNCTION

FUNCTION p420_imx_ins_slk(p_i,p_index,p_qty,p_cmd,p_ima01)
   DEFINE p_i           LIKE type_file.num5
   DEFINE p_index       LIKE type_file.num5
   DEFINE p_qty         LIKE type_file.num10
   DEFINE l_ima01       LIKE ima_file.ima01
   DEFINE p_ima01       LIKE ima_file.ima01
   DEFINE l_n           LIKE type_file.num5
   DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_key2        LIKE oebi_file.oebi03
   DEFINE l_max         LIKE type_file.num5
   DEFINE l_oea213      LIKE oea_file.oea213
   DEFINE l_oea211      LIKE oea_file.oea211
   DEFINE l_oha213      LIKE oha_file.oha213
   DEFINE l_oha211      LIKE oha_file.oha211
   DEFINE l_gec05       LIKE gec_file.gec05
   DEFINE l_gec07       LIKE gec_file.gec05
   DEFINE l_pmm21       LIKE pmm_file.pmm21
   DEFINE l_pmm22       LIKE pmm_file.pmm22
   DEFINE l_pmm43       LIKE pmm_file.pmm43
   DEFINE l_pmnslk25    LIKE pmnslk_file.pmnslk25

#得到子料件編號
   CALL p420_get_ima_slk(p_i,p_index,p_ima01) RETURNING l_ima01
   EXECUTE p420_getcount_slk_pre USING l_ima01 INTO l_n

   IF l_n > 0 THEN                      #數據庫中有子料件的數據
      IF p_qty >= 0 AND p_cmd='u' THEN   #修改子料件的數量

                    UPDATE tmpa_file SET tmpa05 =p_qty
                      WHERE tmpa04=l_ima01
                        AND tmpa01=g_keyvalue1
                        AND tmpa03 in (
                                        SELECT oebi03 FROM oebi_file
                                         WHERE oebi01=g_keyvalue1
                                           AND oebislk03=g_keyvalue2)
        IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
        END IF
      END IF
   END IF
#  IF p_cmd='r' OR (p_qty=0 AND p_cmd='u') THEN   #刪除子料件的數據
#        SELECT COUNT(*) INTO l_n FROM tmpa_file
#             WHERE tmpa00=g_keyvalue1
#               AND tmpa02=( SELECT tmpa02 FROM tmpa_file,pmli_file
#                         WHERE tmpa00=pmli01
#                           AND tmpa02=pmli02
#                           AND tmpa01=pmlislk03
#                           AND pmli01=g_keyvalue1
#                           AND tmpa03=l_ima01
#                           AND pmlislk03=g_keyvalue2)
#      IF l_n > 0 THEN
#          EXECUTE p420_selkey_slk_pre USING l_ima01 INTO l_key2
#          EXECUTE p420_delslk_slk_pre USING l_key2
#        IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#           CALL cl_err3("del",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
#           LET g_success = 'N'
#        END IF
#      END IF
#  ELSE
#     IF p_qty > 0 AND (p_cmd='a' OR p_cmd='u') THEN    #新增子料件的數據
#         SELECT MAX(tmpa02) INTO l_max FROM tmpa_file
#                  WHERE tmpa00=g_keyvalue1
#                IF cl_null(l_max) THEN
#                   LET l_max=1
#                ELSE
#                   LET l_max=l_max+1
#                END IF
#         INSERT INTO tmpa_file VALUES(g_keyvalue1,g_keyvalue2,l_max,l_ima01,p_qty)
#         IF SQLCA.sqlcode THEN
#            CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
#            LET g_success = 'N'
#         END IF
#     END IF
#  END IF
END FUNCTION

FUNCTION p420_update_oebslk()
 DEFINE l_sum_oeb12         LIKE oeb_file.oeb12
 
 SELECT SUM(tmpa05) INTO l_sum_oeb12 FROM tmpa_file
    WHERE tmpa01= g_oebslk[l_ac].oebslk01
      AND tmpa03 IN (SELECT tmpa03 FROM tmpa_file,oebi_file
                     WHERE tmpa01= oebi01 AND tmpa03=oebi03
                       AND oebi01= g_oebslk[l_ac].oebslk01
                       AND oebislk02= g_oebslk[l_ac].oebslk04
                       AND oebislk03= g_oebslk[l_ac].oebslk03)
    LET g_oebslk[l_ac].oebslk12=l_sum_oeb12
    DISPLAY g_oebslk[l_ac].oebslk12 TO s_oebslk[l_ac].oebslk12
END FUNCTION

FUNCTION p420_ins_pmk() 
 DEFINE l_pmk    RECORD LIKE pmk_file.*
 DEFINE li_result LIKE type_file.num5  
 DEFINE l_slip   LIKE type_file.chr5

   INITIALIZE l_pmk.* TO NULL
  # SELECT smyslip INTO l_slip FROM smy_file
  #             WHERE smysys = 'apm' AND smykind = '2'
  
   #SELECT rye03 INTO l_slip FROM rye_file WHERE rye01 = 'apm' AND rye02= '1'             #FUN-C90050 mark
   CALL s_get_defslip('apm','1',g_plant,'N') RETURNING l_slip    #FUN-C90050 add 
   CALL s_auto_assign_no("apm",l_slip,g_today,"","pmk_file","pmk01","","","")             #No.FUN-560132
        RETURNING li_result,l_pmk.pmk01
   LET l_pmk.pmk02 = 'REG'       #單號性質
   LET l_pmk.pmk03 = '0'
   LET l_pmk.pmk04 = g_today     #請購日期
   LET l_pmk.pmk12 = g_user
   LET l_pmk.pmk13 = g_grup
   LET l_pmk.pmk18 = 'N'
   LET l_pmk.pmk25 = '0'         #開立
   LET l_pmk.pmk27 = g_today
   LET l_pmk.pmk30 = 'Y'
   LET l_pmk.pmk40 = 0           #總金額
   LET l_pmk.pmk401= 0           #總金額
   LET l_pmk.pmk42 = 1           #匯率
   LET l_pmk.pmk43 = 0           #稅率
   LET l_pmk.pmk45 = 'Y'         #可用
   SELECT smyapr,smysign INTO l_pmk.pmkmksg,l_pmk.pmksign   #NO:5012
     FROM smy_file
    WHERE smyslip = l_slip
   IF SQLCA.sqlcode OR cl_null(l_pmk.pmkmksg) THEN
      LET l_pmk.pmkmksg = 'N'
      LET l_pmk.pmksign= NULL
   END IF
   LET l_pmk.pmkdays = 0         #簽核天數
   LET l_pmk.pmksseq = 0         #應簽順序
   LET l_pmk.pmkprno = 0         #列印次數
   CALL signm_count(l_pmk.pmksign) RETURNING l_pmk.pmksmax
   LET l_pmk.pmkacti ='Y'        #有效的資料
   LET l_pmk.pmkuser = g_user    #使用者
   LET l_pmk.pmkgrup = g_grup    #使用者所屬群
   LET l_pmk.pmkdate = g_today
   IF g_azw.azw04='2' THEN
      LET l_pmk.pmk46='3'
      LET l_pmk.pmk47=g_plant  
   ELSE
      #LET l_pmk.pmk46='1'       #MOD-C10218 mark
      LET l_pmk.pmk46='3'        #MOD-C10218 add
      LET l_pmk.pmk47=''
   END IF
   LET l_pmk.pmkcond= ''             #審核日期
   LET l_pmk.pmkconu= ''             #審核時間
   LET l_pmk.pmkcrat= g_today        #資料創建日
   LET l_pmk.pmkplant = g_plant        #機構別
   LET l_pmk.pmklegal = g_legal        #FUN-980010 add
   LET l_pmk.pmkoriu = g_user      #No.FUN-980030 10/01/04
   LET l_pmk.pmkorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO pmk_file VALUES(l_pmk.*)     #DISK WRITE
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL s_errmsg("pmk01",l_pmk.pmk01,"ins pmk",SQLCA.sqlcode,1)        #No.FUN-710046
      LET g_success = 'N'
   END IF           #NO.FUN-670007  add
   RETURN l_pmk.pmk01

END FUNCTION        #NO.FUN-670007  add

FUNCTION p420_ins_pml()
 DEFINE l_oeo    RECORD LIKE oeo_file.*
 DEFINE l_qty    LIKE oeb_file.oeb12
 DEFINE l_oeb    RECORD LIKE oeb_file.*
 DEFINE l_tmpa   RECORD 
                 tmpa01 LIKE oea_file.oea01,
                 tmpa02 LIKE oebslk_file.oebslk03,
                 tmpa03 LIKE oeb_file.oeb03,
                 tmpa04 LIKE oeb_file.oeb04,
                 tmpa05 LIKE oeb_file.oeb12
                 END RECORD  
                        
 DEFINE l_pml    RECORD LIKE pml_file.*
 DEFINE l_ima01     LIKE ima_file.ima01,
         l_ima02     LIKE ima_file.ima02,
         l_ima05     LIKE ima_file.ima05,
         l_ima25     LIKE ima_file.ima25,
         l_ima27     LIKE ima_file.ima27,
         l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk    LIKE type_file.num15_3, 
         l_ima44     LIKE ima_file.ima44,
         l_ima44_fac LIKE ima_file.ima44_fac,
         l_ima45     LIKE ima_file.ima45,
         l_ima46     LIKE ima_file.ima46,
         l_ima49     LIKE ima_file.ima49,
         l_ima491    LIKE ima_file.ima491,
         l_ima913    LIKE ima_file.ima913,   
         l_ima914    LIKE ima_file.ima914,   
         l_pan       LIKE type_file.num10,   
         l_flag      LIKE type_file.chr1,   
         l_double    LIKE type_file.num10    
   DEFINE l_pmli     RECORD LIKE pmli_file.*
   DEFINE l_rty03    LIKE rty_file.rty03       
   DEFINE l_rty06    LIKE rty_file.rty06 
   DEFINE l_cnt      LIKE type_file.num10,
          l_oeb01     LIKE oeb_file.oeb01,
         l_oeb03     LIKE oeb_file.oeb03,
         l_oeb03_t   LIKE oeb_file.oeb03,
         l_oeb04     LIKE oeb_file.oeb04,
         l_oeb05_fac LIKE oeb_file.oeb05_fac,
         l_oeb05     LIKE oeb_file.oeb05,
         l_oeb06     LIKE oeb_file.oeb06,
         l_oeb12     LIKE oeb_file.oeb12,
         l_oeb15     LIKE oeb_file.oeb15,
         l_oeb28     LIKE oeb_file.oeb28,
         l_oeb24     LIKE oeb_file.oeb24,
         l_oeb910    LIKE oeb_file.oeb910,
         l_oeb911    LIKE oeb_file.oeb911,
         l_oeb912    LIKE oeb_file.oeb912,
         l_oeb913    LIKE oeb_file.oeb913,
         l_oeb914    LIKE oeb_file.oeb914,
         l_oeb915    LIKE oeb_file.oeb915,
         l_oeb916    LIKE oeb_file.oeb916,
         l_oeb917    LIKE oeb_file.oeb917,
         l_oeb919    LIKE oeb_file.oeb919,
         l_oeb41     LIKE oeb_file.oeb41,
         l_oeb42     LIKE oeb_file.oeb42,
         l_oeb43     LIKE oeb_file.oeb43
         


      DECLARE p420_oeb_curs CURSOR FOR
       SELECT * FROM tmpa_file 
       
      FOREACH  p420_oeb_curs INTO l_tmpa.*
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('','',"foreach:",SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         INITIALIZE l_pml.* TO NULL
         LET l_pml.pml01 = g_pmk01
         SELECT MAX(pml02) INTO l_cnt FROM pml_file WHERE pml01 = g_pmk01
         IF l_cnt > 0 THEN
            LET l_pml.pml02 =  l_cnt + 1  
         ELSE
            LET l_pml.pml02 = 1
         END IF
         LET l_pml.pml011 = 'REG'
         LET l_pml.pml16 = '0'
         LET l_pml.pml14 = g_sma.sma886[1,1]    
         LET l_pml.pml15  =g_sma.sma886[2,2]
         LET l_pml.pml23 = 'Y'         
         LET l_pml.pml38  ='Y'
         LET l_pml.pml43 = 0                
         LET l_pml.pml431 = 0
         LET l_pml.pml11 = 'N'              
         LET l_pml.pml13  = 0
         LET l_pml.pml21  = 0
         LET l_pml.pml30 = 0                
         LET l_pml.pml32 = 0
         LET l_pml.pml930=s_costcenter(g_grup) 
         LET l_pml.pmlplant=g_plant  
         LET l_pml.pmllegal=g_legal
         SELECT oeb49,oeb15,oeb05_fac,oeb06,oeb910,oeb911,oeb912,oeb913,oeb914,oeb915,oeb916,
                oeb41,oeb42,oeb43,oeb919 
           INTO l_pml.pml49,l_oeb15,l_oeb05_fac,l_oeb06,l_oeb911,l_oeb912,l_oeb913,
                l_oeb914,l_oeb915,l_oeb916,l_oeb41,l_oeb42,l_oeb43,l_oeb919 
          FROM oeb_file WHERE oeb01 = l_tmpa.tmpa01 AND oeb03 = l_tmpa.tmpa03    
         LET l_ima913 = 'N'  
         IF l_tmpa.tmpa04[1,4] <> "MISC" THEN
         SELECT ima01,ima02,ima05,ima25,0,ima27,ima44,ima44_fac, 
              ima45,ima46,ima49,ima491,
              ima913,ima914       
         INTO l_ima01,l_ima02,l_ima05,l_ima25,l_avl_stk,l_ima27,
              l_ima44,l_ima44_fac,l_ima45,l_ima46,l_ima49,l_ima491,
              l_ima913,l_ima914    
         FROM ima_file
        WHERE ima01 = l_tmpa.tmpa04
        CALL s_getstock(l_tmpa.tmpa04,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk 
        IF SQLCA.sqlcode THEN
           CALL s_errmsg("ima01",l_tmpa.tmpa04,"sel ima:",SQLCA.sqlcode,1)    
           LET g_success = 'N'
           RETURN
        END IF
        LET l_pml.pml04 = l_ima01
        LET l_pml.pml041= l_ima02
        LET l_pml.pml05 = NULL    
        LET l_pml.pml07 = l_ima44    
        LET l_pml.pml08 = l_ima25
       CALL s_umfchk(l_pml.pml04,l_pml.pml07,
            l_pml.pml08) RETURNING l_flag,l_pml.pml09
            IF cl_null(l_pml.pml09) THEN LET l_pml.pml09=1 END IF
      #先將訂單數量轉換成請購單位數量
     # LET l_tmpa.tmpa05 = l_tmpa.tmpa05  * l_oeb05_fac / l_pml.pml09
       LET l_oeb28=0
       LET l_oeb24=0
       SELECT oeb28,oeb24 INTO l_oeb28,l_oeb24
         FROM oeb_file
        WHERE oeb01=l_tmpa.tmpa01
          AND oeb03=l_tmpa.tmpa03
       IF cl_null(l_oeb28) THEN LET l_oeb28 = 0 END IF
       IF cl_null(l_oeb24) THEN LET l_oeb24 = 0 END IF
    #  LET l_tmpa.tmpa05 = (l_tmpa.tmpa05-l_oeb28-l_oeb24)
       LET l_pml.pml42 = '0'
    IF g_sma.sma115='N' THEN      #No.TQC-740351
       #-->考慮最少採購量/倍量
       IF l_tmpa.tmpa05 > 0 THEN  #FUN-730018
            IF l_tmpa.tmpa05 < l_ima46 THEN #FUN-730018
              #CALL s_sizechk(l_pml.pml04,l_tmpa.tmpa05,g_lang)             #TQC-D40015 mark
               CALL s_sizechk(l_pml.pml04,l_tmpa.tmpa05,g_lang,l_pml.pml07) #TQC-D40015
                             RETURNING l_pml.pml20
           ELSE
               IF l_ima45 > 0 THEN
                   LET l_pan = (l_tmpa.tmpa05 * 1000) / (l_ima45 * 1000)
                   IF (l_pan*(l_ima45*1000)) > (l_tmpa.tmpa05 * 1000) THEN
                       LET l_pan=(l_tmpa.tmpa05*1000) -((l_pan-1)*(l_ima45*1000))
                   ELSE
                       LET l_pan=(l_tmpa.tmpa05*1000) -(l_pan*(l_ima45*1000))
                   END IF

                   IF l_pan !=0 THEN
                       LET l_double = (l_tmpa.tmpa05/l_ima45) + 1
                   ELSE
                       LET l_double = l_tmpa.tmpa05/l_ima45
                   END IF
                   LET l_pml.pml20  = l_double * l_ima45
               ELSE
                   LET l_pml.pml20 = l_tmpa.tmpa05
               END IF
               LET l_pml.pml20 = s_digqty(l_pml.pml20,l_pml.pml07) 
           END IF
       ELSE
           LET l_pml.pml20 = 0
       END IF
    ELSE      
       LET l_pml.pml20 = l_tmpa.tmpa05     
    END IF    
       LET l_pml.pml35 = l_oeb15                 #到庫日期
       CALL s_aday(l_pml.pml35,-1,l_ima491) RETURNING l_pml.pml34 
       CALL s_aday(l_pml.pml34,-1,l_ima49) RETURNING l_pml.pml33
   ELSE
       LET l_pml.pml04 = l_tmpa.tmpa04
       LET l_pml.pml041= l_oeb06
       LET l_pml.pml05 = NULL
       LET l_pml.pml07 = l_oeb05
       LET l_pml.pml08 = l_oeb05
       LET l_pml.pml09 = 1
       LET l_pml.pml42 = '0'
       LET l_pml.pml20 = l_tmpa.tmpa05                       
       LET l_pml.pml35 = l_oeb15
       CALL s_aday(l_pml.pml35,-1,l_ima491) RETURNING l_pml.pml34  
       CALL s_aday(l_pml.pml34,-1,l_ima49) RETURNING l_pml.pml33  
   END IF
   LET l_pml.pml80 = l_oeb910
   LET l_pml.pml81 = l_oeb911
   LET l_pml.pml82 = l_oeb912
   LET l_pml.pml83 = l_oeb913
   LET l_pml.pml84 = l_oeb914
   LET l_pml.pml85 = l_oeb915
   LET l_pml.pml86 = l_oeb916
   LET l_pml.pml12 = l_oeb41
   LET l_pml.pml121 = l_oeb42
   LET l_pml.pml122 = l_oeb43
   LET l_pml.pml919 = l_oeb919  
   IF g_sma.sma116 MATCHES'[13]' THEN
      LET l_pml.pml86 = l_oeb916
   ELSE
      LET l_pml.pml86 = l_pml.pml07
   END IF
   LET g_pml.* = l_pml.*      
   CALL p420_set_pml87()      
   LET l_pml.pml87=g_pml.pml87 


   LET l_pml.pml190 = l_ima913    #統購否
   LET l_pml.pml191 = l_ima914    #採購成本中心
   LET l_pml.pml192 = 'N'         #拋轉否

   LET l_pml.pml24 = l_tmpa.tmpa01
   LET l_pml.pml25 = l_tmpa.tmpa03
   IF g_azw.azw04='2' THEN
      LET l_pml.pml47 = ''
      SELECT rty03,rty06 INTO l_rty03,l_rty06 FROM rty_file
       WHERE rty01=g_plant AND rty02=l_tmpa.tmpa04
      IF SQLCA.sqlcode=100 THEN
         LET l_rty03=NULL
         LET l_rty06=NULL
      END IF
      LET l_pml.pml49=l_rty06
      LET l_pml.pml50=l_rty03
      IF l_pml.pml50='2' THEN
         LET l_pml.pml51=g_plant
         LET l_pml.pml52=g_pmk01
         LET l_pml.pml53=l_pml.pml02
      ELSE
         LET l_pml.pml51=''
         LET l_pml.pml52=''
         LET l_pml.pml53=''
      END IF
      SELECT rty05 INTO l_pml.pml48 FROM rty_file
       WHERE rty01= (SELECT oea84 FROM oea_file WHERE oea01=l_tmpa.tmpa01)
         AND rtyacti='Y' AND rty02=l_tmpa.tmpa04 
      IF SQLCA.sqlcode=100 THEN
         SELECT rty05 INTO l_pml.pml48 FROM rty_file
          WHERE rty01=g_plant AND rtyacti='Y' AND rty02=l_tmpa.tmpa04 
         IF SQLCA.sqlcode=100 THEN
            LET l_pml.pml48=null
         END IF
      END IF
      LET l_pml.pml54='2'
   ELSE
      LET l_pml.pml47=''
      LET l_pml.pml48=''
      LET l_pml.pml49='1'
      LET l_pml.pml50='1'
      LET l_pml.pml51=''
      LET l_pml.pml52=''
      LET l_pml.pml53=''
      LET l_pml.pml54=' '
   END IF
   LET l_pml.pml20 = l_tmpa.tmpa05
   LET l_pml.pml82 = l_pml.pml20
   LET l_pml.pml87 = l_pml.pml20
   IF cl_null(l_pml.pml88) THEN
      LET l_pml.pml88 = 0
   END IF
   IF cl_null(l_pml.pml88t) THEN
      LET l_pml.pml88t = 0
   END IF
   IF cl_null(l_pml.pml49) THEN
      LET l_pml.pml49 = ' '
   END IF
   IF cl_null(l_pml.pml50) THEN
      LET l_pml.pml50 = '1'
   END IF
   LET l_pml.pml56 = '1'  
   LET l_pml.pml91 = 'N'  
   LET l_pml.pml92 = 'N' 
   INSERT INTO pml_file VALUES(l_pml.*)
   IF SQLCA.sqlcode THEN
      CALL s_errmsg("pml01",l_pml.pml01,"INS pml_file",SQLCA.sqlcode,1)      
      LET g_success = 'N'
   ELSE
      IF NOT s_industry('std') THEN
         INITIALIZE l_pmli.* TO NULL
         LET l_pmli.pmli01 = l_pml.pml01
         LET l_pmli.pmli02 = l_pml.pml02
         LET l_pmli.pmliplant = l_pml.pmlplant
         LET l_pmli.pmlilegal = l_pml.pmllegal
         INSERT INTO pmli_file VALUES(l_pmli.*)
         IF SQLCA.sqlcode THEN
            CALL s_errmsg("pmli01",l_pmli.pmli01,"INS pmli_file",SQLCA.sqlcode,1)
            LET g_success = 'N'
         END IF
      END IF
   END IF
    SELECT SUM(pml20) INTO l_pml.pml20
      FROM pml_file,pmk_file
     WHERE pml24 = l_pml.pml24
       AND pml25 = l_pml.pml25
       AND pml01 = pmk01
       AND pmk18 <> 'X'
       AND pml16 <> '9'
#要回寫每張訂單的己拋量和請購單號
   UPDATE oeb_file SET oeb27 = g_pmk01,
                       oeb28 = l_pml.pml20
                 WHERE oeb01 = l_tmpa.tmpa01
                   AND oeb03 = l_tmpa.tmpa03                   
   IF SQLCA.sqlcode THEN
      LET g_showmsg=l_tmpa.tmpa01,"/",l_tmpa.tmpa03     
      CALL s_errmsg("oeb01,oeb03",g_showmsg,"UPD oeb_file",SQLCA.sqlcode,1)   
      LET g_success = 'N'
   END IF
   
  END FOREACH

END FUNCTION


FUNCTION p420_ins_pmlslk()
DEFINE l_pmlslk  RECORD LIKE pmlslk_file.*
DEFINE i         LIKE type_file.num10
DEFINE l_tmpa01  LIKE oea_file.oea01
DEFINE l_tmpa02  LIKE oebslk_file.oebslk03
DEFINE l_pml02   LIKE pml_file.pml02
DEFINE l_oea23   LIKE oea_file.oea23

    DECLARE p420_g_pmlslk CURSOR FOR SELECT DISTINCT tmpa01,tmpa02 FROM tmpa_file  ORDER BY tmpa01 
                                     
    FOREACH p420_g_pmlslk INTO l_tmpa01,l_tmpa02

      SELECT oea23 INTO l_oea23 FROM oea_file WHERE oea01 = l_tmpa01
      SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file  
       WHERE azi01=l_oea23
      LET l_pmlslk.pmlslk01=g_pmk01
      SELECT MAX(pmlslk02) INTO l_pmlslk.pmlslk02 FROM pmlslk_file WHERE pmlslk01=g_pmk01
      IF cl_null(l_pmlslk.pmlslk02) THEN
         LET l_pmlslk.pmlslk02=1
      ELSE
         LET l_pmlslk.pmlslk02=l_pmlslk.pmlslk02+1
      END IF
      SELECT oebslk04 INTO l_pmlslk.pmlslk04 FROM oebslk_file WHERE oebslk01 = l_tmpa01 AND oebslk03 = l_tmpa02
      LET l_pmlslk.pmlslk24=l_tmpa01
      LET l_pmlslk.pmlslk25=l_tmpa02
      SELECT ima02 INTO l_pmlslk.pmlslk041 FROM ima_file WHERE ima01=l_pmlslk.pmlslk04
      
      SELECT MIN(pml02),SUM(pml20),SUM(pml21),
             SUM(pml88),SUM(pml88t)
        INTO l_pml02,l_pmlslk.pmlslk20,l_pmlslk.pmlslk21,
             l_pmlslk.pmlslk88,l_pmlslk.pmlslk88t
        FROM pml_file,pmli_file,oeb_file,oebi_file
       WHERE pml01=pmli01
         AND pml02=pmli02
         AND oeb01=oebi01
         AND oeb03=oebi03
         AND pml24=oeb01
         AND pml25=oeb03
         AND pml01=g_pmk01
         AND pml24=l_pmlslk.pmlslk24
         AND oebislk03=l_pmlslk.pmlslk25

      IF cl_null(l_pmlslk.pmlslk20) THEN
         CONTINUE FOREACH
      END IF
      LET l_pmlslk.pmlslk88 = cl_digcut(l_pmlslk.pmlslk88,t_azi04)
      LET l_pmlslk.pmlslk88t= cl_digcut(l_pmlslk.pmlslk88t,t_azi04)

      SELECT pml07,pml08,pml30,pml31,pml33,pml34,pml35,pml44,
             pml31t,pml190,pml191,pml192,pml930,pml90,pml50
        INTO l_pmlslk.pmlslk07,l_pmlslk.pmlslk08,
             l_pmlslk.pmlslk30,l_pmlslk.pmlslk31,l_pmlslk.pmlslk33,l_pmlslk.pmlslk34,
             l_pmlslk.pmlslk35,l_pmlslk.pmlslk44,
             l_pmlslk.pmlslk31t,l_pmlslk.pmlslk190,l_pmlslk.pmlslk191,l_pmlslk.pmlslk192,
             l_pmlslk.pmlslk930,l_pmlslk.pmlslk90,l_pmlslk.pmlslk50
        FROM pml_file,pmli_file,oeb_file,oebi_file
       WHERE pml01=pmli01
         AND pml02=pmli02
         AND oeb01=oebi01
         AND oeb03=oebi03
         AND pml24=oeb01
         AND pml25=oeb03
         AND pml01=g_pmk01
         AND pml24=l_pmlslk.pmlslk24
         AND oebislk03=l_pmlslk.pmlslk25
         AND pml02=l_pml02

      IF cl_null(l_pmlslk.pmlslk30) THEN
         LET l_pmlslk.pmlslk30=0
      END IF
      IF cl_null(l_pmlslk.pmlslk31) THEN
         LET l_pmlslk.pmlslk31=0
      END IF
      IF cl_null(l_pmlslk.pmlslk31t) THEN
         LET l_pmlslk.pmlslk31t=0
      END IF
      IF cl_null(l_pmlslk.pmlslk44) THEN
         LET l_pmlslk.pmlslk44=0
      END IF
      LET l_pmlslk.pmlslkplant=g_plant
      LET l_pmlslk.pmlslklegal=g_legal
      INSERT INTO pmlslk_file VALUES(l_pmlslk.*)
      IF STATUS THEN
         CALL cl_err3("ins","pmlslk_file","","",SQLCA.sqlcode,"","ins pmlslk",1)
         EXIT FOREACH
      ELSE
         UPDATE pmli_file SET pmlislk02=l_pmlslk.pmlslk04,pmlislk03=l_pmlslk.pmlslk02
           WHERE pmli01=g_pmk01
             AND pmli02 IN (SELECT pml02 FROM pml_file,oeb_file,oebi_file
                             WHERE pml01=pmli01
                               AND pml02=pmli02
                               AND oeb01=oebi01
                               AND oeb03=oebi03
                               AND pml24=oeb01
                               AND pml25=oeb03
                               AND pml01=g_pmk01
                               AND pml24=l_pmlslk.pmlslk24
                               AND oebislk03=l_pmlslk.pmlslk25)

         IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","pmli_file","","",SQLCA.sqlcode,"","",1)
            EXIT FOREACH
         END IF
      END IF

      SELECT SUM(pmlslk20) INTO l_pmlslk.pmlslk20
       FROM pmlslk_file,pmk_file
       WHERE pmlslk24 = l_pmlslk.pmlslk24
         AND pmlslk25 = l_pmlslk.pmlslk25
         AND pmlslk01 = pmk01
         AND pmk18 <> 'X'
  #要回寫每張訂單的己拋量和請購單號
      UPDATE oebslk_file SET oebslk28 = l_pmlslk.pmlslk20
                   WHERE oebslk01 = l_pmlslk.pmlslk24
                     AND oebslk03 = l_pmlslk.pmlslk25

   END FOREACH
   LET g_success = 'Y'
END FUNCTION 

FUNCTION p420_set_pml87()
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima44  LIKE ima_file.ima44,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            g_cnt    LIKE type_file.num5,
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_tot    LIKE img_file.img10,     #計價數量
            l_factor LIKE type_file.num20_6

    SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
      FROM ima_file WHERE ima01=g_pml.pml04
    IF SQLCA.sqlcode =100 THEN
       IF g_pml.pml04 MATCHES 'MISC*' THEN
          SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF

    LET l_fac2=g_pml.pml84
    LET l_qty2=g_pml.pml85
    IF g_sma.sma115 = 'Y' THEN
       LET l_fac1=g_pml.pml81
       LET l_qty1=g_pml.pml82
    ELSE
       LET l_fac1=1
       LET l_qty1=g_pml.pml20
       CALL s_umfchk(g_pml.pml04,g_pml.pml07,l_ima44)
             RETURNING g_cnt,l_fac1
       IF g_cnt = 1 THEN
          LET l_fac1 = 1
       END IF
    END IF
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF

    IF g_sma.sma115 = 'Y' THEN
       CASE l_ima906
          WHEN '1' LET l_tot=l_qty1*l_fac1
          WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2
          WHEN '3' LET l_tot=l_qty1*l_fac1
       END CASE
    ELSE  #不使用雙單位
       LET l_tot=l_qty1*l_fac1
    END IF
    IF cl_null(l_tot) THEN LET l_tot = 0 END IF
    LET l_factor = 1
    CALL s_umfchk(g_pml.pml04,l_ima44,g_pml.pml86)
          RETURNING g_cnt,l_factor
    IF g_cnt = 1 THEN
       LET l_factor = 1
    END IF
    LET l_tot = l_tot * l_factor
    LET g_pml.pml87 = l_tot
    LET g_pml.pml87 = s_digqty(g_pml.pml87,g_pml.pml86)   #No.FUN-BB0086
END FUNCTION

#FUN-C60098---add------
