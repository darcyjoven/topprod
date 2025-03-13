# Prog. Version..: '5.10.05-08.12.18(00009)'     #
# Pattern name...: apsp520.4gl 
# Descriptions...: APS 工單產生作業
# Date & Author..: 03/04/06 By Kammy
# Modify.........: No:FUN-730056 07/03/27 By Mandy APS 相關調整,並刪除程式不相干的垃圾段
# Modify.........: No:TQC-750167 07/05/28 By Joe 處理轉不出資料之情況
# Modify.........: No:FUN-760041 07/06/13 By Joe 新增APS整合欄位(後撤銷)
# Modify.........: No:FUN-790031 07/09/13 By Nicole 正Primary Key後,程式判斷錯誤訊息-239時必須改變做法
# Modify.........: No.CHI-740001 07/09/27 By rainy bma_file要判斷有效碼
# Modify.........: No:FUN-7B0018 08/02/25 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No:FUN-870051 08/07/16 By sherry 增加被替代料(sfa27)為Key
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_apssmo       RECORD LIKE apssmo.*   #FUN-730056
DEFINE g_sfb	      RECORD LIKE sfb_file.*
DEFINE g_wc,g_sql     string              
DEFINE g_t1           LIKE sfb_file.sfb01
DEFINE i,j,k	      LIKE type_file.num10  
DEFINE g_apsdb        LIKE type_file.chr21 
DEFINE g_chr          LIKE type_file.chr1 
DEFINE g_cnt          LIKE type_file.num10      
DEFINE g_i            LIKE type_file.num5          #count/index for any purpose  
DEFINE g_msg          LIKE type_file.chr1000 
DEFINE g_sfb01        LIKE sfb_file.sfb01      
DEFINE l_za05         LIKE type_file.chr1000 
DEFINE g_change_lang  LIKE type_file.chr1   
DEFINE g_opseq        LIKE sfa_file.sfa08
DEFINE g_offset       LIKE sfa_file.sfa09

MAIN
   DEFINE p_row,p_col LIKE type_file.num5,    
          l_time      LIKE type_file.chr8,         # Used time for running the job  
          l_sql       LIKE type_file.chr1000,      # RDSQL STATEMENT  
          l_chr       LIKE type_file.chr1     
   DEFINE l_flag      LIKE type_file.chr1           
   DEFINE ls_date     STRING          

   OPTIONS
       FORM LINE     FIRST + 2,
       MESSAGE LINE  LAST,
       PROMPT LINE   LAST,
       INPUT NO WRAP
   DEFER INTERRUPT				 

   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc     = ARG_VAL(1)             #QBE條件
   LET ls_date  = ARG_VAL(2)
   LET g_sfb.sfb81 = cl_batch_bg_date_convert(ls_date)
   LET g_sfb.sfb01 = ARG_VAL(3)
   LET g_sfb.sfb82 = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)              #背景作業
   IF cl_null(g_bgjob) THEN
       LET g_bgjob = "N"
   END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,l_time,1) RETURNING l_time 

   WHILE TRUE 
      IF g_bgjob = "N" THEN
         INITIALIZE g_sfb.* TO NULL
         CALL s_getdbs_curr(aps_saz.saz01) RETURNING g_apsdb
         LET g_apsdb = g_apsdb CLIPPED
         SELECT MAX(smyslip) INTO g_sfb.sfb01 FROM smy_file
          WHERE smysys='asf' AND smykind='1'
         LET g_sfb.sfb81 = g_today
         SELECT gen03 INTO g_sfb.sfb82 FROM gen_file WHERE gen01=g_user
         CALL p520_ask()
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p520()
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p520
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p520()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
     CALL cl_used(g_prog,l_time,2) RETURNING l_time 
END MAIN

