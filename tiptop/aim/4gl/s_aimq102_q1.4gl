# Prog. Version..: '5.30.06-13.03.29(00005)'     #
#
# Pattern name...: sartq700.4gl
# Descriptions...: 期間異動ACTION
# Date & Author..: #FUN-B80153 11/08/23 by pauline
# Modify.........: No:TQC-B90114 11/09/16 by pauline 利用"X"離開時下次會查不到資料
# Modify.........: No:CHI-B40048 12/02/08 By Elise 期間異動新增"供應商/部門簡稱"
# Modify.........: No:MOD-CA0218 12/11/30 By Elise 修改CHI-B40048,依tlf13判斷抓取順序
# Modify.........: No:TQC-CC0001 12/12/03 By qirl 欄位開窗查詢

DATABASE ds

GLOBALS "../../config/top.global" 

DEFINE w ui.Window                         
DEFINE n om.DomNode                        
DEFINE      g_bbb1 DYNAMIC ARRAY OF RECORD
                 tlf06    LIKE tlf_file.tlf06,
                 tlf026   LIKE tlf_file.tlf026,
                 gee05    like gee_file.gee05,   #darcy:2023/12/04 add
                 tlf036   LIKE tlf_file.tlf036,
                 msg      LIKE ze_file.ze03,     
                 tlf19    LIKE tlf_file.tlf19,
                 gem02    LIKE gem_file.gem02,   #CHI-B40048 add
                 tlf902   LIKE tlf_file.tlf902,
                 tlf903   LIKE tlf_file.tlf903,
                 tlf904   LIKE tlf_file.tlf904,
                 tlf10    LIKE tlf_file.tlf10,
                 tlf11    LIKE tlf_file.tlf11
              END RECORD
DEFINE g_wc4        STRING   
DEFINE g_chr              LIKE type_file.chr1
DEFINE g_ima01            LIKE ima_file.ima01 , 
       g_plant            LIKE tlf_file.tlf020,
       g_tlf902           LIKE tlf_file.tlf902,
       g_type             LIKE type_file.chr1               
DEFINE g_cnt              LIKE type_file.num10
DEFINE g_msg              LIKE type_file.chr1000 
DEFINE tlf902             LIKE tlf_file.tlf902
DEFINE g_wc               STRING
DEFINE g_sql              STRING

