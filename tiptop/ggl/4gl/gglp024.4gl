# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Pattern name...: gglp024.4gl
# Descriptions...: 合併報表關係人交易明細產生作業(整批資料處理作業)--from会计系统
# Date&Author....: 10/12/14 By lutingting copy from aglp005
# Modify.........: NO.FUN-B40104 11/05/05 BY jll   合并报表作業產品
# Modify..........: NO.FUN-B60134 11/06/27 BY minpp    給 asw13,asw131,asw14 賦值
# Modify..........: NO.FUN-B80135 11/08/22 BY minpp    相關日期欄位不可小於關帳日期
# Modify..........: NO.FUN-B90087 11/09/15 By minpp    修改金额和币别的取值
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植
# Modify.........: NO.TQC-C40010 12/04/05 By lujh 把必要字段controlz換成controlr

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm   RECORD #FUN-BB0036 
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
       g_asg08         LIKE asg_file.asg08,
       g_ash04         LIKE ash_file.ash04,      #母公司原始銷貨收入科目 
       g_ash04_1       LIKE ash_file.ash04,      #母公司原始資產交易損益科目
       g_sum           LIKE imb_file.imb118,
       i,g_cnt         LIKE type_file.num5,
       g_npq           RECORD LIKE npq_file.*,
       g_asw           RECORD LIKE asw_file.*,
       g_asg06         LIKE asg_file.asg06,  
       g_cut           LIKE azi_file.azi04, 
       g_aag04         LIKE aag_file.aag04,
       g_asa05         LIKE asa_file.asa05,
       g_asg07         LIKE asg_file.asg07, 
       g_asg           RECORD LIKE asg_file.*, 
       g_asf_count     LIKE type_file.num5 ,
       g_dr            LIKE aah_file.aah04         
  #----FUN-B90087--start---
DEFINE g_dept        DYNAMIC ARRAY OF RECORD        
                     asa01      LIKE asa_file.asa01,  #族群代號
                     asa02      LIKE asa_file.asa02,  #上層公司
                     asa03      LIKE asa_file.asa03,  #帳別
                     asb04      LIKE asb_file.asb04,  #下層公司
                     asb05      LIKE asb_file.asb05   #帳別  
                     END RECORD   
             
DEFINE g_azp01        LIKE azp_file.azp01               #营运中心编号
DEFINE g_dbs_azp01    LIKE azp_file.azp01
DEFINE g_asz01        LIKE asz_file.asz01      
DEFINE g_asz          RECORD LIKE asz_file.*
DEFINE g_date_e       LIKE type_file.dat 
DEFINE g_aaa03        LIKE aaa_file.aaa03 
DEFINE g_rate         LIKE ase_file.ase05             #功能幣別匯率    
DEFINE g_rate1        LIKE ase_file.ase05             #記帳幣別匯率  
DEFINE g_chg_asw12_1  LIKE aah_file.aah04   
DEFINE g_chg_asw12_a  LIKE aah_file.aah04   
DEFINE g_chg_asw12    LIKE aah_file.aah04   
DEFINE g_chg_dr       LIKE aah_file.aah04 
DEFINE g_acc_dr       LIKE aah_file.aah04 
DEFINE g_cut1         LIKE type_file.num5
DEFINE g_bm           LIKE type_file.num5
DEFINE g_fun_dr       LIKE aah_file.aah04    
DEFINE g_ash         RECORD                                       #FUN-580063
           ash04      LIKE ash_file.ash04,  #TQC-AA0098
           ash11      LIKE ash_file.ash11,  #再衡量匯率類別
           ash12      LIKE ash_file.ash12   #換算匯率類別
                         END RECORD
#----FUN-B90087--end---                            
#FUN-B80135--add--str--
DEFINE g_aaa07        LIKE aaa_file.aaa07
DEFINE g_year         LIKE  type_file.chr4
DEFINE g_month        LIKE  type_file.chr2
# FUN-B80135--add--end                        

 
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
   SELECT asz01 INTO g_asz01 FROM asz_file WHERE asz00='0'  #FUN-B80135
  #FUN-B80135--add--str--
   SELECT aaa07 INTO g_aaa07 FROM aaa_file,asz_file
   WHERE aaa01 = asz01 AND asz00 = '0'
   LET g_year = YEAR(g_aaa07)
   LET g_month= MONTH(g_aaa07)
  #FUN-B80135--add—end

   WHILE TRUE
     LET g_change_lang = FALSE
     IF g_bgjob = 'N' THEN
        CALL p500_tm(0,0)
        IF cl_sure(21,21) THEN
           SELECT asg06 INTO g_aaa03 FROM asg_file where asg01 = tm.asa02  #FUN-B90087
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
              SELECT asg06 INTO g_aaa03 FROM asg_file where asg01 = tm.asa02  #FUN-B90087
              CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW gglp024_w
              EXIT WHILE
           END IF
        END IF
     ELSE
        #現行會計年度(aaa04)、現行期別(aaa05)
        SELECT aaa04,aaa05 INTO g_aaa04,g_aaa05
          FROM aaa_file 
        #WHERE aaa01 = g_bookno 
         WHERE aaa01 = g_asz01
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
           l_asa03        LIKE asa_file.asa03,
           lc_cmd         LIKE type_file.chr1000
           
   IF s_shut(0) THEN RETURN END IF
