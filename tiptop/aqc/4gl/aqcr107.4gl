# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aqcr107.4gl
# Descriptions...: QC結果判定列印作業
# Date & Author..: 12/01/17 No.FUN-BC0104 By xujing
# Modify.........: No:FUN-C20076 12/02/13 By xujing  調整參數問題
# Modify.........: No:TQC-C20295 12/02/20 By xujing  調整語法錯誤以及cs3傳參錯誤
# Modify.........: No:TQC-C30208 12/03/28 By xujing  拿掉tm.type='3' 時撈資料條件qcs00 <>'Z' 

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm  RECORD
       wc    STRING,
       type  LIKE type_file.chr20,        #QC類型
       a     LIKE type_file.chr1,         #尚有待入庫量
       more  LIKE type_file.chr1
       END RECORD
DEFINE  g_str      STRING
DEFINE  g_sql      STRING
DEFINE  l_table    STRING
DEFINE  g_argv1    LIKE qco_file.qco01, #接收單據編號(qco01)
        g_argv2    LIKE qco_file.qco02, #接收單據項次(qco02)
        g_argv3    LIKE qco_file.qco05  #接收檢驗批次(qco05)
DEFINE  g_argv4    LIKE type_file.chr20 #接受QC類型         #FUN-C20076


MAIN
   OPTIONS
 
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AQC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   LET g_pdate = ARG_VAL(1)
   LET g_towhom =ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway =ARG_VAL(5)
   LET g_copies =ARG_VAL(6)
   LET g_argv1 =ARG_VAL(7)     #接收單據編號(qco01)
   LET g_argv2 =ARG_VAL(8)     #接收單據項次(qco02)
   LET g_argv3 =ARG_VAL(9)     #接收檢驗批次(qco05)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)
   LET g_argv4 =ARG_VAL(14)    #tm.type   #FUN-C20076
   LET g_sql =   "qcf00.qcf_file.qcf00,",
                 "qcf01.qcf_file.qcf01,",
                 "qcf02.qcf_file.qcf02,",
                 "qcf021.qcf_file.qcf021,",
                 "qcf03.qcf_file.qcf03,",
                 "qcf04.qcf_file.qcf04,",
                 "qcf041.qcf_file.qcf041,",
                 "qcf05.qcf_file.qcf05,",
                 "qcf06.qcf_file.qcf06,",
                 "qcf061.qcf_file.qcf061,",
                 "qcf062.qcf_file.qcf062,",
                 "qcf071.qcf_file.qcf071,",
                 "qcf072.qcf_file.qcf072,",
                 "qcf081.qcf_file.qcf081,",
                 "qcf082.qcf_file.qcf082,",
                 "qcf09.qcf_file.qcf09,",
                 "qcf091.qcf_file.qcf091,",
                 "qcf10.qcf_file.qcf10,",
                 "qcf101.qcf_file.qcf101,",
                 "qcf11.qcf_file.qcf11,",
                 "qcf12.qcf_file.qcf12,",
                 "qcf13.qcf_file.qcf13,",
                 "qcf14.qcf_file.qcf14,",
                 "qcf15.qcf_file.qcf15,",
                 "qcf16.qcf_file.qcf16,",
                 "qcf17.qcf_file.qcf17,",
                 "qcf18.qcf_file.qcf18,",
                 "qcf19.qcf_file.qcf19,",
                 "qcf20.qcf_file.qcf20,",
                 "qcf21.qcf_file.qcf21,",
                 "qcf22.qcf_file.qcf22,",
                 "qcfprno.qcf_file.qcfprno,",
                 "qcfacti.qcf_file.qcfacti,",
                 "qcfuser.qcf_file.qcfuser,",
                 "qcfgrup.qcf_file.qcfgrup,",
                 "qcfmodu.qcf_file.qcfmodu,",
                 "qcfdate.qcf_file.qcfdate,",
                 "qcf30.qcf_file.qcf30,",
                 "qcf31.qcf_file.qcf31,",
                 "qcf32.qcf_file.qcf32,",
                 "qcf33.qcf_file.qcf33,",
                 "qcf34.qcf_file.qcf34,",
                 "qcf35.qcf_file.qcf35,",
                 "qcf36.qcf_file.qcf36,",
                 "qcf37.qcf_file.qcf37,",
                 "qcf38.qcf_file.qcf38,",
                 "qcf39.qcf_file.qcf39,",
                 "qcf40.qcf_file.qcf40,",
                 "qcf41.qcf_file.qcf41,",
                 "qcfspc.qcf_file.qcfspc,",
                 "qco01.qco_file.qco01,",
                 "qco03.qco_file.qco03,",
                 "qco04.qco_file.qco04,",
                 "qco06.qco_file.qco06,",
                 "qco07.qco_file.qco07,",
                 "qco08.qco_file.qco08,",
                 "qco09.qco_file.qco09,",
                 "qco10.qco_file.qco10,",
                 "qco11.qco_file.qco11,",
                 "qco19.qco_file.qco19,",
                 "qco20.qco_file.qco20,",
                 "qcl01.qcl_file.qcl01,",
                 "qcl02.qcl_file.qcl02,",
                 #FUN-C20076---add---str---
                 "qcs02.qcs_file.qcs02,",
                 "qcm012.qcm_file.qcm012,",
                 "qcm05.qcm_file.qcm05,",
                 "ecm06.ecm_file.ecm06,",
                 #FUN-C20076---add---end---
                 "gen02.gen_file.gen02,",
                 "ima02.ima_file.ima02,",
                 "ima021.ima_file.ima021,",
                 "ima109.ima_file.ima109,",
                 "azf03_1.azf_file.azf03,",
                 "sfb22.sfb_file.sfb22,",
                 "sfb221.sfb_file.sfb221,",
                 "sfb82.sfb_file.sfb82,",
                 "occ02.occ_file.occ02,",
                 "gem02.gem_file.gem02,",
                 "oea01.oea_file.oea01,",
                 "oea04.oea_file.oea04,",
                 "oea44.oea_file.oea44,",
                 "sign_type.type_file.chr1,",      #簽核方式   
                 "sign_img.type_file.blob ,",      #簽核圖檔   
                 "sign_show.type_file.chr1,",      #是否顯示簽核資料(Y/N) 
                 "sign_str.type_file.chr1000"
                 

   LET l_table = cl_prt_temptable('aqcr107',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   #FUN-C20076---add--str--- 
   LET tm.wc = " 1=1"
   IF NOT cl_null(g_argv1) THEN LET tm.wc = tm.wc , " AND qco01='",g_argv1,"'" END IF
   IF NOT cl_null(g_argv2) THEN LET tm.wc = tm.wc , " AND qco02=",g_argv2 END IF
   IF NOT cl_null(g_argv3) THEN LET tm.wc = tm.wc , " AND qco05=",g_argv3 END IF
   #FUN-C20076---add--end---

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r107_tm(0,0)
   ELSE 
      LET g_pdate = g_today     #FUN-C20076
      LET g_rlang = g_lang      #FUN-C20076
      LET tm.type = g_argv4     #FUN-C20076
      CALL r107()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION r107_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01  
DEFINE p_row,p_col    LIKE type_file.num5,          
       l_cmd          LIKE type_file.chr1000       
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW r107_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcr107"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.a    = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'


WHILE TRUE
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON qco01,qco06
      
         BEFORE CONSTRUCT
             CALL cl_qbe_init()

      ON ACTION controlp
         IF INFIELD(qco06) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_qco06"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO qco06
            NEXT FIELD qco06
         END IF
      ON ACTION locale
          CALL cl_show_fld_cont()                   
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
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
           LET INT_FLAG = 1
           EXIT CONSTRUCT

         ON ACTION qbe_select
            CALL cl_qbe_select()

   END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF

       IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r107_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      IF tm.wc != ' 1=1' THEN EXIT WHILE END IF
      CALL cl_err('',9046,0)
   END WHILE
   #FUN-C20074---add---str---
   LET tm.type = ''
   LET tm.a    = 'N'
   LET tm.more = 'N' 
   #FUN-C20074---add---end---
   DISPLAY BY NAME tm.type,tm.a,tm.more
   INPUT BY NAME tm.type,tm.a,tm.more WITHOUT DEFAULTS

       BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)

         AFTER FIELD a
         IF tm.a NOT MATCHES "[YN]"
            THEN NEXT FIELD a
         END IF
         
         AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF

         ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  

         ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         
         ON ACTION qbe_save
            CALL cl_qbe_save()

   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r107_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aqcr107'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aqcr107','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", 
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.type CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'",           
                         " '",g_rpt_name CLIPPED,"'"            
 
         CALL cl_cmdat('aqcr107',g_time,l_cmd)
      END IF
      CLOSE WINDOW r107_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r107()
   ERROR ""
