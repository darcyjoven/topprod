# Prog. Version..: '5.30.06-13.03.19(00009)'     #
#
# Pattern name...: afap202.4gl
# Descriptions...: FA系統傳票拋轉總帳
# Date & Author..: No:FUN-B60140 11/08/22 By xuxz "財簽二二次改善"追單
# Modify.........: No:FUN-BA0112 11/11/07 By Sakura 財簽二5.25與5.1程式比對不一致修改
# Modify.........: No:CHI-BC0026 11/12/16 By ck2yuan 清單無上傳，以mail發出
# Modify.........: No:FUN-BC0035 12/01/16 By Sakura 增加npp00=14判斷
# Modify.........: No:MOD-C40111 12/04/18 By Elise 輸入條件"總帳帳別編號2(p_bookno1)"為01帳，但後續"拋轉總帳日期(gl_date)"仍會與現行帳別(00帳)做比對
# Modify.........: No:FUN-C30313 12/04/18 By Sakura 所有使用fahdmy3欄位判斷的程式全改用fahdmy32
# Modify.........: No:TQC-C60116 12/06/13 By lujh gl_no1欄位開窗沒有將值返回
# Modify.........: No:TQC-C60119 12/06/13 By lujh 錄入user範圍的b_user和e_user欄位目前是帶出當前系統使用者，應同系統中其他作業統一使用範圍為0~z的範圍。
# Modify.........: No:CHI-CB0004 12/11/12 By Belle 修改總號計算方式
# Modify.........: No.CHI-C80041 12/12/22 By bart 排除作廢
# Modify.........: No.MOD-CC0100 12/12/13 By Polly 財簽二動態抓取單號長度

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_aba            RECORD LIKE aba_file.*
DEFINE g_aac            RECORD LIKE aac_file.*
DEFINE g_wc,g_sql       STRING               
DEFINE g_dbs_gl         LIKE type_file.chr21 
DEFINE gl_no            LIKE aba_file.aba01  
DEFINE gl_no_b,gl_no_e  LIKE aba_file.aba01  
DEFINE p_plant          LIKE npp_file.npp06  
DEFINE p_plant_old      LIKE npp_file.npp06  
DEFINE p_bookno         LIKE aaa_file.aaa01  
DEFINE p_bookno1        LIKE aaa_file.aaa01  
DEFINE gl_no_b1,gl_no_e1  LIKE aba_file.aba01
DEFINE gl_no1           LIKE aba_file.aba01  
DEFINE gl_date          LIKE type_file.dat   
DEFINE gl_tran          LIKE type_file.chr1  
DEFINE g_t1             LIKE type_file.chr5  
DEFINE gl_seq           LIKE type_file.chr1  
DEFINE b_user,e_user    LIKE type_file.chr20 
DEFINE g_yy,g_mm        LIKE type_file.num5  
DEFINE g_statu          LIKE type_file.chr1  
DEFINE g_aba01t         LIKE aba_file.aba01  
DEFINE p_row,p_col      LIKE type_file.num5  
DEFINE g_npp00          LIKE npp_file.npp00  
DEFINE g_flag           LIKE type_file.num5  
DEFINE g_cnt            LIKE type_file.num10 
DEFINE g_i              LIKE type_file.num5  
DEFINE g_j              LIKE type_file.num5, 
       g_change_lang    LIKE type_file.chr1  
DEFINE g_zero           LIKE type_file.chr1  
DEFINE g_aaz85          LIKE aaz_file.aaz85 #傳票是否自動確認  
DEFINE g_npp01          DYNAMIC ARRAY OF LIKE npp_file.npp01  
DEFINE g_cnt2           LIKE type_file.num10      

MAIN
   DEFINE ls_date       STRING                 
   DEFINE l_flag        LIKE type_file.chr1   
   DEFINE l_tmn02       LIKE tmn_file.tmn02  
   DEFINE l_tmn06       LIKE tmn_file.tmn06 

   OPTIONS
#      FORM LINE     FIRST + 2,
#      MESSAGE LINE  LAST,
#      PROMPT LINE   LAST,
      INPUT NO WRAP
   DEFER INTERRUPT

   INITIALIZE g_bgjob_msgfile TO NULL

   LET g_wc     = ARG_VAL(1)             #QBE條件
   LET b_user   = ARG_VAL(2)             #輸入user範圍
   LET e_user   = ARG_VAL(3)             #輸入user範圍
   LET p_plant  = ARG_VAL(4)             #總帳營運中心編號
   LET p_bookno = ARG_VAL(5)             #總帳帳別編號
   LET gl_no    = ARG_VAL(6)             #總帳傳票單別
   LET ls_date  = ARG_VAL(7)             #總帳傳票日期
   LET gl_date  = cl_batch_bg_date_convert(ls_date)
   LET gl_tran  = ARG_VAL(8)             #應拋轉摘要
   LET gl_seq   = ARG_VAL(9)             #傳票彙總方式
   LET g_bgjob  = ARG_VAL(10)            #背景作業
   LET p_bookno1= ARG_VAL(11)             #總帳帳別編號2    
   LET gl_no1   = ARG_VAL(12)             #總帳傳票單別2   
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF

   IF g_faa.faa31 = 'N' THEN
      CALL cl_err('','afa-260',1)
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   CALL p202_create_tmp() 

   DROP TABLE agl_tmp_file                                                                                                           

   CREATE TEMP TABLE agl_tmp_file
   (tc_tmp00     LIKE type_file.chr1 NOT NULL,
    tc_tmp01     LIKE type_file.num5,  
    tc_tmp02     LIKE type_file.chr20, 
    tc_tmp03     LIKE type_file.chr8)

   IF STATUS THEN CALL cl_err('create tmp',STATUS,0) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM 
   END IF   

   CREATE UNIQUE INDEX tc_tmp_01 on agl_tmp_file (tc_tmp02,tc_tmp03) 

   IF STATUS THEN CALL cl_err('create index',STATUS,0) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM 
   END IF 

    DECLARE tmn_del CURSOR FOR                                                                                                      
     SELECT tc_tmp02,tc_tmp03 FROM agl_tmp_file WHERE tc_tmp00 = 'Y'                                                               

   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p202_ask()
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL cl_wait()
            LET p_row = 19 LET p_col = 20
            LET g_faa.faa02b = p_bookno    # 得帳別
            LET g_faa.faa02c = p_bookno1   # 得帳別
            OPEN WINDOW afap202_t_w9 AT p_row,p_col WITH 3 ROWS, 70 COLUMNS
            CALL cl_set_win_title("afap202_t_w9")
            CALL p202_t('1')
            CALL s_showmsg() 
            CLOSE WINDOW afap202_t_w9
            IF g_success = 'Y' THEN
               IF NOT cl_null(gl_no_b) THEN
                  CALL s_m_prtgl(g_plant_new,g_faa.faa02c,gl_no_b1,gl_no_e1)#FUN-B60140  mod g_dbs->g_plant_new
               END IF
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p202
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         BEGIN WORK
         LET g_faa.faa02b = p_bookno    # 得帳別
         LET g_faa.faa02c = p_bookno1   # 得帳別
         CALL p202_t('1')
         CALL s_showmsg()  
         IF g_success = "Y" THEN
            IF NOT cl_null(gl_no_b) THEN
               CALL s_m_prtgl(g_plant_new,g_faa.faa02c,gl_no_b1,gl_no_e1) #FUN-B60140  mod g_dbs->g_plant_new
            END IF
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   FOREACH tmn_del INTO l_tmn02,l_tmn06                                                                                            

      DELETE FROM tmn_file                                                                                                         
      WHERE tmn01 = p_plant                                                                                                        
        AND tmn02 = l_tmn02                                                                                                        
        AND tmn06 = l_tmn06                                                                                                        

   END FOREACH                                                                                                                     

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 

END MAIN

FUNCTION p202()

   CALL p202_ask()      # Ask for first_flag, data range or exist_no

   IF INT_FLAG THEN RETURN END IF

   IF NOT cl_sure(20,20) THEN   
      CALL cl_wait()
      LET g_faa.faa02b = p_bookno  # 得帳別
      LET p_row = 19 LET p_col = 20
      OPEN WINDOW p202_t_w9 AT 19,4 WITH 3 ROWS, 70 COLUMNS 
   #  CALL cl_set_win_title("afaep202_t_w9") #No:FUN-BA0112 mark
      CALL cl_set_win_title("afap202_t_w9") #No:FUN-BA0112 add 
      CALL p202_t('1')
   END IF 

   CLOSE WINDOW p202_t_w9

END FUNCTION