#   CALL s_dsmark(g_bookno)     #FUN-B80135

   LET p_row = 4 LET p_col = 30

   OPEN WINDOW gglp024_w AT p_row,p_col WITH FORM "ggl/42f/gglp024" 
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
        WHERE aaa01 = g_asz01    #FUN-B80135
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
                 NEXT FIELD  yy
              END IF
              IF tm.yy=g_year AND tm.mm<=g_month THEN
                CALL cl_err(tm.mm,'atp-164',0)
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
             SELECT asa05 INTO g_asa05 FROM asa_file WHERE asa01 = tm.asa01     #族群編號
                                                       AND asa04 = 'Y'   #最上層公司否

         AFTER FIELD asa03   #帳別 
            IF NOT cl_null(tm.asa03) THEN
               SELECT COUNT(*) INTO l_cnt FROM asa_file 
                WHERE asa01=tm.asa01 AND asa02=tm.asa02 AND asa03=tm.asa03
               IF l_cnt = 0  THEN 
                  CALL cl_err3("sel","asa_file",tm.asa01,tm.asa02,"agl-118","","",0)  
                  NEXT FIELD asa03 
               END IF
            END IF

         #ON ACTION CONTROLZ   #TQC-C40010 mark
          ON ACTION CONTROLR   #TQC-C40010 add
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
 
         ON ACTION HELP         
            CALL cl_show_help() 

         ON ACTION EXIT                            #加離開功能
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
         CLOSE WINDOW gglp024_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01= 'gglp024'
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('gglp024','9031',1)   
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " ''",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",tm.asa01 CLIPPED,"'",
                         " '",tm.asa02 CLIPPED,"'",
                         " '",tm.asa03 CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('gglp024',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW gglp024_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE

END FUNCTION
   
FUNCTION p500()
   DEFINE #l_sql        LIKE type_file.chr1000,
           l_sql        STRING,  
           l_sql_asf    LIKE type_file.chr1000 , 
           i,g_no       LIKE type_file.num5,
           g_dept       DYNAMIC ARRAY OF RECORD        
             asa01      LIKE asa_file.asa01,  #族群代號
             asa02      LIKE asa_file.asa02,  #上層公司
             asa03      LIKE asa_file.asa03,  #帳別
             asb04      LIKE asb_file.asb04,  #下層公司
             asb05      LIKE asb_file.asb05   #帳別  
                       END RECORD
   DEFINE    l_azp03    LIKE azp_file.azp03         
   DEFINE    l_azp031   STRING  
   
   
   DROP TABLE p500_tmp

   CREATE TEMP TABLE p500_tmp(
      chk       LIKE type_file.chr1,   
      asa01     LIKE asa_file.asa01,  
      asa02     LIKE asa_file.asa02,  
      asa03     LIKE asa_file.asa03,  
      asb04     LIKE asb_file.asb04,  
      asb05     LIKE asb_file.asb05    );

   #-->step 1 刪除資料
   CALL p500_del()
   IF g_success = 'N' THEN RETURN END IF

   #-->step 2 資料寫入
   CALL g_dept.clear()   #將g_dept清空

#   SELECT  azp03,azp01 INTO l_azp03,g_azp01 
#    FROM  asg_file,azp_file WHERE asg01 = tm.asa02 AND asg03 = azp01
   SELECT asg03 INTO g_azp01 FROM asg_file WHERE asg01 = tm.asa02 AND asg03 = azp01   #NO.FUN-B40104
#   LET l_azp031 = s_dbstring(l_azp03 CLIPPED)
#   LET l_sql = "SELECT * FROM ",l_azp031 CLIPPED,"aaz_file"
   PREPARE aaz_sel FROM l_sql
   EXECUTE aaz_sel INTO g_aaz.*   

   CALL p500_dept()    #抓取關係人層級

   LET l_sql=" SELECT asa01,asa02,asa03,asb04,asb05",
             "   FROM p500_tmp ",
             "  ORDER BY asa01,asa02,asa03,asb04"
   PREPARE p500_asa_p FROM l_sql
   IF STATUS THEN 
      CALL cl_err('prepare:1',STATUS,1)             
      CALL cl_batch_bg_javamail('N')                
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM 
   END IF
   DECLARE p500_asa_c CURSOR FOR p500_asa_p
   LET g_no = 1
   CALL s_showmsg_init()                           
   FOREACH p500_asa_c INTO g_dept[g_no].*
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
   
    #FUN-B90087--add--str--
   LET l_sql_asf=
      "SELECT '2',SUM(asf16),SUM(asf13)", 
      "  FROM asf_file,asg_file",
      " WHERE asf01=? AND asf02=? ",
      "   AND asf02=asg01 ",
      "   AND asf04=asg06 ",
      "   AND asf03=? ",
      "   AND asf06<=? "  #異動日期
   PREPARE p500_asf_p FROM l_sql_asf
    
   LET l_sql_asf=
      "SELECT COUNT(*) ",       
      "  FROM asf_file,asg_file",
      " WHERE asf01=? AND asf02=? ",
      "   AND asf02=asg01 ",
      "   AND asf04=asg06 ",
      "   AND asf03=? ",
      "   AND asf06<=? "
   PREPARE p500_asf_p2 FROM l_sql_asf
   #FUN-B90087--add--end-- 
   
   FOR i =1 TO g_no
      IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y'                                                      
      END IF

      #抓取子公司持股比率
      CALL get_rate(g_dept[i].asb04,g_dept[i].asb05)  

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
   
FUNCTION p500_process_down(g_dept)    #處理順流
DEFINE g_dept       RECORD        
                     asa01      LIKE asa_file.asa01,  #族群代號
                     asa02      LIKE asa_file.asa02,  #上層公司
                     asa03      LIKE asa_file.asa03,  #帳別
                     asb04      LIKE asb_file.asb04,  #下層公司
                     asb05      LIKE asb_file.asb05   #帳別  
                    END RECORD,
       l_omb04      LIKE omb_file.omb04,              #產品編號  
       l_omb12      LIKE omb_file.omb12,              #數量     
       l_imb_sum    LIKE imb_file.imb118              #銷貨成本 
DEFINE l_asg04      LIKE asg_file.asg04              
DEFINE l_sql        STRING                          
DEFINE l_npp02b     LIKE npp_file.npp02            
DEFINE l_npp02e     LIKE npp_file.npp02
DEFINE g_acc_dr     LIKE aah_file.aah05       


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

###存貨
   INITIALIZE g_npq.* TO NULL
   INITIALIZE g_asw.* TO NULL

   SELECT asg04 INTO l_asg04 FROM asg_file WHERE asg01=g_dept.asa02
   IF l_asg04 = 'Y' THEN   #使用Tiptop否
  #    SELECT azp03,azp01 INTO g_dbs_asa02,g_dbs_azp01 FROM azp_file 
  #     WHERE azp01=(SELECT asg03 FROM asg_file WHERE asg01=g_dept.asa02)
       SELECT asg03 INTO g_dbs_azp01 FROM asg_file WHERE asg01=g_dept.asa02  #FUN-B40104
  #    IF STATUS THEN LET g_dbs_azp01 = NULL END IF
  #    IF NOT cl_null(g_dbs_asa02) THEN 
  #       LET g_dbs_new = s_dbstring(g_dbs_asa02 CLIPPED)
  #    END IF
  #    LET g_dbs_asa02 = g_dbs_new CLIPPED
   ELSE
      RETURN
   END IF
   
  #FUN-B90087--Mark--STR 
  #抓母公司的記帳幣別(asg06)
  #LET g_asg06=''
  #SELECT asg06 INTO g_asg06 FROM asg_file
  # WHERE asg01=g_dept.asa02
  #FUN-B90087--Mark--END 
  #抓取上層公司的分錄底稿,屬於銷貨收入科目,異動碼=子公司關係人代碼
   LET l_npp02b = MDY(tm.mm,1,tm.yy)        #取得當月第一天
   LET l_npp02e = s_monend(tm.yy,tm.mm)     #取得當月最後一天

   LET l_sql = "SELECT npq_file.* ",           
         #     "  FROM ",g_dbs_asa02,"npp_file,",
         #               g_dbs_asa02,"npq_file",
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
        #抓取母公司原始銷貨收入科目(ash04)
               "   AND npq03 IN (SELECT ash04 FROM ash_file ",
               " WHERE ash01='",g_dept.asa02,"'",
               "   AND ash00='",g_dept.asa03,"'",
               "   AND ash13='",tm.asa01,"'",
               "   AND ash06='",g_asz.asz07,"')",   #銷貨收入科目
               "   AND npq37='",g_asg08,"'"          #異動碼-關係人
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql	
   CALL cl_parse_qry_sql(l_sql,g_dbs_azp01) RETURNING l_sql  #FUN-B40104
   PREPARE p500_npq_c11_p FROM l_sql
   #FUN-B90087-ADD--STR
   IF STATUS THEN
      LET g_showmsg=tm.yy,"/",g_dept.asb05
      CALL s_errmsg('ash00,ash01',g_showmsg,'pre:p500_npq_c11_p',STATUS,1)
      LET g_success = 'N'
   END IF
   #FUN-B90087-ADD--END
   DECLARE p500_npq_c11 CURSOR FOR p500_npq_c11_p

   FOREACH p500_npq_c11 INTO g_npq.*
      IF SQLCA.SQLCODE THEN 
         CALL s_errmsg(' ',' ','p500_npq_c11:',STATUS,1)
         LET g_success = 'N'
      END IF
   #FUN-B90087--ADD--STR
      LET g_asw.asw12=g_npq.npq07  
      LET l_sql = "SELECT aag04", " FROM ",cl_get_target_table(g_dbs_azp01,'aag_file'),
                  " WHERE  aag00='",g_dept.asa03,"'",
                  "   AND  aag01='",g_npq.npq03,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,g_dbs_azp01) RETURNING l_sql
      PREPARE p500_aag_p FROM l_sql
      EXECUTE p500_aag_p  INTO  g_aag04

      LET g_ash.ash11 = '1'
      LET g_ash.ash12 = '1'
      LET l_sql = 
         " SELECT ash04,ash11,ash12 FROM ash_file ",  
         "  WHERE ash01 = '",g_dept.asb04,"'",
         "    AND ash06 = '",g_asz.asz07,"'", 
         "    AND ash00 = '",g_dept.asb05,"'", 
         "    AND ash13 = '",tm.asa01,"'"   
      PREPARE p500_ash_p4 FROM l_sql
      DECLARE p500_ash_c4 SCROLL CURSOR FOR p500_ash_p4
      OPEN p500_ash_c4 
      FETCH FIRST p500_ash_c4 INTO g_ash.*
      CLOSE p500_ash_c4
      IF STATUS  THEN                   
         LET g_showmsg=g_dept.asb04,"/",g_asw.asw10
         CALL s_errmsg('ash01,ash04',g_showmsg,g_asw.asw10,'aap-021',1)                #NO.FUN-710023    
         LET g_success = 'N'
         CONTINUE FOREACH    
      END IF
      SELECT * INTO g_asg.* FROM asg_file WHERE asg01=g_dept.asa02
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('asg01',g_dept.asb04,' ',SQLCA.sqlcode,1)   
         LET g_success = 'N'
         CONTINUE  FOREACH           
      END IF

      #當上層公司不等於下層公司時,才需要抓匯率來計算,否則匯率用1來計算
      LET g_rate  = 1
      LET g_rate1 = 1
      #當再衡量匯率類別(ash11),換算匯率類別(ash12)選擇的是歷史匯率時,
      #金額需抓agli011設定的記帳幣別金額(小於等於本期),
      #一一換算後再加總起來
      LET g_chg_asw12_1=0
      LET g_chg_asw12=0
      LET g_chg_asw12_a=0
      LET g_chg_dr = 0 
      LET g_fun_dr = 0 
      LET g_acc_dr = 0 
      LET g_dr = 0  
              
      #--現時匯率---
      IF g_ash.ash11='1' THEN 
         CALL p500_fun_amt(g_aag04,g_asw.asw12,
                           g_ash.ash11,g_asg.asg06,
                           g_asg.asg07,tm.yy,tm.mm,g_asa05)   
               RETURNING g_fun_dr 
      END IF

      #--歷史匯率---
      IF g_ash.ash11='2' AND ( g_dept.asa02 != g_dept.asb04 ) THEN  
         #----如果agli011抓不到資料，則依科目餘額計算---- 
         DECLARE p500_cnt_cs4 CURSOR FOR p500_asf_p2
         OPEN p500_cnt_cs4
         USING g_dept.asa01,g_dept.asb04,
              g_npq.npq03,g_date_e               
         FETCH p500_cnt_cs4 INTO g_asf_count
         CLOSE p500_cnt_cs4
         IF g_asf_count > 0 THEN   
             CALL p500_asf(i,g_ash.ash04,' ',g_date_e)    
             RETURNING g_fun_dr,g_acc_dr 
         ELSE
             #--取不到agli011時一樣用匯率換算---
             CALL p500_fun_amt(g_aag04,g_asw.asw12,
                           g_ash.ash11,g_asg.asg06,
                           g_asg.asg07,tm.yy,tm.mm,g_asa05)   
             RETURNING g_fun_dr  
         END IF
      ELSE
          CALL p500_fun_amt(g_aag04,g_asw.asw12,
                            g_ash.ash11,g_asg.asg06,
                            g_asg.asg07,tm.yy,tm.mm,g_asa05)  
          RETURNING g_fun_dr  
      END IF
      
      #--平均匯率---
      IF g_ash.ash11='3' THEN
         CALL p500_fun_amt(g_aag04,g_asw.asw12,g_ash.ash11,g_asg.asg06,
                          g_asg.asg07,tm.yy,tm.mm,g_asa05)   
              RETURNING g_fun_dr  
      END IF
      #-----依科目在agli001中(換算)匯率各自取出匯率後計算上層記帳幣金額--
      
      #--現時匯率---
      IF g_ash.ash12='1' THEN 
          CALL p500_acc_amt(g_aag04,g_fun_dr,
                            g_ash.ash12,g_asg.asg07,
                            g_aaa03,tm.yy,tm.mm,g_asa05)    
          RETURNING g_acc_dr  
      END IF

      #--歷史匯率---
      IF g_ash.ash12='2' AND ( g_dept.asa02 != g_dept.asb04 ) THEN  
          #----如果agli011抓不到資料，則依科目餘額計算---- 
          DECLARE p500_cnt_cs24 CURSOR FOR p500_asf_p2
          OPEN p500_cnt_cs24
          USING g_dept.asa01,g_dept.asb04,
                g_npq.npq03,g_date_e  
          FETCH p500_cnt_cs24 INTO g_asf_count 
          CLOSE p500_cnt_cs24
          IF g_asf_count > 0 THEN   
              CALL p500_asf(i,g_ash.ash04,' ',g_date_e)   
              RETURNING g_fun_dr,g_acc_dr 
          ELSE
          #--取不到agli011時一樣用匯率換算---
              CALL p500_acc_amt(g_aag04,g_fun_dr,
                                g_ash.ash12,g_asg.asg07,
                                g_aaa03,tm.yy,tm.mm,g_asa05)    
              RETURNING g_acc_dr 
          END IF
      ELSE
          CALL p500_acc_amt(g_aag04,g_fun_dr,
                            g_ash.ash12,g_asg.asg07,
                            g_aaa03,tm.yy,tm.mm,g_asa05)         
          RETURNING g_acc_dr  
      END IF
      
      #--平均匯率---
      IF g_ash.ash12='3' THEN
          CALL p500_acc_amt(g_aag04,g_fun_dr,
                            g_ash.ash12,g_asg.asg07,
                            g_aaa03,tm.yy,tm.mm,g_asa05)       
          RETURNING g_acc_dr  
      END IF

      LET g_chg_asw12  =g_chg_asw12   + g_fun_dr
      LET g_chg_asw12_1=g_chg_asw12_1 + g_acc_dr  

      SELECT azi04 INTO g_cut FROM azi_file WHERE azi01=g_asg.asg07                                                                               
      IF cl_null(g_cut) THEN LET g_cut=0 END IF                                                                                                   
      SELECT azi04 INTO g_cut1 FROM azi_file WHERE azi01=g_aaa03                                                                                  
      IF cl_null(g_cut1) THEN LET g_cut1=0 END IF       

      LET g_chg_asw12=cl_digcut(g_chg_asw12,g_cut)    
      LET g_chg_asw12_1=cl_digcut(g_chg_asw12_1,g_cut1)   
      IF cl_null(g_chg_asw12_1) THEN LET g_chg_asw12_1=0 END IF
      #FUN-B90087--ADD--END--
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
      CALL p500_getrate(tm.yy,tm.mm,g_asg06,g_npq.npq24) RETURNING g_rate1
      LET g_sum = g_sum * g_rate1
      LET g_cut = 0
      SELECT azi04 INTO g_cut FROM azi_file WHERE azi01=g_npq.npq24
      IF cl_null(g_cut) THEN LET g_cut=0 END IF
      LET g_sum=cl_digcut(g_sum,g_cut)

      LET g_asw.asw01  = tm.yy                      #年度
      LET g_asw.asw02  = tm.mm                      #期別
     #LET g_asw.asw03  = tm.asa01                   #族群代號 #FUN-B90087 MARK
      LET g_asw.asw03  = g_dept.asa01               #FUN-B90087 ADD
     #LET g_asw.asw031 = tm.asa02                   #上層公司 #FUN-B90087  MARK
      LET g_asw.asw031  = g_dept.asa02              #FUN-B90087
      SELECT MAX(asw04)+1 INTO g_asw.asw04 
        FROM asw_file
       WHERE asw01=tm.yy    AND asw02 =tm.mm
       #  AND asw03=tm.asa01 AND asw031=tm.asa02
          AND asw03= g_dept.asa01 AND asw031= g_dept.asa02
      IF cl_null(g_asw.asw04) THEN 
         LET g_asw.asw04 = 1                        #項次
      END IF
      LET g_asw.asw05  = '1'                        #交易性質-1.順流
      LET g_asw.asw06  = '1'                        #交易類別-1.存貨
      LET g_asw.asw07  = g_dept.asa02               #來源公司-母公司
      LET g_asw.asw08  = g_dept.asb04               #交易公司-子公司
      LET g_asw.asw09  = g_asz.asz07               #帳列科目 
      LET g_asw.asw10  = ' '                        #交易科目
