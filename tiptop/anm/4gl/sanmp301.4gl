# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: sanmp301.4gl
# Date & Author..: No.FUN-740007 07/03/26 chenl
# Modify.........: No.TQC-780056 07/08/17 By Carrier oracle語法轉至ora文檔
# Modify.........: No.FUN-870067 08/07/16 By douzh 新增匯豐銀行接口
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.FUN-B30166 11/03/29 By zhangweib nmu_file add nmu23
# Modify.........: No.CHI-B40058 11/05/16 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_nma           RECORD LIKE nma_file.*
DEFINE g_nmt           RECORD LIKE nmt_file.*
DEFINE g_nmu           RECORD LIKE nmu_file.*
DEFINE g_nmv           RECORD LIKE nmv_file.*
DEFINE tm              RECORD 
              wc       STRING,      #NO.FUN-910082 
              a        LIKE nma_file.nma01,
              b        LIKE nma_file.nma02,
              a_b_date LIKE type_file.dat,
              a_e_date LIKE type_file.dat,
              b_date   LIKE type_file.dat,
              e_date   LIKE type_file.dat,
              bgjob    LIKE type_file.chr1
                       END RECORD 
DEFINE g_msg1,g_msg2,g_msg3,g_msg4 LIKE ze_file.ze03
DEFINE g_success       LIKE type_file.chr1
DEFINE g_flag          LIKE type_file.chr1
DEFINE getdate_array   DYNAMIC ARRAY OF STRING
DEFINE g_b_date        LIKE type_file.dat
DEFINE l_nma39         LIKE nma_file.nma39           #No.FUN-870067
 
FUNCTION p301_tm(p_nma01)
    DEFINE    p_row,p_col   LIKE type_file.num5
    DEFINE    l_cmd         LIKE type_file.chr1000
    DEFINE    l_nma43       LIKE nma_file.nma43
    DEFINE    l_nmt12       LIKE nmt_file.nmt12        #No.FUN-870067
    DEFINE    l_nmaacti     LIKE nma_file.nmaacti
    DEFINE    l_nmr         RECORD LIKE nmr_file.*
    DEFINE    p_nma01       LIKE nma_file.nma01
    DEFINE    l_p1          STRING 
  
    OPEN WINDOW anmp301_w WITH FORM "anm/42f/anmp301"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
    
    CALL cl_opmsg('p')
    INITIALIZE tm.* TO NULL
    LET tm.a      = p_nma01
    LET tm.b_date = g_today
    LET tm.e_date = g_today
    LET tm.bgjob  = 'N'
    
    WHILE TRUE 
      
      INPUT BY NAME tm.a,tm.b_date,tm.e_date,tm.bgjob WITHOUT DEFAULTS
      
         AFTER FIELD a 
           IF NOT cl_null(tm.a) THEN 
              CALL p301_nma01('d')
              IF NOT cl_null(g_errno) THEN 
                 CALL cl_err(tm.a,g_errno,1)
                 LET tm.a = ''
                 DISPLAY BY NAME tm.a 
                 NEXT FIELD a
              END IF
#No.FUN-870067--begin
              SELECT nmt12 INTO l_nmt12 FROM nmt_file 
               WHERE nmt01 = l_nma39
              IF cl_null(g_aza.aza74) OR g_aza.aza74!=l_nmt12 THEN
                 CALL cl_err(tm.a,'anm-118',1)
                 LET tm.a = ''
                 LET tm.b = ''
                 DISPLAY BY NAME tm.a 
                 DISPLAY BY NAME tm.b 
                 NEXT FIELD a
              END IF