FUNCTION p202_ask()
   DEFINE li_chk_bookno   LIKE type_file.num5   
   DEFINE l_aaa07         LIKE aaa_file.aaa07
   DEFINE l_tmn02         LIKE tmn_file.tmn02 
   DEFINE l_tmn06         LIKE tmn_file.tmn06 
   DEFINE l_flag          LIKE type_file.chr1   
   DEFINE li_result       LIKE type_file.num5   
   DEFINE l_cnt           LIKE type_file.num5   
   DEFINE lc_cmd          LIKE type_file.chr1000,
          l_sql           STRING                
   DEFINE l_no            LIKE type_file.chr3   
   DEFINE l_no1           LIKE type_file.chr3   
   DEFINE l_aac03         LIKE aac_file.aac03   
   DEFINE l_aac03_1       LIKE aac_file.aac03   

   OPEN WINDOW p202 AT p_row,p_col WITH FORM "afa/42f/afap202"
     ATTRIBUTE (STYLE = g_win_style)

   CALL cl_ui_init()
   CALL p202_set_comb()

   CALL cl_set_comp_visible("p_bookno,gl_no",FALSE)  

   WHILE TRUE

      CONSTRUCT BY NAME g_wc ON npp00,npp01,npp011,npp02

         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION locale
            LET g_change_lang = TRUE    
           #IF g_aza.aza26 = '2' THEN 
               CALL p202_set_comb()
           #END IF
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
   
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT CONSTRUCT

         ON ACTION qbe_select
            CALL cl_qbe_select()

      END CONSTRUCT

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p202
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF

      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()     
         CONTINUE WHILE             
      END IF

      LET p_plant = g_faa.faa02p 
      LET p_plant_old = p_plant  
      LET p_bookno= g_faa.faa02b 
      LET p_bookno1= g_faa.faa02c
      #LET b_user  = g_user      #TQC-C60119   mark
      LET b_user  = '0'          #TQC-C60119   add
      #LET e_user  = g_user      #TQC-C60119   mark
      LET e_user  = 'z'          #TQC-C60119   add
      LET gl_date = g_today
      LET gl_tran = 'Y' 
      LET gl_seq  = '0'
      LET g_bgjob = 'N' 

      INPUT BY NAME b_user,e_user,p_plant,p_bookno,gl_no,p_bookno1,gl_no1,gl_date,
                    gl_tran,gl_seq,g_bgjob 
            WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)

         AFTER FIELD p_plant
            SELECT azp01 FROM azp_file WHERE azp01 = p_plant
            IF STATUS <> 0 THEN
               NEXT FIELD p_plant
            END IF
            # 得出總帳 database name 
            LET g_plant_new= p_plant  # 工廠編號
            CALL s_getdbs()
            LET g_dbs_gl=g_dbs_new    # 得資料庫名稱
            IF p_plant_old != p_plant THEN 
               FOREACH tmn_del INTO l_tmn02,l_tmn06                                                                                       
                DELETE FROM tmn_file                                                                                                    
                 WHERE tmn01 = p_plant_old                                                                                               
                   AND tmn02 = l_tmn02                                                                                                   
                   AND tmn06 = l_tmn06                                                                                                   
               END FOREACH            
               DELETE FROM agl_tmp_file 
               LET p_plant_old = g_plant_new      
            END IF                               

         AFTER FIELD p_bookno
            IF p_bookno IS NULL THEN
               NEXT FIELD p_bookno
            END IF
            CALL s_check_bookno(p_bookno,g_user,p_plant) RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD p_bookno
            END IF 
            LET g_plant_new= p_plant  # 工廠編號                                                                              
            CALL s_getdbs()                                                                                                    
            LET l_sql = "SELECT COUNT(*) ",                                                                                    
                       # "  FROM ",g_dbs_new CLIPPED,"aaa_file ",  #FUN-B60140 mark
                        "  FROM ",cl_get_target_table(g_plant_new,'aaa_file')  ,#No:FUN-B60140 add                                                             
                        " WHERE aaa01 = '",p_bookno,"' "                                                                          
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #No:FUN-B60140 add
            PREPARE p202_pre3 FROM l_sql                                                                                       
            DECLARE p202_cur3 CURSOR FOR p202_pre3                                                                             
            OPEN p202_cur3                                                                                                     
            FETCH p202_cur3 INTO g_cnt
            IF g_cnt=0 THEN
               CALL cl_err('sel aaa',100,0)
               NEXT FIELD p_bookno
            END IF

         AFTER FIELD p_bookno1
            IF p_bookno1 IS NULL THEN
               NEXT FIELD p_bookno1
            END IF
            IF p_bookno1 = p_bookno THEN
               NEXT FIELD p_bookno1
            END IF
            CALL s_check_bookno(p_bookno1,g_user,p_plant) 
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD p_bookno1
            END IF 
            LET g_plant_new= p_plant  # 工廠編號                                                                              
            CALL s_getdbs()                                                                                                    
            LET l_sql = "SELECT COUNT(*) ",                                                                                    
            #            "  FROM ",g_dbs_new CLIPPED,"aaa_file ", #FUN-B60140 mark
                        "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'),  #No:FUN-B60140 add                                                              
                        " WHERE aaa01 = '",p_bookno1,"' "                                                                          
            CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql   #No:FUN-B60140 add
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            PREPARE p202_pre3_1 FROM l_sql                                                                                       
            DECLARE p202_cur3_1 CURSOR FOR p202_pre3_1                                                                             
            OPEN p202_cur3_1                                                                                                     
            FETCH p202_cur3_1 INTO g_cnt
            IF g_cnt=0 THEN
               CALL cl_err('sel aaa',100,0)
               NEXT FIELD p_bookno1
            END IF
         
         AFTER FIELD gl_no1
            CALL s_check_no("agl",gl_no1,"","1","","",g_plant_new) #FUN-60140  g_dbs->g_plant_new
                 RETURNING li_result,g_t1 
            IF (NOT li_result) THEN
                NEXT FIELD gl_no1
            END IF
            LET l_no1 = gl_no1                                                        
            SELECT aac03 INTO l_aac03_1 FROM aac_file WHERE aac01= l_no1               
            IF l_aac03_1 != '0' THEN                                                  
               CALL cl_err(gl_no1,'agl-991',0)                                       
               NEXT FIELD gl_no1                                                     
            END IF                                                                  
         
         AFTER FIELD b_user
            IF b_user IS NULL THEN
               NEXT FIELD b_user 
            END IF
         
         AFTER FIELD e_user
            IF e_user IS NULL THEN
               NEXT FIELD e_user 
            END IF
            IF e_user = 'Z' THEN 
               LET e_user='z'
               DISPLAY BY NAME e_user 
            END IF
         
         AFTER FIELD gl_no
            CALL s_check_no("agl",gl_no,"","1","","",g_plant_new) #FUN-B60140 g_dbs->g_plant_new
                 RETURNING li_result,g_t1 
            IF (NOT li_result) THEN
                NEXT FIELD gl_no
            END IF
            LET l_no = gl_no                                                        
            SELECT aac03 INTO l_aac03 FROM aac_file WHERE aac01= l_no               
            IF l_aac03 != '0' THEN                                                  
               CALL cl_err(gl_no,'agl-991',0)                                       
               NEXT FIELD gl_no                                                     
            END IF                                                                  
         
         AFTER FIELD gl_date
            IF gl_date IS NULL THEN
               NEXT FIELD gl_date
            END IF
           #SELECT aaa07 INTO l_aaa07 FROM aaa_file WHERE aaa01 = p_bookno   #MOD-C40111 mark
            SELECT aaa07 INTO l_aaa07 FROM aaa_file WHERE aaa01 = p_bookno1  #MOD-C40111
            IF gl_date <= l_aaa07 THEN    
               CALL cl_err('','axm-164',0) NEXT FIELD gl_date
            END IF
            SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01 = gl_date
            IF STATUS THEN
               CALL cl_err3("sel","azn_file",gl_date,"",SQLCA.sqlcode,"","anm-946",0)   
               NEXT FIELD gl_date
            END IF
         
         AFTER FIELD gl_seq  
            IF cl_null(gl_seq) OR gl_seq NOT MATCHES '[012]' THEN
               NEXT FIELD gl_seq 
            END IF
         
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            LET l_flag='N'
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF cl_null(p_plant)    THEN
               LET l_flag='Y'
            END IF
            IF cl_null(p_bookno)   THEN 
               LET l_flag='Y'
            END IF
            IF gl_no1[1,g_doc_len] IS NULL or gl_no1[1,g_doc_len] = ' ' THEN    
               LET l_flag='Y'
            END IF
            IF cl_null(gl_date)    THEN
               LET l_flag='Y'
            END IF
            IF cl_null(gl_tran)    THEN 
               LET l_flag='Y'
            END IF
            IF cl_null(gl_seq)     THEN
               LET l_flag='Y'
            END IF
            IF l_flag='Y' THEN
               CALL cl_err('','9033',0)
               NEXT FIELD p_plant
            END IF
            # 得出總帳 database name
            # g_apz.apz02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl
            LET g_plant_new= p_plant  # 工廠編號
            CALL s_getdbs()
            LET g_dbs_gl=g_dbs_new    # 得資料庫名稱
            SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01 = gl_date
            IF STATUS THEN
               CALL cl_err3("sel","azn_file",gl_date,"",SQLCA.sqlcode,"","anm-946",0)   
               NEXT FIELD gl_date
            END IF
         
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         
         ON ACTION CONTROLG
            CALL cl_cmdask()
         
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(gl_no)
                  CALL q_m_aac(FALSE,TRUE,g_plant_new,gl_no,'1','0',' ','AGL') RETURNING gl_no  #FUN-B60140 g_dbs->g_plant_new
                  DISPLAY BY NAME gl_no
                  NEXT FIELD gl_no
               WHEN INFIELD(gl_no1)
                  #CALL q_m_aac(FALSE,TRUE,g_dbs_gl,gl_no1,'1','0',' ','AGL') RETURNING gl_no1 #FUN-B60140 mark
                  #CALL q_m_aac(FALSE,TRUE,g_plant_new,gl_no,'1','0',' ','AGL') RETURNING gl_no  #FUN-B60140 add     #TQC-C60116  mark
                  CALL q_m_aac(FALSE,TRUE,g_plant_new,gl_no1,'1','0',' ','AGL') RETURNING gl_no1   #TQC-C60116  add
                  DISPLAY BY NAME gl_no1
                  NEXT FIELD gl_no1
               OTHERWISE 
                  EXIT CASE
            END CASE
         
         ON ACTION get_missing_voucher_no     
            IF cl_null(gl_no) AND cl_null(gl_no1) THEN  
               NEXT FIELD gl_no             
            END IF                         
                                          
            FOREACH tmn_del INTO l_tmn02,l_tmn06                                                                                       

               DELETE FROM tmn_file                                                                                                    
                WHERE tmn01 = p_plant
                  AND tmn02 = l_tmn02                                                                                                   
                  AND tmn06 = l_tmn06                                                                                                   

            END FOREACH            

            DELETE FROM agl_tmp_file      
                                        
            CALL s_agl_missingno(p_plant,g_plant_new,p_bookno,gl_no,p_bookno1,gl_no1,gl_date,0) #FUN-B60140 g_dbs->g_plant_new
                                                       
            SELECT COUNT(*) INTO l_cnt FROM agl_tmp_file 
             WHERE tc_tmp00='Y'                       
            IF l_cnt > 0 THEN                        
               CALL cl_err(l_cnt,'aap-501',0)       
            ELSE                                   
               CALL cl_err('','aap-502',0)        
            END IF                 
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         
         ON ACTION about         
            CALL cl_about()     
         
         ON ACTION help         
            CALL cl_show_help() 
         
         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
         
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
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
         CLOSE WINDOW p202
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF

      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "afap202"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('afap202','9031',1)  
         ELSE
            LET g_wc=cl_replace_str(g_wc, "'", "\"")
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_wc CLIPPED,"'",
                         " '",b_user   CLIPPED,"'",
                         " '",e_user   CLIPPED,"'",
                         " '",p_plant  CLIPPED,"'",
                         " '",p_bookno CLIPPED,"'",
                         " '",gl_no    CLIPPED,"'",
                         " '",gl_date  CLIPPED,"'",
                         " '",gl_tran  CLIPPED,"'",
                         " '",gl_seq   CLIPPED,"'",
                         " '",g_bgjob    CLIPPED,"'",
                         " '",p_bookno1  CLIPPED,"'",     
                         " '",gl_no1   CLIPPED,"'"        
            CALL cl_cmdat('afap202',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p202
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF

      EXIT WHILE

   END WHILE

END FUNCTION

FUNCTION p202_t(l_npptype)
   DEFINE l_npptype     LIKE npp_file.npptype
   DEFINE l_npp         RECORD LIKE npp_file.*
   DEFINE l_npq         RECORD LIKE npq_file.*
   DEFINE l_cmd         LIKE type_file.chr1000
   DEFINE l_order       LIKE npp_file.npp01   
   DEFINE l_remark      LIKE type_file.chr1000
   DEFINE l_name        LIKE type_file.chr20  
   DEFINE fa_date       LIKE type_file.dat    
   DEFINE fa_glno       LIKE faq_file.faq06   
   DEFINE fa_conf       LIKE fba_file.fbaconf 
   DEFINE fa_post       LIKE fba_file.fbapost 
   DEFINE fa_user       LIKE fba_file.fbauser 
   DEFINE l_flag        LIKE type_file.chr1   
   DEFINE l_yy,l_mm     LIKE type_file.num5   
   DEFINE l_msg         LIKE type_file.chr1000
   DEFINE l_sql         STRING 
   DEFINE g_cnt1        LIKE type_file.num10 
   DEFINE l_npp00       LIKE npp_file.npp00  
   DEFINE l_npp01       LIKE npp_file.npp01  
  #DEFINE l_fahdmy3     LIKE fah_file.fahdmy3  #FUN-C30313 mark 
   DEFINE l_fahdmy32    LIKE fah_file.fahdmy32 #FUN-C30313 add
   DEFINE l_t1          LIKE type_file.chr5  
   DEFINE l_aba11       LIKE aba_file.aba11  
   DEFINE i             LIKE type_file.num10 
   DEFINE l_flag2       LIKE type_file.chr1  
   DEFINE l_aaa07       LIKE aaa_file.aaa07  
   DEFINE l_npp02_b     LIKE npp_file.npp02  
   DEFINE l_npp02_e     LIKE npp_file.npp02  
   DEFINE l_yn          LIKE type_file.chr1  
   DEFINE l_yy1         LIKE type_file.num5          #CHI-CB0004
   DEFINE l_mm1         LIKE type_file.num5          #CHI-CB0004
  
   IF NOT cl_null(gl_date) THEN
      IF l_npptype ='0' THEN
         SELECT aaa07 INTO l_aaa07 FROM aaa_file
          WHERE aaa01 = p_bookno
      ELSE
         SELECT aaa07 INTO l_aaa07 FROM aaa_file
          WHERE aaa01 = p_bookno1
      END IF
      IF gl_date <= l_aaa07 THEN
         IF g_bgjob = 'Y' THEN
            CALL s_errmsg('','','','axr-164',1)
         ELSE
            CALL cl_err('','axr-164',0)
         END IF
         LET g_success ='N'
         RETURN
      END IF
   END IF

   #LET l_sql = " SELECT aznn02,aznn04 FROM ",g_dbs_gl,"aznn_file",      #No:FUN-B60140 mark 
   LET l_sql = " SELECT aznn02,aznn04 FROM ",cl_get_target_table(g_plant_new,'aznn_file'),  #No:FUN-B60140 add                      
               "  WHERE aznn01 = '",gl_date,"' ",                               
               "    AND aznn00 = '",p_bookno1,"' "                            
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql	
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #No:FUN-B60140 add
   PREPARE aznn_pre1 FROM l_sql                                                 
   DECLARE aznn_cs1 CURSOR FOR aznn_pre1                                        
   OPEN aznn_cs1                                                               
   FETCH aznn_cs1 INTO g_yy,g_mm

   IF STATUS THEN  
      CALL cl_err3("sel","azn_file",gl_date,"",SQLCA.sqlcode,"","anm-946",0) 
      LET g_success = 'N'
      RETURN
   END IF

   LET g_success='Y'

   IF g_aaz.aaz81 = 'Y' THEN
      LET l_yy = YEAR(gl_date)    #CHI-CB0004
      LET l_mm = MONTH(gl_date)   #CHI-CB0004
      #LET g_sql = "SELECT MAX(aba11)+1 FROM ",g_dbs_gl,"aba_file", #No:FUN-B60140 mark
      LET g_sql = "SELECT MAX(aba11)+1 FROM ",cl_get_target_table(g_plant_new,'aba_file'),  #No:FUN-B60140 add
                  " WHERE aba00 =  '",p_bookno1,"'",
                  "   ANd aba19 <> 'X' ",  #CHI-C80041
                  "   AND YEAR(aba02) = '",l_yy,"' AND MONTH(aba02) = '",l_mm,"'"  #CHI-CB0004
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #No:FUN-B60140 add
      PREPARE aba11_pre FROM g_sql
      EXECUTE aba11_pre INTO l_aba11
      
     #CHI-CB0004--(B)
      IF cl_null(l_aba11) OR l_aba11 = 1 THEN
         LET l_aba11 = YEAR(gl_date)*1000000+MONTH(gl_date)*10000+1
      END IF
     #CHI-CB0004--(E)
     #IF cl_null(l_aba11) THEN LET l_aba11 = 1 END IF  #CHI-CB0004
      LET g_aba.aba11 = l_aba11
   ELSE 
      LET g_aba.aba11 = ' '        
   END IF      
   
   #是否自動傳票確認
   #LET g_sql = "SELECT aaz85 FROM ",g_dbs_gl CLIPPED,"aaz_file",#No:FUN-B60140 mark
   LET g_sql = "SELECT aaz85 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),  #No:FUN-B60140 add
               " WHERE aaz00 = '0' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #No:FUN-B60140 add
   PREPARE aaz85_pre FROM g_sql
   DECLARE aaz85_cs CURSOR FOR aaz85_pre
   OPEN aaz85_cs
   FETCH aaz85_cs INTO g_aaz85
   IF STATUS THEN
      LET g_success = 'N'
      CALL cl_err('sel aaz85',STATUS,1)
      RETURN
   END IF
 
   LET l_npp02_b = MDY(MONTH(gl_date),1,YEAR(gl_date))     #取得當月第一天
   LET l_npp02_e = s_monend(YEAR(gl_date),MONTH(gl_date))  #取得當月最後一天

   #check 所選的資料中其分錄日期不可和總帳傳票日期有不同年月
   LET g_sql="SELECT UNIQUE YEAR(npp02),MONTH(npp02),npp00,npp01 ",
             "  FROM npp_file ",
             " WHERE nppsys= 'FA' AND (nppglno IS NULL OR nppglno='')",
             "   AND (npp00 <> 0 OR npp00 <> 2) ",
             "   AND npptype = '",l_npptype,"' AND ",g_wc CLIPPED,
             "   AND npp02 NOT BETWEEN '",l_npp02_b,"' AND '",l_npp02_e,"'"

   PREPARE p202_0_p0 FROM g_sql
   IF STATUS THEN CALL cl_err('p202_0_p0',STATUS,1) RETURN END IF
   DECLARE p202_0_c0 CURSOR WITH HOLD FOR p202_0_p0

   LET l_flag='N'

   FOREACH p202_0_c0 INTO l_yy,l_mm,l_npp00,l_npp01
      IF l_npp00 != 10 AND l_npp00 != 11 AND l_npp00 != 12 THEN
         #LET l_fahdmy3 = '' #FUN-C30313 mark
         LET l_fahdmy32 = '' #FUN-C30313 add
         LET l_t1 = l_npp01[1,g_doc_len]
         #SELECT fahdmy3 INTO l_fahdmy3 FROM fah_file  #FUN-C30313 mark
         SELECT fahdmy32 INTO l_fahdmy32 FROM fah_file #FUN-C30313 add
           WHERE fahslip = l_t1
         #IF l_fahdmy3 <> 'Y' THEN #FUN-C30313 mark
         IF l_fahdmy32 <> 'Y' THEN #FUN-C30313 add
            CONTINUE FOREACH
         END IF
      END IF
      LET l_flag='Y'
      EXIT FOREACH
   END FOREACH

   IF l_flag ='Y' THEN
      LET g_success='N'
      CALL cl_err('err:','axr-061',1)
      RETURN
   END IF

   LET g_sql="SELECT npp_file.*,npq_file.* ", 
             "  FROM npp_file,npq_file ",
             " WHERE nppsys= 'FA' AND (nppglno IS NULL OR nppglno='')",
             "   AND npp01 = npq01 AND npp011=npq011",
             "   AND npp00 = npq00 ",
             "   AND npptype = '",l_npptype,"' AND npptype = npqtype AND nppsys = npqsys AND npp00=npq00 AND ",g_wc CLIPPED, 
             "   AND (npp00 <> 0 OR npp00 <> 2) "

   CASE
      WHEN gl_seq = '0' 
         LET g_sql = g_sql CLIPPED," ORDER BY npq06,npq03,npq05,npq24,npq25"
      WHEN gl_seq = '1'
         LET g_sql = g_sql CLIPPED," ORDER BY npq01,npq06,npq03,npq05,npq24,npq25"
      WHEN gl_seq = '2'
         LET g_sql = g_sql CLIPPED," ORDER BY npq02,npq06,npq03,npq05,npq24,npq25"
      OTHERWISE      
         LET g_sql = g_sql CLIPPED," ORDER BY npq06,npq03,npq05,npq24,npq25"
   END CASE

   IF gl_tran = 'N' THEN 
      LET g_sql = g_sql CLIPPED,",npq11,npq12,npq13,npq14,npq15,npq08,npq01"
   ELSE 
      LET g_sql = g_sql CLIPPED,",npq04,npq11,npq12,npq13,npq14,npq15,npq08"
   END IF

   PREPARE p202_1_p0 FROM g_sql
   IF STATUS THEN CALL cl_err('p202_1_p0',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM 
      LET g_success = 'N'
   END IF

   DECLARE p202_1_c0 CURSOR WITH HOLD FOR p202_1_p0

   CALL cl_outnam('afap202') RETURNING l_name

   IF l_npptype = '0' THEN
      START REPORT afap202_rep TO l_name
   ELSE
      START REPORT afap202_1_rep TO l_name
   END IF

   LET g_cnt1 = 0

   WHILE TRUE  
      CALL s_showmsg_init()
      CALL g_npp01.clear() 
      LET g_cnt2 = 1 
      LET l_yn='N'  

      FOREACH p202_1_c0 INTO l_npp.*,l_npq.*
         LET l_yn='Y'  
         IF STATUS THEN
            CALL s_errmsg('','','foreach:',STATUS,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF

         IF g_success='N' THEN                                                                                                         
            LET g_totsuccess='N'                                                                                                       
            LET g_success="Y"                                                                                                          
         END IF                                                                                                                        

         IF l_npp.npp00 != 10 AND l_npp.npp00 != 11 AND l_npp.npp00 != 12 THEN
            #LET l_fahdmy3 = '' #FUN-C30313 mark
            LET l_fahdmy32 = ''  #FUN-C30313 add
            LET l_t1 = l_npp.npp01[1,g_doc_len]
            #SELECT fahdmy3 INTO l_fahdmy3 FROM fah_file  #FUN-C30313 mark
            SELECT fahdmy32 INTO l_fahdmy32 FROM fah_file #FUN-C30313 add  
             WHERE fahslip = l_t1
            #IF l_fahdmy3 <> 'Y' THEN #FUN-C30313 mark 
            IF l_fahdmy32 <> 'Y' THEN  #FUN-C30313 add
               CONTINUE FOREACH
            END IF
         END IF

         CASE WHEN l_npp.nppsys='FA' AND l_npp.npp00=1 
                 SELECT faq02,faq06,faqconf,faquser,faqpost  
                   INTO fa_date,fa_glno,fa_conf,fa_user,fa_post 
                   FROM faq_file WHERE faq01=l_npp.npp01
                 IF STATUS THEN
                    CALL s_errmsg('faq01',l_npp.npp01,'sel faq:',STATUS,1)  
                    LET g_success='N' 
                 END IF
              WHEN l_npp.nppsys='FA' AND l_npp.npp00=2 
                 SELECT fas02,fas07,fasconf,fasuser,faspost 
                   INTO fa_date,fa_glno,fa_conf,fa_user,fa_post
                   FROM fas_file WHERE fas01=l_npp.npp01
                 IF STATUS THEN
                    CALL s_errmsg('fas01',l_npp.npp01,'sel fas:',STATUS,1)  
                    LET g_success='N' 
                 END IF
              #FUN-BC0035---begin add
              WHEN l_npp.nppsys='FA' AND l_npp.npp00=14
                   SELECT fbx02,fbx07,fbxconf,fbxuser,fbxpost
                     INTO fa_date,fa_glno,fa_conf,fa_user,fa_post
                     FROM fbx_file WHERE fbx01=l_npp.npp01
                   IF STATUS THEN
                      CALL s_errmsg('fbx01',l_npp.npp01,'sel fbx:',STATUS,1)
                      LET g_success='N'
                   END IF              
              #FUN-BC0035---end add
              WHEN l_npp.nppsys='FA' AND l_npp.npp00=4
                 SELECT fbe02,fbe14,fbeconf,fbeuser,fbepost 
                   INTO fa_date,fa_glno,fa_conf,fa_user,fa_post 
                   FROM fbe_file WHERE fbe01=l_npp.npp01
                 IF STATUS THEN
                    CALL s_errmsg('fbe01',l_npp.npp01,'sel fbe:',STATUS,1)  
                    LET g_success='N'
                 END IF
              WHEN l_npp.nppsys='FA' AND (l_npp.npp00=5 OR l_npp.npp00=6)
                 SELECT fbg02,fbg08,fbgconf,fbguser,fbgpost 
                   INTO fa_date,fa_glno,fa_conf,fa_user,fa_post 
                   FROM fbg_file WHERE fbg01=l_npp.npp01
                 IF STATUS THEN
                    CALL s_errmsg('fbg01',l_npp.npp01,'sel fbg:',STATUS,1)   
                    LET g_success='N'
                 END IF
              WHEN l_npp.nppsys='FA' AND l_npp.npp00=7
                 SELECT fay02,fay06,fayconf,fayuser,faypost1 
                   INTO fa_date,fa_glno,fa_conf,fa_user,fa_post 
                   FROM fay_file WHERE fay01=l_npp.npp01
                 IF STATUS THEN
                    CALL s_errmsg('fay01',l_npp.npp01,'sel fay:',STATUS,1)    
                    LET g_success='N'
                 END IF
              WHEN l_npp.nppsys='FA' AND l_npp.npp00=8
                 SELECT fba02,fba06,fbaconf,fbauser,fbapost1
                   INTO fa_date,fa_glno,fa_conf,fa_user,fa_post 
                   FROM fba_file WHERE fba01=l_npp.npp01
                 IF STATUS THEN
                    CALL s_errmsg('fba01',l_npp.npp01,'sel fba:',STATUS,1)  
                    LET g_success='N'
                 END IF
              WHEN l_npp.nppsys='FA' AND l_npp.npp00=9
                 SELECT fbc02,fbc06,fbcconf,fbcuser,fbcpost1
                   INTO fa_date,fa_glno,fa_conf,fa_user,fa_post
                   FROM fbc_file WHERE fbc01=l_npp.npp01
                 IF STATUS THEN
                    CALL s_errmsg('fbc01',l_npp.npp01,'sel fbc:',STATUS,1) 
                    LET g_success='N'
                 END IF
              WHEN l_npp.nppsys='FA' AND l_npp.npp00=10
                 LET fa_date = l_npp.npp02
                 #當npp00=10時,抓取當年度/期別(fbn03/fbn04)fbn資料筆數不可為0
                 LET g_cnt = 0
                 SELECT COUNT(*) INTO g_cnt FROM fbn_file
                  WHERE fbn03=g_yy AND fbn04=g_mm  
                 IF cl_null(g_cnt) THEN LET g_cnt = 0 END IF
                 IF g_cnt = 0 THEN
                    LET l_msg = YEAR(fa_date)+"/"+MONTH(fa_date)
                    CALL s_errmsg('fbn04',l_msg,'','afa-927',1) 
                    LET g_success='N'
                 END IF
                 LET l_flag2 = 'N' 
                 FOR i = 1 TO g_npp01.getlength()
                     IF g_npp01[i] = l_npp.npp01 THEN
                        LET l_flag2 = 'Y'
                        EXIT FOR
                     END IF
                 END FOR
                 IF l_flag2 = 'N' THEN 
                    LET g_npp01[g_cnt2]=l_npp.npp01
                    LET g_cnt2 = g_cnt2 + 1
                    CALL s_chknpq(l_npp.npp01,'FA',1,'1',p_bookno1)
                 END IF 
              WHEN l_npp.nppsys='FA' AND l_npp.npp00=11  #利息－資本化
                 LET fa_date = l_npp.npp02 
              WHEN l_npp.nppsys='FA' AND l_npp.npp00=12  #保險
                 LET fa_date = l_npp.npp02
              WHEN l_npp.nppsys='FA' AND l_npp.npp00=13  #減值準備              
                 SELECT fbs02,fbs04,fbsconf,fbsuser,fbspost1  
                   INTO fa_date,fa_glno,fa_conf,fa_user,fa_post
                   FROM fbs_file WHERE fbs01=l_npp.npp01                      
                 IF STATUS THEN                                               
                    CALL s_errmsg('fbs01',l_npp.npp01,'sel fbs:',STATUS,1) 
                    LET g_success='N'
                 END IF                                                       
              OTHERWISE
                 CONTINUE FOREACH
         END CASE

         IF g_success='N' THEN CONTINUE FOREACH END IF 
         IF fa_conf='N' THEN CONTINUE FOREACH END IF
         IF fa_conf='X' THEN CONTINUE FOREACH END IF
         IF fa_post='N' THEN CONTINUE FOREACH END IF 
         IF fa_post='X' THEN CONTINUE FOREACH END IF  
         IF fa_user<b_user OR fa_user>e_user THEN CONTINUE FOREACH END IF
         IF l_npptype ='0' THEN
            IF fa_glno IS NOT NULL THEN CONTINUE FOREACH END IF
         END IF

         IF l_npp.npp011=1 AND fa_date<>l_npp.npp02 THEN
            LET l_msg= "Date differ:",fa_date,'-',l_npp.npp02,
                       "  * Press any key to continue ..."
            CALL cl_msgany(19,4,l_msg)
            LET INT_FLAG = 0  ######add for prompt bug
         END IF

         IF l_npq.npq04 = ' ' THEN LET l_npq.npq04 = NULL END IF

         IF gl_tran = 'N' THEN 
            LET l_npq.npq04 = NULL 
            LET l_remark = l_npq.npq11 clipped,l_npq.npq12 clipped,
                           l_npq.npq13 clipped,l_npq.npq14 clipped,
                           l_npq.npq31 clipped,l_npq.npq32 clipped,
                           l_npq.npq33 clipped,l_npq.npq34 clipped,
                           l_npq.npq35 clipped,l_npq.npq36 clipped,
                           l_npq.npq37 clipped,
                           l_npq.npq15 clipped,l_npq.npq08 clipped
         ELSE
            LET l_remark = l_npq.npq04 clipped,l_npq.npq11 clipped,
                           l_npq.npq12 clipped,l_npq.npq13 clipped,
                           l_npq.npq14 clipped,
                           l_npq.npq31 clipped,l_npq.npq32 clipped,
                           l_npq.npq33 clipped,l_npq.npq34 clipped,
                           l_npq.npq35 clipped,l_npq.npq36 clipped,
                           l_npq.npq37 clipped,
                           l_npq.npq15 clipped,
                           l_npq.npq08 clipped
         END IF

         CASE WHEN gl_seq = '0' LET l_order = ' '         # 傳票區分項目
              WHEN gl_seq = '1' LET l_order = l_npp.npp01 # 依單號
              WHEN gl_seq = '2' LET l_order = l_npp.npp02 # 依日期
              OTHERWISE         LET l_order = ' '
         END CASE

         IF cl_null(l_remark) THEN LET l_remark = ' '  END IF 

         INSERT INTO p202_tmp VALUES(l_order,l_npp.*,l_npq.*,l_remark)
         IF SQLCA.SQLCODE THEN
            CALL cl_err3("ins","p202_tmp",l_order,l_npp.npp01,STATUS,"","l_order:",1) 
            LET g_success = 'N' 
         END IF

         LET g_cnt1 = g_cnt1 + 1

      END FOREACH

      IF g_totsuccess="N" THEN                                                                                                        
         LET g_success="N"                                                                                                            
      END IF                                                                                                                          

      DECLARE p202_tmpcs CURSOR FOR
          SELECT * FROM p202_tmp
          ORDER BY order1,npq06,npq03,npq05,
                   npq24,npq25,remark1,npq01

      FOREACH p202_tmpcs INTO l_order,l_npp.*,l_npq.*,l_remark
         IF STATUS THEN
            CALL s_errmsg('','','order:',STATUS,1)
            LET g_success='N'
            EXIT FOREACH
         END IF

         IF g_success='N' THEN                                                                                                         
            LET g_totsuccess='N'                                                                                                       
            LET g_success="Y"                                                                                                          
         END IF                                                                                                                        

         IF l_npptype = '0' AND l_npp.npptype = '0' THEN
            OUTPUT TO REPORT afap202_rep(l_order,l_npp.*,l_npq.*,l_remark)
         END IF

         IF l_npptype = '1' AND l_npp.npptype = '1' THEN
            OUTPUT TO REPORT afap202_1_rep(l_order,l_npp.*,l_npq.*,l_remark)
         END IF

      END FOREACH

      IF g_totsuccess="N" THEN                                                                                                        
         LET g_success="N"                                                                                                            
      END IF                                                                                                                          

      EXIT WHILE
   END WHILE

   IF l_yn='Y' THEN 
      IF l_npptype = '0' THEN
         FINISH REPORT afap202_rep
      ELSE
         FINISH REPORT afap202_1_rep
      END IF
   END IF 

   #LET l_cmd = "chmod 777 ", l_name                           #CHI-BC0026 mark
   LET l_cmd = "chmod 777 $TEMPDIR/", l_name, " 2>/dev/null"   #CHI-BC0026 add
   RUN l_cmd

   IF g_cnt1 = 0  THEN                                                          
      CALL s_errmsg('','','','aap-129',1) 
      LET g_success = 'N'                                                       
   END IF            

   DELETE FROM p202_tmp 

END FUNCTION

REPORT afap202_rep(l_order,l_npp,l_npq,l_remark)
   DEFINE l_order       LIKE npp_file.npp01      
   DEFINE l_npp         RECORD LIKE npp_file.*
   DEFINE l_npq         RECORD LIKE npq_file.*
   DEFINE l_seq         LIKE type_file.num5         # 傳票項次   
   DEFINE l_credit,l_debit,l_amt,l_amtf LIKE type_file.num20_6    
   DEFINE l_no           LIKE fcx_file.fcx01       
   DEFINE l_no1          STRING                 
   DEFINE l_remark       LIKE type_file.chr1000  
   DEFINE l_aba06        LIKE aba_file.aba06     
   DEFINE l_number       LIKE type_file.num5    
   DEFINE l_no2          LIKE type_file.chr1     
   DEFINE l_yes          LIKE type_file.chr1      
   DEFINE li_result      LIKE type_file.num5      
   DEFINE l_missingno    LIKE aba_file.aba01       
   DEFINE l_flag1        LIKE type_file.chr1        
   #DEFINE l_success      LIKE type_file.num5        
 
   OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line

   ORDER EXTERNAL BY l_order,l_npq.npq06,l_npq.npq03,l_npq.npq05,
                     l_npq.npq24,l_npq.npq25,l_remark,l_npq.npq01
   FORMAT
      #--------- Insert aba_file ---------------------------------------------
      BEFORE GROUP OF l_order
         # 得出總帳 database name
         # g_faa.faa02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl                                                            
         LET g_plant_new= p_plant  # 工廠編號                                                                                            
         CALL s_getdbs()                                                                                                                 
         LET g_dbs_gl=g_dbs_new CLIPPED                                                                                                  
         
         LET l_flag1='N'          
         LET l_missingno = NULL  
         LET g_j=g_j+1          
         SELECT tc_tmp02 INTO l_missingno    
           FROM agl_tmp_file                 
          WHERE tc_tmp01=g_j AND tc_tmp00 = 'Y'     
            AND tc_tmp03=p_bookno
         IF NOT cl_null(l_missingno) THEN          
            LET l_flag1='Y'                       
            LET gl_no=l_missingno                
            DELETE FROM agl_tmp_file 
             WHERE tc_tmp02 = gl_no      
               AND tc_tmp03 = p_bookno 
         END IF                                                
                                                        
   #缺號使用完，再在流水號最大的編號上增加             
   IF l_flag1='N' THEN                                
   CALL s_auto_assign_no("agl",gl_no[1,g_doc_len],gl_date,"1","","",g_plant_new,"",g_faa.faa02b) ##FUN-B60140 g_dbs->g_plant_new 
        RETURNING li_result,gl_no
     IF g_bgjob = 'N' THEN    
         MESSAGE "Insert G/L voucher no:",gl_no 
         CALL ui.Interface.refresh()
     END IF
     PRINT "Insert aba:",g_faa.faa02b,' ',gl_no,' From:',l_order  #FUN-B60140 mark
     END IF  
     #LET g_sql="INSERT INTO ",g_dbs_gl,"aba_file",
     LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'aba_file')  ,#No:FUN-B60140 add
                        "(aba00,aba01,aba02,aba03,aba04,aba05,",
                        #" aba06,aba07,aba08,aba09,aba12,aba19,abamksg,abapost,",   
                        " aba06,aba07,aba08,aba09,aba12,aba19,aba20,abamksg,abapost,",  
                        " abaprno,abaacti,abauser,abagrup,abadate,",
                        #" abasign,abadays,abaprit,abasmax,abasseq,abamodu)",   
                        " abasign,abadays,abaprit,abasmax,abasseq,abamodu,aba24,aba11,abalegal)",#No:FUN-B60140 add abalegal    
                    #" VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"   
                    #" VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"   
                    " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"     
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql  
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #No:FUN-B60140 add

     PREPARE p202_1_p4 FROM g_sql
## ----
     #自動賦予簽核等級
     LET g_aba.aba01=gl_no
     CALL s_get_doc_no(gl_no) RETURNING g_aba01t     
     SELECT aac08,aacatsg,aacdays,aacprit,aacsign  #簽核處理 (Y/N)
       INTO g_aba.abamksg,g_aac.aacatsg,g_aba.abadays,
            g_aba.abaprit,g_aba.abasign
       FROM aac_file WHERE aac01 = g_aba01t
     IF g_aba.abamksg MATCHES  '[Yy]'
        THEN
        IF g_aac.aacatsg matches'[Yy]'   #自動付予
           THEN
           CALL s_sign(g_aba.aba01,4,'aba01','aba_file')
                RETURNING g_aba.abasign
        END IF
        SELECT COUNT(*) INTO g_aba.abasmax
            FROM azc_file
            WHERE azc01=g_aba.abasign
     END IF
## ----
    #01/11/13 將常數轉變數
    # EXECUTE p202_1_p4 USING g_faa.faa02b,gl_no,gl_date,g_yy,g_mm,gl_date,
    #                         'FA',l_order,'0','0','N','N',g_aba.abamksg,'N',
    #                         '0','Y',g_user,g_grup,g_today,
    #              g_aba.abasign,g_aba.abadays,g_aba.abaprit,g_aba.abasmax,'0',
    #              g_user
     LET l_aba06  = 'FA'    
     LET l_number = 0      
     LET l_no2    = 'N'   
     LET l_yes    = 'Y'  
     LET g_zero='0'   
     EXECUTE p202_1_p4 USING g_faa.faa02b,gl_no,gl_date,g_yy,g_mm,g_today,
                             #l_p1,l_order,l_p2,l_p2,l_p3,l_p3,g_aba.abamksg,   
                            #l_p1,l_order,l_p2,l_p2,l_p3,l_p3,g_zero,g_aba.abamksg,   
                             l_aba06,l_order,l_number,l_number,l_no2,l_no2,g_zero,g_aba.abamksg,    
                            #l_p3,l_p2,l_p4,g_user,g_grup,g_today,g_aba.abasign,      
                             l_no2,l_number,l_yes,g_user,g_grup,g_today,g_aba.abasign, 
                            #g_aba.abadays,g_aba.abaprit,g_aba.abasmax,l_p2,     
                             g_aba.abadays,g_aba.abaprit,g_aba.abasmax,l_number, 
                             #g_user  
                             g_user,g_user,g_aba.aba11,g_legal  #No:FUN-B60140 add g_legal
     IF STATUS THEN
         CALL cl_err('ins aba:',STATUS,1)
         LET g_success = 'N'
     END IF
     DELETE FROM tmn_file WHERE tmn01 = p_plant AND tmn02 = gl_no  
                            AND tmn06 = p_bookno  
     IF gl_no_b IS NULL THEN LET gl_no_b = gl_no END IF
     LET gl_no_e = gl_no
     LET l_credit = 0 LET l_debit  = 0
     LET l_seq = 0
   #------------------ Update gl-no To original file --------------------------
   AFTER GROUP OF l_npq.npq01

     CASE WHEN l_npp.nppsys='FA' AND l_npp.npp00=1
               #UPDATE faq_file SET (faq06,faq07) = (gl_no,gl_date)  #FUN-B60140 mark
                UPDATE faq_file SET faq06 = gl_no, faq07=gl_date #FUN-B60140 add
                WHERE faq01 = l_npq.npq01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                 CALL cl_err('upd faq:',SQLCA.sqlcode,1)   
                  CALL cl_err3("upd","faq_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd faq:",1)   
                  LET g_success = 'N' 
               END IF
          WHEN l_npp.nppsys='FA' AND l_npp.npp00=2
               #UPDATE fas_file SET (fas07,fas08) = (gl_no,gl_date) #FUN-B60140 mark
               UPDATE fas_file SET fas07 = gl_no,fas08= gl_date #FUN-B60140 add
                WHERE fas01 = l_npq.npq01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                 CALL cl_err('upd fas:',SQLCA.sqlcode,1)  
                  CALL cl_err3("upd","fas_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd fas:",1)   
                  LET g_success = 'N' 
               END IF
          #FUN-BC0035---begin add
          WHEN l_npp.nppsys='FA' AND l_npp.npp00=14
               UPDATE fbx_file SET fbx07 = gl_no1,fbx08 = gl_date
                WHERE fbx01 = l_npq.npq01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","fbx_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd fbx:",1)
                  LET g_success = 'N'
               END IF          
          #FUN-BC0035---end add
          WHEN l_npp.nppsys='FA' AND l_npp.npp00=4
               #UPDATE fbe_file SET (fbe14,fbe15) = (gl_no,gl_date)  #FUN-B60140 mark
               UPDATE fbe_file SET fbe14 = gl_no,fbe15 = gl_date #FUN-B60140 add
                WHERE fbe01 = l_npq.npq01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                 CALL cl_err('upd fbe:',SQLCA.sqlcode,1)    
                  CALL cl_err3("upd","fbe_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd fbe:",1)   
                  LET g_success = 'N' 
               END IF
          WHEN l_npp.nppsys='FA' AND (l_npp.npp00=5 OR l_npp.npp00=6)
               #UPDATE fbg_file SET (fbg08,fbg09) = (gl_no,gl_date) #FUN-B60140 mark
               UPDATE fbg_file SET fbg08 = gl_no , fbg09 = gl_date #FUN-B60140 add
                WHERE fbg01 = l_npq.npq01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                 CALL cl_err('upd fbg:',SQLCA.sqlcode,1) 
                  CALL cl_err3("upd","fbg_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd fbg:",1)   
                  LET g_success = 'N' 
               END IF
          WHEN l_npp.nppsys='FA' AND l_npp.npp00=7
               #UPDATE fay_file SET (fay06,fay07) = (gl_no,gl_date)  #FUN-B60140 mark
               UPDATE fay_file SET fay06 = gl_no,fay07 = gl_date  #FUN-B60140 add
                WHERE fay01 = l_npq.npq01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                 CALL cl_err('upd fay:',SQLCA.sqlcode,1)  
                  CALL cl_err3("upd","fay_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd fay:",1)   
                  LET g_success = 'N' 
               END IF
          WHEN l_npp.nppsys='FA' AND l_npp.npp00=8
               #UPDATE fba_file SET (fba06,fba07) = (gl_no,gl_date) #FUN-B60140 mark
                UPDATE fba_file SET fba06 = gl_no,fba07 = gl_date #FUN-B60140 add
                WHERE fba01 = l_npq.npq01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                 CALL cl_err('upd fba:',SQLCA.sqlcode,1)  
                  CALL cl_err3("upd","fba_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd fba:",1)   
                  LET g_success = 'N' 
               END IF
          WHEN l_npp.nppsys='FA' AND l_npp.npp00=9
               #UPDATE fbc_file SET (fbc06,fbc07) = (gl_no,gl_date) #FUN-B60140 mark
               UPDATE fbc_file SET fbc06 = gl_no,fbc07 = gl_date #FUN-B60140 add
                WHERE fbc01 = l_npq.npq01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                 CALL cl_err('upd fbc:',SQLCA.sqlcode,1)   
                  CALL cl_err3("upd","fbc_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd fbc:",1)   
                  LET g_success = 'N' 
               END IF
#-------- added by frank871 1999/05/04  ------NO:0068----------------------#
          WHEN l_npp.nppsys='FA' AND l_npp.npp00=11   #利息-資本化
#              LET l_no = l_npq.npq01             
               LET l_no1= l_npq.npq01       
               LET l_no = l_no1.trim()       
               LET l_no = l_no CLIPPED       
               #UPDATE fcx_file SET (fcx11,fcx12) = (gl_no,gl_date) #FUN-B60140 mark
               UPDATE fcx_file SET fcx11 = gl_no,fcx12 = gl_date #FUN-B60140 add
                WHERE fcx01 = l_no           
                  AND fcx02 = YEAR(l_npp.npp02)
                  AND fcx03 = MONTH(l_npp.npp02)
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                 CALL cl_err('upd fcx:',SQLCA.sqlcode,1)    
                  CALL cl_err3("upd","fcx_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd fcx:",1)   
                  LET g_success = 'N' 
               END IF
          WHEN l_npp.nppsys='FA' AND l_npp.npp00=12  #保險
               #UPDATE fdd_file SET (fdd06,fdd07) = (gl_no,gl_date) #FUN-B60140 mark
               UPDATE fdd_file SET  fdd06 = gl_no, fdd07 = gl_date #FUN-B60140 add
                WHERE fdd01 = l_npq.npq23
                  AND fdd03 = YEAR(l_npp.npp02)
                  AND fdd033 = MONTH(l_npp.npp02)
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                 CALL cl_err('upd fdd:',SQLCA.sqlcode,1)   
                  CALL cl_err3("upd","fdd_file",l_npq.npq23,"",SQLCA.sqlcode,"","upd fdd:",1)   
                  LET g_success = 'N' 
               END IF
#--------------------------------------------------------------------------#
          
          WHEN l_npp.nppsys='FA' AND l_npp.npp00=13  #減值準備                  
               UPDATE fbs_file SET fbs04 = gl_no,
                                   fbs05 = gl_date
                WHERE fbs01 = l_npq.npq01                                       
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                    
#                 CALL cl_err('upd fbs:',SQLCA.sqlcode,1)   
                  CALL cl_err3("upd","fbs_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd fbs:",1)   
                  LET g_success = 'N' 
               END IF                                                           
          
          OTHERWISE EXIT CASE 
     END CASE
     UPDATE npp_file SET npp03 = gl_date, nppglno= gl_no ,
                         npp06 = p_plant, npp07  = p_bookno     #no.7277
      WHERE npp01 = l_npp.npp01
        AND npp011= l_npp.npp011
        AND npp00 = l_npp.npp00
        AND nppsys= l_npp.nppsys
        AND npptype='0' 
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#       CALL cl_err('upd npp03/glno:',SQLCA.sqlcode,1)    
        CALL cl_err3("upd","npp_file",l_npp.npp01,l_npp.npp011,SQLCA.sqlcode,"","upd npp03/glno:",1)   
        LET g_success = 'N'
     END IF
   #------------------ Insert into abb_file ---------------------------------
   AFTER GROUP OF l_remark   
     LET l_seq = l_seq + 1
     IF g_bgjob = 'N' THEN    
         MESSAGE "Seq:",l_seq 
         CALL ui.Interface.refresh()
     END IF
    # LET g_sql = "INSERT INTO ",g_dbs_gl,"abb_file",#FUN-B60140 mark
     LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'abb_file')  ,#No:FUN-B60140 add
                        "(abb00,abb01,abb02,abb03,abb04,",
                        " abb05,abb06,abb07f,abb07,",
#                       " abb08,abb11,abb12,abb13,abb14,abb15,",                       
                        " abb08,abb11,abb12,abb13,abb14,",                            
                        " abb24,abb25,",

                        "abb31,abb32,abb33,abb34,abb35,abb36,abb37",
                        ",abblegal",

                        " )",
#                " VALUES(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?,?, ?,?",             
                 " VALUES(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?,?, ?",              
                 "       ,?,?,?,?,?,?,?,?)"
     LET l_amtf= GROUP SUM(l_npq.npq07f)
     LET l_amt = GROUP SUM(l_npq.npq07)
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #No:FUN-B60140 add
     PREPARE p202_1_p5 FROM g_sql
     EXECUTE p202_1_p5 USING 
                g_faa.faa02b,gl_no1,l_seq,l_npq.npq03,l_npq.npq04,
                l_npq.npq05,l_npq.npq06,l_amtf,l_amt,
                l_npq.npq08,l_npq.npq11,l_npq.npq12,l_npq.npq13,
#               l_npq.npq14,l_npq.npq15,                                               
                l_npq.npq14,                                                           
                l_npq.npq24,l_npq.npq25,

                l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34,
                l_npq.npq35,l_npq.npq36,l_npq.npq37,g_legal

     IF SQLCA.sqlcode THEN
        CALL cl_err('ins abb:',STATUS,1) LET g_success = 'N'
     END IF
     IF l_npq.npq06 = '1'
        THEN LET l_debit  = l_debit  + l_amt
        ELSE LET l_credit = l_credit + l_amt
     END IF
   #------------------ Update aba_file's debit & credit amount --------------
   AFTER GROUP OF l_order
      PRINT "update debit&credit:",l_debit,' ',l_credit," For:",gl_no
      #LET g_sql = "UPDATE ",g_dbs_gl,"aba_file SET (aba08,aba09) = (?,?)",#FUN-90088 mark
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'aba_file')," SET aba08=?,aba09 = ?",#FUN-90088 add
                  " WHERE aba01 = ? AND aba00 = ?"
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql 
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #No:FUN-B60140 add
      PREPARE p202_1_p6 FROM g_sql
      EXECUTE p202_1_p6 USING l_debit,l_credit,gl_no,g_faa.faa02b
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('upd aba08/09:',SQLCA.sqlcode,1) LET g_success = 'N'
      END IF
      PRINT
      #CALL s_flows(g_faa.faa02b,gl_no,gl_date,l_no2,TRUE)   
      IF g_aaz85 = 'Y' THEN 
            #若有立沖帳管理就不做自動確認
           # LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_gl CLIPPED," abb_file,aag_file",#FUN-90088 mark
            LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'aab_file'),cl_get_target_table(g_plant_new,'aag_file')  ,#No:FUN-B60140 add
                        " WHERE abb01 = '",gl_no,"'",
                        "   AND abb00 = '",g_faa.faa02b,"'",
                        "   AND abb03 = aag01  ",
                        "   AND aag20 = 'Y' "
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql		
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #No:FUN-B60140 add
            PREPARE count_pre FROM g_sql
            DECLARE count_cs CURSOR FOR count_pre
            OPEN count_cs 
            FETCH count_cs INTO g_cnt
            CLOSE count_cs
            IF g_cnt = 0 THEN
               IF cl_null(g_aba.aba18) THEN LET g_aba.aba18='0' END IF
              #IF cl_null(g_aba.aba20) THEN LET g_aba.aba20='0' END IF   
              #IF g_aba.abamksg='N' AND g_aba.aba20='0' THEN  
               IF g_aba.abamksg='N' THEN                     
                  LET g_aba.aba20='1' 
                  LET g_aba.aba19 = 'Y'


                 # LET g_sql = " UPDATE ",g_dbs_gl CLIPPED,"aba_file", #FUN-90088 mark
                  LET g_sql = " UPDATE ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-90088 add
                              "    SET abamksg = ? ,",
                                     " abasign = ? ,", 
                                     " aba18   = ? ,",
                                     " aba19   = ? ,",
                                     " aba20   = ? ,",           
                                     " aba37   = ?  ",          
                               " WHERE aba01 = ? AND aba00 = ? "
	CALL cl_replace_sqldb(g_sql) RETURNING g_sql	
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #No:FUN-B60140 add
                  PREPARE upd_aba19 FROM g_sql
                  EXECUTE upd_aba19 USING g_aba.abamksg,g_aba.abasign,
                                          g_aba.aba18  ,g_aba.aba19,
                                          g_aba.aba20  ,
                                          g_user,                  
                                          gl_no        ,g_faa.faa02b
                  IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err('upd aba19',STATUS,1) LET g_success = 'N'
                  END IF
               END IF    
            END IF
      END IF     
     #LET gl_no[4,12]=''   
     #LET gl_no[g_no_sp,g_no_ep]=''      #MOD-CC0100 mark
      LET gl_no1[g_no_sp-1,g_no_ep]=''   #MOD-CC0100 add