#     LET g_asw.asw19  = g_aaz.aaz109               #交易科目
#     LET g_asw.asw11  = g_npq.npq24                #來源幣別  #FUN-B90087 mark
      LET g_asw.asw11  = g_asg06
#     LET g_asw.asw12  = g_npq.npq07               #交易金額=銷貨收入  #FUN-B90087 mark
      LET g_asw.asw12  = g_chg_asw12_1             #FUN-B90087 
#     LET g_asw.asw13  = g_npq.npq07-g_sum         #交易損益=銷貨收入-銷貨成本 #FUN-B60134 MARK
      IF cl_null(g_sum) THEN LET g_sum = 0 END IF
#     LET g_asw.asw13  = g_sum                      #FUN-B60134 ADD  #FUN-B90087 MARK
      LET g_asw.asw13  = 0                           #FUN-B90087
#     LET g_asw.asw131 = 0                          #已實現損益  #FUN-B60134  MARK
#     LET g_asw.asw14  = g_asw.asw13-g_asw.asw131   #未實現利益=交易損益-已實現利益 #FUN-B60134  MARK
      LET g_asw.asw14  = 0                          #FUN-B60134  ADD
#     LET g_asw.asw131 = g_asw.asw12-g_asw.asw14-g_asw.asw13   #FUN-B60134  ADD   #FUN-B90087 MARK
      LET g_asw.asw131 = g_asw.asw12                 #FUN-B90087 
      LET g_asw.asw15  = g_rate                     #持股比率
      LET g_asw.asw16  = g_asw.asw14                #分配未實現利益=未實現利益   
      LET g_asw.asw17  = ' '                        #來源單號  
      LET g_asw.aswlegal =  g_legal                 #所属法人     #NO.FUN-B40104
     
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
                             asw131 = asw131+g_asw.asw131,#FUN-B60134  ADD
                             asw14 =asw14+g_asw.asw14,
                             asw16 =asw16+g_asw.asw16
          WHERE asw01=tm.yy         AND asw02 =tm.mm
            AND asw03=tm.asa01      AND asw031=tm.asa02
            AND asw05='1'           AND asw06 ='1'
            AND asw07=g_dept.asa02  AND asw08 =g_dept.asb04
            AND asw11= g_asw.asw11
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            LET g_showmsg=tm.yy,"/",tm.mm
            CALL s_errmsg('asw01,asw02',g_showmsg,'upd_asw',SQLCA.sqlcode,1)
            CONTINUE FOREACH
         END IF
      END IF
   END FOREACH

END FUNCTION

FUNCTION p500_process_back(g_dept)    #處理逆流
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
DEFINE l_npp02b     LIKE npp_file.npp02              
DEFINE l_npp02e     LIKE npp_file.npp02         
DEFINE l_azp01      LIKE azp_file.azp01               #营运中心
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
      #以下層公司(asb04)的營運中心代碼(asg03)去抓所在的資料庫代碼(azp03)