END WHILE
   CLOSE WINDOW r107_w
END FUNCTION  

FUNCTION r107()
   DEFINE  l_img_blob     LIKE type_file.blob              
   DEFINE l_name       LIKE type_file.chr20,        
          l_sql        STRING,       
          l_chr        LIKE type_file.chr1,          
          l_za05       LIKE cob_file.cob01,          
          l_oea01      LIKE oea_file.oea01,
          l_ofb01      LIKE ofb_file.ofb01,
          l_oea04      LIKE oea_file.oea04,
          l_oea44      LIKE oea_file.oea44,
          l_gen02      LIKE gen_file.gen02,
          l_pmc03      LIKE pmc_file.pmc03,
          l_ima02      LIKE ima_file.ima02,
          l_ima021     LIKE ima_file.ima021,
          l_ima109     LIKE ima_file.ima109,
          l_ima15      LIKE ima_file.ima15,
          l_azf03_1    LIKE azf_file.azf03,
          l_qao01      LIKE qao_file.qao01,
          l_qao02      LIKE qao_file.qao02,
          l_qao021     LIKE qao_file.qao021,
          l_qao03      LIKE qao_file.qao03,
          l_qao05      LIKE qao_file.qao05,
          l_qao06      LIKE qao_file.qao06,
          l_qce03      LIKE qce_file.qce03,
          l_sfb22      LIKE sfb_file.sfb22,
          l_sfb221     LIKE sfb_file.sfb221,
          l_sfb82      LIKE sfb_file.sfb82,
          l_occ02      LIKE occ_file.occ02,
          l_gem02      LIKE gem_file.gem02,

          sr        RECORD                 
                   qcf00  LIKE qcf_file.qcf00,
                   qcf01  LIKE qcf_file.qcf01,
                   qcf02  LIKE qcf_file.qcf02,
                   qcf021 LIKE qcf_file.qcf021,
                   qcf03  LIKE qcf_file.qcf03,
                   qcf04  LIKE qcf_file.qcf04,
                   qcf041 LIKE qcf_file.qcf041,
                   qcf05  LIKE qcf_file.qcf05,
                   qcf06  LIKE qcf_file.qcf06,
                   qcf061 LIKE qcf_file.qcf061,
                   qcf062 LIKE qcf_file.qcf062,
                   qcf071 LIKE qcf_file.qcf071,
                   qcf072 LIKE qcf_file.qcf072,
                   qcf081 LIKE qcf_file.qcf081,
                   qcf082 LIKE qcf_file.qcf082,
                   qcf09  LIKE qcf_file.qcf09,
                   qcf091 LIKE qcf_file.qcf091,
                   qcf10  LIKE qcf_file.qcf10,
                   qcf101 LIKE qcf_file.qcf101,
                   qcf11  LIKE qcf_file.qcf11,
                   qcf12  LIKE qcf_file.qcf12,
                   qcf13  LIKE qcf_file.qcf13,
                   qcf14  LIKE qcf_file.qcf14,
                   qcf15  LIKE qcf_file.qcf15,
                   qcf16  LIKE qcf_file.qcf16,
                   qcf17  LIKE qcf_file.qcf17,
                   qcf18  LIKE qcf_file.qcf18,
                   qcf19  LIKE qcf_file.qcf19,
                   qcf20  LIKE qcf_file.qcf20,
                   qcf21  LIKE qcf_file.qcf21,
                   qcf22  LIKE qcf_file.qcf22,
                  qcfprno LIKE qcf_file.qcfprno,
                  qcfacti LIKE qcf_file.qcfacti,
                  qcfuser LIKE qcf_file.qcfuser,
                  qcfgrup LIKE qcf_file.qcfgrup,
                  qcfmodu LIKE qcf_file.qcfmodu,
                  qcfdate LIKE qcf_file.qcfdate,
                   qcf30  LIKE qcf_file.qcf30,
                   qcf31  LIKE qcf_file.qcf31,
                   qcf32  LIKE qcf_file.qcf32,
                   qcf33  LIKE qcf_file.qcf33,
                   qcf34  LIKE qcf_file.qcf34,
                   qcf35  LIKE qcf_file.qcf35,
                   qcf36  LIKE qcf_file.qcf36,
                   qcf37  LIKE qcf_file.qcf37,
                   qcf38  LIKE qcf_file.qcf38,
                   qcf39  LIKE qcf_file.qcf39,
                   qcf40  LIKE qcf_file.qcf40,
                   qcf41  LIKE qcf_file.qcf41,
                  qcfspc  LIKE qcf_file.qcfspc,
                   qco01  LIKE qco_file.qco01,
                   qco03  LIKE qco_file.qco03,
                   qco04  LIKE qco_file.qco04,
                   qco06  LIKE qco_file.qco06,
                   qco07  LIKE qco_file.qco07,
                   qco08  LIKE qco_file.qco08,
                   qco09  LIKE qco_file.qco09,
                   qco10  LIKE qco_file.qco10,
                   qco11  LIKE qco_file.qco11,
                   qco19  LIKE qco_file.qco19,
                   qco20  LIKE qco_file.qco20,
                   qcl01  LIKE qcl_file.qcl01,
                   qcl02  LIKE qcl_file.qcl02,
                 #FUN-C20076---add---str---
                   qcs02  LIKE qcs_file.qcs02,
                   qcm012 LIKE qcm_file.qcm012,
                   qcm05  LIKE qcm_file.qcm05,
                   ecm06  LIKE ecm_file.ecm06
                 #FUN-C20076---add---end---
                    END RECORD

     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     DISPLAY l_table
     LOCATE l_img_blob IN MEMORY   #blob初始化   
     CALL cl_del_data(l_table)

     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?, ?, ?)"                    #FUN-C20076   
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    
        EXIT PROGRAM
     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('qcfuser', 'qcfgrup')

     IF tm.type='1' OR tm.type='3' THEN
        LET l_sql = "SELECT DISTINCT qcs00, qcs01,'',qcs021, qcs03, qcs04,qcs041,qcs05,",
                    "       qcs06,qcs061,qcs062,qcs071,qcs072,qcs081,qcs082,qcs09, ",
                    "      qcs091, qcs10,qcs101, qcs11, qcs12, qcs13, qcs14,qcs15, ",
                    "       qcs16, qcs17,qcs18 ,qcs19 ,qcs20 ,qcs21 ,qcs22 , ",
                    "       qcsprno,qcsacti,qcsuser,qcsgrup,qcsmodu,qcsdate,",
                    "       qcs30,qcs31 ,qcs32 ,qcs33 ,qcs34 ,qcs35 ,qcs36 ,qcs37 , ",
                    "       qcs38,qcs39 ,qcs40 ,qcs41 ,qcsspc,",
                    "       qco01,qco03,qco04,qco06,qco07,qco08,qco09,qco10,",
                    "       qco11,qco19,qco20,qcl01,qcl02,qcs02,'',0,''",
                    " FROM  qcs_file,qco_file,qcl_file ",
                    " WHERE qco01=qcs01 ",
                    "   AND qco03=qcl01 ",
                    "   AND ",tm.wc CLIPPED,
