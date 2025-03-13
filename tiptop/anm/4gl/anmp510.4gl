# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: anmp510.4gl
# Descriptions...: 退款支票整批生成作業
# Date & Author..: 09/06/25 By dongbg(FUN-960141 GP5.2)
# Modify.........: No.FUN-980005 09/08/19 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990031 09/10/13 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下
# Modify.........: No.FUN-9A0093 09/11/04 By lutingting營運中心欄位拿掉 
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:FUN-A40054 10/04/22 By shiwuying SQL错误
# Modify.........: No:FUN-A40076 10/07/02 By xiaofeizhu 更改ooa37的默認值，如果為Y改為2，N改為1 
# Modify.........: No:FUN-B30088 11/03/28 By zhangweib 更改拋轉成功後的彈窗為anmp500_1
#                                                      只需要抓取oob04 = 'D'的資料即可 所以去掉 g_cnt2及對應的數據
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-C90122 12/10/16 By wangrr 已沖金額nmd55=nmd04
# Modify.........: No.TQC-DA0031 13/10/23 By yangxf “拋轉憑證號”，“退款單號”，“部門編號”，“人員編號”，“退款客戶”，“銀行編號”，“幣種”欄位添加开窗

IMPORT os   #No.FUN-9C0009
DATABASE ds
 
GLOBALS "../../config/top.global"
#模組變數(Module Variables)
    DEFINE l_ac,l_sl             LIKE type_file.num5
    DEFINE g_wc,g_sql  	         string               
    #DEFINE plant  	         ARRAY[10] OF LIKE nmd_file.nmd34   #FUN-9A0093 
    DEFINE g_cnt2                LIKE type_file.num5  
    DEFINE g_tot,g_tot2          LIKE nmd_file.nmd04
    DEFINE g_dept                LIKE type_file.chr20   
    DEFINE g_start_no,g_end_no   LIKE nmd_file.nmd01
    DEFINE g_start_no2,g_end_no2 LIKE nmd_file.nmd01
    DEFINE g_nmd07               LIKE nmd_file.nmd07   
    DEFINE tr_type1              LIKE nmz_file.nmz51  
    DEFINE tr_type2              LIKE nmz_file.nmz51    
    DEFINE g_buf                 LIKE type_file.chr1000 
    DEFINE g_cnt                 LIKE type_file.num5   
    DEFINE z1,z2,z3,z4,z5        LIKE gem_file.gem01   
    DEFINE p_row,p_col           LIKE type_file.num5   
    DEFINE g_rec_b               LIKE type_file.num10   
 
    DEFINE g_chr                 LIKE type_file.chr1  
    DEFINE g_flag                LIKE type_file.chr1  
    DEFINE g_i                   LIKE type_file.num5    
    DEFINE g_msg                 LIKE type_file.chr1000 
    DEFINE i                     LIKE type_file.num5   
    DEFINE j                     LIKE type_file.num5  
    DEFINE l_flag                LIKE type_file.chr1, 
           g_change_lang         LIKE type_file.chr1,   
           ls_date               STRING
 
MAIN
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc     = ARG_VAL(1)
  #FUN-9A0093--mod--str-
  #LET plant[1] = ARG_VAL(2)
  #LET plant[2] = ARG_VAL(3)
  #LET plant[3] = ARG_VAL(4)
  #LET plant[4] = ARG_VAL(5)
  #LET plant[5] = ARG_VAL(6)
  #LET plant[6] = ARG_VAL(7)
  #LET plant[7] = ARG_VAL(8)
  #LET plant[8] = ARG_VAL(9)
  #LET plant[9] = ARG_VAL(10)
  #LET plant[10]= ARG_VAL(11)
  #LET tr_type1 = ARG_VAL(12)
  #LET ls_date  = ARG_VAL(13)
  #LET g_nmd07  = cl_batch_bg_date_convert(ls_date)
  #LET z1       = ARG_VAL(14)
  #LET z2       = ARG_VAL(15)
  #LET z3       = ARG_VAL(16)
  #LET z4       = ARG_VAL(17)
  #LET z5       = ARG_VAL(18)
  #LET g_bgjob  = ARG_VAL(19)                 #背景作業
  LET tr_type1 = ARG_VAL(2)
  LET ls_date  = ARG_VAL(3)
  LET g_nmd07  = cl_batch_bg_date_convert(ls_date)
  LET z1       = ARG_VAL(4)
  LET z2       = ARG_VAL(5)
  LET z3       = ARG_VAL(6)
  LET z4       = ARG_VAL(7)
  LET z5       = ARG_VAL(8)
  LET g_bgjob  = ARG_VAL(9)                 #背景作業
  #FUN-9A0093--mod--end
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET g_success = 'Y'
   WHILE TRUE
      LET g_cnt = 0  LET g_tot = 0 LET g_start_no = ' ' LET g_end_no =' '
      LET g_cnt2= 0  LET g_tot2= 0 LET g_start_no2= ' ' LET g_end_no2=' '
      IF g_bgjob = "N" THEN
         CALL p510()
         IF cl_sure(18,20) THEN
            BEGIN WORK
            LET g_success = 'Y'
            CALL s_showmsg_init()  
            CALL p510_p()
            CALL s_showmsg()        
            IF g_success = 'Y' THEN
               COMMIT WORK
               IF g_cnt > 0 OR g_cnt2 > 0 THEN
