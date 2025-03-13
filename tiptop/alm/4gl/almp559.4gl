# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: almp559.4gl
# Descriptions...: 會員升等批次更新作業
# Date & Author..: NO.FUN-B80051 11/08/09 By nanbing
# Modify.........: No.FUN-D10059 13/01/15 By dongsz 會員升等邏輯調整為調用t559sub_lqt03_uplevel函數

DATABASE ds
 
GLOBALS "../../config/top.global"
	
DEFINE tm     RECORD
         wc       STRING,
         lpj01    LIKE lpj_file.lpj01,
 #       lpf01    LIKE lpf_file.lpf01,
         lpc01    LIKE lpc_file.lpc01,
         lqr03    LIKE lqr_file.lqr03,
         lqt08    LIKE lqt_file.lqt08,
         lqr01    LIKE lqr_file.lqr01
         END RECORD
DEFINE g_lqr      RECORD LIKE lqr_file.*   
DEFINE g_change_lang     LIKE type_file.chr1     #是否有做語言切換
DEFINE g_kindtype        LIKE oay_file.oaytype 
DEFINE g_kindslip        LIKE oay_file.oayslip  
DEFINE li_result         LIKE type_file.num5   
DEFINE g_flag            LIKE type_file.chr1 
DEFINE g_lqt08           LIKE lqt_file.lqt08
MAIN
   DEFINE l_flag   LIKE type_file.chr1
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   
   LET tm.wc = ARG_VAL(1)
   LET g_bgjob = ARG_VAL(2) 
   LET tm.lqr03 = ARG_VAL(3)
   LET tm.lqt08 = ARG_VAL(4)
   LET tm.lqr01 = ARG_VAL(5)
   IF g_bgjob IS NULL THEN
      LET g_bgjob='N'
   END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   ERROR ""
   LET g_success = 'Y'
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p559_tm()
         IF cl_sure(18,20) THEN
            BEGIN WORK
            LET g_success = 'Y'
            CALL almp559()
            CALL s_showmsg()    
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL p559_end2() RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p559_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p559_w
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL almp559()
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
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION p559_tm()
   DEFINE p_row,p_col	LIKE type_file.num5
   DEFINE lc_cmd      LIKE type_file.chr1000
 
   IF s_shut(0) THEN RETURN END IF
 
   LET p_row = 3 LET p_col = 15
 
   OPEN WINDOW p559_w AT p_row,p_col WITH FORM "alm/42f/almp559" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
 
   WHILE TRUE
      CLEAR FORM 
      INITIALIZE tm.* TO NULL			# Default condition
