# Prog. Version..: '5.30.06-13.03.12(00009)'     #
# Pattern name...: gglq942.4gl
# Descriptions...: 現金流量表列印
# Date & Author..: FUN-B60083 11/06/16 BY lixia
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-B80180 11/08/29 By xuxz 程序中涉及到gim_file的sql
#                                                  加上條件:AND gim04 = tm.y1 AND gim05 = tm.m2
#                                                  WHERE gir03 NOT IN ('4','5')---WHERE gir03 NOT IN ('4','5'，‘6’)
# Modify.........: No.TQC-B90234 11/10/10 By wujie  增加第二栏金额  
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No.TQC-C30056 12/03/05 By zhangweib nmz70='1'票據來源時，產生現金流量表修改為抓tic_file，而非先抓nme,再抓tic_file
#                                                      2.去掉程序中 nme14 IS NULL 的條件
# Modify.........: No.TQC-C50204 12/05/24 By lujh 單身補充材料部分的順序不對，應該按照行序排序
# Modify.........: No.TQC-C50215 12/05/28 By lujh 補充資料部分的金額未帶出
# Modify.........: No.TQC-C50230 12/05/29 By lujh TQC-C50215修改
# Modify.........: No.FUN-C80102 12/12/11 By zhangweib CR報表改善追單


DATABASE ds

GLOBALS "../../config/top.global"
DEFINE tm  RECORD
              title   LIKE zaa_file.zaa08,   #輸入報表名稱
#No.TQC-B90234 --begin  
              title1    LIKE zaa_file.zaa08,    #輸入報表名稱 #FUN-B40056
              title2    LIKE zaa_file.zaa08,    #輸入報表名稱 #FUN-B40056
              a         LIKE mai_file.mai01,    #No.FUN-C80102   Add
              y1        LIKE type_file.num5,    #第一栏年度
              bm1       LIKE type_file.num5,    #Begin 期別
              em1       LIKE type_file.num5,    #End 期別
              y2        LIKE type_file.num5,    #第二栏年度
              bm2       LIKE type_file.num5,    #Begin 期別
              em2       LIKE type_file.num5,    #End   期別
#             y1        LIKE type_file.num5,    #輸入起始年度
#             m1        LIKE type_file.num5,    #Begin 期別
#             y2        LIKE type_file.num5,    #輸入截止年度
#             m2        LIKE type_file.num5,    #End   期別
#No.TQC-B90234 --end              
              b       LIKE aaa_file.aaa01,   #帳別
              c       LIKE type_file.chr1,   #異動額及餘額為0者是否列印
              d       LIKE type_file.chr1,   #金額單位
              o       LIKE type_file.chr1,   #轉換幣別否
              r       LIKE azi_file.azi01,   #總帳幣別
              p       LIKE azi_file.azi01,   #轉換幣別
              q       LIKE azj_file.azj03,   #匯率
              more    LIKE type_file.chr1    #Input more condition(Y/N)
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
DEFINE  g_nmz70     LIKE nmz_file.nmz70   #TQC-C30056
DEFINE   g_nml      DYNAMIC ARRAY OF RECORD
                    nml02  LIKE type_file.chr1000, 
                    nml05  LIKE nml_file.nml05,
                    tic07  LIKE tic_file.tic07,
                    tic07b LIKE aah_file.aah04,
                    tic071 LIKE aah_file.aah04    #No.TQC-B90234                     
                    END RECORD
DEFINE   g_pr_ar    DYNAMIC ARRAY OF RECORD
                    type   LIKE type_file.chr1,
                    nml01  LIKE nml_file.nml01,
                    nml02  LIKE type_file.chr1000,
                    nml03  LIKE nml_file.nml03,
                    nml05  LIKE nml_file.nml05,
                    tic07  LIKE tic_file.tic07,
                    tic07b LIKE tic_file.tic07,
                    tic071 LIKE tic_file.tic07    #No.TQC-B90234                     
                   END RECORD
DEFINE   g_pr       RECORD
                    type   LIKE type_file.chr1,
                    nml01  LIKE nml_file.nml01,
                    nml02  LIKE type_file.chr1000,
                    nml03  LIKE nml_file.nml03,
                    nml05  LIKE nml_file.nml05,
                    tic07  LIKE tic_file.tic07,
                    tic07b LIKE tic_file.tic07,
                    tic071 LIKE tic_file.tic07    #No.TQC-B90234                    
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
 
   IF (NOT cl_setup("GGL")) THEN
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
#No.TQC-B90234 --begin 
   LET tm.bm1 = ARG_VAL(11)
   LET tm.em1 = ARG_VAL(12)
   LET tm.bm2 = ARG_VAL(13)
   LET tm.em2 = ARG_VAL(14) 
   LET tm.b = ARG_VAL(15)
   LET tm.c = ARG_VAL(16)
   LET tm.d = ARG_VAL(17)
   LET tm.o = ARG_VAL(18)
   LET tm.r = ARG_VAL(19)
   LET tm.p = ARG_VAL(20)
   LET tm.q = ARG_VAL(21)
   LET g_rep_user = ARG_VAL(22)
   LET g_rep_clas = ARG_VAL(23)
   LET g_template = ARG_VAL(24)
   LET g_rpt_name = ARG_VAL(25)  
#No.TQC-B90234 --end    LET g_rpt_name = ARG_VAL(23)  
   #LET tm.axa01 = ARG_VAL(24)

  #TQC-C30056--mark--str--
  #IF cl_null(tm.b) THEN
  #   SELECT aaw01 INTO tm.b FROM aaw_file WHERE aaw00 = '0'
  #END IF
  #TQC-C30056--mark--end
   IF cl_null(tm.b)  THEN LET tm.b=g_aza.aza81  END IF   #FUN-C80102 add

   SELECT nmz70 INTO g_nmz70 FROM nmz_file  #TQC-C30056
   LET g_rlang  = g_lang
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   OPEN WINDOW q942_w AT 5,10
        WITH FORM "ggl/42f/gglq942" ATTRIBUTE(STYLE = g_win_style)              
                                                                                
   CALL cl_ui_init()                                                           
   CALL cl_set_comp_visible("tic07b",FALSE)
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN  # If background job sw is off
      CALL q942_tm()                          # Input print condition
   ELSE
      CALL q942()                             # Read data and create out-file
   END IF

   CALL q942_menu()                                                            
   CLOSE WINDOW q942_w 

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION q942_menu()
   WHILE TRUE
      CALL q942_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q942_tm()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q942_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nml),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION q942_tm()
   DEFINE li_chk_bookno  LIKE type_file.num5 
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_sw           LIKE type_file.chr1, 
          l_cmd          LIKE type_file.chr1000
   DEFINE l_n            LIKE type_file.num5      #FUN-C80102 add
   DEFINE l_mai01        LIKE mai_file.mai01      #FUN-C80102 add

   CALL s_dsmark(tm.b)  
   LET p_row = 4 LET p_col = 4
  #No.FUN-C80102 ---start--- Mark
  #OPEN WINDOW q942_w1 AT p_row,p_col
  #  WITH FORM "ggl/42f/gglq942_q"  ATTRIBUTE (STYLE = g_win_style CLIPPED)        
 
  #CALL cl_ui_locale("gglq942_q") 
  #No.FUN-C80102 ---end  --- Mark
   CALL s_shwact(0,0,tm.b) 
   CALL cl_opmsg('p')


   #使用預設帳別之幣別
   #TQC-C30056--mod--str--
   IF g_nmz70 = '1' THEN
      LET g_aaa03 = g_aza.aza17
   ELSE
   #TQC-C30056--mod--end
      SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b  
   END IF 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0)  
   END IF
   INITIALIZE tm.* TO NULL    

   LET tm.title = g_x[1]
 # IF cl_null(tm.title) THEN LET tm.title='现金流量表' END IF           #FUN-C80102 mark
   IF cl_null(tm.title) THEN LET tm.title=cl_getmsg('ggl-006',g_lang) END IF   #FUN-C80102 add
#  LET tm.b = g_bookno      #FUN-C80102 mark
   LET tm.b = g_aza.aza81   #FUN-C80102 add
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

   #TQC-C30056--add--str--
   IF g_nmz70 = '1' THEN
      CALL cl_set_comp_visible("b",FALSE)
      LET tm.b = ' '
   END IF
  #TQC-C30056--add--end

   WHILE TRUE

     #No.FUN-C80102 ---start--- Mod
     #INPUT BY NAME tm.title,tm.title1,tm.title2,tm.y1,tm.bm1,tm.em1,tm.y2,tm.bm2,tm.em2,tm.b,tm.d,tm.c,tm.o,   #No.TQC-B90234    #FUN-C80102 mark
     #              tm.r,tm.p,tm.q,tm.more WITHOUT DEFAULTS                                                                       #FUN-C80102 mark
      INPUT BY NAME tm.b,tm.title,tm.d,tm.c,tm.title1,tm.y1,tm.bm1,    #FUN-C80102 add
                    tm.em1,tm.title2,tm.y2,tm.bm2,tm.em2,tm.o,         #FUN-C80102 add
                    tm.r,tm.p,tm.q WITHOUT DEFAULTS                    #FUN-C80102 add
     #No.FUN-C80102 ---end  --- Mod
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   
 
         BEFORE INPUT
            CALL q942_set_entry(p_cmd)
            CALL q942_set_no_entry(p_cmd)
            CALL cl_qbe_init()
 
         AFTER FIELD y1
            IF NOT cl_null(tm.y1) THEN
               IF tm.y1 = 0 THEN
                  NEXT FIELD y1
               END IF
               LET tm.y2=tm.y1
               LET g_yy2= tm.y1 - 1  
            END IF
 
