# Prog. Version..: '5.30.06-13.03.12(00003)'     #
# Pattern name...: aglt940.4gl
# Descriptions...: 現金流量表列印
# Date & Author..: 2010/12/08 By lutingting 
# Modify.........: NO.FUN-B40104 11/05/05 By jll 合并报表作业
# Modify.........: No.FUN-B60095 11/06/20 By lutingting bug修改
# Modify.........: No.FUN-B80057 11/08/04 By fengrui  程式撰寫規範修正

DATABASE ds

GLOBALS "../../config/top.global"
DEFINE tm  RECORD
              title   LIKE zaa_file.zaa08,   #輸入報表名稱
              axa01   LIKE axa_file.axa01,   #族群
              y1      LIKE type_file.num5,   #輸入起始年度
              m1      LIKE type_file.num5,   #Begin 期別
              y2      LIKE type_file.num5,   #輸入截止年度
              m2      LIKE type_file.num5,   # 期別
              b       LIKE aaa_file.aaa01,    #帳別
              #ver     LIKE tia_file.ta_tia001,
              c       LIKE type_file.chr1,   #異動額及餘額為0者是否列印
              d       LIKE type_file.chr1,   #金額單位
              o       LIKE type_file.chr1,   #轉換幣別否
              r       LIKE azi_file.azi01,    #總帳幣別
              p       LIKE azi_file.azi01,    #轉換幣別
              q       LIKE azj_file.azj03,    #匯率
              more    LIKE type_file.chr1     #Input more condition(Y/N)
          END RECORD,
          bdate,edate          LIKE type_file.dat,     
          l_za05               LIKE type_file.chr1000,
          g_bookno             LIKE aah_file.aah00,    #帳別
          g_unit               LIKE type_file.num10, 
          g_zo12               LIKE zo_file.zo12    
DEFINE    g_i                  LIKE type_file.num5 
DEFINE    g_aaa03              LIKE  aaa_file.aaa03
DEFINE    g_before_input_done  LIKE type_file.num5    
DEFINE    p_cmd                LIKE type_file.chr1    
DEFINE    g_msg                LIKE type_file.chr1000 
DEFINE    l_table              STRING 
DEFINE    g_str                STRING
DEFINE    g_sql                STRING
DEFINE   g_yy2      LIKE type_file.num5
DEFINE   g_rec_b    LIKE type_file.num10
DEFINE   g_nml      DYNAMIC ARRAY OF RECORD
                    nml02  LIKE type_file.chr1000, 
                    nml05  LIKE nml_file.nml05,
                    tia08a LIKE aah_file.aah04,
                    tia08b LIKE aah_file.aah04
                    END RECORD
DEFINE   g_pr_ar    DYNAMIC ARRAY OF RECORD
                    type   LIKE type_file.chr1,
                    nml01  LIKE nml_file.nml01,
                    nml02  LIKE type_file.chr1000,
                    nml03  LIKE nml_file.nml03,
                    nml05  LIKE nml_file.nml05,
                    tia08a LIKE tia_file.tia08,
                    tia08b LIKE tia_file.tia08
                    END RECORD
DEFINE   g_pr       RECORD
                    type   LIKE type_file.chr1,
                    nml01  LIKE nml_file.nml01,
                    nml02  LIKE type_file.chr1000,
                    nml03  LIKE nml_file.nml03,
                    nml05  LIKE nml_file.nml05,
                    tia08a LIKE tia_file.tia08,
                    tia08b LIKE tia_file.tia08
                    END RECORD
DEFINE g_nml05     LIKE nml_file.nml05
DEFINE g_zx02      LIKE zx_file.zx02 
DEFINE g_aaw01     LIKE aaw_file.aaw01

