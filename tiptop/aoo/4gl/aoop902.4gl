# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: aoop902.4gl
# Descriptions...: B2B層級整批生成作業
# Input parameter:
# Date & Author..: # 09/11/30 FUN-9B0160 By baofei
# Modify.........: No.FUN-A50102 10/07/13 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   離開MAIN時沒有cl_used(1)和cl_used(2)
# Modify.........: No:FUN-B40071 11/05/09 by jason 已傳POS否狀態調整
# Modify.........: No.FUN-B60118 11/06/22 By huangtao POS賦值為1 

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE   g_azp01a     LIKE   azp_file.azp01
DEFINE   g_azp01b     LIKE   azp_file.azp01
DEFINE   g_occ44      LIKE   occ_file.occ44
DEFINE   g_rtz04      LIKE   rtz_file.rtz04
DEFINE   g_rtz05      LIKE   rtz_file.rtz05
DEFINE   p_row,p_col  LIKE   type_file.num5
DEFINE   g_dbsa       LIKE   azp_file.azp03
DEFINE   g_dbsb       LIKE   azp_file.azp03

MAIN
 DEFINE l_flag LIKE type_file.chr1

    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
    CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211
    OPEN WINDOW p902_w AT p_row,p_col
         WITH FORM "aoo/42f/aoop902"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)

    CALL cl_opmsg('p')
    CALL cl_ui_init()

   WHILE TRUE
      LET g_success = 'Y'
      CALL p902_tm()
      IF INT_FLAG THEN EXIT WHILE END IF
      IF cl_sure(0,0) THEN
         BEGIN WORK

         CALL p902_p()
         IF g_success='Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
         END IF

         IF l_flag THEN
            CONTINUE WHILE
         ELSE
            CLOSE WINDOW p902_w
            EXIT WHILE
         END IF
      ELSE
         CONTINUE WHILE
      END IF
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN

