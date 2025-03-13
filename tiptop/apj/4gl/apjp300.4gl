# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: apjp300.4gl
# Descriptions...: WBS累計預計需求資源推算作業
# Date & Author..: No.FUN-810069 08/03/15 By douzh
# Modify.........: No.TQC-840018 08/03/04 By douzh 處理拋轉時資料重復BUG
# Modify.........: No.FUN-850027 08/05/20 By douzh 新增資料來源邏輯調整
# Modify.........: No.FUN-850027 08/06/17 By douzh 若營運中心有做利潤中心管理
#                :                                 則拋正式預算時部門欄位存入的是對應的成本中心
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10060 10/01/11 By wuxj   修改INSERT INTO加入oriu及orig這2個欄位
# Modify.........: No.FUN-A50102 10/07/20 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:TQC-960062 10/11/04 By sabrina 將g_dbs_rep變量長度改大,chr8不夠用
# Modify.........: No:TQC-AC0252 10/12/18 By yinhy 修正（-268）錯誤
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.TQC-B80008 11/08/01 By lixia 執行完成后右下方信息清空
# Modify.........: No.FUN-D70090 13/07/18 By fengmy 增加afbacti
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_afd01         LIKE afd_file.afd01 
DEFINE  g_afd01_t       LIKE afd_file.afd01  
DEFINE  tm              RECORD 
         choice         LIKE type_file.chr1,    #資料來源
         note           LIKE afd_file.afd00,    #版本
         yy             LIKE afd_file.afd02,    #年度
         bookno         LIKE afb_file.afb00     #帳別
                        END RECORD
DEFINE  ls_date         STRING,             
        l_flag          LIKE type_file.chr1,
        g_change_lang   LIKE type_file.chr1
DEFINE  gv_time         LIKE type_file.chr8 
DEFINE  g_wc            STRING
DEFINE  g_azp03         LIKE azp_file.azp03
#DEFINE  g_dbs_rep       LIKE type_file.chr8    #TQC-960062 mark
DEFINE  g_dbs_rep       LIKE type_file.chr30    #TQC-960062 add
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   LET g_wc    = ARG_VAL(1)
   LET g_bgjob  = ARG_VAL(2)
   IF cl_null(g_bgjob) THEN LET g_bgjob = 'N' END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   WHILE TRUE
     LET g_change_lang = FALSE
     IF g_bgjob = 'N' THEN
        CALL apjp300(0,0)
        IF cl_sure(21,21) THEN
           CALL cl_wait()
           LET g_success='Y'
           BEGIN WORK
#No.FUN-850027--begin
           IF tm.choice='1' THEN
              CALL p300_process_1()
           ELSE
              CALL p300_process_2()
           END IF
#No.FUN-850027--end
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
              CLOSE WINDOW apjp300_w
              EXIT WHILE
           END IF
         ELSE
           CONTINUE WHILE
         END IF
     ELSE
         LET g_success = 'Y'
         BEGIN WORK
#No.FUN-850027--begin
         IF tm.choice='1' THEN
            CALL p300_process_1()
         ELSE
            CALL p300_process_2()
         END IF
#No.FUN-850027--end
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
     END  IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION apjp300(p_row,p_col)
    DEFINE  p_row,p_col    LIKE type_file.num5
    DEFINE  lc_cmd         STRING
    DEFINE  l_cnt          LIKE type_file.num5
    DEFINE  l_zz08         LIKE zz_file.zz08
 
   OPEN WINDOW apjp300_w WITH FORM "apj/42f/apjp300" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   WHILE TRUE 
      IF s_shut(0) THEN RETURN END IF
      CLEAR FORM 
      ERROR ""         #TQC-B80008
      LET g_bgjob = 'N'
#No.FUN-850027 --begin
      LET tm.choice = '1'
 
   INPUT BY NAME tm.choice WITHOUT DEFAULTS
 
   AFTER INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0            
         CLOSE WINDOW p300_w          
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM               
      END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about       
         CALL cl_about()   
 
      ON ACTION help         
         CALL cl_show_help()
 
      ON ACTION controlg   
         CALL cl_cmdask()  
 
      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT INPUT
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
      ON ACTION locale            
         LET g_change_lang = TRUE  
         EXIT INPUT                 
 
   END INPUT
 
   IF tm.choice = '2' THEN