END REPORT

FUNCTION p202_create_tmp() 

   DROP TABLE p202_tmp;

   SELECT 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' order1, npp_file.*,npq_file.*,
          'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' remark1
     FROM npp_file,npq_file
    WHERE npp01 = npq01 AND npp01 = '@@@@'
      AND npp00 = npq00  
     INTO TEMP p202_tmp

   IF SQLCA.SQLCODE THEN
      LET g_success='N'
      CALL cl_err3("ins","p202_tmp","","",SQLCA.sqlcode,"","create p202_tmp",0) 
   END IF

   DELETE FROM p202_tmp WHERE 1=1

   LET gl_no_b=''
   LET gl_no_e=''

END FUNCTION

FUNCTION p202_set_comb()                                                        
   DEFINE comb_value STRING                                                      
   DEFINE comb_item  STRING                                                      
                                                                                
   IF g_aza.aza26 = '2' THEN
      LET comb_value = '1,2,4,5,6,7,8,9,10,11,12,13,14' #FUN-BC0035 add 14
   ELSE
      LET comb_value = '1,2,4,5,6,7,8,9,10,11,12'
   END IF

   CALL cl_getmsg('afa-377',g_lang) RETURNING comb_item

   CALL cl_set_combo_items('npp00',comb_value,comb_item)     