#      SELECT azp03 INTO g_dbs_new FROM azp_file 
#      WHERE azp01=(SELECT asg03 FROM asg_file WHERE asg01=g_dept.asb04)
       SELECT asg03 INTO l_azp01 FROM asg_file WHERE asg01=g_dept.asb04     #FUN-B40104
#      IF STATUS THEN LET g_dbs_new = NULL END IF
#      IF NOT cl_null(g_dbs_new) THEN 
#         LET g_dbs_new=g_dbs_new CLIPPED,'.' 
#      END IF
#      LET g_dbs_gl = g_dbs_new CLIPPED
   ELSE
      RETURN
   END IF

   LET g_ash04   = ''  LET g_ash04_1 = ''  LET g_asg08   = ''


   #抓取母公司關係人代碼(asg08
   SELECT asg08 INTO g_asg08 FROM asg_file 
    WHERE asg01=g_dept.asa02 

  
  #FUN-B90087--Mark-STR
  #抓母公司的記帳幣別(asg06)
  # LET g_asg06=''
  # SELECT asg06 INTO g_asw.asw11  FROM asg_file WHERE asg01=g_dept.asa02
  #FUN-B90087--MARK--END 
   #-->產生asw_file(合併報表關係人交易資料檔)

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
             #抓取子公司原始銷貨收入科目(ash04)
              "   AND npq03 IN (SELECT ash04 FROM ash_file", 
              "                  WHERE ash01='",g_dept.asb04,"'",
              "                    AND ash00='",g_dept.asb05,"'",
              "                    AND ash13='",tm.asa01,"'",      
              "                    AND ash06='",g_asz.asz07,"')", #銷貨收入科目
              "   AND npq37  = '",g_asg08,"'"       #異動碼-關係人
	CALL cl_replace_sqldb(l_sql) RETURNING l_sql	
        CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql
   PREPARE p500_npq_p21 FROM l_sql
    #FUN-B90087-ADD--STR
     IF STATUS THEN
        LET g_showmsg=tm.yy,"/",g_dept.asb05
        CALL s_errmsg('ash00,ash01',g_showmsg,'pre:p500_npq_c11_p',STATUS,1)
        LET g_success = 'N'
     END IF
    #FUN-B90087-ADD--END

   DECLARE p500_npq_c21 CURSOR FOR p500_npq_p21
    
   FOREACH p500_npq_c21 INTO g_npq.*
      IF SQLCA.SQLCODE THEN 
         CALL s_errmsg(' ',' ','p500_npq_c21:',STATUS,1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF

      #FUN-B90087-ADD--STR
      LET g_asw.asw12=g_npq.npq07
      LET l_sql = "SELECT aag04", " FROM ",cl_get_target_table(l_azp01,'aag_file'),
                  " WHERE aag00='",g_dept.asb05,"'",
                  "   AND aag01='",g_npq.npq03,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql
      PREPARE p500_aag_p1 FROM l_sql
      EXECUTE p500_aag_p1  INTO  g_aag04
      
      LET g_ash.ash11 = '1'
      LET g_ash.ash12 = '1'
      LET l_sql = 
          " SELECT ash04,ash11,ash12 FROM ash_file ",  
          "  WHERE ash01 = '",g_dept.asb04,"'",
          "    AND ash06 = '",g_asz.asz07,"'", 
          "    AND ash00 = '",g_dept.asb05,"'", 
          "    AND ash13 = '",tm.asa01,"'"   
      PREPARE p500_ash_p5 FROM l_sql
      DECLARE p500_ash_c5 SCROLL CURSOR FOR p500_ash_p5
      OPEN p500_ash_c5
      FETCH FIRST p500_ash_c5 INTO g_ash.*
      CLOSE p500_ash_c5
      IF STATUS  THEN                   
         LET g_showmsg=g_dept.asb04,"/",g_asw.asw10
         CALL s_errmsg('ash01,ash04',g_showmsg,g_asw.asw10,'aap-021',1)           
         LET g_success = 'N'
         CONTINUE FOREACH    
      END IF

      SELECT * INTO g_asg.* FROM asg_file WHERE asg01=g_dept.asb04
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('asg01',g_dept.asb04,' ',SQLCA.sqlcode,1)   
         LET g_success = 'N'
         CONTINUE  FOREACH                            
      END IF

      #當上層公司不等於下層公司時,才需要抓匯率來計算,否則匯率用1來計算
      LET g_rate  = 1
      LET g_rate1 = 1
      #當再衡量匯率類別(ash11),換算匯率類別(ash12)選擇的是歷史匯率時,
      #金額需抓agli011設定的記帳幣別金額(小於等於本期),
      #一一換算後再加總起來
      LET g_chg_asw12_1=0
      LET g_chg_asw12=0
      LET g_chg_asw12_a=0
      LET g_chg_dr = 0 
      LET g_fun_dr = 0 
      LET g_acc_dr = 0 
      LET g_dr = 0 
     
      #--現時匯率---
      IF g_ash.ash11='1' THEN 
         CALL p500_fun_amt(g_aag04,g_asw.asw12,
                           g_ash.ash11,g_asg.asg06,
                           g_asg.asg07,tm.yy,tm.mm,g_asa05)   
         RETURNING g_fun_dr 
      END IF

      #--歷史匯率---
      IF g_ash.ash11='2' AND ( g_dept.asa02 != g_dept.asb04 ) THEN  
          #----如果agli011抓不到資料，則依科目餘額計算---- 
         DECLARE p500_cnt_cs2 CURSOR FOR p500_asf_p2
         OPEN p500_cnt_cs2
         USING g_dept.asa01,g_dept.asb04,
               g_npq.npq03,g_date_e              
         FETCH p500_cnt_cs2 INTO g_asf_count
         CLOSE p500_cnt_cs2
         IF g_asf_count > 0 THEN   
             CALL p500_asf(i,g_ash.ash04,' ',g_date_e)
             RETURNING g_fun_dr,g_acc_dr 
         ELSE
             #--取不到agli011時一樣用匯率換算---
             CALL p500_fun_amt(g_aag04,g_asw.asw12,
                           g_ash.ash11,g_asg.asg06,
                           g_asg.asg07,tm.yy,tm.mm,g_asa05)  
             RETURNING g_fun_dr 
         END IF
      ELSE
         CALL p500_fun_amt(g_aag04,g_asw.asw12,
                           g_ash.ash11,g_asg.asg06,
                           g_asg.asg07,tm.yy,tm.mm,g_asa05)    
         RETURNING g_fun_dr 
      END IF
     
      #--平均匯率---
      IF g_ash.ash11='3' THEN
         CALL p500_fun_amt(g_aag04,g_asw.asw12,g_ash.ash11,g_asg.asg06,
                           g_asg.asg07,tm.yy,tm.mm,g_asa05)  
         RETURNING g_fun_dr  
      END IF
      #-----依科目在agli001中(換算)匯率各自取出匯率後計算上層記帳幣金額--
      
      #--現時匯率---
      IF g_ash.ash12='1' THEN 
         CALL p500_acc_amt(g_aag04,g_fun_dr,
                           g_ash.ash12,g_asg.asg07,
                           g_aaa03,tm.yy,tm.mm,g_asa05)   
         RETURNING g_acc_dr  
      END IF

      #--歷史匯率---
      IF g_ash.ash12='2' AND ( g_dept.asa02 != g_dept.asb04 ) THEN  
         #----如果agli011抓不到資料，則依科目餘額計算---- 
         DECLARE p500_cnt_cs34 CURSOR FOR p500_asf_p2
         OPEN p500_cnt_cs34
         USING g_dept.asa01,g_dept.asb04,
               g_npq.npq03 ,g_date_e  
         FETCH p500_cnt_cs34 INTO g_asf_count
         CLOSE p500_cnt_cs34
         IF g_asf_count > 0 THEN   
            CALL p500_asf(i,g_ash.ash04,' ',g_date_e) 
            RETURNING g_fun_dr,g_acc_dr  
         ELSE
            #--取不到agli011時一樣用匯率換算---
            CALL p500_acc_amt(g_aag04,g_fun_dr,
                              g_ash.ash12,g_asg.asg07,
                              g_aaa03,tm.yy,tm.mm,g_asa05)    
            RETURNING g_acc_dr  
         END IF
      ELSE
         CALL p500_acc_amt(g_aag04,g_fun_dr,
                           g_ash.ash12,g_asg.asg07,                    
                           g_aaa03,tm.yy,tm.mm,g_asa05)        
         RETURNING g_acc_dr 
      END IF
      
      #--平均匯率---
      IF g_ash.ash12='3' THEN
         CALL p500_acc_amt(g_aag04,g_fun_dr,
                           g_ash.ash12,g_asg.asg07,
                           g_aaa03,tm.yy,tm.mm,g_asa05)       
         RETURNING g_acc_dr  
      END  IF
 
      LET g_chg_asw12  =g_chg_asw12   + g_fun_dr
      LET g_chg_asw12_1=g_chg_asw12_1 + g_acc_dr  

      SELECT azi04 INTO g_cut FROM azi_file WHERE azi01=g_asg.asg07                                                                               
      IF cl_null(g_cut) THEN LET g_cut=0 END IF                                                                                                   
      SELECT azi04 INTO g_cut1 FROM azi_file WHERE azi01=g_aaa03                                                                                  
      IF cl_null(g_cut1) THEN LET g_cut1=0 END IF       
      LET g_chg_asw12=cl_digcut(g_chg_asw12,g_cut)    
      LET g_chg_asw12_1=cl_digcut(g_chg_asw12_1,g_cut1)   
      IF cl_null(g_chg_asw12_1) THEN LET g_chg_asw12_1=0 END IF
      #FUN-90087--ADD--END--
      
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
   #             "  FROM ",g_dbs_asa02,"imb_file ",  
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
      CALL p500_getrate(tm.yy,tm.mm,g_asg06,g_npq.npq24) RETURNING g_rate1
      LET g_sum = g_sum * g_rate1
      LET g_cut = 0
      SELECT azi04 INTO g_cut FROM azi_file WHERE azi01=g_npq.npq24
      IF cl_null(g_cut) THEN LET g_cut=0 END IF
      LET g_sum=cl_digcut(g_sum,g_cut)

      LET g_asw.asw01  = tm.yy                        #年度
      LET g_asw.asw02  = tm.mm                        #期別
    # LET g_asw.asw03  = tm.asa01                     #族群代號
      LET g_asw.asw03 = g_dept.asa01
    # LET g_asw.asw031 = tm.asa02                     #上層公司
      LET g_asw.asw031 = g_dept.asa02
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
      LET g_asw.asw09  = g_asz.asz07                 #帳列科目 
      LET g_asw.asw10  = ' '                          #交易科目
  #   LET g_asw.asw19  = g_aaz.aaz109               #交易科目
  #   LET g_asw.asw11  = g_npq.npq24                  #來源幣別   #FUN-B90087 MARK
      LET g_asw.asw11  = g_asg06                     #FUN-B90087 ADD
  #   LET g_asw.asw12  = g_npq.npq07                 #交易金額=銷貨收入  #FUN-B90087 MARK
      LET g_asw.asw12  = g_chg_asw12_1               #FUN-B90087 ADD
  #   LET g_asw.asw13  = g_npq.npq07-g_sum           #交易損益=銷貨收入-銷貨成本
  #   LET g_asw.asw13  = g_sum                        #FUN-B60134   #FUN-B90087 MARK
      LET g_asw.asw13  = 0                            #FUN-B90087
  #    IF l_poz00 = '1' THEN
  #      LET g_asw.asw131 = g_asw.asw13
  #    ELSE
  #     LET g_asw.asw131 = 0 
  #    END IF 
  #    LET g_asw.asw14  = g_asw.asw13-g_asw.asw131     #未實現利益=交易損益-已實現利益
      LET g_asw.asw14 = 0                                      #FUN-B60134
      LET g_asw.asw131  = g_asw.asw12-g_asw.asw14-g_asw.asw13  #FUN-B60134  #FUN-B90087 ADD
      LET g_asw.asw131  = g_asw.asw12                          #FUN-B90087 
      LET g_asw.asw15  = g_rate                       #持股比率
      LET g_asw.asw16  = g_asw.asw14*g_asw.asw15/100  #分配未實現利益=未實現利益*持股比率/100  
      LET g_asw.asw17  = ' '                          #來源單號   #FUN-910002 mod
      LET g_asw.aswlegal = g_legal                    #所属法人     
   

      #因為採各子公司交易彙總產生，例如j11-->j10的交易逆流只有一筆
      #所以要先檢查子公司-->母公司的資料是否已產生過，
      #沒有的話就INSERT，若有則UPDATE
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt FROM asw_file
       WHERE asw01=tm.yy         AND asw02 =tm.mm
         AND asw03=tm.asa01      AND asw031=tm.asa02
         AND asw05='2'           AND asw06 ='1'
         AND asw07=g_dept.asb04  AND asw08 =g_dept.asa02
         AND asw11 = g_asw.asw11   #No.FUN-920139  
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
                             asw131= asw131+g_asw.asw131,#FUN-B60134
                             asw14 =asw14+g_asw.asw14,
                             asw16 =asw16+g_asw.asw16
          WHERE asw01=tm.yy         AND asw02 =tm.mm
            AND asw03=tm.asa01      AND asw031=tm.asa02
            AND asw05='2'           AND asw06 ='1'
            AND asw07=g_dept.asb04  AND asw08 =g_dept.asa02
            AND asw11 = g_asw.asw11 
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            LET g_showmsg=tm.yy,"/",tm.mm
            CALL s_errmsg('asw01,asw02',g_showmsg,'upd_asw',SQLCA.sqlcode,1)
            CONTINUE FOREACH
         END IF
      END IF
   END FOREACH
END FUNCTION


FUNCTION p500_process_side(g_dept)    #處理側流
DEFINE g_dept       RECORD        
                     asa01      LIKE asa_file.asa01,   #族群代號
                     asa02      LIKE asa_file.asa02,   #上層公司
                     asa03      LIKE asa_file.asa03,   #帳別
                     asb04      LIKE asb_file.asb04,   #下層公司
                     asb05      LIKE asb_file.asb05    #帳別  
                    END RECORD,
       l_sql        STRING,
       g_asb04      LIKE asb_file.asb04,               #其他下層公司
       l_asg04      LIKE asg_file.asg04,
       l_omb04      LIKE omb_file.omb04,               #產品編號  
       l_omb12      LIKE omb_file.omb12,               #數量     
       l_imb_sum    LIKE imb_file.imb118               #銷貨成本
DEFINE l_npp02b     LIKE npp_file.npp02             
DEFINE l_npp02e     LIKE npp_file.npp02            
DEFINE l_dbs_azp01  LIKE azp_file.azp01
#側流:
#依據族群代碼/上層公司
#所屬子公司的關係人交易[同逆流抓取邏輯]

#1.QBE條件=asa01/asa02[族群代碼]/[上層公司]->asb04[下層公司]
#                                          ->asb04[其他下層公司]
#                                          ->asg08[其他下層公司關係人代碼]
#2.找各子公司分錄底稿抓關係人異動碼=asg08[其他子公司關係人代碼]，
#  抓取屬於與其他子公司交易的銷貨收入科目及金額
#3.抓取應收憑單單身的料號-->實際成本
#4.銷貨收入-實際成本=交易損益
#  交易損益-已實現損益=未實現損益
#  未實現損益*持股比率=分配未實現利益
#5.金額需換算成上層公司幣別金額

   SELECT asg04 INTO l_asg04 FROM asg_file WHERE asg01=g_dept.asb04
   IF l_asg04 = 'Y' THEN   #使用Tiptop否
      #以下層公司(asb04)的營運中心代碼(asg03)去抓所在的資料庫代碼(azp03)
    #  SELECT azp03 INTO g_dbs_new FROM azp_file 
    #   WHERE azp01=(SELECT asg03 FROM asg_file WHERE asg01=g_dept.asb04)
     SELECT asg03 INTO l_dbs_azp01 FROM asg_file WHERE asg01=g_dept.asb04  #FUN-B40104
   #   IF STATUS THEN LET g_dbs_new = NULL END IF
   #   IF NOT cl_null(g_dbs_new) THEN 
   #      LET g_dbs_new=g_dbs_new CLIPPED,'.' 
   #   END IF
   #   LET g_dbs_gl = g_dbs_new CLIPPED
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
   PREPARE p500_asb_p FROM l_sql
   IF STATUS THEN 
      CALL cl_err('p500_asb_p',STATUS,1)             
   END IF
   DECLARE p500_asb_c CURSOR FOR p500_asb_p
   FOREACH p500_asb_c INTO g_asb04
   IF SQLCA.SQLCODE THEN 
      CALL s_errmsg(' ',' ','p500_asb_c:',STATUS,1)
      LET g_success = 'N'
      CONTINUE FOREACH
   END IF

   #抓取其他子公司關係人代碼(asg08)
   SELECT asg08 INTO g_asg08 FROM asg_file 
    WHERE asg01=g_asb04 

   #FUN-B90087--MARK--STR
   #抓母公司的記帳幣別(asg06)
   # LET g_asg06=''
   # SELECT asg06 INTO g_asg06  FROM asg_file WHERE asg01=g_dept.asa02
   #FUN-B90087--MARK--END 
      #-->產生asw_file(合併報表關係人交易資料檔)
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
                #抓取子公司原始銷貨收入科目(ash04)
                 "   AND npq03 IN (SELECT ash04 FROM ash_file", 
                 "                  WHERE ash01='",g_dept.asb04,"'",
                 "                    AND ash00='",g_dept.asb05,"'",
                 "                    AND ash13='",tm.asa01,"'",  
                 "                    AND ash06='",g_asz.asz07,"')", #銷貨收入科目
                 "   AND npq37  = '",g_asg08,"'"       #異動碼-關係人
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       CALL cl_parse_qry_sql(l_sql,l_dbs_azp01) RETURNING l_sql  #FUN-B40104		
       PREPARE p500_npq_p31 FROM l_sql
       #FUN-B90087-ADD--STR
       IF STATUS THEN
          LET g_showmsg=tm.yy,"/",g_dept.asb05
          CALL s_errmsg('ash00,ash01',g_showmsg,'pre:p500_npq_c11_p',STATUS,1)
          LET g_success = 'N'
       END IF 
       #FUN-B90087-ADD--END
       DECLARE p500_npq_c31 CURSOR FOR p500_npq_p31
       FOREACH p500_npq_c31 INTO g_npq.*
         IF SQLCA.SQLCODE THEN 
            CALL s_errmsg(' ',' ','p500_npq_c31:',STATUS,1)
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF
        #FUN-B90087-ADD--STR
        LET g_asw.asw12=g_npq.npq07 
        LET l_sql = "SELECT aag04", " FROM ",cl_get_target_table(l_dbs_azp01,'aag_file'),
                    " WHERE aag00='",g_dept.asb05,"'",
                    "   AND aag01='",g_npq.npq03,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,l_dbs_azp01) RETURNING l_sql
        PREPARE p500_aag_p2 FROM l_sql
        EXECUTE p500_aag_p2  INTO  g_aag04
      
        LET g_ash.ash11 = '1'
        LET g_ash.ash12 = '1'  
        LET l_sql = 
           " SELECT ash04,ash11,ash12 FROM ash_file ",  
           "  WHERE ash01 = '",g_dept.asb04,"'",
           "    AND ash06 = '",g_asz.asz07,"'", 
           "    AND ash00 = '",g_dept.asb05,"'", 
           "    AND ash13 = '",tm.asa01,"'"   
        PREPARE p500_ash_p6 FROM l_sql
        DECLARE p500_ash_c6 SCROLL CURSOR FOR p500_ash_p6
        OPEN p500_ash_c6
        FETCH FIRST p500_ash_c6 INTO g_ash.*
        CLOSE p500_ash_c6
        IF STATUS  THEN                   
           LET g_showmsg=g_dept.asb04,"/",g_asw.asw10
           CALL s_errmsg('ash01,ash04',g_showmsg,g_asw.asw10,'aap-021',1)                  
           LET g_success = 'N'
           CONTINUE FOREACH    
        END IF

        SELECT * INTO g_asg.* FROM asg_file WHERE asg01=g_dept.asb04
        IF SQLCA.sqlcode THEN
           CALL s_errmsg('asg01',g_dept.asb04,' ',SQLCA.sqlcode,1)   
           LET g_success = 'N'
        END IF


        #當上層公司不等於下層公司時,才需要抓匯率來計算,否則匯率用1來計算
        LET g_rate  = 1
        LET g_rate1 = 1
         #當再衡量匯率類別(ash11),換算匯率類別(ash12)選擇的是歷史匯率時,
         #金額需抓agli011設定的記帳幣別金額(小於等於本期),
         #一一換算後再加總起來
        LET g_chg_asw12_1=0
        LET g_chg_asw12=0
        LET g_chg_asw12_a=0
        LET g_chg_dr = 0 
        LET g_fun_dr = 0 
        LET g_acc_dr = 0 
        LET g_dr = 0  
        
        #--現時匯率---
        IF g_ash.ash11='1' THEN 
           CALL p500_fun_amt(g_aag04,g_asw.asw12,
                              g_ash.ash11,g_asg.asg06,
                              g_asg.asg07,tm.yy,tm.mm,g_asa05)   
           RETURNING g_fun_dr  
        END IF

        #--歷史匯率---
        IF g_ash.ash11='2' AND ( g_dept.asa02 != g_dept.asb04 ) THEN  
           #----如果agli011抓不到資料，則依科目餘額計算---- 
           DECLARE p500_cnt_cs3 CURSOR FOR p500_asf_p2
           OPEN p500_cnt_cs3
           USING g_dept.asa01,g_dept.asb04,
                g_npq.npq03,g_date_e               
           FETCH p500_cnt_cs3 INTO g_asf_count
           CLOSE p500_cnt_cs3
           IF g_asf_count > 0 THEN   
               CALL p500_asf(i,g_ash.ash04,' ',g_date_e)   
               RETURNING g_fun_dr,g_acc_dr
           ELSE
               #--取不到agli011時一樣用匯率換算---
               CALL p500_fun_amt(g_aag04,g_asw.asw12,
                             g_ash.ash11,g_asg.asg06,
                             g_asg.asg07,tm.yy,tm.mm,g_asa05)  
               RETURNING g_fun_dr  
           END IF
        ELSE
           CALL p500_fun_amt(g_aag04,g_asw.asw12,
                             g_ash.ash11,g_asg.asg06,
                             g_asg.asg07,tm.yy,tm.mm,g_asa05)    
           RETURNING g_fun_dr  
        END IF
       
        #--平均匯率---
        IF g_ash.ash11='3' THEN
           CALL p500_fun_amt(g_aag04,g_asw.asw12,g_ash.ash11,g_asg.asg06,
                             g_asg.asg07,tm.yy,tm.mm,g_asa05)   
           RETURNING g_fun_dr  
        END IF
        #-----依科目在agli001中(換算)匯率各自取出匯率後計算上層記帳幣金額--
        #--現時匯率---
        IF g_ash.ash12='1' THEN 
           CALL p500_acc_amt(g_aag04,g_fun_dr,
                             g_ash.ash12,g_asg.asg07,
                              g_aaa03,tm.yy,tm.mm,g_asa05)    
           RETURNING g_acc_dr  
        END IF

        #--歷史匯率---
        IF g_ash.ash12='2' AND ( g_dept.asa02 != g_dept.asb04 ) THEN  
           #----如果agli011抓不到資料，則依科目餘額計算---- 
           DECLARE p500_cnt_cs44 CURSOR FOR p500_asf_p2
           OPEN p500_cnt_cs44
           USING g_dept.asa01,g_dept.asb04,
                 g_asw.asw01,g_date_e  
           FETCH p500_cnt_cs44 INTO g_asf_count
           CLOSE p500_cnt_cs44
           IF g_asf_count > 0 THEN   
               CALL p500_asf(i,g_ash.ash04,' ',g_date_e)  
               RETURNING g_fun_dr,g_acc_dr 
           ELSE
               #--取不到agli011時一樣用匯率換算---
               CALL p500_acc_amt(g_aag04,g_fun_dr,
                                 g_ash.ash12,g_asg.asg07,
                                 g_aaa03,tm.yy,tm.mm,g_asa05)     
               RETURNING g_acc_dr  
           END IF
        ELSE
           CALL p500_acc_amt(g_aag04,g_fun_dr,
                             g_ash.ash12,g_asg.asg07,
                             g_aaa03,tm.yy,tm.mm,g_asa05)    
           RETURNING g_acc_dr  
        END IF
       
        #--平均匯率---
        IF g_ash.ash12='3' THEN
           CALL p500_acc_amt(g_aag04,g_fun_dr,
                             g_ash.ash12,g_asg.asg07,
                             g_aaa03,tm.yy,tm.mm,g_asa05)        
           RETURNING g_acc_dr  
        END IF

        LET g_chg_asw12  =g_chg_asw12   + g_fun_dr
        LET g_chg_asw12_1=g_chg_asw12_1 + g_acc_dr  

        SELECT azi04 INTO g_cut FROM azi_file WHERE azi01=g_asg.asg07                                                                               
        IF cl_null(g_cut) THEN LET g_cut=0 END IF                                                                                                   
        SELECT azi04 INTO g_cut1 FROM azi_file WHERE azi01=g_aaa03                                                                                  
        IF cl_null(g_cut1) THEN LET g_cut1=0 END IF       

        LET g_chg_asw12=cl_digcut(g_chg_asw12,g_cut)    
        LET g_chg_asw12_1=cl_digcut(g_chg_asw12_1,g_cut1)   
        IF cl_null(g_chg_asw12_1) THEN LET g_chg_asw12_1=0 END IF
        #FUN-B90087--ADD--END-- 
         
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
         CALL p500_getrate(tm.yy,tm.mm,g_asg06,g_npq.npq24) RETURNING g_rate1
         LET g_sum = g_sum * g_rate1
         LET g_cut = 0
         SELECT azi04 INTO g_cut FROM azi_file WHERE azi01=g_npq.npq24
         IF cl_null(g_cut) THEN LET g_cut=0 END IF
         LET g_sum=cl_digcut(g_sum,g_cut)

         LET g_asw.asw01  = tm.yy                        #年度
         LET g_asw.asw02  = tm.mm                        #期別
       # LET g_asw.asw03  = tm.asa01                     #族群代號
         LET g_asw.asw03  = g_dept.asa01
       # LET g_asw.asw031 = tm.asa02                     #上層公司
         LET g_asw.asw031  = g_dept.asa02
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
         LET g_asw.asw09  = g_asz.asz07                 #帳列科目   #FUN-780068 mod 10/19
         LET g_asw.asw10  = ' '                          #交易科目