#No.FUN-850027 --end
 
      CONSTRUCT BY NAME g_wc ON afd01
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(afd01) #項目編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_azp"
               LET g_qryparam.default1 = g_afd01
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO afd01
               NEXT FIELD afd01
            OTHERWISE EXIT CASE
          END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
        CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about     
         CALL cl_about()   
 
      ON ACTION help        
         CALL cl_show_help() 
 
      ON ACTION exit     
         LET INT_FLAG = 1
         EXIT CONSTRUCT
 
      ON ACTION locale
         LET g_change_lang = TRUE
         EXIT CONSTRUCT
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('afduser', 'afdgrup') #FUN-980030
   END IF                                  #No.FUN-850027
 
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW apjp300_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
   LET g_bgjob = 'N' 
   LET tm.yy = YEAR(g_today)
 
   INPUT BY NAME tm.note,tm.yy,tm.bookno,g_bgjob WITHOUT DEFAULTS
 
   AFTER INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0            
         CLOSE WINDOW p300_w          
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM               
      END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about       
         CALL cl_about()   
 
      ON ACTION help         
         CALL cl_show_help()
 
      ON ACTION controlg   
         CALL cl_cmdask()  
 
      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT INPUT
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
      ON ACTION locale            
         LET g_change_lang = TRUE  
         EXIT INPUT                 
 
   END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p300_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
  IF g_bgjob = "Y" THEN
     LET lc_cmd = NULL
#No.FUN-850027 --begin
     IF tm.choice ='1' THEN
        SELECT zz08 INTO l_zz08 FROM zz_file
         WHERE zz01 = "apjp300"
        IF SQLCA.sqlcode OR cl_null(l_zz08) THEN
           CALL cl_err('apjp300','9031',1)  
        ELSE
           LET lc_cmd = l_zz08 CLIPPED,
                        " ''",
                        " '",tm.note CLIPPED,"'",
                        " '",tm.yy CLIPPED,"'",
                        " '",tm.bookno CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('apjp300',g_time,lc_cmd CLIPPED)
           CLOSE WINDOW apjp300_w
           CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
           EXIT PROGRAM
        END IF
     ELSE  
        SELECT zz08 INTO l_zz08 FROM zz_file
         WHERE zz01 = "apjp300"
        IF SQLCA.sqlcode OR cl_null(l_zz08) THEN
           CALL cl_err('apjp300','9031',1)  
        ELSE
           LET lc_cmd = l_zz08 CLIPPED,
                        " ''",
                        " '",g_wc CLIPPED,"'",
                        " '",tm.note CLIPPED,"'",
                        " '",tm.yy CLIPPED,"'",
                        " '",tm.bookno CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('apjp300',g_time,lc_cmd CLIPPED)
           CLOSE WINDOW apjp300_w
           CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
           EXIT PROGRAM
        END IF
     END IF                                                   #No.FUN-850027
   END IF
   EXIT WHILE
 
   ERROR ""
   END WHILE
END FUNCTION
 
