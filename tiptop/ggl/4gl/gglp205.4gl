# Prog. Version..: '5.30.06-13.03.12(00003)'     #
# Pattern name...: gglp205.4gl
# Descriptions...: 合併報表關係人交易明細產生作業(整批資料處理作業)--from会计系统
# Date&Author....: 10/12/14 By lutingting copy from aglp005
# Modify.........: NO.FUN-B40104 11/05/05 By jll    合并报表作业产品
# Modify.........: No.FUN-B80094 11/08/09 By lutingting 1:asw10科目取值方式根據財務性質的不同取之不同
#                                                       2.asw09取所有收入科目,并按科目分組求sum
# Modify.........: No.FUN-B80135 11/08/22 By minpp    相關日期欄位不可小於關帳日期
# Modify.........: No.FUN-B90087 11/09/19 By minpp    單頭幣種抓上層公司幣種
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植
# Modify.........: NO.TQC-C40010 12/04/05 By lujh 把必要字段controlz換成controlr
# Modify.........: NO.TQC-CB0085 12/11/27 By fengmy    ass09<= tm.mm改為ass09 = tm.mm 不要有小于號

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm   RECORD    #FUN-BB0036 
             yy        LIKE type_file.num5,      #會計年度
             mm        LIKE type_file.num5,      #期別
             asa01     LIKE asa_file.asa01,      #族群代號
             asa02     LIKE asa_file.asa02,      #上層公司
             asa03     LIKE asa_file.asa03       #帳別
            END RECORD,
       g_aaa04         LIKE aaa_file.aaa04,      #現行會計年度
       g_aaa05         LIKE aaa_file.aaa05,      #現行期別
       g_bdate         LIKE type_file.dat,       #期間起始日期
       g_edate         LIKE type_file.dat,       #期間起始日期
       g_dbs_gl        LIKE type_file.chr21,
       g_dbs_asa02     LIKE type_file.chr21,   
       g_bookno        LIKE aea_file.aea00,      #帳別
       ls_date         STRING,
       l_flag          LIKE type_file.chr1,
       g_change_lang   LIKE type_file.chr1,
       g_rate          LIKE asd_file.asd07b,
       g_asg08         LIKE asg_file.asg08,
       g_ash04         LIKE ash_file.ash04,      #母公司原始銷貨收入科目 
       g_ash04_1       LIKE ash_file.ash04,      #母公司原始資產交易損益科目
       g_sum           LIKE imb_file.imb118,
       g_cnt           LIKE type_file.num5,
       g_ass           RECORD LIKE ass_file.*,
       g_asw           RECORD LIKE asw_file.*,
       g_asg06         LIKE asg_file.asg06,  
       g_rate1         LIKE ase_file.ase05, 
       g_cut           LIKE azi_file.azi04,
       g_asz01        LIKE asz_file.asz01
 DEFINE g_azp01        LIKE azp_file.azp01               #营运中心编号
 DEFINE g_dbs_azp01    LIKE azp_file.azp01       
 DEFINE g_asz          RECORD LIKE asz_file.*
 #FUN-B80135--add--str--
 DEFINE g_aaa07          LIKE aaa_file.aaa07
 DEFINE g_year           LIKE  type_file.chr4
 DEFINE g_month          LIKE  type_file.chr2
 #FUN-B80135--add--end

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

  LET g_bookno = ARG_VAL(1)
  IF g_bookno IS NULL OR g_bookno = ' ' THEN
     SELECT aaz64 INTO g_bookno FROM aaz_file  
  END IF
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.yy    = ARG_VAL(2)
   LET tm.mm    = ARG_VAL(3)
   LET tm.asa01 = ARG_VAL(4)
   LET tm.asa02 = ARG_VAL(5)
   LET tm.asa03 = ARG_VAL(6)
   LET g_bgjob  = ARG_VAL(7)
   IF cl_null(g_bgjob) THEN LET g_bgjob= "N" END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   SELECT * INTO g_asz.* FROM asz_file WHERE asz00 = '0'

   WHILE TRUE
     LET g_change_lang = FALSE
     
     #FUN-B80135--add--str--
     SELECT aaa07 INTO g_aaa07 FROM aaa_file,asz_file
      WHERE aaa01 = asz01 AND asz00 = '0'
      LET g_year = YEAR(g_aaa07)
      LET g_month= MONTH(g_aaa07)
      #FUN-B80135--add—end


     SELECT asz01 INTO g_asz01 FROM asz_file WHERE asz00='0'

     IF g_bgjob = 'N' THEN
        CALL p501_tm(0,0)
        IF cl_sure(21,21) THEN
           CALL cl_wait()
           LET g_success = 'Y'
           BEGIN WORK
           CALL p501()
           CALL s_showmsg()                      
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
              CLOSE WINDOW gglp205_w
              EXIT WHILE
           END IF
        END IF
     ELSE
        #現行會計年度(aaa04)、現行期別(aaa05)
        SELECT aaa04,aaa05 INTO g_aaa04,g_aaa05
          FROM aaa_file WHERE aaa01 = g_asz01
        LET g_success = 'Y'
        BEGIN WORK
        CALL p501()
        CALL s_showmsg()                      
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