#        LET g_asw.asw19  = g_aaz.aaz109               #交易科目
#        LET g_asw.asw11  = g_npq.npq24                  #來源幣別   #FUN-B90087 MAEK
         LET g_asw.asw11  = g_asg06                      #FUN-B90087 ADD
#        LET g_asw.asw12  = g_npq.npq07                 #交易金額=銷貨收入  #FUN-B90087  MARK
         LET g_asw.asw12  = g_chg_asw12_1                 #FUN-B90087 ADD
#        LET g_asw.asw13  = g_npq.npq07-g_sum           #交易損益=銷貨收入-銷貨成本
#        LET g_asw.asw13  = g_sum                       #FUN-B60134  #FUN-B90087  MARK
         LET g_asw.asw13  = 0                            #FUN-B90087 ADD
#        LET g_asw.asw131 = 0                            #已實現損益
#        LET g_asw.asw14  = g_asw.asw13-g_asw.asw131     #未實現利益=交易損益-已實現利益
         LET g_asw.asw14  = 0                                    #FUN-B60134     
#        LET g_asw.asw131 = g_asw.asw12-g_asw.asw14-g_asw.asw13  #FUN-B60134   ADD  #FUN-B90087 MARK
         LET g_asw.asw131 = g_asw.asw12                 #FUN-B90087 
         LET g_asw.asw15  = g_rate                       #持股比率
         LET g_asw.asw16  = g_asw.asw14*g_asw.asw15/100  #分配未實現利益=未實現利益*持股比率/100  
         LET g_asw.asw17  = ' '                          #來源單號  
         LET g_asw.aswlegal = g_legal                    #所属法人   #NO.FUN-B40104  

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
         #準備寫入agli012關係人交易明細
         IF g_cnt = 0 THEN    #沒有同樣key值的資料,可以新增 
            INSERT INTO asw_file VALUES(g_asw.*)
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("ins","asw_file",g_asw.asw01,g_asw.asw02,SQLCA.sqlcode,"","",1)
            END IF
         ELSE                 #有同樣key值的資料,做UPDATE
            UPDATE asw_file SET asw12 =asw12+g_asw.asw12,
                                asw13 =asw13+g_asw.asw13,
                                asw131 = asw131+g_asw.asw131,   #FUN-B60134  ADD
                                asw14 =asw14+g_asw.asw14,
                                asw16 =asw16+g_asw.asw16
             WHERE asw01=tm.yy         AND asw02 =tm.mm
               AND asw03=tm.asa01      AND asw031=tm.asa02
               AND asw05='3'           AND asw06 ='1'
               AND asw07=g_dept.asb04  AND asw08 =g_asb04
               AND asw11=g_asw.asw11
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
               LET g_showmsg=tm.yy,"/",tm.mm
               CALL s_errmsg('asw01,asw02',g_showmsg,'upd_asw',SQLCA.sqlcode,1)
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
                       asa01      LIKE asa_file.asa01,  #族群代號
                       asa02      LIKE asa_file.asa02,  #上層公司
                       asa03      LIKE asa_file.asa03,  #帳別
                       asb04      LIKE asb_file.asb04,  #下層公司
                       asb05      LIKE asb_file.asb05   #帳別  
                      END RECORD 
   #假設集團公司層級如下:A下面有B、C,B下面有D、E,E下面有F,C下面有G
   #     A             #需產生A-B
   #   ┌─┴─┐        #      A-C
   #  B    C        #      A-D
   # ┌┴┐   │       #      A-E
   # D E   G        #      A-F
   #   │              #      A-G等關係人層級資料
   #   F

   #1.先檢查Temptable裡有沒有資料,沒有的話,先寫入最上一層的關係人層級資料
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM p500_tmp
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt = 0 THEN CALL p500_bom(tm.asa01,tm.asa02,tm.asa03) END IF 

   #2-1.檢查Temptable裡有沒有chk=N的資料(表示還未抓它的下層公司),
   #    沒有的話,表示所有層級資料都產生了,離開此FUNCTION
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM p500_tmp WHERE chk='N'
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt = 0 THEN RETURN END IF 

   #2-2.檢查Temptable裡有沒有chk=N的資料(表示還未抓它的下層公司),
   #    以下層公司當上層公司,去抓其下層公司,產生跨層的公司層級資料
   DECLARE asb_curs1 CURSOR FOR
      SELECT asa01,asa02,asa03,asb04,asb05
        FROM p500_tmp
       WHERE chk='N'
   FOREACH asb_curs1 INTO l_dept.*
      CALL p500_bom(l_dept.asa01,l_dept.asb04,l_dept.asb05)
      UPDATE p500_tmp SET chk='Y'
       WHERE asa01=l_dept.asa01
         AND asb04=l_dept.asb04
         AND asb05=l_dept.asb05
   END FOREACH

   CALL p500_dept()