#No.FUN-850027--begin
FUNCTION p300_process_1()
DEFINE l_sql    STRING
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_n      LIKE type_file.num5
DEFINE l_bgq    RECORD LIKE bgq_file.* 
DEFINE l_afb    RECORD LIKE afb_file.* 
DEFINE l_afb_t  RECORD LIKE afb_file.* 
DEFINE l_afc    RECORD LIKE afc_file.* 
DEFINE l_gem10  LIKE gem_file.gem10            #No.FUN-850027
DEFINE l_amt1   LIKE bgq_file.bgq06
DEFINE l_amt2   LIKE bgq_file.bgq06
DEFINE l_amt3   LIKE bgq_file.bgq06
DEFINE l_amt4   LIKE bgq_file.bgq06
DEFINE l_amt5   LIKE bgq_file.bgq06
DEFINE l_amt6   LIKE bgq_file.bgq06
DEFINE l_amt7   LIKE bgq_file.bgq06
DEFINE l_amt8   LIKE bgq_file.bgq06
DEFINE l_amt9   LIKE bgq_file.bgq06
DEFINE l_amt10  LIKE bgq_file.bgq06
DEFINE l_amt11  LIKE bgq_file.bgq06
DEFINE l_amt12  LIKE bgq_file.bgq06
DEFINE l_amt13  LIKE bgq_file.bgq06
DEFINE l_amt14  LIKE bgq_file.bgq06
DEFINE l_amt15  LIKE bgq_file.bgq06
DEFINE i        LIKE type_file.num5
DEFINE l_max    LIKE bgq_file.bgq03
DEFINE l_min    LIKE bgq_file.bgq03
 
  IF g_success = 'N' THEN
     IF g_bgjob = 'N' THEN CALL cl_rbmsg(1) END IF
     RETURN
  END IF
 
  LET l_sql ="SELECT * FROM bgq_file",
             " WHERE bgq01 = '",tm.note,"'",
             "   AND bgq02 = '",tm.yy,"'",
             " ORDER BY bgq01,bgq02,bgq04,bgq05,bgq051,bgq052,bgq053,bgq03"
  PREPARE p300_pb_1 FROM l_sql
  DECLARE p300_cur_1 CURSOR FOR p300_pb_1
  
  FOREACH p300_cur_1 INTO l_bgq.*
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err('foreach p300_cur_1',STATUS,1)
        EXIT FOREACH
     END IF
     LET l_afb.afb00 = g_aaz.aaz64
     LET l_afb.afb01 = l_bgq.bgq053
     LET l_afb.afb02 = l_bgq.bgq04
     LET l_afb.afb03 = l_bgq.bgq02
     LET l_afb.afb04 = l_bgq.bgq052
 
     IF g_aaz.aaz90 = 'Y' THEN
        SELECT gem10 INTO l_gem10 FROM gem_file
         WHERE gem01 = l_bgq.bgq05
        IF cl_null(l_gem10) THEN
           LET l_afb.afb041= ' '
        ELSE
           LET l_afb.afb041= l_gem10
        END IF
     ELSE
        LET l_afb.afb041= l_bgq.bgq05
     END IF
 
     LET l_afb.afb042= l_bgq.bgq051
     LET l_afb.afb05 = '1'
     LET l_afb.afb06 = '2'
     LET l_afb.afb07 = '2'
     LET l_afb.afb08 = '1'
     LET l_afb.afb09 = 'N'
     SELECT SUM(bgq06),SUM(bgq061),SUM(bgq08)
      INTO l_amt1,l_amt2,l_amt3 FROM bgq_file
      WHERE bgq01 = tm.note AND bgq02 = tm.yy 
        AND bgq04 = l_bgq.bgq04
        AND bgq05 = l_bgq.bgq05  AND bgq051= l_bgq.bgq051
        AND bgq052= l_bgq.bgq052 AND bgq053= l_bgq.bgq053
     SELECT SUM(bgq06),SUM(bgq061),SUM(bgq08)
      INTO l_amt4,l_amt5,l_amt6 FROM bgq_file
      WHERE bgq01 = tm.note AND bgq02 = tm.yy 
        AND bgq04 = l_bgq.bgq04
        AND bgq05 = l_bgq.bgq05  AND bgq051= l_bgq.bgq051
        AND bgq052= l_bgq.bgq052 AND bgq053= l_bgq.bgq053
        AND bgq03 BETWEEN '1' AND '3'
     SELECT SUM(bgq06),SUM(bgq061),SUM(bgq08)
      INTO l_amt7,l_amt8,l_amt9 FROM bgq_file
      WHERE bgq01 = tm.note AND bgq02 = tm.yy 
        AND bgq04 = l_bgq.bgq04
        AND bgq05 = l_bgq.bgq05  AND bgq051= l_bgq.bgq051
        AND bgq052= l_bgq.bgq052 AND bgq053= l_bgq.bgq053
        AND bgq03 BETWEEN '4' AND '6'
     SELECT SUM(bgq06),SUM(bgq061),SUM(bgq08)
      INTO l_amt10,l_amt11,l_amt12 FROM bgq_file
      WHERE bgq01 = tm.note AND bgq02 = tm.yy 
        AND bgq04 = l_bgq.bgq04
        AND bgq05 = l_bgq.bgq05  AND bgq051= l_bgq.bgq051
        AND bgq052= l_bgq.bgq052 AND bgq053= l_bgq.bgq053
        AND bgq03 BETWEEN '7' AND '9'
     SELECT SUM(bgq06),SUM(bgq061),SUM(bgq08)
      INTO l_amt13,l_amt14,l_amt15 FROM bgq_file
      WHERE bgq01 = tm.note AND bgq02 = tm.yy 
        AND bgq04 = l_bgq.bgq04
        AND bgq05 = l_bgq.bgq05  AND bgq051= l_bgq.bgq051
        AND bgq052= l_bgq.bgq052 AND bgq053= l_bgq.bgq053
        AND bgq03 BETWEEN '10' AND '13'
     IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF    
     IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF    
     IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF    
     IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF    
     IF cl_null(l_amt5) THEN LET l_amt5 = 0 END IF    
     IF cl_null(l_amt6) THEN LET l_amt6 = 0 END IF    
     IF cl_null(l_amt7) THEN LET l_amt7 = 0 END IF    
     IF cl_null(l_amt8) THEN LET l_amt8 = 0 END IF    
     IF cl_null(l_amt9) THEN LET l_amt9 = 0 END IF    
     IF cl_null(l_amt10) THEN LET l_amt10 = 0 END IF    
     IF cl_null(l_amt11) THEN LET l_amt11 = 0 END IF    
     IF cl_null(l_amt12) THEN LET l_amt12 = 0 END IF    
     IF cl_null(l_amt13) THEN LET l_amt13 = 0 END IF    
     IF cl_null(l_amt14) THEN LET l_amt14 = 0 END IF    
     IF cl_null(l_amt15) THEN LET l_amt15 = 0 END IF    
     LET l_afb.afb10 = l_amt1+l_amt2+l_amt3
     LET l_afb.afb11 = l_amt4+l_amt5+l_amt6
     LET l_afb.afb12 = l_amt7+l_amt8+l_amt9
     LET l_afb.afb13 = l_amt10+l_amt11+l_amt12
     LET l_afb.afb14 = l_amt13+l_amt14+l_amt15
     LET l_afb.afb15 = '1'
     LET l_afb.afbacti = 'Y'
     LET l_afb.afbuser = g_user
     LET l_afb.afbgrup = g_grup
     LET l_afb.afbdate = g_today
     LET l_afb.afb18 = 'N'
     LET l_afb.afb19 = 'Y'
     LET l_afb.afboriu = g_user      #No.FUN-980030 10/01/04
     LET l_afb.afborig = g_grup      #No.FUN-980030 10/01/04
     INSERT INTO afb_file VALUES(l_afb.*) 
     IF SQLCA.SQLCODE THEN
        #IF SQLCA.SQLCODE = '-239' THEN                #No.TQC-AC0252 mark   
        IF cl_sql_dup_value(SQLCA.SQLCODE) THEN        #No.TQC-AC0252 add
           SELECT COUNT(*) INTO l_n FROM afb_file WHERE afb00 = l_afb_t.afb00
            AND afb01 = l_afb_t.afb01  AND afb02 = l_afb_t.afb02
            AND afb03 = l_afb_t.afb03  AND afb04 = l_afb_t.afb04
            AND afb041= l_afb_t.afb041 AND afb042 = l_afb_t.afb042
            AND afb05 = l_afb_t.afb05  AND afbacti = 'Y'              #FUN-D7009 add afbacti
           IF l_n = 0 THEN
              CALL cl_err3("ins","afb_file",l_afb.afb00,l_afb.afb02,'apm-019',"","",1)
              LET g_success='N' 
              EXIT FOREACH                                                                                                            
           END IF
        ELSE
           CALL cl_err3("ins","afb_file",l_afb.afb00,l_afb.afb02,SQLCA.sqlcode,"","",1)
           LET g_success='N'
           EXIT FOREACH
        END IF
     ELSE
        LET l_afb_t.afb00 = l_afb.afb00          #做舊值用于是否需要報錯檢查
        LET l_afb_t.afb01 = l_afb.afb01          #做舊值用于是否需要報錯檢查
        LET l_afb_t.afb02 = l_afb.afb02          #做舊值用于是否需要報錯檢查
        LET l_afb_t.afb03 = l_afb.afb03          #做舊值用于是否需要報錯檢查
        LET l_afb_t.afb04 = l_afb.afb04          #做舊值用于是否需要報錯檢查
        LET l_afb_t.afb041= l_afb.afb041         #做舊值用于是否需要報錯檢查
        LET l_afb_t.afb042= l_afb.afb042         #做舊值用于是否需要報錯檢查
        LET l_afb_t.afb05 = l_afb.afb05          #做舊值用于是否需要報錯檢查
     END IF
 
     #單身資料
     LET l_afc.afc00 = l_afb.afb00
     LET l_afc.afc01 = l_afb.afb01
     LET l_afc.afc02 = l_afb.afb02
     LET l_afc.afc03 = l_afb.afb03
     LET l_afc.afc04 = l_afb.afb04
     LET l_afc.afc041 = l_afb.afb041
     LET l_afc.afc042 = l_afb.afb042
     LET l_afc.afc05 = l_bgq.bgq03
     LET l_afc.afc06 = l_bgq.bgq06+l_bgq.bgq061+l_bgq.bgq08
     LET l_afc.afc07 = 0
     LET l_afc.afc08 = 0
     LET l_afc.afc09 = 0
     SELECT MIN(bgq03),MAX(bgq03) INTO l_min,l_max FROM bgq_file
      WHERE bgq01 = l_bgq.bgq01 AND bgq02=l_bgq.bgq02
      AND bgq04 = l_bgq.bgq04   AND bgq05=l_bgq.bgq05
      AND bgq051 = l_bgq.bgq051 AND bgq052=l_bgq.bgq052
      AND bgq053 = l_bgq.bgq053
     IF l_bgq.bgq03 >= l_max THEN
        INSERT INTO afc_file VALUES(l_afc.*) 
        IF SQLCA.SQLCODE THEN
           CALL cl_err3("ins","afc_file",l_afc.afc00,l_afc.afc02,SQLCA.sqlcode,"","",1)
           LET g_success='N'
           EXIT FOREACH
        END IF
        SELECT azm02 INTO g_azm.azm02 FROM azm_file WHERE azm01=l_afc.afc03
        IF g_azm.azm02 ='1' THEN
           FOR i=l_bgq.bgq03+1 TO 12
               LET l_afc.afc00 = l_afb.afb00
               LET l_afc.afc01 = l_afb.afb01
               LET l_afc.afc02 = l_afb.afb02
               LET l_afc.afc03 = l_afb.afb03
               LET l_afc.afc04 = l_afb.afb04
               LET l_afc.afc041 = l_afb.afb041
               LET l_afc.afc042 = l_afb.afb042
               LET l_afc.afc05 = i
               LET l_afc.afc06 = 0
               LET l_afc.afc07 = 0
               LET l_afc.afc08 = 0
               LET l_afc.afc09 = 0
               INSERT INTO afc_file VALUES(l_afc.*) 
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("ins","afc_file",l_afc.afc00,l_afc.afc02,SQLCA.sqlcode,"","",1)
                  LET g_success='N'
                  EXIT FOREACH
               END IF
           END FOR
        ELSE
           FOR i=l_bgq.bgq03+1 TO 13
               LET l_afc.afc00 = l_afb.afb00
               LET l_afc.afc01 = l_afb.afb01
               LET l_afc.afc02 = l_afb.afb02
               LET l_afc.afc03 = l_afb.afb03
               LET l_afc.afc04 = l_afb.afb04
               LET l_afc.afc041 = l_afb.afb041
               LET l_afc.afc042 = l_afb.afb042
               LET l_afc.afc05 = i
               LET l_afc.afc06 = 0
               LET l_afc.afc07 = 0
               LET l_afc.afc08 = 0
               LET l_afc.afc09 = 0
               INSERT INTO afc_file VALUES(l_afc.*) 
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("ins","afc_file",l_afc.afc00,l_afc.afc02,SQLCA.sqlcode,"","",1)
                  LET g_success='N'
                  EXIT FOREACH
               END IF
           END FOR
        END IF
     ELSE
        IF l_bgq.bgq03 = l_min AND l_min >1 THEN
           INSERT INTO afc_file VALUES(l_afc.*) 
           IF SQLCA.SQLCODE THEN
              CALL cl_err3("ins","afc_file",l_afc.afc00,l_afc.afc02,SQLCA.sqlcode,"","",1)
              LET g_success='N'
              EXIT FOREACH
           END IF
           FOR i=l_bgq.bgq03-1 TO 1 STEP -1
               LET l_afc.afc00 = l_afb.afb00
               LET l_afc.afc01 = l_afb.afb01
               LET l_afc.afc02 = l_afb.afb02
               LET l_afc.afc03 = l_afb.afb03
               LET l_afc.afc04 = l_afb.afb04
               LET l_afc.afc041 = l_afb.afb041
               LET l_afc.afc042 = l_afb.afb042
               LET l_afc.afc05 = i
               LET l_afc.afc06 = 0
               LET l_afc.afc07 = 0
               LET l_afc.afc08 = 0
               LET l_afc.afc09 = 0
               INSERT INTO afc_file VALUES(l_afc.*) 
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("ins","afc_file",l_afc.afc00,l_afc.afc02,SQLCA.sqlcode,"","",1)
                  LET g_success='N'
                  EXIT FOR
               END IF
           END FOR
        ELSE
           INSERT INTO afc_file VALUES(l_afc.*) 
           IF SQLCA.SQLCODE THEN
              CALL cl_err3("ins","afc_file",l_afc.afc00,l_afc.afc02,SQLCA.sqlcode,"","",1)
              LET g_success='N'
              EXIT FOREACH
           END IF
        END IF
     END IF
  END FOREACH
 