END FUNCTION


REPORT afap202_1_rep(l_order,l_npp,l_npq,l_remark)
  DEFINE l_order	LIKE npp_file.npp01    
  DEFINE l_npp		RECORD LIKE npp_file.*
  DEFINE l_npq		RECORD LIKE npq_file.*
  DEFINE l_seq		LIKE type_file.num5  	# 傳票項次 
  DEFINE l_credit,l_debit,l_amt,l_amtf LIKE type_file.num20_6 
  DEFINE l_no           LIKE fcx_file.fcx01    
  DEFINE l_remark       LIKE type_file.chr1000 
  DEFINE l_aba06_1      LIKE aba_file.aba06    
  DEFINE l_number_1     LIKE type_file.num5    
  DEFINE l_no_1         LIKE type_file.chr1    
  DEFINE l_yes_1        LIKE type_file.chr1    
  DEFINE li_result      LIKE type_file.num5    
  DEFINE l_missingno    LIKE aba_file.aba01    
  DEFINE l_flag1        LIKE type_file.chr1    
  DEFINE l_no1          STRING                 
  DEFINE l_success      LIKE type_file.num5     

  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER EXTERNAL BY l_order,l_npq.npq06,l_npq.npq03,l_npq.npq05,
           l_npq.npq24,l_npq.npq25,l_remark,l_npq.npq01
  FORMAT
   #--------- Insert aba_file ---------------------------------------------
   BEFORE GROUP OF l_order

   # 得出總帳 database name
   # g_faa.faa02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl                                                            
    LET g_plant_new= p_plant  # 工廠編號                                                                                            
    CALL s_getdbs()                                                                                                                 
    LET g_dbs_gl=g_dbs_new CLIPPED                                                                                                  

   LET l_flag1='N'          
   LET l_missingno = NULL  
   LET g_j=g_j+1          
   SELECT tc_tmp02 INTO l_missingno    
     FROM agl_tmp_file                 
    WHERE tc_tmp01=g_j AND tc_tmp00 = 'Y'     
      AND tc_tmp03=p_bookno1 
   IF NOT cl_null(l_missingno) THEN          
      LET l_flag1='Y'                       
      LET gl_no1=l_missingno                
      DELETE FROM agl_tmp_file WHERE tc_tmp02 = gl_no1      
                                AND tc_tmp03 = p_bookno1 
   END IF                                                
                                                        
   #缺號使用完，再在流水號最大的編號上增加             
   IF l_flag1='N' THEN                                
   CALL s_auto_assign_no("agl",gl_no1[1,g_doc_len],gl_date,"1","","",g_plant_new,"",g_faa.faa02c)#FUN-B60140   g_dbs_gl-> g_plant_new 
        RETURNING li_result,gl_no1
     IF g_bgjob = 'N' THEN    
         MESSAGE "Insert G/L voucher no:",gl_no1 
         CALL ui.Interface.refresh()
     END IF
     PRINT "Insert aba:",g_faa.faa02c,' ',gl_no1,' From:',l_order
     END IF  
     #LET g_sql="INSERT INTO ",g_dbs_gl,"aba_file",#FUN-B60140 mark
     LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'aba_file')  ,#No:FUN-B60140 add
                        "(aba00,aba01,aba02,aba03,aba04,aba05,",
                        " aba06,aba07,aba08,aba09,aba12,aba19,aba20,abamksg,abapost,",  
                        " abaprno,abaacti,abauser,abagrup,abadate,",
                        " abasign,abadays,abaprit,abasmax,abasseq,abamodu,aba24,aba11,abalegal)",
                    " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)" 
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #No:FUN-B60140 add
     PREPARE p202_1_p4_1 FROM g_sql