FUNCTION p501_tm(p_row,p_col)
   DEFINE  p_row,p_col    LIKE type_file.num5,
           l_cnt          LIKE type_file.num5,
           l_asa03        LIKE asa_file.asa03,
           lc_cmd         LIKE type_file.chr1000
           
   IF s_shut(0) THEN RETURN END IF
  #CALL s_dsmark(g_bookno)

   LET p_row = 4 LET p_col = 30

   OPEN WINDOW gglp205_w AT p_row,p_col WITH FORM "ggl/42f/gglp205" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()

  #CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('q')
   WHILE TRUE 
      CLEAR FORM 
      INITIALIZE tm.* TO NULL                   # Defaealt condition
      #現行會計年度(aaa04)、現行期別(aaa05)
      SELECT aaa04,aaa05 INTO g_aaa04,g_aaa05
        FROM aaa_file WHERE aaa01 = g_asz01

      LET tm.yy = g_aaa04
      LET tm.mm = g_aaa05 
      LET g_bgjob = 'N'
      INPUT BY NAME tm.yy,tm.mm,tm.asa01,tm.asa02,tm.asa03,g_bgjob
            WITHOUT DEFAULTS 
         ON ACTION locale
            LET g_change_lang = TRUE   
            EXIT INPUT                
            
         #No.FUN-B80135--add--str--
         AFTER FIELD   yy       #会计年度
         IF NOT cl_null(tm.yy) THEN
            IF tm.yy < 0 THEN
               CALL cl_err(tm.yy,'apj-035',0)
               NEXT FIELD yy
            END IF

            IF tm.yy < g_year  THEN
               CALL cl_err(tm.yy,'atp-164',0)
               NEXT FIELD yy
            ELSE
               IF tm.yy=g_year AND tm.mm<=g_month THEN
                  CALL cl_err(tm.mm,'atp-164',0)
                  NEXT FIELD mm
               END IF
            END IF
         END IF 
         #No.FUN-B80135--add—end--

         AFTER FIELD mm    
            IF NOT cl_null(tm.mm) THEN
               IF tm.mm < 0 OR tm.mm > 12  THEN 
                  CALL cl_err('','agl-013',0) 
                  NEXT FIELD mm 
               END IF
               #No.FUN-B80135--add--str--
                IF NOT  cl_null(tm.yy)  AND tm.yy=g_year
                   AND tm.mm<=g_month THEN
                   CALL cl_err(tm.mm,'atp-164',0)
                   NEXT FIELD mm
               END IF 
               #No.FUN-B80135--add—end--
            END IF

         AFTER FIELD asa01   #族群代號
            IF NOT cl_null(tm.asa01) THEN
               SELECT DISTINCT asa01 FROM asa_file WHERE asa01=tm.asa01
               IF STATUS THEN
                  CALL cl_err3("sel","asa_file",tm.asa01,tm.asa02,"agl-117","","",0)
                  NEXT FIELD asa01 
               END IF
               #FUN-B90087--ADD--STR--
               SELECT asg06 INTO g_asg06 FROM asg_file,asa_file
                WHERE asa02=asg01
                  AND asa04='Y'
                  AND asa01=tm.asa01
                #FUN-B90087--ADD--END--
            END IF

         AFTER FIELD asa02   #上層公司編號
            IF NOT cl_null(tm.asa02) THEN
               SELECT COUNT(*) INTO l_cnt FROM asa_file 
                WHERE asa01=tm.asa01 AND asa02=tm.asa02
               IF l_cnt = 0  THEN 
                  CALL cl_err3("sel","asa_file",tm.asa01,tm.asa02,"agl-118","","",0) 
                  NEXT FIELD asa02 
               END IF
               SELECT DISTINCT asa03 INTO tm.asa03 FROM asa_file
                WHERE asa01=tm.asa01 AND asa02=tm.asa02
               DISPLAY BY NAME tm.asa03
            END IF

         AFTER FIELD asa03   #帳別 
            IF NOT cl_null(tm.asa03) THEN
               SELECT COUNT(*) INTO l_cnt FROM asa_file 
                WHERE asa01=tm.asa01 AND asa02=tm.asa02 AND asa03=tm.asa03
               IF l_cnt = 0  THEN 
                  CALL cl_err3("sel","asa_file",tm.asa01,tm.asa02,"agl-118","","",0)  
                  NEXT FIELD asa03 
               END IF
            END IF

         #ON ACTION CONTROLZ       #TQC-C40010   mark
          ON ACTION CONTROLR       #TQC-C40010   add
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(asa01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_asa"
                  LET g_qryparam.default1 = tm.asa01
                  CALL cl_create_qry() RETURNING tm.asa01,tm.asa02,tm.asa03
                  DISPLAY BY NAME tm.asa01,tm.asa02,tm.asa03
                  NEXT FIELD asa01
               WHEN INFIELD(asa02) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_asg"
                  LET g_qryparam.default1 = tm.asa02
                  CALL cl_create_qry() RETURNING tm.asa02
                  DISPLAY BY NAME tm.asa02
                  NEXT FIELD asa02
            END CASE

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about      
            CALL cl_about()  
 
         ON ACTION help         
            CALL cl_show_help() 

         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
         BEFORE INPUT
             CALL cl_qbe_init()

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION qbe_save
            CALL cl_qbe_save()

      END INPUT
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()        
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW gglp205_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01= 'gglp205'
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('gglp205','9031',1)   
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " ''",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",tm.asa01 CLIPPED,"'",
                         " '",tm.asa02 CLIPPED,"'",
                         " '",tm.asa03 CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('gglp205',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW gglp205_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE

END FUNCTION
   
FUNCTION p501()
DEFINE #l_sql        LIKE type_file.chr1000,
       l_sql        STRING,   
       i,g_no       LIKE type_file.num5,
       g_dept       DYNAMIC ARRAY OF RECORD        
                     asa01      LIKE asa_file.asa01,  #族群代號
                     asa02      LIKE asa_file.asa02,  #上層公司
                     asa03      LIKE asa_file.asa03,  #帳別
                     asb04      LIKE asb_file.asb04,  #下層公司
                     asb05      LIKE asb_file.asb05   #帳別  
                    END RECORD
   DEFINE           l_azp03     LIKE azp_file.azp03         
   DEFINE           l_azp031    STRING                     
   
   DROP TABLE p501_tmp

   CREATE TEMP TABLE p501_tmp(
      chk       LIKE type_file.chr1,
      asa01     LIKE asa_file.asa01,
      asa02     LIKE asa_file.asa02,
      asa03     LIKE asa_file.asa03,
      asb04     LIKE asb_file.asb04,
      asb05     LIKE asb_file.asb05    );
   #-->step 1 刪除資料
   CALL p501_del()
   IF g_success = 'N' THEN RETURN END IF

   #-->step 2 資料寫入
   CALL g_dept.clear()   #將g_dept清空
   
   CALL p501_dept()    #抓取關係人層級

   LET l_sql=" SELECT asa01,asa02,asa03,asb04,asb05",
             "   FROM p501_tmp ",
             "  ORDER BY asa01,asa02,asa03,asb04"
   PREPARE p501_asa_p FROM l_sql
   IF STATUS THEN 
      CALL cl_err('prepare:1',STATUS,1)             
      CALL cl_batch_bg_javamail('N')                
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM 
   END IF
   DECLARE p501_asa_c CURSOR FOR p501_asa_p
   LET g_no = 1
   CALL s_showmsg_init()                           
   FOREACH p501_asa_c INTO g_dept[g_no].*
      IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success='Y'
      END IF 
      IF SQLCA.SQLCODE THEN 
         CALL s_errmsg(' ',' ','for_asa_c:',STATUS,1)
         LET g_success = 'N'
         RETURN                                     
      END IF
      LET g_no=g_no+1
   END FOREACH
   CALL g_dept.deleteElement(g_no)
   LET g_no=g_no-1
   IF g_totsuccess="N" THEN                                                        
      LET g_success="N"                                                           
   END IF                                                                          

   FOR i =1 TO g_no
      IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y'                                                      
      END IF

      #抓取子公司持股比率
      CALL get_rate(g_dept[i].asb04,g_dept[i].asb05)  

#luttb 110928--mod--str--
#      #處理順流
#      CALL p501_process_down(g_dept[i].*)

#      #處理逆流
#      CALL p501_process_back(g_dept[i].*)

#      #處理側流
#      CALL p501_process_side(g_dept[i].*)
       CALL p501_process(g_dept[i].*)  
#luttb 110928--mod--end

   END FOR
   IF g_totsuccess="N" THEN                                                        
      LET g_success="N"                                                           
   END IF                                                                          
   IF g_success="N" THEN
      RETURN
   END IF 
 
END FUNCTION
   
FUNCTION p501_del() 
 
  #先將舊資料刪除再重新產生
  #-->delete asw_file(合併報表關係人交易資料檔)
  DELETE FROM asw_file 
        WHERE asw01 =tm.yy
          AND asw02 =tm.mm 
          AND asw03 =tm.asa01 
          AND asw031=tm.asa02
  IF SQLCA.sqlcode THEN 
     CALL cl_err3("del","asw_file",tm.asa01,tm.asa02,SQLCA.sqlcode,"","del asw_file",1)  #No.FUN-660123 
     LET g_success = 'N'
     RETURN 
  END IF 

END FUNCTION
   
FUNCTION get_rate(p_asb04,p_asb05)    #持股比率
DEFINE p_asb04    LIKE asb_file.asb04,
       p_asb05    LIKE asb_file.asb05,
       l_asb07    LIKE asb_file.asb07,
       l_asb08    LIKE asb_file.asb08,
       l_asd07b   LIKE asd_file.asd07b,
       l_asd08b   LIKE asd_file.asd08b,
       l_count    LIKE type_file.num5,
       l_sql      LIKE type_file.chr1000

    SELECT asb07,asb08 INTO l_asb07,l_asb08 
      FROM asb_file 
     WHERE asb01=tm.asa01 
       AND asb02=tm.asa02 
       AND asb03=tm.asa03
       AND asb04=p_asb04      #下層公司
       AND asb05=p_asb05      #下層帳號
    IF STATUS THEN
       LET g_rate=0
      #跨層公司抓取時不串asb02,asb03
       SELECT asb07,asb08 INTO l_asb07,l_asb08
         FROM asb_file
        WHERE asb01=tm.asa01
          AND asb04=p_asb04      #下層公司
          AND asb05=p_asb05      #下層帳號
       IF STATUS THEN LET g_rate=0 RETURN END IF
       IF g_edate >= l_asb08 OR cl_null(l_asb08) THEN 
          LET g_rate=l_asb07
          RETURN 
       END IF
       RETURN
    END IF
    IF g_edate >= l_asb08 OR cl_null(l_asb08) THEN 
       LET g_rate=l_asb07      
       RETURN 
    END IF
END FUNCTION
   
#FUNCTION p501_process_down(g_dept)    #處理順流   #luttb 110928
FUNCTION p501_process(g_dept)    #處理順流
DEFINE g_dept       RECORD        
                     asa01      LIKE asa_file.asa01,  #族群代號
                     asa02      LIKE asa_file.asa02,  #上層公司
                     asa03      LIKE asa_file.asa03,  #帳別
                     asb04      LIKE asb_file.asb04,  #下層公司
                     asb05      LIKE asb_file.asb05   #帳別  
                    END RECORD
DEFINE l_asg04      LIKE asg_file.asg04              
DEFINE l_sql        STRING                          
DEFINE l_sum        LIKE ass_file.ass11
DEFINE l_ass14      LIKE ass_file.ass14
DEFINE l_ass05      LIKE ass_file.ass05   #FUN-B80094
DEFINE l_aag19      LIKE aag_file.aag19   #FUN-B80094

#順流:
#1.QBE條件=asa01/asa02[族群代碼]/[上層公司]-->asb04[下層公司]=asg08[關係人代碼]
#2.母公司=上層公司~分錄底稿中有關係人異動碼=asg08[子公司關係人代碼],
#  找出符合QBE年度/期別之分錄底稿
#3.於分錄底稿中抓取銷貨收入科目及金額[利用透過合併銷貨收入科目-->							
#  依據agli003[會計科目設定],找出各公司的原始會計科目							
#4.透過該分錄之應收憑單單號,抓取應收憑單單身的料號-->實際成本加總
#5.銷貨收入-實際成本  =交易損益
#  交易損益-已實現損益=未實現損益 							

   LET g_ash04   = ''  LET g_ash04_1 = ''  LET g_asg08   = ''

   #抓取子公司關係人代碼(asg08)
   SELECT asg08 INTO g_asg08 FROM asg_file 
    WHERE asg01=g_dept.asb04 

   #-->產生asw_file(合併報表關係人交易資料檔)

###
   INITIALIZE g_ass.* TO NULL
   INITIALIZE g_asw.* TO NULL

   SELECT asg04 INTO l_asg04 FROM asg_file WHERE asg01=g_dept.asa02
#   IF l_asg04 = 'Y' THEN   #使用Tiptop否   #先mark测试后续还原
      SELECT asg03 INTO g_dbs_azp01 FROM asg_file WHERE asg01=g_dept.asa02 
      IF STATUS THEN LET g_dbs_azp01 = NULL END IF 
#  ELSE    #先mark测试后续还原
#     RETURN
#  END IF

  #抓母公司的記帳幣別(asg06)
   #LET g_asg06=''   #luttb 110928
   #SELECT asg06 INTO g_asg06 FROM asg_file WHERE asg01=g_dept.asa02   #luttb 110928

   #抓取上層公司的金额,屬於銷貨收入科目,異動碼=子公司關係人代碼

#FUN-B80094--mod--str--
#  LET l_sql = " SELECT SUM(ass11-ass10),ass14 ",
##              "   FROM ",g_dbs_asa02,"ass_file ",
#              "  FROM ",cl_get_target_table(g_dbs_azp01,'ass_file'),   #FUN-B40104
   LET l_sql = " SELECT SUM(ass11-ass10),ass14,ass05,aag19 ",
#luttb 110928--mod--str--
#               "  FROM ",cl_get_target_table(g_dbs_azp01,'ass_file'),   
#               "      ,",cl_get_target_table(g_dbs_azp01,'aag_file'),
                "  FROM ass_file,aag_file ",
#luttb 110928--mod--end
#FUN-B80094--mod--end
               "  WHERE ass00 = '",g_asz01,"'",   #帐套
               "    AND ass01 = '",tm.asa01,"'",   #族群 
               #"    AND ass02 = '",tm.asa02,"'",   #上层公司   #luttb 110928
               "    AND ass08 = '",tm.yy,"'",      #年度
              #"    AND ass09 <= '",tm.mm,"'",     #期别        #TQC-CB0085 mark
               "    AND ass09  = '",tm.mm,"'",     #期别        #TQC-CB0085
               "    AND ass04 = '",g_dept.asa02,"'",   #下层公司(收入方)
               "    AND ass07 = '",g_asg08,"'",                #关系人
              #FUN-B80094--mod--str--
              #"    AND ass05 = '",g_asz.asz07,"' ", 
              #"  GROUP BY ass14"
               "    AND ass00 = aag00 AND ass05 = aag01 ",
               "    AND (aag19 = '23' OR aag19 = '24')",
               "  GROUP BY ass14,ass05,aag19 "
              #FUN-B80094--mod--end
   #CALL cl_replace_sqldb(l_sql) RETURNING l_sql	                    #luttb 110928
   #CALL cl_parse_qry_sql(l_sql,g_dbs_azp01) RETURNING l_sql  #FUN-B40104   #luttb 110928
   PREPARE p501_ass_c11_p FROM l_sql
   DECLARE p501_ass_c11 CURSOR FOR p501_ass_c11_p

   #FOREACH p501_ass_c11 INTO l_sum,l_ass14   #FUN-B80094
   FOREACH p501_ass_c11 INTO l_sum,l_ass14,l_ass05,l_aag19   #FUN-B80094
      IF SQLCA.SQLCODE THEN 
         CALL s_errmsg(' ',' ','p501_ass_c11:',STATUS,1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
      
      LET g_asw.asw01  = tm.yy                      #年度
      LET g_asw.asw02  = tm.mm                      #期別
      LET g_asw.asw03  = tm.asa01                   #族群代號
      LET g_asw.asw031 = tm.asa02                   #上層公司
      SELECT MAX(asw04)+1 INTO g_asw.asw04 
        FROM asw_file
       WHERE asw01=tm.yy    AND asw02 =tm.mm
         AND asw03=tm.asa01 AND asw031=tm.asa02
      IF cl_null(g_asw.asw04) THEN 
         LET g_asw.asw04 = 1                        #項次
      END IF
      LET g_asw.asw05  = '1'                        #交易性質-1.順流
      LET g_asw.asw06  = '1'                        #交易類別-1.存貨
      LET g_asw.asw07  = g_dept.asa02               #來源公司-母公司
      LET g_asw.asw08  = g_dept.asb04               #交易公司-子公司
     #LET g_asw.asw09  = g_asz.asz07               #帳列科目    #FUN-B80094
      LET g_asw.asw09 = l_ass05                    #收入科目FUN-B80094
      #LET g_asw.asw10  = g_aaz.aaz111               #交易科目
#FUN-B80094--mod--str--
     #LET g_asw.asw10  = g_asz.asz10               #交易科目
      IF l_aag19 = '23' THEN
         LET g_asw.asw10 = g_asz.asz10
      END IF 
      IF l_aag19 = '24' THEN
         LET g_asw.asw10 = g_asz.asz07
      END IF 
#FUN-B80094--mod--end
   #  LET g_asw.asw19  = g_aaz.aaz109               #交易科目
      LET g_asw.asw19  = g_asz.asz09               #交易科目
      #LET g_asw.asw11  = l_ass14                    #來源幣別
      LET g_asw.asw11  = g_asg06                    #luttb 110928
      LET g_asw.asw12  = l_sum                      #交易金額=銷貨收入
      LET g_asw.asw13  = 0                          #交易損益
      LET g_asw.asw131 = g_asw.asw12-g_asw.asw13    #已實現損益
      LET g_asw.asw14  = 0
      LET g_asw.asw15  = g_rate                     #持股比率
      LET g_asw.asw16  = 0                          #分配未實現利益=未實現利益   
      LET g_asw.asw17  = ' '                        #來源單號  
      LET g_asw.aswlegal = g_legal                  #所属法人
      #因為採各子公司交易彙總產生，例如j10-->j11的交易順流只有一筆
      #所以要先檢查母公司-->子公司的資料是否已產生過，
      #沒有的話就INSERT，若有則UPDATE
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt 
        FROM asw_file
       WHERE asw01=tm.yy         
         AND asw02 =tm.mm
         AND asw03=tm.asa01      
         AND asw031=tm.asa02
         AND asw05='1'           
         AND asw06 ='1'
         AND asw07=g_dept.asa02  
         AND asw08 =g_dept.asb04
         AND asw11 = g_asw.asw11 
         AND asw09 = g_asw.asw09   #FUN-B80094

      #準備寫入agli012關係人交易明細
      IF g_cnt = 0 THEN    #沒有同樣key值的資料,可以新增 
         #FUN-B80135--add--str--
         IF g_asw.asw01 <g_year OR (g_asw.asw01=g_year AND g_asw.asw02<=g_month) THEN
           CALL cl_err('','atp-164',0)
           LET g_success='N'
           RETURN
          END IF
         #FUN-B80135--add—end--
         INSERT INTO asw_file VALUES(g_asw.*)         
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","asw_file",g_asw.asw01,g_asw.asw02,SQLCA.sqlcode,"","",1)
         END IF
      ELSE                 #有同樣key值的資料,做UPDATE
         UPDATE asw_file SET asw12 =asw12+g_asw.asw12,
                             asw13 =asw13+g_asw.asw13,
                             asw14 =asw14+g_asw.asw14,
                             asw16 =asw16+g_asw.asw16
          WHERE asw01=tm.yy         AND asw02 =tm.mm
            AND asw03=tm.asa01      AND asw031=tm.asa02
            AND asw05='1'           AND asw06 ='1'
            AND asw07=g_dept.asa02  AND asw08 =g_dept.asb04
            AND asw11= g_asw.asw11
            AND asw09 = g_asw.asw09    #FUN-B80094
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            LET g_showmsg=tm.yy,"/",tm.mm
            CALL s_errmsg('asw01,asw02',g_showmsg,'upd_asw',SQLCA.sqlcode,1)
            CONTINUE FOREACH
         END IF
      END IF
   END FOREACH

END FUNCTION

FUNCTION p501_process_back(g_dept)    #處理逆流
DEFINE g_dept       RECORD        
                     asa01      LIKE asa_file.asa01,  #族群代號
                     asa02      LIKE asa_file.asa02,  #上層公司
                     asa03      LIKE asa_file.asa03,  #帳別
                     asb04      LIKE asb_file.asb04,  #下層公司
                     asb05      LIKE asb_file.asb05   #帳別  
                    END RECORD,
       l_sql        STRING,
       l_asg04      LIKE asg_file.asg04,
       l_omb04      LIKE omb_file.omb04,              #產品編號 
       l_omb12      LIKE omb_file.omb12,              #數量    
       l_oma99      LIKE oma_file.oma99,              #多角序號 
       l_poz01      LIKE poz_file.poz01,              #流程代碼 
       l_poz00      LIKE poz_file.poz00,              #流程類別 1:銷售段 2:代采購 
       l_imb_sum    LIKE imb_file.imb118              #銷貨成本 
DEFINE l_sum        LIKE ass_file.ass11
DEFINE l_ass14      LIKE ass_file.ass14
DEFINE l_ass05      LIKE ass_file.ass05   #FUN-B80094
DEFINE l_aag19      LIKE aag_file.aag19   #FUN-B80094

#逆流:
#1.QBE條件=asa01/asa02[族群代碼]/[上層公司]->asb04[下層公司]
#                                          ->asa02[上層公司]->asg08[關係人代碼]
#2.找各子公司分錄底稿抓關係人異動碼=asg08[母公司關係人代碼]，
#  抓取屬於與母公司交易的銷貨收入科目及金額
#3.抓取應收憑單單身的料號-->實際成本
#4.銷貨收入-實際成本=交易損益
#  交易損益-已實現損益=未實現損益
#  未實現損益*持股比率=分配未實現利益
#5.金額需換算成上層公司幣別金額

   SELECT asg04 INTO l_asg04 FROM asg_file WHERE asg01=g_dept.asb04
   IF l_asg04 = 'Y' THEN   #使用Tiptop否 
      SELECT asg03 INTO g_dbs_azp01 FROM asg_file WHERE asg01=g_dept.asa02
      IF STATUS THEN LET g_dbs_azp01 = NULL END IF 
   ELSE     
      RETURN
   END IF

   LET g_ash04   = ''  LET g_ash04_1 = ''  LET g_asg08   = ''


   #抓取母公司關係人代碼(asg08)
   SELECT asg08 INTO g_asg08 FROM asg_file 
    WHERE asg01=g_dept.asa02 

  #抓子公司的記帳幣別(asg06)
   #LET g_asg06=''
   #SELECT asg06 INTO g_asg06 FROM asg_file WHERE asg01=g_dept.asb04  #luttb 110928

   #-->產生asw_file(合併報表關係人交易資料檔)

###
   INITIALIZE g_ass.* TO NULL

   #抓取子公司的金额,屬於銷貨收入科目,異動碼=母公司關係人代碼
#FUN-B80094--mod-str--
#  LET l_sql = " SELECT SUM(ass11-ass10),ass14 ",
# #            "   FROM ",g_dbs_asa02,"ass_file ",
#              "  FROM ",cl_get_target_table(g_dbs_azp01,'ass_file'),   #FUN-B40104
   LET l_sql = " SELECT SUM(ass11-ass10),ass14,ass05,aag19 ",
               "   FROM ",cl_get_target_table(g_dbs_azp01,'ass_file'), 
               "       ,",cl_get_target_table(g_dbs_azp01,'aag_file'),
#FUN-B80094--mod--end
               "  WHERE ass00 = '",g_asz01,"'",   #帐套
               "    AND ass01 = '",tm.asa01,"'",   #族群
               "    AND ass02 = '",tm.asa02,"'",   #上层公司
               "    AND ass08 = '",tm.yy,"'",      #年度
              #"    AND ass09 <= '",tm.mm,"'",     #期别        #TQC-CB0085 mark
               "    AND ass09  = '",tm.mm,"'",     #期别        #TQC-CB0085
               "    AND ass04 = '",g_dept.asb04,"'",   #下层公司(收入方)
               "    AND ass07 = '",g_asg08,"'",                #关系人
              #FUN-B80094--mod-str--
              #"    AND ass05 = '",g_asz.asz07,"' ",
              #"  GROUP BY ass14"
               "    AND ass00 = aag00 AND ass05 = aag01",
               "    AND (aag19 ='23' OR aag19 = '24') ",
               "  GROUP BY ass14,ass05,aag19"
              #FUN-B80094--mod--end
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql	
   CALL cl_parse_qry_sql(l_sql,g_dbs_azp01) RETURNING l_sql  #FUN-B40104
   PREPARE p501_ass_p21 FROM l_sql
   DECLARE p501_ass_c21 CURSOR FOR p501_ass_p21

   #FOREACH p501_ass_c21 INTO l_sum,l_ass14    #FUN-B80094
   FOREACH p501_ass_c21 INTO l_sum,l_ass14,l_ass05,l_aag19    #FUN-B80094
      IF SQLCA.SQLCODE THEN 
         CALL s_errmsg(' ',' ','p501_ass_c21:',STATUS,1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
      
      LET g_asw.asw01  = tm.yy                        #年度
      LET g_asw.asw02  = tm.mm                        #期別
      LET g_asw.asw03  = tm.asa01                     #族群代號
      LET g_asw.asw031 = tm.asa02                     #上層公司
      SELECT MAX(asw04)+1 INTO g_asw.asw04 
        FROM asw_file
       WHERE asw01=tm.yy    AND asw02 =tm.mm
         AND asw03=tm.asa01 AND asw031=tm.asa02
      IF cl_null(g_asw.asw04) THEN 
         LET g_asw.asw04 = 1                          #項次
      END IF
      LET g_asw.asw05  = '2'                          #交易性質-2.逆流
      LET g_asw.asw06  = '1'                          #交易類別-1.存貨
      LET g_asw.asw07  = g_dept.asb04                 #來源公司-子公司
      LET g_asw.asw08  = g_dept.asa02                 #交易公司-母公司
#FUN-B80094--mod--str--
#     LET g_asw.asw09  = g_asz.asz07                 #帳列科目 
#     LET g_asw.asw10  = g_asz.asz10                 #交易科目
      LET g_asw.asw09 = l_ass05                      #收入科目
      IF l_aag19 = '23' THEN 
         LET g_asw.asw10 = g_asz.asz10
      END IF 
      IF l_aag19 = '24' THEN
         LET g_asw.asw10 = g_asz.asz07
      END IF  
#FUN-B80094--mod--end
#     LET g_asw.asw19  = g_aaz.aaz109               #交易科目
      LET g_asw.asw19  = g_asz.asz09               #交易科目
      #LET g_asw.asw11  = l_ass14                      #來源幣別
      LET g_asw.asw11  = g_asg06                       #luttb 110928
      LET g_asw.asw12  = l_sum                        #交易金額=銷貨收入
      LET g_asw.asw13  = 0                            #交易損益=銷貨收入-銷貨成本
      LET g_asw.asw131 = g_asw.asw12-g_asw.asw13 
      LET g_asw.asw14  = 0                            #未實現利益=交易損益-已實現利益
      LET g_asw.asw15  = 0                            #持股比率
      LET g_asw.asw16  = 0                            #分配未實現利益=未實現利益*持股比率/100  
      LET g_asw.asw17  = ' '                          #來源單號   #FUN-910002 mod
      LET g_asw.aswlegal = g_legal
      #因為採各子公司交易彙總產生，例如j11-->j10的交易逆流只有一筆
      #所以要先檢查子公司-->母公司的資料是否已產生過，
      #沒有的話就INSERT，若有則UPDATE
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt FROM asw_file
       WHERE asw01=tm.yy         AND asw02 =tm.mm
         AND asw03=tm.asa01      AND asw031=tm.asa02
         AND asw05='2'           AND asw06 ='1'
         AND asw07=g_dept.asb04  AND asw08 =g_dept.asa02
         AND asw11 = g_asw.asw11   
         AND asw09 = g_asw.asw09   #FUN-B80094
      #準備寫入agli012關係人交易明細
      IF g_cnt = 0 THEN    #沒有同樣key值的資料,可以新增 
         #FUN-B80135--add--str--
         IF g_asw.asw01 <g_year OR (g_asw.asw01=g_year AND g_asw.asw02<=g_month) THEN
           CALL cl_err('','atp-164',0)
           LET g_success='N'
           RETURN
          END IF
         #FUN-B80135--add—end--
         INSERT INTO asw_file VALUES(g_asw.*)
         IF SQLCA.SQLCODE THEN
            CALL cl_err3("ins","asw_file",g_asw.asw01,g_asw.asw02,SQLCA.sqlcode,"","",1)
         END IF
      ELSE                 #有同樣key值的資料,做UPDATE
         UPDATE asw_file SET asw12 =asw12+g_asw.asw12,
                             asw13 =asw13+g_asw.asw13,
                             asw14 =asw14+g_asw.asw14,
                             asw16 =asw16+g_asw.asw16
          WHERE asw01=tm.yy         AND asw02 =tm.mm
            AND asw03=tm.asa01      AND asw031=tm.asa02
            AND asw05='2'           AND asw06 ='1'
            AND asw07=g_dept.asb04  AND asw08 =g_dept.asa02
            AND asw11 = g_asw.asw11 
            AND asw09 = g_asw.asw09   #FUN-B80094
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            LET g_showmsg=tm.yy,"/",tm.mm
            CALL s_errmsg('asw01,asw02',g_showmsg,'upd_asw',SQLCA.sqlcode,1)
            CONTINUE FOREACH
         END IF
      END IF
   END FOREACH
END FUNCTION


FUNCTION p501_process_side(g_dept)    #處理側流
DEFINE g_dept       RECORD        
                     asa01      LIKE asa_file.asa01,   #族群代號
                     asa02      LIKE asa_file.asa02,   #上層公司
                     asa03      LIKE asa_file.asa03,   #帳別
                     asb04      LIKE asb_file.asb04,   #下層公司
                     asb05      LIKE asb_file.asb05    #帳別  
                    END RECORD,
       l_sql        STRING,
       g_asb04      LIKE asb_file.asb04,               #其他下層公司
       l_asg04      LIKE asg_file.asg04
DEFINE l_sum        LIKE ass_file.ass11
DEFINE l_ass14      LIKE ass_file.ass14
DEFINE l_ass05      LIKE ass_file.ass05    #FUN-B80094
DEFINE l_aag19      LIKE aag_file.aag19    #FUN-B80094

#側流:
#依據族群代碼/上層公司
#所屬子公司的關係人交易[同逆流抓取邏輯]

#1.QBE條件=asa01/asa02[族群代碼]/[上層公司]->asb04[下層公司]
#                                          ->asb04[其他下層公司]
#                                          ->asg08[其他下層公司關係人代碼]
#2.找各子公司分錄底稿抓關係人異動碼=asg08[其他子公司關係人代碼]，

   SELECT asg04 INTO l_asg04 FROM asg_file WHERE asg01=g_dept.asb04
   IF l_asg04 = 'Y' THEN   #使用Tiptop否
      SELECT asg03 INTO g_dbs_azp01 FROM asg_file WHERE asg01=g_dept.asa02
      IF STATUS THEN LET g_dbs_azp01 = NULL END IF 
   ELSE
      RETURN
   END IF

   LET g_ash04   = ''  LET g_ash04_1 = ''  LET g_asg08   = ''


   #抓取其他子公司
   LET l_sql="SELECT asb04 ",
             "  FROM asb_file,asa_file ",
             " WHERE asa01=asb01",
             "   AND asa02=asb02",
             "   AND asa03=asb03",
             "   AND asa01='",tm.asa01,"'",
             "   AND asa02='",tm.asa02,"'",
             "   AND asa03='",tm.asa03,"'",
             "   AND asb04!='",g_dept.asb04,"'",
             " ORDER BY asb04"
   PREPARE p501_asb_p FROM l_sql
   IF STATUS THEN 
      CALL cl_err('p501_asb_p',STATUS,1)             
   END IF
   DECLARE p501_asb_c CURSOR FOR p501_asb_p
   FOREACH p501_asb_c INTO g_asb04
      IF SQLCA.SQLCODE THEN 
         CALL s_errmsg(' ',' ','p501_asb_c:',STATUS,1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF

      #抓取其他子公司關係人代碼(asg08)
      SELECT asg08 INTO g_asg08 FROM asg_file 
       WHERE asg01=g_asb04 

      #抓子公司的記帳幣別(asg06)
       #LET g_asg06=''
       #SELECT asg06 INTO g_asg06 FROM asg_file WHERE asg01=g_dept.asb04   #luttb 110928

      #-->產生asw_file(合併報表關係人交易資料檔)
###
      #抓取子公司的金额,屬於銷貨收入科目,異動碼=其他子公司關係人代碼
#FUN-B80094--mod--str--
#    LET l_sql = " SELECT SUM(ass11-ass10),ass14 ",
##                "   FROM ",g_dbs_asa02,"ass_file ",
#                "  FROM ",cl_get_target_table(g_dbs_azp01,'ass_file'),   #FUN-B40104
     LET l_sql = " SELECT SUM(ass11-ass10),ass14,ass05,aag19 ",
                 "  FROM ",cl_get_target_table(g_dbs_azp01,'ass_file'),   
                 "      ,",cl_get_target_table(g_dbs_azp01,'aag_file'),
#FUN-B80094--mod--end
                 "  WHERE ass00 = '",g_asz01,"'",   #帐套
                 "    AND ass01 = '",tm.asa01,"'",   #族群
                 "    AND ass02 = '",tm.asa02,"'",   #上层公司
                 "    AND ass08 = '",tm.yy,"'",      #年度
                #"    AND ass09 <= '",tm.mm,"'",     #期别        #TQC-CB0085 mark
                 "    AND ass09  = '",tm.mm,"'",     #期别        #TQC-CB0085
                 "    AND ass04 = '",g_dept.asb04,"'",   #下层公司(收入方)
                 "    AND ass07 = '",g_asg08,"'",                #关系人
                #FUN-B80094--mod--str--
                #"    AND ass05 = '",g_asz.asz07,"' ",
                #"  GROUP BY ass14"
                 "    AND ass00 = aag00 AND ass05 = aag01 ",
                 "    AND (aag19 = '23' OR aag19 = '24')",
                 "  GROUP BY ass14,ass05,aag19"
                #FUN-B80094--mod--end
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql	
      CALL cl_parse_qry_sql(l_sql,g_dbs_azp01) RETURNING l_sql  #FUN-B40104	
      PREPARE p501_ass_p31 FROM l_sql
      DECLARE p501_ass_c31 CURSOR FOR p501_ass_p31

      #FOREACH p501_ass_c31 INTO l_sum,l_ass14   #FUN-B80094
      FOREACH p501_ass_c31 INTO l_sum,l_ass14,l_ass05,l_aag19   #FUN-B80094
         IF SQLCA.SQLCODE THEN 
            CALL s_errmsg(' ',' ','p501_ass_c31:',STATUS,1)
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF
         LET g_asw.asw01  = tm.yy                        #年度
         LET g_asw.asw02  = tm.mm                        #期別
         LET g_asw.asw03  = tm.asa01                     #族群代號
         LET g_asw.asw031 = tm.asa02                     #上層公司
         SELECT MAX(asw04)+1 INTO g_asw.asw04 
           FROM asw_file
          WHERE asw01=tm.yy    AND asw02 =tm.mm
            AND asw03=tm.asa01 AND asw031=tm.asa02
         IF cl_null(g_asw.asw04) THEN 
            LET g_asw.asw04 = 1                          #項次
         END IF
         LET g_asw.asw05  = '3'                          #交易性質-3.側流
         LET g_asw.asw06  = '1'                          #交易類別-1.存貨
         LET g_asw.asw07  = g_dept.asb04                 #來源公司-子公司
         LET g_asw.asw08  = g_asb04                      #交易公司-其他子公司
#FUN-B80094--mod--str--
#        LET g_asw.asw09  = g_asz.asz07                 #帳列科目  
#        LET g_asw.asw10  = g_asz.asz10                 #交易科目
         LET g_asw.asw09 = l_ass05                      #收入科目
         IF l_aag19 = '23' THEN
            LET g_asw.asw10 = g_asz.asz10
         END IF 
         IF l_aag19 = '24' THEN
            LET g_asw.asw10 = g_asz.asz07
         END IF 
#FUN-B80094--mod--end
    #    LET g_asw.asw19  = g_aaz.aaz109               #交易科目
         LET g_asw.asw19  = g_asz.asz09               #交易科目
         #LET g_asw.asw11  = l_ass14                      #來源幣別
         LET g_asw.asw11  = g_asg06                      #luttb 110928
         LET g_asw.asw12  = l_sum                        #交易金額=銷貨收入
         LET g_asw.asw13  = 0                            #交易損益=銷貨收入-銷貨成本
         LET g_asw.asw131 = g_asw.asw12-g_asw.asw13      #已實現損益
         LET g_asw.asw14  = 0                            #未實現利益=交易損益-已實現利益
         LET g_asw.asw15  = 0                            #持股比率
         LET g_asw.asw16  = 0                            #分配未實現利益=未實現利益*持股比率/100  
         LET g_asw.asw17  = ' '                          #來源單號  
         LET g_asw.aswlegal = g_legal                       #所属法人  
         #因為採各子公司交易彙總產生，例如j11-->j12的交易側流只有一筆
         #所以要先檢查子公司-->其他子公司的資料是否已產生過，
         #沒有的話就INSERT，若有則UPDATE
         LET g_cnt = 0
         SELECT COUNT(*) INTO g_cnt FROM asw_file
          WHERE asw01=tm.yy         AND asw02 =tm.mm
            AND asw03=tm.asa01      AND asw031=tm.asa02
            AND asw05='3'           AND asw06 ='1'
            AND asw07=g_dept.asb04  AND asw08 =g_asb04
            AND asw11 = g_asw.asw11   
            AND asw09 = g_asw.asw09   #FUN-B80094
         #準備寫入agli012關係人交易明細
         IF g_cnt = 0 THEN    #沒有同樣key值的資料,可以新增 
         #FUN-B80135--add--str--
            IF g_asw.asw01 <g_year OR (g_asw.asw01=g_year AND g_asw.asw02<=g_month) THEN
               CALL cl_err('','atp-164',0)
               LET g_success='N'
               RETURN
            END IF
         #FUN-B80135--add—end--
            INSERT INTO asw_file VALUES(g_asw.*)
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("ins","asw_file",g_asw.asw01,g_asw.asw02,SQLCA.sqlcode,"","",1)
            END IF
         ELSE                 #有同樣key值的資料,做UPDATE
            UPDATE asw_file SET asw12 =asw12+g_asw.asw12,
                                asw13 =asw13+g_asw.asw13,
                                asw14 =asw14+g_asw.asw14,
                                asw16 =asw16+g_asw.asw16
             WHERE asw01=tm.yy         AND asw02 =tm.mm
               AND asw03=tm.asa01      AND asw031=tm.asa02
               AND asw05='3'           AND asw06 ='1'
               AND asw07=g_dept.asb04  AND asw08 =g_asb04
               AND asw11=g_asw.asw11
               AND asw09 = g_asw.asw09   #FUN-B80094
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
               LET g_showmsg=tm.yy,"/",tm.mm
               CALL s_errmsg('asw01,asw02',g_showmsg,'upd_asw',SQLCA.sqlcode,1)
               CONTINUE FOREACH
            END IF
         END IF
      END FOREACH
   END FOREACH   

END FUNCTION  

FUNCTION p501_dept()
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_sql       STRING
   DEFINE l_dept      RECORD
                       asa01      LIKE asa_file.asa01,  #族群代號
                       asa02      LIKE asa_file.asa02,  #上層公司
                       asa03      LIKE asa_file.asa03,  #帳別
                       asb04      LIKE asb_file.asb04,  #下層公司
                       asb05      LIKE asb_file.asb05   #帳別  
                      END RECORD 
   DEFINE l_asa02a    LIKE asa_file.asa02 #110928
   DEFINE l_asa03a    LIKE asa_file.asa03 #110928
   DEFINE l_asa02b    LIKE asa_file.asa02 #110928
   DEFINE l_asa03b    LIKE asa_file.asa03 #110928

   #假設集團公司層級如下:A下面有B、C,B下面有D、E,E下面有F,C下面有G
   #       A             #需產生A-B
   #   ┌─┴─┐        #      A-C
   #   B        C        #      A-D
   # ┌┴┐     │       #      A-E
   # D   E      G        #      A-F
   #     │              #      A-G等關係人層級資料
   #     F

 #luttb 110928 mod--str--需產生族群內所有公司對沖關係

   DECLARE sel_asa_cur CURSOR FOR
    SELECT UNIQUE asa02,asa03 FROM asa_file
     WHERE asa01 = tm.asa01
     UNION
    SELECT UNIQUE asb04,asb05 FROM asa_file,asb_file
     WHERE asa01 = asb01 AND asa02 = asb02
       AND asb01 = tm.asa01    
   FOREACH sel_asa_cur INTO l_asa02a,l_asa03a
       DECLARE sel_asa_cur1 CURSOR FOR
        SELECT UNIQUE asa02,asa03 FROM asa_file
         WHERE asa01 = tm.asa01
           AND asa02<>l_asa02a
         UNION
        SELECT UNIQUE asb04,asb05 FROM asa_file,asb_file
         WHERE asa01 = asb01 AND asa02 = asb02
           AND asb01 = tm.asa01   
           AND asb04<>l_asa02a           
        FOREACH sel_asa_cur1 INTO l_asa02b,l_asa03b           
           INSERT INTO p501_tmp VALUES('',tm.asa01,l_asa02a,l_asa03a,l_asa02b,l_asa03b)
        END FOREACH
   END FOREACH 
#   #1.先檢查Temptable裡有沒有資料,沒有的話,先寫入最上一層的關係人層級資料
#   LET l_cnt = 0
#   SELECT COUNT(*) INTO l_cnt FROM p500_tmp
#   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
#   IF l_cnt = 0 THEN CALL p500_bom(tm.asa01,tm.asa02,tm.asa03) END IF 
#   #2-1.檢查Temptable裡有沒有chk=N的資料(表示還未抓它的下層公司),
#   #    沒有的話,表示所有層級資料都產生了,離開此FUNCTION
#   LET l_cnt = 0
#   SELECT COUNT(*) INTO l_cnt FROM p500_tmp WHERE chk='N'
#   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
#   IF l_cnt = 0 THEN RETURN END IF 
#
#   #2-2.檢查Temptable裡有沒有chk=N的資料(表示還未抓它的下層公司),
#   #    以下層公司當上層公司,去抓其下層公司,產生跨層的公司層級資料
#   DECLARE asb_curs1 CURSOR FOR
#      SELECT asa01,asa02,asa03,asb04,asb05
#        FROM p500_tmp
#       WHERE chk='N'
#   FOREACH asb_curs1 INTO l_dept.*
#      CALL p500_bom(l_dept.asa01,l_dept.asb04,l_dept.asb05)
#      UPDATE p500_tmp SET chk='Y'
#       WHERE asa01=l_dept.asa01
#         AND asb04=l_dept.asb04
#         AND asb05=l_dept.asb05
#   END FOREACH
#
#   CALL p500_dept()
#luttb 110928--mod--end

END FUNCTION
#luttb--110928--mark--str--
#FUNCTION p501_bom(p_asa01,p_asa02,p_asa03)
#   DEFINE p_asa01   LIKE asa_file.asa01   #族群代號
#   DEFINE p_asa02   LIKE asa_file.asa02   #上層公司
#   DEFINE p_asa03   LIKE asa_file.asa03   #帳別
#   DEFINE l_sql       STRING

#   LET l_sql="INSERT INTO p501_tmp (chk,asa01,asa02,asa03,asb04,asb05)",
#             "SELECT 'N',",
#             "       '",tm.asa01 CLIPPED,"',",
#             "       '",tm.asa02 CLIPPED,"',",
#             "       '",tm.asa03 CLIPPED,"',",
#             "       asb04,asb05",
#             "  FROM asb_file,asa_file ",
#             " WHERE asa01=asb01 AND asa02=asb02 AND asa03=asb03 ",
#             "   AND asa01=? AND asa02=? AND asa03=?"
#   PREPARE p501_asb_p1 FROM l_sql
#   EXECUTE p501_asb_p1 USING p_asa01,p_asa02,p_asa03

#END FUNCTION
#luttb --110928--mark--end
#NO.FUN-B40104