MAIN

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                  # Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF

   LET g_trace = 'N'                # default trace off
   LET g_bookno = ARG_VAL(1)
   LET g_pdate  = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.title = ARG_VAL(8)
   LET tm.y1 = ARG_VAL(9)
   LET tm.y2 = ARG_VAL(10)
   LET tm.m1 = ARG_VAL(11)
   LET tm.m2 = ARG_VAL(12)
   LET tm.b = ARG_VAL(13)
   LET tm.c = ARG_VAL(14)
   LET tm.d = ARG_VAL(15)
   LET tm.o = ARG_VAL(16)
   LET tm.r = ARG_VAL(17)
   LET tm.p = ARG_VAL(18)
   LET tm.q = ARG_VAL(19)
   LET g_rep_user = ARG_VAL(20)
   LET g_rep_clas = ARG_VAL(21)
   LET g_template = ARG_VAL(22)
   LET g_rpt_name = ARG_VAL(23)  #No:FUN-7C0078
   LET tm.axa01 = ARG_VAL(24)

   IF cl_null(tm.b) THEN
      SELECT aaw01 INTO tm.b FROM aaw_file WHERE aaw00 = '0'
   END IF

   LET g_rlang  = g_lang

   OPEN WINDOW t940_w AT 5,10
        WITH FORM "agl/42f/aglt940" ATTRIBUTE(STYLE = g_win_style)              
                                                                                
   CALL cl_ui_init()                                                           
   CALL cl_set_comp_visible("tia08b",FALSE)
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80057--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN  # If background job sw is off
      CALL t940_tm()                          # Input print condition
   ELSE
      CALL t940()                             # Read data and create out-file
   END IF

   CALL t940_menu()                                                            
   CLOSE WINDOW t940_w 

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION t940_menu()
   WHILE TRUE
      CALL t940_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t940_tm()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t940_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No:FUN-4B0021
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nml),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION t940_tm()
   DEFINE li_chk_bookno  LIKE type_file.num5 
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_sw           LIKE type_file.chr1, 
          l_cmd          LIKE type_file.chr1000

   CALL s_dsmark(tm.b)  #No.FUN-850030
   LET p_row = 4 LET p_col = 4
   OPEN WINDOW t940_w1 AT p_row,p_col
     WITH FORM "agl/42f/aglt940_1"  ATTRIBUTE (STYLE = g_win_style CLIPPED)        
 
   CALL cl_ui_locale("aglt940_1") 
   CALL s_shwact(0,0,tm.b) 
   CALL cl_opmsg('p')

   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b  
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0)  
   END IF
   INITIALIZE tm.* TO NULL    

   LET tm.title = g_x[1]
   IF cl_null(tm.title) THEN LET tm.title='现金流量表' END IF
   LET tm.b = g_bookno
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.o = 'N'
   LET tm.r = g_aaa03
   LET tm.p = tm.r
   LET tm.q = 1
   LET tm.more = 'N'
   LET g_pdate  = g_today
   LET g_bgjob  = 'N'
   LET g_copies = '1'

   WHILE TRUE

      INPUT BY NAME tm.title,tm.axa01,tm.y1,tm.m1,tm.m2,tm.b,tm.d,tm.c,tm.o,
                    tm.r,tm.p,tm.q,tm.more WITHOUT DEFAULTS
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
 
         BEFORE INPUT
            CALL t940_set_entry(p_cmd)
            CALL t940_set_no_entry(p_cmd)
         #No:FUN-580031 --start--
            CALL cl_qbe_init()
         #No:FUN-580031 ---end---

         AFTER FIELD axa01   #族群代號
            IF NOT cl_null(tm.axa01) THEN
               SELECT DISTINCT axa01 FROM axa_file WHERE axa01=tm.axa01
               IF STATUS THEN
                  CALL cl_err3("sel","axa_file",tm.axa01,'',"agl-117","","",0)
                  NEXT FIELD axa01
               END IF
            END IF
 
         AFTER FIELD y1
            IF NOT cl_null(tm.y1) THEN
               IF tm.y1 = 0 THEN
                  NEXT FIELD y1
               END IF
               LET tm.y2=tm.y1
               LET g_yy2= tm.y1 - 1  #No.FUN-850030
            END IF
 
         AFTER FIELD m1
         IF NOT cl_null(tm.m1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y1
            IF g_azm.azm02 = 1 THEN
               IF tm.m1 > 12 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            ELSE
               IF tm.m1 > 13 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            END IF
         END IF
 
         AFTER FIELD m2
         IF NOT cl_null(tm.m2) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y1
            IF g_azm.azm02 = 1 THEN
               IF tm.m2 > 12 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            ELSE
               IF tm.m2 > 13 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            END IF
         END IF


            IF tm.y1*13+tm.m1 > tm.y2*13+tm.m2 THEN
               CALL cl_err('','9011',0)
               NEXT FIELD m1
            END IF
 
         AFTER FIELD b
            IF NOT cl_null(tm.b) THEN
               #No.FUN-670004--begin
	            CALL s_check_bookno(tm.b,g_user,g_plant) 
                    RETURNING li_chk_bookno
               IF (NOT li_chk_bookno) THEN
                  NEXT FIELD b
               END IF
               #No.FUN-670004--end
            SELECT aaa01 FROM  aaa_file WHERE aaa01 = tm.b AND aaaacti IN ('Y','y')
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","aaa_file",tm.b,"","agl-095","","",0)   #No.FUN-660124
                  NEXT FIELD b
               END IF
	    END IF
 
 
         AFTER FIELD o
            IF tm.o = 'N' THEN
               LET tm.p = tm.r
               LET tm.q = 1
               DISPLAY BY NAME tm.q,tm.r
            END IF
            CALL t940_set_no_entry(p_cmd)
 
         AFTER FIELD p
            SELECT azi01 FROM azi_file WHERE azi01 = tm.p
            IF SQLCA.sqlcode THEN
#              CALL cl_err(tm.p,'mfg3008',0)   #No.FUN-660124
               CALL cl_err3("sel","azi_file",tm.p,"","mfg3008","","",0)   #No.FUN-660124
               NEXT FIELD p
            END IF
 
         AFTER FIELD q
            IF tm.q <= 0 THEN
               NEXT FIELD q
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
            IF tm.d = '1' THEN
               LET g_unit = 1
            END IF

            IF tm.d = '2' THEN
               LET g_unit = 1000
            END IF

            IF tm.d = '3' THEN
               LET g_unit = 1000000
            END IF

            IF tm.o = 'N' THEN
               LET tm.p = tm.r
               LET tm.q = 1
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
 
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(axa01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_axa1"
                  LET g_qryparam.default1 = tm.axa01
                  CALL cl_create_qry() RETURNING tm.axa01
                  DISPLAY BY NAME tm.axa01
                  NEXT FIELD axa01
               WHEN INFIELD(b)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aaa"
                  LET g_qryparam.default1 = tm.b
                  CALL cl_create_qry() RETURNING tm.b
                  DISPLAY tm.b TO b
                  NEXT FIELD b
               WHEN INFIELD(p)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azi"
                  LET g_qryparam.default1 = tm.p
                  CALL cl_create_qry() RETURNING tm.p
                  DISPLAY tm.p TO p
                  NEXT FIELD p
            END CASE
         #No:FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No:FUN-580031 ---end---

         #No:FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No:FUN-580031 ---end---

      END INPUT
     #-----TQC-610056---------
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
               WHERE zz01='aglt940'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('aglt940','9031',1)
        ELSE
           LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_bookno CLIPPED,"'" ,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No:FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No:FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.title CLIPPED,"'" ,
                        " '",tm.y1 CLIPPED,"'" ,
                        " '",tm.y2 CLIPPED,"'" ,
                        " '",tm.m1 CLIPPED,"'" ,
                        " '",tm.m2 CLIPPED,"'" ,
                        " '",tm.b CLIPPED,"'" ,
                       # " '",tm.ver CLIPPED,"'" ,
                        " '",tm.c CLIPPED,"'" ,
                        " '",tm.d CLIPPED,"'" ,
                        " '",tm.o CLIPPED,"'" ,
                        " '",tm.r CLIPPED,"'" ,
                        " '",tm.p CLIPPED,"'" ,
                        " '",tm.q CLIPPED,"'" ,
                        " '",g_rep_user CLIPPED,"'",
                        " '",g_rep_clas CLIPPED,"'",
                        " '",g_template CLIPPED,"'",
                        " '",tm.axa01 CLIPPED,"'"
            CALL cl_cmdat('aglt940',g_time,l_cmd)    # Execute cmd at later tim
        END IF
        CLOSE WINDOW t940_w1
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80057--add--
        EXIT PROGRAM
     END IF
     #-----END TQC-610056-----


      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW t940_w1
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80057--add--
         EXIT PROGRAM
      END IF

      CALL cl_wait()
      CALL t940()

      ERROR ""
      EXIT WHILE   #No.FUN-850030
   END WHILE

   CLOSE WINDOW t940_w1

END FUNCTION

FUNCTION t940()
DEFINE l_name    LIKE type_file.chr20    #NO FUN-690009   VARCHAR(20)    # External(Disk) file name
DEFINE l_chr     LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
DEFINE l_sql     LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(1000)  # RDSQL STATEMENT
DEFINE sr        RECORD
                 type   LIKE type_file.chr1,
                 nml01  LIKE nml_file.nml01,
                 nml02  LIKE type_file.chr1000, #No.090217 by chenl 
                 nml03  LIKE nml_file.nml03,
                 nml05  LIKE nml_file.nml05,
                 tia08a LIKE tia_file.tia08,
                 tia08b LIKE tia_file.tia08
                 END RECORD
DEFINE l_i       LIKE type_file.num10
DEFINE l_tmp     LIKE type_file.num5 
DEFINE l_tib08   LIKE tib_file.tib08 
DEFINE l_nml03   LIKE nml_file.nml03                                            
DEFINE l_aep03   LIKE aep_file.aep03
DEFINE l_aep04   LIKE aep_file.aep04
DEFINE l_aep05   LIKE aep_file.aep05
DEFINE l_aeq07   LIKE aeq_file.aeq07
DEFINE l_aeq08   LIKE aeq_file.aeq08
DEFINE l_aeq10   LIKE aeq_file.aeq10
DEFINE l_aeq06   LIKE aeq_file.aeq06
DEFINE l_aeq09   LIKE aeq_file.aeq09
DEFINE l_gir01   LIKE gir_file.gir01
DEFINE l_gir02   LIKE gir_file.gir02
DEFINE l_amt_s   LIKE axh_file.axh08
DEFINE l_amt_s1  LIKE axh_file.axh08
DEFINE l_amt_s2  LIKE axh_file.axh08
DEFINE l_sub_amt LIKE axh_file.axh08
DEFINE l_amt     LIKE axh_file.axh08
DEFINE l_last_y  LIKE type_file.num5
DEFINE l_last_m  LIKE type_file.num5 
DEFINE l_gim     RECORD LIKE gim_file.*
DEFINE tmp RECORD
            gin02      LIKE gin_file.gin02, 
            gin03      LIKE gin_file.gin03,
            gin04      LIKE gin_file.gin04
            END RECORD
   #No.FUN-B80057--mark--Begin--- 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
   #No.FUN-B80057--mark--End-----
   LET g_prog = 'aglt940'
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aglt940'
   SELECT zo02 INTO g_company FROM zo_file
    WHERE zo01 = g_rlang

   SELECT azi04 INTO t_azi04,t_azi05
     FROM azi_file WHERE azi01 = tm.p  #No.FUN-850030

   IF tm.d != '1' THEN
      LET t_azi04 = 0     #No:CHI-6A0004
      LET t_azi05 = 0
   END IF
   DROP TABLE y
#FUN-B50001--mod--str--luttb
#  SELECT * FROM aep_file
#   WHERE aep_file.aep03 = tm.y1
#     AND aep_file.aep04 BETWEEN tm.m1 AND tm.m2
#     AND aep_file.aep01 = tm.axa01   #族群
#     AND aep_file.aep12 NOT IN (SELECT axa02 FROM axa_file WHERE axa01= tm.axa01)
#     AND aep_file.aep12 NOT IN (SELECT axb04 FROM axb_file WHERE axb01= tm.axa01)
#    INTO TEMP y
    SELECT * FROM aer_file
    WHERE aer_file.aer03 = tm.y1
      AND aer_file.aer04 BETWEEN tm.m1 AND tm.m2
      AND aer_file.aer01 = tm.axa01   #族群
     INTO TEMP y
#FU-B50001--mod--end

   #LET l_sql = "SELECT nml01,nml02,nml03,nml05,SUM(aep06) tia08a", #FUN-B50001 luttb 
   LET l_sql = "SELECT nml01,nml02,nml03,nml05,SUM(aer06) tia08a",
               "  FROM nml_file LEFT OUTER JOIN y",
               #"    ON y.aep05 = nml01 ",   #FUN-B50001 luttb
               "    ON y.aer05 = nml01 ",    #FUN-B50001 luttb
               " GROUP BY nml01,nml02,nml03,nml05"
   PREPARE aglt940_gentemp FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare',STATUS,1)
      RETURN
   END IF

   CALL cl_outnam('aglt940') RETURNING l_name
   START REPORT t940_rep TO l_name
   LET g_pageno = 0

   LET g_rec_b = 1
   CALL g_nml.clear()
   LET g_rec_b = 1
   DECLARE aglt940_curs CURSOR FOR aglt940_gentemp 
   FOREACH aglt940_curs INTO sr.nml01,sr.nml02,sr.nml03,sr.nml05,sr.tia08a
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      #tia08a
      IF sr.tia08a IS NULL THEN LET sr.tia08a = 0 END IF

      LET sr.type = sr.nml03[1,1]

      IF tm.c = 'N' AND sr.tia08a = 0 AND sr.tia08b = 0 THEN
         CONTINUE FOREACH
      END IF

      OUTPUT TO REPORT t940_rep(sr.*)

   END FOREACH

   FINISH REPORT t940_rep
   LET g_nml05=0 #add by mb 090219 行序依次
   FOR l_i = 1 TO g_rec_b
       LET g_nml[l_i].nml02 = g_pr_ar[l_i].nml02
       LET g_nml05=g_nml05+1
       LET g_nml[l_i].nml05 = g_nml05
       LET g_nml[l_i].tia08a= g_pr_ar[l_i].tia08a
       LET g_nml[l_i].tia08b= g_pr_ar[l_i].tia08b
   END FOR

##################以下为现金流量表间接法
   IF tm.m1=1 THEN 
      LET l_last_y = tm.y1 - 1
      LET l_last_m = 12
   ELSE
      LET l_last_y = tm.y1
      LET l_last_m = tm.m1 - 1
   END IF

   LET g_rec_b = g_rec_b+1
   LET g_nml[g_rec_b].nml02 = g_x[33]   #补充材料
   LET g_nml[g_rec_b].nml05 = g_rec_b

   LET g_rec_b = g_rec_b+1
   LET g_nml[g_rec_b].nml02 = g_x[34]   #1.将净利润调节为经营活动现金流量：
   LET g_nml[g_rec_b].nml05 = g_rec_b

   ###经营活动
   LET l_sql="SELECT gir01,gir02 FROM gir_file ",
             " WHERE gir03 NOT IN ('4','5') AND gir04='Y'"
   PREPARE t940_gir_p1 FROM l_sql
   DECLARE t940_gir_cs1 CURSOR FOR t940_gir_p1

   LET l_sql = "SELECT gin02,gin03,gin04",
               "  FROM gin_file,gir_file",
               " WHERE gin01 = gir01  AND gir04='Y' AND gin01 = ?"
   PREPARE t940_p31 FROM l_sql
   DECLARE t940_cu31 CURSOR FOR t940_p31
   LET l_sub_amt = 0
   FOREACH t940_gir_cs1 INTO l_gir01,l_gir02
      LET l_amt_s = 0
      LET l_amt = 0
      FOREACH t940_cu31 USING l_gir01 INTO tmp.*
          CASE tmp.gin04
            WHEN '1'    #异动
              CALL t940_axh(tmp.gin02,tm.y1,tm.m2,l_last_y,l_last_m) 
                 RETURNING l_amt
              IF cl_null(l_amt) THEN LET l_amt = 0 END IF 
            WHEN '2'    #期初
              CALL t940_axh2(tmp.gin02,l_last_y,l_last_m) RETURNING l_amt
              IF cl_null(l_amt) THEN LET l_amt = 0 END IF
            WHEN '3'    #期末
              CALL t940_axh2(tmp.gin02,tm.y1,tm.m2) RETURNING l_amt
              IF cl_null(l_amt) THEN LET l_amt = 0 END IF
            WHEN '4'    #人工录入
              SELECT SUM(git05) INTO l_amt FROM git_file
                WHERE git01 = l_gir01 AND git02 = tmp.gin02
                  AND git06 = tm.y1 AND git07 = tm.m2
                  AND git08 = tm.axa01
                  AND git00 = tm.b
              IF cl_null(l_amt) THEN LET l_amt = 0 END IF
          END CASE
          #若為減項
          IF tmp.gin03 = '-' THEN LET l_amt  = l_amt * -1 END IF
          LET l_amt_s = l_amt_s + l_amt
          IF l_amt_s = 0 AND tm.c = 'N' THEN
             CONTINUE FOREACH
          END IF
      END FOREACH
      LET g_rec_b = g_rec_b +1
      LET g_nml[g_rec_b].nml02 = l_gir02
      LET g_nml[g_rec_b].nml05 = g_rec_b
      LET g_nml[g_rec_b].tia08a = l_amt_s

      Let l_sub_amt = l_sub_amt + l_amt_s   #計算经营活动产生的现金流量净额
      LET l_amt_s = l_amt_s*tm.q/g_unit     #依匯率及單位換算
   END FOREACH

   LET g_rec_b = g_rec_b +1 
   LET g_nml[g_rec_b].nml02 = g_x[35]   #经营活动产生的现金流量净额
   LET g_nml[g_rec_b].nml05 = g_rec_b
   LET g_nml[g_rec_b].tia08a = l_sub_amt
   
   ### 2.不涉及现金收支的投资和筹资活动：
   LET g_rec_b = g_rec_b +1
   LET g_nml[g_rec_b].nml02 = g_x[36]
   LET g_nml[g_rec_b].nml05 = g_rec_b
   LET g_nml[g_rec_b].tia08a = NULL 

   ###债务转为资本
   LET g_rec_b = g_rec_b +1
   LET g_nml[g_rec_b].nml02 = g_x[37]
   LET g_nml[g_rec_b].nml05 = g_rec_b
   LET g_nml[g_rec_b].tia08a = 0

   ### 一年内到期的可转换公司债券
   LET g_rec_b = g_rec_b +1
   LET g_nml[g_rec_b].nml02 = g_x[38]
   LET g_nml[g_rec_b].nml05 = g_rec_b
   LET g_nml[g_rec_b].tia08a = 0

   ###融资租入固定资产
   LET g_rec_b = g_rec_b +1
   LET g_nml[g_rec_b].nml02 = g_x[39]
   LET g_nml[g_rec_b].nml05 = g_rec_b
   LET g_nml[g_rec_b].tia08a = 0

   ### 3.现金及现金等价物净增加情况：
   LET g_rec_b = g_rec_b +1
   LET g_nml[g_rec_b].nml02 = g_x[40]
   LET g_nml[g_rec_b].nml05 = g_rec_b
   LET g_nml[g_rec_b].tia08a = NULL
   LET g_nml[g_rec_b].tia08b = NULL

   ###现金的期末余额
   SELECT gir01,gir02 INTO l_gir01,l_gir02
     FROM gir_file
    WHERE gir03 = '5' AND gir04 = 'Y'

   LET l_sql = "SELECT gin02,gin03,gin04",
               "  FROM gin_file,gir_file",
               #" WHERE gin01 = gir01  AND gir04='Y' AND gin01 = l_gir01"    #FUN-B60095
               " WHERE gin01 = gir01  AND gir04='Y' AND gin01 = '",l_gir01,"'" #FUN-B60095
   PREPARE t940_p32 FROM l_sql
   DECLARE t940_cu32 CURSOR FOR t940_p32
   LET l_amt = 0
   LET l_amt_s1 = 0
   FOREACH t940_cu32 INTO tmp.* 
      CALL t940_axh2(tmp.gin02,tm.y1,tm.m2) RETURNING l_amt
      IF cl_null(l_amt) THEN LET l_amt = 0 END IF
      #若為減項
      IF tmp.gin03 = '-' THEN LET l_amt  = l_amt * -1 END IF
      LET l_amt_s1 = l_amt_s1 + l_amt
      IF l_amt_s1 = 0 AND tm.c = 'N' THEN
         CONTINUE FOREACH
      END IF
   END FOREACH
   LET g_rec_b = g_rec_b +1
   LET g_nml[g_rec_b].nml02 = l_gir02
   LET g_nml[g_rec_b].nml05 = g_rec_b
   LET g_nml[g_rec_b].tia08a = l_amt_s1

   ### 减：现金的期初余额
   SELECT gir01,gir02 INTO l_gir01,l_gir02
     FROM gir_file
    WHERE gir03 = '4' AND gir04 = 'Y'

   LET l_sql = "SELECT gin02,gin03,gin04",
               "  FROM gin_file",
               #" WHERE gin01 = l_gir01"  #FUN-B60095
               " WHERE gin01 = '",l_gir01,"'"   #FUN-B60095
   PREPARE t940_p33 FROM l_sql
   DECLARE t940_cu33 CURSOR FOR t940_p33
   LET l_amt = 0
   LET l_amt_s2 = 0
   FOREACH t940_cu33 INTO tmp.*
      CALL t940_axh2(tmp.gin02,l_last_y,l_last_m) RETURNING l_amt
      IF cl_null(l_amt) THEN LET l_amt = 0 END IF
      #若為減項
      IF tmp.gin03 = '-' THEN LET l_amt  = l_amt * -1 END IF
      LET l_amt_s2 = l_amt_s2 + l_amt
      IF l_amt_s2 = 0 AND tm.c = 'N' THEN
         CONTINUE FOREACH
      END IF
   END FOREACH
   LET g_rec_b = g_rec_b +1
   LET g_nml[g_rec_b].nml02 = l_gir02
   LET g_nml[g_rec_b].nml05 = g_rec_b
   LET g_nml[g_rec_b].tia08a = l_amt_s2

   ###现金及现金等价物净增加额
   LET g_rec_b = g_rec_b +1
   LET g_nml[g_rec_b].nml02 = g_x[41]
   LET g_nml[g_rec_b].nml05 = g_rec_b
   LET g_nml[g_rec_b].tia08a = l_amt_s1-l_amt_s2

#luttb 101227--add--str-- ###揭露事项(agli920)
   ###揭露事项
   LET g_rec_b = g_rec_b +1 
   LET g_nml[g_rec_b].nml02 = g_x[42]
   LET g_nml[g_rec_b].nml05 = g_rec_b
   LET g_nml[g_rec_b].tia08a = NULL

   DECLARE sel_gim_cur CURSOR FOR
    SELECT gim_file.* FROM gim_file
     WHERE gim00 = 'Y'
   FOREACH sel_gim_cur INTO l_gim.*
       LET g_rec_b = g_rec_b+1 
       LET g_nml[g_rec_b].nml02 = l_gim.gim02
       LET g_nml[g_rec_b].nml05 = g_rec_b
       LET g_nml[g_rec_b].tia08a = l_gim.gim03
   END FOREACH
#luttb 101227--add--end
   #No.FUN-B80057--mark--Begin---
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
   #No.FUN-B80057--mark--End-----
END FUNCTION

REPORT t940_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
   DEFINE l_amt        LIKE nme_file.nme08
   DEFINE l_amt2       LIKE nme_file.nme08
   DEFINE l_cash1      LIKE nme_file.nme08
   DEFINE cash_in1     LIKE nme_file.nme08
   DEFINE cash_out1    LIKE nme_file.nme08
   DEFINE l_count1     LIKE nme_file.nme08
   DEFINE l_count_in1   LIKE nme_file.nme08
   DEFINE l_count_out1  LIKE nme_file.nme08
   DEFINE l_cash2      LIKE nme_file.nme08
   DEFINE cash_in2     LIKE nme_file.nme08
   DEFINE cash_out2    LIKE nme_file.nme08
   DEFINE l_count2     LIKE nme_file.nme08
   DEFINE l_count_in2   LIKE nme_file.nme08
   DEFINE l_count_out2  LIKE nme_file.nme08
   DEFINE p_flag       LIKE type_file.num5     #NO FUN-690009   SMALLINT
   DEFINE l_flag       LIKE type_file.num5     #NO FUN-690009   SMALLINT
   DEFINE l_unit       LIKE zaa_file.zaa08   #NO FUN-690009   VARCHAR(40)
   #No.FUN-850030  --Begin
   DEFINE sr           RECORD
                       type   LIKE type_file.chr1,
                       nml01  LIKE nml_file.nml01,
                      #nml02  LIKE nml_file.nml02,   #No.090217 by chenl mark
                       nml02  LIKE type_file.chr1000, #No.090217 by chenl
                       nml03  LIKE nml_file.nml03,
                       nml05  LIKE nml_file.nml05,
                       tia08a LIKE tia_file.tia08,
                       tia08b LIKE tia_file.tia08
                       END RECORD
   #No.FUN-850030  --End  
   DEFINE g_head1      STRING

   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line

   ORDER BY sr.type,sr.nml03,sr.nml01

   FORMAT
      PAGE HEADER
         CASE tm.d
            WHEN '1'
               LET l_unit = g_x[19]
            WHEN '2'
               LET l_unit = g_x[20]
            WHEN '3'
               LET l_unit = g_x[21]
            OTHERWISE
               LET l_unit = ' '
         END CASE

      BEFORE GROUP OF sr.type
         INITIALIZE g_pr_ar[g_rec_b].* TO NULL
         LET g_pr_ar[g_rec_b].type  = sr.type
         LET g_pr_ar[g_rec_b].nml01 = sr.nml01
         LET g_pr_ar[g_rec_b].nml03 = sr.nml03
         CASE sr.type
            WHEN '1'
               LET g_pr_ar[g_rec_b].nml02 = g_x[9]
               LET g_rec_b = g_rec_b + 1
            WHEN '2'
               LET g_pr_ar[g_rec_b].nml02 = g_x[11]
               LET g_rec_b = g_rec_b + 1
            WHEN '3'
               LET g_pr_ar[g_rec_b].nml02 = g_x[13]
               LET g_rec_b = g_rec_b + 1
            WHEN '4'
               LET g_pr_ar[g_rec_b].nml02 = g_x[15]
               LET g_rec_b = g_rec_b + 1
            OTHERWISE
               EXIT CASE
         END CASE
 
      ON EVERY ROW
         LET sr.tia08a = sr.tia08a * tm.q / g_unit
         LET sr.tia08b = sr.tia08b * tm.q / g_unit
         IF NOT cl_null(sr.nml02) THEN #add by mb090617
         LET g_pr_ar[g_rec_b].* = sr.*
         LET g_rec_b = g_rec_b + 1
         END IF #add by mb090617
 
      AFTER GROUP OF sr.nml03
         INITIALIZE g_pr_ar[g_rec_b].* TO NULL
         LET g_pr_ar[g_rec_b].type = sr.type
         LET g_pr_ar[g_rec_b].nml01= sr.nml01
         LET g_pr_ar[g_rec_b].nml03= sr.nml03
         LET cash_in1 = GROUP SUM(sr.tia08a) WHERE sr.nml03[2,2] = '0'
         LET cash_out1= GROUP SUM(sr.tia08a) WHERE sr.nml03[2,2] = '1'
         LET cash_in2 = GROUP SUM(sr.tia08b) WHERE sr.nml03[2,2] = '0'
         LET cash_out2= GROUP SUM(sr.tia08b) WHERE sr.nml03[2,2] = '1'

         IF cl_null(cash_in1) THEN LET cash_in1 = 0 END IF
         IF cl_null(cash_out1) THEN LET cash_out1 = 0 END IF
         IF cl_null(cash_in2) THEN LET cash_in2 = 0 END IF
         IF cl_null(cash_out2) THEN LET cash_out2 = 0 END IF

         IF sr.nml03 <> '40' THEN
            CASE 
              WHEN sr.nml03='1' OR sr.nml03='3'
                   LET g_pr_ar[g_rec_b].nml02 = g_x[18]
              WHEN sr.nml03='2'
                   LET g_pr_ar[g_rec_b].nml02 = g_x[17]
              OTHERWISE
                   LET g_pr_ar[g_rec_b].nml02 = g_x[sr.nml03 MOD 10 + 17]
            END CASE
            IF sr.nml03[2,2] = '0' THEN
               LET cash_in1 = cash_in1 * tm.q / g_unit
               LET cash_in2 = cash_in2 * tm.q / g_unit
               LET g_pr_ar[g_rec_b].tia08a = cash_in1
               LET g_pr_ar[g_rec_b].tia08b = cash_in2
            ELSE
               LET cash_out1 = cash_out1 * tm.q / g_unit
               LET cash_out2 = cash_out2 * tm.q / g_unit
               LET g_pr_ar[g_rec_b].tia08a = cash_out1
               LET g_pr_ar[g_rec_b].tia08b = cash_out2
            END IF
            LET g_rec_b = g_rec_b + 1
         END IF
 
      AFTER GROUP OF sr.type
         INITIALIZE g_pr_ar[g_rec_b].* TO NULL
         LET g_pr_ar[g_rec_b].type = sr.type
         LET g_pr_ar[g_rec_b].nml01= sr.nml01
         LET g_pr_ar[g_rec_b].nml03= sr.nml03

         LET cash_in1 = GROUP SUM(sr.tia08a) WHERE sr.nml03[2,2] = '0'
         LET cash_out1= GROUP SUM(sr.tia08a) WHERE sr.nml03[2,2] = '1'
         LET cash_in2 = GROUP SUM(sr.tia08b) WHERE sr.nml03[2,2] = '0'
         LET cash_out2= GROUP SUM(sr.tia08b) WHERE sr.nml03[2,2] = '1'
         IF cl_null(cash_in1) THEN LET cash_in1 = 0 END IF
         IF cl_null(cash_out1) THEN LET cash_out1 = 0 END IF
         IF cl_null(cash_in2) THEN LET cash_in2 = 0 END IF
         IF cl_null(cash_out2) THEN LET cash_out2 = 0 END IF

         CASE sr.type
            WHEN '1'
               LET l_cash1 = (cash_in1 - cash_out1) * tm.q / g_unit
               LET l_cash2 = (cash_in2 - cash_out2) * tm.q / g_unit
               LET g_pr_ar[g_rec_b].nml02 = g_x[10]
               LET g_pr_ar[g_rec_b].tia08a= l_cash1
               LET g_pr_ar[g_rec_b].tia08b= l_cash2
               LET g_rec_b = g_rec_b + 1
               LET cash_in1 = 0
               LET cash_out1 = 0
               LET cash_in2 = 0
               LET cash_out2 = 0
            WHEN '2'
               LET l_cash1 = (cash_in1 - cash_out1) * tm.q / g_unit
               LET l_cash2 = (cash_in2 - cash_out2) * tm.q / g_unit
               LET g_pr_ar[g_rec_b].nml02 = g_x[12]
               LET g_pr_ar[g_rec_b].tia08a= l_cash1
               LET g_pr_ar[g_rec_b].tia08b= l_cash2
               LET g_rec_b = g_rec_b + 1
               LET cash_in1 = 0
               LET cash_out1 = 0
               LET cash_in2 = 0
               LET cash_out2 = 0
            WHEN '3'
               LET l_cash1 = (cash_in1 - cash_out1) * tm.q / g_unit
               LET l_cash2 = (cash_in2 - cash_out2) * tm.q / g_unit
               LET g_pr_ar[g_rec_b].nml02 = g_x[14]
               LET g_pr_ar[g_rec_b].tia08a= l_cash1
               LET g_pr_ar[g_rec_b].tia08b= l_cash2
               LET g_rec_b = g_rec_b + 1
               LET cash_in1 = 0
               LET cash_out1 = 0
               LET cash_in2 = 0
               LET cash_out2 = 0
            OTHERWISE
               EXIT CASE
         END CASE
 
      ON LAST ROW
         INITIALIZE g_pr_ar[g_rec_b].* TO NULL
         LET g_pr_ar[g_rec_b].type = sr.type
         LET g_pr_ar[g_rec_b].nml01= sr.nml01
         LET g_pr_ar[g_rec_b].nml03= sr.nml03

         LET l_count_in1 = SUM(sr.tia08a) WHERE sr.nml03[2,2] = '0'
         LET l_count_out1= SUM(sr.tia08a) WHERE sr.nml03[2,2] = '1'
         LET l_count_in2 = SUM(sr.tia08b) WHERE sr.nml03[2,2] = '0'
         LET l_count_out2= SUM(sr.tia08b) WHERE sr.nml03[2,2] = '1'
         IF cl_null(l_count_in1) THEN LET l_count_in1 = 0 END IF
         IF cl_null(l_count_out1) THEN LET l_count_out1 = 0 END IF
         IF cl_null(l_count_in2) THEN LET l_count_in2 = 0 END IF
         IF cl_null(l_count_out2) THEN LET l_count_out2 = 0 END IF

         LET l_count1 = l_count_in1 - l_count_out1
         LET l_count2 = l_count_in2 - l_count_out2
         LET l_count1 = l_count1 * tm.q / g_unit
         LET l_count2 = l_count2 * tm.q / g_unit

         LET g_pr_ar[g_rec_b].nml02 = g_x[16]
         LET g_pr_ar[g_rec_b].tia08a= l_count1
         LET g_pr_ar[g_rec_b].tia08b= l_count2
          
END REPORT

FUNCTION t940_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
 
   CALL cl_set_comp_entry("p,q",TRUE)

END FUNCTION
 
FUNCTION t940_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
 
   IF tm.o = 'N' THEN
      CALL cl_set_comp_entry("p,q",FALSE)
   END IF
 
END FUNCTION
#Patch....NO:TQC-610037 <001> #

FUNCTION t940_bp(p_ud)
DEFINE
    p_ud   LIKE type_file.chr1    #No.FUN-680061 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   DISPLAY tm.p TO FORMONLY.azi01
   DISPLAY tm.y1 TO FORMONLY.yy
   DISPLAY tm.m1 TO FORMONLY.mm1
   DISPLAY tm.m2 TO FORMONLY.mm2
   DISPLAY tm.d  TO FORMONLY.unit
   
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nml TO s_nml.* ATTRIBUTE(COUNT=g_rec_b)
      #BEFORE DISPLAY
      #   CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
      #  LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION close
      LET g_action_choice="exit"
      EXIT DISPLAY

      ON ACTION exporttoexcel   #No:FUN-4B0021
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t940_out()
  DEFINE l_i   LIKE type_file.num10
   LET g_prog = 'aglt940'
   LET g_sql =# " type.type_file.chr1,", 
              # " nml01.nml_file.nml01,",
              #" nml02.nml_file.nml02,",   #No.090217 by chenl mark
               " nml02.type_file.chr1000,", #No.090217 by chenl 
              # " nml03.nml_file.nml03,",
               " nml05.nml_file.nml05,",
               " tia08a.tia_file.tia08,",
               " tia08b.tia_file.tia08"
               
   SELECT zo12 INTO g_zo12 FROM zo_file WHERE zo01=g_rlang       #FUN-920034
   SELECT zx02 INTO g_zx02 FROM zx_file WHERE zx01=g_user        #DFUN-960012  
                  
   LET l_table = cl_prt_temptable('aglt940',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80057--add--
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
               " VALUES(?, ?, ?, ? ) " 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80057--add--
      EXIT PROGRAM
   END IF

   CALL cl_del_data(l_table)

   FOR l_i = 1 TO g_rec_b 
       #EXECUTE insert_prep USING g_pr_ar[l_i].*
       EXECUTE insert_prep USING g_nml[l_i].*
   END FOR

   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
   LET g_str = g_str,";",tm.title,";",tm.p,";",tm.d,";",
               t_azi04,";",t_azi05,";",g_zo12,";",tm.y1,";",tm.m1,";",tm.m2,";",g_zx02  #FUN-920034 #DFUN-960012
   CALL cl_prt_cs3('aglt940','aglt940',g_sql,g_str)
   #No.FUN-780031  --End
END FUNCTION


FUNCTION t940_axh(p_axh05,p_axh06,p_axh07,p_last_y,p_last_m)
   DEFINE p_axh05     LIKE axh_file.axh05,
          p_axh06     LIKE axh_file.axh06,
          p_axh07     LIKE axh_file.axh07,
          p_last_y    LIKE axh_file.axh06,   
          p_last_m    LIKE axh_file.axh07,  
          l_value1    LIKE axh_file.axh08, 
          l_value2    LIKE axh_file.axh08,
          l_amt       LIKE axh_file.axh08,
          l_type      LIKE type_file.chr1 

   
   LET l_value1 = 0
   LET l_value2 = 0

   #aag06正常餘額型態(1.借餘 2.貸餘)
   SELECT aag06 INTO l_type FROM aag_file
    WHERE aag01=p_axh05
      AND aag00=tm.b  

   #本期餘額
   SELECT SUM(axh08-axh09) INTO l_value1 FROM axh_file
    WHERE axh00=tm.b                           #帳別
      AND axh05=p_axh05                        #科目
      AND axh06=p_axh06                        #年度
      AND axh07 = tm.m2                        #期別 
      AND axh01=tm.axa01                       #族群
      AND axh13 = '00'
   IF cl_null(l_value1) THEN LET l_value1 = 0 END IF 
   #上期餘額
   SELECT SUM(axh08-axh09) INTO l_value2 FROM axh_file
    WHERE axh00=tm.b                           #帳別
      AND axh05=p_axh05                        #科目
      AND axh06=p_last_y                       #年度
      AND axh07=p_last_m                       #期別   
      AND axh01=tm.axa01                       #族群
      AND axh13 = '00'              
   IF cl_null(l_value2) THEN LET l_value2 = 0 END IF
   IF l_type = '2' THEN
      LET l_value1 = l_value1 * -1
      LET l_value2 = l_value2 * -1
   END IF

   #本期異動   =本期餘額 - 上期餘額
   LET l_amt = l_value1 - l_value2
   RETURN l_amt
END FUNCTION

FUNCTION t940_axh2(p_axh05,p_axh06,p_axh07)
   DEFINE p_axh05     LIKE axh_file.axh05,
          p_axh06     LIKE axh_file.axh06,
          p_axh07     LIKE axh_file.axh07,
          p_value     LIKE axh_file.axh08  
   DEFINE l_type      LIKE type_file.chr1 

   LET p_value = 0
   SELECT aag06 INTO l_type FROM aag_file
    WHERE aag01=p_axh05
      AND aag00=tm.b 

   SELECT SUM(axh08-axh09) INTO p_value FROM axh_file
    WHERE axh00=tm.b                   #帳別
      AND axh05=p_axh05                #科目
      AND axh06=p_axh06                #年度
      AND axh07=p_axh07                #期別
      AND axh01=tm.axa01               #族群
      AND axh13='00'                   #版本 
   IF l_type = '2' THEN   #貸餘
      LET p_value = p_value * -1
   END IF
   IF cl_null(p_value) THEN LET p_value = 0 END IF

   RETURN p_value
END FUNCTION
#NO.FUN-B40104