FUNCTION p520_ask()
   DEFINE li_result    LIKE type_file.num5        
   DEFINE lc_cmd       LIKE type_file.chr1000     
   DEFINE p_row,p_col  LIKE type_file.num5        

   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 30
   ELSE 
      LET p_row = 4 LET p_col = 13
   END IF
   OPEN WINDOW p520_w AT p_row,p_col
        WITH FORM "aps/42f/apsp520" 
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()

   INITIALIZE g_sfb.* TO NULL
   LET g_plant_new = aps_saz.saz01
   CALL s_getdbs()
   SELECT MAX(smyslip) INTO g_sfb.sfb01 FROM smy_file
         WHERE smysys='asf' AND smykind='1'
   LET g_sfb.sfb81 = g_today
   SELECT gen03 INTO g_sfb.sfb82 
     FROM gen_file 
    WHERE gen01=g_user

 WHILE TRUE  
   CONSTRUCT BY NAME g_wc ON pid, ima08
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION locale
         LET g_change_lang = TRUE     
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
   
      ON ACTION qbe_select
         CALL cl_qbe_select()

   END CONSTRUCT
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p520
      EXIT PROGRAM
   END IF
   LET g_bgjob = 'N' 
   INPUT BY NAME g_sfb.sfb81,g_sfb.sfb01,g_sfb.sfb82,g_bgjob 
                 WITHOUT DEFAULTS 
      AFTER FIELD sfb81
         IF cl_null(g_sfb.sfb81) THEN
            NEXT FIELD sfb81
         END IF
      AFTER FIELD sfb01
         IF cl_null(g_sfb.sfb01) THEN
            NEXT FIELD sfb01 
         END IF
         LET g_t1=g_sfb.sfb01[1,g_doc_len]

         CALL s_check_no("asf",g_t1,"","1","","","")
              RETURNING li_result,g_sfb.sfb01
         IF (NOT li_result) THEN
              NEXT FIELD sfb01
         END IF
         CALL s_auto_assign_no("asf",g_sfb.sfb01,g_sfb.sfb81,"1","sfb_file","sfb01",
                  "","","")
             RETURNING li_result,g_sfb.sfb01
         IF g_bgjob = 'N' THEN
            DISPLAY BY NAME g_sfb.sfb01    
         END IF

      AFTER FIELD sfb82
         IF g_sfb.sfb82 IS NULL THEN
            NEXT FIELD sfb82
         END IF

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(sfb01) #order nubmer
              LET g_t1=s_get_doc_no(g_sfb.sfb01)
              CALL q_smy('FALSE','FALSE',g_t1,'ASF','1') RETURNING g_t1  
              LET g_sfb.sfb01=g_t1
              DISPLAY BY NAME g_sfb.sfb01 
              NEXT FIELD sfb01
            WHEN INFIELD(sfb82) #製造部門
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gem"
              LET g_qryparam.default1 =g_sfb.sfb82
              CALL cl_create_qry() RETURNING g_sfb.sfb82
              DISPLAY BY NAME g_sfb.sfb82
              NEXT FIELD sfb82
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
 
      ON ACTION locale
         LET g_change_lang = TRUE       
         EXIT INPUT 
   
      ON ACTION qbe_save
         CALL cl_qbe_save()

   END INPUT
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p520
      EXIT PROGRAM
   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "apsp520"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('apsp520','9031',1)
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_wc CLIPPED,"'",
                      " '",g_sfb.sfb81 CLIPPED,"'",
                      " '",g_sfb.sfb01 CLIPPED,"'",
                      " '",g_sfb.sfb82 CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('apsp520',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p520
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE
END FUNCTION

FUNCTION p520()
  DEFINE l_name	LIKE type_file.chr20   

  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
##TQC-750167-----------------------------------------------------
##LET g_sql="SELECT ",g_apsdb CLIPPED," apssmo.* ",   
##          "  FROM ",g_apsdb CLIPPED," apssmo",
  LET g_sql="SELECT apssmo.* ",
            "  FROM ",g_apsdb CLIPPED,"apssmo",
##TQC-750167-----------------------------------------------------
            " WHERE dm_qty > 0 ",
            "   AND mo_id LIKE 'APS_MO%' ",
            "   AND pid IN ( SELECT DISTINCT bma01 ", 
            "                  FROM bma_file,ima_file ",
            "                 WHERE bma05 IS NOT NULL ", 
            "                   AND bma05 <= '",g_sfb.sfb81,"'", 
            "                   AND bma06 = ima910 ",         
            "                   AND bmaacti = 'Y' ",  #CHI-740001
            "                   AND ima08 <> 'P') ",
            "   AND ",g_wc CLIPPED

   PREPARE p520_p FROM g_sql
   DECLARE p520_c CURSOR FOR p520_p
   CALL cl_outnam('apsp520') RETURNING l_name
   START REPORT p520_rep TO l_name
   FOREACH p520_c INTO g_apssmo.*
      OUTPUT TO REPORT p520_rep(g_apssmo.*)
   END FOREACH
   FINISH REPORT p520_rep
   CALL cl_prt(l_name,' ','1',g_len)
   IF NOT cl_confirm('amr-078') THEN
      LET g_success='N'
   END IF
END FUNCTION

REPORT p520_rep(l_apssmo)
  DEFINE l_apssmo	RECORD LIKE apssmo.*
  DEFINE li_result      LIKE type_file.num5    
  DEFINE l_ima08        LIKE ima_file.ima08,
         l_smy57        LIKE smy_file.smy57,  
         l_chr          LIKE ahe_file.ahe01, 
         l_ima02        LIKE ima_file.ima02,
         l_ima25        LIKE ima_file.ima25,     
         l_ima55        LIKE ima_file.ima55,    
         l_ima55_fac    LIKE ima_file.ima55_fac,
         l_last_sw      LIKE type_file.chr1     
  DEFINE l_sfbi         RECORD LIKE sfbi_file.*   #No.FUN-7B0018

  OUTPUT TOP MARGIN g_top_margin 
         LEFT MARGIN g_left_margin 
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   

  ORDER BY l_apssmo.pid  
  FORMAT
    PAGE HEADER
      LET l_last_sw = 'n'
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_dash[1,g_len] CLIPPED
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED
      PRINT g_dash1

    ON EVERY ROW
      IF cl_null(g_sfb.sfb01[g_no_sp,g_no_ep]) THEN 
         ##CALL s_auto_assign_no("SFB","g_sfb.sfb01","g_sfb.sfb81","1","sfb_file","sfb01","","","")  RETURNING li_result,g_sfb.sfb01   ##TQC-750167
         CALL s_auto_assign_no("asf",g_sfb.sfb01,g_sfb.sfb81,"1","sfb_file","sfb01","","","")  RETURNING li_result,g_sfb.sfb01
         IF (NOT li_result) THEN                                                                                                       
             LET g_success='N'
             IF g_bgjob = 'Y' THEN 
                 CALL cl_batch_bg_javamail("N") 
             END IF 
             EXIT PROGRAM 
         END IF 
      END IF
      LET g_sfb01 = g_sfb.sfb01        
      SELECT ima08,ima25,ima55,ima55_fac 
        INTO l_ima08,l_ima25,l_ima55,l_ima55_fac
        FROM ima_file 
       WHERE ima01=l_apssmo.pid    ##TQC-750167
     ##WHERE ima01=pid
      IF STATUS THEN 
         LET l_ima08='M' 
      END IF
      IF l_ima08='M' OR l_ima08='T' THEN 
         LET g_sfb.sfb02='1' 
      END IF
      IF l_ima08='S' THEN 
         LET g_sfb.sfb02='7' 
      END IF
      LET g_sfb.sfb04  ='1'
      LET g_sfb.sfb05  = l_apssmo.pid
      SELECT smy57 INTO l_smy57 FROM smy_file WHERE smyslip=g_t1          
      IF l_smy57[1,1]='Y' THEN 
         LET g_sfb.sfb06 = l_apssmo.route_id CLIPPED
      END IF
      LET g_sfb.sfb071 = l_apssmo.pnrel_t  
      IF l_ima25 != l_ima55 THEN                       ##庫存單位為計基礎,轉成
         LET g_sfb.sfb08 = l_apssmo.dm_qty/l_ima55_fac ##工單必須再乘上料件庫存
      ELSE                                             ##/生產單位之轉換率
         LET g_sfb.sfb08 = l_apssmo.dm_qty
      END IF
      LET g_sfb.sfb081 = 0
      LET g_sfb.sfb09  = 0
      LET g_sfb.sfb10  = 0
      LET g_sfb.sfb11  = 0
      LET g_sfb.sfb111 = 0  
      LET g_sfb.sfb12  = 0
      LET g_sfb.sfb13  = l_apssmo.pnrel_t
      LET g_sfb.sfb15  = l_apssmo.pncmp_t
      LET g_sfb.sfb222 = l_apssmo.mo_id
      LET g_sfb.sfb23  ='N'
      LET g_sfb.sfb24  ='N'
      LET g_sfb.sfb29  ='Y'
      LET g_sfb.sfb32  = 0
      LET g_sfb.sfb34  = 1
      LET g_sfb.sfb35  ='N'
      LET g_sfb.sfb39  ='1'
      LET g_sfb.sfb41  ='N'
      LET g_sfb.sfb42  = 0
      LET g_sfb.sfb87  ='N'
      LET g_sfb.sfb87  ='N'
      LET g_sfb.sfb93  = l_smy57[1,1]           #製程否
      LET g_sfb.sfb94  = l_smy57[2,2]           #FQC否 
      #LET g_sfb.sfb22  = l_apssmo.pr_doid       #來源訂單   #FUN-760041  #因有併單情況,不適合轉這兩欄位
      #LET g_sfb.sfb86  = l_apssmo.pr_moid       #母工單     #FUN-760041
      SELECT ima910 INTO g_sfb.sfb95
        FROM ima_file
       WHERE ima01 = g_sfb.sfb05
      IF cl_null(g_sfb.sfb95) THEN
         LET g_sfb.sfb95 = ' '
      END IF
      LET g_sfb.sfb98  =' ' 
      LET g_sfb.sfbacti = 'Y'
      LET g_sfb.sfbuser = g_user
      LET g_sfb.sfbgrup = g_grup
      LET g_sfb.sfb1002='N' #保稅核銷否 
      SELECT ima02 INTO l_ima02 
        FROM ima_file 
       WHERE ima01=g_sfb.sfb05
      PRINT COLUMN g_c[31],g_sfb01,                   
            COLUMN g_c[32],g_sfb.sfb05[1,15],
            COLUMN g_c[33],l_ima02,
            COLUMN g_c[34],cl_numfor(g_sfb.sfb08,34,g_azi03), 
            COLUMN g_c[35],g_sfb.sfb13,
            COLUMN g_c[36],g_sfb.sfb15,
            COLUMN g_c[37],g_sfb.sfb222   
      INSERT INTO sfb_file VALUES(g_sfb.*)
      IF STATUS THEN
         CALL cl_err3("ins","sfb_file",g_sfb.sfb01,"",STATUS,"","ins sfb:",1)  
         IF g_bgjob = 'Y' THEN 
             CALL cl_batch_bg_javamail("N") 
         END IF  
         EXIT PROGRAM 
      END IF
      #NO.FUN-7B0018 08/02/26 add --begin
      IF NOT s_industry('std') THEN
         INITIALIZE l_sfbi.* TO NULL
         LET l_sfbi.sfbi01 = g_sfb.sfb01
         IF NOT s_ins_sfbi(l_sfbi.*,'') THEN
            IF g_bgjob = 'Y' THEN 
               CALL cl_batch_bg_javamail("N") 
            END IF  
            EXIT PROGRAM
         END IF
      END IF
      #NO.FUN-7B0018 08/02/26 add --end

     #FUN-730056 mark
     #IF g_sma.sma27='1' THEN   
     #   CALL s_cralc(g_sfb.sfb01,g_sfb.sfb02,g_sfb.sfb05,'Y',
     #                g_sfb.sfb08,g_sfb.sfb071,'Y',g_sma.sma71,0,g_sfb.sfb95)  
     #                RETURNING g_cnt
     #END IF
      CALL p520_ins_sfa(l_apssmo.mo_id,g_sfb.sfb02,g_sfb.sfb39) #FUN-730056 add
      #==>使用製程追蹤
      IF g_sma.sma26='2' THEN
         CALL p520_crrut()
      END IF

      LET g_sfb.sfb01 = g_t1     

   ON LAST ROW
      LET l_last_sw = 'y'
      PRINT g_dash CLIPPED
      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7]

   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash CLIPPED
         PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6]
         ELSE SKIP 2 LINE
      END IF