END FUNCTION

FUNCTION p500_bom(p_asa01,p_asa02,p_asa03)
   DEFINE p_asa01   LIKE asa_file.asa01   #族群代號
   DEFINE p_asa02   LIKE asa_file.asa02   #上層公司
   DEFINE p_asa03   LIKE asa_file.asa03   #帳別
   DEFINE l_sql       STRING

   LET l_sql="INSERT INTO p500_tmp (chk,asa01,asa02,asa03,asb04,asb05)",
             "SELECT 'N',",
             "       '",tm.asa01 CLIPPED,"',",
             "       '",tm.asa02 CLIPPED,"',",
             "       '",tm.asa03 CLIPPED,"',",
             "       asb04,asb05",
             "  FROM asb_file,asa_file ",
             " WHERE asa01=asb01 AND asa02=asb02 AND asa03=asb03 ",
             "   AND asa01=? AND asa02=? AND asa03=?"
   PREPARE p500_asb_p1 FROM l_sql
   EXECUTE p500_asb_p1 USING p_asa01,p_asa02,p_asa03
   
END FUNCTION

FUNCTION p500_getrate(p_ase01,p_ase02,p_ase03,p_ase04)   #抓現時匯率
DEFINE p_ase01 LIKE ase_file.ase01,
       p_ase02 LIKE ase_file.ase02,
       p_ase03 LIKE ase_file.ase03,
       p_ase04 LIKE ase_file.ase04,
       g_rate  LIKE ase_file.ase05 

   SELECT ase05 INTO g_rate   #現時匯率
     FROM ase_file
    WHERE ase01=p_ase01
      AND ase02=(SELECT MAX(ase02) FROM ase_file
                  WHERE ase01 = p_ase01
                    AND ase02 <=p_ase02
                    AND ase03 = p_ase03
                    AND ase04 = p_ase04)
      AND ase03=p_ase03 
      AND ase04=p_ase04

   IF g_rate = 0 THEN LET g_rate = 1 END IF

   RETURN g_rate