#                 OPEN WINDOW p510_w2 AT 5,12 WITH FORM "anm/42f/anmp510"      #No.FUN-B30088 Mark
                  OPEN WINDOW p510_w2 AT 5,12 WITH FORM "anm/42f/anmp510_1"    #No.FUN-B30088 Add
                       ATTRIBUTE (STYLE = g_win_style)
#                 CALL cl_ui_locale("anmp510")                                 #No.FUN-B30088 Mark
                  CALL cl_ui_locale("anmp510_1")                               #No.FUN-B30088 Add 
                  DISPLAY BY NAME g_cnt ,g_tot ,g_start_no ,g_end_no
#                 DISPLAY BY NAME g_cnt2,g_tot2,g_start_no2,g_end_no2          #No.FUN-B30088 Mark
               END IF
               CALL cl_end2(1) RETURNING l_flag
               IF g_cnt > 0 OR g_cnt2 > 0 THEN
                  CLOSE WINDOW p510_w2
               END IF
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
                 CONTINUE WHILE
            ELSE
                 CLOSE WINDOW p510_w
                 EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL s_showmsg_init()  
         CALL p510_p()
         CALL s_showmsg()      
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
 
END MAIN
 
FUNCTION p510()
   DEFINE   l_name    LIKE type_file.chr20   
   DEFINE   l_cmd     LIKE type_file.chr1000 
   DEFINE   l_seq     LIKE type_file.num5    
   DEFINE   l_gem02   LIKE gem_file.gem02
   DEFINE   l_nml02   LIKE nml_file.nml02
   DEFINE   l_nmo02   LIKE nmo_file.nmo02,
            l_allow_insert        LIKE type_file.num5,    #可新增否  
            l_allow_delete        LIKE type_file.num5     #可刪除否 
   DEFINE   li_result             LIKE type_file.num5     
   DEFINE   lc_cmd                LIKE type_file.chr1000  
 
   OPEN WINDOW p510_w AT p_row,p_col WITH FORM "anm/42f/anmp510"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
 
     WHILE TRUE
       LET g_cnt = 0  LET g_tot = 0 LET g_start_no = ' ' LET g_end_no =' '
       LET g_cnt2= 0  LET g_tot2= 0 LET g_start_no2= ' ' LET g_end_no2=' '
 
       CLEAR FORM
       CONSTRUCT BY NAME g_wc ON ooa33, ooa02, ooa01, ooa15, ooa14, ooa03, oob17,ooa23
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
#TQC-DA0031 add begin ---
      ON ACTION CONTROLP
         CASE 
           WHEN INFIELD(ooa33)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ooa33"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ooa33
           WHEN INFIELD(ooa01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ooa01"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ooa01
           WHEN INFIELD(ooa15)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ooa15"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ooa15
           WHEN INFIELD(ooa14)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ooa14"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret 
              DISPLAY g_qryparam.multiret TO ooa14
           WHEN INFIELD(ooa03)    
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ooa03"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ooa03
           WHEN INFIELD(oob17)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_oob17"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oob17
           WHEN INFIELD(ooa23)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ooa23"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ooa23
         END CASE
#TQC-DA0031 add end -----
 
      ON ACTION about      
         CALL cl_about()  
 
      ON ACTION help        
         CALL cl_show_help() 
 
      ON ACTION controlg    
         CALL cl_cmdask()
 
        
         ON ACTION locale                 
           LET g_change_lang = TRUE         
           EXIT CONSTRUCT
        
         ON ACTION exit             
            LET INT_FLAG = 1
            EXIT CONSTRUCT
        
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ooauser', 'ooagrup') #FUN-980030
        
       IF g_change_lang THEN
          LET g_change_lang = FALSE
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()             
          CONTINUE WHILE
       END IF
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          CLOSE WINDOW p510_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM
       END IF
 
      #FUN-9A0093--mark--str--
      #LET plant[1] = g_plant
 
      #LET g_rec_b = 1
 
      #DISPLAY ARRAY plant TO s_plant.* ATTRIBUTE(COUNT=g_rec_b)
      #  BEFORE DISPLAY
      #    EXIT DISPLAY
      #END DISPLAY
 
      #LET l_allow_insert = TRUE
      #LET l_allow_delete = TRUE
 
      #INPUT ARRAY plant WITHOUT DEFAULTS FROM s_plant.* 
      #      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
      #      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      #   AFTER FIELD plant
      #      LET l_ac = ARR_CURR()
      #      IF NOT cl_null(plant[l_ac]) AND plant[l_ac] != g_plant THEN
      #         IF NOT s_chknplt(plant[l_ac],'AAP','AAP') THEN 
      #            CALL cl_err(plant[l_ac],'anm-025',0)
      #            NEXT FIELD plant
      #         END IF
      #      END IF
      #      #FUN-990031--mod--str--    營運中心要控制在當前法人下 
      #      IF NOT cl_null(plant[l_ac]) THEN
      #         SELECT * FROM azw_file WHERE azw01 = plant[l_ac] AND azw02 = g_legal                                                        
      #         IF STATUS THEN                                                                                                          
      #            CALL cl_err3("sel","azw_file",plant[l_ac],"","agl-171","","",1)                                                          
      #            NEXT FIELD plant                                                                                                   
      #         END IF   
      #      END IF 
      #      #FUN-990031--mod--end
 
      #   ON IDLE g_idle_seconds
      #      CALL cl_on_idle()
      #      CONTINUE INPUT
 
      #ON ACTION about       
      #   CALL cl_about()      
 
      #ON ACTION help        
      #   CALL cl_show_help()  
 
      #ON ACTION controlg     
      #   CALL cl_cmdask()   
 
       
      # END INPUT
 
      # IF INT_FLAG THEN
      #    LET INT_FLAG = 0
      #    CLOSE WINDOW p510_w
      #    EXIT PROGRAM
      # END IF
      #FUN-9A0093--mod--end
    
       LET tr_type1 = g_nmz.nmz51
       LET g_nmd07  = null
       LET z4       = g_nmz.nmz55
       LET g_bgjob = "N"    
       DISPLAY BY NAME tr_type1,g_nmd07,z1,z2,z3,z4
 
       INPUT BY NAME tr_type1,g_nmd07,z1,z2,z3,z4,g_bgjob WITHOUT DEFAULTS 
      
          AFTER FIELD tr_type1
             IF NOT cl_null(tr_type1) THEN 
              CALL s_check_no("anm",tr_type1,"","1","","","")
                 RETURNING li_result,tr_type1
             LET tr_type1= s_get_doc_no(tr_type1)                    
              DISPLAY BY NAME tr_type1
               IF (NOT li_result) THEN
                 NEXT FIELD tr_type1
               END IF
             END IF
 
 
          AFTER FIELD z1 
             IF NOT cl_null(z1) THEN 
                SELECT nmo02 INTO l_nmo02 FROM nmo_file 
                 WHERE nmo01 = z1 AND nmoacti = 'Y'
                IF SQLCA.sqlcode THEN 
                   LET l_nmo02 = ' '
                   CALL cl_err3("sel","nmo_file",z1,"","anm-086","","",0)
                   NEXT FIELD z1 
                END IF
                DISPLAY l_nmo02 TO FORMONLY.nmo02 
             END IF
      
          AFTER FIELD z2 
             IF NOT cl_null(z2) THEN 
                SELECT nmo02 INTO l_nmo02 FROM nmo_file 
                 WHERE nmo01 = z2 AND nmoacti = 'Y'
                IF SQLCA.sqlcode THEN 
                   LET l_nmo02 = ' '
                   CALL cl_err3("sel","nmo_file",z2,"","anm-086","","",0) 
                   NEXT FIELD z2 
                END IF
                DISPLAY l_nmo02 TO FORMONLY.nmo02_2 
             END IF
      
          AFTER FIELD z3 
             IF not cl_null(z3) THEN   
                SELECT gem02 INTO l_gem02 FROM gem_file 
                 WHERE gem01 = z3 AND gem05='Y' AND gemacti = 'Y'
                IF SQLCA.sqlcode THEN 
                   LET l_gem02 = ' '
                   CALL cl_err3("sel","gem_file",z3,"","anm-071","","",0) 
                   NEXT FIELD z3 
                END IF
                DISPLAY l_gem02 TO FORMONLY.gem02 
             END IF
      
          AFTER FIELD z4 
             IF not cl_null(z4) THEN 
                SELECT nml02 INTO l_nml02 FROM nml_file 
                 WHERE nml01 = z4 AND nmlacti = 'Y'
                IF SQLCA.sqlcode THEN 
                   LET l_gem02 = ' '
                   CALL cl_err3("sel","nml_file",z4,"","anm-140","","",0) 
                   NEXT FIELD z4 
                END IF
                DISPLAY l_nml02 TO FORMONLY.nml02 
             END IF
      
              
           ON ACTION CONTROLP
              CASE
                 WHEN INFIELD(tr_type1) #查詢單據
                    #CALL q_nmy(FALSE,FALSE,tr_type1,'1',g_sys) 
                    CALL q_nmy(FALSE,FALSE,tr_type1,'1','ANM') 
                    RETURNING tr_type1 
                    DISPLAY BY NAME tr_type1 
                    NEXT FIELD tr_type1
                 WHEN INFIELD(z3) 
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.default1 = z3
                    CALL cl_create_qry() RETURNING z3
                    DISPLAY BY NAME z3 
                    NEXT FIELD z3    
                 WHEN INFIELD(z1)   
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_nmo01"
                    LET g_qryparam.default1 = z1
                    CALL cl_create_qry() RETURNING z1
                    DISPLAY BY NAME z1 
                    NEXT FIELD z1 
                 WHEN INFIELD(z2)    
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_nmo01"
                    LET g_qryparam.default1 = z2
                    CALL cl_create_qry() RETURNING z2
                    DISPLAY BY NAME z2
                    NEXT FIELD z2   
                 WHEN INFIELD(z4) #變動碼
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_nml"
                    LET g_qryparam.default1 = z4
                    CALL cl_create_qry() RETURNING z4
                    DISPLAY BY NAME z4 
                    NEXT FIELD z4   
                 OTHERWISE EXIT CASE
                END CASE
      
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
 
 
          ON ACTION exit              #加離開功能genero
             LET INT_FLAG = 1
             EXIT INPUT     
 
         ON ACTION locale                    #genero
            LET g_change_lang = TRUE  
            EXIT INPUT
       
       END INPUT
 
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          CLOSE WINDOW p510_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM
       END IF
       IF g_bgjob = "Y" THEN
          SELECT zz08 INTO lc_cmd FROM zz_file
           WHERE zz01 = "anmp510"
          IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
              CALL cl_err('anmp510','9031',1)   
          ELSE
             LET g_wc=cl_replace_str(g_wc, "'", "\"")
             LET lc_cmd = lc_cmd CLIPPED,
                          " '",g_wc CLIPPED ,"'",
                         #FUN-9A0093--mark--str--
                         #" '",plant[1] CLIPPED ,"'",
                         #" '",plant[2] CLIPPED ,"'",
                         #" '",plant[3] CLIPPED ,"'",
                         #" '",plant[4] CLIPPED ,"'",
                         #" '",plant[5] CLIPPED ,"'",
                         #" '",plant[6] CLIPPED ,"'",
                         #" '",plant[7] CLIPPED ,"'",
                         #" '",plant[8] CLIPPED ,"'",
                         #" '",plant[9] CLIPPED ,"'",
                         #" '",plant[10] CLIPPED ,"'",
                         #FUN-9A0093--mark--end
                          " '",tr_type1 CLIPPED ,"'",
                          " '",g_nmd07 CLIPPED , "'",
                          " '",z1 CLIPPED , "'",
                          " '",z2 CLIPPED , "'",
                          " '",z3 CLIPPED , "'",
                          " '",z4 CLIPPED , "'",
                          " '",z5 CLIPPED , "'",
                          " '",g_bgjob CLIPPED,"'"
             CALL cl_cmdat('anmp510',g_time,lc_cmd CLIPPED)
          END IF
          CLOSE WINDOW p510_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM
       END IF
     EXIT WHILE
  END WHILE
 
END FUNCTION
 
FUNCTION p510_p()
   DEFINE   l_name    LIKE type_file.chr20   
   DEFINE   l_cmd     LIKE type_file.chr1000 
   DEFINE   l_seq     LIKE type_file.num5  
   DEFINE   l_gem02   LIKE gem_file.gem02
   DEFINE   l_nml02   LIKE nml_file.nml02
   DEFINE   l_nmo02   LIKE nmo_file.nmo02
   DEFINE   l_ooa     RECORD
                         plant    LIKE nmd_file.nmd34,   
                         dbs      LIKE type_file.chr21,  
                         ooa01    LIKE ooa_file.ooa01,
                         ooa03    LIKE ooa_file.ooa03,
                         ooa15    LIKE ooa_file.ooa15,
                         ooa23    LIKE ooa_file.ooa23,
                         ooa24    LIKE ooa_file.ooa24,
                         ooa032   LIKE ooa_file.ooa032,
                         ooa33    LIKE ooa_file.ooa33,
                         oob02    LIKE oob_file.oob02,
                         oob04    LIKE oob_file.oob04,
                         oob17    LIKE oob_file.oob17,
                         ooa02    LIKE ooa_file.ooa02,
                         oob11    LIKE oob_file.oob11,
                         oob111   LIKE oob_file.oob111,
                         oob10    LIKE oob_file.oob10,   #付款日期
                         oob09    LIKE oob_file.oob09,
                         oob08    LIKE oob_file.oob08,
                         oob07    LIKE oob_file.oob07,
                         oob23    LIKE oob_file.oob23   #baofei add oob23
                      END RECORD,
   l_allow_insert  LIKE type_file.num5,       #可新增否  
   l_allow_delete  LIKE type_file.num5        #可刪除否  
DEFINE li_result   LIKE type_file.num5      
   
          CALL cl_outnam('anmp510') RETURNING l_name
          START REPORT anmp510_rep TO l_name
 
 
          LET g_success = 'Y'
          LET l_seq = 0
         #FUN-9A0093--mark--str--
         #FOR i = 1 TO 10
         #   IF cl_null(plant[i]) THEN 
         #      CONTINUE FOR
         #   END IF
         #   LET g_plant_new = plant[i]
 
         #   FOR j = 1 TO i	
         #      IF plant[j] = g_plant_new THEN
         #      END IF
         #   END FOR
 
         #   IF j < i THEN 
         #      CONTINUE FOR
         #   END IF
 
         #   CALL s_getdbs()
         #FUN-9A0093--mark--end 

             LET g_sql = "SELECT '','',ooa01,ooa03,ooa15,ooa23,ooa24,ooa032,",
                         " ooa33,oob02,oob04,oob17,ooa02,oob11,oob111,",
                         " oob10,oob09,oob08,oob07,oob23", 
                         #"  FROM ",g_dbs_new,"ooa_file,",g_dbs_new,"oob_file ",  #FUN-9A0093 mark
                         "  FROM ooa_file,oob_file ",         #FUN-9A0093
                         " WHERE ", g_wc CLIPPED,
                         " AND  ooa01 = oob01 AND ooaconf = 'Y'",
                         #" AND ooa37 = 'Y' AND oob04 = 'D' ",  #FUN-A40076 mark
                         " AND ooa37 = '2' AND oob04 = 'D' ",   #FUN-A40076 add
                         " AND (oob20='N' OR oob20 IS NULL OR oob20 = ' ')"
 
             ##nmz05(付款是否要拋傳票)
             IF g_nmz.nmz05 = 'Y' THEN 
               #LET g_sql = g_sql clipped, " AND oob33 IS NOT NULL AND oob33 != ' ' " #No.FUN-A40054
                LET g_sql = g_sql clipped, " AND ooa33 IS NOT NULL AND ooa33 != ' ' " #No.FUN-A40054
             END IF
             LET g_sql = g_sql clipped," ORDER BY ooa01"   
 
             PREPARE p510_prepare FROM g_sql
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('','',"prepare p510_prepare:",SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF
      
             DECLARE p510_cs CURSOR WITH HOLD FOR p510_prepare
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('','',"declare p510_prepare:",SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF
 
             FOREACH p510_cs INTO l_ooa.*
                IF SQLCA.sqlcode THEN
                   LET g_msg = "p510(Foreach) Plant:",g_plant_new CLIPPED," i:",i
                   CALL s_errmsg('','',g_msg,SQLCA.sqlcode,1)
                   LET g_success = 'N'
                   EXIT FOREACH 
                END IF
                #LET l_ooa.plant = plant[i]   #FUN-9A0093
                #LET l_ooa.dbs   = g_dbs_new  #FUN-9A0093
                OUTPUT TO REPORT anmp510_rep(l_ooa.*)
                LET l_seq = l_seq + 1
             END FOREACH
          #FUN-9A0093--mark--str-- 
          #   IF g_success = 'N' THEN 
          #      CONTINUE FOR       
          #   END IF  
          #END FOR
          #FUN-9A0093--mark--end 
 
          FINISH REPORT anmp510_rep
#         LET l_cmd = "chmod 777 ", l_name                   #No.FUN-9C0009
#         RUN l_cmd                                          #No.FUN-9C0009
          IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009 
 
    IF l_seq = 0 THEN
       CALL s_errmsg('','','','anm-243',1) 
       LET g_success = 'N'
    END IF
END FUNCTION
 
   
REPORT anmp510_rep(l_ooa)
    DEFINE l_sql        LIKE type_file.chr1000     
    DEFINE   l_ooa     RECORD                                                                                                
                         plant    LIKE nmd_file.nmd34,                                                                              
                         dbs      LIKE type_file.chr21,                                                                             
                         ooa01    LIKE ooa_file.ooa01,                                                                              
                         ooa03    LIKE ooa_file.ooa03,                                                                              
                         ooa15    LIKE ooa_file.ooa15,                                                                              
                         ooa23    LIKE ooa_file.ooa23,                                                                              
                         ooa24    LIKE ooa_file.ooa24,                                                                              
                         ooa032   LIKE ooa_file.ooa032,                                                                        
                         ooa33    LIKE ooa_file.ooa33,                                                                            
                         oob02    LIKE oob_file.oob02,                                                                              
                         oob04    LIKE oob_file.oob04,                                                                              
                         oob17    LIKE oob_file.oob17,                                                                            
                         ooa02    LIKE ooa_file.ooa02,                                                                              
                         oob11    LIKE oob_file.oob11,                                                                              
                         oob111   LIKE oob_file.oob111,                                                                             
                         oob10    LIKE oob_file.oob10,   #付款日期                                                                  
                         oob09    LIKE oob_file.oob09,                                                                              
                         oob08    LIKE oob_file.oob08,                                                                              
                         oob07    LIKE oob_file.oob07,
                         oob23    LIKE oob_file.oob23   #baofei add oob23                                                                              
                         END RECORD      
    DEFINE l_nmd01      LIKE nmd_file.nmd01          
    DEFINE l_no         LIKE oea_file.oea01         
    DEFINE l_amt      	LIKE type_file.num20_6     
 
 #ORDER EXTERNAL BY l_ooa.plant,l_ooa.ooa01   #FUN-9A0093
 ORDER EXTERNAL BY l_ooa.ooa01    #FUN-9A0093
 FORMAT
    ON EVERY ROW
       LET l_sql = #"UPDATE ",l_ooa.dbs,"oob_file ",   #FUN-9A0093 
                   "UPDATE oob_file ",                 #FUN-9A0093
                   "   SET oob20 = 'Y'  ",
                   " WHERE oob01 = ? ", 
                   "   AND oob02 =  ? "  CLIPPED
       PREPARE p510_upoob FROM l_sql
       EXECUTE p510_upoob  USING l_ooa.ooa01,l_ooa.oob02
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN 
          LET g_showmsg=l_ooa.ooa01,"/",l_ooa.oob02
          CALL s_errmsg('oob01,oob02',g_showmsg,'upd oob:',SQLCA.sqlcode,1)
          LET g_success = 'N'
       END IF
       CALL p510_ins_nmd(l_ooa.*) RETURNING l_nmd01   #支票
END REPORT
   
FUNCTION p510_ins_nmd(p_ooa)
     DEFINE   p_ooa     RECORD                                                                                         
                         plant    LIKE nmd_file.nmd34,                                                                              
                         dbs      LIKE type_file.chr21,                                                                             
                         ooa01    LIKE ooa_file.ooa01,                                                                              
                         ooa03    LIKE ooa_file.ooa03,                                                                              
                         ooa15    LIKE ooa_file.ooa15,                                                                              
                         ooa23    LIKE ooa_file.ooa23,                                                                              
                         ooa24    LIKE ooa_file.ooa24,                                                                              
                         ooa032   LIKE ooa_file.ooa032,                                                                    
                         ooa33    LIKE ooa_file.ooa33,                                                                            
                         oob02    LIKE oob_file.oob02,                                                                              
                         oob04    LIKE oob_file.oob04,                                                                              
                         oob17    LIKE oob_file.oob17,                                                                            
                         ooa02    LIKE ooa_file.ooa02,                                                                              
                         oob11    LIKE oob_file.oob11,                                                                              
                         oob111   LIKE oob_file.oob111,                                                                             
                         oob10    LIKE oob_file.oob10,                                                                 
                         oob09    LIKE oob_file.oob09,                                                                              
                         oob08    LIKE oob_file.oob08,                                                                              
                         oob07    LIKE oob_file.oob07,
                         oob23    LIKE oob_file.oob23                                                
                        END RECORD      
    DEFINE l_nmd01      LIKE nmd_file.nmd01         
    DEFINE l_pmc081     LIKE pmc_file.pmc081
    DEFINE l_pmc082     LIKE pmc_file.pmc082
    DEFINE l_nmd        RECORD LIKE nmd_file.*
    DEFINE l_nmf        RECORD LIKE nmf_file.*
    DEFINE l_date       LIKE type_file.dat         
    DEFINE li_result    LIKE type_file.num5       
 
#------------------------ INSERT nmd_file ------------------------------
    INITIALIZE l_nmd01 TO NULL
    INITIALIZE l_nmd.* TO NULL
    IF NOT cl_null(g_nmd07) THEN #依畫面輸入之日期  01/08/13
       LET l_date = g_nmd07
    ELSE 
       LET l_date = p_ooa.ooa02
    END IF
    CALL s_auto_assign_no("anm",tr_type1,l_date,"1","nmd_file","nmd01","","","")
      RETURNING li_result,l_nmd01
    IF (NOT li_result) THEN                                                   
       LET g_success = 'N' RETURN l_nmd01
    END IF                                                                    
    LET l_nmd.nmd01 = l_nmd01
    LET l_nmd.nmd03 = p_ooa.oob17
    LET l_nmd.nmd04 = p_ooa.oob09  #原幣金額
    LET l_nmd.nmd26 = p_ooa.oob10   #本幣金額
    LET l_nmd.nmd05 = p_ooa.oob23  # 到期日   #baofei
    LET l_nmd.nmd06 = z1
    LET l_nmd.nmd17 = ''   #付款理由
    IF cl_null(l_nmd.nmd17) THEN LET l_nmd.nmd17 = z5 END IF
    LET l_nmd.nmd20 = z2
    LET l_nmd.nmd07 = l_date
    LET l_nmd.nmd08 = p_ooa.ooa03
    SELECT occ02 INTO l_nmd.nmd09  FROM occ_file
     WHERE ooc01 = p_ooa.ooa03
    IF l_nmd.nmd14 IS NULL THEN LET l_nmd.nmd14 = '2' END IF
    LET l_nmd.nmd10 = p_ooa.ooa01
    LET l_nmd.nmd101 = p_ooa.oob02
    LET l_nmd.nmd12 = 'X'
    LET l_nmd.nmd13 = p_ooa.ooa02
    LET l_nmd.nmd18 = z3
    LET l_nmd.nmd19 = p_ooa.oob08
    LET l_nmd.nmd21 = p_ooa.oob07
    SELECT MAX(pmd02) INTO l_nmd.nmd22 FROM pmd_file
           WHERE pmd01 = p_ooa.ooa03 AND pmd06 = g_nmz.nmz54
    LET l_nmd.nmd23 = p_ooa.oob11
    IF g_aza.aza63='Y' THEN
       LET l_nmd.nmd231 = p_ooa.oob111
    END IF
    LET l_nmd.nmd24 = p_ooa.ooa032
    LET l_nmd.nmd25 = z4
    LET l_nmd.nmd27 = p_ooa.ooa33
    IF NOT cl_null(p_ooa.ooa33) THEN
       SELECT npp03 INTO l_nmd.nmd28 FROM npp_file
        WHERE nppsys = 'AP'   AND npp00 = 3
          AND npp01  = p_ooa.ooa01 AND npp011 = 1 
    END IF
    # 直接付款時
    SELECT npp03 INTO l_nmd.nmd28 FROM npp_file
     WHERE nppsys = 'AP'   AND npp00 = 1
       AND npp01  = p_ooa.ooa01 AND npp011 = 1
       AND npptype='0'
    LET l_nmd.nmd30 = 'N'
    IF p_ooa.oob04 = '1' THEN
       LET l_nmd.nmd31 = '98'    
    ELSE
       LET l_nmd.nmd31 = '98'         
    END IF
    #LET l_nmd.nmd34 = p_ooa.plant   #FUN-9A0093
    LET l_nmd.nmduser=g_user
    LET l_nmd.nmdgrup=g_grup
    LET l_nmd.nmddate=g_today
    LET l_nmd.nmd33=l_nmd.nmd19
    LET l_nmd.nmd40 = '2'
    #LET l_nmd.nmdlegal = p_ooa.ooalegal
    #FUN-980005 add legal 
    LET l_nmd.nmdlegal = g_legal 
    #FUN-980005 end legal 
    LET l_nmd.nmdoriu = g_user      #No.FUN-980030 10/01/04
    LET l_nmd.nmdorig = g_grup      #No.FUN-980030 10/01/04
    LET l_nmd.nmd55=l_nmd.nmd04     #FUN-C90122
    INSERT INTO nmd_file VALUES(l_nmd.*)
    IF SQLCA.sqlcode THEN 
       CALL s_errmsg('nmd01',l_nmd.nmd01,'ins nmd:',STATUS,1) 
       LET g_success = 'N' 
       RETURN ''
    END IF
#No.FUN-B30088----Mark---Begin----
#   CASE p_ooa.oob04
#     WHEN '1' LET g_cnt = g_cnt + 1
#              LET g_tot = g_tot + p_ooa.oob10
#              IF g_cnt =1 THEN LET  g_start_no = l_nmd.nmd01 END IF
#              LET g_end_no = l_nmd.nmd01
#     WHEN 'C' LET g_cnt2= g_cnt2+ 1
#              LET g_tot2= g_tot2+ p_ooa.oob10
#              IF g_cnt2=1 THEN LET  g_start_no2= l_nmd.nmd01 END IF
#              LET g_end_no2= l_nmd.nmd01
#   END CASE
#No.FUN-B30088----Mark---End------
#No.FUN-B30088----Add----Begin----
    IF p_ooa.oob04 = 'D' THEN
       LET g_cnt = g_cnt + 1
       LET g_tot = g_tot + p_ooa.oob10
       IF g_cnt = 1 THEN 
          LET  g_start_no = l_nmd.nmd01 
       END IF
       LET g_end_no = l_nmd.nmd01
    END IF
#No.FUN-B30088----Add----End------
 
#------------------------ INSERT nmf_file ------------------------------
    INITIALIZE l_nmf.* TO NULL
    LET l_nmf.nmf01 = l_nmd.nmd01
    LET l_nmf.nmf02 = p_ooa.ooa02
    LET l_nmf.nmf03 = '1'
    LET l_nmf.nmf04 = g_user
    LET l_nmf.nmf05 = '0'
    LET l_nmf.nmf06 = 'X'
    LET l_nmf.nmf07 = p_ooa.ooa03
    LET l_nmf.nmf08 = 1
    LET l_nmf.nmf09 = 1
    LET l_nmf.nmf12 = p_ooa.ooa01    #付款單號
    LET l_nmf.nmf11 = p_ooa.ooa33    #傳票編號
    LET l_nmf.nmf13 = ''    #傳票日期
    #LET l_nmf.nmflegal = p_ooa.ooalegal
    #FUN-980005 add legal 
    LET l_nmf.nmflegal = g_legal 
    #FUN-980005 end legal 
    INSERT INTO nmf_file VALUES(l_nmf.*)
    IF SQLCA.sqlcode THEN 
       LET g_showmsg=l_nmf.nmf01,"/",l_nmf.nmf03
       CALL s_errmsg('nmf01,nmf03',g_showmsg,'ins nmf:',STATUS,1) 
       LET g_success = 'N' 
       RETURN ' '     
    END IF
    RETURN l_nmd01
END FUNCTION
#FUN-960141