#                   "   AND qco02=qcs02 AND qco05=qcs05 AND qcsacti='Y' AND qcs14<>'X' AND qcs00 <>'Z'"    #TQC-C30208 mark
                    "   AND qco02=qcs02 AND qco05=qcs05 AND qcsacti='Y' AND qcs14<>'X'"                    #TQC-C30208 add
#                   "   ORDER BY qco04"       #TQC-C20295 mark
        #TQC-C30208---add---str---
        IF tm.type='1' THEN
           LET l_sql = l_sql CLIPPED," AND qcs00 <>'Z'"    
        END IF
        IF tm.type='3' THEN
           LET l_sql = l_sql CLIPPED," AND qcs00 ='Z'"
        END IF
        #TQC-C30208---add---end---
     END IF 
     IF tm.type='2' THEN
        LET l_sql = "SELECT  DISTINCT qcf00, qcf01, qcf02,qcf021, qcf03, qcf04,qcf041,qcf05,",
                    "       qcf06,qcf061,qcf062,qcf071,qcf072,qcf081,qcf082,qcf09, ",
                    "      qcf091, qcf10,qcf101, qcf11, qcf12, qcf13, qcf14,qcf15, ",
                    "       qcf16, qcf17,qcf18 ,qcf19 ,qcf20 ,qcf21 ,qcf22 , ",
                    "       qcfprno,qcfacti,qcfuser,qcfgrup,qcfmodu,qcfdate,",
                    "       qcf30,qcf31 ,qcf32 ,qcf33 ,qcf34 ,qcf35 ,qcf36 ,qcf37 , ",
                    "       qcf38,qcf39 ,qcf40 ,qcf41 ,qcfspc,",
                    "       qco01,qco03,qco04,qco06,qco07,qco08,qco09,qco10,",
                    "       qco11,qco19,qco20,qcl01,qcl02,0,'',0,''",
                    " FROM  qcf_file,qco_file,qcl_file ",
                    " WHERE qcf01=qco01 AND qcf18='1' ",
                    "   AND qco03=qcl01 ",
                    "   AND ",tm.wc CLIPPED, 
                    "   AND  qcfacti='Y' AND qcf14<>'X'"