END REPORT

FUNCTION p520_crrut()
  DEFINE l_ecb RECORD LIKE ecb_file.*
  DEFINE l_ima571  LIKE ima_file.ima571
  DEFINE l_ecu01   LIKE ecu_file.ecu01
  DEFINE l_ecu02   LIKE ecu_file.ecu02

  IF NOT cl_null(g_sfb.sfb06) THEN
      #---->check 製程追蹤是否有投入等量
      SELECT COUNT(*) INTO g_cnt FROM ecm_file
       WHERE ecm01=g_sfb.sfb01
         AND (ecm301+ecm302+ecm303)<>0  #(良入 + 重入)
      IF g_cnt > 0 THEN CALL cl_err('','asf-386',0) RETURN END IF
      #生產日報已有資料
      SELECT COUNT(*) INTO g_cnt 
        FROM shb_file 
       WHERE shb05 = g_sfb.sfb01
      IF g_cnt > 0 THEN CALL cl_err('','asf-025',0) RETURN END IF

      SELECT COUNT(*) INTO g_cnt 
        FROM ecm_file 
       WHERE ecm01=g_sfb.sfb01 
      IF g_cnt > 0 THEN
           DELETE FROM ecm_file WHERE ecm01=g_sfb.sfb01
           IF SQLCA.sqlerrd[3]=0 THEN 
               CALL cl_err3("del","ecm_file",g_sfb.sfb01,"","asf-026","","",0)  
               RETURN
           END IF  
      END IF
      #展追蹤先用--->ima571產品料號+ecu02製程編號
      SELECT ima571 INTO l_ima571 FROM ima_file 
       WHERE ima01=g_sfb.sfb05

      IF cl_null(l_ima571) THEN LET l_ima571=' ' END IF 

      SELECT ecu01 FROM ecu_file
       WHERE ecu01=l_ima571 
         AND ecu02=g_sfb.sfb06
      IF STATUS THEN
         SELECT ecu01 FROM ecu_file
                WHERE ecu01=g_sfb.sfb05 
                  AND ecu02=g_sfb.sfb06
         IF STATUS THEN
             CALL cl_err3("sel","ecu_file",g_sfb.sfb05,g_sfb.sfb06,STATUS,"","sel ecu:",0)  
             RETURN
         ELSE
            LET l_ecu01=g_sfb.sfb05
         END IF
      ELSE
         LET l_ecu01=l_ima571
      END IF

      CALL s_schdat(0,g_sfb.sfb13,g_sfb.sfb15,g_sfb.sfb071,
                    g_sfb.sfb01,g_sfb.sfb06,g_sfb.sfb02,l_ecu01,    
                    g_sfb.sfb08,2)
         RETURNING g_cnt,g_sfb.sfb13,g_sfb.sfb15,g_sfb.sfb32,g_sfb.sfb24
      ##TQC-750167---------------------------------------------------
      ##IF g_bgjob = 'N' THEN  
      ##    DISPLAY BY NAME g_sfb.sfb13,g_sfb.sfb15,g_sfb.sfb24
      ##END IF
      ##TQC-750167---------------------------------------------------

      SELECT count(*) INTO g_cnt 
        FROM ecm_file 
       WHERE ecm01 = g_sfb.sfb01
      IF g_cnt > 0 THEN 
          LET g_sfb.sfb24 = 'Y' 
      ELSE 
          LET g_sfb.sfb24 = 'N' 
      END IF
      SELECT count(*) INTO g_cnt 
        FROM sfb_file
       WHERE sfb01=g_sfb.sfb01
         AND (sfb13 IS NOT NULL AND sfb15 IS NOT NULL )
      IF g_cnt > 0 THEN
          UPDATE sfb_file 
             SET sfb24=g_sfb.sfb24 
           WHERE sfb01=g_sfb.sfb01
          SELECT sfb13,sfb15 INTO g_sfb.sfb13,g_sfb.sfb15 
            FROM sfb_file
           WHERE sfb01 = g_sfb.sfb01
          ##TQC-750167---------------------------------------------------
          ##IF g_bgjob = 'N' THEN  
          ##    DISPLAY BY NAME g_sfb.sfb13,g_sfb.sfb15,g_sfb.sfb24
          ##END IF
          ##TQC-750167---------------------------------------------------
      ELSE
          UPDATE sfb_file 
             SET sfb13=g_sfb.sfb13,
                 sfb15=g_sfb.sfb15,
                 sfb24=g_sfb.sfb24
           WHERE sfb01 = g_sfb.sfb01
      END IF
  END IF
