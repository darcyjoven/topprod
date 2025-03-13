# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Pattern name...: aglp500.4gl
# Descriptions...: 合併報表關係人交易明細產生作業(整批資料處理作業)--from应收系统
# Date&Author....: 10/12/14 By lutingting copy from aglp005
# Modify.........: NO.FUN-B40104 11/05/05 By jll   合并报表作業產品
# Modify.........: NO.FUN-B60134 11/06/27 BY minpp    給 axv13,axv131,axv14 賦值
# Modify.........: No.FUN-B80135 11/08/22 By minpp    相關日期欄位不可小於關帳日期
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm   RECORD  
             yy        LIKE type_file.num5,      #會計年度
             mm        LIKE type_file.num5,      #期別
             axa01     LIKE axa_file.axa01,      #族群代號
             axa02     LIKE axa_file.axa02,      #上層公司
             axa03     LIKE axa_file.axa03       #帳別
            END RECORD,
       g_aaa04         LIKE aaa_file.aaa04,      #現行會計年度
       g_aaa05         LIKE aaa_file.aaa05,      #現行期別
       g_bdate         LIKE type_file.dat,       #期間起始日期
       g_edate         LIKE type_file.dat,       #期間起始日期
       g_dbs_gl        LIKE type_file.chr21,
       g_dbs_axa02     LIKE type_file.chr21,   
       g_bookno        LIKE aea_file.aea00,      #帳別
       ls_date         STRING,
       l_flag          LIKE type_file.chr1,
       g_change_lang   LIKE type_file.chr1,
       g_rate          LIKE axd_file.axd07b,
       g_axz08         LIKE axz_file.axz08,
       g_axe04         LIKE axe_file.axe04,      #母公司原始銷貨收入科目 
       g_axe04_1       LIKE axe_file.axe04,      #母公司原始資產交易損益科目
       g_sum           LIKE imb_file.imb118,
       g_cnt           LIKE type_file.num5,
       g_npq           RECORD LIKE npq_file.*,
       g_axv           RECORD LIKE axv_file.*,
       g_axz06         LIKE axz_file.axz06,  
       g_rate1         LIKE axp_file.axp05, 
       g_cut           LIKE azi_file.azi04 
 DEFINE g_azp01        LIKE azp_file.azp01               #营运中心编号
 DEFINE g_dbs_azp01    LIKE azp_file.azp01
 DEFINE g_aaw01        LIKE aaw_file.aaw01      
 DEFINE g_aaw        RECORD LIKE aaw_file.*
#FUN-B80135--add--str--
 DEFINE g_aaa07        LIKE aaa_file.aaa07
 DEFINE g_year         LIKE  type_file.chr4
 DEFINE g_month        LIKE  type_file.chr2
#FUN-B80135--add--end

 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   LET g_bookno = ARG_VAL(1)
   IF g_bookno IS NULL OR g_bookno = ' ' THEN
      SELECT aaz64 INTO g_bookno FROM aaz_file    #總帳預設帳別
   END IF
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.yy    = ARG_VAL(2)
   LET tm.mm    = ARG_VAL(3)
   LET tm.axa01 = ARG_VAL(4)
   LET tm.axa02 = ARG_VAL(5)
   LET tm.axa03 = ARG_VAL(6)
   LET g_bgjob  = ARG_VAL(7)
   IF cl_null(g_bgjob) THEN LET g_bgjob= "N" END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   SELECT * INTO g_aaw.* FROM aaw_file WHERE aaw00 = '0'
   SELECT aaw01 INTO g_aaw01 FROM aaw_file WHERE aaw00='0'  #FUN-B80135
   #FUN-B80135--add--str--
   SELECT aaa07 INTO g_aaa07 FROM aaa_file,aaw_file
    WHERE aaa01 = aaw01 AND aaw00 = '0'
   LET g_year = YEAR(g_aaa07)
   LET g_month= MONTH(g_aaa07)
   #FUN-B80135--add—end

   WHILE TRUE
     LET g_change_lang = FALSE
     IF g_bgjob = 'N' THEN
        CALL p500_tm(0,0)
        IF cl_sure(21,21) THEN
           CALL cl_wait()
           LET g_success = 'Y'
           BEGIN WORK
           CALL p500()
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
              CLOSE WINDOW aglp500_w
              EXIT WHILE
           END IF
        END IF
     ELSE
        #現行會計年度(aaa04)、現行期別(aaa05)
        SELECT aaa04,aaa05 INTO g_aaa04,g_aaa05
          FROM aaa_file 
        #WHERE aaa01 = g_bookno 
         WHERE aaa01 = g_aaw01
        LET g_success = 'Y'
        BEGIN WORK
        CALL p500()
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

FUNCTION p500_tm(p_row,p_col)
   DEFINE  p_row,p_col    LIKE type_file.num5,
           l_cnt          LIKE type_file.num5,
           l_axa03        LIKE axa_file.axa03,
           lc_cmd         LIKE type_file.chr1000
           
   IF s_shut(0) THEN RETURN END IF
#   CALL s_dsmark(g_bookno)     #FUN-B80135

   LET p_row = 4 LET p_col = 30

   OPEN WINDOW aglp500_w AT p_row,p_col WITH FORM "agl/42f/aglp500" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()