#                   "   ORDER BY qco04"                #TQC-C20295 mark
     END IF 
     
     IF tm.type='4' THEN
        LET l_sql = "SELECT  DISTINCT qcm00, qcm01, qcm02,qcm021, qcm03, qcm04,qcm041,0,",
                    "       qcm06,qcm061,qcm062,qcm071,qcm072,qcm081,qcm082,qcm09, ",
                    "      qcm091, qcm10,qcm101, qcm11, qcm12, qcm13, qcm14,qcm15, ",
                    "       qcm16, qcm17,qcm18 ,qcm19 ,qcm20 ,qcm21 ,qcm22 , ",
                    "       qcmprno,qcmacti,qcmuser,qcmgrup,qcmmodu,qcmdate,",
                    "       '' ,0 ,0 ,'' ,0 ,0 ,'' ,0 ,0 ,'' ,0 ,0 ,qcmspc ,",
                    "       qco01,qco03,qco04,qco06,qco07,qco08,qco09,qco10,",
                    "       qco11,qco19,qco20,qcl01,qcl02,0,qcm012,qcm05,ecm06",
                    " FROM  qcm_file,qco_file,qcl_file,ecm_file ",
                    " WHERE qco01=qcm01 AND ecm01=qcm02",
                    "   AND qco03=qcl01 ",
                    "   AND ",tm.wc CLIPPED, 
                    "   AND qcmacti='Y' AND qcm14<>'X'"