END FUNCTION 

#FUN-730056------add-------str-----
FUNCTION p520_ins_sfa(l_mo_id,l_sfb02,l_sfb39)
   DEFINE l_mo_id    LIKE apsddo.mo_id
   DEFINE l_ima86    LIKE ima_file.ima86
   DEFINE l_sfb02    LIKE sfb_file.sfb02
   DEFINE l_sfb39    LIKE sfb_file.sfb39
   DEFINE l_sfa13    LIKE sfa_file.sfa13
   DEFINE l_sfa	     RECORD LIKE sfa_file.*
   DEFINE l_bmb	     RECORD LIKE bmb_file.*
   DEFINE l_apsddo   RECORD LIKE apsddo.*
   DEFINE l_total    LIKE sfa_file.sfa07
   DEFINE l_total2   LIKE sfa_file.sfa07
   DEFINE l_sfai     RECORD LIKE sfai_file.*       #No.FUN-7B0018
   DEFINE l_flag     LIKE type_file.chr1           #No.FUN-7B0018
         
   LET g_sql="SELECT ",g_apsdb CLIPPED," apsddo.* ",
             "  FROM ",g_apsdb CLIPPED," apsddo",
             " WHERE mo_id = '",l_mo_id,"'"

   PREPARE p520_ins_sfa_p FROM g_sql
   DECLARE p520_ins_sfa_d CURSOR FOR p520_ins_sfa_p
   INITIALIZE l_sfa.* TO NULL
   LET l_sfa.sfa01 = g_sfb01 #工單編號
   LET l_sfa.sfa02 = l_sfb02 #工單型態
   FOREACH p520_ins_sfa_d INTO l_apsddo.*
                LET l_sfa.sfa03 = l_apsddo.in_pid  #元件編號
                LET l_sfa.sfa04 = l_apsddo.use_qty #原發數量,預計領用量
                LET l_sfa.sfa05 = l_apsddo.use_qty #應發數量,預計領用量
                LET l_sfa.sfa06 =0
                LET l_sfa.sfa061=0
                LET l_sfa.sfa062=0
                LET l_sfa.sfa063=0
                LET l_sfa.sfa064=0
                LET l_sfa.sfa065=0
                LET l_sfa.sfa066=0
                LET l_sfa.sfa07 =0