#No.FUN-870067--end
           END IF 
      
         AFTER FIELD b_date
           IF NOT cl_null(tm.b_date) THEN 
              IF NOT cl_null(tm.e_date) THEN 
                 IF tm.b_date > tm.e_date THEN 
                    CALL cl_err(tm.b_date,'mfg9234',1)
                    LET tm.b_date = ''
                    DISPLAY BY NAME tm.b_date
                    NEXT FIELD b_date
                 END IF
              END IF
              IF NOT cl_null(tm.a_e_date) THEN 
                 IF tm.b_date > tm.a_e_date THEN
                    CALL cl_getmsg('anm-254',g_lang) RETURNING g_msg2
                    CALL cl_getmsg('anm-256',g_lang) RETURNING g_msg3
                    LET g_msg4 = tm.a_e_date
                    LET g_msg1 = g_msg2 CLIPPED,g_msg4 CLIPPED,g_msg3 CLIPPED  
                    IF NOT (cl_confirm(g_msg1)) THEN 
                       LET tm.b_date = ''
                       DISPLAY BY NAME tm.b_date
                       NEXT FIELD b_date
                    END IF 
                 END IF 
              END IF   
           END IF  
           
         AFTER FIELD e_date
           IF NOT cl_null(tm.e_date) THEN 
              IF NOT cl_null(tm.b_date) THEN 
                 IF tm.e_date < tm.b_date THEN 
                    CALL cl_err(tm.e_date,'aap-100',1)
                    LET tm.e_date = ''
                    DISPLAY BY NAME tm.e_date
                    NEXT FIELD e_date
                 END IF
              END IF
              IF NOT cl_null(tm.a_b_date) THEN 
                 IF tm.e_date <tm.a_b_date THEN
                    CALL cl_getmsg('anm-255',g_lang) RETURNING g_msg2
                    CALL cl_getmsg('anm-256',g_lang) RETURNING g_msg3
                    LET g_msg4 = tm.a_b_date
                    LET g_msg1 = g_msg2 CLIPPED,g_msg4 CLIPPED,g_msg3 CLIPPED 
                    IF NOT (cl_confirm(g_msg1)) THEN 
                       LET tm.e_date = ''
                       DISPLAY BY NAME tm.e_date
                       NEXT FIELD e_date
                    END IF 
                 END IF 
              END IF   
           END IF 
      
         AFTER INPUT 
           IF INT_FLAG THEN 
              EXIT INPUT 
           END IF 
           IF tm.b_date = tm.a_b_date AND tm.e_date = tm.a_e_date THEN 
              CALL cl_err('','anm-257',1)
              LET tm.b_date=''
              LET tm.e_date=''
              DISPLAY BY NAME tm.b_date
              DISPLAY BY NAME tm.e_date
              NEXT FIELD b_date
           END IF 
           
         ON ACTION CONTROLP
            CASE 
              WHEN INFIELD(a)
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_nma7'
                LET g_qryparam.default1 = tm.a
                CALL cl_create_qry() RETURNING tm.a
                DISPLAY BY NAME tm.a
                NEXT FIELD a
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
 
 
         ON ACTION exit  
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
       
      END INPUT 
      
      IF INT_FLAG THEN 
         LET INT_FLAG = 0
         EXIT WHILE 
      END IF 
      
      IF tm.bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='anmp301'
         IF STATUS OR l_cmd IS NULL THEN
             CALL cl_err('anmp301','9031',1)   
         ELSE
         	  SELECT * INTO l_nmr.* FROM nmr_file 
         	   WHERE nmr01 = tm.a
         	  CASE SQLCA.sqlcode 
         	    WHEN 100
         	      CALL p301_b_date() RETURNING tm.b_date
         	      LET tm.e_date = g_today
         	    WHEN 0
         	      LET tm.b_date = l_nmr.nmr03+1
         	      LET tm.e_date = g_today
         	    OTHERWISE 
         	      CALL cl_err('sel nmr_file',SQLCA.sqlcode,1)
         	      EXIT WHILE 
         	  END CASE 
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_lang CLIPPED,"'",
                            " '",tm.bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.a CLIPPED,"'",
                            " '",tm.b_date CLIPPED,"'",
                            " '",tm.e_date CLIPPED,"'"
            CALL cl_cmdat('anmp301',g_time,l_cmd)	# Execute cmd at later time
         END IF
         EXIT WHILE
      END IF
      CALL cl_wait()
      CALL p301_logon() RETURNING l_p1
      IF NOT cl_null(l_p1) THEN
         CALL p301(l_p1)
      END IF
      IF g_success = 'Y' THEN 
         CALL cl_end2(1) RETURNING g_flag
      ELSE 
         CALL cl_end2(2) RETURNING g_flag
      END IF 
      IF g_flag THEN 
         CONTINUE WHILE
      ELSE 
         EXIT WHILE
      END IF 
    ERROR ""
    END WHILE 
    CLOSE WINDOW anmp301_w    
    RETURN tm.a
