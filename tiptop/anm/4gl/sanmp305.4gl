# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: sanmp305.4gl
# Date & Author..: No.FUN-B30213 11/06/30 By lixia 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm     RECORD 
              wc       STRING,      
              nma01    LIKE nma_file.nma01,
              nma02    LIKE nma_file.nma02, 
              noa05    LIKE noa_file.noa05,              
              azf03    LIKE azf_file.azf03,
              noa02    LIKE noa_file.noa02, 
              noa03    LIKE noa_file.noa03,
              nma04    LIKE nma_file.nma04,             
              nmu23    LIKE nmu_file.nmu23,
              a_b_date LIKE type_file.dat,
              a_e_date LIKE type_file.dat,
              b_date   LIKE type_file.dat,
              e_date   LIKE type_file.dat,
              bgjob    LIKE type_file.chr1
              END RECORD 
DEFINE g_msg1,g_msg2,g_msg3,g_msg4 LIKE ze_file.ze03
DEFINE g_nmu           RECORD LIKE nmu_file.*
DEFINE g_success       LIKE type_file.chr1
DEFINE g_flag          LIKE type_file.chr1
DEFINE g_b_date        LIKE type_file.dat
DEFINE l_nma39         LIKE nma_file.nma39 
DEFINE g_xh            LIKE type_file.num5
DEFINE g_sql           STRING          
 