#-------------------------------
                SELECT * INTO l_bmb.*
                  FROM bmb_file
                 WHERE bmb01 = g_sfb.sfb05
                   AND bmb03 = l_sfa.sfa03
                   AND (bmb04 <=g_sfb.sfb071
                        OR bmb04 IS NULL) 
                   AND (bmb05 > g_sfb.sfb071
                        OR bmb05 IS NULL)

                IF l_bmb.bmb09 IS NOT NULL THEN
                    LET g_opseq =l_bmb.bmb09
                    LET g_offset=l_bmb.bmb18
                END IF
                #-->無製程序號
                IF g_opseq IS NULL THEN LET g_opseq=' ' END IF
                IF g_offset IS NULL THEN LET g_offset=0 END IF
                LET l_sfa.sfa08 =g_opseq  #作業編號 
                LET l_sfa.sfa09 =g_offset #前置時間調整 
                CALL p520_get_sfa11(l_sfa.sfa03,l_sfb39) RETURNING l_sfa.sfa11 #來源碼
                LET l_sfa.sfa12 =l_bmb.bmb10
                LET l_sfa.sfa13 =l_bmb.bmb10_fac
                SELECT ima86 INTO l_ima86
                  FROM ima_file
                 WHERE ima01=l_sfa.sfa03
                LET l_sfa.sfa14 =l_ima86
                LET l_sfa.sfa15 =l_bmb.bmb10_fac2
                LET l_sfa.sfa16 =l_bmb.bmb06
                LET l_sfa.sfa161=l_sfa.sfa05/g_sfb.sfb08 #重計實際QPA 
                LET l_sfa.sfa25 =0
                LET l_sfa.sfa26 =l_bmb.bmb16
                LET l_sfa.sfa27 =l_bmb.bmb03
                LET l_sfa.sfa28 =1
                LET l_sfa.sfa29 =l_sfa.sfa03
                LET l_sfa.sfaacti ='Y'
                LET l_sfa.sfa100 =l_bmb.bmb28
                IF cl_null(l_sfa.sfa100) THEN
                   LET l_sfa.sfa100 = 0
                END IF