END FUNCTION
#No.FUN-850027--end
 
FUNCTION p300_process_2()
DEFINE l_sql    STRING
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_n      LIKE type_file.num5
DEFINE l_afd01  LIKE afd_file.afd01
DEFINE l_afd    RECORD LIKE afd_file.* 
DEFINE l_afe    RECORD LIKE afe_file.* 
DEFINE l_afb    RECORD LIKE afb_file.* 
DEFINE l_afb_t  RECORD LIKE afb_file.* 
DEFINE l_afc    RECORD LIKE afc_file.* 
DEFINE l_gem10  LIKE gem_file.gem10            #No.FUN-850027
DEFINE l_amt1   LIKE afe_file.afe11
DEFINE l_amt2   LIKE afe_file.afe12
DEFINE l_amt3   LIKE afe_file.afe11
DEFINE l_amt4   LIKE afe_file.afe12
DEFINE l_amt5   LIKE afe_file.afe11
DEFINE l_amt6   LIKE afe_file.afe12
DEFINE l_amt7   LIKE afe_file.afe11
DEFINE l_amt8   LIKE afe_file.afe12
DEFINE l_amt9   LIKE afe_file.afe11
DEFINE l_amt10  LIKE afe_file.afe12
DEFINE l_dbs_rep  LIKE type_file.chr50                                      
DEFINE l_aza17  LIKE aza_file.aza17                                      
DEFINE l_azp03  LIKE azp_file.azp03                                      
DEFINE l_rate   LIKE azk_file.azk041                                     
 
  IF g_success = 'N' THEN
     IF g_bgjob = 'N' THEN CALL cl_rbmsg(1) END IF
     RETURN
  END IF
 
  LET l_sql="SELECT afd_file.*,afe_file.* FROM afd_file,afe_file ",
            " WHERE afd00= '",tm.note,"'",
            " AND afd02 = '",tm.yy,"'",
            " AND afd00 = afe00 AND afd01=afe01",
            " AND afd02 = afe02 AND afd03=afe03",
            " AND afd04 = afe04 AND afd05=afe05",
            " AND afd06 = afe06 AND afd07=afe07",
            " AND ",g_wc CLIPPED,
            " ORDER BY afe01,afe02,afe03,afe04,afe05,afe06,afe07,afe08"
 
  PREPARE p300_pb_2 FROM l_sql
  DECLARE p300_cur_2 CURSOR FOR p300_pb_2
  
  FOREACH p300_cur_2 INTO l_afd.*,l_afe.*
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err('foreach p300_cur_2',STATUS,1)
        EXIT FOREACH
     END IF
     SELECT azp03 INTO g_azp03 FROM azp_file WHERE azp01 = l_afd.afd01
     CALL s_dbstring(g_azp03) RETURNING g_dbs_rep
     IF tm.bookno IS NOT NULL THEN 
        LET l_afb.afb00 = tm.bookno
     ELSE
     	LET l_afb.afb00 = g_aza.aza81
     END IF
     LET l_afb.afb01 = l_afd.afd06
     LET l_afb.afb02 = l_afd.afd07
     LET l_afb.afb03 = l_afd.afd02
     LET l_afb.afb04 = l_afd.afd05