END FUNCTION

#FUN-B90087--ADD--STR--
FUNCTION p500_fun_amt(p_aag04,p_dr,p_ash11,p_asg06,p_asg07,p_yy,p_mm,p_asa05)   
DEFINE p_aag04    LIKE aag_file.aag04
DEFINE p_ash11    LIKE ash_file.ash11
DEFINE p_asg06    LIKE asg_file.asg06
DEFINE p_asg07    LIKE asg_file.asg07
DEFINE p_yy       LIKE asw_file.asw01
DEFINE p_mm       LIKE asw_file.asw02
DEFINE l_bs_yy    LIKE asw_file.asw01
DEFINE l_bs_mm    LIKE asw_file.asw02
DEFINE g_fun_dr   LIKE asw_file.asw12
DEFINE p_dr       LIKE asw_file.asw12
DEFINE g_cut      LIKE type_file.num5   
DEFINE p_asa05    LIKE asa_file.asa05   

   IF p_aag04='1' THEN #1.BS 2.IS
      LET l_bs_yy=p_yy
      LET l_bs_mm=tm.mm
   ELSE
      LET l_bs_yy=p_yy
      LET l_bs_mm=p_mm
   END IF

   LET g_fun_dr=0 
    
    #當子公司記帳幣別與子公司功能幣別不同時才需要抓匯率來計算
   LET g_rate = 1
   IF p_asg06 != p_asg07 THEN 
        #功能幣別匯率
      IF p_ash11 <> '3' THEN   #不採平均匯率時直接取當期匯率
         CALL p500_getrate(l_bs_yy,l_bs_mm,
                           p_asg06,p_asg07)
         RETURNING g_rate
         IF cl_null(g_rate) THEN LET g_rate = 1 END IF 
      ELSE
         IF p_asa05 = '2' THEN
               CALL p500_getrate1(p_aag04,p_asg06,p_asg07)
               RETURNING g_rate
           ELSE
               CALL p500_getrate3(p_ash11,l_bs_yy,l_bs_mm,
                                 p_asg06,p_asg07)
               RETURNING g_rate
               IF cl_null(g_rate) THEN LET g_rate = 1 END IF 
           END IF
        END IF
    END IF

    #->幣別轉換及取位
    LET g_fun_dr=p_dr * g_rate   
   
    SELECT azi04 INTO g_cut FROM azi_file WHERE azi01=p_asg07                                                                               
    IF cl_null(g_cut) THEN LET g_cut=0 END IF                                                                                                   
    LET g_fun_dr=cl_digcut(g_fun_dr,g_cut)                                                                                               
    IF cl_null(g_fun_dr) THEN LET g_fun_dr=0 END IF                                                                                                                                                                     
    RETURN g_fun_dr