#No.TQC-B90234 --begin
#         AFTER FIELD m1
#            IF NOT cl_null(tm.m1) THEN
#               SELECT azm02 INTO g_azm.azm02 FROM azm_file
#                       g                WHERE azm01 = tm.y1
#               IF g_azm.azm02 = 1 THEN
#                  IF tm.m1 > 12 OR tm.m1 < 1 THEN
#                     CALL cl_err('','agl-020',0)
#                     NEXT FIELD m1
#                  END IF
#               ELSE
#                  IF tm.m1 > 13 OR tm.m1 < 1 THEN
#                     CALL cl_err('','agl-020',0)
#                     NEXT FIELD m1
#                  END IF
#               END IF
#            END IF
#            
#         AFTER FIELD m2
#            IF NOT cl_null(tm.m2) THEN
#               SELECT azm02 INTO g_azm.azm02 FROM azm_file
#                 WHERE azm01 = tm.y1
#               IF g_azm.azm02 = 1 THEN
#                  IF tm.m2 > 12 OR tm.m2 < 1 THEN
#                     CALL cl_err('','agl-020',0)
#                     NEXT FIELD m2
#                  END IF
#               ELSE
#                  IF tm.m2 > 13 OR tm.m2 < 1 THEN
#                     CALL cl_err('','agl-020',0)
#                     NEXT FIELD m2
#                  END IF
#               END IF
#            END IF 
#            IF tm.y1*13+tm.m1 > tm.y2*13+tm.m2 THEN
#               CALL cl_err('','9011',0)
#               NEXT FIELD m1
#            END IF
 
      AFTER FIELD bm1
         IF NOT cl_null(tm.bm1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y1   #No.TQC-B90234  
            IF g_azm.azm02 = 1 THEN
               IF tm.bm1 > 12 OR tm.bm1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm1
               END IF
            ELSE
               IF tm.bm1 > 13 OR tm.bm1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm1
               END IF
            END IF
         END IF
         IF tm.bm1 IS NULL THEN NEXT FIELD bm1 END IF
 
      AFTER FIELD em1
         IF NOT cl_null(tm.em1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y1   #No.TQC-B90234            
            IF g_azm.azm02 = 1 THEN
               IF tm.em1 > 12 OR tm.em1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em1
               END IF
            ELSE
               IF tm.em1 > 13 OR tm.em1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em1
               END IF
            END IF
         END IF
         IF tm.em1 IS NULL THEN NEXT FIELD em1 END IF
         IF tm.bm1 > tm.em1 THEN CALL cl_err('','9011',0) NEXT FIELD bm1 END IF
         IF tm.y2 IS NULL THEN  #No.TQC-B90234 
            LET tm.y2 = tm.y1   #No.TQC-B90234 
            LET tm.bm2 = tm.bm1
            LET tm.em2 = 12
            DISPLAY BY NAME tm.y2,tm.bm2,tm.em2  #No.TQC-B90234  
         END IF
#No.TQC-B90234 --end 
 
         AFTER FIELD b
            IF NOT cl_null(tm.b) THEN
	           CALL s_check_bookno(tm.b,g_user,g_plant) 
                    RETURNING li_chk_bookno
               IF (NOT li_chk_bookno) THEN
                  NEXT FIELD b
               END IF               
               SELECT aaa01 FROM  aaa_file WHERE aaa01 = tm.b AND aaaacti IN ('Y','y')
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","aaa_file",tm.b,"","agl-095","","",0)   
                  NEXT FIELD b
               END IF
	        END IF
 
         AFTER FIELD o
            IF tm.o = 'N' THEN
               LET tm.p = tm.r
               LET tm.q = 1
               DISPLAY BY NAME tm.q,tm.r
            END IF
            CALL q942_set_no_entry(p_cmd)
 
         AFTER FIELD p
            SELECT azi01 FROM azi_file WHERE azi01 = tm.p
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","azi_file",tm.p,"","mfg3008","","",0)   
               NEXT FIELD p
            END IF
 
         AFTER FIELD q
            IF tm.q <= 0 THEN
               NEXT FIELD q
            END IF
 
        #No.FUN-C80102 ---start--- Mark
        #AFTER FIELD more
        #   IF tm.more = 'Y' THEN
        #      CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
        #                     g_bgjob,g_time,g_prtway,g_copies)
        #           RETURNING g_pdate,g_towhom,g_rlang,
        #                     g_bgjob,g_time,g_prtway,g_copies
        #   END IF
        #No.FUN-C80102 ---end  --- Mark
 
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
 
         ON ACTION about         
            CALL cl_about()      
 
         ON ACTION help          
            CALL cl_show_help() 
  
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION CONTROLP
            CASE
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
            
         ON ACTION qbe_select
            CALL cl_qbe_select()
            
         ON ACTION qbe_save
            CALL cl_qbe_save()

      END INPUT
     #No.FUN-C80102 ---start--- Add
     #IF g_bgjob = 'Y' THEN
     #  SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
     #         WHERE zz01='gglq942'
     #  IF SQLCA.sqlcode OR l_cmd IS NULL THEN
     #     CALL cl_err('gglq942','9031',1)
     #  ELSE
     #     LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
     #                  " '",g_bookno CLIPPED,"'" ,
     #                  " '",g_pdate CLIPPED,"'",
     #                  " '",g_towhom CLIPPED,"'",
     #                  " '",g_rlang CLIPPED,"'", 
     #                  " '",g_bgjob CLIPPED,"'",
     #                  " '",g_prtway CLIPPED,"'",
     #                  " '",g_copies CLIPPED,"'",
     #                  " '",tm.title CLIPPED,"'" ,
     #                  " '",tm.y1 CLIPPED,"'" ,
     #                  " '",tm.y2 CLIPPED,"'" ,
     ##No.TQC-B90234 --begin
     #                  " '",tm.bm1 CLIPPED,"'" ,
     #                  " '",tm.em1 CLIPPED,"'" ,
     #                  " '",tm.bm2 CLIPPED,"'" ,
     #                  " '",tm.em2 CLIPPED,"'" ,
     ##No.TQC-B90234 --end 
     #                  " '",tm.b CLIPPED,"'" ,
     #                  " '",tm.c CLIPPED,"'" ,
     #                  " '",tm.d CLIPPED,"'" ,
     #                  " '",tm.o CLIPPED,"'" ,
     #                  " '",tm.r CLIPPED,"'" ,
     #                  " '",tm.p CLIPPED,"'" ,
     #                  " '",tm.q CLIPPED,"'" ,
     #                  " '",g_rep_user CLIPPED,"'",
     #                  " '",g_rep_clas CLIPPED,"'",
     #                  " '",g_template CLIPPED,"'"
     #      CALL cl_cmdat('gglq942',g_time,l_cmd)    # Execute cmd at later tim
     #  END IF
     #  CLOSE WINDOW q942_w1
     #  CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
     #  EXIT PROGRAM
     #END IF
     #No.FUN-C80102 ---end  --- Add

      IF INT_FLAG THEN
         LET INT_FLAG = 0
        #No.FUN-C80102 ---start--- Mod
        #CLOSE WINDOW q942_w1                                                 #No.FUN-C80102 Mark
        #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80096   ADD   #No.FUN-C80102 Mark
        #EXIT PROGRAM                                                         #No.FUN-C80102 Mark
         RETURN                                                               #No.FUN-C80102 Add
        #No.FUN-C80102 ---start--- Mod
      END IF

      CALL cl_wait()
      CALL q942()

      ERROR ""
      EXIT WHILE   
   END WHILE

   CLOSE WINDOW q942_w1

END FUNCTION

FUNCTION q942()
DEFINE l_name    LIKE type_file.chr20    
DEFINE l_chr     LIKE type_file.chr1     
DEFINE l_sql     STRING  
DEFINE sr        RECORD
                 type   LIKE type_file.chr1,
                 nml01  LIKE nml_file.nml01,
                 nml02  LIKE type_file.chr1000, 
                 nml03  LIKE nml_file.nml03,
                 nml05  LIKE nml_file.nml05,
                 tic07 LIKE tic_file.tic07,
                 tic07b LIKE tic_file.tic07,
                 tic071 LIKE tic_file.tic07    #No.TQC-B90234                  
               END RECORD
DEFINE l_i       LIKE type_file.num10
DEFINE l_tmp     LIKE type_file.num5
DEFINE l_nml03   LIKE nml_file.nml03  
DEFINE l_gir01   LIKE gir_file.gir01
DEFINE l_gir02   LIKE gir_file.gir02
DEFINE l_amt_s   LIKE axh_file.axh08
DEFINE l_amt_s1  LIKE axh_file.axh08
DEFINE l_amt_s2  LIKE axh_file.axh08
DEFINE l_sub_amt LIKE axh_file.axh08
DEFINE l_amt     LIKE axh_file.axh08
DEFINE l_last_y  LIKE type_file.num5
DEFINE l_last_m  LIKE type_file.num5 
#No.TQC-B90234 --begin
DEFINE l_amt_s11  LIKE axh_file.axh08
DEFINE l_amt_s21  LIKE axh_file.axh08
DEFINE l_sub_amt1 LIKE axh_file.axh08
DEFINE l_amt1     LIKE axh_file.axh08
DEFINE l_last_y1  LIKE type_file.num5
DEFINE l_last_m1  LIKE type_file.num5 
DEFINE l_azmm02   LIKE azmm_file.azmm02 
#No.TQC-B90234 --end 
DEFINE l_gim     RECORD LIKE gim_file.*
DEFINE l_nmz70   LIKE nmz_file.nmz70 
DEFINE l_tic07   LIKE tic_file.tic07 
DEFINE tmp RECORD
            giv02      LIKE giv_file.giv02, 
            giv03      LIKE giv_file.giv03,
            giv04      LIKE giv_file.giv04
            END RECORD

   #No.FUN-B80096--mark--Begin--- 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
   #No.FUN-B80096--mark--End----- 
   LET g_prog = 'gglq942'
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'gglq942'
   SELECT zo02 INTO g_company FROM zo_file
    WHERE zo01 = g_rlang

   SELECT azi04 INTO t_azi04,t_azi05
     FROM azi_file WHERE azi01 = tm.p 
   SELECT nmz70 INTO l_nmz70 FROM nmz_file  

   IF tm.d != '1' THEN
      LET t_azi04 = 0    
      LET t_azi05 = 0
   END IF

##################以下为现金流量表直接法   
#   DROP TABLE y
#    SELECT * FROM aer_file
#    WHERE aer_file.aer03 = tm.y1
#      AND aer_file.aer04 BETWEEN tm.m1 AND tm.m2
#      #AND aer_file.aer01 = tm.axa01   #族群
#     INTO TEMP y
#
#   LET l_sql = "SELECT nml01,nml02,nml03,nml05,SUM(aer06) tic07",
#               "  FROM nml_file LEFT OUTER JOIN y",
#               "    ON y.aer05 = nml01 ",    
#               " GROUP BY nml01,nml02,nml03,nml05"
#   PREPARE gglq942_gentemp FROM l_sql
#   IF STATUS THEN
#      CALL cl_err('prepare',STATUS,1)
#      RETURN
#   END IF
#
#   CALL cl_outnam('gglq942') RETURNING l_name
#   START REPORT q942_rep TO l_name
#   LET g_pageno = 0
#
#   LET g_rec_b = 1
#   CALL g_nml.clear()
#   LET g_rec_b = 1
#   DECLARE gglq942_curs CURSOR FOR gglq942_gentemp 
#   FOREACH gglq942_curs INTO sr.nml01,sr.nml02,sr.nml03,sr.nml05,sr.tic07
#      IF SQLCA.sqlcode != 0 THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)
#         EXIT FOREACH
#      END IF
#      #tic07
#      IF sr.tic07 IS NULL THEN LET sr.tic07 = 0 END IF
#
#      LET sr.type = sr.nml03[1,1]
#
#      IF tm.c = 'N' AND sr.tic07 = 0 AND sr.tic07b = 0 THEN
#         CONTINUE FOREACH
#      END IF
#
#      OUTPUT TO REPORT q942_rep(sr.*)
#
#   END FOREACH
#
#   FINISH REPORT q942_rep
#   LET g_nml05=0 #行序依次
#   FOR l_i = 1 TO g_rec_b
#       LET g_nml[l_i].nml02 = g_pr_ar[l_i].nml02
#       LET g_nml05=g_nml05+1
#       LET g_nml[l_i].nml05 = g_nml05
#       LET g_nml[l_i].tic07= g_pr_ar[l_i].tic07
#       LET g_nml[l_i].tic07b= g_pr_ar[l_i].tic07b
#   END FOR
   DROP TABLE x
   DROP TABLE y   								
   SELECT nml01,nml02,nml03,nml05,tib08 FROM nml_file,tib_file WHERE 1=0 INTO TEMP x
   #来源是票据时先抓nme_file，再抓tic_file									
  #No.TQC-C30056   ---start--- Mark
  #IF l_nmz70='1' THEN									
  #   SELECT nme_file.*,nmc03 FROM nme_file,nmc_file 									
  #    WHERE YEAR(nme16)*13+MONTH(nme16) >= tm.y1*13+tm.bm1      #No.TQC-B90234 									
  #      AND YEAR(nme16)*13+MONTH(nme16) <= tm.y1*13+tm.em1      #No.TQC-B90234   
  #      AND nme03 = nmc01         
  #     INTO TEMP y	

  #   UPDATE y SET nme08 = nme08*(-1)
  #    WHERE nmc03 = '2' AND nme14 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*0')
  #   UPDATE y SET nme08 = nme08*(-1)
  #    WHERE nmc03 = '1' AND nme14 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*1')      
  #    
  #   LET l_sql = "INSERT INTO x SELECT nml01,nml02,nml03,nml05,SUM(nme08) ",									
  #               "  FROM nml_file LEFT OUTER JOIN y ON nml01 = y.nme14 ",									
  #               " GROUP BY nml01,nml02,nml03,nml05 "	
  #ELSE
  #   IF l_nmz70='2' OR l_nmz70='3' THEN									
  #No.TQC-C30056   ---end---   Mark
         SELECT * FROM tic_file 									
          WHERE tic_file.tic00 = tm.b									
            AND tic_file.tic01*13+tic_file.tic02 >= tm.y1*13+tm.bm1           #No.TQC-B90234 									
            AND tic_file.tic01*13+tic_file.tic02 <= tm.y1*13+tm.em1           #No.TQC-B90234 									
           INTO TEMP y	  
         IF l_nmz70 <> '1' THEN #No.TQC-C30056
            UPDATE y SET tic07 = tic07*(-1)
             WHERE tic03='1' AND tic06 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*0')
            UPDATE y SET tic07 = tic07*(-1)
             WHERE tic03='2' AND tic06 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*1')
         ELSE
            UPDATE y SET tic07 = tic07*(-1)
             WHERE tic03='2' AND tic06 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*0')
            UPDATE y SET tic07 = tic07*(-1)
             WHERE tic03='1' AND tic06 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*1')
         END IF
          
         LET l_sql = "INSERT INTO x SELECT nml01,nml02,nml03,nml05,SUM(tic07) ",									
                     "  FROM nml_file LEFT OUTER JOIN y ON nml01 = y.tic06 ",									
                     " GROUP BY nml01,nml02,nml03,nml05 "		
  #   END IF	   #No.TQC-C30056   Mark
  #END IF	   #No.TQC-C30056   Mark

   PREPARE anmq941_gentemp FROM l_sql
   EXECUTE anmq941_gentemp
    
   DECLARE anmq941_curs CURSOR FOR SELECT * FROM x
   IF STATUS THEN
      CALL cl_err('declare',STATUS,0)
      RETURN
   END IF
 
   CALL cl_outnam('gglq942') RETURNING l_name
   START REPORT q942_rep TO l_name
   LET g_pageno = 0
 
   LET g_rec_b = 1
   CALL g_nml.clear() 
   LET g_rec_b = 1
   
   FOREACH anmq941_curs INTO sr.nml01,sr.nml02,sr.nml03,sr.nml05,sr.tic07
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
      IF sr.tic07 IS NULL THEN LET sr.tic07 = 0 END IF
      SELECT nml03 INTO l_nml03 FROM nml_file WHERE nml01 =sr.nml01
     #No.TQC-C30056   ---start---   Mark
     #IF l_nmz70='1' THEN
     #   DROP TABLE z	
     #   DROP TABLE w
     #   SELECT tic_file.* FROM tic_file,nme_file									
     #    WHERE tic_file.tic01*13+tic_file.tic02 >= tm.y1*13+tm.bm1          #No.TQC-B90234 									
     #      AND tic_file.tic01*13+tic_file.tic02 <= tm.y1*13+tm.em1          #No.TQC-B90234 
     #      AND tic04 = nme12
     #      AND tic05 = nme21
     #      AND tic00 = ' '
     #     #AND nme14 IS NULL         #No.TQC-C30056   Mark
     #     INTO TEMP w 
     #   SELECT * FROM w WHERE tic06 = sr.nml01
     #     INTO TEMP z 	

     #   UPDATE z SET tic07 = tic07*(-1)
     #    WHERE tic03='2' AND tic06 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*0')
     #   UPDATE z SET tic07 = tic07*(-1) 
     #    WHERE tic03='1' AND tic06 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*1')  
   
     #   SELECT SUM(tic07) INTO l_tic07 FROM z		
     #   IF cl_null(l_tic07) THEN
     #      LET l_tic07 = 0
     #   END IF
     #   LET sr.tic07 = sr.tic07 + l_tic07									
     #END IF	
     #No.TQC-C30056   ---End---   Mark

#No.TQC-B90234 --begin
      #取第二栏金额									
      #来源是票据时先抓nme_file，再抓tic_file									
     #No.TQC-C30056   ---start--- Mark
     #IF l_nmz70='1' THEN									
     #   DROP TABLE y
     #   SELECT nme_file.*,nmc03 FROM nme_file,nmc_file 									
     #    WHERE YEAR(nme16)*13+MONTH(nme16) >= tm.y2*13+tm.bm2      #No.TQC-B90234 									
     #      AND YEAR(nme16)*13+MONTH(nme16) <= tm.y2*13+tm.em2      #No.TQC-B90234  
     #      AND nme14 = sr.nml01  
     #      AND nme03 = nmc01         
     #     INTO TEMP y	
     #
     #   UPDATE y SET nme08 = nme08*(-1)
     #    WHERE nmc03 = '2' AND nme14 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*0')
     #   UPDATE y SET nme08 = nme08*(-1)
     #    WHERE nmc03 = '1' AND nme14 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*1')      
     #    
     #   SELECT SUM(nme08) INTO sr.tic071 FROM y
     #
     #   DROP TABLE z	
     #   DROP TABLE w
     #   SELECT tic_file.* FROM tic_file,nme_file									
     #    WHERE tic_file.tic01*13+tic_file.tic02 >= tm.y2*13+tm.bm2          #No.TQC-B90234 									
     #      AND tic_file.tic01*13+tic_file.tic02 <= tm.y2*13+tm.em2          #No.TQC-B90234 
     #      AND tic04 = nme12
     #      AND tic05 = nme21
     #      AND tic00 = ' '
     #     #AND nme14 IS NULL         #No.TQC-C30056   Mark
     #     INTO TEMP w 
     #   SELECT * FROM w WHERE tic06 = sr.nml01
     #     INTO TEMP z 	
     #
     #   UPDATE z SET tic07 = tic07*(-1)
     #    WHERE tic03='2' AND tic06 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*0')
     #   UPDATE z SET tic07 = tic07*(-1) 
     #    WHERE tic03='1' AND tic06 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*1')  
     #
     #
     #   SELECT SUM(tic07) INTO l_tic07 FROM z		
     #   IF cl_null(l_tic07) THEN
     #      LET l_tic07 = 0
     #   END IF
     #   LET sr.tic071 = sr.tic071 + l_tic07	
     #
     #ELSE
     #   IF l_nmz70='2' OR l_nmz70='3' THEN									
     #No.TQC-C30056   ---end---   Mark
            DROP TABLE y 
            SELECT * FROM tic_file 									
             WHERE tic_file.tic00 = tm.b									
               AND tic_file.tic01*13+tic_file.tic02 >= tm.y2*13+tm.bm2           #No.TQC-B90234 									
               AND tic_file.tic01*13+tic_file.tic02 <= tm.y2*13+tm.em2           #No.TQC-B90234 									
               AND tic06 = sr.nml01									
              INTO TEMP y	  
            IF l_nmz70 <> '1' THEN #No.TQC-C30056
               UPDATE y SET tic07 = tic07*(-1)
                WHERE tic03='1' AND tic06 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*0')
               UPDATE y SET tic07 = tic07*(-1)
                WHERE tic03='2' AND tic06 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*1')
            ELSE
               UPDATE y SET tic07 = tic07*(-1)
                WHERE tic03='2' AND tic06 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*0')
               UPDATE y SET tic07 = tic07*(-1)
                WHERE tic03='1' AND tic06 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*1')
            END IF
             
            SELECT SUM(tic07) INTO sr.tic071 FROM y 	
     #   END IF	  #No.TQC-C30056   Mark 
     #END IF	  #No.TQC-C30056   Mark
      IF cl_null(sr.tic071) THEN  
         LET sr.tic071 = 0
      END IF
#No.TQC-B90234 --end
      LET sr.type = sr.nml03[1,1]									
      IF tm.c = 'N' AND sr.tic07 = 0 AND sr.tic07b = 0 THEN									
         CONTINUE FOREACH									
      END IF									
      OUTPUT TO REPORT q942_rep(sr.*)
   END FOREACH
 
   FINISH REPORT q942_rep
   LET g_nml05=0 #行序依次
   FOR l_i = 1 TO g_rec_b
       LET g_nml[l_i].nml02 = g_pr_ar[l_i].nml02
       LET g_nml05=g_nml05+1
       LET g_nml[l_i].nml05 = g_nml05
       LET g_nml[l_i].tic07= g_pr_ar[l_i].tic07
       LET g_nml[l_i].tic07b= g_pr_ar[l_i].tic07b 
       LET g_nml[l_i].tic071= g_pr_ar[l_i].tic071   #No.TQC-B90234   
   END FOR

################以下为现金流量表间接法
   IF tm.bm1=1 THEN   #No.TQC-90234
      LET l_last_y = tm.y1 - 1
      LET l_last_m = 12
   ELSE
      LET l_last_y = tm.y1
      LET l_last_m = tm.bm1 - 1    #No.TQC-B90234   
   END IF
#No.TQC-B90234 --begin
   IF tm.bm1=1 THEN   #No.TQC-90234
      LET l_last_y1 = tm.y2 - 1
      LET l_last_m1 = 12
   ELSE
      LET l_last_y1 = tm.y2
      LET l_last_m1 = tm.bm2 - 1    #No.TQC-B90234   
   END IF
#No.TQC-B90234 --end 

   LET g_rec_b = g_rec_b+1
   LET g_nml[g_rec_b].nml02 = g_x[33]   #补充材料
   LET g_nml[g_rec_b].nml05 = g_rec_b

   LET g_rec_b = g_rec_b+1
   LET g_nml[g_rec_b].nml02 = g_x[34]   #1.将净利润调节为经营活动现金流量：
   LET g_nml[g_rec_b].nml05 = g_rec_b

   ###经营活动
   LET l_sql="SELECT gir01,gir02 FROM gir_file ",
             #" WHERE gir03 NOT IN ('4','5') AND gir04 <> 'Y'"  #No:FUN-B80180 mark
             " WHERE gir03 NOT IN ('4','5','6') AND gir04 <> 'Y'",  #No:FUN-B80180 add
             " ORDER BY gir05 "          #TQC-C50204  add
   PREPARE q942_gir_p1 FROM l_sql
   DECLARE q942_gir_cs1 CURSOR FOR q942_gir_p1

   LET l_sql = "SELECT giv02,giv03,giv04",
               "  FROM giv_file,gir_file",
               " WHERE giv01 = gir01  AND gir04 <> 'Y' AND giv01 = ?",
               "   AND giv00 = '",tm.b,"'"
   PREPARE q942_p31 FROM l_sql
   DECLARE q942_cu31 CURSOR FOR q942_p31
   LET l_sub_amt = 0
   LET l_sub_amt1 = 0   #No.TQC-B90234   
   FOREACH q942_gir_cs1 INTO l_gir01,l_gir02
      LET l_amt_s = 0
      LET l_amt = 0
#No.TQC-B90234 --begin 
      LET l_amt_s1 = 0
      LET l_amt1 = 0
#No.TQC-B90234 --end
      FOREACH q942_cu31 USING l_gir01 INTO tmp.*
          CASE tmp.giv04
            WHEN '1'    #异动
              #CALL q942_axh(tmp.giv02,tm.y1,tm.m2,l_last_y,l_last_m) 
              CALL q942_aeh(tmp.giv02,tm.y1,tm.em1,l_last_y,l_last_m,tm.y1,tm.em1)    #No.TQC-B90234 
                 RETURNING l_amt
              IF cl_null(l_amt) THEN LET l_amt = 0 END IF 
#No.TQC-B90234 --begin 
              CALL q942_aeh(tmp.giv02,tm.y2,tm.em2,l_last_y1,l_last_m1,tm.y2,tm.em2)
                 RETURNING l_amt1
              IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF 
#No.TQC-B90234 --end 
            WHEN '2'    #期初
              #CALL q942_axh2(tmp.giv02,l_last_y,l_last_m) RETURNING l_amt
              CALL q942_aeh2(tmp.giv02,l_last_y,l_last_m) RETURNING l_amt
              IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#No.TQC-B90234 --begin 
              CALL q942_aeh2(tmp.giv02,l_last_y1,l_last_m1) RETURNING l_amt1
              IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
#No.TQC-B90234 --end    
            WHEN '3'    #期末
              #CALL q942_axh2(tmp.giv02,tm.y1,tm.m2) RETURNING l_amt
              CALL q942_aeh2(tmp.giv02,tm.y1,tm.em1) RETURNING l_amt   #No.TQC-B90234   
              IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#No.TQC-B90234 --begin 
              CALL q942_aeh2(tmp.giv02,tm.y2,tm.em2) RETURNING l_amt1
              IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
#No.TQC-B90234 --end  
            WHEN '4'    #人工录入
#              SELECT SUM(git05) INTO l_amt FROM git_file
#                WHERE git01 = l_gir01 AND git02 = tmp.giv02
#                  AND git06 = tm.y1 AND git07 = tm.m2
#                  AND git08 = tm.axa01
#                  AND git00 = tm.b
               SELECT SUM(gio05) INTO l_amt FROM gio_file
                WHERE gio01 = l_gir01 AND gio02 = tmp.giv02
                  AND gio06 = tm.y1 AND gio07 = tm.em1       #No.TQC-B90234  
                  AND gio00 = tm.b   #No.TQC-B90234  
              IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#No.TQC-B90234 --begin 
               SELECT SUM(gio05) INTO l_amt1 FROM gio_file
                WHERE gio01 = l_gir01 AND gio02 = tmp.giv02
                  AND gio06 = tm.y2 AND gio07 = tm.em2
                  AND gio00 = tm.b
              IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
            WHEN '5'    
              CALL q942_aeh3(tmp.giv02,tm.y1,tm.em1,l_last_y,l_last_m) 
                 RETURNING l_amt
              IF cl_null(l_amt) THEN LET l_amt = 0 END IF 
              CALL q942_aeh3(tmp.giv02,tm.y2,tm.em2,l_last_y1,l_last_m1) 
                 RETURNING l_amt1
              IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF 
            WHEN '6'    
              CALL q942_aeh4(tmp.giv02,tm.y1,tm.em1,l_last_y,l_last_m) 
                 RETURNING l_amt
              IF cl_null(l_amt) THEN LET l_amt = 0 END IF 
              CALL q942_aeh4(tmp.giv02,tm.y2,tm.em2,l_last_y1,l_last_m1) 
                 RETURNING l_amt1
              IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF 
#No.TQC-B90234 --end  
          END CASE
          #若為減項
          IF tmp.giv03 = '-' THEN LET l_amt  = l_amt * -1 END IF
          LET l_amt_s = l_amt_s + l_amt
#No.TQC-B90234 --begin 
          IF tmp.giv03 = '-' THEN LET l_amt1  = l_amt1 * -1 END IF
          LET l_amt_s1 = l_amt_s1 + l_amt1
          IF l_amt_s = 0 AND l_amt_s1 = 0 AND tm.c = 'N' THEN
#No.TQC-B90234 --end  
             CONTINUE FOREACH
          END IF
      END FOREACH
      LET g_rec_b = g_rec_b +1
      LET g_nml[g_rec_b].nml02 = l_gir02
      LET g_nml[g_rec_b].nml05 = g_rec_b
      LET g_nml[g_rec_b].tic07 = l_amt_s 
      LET g_nml[g_rec_b].tic071= l_amt_s1   #No.TQC-B90234   

      LET l_sub_amt = l_sub_amt + l_amt_s   #計算经营活动产生的现金流量净额
      LET l_amt_s = l_amt_s*tm.q/g_unit     #依匯率及單位換算
#No.TQC-B90234 --begin 
      LET l_sub_amt1 = l_sub_amt1 + l_amt_s1   #計算经营活动产生的现金流量净额
      LET l_amt_s1 = l_amt_s1*tm.q/g_unit     #依匯率及單位換算
#No.TQC-B90234 --end
   END FOREACH

   LET g_rec_b = g_rec_b +1 
   LET g_nml[g_rec_b].nml02 = g_x[35]   #经营活动产生的现金流量净额
   LET g_nml[g_rec_b].nml05 = g_rec_b
   LET g_nml[g_rec_b].tic07 = l_sub_amt
   LET g_nml[g_rec_b].tic071= l_sub_amt1   #No.TQC-B90234 
   
   ### 2.不涉及现金收支的投资和筹资活动：
   LET g_rec_b = g_rec_b +1
   LET g_nml[g_rec_b].nml02 = g_x[36]
   LET g_nml[g_rec_b].nml05 = g_rec_b
   LET g_nml[g_rec_b].tic07 = NULL 
   LET g_nml[g_rec_b].tic071= NULL   #No.TQC-B90234    
   
   ###债务转为资本
   LET g_rec_b = g_rec_b +1
   LET g_nml[g_rec_b].nml02 = g_x[37]
   LET g_nml[g_rec_b].nml05 = g_rec_b
   LET g_nml[g_rec_b].tic07 = 0
   LET g_nml[g_rec_b].tic071= 0   #No.TQC-B90234   
   
   ### 一年内到期的可转换公司债券
   LET g_rec_b = g_rec_b +1
   LET g_nml[g_rec_b].nml02 = g_x[38]
   LET g_nml[g_rec_b].nml05 = g_rec_b
   LET g_nml[g_rec_b].tic07 = 0
   LET g_nml[g_rec_b].tic071= 0   #No.TQC-B90234   
   
   ###融资租入固定资产
   LET g_rec_b = g_rec_b +1
   LET g_nml[g_rec_b].nml02 = g_x[39]
   LET g_nml[g_rec_b].nml05 = g_rec_b
   LET g_nml[g_rec_b].tic07 = 0
   LET g_nml[g_rec_b].tic071= 0   #No.TQC-B90234   
   
   ### 3.现金及现金等价物净增加情况：
   LET g_rec_b = g_rec_b +1
   LET g_nml[g_rec_b].nml02 = g_x[40]
   LET g_nml[g_rec_b].nml05 = g_rec_b
   LET g_nml[g_rec_b].tic07 = NULL
   LET g_nml[g_rec_b].tic07b = NULL
   LET g_nml[g_rec_b].tic071= NULL   #No.TQC-B90234   
   
   ###现金的期末余额
   SELECT gir01,gir02 INTO l_gir01,l_gir02
     FROM gir_file
    WHERE gir03 = '5' AND gir04 <> 'Y'

   LET l_sql = "SELECT giv02,giv03,giv04",
               "  FROM giv_file,gir_file",
               " WHERE giv01 = gir01  AND gir04 <> 'Y' ",
               "   AND giv01 = '",l_gir01,"'",
               "   AND giv00 = '",tm.b,"'",
               " ORDER BY giv01 "
   PREPARE q942_p32 FROM l_sql
   DECLARE q942_cu32 CURSOR FOR q942_p32
   LET l_amt = 0
   LET l_amt_s1 = 0
#No.TQC-B90234 --begin
   LET l_amt1 = 0
   LET l_amt_s11 = 0
#No.TQC-B90234 --end   
   FOREACH q942_cu32 INTO tmp.* 
      #CALL q942_axh2(tmp.giv02,tm.y1,tm.m2) RETURNING l_amt
      CALL q942_aeh2(tmp.giv02,tm.y1,tm.em1) RETURNING l_amt    #No.TQC-B90234   
      IF cl_null(l_amt) THEN LET l_amt = 0 END IF
      #若為減項
      IF tmp.giv03 = '-' THEN LET l_amt  = l_amt * -1 END IF
#No.TQC-B90234 --begin 
      LET l_amt_s1 = l_amt_s1 + l_amt
      CALL q942_aeh2(tmp.giv02,tm.y2,tm.em2) RETURNING l_amt1
      IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
      #若為減項
      IF tmp.giv03 = '-' THEN LET l_amt1  = l_amt1 * -1 END IF
      LET l_amt_s11 = l_amt_s11 + l_amt1
      IF l_amt_s1 = 0 AND l_amt_s11 = 0 AND tm.c = 'N' THEN
#No.TQC-B90234 --end
         CONTINUE FOREACH
      END IF
   END FOREACH
   LET g_rec_b = g_rec_b +1
   LET g_nml[g_rec_b].nml02 = l_gir02
   LET g_nml[g_rec_b].nml05 = g_rec_b
#No.TQC-B90234 --begin 
   LET g_nml[g_rec_b].tic07 = l_amt_s1
   LET g_nml[g_rec_b].tic071= l_amt_s11  
#No.TQC-B90234 --end 

   ### 减：现金的期初余额
   SELECT gir01,gir02 INTO l_gir01,l_gir02
     FROM gir_file
    WHERE gir03 = '4' AND gir04 <> 'Y'

   LET l_sql = "SELECT giv02,giv03,giv04",
               "  FROM giv_file",
               " WHERE giv01 = '",l_gir01,"'",
               "   AND giv00 = '",tm.b,"'"
   PREPARE q942_p33 FROM l_sql
   DECLARE q942_cu33 CURSOR FOR q942_p33
#No.TQC-B90234 --begin
   LET l_amt1 = 0
   LET l_amt_s2 = 0
   LET l_amt = 0
   LET l_amt_s21 = 0
#No.TQC-B90234 --end
   FOREACH q942_cu33 INTO tmp.*
      #CALL q942_axh2(tmp.giv02,l_last_y,l_last_m) RETURNING l_amt
      CALL q942_aeh2(tmp.giv02,l_last_y,l_last_m) RETURNING l_amt
      IF cl_null(l_amt) THEN LET l_amt = 0 END IF
      #若為減項
      IF tmp.giv03 = '-' THEN LET l_amt  = l_amt * -1 END IF
#No.TQC-B90234 --begin 
      LET l_amt_s2 = l_amt_s2 + l_amt
      CALL q942_aeh2(tmp.giv02,l_last_y1,l_last_m1) RETURNING l_amt1
      IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
      LET l_amt_s21= l_amt_s21+ l_amt1
      IF l_amt_s2 = 0 AND l_amt_s21 = 0 AND tm.c = 'N' THEN
#No.TQC-B90234 --end
         CONTINUE FOREACH
      END IF
   END FOREACH
   LET g_rec_b = g_rec_b +1
   LET g_nml[g_rec_b].nml02 = l_gir02
   LET g_nml[g_rec_b].nml05 = g_rec_b
#No.TQC-B90234 --begin 
   LET g_nml[g_rec_b].tic07 = l_amt_s2
   LET g_nml[g_rec_b].tic071= l_amt_s21
#No.TQC-B90234 --end 

   ###现金及现金等价物净增加额
   LET g_rec_b = g_rec_b +1
   LET g_nml[g_rec_b].nml02 = g_x[41]
   LET g_nml[g_rec_b].nml05 = g_rec_b
   LET g_nml[g_rec_b].tic07 = l_amt_s1-l_amt_s2 
   LET g_nml[g_rec_b].tic071= l_amt_s11-l_amt_s21    #No.TQC-B90234   

##################以下为揭露事项(agli920)
   ###揭露事项
   LET g_rec_b = g_rec_b +1 
   LET g_nml[g_rec_b].nml02 = g_x[42]
   LET g_nml[g_rec_b].nml05 = g_rec_b
   LET g_nml[g_rec_b].tic07 = NULL
   LET g_nml[g_rec_b].tic071= NULL   #No.TQC-B90234  
   
   DECLARE sel_gim_cur CURSOR FOR
    SELECT gim_file.* FROM gim_file
     WHERE gim00 <> 'Y'
       AND gim04=tm.y1   #No:FUN-B80180 add
       AND gim05 = tm.em1  #No:FUN-B80180 add    #No.TQC-B90234   
#No.TQC-B90234 --begin
   SELECT azmm02 INTO l_azmm02 FROM azmm_file WHERE azmm00 = tm.b AND azmm01 = tm.y1    
#No.TQC-B90234 --end 
   FOREACH sel_gim_cur INTO l_gim.*
       LET g_rec_b = g_rec_b+1 
       LET g_nml[g_rec_b].nml02 = l_gim.gim02
       LET g_nml[g_rec_b].nml05 = g_rec_b
       LET g_nml[g_rec_b].tic07 = l_gim.gim03 
          
       SELECT gim03 INTO g_nml[g_rec_b].tic071 FROM gim_file
        WHERE gim00 = l_gim.gim00
          AND gim01 = l_gim.gim01
          AND gim04 = l_gim.gim04 
          AND gim05 = l_gim.gim05   
          AND gim06 = l_gim.gim06   
   END FOREACH
   #No.FUN-BB0047--mark--Begin---
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
   #No.FUN-BB0047--mark--End-----

END FUNCTION

REPORT q942_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1     
   DEFINE l_amt        LIKE nme_file.nme08
   DEFINE l_amt2       LIKE nme_file.nme08
   DEFINE l_cash1      LIKE nme_file.nme08
   DEFINE cash_in1     LIKE nme_file.nme08
   DEFINE cash_out1    LIKE nme_file.nme08
   DEFINE l_count1     LIKE nme_file.nme08
   DEFINE l_count_in1  LIKE nme_file.nme08
   DEFINE l_count_out1 LIKE nme_file.nme08
   DEFINE l_cash2      LIKE nme_file.nme08
   DEFINE cash_in2     LIKE nme_file.nme08
   DEFINE cash_out2    LIKE nme_file.nme08
   DEFINE l_count2     LIKE nme_file.nme08
   DEFINE l_count_in2  LIKE nme_file.nme08
   DEFINE l_count_out2 LIKE nme_file.nme08
#No.TQC-B90234 --begin 
   DEFINE l_cash3      LIKE nme_file.nme08
   DEFINE cash_in3     LIKE nme_file.nme08
   DEFINE cash_out3    LIKE nme_file.nme08
   DEFINE l_count3     LIKE nme_file.nme08
   DEFINE l_count_in3  LIKE nme_file.nme08
   DEFINE l_count_out3 LIKE nme_file.nme08
#No.TQC-B90234 --end  
   DEFINE p_flag       LIKE type_file.num5     
   DEFINE l_flag       LIKE type_file.num5     
   DEFINE l_unit       LIKE zaa_file.zaa08   
   DEFINE sr           RECORD
                       type   LIKE type_file.chr1,
                       nml01  LIKE nml_file.nml01,
                       nml02  LIKE type_file.chr1000, 
                       nml03  LIKE nml_file.nml03,
                       nml05  LIKE nml_file.nml05,
                       tic07 LIKE tic_file.tic07,
                       tic07b LIKE tic_file.tic07,
                       tic071 LIKE tic_file.tic07    #No.TQC-B90234                      
                      END RECORD
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
         LET sr.tic07 = sr.tic07 * tm.q / g_unit
         LET sr.tic071 = sr.tic071 * tm.q / g_unit   #No.TQC-B90234 
         LET sr.tic07b = sr.tic07b * tm.q / g_unit
         IF NOT cl_null(sr.nml02) THEN 
         LET g_pr_ar[g_rec_b].* = sr.*
         LET g_rec_b = g_rec_b + 1
         END IF 
 
      AFTER GROUP OF sr.nml03
         INITIALIZE g_pr_ar[g_rec_b].* TO NULL
         LET g_pr_ar[g_rec_b].type = sr.type
         LET g_pr_ar[g_rec_b].nml01= sr.nml01
         LET g_pr_ar[g_rec_b].nml03= sr.nml03
         LET cash_in1 = GROUP SUM(sr.tic07) WHERE sr.nml03[2,2] = '0'
         LET cash_out1= GROUP SUM(sr.tic07) WHERE sr.nml03[2,2] = '1'
         LET cash_in2 = GROUP SUM(sr.tic07b) WHERE sr.nml03[2,2] = '0'
         LET cash_out2= GROUP SUM(sr.tic07b) WHERE sr.nml03[2,2] = '1'
#No.TQC-B90234 --begin 
         LET cash_in3 = GROUP SUM(sr.tic071) WHERE sr.nml03[2,2] = '0'
         LET cash_out3= GROUP SUM(sr.tic071) WHERE sr.nml03[2,2] = '1'
#No.TQC-B90234 --end
         IF cl_null(cash_in1) THEN LET cash_in1 = 0 END IF
         IF cl_null(cash_out1) THEN LET cash_out1 = 0 END IF
         IF cl_null(cash_in2) THEN LET cash_in2 = 0 END IF
         IF cl_null(cash_out2) THEN LET cash_out2 = 0 END IF
#No.TQC-B90234 --begin 
         IF cl_null(cash_in3) THEN LET cash_in3 = 0 END IF
         IF cl_null(cash_out3) THEN LET cash_out3 = 0 END IF
#No.TQC-B90234 --end 

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
#               LET cash_in1 = cash_in1 * tm.q / g_unit   #No.TQC-B90234  
#               LET cash_in2 = cash_in2 * tm.q / g_unit   #No.TQC-B90234               
               LET g_pr_ar[g_rec_b].tic07 = cash_in1
               LET g_pr_ar[g_rec_b].tic07b = cash_in2
               LET g_pr_ar[g_rec_b].tic071 = cash_in3   #No.TQC-B90234 
            ELSE
#               LET cash_out1 = cash_out1 * tm.q / g_unit   #No.TQC-B90234 
#               LET cash_out2 = cash_out2 * tm.q / g_unit   #No.TQC-B90234               
               LET g_pr_ar[g_rec_b].tic07 = cash_out1
               LET g_pr_ar[g_rec_b].tic07b = cash_out2
               LET g_pr_ar[g_rec_b].tic071 = cash_out3      #No.TQC-B90234 
            END IF
            LET g_rec_b = g_rec_b + 1
         END IF
 
      AFTER GROUP OF sr.type
         INITIALIZE g_pr_ar[g_rec_b].* TO NULL
         LET g_pr_ar[g_rec_b].type = sr.type
         LET g_pr_ar[g_rec_b].nml01= sr.nml01
         LET g_pr_ar[g_rec_b].nml03= sr.nml03

         LET cash_in1 = GROUP SUM(sr.tic07) WHERE sr.nml03[2,2] = '0'
         LET cash_out1= GROUP SUM(sr.tic07) WHERE sr.nml03[2,2] = '1'
         LET cash_in2 = GROUP SUM(sr.tic07b) WHERE sr.nml03[2,2] = '0'
         LET cash_out2= GROUP SUM(sr.tic07b) WHERE sr.nml03[2,2] = '1'
#No.TQC-B90234 --begin 
         LET cash_in3 = GROUP SUM(sr.tic071) WHERE sr.nml03[2,2] = '0'
         LET cash_out3= GROUP SUM(sr.tic071) WHERE sr.nml03[2,2] = '1'
#No.TQC-B90234 --end 
         IF cl_null(cash_in1) THEN LET cash_in1 = 0 END IF
         IF cl_null(cash_out1) THEN LET cash_out1 = 0 END IF
         IF cl_null(cash_in2) THEN LET cash_in2 = 0 END IF
         IF cl_null(cash_out2) THEN LET cash_out2 = 0 END IF
#No.TQC-B90234 --begin 
         IF cl_null(cash_in3) THEN LET cash_in3 = 0 END IF
         IF cl_null(cash_out3) THEN LET cash_out3 = 0 END IF
#No.TQC-B90234 --end 

         CASE sr.type
            WHEN '1'
               LET l_cash1 = (cash_in1 - cash_out1)   #* tm.q / g_unit   #No.TQC-B90234 
               LET l_cash2 = (cash_in2 - cash_out2)   #* tm.q / g_unit   #No.TQC-B90234 
               LET l_cash3 = (cash_in3 - cash_out3)                      #No.TQC-B90234              
               LET g_pr_ar[g_rec_b].nml02 = g_x[10]
               LET g_pr_ar[g_rec_b].tic07= l_cash1
               LET g_pr_ar[g_rec_b].tic07b= l_cash2
               LET g_pr_ar[g_rec_b].tic071= l_cash3                      #No.TQC-B90234   
               LET g_rec_b = g_rec_b + 1
               LET cash_in1 = 0
               LET cash_out1 = 0
               LET cash_in2 = 0
               LET cash_out2 = 0
            WHEN '2'
               LET l_cash1 = (cash_in1 - cash_out1)   #* tm.q / g_unit   #No.TQC-B90234 
               LET l_cash2 = (cash_in2 - cash_out2)   #* tm.q / g_unit   #No.TQC-B90234 
               LET l_cash3 = (cash_in3 - cash_out3)                      #No.TQC-B90234               
               LET g_pr_ar[g_rec_b].nml02 = g_x[12]
               LET g_pr_ar[g_rec_b].tic07= l_cash1
               LET g_pr_ar[g_rec_b].tic07b= l_cash2
               LET g_pr_ar[g_rec_b].tic071= l_cash3                      #No.TQC-B90234 
               LET g_rec_b = g_rec_b + 1
               LET cash_in1 = 0
               LET cash_out1 = 0
               LET cash_in2 = 0
               LET cash_out2 = 0
#No.TQC-B90234 --begin 
               LET cash_in3 = 0
               LET cash_out3 = 0 
#No.TQC-B90234 --end
            WHEN '3'
               LET l_cash1 = (cash_in1 - cash_out1)   #* tm.q / g_unit   #No.TQC-B90234 
               LET l_cash2 = (cash_in2 - cash_out2)   #* tm.q / g_unit   #No.TQC-B90234 
               LET l_cash3 = (cash_in3 - cash_out3)                      #No.TQC-B90234               
               LET g_pr_ar[g_rec_b].nml02 = g_x[14]
               LET g_pr_ar[g_rec_b].tic07= l_cash1
               LET g_pr_ar[g_rec_b].tic07b= l_cash2
               LET g_pr_ar[g_rec_b].tic071= l_cash3                      #No.TQC-B90234 
               LET g_rec_b = g_rec_b + 1
               LET cash_in1 = 0
               LET cash_out1 = 0
               LET cash_in2 = 0
               LET cash_out2 = 0
#No.TQC-B90234 --begin 
               LET cash_in3 = 0
               LET cash_out3 = 0 
#No.TQC-B90234 --end
            OTHERWISE
               EXIT CASE
         END CASE
 
      ON LAST ROW
         INITIALIZE g_pr_ar[g_rec_b].* TO NULL
         LET g_pr_ar[g_rec_b].type = sr.type
         LET g_pr_ar[g_rec_b].nml01= sr.nml01
         LET g_pr_ar[g_rec_b].nml03= sr.nml03

         LET l_count_in1 = SUM(sr.tic07) WHERE sr.nml03[2,2] = '0'
         LET l_count_out1= SUM(sr.tic07) WHERE sr.nml03[2,2] = '1'
         LET l_count_in2 = SUM(sr.tic07b) WHERE sr.nml03[2,2] = '0'
         LET l_count_out2= SUM(sr.tic07b) WHERE sr.nml03[2,2] = '1'
#No.TQC-B90234 --begin 
         LET l_count_in3 = SUM(sr.tic071) WHERE sr.nml03[2,2] = '0'
         LET l_count_out3= SUM(sr.tic071) WHERE sr.nml03[2,2] = '1'
#No.TQC-B90234 --end 
         IF cl_null(l_count_in1) THEN LET l_count_in1 = 0 END IF
         IF cl_null(l_count_out1) THEN LET l_count_out1 = 0 END IF
         IF cl_null(l_count_in2) THEN LET l_count_in2 = 0 END IF
         IF cl_null(l_count_out2) THEN LET l_count_out2 = 0 END IF
#No.TQC-B90234 --begin 
         IF cl_null(l_count_in3) THEN LET l_count_in3 = 0 END IF
         IF cl_null(l_count_out3) THEN LET l_count_out3 = 0 END IF
#No.TQC-B90234 --end
         LET l_count1 = l_count_in1 - l_count_out1
         LET l_count2 = l_count_in2 - l_count_out2
         LET l_count3 = l_count_in3 - l_count_out3      #No.TQC-B90234  
#         LET l_count1 = l_count1   * tm.q / g_unit     #No.TQC-B90234  
#         LET l_count2 = l_count2   * tm.q / g_unit     #No.TQC-B90234

         LET g_pr_ar[g_rec_b].nml02 = g_x[16]
         LET g_pr_ar[g_rec_b].tic07= l_count1
         LET g_pr_ar[g_rec_b].tic07b= l_count2
         LET g_pr_ar[g_rec_b].tic071= l_count3          #No.TQC-B90234 
          
END REPORT

FUNCTION q942_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1     
 
   CALL cl_set_comp_entry("p,q",TRUE)

END FUNCTION
 
FUNCTION q942_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1     
 
   IF tm.o = 'N' THEN
      CALL cl_set_comp_entry("p,q",FALSE)
   END IF
 
END FUNCTION

FUNCTION q942_bp(p_ud)
DEFINE
    p_ud   LIKE type_file.chr1    

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

  #No.FUN-C80102 ---start--- Mark
  #DISPLAY tm.p TO FORMONLY.azi01
##No.TQC-B90234 --begin 
  #DISPLAY tm.y1 TO FORMONLY.yy
  #DISPLAY tm.bm1 TO FORMONLY.mm1
  #DISPLAY tm.em1 TO FORMONLY.mm2
  #No.FUN-C80102 ---start--- Mark
   CALL cl_set_comp_att_text('tic07',tm.title1 CLIPPED)
   CALL cl_set_comp_att_text('tic071',tm.title2 CLIPPED)
#  DISPLAY tm.y1 TO FORMONLY.yy
#  DISPLAY tm.m1 TO FORMONLY.mm1
#  DISPLAY tm.m2 TO FORMONLY.mm2
#No.TQC-B90234 --end 
  #DISPLAY tm.d  TO FORMONLY.unit   #No.FUN-C80102   Mark
   
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nml TO s_nml.* ATTRIBUTE(COUNT=g_rec_b)
      
      BEFORE ROW
         CALL cl_show_fld_cont()                   

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
         CALL cl_show_fld_cont()                  

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION close
      LET g_action_choice="exit"
      EXIT DISPLAY

      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q942_out()
  DEFINE l_i   LIKE type_file.num10
   LET g_prog = 'gglq942'
   LET g_sql = " nml02.type_file.chr1000,", 
               " nml05.nml_file.nml05,",
               " tic07.tic_file.tic07,",
               " tic07b.tic_file.tic07,",
               " tic071.tic_file.tic07" 
               
   SELECT zo12 INTO g_zo12 FROM zo_file WHERE zo01=g_rlang       
   SELECT zx02 INTO g_zx02 FROM zx_file WHERE zx01=g_user        
                  
   LET l_table = cl_prt_temptable('gglq942',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD 
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
               " VALUES(?, ?, ?, ?,? ) "    #No.TQC-B90234   
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF

   CALL cl_del_data(l_table)

   FOR l_i = 1 TO g_rec_b 
       EXECUTE insert_prep USING g_nml[l_i].*
   END FOR

   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
   LET g_str = g_str,";",tm.title,";",tm.p,";",tm.d,";",
               t_azi04,";",t_azi05,";",g_zo12,";",tm.y1,";",tm.bm1,";",tm.em1,";",g_zx02,";",tm.title1,";",tm.title2   #No.TQC-B90234  
   CALL cl_prt_cs3('gglq942','gglq942',g_sql,g_str)
   
END FUNCTION


#FUNCTION q942_axh(p_axh05,p_axh06,p_axh07,p_last_y,p_last_m)
FUNCTION q942_aeh(p_axh05,p_axh06,p_axh07,p_last_y,p_last_m,p_yy,p_mm)  #No.TQC-B90234 add p_yy,p_mm
   DEFINE p_axh05     LIKE axh_file.axh05,
          p_axh06     LIKE axh_file.axh06,
          p_axh07     LIKE axh_file.axh07,
          p_last_y    LIKE axh_file.axh06,   
          p_last_m    LIKE axh_file.axh07,  
          l_value1    LIKE axh_file.axh08, 
          l_value2    LIKE axh_file.axh08,
          l_amt       LIKE axh_file.axh08,
          l_type      LIKE type_file.chr1 
#No.TQC-B90234 --begin
   DEFINE p_yy        LIKE type_file.num5
   DEFINE p_mm        LIKE type_file.num5  
#No.TQC-B90234 --end 
   DEFINE l_aag07     LIKE aag_file.aag07     #TQC-C50215  add
   
   LET l_value1 = 0
   LET l_value2 = 0

   #aag06正常餘額型態(1.借餘 2.貸餘)
   SELECT aag06 INTO l_type FROM aag_file
    WHERE aag01=p_axh05
      AND aag00=tm.b  

   #TQC-C50215--add--str--
   #判斷是否為統制科目
   SELECT aag07 INTO l_aag07 FROM aag_file 
    WHERE aag01 = p_axh05
      AND aag00=tm.b 
   
   IF l_aag07 = '1' THEN 
      #TQC-C50230--mark--str--
      #SELECT SUM(aeh11-aeh12) INTO l_value1 FROM aeh_file
      # WHERE  aeh00 = tm.b                     #帳別
      #   AND  aeh01 IN (select distinct(aag01) from aag_file where aag08 = p_axh05 and aag07 = '2' AND aag00 = tm.b )  #科目
      #   AND  aeh09 = p_yy 
      #   AND  aeh10 = p_mm
      #TQC-C50230--mark--end--
      #TQC-C50230--add--str--
      SELECT SUM(aah04-aah05) INTO l_value1 FROM aah_file
       WHERE  aah00 = tm.b                     #帳別
         AND  aah01 = p_axh05                  #科目
         AND  aah02 = p_yy                     #年度
         AND  aah03 = p_mm                     #期別
      #TQC-C50230--add--end--
   ELSE
   #TQC-C50215--add--end--
      #本期餘額
#     SELECT SUM(axh08-axh09) INTO l_value1 FROM axh_file
#      WHERE axh00=tm.b                           #帳別
#        AND axh05=p_axh05                        #科目
#        AND axh06=p_axh06                        #年度
#        AND axh07 = tm.m2                        #期別 
#        AND axh01=tm.axa01                       #族群
#        AND axh13 = '00'
      SELECT SUM(aeh11-aeh12) INTO l_value1 FROM aeh_file
       WHERE aeh00 = tm.b                            #帳別
         AND aeh01 = p_axh05                         #科目
#No.TQC-B90234 --begin
#        AND aeh09 = tm.y1                           #年度
#        AND aeh10 = tm.m2                           #期別
         AND aeh09 = p_yy                            #年度
         AND aeh10 = p_mm                            #期別
#No.TQC-B90234 --end 
   END IF   #TQC-C50215  add
      
   IF cl_null(l_value1) THEN LET l_value1 = 0 END IF 
   #上期餘額
#   SELECT SUM(axh08-axh09) INTO l_value2 FROM axh_file
#    WHERE axh00=tm.b                           #帳別
#      AND axh05=p_axh05                        #科目
#      AND axh06=p_last_y                       #年度
#      AND axh07=p_last_m                       #期別   
#      AND axh01=tm.axa01                       #族群
#      AND axh13 = '00'              
#No.TQC-B90234 --begin 
#   SELECT SUM(aeh11-aeh12) INTO l_value2 FROM aeh_file
#    WHERE aeh00 = tm.b                            #帳別
#      AND aeh01 = p_axh05                         #科目
#      AND aeh09 = p_last_y                        #年度
#      AND aeh10 = p_last_m                        #期別  
#   IF cl_null(l_value2) THEN LET l_value2 = 0 END IF
#No.TQC-B90234 --end 
   IF l_type = '2' THEN
      LET l_value1 = l_value1 * -1
#      LET l_value2 = l_value2 * -1    #No.TQC-B90234  
   END IF

   #本期異動   =本期餘額 - 上期餘額
   LET l_amt = l_value1   # - l_value2   #No.TQC-B90234   
   RETURN l_amt
END FUNCTION

#FUNCTION q942_axh2(p_axh05,p_axh06,p_axh07)
FUNCTION q942_aeh2(p_axh05,p_axh06,p_axh07)
   DEFINE p_axh05     LIKE axh_file.axh05,
          p_axh06     LIKE axh_file.axh06,
          p_axh07     LIKE axh_file.axh07,
          p_value     LIKE axh_file.axh08  
   DEFINE l_type      LIKE type_file.chr1 
   DEFINE l_aag07     LIKE aag_file.aag07       #TQC-C50230    add

   LET p_value = 0
   SELECT aag06 INTO l_type FROM aag_file
    WHERE aag01=p_axh05
      AND aag00=tm.b 

   #TQC-C50230--add--str--   
   #判斷是否為統制科目
   SELECT aag07 INTO l_aag07 FROM aag_file 
    WHERE aag01 = p_axh05
      AND aag00=tm.b 
   
   IF l_aag07 = '1' THEN 
      SELECT SUM(aah04-aah05) INTO p_value FROM aah_file
       WHERE  aah00 = tm.b                     #帳別
         AND  aah01 = p_axh05                  #科目
         AND  aah02 = p_axh06                  #年度
         AND  aah03 = p_axh07                  #期別
   ELSE
   #TQC-C50230--add--end--

#   SELECT SUM(axh08-axh09) INTO p_value FROM axh_file
#    WHERE axh00=tm.b                   #帳別
#      AND axh05=p_axh05                #科目
#      AND axh06=p_axh06                #年度
#      AND axh07=p_axh07                #期別
#      AND axh01=tm.axa01               #族群
#      AND axh13='00'                   #版本 
      SELECT SUM(aeh11-aeh12) INTO p_value FROM aeh_file
       WHERE aeh00 = tm.b                            #帳別
         AND aeh01 = p_axh05                         #科目
#No.TQC-B90234 --begin
#        AND aeh09 = p_last_y                        #年度
#        AND aeh10 = p_last_m                        #期別
         AND aeh09 = p_axh06                         #年度
         AND aeh10 = p_axh07                         #期別
#No.TQC-B90234 --end 
   END IF #TQC-C50230  add
   IF l_type = '2' THEN   #貸餘
      LET p_value = p_value * -1
   END IF
   IF cl_null(p_value) THEN LET p_value = 0 END IF
   RETURN p_value
END FUNCTION
#NO.FUN-B60083 
#No.TQC-B90234 --begin
FUNCTION q942_aeh3(p_aeh01,p_aeh09,p_aeh10,p_last_y,p_last_m)
   DEFINE p_aeh01     LIKE aeh_file.aeh01,
          p_aeh09     LIKE aeh_file.aeh09,
          p_aeh10     LIKE aeh_file.aeh10,
          p_last_y    LIKE aeh_file.aeh09,   
          p_last_m    LIKE aeh_file.aeh10,  
          l_value1    LIKE aeh_file.aeh11, 
          l_value2    LIKE aeh_file.aeh11,
          l_amt       LIKE aeh_file.aeh11

   
   LET l_value1 = 0
   LET l_value2 = 0

   #本期餘額
   SELECT SUM(aeh11) INTO l_value1 FROM aeh_file
    WHERE aeh00=tm.b                           #帳別
      AND aeh01=p_aeh01                        #科目
      AND aeh09=p_aeh09                        #年度
      AND aeh10=p_aeh10                        #期別 

   IF cl_null(l_value1) THEN LET l_value1 = 0 END IF 
   #上期餘額
#No.TQC-B90234 --begin  
#   SELECT SUM(aeh11) INTO l_value2 FROM aeh_file
#    WHERE aeh00=tm.b                           #帳別
#      AND aeh01=p_aeh01                        #科目
#      AND aeh09=p_last_y                       #年度
#      AND aeh10=p_last_m                       #期別   
#              
#   IF cl_null(l_value2) THEN LET l_value2 = 0 END IF
#No.TQC-B90234 --end   
   #本期異動   =本期餘額 - 上期餘額
   LET l_amt = l_value1    #- l_value2   #No.TQC-B90234   
   RETURN l_amt
END FUNCTION

FUNCTION q942_aeh4(p_aeh01,p_aeh09,p_aeh10,p_last_y,p_last_m)
   DEFINE p_aeh01     LIKE aeh_file.aeh01,
          p_aeh09     LIKE aeh_file.aeh09,
          p_aeh10     LIKE aeh_file.aeh10,
          p_last_y    LIKE aeh_file.aeh09,   
          p_last_m    LIKE aeh_file.aeh10,  
          l_value1    LIKE aeh_file.aeh11, 
          l_value2    LIKE aeh_file.aeh11,
          l_amt       LIKE aeh_file.aeh11

   
   LET l_value1 = 0
   LET l_value2 = 0

   #本期餘額
   SELECT SUM(aeh12) INTO l_value1 FROM aeh_file
    WHERE aeh00=tm.b                           #帳別
      AND aeh01=p_aeh01                        #科目
      AND aeh09=p_aeh09                        #年度
      AND aeh10=p_aeh10                        #期別 

   IF cl_null(l_value1) THEN LET l_value1 = 0 END IF 
#No.TQC-B90234 --begin   
#   #上期餘額
#   SELECT SUM(aeh12) INTO l_value2 FROM aeh_file
#    WHERE aeh00=tm.b                           #帳別
#      AND aeh01=p_aeh01                        #科目
#      AND aeh09=p_last_y                       #年度
#      AND aeh10=p_last_m                       #期別   
#             
#   IF cl_null(l_value2) THEN LET l_value2 = 0 END IF
#No.TQC-B90234 --end   
   #本期異動   =本期餘額 - 上期餘額
   LET l_amt = l_value1     #- l_value2    #No.TQC-B90234   
   RETURN l_amt
END FUNCTION 
#No.TQC-B90234 --end   