#No.FUN-850027--begin
     IF g_aaz.aaz90 = 'Y' THEN
        SELECT gem10 INTO l_gem10 FROM gem_file
         WHERE gem01 = l_afd.afd03
        LET l_afb.afb041= l_gem10
     ELSE
        LET l_afb.afb041= l_afd.afd03
     END IF
#No.FUN-850027--begin
     LET l_afb.afb042 = l_afd.afd04
     LET l_afb.afb05 = '1'
     LET l_afb.afb06 = '2'
     LET l_afb.afb07 = '2'
     LET l_afb.afb08 = '1'
     LET l_afb.afb09 = 'N'
 
     SELECT SUM(afe11),SUM(afe12) INTO l_amt1,l_amt2 
     FROM afd_file,afe_file WHERE afe00 = afd00
     AND afd00 =tm.note AND afd02=tm.yy
     AND afe01 = afd01  AND afe02=afd02
     AND afe03 = afd03  AND afe04=afd04
     AND afe05 = afd05  AND afe06=afd06
     AND afe07 = afd07  AND afe01=l_afe.afe01                     
     AND afe02 = l_afe.afe02 AND afe03=l_afe.afe03
     AND afe03 = l_afe.afe03 AND afe04=l_afe.afe04
     AND afe05 = l_afe.afe05 AND afe06=l_afe.afe06
     AND afe07 = l_afe.afe07 
     SELECT SUM(afe11),SUM(afe12) INTO l_amt3,l_amt4 
     FROM afd_file,afe_file WHERE afe00 = afd00
     AND afd00 =tm.note AND afd02=tm.yy
     AND afe01 = afd01  AND afe02=afd02
     AND afe03 = afd03  AND afe04=afd04
     AND afe05 = afd05  AND afe06=afd06
     AND afe07 = afd07  AND afe01=l_afe.afe01
     AND afe02 = l_afe.afe02 AND afe03=l_afe.afe03
     AND afe03 = l_afe.afe03 AND afe04=l_afe.afe04
     AND afe05 = l_afe.afe05 AND afe06=l_afe.afe06
     AND afe07 = l_afe.afe07 
     AND afe08 BETWEEN '1' AND '3'
     SELECT SUM(afe11),SUM(afe12) INTO l_amt5,l_amt6 
     FROM afd_file,afe_file WHERE afe00 = afd00
     AND afd00 =tm.note AND afd02=tm.yy
     AND afe01 = afd01  AND afe02=afd02
     AND afe03 = afd03  AND afe04=afd04
     AND afe05 = afd05  AND afe06=afd06
     AND afe07 = afd07  AND afe01=l_afe.afe01
     AND afe02 = l_afe.afe02 AND afe03=l_afe.afe03
     AND afe03 = l_afe.afe03 AND afe04=l_afe.afe04
     AND afe05 = l_afe.afe05 AND afe06=l_afe.afe06
     AND afe07 = l_afe.afe07 
     AND afe08 BETWEEN '4' AND '6'
     SELECT SUM(afe11),SUM(afe12) INTO l_amt7,l_amt8 
     FROM afd_file,afe_file WHERE afe00 = afd00
     AND afd00 =tm.note AND afd02=tm.yy
     AND afe01 = afd01  AND afe02=afd02
     AND afe03 = afd03  AND afe04=afd04
     AND afe05 = afd05  AND afe06=afd06
     AND afe07 = afd07  AND afe01=l_afe.afe01                       #此處QBE的條件有疑問
     AND afe02 = l_afe.afe02 AND afe03=l_afe.afe03
     AND afe03 = l_afe.afe03 AND afe04=l_afe.afe04
     AND afe05 = l_afe.afe05 AND afe06=l_afe.afe06
     AND afe07 = l_afe.afe07 
     AND afe08 BETWEEN '7' AND '9'
     SELECT SUM(afe11),SUM(afe12) INTO l_amt9,l_amt10 
     FROM afd_file,afe_file WHERE afe00 = afd00
     AND afd00 =tm.note AND afd02=tm.yy
     AND afe01 = afd01  AND afe02=afd02
     AND afe03 = afd03  AND afe04=afd04
     AND afe05 = afd05  AND afe06=afd06
     AND afe07 = afd07  AND afe01=l_afe.afe01
     AND afe02 = l_afe.afe02 AND afe03=l_afe.afe03
     AND afe03 = l_afe.afe03 AND afe04=l_afe.afe04
     AND afe05 = l_afe.afe05 AND afe06=l_afe.afe06
     AND afe07 = l_afe.afe07 
     AND afe08 BETWEEN '10' AND '13'
     IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF    
     IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
     IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
     IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF
     IF cl_null(l_amt5) THEN LET l_amt5 = 0 END IF
     IF cl_null(l_amt6) THEN LET l_amt6 = 0 END IF
     IF cl_null(l_amt7) THEN LET l_amt7 = 0 END IF
     IF cl_null(l_amt8) THEN LET l_amt8 = 0 END IF
     IF cl_null(l_amt9) THEN LET l_amt9 = 0 END IF
     IF cl_null(l_amt10) THEN LET l_amt10 = 0 END IF
     SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = l_afd.afd01
     #CALL s_dbstring(l_azp03) RETURNING l_dbs_rep    #FUN-A50102
     #LET l_sql="SELECT aza17 FROM ",l_dbs_rep CLIPPED,"aza_file"
     LET l_sql="SELECT aza17 FROM ",cl_get_target_table(l_afd.afd01,'aza_file') #FUN-A50102
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_afd.afd01) RETURNING l_sql #FUN-A50102
     PREPARE aza_cs FROM l_sql 
     EXECUTE aza_cs INTO l_aza17
     CALL s_curr(l_aza17,g_today) RETURNING l_rate 
     LET l_afb.afb10 = l_amt1+l_amt2
     LET l_afb.afb11 = l_amt3+l_amt4
     LET l_afb.afb12 = l_amt5+l_amt6
     LET l_afb.afb13 = l_amt7+l_amt8
     LET l_afb.afb14 = l_amt9+l_amt10 
     LET l_afb.afb15  = '1'
     LET l_afb.afbacti= 'Y'
     LET l_afb.afbuser= g_user
     LET l_afb.afbgrup= g_grup
     LET l_afb.afbmodu= ''
     LET l_afb.afbdate= g_today
     LET l_afb.afb16  = ''
     LET l_afb.afb17  = ''
     LET l_afb.afb18  = 'N'
     LET l_afb.afb19  = 'Y'
     LET l_afb.afboriu = g_user   #TQC-A10060   add
     LET l_afb.afborig = g_grup   #TQC-A10060   add