#                   "   ORDER BY qco04"                 #TQC-C20295 mark
     END IF 
     IF tm.a="Y" THEN     
        LET l_sql = l_sql CLIPPED,"   AND qco11 > qco20"
     END IF
     LET l_sql = l_sql CLIPPED," ORDER BY qco04"        #TQC-C20295 
     PREPARE r107_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
     END IF
     DECLARE r107_curs1 CURSOR FOR r107_prepare1

     FOREACH r107_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF

         LET l_gen02 = NULL
         LET l_pmc03 = NULL
         LET l_ima02 = NULL
         LET l_ima021 = NULL
         LET l_ima15 = NULL
         LET l_ima109= NULL
         LET l_azf03_1 = NULL
         LET l_sfb22 = NULL
         LET l_sfb221 = 0      #FUN-C20076 mod 
         LET l_sfb82 = NULL
         LET l_occ02 = NULL
         LET l_gem02 = NULL
         LET l_oea01 = NULL
         LET l_oea04 = NULL
         LET l_oea44 = NULL
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.qcf13  
         SELECT ima02,ima021,ima109
           INTO l_ima02,l_ima021,l_ima109
           FROM ima_file
          WHERE ima01=sr.qcf021   
         SELECT azf03 INTO l_azf03_1 FROM azf_file WHERE azf01=l_ima109 AND azf02='8'
         SELECT sfb22,sfb221,sfb82 INTO l_sfb22,l_sfb221,l_sfb82 FROM sfb_file
           WHERE sfb01=sr.qcf02  
         #FUN-C20076---add---str---
         IF cl_null(l_sfb221) THEN
            LET l_sfb221 = 0
         END IF 
         #FUN-C20076---add---end---
         SELECT occ02 INTO l_occ02 FROM oea_file,occ_file
           WHERE oea04=occ01 AND oea01=l_sfb22
         #FUN-C20076---add---str---
         IF tm.type='2' THEN
            SELECT gem02 INTO l_gem02 FROM gem_file
              WHERE gem01 = l_sfb82
         END IF 
         IF tm.type='1' OR tm.type='3' THEN
            SELECT pmc03 INTO l_gem02 FROM pmc_file
              WHERE pmc01 = sr.qcf03
         END IF
         IF tm.type='4' THEN
            SELECT ecm45 INTO l_gem02 FROM ecm_file
              WHERE ecm01 = sr.qcf02
         END IF
         #FUN-C20076---add---end---
         
         SELECT oea01,oea04,oea44 INTO l_oea01,l_oea04,l_oea44
           FROM oea_file              #抓單頭資料
          WHERE oea01=l_sfb22
         EXECUTE insert_prep USING sr.*,l_gen02,l_ima02,l_ima021,l_ima109,l_azf03_1,
                                   l_sfb22,l_sfb221,l_sfb82,l_occ02,l_gem02,l_oea01,l_oea04,l_oea44,
                                   "", l_img_blob, "N",""
    END FOREACH
    
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'qco01,qco06')
          RETURNING tm.wc
    LET g_str = tm.wc,";",g_zz05,";",tm.type,";",tm.a,";",g_sma.sma115,";",g_sma.sma541,";"
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    LET g_cr_table = l_table                 #主報表的temp table名稱  
    LET g_cr_apr_key_f = "qcf01"       #報表主鍵欄位名稱  
    CALL cl_prt_cs3('aqcr107','aqcr107',l_sql,g_str)
         
END FUNCTION 

#FUN-BC0104---