FUNCTION s_aimq102_q1(p_argv1,p_argv2, p_argv3,p_argv4)
   DEFINE p_argv1   LIKE ima_file.ima01 , 
          p_argv2   LIKE tlf_file.tlf020,
          p_argv3   LIKE tlf_file.tlf902,
          p_argv4   LIKE type_file.chr1
   DEFINE l_sql            LIKE type_file.chr1000 
   DEFINE l_exit_sw      LIKE type_file.chr1  
   DEFINE l_gem02          LIKE gem_file.gem02    #CHI-B40048 add
   DEFINE l_pmc03          LIKE pmc_file.pmc03    #CHI-B40048 add  
   DEFINE l_occ02          LIKE occ_file.occ02    #CHI-B40048 add 
   DEFINE l_tlf      RECORD
               tlf01      LIKE tlf_file.tlf01,
               tlf026      LIKE tlf_file.tlf026,
               gee05       like gee_file.gee05,    #darcy:2023/12/04 add
               tlf036      LIKE tlf_file.tlf036,
               tlf06      LIKE tlf_file.tlf06,
               tlf10      LIKE tlf_file.tlf10,
               tlf11      LIKE tlf_file.tlf11,
               tlf13      LIKE tlf_file.tlf13,
               tlf19      LIKE tlf_file.tlf19,
               tlf901      LIKE tlf_file.tlf901,
               tlf902      LIKE tlf_file.tlf902,
               tlf903      LIKE tlf_file.tlf903,
               tlf904      LIKE tlf_file.tlf904,
               tlf905      LIKE tlf_file.tlf905,
               tlf907      LIKE tlf_file.tlf907
               END RECORD
   DEFINE index            LIKE type_file.num5
   DEFINE p_row,p_col        LIKE type_file.num5 
   LET g_ima01 = NULL 
   LET g_plant = NULL 
   LET g_tlf902 = NULL 
   LET g_type = NULL

   LET g_ima01 = p_argv1
   LET g_plant= p_argv2
   LET g_tlf902 = p_argv3
   LET g_type = p_argv4
   LET p_row = 6 LET p_col = 2
   OPEN WINDOW q102_q1_w AT p_row,p_col
     WITH FORM "aim/42f/aimq10211"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 

   CALL cl_ui_locale("aimq10211")

      CALL g_bbb1.clear()
      CALL q102_wc()
 WHILE TRUE
    LET l_exit_sw = 'N'
    IF INT_FLAG THEN      
      LET INT_FLAG = 0   
    ELSE
       IF g_type = '1' THEN
          IF cl_null(g_plant) THEN 
             LET l_sql= "SELECT tlf01,tlf026,gee05,tlf036,tlf06,tlf10,tlf11,tlf13,tlf19,",
                  "       tlf901,tlf902,tlf903,tlf904,tlf905,tlf907 FROM  tlf_file",
                  " left join (select smyslip,gee05 from smy_file,gee_file",
                  " where upper(smysys) = gee01 and gee04 ='asmi300'",
                  " and gee02= smykind and gee03 ='2' ) on smyslip = substr(tlf026,0,3)",
                  " WHERE ",
                  "  tlf01='",g_ima01,"'",
                  "   AND (tlf02=50 OR tlf03=50)",
                  "   AND ",g_wc4 CLIPPED,
                  " ORDER BY tlf06"
          ELSE
             LET l_sql= "SELECT tlf01,tlf026,gee05,tlf036,tlf06,tlf10,tlf11,tlf13,tlf19,",
                  "       tlf901,tlf902,tlf903,tlf904,tlf905,tlf907 FROM  ",
                  cl_get_target_table(g_plant,'tlf_file'),
                  " left join (select smyslip,gee05 from smy_file,gee_file",
                  " where upper(smysys) = gee01 and gee04 ='asmi300'",
                  " and gee02= smykind and gee03 ='2' ) on smyslip = substr(tlf026,0,3)",
                  " WHERE ",
                  "  tlfplant='",g_plant,"'",
                  "  AND tlf01='",g_ima01,"'",
                  "   AND (tlf02=50 OR tlf03=50)",
                  "   AND ",g_wc4 CLIPPED,
                  " ORDER BY tlf06"
          END IF
          CALL g_bbb1.clear()
          LET g_cnt=1
          PREPARE q102_q1_p FROM l_sql
          DECLARE q102_q1_c CURSOR FOR q102_q1_p
          FOREACH q102_q1_c INTO l_tlf.*
             IF STATUS THEN
                CALL cl_err('for:',STATUS,1)
             EXIT FOREACH
             END IF
             LET l_tlf.tlf10 = l_tlf.tlf10 * l_tlf.tlf907
             CALL s_command (l_tlf.tlf13) RETURNING g_chr,g_msg
  
             LET g_bbb1[g_cnt].tlf06 = l_tlf.tlf06
             LET g_bbb1[g_cnt].tlf026=l_tlf.tlf026
             LET g_bbb1[g_cnt].gee05=l_tlf.gee05

             LET g_bbb1[g_cnt].tlf036=l_tlf.tlf036
             LET g_bbb1[g_cnt].msg=g_msg[1,30]
             LET g_bbb1[g_cnt].tlf19 =l_tlf.tlf19
            #MOD-CA0218---MOD---S
             IF l_tlf.tlf13 LIKE 'apm%' THEN
                LET l_pmc03 = ''
                SELECT pmc03 INTO l_pmc03 FROM pmc_file
                 WHERE pmc01 = l_tlf.tlf19
                IF cl_null(l_pmc03) THEN
                   LET l_occ02 = ''
                   SELECT occ02 INTO l_occ02 FROM occ_file
                    WHERE occ01 = l_tlf.tlf19
                   IF cl_null(l_occ02) THEN
                      LET l_gem02 = ''
                      SELECT gem02 INTO l_gem02 FROM gem_file
                       WHERE gem01 = l_tlf.tlf19
                      IF cl_null(l_gem02) THEN
                         LET g_bbb1[g_cnt].gem02 = ' '
                      ELSE
                         LET g_bbb1[g_cnt].gem02 = l_gem02
                      END IF
                   ELSE
                      LET g_bbb1[g_cnt].gem02 = l_occ02
                   END IF
                ELSE
                   LET g_bbb1[g_cnt].gem02 = l_pmc03
                END IF
             ELSE
                IF l_tlf.tlf13 LIKE 'axm%' THEN
                   LET l_occ02 = ''
                   SELECT occ02 INTO l_occ02 FROM occ_file
                    WHERE occ01 = l_tlf.tlf19
                   IF cl_null(l_occ02) THEN
                      LET l_pmc03 = ''
                      SELECT pmc03 INTO l_pmc03 FROM pmc_file
                       WHERE pmc01 = l_tlf.tlf19
                      IF cl_null(l_pmc03) THEN
                         LET l_gem02 = ''
                         SELECT gem02 INTO l_gem02 FROM gem_file
                          WHERE gem01 = l_tlf.tlf19
                         IF cl_null(l_gem02) THEN
                            LET g_bbb1[g_cnt].gem02 = ' '
                         ELSE
                            LET g_bbb1[g_cnt].gem02 = l_gem02
                         END IF
                      ELSE
                         LET g_bbb1[g_cnt].gem02 = l_pmc03
                      END IF
                   ELSE
                      LET g_bbb1[g_cnt].gem02 = l_occ02
                   END IF
                ELSE
                  #CHI-B40048---add---start---
                   LET l_gem02 = ''
                   SELECT gem02 INTO l_gem02 FROM gem_file
                    WHERE gem01 = l_tlf.tlf19
                   IF cl_null(l_gem02) THEN
                      LET l_pmc03 = ''
                      SELECT pmc03 INTO l_pmc03 FROM pmc_file
                       WHERE pmc01 = l_tlf.tlf19
                      IF cl_null(l_pmc03) THEN
                         LET l_occ02= ''                         #MOD-CA0218 add
                         SELECT occ02 INTO l_occ02 FROM occ_file
                          WHERE occ01 = l_tlf.tlf19
                         IF cl_null(l_occ02) THEN
                            LET g_bbb1[g_cnt].gem02 = ' '
                         ELSE
                            LET g_bbb1[g_cnt].gem02 = l_occ02
                         END IF
                      ELSE
                         LET g_bbb1[g_cnt].gem02 = l_pmc03
                      END IF
                   ELSE
                      LET g_bbb1[g_cnt].gem02 = l_gem02
                   END IF
                  #CHI-B40048---add---end---
                END IF
             END IF
            #MOD-CA0218---MOD---E

             LET g_bbb1[g_cnt].tlf902=l_tlf.tlf902
             LET g_bbb1[g_cnt].tlf903=l_tlf.tlf903
             LET g_bbb1[g_cnt].tlf904=l_tlf.tlf904
             LET g_bbb1[g_cnt].tlf10 =l_tlf.tlf10 USING '-----------&.&&&'
             LET g_bbb1[g_cnt].tlf11 =l_tlf.tlf11

             LET g_cnt=g_cnt+1
          END FOREACH
    END IF
 END IF 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bbb1 TO s_bbb1.*
        ON ACTION query
           CALL q102_wc()
           EXIT DISPLAY
        ON ACTION exit
           LET l_exit_sw = 'Y'
           EXIT DISPLAY

        ON ACTION cancel
           LET l_exit_sw = 'Y'
           LET INT_FLAG = 0 #TQC-B90114 add 
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
      ON ACTION exporttoexcel
         LET w = ui.Window.getCurrent()
         LET n = w.getNode()
         CALL cl_export_to_excel(n,base.TypeInfo.create(g_bbb1),'','')
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   IF l_exit_sw = 'Y' THEN
       EXIT WHILE
   END IF
 END WHILE 
   CLOSE WINDOW q102_q1_w 