#No.TQC-840018--begin
     #LET l_sql="INSERT INTO ",g_dbs_rep CLIPPED,"afb_file ",
     LET l_sql="INSERT INTO ",cl_get_target_table(l_afd.afd01,'afb_file'), #FUN-A50102
                " VALUES(?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                " ?,?,?,?, ?,?,?,?,?)"    #TQC-A10060   add ?,?
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_afd.afd01) RETURNING l_sql #FUN-A50102
     PREPARE ins_afb FROM l_sql
     EXECUTE ins_afb USING l_afb.*
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        #IF SQLCA.sqlcode = '-239' THEN                #No.TQC-AC0252 add
        IF cl_sql_dup_value(SQLCA.SQLCODE) THEN        #No.TQC-AC0252 add 
           #LET l_sql="SELECT COUNT(*) FROM ",g_dbs_rep CLIPPED,"afb_file WHERE afb00 = '",l_afb_t.afb00,"' ",
           LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_afd.afd01,'afb_file'), #FUN-A50102
                     " WHERE afb00 = '",l_afb_t.afb00,"' ",
                     " AND afb01 ='",l_afb_t.afb01,"' "," AND afb02 = '",l_afb_t.afb02,"' ",
                     " AND afb03 ='",l_afb_t.afb03,"' "," AND afb04 = '",l_afb_t.afb04,"' ",
                     " AND afb041='",l_afb_t.afb041,"' "," AND afb042= '",l_afb_t.afb042,"' ",
                     " AND afb05 ='",l_afb_t.afb05,"' "
                    ,"   AND afbacti = 'Y' "                    #FUN-D70090 add
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_afd.afd01) RETURNING l_sql #FUN-A50102
           PREPARE sel_afb FROM l_sql
           EXECUTE sel_afb INTO l_n
           IF l_n =0 THEN
              CALL cl_err3("ins","afb_file",l_afb.afb00,l_afb.afb02,'apm-019',"","",1)
              LET g_success='N' 
              EXIT FOREACH                                                                                                            
           END IF
        ELSE
           CALL cl_err3("ins","afb_file",l_afb.afb00,l_afb.afb02,SQLCA.sqlcode,"","",1)
           LET g_success='N' 
           EXIT FOREACH                                                                                                            
        END IF
     ELSE
        LET l_afb_t.afb00 = l_afb.afb00          #做舊值用于是否需要報錯檢查
        LET l_afb_t.afb01 = l_afb.afb01          #做舊值用于是否需要報錯檢查
        LET l_afb_t.afb02 = l_afb.afb02          #做舊值用于是否需要報錯檢查
        LET l_afb_t.afb03 = l_afb.afb03          #做舊值用于是否需要報錯檢查
        LET l_afb_t.afb04 = l_afb.afb04          #做舊值用于是否需要報錯檢查
        LET l_afb_t.afb041= l_afb.afb041         #做舊值用于是否需要報錯檢查
        LET l_afb_t.afb042= l_afb.afb042         #做舊值用于是否需要報錯檢查
        LET l_afb_t.afb05 = l_afb.afb05          #做舊值用于是否需要報錯檢查
     END IF