## ----
     #自動賦予簽核等級
     LET g_aba.aba01=gl_no1
     CALL s_get_doc_no(gl_no1) RETURNING g_aba01t     
     SELECT aac08,aacatsg,aacdays,aacprit,aacsign  #簽核處理 (Y/N)
       INTO g_aba.abamksg,g_aac.aacatsg,g_aba.abadays,
            g_aba.abaprit,g_aba.abasign
       FROM aac_file WHERE aac01 = g_aba01t
     IF g_aba.abamksg MATCHES  '[Yy]'
        THEN
        IF g_aac.aacatsg matches'[Yy]'   #自動付予
           THEN
           CALL s_sign(g_aba.aba01,4,'aba01','aba_file')
                RETURNING g_aba.abasign
        END IF
        SELECT COUNT(*) INTO g_aba.abasmax
            FROM azc_file
            WHERE azc01=g_aba.abasign
     END IF
## ----
    #01/11/13 將常數轉變數
     LET l_aba06_1  = 'FA'    
     LET l_number_1 = 0       
     LET l_no_1     = 'N'    
     LET l_yes_1    = 'Y'   
     LET g_zero='0'   
     EXECUTE p202_1_p4_1 USING g_faa.faa02c,gl_no1,gl_date,g_yy,g_mm,g_today,
                             l_aba06_1,l_order,l_number_1,l_number_1,l_no_1,l_no_1,g_zero,g_aba.abamksg, 
                             l_no_1,l_number_1,l_yes_1,g_user,g_grup,g_today,g_aba.abasign,
                             g_aba.abadays,g_aba.abaprit,g_aba.abasmax,l_number_1,
                             g_user,g_user,g_aba.aba11,g_legal 
     IF STATUS THEN
         CALL cl_err('ins aba:',STATUS,1)
         LET g_success = 'N'
     END IF
     DELETE FROM tmn_file WHERE tmn01 = p_plant AND tmn02 = gl_no1  
                            AND tmn06 = p_bookno1  
     IF gl_no_b1 IS NULL THEN LET gl_no_b1 = gl_no1 END IF
     LET gl_no_e1 = gl_no1
     LET l_credit = 0 LET l_debit  = 0
     LET l_seq = 0

   #------------------ Update gl-no To original file --------------------------
   AFTER GROUP OF l_npq.npq01
     CASE WHEN l_npp.nppsys='FA' AND l_npp.npp00=1
               UPDATE faq_file SET faq062 = gl_no1,
                                   faq072 = gl_date
                WHERE faq01 = l_npq.npq01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","faq_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd faq:",1)   
                  LET g_success = 'N' 
               END IF
          WHEN l_npp.nppsys='FA' AND l_npp.npp00=2
               #UPDATE fas_file SET (fas072,fas082) = (gl_no1,gl_date) #FUN-B60140 mark
               UPDATE fas_file SET fas072 = gl_no1,fas082 =gl_date #FUN-B60140 add
                WHERE fas01 = l_npq.npq01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","fas_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd fas:",1)   
                  LET g_success = 'N' 
               END IF
          #FUN-BC0035---begin add
          WHEN l_npp.nppsys='FA' AND l_npp.npp00=14
               UPDATE fbx_file SET fbx072 = gl_no1,fbx082 = gl_date
                WHERE fbx01 = l_npq.npq01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","fbx_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd fbx:",1)
                  LET g_success = 'N'
               END IF          
          #FUN-BC0035---end add          
          WHEN l_npp.nppsys='FA' AND l_npp.npp00=4
               #UPDATE fbe_file SET (fbe142,fbe152) = (gl_no1,gl_date) #FUN-B60140 mark
               UPDATE fbe_file SET fbe142 = gl_no1,fbe152 = gl_date #FUN-B60140 add
                WHERE fbe01 = l_npq.npq01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","fbe_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd fbe:",1)   
                  LET g_success = 'N' 
               END IF
          WHEN l_npp.nppsys='FA' AND (l_npp.npp00=5 OR l_npp.npp00=6)
               #UPDATE fbg_file SET (fbg082,fbg092) = (gl_no1,gl_date) #FUN-B60140 mark
               UPDATE fbg_file SET fbg082 = gl_no1,fbg092 = gl_date #FUN-B60140 add
                WHERE fbg01 = l_npq.npq01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","fbg_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd fbg:",1)   
                  LET g_success = 'N' 
               END IF
          WHEN l_npp.nppsys='FA' AND l_npp.npp00=7
               #UPDATE fay_file SET (fay062,fay072) = (gl_no1,gl_date) #FUN-B60140 mark
               UPDATE fay_file SET fay062 = gl_no1,fay072 = gl_date #FUN-B60140 add
                WHERE fay01 = l_npq.npq01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","fay_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd fay:",1)   
                  LET g_success = 'N' 
               END IF
          WHEN l_npp.nppsys='FA' AND l_npp.npp00=8
               #UPDATE fba_file SET (fba062,fba072) = (gl_no1,gl_date)#FUN-B60140 mark
               UPDATE fba_file SET fba062 = gl_no1,fba072 = gl_date #FUN-B60140 add
                WHERE fba01 = l_npq.npq01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","fba_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd fba:",1)   
                  LET g_success = 'N' 
               END IF
          WHEN l_npp.nppsys='FA' AND l_npp.npp00=9
               #UPDATE fbc_file SET (fbc062,fbc072) = (gl_no1,gl_date) #FUN-B60140 mark
               UPDATE fbc_file SET fbc062 = gl_no1,fbc072 = gl_date #FUN-B60140 add
                WHERE fbc01 = l_npq.npq01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","fbc_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd fbc:",1)   
                  LET g_success = 'N' 
               END IF
          WHEN l_npp.nppsys='FA' AND l_npp.npp00=11   #利息-資本化
               LET l_no1= l_npq.npq01
               LET l_no = l_no1.trim()
               LET l_no = l_no CLIPPED 
               #UPDATE fcx_file SET (fcx112,fcx122) = (gl_no1,gl_date)#FUN-B60140 mark
               UPDATE fcx_file SET fcx112 = gl_no1,fcx122 = gl_date #FUN-B60140 add
                WHERE fcx01 = l_no    
                  AND fcx02 = YEAR(l_npp.npp02)
                  AND fcx03 = MONTH(l_npp.npp02)
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","fcx_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd fcx:",1)   
                  LET g_success = 'N' 
               END IF
          WHEN l_npp.nppsys='FA' AND l_npp.npp00=12  #保險
               #UPDATE fdd_file SET (fdd062,fdd072) = (gl_no1,gl_date)#FUN-B60140 mark
               UPDATE fdd_file SET fdd062 = gl_no1,fdd072 = gl_date #FUN-b60140 add
                WHERE fdd01 = l_npq.npq23
                  AND fdd03 = YEAR(l_npp.npp02)
                  AND fdd033 = MONTH(l_npp.npp02)
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","fdd_file",l_npq.npq23,"",SQLCA.sqlcode,"","upd fdd:",1)   
                  LET g_success = 'N' 
               END IF
          WHEN l_npp.nppsys='FA' AND l_npp.npp00=13  #減值準備                  
               UPDATE fbs_file SET fbs042 = gl_no1,
                                   fbs052 = gl_date
                WHERE fbs01 = l_npq.npq01                                       
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                    
                  CALL cl_err3("upd","fbs_file",l_npq.npq01,"",SQLCA.sqlcode,"","upd fbs:",1)   
                  LET g_success = 'N' 
               END IF                                                           
          OTHERWISE EXIT CASE 
     END CASE

     UPDATE npp_file SET npp03 = gl_date, nppglno= gl_no1,
                         npp06 = p_plant, npp07  = p_bookno1   
      WHERE npp01 = l_npp.npp01
        AND npp011= l_npp.npp011
        AND npp00 = l_npp.npp00
        AND nppsys= l_npp.nppsys
        AND npptype='1' 
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err3("upd","npp_file",l_npp.npp01,l_npp.npp011,SQLCA.sqlcode,"","upd npp03/glno:",1)   
        LET g_success = 'N'
     END IF

   #------------------ Insert into abb_file ---------------------------------
   AFTER GROUP OF l_remark 
     LET l_seq = l_seq + 1
     IF g_bgjob = 'N' THEN    
         MESSAGE "Seq:",l_seq 
         CALL ui.Interface.refresh()
     END IF
     #LET g_sql = "INSERT INTO ",g_dbs_gl,"abb_file",#FUN-B60140 mark
     LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'abb_file')  ,#No:FUN-B60140 add
                        "(abb00,abb01,abb02,abb03,abb04,",
                        " abb05,abb06,abb07f,abb07,",
                        " abb08,abb11,abb12,abb13,abb14,",
                        " abb24,abb25,",
                        "abb31,abb32,abb33,abb34,abb35,abb36,abb37",
                        ",abblegal",
                        " )",
                 " VALUES(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?,?, ?", 
                 "       ,?,?,?,?,?,?,?,?)"
     LET l_amtf= GROUP SUM(l_npq.npq07f)
     LET l_amt = GROUP SUM(l_npq.npq07)
	CALL cl_replace_sqldb(g_sql) RETURNING g_sql
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #No:FUN-B60140 add
     PREPARE p202_1_p5_1 FROM g_sql
     EXECUTE p202_1_p5_1 USING 
                g_faa.faa02c,gl_no1,l_seq,l_npq.npq03,l_npq.npq04,
                l_npq.npq05,l_npq.npq06,l_amtf,l_amt,
                l_npq.npq08,l_npq.npq11,l_npq.npq12,l_npq.npq13,
                l_npq.npq14,l_npq.npq24,l_npq.npq25,
                l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34,
                l_npq.npq35,l_npq.npq36,l_npq.npq37,g_legal

     IF SQLCA.sqlcode THEN
        CALL cl_err('ins abb:',STATUS,1) LET g_success = 'N'
     END IF
     IF l_npq.npq06 = '1'
        THEN LET l_debit  = l_debit  + l_amt
        ELSE LET l_credit = l_credit + l_amt
     END IF

   #------------------ Update aba_file's debit & credit amount --------------
   AFTER GROUP OF l_order
      PRINT "update debit&credit:",l_debit,' ',l_credit," For:",gl_no1
      #LET g_sql = "UPDATE ",g_dbs_gl,"aba_file SET (aba08,aba09) = (?,?)",#FUN-B60140 mark
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'aba_file')," SET aba08=?,aba09=?",#FUN-B60140 add
                  " WHERE aba01 = ? AND aba00 = ?"
	CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      PREPARE p202_1_p6_1 FROM g_sql
      EXECUTE p202_1_p6_1 USING l_debit,l_credit,gl_no1,g_faa.faa02c
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('upd aba08/09:',SQLCA.sqlcode,1) LET g_success = 'N'
      END IF
      PRINT
      #CALL s_flows(g_faa.faa02c,gl_no1,gl_date,l_no_1,TRUE)   
      IF g_aaz85 = 'Y' THEN 
            #若有立沖帳管理就不做自動確認
            #LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_gl CLIPPED," abb_file,aag_file",#FUN-B60140 mark
            LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'abb_file'),cl_get_target_table(g_plant_new,'aag_file'),#FUN-B60140 add
                        " WHERE abb01 = '",gl_no1,"'",
                        "   AND abb00 = '",g_faa.faa02c,"'",
                        "   AND abb03 = aag01  ",
                        "   AND aag20 = 'Y' "
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #No:FUN-B60140 add
            PREPARE count_pre2 FROM g_sql
            DECLARE count_cs2 CURSOR FOR count_pre2
            OPEN count_cs2 
            FETCH count_cs2 INTO g_cnt
            CLOSE count_cs2
            IF g_cnt = 0 THEN
               IF cl_null(g_aba.aba18) THEN LET g_aba.aba18='0' END IF
               IF g_aba.abamksg='N' THEN
                  LET g_aba.aba20='1' 
                  LET g_aba.aba19 = 'Y'

                  CALL s_chktic (g_faa.faa02c,gl_no1) RETURNING l_success
                  IF NOT l_success THEN
                     LET g_aba.aba20 ='0'
                     LET g_aba.aba19 ='N'
                  END IF

                  #LET g_sql = " UPDATE ",g_dbs_gl CLIPPED,"aba_file",FUN-B60140 mark
                  LET g_sql = " UPDATE ",cl_get_target_table(g_plant_new,'aba_file')  ,#No:FUN-B60140 add
                              "    SET abamksg = ? ,",
                                     " abasign = ? ,", 
                                     " aba18   = ? ,",
                                     " aba19   = ? ,",
                                     " aba20   = ? ,",
                                     " aba37   = ?  ",
                               " WHERE aba01 = ? AND aba00 = ? "
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #No:FUN-B60140 add
                  PREPARE upd_aba19_2 FROM g_sql
                  EXECUTE upd_aba19_2 USING g_aba.abamksg,g_aba.abasign,
                                          g_aba.aba18,g_aba.aba19,
                                          g_aba.aba20,g_user,
                                          gl_no1,g_faa.faa02c
                  IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err('upd aba19',STATUS,1) LET g_success = 'N'
                  END IF
               END IF    
            END IF
      END IF     

     #LET gl_no1[4,12]=''                #MOD-CC0100 mark
      LET gl_no1[g_no_sp-1,g_no_ep]=''   #MOD-CC0100 add

END REPORT
  #No:FUN-B60140