FUNCTION p305_tm(p_nma01,p_nma04,p_noa05,p_noa02,p_nmu23)
    DEFINE    p_row,p_col   LIKE type_file.num5
    DEFINE    l_cmd         LIKE type_file.chr1000
    DEFINE    l_nma43       LIKE nma_file.nma43
    DEFINE    l_nma47       LIKE nma_file.nma47
    DEFINE    l_nmt12       LIKE nmt_file.nmt12       
    DEFINE    l_nmaacti     LIKE nma_file.nmaacti
    DEFINE    l_nmr         RECORD LIKE nmr_file.*
    DEFINE    p_nma01       LIKE nma_file.nma01
    DEFINE    p_nma04       LIKE nma_file.nma04
    DEFINE    p_noa05       LIKE noa_file.noa05
    DEFINE    p_noa02       LIKE noa_file.noa02
    DEFINE    p_nmu23       LIKE nmu_file.nmu23
    DEFINE    l_azf03       LIKE azf_file.azf03
    DEFINE    l_n,l_n1,l_n2           LIKE type_file.num5
  
    OPEN WINDOW anmp305_w WITH FORM "anm/42f/anmp305"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
    WHENEVER ERROR CALL cl_err_msg_log 
    
    CALL cl_opmsg('p')
    INITIALIZE tm.* TO NULL
    LET tm.nma01  = p_nma01
    LET tm.nma04  = p_nma04 
    LET tm.noa05  = p_noa05 
    LET tm.noa02  = p_noa02  
    LET tm.nmu23  = p_nmu23
    LET tm.b_date = g_today
    LET tm.e_date = g_today
    LET tm.bgjob  = 'N'
    
    WHILE TRUE       
      INPUT BY NAME tm.nma01,tm.nma04,tm.noa05,tm.noa02,tm.nmu23,tm.b_date,tm.e_date,tm.bgjob WITHOUT DEFAULTS      
         AFTER FIELD nma01 
           IF NOT cl_null(tm.nma01) THEN 
              CALL p305_nma01('d')
              IF NOT cl_null(g_errno) THEN 
                 CALL cl_err(tm.nma01,g_errno,1)
                 LET tm.nma01 = ''
                 DISPLAY BY NAME tm.nma01 
                 NEXT FIELD nma01
              ELSE
                 SELECT nma04,nma47 INTO tm.nma04,l_nma47 FROM nma_file WHERE nma01 = tm.nma01  
                 DISPLAY BY NAME tm.nma04                
              END IF
           END IF

         AFTER FIELD noa05
            IF NOT cl_null(tm.noa05) THEN
               LET l_n = 0
               SELECT COUNT(*) INTO l_n FROM noa_file 
                WHERE noa05 = tm.noa05 AND noa04 = '2' AND noa14 = '1'
               IF l_n > 0 THEN 
                  SELECT azf03 INTO tm.azf03 FROM azf_file WHERE azf01 = tm.noa05 AND azf02 = 'T'
                  IF cl_null(tm.noa02) THEN
                     SELECT noa02,noa03 INTO tm.noa02,tm.noa03 FROM noa_file 
                      WHERE noa01 = l_nma47 AND noa05 = tm.noa05 AND noa13 = 'Y' AND noa04 = '2' AND noa14 = '1'
                     DISPLAY BY NAME tm.noa02,tm.noa03
                  END IF    
                  DISPLAY BY NAME tm.azf03
               ELSE
                  CALL cl_err(tm.noa05,'anm1034',0)
                  NEXT FIELD noa05
               END IF   
            END IF 

         AFTER FIELD noa02
            IF NOT cl_null(tm.noa02) THEN
               LET l_n = 0
               SELECT COUNT(*) INTO l_n FROM noa_file 
                WHERE noa05 = tm.noa05 AND noa04 = '2' AND noa01 = l_nma47 AND noa14 = '1' AND noa02 = tm.noa02
               IF l_n < 1 THEN              
                  CALL cl_err(tm.noa02,'adm-002',0)
                  NEXT FIELD noa02
               ELSE
                  SELECT noa03 INTO tm.noa03 FROM noa_file 
                   WHERE noa01 = l_nma47 AND noa05 = tm.noa05 AND noa04 = '2' AND noa14 = '1' AND noa02 = tm.noa02     
                  DISPLAY BY NAME tm.noa03
               END IF   
            END IF     

          AFTER FIELD nmu23
            IF NOT cl_null(tm.nmu23) THEN
               LET l_n = 0  LET l_n1=0     LET l_n2=0
               SELECT COUNT(*) INTO l_n1 FROM nmu_file 
                WHERE nmu03 = tm.nma01 AND nmu23 = tm.nmu23
               SELECT COUNT(*) INTO l_n2 FROM nme_file 
                WHERE nme01 = tm.nma01 AND nme27 = tm.nmu23
               LET l_n=l_n1+l_n2
               IF l_n <= 0 THEN
                  CALL cl_err(tm.nmu23,'mfg9329',0)
                  NEXT FIELD nmu23
               END IF   
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
               WHEN INFIELD(nma01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_nma7'
                  LET g_qryparam.default1 = tm.nma01
                  CALL cl_create_qry() RETURNING tm.nma01
                  DISPLAY BY NAME tm.nma01
                  NEXT FIELD nma01

               WHEN INFIELD(noa05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_noa05"
                  LET g_qryparam.default1= tm.noa05
                  LET g_qryparam.arg1 = l_nma47
                  LET g_qryparam.arg2 = '1'
                  CALL cl_create_qry() RETURNING tm.noa05
                  DISPLAY BY NAME tm.noa05
                  NEXT FIELD noa05 

               WHEN INFIELD(noa02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_noa02"
                  LET g_qryparam.default1= tm.noa02
                  LET g_qryparam.arg1 = tm.noa05
                  LET g_qryparam.arg2 = l_nma47
                  LET g_qryparam.arg3 = '1'
                  CALL cl_create_qry() RETURNING tm.noa02
                  NEXT FIELD noa02     
                  
               WHEN INFIELD(nmu23)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nmu23"
                  LET g_qryparam.arg1 = tm.nma01
                  LET g_qryparam.default1= tm.nmu23
                  CALL cl_create_qry() RETURNING tm.nmu23
                  DISPLAY BY NAME tm.nmu23
                  NEXT FIELD nmu23      
               OTHERWISE 
                  EXIT CASE 
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
          WHERE zz01='anmp305'
         IF STATUS OR l_cmd IS NULL THEN
             CALL cl_err('anmp305','9031',1)   
         ELSE
         	  SELECT * INTO l_nmr.* FROM nmr_file 
         	   WHERE nmr01 = tm.nma01
         	  CASE SQLCA.sqlcode 
         	    WHEN 100
         	      LET tm.e_date = g_today
         	    WHEN 0
         	      LET tm.b_date = l_nmr.nmr03+1
         	      LET tm.e_date = g_today
         	    OTHERWISE 
         	      CALL cl_err('sel nmr_file',SQLCA.sqlcode,1)
         	      EXIT WHILE 
         	  END CASE 
            LET l_cmd = l_cmd CLIPPED,		        #(at time fglgo xxxx p1 p2 p3)                            
                            " '",tm.nma01 CLIPPED,"'",
                            " '",tm.nma04 CLIPPED,"'",   
                            " '",tm.noa05 CLIPPED,"'",
                            " '",tm.noa02 CLIPPED,"'",
                            " '",tm.nmu23 CLIPPED,"'",
                            " '",tm.b_date CLIPPED,"'",
                            " '",tm.e_date CLIPPED,"'",
                            " '",tm.bgjob CLIPPED,"'"
            CALL cl_cmdat('anmp305',g_time,l_cmd)	# Execute cmd at later time
         END IF
         EXIT WHILE
      END IF
      CALL cl_wait()
      CALL p305()
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
    CLOSE WINDOW anmp305_w    
    RETURN tm.nma01
END FUNCTION 

FUNCTION p305_nma01(p_cmd)
   DEFINE p_cmd       LIKE type_file.chr1
   DEFINE l_nma43     LIKE nma_file.nma43
   DEFINE l_nma02     LIKE nma_file.nma02
   DEFINE l_nmaacti   LIKE nma_file.nmaacti
   DEFINE l_nmr02     LIKE nmr_file.nmr02
   DEFINE l_nmr03     LIKE nmr_file.nmr03
 
   LET g_errno = ''    
   SELECT nma02,nma39,nma43,nmaacti,nmr02,nmr03
     INTO l_nma02,l_nma39,l_nma43,l_nmaacti,l_nmr02,l_nmr03
     FROM nma_file LEFT OUTER JOIN nmr_file ON nma01 = nmr01
    WHERE nma01= tm.nma01   
   CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'aap-007'
                               LET l_nma02 = ''
                               LET l_nmr02 = ''
                               LET l_nmr03 = ''
      WHEN l_nma43  != 'Y'     LET g_errno = 'anm-159'    
      WHEN l_nmaacti = 'N'     LET g_errno = 'mfg0301'
      OTHERWISE                LET g_errno = SQLCA.sqlcode USING '-----'        
   END CASE  
    
    LET tm.nma02    = l_nma02
    LET tm.a_b_date = l_nmr02
    LET tm.a_e_date = l_nmr03
    DISPLAY l_nma02 TO FORMONLY.nma02
    DISPLAY l_nmr02 TO FORMONLY.a_b_date
    DISPLAY l_nmr03 TO FORMONLY.a_e_date  
END FUNCTION 
 
FUNCTION p305()
   DEFINE   l_sql    STRING      
   DEFINE   sr       RECORD 
            nma01    LIKE nma_file.nma01,
            nma04    LIKE nma_file.nma04,
            nma10    LIKE nma_file.nma10,
            nma39    LIKE nma_file.nma39,
            nma47    LIKE nma_file.nma47
                     END RECORD
   DEFINE sdkresult  STRING
   DEFINE l_n        LIKE type_file.num5
   DEFINE l_max_dat  LIKE type_file.dat
   DEFINE l_min_dat  LIKE type_file.dat 
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_time     LIKE type_file.chr20
   DEFINE l_nmu23    LIKE nmu_file.nmu23
   DEFINE l_str2     STRING
   DEFINE l_str3     STRING
   
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
        nmu22    LIKE nmu_file.nmu22,
        nmu23    LIKE nmu_file.nmu23,
        nmu24    LIKE nmu_file.nmu24,
        nmuud01  LIKE nmu_file.nmuud01,
        nmuud02  LIKE nmu_file.nmuud02,
        nmuud03  LIKE nmu_file.nmuud03,
        nmuud04  LIKE nmu_file.nmuud04,
        nmuud05  LIKE nmu_file.nmuud05,
        nmuud06  LIKE nmu_file.nmuud06,
        nmuud07  LIKE nmu_file.nmuud07,
        nmuud08  LIKE nmu_file.nmuud08,
        nmuud09  LIKE nmu_file.nmuud09,
        nmuud10  LIKE nmu_file.nmuud10,
        nmuud11  LIKE nmu_file.nmuud11,
        nmuud12  LIKE nmu_file.nmuud12,
        nmuud13  LIKE nmu_file.nmuud13,
        nmuud14  LIKE nmu_file.nmuud14,
        nmuud15  LIKE nmu_file.nmuud15,
        nmulegal LIKE nmu_file.nmulegal) 
    DELETE FROM nmu_temp      

    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmauser', 'nmagrup')   
     
    LET g_xh = 0 
    LET l_str2 = ''
    LET l_str3 = ''  
    LET l_max_dat = NULL
    LET l_min_dat = NULL
    LET l_sql = "SELECT nma01,nma04,nma10,nma39,nma47 FROM nma_file",
                " WHERE nma01 = '",tm.nma01,"'"
    IF NOT cl_null(tm.wc) THEN 
       LET l_sql = l_sql ,tm.wc
    END IF 
    PREPARE p305_prep FROM l_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('p305_prep',SQLCA.sqlcode,1) 
       LET g_success = 'N'
       RETURN 
    END IF             
    DECLARE p305_cs CURSOR FOR p305_prep
    IF SQLCA.sqlcode THEN 
       CALL cl_err('p305_cs',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN 
    END IF 
   
    LET g_success = 'Y'
    CALL s_showmsg_init()      
    FOREACH p305_cs INTO sr.*
      IF cl_null(sr.nma47) THEN
         CALL s_errmsg('nma01',tm.nma01,'','anm1019',1)
         LET g_success = 'N'
         EXIT FOREACH 
      END IF
      
      #抓取公共配置信息
      CALL p305_getstr(sr.nma47,tm.noa02,'3',tm.noa05,'') RETURNING l_str3
      IF g_success = 'N' OR cl_null(l_str3) THEN 
         CALL s_errmsg('nma01',tm.nma01,'noa04=3','anm1040',1)
         LET g_success = 'N'
         EXIT FOREACH 
      ELSE
         DISPLAY l_str3    
      END IF 

      #抓取傳輸規則
      CALL p305_getxml(sr.nma47,tm.noa02,tm.noa05) RETURNING l_str2
      IF g_success = 'N' OR cl_null(l_str2) THEN 
         CALL s_errmsg('nma01',tm.nma01,'noa04=2','anm1039',1)
         LET g_success = 'N'
         EXIT FOREACH  
      ELSE
         DISPLAY l_str2
      END IF 
      
      #調用網銀接口函數
      #CALL xxx()  RETURNING  sdkresult 
    {  LET sdkresult = "<?xml version='1.0' encoding='GBK' ?> <ap>
<head>   
   <tr_code>07</tr_code>
   <corp_no>0000002234</corp_no>
</head>
<body>
   <rcv_bank_name></rcv_bank_name>
   <pay_acno></pay_acno>
   <cur_code>CNY</cur_code>
   <amt>500.000000</amt>
   <sercode>a|b|c|d|07|06|05|04|</sercode>
</body>
</ap>"  }   #zmtest
     #  LET sdkresult = "<ap>
     #        <head>
     #          <tr_code>310201</tr_code>
     #          <corp_no>0000002234</corp_no>
     #          <req_no>00010239</req_no>
     #          <serial_no>00010239</serial_no>   
     #          <ans_no>00010239</ans_no>
     #          <next_no>00006</next_no>
     #          <tr_acdt>20110712</tr_acdt>
     #          <tr_time>100008</tr_time>
     #          <ans_code>1</ans_code>
     #          <ans_info></ans_info>
     #          <particular_code>1</particular_code>
     #          <particular_info>1</particular_info>
     #          <atom_tr_count>1</atom_tr_count>
     #          <reserved></reserved>
     #        </head>
     #        <body>
     #      <serial_record>状态|交易日期|交易时间|业务类型|流水号|流水序号|账号|户名|收支标志|币种|交易金额|余额|可用余额|对方账号|对方户名|对方地址|对方开户行行号|对方开户行行名|票据种类|票据号码|票据名称|票据签发日期|附言|备注|0|20110718|111118|310201|88888|12345689|001| 张三|1|RM|666.6|1000|1000|0033|李刚|共和新路4666号|210210|工商银行娄山关路支行|||||转帐|转帐汇款|</serial_record>                                     
     #                   <fiel#d_num>25</field_num>
     #                   <record_num>1</record_num>
     #                   <file_flag>1</file_flag>
     #                   <filename></filename>
     #        </body>
     #      </ap>
     #        "   
{    #  LET sdkresult = "<ap>
     #        <head>
     #          <tr_code>310204</tr_code>
     #          <corp_no>0000002234</corp_no>
     #          <req_no>00010239</req_no>
     #          <serial_no>00010239</serial_no>   
     #          <ans_no>00010239</ans_no>
     #          <next_no>00006</next_no>
     #          <tr_acdt>20110712</tr_acdt>
     #          <tr_time>140000</tr_time>
     #          <ans_code>1</ans_code>
     #          <ans_info></ans_info>
     #          <particular_code>1</particular_code>
     #          <particular_info>1</particular_info>
     #          <atom_tr_count>1</atom_tr_count>
     #          <reserved></reserved>
     #        </head>
     #        <body>
     #           <ogl_serial_no> 20110713888888</ogl_serial_no>                                    
     #           <stat>1</stat>
     #           <err_msg>success</err_msg>
     #           <pay_acno>111111111</pay_acno>
     #           <pay_bank_no >123</pay_bank_no>
     #           <rcv_acno>22222222</rcv_acno>
     #           <rcv_bank_no>987</rcv_bank_no>
     #           <amt>333.33</amt>
     #           <cert_no>ABC</cert_no>
     #        </body>
     #      </ap>" }
 

      #拆解信息     
      CALL p305_s(sdkresult,sr.nma47,'c')
      IF g_success = 'N' THEN 
         LET g_success = 'N'
         EXIT FOREACH 
      END IF 

      BEGIN WORK
      DECLARE p305_cs_t CURSOR FOR SELECT * FROM nmu_temp
      FOREACH p305_cs_t INTO g_nmu.*
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
          WHERE nmu01 = g_nmu.nmu01
            AND nmu16 = g_nmu.nmu16
            AND nmu03 = sr.nma01
         IF l_n >0 THEN 
            CONTINUE FOREACH 
         ELSE 
            LET g_nmu.nmu03 = sr.nma01
            LET g_nmu.nmu04 = sr.nma39
            LET g_nmu.nmu05 = sr.nma04
            LET g_nmu.nmu08 = sr.nma10           
            IF cl_null(g_nmu.nmu13) THEN 
               LET g_nmu.nmu13 = ' ' 
            END IF
            IF cl_null(g_nmu.nmu17) THEN 
               LET g_nmu.nmu17 = ' ' 
            END IF
            SELECT nma47 INTO g_nmu.nmu18 FROM nma_file WHERE nma01=g_nmu.nmu03   #Add by zm FUN-B30213
            IF cl_null(g_nmu.nmu18) THEN 
               LET g_nmu.nmu18 = ' ' 
            END IF   
            LET g_nmu.nmulegal= g_legal
            IF cl_null(g_nmu.nmu23) THEN
               LET l_date1 = g_today
               LET l_year = YEAR(l_date1)USING '&&&&'
               LET l_month = MONTH(l_date1) USING '&&'
               LET l_day = DAY(l_date1) USING  '&&'
               LET l_time = TIME(CURRENT)
               LET l_dt = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                          l_time[1,2],l_time[4,5],l_time[7,8]
               SELECT MAX(nmu23) + 1 INTO g_nmu.nmu23 FROM nmu_file
                WHERE nmu23[1,14] = l_dt
               IF cl_null(g_nmu.nmu23) THEN
                  LET g_nmu.nmu23 = l_dt,'000001'
               END IF
            END IF 
            INSERT INTO nmu_file VALUES(g_nmu.*)
            IF SQLCA.sqlcode THEN 
               CALL s_errmsg('insert nmu_file','','',SQLCA.sqlcode,1)
               LET g_success = 'N'
               EXIT FOREACH 
            END IF 
         END IF 
      END FOREACH      
    END FOREACH 
    IF g_success = 'Y' THEN 
       SELECT COUNT(*) INTO l_n FROM nmr_file 
       WHERE nmr01 = sr.nma01
       IF l_n = 0 THEN 
          INSERT INTO nmr_file VALUES(sr.nma01,l_min_dat,l_max_dat,g_legal) 
          IF SQLCA.sqlcode THEN 
             CALL s_errmsg('ins nmr_file','','',SQLCA.sqlcode,1)
             LET g_success = 'N'
          END IF 
       ELSE
          CASE 
             WHEN l_max_dat < tm.a_b_date  
                UPDATE nmr_file SET nmr02 = l_min_dat, 
       	                            nmr03 = l_max_dat
       	         WHERE nmr01 = tm.nma01
       	        IF SQLCA.sqlcode THEN 
       	           CALL s_errmsg('upd nmr_file','','',SQLCA.sqlcode,1)
                   LET g_success = 'N'
       	        END IF 
             
       	     WHEN l_min_dat < tm.a_b_date AND l_max_dat>= tm.a_b_date AND l_max_dat <=tm.a_e_date
       	        UPDATE nmr_file SET nmr02 = l_min_dat
       	         WHERE nmr01 = tm.nma01
       	        IF SQLCA.sqlcode THEN 
          	       CALL s_errmsg('upd nmr_file','','',SQLCA.sqlcode,1)
                   LET g_success = 'N'
         	    END IF 
             
       	     WHEN l_max_dat > tm.a_e_date AND l_min_dat>= tm.a_b_date AND l_min_dat <=tm.a_e_date
       	        UPDATE nmr_file SET nmr03 = l_max_dat
       	         WHERE nmr01 = tm.nma01
       	        IF SQLCA.sqlcode THEN 
       	           CALL s_errmsg('upd nmr_file','','',SQLCA.sqlcode,1)
                   LET g_success = 'N'
       	        END IF 
             
             WHEN l_max_dat > tm.a_e_date AND l_min_dat < tm.a_b_date 
       	        UPDATE nmr_file SET nmr02 = l_min_dat,
       	                            nmr03 = l_max_dat
       	         WHERE nmr01 = tm.nma01
       	        IF SQLCA.sqlcode THEN  
       	           CALL s_errmsg('upd nmr_file','','',SQLCA.sqlcode,1)
                   LET g_success = 'N'
       	        END IF 
             OTHERWISE EXIT CASE 
          END CASE 
       END IF 
    END IF 
    IF g_success = 'N' THEN
       CALL s_showmsg() 
       ROLLBACK WORK
       RETURN
    ELSE
       COMMIT WORK 
    END IF  
    
END FUNCTION 
 
#網銀接口返回字符串拆解
FUNCTION p305_s(param_str,p_nma47,p_cmd)
   DEFINE param_str      STRING              #分析字符串
   DEFINE p_nma47        LIKE nma_file.nma47 #銀行接口編碼 
   DEFINE p_cmd          LIKE type_file.chr1 
   DEFINE l_channel      base.Channel 
   DEFINE l_noa          RECORD LIKE noa_file.*
   DEFINE l_file         STRING
   DEFINE l_cmd          LIKE type_file.chr1000
   
   INITIALIZE l_noa.* TO NULL   
   
   SELECT noa_file.* INTO l_noa.* FROM noa_file,nma_file
    WHERE noa01 = p_nma47  AND nma01 = tm.nma01
      AND nmaacti  = 'Y'   AND noa04 = '2'
      AND noa05 = tm.noa05 AND noa02 = tm.noa02
      AND noa14='2' 
   IF cl_null(l_noa.noa01) THEN
      CALL s_errmsg('noa01',p_nma47,'2','anm1024',1)
      LET g_success = 'N'
      RETURN 
   END IF   
   IF l_noa.noa06 = '1' THEN   #XML
      LET l_file = "/tmp/11.xml" 
      LET l_channel = base.Channel.create()
      CALL l_channel.openFile(l_file,"a" )
      CALL l_channel.setDelimiter("")
      CALL l_channel.write(param_str) 
      CALL p305_fromXml(l_file,l_noa.*)
      CALL l_channel.close()
      LET l_cmd = "rm ",l_file
      RUN l_cmd 
   ELSE
      CALL p305_fromStr(param_str,l_noa.*)
   END IF
END FUNCTION  

#根據anmi012和anmi013中單身的內容組合成srting
FUNCTION p305_getstr(p_noa01,p_noa02,p_noa04,p_noa05,p_nob13)   
   DEFINE p_noa01  LIKE noa_file.noa01  #銀行接口編碼
   DEFINE p_noa02  LIKE noa_file.noa02  #版本編號
   DEFINE p_noa04  LIKE noa_file.noa04  #資料類型 2：anmi012 3：anmi013
   DEFINE p_noa05  LIKE noa_file.noa05  #交易類型   
   DEFINE p_nob13  LIKE nob_file.nob13  #類別
   DEFINE l_noa06  LIKE noa_file.noa06  #傳輸規則  
   DEFINE l_noa07  LIKE noa_file.noa07
   DEFINE l_nob06  LIKE nob_file.nob06
   DEFINE l_nob    RECORD LIKE nob_file.* 
   DEFINE l_nob1   RECORD LIKE nob_file.* 
   DEFINE l_value  LIKE nob_file.nob09
   DEFINE l_value1 LIKE nob_file.nob09
   DEFINE l_value2 LIKE nob_file.nob09
   DEFINE l_str    STRING
   DEFINE l_sql    STRING
   
   INITIALIZE l_nob.* TO NULL
   INITIALIZE l_nob1.* TO NULL
   LET l_sql = "SELECT nob_file.*,noa06,noa07 FROM noa_file,nob_file ",
               " WHERE noa01 = nob01 AND noa02 = nob02 ",
               "   AND noa04 = nob04 AND noa05 = nob03 ",
               "   AND noa14 = nob24 ",
               "   AND noa01 = '",p_noa01,"'",
               "   AND noa04 = '",p_noa04,"'",
               "   AND nob21 <> 'Y' "                
   IF p_noa04 = '2' THEN
      IF NOT cl_null(p_nob13) THEN
         LET l_sql = l_sql,"   AND nob13 = '",p_nob13,"'"
      END IF
      LET l_sql = l_sql,"   AND noa14 = '1' ",
                        "   AND noa02 = '",p_noa02,"' ",
                        "   AND noa05 = '",p_noa05,"'",
                        " ORDER BY nob05,nob06 " 
   ELSE
      LET l_sql = l_sql,"   AND noa14 = '3' ",
                        "   AND noa13 = 'N' ",
                        " ORDER BY nob05,nob06 "  
   END IF   
   PREPARE nob_pre2  FROM l_sql
   DECLARE nob_curs2 CURSOR FOR nob_pre2 
   LET l_nob06 = ""
   LET l_str = ""
   FOREACH nob_curs2 INTO l_nob.*,l_noa06,l_noa07
      IF NOT cl_null(l_nob06) AND l_nob06 = l_nob.nob06 THEN
         CONTINUE FOREACH
      END IF 
      LET l_value = p305_getvalue(l_nob.*)
      IF g_success = 'N' THEN
         RETURN  ''
      END IF      
      #組合字符串
      IF l_noa06 = '1' THEN #XML
         LET l_str = l_str,"   <",l_nob.nob06,">",l_value CLIPPED,"</",l_nob.nob06,">", ASCII 10 
      ELSE                  #分隔符
         LET l_str = l_str,l_value CLIPPED,l_noa07
      END IF             
   END FOREACH
   RETURN l_str
END FUNCTION 

#根據anmi011和anmi012的內容組合成XML
FUNCTION p305_getxml(p_noa01,p_noa02,p_noa05)
   DEFINE l_nob    RECORD LIKE nob_file.*
   DEFINE p_noa01  LIKE noa_file.noa01
   DEFINE p_noa02  LIKE noa_file.noa02  #版本編號
   DEFINE p_noa05  LIKE noa_file.noa05
   DEFINE l_str1   STRING
   DEFINE l_str2   STRING
   DEFINE l_sql    STRING      
   
   LET l_sql = "SELECT * FROM nob_file ",
               " WHERE nob01 = '",p_noa01,"'",
               "   AND nob02 = '",p_noa02,"'",
               "   AND nob04 = '1'",
               "   AND nob03 = '",p_noa05,"'",
               "   AND nob24 = '1' ",
               " ORDER BY nob05 "
   PREPARE nob_pre1  FROM l_sql
   DECLARE nob_curs1 CURSOR FOR nob_pre1 
   LET l_str1  = ""
   LET l_str2 = ""  
   FOREACH nob_curs1 INTO l_nob.*
      IF NOT cl_null(l_nob.nob09) THEN
         LET l_str1 = l_str1,l_nob.nob09, ASCII 10
      END IF 
      IF l_nob.nob09  MATCHES "</*"  THEN #尾節點
         CONTINUE FOREACH
      ELSE
         LET l_str2 = p305_getstr(p_noa01,p_noa02,'2',p_noa05,l_nob.nob13)
         IF NOT cl_null(l_str2) THEN
            LET l_str1 = l_str1, l_str2 
         END IF    
      END IF
   END FOREACH
   RETURN l_str1
END FUNCTION

FUNCTION p305_getvalue(p_nob)
   DEFINE p_nob    RECORD LIKE nob_file.* 
   DEFINE l_nob1   RECORD LIKE nob_file.*
   DEFINE l_value  LIKE nob_file.nob09
   DEFINE l_diff   LIKE type_file.num10   
   DEFINE l_i      LIKE type_file.num5
   DEFINE l_time   LIKE type_file.chr8
   DEFINE l_sql    STRING
   DEFINE l_addstr STRING
   DEFINE l_tabstr STRING
   DEFINE field_val  STRING
   DEFINE data_val   STRING

   LET l_value = "" 
   LET field_val = ""
   LET field_val = ""    
   CASE p_nob.nob08 #取值來源
      WHEN "1"     #1 固定值
         LET l_value = p_nob.nob09

      WHEN "2"     #2 從TIPTOP取值
         IF cl_null(p_nob.nob12) THEN
            LET p_nob.nob12 = " 1=1 "
         END IF
         IF p_nob.nob10 NOT MATCHES 'nma_file' THEN
            LET l_tabstr = "  nma_file, ",p_nob.nob10
         ELSE
            LET l_tabstr = p_nob.nob10
         END IF
         LET l_sql = "SELECT ",p_nob.nob11,"  FROM ",l_tabstr,                        
                     " WHERE ",p_nob.nob12,
                     "   AND nma01= '",tm.nma01,"'"
         PREPARE p305_pre1  FROM l_sql
         EXECUTE p305_pre1 INTO l_value
         IF SQLCA.sqlcode THEN 
            CALL s_errmsg('nob11',p_nob.nob11,'exe p305_pre1',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN  ''
         END IF          

      WHEN "3"     #3 序號
         LET g_xh = g_xh + 1
         LET l_value = g_xh 

      WHEN "4"     #4 畫面取值
         IF p_nob.nob09 MATCHES "*nmu23*" THEN
            LET l_value = tm.nmu23
         ELSE
            IF p_nob.nob09 MATCHES "*b_date*" THEN
               LET l_value = tm.b_date
            ELSE
               IF p_nob.nob09 MATCHES "*e_date*" THEN
                  LET l_value = tm.e_date
               ELSE
                  IF p_nob.nob09 MATCHES "*nma04*" THEN
                     LET l_value = tm.nma04
                  END IF   
               END IF   
            END IF   
         END IF

      WHEN "5"     #5 多域串         
         DECLARE nob_curs_1 CURSOR FOR SELECT * FROM nob_file 
           WHERE nob01 = p_nob.nob01 AND nob02 = p_nob.nob02 
             AND nob03 = p_nob.nob03 AND nob04 = p_nob.nob04
             AND nob24 = p_nob.nob24 AND nob21 = 'Y'
             AND nob08 <> '5'
           ORDER BY nob05  
         FOREACH nob_curs_1 INTO l_nob1.*   
            LET field_val =  field_val,l_nob1.nob06,l_nob1.nob22
            LET l_value = p305_getvalue(l_nob1.*)
            LET data_val = data_val,l_value,l_nob1.nob22
            IF g_success = 'N' THEN
               RETURN  ''
            END IF 
         END FOREACH
         LET l_value =  field_val CLIPPED,data_val CLIPPED      
       
      WHEN "6"    #當前日期
         IF NOT cl_null(p_nob.nob09) THEN
            LET l_value = g_today USING p_nob.nob09
         ELSE
            LET l_value = g_today
         END IF

      WHEN "7"    #當前時間
         IF NOT cl_null(p_nob.nob09) THEN
           LET l_i = LENGTH(p_nob.nob09)
           LET l_time = TIME
           IF p_nob.nob09 MATCHES "*:*" THEN
              LET l_value = l_time
           ELSE
              LET l_value = l_time[1,2],l_time[4,5],l_time[7,8]
           END IF
           LET l_value = l_value[1,l_i]
         ELSE
            LET l_value = l_time
         END IF
   END CASE 
   IF p_nob.nob04 = '2' AND p_nob.nob08 <> '5' THEN
      #是否必輸nob14
      IF cl_null(l_value) AND p_nob.nob14 = 'Y' THEN 
         LET g_success = 'N'
         CALL s_errmsg('nob01',p_nob.nob01,"nob14 = Y",'anm1021',1)
         RETURN ''
      END IF  
      #是否控制小數位數nob19 nob20
      IF p_nob.nob19 = 'Y' THEN
         LET l_value = cl_set_num_value(l_value,p_nob.nob20)
      END IF
      #是否需補字符nob16 nob17 nob18
      LET l_diff = 0
      LET l_addstr = ''
      IF p_nob.nob16 = 'Y' THEN
         IF LENGTH(p_nob.nob17) > 1 THEN
            LET g_success = 'N'
            CALL s_errmsg('nob17',p_nob.nob17,"",'abm-811',1)
            RETURN ''
         END IF
         LET l_diff = p_nob.nob15 - LENGTH(l_value)
         IF l_diff > 0 THEN      
            FOR l_i = 1 TO l_diff 
               LET l_addstr = l_addstr,p_nob.nob17
            END FOR   
            IF p_nob.nob18 = '01' THEN
               lET l_value = l_addstr,l_value
            ELSE
               LET l_value = l_value,l_addstr
            END IF
         END IF
      END IF
      #最大長度nob15
      IF NOT cl_null(p_nob.nob15) AND LENGTH(l_value) > p_nob.nob15 THEN
         LET g_success = 'N'
         CALL s_errmsg('nob15',l_value,"nob15",'anm1020',1)
         RETURN  ''
      END IF 
   END IF   
   RETURN l_value
END FUNCTION

#拆分XML
FUNCTION p305_fromXml(p_file,p_noa)
   DEFINE p_file      STRING
   DEFINE p_noa       RECORD LIKE noa_file.*
   DEFINE r           om.XmlReader
   DEFINE e           STRING
   DEFINE a           om.SaxAttributes
   DEFINE i,j,k       LIKE type_file.num5
   DEFINE l_value1    STRING
   DEFINE l_value2    STRING
   DEFINE value_str   STRING
   DEFINE field_str   STRING 
   DEFINE value_array DYNAMIC ARRAY OF RECORD
                      nod     STRING,
                      val     STRING
                      END RECORD 
   DEFINE l_nob       DYNAMIC ARRAY OF RECORD
                      nob06     LIKE nob_file.nob06,
                      nob08     LIKE nob_file.nob08,
                      nob11     LIKE nob_file.nob11,
                      nob21     LIKE nob_file.nob21,
                      nob22     LIKE nob_file.nob22
                      END RECORD
   DEFINE l_flag      LIKE type_file.chr1                   

   LET value_str = ""
   LET field_str = ""
   CALL l_nob.clear()
   CALL value_array.clear() 
   
   LET g_sql ="SELECT nob06,nob08,nob11,nob21,nob22 FROM nob_file ",
              " WHERE nob01 = '",p_noa.noa01,"'",
              "   AND nob02 = '",p_noa.noa02,"'",
              "   AND nob03 = '",p_noa.noa05,"'",
              "   AND nob04 = '2'", 
              "   AND nob24 = '",p_noa.noa14,"'",
              "   AND nob21 <> 'Y' ",
              " ORDER BY nob05"
   PREPARE nob_pre_x  FROM g_sql
   DECLARE nob_curs_x CURSOR FOR nob_pre_x  
   #讀取xml信息
   LET r = om.XmlReader.createFileReader(p_file)
   LET a = r.getAttributes()
   LET i = 0
   LET e = r.read()  
   WHILE e IS NOT NULL       
      CASE e
         WHEN "StartElement"
            LET i = i + 1
            LET value_array[i].nod = r.getTagName()
         WHEN "Characters"
            LET value_array[i].val = r.getCharacters()      
      END CASE
      LET e = r.read()
   END WHILE
   IF i = 0 THEN
      CALL s_errmsg('','','','azz1063',1)
      LET g_success = 'N'
      RETURN 
   END IF
   #讀取字段信息
   LET j = 1
   LET l_flag = 'N'   
   FOREACH nob_curs_x INTO l_nob[j].*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('FOREACH','','',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH       
      END IF
      IF l_nob[j].nob08 <> '5' AND (cl_null(l_nob[j].nob11) OR l_nob[j].nob11 NOT MATCHES "nmu*") THEN
         LET j = j + 1
         CONTINUE FOREACH            
      END IF        
      LET l_flag = 'Y'      
      FOR k =1 TO i
         IF l_nob[j].nob06 = value_array[k].nod THEN 
            IF l_nob[j].nob08 = '5' THEN  #多域串處理
               LET l_value1 = "" 
               LET l_value2 = ""
               CALL p305_fromcomplex(p_noa.*,value_array[k].val) RETURNING l_value1,l_value2 
               LET field_str = field_str,",",l_value1
               LET value_str = value_str,",",l_value2                      
            ELSE                  
               LET field_str = field_str,",",l_nob[j].nob11
               LET value_str = value_str,",'",value_array[k].val,"'"               
            END IF
            EXIT FOR
         END IF   
      END FOR
      LET j = j + 1
   END FOREACH
   IF l_flag = 'N' THEN
      LET g_success = 'N'
      RETURN 
   END IF   
   LET field_str = field_str.subString(2,field_str.getLength())
   LET value_str = value_str.subString(2,value_str.getLength())

   #把資料插入臨時表
   CALL p305_insnmutmp(field_str,value_str)
   
END FUNCTION

#拆分字符串
FUNCTION p305_fromStr(p_valuestr,p_noa)
   DEFINE p_valuestr  STRING
   DEFINE p_noa       RECORD LIKE noa_file.*
   DEFINE i,j,k       LIKE type_file.num5
   DEFINE data_array  DYNAMIC ARRAY OF STRING
   DEFINE field_array DYNAMIC ARRAY OF STRING
   DEFINE l_nob06     LIKE nob_file.nob06 
   DEFINE l_nob11     LIKE nob_file.nob11 
   DEFINE l_tok_field base.StringTokenizer 
   DEFINE l_cnt_field LIKE type_file.num5
   DEFINE value_str   STRING
   DEFINE field_str   STRING  

   LET l_nob06 =  ""
   LET l_nob11 = ""
   LET value_str = ""
   LET field_str = ""
   CALL data_array.clear()
   CALL field_array.clear()
   
   LET g_sql ="SELECT nob06,nob08,nob11,nob21,nob22 FROM nob_file ",
              " WHERE nob01 = '",p_noa.noa01,"'",
              "   AND nob02 = '",p_noa.noa02,"'",
              "   AND nob03 = '",p_noa.noa05,"'",
              "   AND nob04 = '2'", 
              "   AND nob24 = '",p_noa.noa14,"'",
              "   AND nob21 <> 'Y' ",
              " ORDER BY nob05"
   PREPARE nob_pre_s  FROM g_sql
   DECLARE nob_curs_s CURSOR FOR nob_pre_s  
   
   LET p_valuestr = p_valuestr.trim() 
   IF p_valuestr.subString(p_valuestr.getLength(),p_valuestr.getLength()) = p_noa.noa07 THEN
      LET p_valuestr = p_valuestr.subString(1,p_valuestr.getLength()-1)
   END IF
   LET l_tok_field = base.StringTokenizer.createExt(p_valuestr,p_noa.noa07,'',TRUE)
   LET l_cnt_field = l_tok_field.countTokens()
   IF l_cnt_field >0 THEN 
      CALL data_array.clear()
      LET i = 0
      WHILE l_tok_field.hasMoreTokens()
         LET i = i+1
         LET data_array[i] = l_tok_field.nextToken()
      END WHILE
   END IF        
   LET j = 0          
   FOREACH nob_curs_s INTO l_nob06,l_nob11
      LET j = j + 1
      LET field_array[j] = l_nob11            
   END FOREACH
   IF j <> l_cnt_field THEN
      CALL s_errmsg('noa01',p_noa.noa01,'','-2931',1)
      LET g_success = 'N'
      RETURN
   END IF 
   FOR k = 1 TO l_cnt_field
      IF NOT cl_null(field_array[k]) AND field_array[k] MATCHES "nmu*" THEN
         LET field_str = field_str,",",field_array[k]
         LET value_str = value_str,",'",data_array[k],"'"  
      END IF   
   END FOR
   LET field_str = field_str.subString(2,field_str.getLength())
   LET value_str = value_str.subString(2,value_str.getLength())
   
   #資料插入臨時表
   CALL p305_insnmutmp(field_str,value_str)
   
END FUNCTION

#拆分多域串
FUNCTION p305_fromcomplex(p_noa,p_value)
   DEFINE p_noa       RECORD LIKE noa_file.* 
   DEFINE p_value     STRING
   DEFINE value_str   STRING
   DEFINE field_str   STRING 
   DEFINE i,j         LIKE type_file.num5
   DEFINE l_nob06     LIKE nob_file.nob06 
   DEFINE l_nob11     LIKE nob_file.nob11 
   DEFINE l_nob22     LIKE nob_file.nob22 
   DEFINE l_tok_field base.StringTokenizer 
   DEFINE l_cnt_field LIKE type_file.num5
   DEFINE data_array  DYNAMIC ARRAY OF STRING

   LET l_nob06 = ""
   LET l_nob11 = ""
   LET l_nob22 = ""
   LET value_str = ""
   LET field_str = ""
   CALL data_array.clear()
   
   LET g_sql ="SELECT nob06,nob11,nob22 FROM nob_file ",
              " WHERE nob01 = '",p_noa.noa01,"'",
              "   AND nob02 = '",p_noa.noa02,"'",
              "   AND nob03 = '",p_noa.noa05,"'",
              "   AND nob24 = '",p_noa.noa14,"'",
              "   AND nob04 = '2'",              
              "   AND nob21 = 'Y' ",
              " ORDER BY nob05"
   PREPARE nob_pre_c  FROM g_sql
   DECLARE nob_curs_c CURSOR FOR nob_pre_c
   LET i = 1    
   FOREACH nob_curs_c INTO l_nob06,l_nob11,l_nob22
      IF i = 1 THEN
         LET p_value = p_value.trim()
         IF p_value.subString(p_value.getLength(),p_value.getLength()) = l_nob22 THEN
            LET p_value = p_value.subString(1,p_value.getLength()-1)
         END IF
         LET l_tok_field = base.StringTokenizer.createExt(p_value,l_nob22,'',TRUE)
         LET l_cnt_field = l_tok_field.countTokens()
         IF l_cnt_field >0 THEN 
             LET j=0
             WHILE l_tok_field.hasMoreTokens()
                LET j = j + 1
                LET data_array[j] = l_tok_field.nextToken()
             END WHILE
         END IF  
      END IF 
      IF NOT cl_null(l_nob11) AND l_nob11 MATCHES "nmu*" THEN
         LET field_str = field_str,",",l_nob11
         LET value_str = value_str,",'",data_array[i + j/2],"'"
      END IF    
      LET i = i + 1                                   
   END FOREACH
   LET field_str = field_str.subString(2,field_str.getLength())
   LET value_str = value_str.subString(2,value_str.getLength())
   RETURN field_str,value_str
   
END FUNCTION

#資料插入臨時表
FUNCTION p305_insnmutmp(p_field_str,p_value_str)
   DEFINE p_value_str  STRING
   DEFINE p_field_str  STRING

   LET g_sql ="INSERT INTO nmu_temp(",p_field_str,") VALUES(",p_value_str,")"
   PREPARE temp_pre FROM g_sql       
   EXECUTE temp_pre
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('insert into temptable','','',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF    
END FUNCTION

#若為背景作業，怎會進入此函數開始運行
FUNCTION p305_bg(p_nma01,p_nma04,p_noa05,p_noa02,p_b_date,p_e_date,p_bgjob)
   DEFINE   l_nmr       RECORD LIKE nmr_file.*
   DEFINE   p_nma01     LIKE nma_file.nma01
   DEFINE   p_nma04     LIKE nma_file.nma04 
   DEFINE   p_noa02     LIKE noa_file.noa02
   DEFINE   p_noa05     LIKE noa_file.noa05
   DEFINE   p_b_date    LIKE type_file.dat
   DEFINE   p_e_date    LIKE type_file.dat
   DEFINE   p_bgjob     LIKE type_file.chr1
   DEFINE   l_p1        STRING                  #用于接收登錄信息
 
    LET tm.nma01    = p_nma01
    LET tm.nma04    = p_nma04
    LET tm.noa02    = p_noa02
    LET tm.noa05    = p_noa05
    LET tm.b_date   = p_b_date
    LET tm.e_date   = p_e_date
    LET tm.bgjob    = p_bgjob
    LET tm.a_b_date = NULL
    LET tm.a_e_date = NULL
 
    IF tm.bgjob = 'Y' THEN 
       SELECT * INTO l_nmr.* FROM nmr_file 
        WHERE nmr01 = tm.nma01
       CASE SQLCA.sqlcode 
         WHEN 100
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
     WHERE nmr01=tm.nma01
    IF SQLCA.sqlcode = 100 THEN 
       LET tm.a_b_date = NULL
       LET tm.a_e_date = NULL
    END IF 
    CALL p305()
    RETURN g_success  
END FUNCTION 
#FUN-B30213--end--