END FUNCTION 
 
FUNCTION p301(p_p1)
DEFINE   #l_sql       LIKE type_file.chr1000
         l_sql       STRING      #NO.FUN-910082 
DEFINE   sr          RECORD 
              nma01  LIKE nma_file.nma01,
              nma04  LIKE nma_file.nma04,
              nma10  LIKE nma_file.nma10,
              nma39  LIKE nma_file.nma39,
              nmt09  LIKE nmt_file.nmt09,
              nmt10  LIKE nmt_file.nmt10,
              nmt12  LIKE nmt_file.nmt12
                     END RECORD 
DEFINE   l_p         STRING
DEFINE   p_p1        STRING                #網銀登錄信息
DEFINE   sdkresult   STRING
DEFINE   l_n         LIKE type_file.num5
DEFINE   l_max_dat   LIKE type_file.dat
DEFINE   l_min_dat   LIKE type_file.dat
 
#FUN-B30166--add--str
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_time     LIKE type_file.chr20
   DEFINE l_nmu23    LIKE nmu_file.nmu23
#FUN-B30166--add--end
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET tm.wc = tm.wc clipped," AND nmauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET tm.wc = tm.wc clipped," AND nmagrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET tm.wc = tm.wc clipped," AND nmagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmauser', 'nmagrup')
    #End:FUN-980030
    
    CREATE TEMP TABLE nmu_temp(
        nmu01    LIKE nmu_file.nmu01,
        nmu02    LIKE nmu_file.nmu02, 
        nmu03    LIKE nmu_file.nmu03, 
        nmu04    LIKE nmu_file.nmu04,
        nmu05    LIKE nmu_file.nmu05,
        nmu06    LIKE nmu_file.nmu06,
        nmu07    LIKE nmu_file.nmu07,
        nmu08    LIKE nmu_file.nmu08,
        nmu09    LIKE nmu_file.nmu09,
        nmu10    LIKE nmu_file.nmu10,
        nmu11    LIKE nmu_file.nmu11,
        nmu12    LIKE nmu_file.nmu12,
        nmu13    LIKE nmu_file.nmu13,
        nmu14    LIKE nmu_file.nmu14,
        nmu15    LIKE nmu_file.nmu15,
        nmu16    LIKE nmu_file.nmu16,
        nmu17    LIKE nmu_file.nmu17,
        nmu18    LIKE nmu_file.nmu18,
        nmu19    LIKE nmu_file.nmu19,
        nmu20    LIKE nmu_file.nmu20,
        nmu21    LIKE nmu_file.nmu21,
        nmu22    LIKE nmu_file.nmu22 )
 
    DELETE FROM nmu_temp
     
    LET l_p = ''
    LET l_max_dat = NULL
    LET l_min_dat = NULL
    LET l_sql = "SELECT nma01,nma04,nma10,nma39,nmt09,nmt10,nmt12 ",
               #"  FROM nma_file, nmt_file " ,
                "  FROM nma_file LEFT OUTER JOIN nmt_file ON nma39 = nmt01" ,  #No.TQC-780056
                " WHERE nma01 = '",tm.a,"'"
               #"   AND nma39 = nmt01 "
    IF NOT cl_null(tm.wc) THEN 
       LET l_sql = l_sql ,tm.wc
    END IF 
    PREPARE p301_prep FROM l_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('p301_prep',SQLCA.sqlcode,1) 
       LET g_success = 'N'
       RETURN 
    END IF             
    DECLARE p301_cs CURSOR FOR p301_prep
    IF SQLCA.sqlcode THEN 
       CALL cl_err('p301_cs',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN 
    END IF 
   
    BEGIN WORK 
    LET g_success = 'Y'
    
    FOREACH p301_cs INTO sr.*
      IF sr.nmt12 = g_aza.aza74 THEN 
         LET l_p = "BBKNBR=",sr.nmt09 CLIPPED," ;ACCNBR=",sr.nma04 CLIPPED," ;BGNDAT=",tm.b_date USING "yyyymmdd" CLIPPED," ;ENDDAT=",tm.e_date USING "yyyymmdd" CLIPPED
        #調用網銀接口函數
         CALL cl_cmbinf(p_p1,'GetTransInfoA',l_p,'|')  RETURNING  sdkresult 
         CALL p301_s(sdkresult,'|','c') RETURNING g_success
         IF g_success = 'N' THEN 
            CALL cl_err('','abm-020',1)
            LET g_success = 'N'
            ROLLBACK WORK
            RETURN 
         END IF 
      END IF 
      DECLARE p301_cs1 CURSOR FOR SELECT * FROM nmu_temp
      FOREACH p301_cs1 INTO g_nmu.*
         IF cl_null(l_max_dat) AND cl_null(l_min_dat) THEN 
            LET l_max_dat = g_nmu.nmu01
            LET l_min_dat = g_nmu.nmu01 
         ELSE
         	  IF g_nmu.nmu01 < l_min_dat THEN 
         	     LET l_min_dat = g_nmu.nmu01
         	  END IF 
         	  IF g_nmu.nmu01 > l_max_dat THEN 
         	     LET l_max_dat = g_nmu.nmu01
         	  END IF 
         END IF 
         SELECT COUNT(*) INTO l_n FROM nmu_file 
          WHERE nmu01=g_nmu.nmu01 
            AND nmu17=sr.nmt09 
            AND nmu18=sr.nmt12
            AND nmu16=g_nmu.nmu16
            AND nmu03=sr.nma01
         IF l_n >0 THEN 
            CONTINUE FOREACH 
         ELSE 
            LET g_nmu.nmu03 = sr.nma01
            LET g_nmu.nmu04 = sr.nma39
            LET g_nmu.nmu05 = sr.nma04
            LET g_nmu.nmu08 = sr.nma10
            LET g_nmu.nmu17 = sr.nmt09
            LET g_nmu.nmu18 = sr.nmt12
            IF cl_null(g_nmu.nmu13) THEN LET g_nmu.nmu13 = ' ' END IF  #No.FUN-870067
 
            #FUN-980005 add legal 
            LET g_nmu.nmulegal= g_legal
            #FUN-980005 end legal 

#FUN-B30166--add--str
            LET l_date1 = g_today
            LET l_year = YEAR(l_date1)USING '&&&&'
            LET l_month = MONTH(l_date1) USING '&&'
            LET l_day = DAY(l_date1) USING  '&&'
            LET l_time = TIME(CURRENT)
            LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                         l_time[1,2],l_time[4,5],l_time[7,8]
            SELECT MAX(nmu23) + 1 INTO g_nmu.nmu23 FROM nmu_file
             WHERE nmu23[1,14] = l_dt
            IF cl_null(g_nmu.nmu23) THEN
               LET g_nmu.nmu23 = l_dt,'000001'
            END if
#FUN-B30166--add--end

            INSERT INTO nmu_file VALUES(g_nmu.*)
         END IF 
      END FOREACH      
    END FOREACH 
    #IF tm.bgjob <> 'Y' THEN 
       SELECT COUNT(*) INTO l_n FROM nmr_file 
        WHERE nmr01 = sr.nma01
       IF l_n = 0 THEN 
          INSERT INTO nmr_file VALUES(sr.nma01,l_min_dat,l_max_dat,g_legal) #FUN-980005 add legal 
          IF SQLCA.sqlcode THEN 
             CALL cl_err('insert nmr_file',SQLCA.sqlcode,1)
             LET g_success = 'N'
             RETURN 
          END IF 
       ELSE
       	 CASE 
       	   WHEN l_max_dat < tm.a_b_date  
       	     UPDATE nmr_file SET nmr02 = l_min_dat, 
       	                         nmr03 = l_max_dat
       	      WHERE nmr01 = tm.a
       	     IF SQLCA.sqlcode THEN 
       	        CALL cl_err('',SQLCA.sqlcode,1)
       	        LET g_success ='N'
       	        RETURN 
       	     END IF  
       	   WHEN l_min_dat < tm.a_b_date AND l_max_dat>= tm.a_b_date AND l_max_dat <=tm.a_e_date
       	     UPDATE nmr_file SET nmr02 = l_min_dat
       	      WHERE nmr01 = tm.a
       	     IF SQLCA.sqlcode THEN 
       	        CALL cl_err('',SQLCA.sqlcode,1)
       	        LET g_success = 'N'
       	        RETURN 
       	     END IF 
       	   WHEN l_max_dat > tm.a_e_date AND l_min_dat>= tm.a_b_date AND l_min_dat <=tm.a_e_date
       	     UPDATE nmr_file SET nmr03 = l_max_dat
       	      WHERE nmr01 = tm.a
       	     IF SQLCA.sqlcode THEN 
       	        CALL cl_err('',SQLCA.sqlcode,1)
       	        LET g_success = 'N'
       	        RETURN 
       	     END IF 
       	   WHEN l_max_dat > tm.a_e_date AND l_min_dat < tm.a_b_date 
       	     UPDATE nmr_file SET nmr02 = l_min_dat,
       	                         nmr03 = l_max_dat
       	      WHERE nmr01 = tm.a
       	     IF SQLCA.sqlcode THEN  
       	        CALL cl_err('',SQLCA.sqlcode,1)
       	        LET g_success = 'N'
       	        RETURN 
       	     END IF 
       	   OTHERWISE EXIT CASE 
       	 END CASE 
       END IF   
    #END IF 
    IF g_success = 'N' THEN 
       CALL cl_rbmsg(1)
       ROLLBACK WORK
       RETURN
    ELSE
       COMMIT WORK 
    END IF 
 
END FUNCTION 
 
#網銀接口返回字符串拆解
FUNCTION p301_s(param_str,param_delim,p_cmd)
DEFINE param_str      STRING      #分析字符串
DEFINE param_delim    STRING      #分隔符
DEFINE param_array    DYNAMIC ARRAY OF STRING
DEFINE l_tok_param    base.StringTokenizer
DEFINE l_cnt_param    LIKE type_file.num5
DEFINE i              LIKE type_file.num5
DEFINE j              LIKE type_file.num5
DEFINE k              LIKE type_file.num5
DEFINE param_step     LIKE type_file.chr1
DEFINE data_str       STRING
DEFINE data_delim     LIKE type_file.chr2
DEFINE data_array     DYNAMIC ARRAY OF STRING
DEFINE l_tok_data     base.StringTokenizer
DEFINE l_cnt_data     LIKE type_file.num5
DEFINE field_str      STRING
DEFINE field_array    DYNAMIC ARRAY OF STRING
DEFINE l_tok_field    base.StringTokenizer 
DEFINE l_cnt_field    LIKE type_file.num5
DEFINE l_str          STRING
DEFINE l_tok_str      base.StringTokenizer 
DEFINE l_cnt_str      LIKE type_file.num5
DEFINE str_array      DYNAMIC ARRAY OF STRING
DEFINE l_success      LIKE type_file.chr1
DEFINE sr             RECORD LIKE nmu_file.*
DEFINE p_cmd          LIKE type_file.chr1
 
    LET l_success ='Y'
    #先判斷是否成功，若不成功則報錯。
    LET param_delim = param_delim.trimRight()
    LET l_tok_param = base.StringTokenizer.create(param_str,param_delim)
    LET l_cnt_param = l_tok_param.countTokens()
    IF l_cnt_param >0 THEN 
       CALL param_array.clear()
       LET i = 0 
       WHILE l_tok_param.hasMoreTokens()
           LET i=i+1
           LET param_array[i] =l_tok_param.nextToken()
       END WHILE 
    END IF 
    IF param_array[1] != '0' THEN #若不等于零則報錯
       CALL cl_err(param_array[2],'3228',1)
       LET l_success ='N'
       RETURN l_success
    END IF 
    #剝出記錄
    IF param_array[1] = '0' THEN  #若為零，則開始拆解。
      # LET date_delim = "\r\n"
      # LET date_delim = date_delim.trimRight 
       LET data_str = param_array[2]
       LET l_tok_data = base.StringTokenizer.create(data_str,"\r\n")
       LET l_cnt_data = l_tok_data.countTokens()
       IF l_cnt_data > 0 THEN 
          CALL data_array.clear()
          LET j=0
          WHILE l_tok_data.hasMoreTokens()
             LET j = j+1
             LET data_array[j]=l_tok_data.nextToken()     
          END WHILE
          #剝出字段
          FOR j=1 TO l_cnt_data
              INITIALIZE sr.* LIKE nmu_file.*
              LET field_str = data_array[j]
              LET l_tok_field = base.StringTokenizer.create(field_str," ;")
              LET l_cnt_field = l_tok_field.countTokens()
              IF l_cnt_field >0 THEN 
                 CALL field_array.clear()
                 LET k=0
                 WHILE l_tok_field.hasMoreTokens()
                    LET k=k+1
                    LET field_array[k]=l_tok_field.nextToken()   
                 END WHILE 
              END IF 
              #分析字段
              FOR k = 1 TO l_cnt_field
                  LET l_str = field_array[k]
                  LET l_tok_str = base.StringTokenizer.create(l_str,"=")
                  LET l_cnt_str = l_tok_str.countTokens()
                  IF l_cnt_str > 0 THEN 
                     CALL str_array.clear()
                     LET i = 0
                     WHILE l_tok_str.hasMoreTokens()
                        LET i = i+1
                        LET str_array[i] = l_tok_str.nextToken()
                     END WHILE 
                     IF p_cmd = 'c' THEN 
                        CASE str_array[1]
                          WHEN "ETYDAT"
                            LET sr.nmu01 = str_array[2]
                          WHEN "ETYTIM"
                            LET sr.nmu02 = str_array[2]                       
                          WHEN "RPYACC"
                            LET sr.nmu06 = str_array[2]
                          WHEN "GSBACC"
                            LET sr.nmu07 = str_array[2]
                          WHEN "TRSAMTD"
                            IF str_array[2] >0 THEN 
                               LET sr.nmu09 = -1
                               LET sr.nmu10 = str_array[2]
                            END IF 
                          WHEN "TRSAMTC"
                            IF str_array[2] > 0 THEN 
                               LET sr.nmu09 = 1 
                               LET sr.nmu10 = str_array[2] 
                            END IF 
                          WHEN "TRSBLV"
                            LET sr.nmu11 = str_array[2]
                          WHEN "BUSNAR"
                            LET sr.nmu12 = str_array[2]
                          WHEN "NARYUR"
                            LET sr.nmu13 = str_array[2]
                          WHEN "YURREF"
                            LET sr.nmu14 = str_array[2]
                          WHEN "TRSCOD"
                            LET sr.nmu15 = str_array[2]
                          WHEN "REFNBR"
                            LET sr.nmu16 = str_array[2]
                          WHEN "RPYNAM"
                            LET sr.nmu19 = str_array[2]
                          WHEN "RPYBNK"
                            LET sr.nmu20 = str_array[2]
                          WHEN "GSBNAM"
                            LET sr.nmu21 = str_array[2]
                          WHEN "INFFLG"
                            LET sr.nmu22 = str_array[2]
                          OTHERWISE EXIT CASE 
                        END CASE
                     END IF 
                     IF p_cmd = 'd' THEN 
                        CASE str_array[1]
                          WHEN 'OPNDAT'
                            LET g_b_date = str_array[2]
                        END CASE 
                     END IF  
                  END IF  
              END FOR 
              IF p_cmd = 'c' THEN 
                 INSERT INTO nmu_temp VALUES(sr.*)
                 IF SQLCA.sqlcode THEN 
                    CALL cl_err('insert into temptable:',SQLCA.sqlcode,1)
                    LET l_success = 'N'
                    RETURN l_success
                 END IF 
              END IF 
          END FOR  
       END IF 
    END IF 
    
    RETURN l_success
       
END FUNCTION 
 
FUNCTION p301_nma01(p_cmd)
DEFINE p_cmd       LIKE type_file.chr1
DEFINE l_nma43     LIKE nma_file.nma43
DEFINE l_nma02     LIKE nma_file.nma02
DEFINE l_nmaacti   LIKE nma_file.nmaacti
DEFINE l_nmr02     LIKE nmr_file.nmr02
DEFINE l_nmr03     LIKE nmr_file.nmr03
DEFINE #l_sql       LIKE type_file.chr1000
       l_sql       STRING      #NO.FUN-910082 
 
    LET l_sql = ''
    LET g_errno = ''
    
    LET l_sql = "SELECT nma02,nma39,nma43,nmaacti,nmr02,nmr03 ",
               #"  FROM nma_file,nmr_file ",
                "  FROM nma_file LEFT OUTER JOIN nmr_file ON nma01 = nmr01",  #No.TQC-780056
               #" WHERE nma01=? AND nma01=nmr01(+) "
                " WHERE nma01=? "  #No.TQC-780056
    PREPARE p301_prep_nma01 FROM l_sql
    DECLARE p301_cs_nma01 CURSOR FOR p301_prep_nma01
    OPEN p301_cs_nma01 USING tm.a
    FETCH p301_cs_nma01 INTO l_nma02,l_nma39,l_nma43,l_nmaacti,l_nmr02,l_nmr03
    CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'aap-007'
                             LET l_nma02 = ''
                             LET l_nmr02 = ''
                             LET l_nmr03 = ''
#      WHEN l_nma43  != 'Y'   LET g_errno = 'gpy-041'    #CHI-B40058
      WHEN l_nma43  != 'Y'   LET g_errno = 'anm-159'     #CHI-B40058 
      WHEN l_nmaacti = 'N'   LET g_errno = 'mfg0301'
      OTHERWISE 
           LET g_errno = SQLCA.sqlcode USING '-----'
    END CASE  
    
    LET tm.b        = l_nma02
    LET tm.a_b_date = l_nmr02
    LET tm.a_e_date = l_nmr03
    DISPLAY l_nma02 TO FORMONLY.b
    DISPLAY l_nmr02 TO FORMONLY.a_b_date
    DISPLAY l_nmr03 TO FORMONLY.a_e_date
 
    CLOSE p301_cs_nma01
 
END FUNCTION 
 
FUNCTION p301_b_date()  #背景作業下，對起始日期有作用。
DEFINE l_result      STRING
DEFINE p_b_date      LIKE type_file.dat
DEFINE l_nma04       LIKE nma_file.nma04
DEFINE l_nmt09       LIKE nmt_file.nmt09
DEFINE l_nmt12       LIKE nmt_file.nmt12
DEFINE l_p           LIKE type_file.chr1000
DEFINE l_success     LIKE type_file.chr1
DEFINE l_p1          STRING 
 
    LET p_b_date = tm.b_date
    SELECT nma04,nmt09,nmt12 INTO l_nma04,l_nmt09,l_nmt12 FROM nmt_file,nma_file 
     WHERE nmt01 = nma39 AND nma01=tm.a
    IF SQLCA.sqlcode THEN 
       RETURN p_b_date
    END IF 
    IF l_nmt12 = g_aza.aza74 THEN 
       LET l_p = l_nma04,"|",l_nmt09 CLIPPED 
       CALL p301_logon() RETURNING l_p1
       CALL cl_cmbinf(l_p1,"GetAccInfoA",l_p,"|") RETURNING l_result
       LET g_b_date = NULL
       CALL p301_s(l_result,"|",'d') RETURNING l_success
       IF l_success = 'Y' AND NOT cl_null(g_b_date) THEN 
          LET p_b_date = g_b_date
       END IF  
    END IF 
    
    RETURN p_b_date
 
END FUNCTION 
 
#若為背景作業，怎會進入此函數開始運行
FUNCTION p301_bg(p_nma01,p_b_date,p_e_date,p_bgjob)
DEFINE   l_nmr       RECORD LIKE nmr_file.*
DEFINE   p_nma01     LIKE nma_file.nma01
DEFINE   p_b_date    LIKE type_file.dat
DEFINE   p_e_date    LIKE type_file.dat
DEFINE   p_bgjob     LIKE type_file.chr1
DEFINE   l_p1        STRING                  #用于接收登錄信息
 
    LET tm.a        = p_nma01
    LET tm.b_date   = p_b_date
    LET tm.e_date   = p_e_date
    LET tm.bgjob    = p_bgjob
    LET tm.a_b_date = NULL
    LET tm.a_e_date = NULL
 
    IF tm.bgjob = 'Y' THEN 
       SELECT * INTO l_nmr.* FROM nmr_file 
        WHERE nmr01 = tm.a
       CASE SQLCA.sqlcode 
         WHEN 100
           CALL p301_b_date() RETURNING tm.b_date
           LET tm.e_date = g_today
         WHEN 0
           LET tm.b_date = l_nmr.nmr03+1
           LET tm.e_date = g_today
         OTHERWISE 
           CALL cl_err('sel nmr_file',SQLCA.sqlcode,1)
           LET g_success = 'N'
           RETURN g_success
       END CASE 
    END IF
    SELECT nmr02,nmr03 INTO tm.a_b_date,tm.a_e_date FROM nmr_file
     WHERE nmr01=tm.a
    IF SQLCA.sqlcode = 100 THEN 
       LET tm.a_b_date = NULL
       LET tm.a_e_date = NULL
    END IF 
    CALL p301_logon() RETURNING l_p1
    CALL p301(l_p1)
    RETURN g_success
    
 
END FUNCTION 
 
#原網絡銀行登錄及登出函數。
#現在功能為組登錄相關資料。
FUNCTION p301_logon()
DEFINE l_success     LIKE type_file.chr1
DEFINE l_result      LIKE type_file.chr1
DEFINE l_nmv03       LIKE nmv_file.nmv03
DEFINE l_nmv04       LIKE nmv_file.nmv04
DEFINE l_p1          LIKE type_file.chr1000
 
    IF cl_null(g_aza.aza74) THEN 
       CALL cl_err('','anm-702',1)
       LET g_success ='N'
       RETURN 
    ELSE
      CALL nmv01()                  #對nmv_file.nmv01必須要做判斷。
      IF NOT cl_null(g_errno) THEN 
         CALL cl_err('',g_errno,1)
         LET g_success = 'N'
         LET l_p1 = NULL
         RETURN l_p1
      END IF 
      LET l_p1= "LGNTYP=0 ;LGNNAM=",g_nmv.nmv03 CLIPPED," ;LGNPWD=",g_nmv.nmv04 CLIPPED," ;ICCPWD=",g_nmv.nmv07
 
      RETURN l_p1
    # CALL p301(l_p1)
 
     #原網絡段登錄已集成到接口，此處不再需要執行登錄和登出功能。
     #CALL cl_cmbinf("Login",l_p,"|") RETURNING l_result
     ##若返回值第一碼為'0'，則登錄成果，其他值皆為登錄失敗，則退出程序。
     #IF l_result = '0' THEN 
     #   CALL p301()
     #   #程序執行完后，無論結果為何，都必須等出網銀系統。
     #   CALL cl_cmbinf("Logout","","") RETURNING l_result
     #ELSE 
     #	 LET g_success = 'N'
     #	 CALL cl_err('','anm-704',1)
     #	 RETURN 
     #END IF 
    END IF 
END FUNCTION
 
#此函數目的是判斷nmv_file中是否有值且網絡銀行接口代碼是否一致。
FUNCTION nmv01() 
DEFINE #l_sql           LIKE type_file.chr1000
       l_sql           STRING      #NO.FUN-910082  
 
    LET l_sql = ''
    LET g_errno = ''
    INITIALIZE g_nmv.* TO NULL 
    LET l_sql="SELECT * FROM nmv_file ",
              " WHERE nmv01='",g_aza.aza74 CLIPPED,"'",
              "   AND nmv06='",g_user CLIPPED,"'",
              "   AND nmv08= 'ALL' "
    PREPARE p301_pre_nmv01  FROM l_sql
    DECLARE p301_cs_nmv01   CURSOR FOR p301_pre_nmv01
    OPEN p301_cs_nmv01
    FETCH p301_cs_nmv01 INTO g_nmv.*
    CASE 
      WHEN (SQLCA.sqlcode=100 OR cl_null(g_nmv.nmv01))  LET g_errno = "anm-703"
      OTHERWISE LET g_errno = SQLCA.sqlcode USING '-----'
    END CASE 
    CLOSE p301_cs_nmv01
END FUNCTION 