END FUNCTION

FUNCTION q102_wc()
DEFINE index     LIKE type_file.num5
   OPEN WINDOW q102_iw AT 14,20
        WITH FORM "aim/42f/aimq102i"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 

    CALL cl_ui_locale("aimq102i")
    CALL cl_set_act_visible("accept,cancel", TRUE)
    LET tlf902 = g_tlf902
    DISPLAY BY NAME tlf902 
    CONSTRUCT BY NAME g_wc4 ON tlf902,tlf06
              BEFORE CONSTRUCT
                 DISPLAY BY NAME tlf902
                 CALL cl_qbe_init()
      AFTER FIELD tlf902
         LET g_tlf902 = GET_FLDBUF(tlf902)

#--------TQC-CC0001---add----star--
               ON ACTION CONTROLP
                  CASE
                     WHEN INFIELD(tlf902)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_tlf902"
                        LET g_qryparam.state = 'c'
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO tlf902
                        NEXT FIELD tlf902
                  END CASE
#--------TQC-CC0001---add----end---
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about         
         CALL cl_about()   

      ON ACTION help         
         CALL cl_show_help()  

      ON ACTION controlg      
         CALL cl_cmdask()    

      ON ACTION exit    
         ON ACTION qbe_select
           CALL cl_qbe_select()
         ON ACTION qbe_save
           CALL cl_qbe_save()
         EXIT CONSTRUCT 

   END CONSTRUCT
   CLOSE WINDOW q102_iw

END FUNCTION
#FUN-B80153