#      CONSTRUCT BY NAME tm.wc ON lpj01,lpf01 
      CONSTRUCT BY NAME tm.wc ON lpj01,lpc01 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(lpj01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lpk01_1"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpj01
                  NEXT FIELD lpj01
            
#               WHEN INFIELD(lpf01) 
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_lqt04"
#                  CALL cl_create_qry() RETURNING tm.lpf01
#                  DISPLAY BY NAME tm.lpf01
#                  NEXT FIELD lpf01
               WHEN INFIELD(lpc01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lpc02"
                  CALL cl_create_qry() RETURNING tm.lpc01
                  DISPLAY BY NAME tm.lpc01
                  NEXT FIELD lpc01                  
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
 
         ON ACTION locale                
            LET g_change_lang = TRUE
            EXIT CONSTRUCT
      
         ON ACTION EXIT              
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
      END CONSTRUCT
      
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p559_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      
         EXIT PROGRAM
      END IF
      
      LET g_bgjob = 'N'
      INPUT BY NAME tm.lqr03,tm.lqt08,tm.lqr01,g_bgjob WITHOUT DEFAULTS 
        
         AFTER FIELD lqr01
            IF NOT cl_null(tm.lqr01) THEN
               CALL s_check_no("alm",tm.lqr01,'',"O3","lqr_file","lqr01","")
                 RETURNING li_result,tm.lqr01
               IF (NOT li_result) THEN
                  NEXT FIELD lqr01
               END IF
               DISPLAY BY NAME tm.lqr01
            END IF 
         AFTER FIELD lqt08
            IF NOT cl_null(tm.lqt08) THEN  
               CALL p559_lqt08('a')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0) 
                  NEXT FIELD lqt08
               END IF   
            END IF     
         AFTER FIELD lqr03
            IF NOT cl_null(tm.lqr03) THEN  
               CALL p559_lqr03('a')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0) 
                  NEXT FIELD lqr03
               END IF   
            END IF     
         AFTER FIELD g_bgjob 
            IF g_bgjob NOT MATCHES "[YN]"  OR cl_null(g_bgjob) THEN
               NEXT FIELD g_bgjob 
            END IF

         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         ON ACTION about         
            CALL cl_about()    
         ON ACTION HELP          
            CALL cl_show_help() 
         ON ACTION exit  #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
         ON ACTION qbe_save
            CALL cl_qbe_save()
         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
         ON ACTION controlp
            CASE
               WHEN INFIELD(lqr03) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azf01a"
                  LET g_qryparam.arg1 = "I"
                  CALL cl_create_qry() RETURNING tm.lqr03
                  DISPLAY BY NAME tm.lqr03
                  NEXT FIELD lqr03
               WHEN INFIELD(lqt08) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lpc02"
                  CALL cl_create_qry() RETURNING tm.lqt08
                  DISPLAY BY NAME tm.lqt08
                  NEXT FIELD lqt08
               WHEN INFIELD(lqr01) 
                  LET g_kindslip = s_get_doc_no(tm.lqr01)
                  CALL q_oay(FALSE,FALSE,g_kindslip,'O3','ALM') RETURNING g_kindslip 
                  LET tm.lqr01 = g_kindslip
                  DISPLAY BY NAME tm.lqr01
                  NEXT FIELD lqr01 
            END CASE
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p559_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "almp559"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('almp559','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET lc_cmd = lc_cmd CLIPPED,
                        " '",tm.wc CLIPPED ,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",tm.lqr03 CLIPPED ,"'",
                        " '",tm.lqt08 CLIPPED ,"'",
                        " '",tm.lqr01 CLIPPED ,"'"
            CALL cl_cmdat('almp559',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p559_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION almp559()
DEFINE l_lqt  DYNAMIC ARRAY OF RECORD
       lpk01    LIKE lpk_file.lpk01,
       lpk10    LIKE lpk_file.lpk10,
       lpkacti  LIKE lpk_file.lpkacti,
       lpj15    LIKE lpj_file.lpj15,
       lpj14    LIKE lpj_file.lpj14,
       lpj07    LIKE lpj_file.lpj07
              END RECORD
DEFINE l_n        LIKE type_file.num5
DEFINE l_sql      STRING
DEFINE l_flag     LIKE type_file.chr1
   LET l_sql = "SELECT lpk01,lpk10,lpkacti,SUM(lpj15) ,SUM(lpj14) , SUM(lpj07)",
               "  FROM lpj_file INNER JOIN lpk_file ON lpk01 = lpj01",
      #         "                LEFT JOIN lpf_file ON lpk10 = lpf01",
               "                LEFT JOIN lpc_file ON lpk10 = lpc01 AND lpc00 = '6' ", #FUN-D10059 Mod
               " WHERE " ,tm.wc CLIPPED," AND lpj09 = '2' ",
               " GROUP BY lpk01,lpk10,lpkacti  " 
   PREPARE p559_c1_p FROM l_sql
   IF SQLCA.sqlcode THEN 
      CALL s_errmsg('','','prepare p559_c1_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF  
 
   DECLARE p559_c1 CURSOR FOR p559_c1_p
   CALL s_showmsg_init()
   LET l_n = 1
   LET l_flag = 'N'
   LET g_success = 'N'
   FOREACH p559_c1 INTO l_lqt[l_n].*
      IF SQLCA.sqlcode THEN 
         CALL s_errmsg('','','prepare FOREACH',SQLCA.sqlcode,1) 
         LET g_success = 'N'
         RETURN
      END IF   
      IF g_success='N' THEN                                                                                                          
         LET g_success="Y"                                                                                                          
      END IF                  
      IF l_lqt[l_n].lpkacti = 'N' THEN
         LET g_success = 'N'
      END IF
      IF g_success = 'Y' THEN
         CALL p559_lqt03_check(l_lqt[l_n].lpk01)
            CALL p559_lqt03_uplevel(l_lqt[l_n].lpk01,l_lqt[l_n].lpk10,l_lqt[l_n].lpj15,l_lqt[l_n].lpj14,l_lqt[l_n].lpj07)  
         IF g_flag = 'Y' THEN
            CALL s_auto_assign_no("alm",tm.lqr01,g_today,"O3","lqr_file","lqr01","","","")
            RETURNING li_result,tm.lqr01
            IF (NOT li_result) THEN
               LET g_success = 'N'
            END IF  
            INSERT INTO lqt_file(lqt01,lqt02,lqt03,lqt04,lqt05,lqt06,lqt07,lqt08,lqtlegal,lqtplant)
                 VALUES(tm.lqr01,l_n,l_lqt[l_n].lpk01,l_lqt[l_n].lpk10,l_lqt[l_n].lpj15,l_lqt[l_n].lpj14,l_lqt[l_n].lpj07,g_lqt08,g_legal,g_plant)
            IF SQLCA.sqlcode THEN                   
               CALL s_errmsg('','','ins lqt_file',SQLCA.sqlcode,1)
               LET g_success = 'N'   
               EXIT FOREACH
            ELSE
               MESSAGE 'INSERT O.K'
               LET l_n=l_n+1
            END IF
            IF g_success = 'Y' THEN
               LET g_lqr.lqr01 = tm.lqr01
               LET g_lqr.lqr04 = g_user
               LET g_lqr.lqr03 = tm.lqr03
               LET g_lqr.lqruser = g_user
               LET g_lqr.lqracti = 'Y'
               LET g_lqr.lqroriu = g_user 
               LET g_lqr.lqrorig = g_grup 
               LET g_lqr.lqrgrup = g_grup
               LET g_lqr.lqrconf = 'N'
               LET g_lqr.lqrcond = NULL
               LET g_lqr.lqr02 = g_today
               LET g_lqr.lqrplant = g_plant
               LET g_lqr.lqrlegal = g_legal
               LET g_lqr.lqr05 = '0'
               INSERT INTO lqr_file VALUES (g_lqr.*)
               IF SQLCA.sqlcode THEN                   
                  LET g_success = 'N'     
                  CALL s_errmsg('','','ins lqr_file',SQLCA.sqlcode,1)
               ELSE
                  CALL cl_flow_notify(tm.lqr01,'I')
                  LET l_flag = 'Y'
               END IF
            END IF 
         ELSE
            LET g_success= 'N'   
         END IF
             
      END IF   
   END FOREACH  
   IF l_flag = 'Y' THEN #
      LET g_success = 'Y'
   END IF    
END FUNCTION
FUNCTION p559_lqt03_check(l_lqt03)
DEFINE l_lqt03       LIKE lqt_file.lqt03,
       l_lqr01       LIKE lqr_file.lqr01,
       l_lqrconf     LIKE lqr_file.lqrconf,
       l_lqr05       LIKE lqr_file.lqr05
DEFINE l_ze03        LIKE ze_file.ze03

   SELECT lqt03,lqr01,lqrconf,lqr05 
     INTO l_lqt03,l_lqr01,l_lqrconf,l_lqr05
     FROM lqt_file INNER JOIN lqr_file ON lqt01 = lqr01
    WHERE lqt03 = l_lqt03
      AND (lqrconf = 'N' OR (lqrconf = 'Y' AND lqr05 <> '2'))
   CASE
      WHEN l_lqrconf = 'N'
         LET g_flag = 'N'
      WHEN (l_lqrconf = 'Y' AND l_lqr05 <> '2')
         LET g_flag = 'N'
      WHEN SQLCA.SQLCODE = 100
         LET g_flag = 'Y'
      OTHERWISE          LET g_showmsg = SQLCA.SQLCODE USING '-------'  
   END CASE  
END FUNCTION
 
FUNCTION p559_lqt03_uplevel(l_lpk01,l_lpk10,sum_lpj15,sum_lpj14,sum_lpj07)
DEFINE l_lqq01_t       LIKE lqq_file.lqq01,
       l_lpk01         LIKE lpk_file.lpk01,
       l_lpk10         LIKE lpk_file.lpk10,
       sum_lpj07       LIKE lpj_file.lpj07,
       sum_lpj14       LIKE lpj_file.lpj14,
       sum_lpj15       LIKE lpj_file.lpj15,
       l_n             LIKE type_file.num10,
       l_sql           STRING,
       l_wc            STRING
DEFINE l_arr     DYNAMIC ARRAY OF RECORD
       lqq01         LIKE lqq_file.lqq01,
       lqq02         LIKE lqq_file.lqq02,
       lqq03         LIKE lqq_file.lqq03,
       lqq04         LIKE lqq_file.lqq04,
       lqq05         LIKE lqq_file.lqq05
                END RECORD
   IF NOT cl_null(tm.lqt08) THEN
      LET l_wc = " lqq01 = '",tm.lqt08 CLIPPED,"'"
   ELSE
      LET l_wc = " 1=1"   
   END IF   

   CALL t559sub_lqt03_uplevel(l_lpk01,l_lpk10,sum_lpj15,sum_lpj14,sum_lpj07,g_flag,l_wc,g_lqr.lqrplant)  #FUN-D10059 add
      RETURNING g_flag,l_n,l_lqq01_t                      #FUN-D10059 add 

  #FUN-D10059--mark--str---
  #LET l_sql = "SELECT lqq01,lqq02,lqq03,lqq04,lqq05 ", 
# #             " FROM lpf_file ", 
# #             "INNER JOIN lqq_file ON lpf01 = lqq01 ",
# #             "WHERE lpf05 = 'Y' AND ",l_wc CLIPPED,
  #            " FROM lpc_file ", 
  #            "INNER JOIN lqq_file ON lpc01 = lqq01 ",
  #            "WHERE lpc00 = '6' AND lpcacti = 'Y' AND ",l_wc CLIPPED,
  #            " ORDER BY lqq01 "
  #      
  #PREPARE p559_lqt03pre FROM　l_sql
  #DECLARE p559_lqt03cl CURSOR FOR p559_lqt03pre
  #LET l_n = 1
  #LET g_flag = 'N'
  #LET l_lqq01_t = ' '  
  #FOREACH p559_lqt03cl INTO l_arr[l_n].*
  #   IF SQLCA.sqlcode THEN
  #      CALL s_errmsg('','','prepare FOREACH',SQLCA.sqlcode,1) 
  #      EXIT FOREACH
  #   END IF
  #   
  #   IF l_arr[l_n].lqq01 <> l_lpk10 THEN #如果抓取的等級與當前等級相同則不比較
  #      IF l_lqq01_t <> l_arr[l_n].lqq01 THEN #同一个等级的每一个条件都判断后，通过g_flag判断是否能够升级
  #         IF g_flag = 'Y' THEN
  #            EXIT FOREACH
  #         END IF
  #         LET l_lqq01_t = l_arr[l_n].lqq01 
  #         LET g_flag = 'Y'   
  #      END IF   
  #      CASE 
  #         WHEN l_arr[l_n].lqq02 = '1'  #判斷累積積分
  #            IF g_flag = 'Y' OR l_arr[l_n].lqq03 = 'OR' THEN 
  #               IF sum_lpj14 >= l_arr[l_n].lqq04 AND sum_lpj14 <= l_arr[l_n].lqq05 THEN
  #                  LET g_flag = 'Y'
  #               ELSE 
  #                  LET g_flag = 'N'
  #               END IF
  #            END IF
  #         WHEN l_arr[l_n].lqq02 = '2' #判斷累計金額
  #            IF g_flag = 'Y' OR l_arr[l_n].lqq03 = 'OR' THEN
  #               IF sum_lpj15 >= l_arr[l_n].lqq04 AND sum_lpj15 <= l_arr[l_n].lqq05 THEN
  #                  LET g_flag = 'Y'
  #               ELSE 
  #                  LET g_flag = 'N'
  #               END IF
  #            END IF
  #         WHEN l_arr[l_n].lqq02 = '3' #判斷累計消費次數
  #            IF g_flag = 'Y' OR l_arr[l_n].lqq03 = 'OR' THEN
  #               IF sum_lpj07 >= l_arr[l_n].lqq04 AND sum_lpj07 <= l_arr[l_n].lqq05 THEN
  #                  LET g_flag = 'Y'
  #               ELSE 
  #                  LET g_flag = 'N'
  #               END IF
  #            END IF
  #         OTHERWISE  LET g_flag = 'N'
  #      END CASE
  #   END IF 
  #   LET l_n = l_n + 1
  #END FOREACH 
  #FUN-D10059--mark--end---
   IF g_flag = 'N' AND l_n != 1 THEN#經過判斷后g_flag為N則表示會員編號未符合升等資格
      RETURN
   ELSE
      LET g_lqt08 = l_lqq01_t
   END IF 
      
END FUNCTION
 
FUNCTION p559_lqr03(p_cmd)
DEFINE    p_cmd         LIKE type_file.chr1,
          l_azf03       LIKE azf_file.azf03,
          l_azf09       LIKE azf_file.azf09,
          l_azfacti     LIKE azf_file.azfacti

   SELECT azf03,azf09,azfacti INTO l_azf03,l_azf09,l_azfacti FROM azf_file 
    WHERE azf01 = tm.lqr03 AND azf02 = '2' 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm1103'
        WHEN l_azfacti = 'N'      LET g_errno = 'alm1105'
        WHEN l_azf09 <> 'I'       LET g_errno = 'alm1106'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------' 
   END CASE 
END FUNCTION
FUNCTION p559_lqt08(p_cmd)
DEFINE    p_cmd         LIKE type_file.chr1
#          l_lpf05       LIKE lpf_file.lpf05
DEFINE    l_lpcacti     LIKE lpc_file.lpcacti 
#   SELECT lpf05 INTO l_lpf05 FROM lpf_file
#    WHERE lpf01 = tm.lqt08
   SELECT lpcacti INTO l_lpcacti FROM lpc_file
    WHERE lpc01 = tm.lqt08 AND lpc00 = '6'  
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm1110'
        WHEN l_lpcacti = 'N'        LET g_errno = 'alm1112'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------' 
   END CASE     
END FUNCTION 
FUNCTION p559_end2()
DEFINE   li_result    LIKE type_file.num5,    
         ls_msg       LIKE ze_file.ze03,         
         lc_title      LIKE ze_file.ze03     

   SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'alm1115' AND ze02 = g_lang
   SELECT ze03 INTO lc_title FROM ze_file WHERE ze01 = 'lib-041' AND ze02 = g_lang

   MENU lc_title ATTRIBUTE (STYLE="dialog", COMMENT=ls_msg CLIPPED, IMAGE="question")
      ON ACTION yes
         LET li_result = TRUE
         EXIT MENU
      ON ACTION no
         EXIT MENU
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
   END MENU

   IF (INT_FLAG) THEN
      LET INT_FLAG = FALSE
      LET li_result = FALSE
   END IF

   RETURN li_result

END FUNCTION
#FUN-B80051
   