FUNCTION p902_tm()
 DEFINE  l_n      LIKE  type_file.num5
 DEFINE  l_azw01  LIKE  azw_file.azw01
 DEFINE  l_azw07  LIKE  azw_file.azw07
  INPUT  g_azp01a,g_azp01b,g_occ44,g_rtz04,g_rtz05 FROM
    FORMONLY.azp01a,FORMONLY.azp01b,FORMONLY.occ44,FORMONLY.rtz04,FORMONLY.rtz05

      AFTER FIELD azp01a
       IF NOT cl_null(g_azp01a) THEN
          LET l_n = 0
          SELECT COUNT(*) INTO l_n FROM azp_file
           WHERE azp01 = g_azp01a

          IF l_n = 0  THEN
             CALL cl_err('','aap-025',0)
             LET g_azp01a = ''
             DISPLAY g_azp01a TO  FORMONLY.azp01a
             NEXT FIELD azp01a
          END IF
          IF NOT cl_null(g_azp01b) THEN
             IF g_azp01a = g_azp01b THEN
                CALL cl_err('','aoo-230',0)
                LET g_azp01a = ''
                DISPLAY g_azp01a TO  FORMONLY.azp01a
                NEXT FIELD azp01a
             END IF
          END IF
          LET g_plant_new = g_azp01a
          CALL s_gettrandbs()
          LET g_dbsa=g_dbs_tra 
         
       ELSE
          NEXT FIELD azp01a
       END IF

      AFTER FIELD azp01b
       IF NOT cl_null(g_azp01b) THEN
          LET l_n = 0
          SELECT COUNT(*) INTO l_n FROM azp_file
           WHERE azp01 = g_azp01b

          IF l_n = 0  THEN
             CALL cl_err('','aap-025',0)
             LET g_azp01b = ''
             DISPLAY g_azp01b TO  FORMONLY.azp01b
             NEXT FIELD azp01b
          END IF
          IF NOT cl_null(g_azp01a) THEN
             IF g_azp01a = g_azp01b THEN
                CALL cl_err('','aoo-230',0)
                LET g_azp01b = ''
                DISPLAY g_azp01b TO  FORMONLY.azp01b
                NEXT FIELD azp01b
             END IF
          END IF
          LET g_plant_new = g_azp01b                                                                                            
          CALL s_gettrandbs()                                                                                                  
          LET g_dbsb=g_dbs_tra                                                                                                 
       ELSE
          NEXT FIELD azp01b
       END IF

      AFTER FIELD occ44
       IF NOT cl_null(g_occ44) THEN
          CALL p902_occ44()
          IF  NOT cl_null(g_errno)  THEN
             CALL cl_err('',g_errno,0)
             NEXT FIELD occ44
          END IF
       END IF

      AFTER FIELD rtz04
         IF g_rtz04 IS NOT NULL THEN
            CALL p902_rtz04()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD rtz04
            END IF
         END IF

      AFTER FIELD rtz05
         IF g_rtz05 IS NOT NULL THEN
            CALL p902_rtz05()
            IF NOT cl_null(g_errno)  THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD rtz05
            END IF
         END IF


      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(azp01a)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_azp01_2"
                CALL cl_create_qry() RETURNING g_azp01a
                DISPLAY g_azp01a TO FORMONLY.azp01a
                NEXT FIELD azp01a
           WHEN INFIELD(azp01b)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_azp01_2"
                CALL cl_create_qry() RETURNING g_azp01b
                DISPLAY g_azp01b TO FORMONLY.azp01b
                NEXT FIELD azp01b
           WHEN INFIELD(occ44)
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_oah'
                LET g_qryparam.default1 = g_occ44
                LET g_qryparam.plant = g_azp01b
                CALL cl_create_qry() RETURNING g_occ44
                DISPLAY  g_occ44 TO FORMONLY.occ44
                NEXT FIELD occ44
           WHEN INFIELD(rtz04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_rtd01"
              LET g_qryparam.default1 = g_rtz04
              CALL cl_create_qry() RETURNING g_rtz04
              DISPLAY  g_rtz04 TO  FORMONLY.rtz04
              CALL p902_rtz04()
              NEXT FIELD rtz04
           WHEN INFIELD(rtz05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_rtf"
              LET g_qryparam.default1 = g_rtz05
              CALL cl_create_qry() RETURNING g_rtz05
              DISPLAY  g_rtz05 TO FORMONLY.rtz05
              CALL p902_rtz05()
              NEXT FIELD rtz05

         END CASE
      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
                            RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()
      ON ACTION close
         EXIT INPUT     
  END INPUT

END FUNCTION

FUNCTION p902_p()
 DEFINE   l_cnt    LIKE   type_file.num5
 DEFINE   l_n      LIKE   type_file.num5
 DEFINE   l_azt    RECORD LIKE  azt_file.*
 DEFINE   l_azw    RECORD LIKE  azw_file.*
 DEFINE   l_azp03  LIKE   azp_file.azp03
 DEFINE   l_azp02  LIKE   azp_file.azp02
 DEFINE   l_occ    RECORD LIKE  occ_file.*
 DEFINE   l_pmc    RECORD LIKE  pmc_file.*
 DEFINE   b_pmc    RECORD LIKE  pmc_file.*
 DEFINE   l_dbs    LIKE   type_file.chr20
 DEFINE   b_dbs    LIKE   type_file.chr20
 DEFINE   l_sql    STRING
 DEFINE   l_imd    RECORD LIKE  imd_file.*
 DEFINE   l_azw07  LIKE   azw_file.azw07
 DEFINE   l_xsa11  LIKE	  xsa_file.xsa11 
 DEFINE   l_xsa12  LIKE   xsa_file.xsa12

#  INITIALIZE l_azt.* TO NULL
#  LET l_cnt = 0
#  SELECT COUNT(*) INTO l_cnt  FROM azt_file  WHERE azt01 = '#'
#  IF l_cnt =0 THEN
#     LET l_azt.azt01 = '#'
#     LET l_azt.azt02 = 'B2B'
#     LET l_azt.aztacti = 'Y'
#     INSERT INTO azt_file  VALUES (l_azt.*)
#     IF STATUS OR SQLCA.SQLCODE THEN
#        CALL cl_err3("ins","azt_file","","",SQLCA.sqlcode,"","",1)
#        LET g_success = 'N'
#        RETURN
#     END IF
#  END IF

#  INITIALIZE l_azw.* TO NULL
#  LET  l_azw.azw01 = g_azp01a
#  LET  l_azw.azw07 = g_azp01b
#  LET  l_azw.azw03 = 'std'
#  LET  l_azw.azw04 = '3'
#  LET  l_azp03 = ''
#  SELECT azp03 INTO l_azp03 FROM azp_file
#   WHERE azp01 = g_azp01a
#  LET  l_azw.azw05 = l_azp03
#  LET  l_azw.azw06 = l_azp03
#  LET  l_azw.azw02 = '#'
#  LET  l_azw.azwacti = 'Y'
#  INSERT INTO azw_file  VALUES  (l_azw.*)
#  IF STATUS OR SQLCA.SQLCODE THEN
#     CALL cl_err3("ins","azw_file","","",SQLCA.sqlcode,"","",1)
#     LET g_success = 'N'
#     RETURN
#  END IF

   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw01 = g_azp01a
   IF l_cnt = 0 THEN 
      CALL cl_err('','aoo-169',1)
      LET g_success = 'N' 
      RETURN
   ELSE
      UPDATE  azw_file SET azw07 = g_azp01b WHERE azw01 = g_azp01a
      IF STATUS OR SQLCA.SQLCODE THEN                                                                                                  
         CALL cl_err3("upd","azw_file","","",SQLCA.sqlcode,"","",1)                                                                    
         LET g_success = 'N'                                                                                                           
         RETURN                                                                                                                        
      END IF    
   END IF 

   INITIALIZE l_occ.* TO NULL
   LET l_xsa11= ''
   LET l_xsa12 = ''
   LET l_occ.occ01 = g_azp01a
   SELECT azw08 INTO l_occ.occ02 FROM azw_file 
    WHERE azw01 = l_occ.occ01
   LET l_occ.occ44 = g_occ44
   LET l_occ.occ71 = '1'
   LET l_occ.occpos = '1' #FUN-B40071
   LET l_occ.occ73 = 'N'
   LET l_occ.occ1004 ='0'
   LET l_occ.occ1027 ='N'
   LET l_occ.occ05   ='1'
   LET l_occ.occ06   ='1'
   LET l_occ.occ07   = l_occ.occ01
   LET l_occ.occ09   = l_occ.occ01 
   LET l_occ.occ08   ='1'
   LET l_occ.occ62   ='N'
   LET l_occ.occ34   =' '
   LET l_occ.occ66   =' '
   LET l_occ.occ37   ='N'
   LET l_occ.occ40   ='Y'
   LET l_occ.occ56   ='N'
   LET l_occ.occ57   ='N'
   LET l_occ.occ63   =0
   LET l_occ.occ64   =0
   LET l_occ.occ31   ='N'
   LET l_occ.occ65   ='N'
   LET l_occ.occ72   = 0
   LET l_occ.occuser = g_user
   LET l_occ.occoriu = g_user
   LET l_occ.occorig = g_grup
   LET l_occ.occgrup = g_grup
   LET l_occ.occdate = g_today
   LET l_occ.occacti = 'P'
   LET l_occ.occ246  = g_plant
   LET l_dbs = ''
   LET g_plant_new = g_azp01b
   CALL s_gettrandbs()
   LET l_dbs=g_dbs_tra
   #LET l_sql = " SELECT xsa11,xsa12 FROM ",s_dbstring(l_dbs CLIPPED),"xsa_file  WHERE xsa00 = '0' "
   LET l_sql = " SELECT xsa11,xsa12 FROM ",cl_get_target_table(g_azp01b,'xsa_file'), #FUN-A50102
               "  WHERE xsa00 = '0' "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_azp01b) RETURNING l_sql #FUN-A50102            
   PREPARE xsa_pre FROM l_sql
   EXECUTE xsa_pre INTO l_xsa11,l_xsa12
   LET l_occ.occ41 = l_xsa12
   LET l_occ.occ42 = l_xsa11
   #LET l_sql = " INSERT INTO ",s_dbstring(l_dbs CLIPPED),"occ_file VALUES (?,?,?,?,?, ?,?,?,?,?,",
   LET l_sql = " INSERT INTO ",cl_get_target_table(g_azp01b,'occ_file'), #FUN-A50102
               " VALUES (?,?,?,?,?, ?,?,?,?,?,",
               " ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               " ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               " ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               " ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?) "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_azp01b) RETURNING l_sql #FUN-A50102                  
   PREPARE occ_pre FROM l_sql
   EXECUTE occ_pre  USING  l_occ.*
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL cl_err3("ins","occ_file","","",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF

   INITIALIZE l_pmc.* TO NULL
   LET l_xsa11= ''                                                                                                                  
   LET l_xsa12 = ''
   LET l_pmc.pmc01 = g_azp01a
   SELECT azw08 INTO l_pmc.pmc03  FROM azw_file
    WHERE azw01 = l_pmc.pmc01
   LET l_pmc.pmc04 = l_pmc.pmc01
   LET l_pmc.pmc901 = l_pmc.pmc01
   LET l_pmc.pmc05 = 'Y'
   LET l_pmc.pmc14 = '1' 
   LET l_pmc.pmc23 = 'Y'
   LET l_pmc.pmc27 = '1'
   LET l_pmc.pmc30 = '3'
   LET l_pmc.pmc45 =  0
   LET l_pmc.pmc46 =  0
   LET l_pmc.pmc48 =  'Y'
   LET l_pmc.pmc912 = 'N'
   LET l_pmc.pmc902 = '0'
   LET l_pmc.pmc903 = 'N'
   LET l_pmc.pmc911 = g_lang
   LET l_pmc.pmc1920 = g_plant
   LET l_pmc.pmc913 = 'N'
   LET l_pmc.pmc914 = 'N'
   LET l_pmc.pmcuser = g_user
   LET l_pmc.pmcgrup = g_grup
   LET l_pmc.pmcoriu = g_user
   LET l_pmc.pmcorig = g_grup
   LET b_dbs = ''
   LET g_plant_new = g_azp01a
   CALL s_gettrandbs()
   LET b_dbs=g_dbs_tra
   #LET l_sql = " SELECT xsa11,xsa12 FROM ",s_dbstring(b_dbs CLIPPED),"xsa_file  WHERE xsa00 = '0' " 
   LET l_sql = " SELECT xsa11,xsa12 FROM ",cl_get_target_table(g_azp01a,'xsa_file'), #FUN-A50102
               "  WHERE xsa00 = '0' " 
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_azp01a) RETURNING l_sql #FUN-A50102         
   PREPARE xsa_prea FROM l_sql                                                                                                       
   EXECUTE xsa_prea INTO l_xsa11,l_xsa12 
   LET l_pmc.pmc47 = l_xsa12
   LET l_pmc.pmc22 = l_xsa11
   #LET l_sql = " INSERT INTO ",s_dbstring(b_dbs CLIPPED),"pmc_file VALUES (?,?,?,?,?, ?,?,?,?,?,",
   LET l_sql = " INSERT INTO ",cl_get_target_table(g_azp01a,'pmc_file'), #FUN-A50102
               " VALUES (?,?,?,?,?, ?,?,?,?,?,",
               " ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               " ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               " ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?) "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_azp01a) RETURNING l_sql #FUN-A50102             
   PREPARE pmc_pre1 FROM l_sql
   EXECUTE pmc_pre1 USING l_pmc.*
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL cl_err3("ins","pmc_file","","",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF

   INITIALIZE b_pmc.* TO NULL
   LET l_azw07 = ''
   SELECT azw07 INTO l_azw07  FROM azw_file WHERE azw01 = g_azp01b
   IF cl_null(l_azw07) THEN
     LET l_n = 0
     #LET l_sql = " SELECT COUNT(*) FROM ",s_dbstring(b_dbs CLIPPED),"pmc_file ",
     LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(g_azp01a,'pmc_file'), #FUN-A50102
                 " WHERE pmc01 = '",g_azp01b,"'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
     CALL cl_parse_qry_sql(l_sql,g_azp01a) RETURNING l_sql #FUN-A50102            
     PREPARE pmc_pre3 FROM l_sql   
     DECLARE pmc_count CURSOR FOR pmc_pre3         
     OPEN  pmc_count
     FETCH pmc_count INTO l_n
     IF l_n = 0 THEN
       LET l_xsa11 = ''
       LET l_xsa12 = ''
       LET b_pmc.pmc01 = g_azp01b
       SELECT azw08 INTO b_pmc.pmc03 FROM azw_file
        WHERE azw01 = b_pmc.pmc01
       LET b_pmc.pmc04 = b_pmc.pmc01
       LET b_pmc.pmc901 = b_pmc.pmc01
       LET b_pmc.pmc05 = 'Y'
       LET b_pmc.pmc14 = '1' 
       LET b_pmc.pmc23 = 'Y'
       LET b_pmc.pmc27 = '1'
       LET b_pmc.pmc30 = '3'
       LET b_pmc.pmc45 =  0
       LET b_pmc.pmc46 =  0
       LET b_pmc.pmc48 =  'Y'
       LET b_pmc.pmc912 = 'N'
       LET b_pmc.pmc902 = '0'
       LET b_pmc.pmc903 = 'N'
       LET b_pmc.pmc911 = g_lang
       LET b_pmc.pmc1920 = g_plant
       LET b_pmc.pmc913 = 'N'
       LET b_pmc.pmc914 = 'N'
       LET b_pmc.pmcuser = g_user
       LET b_pmc.pmcgrup = g_grup
       LET b_pmc.pmcoriu = g_user
       LET b_pmc.pmcorig = g_grup
       #LET l_sql = " SELECT xsa11,xsa12 FROM ",s_dbstring(b_dbs CLIPPED),"xsa_file  WHERE xsa00 = '0' " 
       LET l_sql = " SELECT xsa11,xsa12 FROM ",cl_get_target_table(g_azp01a,'xsa_file'), #FUN-A50102
                   "  WHERE xsa00 = '0' " 
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
       CALL cl_parse_qry_sql(l_sql,g_azp01a) RETURNING l_sql #FUN-A50102       
       PREPARE xsa_preb FROM l_sql                                                                                                      
       EXECUTE xsa_preb INTO l_xsa11,l_xsa12                                                                                            
       LET b_pmc.pmc47 = l_xsa12                                                                                                        
       LET b_pmc.pmc22 = l_xsa11  
       #LET l_sql = " INSERT INTO ",s_dbstring(b_dbs CLIPPED),"pmc_file VALUES (?,?,?,?,?, ?,?,?,?,?,",
       LET l_sql = " INSERT INTO ",cl_get_target_table(g_azp01a,'pmc_file'), #FUN-A50102
                   " VALUES (?,?,?,?,?, ?,?,?,?,?,",
                   " ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                   " ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                   " ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?) "
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
       CALL cl_parse_qry_sql(l_sql,g_azp01a) RETURNING l_sql #FUN-A50102              
       PREPARE pmc_pre2 FROM l_sql
       EXECUTE pmc_pre2 USING b_pmc.*
       IF STATUS OR SQLCA.SQLCODE THEN
          CALL cl_err3("ins","pmc_file","","",SQLCA.sqlcode,"","",1)
          LET g_success = 'N'
          RETURN
       END IF
     END IF 
     CLOSE pmc_count
   END IF

   INITIALIZE l_imd.* TO NULL
   LET l_imd.imd01 = g_azp01a
   SELECT azp02 INTO l_azp02 FROM azp_file
    WHERE azp01 = g_azp01a
   LET l_imd.imd02 = l_azp02
   LET l_imd.imd20 = g_azp01a
   LET l_imd.imd10 = 'S'
   LET l_imd.imd11 = 'Y'
   LET l_imd.imd12 = 'Y'
   LET l_imd.imd13 = 'N'
   LET l_imd.imd14 = 0
   LET l_imd.imd15 = 0
   LET l_imd.imdacti = 'Y'
   LET l_imd.imd17 = 'N'
   LET l_imd.imd18 = 0
   LET l_imd.imd19 = 'N'
#  LET l_imd.imdpos = 'N'           #FUN-B60118  mark
   LET l_imd.imdpos = '1'           #FUN-B60118
   LET l_imd.imduser = g_user
   LET l_imd.imdgrup = g_grup
   LET l_imd.imdoriu = g_user
   LET l_imd.imdorig = g_grup

   #LET l_sql = " INSERT INTO ",s_dbstring(b_dbs CLIPPED)," imd_file  VALUES(?,?,?,?,?, ?,?,?,?,? ,",
   LET l_sql = " INSERT INTO ",cl_get_target_table(g_azp01a,'imd_file'), #FUN-A50102
               "   VALUES(?,?,?,?,?, ?,?,?,?,? ,",
               " ?,?,?,?,?, ?,?,?,?,? ,?,?,?,?,?, ?,?,?,?,? ,?) "  
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_azp01a) RETURNING l_sql #FUN-A50102              
   PREPARE imd_pre FROM l_sql
   EXECUTE imd_pre USING l_imd.*
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL cl_err3("ins","imd_file","","",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
   LET l_cnt = 0
   SELECT count(*) INTO l_cnt FROM rtz_file WHERE rtz01 = g_azp01a
   IF l_cnt = 0 THEN 
      CALL cl_err('','aoo-170',1)
      LET g_success = 'N'
      RETURN
   ELSE
      UPDATE  rtz_file SET rtz04 = g_rtz04,rtz05 = g_rtz05  WHERE rtz01 = g_azp01a
      IF STATUS OR SQLCA.SQLCODE THEN                                                                                                  
         CALL cl_err3("upd","rtz_file","","",SQLCA.sqlcode,"","",1)                                                                    
         LET g_success = 'N'                                                                                                           
         RETURN                                                                                                                        
      END IF       
   END IF
END FUNCTION

FUNCTION p902_occ44()
 DEFINE    l_sql    STRING
 DEFINE    l_n      LIKE  type_file.num5

   LET  g_errno = ' '
   #LET l_sql =" SELECT COUNT(*) FROM ",s_dbstring(g_dbsb CLIPPED),"oah_file  ",
   LET l_sql =" SELECT COUNT(*) FROM ",cl_get_target_table(g_azp01b,'oah_file'), #FUN-A50102
              " WHERE oah01 = '",g_occ44,"'  "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_azp01b) RETURNING l_sql #FUN-A50102            
   PREPARE oah_pre FROM l_sql 
   EXECUTE oah_pre INTO l_n
   IF l_n = 0 THEN
      LET g_errno = 'mfg4101'
      RETURN
   END IF   