# Prog. Version..: '5.30.06-13.03.12(0,0,g_bookno)  #FUN-B80135
   CALL cl_opmsg('q')
   WHILE TRUE 
      CLEAR FORM 
      INITIALIZE tm.* TO NULL                   # Defaealt condition
      #現行會計年度(aaa04)、現行期別(aaa05)
      SELECT aaa04,aaa05 INTO g_aaa04,g_aaa05
        FROM aaa_file 
       #WHERE aaa01 = g_bookno   #FUN-B80135
        WHERE aaa01 = g_aaw01    #FUN-B80135
      LET tm.yy = g_aaa04
      LET tm.mm = g_aaa05 
      LET g_bgjob = 'N'
      INPUT BY NAME tm.yy,tm.mm,tm.axa01,tm.axa02,tm.axa03,g_bgjob
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
                 CALL cl_err(tm.yy,'axm-164',0)
                 NEXT FIELD  yy
              END IF
              IF tm.yy=g_year AND tm.mm<=g_month THEN
                CALL cl_err(tm.mm,'axm-164',0)
                NEXT FIELD  mm
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
                  CALL cl_err(tm.mm,'axm-164',0)
                  NEXT FIELD mm
               END IF 
               #No.FUN-B80135--add—end--

            END IF

         AFTER FIELD axa01   #族群代號
            IF NOT cl_null(tm.axa01) THEN
               SELECT DISTINCT axa01 FROM axa_file WHERE axa01=tm.axa01
               IF STATUS THEN
                  CALL cl_err3("sel","axa_file",tm.axa01,tm.axa02,"agl-117","","",0)
                  NEXT FIELD axa01 
               END IF
            END IF

         AFTER FIELD axa02   #上層公司編號
            IF NOT cl_null(tm.axa02) THEN
               SELECT COUNT(*) INTO l_cnt FROM axa_file 
                WHERE axa01=tm.axa01 AND axa02=tm.axa02
               IF l_cnt = 0  THEN 
                  CALL cl_err3("sel","axa_file",tm.axa01,tm.axa02,"agl-118","","",0) 
                  NEXT FIELD axa02 
               END IF
               SELECT DISTINCT axa03 INTO tm.axa03 FROM axa_file
                WHERE axa01=tm.axa01 AND axa02=tm.axa02
               DISPLAY BY NAME tm.axa03
            END IF

         AFTER FIELD axa03   #帳別 
            IF NOT cl_null(tm.axa03) THEN
               SELECT COUNT(*) INTO l_cnt FROM axa_file 
                WHERE axa01=tm.axa01 AND axa02=tm.axa02 AND axa03=tm.axa03
               IF l_cnt = 0  THEN 
                  CALL cl_err3("sel","axa_file",tm.axa01,tm.axa02,"agl-118","","",0)  
                  NEXT FIELD axa03 
               END IF
            END IF

         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(axa01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_axa"
                  LET g_qryparam.default1 = tm.axa01
                  CALL cl_create_qry() RETURNING tm.axa01,tm.axa02,tm.axa03
                  DISPLAY BY NAME tm.axa01,tm.axa02,tm.axa03
                  NEXT FIELD axa01
               WHEN INFIELD(axa02) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_axz"
                  LET g_qryparam.default1 = tm.axa02
                  CALL cl_create_qry() RETURNING tm.axa02
                  DISPLAY BY NAME tm.axa02
                  NEXT FIELD axa02
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
         CLOSE WINDOW aglp500_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01= 'aglp500'
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('aglp500','9031',1)   
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " ''",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",tm.axa01 CLIPPED,"'",
                         " '",tm.axa02 CLIPPED,"'",
                         " '",tm.axa03 CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('aglp500',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW aglp500_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE

END FUNCTION
   
FUNCTION p500()
DEFINE #l_sql        LIKE type_file.chr1000,
       l_sql        STRING,   
       i,g_no       LIKE type_file.num5,
       g_dept       DYNAMIC ARRAY OF RECORD        
                     axa01      LIKE axa_file.axa01,  #族群代號
                     axa02      LIKE axa_file.axa02,  #上層公司
                     axa03      LIKE axa_file.axa03,  #帳別
                     axb04      LIKE axb_file.axb04,  #下層公司
                     axb05      LIKE axb_file.axb05   #帳別  
                    END RECORD
   DEFINE           l_azp03     LIKE azp_file.azp03         
   DEFINE           l_azp031    STRING                     
   
   DROP TABLE p500_tmp

   CREATE TEMP TABLE p500_tmp(
      chk       LIKE type_file.chr1,   
      axa01     LIKE axa_file.axa01,  
      axa02     LIKE axa_file.axa02,  
      axa03     LIKE axa_file.axa03,  
      axb04     LIKE axb_file.axb04,  
      axb05     LIKE axb_file.axb05    );

   #-->step 1 刪除資料
   CALL p500_del()
   IF g_success = 'N' THEN RETURN END IF

   #-->step 2 資料寫入
   CALL g_dept.clear()   #將g_dept清空
   
#   SELECT  azp03,azp01 INTO l_azp03,g_azp01 
#    FROM  axz_file,azp_file WHERE axz01 = tm.axa02 AND axz03 = azp01
   SELECT axz03 INTO g_azp01 FROM axz_file WHERE axz01 = tm.axa02 AND axz03 = azp01   #NO.FUN-B40104
#   LET l_azp031 = s_dbstring(l_azp03 CLIPPED)
#   LET l_sql = "SELECT * FROM ",l_azp031 CLIPPED,"aaz_file"
   PREPARE aaz_sel FROM l_sql
   EXECUTE aaz_sel INTO g_aaz.*   

   CALL p500_dept()    #抓取關係人層級

   LET l_sql=" SELECT axa01,axa02,axa03,axb04,axb05",
             "   FROM p500_tmp ",
             "  ORDER BY axa01,axa02,axa03,axb04"
   PREPARE p500_axa_p FROM l_sql
   IF STATUS THEN 
      CALL cl_err('prepare:1',STATUS,1)             
      CALL cl_batch_bg_javamail('N')                
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM 
   END IF
   DECLARE p500_axa_c CURSOR FOR p500_axa_p
   LET g_no = 1
   CALL s_showmsg_init()                           
   FOREACH p500_axa_c INTO g_dept[g_no].*
      IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success='Y'
      END IF 
      IF SQLCA.SQLCODE THEN 
         CALL s_errmsg(' ',' ','for_axa_c:',STATUS,1)
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
      CALL get_rate(g_dept[i].axb04,g_dept[i].axb05)  

      #處理順流
      CALL p500_process_down(g_dept[i].*)

      #處理逆流
      CALL p500_process_back(g_dept[i].*)

      #處理側流
      CALL p500_process_side(g_dept[i].*)

   END FOR
   IF g_totsuccess="N" THEN                                                        
      LET g_success="N"                                                           
   END IF                                                                          
   IF g_success="N" THEN
      RETURN
   END IF 
 
END FUNCTION
   
FUNCTION p500_del() 
 
  #先將舊資料刪除再重新產生
  #-->delete axv_file(合併報表關係人交易資料檔)
  DELETE FROM axv_file 
        WHERE axv01 =tm.yy
          AND axv02 =tm.mm 
          AND axv03 =tm.axa01 
          AND axv031=tm.axa02
  IF SQLCA.sqlcode THEN 
     CALL cl_err3("del","axv_file",tm.axa01,tm.axa02,SQLCA.sqlcode,"","del axv_file",1)  #No.FUN-660123 
     LET g_success = 'N'
     RETURN 
  END IF 

END FUNCTION
   
FUNCTION get_rate(p_axb04,p_axb05)    #持股比率
DEFINE p_axb04    LIKE axb_file.axb04,
       p_axb05    LIKE axb_file.axb05,
       l_axb07    LIKE axb_file.axb07,
       l_axb08    LIKE axb_file.axb08,
       l_axd07b   LIKE axd_file.axd07b,
       l_axd08b   LIKE axd_file.axd08b,
       l_count    LIKE type_file.num5,
       l_sql      LIKE type_file.chr1000

    SELECT axb07,axb08 INTO l_axb07,l_axb08 
      FROM axb_file 
     WHERE axb01=tm.axa01 
       AND axb02=tm.axa02 
       AND axb03=tm.axa03
       AND axb04=p_axb04      #下層公司
       AND axb05=p_axb05      #下層帳號
    IF STATUS THEN
       LET g_rate=0
      #跨層公司抓取時不串axb02,axb03
       SELECT axb07,axb08 INTO l_axb07,l_axb08
         FROM axb_file
        WHERE axb01=tm.axa01
          AND axb04=p_axb04      #下層公司
          AND axb05=p_axb05      #下層帳號
       IF STATUS THEN LET g_rate=0 RETURN END IF
       IF g_edate >= l_axb08 OR cl_null(l_axb08) THEN 
          LET g_rate=l_axb07
          RETURN 
       END IF
       RETURN
    END IF
    IF g_edate >= l_axb08 OR cl_null(l_axb08) THEN 
       LET g_rate=l_axb07      
       RETURN 
    END IF
END FUNCTION
   
FUNCTION p500_process_down(g_dept)    #處理順流
DEFINE g_dept       RECORD        
                     axa01      LIKE axa_file.axa01,  #族群代號
                     axa02      LIKE axa_file.axa02,  #上層公司
                     axa03      LIKE axa_file.axa03,  #帳別
                     axb04      LIKE axb_file.axb04,  #下層公司
                     axb05      LIKE axb_file.axb05   #帳別  
                    END RECORD,
       l_omb04      LIKE omb_file.omb04,              #產品編號  
       l_omb12      LIKE omb_file.omb12,              #數量     
       l_imb_sum    LIKE imb_file.imb118              #銷貨成本 
DEFINE l_axz04      LIKE axz_file.axz04              
DEFINE l_sql        STRING                          
DEFINE l_npp02b     LIKE npp_file.npp02            
DEFINE l_npp02e     LIKE npp_file.npp02           


#順流:
#1.QBE條件=axa01/axa02[族群代碼]/[上層公司]-->axb04[下層公司]=axz08[關係人代碼]
#2.母公司=上層公司~分錄底稿中有關係人異動碼=axz08[子公司關係人代碼],
#  找出符合QBE年度/期別之分錄底稿
#3.於分錄底稿中抓取銷貨收入科目及金額[利用透過合併銷貨收入科目-->							
#  依據agli003[會計科目設定],找出各公司的原始會計科目							
#4.透過該分錄之應收憑單單號,抓取應收憑單單身的料號-->實際成本加總
#5.銷貨收入-實際成本  =交易損益
#  交易損益-已實現損益=未實現損益 							

   LET g_axe04   = ''  LET g_axe04_1 = ''  LET g_axz08   = ''

   #抓取子公司關係人代碼(axz08)
   SELECT axz08 INTO g_axz08 FROM axz_file 
    WHERE axz01=g_dept.axb04 

   #-->產生axv_file(合併報表關係人交易資料檔)

###存貨
   INITIALIZE g_npq.* TO NULL
   INITIALIZE g_axv.* TO NULL

   SELECT axz04 INTO l_axz04 FROM axz_file WHERE axz01=g_dept.axa02
   IF l_axz04 = 'Y' THEN   #使用Tiptop否
  #    SELECT azp03,azp01 INTO g_dbs_axa02,g_dbs_azp01 FROM azp_file 
  #     WHERE azp01=(SELECT axz03 FROM axz_file WHERE axz01=g_dept.axa02)
       SELECT axz03 INTO g_dbs_azp01 FROM axz_file WHERE axz01=g_dept.axa02  #FUN-B40104
  #    IF STATUS THEN LET g_dbs_azp01 = NULL END IF
  #    IF NOT cl_null(g_dbs_axa02) THEN 
  #       LET g_dbs_new = s_dbstring(g_dbs_axa02 CLIPPED)
  #    END IF
  #    LET g_dbs_axa02 = g_dbs_new CLIPPED
   ELSE
      RETURN
   END IF

  #抓母公司的記帳幣別(axz06)
   LET g_axz06=''
   SELECT axz06 INTO g_axz06 FROM axz_file WHERE axz01=g_dept.axa02

   #抓取上層公司的分錄底稿,屬於銷貨收入科目,異動碼=子公司關係人代碼
   LET l_npp02b = MDY(tm.mm,1,tm.yy)        #取得當月第一天
   LET l_npp02e = s_monend(tm.yy,tm.mm)     #取得當月最後一天

   LET l_sql = "SELECT npq_file.* ",
         #     "  FROM ",g_dbs_axa02,"npp_file,",
         #               g_dbs_axa02,"npq_file",
               " FROM ",cl_get_target_table(g_dbs_azp01,'npp_file,'),
                        cl_get_target_table(g_dbs_azp01,'npq_file'),
               " WHERE nppsys = npqsys",
               "   AND npptype= npqtype ",
               "   AND npp00  = npq00 ",
               "   AND npp01  = npq01 ",
               "   AND npp011 = npq011",
               "   AND nppsys = 'AR'",
               "   AND npptype= '0'",
               "   AND npp00  = 2",
               "   AND npp011 = 1",
               "   AND npp02 BETWEEN '",l_npp02b,"' AND '",l_npp02e,"'",
        #抓取母公司原始銷貨收入科目(axe04)
               "   AND npq03 IN (SELECT axe04 FROM axe_file ",
               " WHERE axe01='",g_dept.axa02,"'",
               "   AND axe00='",g_dept.axa03,"'",
               "   AND axe13='",tm.axa01,"'",
               "   AND axe06='",g_aaw.aaw07,"')",   #銷貨收入科目
               "   AND npq37='",g_axz08,"'"          #異動碼-關係人
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql	
   CALL cl_parse_qry_sql(l_sql,g_dbs_azp01) RETURNING l_sql  #FUN-B40104
   PREPARE p500_npq_c11_p FROM l_sql
   DECLARE p500_npq_c11 CURSOR FOR p500_npq_c11_p

   FOREACH p500_npq_c11 INTO g_npq.*
      IF SQLCA.SQLCODE THEN 
         CALL s_errmsg(' ',' ','p500_npq_c11:',STATUS,1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
      
      #-->銷貨成本
      #依據分錄底稿->應收憑單單號(npq23)->該應收憑單之單身所有料號的成本加總
      #料號的成本來源為aimi106的實際成本(d3)加總
      LET g_sum = 0
     #應收單身的產品編號,數量
      DECLARE p500_omb_c1 CURSOR FOR
         SELECT omb04,omb12 FROM omb_file
          WHERE omb01=g_npq.npq23
      FOREACH p500_omb_c1 INTO l_omb04,l_omb12
         IF cl_null(l_omb12) THEN LET l_omb12 = 0 END IF
         SELECT SUM(imb211 +imb212 +imb2131+imb2132+imb214 + 
                    imb215 +imb2151+imb216 +imb2171+imb2172+
                    imb219 +imb220 +imb221 +imb222 +imb2231+
                    imb2232+imb224 +imb225 +imb226 +imb2251+
                    imb2271+imb2272+imb229 +imb230)
           INTO l_imb_sum   #FUN-780068 mod 10/19 g_sum->l_imb_sum
           FROM imb_file
          WHERE imb01 = l_omb04 
         IF SQLCA.SQLCODE THEN
            LET l_imb_sum = 0  
         END IF
         IF cl_null(l_imb_sum) THEN LET l_imb_sum = 0 END IF
         LET g_sum = g_sum + l_imb_sum * l_omb12
      END FOREACH
     #銷貨成本是依本國幣呈現,需換算成交易幣別的金額
      LET g_rate1 = 0
      CALL p500_getrate(tm.yy,tm.mm,g_axz06,g_npq.npq24) RETURNING g_rate1
      LET g_sum = g_sum * g_rate1
      LET g_cut = 0
      SELECT azi04 INTO g_cut FROM azi_file WHERE azi01=g_npq.npq24
      IF cl_null(g_cut) THEN LET g_cut=0 END IF
      LET g_sum=cl_digcut(g_sum,g_cut)

      LET g_axv.axv01  = tm.yy                      #年度
      LET g_axv.axv02  = tm.mm                      #期別
      LET g_axv.axv03  = tm.axa01                   #族群代號
      LET g_axv.axv031 = tm.axa02                   #上層公司
      SELECT MAX(axv04)+1 INTO g_axv.axv04 
        FROM axv_file
       WHERE axv01=tm.yy    AND axv02 =tm.mm
         AND axv03=tm.axa01 AND axv031=tm.axa02
      IF cl_null(g_axv.axv04) THEN 
         LET g_axv.axv04 = 1                        #項次
      END IF
      LET g_axv.axv05  = '1'                        #交易性質-1.順流
      LET g_axv.axv06  = '1'                        #交易類別-1.存貨
      LET g_axv.axv07  = g_dept.axa02               #來源公司-母公司
      LET g_axv.axv08  = g_dept.axb04               #交易公司-子公司
      LET g_axv.axv09  = g_aaw.aaw07               #帳列科目 
      LET g_axv.axv10  = ' '                        #交易科目
#     LET g_axv.axv19  = g_aaz.aaz109               #交易科目
      LET g_axv.axv11  = g_npq.npq24                #來源幣別
      LET g_axv.axv12  = g_npq.npq07               #交易金額=銷貨收入
#     LET g_axv.axv13  = g_npq.npq07-g_sum         #交易損益=銷貨收入-銷貨成本 #FUN-B60134 MARK
      IF cl_null(g_sum) THEN LET g_sum = 0 END IF
      LET g_axv.axv13  = g_sum                      #FUN-B60134 ADD
#     LET g_axv.axv131 = 0                          #已實現損益  #FUN-B60134  MARK
      LET g_axv.axv131 = g_axv.axv12-g_axv.axv14-g_axv.axv13   #FUN-B60134  ADD
#     LET g_axv.axv14  = g_axv.axv13-g_axv.axv131   #未實現利益=交易損益-已實現利益 #FUN-B60134  MARK
      LET g_axv.axv14  = 0                          #FUN-B60134  ADD
      LET g_axv.axv15  = g_rate                     #持股比率
      LET g_axv.axv16  = g_axv.axv14                #分配未實現利益=未實現利益   
      LET g_axv.axv17  = ' '                        #來源單號  
      LET g_axv.axvlegal =  g_legal                 #所属法人     #NO.FUN-B40104
      #因為採各子公司交易彙總產生，例如j10-->j11的交易順流只有一筆
      #所以要先檢查母公司-->子公司的資料是否已產生過，
      #沒有的話就INSERT，若有則UPDATE
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt 
        FROM axv_file
       WHERE axv01=tm.yy         
         AND axv02 =tm.mm
         AND axv03=tm.axa01      
         AND axv031=tm.axa02
         AND axv05='1'           
         AND axv06 ='1'
         AND axv07=g_dept.axa02  
         AND axv08 =g_dept.axb04
         AND axv11 = g_axv.axv11 
      #準備寫入agli012關係人交易明細
      IF g_cnt = 0 THEN    #沒有同樣key值的資料,可以新增 
         #FUN-B80135--add--str--
         IF g_axv.axv01 <g_year OR (g_axv.axv01=g_year AND g_axv.axv02<=g_month) THEN
           CALL cl_err('','axm-164',0)
           LET g_success='N'
           RETURN
          END IF
         #FUN-B80135--add—end--

         INSERT INTO axv_file VALUES(g_axv.*)         
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","axv_file",g_axv.axv01,g_axv.axv02,SQLCA.sqlcode,"","",1)
         END IF
      ELSE                 #有同樣key值的資料,做UPDATE
         UPDATE axv_file SET axv12 =axv12+g_axv.axv12,
                             axv13 =axv13+g_axv.axv13,
                             axv131 = axv131+g_axv.axv131,#FUN-B60134  ADD
                             axv14 =axv14+g_axv.axv14,
                             axv16 =axv16+g_axv.axv16
          WHERE axv01=tm.yy         AND axv02 =tm.mm
            AND axv03=tm.axa01      AND axv031=tm.axa02
            AND axv05='1'           AND axv06 ='1'
            AND axv07=g_dept.axa02  AND axv08 =g_dept.axb04
            AND axv11= g_axv.axv11
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            LET g_showmsg=tm.yy,"/",tm.mm
            CALL s_errmsg('axv01,axv02',g_showmsg,'upd_axv',SQLCA.sqlcode,1)
            CONTINUE FOREACH
         END IF
      END IF
   END FOREACH

END FUNCTION

FUNCTION p500_process_back(g_dept)    #處理逆流
DEFINE g_dept       RECORD        
                     axa01      LIKE axa_file.axa01,  #族群代號
                     axa02      LIKE axa_file.axa02,  #上層公司
                     axa03      LIKE axa_file.axa03,  #帳別
                     axb04      LIKE axb_file.axb04,  #下層公司
                     axb05      LIKE axb_file.axb05   #帳別  
                    END RECORD,
       l_sql        STRING,
       l_axz04      LIKE axz_file.axz04,
       l_omb04      LIKE omb_file.omb04,              #產品編號 
       l_omb12      LIKE omb_file.omb12,              #數量    
       l_oma99      LIKE oma_file.oma99,              #多角序號 
       l_poz01      LIKE poz_file.poz01,              #流程代碼 
       l_poz00      LIKE poz_file.poz00,              #流程類別 1:銷售段 2:代采購 
       l_imb_sum    LIKE imb_file.imb118              #銷貨成本 
DEFINE l_npp02b     LIKE npp_file.npp02              
DEFINE l_npp02e     LIKE npp_file.npp02         
DEFINE l_azp01      LIKE azp_file.azp01               #营运中心
#逆流:
#1.QBE條件=axa01/axa02[族群代碼]/[上層公司]->axb04[下層公司]
#                                          ->axa02[上層公司]->axz08[關係人代碼]
#2.找各子公司分錄底稿抓關係人異動碼=axz08[母公司關係人代碼]，
#  抓取屬於與母公司交易的銷貨收入科目及金額
#3.抓取應收憑單單身的料號-->實際成本
#4.銷貨收入-實際成本=交易損益
#  交易損益-已實現損益=未實現損益
#  未實現損益*持股比率=分配未實現利益
#5.金額需換算成上層公司幣別金額

   SELECT axz04 INTO l_axz04 FROM axz_file WHERE axz01=g_dept.axb04
   IF l_axz04 = 'Y' THEN   #使用Tiptop否
      #以下層公司(axb04)的營運中心代碼(axz03)去抓所在的資料庫代碼(azp03)
#      SELECT azp03 INTO g_dbs_new FROM azp_file 
#      WHERE azp01=(SELECT axz03 FROM axz_file WHERE axz01=g_dept.axb04)
       SELECT axz03 INTO l_azp01 FROM axz_file WHERE axz01=g_dept.axb04     #FUN-B40104
#      IF STATUS THEN LET g_dbs_new = NULL END IF
#      IF NOT cl_null(g_dbs_new) THEN 
#         LET g_dbs_new=g_dbs_new CLIPPED,'.' 
#      END IF
#      LET g_dbs_gl = g_dbs_new CLIPPED
   ELSE
      RETURN
   END IF

   LET g_axe04   = ''  LET g_axe04_1 = ''  LET g_axz08   = ''


   #抓取母公司關係人代碼(axz08
   SELECT axz08 INTO g_axz08 FROM axz_file 
    WHERE axz01=g_dept.axa02 

  #抓子公司的記帳幣別(axz06)
   LET g_axz06=''
   SELECT axz06 INTO g_axz06 FROM axz_file WHERE axz01=g_dept.axb04

   #-->產生axv_file(合併報表關係人交易資料檔)

###存貨
   INITIALIZE g_npq.* TO NULL

   LET l_npp02b = MDY(tm.mm,1,tm.yy)        #取得當月第一天   
   LET l_npp02e = s_monend(tm.yy,tm.mm)     #取得當月最後一天

   #抓取子公司的分錄底稿,屬於銷貨收入科目,異動碼=母公司關係人代碼
   LET l_sql ="SELECT npq_file.* ",
#             "  FROM ",g_dbs_gl,"npp_file,",
#                       g_dbs_gl,"npq_file ",
              "  FROM ",cl_get_target_table(l_azp01,'npp_file,'),
                        cl_get_target_table(l_azp01,'npq_file'),
              "  WHERE nppsys = npqsys",
              "   AND npptype= npqtype",
              "   AND npp00  = npq00",
              "   AND npp01  = npq01",
              "   AND npp011 = npq011",
              "   AND nppsys = 'AR'",
              "   AND npptype= '0'",
              "   AND npp00  = 2",
              "   AND npp011 = 1",
              "   AND npp02 BETWEEN '",l_npp02b,"' AND '",l_npp02e,"'",  
             #抓取子公司原始銷貨收入科目(axe04)
              "   AND npq03 IN (SELECT axe04 FROM axe_file", 
              "                  WHERE axe01='",g_dept.axb04,"'",
              "                    AND axe00='",g_dept.axb05,"'",
              "                    AND axe13='",tm.axa01,"'",      
              "                    AND axe06='",g_aaw.aaw07,"')", #銷貨收入科目
              "   AND npq37  = '",g_axz08,"'"       #異動碼-關係人
	CALL cl_replace_sqldb(l_sql) RETURNING l_sql	
        CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql
   PREPARE p500_npq_p21 FROM l_sql
   DECLARE p500_npq_c21 CURSOR FOR p500_npq_p21

   FOREACH p500_npq_c21 INTO g_npq.*
      IF SQLCA.SQLCODE THEN 
         CALL s_errmsg(' ',' ','p500_npq_c21:',STATUS,1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
      
      #-->銷貨成本
      #依據分錄底稿->應收憑單單號(npq23)->該應收憑單之單身所有料號的成本加總
      #料號的成本來源為aimi106的實際成本(d3)加總
      LET g_sum = 0
     #應收單身的產品編號,數量
      LET l_sql = "SELECT oma99,omb04,omb12 ",     
       #           "  FROM ",g_dbs_gl,"omb_file ,",
       #                     g_dbs_gl,"oma_file ", 
                   "  FROM ",cl_get_target_table(l_azp01,'omb_file,'),   #FUN-B40104
                             cl_get_target_table(l_azp01,'oma_file'),   #FUN-B40104
                  "  WHERE omb01='",g_npq.npq23,"'",
                  "   AND oma01 = omb01 "        
	CALL cl_replace_sqldb(l_sql) RETURNING l_sql	        #FUN-B40104
        CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql    #FUN-B40104
      PREPARE p500_omb_p2 FROM l_sql
      IF STATUS THEN
         CALL s_errmsg('omb01',g_npq.npq23,'pre sel_omb',STATUS,1)
      END IF
      DECLARE p500_omb_c2 CURSOR FOR p500_omb_p2
      FOREACH p500_omb_c2 INTO l_oma99,l_omb04,l_omb12 
         IF cl_null(l_omb12) THEN LET l_omb12 = 0 END IF
         IF NOT cl_null(l_oma99) THEN
            LET l_poz01 = l_oma99[1,8]
            LET l_poz01 = l_poz01 CLIPPED
  #         LET l_sql = "SELECT poz00 FROM ",g_dbs_gl CLIPPED,"poz_file ",
            LET l_sql = "SELECT poz00 FROM ",cl_get_target_table(l_azp01,'poz_file'), 
                        " WHERE poz01 = '",l_poz01,"'"
       	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql    #FUN-B40104
            PREPARE poz00_curs FROM l_sql
            DECLARE ins_poz00 CURSOR FOR poz00_curs
            OPEN ins_poz00
            FETCH ins_poz00 INTO l_poz00
            CLOSE ins_poz00
         END IF 
         IF l_poz00 = '1' THEN
             LET l_sql =                               
                 "SELECT SUM(imb211 +imb212 +imb2131+imb2132+imb214 +",  
                 "           imb215 +imb2151+imb216 +imb2171+imb2172+", 
                 "           imb219 +imb220 +imb221 +imb222 +imb2231+",
                 "           imb2232+imb224 +imb225 +imb226 +imb2251+",
                 "           imb2271+imb2272+imb229 +imb230) ",       
   #             "  FROM ",g_dbs_axa02,"imb_file ",  
                 "  FROM ",cl_get_target_table(l_azp01,'imb_file'),
                 " WHERE imb01 ='",l_omb04,"' "  
         ELSE
             LET l_sql = 
                 "SELECT SUM(imb211 +imb212 +imb2131+imb2132+imb214 +",
                 "           imb215 +imb2151+imb216 +imb2171+imb2172+",
                 "           imb219 +imb220 +imb221 +imb222 +imb2231+",
                 "           imb2232+imb224 +imb225 +imb226 +imb2251+",
                 "           imb2271+imb2272+imb229 +imb230) ",
   #             "  FROM ",g_dbs_gl,"imb_file ",   
                 "  FROM ",cl_get_target_table(l_azp01,'imb_file'),        
                 " WHERE imb01 ='",l_omb04,"' "
         END IF  
         
	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql    #FUN-B40104
         PREPARE p500_imb_p1 FROM l_sql
         IF STATUS THEN 
            CALL s_errmsg('imb01',g_npq.npq23,'pre sel_imb',STATUS,1)
         END IF
         DECLARE p500_imb_c1 CURSOR FOR p500_imb_p1
         OPEN p500_imb_c1
         FETCH p500_imb_c1 INTO l_imb_sum 
         CLOSE p500_imb_c1
         IF cl_null(l_imb_sum) THEN LET l_imb_sum = 0 END IF
         LET g_sum = g_sum + l_imb_sum * l_omb12
      END FOREACH   
     #銷貨成本是依本國幣呈現,需換算成交易幣別的金額
      LET g_rate1 = 0
      CALL p500_getrate(tm.yy,tm.mm,g_axz06,g_npq.npq24) RETURNING g_rate1
      LET g_sum = g_sum * g_rate1
      LET g_cut = 0
      SELECT azi04 INTO g_cut FROM azi_file WHERE azi01=g_npq.npq24
      IF cl_null(g_cut) THEN LET g_cut=0 END IF
      LET g_sum=cl_digcut(g_sum,g_cut)

      LET g_axv.axv01  = tm.yy                        #年度
      LET g_axv.axv02  = tm.mm                        #期別
      LET g_axv.axv03  = tm.axa01                     #族群代號
      LET g_axv.axv031 = tm.axa02                     #上層公司
      SELECT MAX(axv04)+1 INTO g_axv.axv04 
        FROM axv_file
       WHERE axv01=tm.yy    AND axv02 =tm.mm
         AND axv03=tm.axa01 AND axv031=tm.axa02
      IF cl_null(g_axv.axv04) THEN 
         LET g_axv.axv04 = 1                          #項次
      END IF
      LET g_axv.axv05  = '2'                          #交易性質-2.逆流
      LET g_axv.axv06  = '1'                          #交易類別-1.存貨
      LET g_axv.axv07  = g_dept.axb04                 #來源公司-子公司
      LET g_axv.axv08  = g_dept.axa02                 #交易公司-母公司
      LET g_axv.axv09  = g_aaw.aaw07                 #帳列科目 
      LET g_axv.axv10  = ' '                          #交易科目
  #   LET g_axv.axv19  = g_aaz.aaz109               #交易科目
      LET g_axv.axv11  = g_npq.npq24                  #來源幣別
      LET g_axv.axv12  = g_npq.npq07                 #交易金額=銷貨收入
  #   LET g_axv.axv13  = g_npq.npq07-g_sum           #交易損益=銷貨收入-銷貨成本
      LET g_axv.axv13  = g_sum                        #FUN-B60134
  #    IF l_poz00 = '1' THEN
  #      LET g_axv.axv131 = g_axv.axv13
  #    ELSE
  #     LET g_axv.axv131 = 0 
  #    END IF 
  #    LET g_axv.axv14  = g_axv.axv13-g_axv.axv131     #未實現利益=交易損益-已實現利益
      LET g_axv.axv14 = 0                                      #FUN-B60134
      LET g_axv.axv131  = g_axv.axv12-g_axv.axv14-g_axv.axv13  #FUN-B60134
      LET g_axv.axv15  = g_rate                       #持股比率
      LET g_axv.axv16  = g_axv.axv14*g_axv.axv15/100  #分配未實現利益=未實現利益*持股比率/100  
      LET g_axv.axv17  = ' '                          #來源單號   #FUN-910002 mod
      LET g_axv.axvlegal = g_legal                    #所属法人     

      #因為採各子公司交易彙總產生，例如j11-->j10的交易逆流只有一筆
      #所以要先檢查子公司-->母公司的資料是否已產生過，
      #沒有的話就INSERT，若有則UPDATE
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt FROM axv_file
       WHERE axv01=tm.yy         AND axv02 =tm.mm
         AND axv03=tm.axa01      AND axv031=tm.axa02
         AND axv05='2'           AND axv06 ='1'
         AND axv07=g_dept.axb04  AND axv08 =g_dept.axa02
         AND axv11 = g_axv.axv11   #No.FUN-920139  
      #準備寫入agli012關係人交易明細
      IF g_cnt = 0 THEN    #沒有同樣key值的資料,可以新增 
         #FUN-B80135--add--str--
         IF g_axv.axv01 <g_year OR (g_axv.axv01=g_year AND g_axv.axv02<=g_month) THEN
           CALL cl_err('','axm-164',0)
           LET g_success='N'
           RETURN
          END IF
         #FUN-B80135--add—end--
         INSERT INTO axv_file VALUES(g_axv.*)
         IF SQLCA.SQLCODE THEN
            CALL cl_err3("ins","axv_file",g_axv.axv01,g_axv.axv02,SQLCA.sqlcode,"","",1)
         END IF
      ELSE                 #有同樣key值的資料,做UPDATE
         UPDATE axv_file SET axv12 =axv12+g_axv.axv12,
                             axv13 =axv13+g_axv.axv13,
                             axv131= axv131+g_axv.axv131,#FUN-B60134
                             axv14 =axv14+g_axv.axv14,
                             axv16 =axv16+g_axv.axv16
          WHERE axv01=tm.yy         AND axv02 =tm.mm
            AND axv03=tm.axa01      AND axv031=tm.axa02
            AND axv05='2'           AND axv06 ='1'
            AND axv07=g_dept.axb04  AND axv08 =g_dept.axa02
            AND axv11 = g_axv.axv11 
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            LET g_showmsg=tm.yy,"/",tm.mm
            CALL s_errmsg('axv01,axv02',g_showmsg,'upd_axv',SQLCA.sqlcode,1)
            CONTINUE FOREACH
         END IF
      END IF
   END FOREACH
END FUNCTION


FUNCTION p500_process_side(g_dept)    #處理側流
DEFINE g_dept       RECORD        
                     axa01      LIKE axa_file.axa01,   #族群代號
                     axa02      LIKE axa_file.axa02,   #上層公司
                     axa03      LIKE axa_file.axa03,   #帳別
                     axb04      LIKE axb_file.axb04,   #下層公司
                     axb05      LIKE axb_file.axb05    #帳別  
                    END RECORD,
       l_sql        STRING,
       g_axb04      LIKE axb_file.axb04,               #其他下層公司
       l_axz04      LIKE axz_file.axz04,
       l_omb04      LIKE omb_file.omb04,               #產品編號  
       l_omb12      LIKE omb_file.omb12,               #數量     
       l_imb_sum    LIKE imb_file.imb118               #銷貨成本
DEFINE l_npp02b     LIKE npp_file.npp02             
DEFINE l_npp02e     LIKE npp_file.npp02            
DEFINE l_dbs_azp01  LIKE azp_file.azp01
#側流:
#依據族群代碼/上層公司
#所屬子公司的關係人交易[同逆流抓取邏輯]

#1.QBE條件=axa01/axa02[族群代碼]/[上層公司]->axb04[下層公司]
#                                          ->axb04[其他下層公司]
#                                          ->axz08[其他下層公司關係人代碼]
#2.找各子公司分錄底稿抓關係人異動碼=axz08[其他子公司關係人代碼]，
#  抓取屬於與其他子公司交易的銷貨收入科目及金額
#3.抓取應收憑單單身的料號-->實際成本
#4.銷貨收入-實際成本=交易損益
#  交易損益-已實現損益=未實現損益
#  未實現損益*持股比率=分配未實現利益
#5.金額需換算成上層公司幣別金額

   SELECT axz04 INTO l_axz04 FROM axz_file WHERE axz01=g_dept.axb04
   IF l_axz04 = 'Y' THEN   #使用Tiptop否
      #以下層公司(axb04)的營運中心代碼(axz03)去抓所在的資料庫代碼(azp03)
    #  SELECT azp03 INTO g_dbs_new FROM azp_file 
    #   WHERE azp01=(SELECT axz03 FROM axz_file WHERE axz01=g_dept.axb04)
     SELECT axz03 INTO l_dbs_azp01 FROM axz_file WHERE axz01=g_dept.axb04  #FUN-B40104
   #   IF STATUS THEN LET g_dbs_new = NULL END IF
   #   IF NOT cl_null(g_dbs_new) THEN 
   #      LET g_dbs_new=g_dbs_new CLIPPED,'.' 
   #   END IF
   #   LET g_dbs_gl = g_dbs_new CLIPPED
   ELSE
      RETURN
   END IF

   LET g_axe04   = ''  LET g_axe04_1 = ''  LET g_axz08   = ''


   #抓取其他子公司
   LET l_sql="SELECT axb04 ",
             "  FROM axb_file,axa_file ",
             " WHERE axa01=axb01",
             "   AND axa02=axb02",
             "   AND axa03=axb03",
             "   AND axa01='",tm.axa01,"'",
             "   AND axa02='",tm.axa02,"'",
             "   AND axa03='",tm.axa03,"'",
             "   AND axb04!='",g_dept.axb04,"'",
             " ORDER BY axb04"
   PREPARE p500_axb_p FROM l_sql
   IF STATUS THEN 
      CALL cl_err('p500_axb_p',STATUS,1)             
   END IF
   DECLARE p500_axb_c CURSOR FOR p500_axb_p
   FOREACH p500_axb_c INTO g_axb04
      IF SQLCA.SQLCODE THEN 
         CALL s_errmsg(' ',' ','p500_axb_c:',STATUS,1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF

      #抓取其他子公司關係人代碼(axz08)
      SELECT axz08 INTO g_axz08 FROM axz_file 
       WHERE axz01=g_axb04 

      #抓子公司的記帳幣別(axz06)
       LET g_axz06=''
       SELECT axz06 INTO g_axz06 FROM axz_file WHERE axz01=g_dept.axb04

      #-->產生axv_file(合併報表關係人交易資料檔)
###存貨
      INITIALIZE g_npq.* TO NULL

      LET l_npp02b = MDY(tm.mm,1,tm.yy)        #取得當月第一天   
      LET l_npp02e = s_monend(tm.yy,tm.mm)     #取得當月最後一天

      #抓取子公司的分錄底稿,屬於銷貨收入科目,異動碼=其他子公司關係人代碼
      LET l_sql ="SELECT npq_file.* ",
         #       "  FROM ",g_dbs_gl CLIPPED,"npp_file,",
         #                 g_dbs_gl CLIPPED,"npq_file ",
             "  FROM ",cl_get_target_table(l_dbs_azp01,'npp_file,'),   #FUN-B40104
                       cl_get_target_table(l_dbs_azp01,'npq_file'),   #FUN-B40104
                 " WHERE nppsys = npqsys",
                 "   AND npptype= npqtype",
                 "   AND npp00  = npq00",
                 "   AND npp01  = npq01",
                 "   AND npp011 = npq011",
                 "   AND nppsys = 'AR'",
                 "   AND npptype= '0'",
                 "   AND npp00  = 2",
                 "   AND npp011 = 1",
                 "   AND npp02 BETWEEN '",l_npp02b,"' AND '",l_npp02e,"'", 
                #抓取子公司原始銷貨收入科目(axe04)
                 "   AND npq03 IN (SELECT axe04 FROM axe_file", 
                 "                  WHERE axe01='",g_dept.axb04,"'",
                 "                    AND axe00='",g_dept.axb05,"'",
                 "                    AND axe13='",tm.axa01,"'",  
                 "                    AND axe06='",g_aaw.aaw07,"')", #銷貨收入科目
                 "   AND npq37  = '",g_axz08,"'"       #異動碼-關係人
	CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,l_dbs_azp01) RETURNING l_sql  #FUN-B40104		
      PREPARE p500_npq_p31 FROM l_sql
      DECLARE p500_npq_c31 CURSOR FOR p500_npq_p31

      FOREACH p500_npq_c31 INTO g_npq.*
         IF SQLCA.SQLCODE THEN 
            CALL s_errmsg(' ',' ','p500_npq_c31:',STATUS,1)
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF
         
         #-->銷貨成本
         #依據分錄底稿->應收憑單單號(npq23)->該應收憑單之單身所有料號的成本加總
         #料號的成本來源為aimi106的實際成本(d3)加總
         LET g_sum = 0
        #應收單身的產品編號,數量
         LET l_sql = "SELECT omb04,omb12 ",
             #       "  FROM ",g_dbs_gl,"omb_file ",
                     "  FROM ",cl_get_target_table(l_dbs_azp01,'omb_file'),   #FUN-B40104   
                     " WHERE omb01='",g_npq.npq23,"'"
	CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,l_dbs_azp01) RETURNING l_sql  #FUN-B40104    
         PREPARE p500_omb_p3 FROM l_sql
         IF STATUS THEN
            CALL s_errmsg('omb01',g_npq.npq23,'pre sel_omb',STATUS,1)
         END IF
         DECLARE p500_omb_c3 CURSOR FOR p500_omb_p3
         FOREACH p500_omb_c3 INTO l_omb04,l_omb12
            IF cl_null(l_omb12) THEN LET l_omb12 = 0 END IF
            LET l_sql = 
                "SELECT SUM(imb211 +imb212 +imb2131+imb2132+imb214 +",
                "           imb215 +imb2151+imb216 +imb2171+imb2172+",
                "           imb219 +imb220 +imb221 +imb222 +imb2231+",
                "           imb2232+imb224 +imb225 +imb226 +imb2251+",
                "           imb2271+imb2272+imb229 +imb230) ",
          #     "  FROM ",g_dbs_gl,"imb_file ",
                "  FROM ",cl_get_target_table(l_dbs_azp01,'imb_file'),  
                "  WHERE imb01 ='",l_omb04,"'"   #FUN-780068 add 10/19
       	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,l_dbs_azp01) RETURNING l_sql 
            PREPARE p500_imb_p2 FROM l_sql
            IF STATUS THEN 
               CALL s_errmsg('imb01',g_npq.npq23,'pre sel_imb',STATUS,1)
            END IF
            DECLARE p500_imb_c2 CURSOR FOR p500_imb_p2
            OPEN p500_imb_c2
            FETCH p500_imb_c2 INTO l_imb_sum 
            CLOSE p500_imb_c2
            IF cl_null(l_imb_sum) THEN LET l_imb_sum = 0 END IF
            LET g_sum = g_sum + l_imb_sum * l_omb12
         END FOREACH   
        #銷貨成本是依本國幣呈現,需換算成交易幣別的金額
         LET g_rate1 = 0
         CALL p500_getrate(tm.yy,tm.mm,g_axz06,g_npq.npq24) RETURNING g_rate1
         LET g_sum = g_sum * g_rate1
         LET g_cut = 0
         SELECT azi04 INTO g_cut FROM azi_file WHERE azi01=g_npq.npq24
         IF cl_null(g_cut) THEN LET g_cut=0 END IF
         LET g_sum=cl_digcut(g_sum,g_cut)

         LET g_axv.axv01  = tm.yy                        #年度
         LET g_axv.axv02  = tm.mm                        #期別
         LET g_axv.axv03  = tm.axa01                     #族群代號
         LET g_axv.axv031 = tm.axa02                     #上層公司
         SELECT MAX(axv04)+1 INTO g_axv.axv04 
           FROM axv_file
          WHERE axv01=tm.yy    AND axv02 =tm.mm
            AND axv03=tm.axa01 AND axv031=tm.axa02
         IF cl_null(g_axv.axv04) THEN 
            LET g_axv.axv04 = 1                          #項次
         END IF
         LET g_axv.axv05  = '3'                          #交易性質-3.側流
         LET g_axv.axv06  = '1'                          #交易類別-1.存貨
         LET g_axv.axv07  = g_dept.axb04                 #來源公司-子公司
         LET g_axv.axv08  = g_axb04                      #交易公司-其他子公司
         LET g_axv.axv09  = g_aaw.aaw07                 #帳列科目   #FUN-780068 mod 10/19
         LET g_axv.axv10  = ' '                          #交易科目
#        LET g_axv.axv19  = g_aaz.aaz109               #交易科目
         LET g_axv.axv11  = g_npq.npq24                  #來源幣別
         LET g_axv.axv12  = g_npq.npq07                 #交易金額=銷貨收入
#        LET g_axv.axv13  = g_npq.npq07-g_sum           #交易損益=銷貨收入-銷貨成本
         LET g_axv.axv13  = g_sum                       #FUN-B60134
#        LET g_axv.axv131 = 0                            #已實現損益
#        LET g_axv.axv14  = g_axv.axv13-g_axv.axv131     #未實現利益=交易損益-已實現利益
         LET g_axv.axv14  = 0                                    #FUN-B60134     
         LET g_axv.axv131 = g_axv.axv12-g_axv.axv14-g_axv.axv13  #FUN-B60134   ADD
         LET g_axv.axv15  = g_rate                       #持股比率
         LET g_axv.axv16  = g_axv.axv14*g_axv.axv15/100  #分配未實現利益=未實現利益*持股比率/100  
         LET g_axv.axv17  = ' '                          #來源單號  
         LET g_axv.axvlegal = g_legal                    #所属法人   #NO.FUN-B40104  
         #因為採各子公司交易彙總產生，例如j11-->j12的交易側流只有一筆
         #所以要先檢查子公司-->其他子公司的資料是否已產生過，
         #沒有的話就INSERT，若有則UPDATE
         LET g_cnt = 0
         SELECT COUNT(*) INTO g_cnt FROM axv_file
          WHERE axv01=tm.yy         AND axv02 =tm.mm
            AND axv03=tm.axa01      AND axv031=tm.axa02
            AND axv05='3'           AND axv06 ='1'
            AND axv07=g_dept.axb04  AND axv08 =g_axb04
            AND axv11 = g_axv.axv11   
         #準備寫入agli012關係人交易明細
         IF g_cnt = 0 THEN    #沒有同樣key值的資料,可以新增 
            INSERT INTO axv_file VALUES(g_axv.*)
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("ins","axv_file",g_axv.axv01,g_axv.axv02,SQLCA.sqlcode,"","",1)
            END IF
         ELSE                 #有同樣key值的資料,做UPDATE
            UPDATE axv_file SET axv12 =axv12+g_axv.axv12,
                                axv13 =axv13+g_axv.axv13,
                                axv131 = axv131+g_axv.axv131,   #FUN-B60134  ADD
                                axv14 =axv14+g_axv.axv14,
                                axv16 =axv16+g_axv.axv16
             WHERE axv01=tm.yy         AND axv02 =tm.mm
               AND axv03=tm.axa01      AND axv031=tm.axa02
               AND axv05='3'           AND axv06 ='1'
               AND axv07=g_dept.axb04  AND axv08 =g_axb04
               AND axv11=g_axv.axv11
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
               LET g_showmsg=tm.yy,"/",tm.mm
               CALL s_errmsg('axv01,axv02',g_showmsg,'upd_axv',SQLCA.sqlcode,1)
               CONTINUE FOREACH
            END IF
         END IF
      END FOREACH
   END FOREACH   

END FUNCTION  

FUNCTION p500_dept()
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_sql       STRING
   DEFINE l_dept      RECORD
                       axa01      LIKE axa_file.axa01,  #族群代號
                       axa02      LIKE axa_file.axa02,  #上層公司
                       axa03      LIKE axa_file.axa03,  #帳別
                       axb04      LIKE axb_file.axb04,  #下層公司
                       axb05      LIKE axb_file.axb05   #帳別  
                      END RECORD 
   #假設集團公司層級如下:A下面有B、C,B下面有D、E,E下面有F,C下面有G
   #       A             #需產生A-B
   #   ┌─┴─┐        #      A-C
   #   B        C        #      A-D
   # ┌┴┐     │       #      A-E
   # D   E      G        #      A-F
   #     │              #      A-G等關係人層級資料
   #     F

   #1.先檢查Temptable裡有沒有資料,沒有的話,先寫入最上一層的關係人層級資料
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM p500_tmp
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt = 0 THEN CALL p500_bom(tm.axa01,tm.axa02,tm.axa03) END IF 

   #2-1.檢查Temptable裡有沒有chk=N的資料(表示還未抓它的下層公司),
   #    沒有的話,表示所有層級資料都產生了,離開此FUNCTION
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM p500_tmp WHERE chk='N'
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt = 0 THEN RETURN END IF 

   #2-2.檢查Temptable裡有沒有chk=N的資料(表示還未抓它的下層公司),
   #    以下層公司當上層公司,去抓其下層公司,產生跨層的公司層級資料
   DECLARE axb_curs1 CURSOR FOR
      SELECT axa01,axa02,axa03,axb04,axb05
        FROM p500_tmp
       WHERE chk='N'
   FOREACH axb_curs1 INTO l_dept.*
      CALL p500_bom(l_dept.axa01,l_dept.axb04,l_dept.axb05)
      UPDATE p500_tmp SET chk='Y'
       WHERE axa01=l_dept.axa01
         AND axb04=l_dept.axb04
         AND axb05=l_dept.axb05
   END FOREACH

   CALL p500_dept()

END FUNCTION

FUNCTION p500_bom(p_axa01,p_axa02,p_axa03)
   DEFINE p_axa01   LIKE axa_file.axa01   #族群代號
   DEFINE p_axa02   LIKE axa_file.axa02   #上層公司
   DEFINE p_axa03   LIKE axa_file.axa03   #帳別
   DEFINE l_sql       STRING

   LET l_sql="INSERT INTO p500_tmp (chk,axa01,axa02,axa03,axb04,axb05)",
             "SELECT 'N',",
             "       '",tm.axa01 CLIPPED,"',",
             "       '",tm.axa02 CLIPPED,"',",
             "       '",tm.axa03 CLIPPED,"',",
             "       axb04,axb05",
             "  FROM axb_file,axa_file ",
             " WHERE axa01=axb01 AND axa02=axb02 AND axa03=axb03 ",
             "   AND axa01=? AND axa02=? AND axa03=?"
   PREPARE p500_axb_p1 FROM l_sql
   EXECUTE p500_axb_p1 USING p_axa01,p_axa02,p_axa03
   
END FUNCTION

FUNCTION p500_getrate(p_axp01,p_axp02,p_axp03,p_axp04)   #抓現時匯率
DEFINE p_axp01 LIKE axp_file.axp01,
       p_axp02 LIKE axp_file.axp02,
       p_axp03 LIKE axp_file.axp03,
       p_axp04 LIKE axp_file.axp04,
       l_rate  LIKE axp_file.axp05 

   SELECT axp05 INTO l_rate   #現時匯率
     FROM axp_file
    WHERE axp01=p_axp01
      AND axp02=(SELECT max(axp02) FROM axp_file
                  WHERE axp01 = p_axp01
                    AND axp02 <=p_axp02
                    AND axp03 = p_axp03
                    AND axp04 = p_axp04)
      AND axp03=p_axp03 
      AND axp04=p_axp04

   IF l_rate = 0 THEN LET l_rate = 1 END IF

   RETURN l_rate
END FUNCTION
#NO.FUN-B40104	