#No.TQC-840018--end
 
     LET l_afc.afc00 = l_afb.afb00
     LET l_afc.afc01 = l_afb.afb01
     LET l_afc.afc02 = l_afb.afb02
     LET l_afc.afc03 = l_afb.afb03
     LET l_afc.afc04 = l_afb.afb04
     LET l_afc.afc041 = l_afb.afb041
     LET l_afc.afc042 = l_afb.afb042
     LET l_afc.afc05 = l_afe.afe08
     LET l_afc.afc06 = l_afe.afe09*l_rate
     LET l_afc.afc07 = 0
     LET l_afc.afc08 = 0
     LET l_afc.afc09 = 0
     #LET l_sql="INSERT INTO ",g_dbs_rep CLIPPED,"afc_file ",
     LET l_sql="INSERT INTO ",cl_get_target_table(l_afd.afd01,'afc_file'), #FUN-A50102
                " VALUES(?,?,?,?, ?,?,?,?, ?,?,?,?)" 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_afd.afd01) RETURNING l_sql #FUN-A50102
     PREPARE ins_afc FROM l_sql
     EXECUTE ins_afc USING l_afc.*
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err3("ins","afc_file",l_afc.afc00,l_afc.afc01,SQLCA.sqlcode,"","",1)
        LET g_success='N' 
        EXIT FOREACH                                                                                                            
     END IF
  END FOREACH
  IF g_success='Y' THEN 
  END IF
END FUNCTION