END FUNCTION 

FUNCTION p902_rtz04()
DEFINE p_cmd           LIKE type_file.chr1000,
       l_rtdacti       LIKE rtd_file.rtdacti,
       l_rtdconf       LIKE rtd_file.rtdconf,
       l_rtd02         LIKE rtd_file.rtd02
    LET g_errno = ' '
    SELECT rtd02,rtdacti,rtdconf INTO l_rtd02,l_rtdacti,l_rtdconf
        FROM rtd_file
      WHERE rtd01 = g_rtz04

    CASE
        WHEN SQLCA.SQLCODE = 100
                            LET g_errno = 'atm-341'
                            LET l_rtd02 = NULL
         WHEN l_rtdacti='N' LET g_errno = '9028'
                            LET l_rtd02 = NULL
      WHEN  l_rtdconf = 'N' LET g_errno = '9029'
                            LET l_rtd02 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                       
    END CASE

END FUNCTION

FUNCTION p902_rtz05()
DEFINE p_cmd           LIKE type_file.chr1000,
       l_rtfacti       LIKE rtf_file.rtfacti,
       l_rtfconf       LIKE rtf_file.rtfconf,
       l_rtf02         LIKE rtf_file.rtf02

    LET g_errno = ' '
    SELECT rtf02,rtfacti,rtfconf INTO l_rtf02,l_rtfacti,l_rtfconf
      FROM rtf_file
     WHERE rtf01 = g_rtz05

    CASE
        WHEN SQLCA.SQLCODE = 100
                            LET g_errno = 'atm-342'
                            LET l_rtf02 = NULL
         WHEN l_rtfacti='N' LET g_errno = '9028'
                            LET l_rtf02 = NULL
        WHEN l_rtfconf ='N' LET g_errno = '9029'
                            LET l_rtf02 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                        
    END CASE

END FUNCTION
#FUN-9B0160---End