END FUNCTION


FUNCTION p500_acc_amt(p_aag04,p_dr,p_ash12,p_asg07,p_aaa03,p_yy,p_mm,p_asa05)      
DEFINE p_aag04    LIKE aag_file.aag04
DEFINE p_ash12    LIKE ash_file.ash12
DEFINE p_aaa03    LIKE aaa_file.aaa03
DEFINE p_asg07    LIKE asg_file.asg07
DEFINE p_yy       LIKE asw_file.asw01
DEFINE p_mm       LIKE asw_file.asw02
DEFINE l_bs_yy    LIKE asw_file.asw01
DEFINE l_bs_mm    LIKE asw_file.asw02
DEFINE g_acc_dr   LIKE asw_file.asw12
DEFINE p_dr       LIKE asw_file.asw12
DEFINE g_cut1     LIKE type_file.num5             #幣別取位(記帳幣別)
DEFINE p_asa05    LIKE asa_file.asa05    

   IF p_aag04='1' THEN #1.BS 2.IS
        LET l_bs_yy=p_yy
        LET l_bs_mm=tm.mm
   ELSE
        LET l_bs_yy=p_yy
        LET l_bs_mm=p_mm
   END IF
   LET g_acc_dr=0 
 
   #當子公司功能幣別與母公司記帳幣別不同時才需要抓匯率來計算
   LET g_rate1 = 1
   IF p_asg07 != p_aaa03 THEN
       #記帳幣別匯率
       IF p_ash12 <> '3' THEN   
          CALL p500_getrate(l_bs_yy,l_bs_mm,
                            p_asg07,p_aaa03)
          RETURNING g_rate1
          IF cl_null(g_rate1) THEN LET g_rate1 = 1 END IF
       ELSE
          IF p_asa05 != '3' THEN 
              CALL p500_getrate1(p_aag04,p_asg07,p_aaa03)
              RETURNING g_rate1
          ELSE
              CALL p500_getrate3(p_ash12,l_bs_yy,l_bs_mm,
                                p_asg07,p_aaa03)
              RETURNING g_rate1
              IF cl_null(g_rate1) THEN LET g_rate1 = 1 END IF 
          END IF
       END IF
   END IF

   #->幣別轉換及取位
   LET g_acc_dr=p_dr * g_rate1 

   SELECT azi04 INTO g_cut1 FROM azi_file WHERE azi01=g_aaa03                                                                                  
   IF cl_null(g_cut1) THEN LET g_cut1=0 END IF                                                                                                 
                                                                                                                                        
   LET g_acc_dr=cl_digcut(g_acc_dr,g_cut1)                                                                                           
   IF cl_null(g_acc_dr) THEN LET g_acc_dr=0 END IF                                                                                                                                                                    
   RETURN g_acc_dr

END FUNCTION


FUNCTION p500_asf(p_i,p_aag01,p_ash06,p_date) 
DEFINE p_aag01  LIKE aag_file.aag01
DEFINE p_ash06  LIKE ash_file.ash06
DEFINE p_date   LIKE type_file.dat 
DEFINE l_aag06  LIKE aag_file.aag06
DEFINE l_asf13  LIKE asf_file.asf13               
DEFINE p_i      LIKE type_file.num5
DEFINE l_asf16  LIKE asf_file.asf16             

   DECLARE p500_asf_cs1 CURSOR FOR p500_asf_p
   OPEN p500_asf_cs1 
   USING g_dept[p_i].asa01,g_dept[p_i].asb04,
         p_ash06,p_date    
   FETCH p500_asf_cs1                      
   INTO l_aag06,l_asf16,l_asf13                  

   IF l_asf13 > 0 THEN 
       IF l_aag06='1' THEN                     #正常餘額為1.借餘
            LET g_fun_dr=l_asf16         
            LET g_chg_dr=l_asf13          #借
       ELSE                                    #正常餘額為2.貸餘
           LET g_fun_dr=0                
           LET g_chg_dr=0                 
       END IF
   ELSE
       IF l_aag06='1' THEN                     #正常餘額為1.借餘
           LET g_fun_dr=0                     
           LET g_chg_dr=0
       ELSE                                    #正常餘額為2.貸餘
           LET g_fun_dr=(l_asf16*-1)          
           LET g_chg_dr=(l_asf13*-1)
       END IF
   END IF

   LET g_rate = 1
   LET g_rate1 = 1
   SELECT asf15,asf12
   INTO g_rate,g_rate1  
    FROM asf_file
   WHERE asf01= g_dept[p_i].asa01
     AND asf02= g_dept[p_i].asb04
     AND asf07= p_aag01
     AND asf03= p_ash06
     AND asf06<=p_date
   IF cl_null(g_rate) THEN LET g_rate = 1 END IF  
   IF cl_null(g_rate1) THEN LET g_rate1 = 1 END IF   
   RETURN g_fun_dr,g_chg_dr
END FUNCTION

FUNCTION p500_getrate1(p_aag04,p_asg06,p_asg07)   #抓歷史匯率
DEFINE p_aah01       LIKE aah_file.aah01
DEFINE p_asg06       LIKE asg_file.asg07
DEFINE p_asg07       LIKE asg_file.asg07
DEFINE p_aag04       LIKE aag_file.aag04
DEFINE l_month_count LIKE type_file.num5
DEFINE l_sum_ase07   LIKE ase_file.ase07
DEFINE l_rate        LIKE ase_file.ase05
   IF p_aag04 = '1' THEN
      LET g_bm = 0
   ELSE
      LET g_bm = 1
   END IF
   SELECT SUM(ase07) INTO l_sum_ase07
     FROM ase_file
    WHERE ase01 = tm.yy
      AND ase03 = p_asg06
      AND ase04 = p_asg07
      AND ase02 BETWEEN g_bm AND tm.mm
      AND (ase07 IS NOT NULL AND ase07<>0)
   SELECT COUNT(ase07) INTO l_month_count
     FROM ase_file
    WHERE ase01 = tm.yy
      AND ase03 = p_asg06
      AND ase04 = p_asg07
      AND ase02 BETWEEN g_bm AND tm.mm
      AND (ase07 IS NOT NULL AND ase07<>0)
     
   LET l_rate = l_sum_ase07/l_month_count
   IF cl_null(l_rate) THEN LET l_rate = 1 END IF
   RETURN l_rate
END FUNCTION

FUNCTION p500_getrate3(l_value,l_ase01,l_ase02,l_ase03,l_ase04)
DEFINE l_value LIKE ash_file.ash11,
       l_ase01 LIKE ase_file.ase01,
       l_ase02 LIKE ase_file.ase02,
       l_ase03 LIKE ase_file.ase03,
       l_ase04 LIKE ase_file.ase04,
       l_ase05 LIKE ase_file.ase05,    
       l_ase06 LIKE ase_file.ase06,   
       l_ase07 LIKE ase_file.ase07,  
       l_rate  LIKE ase_file.ase05  

   SELECT ase05,ase06,ase07 
     INTO l_ase05,l_ase06,l_ase07 
     FROM ase_file
    WHERE ase01=l_ase01
      AND ase02=l_ase02
      AND ase03=l_ase03 
      AND ase04=l_ase04

   CASE
      WHEN l_value='1'   #1.現時匯率
         LET l_rate=l_ase05
      WHEN l_value='2'   #2.歷史匯率
         LET l_rate=l_ase06
      WHEN l_value='3'   #3.平均匯率
         LET l_rate=l_ase07
      OTHERWISE      
         LET l_rate=1
   END CASE

   IF l_rate = 0 THEN LET l_rate = 1 END IF

   RETURN l_rate
END FUNCTION
#FUN-B90087--ADD--END--
#--FUN-A70053 end-------------
#NO.FUN-B40104	