#-------------------------------
                INSERT INTO sfa_file VALUES(l_sfa.*)
                IF SQLCA.SQLCODE THEN    #Duplicate
                   #IF SQLCA.SQLCODE=-239 THEN  #FUN-790031
                    IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
                        #因為相同的料件可能有不同的發料單位, 故宜換算之
                        SELECT sfa13 INTO l_sfa13
                          FROM sfa_file
                         WHERE sfa01=g_sfb01
                           AND sfa03=l_bmb.bmb03
                           AND sfa08=g_opseq
                        LET l_sfa13=l_bmb.bmb10_fac/l_sfa13
                        LET l_total=l_total*l_sfa13
                        LET l_total2=l_total2*l_sfa13
                        UPDATE sfa_file
                           SET sfa04=sfa04+l_total,
                               sfa05=sfa05+l_total2,
                               sfa16=sfa16+l_sfa.sfa16,         
                               sfa161=l_sfa.sfa161
                         WHERE sfa01=g_sfb01
                           AND sfa03=l_bmb.bmb03
                           AND sfa08=g_opseq 
                           AND sfa12=l_bmb.bmb10
                           AND sfa27=l_bmb.bmb03     #No:FUN-870051
                        IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                            CALL cl_err3("upd","sfa_file",g_sfb01,"",STATUS,"","upd sfa:",1)  
                        END IF
                    END IF
                #NO.FUN-7B0018 08/02/25 add --begin
                ELSE
                   IF NOT s_industry('std') THEN
                      INITIALIZE l_sfai.* TO NULL
                      LET l_sfai.sfai01 = l_sfa.sfa01
                      LET l_sfai.sfai03 = l_sfa.sfa03
                      LET l_sfai.sfai08 = l_sfa.sfa08
                      LET l_sfai.sfai12 = l_sfa.sfa12
                      LET l_sfai.sfai27 = l_sfa.sfa27   #No:FUN-870051 
                      LET l_flag = s_ins_sfai(l_sfai.*,'')
                   END IF
                #NO.FUN-7B0018 08/02/25 add --end
                END IF
   END FOREACH
END FUNCTION 

FUNCTION p520_get_sfa11(l_ima01,l_sfb39)
   DEFINE l_ima01  LIKE ima_file.ima01
   DEFINE l_ima08  LIKE ima_file.ima08
   DEFINE l_ima70  LIKE ima_file.ima70
   DEFINE l_sfa11  LIKE sfa_file.sfa11
   DEFINE l_sfb39  LIKE sfb_file.sfb39

   SELECT ima08,ima70 INTO l_ima08,l_ima70
     FROM ima_file
    WHERE ima01 = l_ima01

   LET l_sfa11='N'
   IF l_ima08='R' THEN #來源碼
       LET l_sfa11='R'
   ELSE
       IF l_ima70='Y' THEN #消耗料件否
           LET l_sfa11='E'
       ELSE 
           IF l_ima08 MATCHES '[UV]' THEN #來源碼
               LET l_sfa11=l_ima08
           END IF
       END IF 
   END IF
   IF l_sfb39='2' THEN #完工方式
       LET l_sfa11='E' 
   END IF
   RETURN l_sfa11
END FUNCTION

#FUN-730056------add-------end-----
